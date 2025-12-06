**FREE
//---------------------------------------------------------------------
//  Header
//---------------------------------------------------------------------

Ctl-Opt DftActGrp(*No)
DatFmt(*Iso)
Option(*NODEBUGIO:*SRCSTMT)
TimFmt(*Iso);
//---------------------------------------------------------------------
//  Files/Tables/Indexes
//---------------------------------------------------------------------
// Display file
Dcl-F SLINBMGTD WorkStn IndDs(displayindicators)
InfDs(infds)
Sfile(TrpHdrD:TpHdRrn);

//---------------------------------------------------------------------
//  Screen Data Structures
//---------------------------------------------------------------------
*
* Information data structure
*
Dcl-Ds INFDS;
FunctionKeyPressed Char(1) Pos(369);
End-Ds;

*
* System status data structure
*
Dcl-Ds ProgramStatus PSDS;
pgmnam Char(10) Pos(1);
wSID Char(10) Pos(244);
userID Char(10) Pos(254);
job# Zoned(6:0) Pos(264);
systemDate Zoned(6:0) Pos(276);
systemTime Zoned(6:0) Pos(282);
program Char(10) Pos(334);
End-Ds;

*
* Display indicators data structure and pointers
*
Dcl-Ds DisplayIndicators Based(pdispindicators);
ind50SflDsp     Ind Pos(50);
inId51SflCtlDsp Ind Pos(51);
End-Ds;
Dcl-S pDispIndicators Pointer Inz(%Addr(*In));

//*
//* Display function key values
//*
Dcl-C Cmd01                  Const(x'31'); // Cmd-1
Dcl-C Cmd02                  Const(x'32'); // Cmd-2
Dcl-C F3ExitKeyPressed       Const(x'33'); // Cmd-3
Dcl-C F4PromptKeyPressed     Const(x'34'); // Cmd-4
Dcl-C F5SelectionKeyPressed  Const(x'35'); // Cmd-5
Dcl-C F6AddKeyPressed        Const(x'36'); // Cmd-6
Dcl-C Cmd07                  Const(x'37'); // Cmd-7
Dcl-C F8UpdateKeyPressed     Const(x'38'); // Cmd-8
Dcl-C F9ReportsKeyPressed    Const(x'39'); // Cmd-8
Dcl-C F10InvoiceKeyPressed   Const(x'3A'); // Cmd-10
Dcl-C F11InquiryKeyPressed   Const(x'3B'); // Cmd-11
Dcl-C F12PreviousKeyPressed  Const(x'3C'); // Cmd-12
Dcl-C F13TransferKeyPressed  Const(x'B1'); // Cmd-13
Dcl-C F14InqSelctKeyPressed  Const(x'B2'); // Cmd-14
Dcl-C F15AeroSSKeyPressed    Const(x'B3'); // Cmd-15
Dcl-C F16RevRptKeyPressed    Const(x'B4'); // Cmd-16
Dcl-C F17DownloadPressed     Const(x'B5'); // Cmd-17
Dcl-C F18ViewConsPressed     Const(x'B6'); // Cmd-18
Dcl-C F19UndAeroPressed      Const(x'B7'); // Cmd-19
Dcl-C F20SelDnLdPressed      Const(x'B8'); // Cmd-19
Dcl-C F21SelectAllPressed    Const(x'B9'); // Cmd-21
Dcl-C F22RemoveKeyPressed    Const(x'BA'); // Cmd-22
Dcl-C Cmd23                  Const(x'BB'); // Cmd-23
Dcl-C Cmd24                  Const(x'BC'); // Cmd-24
Dcl-C EnterKey               Const(x'F1'); // Enter
Dcl-C RollUp                 Const(x'F5'); // Roll Up
Dcl-C RollDown               Const(x'F4'); // Roll Down

