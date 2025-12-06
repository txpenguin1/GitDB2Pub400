 -- *--------------------------------------------------------------------------*
 -- * Name:  CUSTOMER                                                          *
 -- * Description: Customer Master                                             *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(CUSTOMER)      *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/06/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Table
  CUSTOMER_TBL_Customer_Master
   (
    CustomerOID         for Column CUOID,
    CustomerNumber      for Column CUNUM,
    Name                for Column CUNAME,
    Address1            for Column CUADD1,
    Address2            for Column CUADD2,
    City                for Column CUCITY,
    State               for Column CUST,
    ZipCode             for Column CUZIP,
    Contact             for COLUMN CUCONT
   )
   As
   (Select
      OID,
      IntNumber,
      Name,
      Address,
      Address,
      City,
      State,
      ZipCode,
      Name
    From MSTRREF_TBL_Master_Reference
   )
   Definition Only RcdFmt CUSTOMERF;

  Rename Table
    CUSTOMER_TBL_Customer_Master
  To System Name
    CUSTOMER;

  Alter Table CUSTOMER_TBL_Customer_Master
    Add Constraint CUSTOMER_PK
    Primary Key(CustomerOID);

  Alter Table CUSTOMER_TBL_Customer_Master
    Alter Column CustomerOID Set Generated Always as Identity;

  Label on Table
    CUSTOMER_TBL_Customer_Master
  Is
    'TXP Customer Master';

   -- * Format    <----COLUMN 1------><----COLUMN 2------><----COLUMN 3------>
  Label on Column
  CUSTOMER_TBL_Customer_Master
   (
   CUOID      is 'Customer            OID                                     ',
   CUNUM      is 'Customer            Number                                  ',
   CUNAME     is 'Customer            Name                                    ',
   CUADD1     is 'Address             Line 1                                  ',
   CUADD2     is 'Address             Line 2                                  ',
   CUCITY     is 'City                                                        ',
   CUST       is 'State                                                       ',
   CUZIP      is 'Zip                 Code                                    ',
   CUCONT     is 'Contact                                                     '
   );

 -- * Maximum size *    <---------------------- TEXT -------------------->
 Label on Column
  CUSTOMER_TBL_Customer_Master
   (
    CUOID      Text is 'Customer OID                                      ',
    CUNUM      Text is 'Customer Number                                   ',
    CUNAME     Text is 'Customer Name                                     ',
    CUADD1     Text is 'Address Line 1                                    ',
    CUADD2     Text is 'Address Line 2                                    ',
    CUCITY     Text is 'City                                              ',
    CUST       Text is 'State                                             ',
    CUZIP      Text is 'Zip Code                                          ',
    CUCONT     Text is 'Contact                                           '
   );


