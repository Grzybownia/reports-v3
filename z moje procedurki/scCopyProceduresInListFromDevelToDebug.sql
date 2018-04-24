USE C_HARTWIG_SO_DEVEL
DECLARE
   @sql varchar(max),
   @targetDBName varchar(64)='C_HARTWIG_SO_DEBUG'

DECLARE c CURSOR FOR 
   SELECT definition
FROM sys.procedures p
	INNER JOIN sys.sql_modules m
	ON p.object_id = m.object_id
WHERE p.name IN (
   'prGetCustomsClearance'
    ,'prGetBooking'
--    ,'prGetOperationLCL'   
    ,'prGetTransportOrder'
--    ,'PrGetLabelsByType'
--    ,'prGetAllShippersNamesFromShippingOperationMetrics'
--    ,'prGetAllContractorsNamesFromtShippingActions'
--    ,'prGetAllPrincipalsCHGNamesFromtShippingActionsMainData'
-- ,'prGetOperationFCL'
-- ,'prGetCustomers'
-- ,'prGetPORTS'
-- ,'prGetSettlement'
   )
OPEN c

FETCH NEXT FROM c INTO @sql

WHILE @@FETCH_STATUS = 0 
BEGIN
	SET @sql = REPLACE(@sql,'''','''''')
	SET @sql = REPLACE(@sql,'CREATE PROCEDURE','ALTER PROCEDURE')
	SET @sql = 'USE [' + @targetDBName + ']; EXEC(''' + @sql + ''')'

	EXEC(@sql)

	FETCH NEXT FROM c INTO @sql
END

CLOSE c
DEALLOCATE c



