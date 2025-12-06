 -- *--------------------------------------------------------------------------*
 -- * Name:  UpdHdrPrcP                                                        *
 -- * Description: Procedure to Update the Header Price                        *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(UPDHDRPRCP)    *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/11/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Procedure Update_Order_Header_Price
        (In p_OrderHeaderOID  INT)

 Language SQL
 Begin

   Update OrderHdr_Tbl_Order_Header
   Set TotalPrice =
        (Select sum(TotalPrice)
         From OrderDtl_Tbl_Order_Detail
         Where OrderHeaderOID = p_OrderHeaderOID)
   Where OrderHeaderOID = p_OrderHeaderOID;

   Commit;

 End;


