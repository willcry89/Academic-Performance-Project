-- Rank programs by average final-year GPA improvement (CGPA400 - CGPA100)
WITH ProgramImprovement AS (
    SELECT 
        `Prog Code`, 
        ROUND(AVG(cgpa400 - cgpa100), 2) AS avg_improvement
    FROM academic_performance_dataset_v2
    GROUP BY `Prog Code`
)
SELECT 
    `Prog Code`, 
    avg_improvement,
    RANK() OVER (ORDER BY avg_improvement DESC) AS improvement_rank
FROM ProgramImprovement;

--- Compute running average of GPA improvement for each program over different years of graduation (YoG)
WITH AggregatedImprovements AS (
    SELECT 
        `Prog Code`, 
        yog,
        ROUND(AVG(cgpa400 - cgpa100), 2) AS avg_improvement
    FROM academic_performance_dataset_v2
    GROUP BY `Prog Code`, yog
),
RunningAvg AS (
    SELECT 
        `Prog Code`, 
        yog, 
        ROUND(AVG(avg_improvement) OVER (
             PARTITION BY `Prog Code` 
             ORDER BY yog 
             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
         ), 2) AS running_avg_improvement
    FROM AggregatedImprovements
)
SELECT DISTINCT
    `Prog Code`,
    yog,
    running_avg_improvement
FROM RunningAvg
ORDER BY `Prog Code`, yog
Limit 4000;

--- Identify the top 10% of students by overall GPA improvement (CGPA400 - CGPA100)
WITH StudentImprovement AS (
    SELECT 
        `ID no`, 
        `Prog Code`, 
        gender,
        (cgpa400 - cgpa100) AS gpa_improvement,
        cgpa100, 
        cgpa400,
        PERCENT_RANK() OVER (ORDER BY (cgpa400 - cgpa100) DESC) AS improvement_percentile
    FROM academic_performance_dataset_v2
)
SELECT 
    `ID no`, 
    `Prog Code`, 
    gender,
    ROUND(gpa_improvement, 2) AS gpa_improvement,
    cgpa100, 
    cgpa400,
    ROUND(improvement_percentile, 2) AS improvement_percentile
FROM StudentImprovement
WHERE improvement_percentile <= 0.10
ORDER BY gpa_improvement DESC
Limit 4000;

--- Calculate the variance in GPA improvement (CGPA400 - CGPA100) for each program
SELECT 
    `Prog Code`,
    ROUND(VAR_POP(cgpa400 - cgpa100), 2) AS improvement_variance,
    COUNT(*) AS student_count
FROM academic_performance_dataset_v2
GROUP BY `Prog Code`
ORDER BY improvement_variance DESC;

--- For each program, calculate the percentage of students who improved between each academic stage
SELECT 
    `Prog Code`,
    ROUND(AVG(CASE WHEN cgpa200 > cgpa100 THEN 1 ELSE 0 END) * 100, 2) AS pct_improved_100_to_200,
    ROUND(AVG(CASE WHEN cgpa300 > cgpa200 THEN 1 ELSE 0 END) * 100, 2) AS pct_improved_200_to_300,
    ROUND(AVG(CASE WHEN cgpa400 > cgpa300 THEN 1 ELSE 0 END) * 100, 2) AS pct_improved_300_to_400,
    ROUND(AVG(CASE WHEN cgpa400 > cgpa100 THEN 1 ELSE 0 END) * 100, 2) AS pct_improved_100_to_400
FROM academic_performance_dataset_v2
GROUP BY `Prog Code`
ORDER BY `Prog Code`;

Select * FROM academic_performance_dataset_v2
Limit 4000
