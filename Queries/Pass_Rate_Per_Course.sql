SELECT c.name AS course,
       ROUND(SUM(CASE WHEN e.grade >= 40 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pass_rate
FROM enrollments e
JOIN courses c ON e.course_id = c.id
GROUP BY c.name;