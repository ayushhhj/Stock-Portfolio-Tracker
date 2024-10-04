-- INSERT
-- Insert a new account
INSERT INTO
    Accounts (SIN, fullName, Balance, pswd)
VALUES (
        '1122334455', 'Jane Doe', 5000, 'janeDoePass'
    );

-- DELETE
-- Remove a stock entry
DELETE FROM Stocks WHERE Company = 'Tesla Inc.';

-- UPDATE
-- Update balance for a specific account
UPDATE Accounts SET Balance = Balance + 1000 WHERE SIN = '123456789';

-- SELECTION
-- Find all accounts with a balance greater than 1000
SELECT * FROM Accounts WHERE Balance > 1000;

-- PROJECTION
-- Find distinct industries of investments
SELECT DISTINCT Industry FROM Investments;

-- JOIN
-- Select all investments made by a particular account
SELECT I.*
FROM Investments I
    JOIN Contains C ON I.InvestmentID = C.InvestmentID
WHERE
    C.SIN = '123456789';

-- AGGREGATION WITH GROUP BY
-- Find the total quantity of investments by industry
SELECT Industry, SUM(Quantity) AS TotalQuantity
FROM Investments
GROUP BY
    Industry;

-- AGGREGATION WITH GROUP BY AND HAVING
-- Find industries where the total quantity of investments exceeds 1000
SELECT Industry, SUM(Quantity) AS TotalQuantity
FROM Investments
GROUP BY
    Industry
HAVING
    SUM(Quantity) > 1000;

-- NESTED AGGREGATION
-- Find the maximum average quantity of investments across all industries
SELECT MAX(AvgQuantity) AS MaxAvgQuantity
FROM (
        SELECT Industry, AVG(Quantity) AS AvgQuantity
        FROM Investments
        GROUP BY
            Industry
    ) SubQuery;

-- DIVISION
-- selects accounts that have investments in both specified industries
SELECT SIN
FROM Accounts
WHERE
    SIN IN (
        SELECT C.SIN
        FROM Contains C
            JOIN Investments I ON C.InvestmentID = I.InvestmentID
        WHERE
            I.Industry = 'Technology'
    ) INTERSECT
SELECT SIN
FROM Accounts
WHERE
    SIN IN (
        SELECT C.SIN
        FROM Contains C
            JOIN Investments I ON C.InvestmentID = I.InvestmentID
        WHERE
            I.Industry = 'Finance'
    );