//*
//* General display constant values
//* (Ri=Reverse Image;Hi=Hi Intensity;Bl=Blink;Ul=Underline;Nd=NonDisplay)
//*
//* UnProtected Values
Dcl-C Green                                          Const(x'20');
Dcl-C GreenReverseImange                             Const(x'21');
Dcl-C White                                          Const(x'22');
Dcl-C WhiteReverseImage                              Const(x'23');
Dcl-C GreenUnderline                                 Const(x'24');
Dcl-C GreenUnderlineReverseImage                     Const(x'25');
Dcl-C WhiteUnderline                                 Const(x'26');
Dcl-C NonDisplay                                     Const(x'27');
Dcl-C Red                                            Const(x'28');
Dcl-C RedReverseImage                                Const(x'29');
Dcl-C RedHighIntensity                               Const(x'2A');
Dcl-C RedReverseImageHighIntensity                   Const(x'2B');
Dcl-C RedUnderline                                   Const(x'2C');
Dcl-C RedUnderlineReverseImage                       Const(x'2D');
Dcl-C RedUnderlineBlink                              Const(x'2E');
//NonDisplay                                     Const(x'2F');
Dcl-C TurquoiseColumnSeparator                       Const(x'30');
Dcl-C TurquoiseReverseImageColumnSeparator           Const(x'31');
Dcl-C YellowColumnSeparator                          Const(x'32');
Dcl-C WhiteReverseImageColumnSeparator               Const(x'33');
Dcl-C TurquoiseUnderlineColumnSeparator              Const(x'34');
Dcl-C TurquoiseUnderlineReverseImageColumnSeparator  Const(x'35');
Dcl-C YellowUnderscoreColumnSeparator                Const(x'36');
//NonDisplay                                     Const(x'37');
Dcl-C Pink                                           Const(x'38');
Dcl-C PinkReverseImage                               Const(x'39');
Dcl-C Blue                                           Const(x'3A');
Dcl-C BlueReverseImage                               Const(x'3B');
Dcl-C PinkUnderline                                  Const(x'3C');
Dcl-C PinkUnderlineReverseImage                      Const(x'3D');
Dcl-C BlueUnderline                                  Const(x'3E');
//NonDisplay                                     Const(x'3F');
*
//* Protected Values
Dcl-C ProtectedGreen                                 Const(x'A0');
Dcl-C ProtectedGreenReverseImange                    Const(x'A1');
Dcl-C ProtectedWhite                                 Const(x'A2');
Dcl-C ProtectedWhiteReverseImage                     Const(x'A3');
Dcl-C ProtectedGreenUnderline                        Const(x'A4');
Dcl-C ProtectedGreenUnderlineReverseImage            Const(x'A5');
Dcl-C ProtectedWhiteUnderline                        Const(x'A6');
Dcl-C ProtectedNonDisplay                            Const(x'A7');
Dcl-C ProtectedRed                                   Const(x'A8');
Dcl-C ProtectedRedReverseImage                       Const(x'A9');
Dcl-C ProtectedRedHighIntensity                      Const(x'AA');
Dcl-C ProtectedRedReverseImageHighIntensity          Const(x'AB');
Dcl-C ProtectedRedUnderline                          Const(x'AC');
Dcl-C ProtectedRedUnderlineReverseImage              Const(x'AD');
Dcl-C ProtectedRedUnderlineBlink                     Const(x'AE');
//ProtectedNonDisplay                            Const(x'AF');
Dcl-C ProtectedTurquoiseColumnSeparator              Const(x'B0');
Dcl-C ProtectedTurquoiseReverseImageColumnSeparator  Const(x'B1');
Dcl-C ProtectedYellowColumnSeparator                 Const(x'B2');
Dcl-C ProtectedWhiteReverseImageColumnSeparator      Const(x'B3');
Dcl-C ProtectedTurquoiseUnderlineColumnSeparator     Const(x'B4');
Dcl-C ProtectedTurquoiseUnderlineReverseImageColumnSeparator
Const(x'B5');
Dcl-C ProtectedYellowUnderscoreColumnSeparator       Const(x'B6');
//ProtectedNonDisplay                            Const(x'B7');
Dcl-C ProtectedPink                                  Const(x'B8');
Dcl-C ProtectedPinkReverseImage                      Const(x'B9');
Dcl-C ProtectedBlue                                  Const(x'BA');
Dcl-C ProtectedBlueReverseImage                      Const(x'BB');
Dcl-C ProtectedPinkUnderline                         Const(x'BC');
Dcl-C ProtectedPinkUnderlineReverseImage             Const(x'BD');
Dcl-C ProtectedBlueUnderline                         Const(x'BE');
//NonDisplay                                     Const(x'BF');

//--------------------------- Mainline Processing ----------------------//

//===========================================================
// Various Code Segments
//============================================================
Dcl-Proc CodeSegments;

//Basic Loop Logic
DoU FunctionKeyPressed = F3ExitKeyPressed;
Exfmt Prompt;
ErrPrmpt = *Blanks;
Select;
When FunctionKeyPressed = F3ExitKeyPressed;
Leave;
When FunctionKeyPressed = F4PromptKeyPressed;
LINE = 5;
//When...
EndSl;
EndDo;

