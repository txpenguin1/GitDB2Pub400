**FREE
//---------------------------------------------------------------------
// Program Name:  ST002R
// Program Description:  Status Code Add/Update Description
// Program Narrative:  If an OID is passed in, then allow the user to
//                      change the code description.  If there is no
//                      OID allow the user to enter a new status code
//                      and description.
//
// Change Log:
// Marker  Name         Date      Narrative
// ------  -----------  --------  -------------------------------------
//         S.Meisinger  09/22/25  New Program
//---------------------------------------------------------------------
//---------------------------------------------------------------------
//  Header
//---------------------------------------------------------------------
/Copy QRpgLeCpy,StdHdr
//---------------------------------------------------------------------
//  Files/Tables/Indexes
//---------------------------------------------------------------------
// Display file
Dcl-F ST002D  WorkStn IndDs(displayindicators)
              InfDs(infds);
//---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
//---------------------------------------------------------------------
Dcl-Pr ST002R;
  *n  Like(receiveParm1) Options(*NoPass);
End-Pr;

Dcl-Pi ST002R;
  inStatusCodeOid  Like(receiveParm1) Options(*NoPass);
End-Pi;

//---------------------------------------------------------------------
//  Prototypes for External Program Calls from Within This Program
//---------------------------------------------------------------------
// **None**

//---------------------------------------------------------------------
//  Program Input and Output Parameters
//---------------------------------------------------------------------
Dcl-S receiveParm1  Packed(9:0);

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
Dcl-Ds Status_Data  Qualified;
  Code           Char(25);
  Description    Char(100);
End-ds;

Dcl-S ChangeDescription  Ind Inz(*Off);

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
  ChangeDescription = *Off;
Else;
  ChangeDescription = *On;
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
  BdyCodeA = White;
  BdyDescA = WhiteUnderline;
  FErrMsgA = NonDisplay;
  FKeysA = Blue;

  If ChangeDescription;
    // Top/Bottom of screen soft-load logic
    Title1Work = 'Status Codes Description Change';
    BdyTitle1 = 'Update the Description and press F8';
    // Load Function Keys to be placed on the screen
    FunctionKeysText(1) = 'F8=Update Status Code Description';
  Else;
    // Top/Bottom of screen soft-load logic
    Title1Work = 'Status Codes Add New Code';
    BdyTitle2 = 'Add a new Code and Description and press F8';
    // Load Function Keys to be placed on the screen
    FunctionKeysText(1) = 'F8=Add New Status Code';
  EndIf;

  FunctionKeysText(2) = 'F12=Cancel';
  FunctionKeysCount = 2;

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
  Select;
    When FunctionKeyPressed = F8AddUpdateKeyPressed;
      If ChangeDescription;
        UpdateStatusCodeDescription();
        Leave;
      Else;
        AddStatusCode();
        Leave;
      EndIf;
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
  If ChangeDescription;
    Exec Sql
      Declare Sql1Cursor Cursor for
        Select Code, Description From StatCode_Tbl_Status_Codes
        Where StatCodeOid = :inStatusCodeOid;
    Exec Sql
      Open Sql1Cursor;
    GetSQLDiagnostics();
    DoU SQLDiagnosticsReturnedSQLCode <> *Zeros;
      Exec SQL Fetch Sql1Cursor into :Status_Data.Code,
                                     :Status_Data.Description;
      GetSQLDiagnostics();
      If SQLDiagnosticsReturnedSQLCode = *Zeros;
        BdyCode = Status_Data.Code;
        BdyDesc = Status_Data.Description;
        BdyTitle = x'3E' + %Trim(BdyTitle1) + x'20';
        BdyTitle = CenterTitle(BdyTitle: 80);
        BdyCodeA = ProtectedWhite;
      EndIf;
    EndDo;
  Else;
    BdyCode = *Blanks;
    BdyCodeA = WhiteUnderline;
    BdyDesc = *Blanks;
    BdyTitle = x'3E' + %Trim(BdyTitle2) + x'20';
    BdyTitle = CenterTitle(BdyTitle: 80);
  EndIf;
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
Dcl-Proc UpdateStatusCodeDescription;
//***********************************

  Dcl-S UpdateStatusErrorHappened  Ind;

  Exec SQL
    Update StatCode_Tbl_Status_Codes
      Set Description = Trim(BdyDesc)
      Where StatCodeOid = :inStatusCodeOid;
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    Commit;
  Else;
    FErrMsg = *Blanks;
    FErrMsg = %Trim(GetErrorMessage('ST00003'));
    FErrMsgA = Red;
  EndIf;

  On-Exit UpdateStatusErrorHappened;
    If UpdateStatusErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc UpdateStatusCodeDescription;

//***********************************
Dcl-Proc AddStatusCode;
//***********************************

  Dcl-S AddStatusCodeErrorHappened  Ind;

  Exec SQL
    Insert Into StatCode_Tbl_Status_Codes
      (Code, Description)
      Values(:BdyCode, :BdyDesc);
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    Commit;
  Else;
    FErrMsg = *Blanks;
    FErrMsg = %Trim(GetErrorMessage('ST00004'));
    FErrMsgA = Red;
  EndIf;

  On-Exit AddStatusCodeErrorHappened;
    If AddStatusCodeErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc AddStatusCode;

