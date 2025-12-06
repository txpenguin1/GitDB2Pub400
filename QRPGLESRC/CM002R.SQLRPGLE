**FREE
//---------------------------------------------------------------------
// Program Name:  CM002R
// Program Description:  Customer Listing Selection
// Program Narrative:  Display the list of customers.  Allow the search
//                      to change and reload the list.  When one is
//                      selected, call the maintenance program.
//
// Change Log:
// Marker  Name         Date      Narrative
// ------  -----------  --------  -------------------------------------
//         S.Meisinger  10/04/25  New Program
//---------------------------------------------------------------------
//---------------------------------------------------------------------
//  Header
//---------------------------------------------------------------------
/Copy QRpgLeCpy,StdHdr
//---------------------------------------------------------------------
//  Files/Tables/Indexes
//---------------------------------------------------------------------
// Display file
Dcl-F CM002D  WorkStn IndDs(displayindicators)
              InfDs(infds)
              Sfile(Sfl1:Sfl1Rrn);
//---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
//---------------------------------------------------------------------
Dcl-Pr CM002R;
  *n  Like(receiveParm1);
End-Pr;

Dcl-Pi CM002R;
  inSearchCriteria  Like(receiveParm1);
End-Pi;

//---------------------------------------------------------------------
//  Prototypes for External Program Calls from Within This Program
//---------------------------------------------------------------------
Dcl-Pr CallToCustomerMaintenance  ExtPgm('CM003R');
  CustomerOidToActUpon  Packed(9:0) Const Options(*NoPass);
  CustomerAction        Char(1) Const Options(*NoPass);
End-Pr;

//---------------------------------------------------------------------
//  Program Input and Output Parameters
//---------------------------------------------------------------------
Dcl-S receiveParm1  Char(40);

//---------------------------------------------------------------------
//  Copy Books/Prototype Imports
//---------------------------------------------------------------------
/Copy QCpyModSrc,ProjSvcPr

//---------------------------------------------------------------------
//  Generic Prototypes and Data Structures (QCMDEXC, PSDS, SQL Diagnostics)
//---------------------------------------------------------------------
/Copy QRpgLeCpy,GenPrDs

//---------------------------------------------------------------------
//  Write Messages to the Job Log
//---------------------------------------------------------------------
/Copy QRpgLeCpy,WrtJobLog

//---------------------------------------------------------------------
//  Display File Function Key Values
//---------------------------------------------------------------------
Dcl-C Cmd01                        Const(x'31'); // Cmd-1
Dcl-C Cmd02                        Const(x'32'); // Cmd-2
Dcl-C Cmd03                        Const(x'33'); // Cmd-3
Dcl-C Cmd04                        Const(x'34'); // Cmd-4
Dcl-C Cmd05                        Const(x'35'); // Cmd-5
Dcl-C F6UpdateSearchKeyPressed     Const(x'36'); // Cmd-6
Dcl-C Cmd07                        Const(x'37'); // Cmd-7
Dcl-C Cmd08                        Const(x'38'); // Cmd-8
Dcl-C Cmd09                        Const(x'39'); // Cmd-9
Dcl-C Cmd10                        Const(x'3A'); // Cmd-10
Dcl-C Cmd11                        Const(x'3B'); // Cmd-11
Dcl-C F12CancelKeyPressed          Const(x'3C'); // Cmd-12
Dcl-C Cmd13                        Const(x'B1'); // Cmd-13
Dcl-C Cmd14                        Const(x'B2'); // Cmd-14
Dcl-C Cmd15                        Const(x'B3'); // Cmd-15
Dcl-C Cmd16                        Const(x'B4'); // Cmd-16
Dcl-C Cmd17                        Const(x'B5'); // Cmd-17
Dcl-C Cmd18                        Const(x'B6'); // Cmd-18
Dcl-C Cmd19                        Const(x'B7'); // Cmd-19
Dcl-C Cmd20                        Const(x'B8'); // Cmd-19
Dcl-C Cmd21                        Const(x'B9'); // Cmd-21
Dcl-C Cmd22                        Const(x'BA'); // Cmd-22
Dcl-C Cmd23                        Const(x'BB'); // Cmd-23
Dcl-C Cmd24                        Const(x'BC'); // Cmd-24
Dcl-C EnterKeyPressed              Const(x'F1'); // Enter
Dcl-C RollUp                       Const(x'F5'); // Roll Up
Dcl-C RollDown                     Const(x'F4'); // Roll Down

//---------------------------------------------------------------------
//  Display File Data Structures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,DspfDs

//---------------------------------------------------------------------
//  Various DS, Variables, and Constants Specific to this Program
//---------------------------------------------------------------------
Dcl-Ds Customer_Data  Qualified;
  CustomerOID     Packed(9:0);
  CustomerNumber  Packed(9:0);
  Name            Char(100);
  Address1        Char(100);
  Address2        Char(100);
  City            Char(50);
  State           Char(2);
End-ds;

Dcl-S SearchCriteria  Char(40) Inz(*Blanks);

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

