import datetime
import mysql.connector
from database_module import create_db_connection
import hashlib



def valid_date(datetime_str,include_time):
    
    # Define the date and time format
    if(include_time):
        datetime_format = '%Y-%m-%d %H:%M:%S'
    else:
        datetime_format = '%Y-%m-%d'

    # Try to create a datetime object from the string
    try:
        datetime_obj = datetime.datetime.strptime(datetime_str, datetime_format)
        print('Valid date and time!')
        return True
    except ValueError:
        print('Invalid date and time.')
        return False

def getFieldnames(table_names):
    connection = create_db_connection()
    cursor = connection.cursor()
    field_names = ""
    for table_name in table_names:
        query="DESCRIBE %s"
        values = (table_name,)
        cursor.execute(query,values)
        records = cursor.fetchall()
        for x in records:
            table_fields+=str(x[0])+','
        
        field_names += table_fields
    cursor.close()
    cnx.close()
    return field_names

def userSignup(user_id,user_is):
    connection = create_db_connection()
    cursor = connection.cursor()
    username = input("Enter your username: ")
    password = input("Enter password: ")
    hashed_password = hashlib.sha256(password.encode('utf-8')).hexdigest()
    query = "INSERT into user (username ,userpassword ,user_is, user_id) values (%s,%s,%s,%s)"
    values = (username,hashed_password,user_is,user_id)

    try:
        cursor.execute(query, values)
        connection.commit()
        cursor.close()
        connection.close()
        print("------------Insertion successful------------")
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()
        
        cursor.close()
        connection.close()
        userSignup(user_id,user_is)

