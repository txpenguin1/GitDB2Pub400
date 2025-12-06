 -- *--------------------------------------------------------------------------*
 -- * Name:  UpdDtlPrcP                                                        *
 -- * Description: Procedure to Update Order Detail Price for an Item          *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(UPDDTLPRCP)    *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/11/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Procedure Update_Order_Detail_Item_Price
        (In p_OrderDetailOID  INT,
         In p_OrderDate  DATE,
         In p_ItemOID  INT)

 Language SQL
 Begin

   Update OrderDtl_Tbl_Order_Detail
   Set TotalPrice = Quantity *
        (SELECT price
         FROM ITEMPRICE_TBL_ITEM_PRICE_MASTER
         WHERE p_OrderDate  Between EFFECTIVEDATE AND EXPIRATIONDATE
         AND ITEMOID = p_ItemOID)
   Where OrderDetailOID = p_OrderDetailOID;

   Commit;

 End;






