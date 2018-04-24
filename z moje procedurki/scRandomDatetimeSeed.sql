USE C_HARTWIG_SO_DEVEL
GO
DECLARE @StartDate1 datetime = '2015-01-01'
DECLARE @StartDate2 datetime = '2017-12-31'
DECLARE @EndDate1 datetime = '2018-01-01'
DECLARE @EndDate2 datetime = '2020-12-31'
DECLARE @d1 datetime = DATEADD(SECOND, ABS(CHECKSUM(NEWID())) % ( 1 + DATEDIFF(SECOND, @StartDate1, @StartDate2)), @StartDate1)
DECLARE @d2 datetime  = DATEADD(SECOND, ABS(CHECKSUM(NEWID())) % ( 1 + DATEDIFF(SECOND, @EndDate1, @EndDate2)), @EndDate1)

UPDATE t
SET 
	 t.Etd = DATEADD(SECOND, ABS(CHECKSUM(NEWID())) % ( 1 + DATEDIFF(SECOND, @StartDate1, @StartDate2)), @StartDate1) 
	,t.Eta = DATEADD(SECOND, ABS(CHECKSUM(NEWID())) % ( 1 + DATEDIFF(SECOND, @EndDate1, @EndDate2)), @EndDate1)
FROM schSOA.tShippingBookings t
WHERE  t.Etd IS NULL AND t.Eta IS NULL
