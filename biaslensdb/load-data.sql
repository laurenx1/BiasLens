-- -- Insert sample keywords into keyword_list
-- INSERT INTO keyword_list (keyword) VALUES
--     ('Vaccines'),
--     ('COVID-19'),
--     ('American Medicine'),
--     ('Wellness'),
--     ('Public Health'),
--     ('Bird Flu'),
--     ('Global Medicine'),
--     ('Cancer');

-- -- ------------------------------------------------------------------------------
-- -- some examples to work with during dev

-- -- add users to the account table 
-- CALL sp_add_user('0000001', 'jdoe', 'jdoe@example.com', 'password123');
-- CALL sp_add_user('0000002', 'asmith', 'asmith@example.com', 'securepass456');
-- CALL sp_add_user('1111111', 'admin', 'admin@example.com', 'adminpass789');


-- -- add students to the student table (all non-admin accounts, they take the survey)

-- INSERT INTO student (uid, name, age, major, house, grad_year)
-- VALUES
--     ('0000001', 'John Doe', 20, 'Computer Science', 'Venerable', 2025),
--     ('0000002', 'Alice Smith', 21, 'Biology', 'Ricketts', 2024);

-- -- Update the `taken_survey` flag in the `account` table for the inserted students
-- UPDATE account
-- SET taken_survey = 1
-- WHERE uid IN ('0000001', '0000002');



-- -- Insert articles into the `article` table
-- INSERT INTO article (keyword, article_title, author, publisher, ai_or_web, sensation_score)
-- VALUES
--     -- Vaccines
--     ('Vaccines', 'This New Drug Could Help End the HIV Epidemic—but US Funding Cuts Are Killing Its Rollout', 'Jane Doe', 'The New York Times', 'web', 75),
--     ('Vaccines', 'A new era of Made in America drug manufacturing', 'John Smith', 'The Washington Post', 'ai', 80),
    
--     -- COVID-19
--     ('COVID-19', 'COVID isn’t done with us, and there’s still much to learn from its unpredictability', 'Alice Brown', 'BBC News', 'web', 70),
--     ('COVID-19', 'COVID-19 “miracle drugs” could have been a turning point. What went wrong?', 'Bob Johnson', 'The Guardian', 'ai', 85),
    
--     -- American Medicine
--     ('American Medicine', 'America is finally bringing drug manufacturing back home, starting with penicillin', 'Emily White', 'Reuters', 'web', 90),
--     ('American Medicine', 'Medical breakthroughs in America over the past 5 years', 'Chris Davis', 'Bloomberg', 'ai', 60),
    
--     -- Wellness
--     ('Wellness', 'How the wellness industry is targeting Gen Z', 'Sophia Taylor', 'Vox', 'web', 55),
--     ('Wellness', 'Exploring the hidden costs of wellness culture', 'Michael Wilson', 'The Atlantic', 'ai', 65),
    
--     -- Public Health
--     ('Public Health', 'Challenges facing public health after the pandemic', 'Emma Harris', 'National Geographic', 'web', 75),
--     ('Public Health', 'How AI is transforming public health initiatives', 'Daniel Moore', 'Scientific American', 'ai', 80),
    
--     -- Bird Flu
--     ('Bird Flu', 'The ongoing threat of bird flu in 2025', 'William Scott', 'The Wall Street Journal', 'web', 85),
--     ('Bird Flu', 'Preparing for the next global bird flu outbreak', 'Charlotte Evans', 'Nature', 'ai', 70),
    
--     -- Global Medicine
--     ('Global Medicine', 'Innovations in global medicine distribution', 'Olivia Martinez', 'The Economist', 'web', 60),
--     ('Global Medicine', 'Global healthcare systems struggling in 2025', 'James Lee', 'Foreign Policy', 'ai', 50),
    
--     -- Cancer
--     ('Cancer', 'A new breakthrough in cancer immunotherapy', 'Grace Clark', 'Forbes', 'web', 90),
--     ('Cancer', 'Rising costs of cancer treatment worldwide', 'Benjamin Hall', 'TIME', 'ai', 65);


