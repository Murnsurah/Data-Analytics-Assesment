USE adashi_staging;

-- Flag savings or investment accounts with no inflow transactions in the last 365 days
-- Goal: Identify accounts that are still active (i.e., exist in the system) but haven't had any transactions in the past year

-- Get the most recent transaction date for each plan
WITH last_transactions AS (
    SELECT 
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    GROUP BY plan_id
),

-- Filter for active plans that are either savings or investment accounts
filtered_plans AS (
    SELECT 
        id AS plan_id,
        owner_id,
        CASE 
            WHEN is_regular_savings = 1 THEN 'Savings'
            WHEN is_a_fund = 1 THEN 'Investment'
        END AS account_type
    FROM plans_plan
    WHERE is_regular_savings = 1 OR is_a_fund = 1
)

-- Join the active plans with their last transaction info and filter for plans with no transactions in the last 365 days 
	-- including when the last transaction date is null 
SELECT 
    f.plan_id,
    f.owner_id,
    f.account_type,
    l.last_transaction_date,
    DATEDIFF(CURRENT_DATE, l.last_transaction_date) AS inactivity_days
FROM filtered_plans f
JOIN last_transactions l
    ON f.plan_id = l.plan_id
WHERE l.last_transaction_date IS NULL 
   OR DATEDIFF(CURRENT_DATE, l.last_transaction_date) > 365;
