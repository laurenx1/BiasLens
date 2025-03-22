# BiasLens
Comparing bias and sensationalism in AI vs. web recommendations of news articles through their ability to grab the attention of college students.

## Data
Our data comes from three sources: a survey of current Caltech students using Airtable to collect information about their health news preferences. Additionally, we generated data to populate the student data manually and using Python to randomly select articles per student. Finally, we include in our frontend web app as a way to take the survey and continue populating the database. 

### Data: Articles
Our articles were populated using two sources, ChatGPT and the Google Chrome search engine. 

We collected headlines for 8 health-related keywords: vaccines, COVID-19, american medicine, wellness,
public health, bird flu, global medicine, and cancer.

For each keyword, we collected 15 articles from a web search on Google of the keyword and another 15
articles through GPT3. The prompt we used for GPT3 was:


"Give me 25 news headlines relating to [*keyword*] and ensure there are no repeats."

These articles were entered manually into our database, hosted on Airtable. Each article entry has the
article title, whether it's GPT or web generated, its associated keyword, its sensationalism score, its author
if it's available, its publisher if it's available, and its associated link.

### Data: Survey Data Collections
We created a survey on Airtable that facilitated the collection of students' names, ages, years of graduation, and houses, along with their article selection per keyword. 

We couldn't get many students to take our survey, so we took it multiple times to include various names, ages, years of graduation, and houses. Then we used a Python script to randomly select 5 articles for each keyword for each person. In the future, we'll replace this data with actual student data collected from our peers, to more accurately represent students' views on sensationalized news articles on health.

### Data: Scoring the sensationalism of each news article
We created a machine learning model that leverages natural language processing to score an article headline by how sensational it is. We used textual attributes such as punctuation analysis, POS-tagging, number of capital letters, readability analysis, and sentiment analysis in order to detect the high emotion, simplified language and amplified bias which characterizes sensational text. 

Here is a [link](https://docs.google.com/document/d/17bnQoCprgO3J-0tloLNk-lFUbAVOV64RHb6NZpYktYI/edit?usp=sharing ) to a document profiling the purpose of the model, the dataset used to train it, and the steps used to train the model.

## Instructions for loading data from the command-line in MySQL
MUST FILL IN 

## Instructions for running the Python program (command-line arguments are supported)

## Unfinished Features







#### SQL setup

> cd biaslensdb

> sudo mysql

> source setup.sql

> source setup-passwords.sql

> source load.data.sql

> source setup-routines.sql

> source grant-permissions.sql

> source queries.sql 



#### python3
in another terminal, from root dir.

create + activate virtual environment

> pip install requirements.txt

> cd biaslensdb

> python3 app-admin.py for admin access, app-student.py for student access




#### frontend app
ensure Node.js, npm installed
> cd frontend

> npm install

> npm start

## Project Creators:
Ashlyn Roice (aroice@caltech.edu)
Lauren Pryor (lpryor@caltech.edu)