// Top/Bottom of screen soft-load logic
title = 'This is the title';
optionLine1 = '2=Edit  4=Delete  5=Display  A=Approve  C=Close  ' +
'S=Spreadsheet  F=Flat File';
optionLine2 = '5=Display  S=Spreadsheet';
fKeyLine1   = 'F3=Exit   F5=Refresh   F6=Add   F8=Toggle';
fKeyLine2   = 'F3=Exit   F5=Refresh   F8=Toggle';

// Set File to Working File by Default from above
OPTLINE = optionLine1;
FKYLINE = fKeyLine1;

End-Proc CodeSegments;

//===========================================================
// Soft Code Query Files based on A or B situation
//============================================================
Dcl-Proc SoftCodeQuery;

Dcl-c BASE_QUERY
'select D.DetailGUID, D.IssuerLoanID, D.IssuerTransferNumber, +
trim(char(D.IssuerLoanID)) || ''-'' +
|| digits(D.IssuerTransferNumber) as Loan#, +
D.GinnieMaeLoanID as GNMA_Loan_ID, +
D.DefaultReasonCode as Reason_Code, +
D.PoolID as Pool_ID, +
D.EstimatedForbearanceTerm as Estimated_Forbearance_Term, +
F.FTYPE as Loan_Type, G.TSTATS as Loan_Status +
from QTEMP.GNMA_PDS_REPORTING_DETAIL D +
left join FPMFINC F on D.IssuerLoanID = F.FLOAN +
and D.IssuerTransferNumber = F.FTXFER +
left join GPMCUST G on D.IssuerLoanID = G.TLOAN +
and D.IssuerTransferNumber = G.TTXFER +
where D.HeaderGUID = ? +
and D.Record_Status = ''A'' +
order by ';

If gUseHistoryTables = *Off;
// Use Work tables.
EXEC SQL
Create or replace alias QTEMP.GNMA_PDS_REPORTING_HEADER
for FTWGMPHD_TBL_GNMA_PDS_REPORTING_HEADER_WORK;
EXEC SQL
Create or replace alias QTEMP.GNMA_PDS_REPORTING_DETAIL
for FTWGMPDT_TBL_GNMA_PDS_REPORTING_DETAIL_WORK;
sflTitle = 'Detail Screen-Working';
Else;
// Use History tables.
EXEC SQL
Create or replace alias QTEMP.GNMA_PDS_REPORTING_HEADER
for FTHGMPHD_TBL_GNMA_PDS_REPORTING_HEADER_HISTORY;
EXEC SQL
Create or replace alias QTEMP.GNMA_PDS_REPORTING_DETAIL
for FTHGMPDT_TBL_GNMA_PDS_REPORTING_DETAIL_HISTORY;
sflTitle = 'Detail Screen-History';
Endif;

End-Proc SoftCodeQuery;

//---------------------------------------------------------------------*
// CenterTitle
//---------------------------------------------------------------------*

Dcl-Proc CenterTitle;

Dcl-PI *N like(retStr);
inString  char(50);
inLen     int(5) const;
End-PI;

Dcl-S retStr   Char(50)   Inz;
Dcl-S ln       Int(5)     Inz;
Dcl-S offSet   Int(5)     Inz;

ln=%len(%trim(inString));
offset=(inLen-ln)/2+1;
%subst(retStr:offSet:ln)=%subst(inString:1:ln);

Return retStr;

End-Proc;

// ***********************************
dcl-proc ClearSubfile;
// ***********************************
dcl-pi ClearSubfile;
end-pi;

// SFLDSP    = 30
// SFLDSPCTL = 31
// SFLCLR    = 32
// Error on Action Code = 33

*in30 = *off;
*in31 = *off;
*in32 = *on;
*in33 = *off;
##RRN = 0;
write sfl1ctl;
*in30 = *on;
*in31 = *on;
*in32 = *off;
POS = 1;

ShowMessage(*blanks);

return;

end-proc ClearSubfile;

// ***********************************
dcl-proc LoadSubfile;
// ***********************************
dcl-pi LoadSubfile;
end-pi;


##rrn = 0; // need incoming parm
exec sql declare c1 cursor for
select ACWDFACDT, ACWDFACCD, ACWACGUID, GACDESC from FTWGMACN
join FTMGMACD on acwdfaccd = gacactcd
where ACWDTGUID = :detailGuid and
ACWRCDST = 'A'
order by ACWDFACDT desc, ACWDFACCD;
exec sql open c1;
exec sql fetch c1 into :##date, :##code, :##acguid, :##desc;
dow sqlcode = 0 and ##rrn <= 20;
##rrn +=1;
##OPTN = *blanks;
write sfl1;
exec sql fetch c1 into :##date, :##code, :##acguid, :##desc;
enddo;

