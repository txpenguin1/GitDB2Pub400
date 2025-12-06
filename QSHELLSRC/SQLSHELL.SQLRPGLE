**FREE
//---------------------------------------------------------------------
//  Header
//---------------------------------------------------------------------
Ctl-Opt  DftActGrp(*No)
ActGrp(*Caller)
Option(*noDebugIO:*SrcStmt)
BndDir('FMBSR807')
DatFmt(*ISO) TimFmt(*ISO);

//---------------------------------------------------------------------
//  Files/Tables/Indexes
//---------------------------------------------------------------------
Dcl-F SlDlBdgL3 Keyed Alias UsrOpn Qualified
ReName(SlDlBdgP:rSlDlBdgL3);

//---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
//---------------------------------------------------------------------
Dcl-Pr SqlShell;
*n  Like(receiveParm1);
*n  Like(receiveParm2);
*n  Like(returnFlag);
*n  Like(returnString);
End-Pr;

Dcl-Pi SqlShell;
inParm1          Like(receiveParm1);
inParm2          Like(reveiveParm2);
outReturnFlag    Like(returnFlag);
outReturnString  Like(returnString);
End-Pi;

//---------------------------------------------------------------------
//  Copy Books/Prototype Imports
//---------------------------------------------------------------------
/Include Qrpglecpy,FMBSR807CP;
/Include Qrpglecpy,FMBSR807MD;

//---------------------------------------------------------------------
//  External Program Prototype
//---------------------------------------------------------------------
Dcl-Pr QCMDEXC ExtPgm('QCMDEXC');
command_String  Char(1024)   Options(*VarSize);
command_Length  Packed(15:5) Const;
End-Pr;

Dcl-Pr DisplayMessage ExtPgm('PGMMSG');
programName     Char(10)  Const;
messageID       Char(7)   Const;
messageFile     Char(10)  Const;
fileLibrary     Char(10)  Const;
message         Char(80)  Const;
clearMessages   Char(1)   Const;
End-Pr;

Dcl-Pr DatePrompt ExtPgm('FINVR463');
pFieldName      Char(15)    Const;
pProtect        Char(1)     Const;
pInDate         Zoned(8:0)  Const;
pOutDate        Zoned(8:0);
End-Pr;

Dcl-Pr GenericPrompt Extpgm('FINVR464');
pinField         VarChar(10)  Const;    //fieldname
pinValue         VarChar(80)  Const;    //value selected on entry
pinTitle         VarChar(50)  Const;    //title
pinSubTitle      VarChar(50)  Const;    //sub-title
pinColHdg        VarChar(70)  Const;    //column heading
pinSql           VarChar(256) Const;    //fieldname
pinLine          Zoned(2:0)   Const;    //row position
pinPosition      Zoned(2:0)   Const;    //col position
pinSize          Char(1)      Const;    //size s m l
pinBorder        Char(1)      Const;    //border y n + other border info
pinVarLen        Zoned(2:0)   Const;    // variable length in subfile
pOutField        VarChar(80);           // out field value selected
pOutStatus       Char(1);               // out field status error,not selected/selected
pOutMessage      VarChar(30);           // out field status error,not selected/selected
End-Pr;

Dcl-Pr WriteToJobLog  Int(10) ExtProc('Qp0zLprintf');
*n Pointer Value Options(*String);  // Log Message
*n Pointer Value Options(*String:*NoPass);
*n Pointer Value Options(*String:*NoPass);
*n Pointer Value Options(*String:*NoPass);
*n Pointer Value Options(*String:*NoPass);
*n Pointer Value Options(*String:*NoPass);
*n Pointer Value Options(*String:*NoPass);
*n Pointer Value Options(*String:*NoPass);
*n Pointer Value Options(*String:*NoPass);
*n Pointer Value Options(*String:*NoPass);
*n Pointer Value Options(*String:*NoPass);
End-Pr;

//---------------------------------------------------------------------
//  Prototypes for Procedures
//---------------------------------------------------------------------
Dcl-Pr CodeSegments  End-Pr;

//---------------------------------------------------------------------
//  Prototypes for Functions
//---------------------------------------------------------------------
Dcl-Pr ShellFunction1  Packed(3:0)  End-Pr;
*
Dcl-Pr ShellFunction2;
PassedParm1  Char(10) Value;
End-Pr;

//---------------------------------------------------------------------
//  Data Structures based upon external file layouts
//---------------------------------------------------------------------
Dcl-Ds In_FileName ExtName('FileName') Prefix(in : 2) End-Ds;

//---------------------------------------------------------------------
//  Data Structure to Use Long Field Names
//---------------------------------------------------------------------
Dcl-Ds AuditBridgeL3 LikeRec(SLDLBDGL3.rSLDLBDGL3);

