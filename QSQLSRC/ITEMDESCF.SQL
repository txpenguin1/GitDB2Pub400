 -- *--------------------------------------------------------------------------*
 -- * Name:  ItemDescF                                                         *
 -- * Description: Function to Get Item Description                            *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(ITEMDESCF)     *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/11/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Function Get_Item_Description
                   (p_ItemOID INT)
 Returns VarChar(100)

 Language SQL
 Not Deterministic
 Not Fenced
 No External Action
 Set Option DatFmt    = *Iso ,
            UsrPrf    = *Owner ,
            Commit    = *None  ,
            DynUsrPrf = *Owner ,
            DbgView   = *Source
 Begin

   Declare returnStatus  VarChar(100) Not Null Default '';
   Declare sqlStatement  VarChar(500) Not Null Default '';

   Declare sqlCursor Cursor for sqlPrepare;

   Declare Exit Handler For SqlException
     Begin
       Set returnStatus = '*Not Found*';
       Return returnStatus;
     End;

   Set sqlStatement =
                'SELECT a.DESCRIPTION ' ||
                'FROM ITEM_TBL_ITEM_MASTER a ' ||
                'WHERE a.ITEMOID = ' || p_ItemOID || ' ';

   Prepare sqlPrepare from sqlStatement;
   Open sqlCursor;
   Fetch sqlCursor Into returnStatus;
   Close sqlCursor;

   Return returnStatus;

 End;



