-- [Function 1]
DELIMITER !
CREATE FUNCTION calculate_student_sensation_score(student_id CHAR(7))
-- Given a student_id, calculates the average sensation score across all 
-- articles they selected in our survey. Helper function for add_student.
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE final_score_avg FLOAT;

    SELECT * 
    FROM student s 
    JOIN 