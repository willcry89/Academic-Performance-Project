--- Reading the Data
SELECT * FROM academic_performance_dataset_v2
LIMIT 4000;

--- 1. What is the overall average CGPA of all students?
SELECT ROUND(AVG(cgpa),2) AS overall_avg_cgpa
FROM academic_performance_dataset_v2;

--- 2. What is the average CGPA for each program (Prog Code)?
SELECT `Prog Code`, ROUND(AVG(cgpa), 2) AS avg_cgpa, COUNT(*) AS student_count
FROM academic_performance_dataset_v2
GROUP BY `Prog Code`;

--- 3. What is the average CGPA by gender?
SELECT gender, ROUND(AVG(cgpa),2) AS avg_cgpa, COUNT(*) AS student_count
FROM academic_performance_dataset_v2
GROUP BY gender;

--- 4. How many students are enrolled in each program?
SELECT `Prog Code`, COUNT(*) AS total_students
FROM academic_performance_dataset_v2
GROUP BY `Prog Code`;

--- 5. Which program has the highest average final-year GPA (CGPA400)?
SELECT `Prog Code`, ROUND(AVG(cgpa400),2) AS avg_final_year_gpa
FROM academic_performance_dataset_v2
GROUP BY `Prog Code`
ORDER BY avg_final_year_gpa DESC
LIMIT 1;

--- 6. What is the GPA improvement for each student from their first year (CGPA100) to their final year (CGPA400)?
SELECT `ID no`, `Prog Code`, gender, ROUND((cgpa400 - cgpa100),2) AS gpa_improvement
FROM academic_performance_dataset_v2
LIMIT 4000;

--- 7. What is the average GPA improvement (CGPA400 - CGPA100) for each program?
SELECT `Prog Code`, ROUND(AVG(cgpa400 - cgpa100),2) AS avg_gpa_improvement
FROM academic_performance_dataset_v2
GROUP BY `Prog Code`;

--- 8. What percentage of students have an overall CGPA above 3.0?
SELECT ROUND((SUM(CASE WHEN cgpa > 3.0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) AS percentage_above_3
FROM academic_performance_dataset_v2;

--- 9. Is there a difference in average GPA improvement between genders?
SELECT gender, ROUND(AVG(cgpa400 - cgpa100),2) AS avg_gpa_improvement
FROM academic_performance_dataset_v2
GROUP BY gender;

--- 10. What are the trends in GPA across different academic stages (CGPA100, CGPA200, CGPA300, CGPA400)?
SELECT 'CGPA100' AS stage, ROUND(AVG(cgpa100),2) AS avg_gpa FROM academic_performance_dataset_v2
UNION ALL
SELECT 'CGPA200' AS stage, ROUND(AVG(cgpa200),2) AS avg_gpa FROM academic_performance_dataset_v2
UNION ALL
SELECT 'CGPA300' AS stage, ROUND(AVG(cgpa300),2) AS avg_gpa FROM academic_performance_dataset_v2
UNION ALL
SELECT 'CGPA400' AS stage, ROUND(AVG(cgpa400),2) AS avg_gpa FROM academic_performance_dataset_v2;

--- 11. How many students have shown consistent improvement across all years (CGPA100 < CGPA200 < CGPA300 < CGPA400)?
SELECT COUNT(*) AS consistent_improvers
FROM academic_performance_dataset_v2
WHERE cgpa100 < cgpa200 AND cgpa200 < cgpa300 AND cgpa300 < cgpa400;

--- 12. Which five students had the highest overall CGPA, and what are their programs and genders?
SELECT `ID no`, `Prog Code`, gender, cgpa
FROM academic_performance_dataset_v2
ORDER BY cgpa DESC
LIMIT 5;

--- 13. What is the average CGPA for each year of graduation (YoG)?
SELECT yog, ROUND(AVG(cgpa),2) AS avg_cgpa, COUNT(*) AS student_count
FROM academic_performance_dataset_v2
GROUP BY yog
ORDER BY yog;

--- 14a. What is the distribution of SGPA across different programs?
SELECT `Prog Code`, ROUND(AVG(sgpa),2) AS avg_sgpa, MIN(sgpa) AS min_sgpa, MAX(sgpa) AS max_sgpa, COUNT(*) AS student_count
FROM academic_performance_dataset_v2
GROUP BY `Prog Code`
ORDER BY `Prog Code`;

--- 14b. What is the distribution of SGPA across different genders?
SELECT gender, ROUND(AVG(sgpa),2) AS avg_sgpa, MIN(sgpa) AS min_sgpa, MAX(sgpa) AS max_sgpa, COUNT(*) AS student_count
FROM academic_performance_dataset_v2
GROUP BY gender;

--- 15. Which programs have the most high-performing students (CGPA > 3.5)?
SELECT `Prog Code`, COUNT(*) AS high_performers
FROM academic_performance_dataset_v2
WHERE cgpa > 3.5
GROUP BY `Prog Code`
ORDER BY high_performers DESC;
