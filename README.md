# Task 4: Student Database Management System

## Project Overview
This project implements a comprehensive student database system that manages student information, courses, and enrollments. The system tracks student grades across multiple semesters and provides various analytical queries to generate insights about academic performance.

---

## Database Setup

### Step 1: Create Database
**File:** `Database_Creation/database.sql`

```sql
create DATABASE student;
USE student;
```

**Explanation:** 
- Creates a new database named `student`
- Selects the `student` database for use in subsequent operations

---

### Step 2: Create Tables
**File:** `Table_Creation/students.sql`

```sql
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
```

**Explanation:**
- **students table**: Stores student information with unique ID, name, and gender
- **courses table**: Stores course information with unique ID and course name
- **enrollments table**: Tracks which students are enrolled in which courses, their grades, and semester information

---

### Step 3: Insert Sample Data
**File:** `Table_Creation/Rows_insertion.sql`

```sql
INSERT INTO students VALUES
(1,'Alice','Female'),(2,'Bob','Male'),(3,'Carol','Female'),
(4,'David','Male'),(5,'Eva','Female'),(6,'Frank','Male');

INSERT INTO courses VALUES
(1,'Mathematics'),(2,'Science'),(3,'English'),(4,'History');

INSERT INTO enrollments VALUES
(1,1,1,85,'Semester 1'),(2,1,2,78,'Semester 1'),(3,1,3,92,'Semester 1'),
(4,2,1,35,'Semester 1'),(5,2,2,55,'Semester 1'),
(6,3,1,70,'Semester 1'),(7,3,3,88,'Semester 1'),(8,3,4,65,'Semester 1'),
(9,4,2,45,'Semester 1'),(10,4,3,30,'Semester 1'),
(11,5,1,95,'Semester 1'),(12,5,4,80,'Semester 1'),
(13,6,1,60,'Semester 1'),(14,6,2,72,'Semester 1'),(15,6,3,50,'Semester 1'),
(16,1,1,90,'Semester 2'),
(17,2,1,60,'Semester 2'),
(18,3,3,95,'Semester 2'),
(19,4,2,70,'Semester 2'),
(20,5,1,98,'Semester 2'),
(21,6,2,80,'Semester 2');
```

**Explanation:**
- Inserts 6 students (Alice, Bob, Carol, David, Eva, Frank)
- Inserts 4 courses (Mathematics, Science, English, History)
- Inserts 21 enrollment records with grades for Semester 1 and Semester 2

---

## Analytical Queries

### Query 1: Average Grade by Gender
**File:** `Queries/Average_Grade_by_gender.sql`

```sql
SELECT s.gender, ROUND(AVG(e.grade), 2) AS avg_grade
FROM students s
JOIN enrollments e ON s.id = e.student_id
GROUP BY s.gender;
```

**Explanation:**
- Calculates the average grade for each gender
- Uses `JOIN` to connect students with their enrollments
- Uses `GROUP BY` to group results by gender
- `ROUND()` function rounds the average to 2 decimal places
- **Purpose:** Compare academic performance between male and female students

**Expected Output:**
| gender | avg_grade |
|--------|-----------|
| Female | 82.40     |
| Male   | 54.17     |

---

### Query 2: Pass Rate Per Course
**File:** `Queries/Pass_Rate_Per_Course.sql`

```sql
SELECT c.name AS course,
       ROUND(SUM(CASE WHEN e.grade >= 40 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pass_rate
FROM enrollments e
JOIN courses c ON e.course_id = c.id
GROUP BY c.name;
```

**Explanation:**
- Calculates the pass rate (percentage of students who scored >= 40) for each course
- Uses `CASE WHEN` statement to count passing grades (>= 40)
- Multiplies by 100 and divides by total count to get percentage
- Uses `ROUND()` to display percentage with 2 decimal places
- **Purpose:** Identify which courses have higher or lower student success rates

**Expected Output:**
| course      | pass_rate |
|-------------|-----------|
| Mathematics | 83.33     |
| Science     | 66.67     |
| English     | 60.00     |
| History     | 100.00    |

---

### Query 3: Top 3 Students
**File:** `Queries/Top_3_Students.sql`

```sql
SELECT s.name, ROUND(AVG(e.grade), 2) AS avg_grade
FROM enrollments e
JOIN students s ON e.student_id = s.id
GROUP BY s.id, s.name
ORDER BY avg_grade DESC
LIMIT 3;
```

**Explanation:**
- Identifies the top 3 performing students based on average grade
- Calculates average grade for each student across all enrollments
- Uses `ORDER BY ... DESC` to sort by highest average grade first
- Uses `LIMIT 3` to retrieve only the top 3 records
- **Purpose:** Recognize high-performing students

