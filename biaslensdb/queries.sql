-- this file includes queries to see student demographics and article statistics

/*
This query returns the distribution of students across different majors c
*/
SELECT 
     s.major as major, 
     (COUNT(s.uid) / (SELECT (COUNT(*)) FROM student)) as percent_per_major, 
     COUNT(*) as count_per_major
FROM student s 
GROUP BY s.major;


-- display percentages by house
SELECT 
     s.house as house, 
     (COUNT(s.uid) / (SELECT (COUNT(*)) FROM student)) as percent_per_house, 
     COUNT(*) as count_per_house
FROM student s 
GROUP BY s.house;

-- display percentages by year of graduation
SELECT 
     s.grad_year as grad_year, 
     (COUNT(s.uid) / (SELECT (COUNT(*)) FROM student)) as percent_per_grad_year, 
     COUNT(*) as count_per_grad_year
FROM student s 
GROUP BY s.grad_year;

-- display pecentages by age
SELECT 
     s.age as age, 
     (COUNT(s.uid) / (SELECT (COUNT(*)) FROM student)) as percent_per_age, 
     COUNT(*) as count_per_age
FROM student s 
GROUP BY s.age
ORDER BY s.age ASC;


-- display top article clicked on from each keyword

CREATE TABLE temp_titles_and_clicks
SELECT ssr.uid, ssr.article_id, a.article_title, ssr.keyword
FROM student_survey_results ssr
JOIN article a 
ON ssr.article_id = a.article_id;

SELECT ttc.article_title, ttc.keyword, COUNT(*) as total_clicks
FROM temp_titles_and_clicks ttc 
GROUP BY ttc.article_title, ttc.keyword
HAVING COUNT(*) = (
    SELECT MAX(num_clicks)
    FROM (
        SELECT ttc1.article_title, ttc1.keyword, COUNT(*) as num_clicks 
        FROM temp_titles_and_clicks ttc1
        GROUP BY ttc1.keyword, ttc1.article_title 
    ) subquer
    WHERE subquer.keyword = ttc.keyword
)
ORDER BY ttc.keyword ASC;

-- display all articles and senstion score, in desc. order
SELECT a.article_title, a.sensation_score 
FROM article a 
ORDER BY a.sensation_score DESC;

-- display all articles with sensation score >= 0.2
SELECT *
FROM article 
WHERE a.sensation_score >= 0.2
ORDER BY a.sensation_score ASC;