-- -- Additional articles for the `article` table
-- INSERT INTO article (keyword, article_title, author, publisher, ai_or_web, sensation_score)
-- VALUES
--     -- Vaccines
--     ('Vaccines', 'New vaccine technologies are reshaping global health', 'Laura Adams', 'The Verge', 'web', 78),
--     ('Vaccines', 'The unexpected hurdles in vaccine distribution worldwide', 'Mark Thompson', 'CNN', 'ai', 65),
--     ('Vaccines', 'How mRNA technology revolutionized the fight against diseases', 'Emily Foster', 'NBC News', 'web', 72),
--     ('Vaccines', 'Developing countries struggle with vaccine accessibility', 'Nathan Brown', 'Al Jazeera', 'ai', 85),
--     ('Vaccines', 'Vaccines and the ethics of global health equity', 'Olivia Turner', 'The Lancet', 'web', 90),
--     ('Vaccines', 'The rise of personalized vaccines in modern medicine', 'Sarah Reed', 'The Boston Globe', 'ai', 80),
--     ('Vaccines', 'Global funding gaps threaten future vaccine research', 'Ethan White', 'Politico', 'web', 68),
--     ('Vaccines', 'Could a universal flu vaccine be on the horizon?', 'Chloe Harris', 'The Guardian', 'ai', 75),
--     ('Vaccines', 'Vaccine misinformation continues to spread online', 'Daniel King', 'The New Yorker', 'web', 70),
--     ('Vaccines', 'New malaria vaccine offers hope for Africa', 'Sophia Martin', 'Nature', 'ai', 82),

--     -- COVID-19
--     ('COVID-19', 'What the world learned from COVID-19: Five years later', 'Alexander Gray', 'TIME', 'web', 78),
--     ('COVID-19', 'The enduring mystery of long COVID', 'Hannah Roberts', 'Science Magazine', 'ai', 85),
--     ('COVID-19', 'Could another pandemic be closer than we think?', 'Liam Parker', 'The Atlantic', 'web', 75),
--     ('COVID-19', 'How vaccines mitigated COVID-19 impacts globally', 'Charlotte Davis', 'The New York Times', 'ai', 88),
--     ('COVID-19', 'The economic aftermath of the COVID-19 pandemic', 'Ethan Mitchell', 'BBC News', 'web', 72),
--     ('COVID-19', 'COVID variants remain a concern in 2025', 'Grace Scott', 'The Washington Post', 'ai', 83),
--     ('COVID-19', 'The role of AI in combating pandemics', 'Benjamin Ross', 'Forbes', 'web', 65),
--     ('COVID-19', 'Social media’s role in shaping COVID-19 responses', 'William Baker', 'Reuters', 'ai', 80),
--     ('COVID-19', 'Are we prepared for the next health crisis?', 'Amelia Price', 'The Economist', 'web', 68),
--     ('COVID-19', 'New data reveals gaps in COVID recovery efforts', 'Emily Johnson', 'Foreign Affairs', 'ai', 70),

--     -- American Medicine
--     ('American Medicine', 'The growing trend of telemedicine in the US', 'Jacob Clark', 'Vox', 'web', 75),
--     ('American Medicine', 'How AI is transforming American healthcare', 'Olivia Evans', 'MIT Technology Review', 'ai', 82),
--     ('American Medicine', 'Challenges in rural healthcare accessibility', 'Sophia Taylor', 'NPR', 'web', 80),
--     ('American Medicine', 'The opioid crisis: Where are we now?', 'Daniel Martinez', 'The Washington Post', 'ai', 88),
--     ('American Medicine', 'Medical startups are redefining American innovation', 'Ella Lewis', 'Bloomberg', 'web', 65),
--     ('American Medicine', 'The hidden costs of America’s healthcare system', 'James Carter', 'The New Yorker', 'ai', 90),
--     ('American Medicine', 'Mental health services are finally gaining momentum', 'Hannah Brown', 'The Atlantic', 'web', 78),
--     ('American Medicine', 'Drug prices continue to soar despite reforms', 'Charlotte Hall', 'Politico', 'ai', 68),
--     ('American Medicine', 'The debate over universal healthcare in the US', 'Michael White', 'TIME', 'web', 72),
--     ('American Medicine', 'The impact of innovation in medical devices', 'Liam Harris', 'The Verge', 'ai', 74),

