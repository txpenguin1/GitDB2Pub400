**FREE

// ***********************************
Dcl-Proc ClearSubfile;
// ***********************************

  // SFLDSP    = 90
  // SFLDSPCTL = 91

  *In90 = *Off;
  *In91 = *Off;
  Sfl1Rrn = 0;
  Write SflCtl1;
  *In91 = *On;

End-Proc ClearSubfile;


