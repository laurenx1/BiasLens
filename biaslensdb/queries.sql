-- This file includes queries to see student demographics and article statistics

/*
This query returns the distribution of majors across all students.

Returns:
- s.major (VARCHAR): the major of each student, from table STUDENT
- percent_per_major (FLOAT): the percent of students that have major s.major 
- count_per_major (INT): the number of students that have major s.major
*/
SELECT 
     s.major as major, 
     -- calculates the percentage of students of that major by dividing number
     -- of students in that major by total number of students
     (COUNT(s.uid) / (SELECT (COUNT(*)) FROM student)) as percent_per_major, 
     -- outputs the count of students that are of that major
     COUNT(*) as count_per_major
FROM student s 
GROUP BY s.major;


/*
This query returns the distribution of houses across all students.

Returns:
- s.house (VARCHAR): the house of each student, from table STUDENT
- percent_per_house (FLOAT): the percent of students that are of house s.house
- count_per_house (INT): the number of students that are of house s.house
*/
SELECT 
     s.house as house, 
     -- calculates the percentage of students of that house by dividing number
     -- of students in that house by total number of students
     (COUNT(s.uid) / (SELECT (COUNT(*)) FROM student)) as percent_per_house, 
     -- outputs the count of students in each house
     COUNT(*) as count_per_house
FROM student s 
GROUP BY s.house;

/*
This query returns the distribution of graduation years across all students.

Returns:
- s.grad_year (YEAR): the graduation year of each student, from table STUDENT
- percent_per_grad_year (FLOAT): the percent of students that 
  are of each graduation year
- count_per_grad_year (INT): the number of students that are of each graduation
  are of each graduation year
*/
SELECT 
     s.grad_year as grad_year, 
     (COUNT(s.uid) / (SELECT (COUNT(*)) FROM student)) as percent_per_grad_year, 
     COUNT(*) as count_per_grad_year
FROM student s 
GROUP BY s.grad_year;

/*
This query returns the distribution of age across all students.

Returns:
- s.age (INT): the age of each student, from table STUDENT
- percent_per_age (FLOAT): the percent of students that are of each age
- count_per_age (INT): the number of students that are of each age.
*/
SELECT 
     s.age as age, 
     (COUNT(s.uid) / (SELECT (COUNT(*)) FROM student)) as percent_per_age, 
     COUNT(*) as count_per_age
FROM student s 
GROUP BY s.age
ORDER BY s.age ASC;


/*
Returns the top article selected per keyword. There are 8 keywords: vaccine,
COVID-19, american medicine, wellness, public health, bird flu, global medicine,
and cancer.

Returns:
- article_title: the title of each article that was the most clicked in 
  its category
- keyword: the keyword the article title is associated with
- total_clicks: the amount of times each most-clicked article was selected.
*/

-- Created a temporary table that combines article_id 
-- (from student_survey_results) and article_title (from article).
CREATE TABLE temp_titles_and_clicks
SELECT ssr.uid, ssr.article_id, a.article_title, ssr.keyword
FROM student_survey_results ssr
JOIN article a 
ON ssr.article_id = a.article_id;

-- Returns the article_title, keyword, and count associated with each
-- article with the MAX number of clicks from subquery table subquer.
SELECT ttc.article_title, ttc.keyword, COUNT(*) as total_clicks
FROM temp_titles_and_clicks ttc 
GROUP BY ttc.article_title, ttc.keyword
HAVING COUNT(*) = (
    -- Selects the maximum number of clicks per category (check outer WHERE
    -- check for subquer.keyword = ttc.keyword).
    SELECT MAX(num_clicks)
    FROM (
        -- Subquery outputs the number of selections per article, along with its
        -- associated keyword.
        SELECT ttc1.article_title, ttc1.keyword, COUNT(*) as num_clicks 
        FROM temp_titles_and_clicks ttc1
        GROUP BY ttc1.keyword, ttc1.article_title 
    ) subquer
    WHERE subquer.keyword = ttc.keyword
)
ORDER BY ttc.keyword ASC;

/*
Displays all article titles and their associated sensation scores, in order of
decreasing sensation score.

Returns:
- article_title: the title of each article
- sensation_score: the sensation score of each article (by which the output
is ordered - by decreasing sensation score)
*/
SELECT a.article_title, a.sensation_score 
FROM article a 
ORDER BY a.sensation_score DESC;

/*
Displays all articles with a sensation score over 0.2.


Returns:
All items from table ARTICLE (article_id, keyword, ai or web, article title, 
author, publisher, sensation score, and sentiment score) where the article has
a sensation score over 0.2.
*/
SELECT *
FROM article 
WHERE a.sensation_score >= 0.2
ORDER BY a.sensation_score ASC;


/*
RELATIONAL ALGEBRA QUERIES
-------------------------------------------------------------------------------
*/
-- [Query 1: ranking students in order of highest student_sensation_score, 
-- grouped by major]
SELECT a.username, s.major, q.sensation_score 
FROM account a 
JOIN student s on s.uid = s.uid 
JOIN student_sensation_scores_view q ON a.uid = q.uid
ORDER BY q.sensation_score ASCENDING;

-- [Query 2: projecting students with the lower than average student sensation
-- score]
DECLARE avg_score INT;
SET avg_score = 
    (SELECT AVG(sensation_score) FROM student_sensation_scores_view);

SELECT a.uid, a.username, AVG(q.sensation_score)
FROM account 
JOIN student_sensation_scores_view q ON a.uid = q.uid 
GROUP BY q.uid 
WHERE 