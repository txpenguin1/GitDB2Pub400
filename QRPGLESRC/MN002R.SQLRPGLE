**FREE
//---------------------------------------------------------------------
// Program Name:  MN002R
// Program Description:  Menu Items Mainenance and Add
// Program Narrative:  If an OID is passed in, then allow the user to
//                      maintain the information.  If there is no OID
//                      allow the user to enter a new menu item.
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
Dcl-F MN002D  WorkStn IndDs(displayindicators)
              InfDs(infds);
//---------------------------------------------------------------------
//  Procedure and Prototype for Entry Interface
//---------------------------------------------------------------------
Dcl-Pr MN002R;
  *n  Like(receiveParm1) Options(*NoPass);
End-Pr;

Dcl-Pi MN002R;
  inMenuOid  Like(receiveParm1) Options(*NoPass);
End-Pi;

//---------------------------------------------------------------------
//  Prototypes for External Program Calls from Within This Program
//---------------------------------------------------------------------
// **None**

//---------------------------------------------------------------------
//  Program Input and Output Parameters
//---------------------------------------------------------------------
Dcl-S receiveParm1  Packed(9:0);

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
Dcl-C Cmd01                  Const(x'31'); // Cmd-1
Dcl-C Cmd02                  Const(x'32'); // Cmd-2
Dcl-C Cmd03                  Const(x'33'); // Cmd-3
Dcl-C Cmd04                  Const(x'34'); // Cmd-4
Dcl-C Cmd05                  Const(x'35'); // Cmd-5
Dcl-C Cmd06                  Const(x'36'); // Cmd-6
Dcl-C Cmd07                  Const(x'37'); // Cmd-7
Dcl-C F8AddUpdateKeyPressed  Const(x'38'); // Cmd-8
Dcl-C Cmd09                  Const(x'39'); // Cmd-9
Dcl-C Cmd10                  Const(x'3A'); // Cmd-10
Dcl-C Cmd11                  Const(x'3B'); // Cmd-11
Dcl-C F12CancelKeyPressed    Const(x'3C'); // Cmd-12
Dcl-C Cmd13                  Const(x'B1'); // Cmd-13
Dcl-C Cmd14                  Const(x'B2'); // Cmd-14
Dcl-C Cmd15                  Const(x'B3'); // Cmd-15
Dcl-C Cmd16                  Const(x'B4'); // Cmd-16
Dcl-C Cmd17                  Const(x'B5'); // Cmd-17
Dcl-C Cmd18                  Const(x'B6'); // Cmd-18
Dcl-C Cmd19                  Const(x'B7'); // Cmd-19
Dcl-C Cmd20                  Const(x'B8'); // Cmd-19
Dcl-C Cmd21                  Const(x'B9'); // Cmd-21
Dcl-C Cmd22                  Const(x'BA'); // Cmd-22
Dcl-C Cmd23                  Const(x'BB'); // Cmd-23
Dcl-C Cmd24                  Const(x'BC'); // Cmd-24
Dcl-C EnterKeyPressed        Const(x'F1'); // Enter
Dcl-C RollUp                 Const(x'F5'); // Roll Up
Dcl-C RollDown               Const(x'F4'); // Roll Down

//---------------------------------------------------------------------
//  Display File Data Structures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,DspfDs

//---------------------------------------------------------------------
//  Various DS, Variables, and Constants Specific to this Program
//---------------------------------------------------------------------
Dcl-Ds Menu_Data ExtName('MENUITEMS') Alias Qualified End-Ds;

Dcl-S AddItem     Ind Inz(*Off);
Dcl-S ChangeItem  Ind Inz(*Off);

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

If %Parms < 1;
  AddItem = *On;
Else;
  ChangeItem = *On;
EndIf;

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
  //   SFLOA (Subfile Output Field) = Yellow
  //   SFLIOA (Subfile Input/Output Field) = White/Underline
  //   FKEYSA (Function Keys) = Ble
  TitleA = White;
  BdyA = WhiteUnderline;
  FErrMsgA = NonDisplay;
  FKeysA = Blue;

  Select;
    When AddItem;
      // Top/Bottom of screen soft-load logic
      Title1Work = 'Add New Menu Item';
      BdyTitle2 = 'Add new menu item and press F8';
      // Load Function Keys to be placed on the screen
      FunctionKeysText(1) = 'F8=Add New Menu Item';
    When ChangeItem;
      // Top/Bottom of screen soft-load logic
      Title1Work = 'Menu Item Maintenance';
      BdyTitle1 = 'Update the menu item information and press F8';
      // Load Function Keys to be placed on the screen
      FunctionKeysText(1) = 'F8=Update Menu Item Information';
  EndSl;

  FunctionKeysText(2) = 'F12=Cancel';
  FunctionKeysCount = 2;


  // Set Screen fileds based upon above
  ##PROG = ProgramName;
  Title1 = CenterTitle(Title1Work: 80);
  OPTLINE  = optLine1;
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
  LoadScreen();
  DoU FunctionKeyPressed = F12CancelKeyPressed;
    Write Header1;
    Write Footer1;
    ExFmt Body1;
    FErrMsgA = NonDisplay;
    ErrorsOnScreen = *Off;
    Select;
      When FunctionKeyPressed = F8AddUpdateKeyPressed;
        Select;
          When AddItem;
            CheckInputData();
            If Not ErrorsOnScreen;
              AddNewMenuItem();
              If Not ErrorsOnScreen;
                Leave;
              EndIf;
            EndIf;
          When ChangeItem;
            CheckInputData();
            If Not ErrorsOnScreen;
              UpdateMenuItemInformation();
              If Not ErrorsOnScreen;
                Leave;
              EndIf;
            EndIf;
          Other;
            //No action to take
        EndSl;
      When FunctionKeyPressed = F12CancelKeyPressed;
        Leave;
      Other;
        //Do nothing - simply re-show the screen
    EndSl;
  EndDo;

  Write Dummy1;

