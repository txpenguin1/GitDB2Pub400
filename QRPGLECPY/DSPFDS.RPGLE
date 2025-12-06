**Free
// ---------------------------------------------------------------------
//  Screen Data Structures
// ---------------------------------------------------------------------
//
// Information data structure
//
Dcl-Ds INFDS;
  FunctionKeyPressed Char(1) Pos(369);
End-Ds;

//
// Display indicators data structure and pointers
//
Dcl-Ds DisplayIndicators Based(pdispindicators);
  Ind90SflDsp      Ind Pos(90);
  Ind91SflCtlDsp   Ind Pos(91);
  Ind97SflEnd      Ind Pos(97);
  Ind98SflNxtChg   Ind Pos(98);
  Ind99SflAlarm    Ind Pos(99);
End-Ds;
Dcl-S pDispIndicators  Pointer Inz(%Addr(*In));

Dcl-S Sfl1RecordCount  Packed(5:0) Inz(*Zeros);
Dcl-S Sfl2RecordCount  Packed(5:0) Inz(*Zeros);
Dcl-S Sfl3RecordCount  Packed(5:0) Inz(*Zeros);

Dcl-S ErrorsOnScreen  Ind Inz(*Off);

// ---------------------------------------------------------------------
//  Option and Function Key Lines
// ---------------------------------------------------------------------
Dcl-S OptLine    Char(100);
Dcl-S FKeyLine   Char(125);

Dcl-S OptLine1   Like(OptLine);
Dcl-S OptLine2   Like(OptLine);
Dcl-S OptLine3   Like(OptLine);
Dcl-S OptLine4   Like(OptLine);
Dcl-S OptLine5   Like(OptLine);
Dcl-S OptLine6   Like(OptLine);
Dcl-S OptLine7   Like(OptLine);
Dcl-S OptLine8   Like(OptLine);
Dcl-S OptLine9   Like(OptLine);
Dcl-S OptLine10  Like(OptLine);

Dcl-S FKeyLine1   Like(FKeyLine);
Dcl-S FKeyLine2   Like(FKeyLine);
Dcl-S FKeyLine3   Like(FKeyLine);
Dcl-S FKeyLine4   Like(FKeyLine);
Dcl-S FKeyLine5   Like(FKeyLine);
Dcl-S FKeyLine6   Like(FKeyLine);
Dcl-S FKeyLine7   Like(FKeyLine);
Dcl-S FKeyLine8   Like(FKeyLine);
Dcl-S FKeyLine9   Like(FKeyLine);
Dcl-S FKeyLine10  Like(FKeyLine);

