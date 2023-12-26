import mysql.connector

def create_db_connection():
    #connect mysql
    return mysql.connector.connect(user='root', password='Mysql@12345',
                              host="localhost",
                              database='student_electronic_medical_record2')
    
    # if connection.is_connected():
    #     print("Connected to database")  