exec sql close c1;

return;

end-proc LoadSubfile;


// ***********************************
dcl-proc DisplayScreen;
// ***********************************
dcl-pi DisplayScreen;
end-pi;

// SFLDSP    = 30
// SFLDSPCTL = 31
// SFLCLR    = 32
// Error on Action Code = 33
// viewOnly = 34

if ##rrn > 0;
*in30 = *on;
*in31 = *on;
*in33 = *off;

write FKEY1;
write MSGCTL;
exfmt SFL1CTL;
ShowMessage(*blanks);
else;
*in30 = *off;
*in31 = *on;
write FKEY1;
write norec;
exfmt SFL1CTL;
endif;

return;

end-proc DisplayScreen;


// ***********************************
dcl-proc RefreshScreen;
// ***********************************
dcl-pi RefreshScreen;
end-pi;

ClearSubfile();
LoadSubfile();

return;

end-proc RefreshScreen;

Dcl-proc ProcessSFL ;

//--------------------------------------------------------------------
//  external prototypes
//--------------------------------------------------------------------
//--------------------------------------------------------------------
// Prototype for procedure: UpdateActionCode
// Purpose:        GNMA Default Reporting - Action Code Edit
// Returns:        null
// Parameter:      headerGUID => ID for loan header row
// Parameter:      detailGUID => ID for loan detail row
// Parameter:      viewFlag => Read-only view
// Parameter:      changeFlag => Reason codes were changed  (OUT)
// Parameter:      exitFlag => User requested pgm exit      (OUT)
//--------------------------------------------------------------------
Dcl-pr UpdateActionCode extPgm('FMBSR804') ;
headerGUID like(gFtwGmpHdDs.headerGUID) const ;
detailGUID like(detailGUID) const ;
viewFlag ind const ;
changeFlag ind ;
exitFlag ind ;
End-pr ;

//--------------------------------------------------------------------
//  records
//--------------------------------------------------------------------
Dcl-ds lLoansSflDs likeRec(LOANSSFL :*all) inz ;

//--------------------------------------------------------------------
//  data structures / enums
//--------------------------------------------------------------------
Dcl-ds lEditDetailsDs likeDs(gEditDetailsDs) inz ;
Dcl-ds lGetActionCodeDs likeDs(gGetActionCodeDs) inz ;

//--------------------------------------------------------------------
//  stand-alone fields
//--------------------------------------------------------------------
Dcl-s lReloadSFL ind ;
Dcl-s lUpdateActionCodeChange ind ;
Dcl-s lUpdateActionCodeExit ind ;

//--------------------------------------------------------------------

ReadC LOANSSFL lLoansSflDs;
Dow not %eof();
POS001 = RRN001;
Update LOANSSFL lLoansSflDs;
ReadC LOANSSFL lLoansSflDs;
Enddo;

If lReloadSFL;
LoadSubfile(headerGUID);
Endif;

Return;
On-Exit;
If not lUpdateActionCodeExit;
Clear keyPressed;
Endif;
End-proc ;



Dcl-proc LoadSubfile ;
Dcl-pi *n ;
headerFileGUID like(headerGUID) const ;
End-pi ;

//--------------------------------------------------------------------
//  records
//--------------------------------------------------------------------
Dcl-ds lGetActionCodeDs likeDs(gGetActionCodeDs) inz ;
Dcl-ds lLoansSflDs likeRec(LOANSSFL :*all) inz ;

Dcl-ds lLoadWorkDetailDs qualified inz ;
detailGUID like(detailGUID) ;
issuerLoanID like(gFtwGmpDtDs.issuerLoanID) ;
issuerTransferNumber like(gFtwGmpDtDs.issuerTransferNumber) ;
loanID like(loanID) ;
ginnieMaeLoanID like(ginnieMaeLoanID) ;
defaultReasonCode like(defaultReasonCode) ;
poolID like(poolID) ;
estimatedForbearanceTerm like(estimatedForbearanceTerm) ;
loanType like(loanType) ;
loanStatus like(loanStatus) ;
End-ds ;

//--------------------------------------------------------------------
//  stand-alone fields
//--------------------------------------------------------------------
Dcl-s lNullInd int(5) dim(100) ;
Dcl-s lPositionToNumeric int(10) ;

Dcl-s lQuery varChar(1024) ;

