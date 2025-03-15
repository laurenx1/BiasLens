"""
Ashlyn Roice and Lauren Pryor
aroice@caltech.edu and lpryor@caltech.edu
TODO: Function Stubs 
******************************************************************************
"""
# Students 
def create_account(uid, password):
    """
    Given a student's UID and desired password, checks that a student with that
    same UID does not exist in the database (otherwise throws an error) and
    checks for a strong password. If the password isn't over 10 characters and 
    doesn't include a number the user is prompted to make their password
    stronger. Then creates the account and adds to our database, allowing them
    to log in.
    """
    pass 

def login(uid, password):
    """
    Given a username and password, checks to ensure the validity of both 
    (existence within our database) and logs the user in, providing them VIEW
    access to our database. 
    """
    pass

def take_survey():
    """
    When this function is called, the survey questions are rolled out to
    the user. The function collects their name, major, house, 
    year of graduation, and the top 5 articles they would read from our given
    categories of vaccines, COVID-19, American Medicine, Wellness, Public
    Health, Bird Flu, Global Medicine, and Cancer. Stores all of this 
    information in student_survey_results.
    """
    pass

def load_all_results(categ='all'):
    """
    When this function is called, the results of the query SELECT * FROM 
    student_survey_results GROUP BY [categ] is displayed so the user 
    can view all current results. Depending on the argument `categ`, the 
    function will display results by age, house, major, or year of graduation. 
    If no argument is passed, the query results for SELECT * will be returned.
    """
    pass

def average_by_categ(categ='all'):
    """
    When this function is called, the average student sensation score of each
    student will be displayed, grouped by the argument of `categ`. Depending 
    on the argument `categ`, the function will display results by age, house, 
    major, or year of graduation. If no argument is passed, the query results 
    for SELECT * will be returned.
    """
    pass

def display_student_demographics():
    """
    When this function is called, all student information will be displayed
    from STUDENTS. This is so that the user can obtain a better depiction of
    the distribution of houses, ages, years of graduation, and majors 
    represented in our database.
    """

def display_student_visualizations(categ='all'):
    """
    When this function is called, a graph of all student results is displayed.
    Graphs for results based on major, age, house, and/or year of graduation
    are generated and outputted, depending on the argument value of `categ`. 
    If no argument is passed, `categ` is defaulted to 'all' and will display 
    all graphs. Otherwise, it will only display results based on the `categ` 
    argument.
    """
    pass

def experiment_summary():
    """
    When this function is called, a paragraph on what our experiment does
    it outputted (pre-generated).
    """
    pass

# Admin
def add_article(title, author, ai_or_web, publisher):
    """
    Given an article title, author, whether it is AI or web generated, and the 
    article's publisher, evaluates its sensationalism and adds the article to 
    the ARTICLE relation. The author and publisher can be null.
    """
    pass

def add_student(name, age, major, house, grad_year):
    """
    Given a student first name, last name, age, major, house, and year of 
    graduation, adds their information to the STUDENTS database.
    """
    pass

def update_student(name, arg, value):
    """
    Given a student's name, a given argument, and desired value, updates
    that student's information for that argument in STUDENTS. Ensures that
    student exists in database, and that arg and value are valid.
    """

def delete_student(name):
    """
    Given a student's name, deletes the student from the STUDENT relation. 
    Ensures deletes cascade into other relevant parts of the database.
    """

def quit():
    """
    Exists out of the application (stops prompting the user).
    """