--     -- Wellness
--     ('Wellness', 'Meditation apps are reshaping mental health care', 'Sophia Adams', 'Healthline', 'web', 60),
--     ('Wellness', 'Wellness retreats: Luxury or necessity?', 'Jacob Lee', 'The Guardian', 'ai', 70),
--     ('Wellness', 'Exploring the benefits of functional fitness', 'Emily Foster', 'Men’s Health', 'web', 68),
--     ('Wellness', 'The rise of adaptogens in everyday diets', 'Olivia King', 'The Atlantic', 'ai', 75),
--     ('Wellness', 'Digital detox: Does it really work?', 'Charlotte Davis', 'Forbes', 'web', 80),
--     ('Wellness', 'The intersection of wellness and technology', 'Ethan Martin', 'MIT Technology Review', 'ai', 78),
--     ('Wellness', 'How sleep tracking is transforming wellness culture', 'Grace Parker', 'National Geographic', 'web', 65),
--     ('Wellness', 'The science behind plant-based diets', 'Daniel Harris', 'Science Magazine', 'ai', 82),
--     ('Wellness', 'The mental health benefits of journaling', 'Sophia Evans', 'Psychology Today', 'web', 70),
--     ('Wellness', 'Can wearable tech improve overall wellness?', 'Liam Scott', 'TechCrunch', 'ai', 74);

-- INSERT INTO article (keyword, article_title, author, publisher, ai_or_web, sensation_score)
-- VALUES
--     -- Public Health
--     ('Public Health', 'Global strategies for improving public health in underserved regions', 'Sarah Lee', 'The Guardian', 'web', 80),
--     ('Public Health', 'The role of technology in advancing public health initiatives', 'John Moore', 'Reuters', 'ai', 70),
--     ('Public Health', 'Mental health: The rising public health crisis in modern societies', 'Rachel Green', 'BBC', 'web', 75),

--     -- Bird Flu
--     ('Bird Flu', 'Understanding the risks of bird flu in the modern world', 'David Smith', 'National Geographic', 'web', 82),
--     ('Bird Flu', 'New breakthroughs in combating bird flu outbreaks', 'Anna Walker', 'Al Jazeera', 'ai', 68),
--     ('Bird Flu', 'How global health organizations are preparing for the next bird flu pandemic', 'James Miller', 'CNN', 'web', 74),

--     -- Global Medicine
--     ('Global Medicine', 'Innovative treatments changing the landscape of global medicine', 'Helen Thompson', 'Science Daily', 'ai', 85),
--     ('Global Medicine', 'The challenges of providing affordable healthcare in developing nations', 'Thomas Brown', 'TIME', 'web', 77),
--     ('Global Medicine', 'How technology is driving the future of global healthcare', 'Megan Clark', 'Forbes', 'ai', 79),

--     -- Cancer
--     ('Cancer', 'Latest advancements in cancer immunotherapy', 'David Carter', 'The New York Times', 'web', 88),
--     ('Cancer', 'The role of artificial intelligence in cancer detection and treatment', 'Samantha Brooks', 'Bloomberg', 'ai', 90),
--     ('Cancer', 'Exploring the link between genetics and cancer prevention', 'Michael Davis', 'USA Today', 'web', 76);


