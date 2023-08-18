# SQL
##1. Select All Coloumn from the table 
SELECT *  // * = Select all coloumn
FROM Schema_Name.Table name  
LIMIT 10 // * = Select number of row

Example: 
SELECT CUSTOMER_ID, CUSTOMER_FNAME
FROM orders.online_customer
LIMIT 10 

##2. Select Individual Coloumn 
SELECT CUSTOMER_GENDER
FROM orders.online_customer
LIMIT 11

##3. Select Distinct value from coloumn (It wont show repeated value)
SELECT distinct CUSTOMER_GENDER
FROM orders.online_customer
LIMIT 11

##4. Insert new value in the table
INSERT INTO Schema_Name.Table_name
VALUES ("Col1"........"ColN")

Example: 
INSERT INTO orders.online_customer
VALUES ("53", "Bidhan", "C.Roy", "bidhanroy@yahoo.co.in", "9886218583", "918", "2011-10-23", "bcroy", "F")

##5. Update one or more coloumn values
UPDATE Schema_Name.Table_name SET Coloumn_name = Coloumn_name - Value

Example: 
UPDATE orders.online_customer SET ADDRESS_ID = ADDRESS_ID-9 


##6. Update one or more coloumn values
UPDATE Schema_Name.Table_name SET Coloumn_name = Coloumn_name - Value

Example: 
UPDATE orders.online_customer SET ADDRESS_ID = ADDRESS_ID-9

##6. Update one or more coloumn values
DELETE FROM Schema_Name.Table_name 
WHERE Coloumn_name = row_values

Example: 
DELETE FROM orders.online_customer
WHERE CUSTOMER_ID = 2 