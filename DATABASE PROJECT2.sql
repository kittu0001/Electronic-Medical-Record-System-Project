CREATE DATABASE Student_Electronic_Medical_Record2;
USE Student_Electronic_Medical_Record2;

CREATE TABLE insurance_providers (
    provider_id INT PRIMARY KEY auto_increment,
    provider_name VARCHAR(50) NOT NULL,
    INDEX(provider_id)
);

CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY auto_increment,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(80) NOT NULL,
    INDEX(doctor_id)
);

CREATE TABLE staff (
    staff_id INT PRIMARY KEY auto_increment,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    position VARCHAR(150) NOT NULL,
    INDEX(staff_id)
);

CREATE TABLE insurance_details (
    insurance_id INT PRIMARY KEY  auto_increment,
    provider_id INT NOT NULL,
    policy_number VARCHAR(100) NOT NULL,
	INDEX(insurance_id),
    CONSTRAINT ins_prov FOREIGN KEY (provider_id) REFERENCES insurance_providers(provider_id) on DELETE CASCADE on UPDATE CASCADE
);
CREATE TABLE students (
    student_id INT PRIMARY KEY  auto_increment,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dob date,
    email VARCHAR(80) NOT NULL,
    phone_number VARCHAR(30) NOT NULL,
    insurance_id INT NOT NULL,
    INDEX(student_id),
    CONSTRAINT stu_ins FOREIGN KEY (insurance_id) REFERENCES insurance_details(insurance_id) on DELETE CASCADE on UPDATE CASCADE
);
	

CREATE TABLE appointments (
    appointment_id INT PRIMARY KEY auto_increment,
    student_id INT NOT NULL,
    doctor_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    room_number VARCHAR(50) NOT NULL,
    notes VARCHAR(700) NOT NULL,
	INDEX(appointment_id),
    CONSTRAINT app_stu FOREIGN KEY (student_id) REFERENCES students(student_id) on DELETE CASCADE on UPDATE CASCADE,
    CONSTRAINT app_doc FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE medical_records (
    medical_record_id INT PRIMARY KEY auto_increment,
    student_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date DATE NOT NULL,
    diagnosis VARCHAR(400) NOT NULL,
    treatment VARCHAR(600) NOT NULL,
    doctor_notes VARCHAR(1000) NOT NULL,
    INDEX(medical_record_id),
    CONSTRAINT med_stu FOREIGN KEY (student_id) REFERENCES students(student_id) on DELETE CASCADE on UPDATE CASCADE,
    CONSTRAINT med_doc FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE visits (
    visit_id INT PRIMARY KEY auto_increment,
    student_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date DATE NOT NULL,
    time_in DATETIME NOT NULL,
    time_out DATETIME NOT NULL,
    facility VARCHAR(30) NOT NULL,
    notes VARCHAR(600) NOT NULL,
    INDEX(visit_id),
    CONSTRAINT vis_stu FOREIGN KEY (student_id) REFERENCES students(student_id) on DELETE CASCADE on UPDATE CASCADE,
    CONSTRAINT vis_doc FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE signs_and_symptoms (
    signs_and_symptoms_id INT PRIMARY KEY auto_increment,
    visit_id INT NOT NULL,
    symptom VARCHAR(200) NOT NULL,
	INDEX(signs_and_symptoms_id),
    CONSTRAINT sign_vis FOREIGN KEY (visit_id) REFERENCES visits(visit_id) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE prescriptions (
    prescription_id INT PRIMARY KEY auto_increment,
    medical_record_id INT NOT NULL,
    medication_name VARCHAR(150) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    instructions VARCHAR(600) NOT NULL,
    INDEX(prescription_id),
    CONSTRAINT pres_med FOREIGN KEY (medical_record_id) REFERENCES medical_records(medical_record_id) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE ClinicalCare (
  CareID INT PRIMARY KEY auto_increment,
  Visit_id INT NOT NULL,
  SignsAndSymptoms VARCHAR(500) NOT NULL,
  DischargeDiagnosis VARCHAR(500) NOT NULL,
  Prescriptions VARCHAR(500) NOT NULL,
  ExamOrders VARCHAR(500) NOT NULL,
  TestOrders VARCHAR(500) NOT NULL,
  INDEX(CareID),
  CONSTRAINT clin_vis FOREIGN KEY (Visit_id) REFERENCES visits(visit_id) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE diagnosis (
    diagnosis_id INT PRIMARY KEY auto_increment,
    visit_id INT NOT NULL,
    diagnosis_name VARCHAR(500) NOT NULL,
    INDEX(diagnosis_id),
    CONSTRAINT diag_vis FOREIGN KEY (visit_id) REFERENCES visits(visit_id) on DELETE CASCADE on UPDATE CASCADE
);

CREATE TABLE user(
	username varchar(20),
	userpassword varchar(100),
	user_is varchar(20) NOT NULL CHECK (user_is IN ('DOCTOR','STUDENT')),
    user_id INT,
    INDEX(user_id)
);
DELIMITER //
CREATE PROCEDURE getuser_id(IN userid INT)
BEGIN
    DECLARE uid INT DEFAULT -1;
    
    -- set the value of uid
    SET uid = userid;
    
    -- select the value of uid as a result set
    SELECT uid;
END //
DELIMITER ;

CREATE VIEW user_view AS
SELECT *
FROM user;
create view student_view 
as SELECT *
FROM students;
create view doctor_view 
as SELECT *
FROM doctors;
select * from doctor_view;
    
