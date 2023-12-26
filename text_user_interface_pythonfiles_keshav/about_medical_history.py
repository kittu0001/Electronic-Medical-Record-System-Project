import mysql.connector
from database_module import create_db_connection
import usables 
import about_appointment as aa

def getPatientMedicalHistory():
    student_id = input("Enter id of the patient who you want to check medical history: ")
    connection = create_db_connection()
    cursor = connection.cursor() 
    

    query = "SELECT * from medical_records where student_id = %s"
    values = (student_id,)

    cursor.execute(query,values)
    
    records = cursor.fetchall()
    print("Medical History of patient")
    for record in records:
        print(record)

    cursor.close()
    connection.close()

def checkUrMedicalHistory(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 

    query = "SELECT * from medical_records where student_id = %s"
    values = (user_id,)

    cursor.execute(query,values)
    
    records = cursor.fetchall()
    print("Medical History of patient")
    for record in records:
        print(record)

    cursor.close()
    connection.close()

def getAllMedicalHistory():
    connection = create_db_connection()
    cursor = connection.cursor() 
    query = "SELECT * from medical_records"
    cursor.execute(query)
    records = cursor.fetchall()
    for record in records:
        print(record)
    cursor.close()
    connection.close()

def editMedicalHistory(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    m_id = input("Enter medical record id of the patient you want to edit: ")
    pat_id = input("Enter student id: ")
    doc_id = input("enter doctor id: ")
    diagnosis = input("Enter diagnosis of the patient: ")
    dia_date = input("Enter diagnosed date in YYYY-MM-DD: ")
    while(not usables.valid_date(dia_date,False)):
        print("check the date format")
        dia_date = input("Enter diagnosed date in YYYY-MM-DD: ")
    treatment = input("Enter treatment: ")
    doc_notes = input("enter doctor notes: ")
    query ="UPDATE medical_records set student_id = %s, doctor_id = %s, diagnosis=%s, date =%s, treatment=%s, doctor_notes=%s where medical_record_id = %s"
    #query = "INSERT INTO medical_history (patient_id, medical_condition, date_diagnosed, treatment) VALUES (%s,%s,%s,%s)"
    values = (pat_id,doc_id,diagnosis,dia_date,treatment,doc_notes,m_id)
    try:
        cursor.execute(query,values)
        connection.commit()
        print("------------ Record is Updated Successfully ------------")
        cursor.close()
        connection.close()
        return      
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        editMedicalHistory(user_id)
        connection.rollback() 
        cursor.close()
        connection.close() 

def ifItsUserRecord(cursor,id1,id2):
    sub_query = "SELECT student_id from medical_records where medical_record_id = %s"
    sub_values = (id1,)
    cursor.execute(sub_query,sub_values)
    sub_result = cursor.fetchone()
    # print("student_id retrieved is: ",sub_result)
    if(sub_result is not None and sub_result[0] == id2 ):
        return True
    else:
        print("Please check your appointment id. You cannot modify other users' record")
        return False

def deleteMedicalHistory(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    m_id = input("Enter medical record id of the patient: ")
    query = "DELETE  from medical_records where medical_record_id = %s"
    values = (m_id,)

    try:
        cursor.execute(query,values)
        connection.commit()
        print("------------ Medical History is deleted------------")
        cursor.close()
        connection.close()
        return      
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        editAppointment(user_id)
        connection.rollback() 
        cursor.close()
        connection.close() 

def addMedicalHistory(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    # m_id = input("Enter medical record id of the patient you want to edit: ")
    pat_id = input("Enter student id: ")
    # doc_id = input("enter doctor id: ")
    diagnosis = input("Enter diagnosis of the patient: ")
    dia_date = input("Enter diagnosed date in YYYY-MM-DD: ")
    while(not usables.valid_date(dia_date,False)):
        print("check the date format")
        dia_date = input("Enter diagnosed date in YYYY-MM-DD: ")
    treatment = input("Enter treatment: ")
    doc_notes = input("enter doctor notes: ")
   # query ="INSERT INTO medical_records (student_id, doctor_id, date, diagnosis, treatment, doctor_notes) where medical_record_id = %s"
    query = "INSERT INTO medical_records (student_id, doctor_id, date, diagnosis, treatment, doctor_notes) VALUES (%s,%s,%s,%s,%s,%s)"
    values = (pat_id,user_id,dia_date,diagnosis,treatment,doc_notes)
    try:
        cursor.execute(query,values)

        connection.commit()
        print("------------ Record is inserted into Medical History ------------")
        cursor.close()
        connection.close()
        return      
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        addMedicalHistory(user_id)
        connection.rollback() 
        cursor.close()
        connection.close() 


