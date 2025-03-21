-- This file includes queries to see student demographics and article statistics

-- [Query 1: Percent of Students in Each Major]
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

-- [Query 2: Percent of Students in Each House]
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

-- [Query 3: Percent of Students in Each Grad Year]
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

-- [Query 4: Percent of Students of Each Age]
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

-- [Query 5: Top Article Selected per Keyword]
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

-- [Query 6: Articles Listed by Decreasing Sensation Score]
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
-- [RA Query 1: ranking students in order of highest student_sensation_score, 
-- grouped by major]
/*
Outputs the average student sensation score per major.

Returns:
- q.major (VARCHAR): the possible majors for each student.
- avg_major_score (FLOAT): the average student sensation score per major.
*/
SELECT 
    -- selects major and average score per major from subquery q
    q.major, 
    AVG(q.student_sensation_score) as avg_major_score
FROM 
(   -- outputs the average sensation score per student
    SELECT 
        a.username, 
        s.major, 
        get_avg_sensation_by_username(a.username) AS student_sensation_score
    FROM account a 
    JOIN student s on s.uid = a.uid 
    ORDER BY get_avg_sensation_by_username(a.username) ASC
) q 
-- groups all student scores by major for output
GROUP BY q.major;

-- [Query 2: projecting students with the lower than average student sensation
-- score]
/*
Outputs all UIDs and usernames of all students with lower than the average 
student sensation score across all students.

Returns:
- a.uid (CHAR): the UID of each student
- a.username (VARCHAR): the username of each student
- student_sensation_score (FLOAT): the student sensation score of every student
  with a student sensation score lower than 0.2.
*/
SELECT 
    a.uid, 
    a.username, 
    get_avg_sensation_by_username(a.username) as student_sensation_score
FROM account a
WHERE get_avg_sensation_by_username(a.username) < (
    SELECT AVG(avg_score) 
    FROM (
        SELECT (AVG(get_avg_sensation_by_username(a.username))) as avg_score 
        FROM account a 
        GROUP BY a.username 
    ) sub
)
ORDER BY get_avg_sensation_by_username(a.username) ASC;