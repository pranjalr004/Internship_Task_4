SELECT e1.student_id, s.name,
       e1.grade AS grade_sem1, e2.grade AS grade_sem2
FROM enrollments e1
JOIN enrollments e2 ON e1.student_id = e2.student_id
                    AND e2.semester = 'Semester 2'
JOIN students s ON e1.student_id = s.id
WHERE e1.semester = 'Semester 1'
  AND e2.grade > e1.grade;