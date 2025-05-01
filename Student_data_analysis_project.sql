-- Student Data Analysis SQL Project

CREATE DATABASE student_project_db;

-- Create table
CREATE TABLE student_data
(
      student_id VARCHAR(20) PRIMARY KEY,
      first_name VARCHAR(50),
      last_name VARCHAR(50),
      email VARCHAR(50),
      gender VARCHAR(10),
      age INT,
      department VARCHAR(20),
      attendance DOUBLE,
      midterm_score DOUBLE,
      final_score DOUBLE,
      assignment_avg DOUBLE,
      quizzes_avg DOUBLE,
      participation_score DOUBLE,
      project_score DOUBLE,
      total_score DOUBLE,
      grade VARCHAR(10),
      study_hours_per_week DOUBLE,
      extracurricular_activities VARCHAR(10),
      internet_access_at_home VARCHAR(10),
      parent_education_level VARCHAR(50),
      family_income_level VARCHAR(10),
      stress_level INT,
      sleep_hours_per_night DOUBLE
);

SELECT * FROM student_data
LIMIT 100 ;

SELECT COUNT(*)
FROM student_data ;

-- Data cleaning

-- Finding records with any null values
SELECT * 
FROM student_data
WHERE
    student_id IS NOT NULL
    AND 
    first_name IS NOT NULL
    AND 
    last_name IS NOT NULL
    AND
    email IS NOT NULL
    AND
    gender IS NOT NULL
    AND
    age IS NOT NULL
    AND
    department IS NOT NULL
    AND
    attendance IS NOT NULL
    AND
    midterm_score IS NOT NULL
    AND
    final_score IS NOT NULL
    AND
    assignment_avg IS NOT NULL
    AND
    quizzes_avg IS NOT NULL
    AND
    participation_score IS NOT NULL
    AND
    project_score IS NOT NULL
    AND
    total_score IS NOT NULL
    AND
    grade IS NOT NULL
    AND
    study_hours_per_week IS NOT NULL
    AND
    extracurricular_activities IS NOT NULL 
    AND
    internet_access_at_home IS NOT NULL
    AND
    parent_education_level IS NOT NULL
    AND
    family_income_level IS NOT NULL
    AND
    stress_level IS NOT NULL
    AND
    sleep_hours_per_night IS NOT NULL ;

-- Creating student_data_valid table
CREATE TABLE student_data_valid as
SELECT * 
FROM student_data
WHERE
    student_id IS NOT NULL
    AND 
    first_name IS NOT NULL
    AND 
    last_name IS NOT NULL 
    AND
    email IS NOT NULL
    AND
    gender IS NOT NULL
    AND
    age IS NOT NULL
    AND
    department IS NOT NULL
    AND
    attendance IS NOT NULL
    AND
    midterm_score IS NOT NULL
    AND
    final_score IS NOT NULL
    AND
    assignment_avg IS NOT NULL
    AND
    quizzes_avg IS NOT NULL
    AND
    participation_score IS NOT NULL
    AND
    project_score IS NOT NULL
    AND
    total_score IS NOT NULL
    AND
    grade IS NOT NULL
    AND
    study_hours_per_week IS NOT NULL
    AND
    extracurricular_activities IS NOT NULL 
    AND
    internet_access_at_home IS NOT NULL 
    AND
    parent_education_level IS NOT NULL
    AND
    family_income_level IS NOT NULL
    AND
    stress_level IS NOT NULL
    AND
    sleep_hours_per_night IS NOT NULL ;

SELECT COUNT(*) FROM student_data_valid ;

-- Creating student_data_invalid table

CREATE TABLE student_data_invalid as
SELECT * 
FROM student_data
WHERE
    student_id IS NULL
    OR 
    first_name IS NULL
    OR 
    last_name IS NULL
    OR
    email IS NULL
    OR
    gender IS NULL
    OR
    age IS NULL
    OR
    department IS NULL
    OR
    attendance IS NULL
    OR
    midterm_score IS NULL
    OR
    final_score IS NULL
    OR
    assignment_avg IS NULL
    OR
    quizzes_avg IS NULL
    OR
    participation_score IS NULL
    OR
    project_score IS NULL
    OR
    total_score IS NULL
    OR
    grade IS NULL
    OR
    study_hours_per_week IS NULL
    OR
    extracurricular_activities IS NULL 
    OR
    internet_access_at_home IS NULL 
    OR
    parent_education_level IS NULL
    OR
    family_income_level IS NULL
    OR
    stress_level IS NULL
    OR
    sleep_hours_per_night IS NULL ;