End-Proc DoTheWork;

//***********************************
Dcl-Proc LoadScreen;
//***********************************

  Dcl-S LoadScreenErrorHappened  Ind;

  //Get data and load to screen fields
  //Setup any special attributes
  Select;
    When AddItem;
      BdySeq   = *Zeros;
      BdyName  = *Blanks;
      BdyText  = *Blanks;
      BdyPgm   = *Blanks;
      BdyTitle = x'3E' + %Trim(BdyTitle2) + x'20';
      BdyTitle = CenterTitle(BdyTitle: 80);
    When ChangeItem;
      Exec Sql
        Declare Sql1Cursor Cursor for
          Select Sequence, MenuName, OptionText, OptionProgram
          From MenuItems_Tbl_Menu_Items_Master
          Where MenuOid = :inMenuOid;
      Exec Sql
        Open Sql1Cursor;
      GetSQLDiagnostics();
      If SQLDiagnosticsReturnedSQLCode = *Zeros;
        Exec SQL Fetch Sql1Cursor into :Menu_Data.Sequence,
                                       :Menu_Data.MenuName,
                                       :Menu_Data.OptionText,
                                       :Menu_Data.OptionProgram;
        GetSQLDiagnostics();
        If SQLDiagnosticsReturnedSQLCode = *Zeros;
          BdySeq   = Menu_Data.Sequence;
          BdyName  = Menu_Data.MenuName;
          BdyText  = Menu_Data.OptionText;
          BdyPgm   = Menu_Data.OptionProgram;
          BdyTitle = x'3E' + %Trim(BdyTitle1) + x'20';
          BdyTitle = CenterTitle(BdyTitle: 80);
        EndIf;
      EndIf;
  EndSl;

  Exec Sql
    Close Sql1Cursor;

  On-Exit LoadScreenErrorHappened;
    If LoadScreenErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc LoadScreen;

//***********************************
Dcl-Proc UpdateMenuItemInformation;
//***********************************

  Dcl-S UpdateMenuItemErrorHappened  Ind;

  Exec SQL
    Update MenuItems_Tbl_Menu_Items_Master
      Set Sequence = Trim(:BdySeq),
          MenuName = Trim(:BdyName),
          OptionText = Trim(:BdyText),
          OptionProgram = Trim(:BdyPgm)
      Where MenuOid = :inMenuOid;
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    Commit;
  Else;
    FErrMsg = *Blanks;
    FErrMsg = %Trim(GetErrorMessage('MN00005'));
    FErrMsgA = Red;
    ErrorsOnScreen = *On;
  EndIf;

  On-Exit UpdateMenuItemErrorHappened;
    If UpdateMenuItemErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc UpdateMenuItemInformation;

//***********************************
Dcl-Proc CheckInputData;
//***********************************

  Select;
    When BdySeq = *Zeros;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('M00001'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    When BdyName = *Blanks;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('MN00002'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    When BdyText = *Blanks;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('MN00003'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
    When BdyPgm = *Blanks;
      FErrMsg = *Blanks;
      FErrMsg = %Trim(GetErrorMessage('MN00004'));
      FErrMsgA = Red;
      ErrorsOnScreen = *On;
  EndSl;

End-Proc CheckInputData;

//***********************************
Dcl-Proc AddNewMenuItem;
//***********************************

  Dcl-S AddNewMenuItemErrorHappened  Ind;

  Exec SQL
    Insert Into MenuItems_Tbl_Menu_Items_Master
      (MenuName, Sequence, OptionText, OptionProgram)
      Values(:BdyName, :BdySeq, :BdyText, :BdyPgm);
  GetSQLDiagnostics();
  If SQLDiagnosticsReturnedSQLCode = *Zeros;
    Commit;
  Else;
    FErrMsg = *Blanks;
    FErrMsg = %Trim(GetErrorMessage('MN00006'));
    FErrMsgA = Red;
    ErrorsOnScreen = *On;
  EndIf;

  On-Exit AddNewMenuItemErrorHappened;
    If AddNewMenuItemErrorHappened;
      // Handle error
    Else;
      // All is ok
    EndIf;

End-Proc AddNewMenuItem;