-- INSERT INTO article (keyword, article_title, author, publisher, ai_or_web, sensation_score)
-- VALUES
--     -- Public Health
--     ('Public Health', 'Global strategies for improving public health in underserved regions', 'Sarah Lee', 'The Guardian', 'web', 80),
--     ('Public Health', 'The role of technology in advancing public health initiatives', 'John Moore', 'Reuters', 'ai', 70),
--     ('Public Health', 'Mental health: The rising public health crisis in modern societies', 'Rachel Green', 'BBC', 'web', 75),
--     ('Public Health', 'Vaccination campaigns: A key to combating global public health threats', 'Olivia White', 'The Wall Street Journal', 'ai', 78),
--     ('Public Health', 'Public health challenges in the face of climate change', 'Henry Adams', 'Washington Post', 'web', 72),
--     ('Public Health', 'The ethics of public health surveillance in the digital age', 'Liam Johnson', 'TIME', 'ai', 66),
--     ('Public Health', 'Improving access to healthcare through public health policies', 'Sophia Brown', 'The Lancet', 'web', 74),
--     ('Public Health', 'Social determinants of health: Addressing inequalities for better outcomes', 'Michael Roberts', 'Reuters', 'web', 69),
--     ('Public Health', 'The importance of mental health education in schools', 'Isabelle Turner', 'New York Times', 'ai', 71),
--     ('Public Health', 'How public health experts are tackling the opioid crisis', 'Emma Harris', 'NPR', 'web', 83),
--     ('Public Health', 'Public health and urban planning: How cities can improve health outcomes', 'Ella Clark', 'The Guardian', 'ai', 77),

--     -- Bird Flu
--     ('Bird Flu', 'Understanding the risks of bird flu in the modern world', 'David Smith', 'National Geographic', 'web', 82),
--     ('Bird Flu', 'New breakthroughs in combating bird flu outbreaks', 'Anna Walker', 'Al Jazeera', 'ai', 68),
--     ('Bird Flu', 'How global health organizations are preparing for the next bird flu pandemic', 'James Miller', 'CNN', 'web', 74),
--     ('Bird Flu', 'The impact of bird flu on global trade and agriculture', 'Tom Walker', 'The Economist', 'web', 70),
--     ('Bird Flu', 'Vaccination strategies for preventing the spread of bird flu', 'Elena Martinez', 'Reuters', 'ai', 79),
--     ('Bird Flu', 'Bird flu outbreaks: What history teaches us about prevention', 'Chris Turner', 'The Guardian', 'web', 76),
--     ('Bird Flu', 'How AI is being used to predict and manage bird flu outbreaks', 'Sophia Collins', 'Bloomberg', 'ai', 84),
--     ('Bird Flu', 'Public health responses to bird flu: Lessons learned from previous outbreaks', 'Oliver King', 'BBC', 'web', 78),
--     ('Bird Flu', 'The economics of managing bird flu outbreaks globally', 'Jackie Davis', 'TIME', 'ai', 71),
--     ('Bird Flu', 'How international cooperation is key in fighting bird flu', 'Benjamin Foster', 'Al Jazeera', 'web', 67),
--     ('Bird Flu', 'New approaches to bird flu vaccine development and distribution', 'Gabriella Scott', 'Reuters', 'ai', 73),

--     -- Global Medicine
--     ('Global Medicine', 'Innovative treatments changing the landscape of global medicine', 'Helen Thompson', 'Science Daily', 'ai', 85),
--     ('Global Medicine', 'The challenges of providing affordable healthcare in developing nations', 'Thomas Brown', 'TIME', 'web', 77),
--     ('Global Medicine', 'How technology is driving the future of global healthcare', 'Megan Clark', 'Forbes', 'ai', 79),
--     ('Global Medicine', 'The role of digital health platforms in improving global health access', 'Jack Peterson', 'Bloomberg', 'ai', 82),
--     ('Global Medicine', 'How telemedicine is revolutionizing healthcare delivery in remote areas', 'Olivia Martin', 'Reuters', 'web', 80),
--     ('Global Medicine', 'Building resilient health systems: A challenge for global medicine', 'Eva Perez', 'The Lancet', 'web', 74),
--     ('Global Medicine', 'The rise of precision medicine and its global impact', 'David White', 'Nature Medicine', 'ai', 86),
--     ('Global Medicine', 'Healthcare infrastructure challenges in low-income countries', 'Lucas Hall', 'TIME', 'web', 72),
--     ('Global Medicine', 'Global medicine in the age of pandemics: What we have learned', 'Jasmine Lee', 'The Guardian', 'ai', 81),
--     ('Global Medicine', 'Collaborative approaches in global medicine to combat global health crises', 'Ethan Carter', 'Science Daily', 'web', 75),
--     ('Global Medicine', 'The future of vaccine development and distribution in global medicine', 'Catherine Green', 'New York Times', 'ai', 83),

