**FREE
// Receives the title string and length of screen field, returns string centered
Dcl-Pr CenterTitle  Char(100);
  inText          Char(100) Const;
  inScreenLength  Int(5) Const;
End-Pr;

Dcl-Pr SpaceFunctionKeys  Char(125);
  inFunctionKeyText   VarChar(50) Dim(10) Const;
  inFunctionKeyCount  Packed(3:0) Const;
End-Pr;

Dcl-Pr GetErrorMessage  Char(75);
  inErrorMessageId  Char(7) Const;
End-Pr;
