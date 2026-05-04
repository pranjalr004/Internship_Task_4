SELECT s.name, ROUND(AVG(e.grade), 2) AS avg_grade
FROM enrollments e
JOIN students s ON e.student_id = s.id
GROUP BY s.id, s.name
ORDER BY avg_grade DESC
LIMIT 3;