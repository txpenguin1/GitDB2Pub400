**FREE
//----------------------------------------------------------------------------------------*
// CRTSQLRPGI OBJ(TXPENGUIN2/PROJMODS) SRCFILE(TXPENGUIN2/QCPYMODSRC)                     *
//                                     SRCMBR(PROJSVCMOD) OBJTYPE(*MODULE)                *
// CRTSRVPGM SRVPGM(TXPENGUIN2/PROJSVCPGM) MODULE(TXPENGUIN2/PROJMODS) EXPORT(*ALL)       *
//  (create binding directory only one time)                                              *
// CRTBNDDIR BNDDIR(TXPENGUIN2/PROJSVCBND) TEXT('Binding Directory for Project')          *
// ADDBNDDIRE BNDDIR(TXPENGUIN2/PROJSVCBND) OBJ((TXPENGUIN2/PROJSVCPGM))                  *
//  (to ensure the add was successful)                                                    *
// DSPBNDDIR BNDDIR(TXPENGUIN2/PROJSVCBND)                                                *
//----------------------------------------------------------------------------------------*
Ctl-Opt NOMAIN;
// I'm using this /copy here because it will include the data
// structures.  Otherwise you'd have to code the data structures in
// each program that uses the service program
/Copy QCpyModSrc,ProjSvcPr

//---------------------------------------------------------------------
//  Generic Prototypes and Data Structures (QCMDEXC, PSDS, SQL Diagnostics)
//---------------------------------------------------------------------
/Copy QRpgLeCpy,GenPrDs

//---------------------------------------------------------------------
//  Generic Procedures
//---------------------------------------------------------------------
/Copy QRpgLeCpy,GenProc

//-------------------------------------------------------------------*
// CenterTitle - Centers the text for placement on the screen
//-------------------------------------------------------------------*
 Dcl-Proc CenterTitle  Export;

   Dcl-Pi *n Char(100);
     inText          Char(100) Const;
     inScreenLength  Int(5) Const;
   End-Pi;

   Dcl-S returnString  Char(100)   Inz;
   Dcl-S length       Int(5)     Inz;
   Dcl-S offset   Int(5)     Inz;

   Clear returnString;

   length=%Len(%Trim(inText));
   offset=(inScreenLength-length)/2+1;
   %Subst(returnString:offSet:length)=%Subst(inText:1:length);

   Return returnString;
 End-Proc ;

//-------------------------------------------------------------------*
// SpaceFunctionKeys - Evenly space the function keys across the screen
//-------------------------------------------------------------------*
 Dcl-Proc SpaceFunctionKeys Export;
   Dcl-Pi *n Char(125);
     FunctionKeyText   VarChar(50) Dim(10) Const;
     FunctionKeyCount  Packed(3:0) Const;
   End-Pi;

   Dcl-Ds KeyTexts  Dim(10) Qualified;
      ktValue   VarChar(50);
      ktLength  Packed(3:0);
   End-Ds;

   Dcl-S ReturnSpacedFunctionKeys     Char(125)   Inz(*Blanks);
   Dcl-S Xjr                          Packed(3:0) Inz(*Zeros);
   Dcl-S FunctionKeyTextsTotalLength  Packed(5:0) Inz(*Zeros);
   Dcl-S AvailableBlankSpaces         Packed(3:0) Inz(*Zeros);
   Dcl-S SpacesBetweenKeys            Packed(3:0) Inz(*Zeros);
   Dcl-S CurrentBuildLocation         Packed(3:0) Inz(*Zeros);
   Dcl-S fKeyLine                     Char(125)   Inz(*Blanks);

   ReturnSpacedFunctionKeys = *Blanks;
   Xjr = 1;
   FunctionKeyTextsTotalLength = *Zeros;
   AvailableBlankSpaces = *Zeros;
   SpacesBetweenKeys = *Zeros;
   CurrentBuildLocation = *Zeros;

   DoU Xjr > FunctionKeyCount;
     If FunctionKeyText(Xjr) <> *Blanks;
       KeyTexts(Xjr).ktValue = %Trim(FunctionKeyText(Xjr));
       KeyTexts(Xjr).ktLength = %Len(%Trim(KeyTexts(Xjr).ktValue));
       FunctionKeyTextsTotalLength += KeyTexts(Xjr).ktLength;
     EndIf;
     Xjr += 1;
   EndDo;

   If FunctionKeyTextsTotalLength > %Len(FKEYLINE);
     ReturnSpacedFunctionKeys = '** Too many keys/too wide to fit **';
     Return ReturnSpacedFunctionKeys;
   EndIf;

   AvailableBlankSpaces = %Len(FKEYLINE) - FunctionKeyTextsTotalLength;
   Eval(H) SpacesBetweenKeys = AvailableBLankSpaces / (FunctionKeyCount + 1);

   CurrentBuildLocation = *Zeros;

   Xjr = 1;
   DoU Xjr > FunctionKeyCount;
     CurrentBuildLocation += SpacesBetweenKeys + 1;
     %Subst(ReturnSpacedFunctionKeys:
            CurrentBuildLocation:
            KeyTexts(Xjr).ktLength) = %Trim(KeyTexts(Xjr).ktValue);
     CurrentBuildLocation += KeyTexts(Xjr).ktLength;
     Xjr += 1;
   EndDo;

   Return ReturnSpacedFunctionKeys;

 End-Proc SpaceFunctionKeys;

//-------------------------------------------------------------------*
// GetErrorMessage - Retrieve error message text for message ID from MSGF
//-------------------------------------------------------------------*
 Dcl-Proc GetErrorMessage Export;
   Dcl-Pi *n Char(75);
     inMessageId  Char(7) Const;
   End-Pi;

   Dcl-S ReturnMessageText  Char(75) Inz(*Blanks);

   ReturnMessageText = *Blanks;
   Exec Sql
     Select message_text
     Into :ReturnMessageText
     From qsys2.message_file_data
     Where message_file = 'PROJMSGF'
     And message_file_library = 'TXPENGUIN2'
     And message_id = :inMessageId;
   GetSQLDiagnostics();
   If SQLDiagnosticsReturnedSQLCode <> *Zeros;
     ReturnMessageText = 'No such error message ID exists in MSGF';
   EndIf;

   Return ReturnMessageText;

 End-Proc GetErrorMessage;


