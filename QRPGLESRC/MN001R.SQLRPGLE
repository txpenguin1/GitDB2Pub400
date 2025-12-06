**FREE
//---------------------------------------------------------------------
// Program Name:  MN001R
// Program Description:  Menu Master
// Program Narrative:  Display the list of menu items.  User can choose to
//                       add a new item to the list, maintain an item on
//                       the list, or change the sequence of the items
//                       to appear on the menu.
//
// Change Log:
// Marker  Name         Date      Narrative
// ------  -----------  --------  -------------------------------------
//         S.Meisinger  10/05/25  New Program
//---------------------------------------------------------------------
//---------------------------------------------------------------------
//  Header
//---------------------------------------------------------------------
/Copy QRpgLeCpy,StdHdr
//---------------------------------------------------------------------
//  Files/Tables/Indexes
//---------------------------------------------------------------------
// Display file
Dcl-F MN001D  WorkStn IndDs(displayindicators)
              InfDs(infds)
              Sfile(Sfl1:Sfl1Rrn);
//---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
//---------------------------------------------------------------------
Dcl-Pr MN001R;
  *n  Like(receiveParm1);
End-Pr;

Dcl-Pi MN001R;
  inUserProfile  Like(receiveParm1);
End-Pi;

//---------------------------------------------------------------------
//  Prototypes for External Program Calls from Within This Program
//---------------------------------------------------------------------
Dcl-Pr CallToAddOrChangeMenuItem  ExtPgm('MN002R');
  MenuItemOidToActUpon  Packed(9:0) Const Options(*NoPass);
End-Pr;

//---------------------------------------------------------------------
//  Program Input and Output Parameters
//---------------------------------------------------------------------
Dcl-S receiveParm1  Char(10);

//---------------------------------------------------------------------
//  Copy Books/Prototype Imports
//---------------------------------------------------------------------
/Copy QCpyModSrc,ProjSvcPr

//---------------------------------------------------------------------
//  Generic Prototypes and Data Structures (QCMDEXC, PSDS, SQL Diagnostics)
//---------------------------------------------------------------------
/Copy QRpgLeCpy,GenPrDs

//---------------------------------------------------------------------
//  Write Messages to the Job Log
//---------------------------------------------------------------------
/Copy QRpgLeCpy,WrtJobLog

//---------------------------------------------------------------------
//  Display File Function Key Values
//---------------------------------------------------------------------
Dcl-C Cmd01                        Const(x'31'); // Cmd-1
Dcl-C Cmd02                        Const(x'32'); // Cmd-2
Dcl-C F3ExitKeyPressed             Const(x'33'); // Cmd-3
Dcl-C Cmd04                        Const(x'34'); // Cmd-4
Dcl-C Cmd05                        Const(x'35'); // Cmd-5
Dcl-C F6AddNewMenuItemKeyPressed   Const(x'36'); // Cmd-6
Dcl-C Cmd07                        Const(x'37'); // Cmd-7
Dcl-C Cmd08                        Const(x'38'); // Cmd-8
Dcl-C F9UpdateSequenceKeyPressed   Const(x'39'); // Cmd-9
Dcl-C Cmd10                        Const(x'3A'); // Cmd-10
Dcl-C Cmd11                        Const(x'3B'); // Cmd-11
Dcl-C Cmd12                        Const(x'3C'); // Cmd-12
Dcl-C Cmd13                        Const(x'B1'); // Cmd-13
Dcl-C Cmd14                        Const(x'B2'); // Cmd-14
Dcl-C Cmd15                        Const(x'B3'); // Cmd-15
Dcl-C Cmd16                        Const(x'B4'); // Cmd-16
Dcl-C Cmd17                        Const(x'B5'); // Cmd-17
Dcl-C Cmd18                        Const(x'B6'); // Cmd-18
Dcl-C Cmd19                        Const(x'B7'); // Cmd-19
Dcl-C Cmd20                        Const(x'B8'); // Cmd-19
Dcl-C Cmd21                        Const(x'B9'); // Cmd-21
Dcl-C Cmd22                        Const(x'BA'); // Cmd-22
Dcl-C Cmd23                        Const(x'BB'); // Cmd-23
Dcl-C Cmd24                        Const(x'BC'); // Cmd-24
Dcl-C EnterKeyPressed              Const(x'F1'); // Enter
Dcl-C RollUp                       Const(x'F5'); // Roll Up
Dcl-C RollDown                     Const(x'F4'); // Roll Down

