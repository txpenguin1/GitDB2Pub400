 -- *--------------------------------------------------------------------------*
 -- * Name:  UpdItmQohP                                                        *
 -- * Description: Procedure to Update the Item Quantity On Hamd               *
 -- *               (p_Quantity will be negative when it is a quantity         *
 -- *                 decrease like an increase in quantity on the order       *
 -- *                 screen.                                                  *
 -- *                p_Quantity will be positive when it is a quantity         *
 -- *                 increase like a reduction in quantity on the order       *
 -- *                 screen.                                                  *
 -- *                So, based upon the above, the computation will be to      *
 -- *                 add the p_Quantity to the existing QOH to create the     *
 -- *                 new QOH amount.)                                         *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(UPDITMQOHP)    *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/13/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Procedure Update_Item_Quantity_On_Hand
        (In p_ItemOID  INT,
         In p_Quantity  INT)

 Language SQL
 Begin

   Update Item_Tbl_Item_Master
   Set QuantityOnHand = QuantityOnHand + p_Quantity
   Where ItemOID = p_ItemOID;

   Commit;

 End;


