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


