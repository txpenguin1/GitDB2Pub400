 -- *--------------------------------------------------------------------------*
 -- * Name:  CustOrdF                                                          *
 -- * Description: Function to see list Customer Orders                        *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(CUSTORDF)      *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/11/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Function Get_Customer_Orders
                   (In_CustomerOID INT)
 Returns Table (
   OrderHeaderOID  Int,
   OrderNumber  Int,
   CustomerOrderStatus VarChar(100)
 )

 Language SQL
 Reads SQL Data
 Deterministic

 Return

   Select OrderHeaderOID,
          OrderNumber,
          Get_Customer_Order_Status(OrderHeaderOID)
   From ORDERHDR_TBL_ORDER_HEADER
   Where customeroid = In_CustomerOID;