//---------------------------------------------------------------------
//  Display File Data Structures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,DspfDs

//---------------------------------------------------------------------
//  Various DS, Variables, and Constants Specific to this Program
//---------------------------------------------------------------------
Dcl-Ds MenuItem_Data  Qualified;
  MenuOID         Packed(9:0);
  MenuName        Char(100);
  Sequence        Packed(3:0);
  OptionText      Char(100);
End-ds;

//---------------------------------------------------------------------
//  Display File Color and Attribute Constants
//---------------------------------------------------------------------
/Copy QRpgLeCpy,DspfConst

//---------------------------------------------------------------------
//  Generic Variables and Constants
//---------------------------------------------------------------------
/Copy QRpgLeCpy,GenVarCon

//--------------------------- Mainline Processing --------------------

// Setup current date/time for use

Date# = %Dec(%Subst(%Char(%Date():*ISO0):1:8):8:0);
Time6# = %Dec(%Subst(%Char(%Time():*ISO0):1:6):6:0);

Monitor;
  SetupScreenGenerics();
  DoTheWork();
  *InLr = *On;
  Return;
On-Error *Program;
  Dump(A);
  *InLr = *On;
  Return;
EndMon;

//---------------------------------------------------------------------
//  DSPF Procedures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,DspfProc

//---------------------------------------------------------------------
//  Generic Procedures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,GenProc

//***********************************
Dcl-Proc SetupScreenGenerics;
//***********************************

  Dcl-S SetupScreenErrorHappened  Ind;

  // NOTE:  Default Coloring Attributes will be:
  //   TITLEA (Titles) = White
  //   OPTIONA (Options for Subfile Rows) = White
  //   HEADERA (Column Headers) = Blue/Underline
  //   SEARCHA (Text on Search Line) = Blue
  //   SFLOA (Subfile Output Field) = Yellow
  //   SFLIOA (Subfile Input/Output Field) = White/Underline
  //   FKEYSA (Function Keys) = Blue
  TitleA = White;
  OptionA = White;
  HeaderA = RedUnderline;
  SflIoA = BlueUnderline;
  SflOA = ProtectedBlue;
  FErrMsgA = NonDisplay;
  FKeysA = Blue;

  // Top/Bottom of screen soft-load logic
  Title1Work = 'Master Menu Items Listing';
  optLine1  = 'Select "C" and <Enter> to change menu item or +
               change sequence number(s) and press F9';

  // Load Function Keys to be placed on the screen
  FunctionKeysText(1) = 'F3=Exit';
  FunctionKeysText(2) = 'F6=Add New';
  FunctionKeysText(3) = 'F9=Update Sequence';
  FunctionKeysCount = 3;

  // Set Screen fileds based upon above
  ##PROG = ProgramName;
  Title1 = CenterTitle(Title1Work: 80);
  FKEYLINE = SpaceFunctionKeys(FunctionKeysText:FunctionKeysCount);

  On-Exit SetupScreenErrorHappened;
    If SetupScreenErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc SetupScreenGenerics;

//***********************************
Dcl-Proc DoTheWork;
//***********************************

  //Basic Loop Logic
  ClearSubfile();
  LoadSubfile();
  DoU FunctionKeyPressed = F3ExitKeyPressed;
    Write Header1;
    Write Footer1;
    SflRcd = 1;
    ExFmt SflCtl1;
    FErrMsgA = NonDisplay;
    ErrorsOnScreen = *Off;
    Select;
      When FunctionKeyPressed = F3ExitKeyPressed;
        Leave;
      When FunctionKeyPressed = F6AddNewMenuItemKeyPressed;
        CallToAddOrChangeMenuItem();
        ClearSubfile();
        LoadSubfile();
      When FunctionKeyPressed = F9UpdateSequenceKeyPressed;
        ResequenceMenuItems();
        ClearSubfile();
        LoadSubfile();
      When FunctionKeyPressed = EnterKeyPressed;
        CheckForMenuItemToChange();
        ClearSubfile();
        LoadSubfile();
      Other;
        //Do nothing - simply re-show the screen
    EndSl;
  EndDo;

