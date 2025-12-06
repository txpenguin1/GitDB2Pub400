 -- *--------------------------------------------------------------------------*
 -- * Name:  ItmPrcF                                                           *
 -- * Description: Function to get an Item Price                               *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(ITMPRCF)       *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/12/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Function Get_Item_Price
                   (In_ItemOID INT,
                    In_Date  DATE)
 Returns Decimal(10, 2)

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

   Declare returnPrice   Decimal(10, 2)  Not Null Default 0;
   Declare sqlStatement  VarChar(500)    Not Null Default '';

   Declare sqlCursor Cursor for sqlPrepare;

   Declare Exit Handler For SqlException
     Begin
       Set returnPrice = 0;
       Return returnPrice;
     End;

   Set sqlStatement =
                'SELECT a.price ' ||
                'FROM ITEMPRICE_TBL_ITEM_PRICE_MASTER a ' ||
                'WHERE ITEMOID = ' || In_ItemOID || ' ' ||
                'AND ''' || In_Date || ''' Between ' ||
                'a.effectiveDate and a.expirationDate';

   Prepare sqlPrepare from sqlStatement;
   Open sqlCursor;
   Fetch sqlCursor Into returnPrice;
   Close sqlCursor;

   Return returnPrice;

 End;
