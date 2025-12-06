 -- *--------------------------------------------------------------------------*
 -- * Name:  ORDERDTL                                                          *
 -- * Description: Order Detail                                                *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(ORDERDTL)      *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/07/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Table
  ORDERDTL_TBL_Order_Detail
   (
    OrderDetailOID      for Column ODOID,
    OrderHeaderOID      for Column ODOHOID,
    DetailSequence      for Column ODSEQ,
    ItemOID             for Column ODITOID,
    Quantity            for Column ODQTY,
    TotalPrice          for Column ODTOTPRC
   )
   As
   (Select
      OID,
      FKOID,
      IntNumber,
      FKOID,
      IntNumber,
      Dec10D2
    From MSTRREF_TBL_Master_Reference
   )
   Definition Only RcdFmt ORDERDTLF;

  Rename Table
    ORDERDTL_TBL_Order_Detail
  To System Name
    ORDERDTL;

  Alter Table ORDERDTL_TBL_Order_Detail
    Add Constraint ORDERDTL_PK
    Primary Key(OrderDetailOID);

  Alter Table ORDERDTL_TBL_Order_Detail
    Alter Column OrderDetailOID Set Generated Always as Identity;

  Alter Table ORDERDTL_TBL_Order_Detail
    Add Constraint ORDERDTL_ORDERHDR_FK
    Foreign Key(OrderHeaderOID) References OrderHdr(OrderHeaderOID);

  Alter Table ORDERDTL_TBL_Order_Detail
    Add Constraint ORDERDTL_ITEM_FK
    Foreign Key(ItemOID) References Item(ItemOID);

  Label on Table
    ORDERDTL_TBL_Order_Detail
  Is
    'TXP Order Detail';

   -- * Format *  <----COLUMN 1------><----COLUMN 2------><----COLUMN 3------>
  Label on Column
  ORDERDTL_TBL_Order_Detail
   (
   ODOID      is 'Order               Detail OID                              ',
   ODOHOID    is 'Order Header        OID (FK)                                ',
   ODSEQ      is 'Sequence                                                    ',
   ODITOID    is 'Item                OID (FK)                                ',
   ODQTY      is 'Quantity                                                    ',
   ODTOTPRC   is 'Total               Price                                   '
   );

 -- * Maximum size *    <---------------------- TEXT -------------------->
 Label on Column
  ORDERDTL_TBL_Order_Detail
   (
    ODOID      Text is 'Order Detail OID                                  ',
    ODOHOID    Text is 'Order Header OID (FK)                             ',
    ODSEQ      Text is 'Sequence                                          ',
    ODITOID    Text is 'Item OID (FK)                                     ',
    ODQTY      Text is 'Quantity                                          ',
    ODTOTPRC   Text is 'Total Price                                       '
   );


