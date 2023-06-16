# Case Study 2

-- Create 'departments' table
```
CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);
```

-- Create 'employees' table
```
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    hire_date DATE,
    job_title VARCHAR(50),
    department_id INT REFERENCES departments(id)
);
```

-- Create 'projects' table
```
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    department_id INT REFERENCES departments(id)
);
```

-- Insert data into 'departments'
```
INSERT INTO departments (name, manager_id)
VALUES ('HR', 1), ('IT', 2), ('Sales', 3);
```

-- Insert data into 'employees'
```
INSERT INTO employees (name, hire_date, job_title, department_id)
VALUES ('John Doe', '2018-06-20', 'HR Manager', 1),
       ('Jane Smith', '2019-07-15', 'IT Manager', 2),
       ('Alice Johnson', '2020-01-10', 'Sales Manager', 3),
       ('Bob Miller', '2021-04-30', 'HR Associate', 1),
       ('Charlie Brown', '2022-10-01', 'IT Associate', 2),
       ('Dave Davis', '2023-03-15', 'Sales Associate', 3);
```

-- Insert data into 'projects'
```
INSERT INTO projects (name, start_date, end_date, department_id)
VALUES ('HR Project 1', '2023-01-01', '2023-06-30', 1),
       ('IT Project 1', '2023-02-01', '2023-07-31', 2),
       ('Sales Project 1', '2023-03-01', '2023-08-31', 3),
       ('HR Project 1', '2023-01-01', '2023-07-30', 1);
```

```
UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'John Doe')
WHERE name = 'HR';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Jane Smith')
WHERE name = 'IT';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Alice Johnson')
WHERE name = 'Sales';
```


-- SQL Challenge Questions

--1. Find the longest ongoing project for each department.

```
select name, max(end_date - start_date) total_days
from projects
group by name;
```

--2. Find all employees who are not managers.

```
select * from employees where id not in (select manager_id from departments);
```

--3. Find all employees who have been hired after the start of a project in their department.

```
with emp_Details as(
  select e.id emp_id, d.id dept_id, e.hire_date
  from employees e
  join departments d
  on e.department_id = d.id
),
project_details as(
  select d.id dept_id, p.id project_id, p.start_date
  from projects p
  join departments d
  on d.id = p.department_id
)
select distinct e.emp_id, p.dept_id, e.hire_date, p.start_date
from emp_Details e
join project_details p
on e.dept_id = p.dept_id
where e.hire_date  > p.start_date
order by p.dept_id;
```

--4. Rank employees within each department based on their hire date (earliest hire gets the highest rank).

```
select e.id emp_id, d.id dept_id, e.name, e.hire_date, d.name dept_name,
	   dense_rank() over (partition by e.department_id order by e.hire_date asc) as rank
from employees e
join departments d
on e.department_id = d.id
```

--5. Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department.

```
select e.id emp_id, d.id dept_id, e.name, e.hire_date, d.name dept_name,
	   e.hire_date - lag(e.hire_date) over (order_by e.hire_date) as join_diff_date
from employees e
join departments d
on e.department_id = d.id
--group by d.id
--order by d.id, e.id, e.hire_date

```