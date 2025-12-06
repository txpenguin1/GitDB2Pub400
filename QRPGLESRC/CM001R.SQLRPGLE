**FREE
// ---------------------------------------------------------------------
// Program Name:  CM001R
// Program Description:  Customer Master Maintenance
// Program Narrative:  Enter either a customer name, unique customer name
//                      or press F8 and be taken to the maintenance screen.
//                      Enter a customer name that appears on more than one
//                      customer or press F6 and be taken to the listing
//                      screen to make a selection.
//
// Change Log:
// Marker  Name         Date      Narrative
// ------  -----------  --------  -------------------------------------
//         S.Meisinger  10/04/25  New Program
// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
//  Header
// ---------------------------------------------------------------------
/Copy QRpgLeCpy,StdHdr
// ---------------------------------------------------------------------
//  Files/Tables/Indexes
// ---------------------------------------------------------------------
// Display file
Dcl-F CM001D  WorkStn IndDs(displayindicators)
              InfDs(infds);
// ---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
// ---------------------------------------------------------------------
Dcl-Pr CM001R;
  *n  Like(receiveParm1) Options(*NoPass);
End-Pr;

Dcl-Pi CM001R;
  inUserProfile  Like(receiveParm1) Options(*NoPass);
End-Pi;

// ---------------------------------------------------------------------
//  Prototypes for External Program Calls from Within This Program
// ---------------------------------------------------------------------
Dcl-Pr CallToCustomerSearch  ExtPgm('CM002R');
  CustomerSearchCriteria  Char(40) Const Options(*NoPass);
End-Pr;

Dcl-Pr CallToCustomerMaintenance  ExtPgm('CM003R');
  CustomerOidToActUpon  Packed(9:0) Const Options(*NoPass);
  CustomerAction        Char(1) Const Options(*NoPass);
End-Pr;

// ---------------------------------------------------------------------
//  Program Input and Output Parameters
// ---------------------------------------------------------------------
Dcl-S receiveParm1  Char(10);

// ---------------------------------------------------------------------
//  Copy Books/Prototype Imports
// ---------------------------------------------------------------------
/Copy QCpyModSrc,ProjSvcPr

// ---------------------------------------------------------------------
//  Generic Prototypes and Data Structures (QCMDEXC, PSDS, SQL Diagnostics)
// ---------------------------------------------------------------------
/Copy QRpgLeCpy,GenPrDs

// ---------------------------------------------------------------------
//  Write Messages to the Job Log
// ---------------------------------------------------------------------
/Copy QRpgLeCpy,WrtJobLog

// ---------------------------------------------------------------------
//  Display File Function Key Values
// ---------------------------------------------------------------------
Dcl-C Cmd01                  Const(x'31'); // Cmd-1
Dcl-C Cmd02                  Const(x'32'); // Cmd-2
Dcl-C F3ExitKeyPressed       Const(x'33'); // Cmd-3
Dcl-C Cmd04                  Const(x'34'); // Cmd-4
Dcl-C Cmd05                  Const(x'35'); // Cmd-5
Dcl-C F6SearchKeyPressed     Const(x'36'); // Cmd-6
Dcl-C Cmd07                  Const(x'37'); // Cmd-7
Dcl-C F8AddNewKeyPressed     Const(x'38'); // Cmd-8
Dcl-C Cmd09                  Const(x'39'); // Cmd-9
Dcl-C Cmd10                  Const(x'3A'); // Cmd-10
Dcl-C Cmd11                  Const(x'3B'); // Cmd-11
Dcl-C Cmd12                  Const(x'3C'); // Cmd-12
Dcl-C Cmd13                  Const(x'B1'); // Cmd-13
Dcl-C Cmd14                  Const(x'B2'); // Cmd-14
Dcl-C Cmd15                  Const(x'B3'); // Cmd-15
Dcl-C Cmd16                  Const(x'B4'); // Cmd-16
Dcl-C Cmd17                  Const(x'B5'); // Cmd-17
Dcl-C Cmd18                  Const(x'B6'); // Cmd-18
Dcl-C Cmd19                  Const(x'B7'); // Cmd-19
Dcl-C Cmd20                  Const(x'B8'); // Cmd-19
Dcl-C Cmd21                  Const(x'B9'); // Cmd-21
Dcl-C Cmd22                  Const(x'BA'); // Cmd-22
Dcl-C Cmd23                  Const(x'BB'); // Cmd-23
Dcl-C Cmd24                  Const(x'BC'); // Cmd-24
Dcl-C EnterKeyPressed        Const(x'F1'); // Enter
Dcl-C RollUp                 Const(x'F5'); // Roll Up
Dcl-C RollDown               Const(x'F4'); // Roll Down

