-- 1. 查询所有员工的姓名、邮箱和工作岗位。
SELECT CONCAT(e.first_name,' ',e.last_name) 姓名,email 邮箱,job_title 工作岗位
FROM employees e;

-- 2. 查询所有部门的名称和位置。
SELECT d.dept_name 部门名称,d.location 位置
FROM departments d;

-- 3. 查询工资超过70000的员工姓名和工资。
SELECT CONCAT(e.first_name,' ',e.last_name) 姓名,e.salary 工资
FROM employees e
WHERE e.salary>70000;

-- 4. 查询IT部门的所有员工。
SELECT *
FROM employees e
WHERE e.dept_id=(SELECT d.dept_id FROM departments d WHERE d.dept_name='IT'); 

-- 5. 查询入职日期在2020年之后的员工信息。
SELECT *
FROM employees e
WHERE YEAR(e.hire_date)>2020

-- 6. 计算每个部门的平均工资。
SELECT d.dept_name 部门,AVG(e.salary) 平均工资
FROM employees e,departments d
WHERE e.dept_id=d.dept_id
GROUP BY e.dept_id;

-- 7. 查询工资最高的前3名员工信息。
WITH rank_salary AS(
	SELECT e.*,
	RANK() over(ORDER BY e.salary DESC) AS rank_id
	FROM employees e
)
SELECT *
FROM rank_salary
WHERE rank_id<=3;

-- 8. 查询每个部门员工数量。
SELECT d.dept_name 部门,COUNT(e.emp_id) 数量
FROM employees e,departments d
WHERE d.dept_id=e.dept_id
GROUP BY e.dept_id;

-- 9. 查询没有分配部门的员工。
SELECT *
FROM employees e
WHERE e.dept_id is NULL;

-- 10. 查询参与项目数量最多的员工。
WITH rank_number AS (
    SELECT 
        ep.emp_id,
        COUNT(ep.project_id) AS number,
        RANK() OVER (ORDER BY COUNT(ep.project_id) DESC) AS number_rank
    FROM employee_projects ep
    GROUP BY ep.emp_id
)
SELECT e.*
FROM employees e
JOIN rank_number rn ON e.emp_id = rn.emp_id
WHERE rn.number_rank <= 1;

-- 11. 计算所有员工的工资总和。
SELECT SUM(e.salary) 工资总和
FROM employees e

-- 12. 查询姓"Smith"的员工信息。
SELECT e.*
FROM employees e
WHERE e.last_name='Smith';

-- 13. 查询即将在半年内到期的项目。
SELECT p.*
FROM projects p
WHERE p.end_date BETWEEN NOW() AND DATE_ADD(NOW(),INTERVAL 6 MONTH);

-- 14. 查询至少参与了两个项目的员工。
WITH pro_number AS(
	SELECT ep.emp_id,COUNT(ep.emp_id) total_projects
	FROM employee_projects ep
	GROUP BY ep.emp_id
)
SELECT e.*
FROM employees e
JOIN pro_number pn ON e.emp_id=pn.emp_id
WHERE pn.total_projects>=2;

-- 15. 查询没有参与任何项目的员工。
SELECT e.*
FROM employees e
WHERE e.emp_id NOT IN (SELECT ep.emp_id FROM employee_projects ep);

-- 16. 计算每个项目参与的员工数量。
SELECT p.project_name,COUNT(emp_id) 参与数量
FROM projects p,employee_projects ep
WHERE p.project_id=ep.project_id
GROUP BY ep.project_id;

-- 17. 查询工资第二高的员工信息。
WITH rank_em AS(
SELECT e.*,
RANK() over(ORDER BY e.salary) AS rank_salary
FROM employees e
)
SELECT e.*
FROM rank_em e
WHERE rank_salary=2;

-- 18. 查询每个部门工资最高的员工。
WITH rank_dp_high AS(
	SELECT e.*,
	RANK() over(PARTITION by e.dept_id ORDER BY e.salary) AS rank_first
	FROM employees e
)
SELECT *
FROM rank_dp_high
WHERE rank_first = 1;

-- 19. 计算每个部门的工资总和,并按照工资总和降序排列。
SELECT d.dept_name,SUM(e.salary) 工资总和
FROM employees e,departments d
WHERE e.dept_id=d.dept_id
GROUP BY d.dept_id
ORDER BY SUM(e.salary) DESC;

-- 20. 查询员工姓名、部门名称和工资。
SELECT CONCAT(e.first_name,' ',e.last_name) 姓名,d.dept_name 部门名称,e.salary 工资
FROM employees e,departments d
WHERE e.dept_id=d.dept_id;

-- 21. 查询每个员工的上级主管(假设emp_id小的是上级)。
SELECT CONCAT(e1.first_name,' ',e1.last_name) 员工,CONCAT(e1.first_name,' ',e1.last_name) 上级主管
FROM employees e1
LEFT JOIN employees e2 ON e1.dept_id = e2.dept_id AND e1.emp_id > e2.emp_id;

-- 22. 查询所有员工的工作岗位,不要重复。
SELECT DISTINCT CONCAT(e.first_name,' ',e.last_name) 员工,e.job_title 工作岗位
FROM employees e;

-- 23. 查询平均工资最高的部门。
WITH avg_salary AS(
	SELECT d.dept_name,avg(e.salary) avgs
	FROM employees e,departments d
	WHERE d.dept_id=e.dept_id
	GROUP BY e.dept_id
)
SELECT dept_name
FROM avg_salary
ORDER BY avgs DESC
LIMIT 1;

-- 24. 查询工资高于其所在部门平均工资的员工。
WITH avg_salary AS(
	SELECT d.dept_id,d.dept_name,avg(e.salary) avgs
	FROM employees e,departments d
	WHERE d.dept_id=e.dept_id
	GROUP BY e.dept_id
)
SELECT e.*
FROM employees e,avg_salary av
WHERE e.dept_id=av.dept_id AND e.salary>avgs;

-- 25. 查询每个部门工资前两名的员工。
WITH ranked_employees AS (
	 SELECT e.*, d.dept_name,
	 RANK() OVER(PARTITION BY e.dept_id ORDER BY e.salary DESC) AS salary_rank
	 FROM employees e
	 JOIN departments d ON e.dept_id = d.dept_id
)
SELECT *
FROM ranked_employees
WHERE salary_rank <= 2;
