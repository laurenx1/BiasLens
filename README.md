# BiasLens
Comparing bias and sensationalism in AI vs. web recommendations of news articles through their ability to grab the attention of college students.


## Data
Our data comes from three sources: a survey of current Caltech students using Airtable to collect information about their health news preferences. Additionally, we generated data to populate the student data ntoh manually and using DeepSeek. Finally, we include in our frontend web app a way to take the survey and continue populating the database. 

### Data: Articles
Our articles were populated using two sources, ChatGPT and the Google Chrome search engine. 


## Instructions for loading data from the command-line in MySQL
MUST FILL IN 

## Instructions for running the Python program (command-line arguments are supported)

## Unfinished Features


#### SQL setup

> cd biaslensdb

> sudo mysql

> source setup.sql

> source load.data.sql

> source setup-passwords.sql

> source setup-routines.sql

> source queries.sql 

> source grant-permissions.sql

#### python3
in another terminal, from root dir.

create + activate virtual environment

> pip install requirements.txt

> cd biaslensdb

> python3 app.py


#### frontend app
ensure Node.js, npm installed
> cd frontend

> npm install

> npm start