//---------------------------------------------------------------------
//  Display File Data Structures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,DspfDs

//---------------------------------------------------------------------
//  Various DS, Variables, and Constants Specific to this Program
//---------------------------------------------------------------------

Dcl-S HoldNumberOrNameSearch  Like(BdyNumNam) Inz(*Blanks);
Dcl-S CustomerNumberOrNameFound Ind Inz(*Off);
Dcl-S FoundCustomerOid  Packed(9:0);

//---------------------------------------------------------------------
//  Display File Color and Attribute Constants
//---------------------------------------------------------------------
/Copy QRpgLeCpy,DspfConst

//---------------------------------------------------------------------
//  Generic Variables and Constants
//---------------------------------------------------------------------
/Copy QRpgLeCpy,GenVarCon

//--------------------------- Mainline Processing --------------------

// Setup current date/time for use

Date# = %Dec(%Subst(%Char(%Date():*ISO0):1:8):8:0);
Time6# = %Dec(%Subst(%Char(%Time():*ISO0):1:6):6:0);
HoldNumberOrNameSearch = *Blanks;

Monitor;
  SetupScreenGenerics();
  DoTheWork();
  *InLr = *On;
  Return;
On-Error *Program;
  Dump(A);
  *InLr = *On;
  Return;
EndMon;

//---------------------------------------------------------------------
//  Generic Procedures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,GenProc

//***********************************
Dcl-Proc SetupScreenGenerics;
//***********************************

  Dcl-S SetupScreenErrorHappened  Ind;

  // NOTE:  Default Coloring Attributes will be:
  //   TITLEA (Titles) = White
  //   OPTIONA (Options for Subfile Rows) = White
  //   HEADERA (Column Headers) = Blue/Underline
  //   SFLOA (Subfile Output Field) = Yellow
  //   SFLIOA (Subfile Input/Output Field) = White/Underline
  //   FKEYSA (Function Keys) = Ble
  TitleA = White;
  BdyNumNamA = WhiteUnderline;
  FErrMsgA = NonDisplay;
  FKeysA = Blue;

  // Top/Bottom of screen soft-load logic
  Title1Work = 'Customer Master Maintenance';
  BdyTitle1 = 'Enter customer number, full or part name, and press <Enter>';
  BdyTitle2 = 'or select F6 or F8.';
  // Load Function Keys to be placed on the screen
  FunctionKeysText(1) = 'F3=Exit';
  FunctionKeysText(2) = 'F6=Search Customers';
  FunctionKeysText(3) = 'F8=Add New Customer';
  FunctionKeysCount = 3;

  // Set Screen fileds based upon above
  ##PROG = ProgramName;
  Title1 = CenterTitle(Title1Work: 80);
  OPTLINE  = optLine1;
  FKEYLINE = SpaceFunctionKeys(FunctionKeysText:FunctionKeysCount);

  On-Exit SetupScreenErrorHappened;
    If SetupScreenErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc SetupScreenGenerics;

//***********************************
Dcl-Proc DoTheWork;
//***********************************

//Basic Loop Logic
  Write Dummy1;
  LoadScreen();
  DoU FunctionKeyPressed = F3ExitKeyPressed;
    FoundCustomerOid = *Zeros;
    CustomerNumberOrNameFound = *Off;
    HoldNumberOrNameSearch = *Blanks;
    Write Header1;
    Write Footer1;
    ExFmt Body1;
    FErrMsgA = NonDisplay;
    ErrorsOnScreen = *Off;
    HoldNumberOrNameSearch = BdyNumNam;
    Select;
      When FunctionKeyPressed = F3ExitKeyPressed;
        Leave;
      When FunctionKeyPressed = F6SearchKeyPressed;
        If HoldNumberOrNameSearch <> *Blanks;
          ProcessSearch();
        EndIf;
        If CustomerNumberOrNameFound;
          GoToCustomerAddOrChange();
        Else;
          GoToCustomerListing();
        EndIf;
      When FunctionKeyPressed = F8AddNewKeyPressed;
        GoToCustomerAddOrChange();
      When FunctionKeyPressed = EnterKeyPressed;
        If HoldNumberOrNameSearch <> *Blanks;
          ProcessSearch();
        EndIf;
        If CustomerNumberOrNameFound;
          GoToCustomerAddOrChange();
        EndIf;
      Other;
      //Do nothing - simply re-show the screen
    EndSl;
  EndDo;

End-Proc DoTheWork;

//***********************************
Dcl-Proc LoadScreen;
//***********************************

  Dcl-S BdyTitle  Like(BdyTitle1);

  BdyNumNam = HoldNumberOrNameSearch;
  BdyTitle = x'3E' + %Trim(BdyTitle1) + x'20';
  BdyTitle1 = CenterTitle(BdyTitle: 80);
  BdyTitle = x'3E' + %Trim(BdyTitle2) + x'20';
  BdyTitle2 = CenterTitle(BdyTitle: 80);

