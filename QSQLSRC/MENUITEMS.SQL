 -- *--------------------------------------------------------------------------*
 -- * Name:  MENUITEMS                                                         *
 -- * Description: Menu Items Master                                           *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(MENUITEMS)     *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/06/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Table
  MENUITEMS_TBL_Menu_Items_Master
   (
    MenuOID             for Column MEOID,
    MenuName            for Column MENAME,
    Sequence            for Column MESEQ,
    OptionText          for Column METEXT,
    OptionProgram       for Column MEPGM
   )
   As
   (Select
      OID,
      VCh100,
      Dec3D0,
      VCh100,
      VCh100
    From MSTRREF_TBL_Master_Reference
   )
   Definition Only RcdFmt MENUITEMSF;

  Rename Table
    MENUITEMS_TBL_Menu_Items_Master
  To System Name
    MENUITEMS;

  Alter Table MENUITEMS_TBL_Menu_Items_Master
    Add Constraint MENUITEMS_PK
    Primary Key(MenuOID);

  Alter Table MENUITEMS_TBL_Menu_Items_Master
    Alter Column MenuOID Set Generated Always as Identity;

  Label on Table
    MENUITEMS_TBL_Menu_Items_Master
  Is
    'TXP Menu Items Master';

   -- * Format *  <----COLUMN 1------><----COLUMN 2------><----COLUMN 3------>
  Label on Column
  MENUITEMS_TBL_Menu_Items_Master
   (
   MEOID      is 'Menu                OID                                     ',
   MENAME     is 'Menu                Name                                    ',
   MESEQ      is 'Sequence                                                    ',
   METEXT     is 'Option              Text                                    ',
   MEPGM      is 'Option              Program                                 '
   );

 -- * Maximum size *    <---------------------- TEXT -------------------->
 Label on Column
  MENUITEMS_TBL_Menu_Items_Master
   (
    MEOID      Text is 'Menu OID                                          ',
    MENAME     Text is 'Menu Name                                         ',
    MESEQ      Text is 'Sequence                                          ',
    METEXT     Text is 'Option Text                                       ',
    MEPGM      Text is 'Option Program                                    '
   );


