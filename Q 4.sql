	-- Aggregating customer activity by counting total transactions and calculating average profit per transaction
WITH customer_activity AS (
    SELECT 
        sa.owner_id AS customer_id,
        COUNT(*) AS total_transactions,
        AVG(0.001 * sa.confirmed_amount) AS avg_profit_per_transaction
    FROM savings_savingsaccount sa
    GROUP BY sa.owner_id
),
-- Calculating tenure in months for each user since the account was created
tenure_data AS (
    SELECT 
        id AS customer_id,
         CONCAT_WS(' ', first_name, last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE) AS tenure_months
    FROM users_customuser
)
-- Joining both CTEs and calculating estimated CLV using the formula provided
SELECT 
    td.customer_id,
    name,
    td.tenure_months,
    ca.total_transactions,
    ROUND((ca.total_transactions / NULLIF(td.tenure_months, 0)) * 12 * ca.avg_profit_per_transaction, 2) AS estimated_clv
FROM tenure_data td
JOIN customer_activity ca ON td.customer_id = ca.customer_id
ORDER BY estimated_clv DESC;