End-Proc LoadScreen;

//***********************************
Dcl-Proc ProcessSearch;
//***********************************

  Dcl-S ProcessSearchErrorHappened  Ind;
  Dcl-S CustomerNumberFoundOid Packed(9:0);

  CustomerNumberFoundOid = *Zeros;
  CustomerNumberFoundOid = CustomerNumberSearch();
  // If return value is zero, nothing matches and look for customer name
  // If return value is value, specific customer found and go to view
  // If return value is all 9s, multiple customers match and go to listing
  Select;
    When CustomerNumberFoundOid = *Zeros;
      CustomerNumberFoundOid = CustomerNameSearch();
      // Same rules as above
      Select;
        When CustomerNumberFoundOid = *Zeros;
          NoCustomerFound();
        When CustomerNumberFoundOid = *All'9';
          GoToCustomerListing();
        Other;
          Return;
      EndSl;
    When CustomerNumberFoundOid = *All'9';
      GoToCustomerListing();
    Other;
      Return;
  EndSl;

  On-Exit ProcessSearchErrorHappened;
    If ProcessSearchErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc ProcessSearch;

//***********************************
Dcl-Proc CustomerNumberSearch;
//***********************************
  Dcl-Pi *n Packed(9:0);
  End-Pi;

  Dcl-S CustomerNumberSearchErrorHappened  Ind;
  Dcl-S SearchCriteriaPattern  Char(42);
  Dcl-S Sql2SqlStatement  Char(500);
  Dcl-S SearchNumberLength  Packed(3:0);
  Dcl-S SearchNumber  Packed(9:0);
  Dcl-S ReturnCustomerOid  Packed(9:0);
  Dcl-S CustomerLikeCount  Packed(3:0);
  Dcl-S CharacterInStringLocation  Int(5);
  Dcl-S UpperSearch  Like(HoldNumberOrNameSearch);

  ReturnCustomerOid = *Zeros;

  // If there are any characters in the entered value on the screen, do not try
  //  to located based upon customer number.  Exit this process and go straight
  //  to looking at the customer name.

  UpperSearch = %Upper(HoldNumberOrNameSearch);
  CharacterInStringLocation = %Check(upper:UpperSearch);
  If CharacterInStringLocation > *Zeros;
    Return ReturnCustomerOid;
  EndIf;

  // Try to find the exact number entered.  If so, then go to view of customer
  SearchNumberLength = %Len(%Trim(HoldNumberOrNameSearch));
  SearchNumber = %Dec(%Subst(HoldNumberOrNameSearch:1:SearchNumberLength):9:0);

  Exec Sql
    Declare Sql1Cursor Cursor for
      Select CustomerOid From Customer_Tbl_Customer_Master
      Where CustomerNumber = :SearchNumber;
  Exec Sql
    Open Sql1Cursor;
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    Exec SQL Fetch Sql1Cursor into :FoundCustomerOid;
    GetSQLDiagnostics();
    If SQLDiagnosticsReturnedSQLCode = *Zeros;
      CustomerNumberOrNameFound = *On;
      ReturnCustomerOid = FoundCustomerOid;
    EndIf;
  EndIf;
  Exec Sql
    Close Sql1Cursor;
  If CustomerNumberOrNameFound;
    Return ReturnCustomerOid;
  EndIf;

  // See if a wildcard search for the number entered exists, If so, go to listing.

  Sql2SqlStatement = *Blanks;
  Sql2SqlStatement = 'Select Count(*) From Customer_Tbl_Customer_Master';
  If HoldNumberOrNameSearch <> *Blanks;
    SearchCriteriaPattern = *Blanks;
    SearchCriteriaPattern = '%' + %Trim(HoldNumberOrNameSearch) + '%';
    Sql2SqlStatement = %Trim(Sql2SqlStatement) +
        ' Where CustomerNumber Like ' + quote + SearchCriteriaPattern + quote;
  EndIf;

  Exec Sql
    Prepare CustomerSql2 From :Sql2SqlStatement;

  Exec Sql
    Declare Sql2Cursor Cursor for CustomerSql2;

  Exec Sql
    Open Sql2Cursor;
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    Exec SQL Fetch Sql2Cursor into :CustomerLikeCount;
    GetSQLDiagnostics();
    If SQLDiagnosticsReturnedSQLCode = *Zeros;
      If CustomerLikeCount > *Zeros;
        ReturnCustomerOid = *All'9';
      EndIf;
    EndIf;
  EndIf;
  Exec Sql
    Close Sql2Cursor;

  Return ReturnCustomerOid;

  On-Exit CustomerNumberSearchErrorHappened;
    If CustomerNumberSearchErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc CustomerNumberSearch;