SELECT COUNT(*) FROM student_data_invalid;

-- Data Analysis & Findings
-- 1. SQL query to find total student in each department (valid & invalid data both):

SELECT
     department,
     COUNT(*) AS total_student 
FROM student_data_valid
GROUP BY department
order BY total_student DESC;

SELECT
     department,
     COUNT(*) AS total_student 
FROM student_data_invalid
GROUP BY department
order BY total_student DESC;

-- 2. SQL query to find out total student gender wise in each department:

SELECT
      department,
      gender,
      COUNT(*) AS total_student
FROM student_data_valid
GROUP BY department, gender
ORDER BY department;

-- 3. SQL query to find top 5 rank holders of each dept gender wise:

WITH department_toppers AS (
    SELECT
        student_id,
        first_name,
        last_name,
        gender,
        department,
        total_score,
        rank() OVER(PARTITION BY department, gender 
                    ORDER BY total_score desc )
         AS rank_in_dept
      FROM student_data_valid
)
SELECT *
FROM department_toppers
WHERE rank_in_dept BETWEEN 1 AND 5 
ORDER BY department; 

-- 4. SQL query for finding students with attendance lower than 60% dept wise:

SELECT 
      department,
      student_id,
      first_name,
      last_name,
      gender,
      email,
      attendance
FROM student_data_valid
WHERE attendance < 60
ORDER BY department, attendance ASC ;

SELECT 
      department,
      COUNT(*) AS low_attendance_students
FROM student_data_valid
WHERE attendance < 60
GROUP BY department
ORDER BY low_attendance_students DESC;

-- 5. SQL query to generate attendance warning list of CS dept:

SELECT 
      student_id,
      CONCAT(first_name, ' ', last_name) AS full_name,
      department,
      email,
      attendance,
      case
          when attendance < 55 then 'Critical warning'
          when attendance < 65 then 'Warning'
          
      END AS attendance_status
FROM student_data_valid
WHERE department = 'CS' AND attendance < 65
ORDER BY attendance;

-- 6. SQL query for updating grades according to total marks:
UPDATE student_data_valid
SET grade = case
    when total_score >= 90 then 'A'
    when total_score >= 80 then 'B'
    when total_score >= 70 then 'C'
    when total_score >= 60 then 'D'
    ELSE 'F'
END ;

-- 7. SQL query for student performance overview:

SELECT
      student_id,
      CONCAT( first_name , ' ', last_name ) AS full_name,
      department,
      total_score,
      grade,
      attendance
FROM student_data_valid
ORDER BY total_score DESC ;

-- 8. SQL query for dept wise performance analysis:

SELECT
      department,
      COUNT(*) AS total_student,
      ROUND(AVG(total_score), 2) AS avg_score,
      ROUND(AVG(attendance), 2) AS avg_attendance,
      ROUND(AVG(study_hours_per_week), 2) AS avg_study_hours
FROM student_data_valid
GROUP BY department
ORDER BY avg_score DESC ;

-- 9. SQL query to find stress level corelation:

SELECT
      stress_level,
      COUNT(*) AS total_students,
      ROUND(AVG(total_score), 2) AS avg_score,
      ROUND(AVG(sleep_hours_per_night), 2) AS avg_sleep_hours,
      ROUND(AVG(study_hours_per_week), 2) AS avg_study_hours
FROM student_data_valid
GROUP BY stress_level
ORDER BY stress_level ;

-- 10. SQL query to find avg marks of students department wise with internet access and no access at home:

SELECT department,
       internet_access_at_home,
       COUNT(*) AS total_students,
       ROUND(AVG(total_score), 2) AS average_score
FROM student_data_valid
GROUP BY department, internet_access_at_home 
ORDER BY department ;