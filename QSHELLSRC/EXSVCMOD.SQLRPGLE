**FREE
Ctl-Opt NOMAIN;
//********************************************************************
//                                                                   *
// Examples from service program FNMASR of how to code and retrieve  *
// data structures using the service program                         *
// See Two examples below for retrieving a data structure in the     *
// calling program.                                                  *
//                                                                   *
//Desc: Various FNMA routines for the daily single debits and        *
//      back end WEB application.                                    *
//                                                                   *
// Procedure          Description                                    *
// ------------       ----------------------------------------       *
// Procedure1         Get a 6 position result                      *
// Procedure2         Get an amount                                  *
//                                                                   *
//------------------------------------------------------------------ *
//?*** Note *** Be sure to add the copy book to the programs using   *
//?             this service program                                 *
//  /copy Prsrcefl,TEMPSVCPR                                         *
//********************************************************************
//                  PROGRAM CHANGE LOG                               *
//ISR #     BY          DATE      DESCRIPTION                        *
//--------  ----------  --------  --------------------------------   *
//          X. xxxxxxx  99/99/99  Created                            *
//********************************************************************

// I'm using this /copy here because it will include the data
// structures.  Otherwise you'd have to code the data structures in
// each program that uses the service program
 /copy Prsrcefl,TEMPSVCPR;

//-------------------------------------------------------------------*
// Procedure1 -  Description of what this will do
//-------------------------------------------------------------------*
 Dcl-Proc Procedure1  export;

 Dcl-Pi *n char(6);
   WkInParm char(3) const;
 End-Pi;

   Clear WkField;

   MainCode;

   return WkField;

 End-Proc;
//-------------------------------------------------------------------*
// Procedure2 -  Description of what this will do
//-------------------------------------------------------------------*
 Dcl-Proc Procedure2  Export;

 Dcl-Pi *n packed(9:2);
   WkInBrn#   Packed(5) const;
   WkInApp#   Packed(7) const;
 End-Pi;

   Clear WkAmount;

   MainCode;

   return WkAmount;

 End-Proc ;

