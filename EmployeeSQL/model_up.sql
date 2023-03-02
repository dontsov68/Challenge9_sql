DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS titles;
DROP TABLE IF EXISTS salaries;

CREATE TABLE departments (
  dept_no character varying(45) NOT NULL,
  dept_name character varying(45) NOT NULL,
  PRIMARY KEY (dept_no)
);

CREATE TABLE titles (
  title_id character varying(45) NOT NULL,
  title character varying(45) NOT NULL,
  PRIMARY KEY (title_id)
);

CREATE TABLE employees (
  emp_no character varying(45),
  emp_title_id character varying(20) NOT NULL,
  birth_date date NOT NULL,
  first_name character varying(45) NOT NULL,
  last_name character varying(45) NOT NULL,
  sex character varying(10),
  hire_date date NOT NULL,
  --SET birth_date = date_format(str_to_date(**'%m/%d/%Y'**), **'%Y-%m-%d);
  --SET hire_date = date_format(str_to_date(**'%m/%d/%Y'**), **'%Y-%m-%d);
  PRIMARY KEY (emp_no),
  FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

CREATE TABLE dept_manager (
  dept_no character varying(45) NOT NULL,
  emp_no integer NOT NULL,
  FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
  FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE dept_emp (
  emp_no character varying(45),
  dept_no character varying(45) NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
  FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);


CREATE TABLE salaries (
  emp_no character varying(45),
  salary integer NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

--select *
--from dept_emp;

--List the employee number, last name, first name, sex, and salary of each employee.

SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
LEFT JOIN salaries s
ON s.emp_no = e.emp_no; 

--List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT e.first_name, e.last_name, e.hire_date
FROM employees e
WHERE (hire_date) BETWEEN '1986-01-01' AND '1986-12-31' 
--ORDER BY (hire_date) ASC; 

--List the manager of each department along with their department number, department name, employee number, last name, and first name.

SELECT  dm.emp_no, dm.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM dept_manager dm
INNER JOIN departments d
ON dm.dept_no = d.dept_no
LEFT JOIN employees e
ON e.emp_no=dm.emp_no;


--List the department number for each employee along with that employee’s employee number, 
--last name, first name, and department name.

SELECT  de.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name 
FROM dept_emp de
INNER JOIN departments d
ON de.dept_no = d.dept_no
INNER JOIN employees e
ON e.emp_no=de.emp_no;


--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

SELECT e.first_name, e.last_name, e.sex
FROM employees e
WHERE (first_name) = 'Hercules'
AND (last_name) LIKE 'B%';


--List each employee in the Sales department, including their employee number, last name, and first name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name 
FROM employees e
INNER JOIN dept_emp de
ON e.emp_no = de.emp_no
INNER JOIN departments d
ON de.dept_no=d.dept_no
WHERE (dept_name) = 'Sales';

--List each employee in the Sales and Development departments, including their 
--employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name 
FROM employees e
INNER JOIN dept_emp de
ON e.emp_no = de.emp_no
INNER JOIN departments d
ON de.dept_no=d.dept_no
WHERE (dept_name) = 'Sales' OR (dept_name) ='Development';

--List the frequency counts, in descending order, of all the employee last names 
--(that is, how many employees share each last name).


SELECT last_name, COUNT(last_name) AS "fam count"
FROM employees
GROUP BY last_name
ORDER BY "fam count" DESC; 
