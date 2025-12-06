**FREE
//---------------------------------------------------------------------
//  Header
//---------------------------------------------------------------------
/Copy QRpgLeCpy,StdHdr
//---------------------------------------------------------------------
//  Files/Tables/Indexes
//---------------------------------------------------------------------
// Display file
Dcl-F ProjDspf  WorkStn IndDs(displayindicators)
                InfDs(infds)
                Sfile(Sfl1:Sfl1Rrn);
//---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
//---------------------------------------------------------------------
Dcl-Pr ProjDspfR;
  *n  Like(receiveParm1);
  *n  Like(receiveParm2);
  *n  Like(returnFlag);
  *n  Like(returnString);
End-Pr;

Dcl-Pi ProjDspfR;
  inParm1          Like(receiveParm1);
  inParm2          Like(receiveParm2);
  outReturnFlag    Like(returnFlag);
  outReturnString  Like(returnString);
End-Pi;

//---------------------------------------------------------------------
//  Program Input and Output Parameters
//---------------------------------------------------------------------
Dcl-S receiveParm1  Char(500);
Dcl-S receiveParm2  Zoned(3);
Dcl-S returnFlag    Char(1);
Dcl-S returnString  Char(250);

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
Dcl-C F4PromptKeyPressed     Const(x'34'); // Cmd-4
Dcl-C Cmd05                  Const(x'35'); // Cmd-5
Dcl-C Cmd06                  Const(x'36'); // Cmd-6
Dcl-C Cmd07                  Const(x'37'); // Cmd-7
Dcl-C Cmd08                  Const(x'38'); // Cmd-8
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
Dcl-C EnterKey               Const(x'F1'); // Enter
Dcl-C RollUp                 Const(x'F5'); // Roll Up
Dcl-C RollDown               Const(x'F4'); // Roll Down

//---------------------------------------------------------------------
//  Display File Data Structures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,DspfDs

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
  CloseSqlCursors();
  *InLr = *On;
  Return;
On-Error *Program;
  Dump(A);
  CloseSqlCursors();
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
  SflOA = Blue;
  SflIoA = BlueUnderline;
  FKeysA = Blue;

  // Top/Bottom of screen soft-load logic
  optLine1 = '2=Edit  4=Delete  5=Display  A=Approve  C=Close  ' +
  'S=Spreadsheet  F=Flat File';
  optLine2 = '5=Display  S=Spreadsheet';
  fKeyLine1   = 'F3=Exit   F5=Refresh   F6=Add   F8=Toggle';
  fKeyLine2   = 'F3=Exit   F5=Refresh   F8=Toggle';

  // Set File to Working File by Default from above
  OPTLINE  = optLine1;
  FKEYLINE = fKeyLine1;

End-Proc SetupScreenGenerics;

//***********************************
Dcl-Proc DoTheWork;
//***********************************

//Basic Loop Logic
DoU FunctionKeyPressed = F3ExitKeyPressed;
  Exfmt Footer1;
  Select;
    When FunctionKeyPressed = F3ExitKeyPressed;
      Leave;
    When FunctionKeyPressed = F4PromptKeyPressed;
    //When...
    Other;
      //Other
  EndSl;
EndDo;

End-Proc DoTheWork;

//***********************************
Dcl-Proc ClearSubfile;
//***********************************

  // SFLDSP    = 90
  // SFLDSPCTL = 91

  *In30 = *Off;
  *In31 = *Off;
  Sfl1Rrn = 0;
  Write SflCtl1;
  *In30 = *On;

End-Proc ClearSubfile;

//***********************************
Dcl-Proc LoadSubfile;
//***********************************

  //Get data and load to screen fields
  //Setup any special attributes
  Sfl1Rrn += 1;
  Write Sfl1;
  *In31 = *Off;

End-Proc LoadSubfile;

//---------------------------------------------------------------
//  Procedure at the end of the job to close the open cursors
//---------------------------------------------------------------
Dcl-Proc CloseSqlCursors;

  If SQL1CursorIsOpen;
    Exec SQL CLOSE C1;
    GetSQLDiagnostics();
    If SQLDiagnosticsReturnedSQLCode = *Zero;
      SQL1CursorIsOpen = *Off;
    Else;
      JobLogMessage = '*** Error Closing Cursor C1 - Close Procedure';
      WriteToJobLog(JobLogMessage + '%s':JobLogCRLF);
    EndIf;
  EndIf;

End-Proc CloseSqlCursors;

