 -- *--------------------------------------------------------------------------*
 -- * Name:  StatCodeF                                                         *
 -- * Description: Function to get List of Status Codes                        *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(STATCODEF)     *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/20/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Function Get_Status_Codes_List
  ()

 Returns Table (
   StatCodeOID  Int,
   Code         VarChar(25),
   Description  VarChar(100)
 )

 Language SQL
 Reads SQL Data
 Deterministic

 Return

   Select StatCodeOID,
          Code,
          Description
   From STATCODE_TBL_STATUS_CODES
   Order By Code;


