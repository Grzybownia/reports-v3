USE [C_HARTWIG_SO_DEVEL]
GO

DECLARE	@return_value int

EXEC	@return_value = [schDictionaries].[PrGetLabelsByType]
		@intIdOfType = 670002
GO


/*
=Split("686,683,687,684,685",",")
=Split("513,514",",")
=Split("680,681,682",",")

=Split("5949, 2802, 8626, 12462, 7012, 11433, 13529, 19047, 11300, 12408, 19005, 1, 12469, 12441, 11550, 5151, 11503, 12409, 11615, 12457, 12529, 11674, 17649, 12425",",")


*/

