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

--;
--WITH cte
--  AS (
--      SELECT
--          P.name
--         ,P.prices_amountMax
--         ,P.brand
--         ,P.categories
--         ,P.imageURLs
--         ,P.manufacturer
--         ,P.manufacturerNumber
--         ,P.primaryCategories
--         ,P.weight
--         ,row_num = ROW_NUMBER() OVER (PARTITION BY P.name ORDER BY P.name)
--      FROM
--          dbo.Products AS P
--  )
--SELECT * FROM cte 
--WHERE cte.row_num = 1;

--SELECT * FROM dbo.Products AS P


--UPDATE 
--	Application.Organization 
--SET 
--	WebsiteURL = 'https://' + LOWER(REPLACE(TRANSLATE(OrganizationName, '~`!@#$%^&*()-_=+[{]}\|:;"/?.,>< ''', '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', ''))+ '.com'
--WHERE 
--	WebsiteURL IS NOT NULL;

--DELETE FROM dbo.Flipkart2 WHERE uniq_id IN (
--'d5be97e54159b52cacf95b651db26e45'
--,'2f1e410832e4e010fa18923c3d4ec588'
--,'11c0099e325b67f908e75803bb6b9135'
--,'cd7189193ec8bdb1b4a0ed04d40b3a0a'
--,'fb5a9da340b7910d4e0802c9aee1f4b9'
--)

--UPDATE dbo.flipkart2 SET discounted_price = discounted_price / 72.5537
--UPDATE dbo.flipkart2 SET retail_price = 19.00, discounted_price = 14.99 WHERE retail_price IS null
--product_slug = 
----	REPLACE(
----	REPLACE(
----	REPLACE(
--LOWER(REPLACE(TRANSLATE(product_name, ' ~`!@#$%^&*()-_=+[{]}\|:;"/?.,><''', '_@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', ''))
----	  , ' ', '_')
--		--, ')', '')
--		--, '(', '')

--UPDATE dbo.Flipkart3 SET product_slug = LOWER(REPLACE(TRANSLATE(product_name, ' ~`!@#$%^&*()-_=+[{]}\|:;"/?.,><''', '_@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', ''))


--BEGIN TRAN
--COMMIT
--ROLLBACK

--SELECT
--   product_category_tree
----INTO dbo.FlipkartCategory1
--FROM
--    dbo.Flipkart4
----ORDER BY LEN(description) desc
----WHERE retail_price IS null


----UPDATE dbo.FlipkartCategory1 SET product_category_tree = 
--SELECT DISTINCT
--       product_category_tree
----INTO dbo.FlipkartCategory2
--FROM
--    dbo.FlipkartCategory2
----WHERE product_category_tree  LIKE '%|%'
----ORDER BY product_category_tree






--SELECT * FROM dbo.FlipkartCategory2 AS FC WHERE FC.product_category_tree like '%Tarkan Umbrellas%'
--BEGIN TRAN
--UPDATE dbo.FlipkartCategory2 SET product_category_tree = 'Pens & Stationery|School Supplies|Umbrellas|Tarkan Umbrellas|Tarkan Unique Style-2016 Umbrella (Multicolor)'
--WHERE product_category_tree = 'Pens & Stationery|School Supplies|Umbrellas| Tarkan Umbrellas| Tarkan Unique Style-2016 Umbrella (Multicolor)'
--COMMIT










--SET NOCOUNT ON;
--DROP TABLE IF EXISTS #product_category_tree;
--CREATE TABLE #product_category_tree (
--    product_category_tree NVARCHAR(4000) NOT NULL
--   ,IsProcessedFlag       BIT            NOT NULL DEFAULT (0)
--);
--INSERT INTO #product_category_tree (product_category_tree)
--SELECT DISTINCT product_category_tree FROM dbo.FlipkartCategory2;

----SELECT * FROM #product_category_tree;

--DECLARE @product_category_tree NVARCHAR(4000);

--WHILE EXISTS (SELECT * FROM #product_category_tree AS C WHERE C.IsProcessedFlag = 0)
--    BEGIN
--        SELECT TOP (1)
--               @product_category_tree = C.product_category_tree
--        FROM
--            #product_category_tree AS C
--        WHERE
--            C.IsProcessedFlag = 0;

--        DROP TABLE IF EXISTS #product_category;
--        CREATE TABLE #product_category (
--            Id                        INT            IDENTITY(1, 1)
--           ,product_category          NVARCHAR(4000) NOT NULL
--           ,ProductCategoryId         INT            NULL
--           ,ParentIdProductCategoryId INT            NULL
--           ,IsProcessedFlag           BIT            NOT NULL DEFAULT (0)
--        );

--        INSERT INTO #product_category (product_category)
--        SELECT value FROM STRING_SPLIT(@product_category_tree, '|');

--        DECLARE
--            @product_category NVARCHAR(4000)
--           ,@Id               INT;
--        DECLARE @PreviousProductCategoryId INT;
--        WHILE EXISTS (SELECT * FROM #product_category AS C WHERE C.IsProcessedFlag = 0)
--            BEGIN
--                SELECT TOP (1)
--                       @Id               = Id
--                      ,@product_category = product_category
--                FROM
--                    #product_category
--                WHERE
--                    IsProcessedFlag = 0;

--                DECLARE @ProductCategoryId INT;

--                IF NOT EXISTS (
--                    SELECT
--                        *
--                    FROM
--                        dbo.ProductCategory
--                    WHERE
--                        ProductCategoryName = @product_category
--                )
--                    BEGIN
--                        INSERT INTO dbo.ProductCategory (ProductCategoryName, ParentIdProductCategoryId)
--                        SELECT
--                            @product_category
--                           ,ParentIdProductCategoryId = IIF(@Id = 1, NULL, @PreviousProductCategoryId);

--                        UPDATE
--                            #product_category
--                        SET
--                            ProductCategoryId = SCOPE_IDENTITY()
--                           ,ParentIdProductCategoryId = IIF(@Id = 1, NULL, @PreviousProductCategoryId)
--                           ,IsProcessedFlag = 1
--                        WHERE
--                            product_category = @product_category;

--                        SET @PreviousProductCategoryId = SCOPE_IDENTITY();
--                    END;
--                ELSE
--                    BEGIN
--                        UPDATE
--                            #product_category
--                        SET
--                            ProductCategoryId = (
--                                SELECT
--                                    ProductCategoryId
--                                FROM
--                                    dbo.ProductCategory
--                                WHERE
--                                    ProductCategoryName = @product_category
--                            )
--                           ,ParentIdProductCategoryId = IIF(@Id = 1, NULL, @PreviousProductCategoryId)
--                           ,IsProcessedFlag = 1
--                        WHERE
--                            product_category = @product_category;


--                        SET @PreviousProductCategoryId = (
--                            SELECT
--                                ProductCategoryId
--                            FROM
--                                dbo.ProductCategory
--                            WHERE
--                                ProductCategoryName = @product_category
--                        );
--                    END;

--            END;

--        --SELECT * FROM #product_category AS PC;

--        UPDATE
--            #product_category_tree
--        SET
--            IsProcessedFlag = 1
--        WHERE
--            product_category_tree = @product_category_tree;
--    END;









--  TRUNCATE TABLE dbo.ProductCategory

/*
;WITH MyCTE
   AS (
       -- anchor
       SELECT
           t1.CategoryId
          ,t1.CategoryName
          ,t1.ParentIdCategoryId
          ,Level     = 1
          ,Hierarchy = CAST((t1.CategoryName) AS VARCHAR(MAX))
       FROM
           dbo.Category AS t1
       WHERE
           t1.ParentIdCategoryId IS NULL
       UNION ALL
       --recursive member
       SELECT
           t2.CategoryId
          ,t2.CategoryName
          ,t2.ParentIdCategoryId
          ,Level     = M.Level + 1
          ,Hierarchy = CAST((M.Hierarchy + '->' + t2.CategoryName) AS VARCHAR(MAX))
       FROM
           dbo.Category AS t2
           JOIN MyCTE          AS M ON t2.ParentIdCategoryId = M.CategoryId
   )
SELECT * FROM MyCTE ORDER BY MyCTE.Hierarchy;
*/








--SELECT * FROM dbo.ProductCategory AS PC WHERE PC.ProductCategoryName = 'Engage Combos'
--UPDATE dbo.Flipkart4 SET product_category_tree2= '|'+ REPLACE(
--	REPLACE(
--	REPLACE(
--	REPLACE(
--		product_category_tree 
--	,'["','')
--	,'"]','')
--	,' >>  ','|')
--	,' >> ','|')

--SELECT 
--'|'+ REPLACE(
--	REPLACE(
--	REPLACE(
--	REPLACE(
--		product_category_tree 
--	,'["','')
--	,'"]','')
--	,' >>  ','|')
--	,' >> ','|')
--FROM dbo.Flipkart4 --WHERE product_category_tree LIKE '%ABEEZ Boys, Men, Girls (Black, Pack of 1)%'

--UPDATE dbo.Flipkart4 SET product_category = REVERSE(LEFT(REVERSE(product_category_tree2), CHARINDEX('|', REVERSE(product_category_tree2)) -1))

--SELECT 
--	product_category_tree2
--	--,REVERSE(product_category_tree2)
--	--,CHARINDEX('|', REVERSE(product_category_tree2))
--	,REVERSE(LEFT(REVERSE(product_category_tree2), CHARINDEX('|', REVERSE(product_category_tree2)) -1))
--	--,LEFT(product_category_tree2, LEN(product_category_tree2) - CHARINDEX('.', REVERSE(product_category_tree2)))

--FROM dbo.Flipkart4
----WHERE product_category_tree LIKE '%ABEEZ Boys, Men, Girls (Black, Pack of 1)%'




--TRUNCATE TABLE dbo.Product;

--WITH cte
--  AS (
--      SELECT
--          *
--         ,rn = ROW_NUMBER() OVER (PARTITION BY product_name ORDER BY product_name ASC)
--      FROM
--          dbo.Flipkart4
--  )
--INSERT INTO dbo.Product (
--    ProductName
--   ,ProductSlug
--   ,ProductCategory
--   ,ProductDescription
--   ,RegularPrice
--   ,SalePrice
--   ,Images
--   ,Brand
--)
--SELECT
--    cte.product_name
--   ,cte.product_slug
--   ,cte.product_category
--   ,cte.description
--   ,cte.retail_price
--   ,cte.discounted_price
--   ,cte.image
--   ,cte.brand
--FROM
--    cte
--WHERE
--    cte.rn = 1;




--UPDATE dbo.Product SET ProductName = 'Tarkan Unique Style-2016 Umbrella'
--,ProductSlug = 'tarkan_unique_style2016_umbrella'
--,ProductCategory = 'Tarkan Unique Style-2016 Umbrella (Multicolor)'
--,Brand = 'Tarkan'
--WHERE ProductId = 1

	

--SELECT
--    P.ProductName
--   ,COUNT(*)
--FROM
--    dbo.Product AS P
--GROUP BY
--    P.ProductName
--HAVING
--    COUNT(*) > 1
--ORDER BY
--    COUNT(*) DESC;

--BEGIN tran
--UPDATE P
--SET P.CategoryId = C.CategoryId
----SELECT *, C.CategoryId, C.CategoryName 
--FROM dbo.Product AS P --12618
--INNER JOIN dbo.Category AS C ON P.ProductCategory = C.CategoryName

--SELECT P.ProductId, P.ProductCategory, c.CategoryId, c.CategoryName FROM dbo.Product AS P
--INNER JOIN dbo.Category AS C ON P.CategoryId = C.CategoryId
----COMMIT













--BEGIN TRAN
--UPDATE dbo.Category SET CategorySlug = LOWER(REPLACE(TRANSLATE(CategoryName, '~`!@#$%^&*()_=+[{]}\|:;"/?.,><'' -', '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@__'), '@', ''))
--ROLLBACK
----Commit
--SELECT * FROM dbo.Category AS C

--SELECT 
--C.CategoryName
--,LOWER(REPLACE(TRANSLATE(C.CategoryName, '~`!@#$%^&*()_=+[{]}\|:;"/?.,><'' -', '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@__'), '@', ''))
--FROM dbo.Category AS C









--Top level categories should be fixed
--SET IDENTITY_INSERT dbo.Category ON
--INSERT INTO dbo.Category (CategoryId, CategoryName, CategorySlug)
--VALUES
--     (0   -- ParentIdCategoryId - int
--     ,N'Hidden' -- CategoryName - nvarchar(200)
--     ,N'hidden' -- CategorySlug - nvarchar(400)
--    )
--SET IDENTITY_INSERT dbo.Category OFF

--SELECT * FROM dbo.Category WHERE ParentIdCategoryId IS NULL
--AND CategoryId not IN (
--SELECT ParentIdCategoryId FROM dbo.Category WHERE ParentIdCategoryId IS NOT null
--)
--ORDER BY CategoryName
--BEGIN tran
--UPDATE dbo.Category SET ParentIdCategoryId = 0 
--WHERE CategoryId IN (
--SELECT CategoryId FROM dbo.Category WHERE ParentIdCategoryId IS NULL
--AND CategoryId not IN (
--SELECT ParentIdCategoryId FROM dbo.Category WHERE ParentIdCategoryId IS NOT null
--)
--)
--SELECT * FROM dbo.Category AS C WHERE C.ParentIdCategoryId IS NULL
----COMMIT
--BEGIN TRAN
--UPDATE dbo.Category SET ParentIdCategoryId = NULL WHERE CategoryId = 0
--SELECT * FROM dbo.Category AS C WHERE C.ParentIdCategoryId IS null
----COMMIT

--SET NOCOUNT OFF











SELECT * FROM dbo.Product AS P
--figure out how to populate product variants with size and color and each for every other product
;WITH MyCTE
   AS (
       -- anchor
       SELECT
           t1.CategoryId
          ,t1.CategoryName
          ,t1.ParentIdCategoryId
          ,Level     = 1
          ,Hierarchy = CAST((t1.CategoryName) AS VARCHAR(MAX))
       FROM
           dbo.Category AS t1
       WHERE
           t1.ParentIdCategoryId IS NULL
       UNION ALL
       --recursive member
       SELECT
           t2.CategoryId
          ,t2.CategoryName
          ,t2.ParentIdCategoryId
          ,Level     = M.Level + 1
          ,Hierarchy = CAST((M.Hierarchy + '->' + t2.CategoryName) AS VARCHAR(MAX))
       FROM
           dbo.Category AS t2
           JOIN MyCTE          AS M ON t2.ParentIdCategoryId = M.CategoryId
   )
SELECT * FROM MyCTE 
WHERE
	MyCTE.Hierarchy LIKE 'Clothing%'
ORDER BY MyCTE.Hierarchy;


