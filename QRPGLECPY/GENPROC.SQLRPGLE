**FREE

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//  Procedure to obtain SQL Diagnostics
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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


