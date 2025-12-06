 -- *--------------------------------------------------------------------------*
 -- * Name:  ORDERHDR                                                          *
 -- * Description: Order Header                                                *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(ORDERHDR)      *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/07/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Table
  ORDERHDR_TBL_Order_Header
   (
    OrderHeaderOID      for Column OHOID,
    CustomerOID         for Column OHCUOID,
    OrderNumber         for Column OHORNUM,
    StatusCodeOID       for Column OHSCOID,
    OrderDate           for Column OHORDT,
    CompleteDate        for Column OHCMDT,
    TotalPrice          for Column OHTOTPRC
   )
   As
   (Select
      OID,
      FKOID,
      IntNumber,
      FKOID,
      Date,
      Date,
      Dec10D2
    From MSTRREF_TBL_Master_Reference
   )
   Definition Only RcdFmt ORDERHDRF;

  Rename Table
    ORDERHDR_TBL_Order_Header
  To System Name
    ORDERHDR;

  Alter Table ORDERHDR_TBL_Order_Header
    Add Constraint ORDERHDR_PK
    Primary Key(OrderHeaderOID);

  Alter Table ORDERHDR_TBL_Order_Header
    Alter Column OrderHeaderOID Set Generated Always as Identity;

  Alter Table ORDERHDR_TBL_Order_Header
    Add Constraint ORDERHDR_CUSTOMER_FK
    Foreign Key(CustomerOID) References Customer(CustomerOID);

  Alter Table ORDERHDR_TBL_Order_Header
    Add Constraint ORDERHDR_STATUSCODE_FK
    Foreign Key(StatusCodeOID) References StatCode(StatCodeOID)
        On Delete Restrict;

  Label on Table
    ORDERHDR_TBL_Order_Header
  Is
    'TXP Order Header';

   -- * Format *  <----COLUMN 1------><----COLUMN 2------><----COLUMN 3------>
  Label on Column
  ORDERHDR_TBL_Order_Header
   (
   OHOID      is 'Order               Header OID                              ',
   OHCUOID    is 'Customer            OID (FK)                                ',
   OHORNUM    is 'Order               Number                                  ',
   OHSCOID    is 'Status Code         OID (FK)                                ',
   OHORDT     is 'Order               Date                                    ',
   OHCMDT     is 'Complete            Date                                    ',
   OHTOTPRC   is 'Total               Price                                   '
   );

 -- * Maximum size *    <---------------------- TEXT -------------------->
 Label on Column
  ORDERHDR_TBL_Order_Header
   (
    OHOID      Text is 'Order Header OID                                  ',
    OHCUOID    Text is 'Customer OID (FK)                                 ',
    OHORNUM    Text is 'Order Number                                      ',
    OHSCOID    Text is 'Status Code OID (FK)                              ',
    OHORDT     Text is 'Order Date                                        ',
    OHCMDT     Text is 'Complete Date                                     ',
    OHTOTPRC   Text is 'Total Price                                       '
   );


