WITH monthly_transaction AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS month_count,
        COUNT(*) AS transaction_count
    FROM savings_savingsaccount
    GROUP BY owner_id, month_count
),

avg_transaction_per_customer AS (
    SELECT 
        owner_id, 
        AVG(transaction_count) AS avg_monthly_transaction
    FROM monthly_transaction
    GROUP BY owner_id
),

frequency AS (
    SELECT 
        owner_id,
        avg_monthly_transaction,
        CASE 
            WHEN avg_monthly_transaction >= 10 THEN 'High Frequency'
            WHEN avg_monthly_transaction BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS freq
    FROM avg_transaction_per_customer
)

SELECT  
    freq AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_monthly_transaction), 2) AS avg_transactions_per_month
FROM frequency
GROUP BY freq
ORDER BY FIELD(freq, 'High Frequency', 'Medium Frequency', 'Low Frequency');
