import mysql.connector
import about_student as ap
import about_doctor as ad
import database_module as dm


user = -1  # doctor = 0, patient = 1, other/guest = 2 
user_id = -1 #id of doctors / patients

                            

def isOther():
    print("New user registration page")
    print("Press 1 to register new Doctor")
    print("Press 2 to register new Patient")
    print("Press any other to go back to main menu")
    command = input()

    if((command) == "1") :
        print("Before insertion")
        ad.getAllDoctors()
        if(ad.addDoctorDetails()):
            #userSignup()
            print("Signup Completed, Login now")
            print("after insertion")
            ad.getAllDoctors()
            main()
            


    elif((command) == "2") :
        print("Before insertion")
        ap.getAllPatients()
        if(ap.addPatientDetails()):
            #userSignup()
            print("Signup Completed, Login now")
            
            print("after insertion")
            ap.getAllPatients()
            
            main()
    else:
        main()
    
        



def main():
    print("Welcome to Outpatient Clinic Database!!!")
    print("Press 1 if you are Doctor")
    print("Press 2 if you are registered patient")
    print("Press 3 if you are new")

    print("Press q to quit")
    

    command = input()
    if (command == 'q'):
        return
    elif(command == "1") :
        user,user_id = ad.isDoctor()
        #usables.setUserId(user_id)
        print("user = ",user," user_id = ",user_id)

        if(user == 0):  
            ad.doctorAccessibilty(user_id)
    elif(command == "2") :
        user,user_id = ap.isPatient()
        #usables.setUserId(user_id)
        
        print("user = ",user," user_id = ",user_id)
        if(user == 1):  
            ap.patientAccessibilty(user_id)
    elif(command == "3") :    
        isOther()
    else:
        main()

if dm.create_db_connection().is_connected():
        print("Connected to database")
main()


#IMPORTANT
# Add tables and other features to enable audit trail so that every query or change of
# every record in the database is monitored and the entire history of the data in the
# database is captured. Basically, every time a record is accessed (queried, inserted,
# or changed), the user and time of access is recorded. Every time any field of a record
# is updated or deleted, the previous value of the record is saved
