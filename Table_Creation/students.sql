CREATE TABLE students(
    id INT PRIMARY KEY,
    name VARCHAR(100),
    gender VARCHAR(10)
);

CREATE TABLE courses(
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE enrollments(
    id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade INT,
    semester VARCHAR(20)
);

