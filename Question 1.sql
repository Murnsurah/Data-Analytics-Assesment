USE adashi_staging;
					-- 1. High-Value Customers with Multiple Products
	-- Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
	-- Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
	-- Tables:
	-- users_customuser
	-- savings_savingsaccount
	-- plans_plan

-- Query for Savings accounts
WITH savings AS 
(SELECT owner_id, 
COUNT(CASE WHEN is_regular_savings = 1 THEN 1 END) savings_count
FROM plans_plan
GROUP BY owner_id
HAVING savings_count != 0),

-- Query for Investment account
investment AS (SELECT owner_id, 
COUNT(CASE WHEN is_a_fund = 1 THEN 1 END) investment_count
FROM plans_plan
GROUP BY owner_id
HAVING investment_count != 0),

-- Query for Total Deposits
deposits AS (SELECT owner_id,
ROUND(SUM(confirmed_amount),0) AS total_deposits
FROM savings_savingsaccount
GROUP BY owner_id)

-- Joining all Temporary tables; 
SELECT u.id AS owner_id, CONCAT(u.first_name, ' ',u.last_name) AS name, s.savings_count,
i.investment_count, d.total_deposits
FROM users_customuser as u
JOIN savings as s 
ON u.id = s.owner_id
JOIN investment as i
ON u.id = i.owner_id
JOIN deposits as d 
ON u.id = d.owner_id
ORDER BY d.total_deposits;