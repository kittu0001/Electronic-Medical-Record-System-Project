import about_appointment as aa
import mysql.connector
from database_module import create_db_connection
import about_medical_history as am
import about_prescription as apre
import usables
import hashlib


def addDoctorDetails():
    connection = create_db_connection()
    cursor = connection.cursor()

    fname = input("Enter First Name: ")
    lname = input("Enter Last Name: ")
    specialty = input("Enter Specialty: ")

    query = "INSERT INTO doctors(first_name, last_name, specialty) values(%s,%s,%s)"
    values = (fname,lname,specialty)
    
    try:
        cursor.execute(query, values)
        connection.commit()
        print("------------Insertion successful------------")
        
        cursor.close()
        connection.close()
        
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()

        cursor.close()
        connection.close()

    uid = cursor.lastrowid
    usables.userSignup(uid,'DOCTOR')
       

def doctorAccessibilty(user_id):
    #check appointments
    #check patient medical history
    #add/update prescription
    connection = create_db_connection()
    cursor = connection.cursor()    
    print("Press 1 to check your appointments")
    # print("Press 2 to add new appointment")
    print("Press 2 to edit your appointments")

    print("Press 3 to check patient medical history")
    print("Press 4 to add to medical history")
    print("Press 5 to edit medical history")
    print("Press 6 to delete medical history")
    

    print("Press 7 to add new prescription")
    print("Press 8 to edit prescription")
    print("Press 9 to delete prescription")
    print("Press 10 for all appointments")
    print("Press 11 for all medical history")
    
    print("Press q to go back to main menu")
    command = input()

    if(command == "1"):
        aa.checkDoctorsAppointments(user_id)
    elif(command == "2"):
        aa.editAppointment(user_id)
    
    elif(command == "3"):
        am.getPatientMedicalHistory()
    elif(command == "4"):
        am.addMedicalHistory(user_id)
    elif(command == "5"):
        am.editMedicalHistory(user_id)
    elif(command == "6"):
        am.deleteMedicalHistory(user_id)

    elif(command == "7"):
        apre.addPrescription()
    elif(command == "8"):
        apre.editPrescription()
    elif(command == "9"):
        apre.deletePrescription()

    elif(command == "10"):
        aa.getAllAppointments()
    elif(command == "11"):
        am.getAllMedicalHistory()
    
    elif(command =="q"):
        return()
    
    cursor.close()
    connection.close()

def isDoctor():
    print("Doctor check page")
    connection = create_db_connection()
    cursor = connection.cursor()
    user = -1
    user_id = -1

    uname = input("Enter username: ")
   
    password = input("Enter password: ")
    hashed_password = hashlib.sha256(password.encode('utf-8')).hexdigest()
    query = "SELECT user_id FROM user WHERE  username= %s AND userpassword = %s"
    values = (uname, hashed_password)
    cursor.execute(query, values)

    # Fetch the first row of the result set
    doctor_id = cursor.fetchone()
    cursor.close()
    connection.close()

    # If the doctor_id is not None, the email and password are valid
    if doctor_id is not None:
        print("------------Login successful. Doctor ID:", doctor_id[0],"------------")
        user = 0
        user_id = doctor_id[0]
        
    else:
        print("Invalid credentials, please try again")
        user,user_id = isDoctor()
    
    cursor.close()
    connection.close()

    return (user,user_id)
    
    


def getAllDoctors():
    connection = create_db_connection()
    cursor = connection.cursor()

    query = "SELECT * FROM doctors"
    # Execute the query
    cursor.execute(query)

    # Fetch all the records
    records = cursor.fetchall()

    print("All Doctor records")
    for record in records:
        print(record)
    
    cursor.close()
    connection.close()

    return
