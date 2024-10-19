-- 1. 查询所有学生的信息。
SELECT s.*
FROM student s;

-- 2. 查询所有课程的信息。
SELECT c.*
FROM course c;

-- 3. 查询所有学生的姓名、学号和班级。
SELECT s.name,s.student_id,s.my_class 
FROM student s;

-- 4. 查询所有教师的姓名和职称。
SELECT name,title
FROM teacher;

-- 5. 查询不同课程的平均分数。
SELECT sc.course_id,AVG(sc.score) 平均分数
FROM score sc
GROUP BY sc.course_id;

-- 6. 查询每个学生的平均分数。
SELECT s.name,AVG(sc.score) 平均分数
FROM student s,score sc
WHERE s.student_id=sc.student_id
GROUP BY s.student_id;

-- 7. 查询分数大于85分的学生学号和课程号。
SELECT student_id,course_id
FROM score sc
WHERE sc.score>85; 

-- 8. 查询每门课程的选课人数。
SELECT c.course_name,COUNT(sc.student_id) 选课人数
FROM course c,score sc
WHERE c.course_id=sc.course_id
GROUP BY sc.course_id;

-- 9. 查询选修了"高等数学"课程的学生姓名和分数。
SELECT name,score
FROM student,course,score
WHERE student.student_id=score.student_id AND score.course_id=course.course_id AND course_name='高等数学';

-- 10. 查询没有选修"大学物理"课程的学生姓名。
SELECT s.name
FROM student s
WHERE s.student_id NOT IN (
    SELECT sc.student_id
    FROM score sc
    JOIN course c ON sc.course_id = c.course_id
    WHERE c.course_name = '大学物理');

-- 11. 查询C001比C002课程成绩高的学生信息及课程分数。
SELECT s.*,sc1.score c1,sc2.score c2
FROM student s
JOIN score sc1 ON s.student_id = sc1.student_id
JOIN score sc2 ON s.student_id = sc2.student_id
WHERE sc1.course_id = 'C001' AND sc2.course_id = 'C002' AND sc1.score > sc2.score;

-- 12. 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0] 及所占百分比
SELECT 
    c.course_id,
    c.course_name,
    SUM(CASE WHEN sc.score BETWEEN 85 AND 100 THEN 1 ELSE 0 END) AS '85-100',
    SUM(CASE WHEN sc.score BETWEEN 70 AND 84 THEN 1 ELSE 0 END) AS '70-84',
    SUM(CASE WHEN sc.score BETWEEN 60 AND 69 THEN 1 ELSE 0 END) AS '60-69',
    SUM(CASE WHEN sc.score BETWEEN 0 AND 59 THEN 1 ELSE 0 END) AS '0-59',
    ROUND(SUM(CASE WHEN sc.score BETWEEN 85 AND 100 THEN 1 ELSE 0 END) / COUNT(sc.score) * 100, 2) AS '85-100百分比',
    ROUND(SUM(CASE WHEN sc.score BETWEEN 70 AND 84 THEN 1 ELSE 0 END) / COUNT(sc.score) * 100, 2) AS '70-84百分比',
    ROUND(SUM(CASE WHEN sc.score BETWEEN 60 AND 69 THEN 1 ELSE 0 END) / COUNT(sc.score) * 100, 2) AS '60-69百分比',
    ROUND(SUM(CASE WHEN sc.score BETWEEN 0 AND 59 THEN 1 ELSE 0 END) / COUNT(sc.score) * 100, 2) AS '0-59百分比'
FROM 
    course c
JOIN 
    score sc ON c.course_id = sc.course_id
GROUP BY 
    c.course_id;

-- 13. 查询选择C002课程但没有选择C004课程的成绩情况(不存在时显示为 null )。
SELECT s.student_id, s.name, sc2.score AS C002_score, sc4.score AS C004_score
FROM student s
LEFT JOIN score sc2 ON s.student_id = sc2.student_id AND sc2.course_id = 'C002'
LEFT JOIN score sc4 ON s.student_id = sc4.student_id AND sc4.course_id = 'C004'
WHERE sc2.course_id IS NOT NULL AND sc4.course_id IS NULL;

