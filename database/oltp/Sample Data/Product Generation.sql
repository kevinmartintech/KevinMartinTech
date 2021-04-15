--SELECT TOP 1 * FROM Application.AttributeTerm AS AT WHERE AT.AttributeId = 2 ORDER BY NEWID()
--SELECT TOP 1 * FROM Application.AttributeTerm AS AT WHERE AT.AttributeId = 1 ORDER BY NEWID()

--TODO: Create loops to create better product, productitem, productvaiant records

SELECT * FROM KevinMartinTechData.dbo.Product AS P WHERE P.ProductId = 367
SELECT * FROM Application.Product AS P WHERE P.ProductId = 367