import mysql.connector
import about_appointment as aa
import about_medical_history as am
import about_prescription as apre
import about_insurance as ai
import usables
import hashlib

from database_module import create_db_connection

def checkUrInfo(user_id):
    connection = create_db_connection()
    cursor = connection.cursor() 
    query = "SELECT * FROM students where student_id = %s"
    values = (user_id,)
    
    # Execute the query
    cursor.execute(query,values)

    # Fetch all the records
    record = cursor.fetchone()

    print("Your Info:")
    print(record)

    cursor.close()
    connection.close()

    return


def editPatientDetails(user_id):
    connection = create_db_connection()
    cursor = connection.cursor()
    fname = input("Enter First Name: ")
    lname = input("Enter Last Name: ")
    dob = input("Enter date of birth: ")
    email = input("Enter email: ")
    ph_no = input("Enter Phone number: ")
    insurance_id = input("Enter insurance_id: ")

    query = "UPDATE  students set first_name =%s, last_name=%s, dob=%s, email=%s, phone_number=%s, insurance_id=%s where student_id = %s"
    values = (fname,lname,dob,email,ph_no,insurance_id,user_id)
    
    try:
        cursor.execute(query, values)
        connection.commit()
        cursor.close()
        connection.close()
        print("------------Update successful------------")
        return True
    except mysql.connector.Error as error:
        print("Error: {}".format(error))
        connection.rollback()
        
        cursor.close()
        connection.close()
        editPatientDetails(user_id)
        return False




def getAllPatients():
    connection = create_db_connection()
    cursor = connection.cursor() 
    query = "SELECT * FROM students"
    
    # Execute the query
    cursor.execute(query)

    # Fetch all the records
    records = cursor.fetchall()

    print("All student records")
    for record in records:
        print(record)

    cursor.close()
    connection.close()

    return



def isPatient():
    print("student check page")

    connection = create_db_connection()
    cursor = connection.cursor() 
    user = -1
    user_id = -1
   

    uname = input("Enter username: ")
    # lname = input("Enter Last Name: ")
    password = input("Enter password: ")
    hashed_password = hashlib.sha256(password.encode('utf-8')).hexdigest()
    query = "SELECT user_id FROM user WHERE  username= %s AND userpassword = %s"
    values = (uname, hashed_password)
    cursor.execute(query, values)

    # Fetch the first row of the result set
    student_id = cursor.fetchone()
    cursor.close()
    connection.close()

    # If the student_id is not None, the credentials are valid
    if student_id is not None:
        print("------------Login successful. Student ID:", student_id[0],"------------")
        user = 1
        user_id = student_id[0]

    else:
        print("Invalid credentials, please try again")
        user, user_id = isPatient()

    return (user, user_id)


def addPatientDetails():
    connection = create_db_connection()
    cursor = connection.cursor() 
    fname = input("Enter First Name: ")
    lname = input("Enter Last Name: ")
    dob = input("Enter date of birth: ")
    email = input("Enter email: ")
    ph_no = input("Enter Phone number: ")
    insurance_id = input("Enter insurance_id: ")

    query = "INSERT INTO students (first_name, last_name, dob, email, phone_number, insurance_id) values(%s,%s,%s,%s,%s,%s)"
    values = (fname,lname,dob,email,ph_no,insurance_id)
    
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

    uid = cursor.lastrowid

    usables.usersignup(uid,'STUDENT')

    
        

def patientAccessibilty(user_id):
    #check appointments
    #check patient medical history
    #add/update prescription
    connection = create_db_connection()
    cursor = connection.cursor() 
    print("Press 1 to check your appointment")
    print("Press 2 to make new appointment")
    print("Press 3 to cancel your appointment")

    print("Press 4 to check your medical history")
    
    
    print("Press 5 to check your prescription")

    print("Press 6 to check your insurance")
    print("Press 7 to add insurance")
    print("Press 8 to edit your insurance")
    print("Press 9 to delete your insurance")

    print("Press 10 to check your info")
    print("Press 11 to edit your info")

    print("Press q to go back to main menu")

    command = input()

    if(command=="1"):
        aa.checkUrAppointment(user_id)
    elif(command=="2"):
        aa.addAppointment(user_id)
    elif(command=="3"):
        aa.cancelAppointment(user_id) 
    elif(command=="4"):
        am.checkUrMedicalHistory(user_id)
    elif(command=="5"):
        apre.checkUrPrescriptions(user_id)   
    elif(command=="6"):
        ai.checkUrInsurance(user_id)   
    elif(command=="7"):
        ai.addInsurance(user_id)
    elif(command=="8"):
        ai.editInsurance(user_id)  
    
    elif(command=="9"):
        ai.deleteInsurance(user_id)
    elif(command=="10"):
        checkUrInfo(user_id) 
    elif(command=="11"):
        editPatientDetails(user_id)              
    elif(command  == "q"):
        return




    cursor.close()
    connection.close()

    # if(command == "1")
 