//***********************************
Dcl-Proc CustomerNameSearch;
//***********************************
  Dcl-Pi *n Packed(9:0);
  End-Pi;

  Dcl-S CustomerNameSearchErrorHappened  Ind;
  Dcl-S SearchCriteriaPattern  Char(42);
  Dcl-S Sql3SqlStatement  Char(500);
  Dcl-S Sql4SqlStatement  Char(500);
  Dcl-S ReturnCustomerOid  Packed(9:0);
  Dcl-S CustomerLikeCount  Packed(3:0);

  ReturnCustomerOid = *Zeros;

  //Reverse from above - first do the wildcard search
  // If zero return, none exist
  // If only one count returns, then go get that OID and go to view
  // If more than one count, then go to listing
  // See if a wildcard search for the number entered exists, If so, go to listing.

  Sql3SqlStatement = *Blanks;
  Sql3SqlStatement = 'Select Count(*) From Customer_Tbl_Customer_Master';
  If HoldNumberOrNameSearch <> *Blanks;
    SearchCriteriaPattern = *Blanks;
    SearchCriteriaPattern = '%' + %Trim(%Upper(HoldNumberOrNameSearch)) + '%';
    Sql3SqlStatement = %Trim(Sql3SqlStatement) +
        ' Where Upper(Name) Like ' + quote + SearchCriteriaPattern + quote;
  EndIf;

  Exec Sql
    Prepare CustomerSql3 From :Sql3SqlStatement;

  Exec Sql
    Declare Sql3Cursor Cursor for CustomerSql3;

  Exec Sql
    Open Sql3Cursor;
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    Exec SQL Fetch Sql3Cursor into :CustomerLikeCount;
    GetSQLDiagnostics();
    If SQLDiagnosticsReturnedSQLCode = *Zeros;
      Select;
        When CustomerLikeCount = 1;
          // Try to find the exact name entered.  If so, then go to view of customer
          Sql4SqlStatement = *Blanks;
          Sql4SqlStatement = 'Select CustomerOid From Customer_Tbl_Customer_Master';
          Sql4SqlStatement = %Trim(Sql4SqlStatement) +
                 ' Where Upper(Name) Like ' + quote + SearchCriteriaPattern + quote;
          Exec Sql
            Prepare CustomerSql4 From :Sql4SqlStatement;

          Exec Sql
            Declare Sql4Cursor Cursor for CustomerSql4;

          Exec Sql
            Open Sql4Cursor;

          GetSQLDiagnostics();
          If SQLDiagnosticsReturnedSQLCode = *Zeros;
            Exec SQL Fetch Sql4Cursor into :FoundCustomerOid;
            GetSQLDiagnostics();
            If SQLDiagnosticsReturnedSQLCode = *Zeros;
              CustomerNumberOrNameFound = *On;
              ReturnCustomerOid = FoundCustomerOid;
            EndIf;
          EndIf;
          Exec Sql
            Close Sql4Cursor;
        When CustomerLikeCount > 1;
          ReturnCustomerOid = *All'9';
      EndSl;
    EndIf;
  EndIf;
  Exec Sql
    Close Sql3Cursor;

  Return ReturnCustomerOid;

  On-Exit CustomerNameSearchErrorHappened;
    If CustomerNameSearchErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc CustomerNameSearch;


//***********************************
Dcl-Proc GoToCustomerAddOrChange;
//***********************************

  Dcl-S GoToAddOrChangeErrorHappened  Ind;

  If CustomerNumberOrNameFound;
    CalltoCustomerMaintenance(FoundCustomerOid:'V');
    Write Dummy1;
  Else;
    CallToCustomerMaintenance();
    Write Dummy1;
  EndIf;

  On-Exit GoToAddOrChangeErrorHappened;
    If GoToAddOrChangeErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc GoToCustomerAddOrChange;

//***********************************
Dcl-Proc GoToCustomerListing;
//***********************************

  Dcl-S GoToListingErrorHappened  Ind;

  CalltoCustomerSearch(HoldNumberOrNameSearch);
  Write Dummy1;

  On-Exit GoToListingErrorHappened;
    If GoToListingErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc GoToCustomerListing;

//***********************************
Dcl-Proc NoCustomerFound;
//***********************************

  Dcl-S NoCustomerErrorHappened  Ind;

  FErrMsg = *Blanks;
  FErrMsg = %Trim(GetErrorMessage('CM00012'));
  FErrMsgA = Red;
  ErrorsOnScreen = *On;

  On-Exit NoCustomerErrorHappened;
    If NoCustomerErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc NoCustomerFound;


