 -- *--------------------------------------------------------------------------*
 -- * Name:  ITEMPRICE                                                         *
 -- * Description: Item Price Master                                           *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(ITEMPRICE)     *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/06/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Table
  ITEMPRICE_TBL_Item_Price_Master
   (
    ItemPriceOID        for Column IPOID,
    ItemOID             for Column IPITOID,
    Price               for Column IPPRICE,
    EffectiveDate       for Column IPEFFDT,
    ExpirationDate      for Column IPEXPDT
   )
   As
   (Select
      OID,
      FKOID,
      Dec10D2,
      Date,
      Date
    From MSTRREF_TBL_Master_Reference
   )
   Definition Only RcdFmt ITEMPRICEF;

  Rename Table
    ITEMPRICE_TBL_Item_Price_Master
  To System Name
    ITEMPRICE;

  Alter Table ITEMPRICE_TBL_Item_Price_Master
    Add Constraint ITEMPRICE_PK
    Primary Key(ItemPriceOID);

  Alter Table ITEMPRICE_TBL_Item_Price_Master
    Alter Column ItemPriceOID Set Generated Always as Identity;

  Alter Table ITEMPRICE_TBL_Item_Price_Master
    Add Constraint ITEMPRICE_ITEM_FK
    Foreign Key(ItemOID) References Item(ItemOID);

  Label on Table
    ITEMPRICE_TBL_Item_Price_Master
  Is
    'TXP Item Price Master';

   -- * Format *  <----COLUMN 1------><----COLUMN 2------><----COLUMN 3------>
  Label on Column
  ITEMPRICE_TBL_Item_Price_Master
   (
   IPOID      is 'Item                Price OID                               ',
   IPITOID    is 'Item                OID (FK)                                ',
   IPPRICE    is 'Price                                                       ',
   IPEFFDT    is 'Effective           Date                                    ',
   IPEXPDT    is 'Expiration          Date                                    '
   );

 -- * Maximum size *    <---------------------- TEXT -------------------->
 Label on Column
  ITEMPRICE_TBL_Item_Price_Master
   (
    IPOID      Text is 'Item Price OID                                    ',
    IPITOID    Text is 'Item OID (FK)                                     ',
    IPPRICE    Text is 'Price                                             ',
    IPEFFDT    Text is 'Effective Date                                    ',
    IPEXPDT    Text is 'Expiration Date                                   '
   );