--     -- Cancer
--     ('Cancer', 'Latest advancements in cancer immunotherapy', 'David Carter', 'The New York Times', 'web', 88),
--     ('Cancer', 'The role of artificial intelligence in cancer detection and treatment', 'Samantha Brooks', 'Bloomberg', 'ai', 90),
--     ('Cancer', 'Exploring the link between genetics and cancer prevention', 'Michael Davis', 'USA Today', 'web', 76),
--     ('Cancer', 'The future of cancer treatment: Targeted therapies and precision medicine', 'Natalie Wilson', 'TIME', 'web', 92),
--     ('Cancer', 'Artificial intelligence in early cancer detection: Revolutionizing diagnostics', 'William Turner', 'Bloomberg', 'ai', 85),
--     ('Cancer', 'How advancements in cancer research are improving patient outcomes', 'Emma Harris', 'BBC', 'web', 80),
--     ('Cancer', 'New approaches to personalized cancer treatment using AI and genomics', 'Sophia Carter', 'Reuters', 'ai', 89),
--     ('Cancer', 'The role of immunotherapy in cancer treatment: What patients need to know', 'John Anderson', 'NBC News', 'web', 83),
--     ('Cancer', 'How cancer research is benefiting from advances in molecular biology', 'Lucas White', 'Scientific American', 'ai', 78),
--     ('Cancer', 'Public health strategies for reducing cancer rates globally', 'Isabelle Moore', 'The Guardian', 'web', 75),
--     ('Cancer', 'Cancer prevention: The importance of lifestyle changes and early screening', 'Matthew Scott', 'TIME', 'web', 77);


-- -- Insert survey results for Student 1 (uid = '0000001')
-- INSERT INTO student_survey_results (uid, keyword, article_id) VALUES
-- ('0000001', 'Vaccines', 1), 
-- ('0000001', 'Vaccines', 17),
-- ('0000001', 'Vaccines', 18),
-- ('0000001', 'Vaccines', 19),
-- ('0000001', 'Vaccines', 22),

-- ('0000001', 'COVID-19', 3),
-- ('0000001', 'COVID-19', 4),
-- ('0000001', 'COVID-19', 28),
-- ('0000001', 'COVID-19', 29),
-- ('0000001', 'COVID-19', 31),

-- ('0000001', 'American Medicine', 5),
-- ('0000001', 'American Medicine', 6),
-- ('0000001', 'American Medicine', 39),
-- ('0000001', 'American Medicine', 42),
-- ('0000001', 'American Medicine', 43),

-- ('0000001', 'Wellness', 51),
-- ('0000001', 'Wellness', 52),
-- ('0000001', 'Wellness', 53),
-- ('0000001', 'Wellness', 54),
-- ('0000001', 'Wellness', 55),

-- ('0000001', 'Public Health', 57),
-- ('0000001', 'Public Health', 58),
-- ('0000001', 'Public Health', 59),
-- ('0000001', 'Public Health', 77),
-- ('0000001', 'Public Health', 78),

-- ('0000001', 'Bird Flu', 80),
-- ('0000001', 'Bird Flu', 81),
-- ('0000001', 'Bird Flu', 82),
-- ('0000001', 'Bird Flu', 83),
-- ('0000001', 'Bird Flu', 84),

-- ('0000001', 'Global Medicine', 13),
-- ('0000001', 'Global Medicine', 14),
-- ('0000001', 'Global Medicine', 63),
-- ('0000001', 'Global Medicine', 64),
-- ('0000001', 'Global Medicine', 65),

-- ('0000001', 'Cancer', 66),
-- ('0000001', 'Cancer', 67),
-- ('0000001', 'Cancer', 68),
-- ('0000001', 'Cancer', 107),
-- ('0000001', 'Cancer', 108);



-- -- Insert survey results for Student 2 (uid = '0000002')
-- INSERT INTO student_survey_results (uid, keyword, article_id) VALUES
-- ('0000002', 'Vaccines', 24),
-- ('0000002', 'Vaccines', 23),
-- ('0000002', 'Vaccines', 22),
-- ('0000002', 'Vaccines', 21),
-- ('0000002', 'Vaccines', 2),