Monitor;
  SearchCriteria = inSearchCriteria;
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
//  DSPF Procedures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,DspfProc

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
  //   SEARCHA (Text on Search Line) = Blue
  //   SFLOA (Subfile Output Field) = Yellow
  //   SFLIOA (Subfile Input/Output Field) = White/Underline
  //   FKEYSA (Function Keys) = Blue
  TitleA = White;
  OptionA = White;
  HeaderA = BlueUnderline;
  SearchA = Blue;
  SflOA = YellowColumnSeparator;
  SflIoA = BlueUnderline;
  FErrMsgA = NonDisplay;
  FKeysA = Blue;

  // Top/Bottom of screen soft-load logic
  Title1Work = 'Customer Selection Listing';
  optLine1  = 'Select "C" to change customer or a "V" to view customer';

  // Load Function Keys to be placed on the screen
  FunctionKeysText(1) = 'F12=Cancel';
  FunctionKeysCount = 1;

  // Set Screen fileds based upon above
  ##PROG = ProgramName;
  Title1 = CenterTitle(Title1Work: 80);
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
ClearSubfile();
LoadSubfile();
DoU FunctionKeyPressed = F12CancelKeyPressed;
  Write Dummy1;
  Write Header1;
  Write Footer1;
  SflRcd = 1;
  ExFmt SflCtl1;
  FErrMsgA = NonDisplay;
  ErrorsOnScreen = *Off;
  Select;
    When FunctionKeyPressed = F12CancelKeyPressed;
      Leave;
    When FunctionKeyPressed = F6UpdateSearchKeyPressed;
      SearchCriteria = *Blanks;
      SearchCriteria = HdrSrch;
      ClearSubfile();
      LoadSubfile();
    When FunctionKeyPressed = EnterKeyPressed;
      MaintainCustomerRecord();
      ClearSubfile();
      LoadSubfile();
    Other;
      //Do nothing - simply re-show the screen
  EndSl;
EndDo;

End-Proc DoTheWork;

//***********************************
Dcl-Proc LoadSubfile;
//***********************************

  Dcl-S LoadSubfileErrorHappened  Ind;
  Dcl-S SearchCriteriaPattern  Char(42);
  Dcl-S Sql1SqlStatement Char(500);

  //Get data and load to screen fields
  //Setup any special attributes
  OPTLINE  = optLine1;
  HdrSrch = SearchCriteria;

  Sql1SqlStatement = *Blanks;
  Sql1SqlStatement = 'Select * From Table(Get_Customer_List())';
  If SearchCriteria <> *Blanks;
    SearchCriteriaPattern = *Blanks;
    SearchCriteriaPattern = '%' + %Trim(%Upper(SearchCriteria)) + '%';
    Sql1SqlStatement = %Trim(Sql1SqlStatement) +
        ' Where Upper(Name) Like ' + quote + SearchCriteriaPattern + quote;
  EndIf;

  Exec Sql
    Prepare CustomerSql From :Sql1SqlStatement;

  Exec Sql
    Declare Sql1Cursor Cursor for CustomerSql;

  Exec Sql
    Open Sql1Cursor;
  GetSQLDiagnostics();
  DoU SQLDiagnosticsReturnedSQLCode <> *Zeros;
    Exec SQL Fetch Sql1Cursor into :Customer_Data.CustomerOID,
                                   :Customer_Data.CustomerNumber,
                                   :Customer_Data.Name,
                                   :Customer_Data.Address1,
                                   :Customer_Data.Address2,
                                   :Customer_Data.City,
                                   :Customer_Data.State;
    GetSQLDiagnostics();
    If SQLDiagnosticsReturnedSQLCode = *Zeros;
      SflOID =  Customer_Data.CustomerOID;
      SflSel =  *Blanks;
      SflName = Customer_Data.Name;
      Sfl1Rrn += 1;
      Sfl1RecordCount += 1;
      Write Sfl1;
      *In90 = *On;
    EndIf;
  EndDo;
  Exec Sql
    Close Sql1Cursor;

  On-Exit LoadSubfileErrorHappened;
    If LoadSubfileErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc LoadSubfile;

//***********************************
Dcl-Proc MaintainCustomerRecord;
//***********************************

  Dcl-S UpdateOrDeleteErrorHappened  Ind;

  Xjr = 1;
  DoU Xjr > Sfl1RecordCount;
    Chain Xjr Sfl1;
    Select;
      When SflSel = 'C';
        CallToCustomerMaintenance(SflOid:SflSel);
        Leave;
      When SflSel = 'V';
        CallToCustomerMaintenance(SflOid:SflSel);
        Leave;
      When SflSel <> *Blanks;
        FErrMsg = *Blanks;
        FErrMsg = %Trim(GetErrorMessage('CM00011'));
        FErrMsgA = Red;
        ErrorsOnScreen = *On;
        Leave;
      Other;
        //No action since it's blank
    EndSl;
    Xjr += 1;
  EndDo;

  On-Exit UpdateOrDeleteErrorHappened;
    If UpdateOrDeleteErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc MaintainCustomerRecord;


