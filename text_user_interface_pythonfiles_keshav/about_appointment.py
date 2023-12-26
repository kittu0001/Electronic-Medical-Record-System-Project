import mysql.connector
from database_module import create_db_connection
import usables 

def checkDoctorsAppointments(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 

    query = "SELECT * FROM appointments where doctor_id = %s"
    values = (user_id,)
    # Execute the query
    cursor.execute(query,values)
    
    records = cursor.fetchall()

    print("Your appointments")
    for record in records:
        print(record)
    
    cursor.close()
    connection.close()

def checkUrAppointment(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    # pat_id = input("Enter your id: ")
    query = "SELECT * FROM appointments where student_id = %s"
    values = (user_id,)
    # Execute the query
    cursor.execute(query, values)
    
    records = cursor.fetchall()

    if(len(records)==0):
        print("You have no appointments")
    else:
        print("All your appointments")
        for record in records:
            print(record)
    
    cursor.close()
    connection.close()


def addAppointment(user_id):
    connection = create_db_connection()
    cursor = connection.cursor()
    query = "INSERT INTO appointments (student_id, doctor_id, start_time, end_time, room_number, notes) VALUES (%s,%s,%s,%s,%s,%s)"
    stu_id = input("Enter your id: ")
    start_time = input("Enter appointment_date; ")
    while(not usables.valid_date(start_time,True)):
        start_time = input("Enter date in this format YYYY-MM-DD H:M:S - ")
    end_time = input("Enter appointment_end_date; ")
    while(not usables.valid_date(end_time,True)):
        end_time = input("Enter date in this format YYYY-MM-DD H:M:S - ")
    doc_id = input("Enter doc_id: ")
    room_number = input("Enter room number: ")
    notes = input("Enter reason/symptoms: ")

    values = (stu_id,doc_id,start_time,end_time,room_number,notes)
    try:
        cursor.execute(query,values)

        connection.commit()
        print("------------Added appointment successfully------------")
        cursor.close()
        connection.close()
        checkUrAppointment(user_id)  
        return      
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback() 
        cursor.close()
        connection.close() 





def getAllAppointments():
    connection = create_db_connection()
    cursor = connection.cursor() 

    query = "SELECT * FROM appointments"
    # Execute the query
    cursor.execute(query)
    
    records = cursor.fetchall()

    print("All appointments")
    for record in records:
        print(record)
    
    cursor.close()
    connection.close()




def editAppointment(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    checkDoctorsAppointments(user_id)
    
    app_id = input("Enter appointment id of the record that you want to edit: ")
        
    

    start_time = input("Enter appointment_date; ")
    while(not usables.valid_date(start_time,True)):
        start_time = input("Enter date in this format YYYY-MM-DD H:M:S - ")
    end_time = input("Enter appointment_end_date; ")
    while(not usables.valid_date(end_time,True)):
        end_time = input("Enter date in this format YYYY-MM-DD H:M:S - ")
    doc_id = input("Enter doc_id: ")
    room_number = input("Enter room number: ")
    notes = input("Enter reason/symptoms: ")

    

    query2 = "UPDATE appointments SET start_time = %s, end_time = %s, doc_id =%s, room_number = %s, notes = %s where appointment_id = %s and doctor_id = %s"

    values2 = (app_id,start_time,end_time,doc_id,room_number,notes,app_id,user_id)
    # Execute the query
    try:
        cursor.execute(query2,values2)

        connection.commit()
        print("------------Update successful------------")
        cursor.close()
        connection.close()
        checkDoctorsAppointments(user_id)  
        return      
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        editAppointment(user_id)
        connection.rollback() 
        cursor.close()
        connection.close() 

def ifItsUserRecord(cursor,id1,id2):
    sub_query = "SELECT student_id from appointments where appointment_id = %s"
    sub_values = (id1,)
    cursor.execute(sub_query,sub_values)
    sub_result = cursor.fetchone()
    # print("student_id retrieved is: ",sub_result)
    if(sub_result is not None and sub_result[0] == id2 ):
        return True
    else:
        print("Please check your appointment id. You cannot modify other users' record")
        return False

def cancelAppointment(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    # stu_id = input("Enter your student id: ")
    checkUrAppointment(user_id)
    user_record = False
    app_id = -1
    while(not user_record):
        app_id = input("Enter appointment id of the record that you want to cancel/delete: ")
        user_record = ifItsUserRecord(cursor,app_id,user_id)

    query = "DELETE from appointments where appointment_id = %s and student_id = %s"
    
    values = (app_id,user_id)

    # Execute the query
    try:
        cursor.execute(query,values)

        connection.commit()
        print("------------Your appointment is cancelled------------")
        cursor.close()
        connection.close()
        return      
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        editAppointment(user_id)
        connection.rollback() 
        cursor.close()
        connection.close() 
        
    


    