# Data-Analytics-Assesment
This is the solution to Cowry Rise's SQL technical Assesment 
## Question 1
Approach to Answer
-	Count of Regular Savings Accounts per Customer
Approach: Queried the plans_plan table, filtering rows where is_regular_savings = 1, and grouped by owner_id to get the savings account count for each customer.
-	Count of Investment Accounts per Customer
Approach: Queried the same table but filtered for is_a_fund = 1, then grouped by owner_id to get the investment account count.
-	Total Confirmed Deposits per Customer
Approach: Queried the savings_savingsaccount table, summing up the confirmed_amount per owner_id after grouping.
-	Combining All Metrics
Approach: Joined the three temporary tables (CTEs) with the users_customuser table using owner_id, to generate a final table showing each user’s full name, number of savings and investment accounts, and total deposits.

-	Challenges & Resolutions
All 3 tables contained different primary and foreign keys so initially I joined the id in user_id to a different id in savings and plan which returned no results due to mismatched keys. I resolved this by having another look and understanding at the ‘hints’ section where the columns were properly explained. 


## Question 2
Approach to answer
- Monthly Transactions per Customer
I extracted year and month from transaction_date and grouped by owner_id and month to count the monthly transactions.
- Average Monthly Transactions
Afterwards I calculated the average number of monthly transactions for each customer.
- Frequency Categorization
I used CASE logic to segment customers into frequency categories based on their average.
- Final Aggregation
I grouped the frequency category to count customers and calculated the average transaction rate within each segment.


#### Challenges and Resolutions
Initially, I attempted to group by only month instead of both owner_id and month, which led to incorrect transaction averages per customer. I corrected this by grouping by the month and owner_id. 

- I used Data Format (transaction_date, '%Y-%m') for Monthly Aggregation : 
Since the data spans multiple years (from 2016 onwards), I chose to use DATE_FORMAT(transaction_date, '%Y-%m') to group transactions by both year and month. This prevents incorrect aggregation across the same month in different years. For example, aggregating solely by MONTH(transaction_date) would combine all Januaries (e.g., Jan 2016, Jan 2017), leading to inflated and misleading transaction counts. Using the year-month format ensures each month's data is accurately represented within its specific year.


## Question 3 
Approach
- last_transactions CTE:
For this, i extracted the most recent transaction date (MAX(transaction_date)) for each plan_id from the savings_savingsaccount table and i Grouped it by plan_id to ensure the latest activity was isolated per account.

- filtered_plans CTE:
I filtered the plans_plan table to select only active savings or investment accounts. This was done by checking is_regular_savings = 1 or is_a_fund = 1. I then added a CASE statement to label the account type as either "Savings" or "Investment" for readability.

-Final SELECT with JOIN:
I joined the active plans from filtered_plans with the transaction info from last_transactions using plan_id. I filtered results to show only: Accounts with no transaction date (NULL – never transacted), or Accounts where the last transaction was more than 365 days ago.

#### Challenges and Resolutions
I misinterpreted "Last 1 Year” part of the question, hence filtering DATEDIFF(...) < 365, which incorrectly included active accounts. I corrected to > 365 to focus on inactivity beyond one year which gave me the needed result.
Accounts with no transaction records at all were being excluded because the join required matching records in both tables. I resolved this by using a LEFT JOIN to include transaction dates that were null, which included the accounts with no transactions. 
