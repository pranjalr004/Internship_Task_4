SELECT s.name, COUNT(e.course_id) AS courses_enrolled
FROM enrollments e
JOIN students s ON e.student_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(e.course_id) > 2;