//---------------------------------------------------------------------
//  Other Data structures
//---------------------------------------------------------------------
*
* System status data structure
*
Dcl-Ds ProgramStatusDS  PSDS;
pgmName        Char(10)   Pos(1);
workstationId  Char(10)   Pos(244);
userID         Char(10)   Pos(254);
job#           Zoned(6:0) Pos(264);
systemDate     Zoned(6:0) Pos(276);
systemTime     Zoned(6:0) Pos(282);
program        Char(10)   Pos(334);
End-Ds;
*
* Data Structure for SQL Diagnostic Results
*
Dcl-Ds DataStructureForSQLDiagnostics Inz;
sQLDiagnosticsMessageId         Char(10);
sQLDiagnosticsMessageId1        VarChar(7);
sQLDiagnosticsMessageId2        VarChar(7);
sQLDiagnosticsMessageLength     Int(5);
sQLDiagnosticsMessageText       VarChar(32740);
sQLDiagnosticsReturnedSQLCode   Int(5);
sQLDiagnosticsReturnedSQLState  Char(5);
sQLDiagnosticsRowsCount         Int(10);
sQLDiagnosticsSuccessFlag       Ind;
End-Ds;
*
* Constants for error message codes
*
Dcl-S noDateTime Char(26) Inz('0001-01-01-00.00.00.000000');
Dcl-S noDateTimeTimeStamp TimeStamp;
Dcl-C isSuccessful        Const('000');
Dcl-C notSuccessful       Const('999');
Dcl-C isUnrecoverable     Const('004');
*
*  Parameters for generic prompt  FINVR464
*
Dcl-S inField     VarChar(10);   //fieldname
Dcl-S inValue     VarChar(80);   //value selected on entry
Dcl-S inTitle     VarChar(50);   //title
Dcl-S inSubTitle  VarChar(50);   //sub-title
Dcl-S inColHdg    VarChar(70);   //column heading
Dcl-S inSql       VarChar(256);  //fieldname
Dcl-S inLine      Zoned(2:0);    //row position
Dcl-S inPosition  Zoned(2:0);    //col position
Dcl-S inSize      Char(1) ;      //size s m l
Dcl-S inBorder    Char(1) ;      //border y n + other border info
Dcl-S inVarLen    Zoned(2:0) ;   // variable length in subfile
Dcl-S OutField    VarChar(80);   // out field value selected
Dcl-S OutStatus   Char(1);       // out field status code
Dcl-S OutMessage  VarChar(30);   // out field status message

//---------------------------------------------------------------------
//  Arrays
//---------------------------------------------------------------------
Dcl-Ds *n;
Named_Array  Char(223) Dim(200) Ascend;
Value1     Zoned(12) Overlay(Named_Array:1) Inz(*Zeros);
Value2     Char(3)   Overlay(Named_Array:13) Inz(*Blanks);
End-Ds;

//---------------------------------------------------------------------
//  Define Data Areas
//---------------------------------------------------------------------
Dcl-Ds *N DTAARA('NAME');
NameValue Char(4);
End-Ds;

//---------------------------------------------------------------------
//  Program Input and Output Parameters
//---------------------------------------------------------------------
Dcl-S receiveParm1  Char(500);
Dcl-S receiveParm2  Zoned(3);
Dcl-S returnFlag    Char(1);
Dcl-S returnString  Char(250);

//---------------------------------------------------------------------
//  Declared Variable and Constant for Writing to the Job Log
//---------------------------------------------------------------------
Dcl-S JobLogMessage  VarChar(200) Inz(*Blanks);
Dcl-C JobLogCRLF     Const(x'0d25');

//---------------------------------------------------------------------
//  Generic Program Variables
//---------------------------------------------------------------------
Dcl-S commandLength        Int(5) Inz( 0 );
Dcl-S date#                Packed(8:0) Inz(*Zeros);
Dcl-S noDateTime           Char(26) Inz('0001-01-01-00.00.00.000000');
Dcl-S noDateTimeTimeStamp  TimeStamp;
dcl-s nullInds             Int(5) Dim(100) ;
Dcl-S submitCommand        Char(200) Inz( *Blank );
Dcl-S time6#               Packed(6:0) Inz(*Zeros);
Dcl-S xjr                  Packed(3:0) Inz(*Zeros);

//---------------------------------------------------------------------
//  Program Variables
//---------------------------------------------------------------------
Dcl-S someParm  Packed(3:0) Inz(*Zeros);

//---------------------------------------------------------------------
//  Program Indicators
//---------------------------------------------------------------------
Dcl-S Sql1CursorIsOpen  Ind Inz(*Off);

