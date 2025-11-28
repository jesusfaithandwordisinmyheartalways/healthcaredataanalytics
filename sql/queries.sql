SELECT DEPARTMENT, SUM(Billing_Amount) AS TotalBilling FROM healthcare GROUP BY Department ORDER BY TotalBilling DESC;

-- Top doctors by visits
SELECT Doctor, COUNT(*) AS Visits
FROM healthcare
GROUP BY Doctor,
ORDER BY Visits DESC;


-- Window function example: running total by Visit_Date
SELECT Visit_Date, SUM(Billing_Amount) OVER (ORDER BY Visit_Date) AS RunningTotal
FROM healthcare;


-- CTE example: Avg billing per department > 500
WITH DeptAvg AS (SELECT DEPARTMENT, AVG(Billing_Amount) AS AvgBilling FROM healthcare  GROUP BY Department)
SELECT * FROM DeptAvg WHERE AvgBilling > 500;

