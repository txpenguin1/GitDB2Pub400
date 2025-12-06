 -- *--------------------------------------------------------------------------*
 -- * Name:  RplItmQohP                                                        *
 -- * Description: Procedure to Replenish Item Quantity On Hand                *
 -- *               (Do so where the QOH is less than 25% of the maximum)      *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(RPLITMQOHP)    *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/13/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Procedure Replenish_Item_Quantity_On_Hand
  ()

 Language SQL
 Begin

   UPDATE ITEM_TBL_ITEM_MASTER
   SET QUANTITYONHAND = MAXIMUMQUANTITY
   WHERE QUANTITYONHAND < (MAXIMUMQUANTITY * .25);

   Commit;

 End;


