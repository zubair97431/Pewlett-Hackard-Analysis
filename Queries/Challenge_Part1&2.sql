--Challenge: Table 1
SELECT e.emp_no,
e.first_name,
e.last_name,
de.from_date,
s.salary,
s.to_date,
ti.title
INTO retiring_employees_by_title
FROM employees as e
	INNER JOIN salaries as s
		ON (e.emp_no = s.emp_no)
	INNER JOIN dept_manager as de
		ON (de.from_date = s.from_date)
	INNER JOIN titles as ti
		ON (e.emp_no = ti.emp_no)
Order BY e.emp_no;

-- Partition the data (show only most recent title per employee)
SELECT emp_no,
 first_name,
 last_name,
 salary,
 from_date,
 to_date,
 title
INTO p_retiring_employees_by_title
FROM
 (SELECT emp_no,
 first_name,
 last_name,
 salary,
 from_date,
 to_date,
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM retiring_employees_by_title
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM p_retiring_employees_by_title;

--Challenge: Table 2
SELECT e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.to_date
INTO eligible_birth_dates
FROM employees as e
	INNER JOIN dept_emp as de
	ON (de.emp_no = e.emp_no)
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01');

SELECT e.emp_no,
e.first_name,
e.last_name,
s.from_date,
e.to_date,
ti.title
INTO mentorship_eligibility 
FROM eligible_birth_dates as e
	INNER JOIN salaries as s 
		ON (e.emp_no = s.emp_no)
	INNER JOIN titles as ti
		ON (e.emp_no = ti.emp_no)
ORDER BY e.emp_no;

SELECT * FROM mentorship_eligibility;

--Partition Data(Remove Duplicates)
SELECT emp_no,
 first_name,
 last_name,
 from_date,
 to_date,
 title
INTO p_mentorship_eligibility
FROM 
 (SELECT emp_no,
 first_name,
 last_name,
 from_date,
 to_date, 
 title, ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM mentorship_eligibility
 ) tmp WHERE rn = 1
ORDER BY emp_no;

SELECT * FROM p_mentorship_eligibility; 