-- 14. 查询平均分数最高的学生姓名和平均分数。
SELECT s.name, AVG(sc.score) AS average_score
FROM student s
JOIN score sc ON s.student_id = sc.student_id
GROUP BY s.student_id
ORDER BY average_score DESC
LIMIT 1;

-- 15. 查询总分最高的前三名学生的姓名和总分。
SELECT s.name, SUM(sc.score) AS total_score
FROM student s
JOIN score sc ON s.student_id = sc.student_id
GROUP BY s.student_id
ORDER BY total_score DESC
LIMIT 3;

-- 16.  查询所有课程分数都高于85分的学生姓名。
SELECT s.name
FROM student s
JOIN score sc ON s.student_id = sc.student_id
GROUP BY s.student_id, s.name
HAVING MIN(sc.score) > 85;

-- 17. 查询男生和女生的人数。
SELECT gender, COUNT(*) AS 人数
FROM student
GROUP BY gender;

-- 18. 查询年龄最大的学生姓名。
SELECT s.name
FROM student s
ORDER BY s.birth_date ASC
LIMIT 1;

-- 19. 查询年龄最小的教师姓名。
SELECT name
FROM teacher
ORDER BY birth_date DESC
LIMIT 1;

-- 20. 查询学过「张教授」授课的同学的信息。
SELECT DISTINCT s.*
FROM student s
JOIN score sc ON s.student_id = sc.student_id
JOIN course c ON sc.course_id = c.course_id
WHERE c.teacher_id = (SELECT teacher_id FROM teacher WHERE name='张教授');

-- 21. 查询查询至少有一门课与学号为"2021001"的同学所学相同的同学的信息 。
SELECT DISTINCT s.*
FROM student s
JOIN score sc1 ON s.student_id = sc1.student_id
WHERE sc1.course_id IN (SELECT course_id FROM score WHERE student_id = '2021001') AND s.student_id != '2021001';

-- 22. 查询每门课程的平均分数，并按平均分数降序排列。
SELECT c.course_name, AVG(sc.score) AS average_score
FROM course c
LEFT JOIN score sc ON c.course_id = sc.course_id
GROUP BY c.course_id, c.course_name
ORDER BY average_score DESC;

-- 23. 查询学号为"2021001"的学生所有课程的分数。
SELECT c.course_name, sc.score
FROM score sc
JOIN course c ON sc.course_id = c.course_id
WHERE sc.student_id = '2021001';

-- 24. 查询所有学生的姓名、选修的课程名称和分数。
SELECT s.name, c.course_name, sc.score
FROM student s
JOIN score sc ON s.student_id = sc.student_id
JOIN course c ON sc.course_id = c.course_id;

-- 25. 查询每个教师所教授课程的平均分数。
SELECT t.name, AVG(sc.score) AS 平均分数
FROM teacher t
JOIN course c ON t.teacher_id = c.teacher_id
JOIN score sc ON c.course_id = sc.course_id
GROUP BY t.teacher_id, t.name;

-- 26. 查询分数在80到90之间的学生姓名和课程名称。
SELECT s.name, c.course_name
FROM student s
JOIN score sc ON s.student_id = sc.student_id
JOIN course c ON sc.course_id = c.course_id
WHERE sc.score BETWEEN 80 AND 90;

-- 27. 查询每个班级的平均分数。
SELECT s.my_class, AVG(sc.score) AS 平均分数
FROM student s
JOIN score sc ON s.student_id = sc.student_id
GROUP BY s.my_class;

-- 28. 查询没学过"王讲师"老师讲授的任一门课程的学生姓名。
SELECT s.name
FROM student s
WHERE s.student_id NOT IN (
    SELECT sc.student_id
    FROM score sc
    JOIN course c ON sc.course_id = c.course_id
    WHERE c.teacher_id = (SELECT teacher_id FROM teacher WHERE name='王讲师'));

