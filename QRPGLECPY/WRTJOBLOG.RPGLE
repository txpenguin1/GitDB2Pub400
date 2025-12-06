**FREE
// ---------------------------------------------------------------------
//  Procedure for Writing Messages to the Job Log
// ---------------------------------------------------------------------
Dcl-Pr WriteToJobLog  ExtProc('Qp0zLprintf');
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

// ---------------------------------------------------------------------
//  Declared Variable and Constant for Writing to the Job Log
// ---------------------------------------------------------------------
Dcl-S JobLogMessage  VarChar(200) Inz(*Blanks);
Dcl-C JobLogCRLF     Const(x'0d25');

