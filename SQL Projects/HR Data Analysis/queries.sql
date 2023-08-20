SELECT 
    e.first_name || ' ' || e.last_name AS employee,
    m.first_name || ' ' || m.last_name AS manager
FROM
    employees e
        INNER JOIN
    employees m ON m.employee_id = e.manager_id
ORDER BY manager;

SELECT 
    e.first_name || ' ' || e.last_name AS employee,
    m.first_name || ' ' || m.last_name AS manager
FROM
    employees e
        LEFT JOIN
    employees m ON m.employee_id = e.manager_id
ORDER BY manager

--------------- first_value()------------------------
SELECT
    first_name,
    last_name,
    salary,
    FIRST_VALUE (first_name) OVER (
        ORDER BY salary
    ) lowest_salary
FROM
    employees e;
	
SELECT
    first_name,
    last_name,
    department_name,
    salary,
    FIRST_VALUE (CONCAT(first_name,' ',last_name)) OVER (
        PARTITION BY department_name
        ORDER BY salary
    ) lowest_salary
FROM
    employees e
    INNER JOIN departments d 
        ON d.department_id = e.department_id;


