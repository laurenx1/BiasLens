-- CS 121
-- Final Project: Ashlyn Roice and Lauren Pryor
-- Setup file for our final project: conducting an experiment on how 
-- sensationalized new headlines propagate health news misinformation.

-- [Problem 1]
-- clean up old tables;
-- must drop tables with foreign keys first
-- due to referential integrity constraints
DROP TABLE IF EXISTS student;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS article_gpt3_web;
DROP TABLE IF EXISTS user_login;
DROP TABLE IF EXISTS student_survey_results;

-- Creating the "student" relation. Represents a student entity with a unique
-- student_id, name, age, and major. No two students have the same
-- student_id. Nothing can be null in this table.
CREATE TABLE student (
    -- driver_id must be 10 characters, and is the primary key.
    student_id   CHAR(7)        NOT NULL,
    name         VARCHAR(1000)  NOT NULL,
    age          INT            NOT NULL,
    major        VARCHAR(100)   NOT NULL,
    house        VARCHAR(60)    NOT NULL
    grad_year    YEAR           NOT NULL,
    -- driver_id is primary key
    PRIMARY KEY (student_id)
);

CREATE TABLE articles (
   -- license must be 7 characters, and is the primary key.
   article_id         CHAR(10)        NOT NULL,
   article_title      VARCHAR(1000)   NOT NULL,
   article_author     VARCHAR(1000),
   ai_or_web  VARCHAR(5)   NOT NULL,
   publisher    VARCHAR(500),
   sensational_score    FLOAT,
   sentiment_score      FLOAT
   PRIMARY KEY (article_id)
);

CREATE TABLE article_gpt3_web (
   article_id    CHAR(10)    NOT NULL,
   gpt3_prompt     VARCHAR(5000),
   health_category      VARCHAR(500),
   PRIMARY KEY (article_id),
   FOREIGN KEY (article_id) REFERENCES article(article_id) ON DELETE CASCADE
);

CREATE TABLE user_login (
    user_id     CHAR(10)   NOT NULL,
    student_id   CHAR(7)   NOT NULL,
    username    VARCHAR(1000),
    password    VARCHAR(1000),
    PRIMARY KEY (user_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE
);

CREATE TABLE student_survey_results(
    student_id    CHAR(10)     NOT NULL,
    ai_articles_chosen    JSON,
    web_articles_chosen   JSON,
    student_sensation_score   FLOAT    NOT NULL,
    PRIMARY KEY (student_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);