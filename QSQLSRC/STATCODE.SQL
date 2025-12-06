 -- *--------------------------------------------------------------------------*
 -- * Name:  STATCODE                                                          *
 -- * Description: Status Codes Master                                         *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(STATCODE)      *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/06/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Table
  STATCODE_TBL_Status_Codes
   (
    StatCodeOID         for Column SCOID,
    Code                for Column SCCODE,
    Description         for COLUMN SCDESC
   )
   As
   (Select
      OID,
      VCh25,
      VCh100
    From MSTRREF_TBL_Master_Reference
   )
   Definition Only RcdFmt STATCODEF;

  Rename Table
    STATCODE_TBL_Status_Codes
  To System Name
    STATCODE;

  Alter Table STATCODE_TBL_Status_Codes
    Add Constraint STATCODE_PK
    Primary Key(StatCodeOID);

  Alter Table STATCODE_TBL_Status_Codes
    Alter Column StatCodeOID Set Generated Always as Identity;

  Label on Table
    STATCODE_TBL_Status_Codes
  Is
    'TXP Status Codes Master';

   -- * Format *  <----COLUMN 1------><----COLUMN 2------><----COLUMN 3------>
  Label on Column
  STATCODE_TBL_Status_Codes
   (
   SCOID      is 'Status              Code                OID                 ',
   SCCODE     is 'Status              Code                                    ',
   SCDESC     is 'Description                                                 '
   );

 -- * Maximum size *    <---------------------- TEXT -------------------->
 Label on Column
  STATCODE_TBL_Status_Codes
   (
    SCOID      Text is 'Status Code OID                                   ',
    SCCODE     Text is 'Status Code                                       ',
    SCDESC     Text is 'Description                                       '
   );