//---------------------------------------------------------------------
//  Program Constants
//---------------------------------------------------------------------
Dcl-C quote          Const(X'7D');
Dcl-C isSuccessful   Const('000');
Dcl-C notSuccessful  Const('999');
Dcl-C lower          Const('abcdefghijklmnopqrstuvwxyz');
Dcl-C upper          Const('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
Dcl-C digits         Const('0123456789');
Dcl-C hyphen         Const('-');

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

//===========================================================
// Various Code Segments
//============================================================
Dcl-Proc CodeSegments;

//Generic Prompt
Dcl-S inField     VarChar(10)  Inz('GACACTCD');     //fieldname
Dcl-S inValue     VarChar(80);                      //value selected on entry
Dcl-S inTitle     VarChar(50)  Inz('GNMA Default Reporting');  //title
Dcl-S inSubTitle  VarChar(50)  Inz('List of Action Codes');    //sub-title
Dcl-S inColHdg    VarChar(70)  Inz('Action Code and Description');
Dcl-S inSql       VarChar(256) Inz(*Blanks);        //fieldname
Dcl-S inLine      Zoned(2:0)   Inz(2);              //row position
Dcl-S inPosition  Zoned(2:0)   Inz(5);              //col position
Dcl-S inSize      Char(1)      Inz('M');            //size s m l
Dcl-S inBorder    Char(1)      Inz(*Blanks);        // border y n + other border info
Dcl-S inVarLen    Zoned(2:0)   Inz(0);              // variable length in subfile
Dcl-S OutField    VarChar(80);                      // out field value selected
Dcl-S OutStatus   Char(1);      // out field status error,not selected,selected
Dcl-S OutMessage  VarChar(30);  // out field status error,not selected,selected
Dcl-S Addlvalues  VarChar(200);
If fld = 'EDTCODE';
inSql = 'Select GACACTCD, Substring(GACDESC,1,50), ' +
'GACACTCD from ftmgmacd Order by gacactcd';
Clear inValue;
Clear inBorder;
Clear outField;
Clear outStatus;
Clear outMessage;
GenericPrompt(inField:inValue:inTitle:inSubTitle:inColHdg:
inSQl:inLine:inPosition:inSize:inBorder:inVarLen:
outField:outStatus:outMessage:addlValues);
If outField <> *blanks and outfield <> ##code;
edtcode = outField;
EndIf;
EndIf;

//Date Prompt
DatePrompt('Action Code Date':'N':inDate:outDate);
If outDate <> *zero and cfkey <> EXIT and cfkey <> CANCEL;
edtdate = %Date(outDate);
EndIf;

//Submit Command
submitCommand = 'SBMJOB CMD(CALL PGM(FMBSR805S) +
PARM(dsHeaders)) JOB(GNMAEXLRPT)';
commandLength = %Len(%Trim(submitCommand));
Monitor;
QcmdExc(submitCommand : commandLength);
On-Error;
JobLogMessage = '*** Error submitting batch job';
WriteToJobLog(JobLogMessage + '%s':JobLogCRLF);
ErrorSubmitReportJob();
EndMon;

//SQL Open Logic
If Not Sql1CursorIsOpen;
Exec SQL OPEN C1;
GetSQLDiagnostics();
If SQLDiagnosticsReturnedSQLCode = *Zero;
Sql1CursorIsOpen = *On;
Else;
JobLogMessage = '*** Error Opening Cursor C1';
WriteToJobLog(JobLogMessage + '%s':JobLogCRLF);
EndIf;
EndIf;

//SQL Do Read Loop
DoU SQLDiagnosticsReturnedSQLCode <> *Zeros;
Exec SQL Fetch C1 into :GetUserEmail;
GetSQLDiagnostics();
If SQLDiagnosticsReturnedSQLCode = *Zeros;
//Code Logic here
EndIf;
EndDo;

//SQL Select Into with NullInds
EXEC SQL
Select H.IssuerID, digits(H.ReportingPeriod) || '-' ||
right(digits(H.ReportingPeriod), 2) as ReportingPeriod,
H.SequenceNumber
Into :issuerID :lNullInd, :reportingPeriod :NullInds,
:sequenceNumber :NullInds
From QTEMP.GNMA_PDS_REPORTING_HEADER H
Where H.HeaderGUID = :headerGUID
Fetch first 1 row only;

//SQL Close Logic
If Not Sql1CursorIsOpen;
Exec SQL OPEN C1 USING :ProcessWeekStartDate, :ProcessWeekEndDate
GetSQLDiagnostics();
If SQLDiagnosticsReturnedSQLCode = *Zeros;
Sql2CursorIsOpen = *On;
Else;
JobLogMessage = '*** Error Opening Cursor C1';
WriteToJobLog(JobLogMessage + '%s':JobLogCRLF);
EndIf;
EndIf;

End-Proc CodeSegments;

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Procedure to obtain SQL Diagnostics
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Dcl-Proc GetSQLDiagnostics;

Clear DataStructureForSQLDiagnostics;

Exec Sql GET DIAGNOSTICS CONDITION 1
:SQLDiagnosticsMessageId         = DB2_MESSAGE_ID,
:SQLDiagnosticsMessageId1        = DB2_MESSAGE_ID1,
:SQLDiagnosticsMessageId2        = DB2_MESSAGE_ID2,
:SQLDiagnosticsMessageLength     = MESSAGE_LENGTH,
:SQLDiagnosticsMessageText       = MESSAGE_TEXT,
:SQLDiagnosticsReturnedSQLCode   = DB2_RETURNED_SQLCODE,
:SQLDiagnosticsReturnedSQLState  = RETURNED_SQLSTATE,
:SQLDiagnosticsRowsCount         = DB2_SQLERRD3;

End-Proc GetSQLDiagnostics;

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
JobLogMessage = '*** Error Closing Cursor C1 - Close Procedure'
WriteToJobLog(JobLogMessage + '%s':JobLogCRLF);
EndIf;
EndIf;

End-Proc CloseSqlCursors;