-- ('0000002', 'COVID-19', 4),
-- ('0000002', 'COVID-19', 36),
-- ('0000002', 'COVID-19', 3),
-- ('0000002', 'COVID-19', 35),
-- ('0000002', 'COVID-19', 34),

-- ('0000002', 'American Medicine', 46),
-- ('0000002', 'American Medicine', 45),
-- ('0000002', 'American Medicine', 44),
-- ('0000002', 'American Medicine', 37),
-- ('0000002', 'American Medicine', 38),

-- ('0000002', 'Wellness', 54),
-- ('0000002', 'Wellness', 55),
-- ('0000002', 'Wellness', 56),
-- ('0000002', 'Wellness', 8),
-- ('0000002', 'Wellness', 7),

-- ('0000002', 'Public Health', 79),
-- ('0000002', 'Public Health', 78),
-- ('0000002', 'Public Health', 77),
-- ('0000002', 'Public Health', 74),
-- ('0000002', 'Public Health', 75),

-- ('0000002', 'Bird Flu', 90),
-- ('0000002', 'Bird Flu', 89),
-- ('0000002', 'Bird Flu', 88),
-- ('0000002', 'Bird Flu', 80),
-- ('0000002', 'Bird Flu', 81),

-- ('0000002', 'Global Medicine', 101),
-- ('0000002', 'Global Medicine', 100),
-- ('0000002', 'Global Medicine', 99),
-- ('0000002', 'Global Medicine', 14),
-- ('0000002', 'Global Medicine', 13),

-- ('0000002', 'Cancer', 15),
-- ('0000002', 'Cancer', 16),
-- ('0000002', 'Cancer', 112),
-- ('0000002', 'Cancer', 111),
-- ('0000002', 'Cancer', 106);




-- ----------------------------------------------------------------------------
-- loading in our partial real / partial generated data ()

/*
Inserting all keywords into the keyword table.
*/
INSERT INTO keyword_list
VALUES
    ('vaccine'), 
    ('COVID-19'), 
    ('american medicine'), 
    ('wellness'),
    ('public health'), 
    ('bird flu'), 
    ('global medicine'), 
    ('cancer');

/*
Loading all account data from generated records.
*/
LOAD DATA LOCAL INFILE 
    '../data/all_data - account_data_final.csv' 
    INTO TABLE account
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
(uid, username, email, password_hash, is_admin, taken_survey);

UPDATE account 
SET 
    salt = make_salt(8),
    password_hash = SHA2(CONCAT(password_hash, salt), 256);

/*
Loading all student data from generated records.
*/
LOAD DATA LOCAL INFILE 
    '../data/all_data - student_data.csv' 
    INTO TABLE student
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
(uid, name, age, major, house, grad_year);

/*
Loading all article details from created records.
*/
LOAD DATA LOCAL INFILE 
    '../data/all_headlines_with_scores.csv'
    INTO TABLE article
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS
(article_title, ai_or_web, keyword, sensation_score, author, publisher);

/*
Loading student survey results from created records.
*/
-- temporary record holding Python-generated data of students and article
-- selections. Python script used to generate data is included in 
-- repo.
DROP TABLE IF EXISTS temp_student_records;
CREATE TEMPORARY TABLE temp_student_records (
    uid CHAR(7) NOT NULL,
    keyword VARCHAR(20) NOT NULL,
    article_title VARCHAR(500) NOT NULL
);

-- loading from generated file.
LOAD DATA LOCAL INFILE 
    '../data/final_student_survey_selections.tsv'
    INTO TABLE temp_student_records
FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n' IGNORE 1 ROWS
(uid, keyword, article_title);

-- generated file data is inserted into student_survey_results table.
-- JOIN is used to obtain article_id from article titles.
INSERT INTO student_survey_results (uid, keyword, article_id)
SELECT
    tsr.uid,
    tsr.keyword,
    a.article_id
FROM
    temp_student_records tsr
JOIN article a
    ON tsr.article_title = a.article_title;

/*
Creating index on article_name for speedup of queries.
*/
