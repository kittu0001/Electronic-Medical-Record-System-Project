import mysql.connector
from database_module import create_db_connection
import usables

def getAllPrescriptions():
    connection = create_db_connection()
    cursor = connection.cursor() 
    query = "SELECT * from prescriptions"
    cursor.execute(query)
    records = cursor.fetchall()
    print("All Prescriptions")
    for record in records:
        print(record)

    cursor.close()
    connection.close()

def checkUrPrescriptions(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    query = "SELECT * from prescriptions where medical_record_id = %s"
    values = (user_id,)
    cursor.execute(query,values)
    records = cursor.fetchall()
    print("All Prescriptions")
    for record in records:
        print(record)

    cursor.close()
    connection.close()


def editPrescription():
    connection = create_db_connection()
    cursor = connection.cursor() 
    pres_id = input("Enter prescription id: ")
    medication_name = input("Enter medication name: ")
    dosage = input("Enter dosage: ")
    instructions = input(" enter medication instructions: ")

    query = "UPDATE prescriptions set medication_name =%s, dosage=%s, instructions=%s  where prescription_id = %s"
    values = (medication_name,dosage,instructions,pres_id)

    try:
        cursor.execute(query, values)
        connection.commit()
        print("------------Update successful------------")
        
        cursor.close()
        connection.close()

        getAllPrescriptions()

        return True
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()

        cursor.close()
        connection.close()
        return False  

# def ifItsUserRecord(id1,id2):
#     sub_query = "SELECT doctor_id from prescriptions where prescription_id = %s"
#     sub_values = (id1))
#     cursor.execute(sub_query,sub_values)
#     sub_result = cursor.fetchone()
#     if(sub_result is not None and sub_result == user_id ):
#         return True
#     else:
#         print("Please check your appointment id. You cannot modify other users' record")
#         return False

def deletePrescription():
    connection = create_db_connection()
    cursor = connection.cursor() 
    pres_id = input("Enter prescription id which you want to delete: ")
    query = "Delete from prescriptions where prescription_id = %s"
    values = (pres_id,)

    try:
        cursor.execute(query, values)
        connection.commit()
        print("------------Deletion successful------------")
        
        cursor.close()
        connection.close()

        getAllPrescriptions()

        return True
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()

        cursor.close()
        connection.close()
        return False



def addPrescription():
    connection = create_db_connection()
    cursor = connection.cursor() 
    medical_record_id= input("Enter id of the medical record: ")
    medication_name = input("Enter medication name: ")
    dosage = input("Enter dosage: ")
    instructions = input("Enter instructions")

    query = "INSERT into prescriptions (medical_record_id, medication_name, dosage, instructions) VALUES (%s,%s,%s,%s)"
    values = (medical_record_id,medication_name,dosage,instructions)

    try:
        cursor.execute(query, values)
        connection.commit()
        print("------------Insertion successful------------")
        
        cursor.close()
        connection.close()

        getAllPrescriptions()

        return True
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()

        cursor.close()
        connection.close()
        return False    