-- 29. 查询两门及其以上小于85分的同学的学号，姓名及其平均成绩 。
SELECT s.student_id, s.name, AVG(sc.score) AS 平均成绩
FROM student s
JOIN score sc ON s.student_id = sc.student_id
WHERE sc.score < 85
GROUP BY s.student_id
HAVING COUNT(sc.course_id) >= 2;

-- 30. 查询所有学生的总分并按降序排列。
SELECT s.name, SUM(sc.score) AS total_score
FROM student s
JOIN score sc ON s.student_id = sc.student_id
GROUP BY s.student_id
ORDER BY total_score DESC;

-- 31. 查询平均分数超过85分的课程名称。
SELECT c.course_name
FROM course c
JOIN score sc ON c.course_id = sc.course_id
GROUP BY c.course_id
HAVING AVG(sc.score) > 85;

-- 32. 查询每个学生的平均成绩排名。
SELECT s.name, AVG(sc.score) AS 平均成绩,
       RANK() OVER (ORDER BY AVG(sc.score) DESC) AS 排名
FROM student s
JOIN score sc ON s.student_id = sc.student_id
GROUP BY s.student_id;

-- 33. 查询每门课程分数最高的学生姓名和分数。
SELECT c.course_name,s.name,sc.score
FROM score sc
JOIN course c ON sc.course_id = c.course_id
JOIN student s ON sc.student_id = s.student_id
WHERE (c.course_id, sc.score) IN (SELECT course_id, MAX(score) FROM score GROUP BY course_id);

-- 34. 查询选修了"高等数学"和"大学物理"的学生姓名。
SELECT s.name
FROM student s
JOIN score sc1 ON s.student_id = sc1.student_id
JOIN course c1 ON sc1.course_id = c1.course_id
JOIN score sc2 ON s.student_id = sc2.student_id
JOIN course c2 ON sc2.course_id = c2.course_id
WHERE c1.course_name = '高等数学' AND c2.course_name = '大学物理';

-- 35. 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩（没有选课则为空）。
SELECT s.name,c.course_name,sc.score,AVG(sc.score) OVER (PARTITION BY s.student_id) AS avg_score
FROM student s
LEFT JOIN score sc ON s.student_id = sc.student_id
LEFT JOIN course c ON sc.course_id = c.course_id
ORDER BY avg_score DESC;

-- 36. 查询分数最高和最低的学生姓名及其分数。
SELECT s.name, sc.score
FROM student s
JOIN score sc ON s.student_id = sc.student_id
WHERE sc.score = (SELECT MAX(score) FROM score) OR sc.score = (SELECT MIN(score) FROM score);

-- 37. 查询每个班级的最高分和最低分。
SELECT s.my_class, MAX(sc.score) AS 最高分, MIN(sc.score) AS 最低分
FROM student s
JOIN score sc ON s.student_id = sc.student_id
GROUP BY s.my_class;

-- 38. 查询每门课程的优秀率（优秀为90分）。
SELECT c.course_name,SUM(CASE WHEN sc.score >= 90 THEN 1 ELSE 0 END) / COUNT(sc.score) * 100 AS 优秀率
FROM course c
LEFT JOIN score sc ON c.course_id = sc.course_id
GROUP BY c.course_id;

-- 39. 查询平均分数超过班级平均分数的学生。
SELECT s.*,AVG(sc.score) AS p_avg_sc,AVG(avg_class_score) AS c_avg_sc
FROM student s
JOIN score sc ON s.student_id = sc.student_id
JOIN (SELECT my_class, AVG(score) AS avg_class_score FROM student st JOIN score scr ON st.student_id = scr.student_id GROUP BY my_class)
			AS class_avg ON s.my_class = class_avg.my_class
GROUP BY s.student_id
HAVING p_avg_sc>c_avg_sc;

-- 40. 查询每个学生的分数及其与课程平均分的差值。
SELECT s.name,c.course_name,
       (sc.score - avg_score) AS 差值
FROM score sc
JOIN student s ON sc.student_id = s.student_id
JOIN course c ON sc.course_id = c.course_id
JOIN (SELECT course_id, AVG(score) AS avg_score FROM score GROUP BY course_id) AS avg_scores ON sc.course_id = avg_scores.course_id;
