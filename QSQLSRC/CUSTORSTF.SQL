 -- *--------------------------------------------------------------------------*
 -- * Name:  CustOrStF                                                         *
 -- * Description: Function to Get Customer Order Status                       *
 -- * Create with: RUNSQLSTM SRCFILE(TXPENGUIN2/QSQLSRC) SRCMBR(CUSTORSTF)     *
 -- * Change Log:                                                              *
 -- * Tag   Date       Name         Narrative                                  *
 -- *----- ---------- ------------ ------------------------------------------  *
 -- *      09/08/2025 S.Meisinger  Created                                     *
 -- *--------------------------------------------------------------------------*

 Create or Replace Function Get_Customer_Order_Status
                   (p_OrderHeaderOID INT)
 Returns VarChar(100)

 Language SQL
 Not Deterministic
 Not Fenced
 No External Action
 Set Option DatFmt    = *Iso ,
            UsrPrf    = *Owner ,
            Commit    = *None  ,
            DynUsrPrf = *Owner ,
            DbgView   = *Source
 Begin

   Declare returnStatus  VarChar(100) Not Null Default '';
   Declare sqlStatement  VarChar(500) Not Null Default '';

   Declare sqlCursor Cursor for sqlPrepare;

   Declare Exit Handler For SqlException
     Begin
       Set returnStatus = '*Not Found*';
       Return returnStatus;
     End;

   Set sqlStatement =
                'SELECT a.DESCRIPTION ' ||
                'FROM STATCODE_TBL_STATUS_CODES a ' ||
                'WHERE a.STATCODEOID =  ' ||
                '(SELECT z.STATUSCODEOID ' ||
                'FROM OrderHdr_Tbl_Order_Header z ' ||
                'WHERE z.ORDERHEADEROID = ' || p_OrderHeaderOID || ')';

   Prepare sqlPrepare from sqlStatement;
   Open sqlCursor;
   Fetch sqlCursor Into returnStatus;
   Close sqlCursor;

   Return returnStatus;

 End;



