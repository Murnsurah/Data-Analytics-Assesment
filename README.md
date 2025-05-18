# Data-Analytics-Assesment

This is the solution to Cowry Rise's SQL technical Assesment

## Question 1

**Approach to Answer**

* **Count of Regular Savings Accounts per Customer**
  Approach: Queried the plans\_plan table, filtering rows where is\_regular\_savings = 1, and grouped by owner\_id to get the savings account count for each customer.

* **Count of Investment Accounts per Customer**
  Approach: Queried the same table but filtered for is\_a\_fund = 1, then grouped by owner\_id to get the investment account count.

* **Total Confirmed Deposits per Customer**
  Approach: Queried the savings\_savingsaccount table, summing up the confirmed\_amount per owner\_id after grouping.

* **Combining All Metrics**
  Approach: Joined the three temporary tables (CTEs) with the users\_customuser table using owner\_id, to generate a final table showing each user’s full name, number of savings and investment accounts, and total deposits.

**Challenges & Resolutions**

All 3 tables contained different primary and foreign keys so initially I joined the id in user\_id to a different id in savings and plan which returned no results due to mismatched keys. I resolved this by having another look and understanding at the ‘hints’ section where the columns were properly explained.

---

## Question 2

**Approach to answer**

* **Monthly Transactions per Customer**
  I extracted year and month from transaction\_date and grouped by owner\_id and month to count the monthly transactions.

* **Average Monthly Transactions**
  Afterwards I calculated the average number of monthly transactions for each customer.

* **Frequency Categorization**
  I used CASE logic to segment customers into frequency categories based on their average.

* **Final Aggregation**
  I grouped the frequency category to count customers and calculated the average transaction rate within each segment.

**Challenges and Resolutions**

Initially, I attempted to group by only month instead of both owner\_id and month, which led to incorrect transaction averages per customer. I corrected this by grouping by the month and owner\_id.

* I used Data Format (transaction\_date, '%Y-%m') for Monthly Aggregation :
  Since the data spans multiple years (from 2016 onwards), I chose to use DATE\_FORMAT(transaction\_date, '%Y-%m') to group transactions by both year and month. This prevents incorrect aggregation across the same month in different years. For example, aggregating solely by MONTH(transaction\_date) would combine all Januaries (e.g., Jan 2016, Jan 2017), leading to inflated and misleading transaction counts. Using the year-month format ensures each month's data is accurately represented within its specific year.

---

## Question 3

**Approach**

* **last\_transactions CTE**:
  For this, i extracted the most recent transaction date (MAX(transaction\_date)) for each plan\_id from the savings\_savingsaccount table and i Grouped it by plan\_id to ensure the latest activity was isolated per account.

* **filtered\_plans CTE**:
  I filtered the plans\_plan table to select only active savings or investment accounts. This was done by checking is\_regular\_savings = 1 or is\_a\_fund = 1. I then added a CASE statement to label the account type as either "Savings" or "Investment" for readability.

* **Final SELECT with JOIN**:
  I joined the active plans from filtered\_plans with the transaction info from last\_transactions using plan\_id. I filtered results to show only: Accounts with no transaction date (NULL – never transacted), or Accounts where the last transaction was more than 365 days ago.

**Challenges and Resolutions**

* I misinterpreted "Last 1 Year” part of the question, hence filtering DATEDIFF(...) < 365, which incorrectly included active accounts. I corrected to > 365 to focus on inactivity beyond one year which gave me the needed result.

* Accounts with no transaction records at all were being excluded because the join required matching records in both tables. I resolved this by using a LEFT JOIN to include transaction dates that were null, which included the accounts with no transactions.

---

## Question 4

**My Approach**

* For **customer\_count CTE**, I aggregated data from savings\_savingsaccount to count the total number of transactions per user. I estimated average profit per transaction, using the assumption that each transaction yields 0.1% profit (0.001 \* transaction\_value) as stated by the question.

* For **tenure\_data CTE**, From the users\_customuser table, I Extracted each customer's signup date and Calculated account tenure in months using TIMESTAMPDIFF(MONTH, date\_joined, CURRENT\_DATE).

* For **final SELECT**, I Joined both datasets by customer ID and Calculated Estimated CLV using the formula: (total\_transactions / tenure\_months) \* 12 \* avg\_profit\_per\_transaction. This projects average yearly profit based on historical data. I further rounded the CLV to two decimal places and ordered results by CLV descending to highlight top-value users.

**Challenges and Resolutions**

* **Division by Zero**: Customers who signed up recently may have a tenure\_months = 0, causing a division error. This was resolved by using NULLIF(td.tenure\_months, 0) to safely avoid dividing by zero.

* There were **missing Users or Transactions** which mean't they wouldn't appear in the customer\_activity table. This was resolved by using an inner join to ensure that only active users with transaction history were involved.
