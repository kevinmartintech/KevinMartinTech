﻿/* Purchasing.PurchaseOrder Comment Fix */
UPDATE
    Purchasing.PurchaseOrder
SET
    Comment = UPPER(LEFT(Comment, 1)) + SUBSTRING(Comment, 2, LEN(Comment)) + '.';




/* Update Purchasing.PurchaseOrderLine */
UPDATE
    Purchasing.PurchaseOrderLine
SET
    UnitPrice = PI.RegularPrice
   ,NetAmount = CASE
                    WHEN POL.DiscountPercentage IS NOT NULL
                         AND POL.DiscountPercentage <> 0 THEN
                        PI.RegularPrice * (1 - POL.DiscountPercentage / 100)
                    ELSE
                        PI.RegularPrice
                END * POL.QuantityOrdered
FROM
    Purchasing.PurchaseOrderLine       AS POL
    INNER JOIN Application.ProductItem AS PI ON POL.ProductItemId = PI.ProductItemId;







/* Update Application.Person Email Columns */
UPDATE
    P
SET
    P.EmailAddress = LOWER(REPLACE(TRANSLATE(CONCAT(P.FirstName, P.LastName), N'爱安納彩红靜義凯文王李張劉陳楊~`!@#$%^&*()-_=+[{]}\|:;"/?.,>< ''', '???????????????@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', '') + '@' + O.Domain)
--   ,P.NormalizedEmailAddress = UPPER(REPLACE(TRANSLATE(CONCAT(P.FirstName, P.LastName), N'爱安納彩红靜義凯文王李張劉陳楊~`!@#$%^&*()-_=+[{]}\|:;"/?.,>< ''', '???????????????@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', '') + '@' + O.Domain)
FROM
    Application.Person                              AS P
    INNER JOIN KevinMartinTechData.dbo.Organization AS O ON P.PersonId = O.OrganizationId
WHERE
    P.EmailAddress IS NOT NULL;




/* Update Application.Person Email Columns for People joined with an organization */
UPDATE P
SET 
    P.EmailAddress = LOWER(REPLACE(TRANSLATE(CONCAT(P.FirstName, P.LastName), N'爱安納彩红靜義凯文王李張劉陳楊~`!@#$%^&*()-_=+[{]}\|:;"/?.,>< ''', '???????????????@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', '') + '@' + O.Domain)
--   ,P.NormalizedEmailAddress = UPPER(REPLACE(TRANSLATE(CONCAT(P.FirstName, P.LastName), N'爱安納彩红靜義凯文王李張劉陳楊~`!@#$%^&*()-_=+[{]}\|:;"/?.,>< ''', '???????????????@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', '') + '@' + O.Domain)
FROM
    Application.OrganizationPerson                  AS OP
    INNER JOIN Application.Person                   AS P ON OP.PersonId       = P.PersonId
    INNER JOIN KevinMartinTechData.dbo.Organization AS O ON OP.OrganizationId = O.OrganizationId
WHERE
	P.EmailAddress IS NOT NULL;




/* Update Organization Email Column */
UPDATE
    OE
SET
    OE.EmailAddress = LOWER(REPLACE(TRANSLATE(A.Alias, N'爱安納彩红靜義凯文王李張劉陳楊~`!@#$%^&*()-_=+[{]}\|:;"/?.,>< ''', '???????????????@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'), '@', '') + '@' + O2.Domain)
FROM
    Application.OrganizationEmail                   AS OE
    INNER JOIN Application.Organization             AS O ON OE.OrganizationId = O.OrganizationId
    INNER JOIN KevinMartinTechData.dbo.Organization AS O2 ON O.OrganizationName = O2.OrganizationName
    OUTER APPLY (
    SELECT TOP (1)
           n.Alias
    FROM (
        VALUES ('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('info@')
              ,('hello@')
              ,('hi@')
              ,('howdy@')
              ,('yourfriends@')
              ,('abuse@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('billing@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('orders@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accounting@')
              ,('accountreceivable@')
              ,('accountpayable@')
              ,('ar@')
              ,('ap@')
              ,('marketing@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('support@')
              ,('care@')
              ,('customerservice@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('sales@')
              ,('contact@')
              ,('assist@')
              ,('ask@')
              ,('wearelistening@')
              ,('solutions@')
              ,('editor@')
              ,('admin@')
              ,('webmaster@')
              ,('privacy@')
              ,('jobs@')
              ,('press@')
              ,('careers@')
              ,('help@')
              ,('news@')
              ,('feedback@')
              ,('media@')
              ,('hr@')
              ,('advertising@')
              ,('events@')
              ,('pr@')
              ,('enquiries@')
              ,('wecare@')
              ,('business@')
              ,('write@')
              ,('mailus@')
              ,('contactus@')
              ,('satisfaction@')
              ,('getanswer@')
              ,('query@')
              ,('questions@')
              ,('customer.service@')
              ,('customer.care@')
              ,('qna@')
              ,('hello@')
              ,('emailus@')
              ,('suggest@')
              ,('quick@')
              ,('quickreply@')
              ,('quickanswer@')
              ,('24x7@')
              ,('24x7help@')
              ,('client@')
              ,('customercare@')
              ,('happyhelp@')
              ,('serviceninjas@')
              ,('atyourservice@')
              ,('911@')
              ,('help@')
              ,('shout@')
              ,('helpme@')
              ,('shoutout@')
              ,('reachus@')
              ,('partners@')
              ,('letstalk@')
    ) AS n (Alias)
    WHERE
        OE.OrganizationId = OE.OrganizationId
    ORDER BY
        NEWID()
)                                                   AS A;

