 -- *--------------------------------------------------------------------------*
 -- * Name:  CustOrDtF                                                         *
 -- * Description: Function to see list Customer Order Details                 *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(CUSTORDTF)     *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/11/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Function Get_Customer_Order_Details
                   (In_OrderHeaderOID INT)
 Returns Table (
   DetailSequence  Int,
   ItemOID  Int,
   ItemDescription  VarChar(100),
   Quantity  Int,
   TotalPrice Decimal
 )

 Language SQL
 Reads SQL Data
 Deterministic

 Return

   Select DetailSequence,
          ItemOID,
          Get_Item_Description(ItemOID),
          Quantity,
          TotalPrice
   From OrderDtl_Tbl_Order_Detail
   Where OrderHeaderOID = In_OrderHeaderOID
   Order by DetailSequence;



