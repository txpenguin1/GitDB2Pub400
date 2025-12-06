 -- *--------------------------------------------------------------------------*
 -- * Name:  CustListF                                                         *
 -- * Description: Function to view List of Customers                          *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(CUSTLISTF)     *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/13/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Function Get_Customer_List
  ()

 Returns Table (
   CutomerOID  Int,
   CustomerNumber  Int,
   Name  Char(100),
   Address1  Char(100),
   Address2  Char(100),
   City  Char(50),
   State  Char(2)
 )

 Language SQL
 Reads SQL Data
 Deterministic

 Return

   Select CustomerOID,
          CustomerNumber,
          Name,
          Address1,
          Address2,
          City,
          State
   From CUSTOMER_TBL_CUSTOMER_MASTER
   Order By Name;


