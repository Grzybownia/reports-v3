USE C_HARTWIG_SO_DEVEL
SELECT tsamd.CreatedUserId
,tb.BookingNumber
,tsa.CreatedUserId
FROM schSOA.tShippingActions tsa
	LEFT JOIN schSOA.tShippingActionMainData tsamd
	ON tsa.ShippingActionMainDataId=tsamd.ShippingActionMainDataId
	LEFT JOIN schSOA.tShippingBookings tb
	ON tsamd.ShippingActionMainDataId=tb.BookingMainId
WHERE tsamd.CreatedUserId=19021
	OR tsa.CreatedUserId=19021