SELECT CURRENT_USER();
SELECT CURRENT_ACCOUNT();
SELECT CURRENT_ACCOUNT();
SELECT CURRENT_ACCOUNT_NAME();
SELECT CURRENT_REGION();
USE ROLE ACCOUNTADMIN;
CREATE WAREHOUSE IF NOT EXISTS NEW
WITH 
    WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    COMMENT = 'Warehouse for learning and practice';

-- Use the warehouse
USE WAREHOUSE NEW;

CREATE DATABASE IF NOT EXISTS learn
COMMENT='Database for learning Snowflake'

-- Use the database
USE DATABASE learn;

-- Create a schema
CREATE SCHEMA IF NOT EXISTS learn_schema
COMMENT = 'Schema for practice tables';

-- Use the schema
USE SCHEMA learn_schema;


-- Create a table for customer data
CREATE TABLE IF NOT EXISTS customer(
    customer_id INTEGER,
    name STRING,
    region STRING,
    annual_spend FLOAT,
    signup_date DATE
)
COMMENT = 'Table storing customer information';

-- Insert sample data
INSERT INTO customer (customer_id, name, region, annual_spend, signup_date)
VALUES 
    (1, 'Alice Smith', 'North America', 12000.50, '2024-03-15'),
    (2, 'Bob Jones', 'Europe', 8500.75, '2024-06-22'),
    (3, 'Charlie Lee', 'Asia', 15000.00, '2024-09-10'),
    (4, 'Dana Kim', 'North America', 9500.25, '2025-01-05');

SELECT * FROM customer;




-- Set role to ACCOUNTADMIN for user and role management
USE ROLE ACCOUNTADMIN;

-- Create a new role
CREATE ROLE IF NOT EXISTS analyst_role
COMMENT = 'Role for data analysts with limited access';


-- Grant warehouse usage to the role
GRANT USAGE ON WAREHOUSE NEW TO ROLE analyst_role;

-- Grant database and schema usage
GRANT USAGE ON DATABASE learn TO ROLE analyst_role;
GRANT USAGE ON SCHEMA learn_schema TO ROLE analyst_role;

-- Grant SELECT privilege on the customers table
GRANT SELECT ON TABLE learn.learn_schema.customer to ROLE analyst_role;

-- Verify role and privileges (optional)
SHOW GRANTS TO ROLE analyst_role;


-- Create a new user
CREATE USER IF NOT EXISTS analyst_user
    PASSWORD = 'AnalystPass2025'
    DEFAULT_ROLE = analyst_role
    COMMENT = 'Test user for analyst role';

-- Assign the role to the user
GRANT ROLE analyst_role TO USER analyst_user;

SHOW GRANTS TO USER analyst_user;

SHOW USERS;

show databases;
SHOW WAREHOUSES;
show schemas;

USE WAREHOUSE NEW;
USE DATABASE LEARN;
USE SCHEMA LEARN_SCHEMA;

select * from customer;
-- Analytical query: Average spend by region
SELECT region, SUM(annual_spend) from customer group by region;
SELECT region, ROUND(AVG(annual_spend)) AS avg_spend 
from customer 
group by region
ORDER by avg_spend DESC
;


-- Filter and sort: Customers with high spend
SELECT customer_id, name, annual_spend
FROM customer
WHERE annual_spend > 10000
ORDER BY annual_spend DESC;


-- Date-based analysis: Customers who signed up in 2024
select YEAR(signup_date) from customer;
SELECT name, signup_date
FROM customers
WHERE YEAR(signup_date) = 2024;


-- Update data: Increase spend for North America customers
UPDATE customer
set annual_spend=annual_spend*1.1
WHERE region = 'North America';

-- Verify update
SELECT * FROM customer WHERE region = 'North America';

ALTER TABLE customer 
add column x STRING;
SELECT * FROM customer;

ALTER TABLE customer 
drop column x ;
SELECT * FROM customer;

-- Delete data: Remove customers with low spend
DELETE FROM customer 
where annual_spend < 9000;
SELECT * FROM customer;



