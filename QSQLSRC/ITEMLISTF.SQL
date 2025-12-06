 -- *--------------------------------------------------------------------------*
 -- * Name:  ItemListF                                                         *
 -- * Description: Function to view List of Items                              *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(ITEMLISTF)     *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/13/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Function Get_Item_List
  ()

 Returns Table (
   ItemOID  Int,
   ItemNumber  Int,
   Description  VarChar(100)
 )

 Language SQL
 Reads SQL Data
 Deterministic

 Return

   Select ItemOID,
          ItemNumber,
          Description
   From ITEM_TBL_ITEM_MASTER
   Order By ItemNumber;


