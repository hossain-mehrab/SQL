USE ORDERS;

-- LET'S CREATE A TEMPORARY TABLE WITH ALL THE REQUIRED DATA AND THEN USE IT TO FETCH OUR RESULTS
CREATE TEMPORARY TABLE DEMAND_SUPPLY
SELECT 
	OH.CUSTOMER_ID, 
    OI.PRODUCT_ID, 
    PRODUCT_DESC, 
    OH.ORDER_ID, 
    SUM(OI.PRODUCT_QUANTITY) AS DEMAND,
    CEIL( SUM(OI.PRODUCT_QUANTITY) + ( SUM(OI.PRODUCT_QUANTITY) * 0.25 ) ) AS NEW_DEMAND,
    PC.PRODUCT_CLASS_DESC,
	PRODUCT_QUANTITY_AVAIL AS SUPPLY, 
    ROUND(PRODUCT_QUANTITY_AVAIL / SUM(PRODUCT_QUANTITY), 2) AS CURRENT_RATIO,
    ROUND(PRODUCT_QUANTITY_AVAIL / CEIL( SUM(OI.PRODUCT_QUANTITY) + ( SUM(OI.PRODUCT_QUANTITY) * 0.25 ) ), 2) AS NEW_RATIO
FROM ORDER_HEADER OH
	JOIN ORDER_ITEMS OI USING(ORDER_ID)
	JOIN PRODUCT USING(PRODUCT_ID)
	JOIN PRODUCT_CLASS PC ON PC.PRODUCT_CLASS_CODE = PRODUCT.PRODUCT_CLASS_CODE
GROUP BY PRODUCT_ID;
    
SELECT * FROM DEMAND_SUPPLY;
-- DROP TABLE DEMAND_SUPPLY;

-- [1.1] WHAT IS THE CURRENT SUPPLY TO DEMAND STATUS?
SELECT 
	CUSTOMER_ID, 
    PRODUCT_ID, 
    PRODUCT_DESC, 
    ORDER_ID, 
    DEMAND,
	PRODUCT_CLASS_DESC, 
    SUPPLY,
        CASE
            WHEN CURRENT_RATIO < 1 THEN  "RISK"
            WHEN CURRENT_RATIO >= 1 AND CURRENT_RATIO < 1.1 THEN "MATCHED"
            WHEN CURRENT_RATIO >= 1.1 THEN "SAFE"
		END AS STOCK_STATUS
FROM DEMAND_SUPPLY;

-- [1.2] CALCULATE THE PERCENTAGE RATIO FOR EACH STOCK_STATUS
SELECT (SUM(CASE WHEN CURRENT_RATIO < 1 THEN 1 ELSE 0 END)/COUNT(*))*100 AS 'RISK_RATIO(%)',
       (SUM(CASE WHEN CURRENT_RATIO >= 1 AND CURRENT_RATIO < 1.1 THEN 1 ELSE 0 END)/COUNT(*))*100 AS 'MATCHED_RATIO(%)',
       (SUM(CASE WHEN CURRENT_RATIO >= 1.1 THEN 1 ELSE 0 END)/COUNT(*))*100 AS 'SAFE_RATIO(%)'
FROM DEMAND_SUPPLY;

-- [1.3] FIND THE CUSTOMERS AND HOW MANY OF THEIR ORDERS ARE AT RISK. 
SELECT
	CUSTOMER_ID,
    COUNT(*) AS NUM_OF_ORDERS,
    SUM(CASE WHEN CURRENT_RATIO < 1 THEN  1 ELSE 0 END) AS ORDERS_AT_RISK,
    ROUND( (SUM(CASE WHEN CURRENT_RATIO < 1 THEN  1 ELSE 0 END) / COUNT(*) ) * 100, 2) AS '%AT_RISK'
FROM DEMAND_SUPPLY
GROUP BY 1; -- YOU CAN SPECIFY 1,2,3 INSTEAD OF GIVING THE COLUMN NAMES 

/*-------------------------------------------------------------------------------------------------------------------------------*/

-- [2.1] WHAT IS THE NEW SUPPLY TO DEMAND STATUS?
SELECT 
	CUSTOMER_ID, 
    PRODUCT_ID, 
    PRODUCT_DESC, 
    ORDER_ID, 
    NEW_DEMAND,
	PRODUCT_CLASS_DESC, 
    SUPPLY,
        CASE
            WHEN NEW_RATIO < 1 THEN  "RISK"
            WHEN NEW_RATIO >= 1 AND NEW_RATIO < 1.1 THEN "MATCHED"
            WHEN NEW_RATIO >= 1.1 THEN "SAFE"
		END AS STOCK_STATUS
FROM DEMAND_SUPPLY;

-- [2.2] CALCULATE THE PERCENTAGE RATIO FOR EACH STOCK_STATUS
SELECT (SUM(CASE WHEN NEW_RATIO < 1 THEN 1 ELSE 0 END)/COUNT(*))*100 AS 'RISK_RATIO(%)',
       (SUM(CASE WHEN NEW_RATIO >= 1 AND NEW_RATIO < 1.1 THEN 1 ELSE 0 END)/COUNT(*))*100 AS 'MATCHED_RATIO(%)',
       (SUM(CASE WHEN NEW_RATIO >= 1.1 THEN 1 ELSE 0 END)/COUNT(*))*100 AS 'SAFE_RATIO(%)'
FROM DEMAND_SUPPLY;

-- [2.3] HOW MUCH MORE INVENTORY DO YOU NEED TO MATCH YOUR DEMAND IF YOU CONSIDER DEMAND + 10% AS A SAFE_INVENTORY?
SELECT 
	DS.*, 
    CEIL(NEW_DEMAND*1.1) AS SAFE_INVENTORY,
    CEIL(NEW_DEMAND*1.1) - NEW_DEMAND AS INVENTORY_NEEDED 
FROM DEMAND_SUPPLY DS WHERE NEW_RATIO < 1;