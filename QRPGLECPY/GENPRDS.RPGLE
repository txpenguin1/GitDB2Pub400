**FREE
// ---------------------------------------------------------------------
//  External Program Prototype
// ---------------------------------------------------------------------
Dcl-Pr CommandToExecute ExtPgm('QCMDEXC');
  command_String  Char(1024)   Options(*VarSize);
  command_Length  Packed(15:5) Const;
End-Pr;

//
// System status data structure
//
Dcl-Ds ProgramStatusDS PSDS;
  ModuleName     Char(10)   Pos(1);
  WorkstationID  Char(10)   Pos(244);
  UserID         Char(10)   Pos(254);
  JobNumber      Zoned(6:0) Pos(264);
  SystemDate     Zoned(6:0) Pos(276);
  SystemTime     Zoned(6:0) Pos(282);
  ProgramName    Char(10)   Pos(334);
End-Ds;

//
// Data Structure for SQL Diagnostic Results
//
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

// For use with SQL Read Into Variables
Dcl-S nullInds  Int(5) Dim(100);



