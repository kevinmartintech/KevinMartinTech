----SELECT FORMAT(COUNT(*),'#,##0') FROM dbo.Products AS P --14,592
--SELECT
--    name             = MAX(P.name)
--   ,prices_amountMax = MAX(P.prices_amountMax)
--,brand              = MAX(P.brand)
--,categories         = MAX(P.categories)
--,imageURLs          = MAX(P.imageURLs)
--,manufacturer       = MAX(P.manufacturer)
--,manufacturerNumber = MAX(P.manufacturerNumber)
--,primaryCategories  = MAX(P.primaryCategories)
--,weight             = MAX(P.weight)
--FROM
--    dbo.Products AS P
--GROUP BY
--    P.name
--   ,P.prices_amountMax
--,P.brand
--,P.categories
--,P.imageURLs
--,P.manufacturer
--,P.manufacturerNumber
--,P.primaryCategories
--,P.weight
--ORDER BY
--    P.name;

;
WITH cte
  AS (
      SELECT
          P.name
         ,P.prices_amountMax
         ,P.brand
         ,P.categories
         ,P.imageURLs
         ,P.manufacturer
         ,P.manufacturerNumber
         ,P.primaryCategories
         ,P.weight
         ,row_num = ROW_NUMBER() OVER (PARTITION BY P.name ORDER BY P.name)
      FROM
          dbo.Products AS P
  )
SELECT * FROM cte 
WHERE cte.row_num = 1;

SELECT * FROM dbo.Products AS P