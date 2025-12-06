 -- *--------------------------------------------------------------------------*
 -- * Name:  ITEM                                                              *
 -- * Description: Item Master                                                 *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(ITEM)          *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/06/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Table
  ITEM_TBL_Item_Master
   (
    ItemOID             for Column ITOID,
    ItemNumber          for Column ITNUM,
    Description         for Column ITDESC,
    QuantityOnHand      for Column ITQOH,
    MaximumQuantity     for Column ITMAXQTY
   )
   As
   (Select
      OID,
      IntNumber,
      Char100,
      Dec7D0,
      Dec7D0
    From MSTRREF_TBL_Master_Reference
   )
   Definition Only RcdFmt ITEMF;

  Rename Table
    ITEM_TBL_Item_Master
  To System Name
    ITEM;

  Alter Table ITEM_TBL_Item_Master
    Add Constraint ITEM_PK
    Primary Key(ItemOID);

  Alter Table ITEM_TBL_Item_Master
    Alter Column ItemOID Set Generated Always as Identity;

  Label on Table
    ITEM_TBL_Item_Master
  Is
    'TXP Item Master';

   -- * Format *  <----COLUMN 1------><----COLUMN 2------><----COLUMN 3------>
  Label on Column
  ITEM_TBL_Item_Master
   (
   ITOID      is 'Item                OID                                     ',
   ITNUM      is 'Item                Number                                  ',
   ITDESC     is 'Description                                                 ',
   ITQOH      is 'Quantity            On-Hand                                 ',
   ITMAXQTY   is 'Maximum             Quantity                                '
   );

 -- * Maximum size *    <---------------------- TEXT -------------------->
 Label on Column
  ITEM_TBL_Item_Master
   (
    ITOID      Text is 'Item OID                                          ',
    ITNUM      Text is 'Item Number                                       ',
    ITDESC     Text is 'Item Description                                  ',
    ITQOH      Text is 'Quantity On-Hand                                  ',
    ITMAXQTY   Text is 'Maximum Quantity                                  '
   );


