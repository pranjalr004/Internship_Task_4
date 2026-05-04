SELECT s.gender, ROUND(AVG(e.grade), 2) AS avg_grade
FROM students s
JOIN enrollments e ON s.id = e.student_id
GROUP BY s.gender;