End-Proc DoTheWork;

//***********************************
Dcl-Proc LoadSubfile;
//***********************************

  Dcl-S LoadSubfileErrorHappened  Ind;

  //Get data and load to screen fields
  //Setup any special attributes
  OPTLINE  = *Blanks;
  Sfl1Rrn = *Zeros;
  Sfl1RecordCount = *Zeros;

  Exec Sql
    Declare Sql1Cursor Cursor for
      Select MenuOid, MenuName,
       Sequence, OptionText
       From MenuItems_Tbl_Menu_Items_Master
       Order by Sequence;
  Exec Sql
    Open Sql1Cursor;
  GetSQLDiagnostics();
  DoU SQLDiagnosticsReturnedSQLCode <> *Zeros;
    Exec SQL Fetch Sql1Cursor into :MenuItem_Data.MenuOID,
                                   :MenuItem_Data.MenuName,
                                   :MenuItem_Data.Sequence,
                                   :MenuItem_Data.OptionText;
    GetSQLDiagnostics();
    If SQLDiagnosticsReturnedSQLCode = *Zeros;
      SflOID  =  MenuItem_Data.MenuOID;
      SflSel  =  *Blanks;
      SflName =  MenuItem_Data.MenuName;
      SflSeq  =  MenuItem_Data.Sequence;
      SflText =  MenuItem_Data.OptionText;
      Sfl1Rrn += 1;
      Sfl1RecordCount += 1;
      Write Sfl1;
      *In90 = *On;
    EndIf;
  EndDo;
  Exec Sql
    Close Sql1Cursor;

  On-Exit LoadSubfileErrorHappened;
    If LoadSubfileErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

  OPTLINE  = optLine1;

End-Proc LoadSubfile;

//***********************************
Dcl-Proc CheckForMenuItemToChange;
//***********************************

  Dcl-S CheckForChangeErrorHappened  Ind;

  Xjr = 1;
  DoU Xjr > Sfl1RecordCount;
    Chain Xjr Sfl1;
    Select;
      When SflSel = 'C';
        CallToAddOrChangeMenuItem(SflOid);
        Leave;
      When SflSel <> *Blanks;
        FErrMsg = *Blanks;
        FErrMsg = %Trim(GetErrorMessage('MN00007'));
        FErrMsgA = Red;
        ErrorsOnScreen = *On;
        Leave;
      Other;
        //No action since it's blank
    EndSl;
    Xjr += 1;
  EndDo;

  On-Exit CheckForChangeErrorHappened;
    If CheckForChangeErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc CheckForMenuItemToChange;

//***********************************
Dcl-Proc ResequenceMenuItems;
//***********************************

  Dcl-S ResequenceErrorHappened  Ind;

  Dcl-Ds SortDS Qualified Dim(100);
    SortSequence  Packed(3:0);
    SortOID       Packed(9:0);
  End-Ds;

  Dcl-S UpdateOID  Packed(9:0);

  Xjr = 1;
  DoU Xjr > 100;
    SortDs(Xjr).SortSequence = 999;
    Xjr += 1;
  EndDo;

  Xjr = 1;
  DoU Xjr > Sfl1RecordCount;
    Chain Xjr Sfl1;
    SortDS(Xjr).SortSequence = SflSeq;
    SortDS(Xjr).SortOID = SflOID;
    Xjr += 1;
  EndDo;

  SortA SortDs(*).SortSequence;

  Xjr = 1;
  DoU Xjr > Sfl1RecordCount;
    UpdateOID = SortDS(Xjr).SortOID;
    Exec SQL
    Update MenuItems_Tbl_Menu_Items_Master
      Set Sequence = :Xjr
      Where MenuOid = :UpdateOID;
    GetSQLDiagnostics();
    If SQLDiagnosticsReturnedSQLCode = *Zeros;
      Commit;
    Else;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('MN00008'));
      FErrMsgA = Red;
    EndIf;
    Xjr += 1;
  EndDo;

  On-Exit ResequenceErrorHappened;
    If ResequenceErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc ResequenceMenuItems;
