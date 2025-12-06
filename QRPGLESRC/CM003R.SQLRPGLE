**FREE
//---------------------------------------------------------------------
// Program Name:  CM003R
// Program Description:  Customer Master Mainenance and Add
// Program Narrative:  If an OID is passed in, then allow the user to
//                      maintain the informatoin.  If there is no OID
//                      allow the user to enter a new customer information.
//
// Change Log:
// Marker  Name         Date      Narrative
// ------  -----------  --------  -------------------------------------
//         S.Meisinger  09/24/25  New Program
//---------------------------------------------------------------------
//---------------------------------------------------------------------
//  Header
//---------------------------------------------------------------------
/Copy QRpgLeCpy,StdHdr
//---------------------------------------------------------------------
//  Files/Tables/Indexes
//---------------------------------------------------------------------
// Display file
Dcl-F CM003D  WorkStn IndDs(displayindicators)
              InfDs(infds);
//---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
//---------------------------------------------------------------------
Dcl-Pr CM003R;
  *n  Like(receiveParm1) Options(*NoPass);
  *n  Like(receiveParm2) Options(*NoPass);
End-Pr;

Dcl-Pi CM003R;
  inCustomerOid     Like(receiveParm1) Options(*NoPass);
  inCustomerAction  Like(receiveParm2) Options(*NoPass);
End-Pi;

//---------------------------------------------------------------------
//  Prototypes for External Program Calls from Within This Program
//---------------------------------------------------------------------
// **None**

//---------------------------------------------------------------------
//  Program Input and Output Parameters
//---------------------------------------------------------------------
Dcl-S receiveParm1  Packed(9:0);
Dcl-S receiveParm2  Char(1);

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
Dcl-C Cmd01                  Const(x'31'); // Cmd-1
Dcl-C Cmd02                  Const(x'32'); // Cmd-2
Dcl-C Cmd03                  Const(x'33'); // Cmd-3
Dcl-C Cmd04                  Const(x'34'); // Cmd-4
Dcl-C Cmd05                  Const(x'35'); // Cmd-5
Dcl-C Cmd06                  Const(x'36'); // Cmd-6
Dcl-C Cmd07                  Const(x'37'); // Cmd-7
Dcl-C F8AddUpdateKeyPressed  Const(x'38'); // Cmd-8
Dcl-C Cmd09                  Const(x'39'); // Cmd-9
Dcl-C Cmd10                  Const(x'3A'); // Cmd-10
Dcl-C Cmd11                  Const(x'3B'); // Cmd-11
Dcl-C F12CancelKeyPressed    Const(x'3C'); // Cmd-12
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
Dcl-Ds Customer_Data ExtName('CUSTOMER') Alias Qualified End-Ds;

Dcl-S AddCustomer     Ind Inz(*Off);
Dcl-S ChangeCustomer  Ind Inz(*Off);
Dcl-S ViewCustomer    Ind Inz(*Off);

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

If %Parms < 1;
  AddCustomer = *On;
Else;
  Select;
    When inCustomerAction = 'C';
      ChangeCustomer = *On;
    When inCustomerAction = 'V';
      ViewCustomer = *On;
    Other;
      //Guess nothing will happen
  EndSl;
EndIf;

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
  FErrMsgA = NonDisplay;
  FKeysA = Blue;

  Select;
    When AddCustomer;
      // Top/Bottom of screen soft-load logic
      Title1Work = 'Add New Customer';
      BdyTitle2 = 'Add new Customer information and press F8';
      // Load Function Keys to be placed on the screen
      FunctionKeysText(1) = 'F8=Add New Customer';
      FunctionKeysText(2) = 'F12=Cancel';
      FunctionKeysCount = 2;
    When ChangeCustomer;
      // Top/Bottom of screen soft-load logic
      Title1Work = 'Customer Maintenance';
      BdyTitle1 = 'Update the Customer information and press F8';
      // Load Function Keys to be placed on the screen
      FunctionKeysText(1) = 'F8=Update Customer Information';
      FunctionKeysText(2) = 'F12=Cancel';
      FunctionKeysCount = 2;
    When ViewCustomer;
      // Top/Bottom of screen soft-load logic
      Title1Work = 'View Customer Details';
      BdyTitle1 = 'Display of Customer information - no update or change';
      // Load Function Keys to be placed on the screen
      FunctionKeysText(1) = 'F12=Cancel';
      FunctionKeysCount = 1;
    Other;
      //Guess nothing will happen
  EndSl;


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
LoadScreen();
DoU FunctionKeyPressed = F12CancelKeyPressed;
  Write Header1;
  Write Footer1;
  ExFmt Body1;
  FErrMsgA = NonDisplay;
  ErrorsOnScreen = *Off;
  Select;
    When FunctionKeyPressed = F8AddUpdateKeyPressed;
      Select;
        When AddCustomer;
          DoesCustomerNumberExist(BdyNumber);
          If Not ErrorsOnScreen;
            CheckInputData();
            If Not ErrorsOnScreen;
              AddNewCustomer();
              If Not ErrorsOnScreen;
                Leave;
              EndIf;
            EndIf;
          EndIf;
        When ChangeCustomer;
          CheckInputData();
          If Not ErrorsOnScreen;
            UpdateCustomerInformation();
            If Not ErrorsOnScreen;
              Leave;
            EndIf;
          EndIf;
        Other;
          //No action to take
      EndSl;
    When FunctionKeyPressed = F12CancelKeyPressed;
      Leave;
    Other;
      //Do nothing - simply re-show the screen
  EndSl;
EndDo;

End-Proc DoTheWork;

