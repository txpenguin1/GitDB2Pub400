 -- *--------------------------------------------------------------------------*
 -- * Name:  MSTRREF                                                           *
 -- * Description: Master Column Reference Table                               *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(MSTRREF)       *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/06/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Table
  MSTRREF_TBL_Master_Reference
  (
   Address      Char(100)       CCSID 37        Not Null Default '',
   Char100      Char(100)       CCSID 37        Not Null Default '',
   City         Char(50)        CCSID 37        Not Null Default '',
   Date         Date,
   Dec3D0       Decimal(3, 0)                   Not Null Default 0,
   Dec7D0       Decimal(7, 0)                   Not Null Default 0,
   Dec10D2      Decimal(10, 2)                  Not Null Default 0,
   FkOID        Integer                         Not Null Default 0,
   IntNumber    Integer                         Not Null Default 0,
   Name         Char(100)       CCSID 37        Not Null Default '',
   OID          Integer                         Not Null Generated
                                                 Always as Identity
                                                 (Start with 1,
                                                  Increment by 1),
   State        Char(2)         CCSID 37        Not Null Default '',
   VCh25        VarChar(25)     CCSID 37        Not Null Default '',
   VCh100       VarChar(100)    CCSID 37        Not Null Default '',
   ZipCode      Char(9)         CCSID 37        Not Null Default ''
  )
  RcdFmt MSTRREFF;

  Rename Table
    MSTRREF_TBL_Master_Reference
  To System Name
    MSTRREF;

  Label on Table
    MSTRREF_TBL_Master_Reference
  Is
    'TXP Master Column Reference';

   -- * Format *  <----COLUMN 1------><----COLUMN 2------><----COLUMN 3------>
  Label on Column
   MSTRREF_TBL_Master_Reference
   (
   Address    is 'Address                                                     ',
   Char100    is 'Char100                                                     ',
   City       is 'City                                                        ',
   Date       is 'Date                                                        ',
   Dec3D0     is 'Decimal             3-0                                     ',
   Dec7D0     is 'Decimal             7-0                                     ',
   Dec10D2    is 'Decimal             10-2                                    ',
   FkOID      is 'Foreign             Key OID                                 ',
   IntNumber  is 'Generic             Integer                                 ',
   Name       is 'Name                                                        ',
   OID        is 'OID                                                         ',
   State      is 'State                                                       ',
   VCh25      is 'VarChar25                                                   ',
   VCh100     is 'VarChar100                                                  ',
   ZipCode    is 'Zip                 Code                                    '
   );

 -- * Maximum size *     <---------------------- TEXT -------------------->
 Label on Column
   MSTRREF_TBL_Master_Reference
   (
    Address     Text is 'Address                                           ',
    Char100     Text is 'Char100                                           ',
    City        Text is 'City                                              ',
    Date        Text is 'Date                                              ',
    Dec3D0      Text is 'Decimal 3-0                                       ',
    Dec7D0      Text is 'Decimal 7-0                                       ',
    Dec10D2     Text is 'Decimal 10-2                                      ',
    FkOID       Text is 'Foreign Key OID                                   ',
    IntNumber   Text is 'Generic Integer                                   ',
    Name        Text is 'Name                                              ',
    OID         Text is 'OID                                               ',
    State       Text is 'State                                             ',
    VCh25       Text is 'VarChar25                                         ',
    VCh100      Text is 'VarChar100                                        ',
    ZipCode     Text is 'Zip Code                                          '
   );


