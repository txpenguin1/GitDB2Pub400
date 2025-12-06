**FREE
//---------------------------------------------------------------------
//  Header
//---------------------------------------------------------------------
/Copy QRpgLeCpy,StdHdr
//---------------------------------------------------------------------
//  Files/Tables/Indexes
//---------------------------------------------------------------------
// Files (if any)
//Dcl-F Tables  Alias Qualified ReName(Tables:rTables);
//Dcl-F OpsRating  Alias Qualified Usage(*Output)
//                                 ReName(OpsRating:rOpsRating);
//---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
//---------------------------------------------------------------------
Dcl-Pr ProjGenR;
  *n  Like(receiveParm1);
  *n  Like(receiveParm2);
  *n  Like(returnFlag);
  *n  Like(returnString);
End-Pr;

Dcl-Pi ProjGenR;
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
Dcl-Proc DoTheWork;
//***********************************

//Basic Loop Logic
DoU Date# = 1;
EndDo;

End-Proc DoTheWork;

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

