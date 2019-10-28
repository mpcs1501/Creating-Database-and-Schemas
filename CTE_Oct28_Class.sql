USE Chinook;
GO

DECLARE @mytable TABLE (
    ManagerId int NOT NULL,
    Manager nvarchar(50),
    Manager_Title nvarchar(50)
)
;


INSERT INTO @mytable     
		
		SELECT DISTINCT e.ReportsTo as 'ManagerId'
					   ,m.FirstName + ' ' + m.LastName as 'Manager'
					   ,m.Title as 'Manager Title'
		FROM dbo.Employee e INNER JOIN dbo.Employee m
				ON e.ReportsTo = m.EmployeeId
;

--SELECT * from @mytable;


SELECT emp.EmployeeId as 'ID'
      ,emp.FirstName + ' ' + emp.LastName as 'Employee'
      ,emp.Title as 'Employee Title'
      ,(CASE
           WHEN tab.Manager is NULL THEN 'The Board'
           ELSE tab.Manager
       END)  as 'Manager'
      ,(CASE
           WHEN tab.Manager is NULL THEN 'Board of Directors'
           ELSE tab.[Manager_Title]
       END)  as 'Manager Title'
FROM dbo.Employee emp LEFT OUTER JOIN @mytable tab
       ON emp.ReportsTo = tab.ManagerId
;
GO