**Expected Output:**
| name | avg_grade |
|------|-----------|
| Eva  | 93.00     |
| Alice| 86.75     |
| Carol| 82.00     |

---

### Query 4: Students Enrolled in Multiple Courses
**File:** `Queries/Students_Enrolled_in_Multiple_Course.sql`

```sql
SELECT s.name, COUNT(e.course_id) AS courses_enrolled
FROM enrollments e
JOIN students s ON e.student_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(e.course_id) > 2;
```

**Explanation:**
- Lists students who are enrolled in more than 2 courses
- Uses `COUNT()` to count the number of course enrollments per student
- Uses `HAVING` clause (filters after grouping) to show only students with > 2 enrollments
- Note: `HAVING` is used instead of `WHERE` because we filter on aggregated data
- **Purpose:** Identify students with heavy course loads

**Expected Output:**
| name  | courses_enrolled |
|-------|------------------|
| Alice | 4                |
| Carol | 4                |
| Frank | 3                |

---

### Query 5: Improvement Report
**File:** `Queries/Improvement_Report.sql`

```sql
SELECT e1.student_id, s.name,
       e1.grade AS grade_sem1, e2.grade AS grade_sem2
FROM enrollments e1
JOIN enrollments e2 ON e1.student_id = e2.student_id
                    AND e2.semester = 'Semester 2'
JOIN students s ON e1.student_id = s.id
WHERE e1.semester = 'Semester 1'
  AND e2.grade > e1.grade;
```

**Explanation:**
- Identifies students who improved their grades from Semester 1 to Semester 2
- Uses two `JOIN` operations on the enrollments table to match same course enrollments across semesters
- Filters where Semester 2 grade (e2.grade) is greater than Semester 1 grade (e1.grade)
- Shows student ID, name, and grades from both semesters
- **Purpose:** Track student academic improvement and progress

**Expected Output:**
| student_id | name  | grade_sem1 | grade_sem2 |
|------------|-------|------------|------------|
| 1          | Alice | 85         | 90         |
| 2          | Bob   | 35         | 60         |
| 4          | David | 45         | 70         |
| 5          | Eva   | 95         | 98         |

---

## How to Use This Project

### Prerequisites
- MySQL Server installed and running
- MySQL client or any MySQL IDE (MySQL Workbench, DBeaver, etc.)

### Execution Steps

1. **Create the database:**
   - Execute `Database_Creation/database.sql`

2. **Create the tables:**
   - Execute `Table_Creation/students.sql`

3. **Insert sample data:**
   - Execute `Table_Creation/Rows_insertion.sql`

4. **Run queries:**
   - Execute individual query files from the `Queries/` folder as needed

### Alternative: Run Everything at Once
You can combine all files and execute them in sequence:
```
Database_Creation/database.sql
→ Table_Creation/students.sql
→ Table_Creation/Rows_insertion.sql
→ Queries/*.sql
```

---

## Project Structure

```
Internship_Task_4/
├── Database_Creation/
│   └── database.sql
├── Table_Creation/
│   ├── students.sql
│   └── Rows_insertion.sql
├── Queries/
│   ├── Average_Grade_by_gender.sql
│   ├── Pass_Rate_Per_Course.sql
│   ├── Top_3_Students.sql
│   ├── Students_Enrolled_in_Multiple_Course.sql
│   └── Improvement_Report.sql
└── README.md
```

---

## Key Concepts Demonstrated

- **SQL Joins:** Connecting multiple tables to retrieve related data
- **Aggregation Functions:** AVG(), COUNT(), SUM() for data analysis
- **GROUP BY & HAVING:** Grouping data and filtering aggregated results
- **CASE WHEN:** Conditional logic in SELECT statements
- **Subqueries:** Joining tables on multiple conditions
- **Data Filtering:** Using WHERE and HAVING clauses effectively
- **Sorting & Limiting:** ORDER BY and LIMIT for result control
- **Rounding:** Formatting numeric output with ROUND()

---

## Grading Scale

The database uses the following grading scale:
- **Pass:** Grade >= 40
- **Fail:** Grade < 40

---

## Sample Data Overview

### Students
- 6 students: Alice, Bob, Carol, David, Eva, Frank
- 3 Female: Alice, Carol, Eva
- 3 Male: Bob, David, Frank

### Courses
- 4 courses: Mathematics, Science, English, History

### Enrollment Data
- 21 enrollment records (Semester 1 and Semester 2)
- Each student is enrolled in 3-4 courses

---

## Notes

- All grades are stored as integers (0-100)
- The database supports multiple semesters (Semester 1, Semester 2, etc.)
- Student IDs and Course IDs are unique primary keys
- The system can be easily extended with additional semesters or students

---

**Created:** May 5, 2026  
**Task:** Database Management System with Analytical Queries
