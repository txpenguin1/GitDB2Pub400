**FREE
//*******************************************************************
//                                                                  *
// PGM ID - NAME    /CopyBook for the procedure routines            *
//                                                                  *
//*******************************************************************
//    *  Procedure          Description                                   *
//    *  ------------       ----------------------------------------      *
//    *  Procedure1         Parms for procedure 1                         *
//    *  Procedure2         Parms for procedure 2                         *
//    *********************************************************************
//    *                   PROGRAM CHANGE LOG                              *
//    * Project#  BY          DATE      DESCRIPTION                       *
//    * --------  ----------  --------  --------------------------------  *
//    * xxxxxxx   X. Xxxxxxx  99/99/99  Created                           *
//    *********************************************************************

//Sends in one parm, returns 6 position result
  Dcl-Pr Procedure1  char(6);
    WkInParm    char(3) const;
  End-Pr;

//Sends in two parms, returns an amount
  Dcl-Pr Procedure2  packed(9:2);
    WkInBrn#   Packed(5) const;
    WkInApp#   Packed(7) const;
  End-Pr;

