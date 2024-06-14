-- 01
-- PostgreSQL
--WITH RECURSIVE random_check_schedule (check_number, check_date) AS
--	(SELECT 1, CURRENT_DATE UNION ALL
--	SELECT check_number + 1, (SELECT check_date + (RANDOM() *(7-2) + 2)::INT)
--	FROM random_check_schedule WHERE check_number < 100)
--SELECT check_number, TO_CHAR(check_date, 'dd.mm.yyyy') AS check_date FROM random_check_schedule;
-- MS SQL Server
WITH random_check_schedule (check_number, check_date) AS
	(SELECT 1, GETDATE() UNION ALL
	SELECT check_number + 1, (SELECT dateadd(day, ABS(CHECKSUM(NEWID())) % 6 + 2, check_date))
	FROM random_check_schedule WHERE check_number < 100)
SELECT check_number, FORMAT(check_date, 'dd.MM.yyyy') AS check_date FROM random_check_schedule OPTION (MAXRECURSION 100);

-- 02
CREATE TABLE employee
(ID INT PRIMARY KEY IDENTITY(1, 1) NOT NULL,
Name VARCHAR(10));
INSERT INTO employee VALUES
('Ann'), ('Mick'), ('Joe'), ('Sarah'), ('Andrew'), ('Chloe'), ('Rose'), ('Scarlet'), ('George'), ('Vanessa');
SELECT * FROM employee;
CREATE TABLE sales
(ID INT PRIMARY KEY IDENTITY NOT NULL,
emp_id INT NOT NULL,
price INT NOT NULL,
FOREIGN KEY (emp_id) REFERENCES employee(ID));
INSERT INTO sales VALUES
(1, 20), (1, 24), (2, 17), (3, 31), (4, 18), (5, 16), (6, 29), (7, 50), (8, 35), (9, 26), (10, 37), 
(5, 14), (5, 20), (5, 11), (5, 19), (9, 22), (9, 31), (9, 26), (7, 11), (7, 17), (4, 29), (4, 37),
(6, 40), (8, 24), (2, 12), (2, 39);
SELECT * FROM sales ORDER BY emp_id;

SELECT e.ID, e.Name, 
COUNT(s.price) AS sales_count,
ROW_NUMBER() OVER (ORDER BY COUNT(s.price) DESC) AS sales_count_rownum,
RANK() OVER (ORDER BY COUNT(s.price) DESC) AS sales_count_rank,
DENSE_RANK() OVER (ORDER BY COUNT(s.price) DESC) AS sales_count_denserank,
SUM(s.price) AS sales_sum,
ROW_NUMBER() OVER (ORDER BY SUM(s.price) DESC) AS sales_sum_rank
FROM dbo.sales AS s
JOIN
dbo.employee AS e
ON s.emp_id = e.ID
GROUP BY e.ID, e.Name
ORDER BY sales_count DESC, sales_sum DESC;

-- 03
CREATE TABLE transfers
("from" INT, [to] INT, amount INT, tdate DATE);
SELECT * FROM transfers;
INSERT INTO transfers VALUES
(1, 2, 500, '2023.02.23'), (2, 3, 300, '2023.03.01'), (3, 1, 200, '2023.03.05'), (1, 3, 400, '2023.04.05');

SELECT 
[from] AS acc, 
FORMAT(tdate, 'dd.MM.yyyy') AS dt_from,
FORMAT(LEAD(tdate, 1, '3000.01.01') OVER (PARTITION BY "from" ORDER BY tdate), 'dd.MM.yyyy') AS dt_to,
SUM(amount) OVER (PARTITION BY "from" ORDER BY tdate) AS balance
FROM 
(SELECT [from], -amount AS amount, tdate FROM transfers
UNION ALL
SELECT [to], amount, tdate FROM transfers) AS res
ORDER BY acc;