//***********************************
Dcl-Proc LoadScreen;
//***********************************

  Dcl-S LoadScreenErrorHappened  Ind;

  //Get data and load to screen fields
  //Setup any special attributes
  Select;
    When AddCustomer;
      BdyNumber  = *Zeros;
      BdyName    = *Blanks;
      BdyAdd1    = *Blanks;
      BdyAdd2    = *Blanks;
      BdyCity    = *Blanks;
      BdyState   = *Blanks;
      BdyZip     = *Blanks;
      BdyContact = *Blanks;
      BdyTitle = x'3E' + %Trim(BdyTitle2) + x'20';
      BdyTitle = CenterTitle(BdyTitle: 80);
      BdyAddA = WhiteUnderline;
      BdyMaintA = WhiteUnderline;
    When ChangeCustomer or ViewCustomer;
      Exec Sql
        Declare Sql1Cursor Cursor for
          Select CustomerNumber, Name, Address1, Address2,
                 City, State, ZipCode, Contact
          From Customer_Tbl_Customer_Master
          Where CustomerOid = :inCustomerOid;
      Exec Sql
        Open Sql1Cursor;
      GetSQLDiagnostics();
      If SQLDiagnosticsReturnedSQLCode = *Zeros;
        Exec SQL Fetch Sql1Cursor into :Customer_Data.CustomerNumber,
                                       :Customer_Data.Name,
                                       :Customer_Data.Address1,
                                       :Customer_Data.Address2,
                                       :Customer_Data.City,
                                       :Customer_Data.State,
                                       :Customer_Data.ZipCode,
                                       :Customer_Data.Contact;
        GetSQLDiagnostics();
        If SQLDiagnosticsReturnedSQLCode = *Zeros;
          BdyNumber  = Customer_Data.CustomerNumber;
          BdyName    = Customer_Data.Name;
          BdyAdd1    = Customer_Data.Address1;
          BdyAdd2    = Customer_Data.Address2;
          BdyCity    = Customer_Data.City;
          BdyState   = Customer_Data.State;
          BdyZip     = Customer_Data.ZipCode;
          BdyContact = Customer_Data.Contact;
          BdyTitle = x'3E' + %Trim(BdyTitle1) + x'20';
          BdyTitle = CenterTitle(BdyTitle: 80);
          BdyAddA = ProtectedWhite;
          BdyMaintA = WhiteUnderline;
          If ViewCustomer;
            // Change all data on the screen to protected
            BdyMaintA = ProtectedWhite;
          EndIf;
        EndIf;
      EndIf;
    Other;
      // Guess it won't do anything
  EndSl;

  Exec Sql
    Close Sql1Cursor;

  On-Exit LoadScreenErrorHappened;
    If LoadScreenErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc LoadScreen;

//***********************************
Dcl-Proc UpdateCustomerInformation;
//***********************************

  Dcl-S UpdateCustomerErrorHappened  Ind;

  Exec SQL
    Update Customer_Tbl_Customer_Master
      Set Name = Trim(:BdyName),
          Address1 = Trim(:BdyAdd1),
          Address2 = Trim(:BdyAdd2),
          City = Trim(:BdyCity),
          State = Trim(:BdyState),
          ZipCode = Trim(:BdyZip),
          Contact = Trim(:BdyContact)
      Where CustomerOid = :inCustomerOid;
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    Commit;
  Else;
    FErrMsg = *Blanks;
    FErrMsg = %Trim(GetErrorMessage('CM00007'));
    FErrMsgA = Red;
    ErrorsOnScreen = *On;
  EndIf;

  On-Exit UpdateCustomerErrorHappened;
    If UpdateCustomerErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc UpdateCustomerInformation;

//***********************************
Dcl-Proc DoesCustomerNumberExist;
//***********************************

  Dcl-Pi *n;
    CheckNumber  Like(BdyNumber);
  End-Pi;

  Dcl-S ExistingName  Like(Customer_Data.Name);
  Dcl-S CustomerExistsErrorHappened  Ind;

  Exec Sql
      Select Name
      Into :ExistingName
      From Customer_Tbl_Customer_Master
      Where CustomerNumber = :CheckNumber;
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    If ExistingName <> *Blanks;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('CM00006')) +
                '  ' + %Subst(ExistingName:1:50);
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    EndIf;
  Else;
    If SQLDiagnosticsReturnedSQLCode = 100;
      //SQL worked and found number does not exist
    Else;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('CM00009'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    EndIf;
  EndIf;

  On-Exit CustomerExistsErrorHappened;
    If CustomerExistsErrorHappened;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('CM00008'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    Else;
      // All is ok
    EndIf;

End-Proc DoesCustomerNumberExist;

//***********************************
Dcl-Proc CheckInputData;
//***********************************

  Select;
    When BdyName = *Blanks;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('CM00001'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    When BdyAdd1 = *Blanks;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('CM00002'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    When BdyCity = *Blanks;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('CM00003'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    When BdyState = *Blanks;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('CM00004'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    When BdyZip = *Blanks;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('CM00005'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
  EndSl;

End-Proc CheckInputData;

//***********************************
Dcl-Proc AddNewCustomer;
//***********************************

  Dcl-S AddNewCustomerErrorHappened  Ind;

  Exec SQL
    Insert Into Customer_Tbl_Customer_Master
      (CustomerNumber, Name, Address1, Address2,
       City, State, ZipCode, Contact)
      Values(:BdyNumber, :BdyName, :BdyAdd1, :BdyAdd2,
             :BdyCity, :BdyState, :BdyZip, :BdyContact);
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    Commit;
  Else;
    FErrMsg = *Blanks;
    FErrMsg = %Trim(GetErrorMessage('CM00010'));
    FErrMsgA = Red;
    ErrorsOnScreen = *On;
  EndIf;

  On-Exit AddNewCustomerErrorHappened;
    If AddNewCustomerErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc AddNewCustomer;

