/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000
	--   ,[ShippingCargoReadinessId]
	--   ,tSAMD.CreatedDate
	tSBMD.ActionNumber
	,tSAMD.ActionNumber
	,tsa.ShippingBookingConfirmationId




FROM [schSOA].[tShippingBookings] AS [tSB]
	LEFT JOIN schSOA.tShippingActionMainData tSBMD
	ON tSB.BookingMainId = tSBMD.ShippingActionMainDataId


	LEFT JOIN schSOA.tShippingActions tSA
	ON tSBMD.ShippingActionMainDataId = tSA.ShippingActionMainDataId
	LEFT JOIN schSOA.tShippingActionMainData tSAMD
	ON tSA.ShippingActionMainDataId = tSAMD.ShippingActionMainDataId



WHERE --tSA.IsActive=1
 --tSBMD.ActionNumber like '%BK0263/2018%'
 tSAMD.ActionNumber LIKE '%BC0106/2018%'
ORDER BY tsa.ShippingBookingConfirmationId
--tSBMD.ActionNumber desc


--   t.CutoffVGM desc,
--   t.ETA desc,
--   t.ETD desc