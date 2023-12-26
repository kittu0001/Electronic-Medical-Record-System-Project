import mysql.connector
from database_module import create_db_connection
import usables

def checkUrInsurance(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    query = "SELECT * from insurance_details, insurance_providers where insurance_details.provider_id = insurance_providers.provider_id and insurance_details.insurance_id =%s"
    values = list(str(user_id))
    cursor.execute(query,values)
    records = cursor.fetchall()
    print("Your insurances")
    for record in records:
        print(record)

    cursor.close()
    connection.close()

def addInsurance(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    query1 = "select provider_name from insurance_providers" 
    cursor.execute(query1)
    sub_records = cursor.fetchall()
    print("All Provider names")
    for sub_record in sub_records:
        print(sub_record)
    
    query = "INSERT into insurance_details (provider_id, policy_number) values (%s,%s)"
    pr_id = input("Enter provider_id: ")
    policy_no = input("Enter policy number: ")
    values = (pr_id,policy_no)

    try:
        cursor.execute(query, values)
        connection.commit()
        

    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()

    
    query1 = "SELECT insurance_id from insurance_details where provider_id = %s and policy_number = %s"
    values1 = (pr_id,policy_no)
    cursor.execute(query1,values1)
    ins_id = cursor.fetchone()[0]

    query2 = "INSERT INTO insurance_details (insurance_id, insurance_id) VALUES (%s,%s)"
    values2 = (user_id,ins_id)
    try:
        cursor.execute(query2, values2)
        connection.commit()
        print("------------Insertion successful------------")
        checkUrInsurance(user_id)
        cursor.close()
        connection.close()
        return True
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()

        cursor.close()
        connection.close()
        return False  


def editInsurance(user_id):
    connection = create_db_connection()
    cursor = connection.cursor()
    

    checkUrInsurance(user_id)
    ins_id = input("Enter insurance id: ")
    query = "UPDATE insurance_details set provider_id = %s, policy_number = %s where insurance_id = %s"
    pr_id = input("Enter provider id: ")
    policy_no = input("Enter policy number: ")
    values = (pr_id,policy_no,ins_id)
    try:
        cursor.execute(query, values)
        connection.commit()
        print("------------Update successful------------")
        checkUrInsurance(user_id)
        cursor.close()
        connection.close()
        return True
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()

        cursor.close()
        connection.close()
        return False  

def deleteInsurance(user_id):
    connection = create_db_connection()
    cursor = connection.cursor()

    ins_id = input("Enter insurance id: ")
    query = "DELETE from insurance_details where insurance_id = %s"
    values = (ins_id)
    try:
        cursor.execute(query, values)
        connection.commit()
        print("------------Delete successful------------")
        checkUrInsurance(user_id)
        cursor.close()
        connection.close()
        return True
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()
        cursor.close()
        connection.close()
        return False  

