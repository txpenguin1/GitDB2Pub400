**FREE
//---------------------------------------------------------------------
// Program Name:  ST001R
// Program Description:  Status Code Maintenance
// Program Narrative:  Display the current status codes.  Allow the user
//                      to change the description of a current code or
//                      to add a new code and description.
//
// Change Log:
// Marker  Name         Date      Narrative
// ------  -----------  --------  -------------------------------------
//         S.Meisinger  09/16/25  New Program
//---------------------------------------------------------------------
//---------------------------------------------------------------------
//  Header
//---------------------------------------------------------------------
/Copy QRpgLeCpy,StdHdr
//---------------------------------------------------------------------
//  Files/Tables/Indexes
//---------------------------------------------------------------------
// Display file
Dcl-F ST001D  WorkStn IndDs(displayindicators)
              InfDs(infds)
              Sfile(Sfl1:Sfl1Rrn);
//---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
//---------------------------------------------------------------------
Dcl-Pr ST001R;
  *n  Like(receiveParm1);
End-Pr;

Dcl-Pi ST001R;
  inUserProfile    Like(receiveParm1);
End-Pi;

//---------------------------------------------------------------------
//  Prototypes for External Program Calls from Within This Program
//---------------------------------------------------------------------
Dcl-Pr CallToAddOrChangeStatusCode  ExtPgm('ST002R');
  CodeOidToChange  Packed(9:0) Const Options(*NoPass);
End-Pr;

//---------------------------------------------------------------------
//  Program Input and Output Parameters
//---------------------------------------------------------------------
Dcl-S receiveParm1  Char(10);

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
Dcl-C F3ExitKeyPressed       Const(x'33'); // Cmd-3
Dcl-C Cmd04                  Const(x'34'); // Cmd-4
Dcl-C Cmd05                  Const(x'35'); // Cmd-5
Dcl-C F6AddNewKeyPressed     Const(x'36'); // Cmd-6
Dcl-C Cmd07                  Const(x'37'); // Cmd-7
Dcl-C F8DeleteKeyPressed     Const(x'38'); // Cmd-8
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
  StatusCodeOID  Packed(9:0);
  Code           Char(25);
  Description    Char(100);
End-ds;

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
  //   SFLOA (Subfile Output Field) = Yellow
  //   SFLIOA (Subfile Input/Output Field) = White/Underline
  //   FKEYSA (Function Keys) = Ble
  TitleA = White;
  OptionA = White;
  HeaderA = BlueUnderline;
  SflOA = YellowColumnSeparator;
  SflIoA = BlueUnderline;
  FErrMsgA = NonDisplay;
  FKeysA = Blue;

  // Top/Bottom of screen soft-load logic
  Title1Work = 'Status Codes Master Maintenance';
  optLine1  = 'Select:  C=Change Description   D=Delete Status Code ';

  // Load Function Keys to be placed on the screen
  FunctionKeysText(1) = 'F3=Exit';
  FunctionKeysText(2) = 'F6=Add New Status Code';
  FunctionKeysText(3) = '<Enter> to Change or Delete';
  FunctionKeysCount = 3;

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
DoU FunctionKeyPressed = F3ExitKeyPressed;
  Write Dummy1;
  Write Header1;
  Write Footer1;
  SflRcd = 1;
  ExFmt SflCtl1;
  FErrMsgA = NonDisplay;
  Select;
    When FunctionKeyPressed = F3ExitKeyPressed;
      Leave;
    When FunctionKeyPressed = F6AddNewKeyPressed;
      CallToAddOrChangeStatusCode();
      ClearSubfile();
      LoadSubfile();
    When FunctionKeyPressed = EnterKeyPressed;
      UpdateOrDeleteStatusCode();
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

  //Get data and load to screen fields
  //Setup any special attributes
  OPTLINE  = optLine1;
  Exec Sql
    Declare Sql1Cursor Cursor for
      Select * From Table(Get_Status_Codes_List());
  Exec Sql
    Open Sql1Cursor;
  GetSQLDiagnostics();
  DoU SQLDiagnosticsReturnedSQLCode <> *Zeros;
    Exec SQL Fetch Sql1Cursor into :Status_Data.StatusCodeOID,
                                   :Status_Data.Code,
                                   :Status_Data.Description;
    GetSQLDiagnostics();
    If SQLDiagnosticsReturnedSQLCode = *Zeros;
      SflOID =  Status_Data.StatusCodeOID;
      SflSel =  *Blanks;
      SflCode = Status_Data.Code;
      SflDesc = Status_Data.Description;
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
Dcl-Proc UpdateOrDeleteStatusCode;
//***********************************

  Dcl-S UpdateOrDeleteErrorHappened  Ind;

  Xjr = 1;
  DoU Xjr > Sfl1RecordCount;
    Chain Xjr Sfl1;
    Select;
      When SflSel = 'C';
        CallToAddOrChangeStatusCode(SflOid);
        Leave;
      When SflSel = 'D';
        DeleteExistingStatusCode(SflOid:SflCode:SflDesc);
      When SflSel <> *Blanks;
        FErrMsg = *Blanks;
        FErrMsg = %Trim(GetErrorMessage('ST00001'));
        FErrMsgA = Red;
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

End-Proc UpdateOrDeleteStatusCode;

//***********************************
Dcl-Proc DeleteExistingStatusCode;
//***********************************
  Dcl-Pi *n;
    OidToDelete   Like(SflOid);
    CodeToDelete  Like(SflCode);
    DescToDelete  Like(SflDesc);
  End-Pi;

  Dcl-S DeleteExistingErrorHappened  Ind;
  Dcl-S LeaveDelete  Ind  Inz(*Off);

  DelCode = CodeToDelete;
  DelDesc = DescToDelete;
  LeaveDelete = *Off;

  DoU LeaveDelete;
  Exfmt DeleteW1;
    Select;
      When FunctionKeyPressed = F12CancelKeyPressed;
        SflSel = *Blanks;
        Update Sfl1;
        LeaveDelete = *On;
      When FunctionKeyPressed = EnterKeyPressed;
        Select;
          When Confirm = 'Y';
            Exec SQL
              Delete from StatCode_Tbl_Status_Codes
              Where StatCodeOid = :OidToDelete;
            GetSQLDiagnostics();
            If SQLDiagnosticsReturnedSQLCode = *Zeros;
              Commit;
            Else;
              FErrMsg = *Blanks;
              FErrMsg = %Trim(GetErrorMessage('ST00002'));
              FErrMsgA = Red;
            EndIf;
            Update Sfl1;
            LeaveDelete = *On;
          When Confirm = 'N';
            SflSel = *Blanks;
            Update Sfl1;
            LeaveDelete = *On;
          Other;
            //Remain on the screen until something is selected
        EndSl;
      Other;
        //Remain on the screen until something is selected
    EndSl;
  EndDo;

  On-Exit DeleteExistingErrorHappened;
    If DeleteExistingErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc DeleteExistingStatusCode;

