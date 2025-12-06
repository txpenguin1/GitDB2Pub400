**FREE
// ---------------------------------------------------------------------
//  Date and TimeStamp Defaults
// ---------------------------------------------------------------------
Dcl-S noDateTime           Char(26)  Inz('0001-01-01-00.00.00.000000');
Dcl-S noDateTimeTimeStamp  TimeStamp;
Dcl-S Date#                Packed(8:0) Inz(*Zeros);
Dcl-S Time6#               Packed(6:0) Inz(*Zeros);

// ---------------------------------------------------------------------
// SQL Cursor Indicators
// ---------------------------------------------------------------------
Dcl-S SQL1CursorIsOpen   Ind Inz(*Off);
Dcl-S SQL2CursorIsOpen   Ind Inz(*Off);
Dcl-S SQL3CursorIsOpen   Ind Inz(*Off);
Dcl-S SQL4CursorIsOpen   Ind Inz(*Off);
Dcl-S SQL5CursorIsOpen   Ind Inz(*Off);
Dcl-S SQL6CursorIsOpen   Ind Inz(*Off);
Dcl-S SQL7CursorIsOpen   Ind Inz(*Off);
Dcl-S SQL8CursorIsOpen   Ind Inz(*Off);
Dcl-S SQL9CursorIsOpen   Ind Inz(*Off);
Dcl-S SQL10CursorIsOpen  Ind Inz(*Off);

// ---------------------------------------------------------------------
//  Program Variables
// ---------------------------------------------------------------------
Dcl-S Title1Work  Char(80) Inz(*Blanks);

Dcl-S BdyTitle1   Char(80) Inz(*Blanks);
Dcl-S BdyTitle2   Char(80) Inz(*Blanks);
Dcl-S BdyTitle3   Char(80) Inz(*Blanks);
Dcl-S BdyTitle4   Char(80) Inz(*Blanks);

Dcl-S FunctionKeysText   VarChar(50) Dim(10);
Dcl-S FunctionKeysCount  Packed(3:0) Inz(*Zeros);

Dcl-S Xjr   Packed(5:0) Inz(*Zeros);
Dcl-S Xjr2  Packed(5:0) Inz(*Zeros);
Dcl-S Xjr3  Packed(5:0) Inz(*Zeros);
Dcl-S Xjr4  Packed(5:0) Inz(*Zeros);
Dcl-S Xjr5  Packed(5:0) Inz(*Zeros);

// ---------------------------------------------------------------------
//  Program Constants
// ---------------------------------------------------------------------
Dcl-C quote                Const(X'7D');
Dcl-C isSuccessful         Const('000');
Dcl-C isUnrecoverable      Const('004');
Dcl-C notSuccessful        Const('999');
Dcl-C lower                Const('abcdefghijklmnopqrstuvwxyz');
Dcl-C upper                Const('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
Dcl-C digits               Const('0123456789');
Dcl-C hyphen               Const('-');