//--------------------------------------------------------------------
//  named constants
//--------------------------------------------------------------------
Dcl-c BASE_QUERY
'select D.DetailGUID, D.IssuerLoanID, D.IssuerTransferNumber, +
trim(char(D.IssuerLoanID)) || ''-'' +
|| digits(D.IssuerTransferNumber) as Loan#, +
D.GinnieMaeLoanID as GNMA_Loan_ID, +
D.DefaultReasonCode as Reason_Code, +
D.PoolID as Pool_ID, +
D.EstimatedForbearanceTerm as Estimated_Forbearance_Term, +
F.FTYPE as Loan_Type, G.TSTATS as Loan_Status +
from QTEMP.GNMA_PDS_REPORTING_DETAIL D +
left join FPMFINC F on D.IssuerLoanID = F.FLOAN +
and D.IssuerTransferNumber = F.FTXFER +
left join GPMCUST G on D.IssuerLoanID = G.TLOAN +
and D.IssuerTransferNumber = G.TTXFER +
where D.HeaderGUID = ? +
and D.Record_Status = ''A'' +
order by ';

//--------------------------------------------------------------------

// Clear SFL.  14 Oct 24 JET
*in28 = *off;
RRN001 = 0;
Write LOANSCTL;
*in28 = *on;
POS001 = 1;

lQuery = BASE_QUERY;
If gPositionToColumn <> *blank and gPositionToValue <> *blank;
gPositionToValue = %trim(gPositionToValue);
If gPositionToColumn = POSITION_TO_LOAN_ID;
Monitor;
lPositionToNumeric = %int(gPositionToValue);
On-Error;
Clear gPositionToColumn;
Clear gPositionToValue;
Endmon;
Endif;
Endif;

If gPositionToColumn <> POSITION_TO_POOL_ID;
lQuery += 'IssuerLoanID';
Else;
lQuery += 'PoolID';
Endif;
lQuery += ' for read only';

EXEC SQL  Prepare LoadWorkDetailStmt From :lQuery;

EXEC SQL  Declare LoadWorkDetailCsr Cursor For LoadWorkDetailStmt;

EXEC SQL  Open LoadWorkDetailCsr Using :headerFileGUID;
If SQLSTATE = CURSOR_ALREADY_OPEN_SQL;
EXEC SQL  Close LoadWorkDetailCsr;
EXEC SQL  Open LoadWorkDetailCsr;
Endif;

RRN001 = 0;
POS001 = 0;

EXEC SQL  Fetch Next From LoadWorkDetailCsr into :lLoadWorkDetailDs
:lNullInd;
Dow SQLSTATE = SUCCESS_SQL;
RRN001 += 1;
Eval-Corr lLoansSflDs = lLoadWorkDetailDs;
// Get Action Code for SFL display.  17 Oct 24 JET
lGetActionCodeDs = GetActionCode(lLoadWorkDetailDs.detailGUID);
Eval-Corr lLoansSflDs = lGetActionCodeDs;
EvalR lLoansSflDs.LoanID = %trim(lLoansSflDs.LoanID);
lLoansSflDs.CustName = GetCustomerName(lLoadWorkDetailDs.issuerLoanID
:lLoadWorkDetailDs.issuerTransferNumber);
lLoansSflDs.dueDate = GetDueDate(lLoadWorkDetailDs.issuerLoanID
:lLoadWorkDetailDs.issuerTransferNumber);
If lLoansSflDs.dueDate <> d'1940-01-01';
Clear lLoansSflDs.P_DUE_DATE;
Else;
lLoansSflDs.P_DUE_DATE = DSPATR_NON_DISPLAY;
Endif;
// Check for null date
lLoansSflDs.P_DF_AC_DT =
CheckDefaultActionCodeDate(lLoansSflDs.defaultActionCodeDate);

// Set position-to line.  16 Oct 24 JET
If gPositionToValue <> *blank;
If gPositionToColumn = POSITION_TO_LOAN_ID
and lPositionToNumeric >= lLoadWorkDetailDs.IssuerLoanID
or gPositionToColumn = POSITION_TO_POOL_ID
and gPositionToValue >= lLoansSflDs.PoolID;
POS001 = RRN001;
If gPositionToColumn = POSITION_TO_LOAN_ID
and lPositionToNumeric = lLoadWorkDetailDs.IssuerLoanID
or gPositionToColumn = POSITION_TO_POOL_ID
and gPositionToValue = lLoansSflDs.PoolID;
// Stop on first exact match.  16 Oct 24 JET
Clear gPositionToValue;
Endif;
Endif;
Endif;
Write LOANSSFL lLoansSflDs;
EXEC SQL  Fetch Next From LoadWorkDetailCsr into :lLoadWorkDetailDs
:lNullInd;
Enddo;

Return;

//....................................................................

On-Exit;
EXEC SQL  Close LoadWorkDetailCsr;
End-proc ;





