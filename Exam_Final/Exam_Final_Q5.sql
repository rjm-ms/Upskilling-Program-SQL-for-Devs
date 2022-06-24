--SQL for Devs Finals 5/5
--5. Retrieve the Employee hierarchy under dbo.Staff. (6 pts)
--a. Select the staff’s full name (First Name + Last Name) plus the full name of its manager/s
--b. Display the top-level manager’s name first (comma separated)
--c. E.g. “Mireya Copeland” manager is “Fabiola Jackson“ so the result is “Fabiola Jackson, Mierya Copeland”
--d. Use only recursive CTE
WITH recursiveCTE AS (
SELECT	 s.StaffId
       , s.FirstName + ' ' + s.LastName AS FullName
       , 0 AS OrgLevel
       , CAST(s.FirstName + ' ' + s.LastName + ', 'AS VARCHAR(500)) AS EmployeeHierarchy
FROM     dbo.Staff s
WHERE    ManagerId IS NULL

UNION ALL

SELECT	 s.StaffId
       , s.FirstName + ' ' + s.LastName AS FullName
       , r.OrgLevel + 1
       , CAST(r.EmployeeHierarchy + s.FirstName + ' ' + s.LastName + ', ' AS VARCHAR(500))
FROM     dbo.Staff s
JOIN     recursiveCTE AS r ON s.ManagerId = r.StaffId 
)

SELECT	 cte.StaffId
       , cte.FullName
	   , CASE WHEN cte.EmployeeHierarchy LIKE '%,'
				THEN LEFT(cte.EmployeeHierarchy, LEN(cte.EmployeeHierarchy) - 1)
			  ELSE cte.EmployeeHierarchy 
		 END AS EmployeeHierarchy
FROM     recursiveCTE cte
ORDER BY cte.StaffId