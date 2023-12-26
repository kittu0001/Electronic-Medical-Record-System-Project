CREATE TABLE audit_students (
    student_id INT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    dob date,
    email VARCHAR(80) NOT NULL,
    phone_number VARCHAR(30) NOT NULL,
    insurance_id INT NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_date DATETIME NOT NULL,
    action_by VARCHAR(20) NOT NULL CHECK (action_by IN ('student','DOCTOR')),
    action_name VARCHAR(20) not NULL
);

CREATE TABLE audit_doctors (
    doctor_id INT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(80) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_date DATETIME NOT NULL,
    action_by VARCHAR(20) NOT NULL CHECK (action_by IN ('student','DOCTOR')),
    action_name VARCHAR(20) not NULL
);

CREATE TABLE audit_insurance_details (
    insurance_id INT,
    provider_id INT NOT NULL,
    policy_number VARCHAR(100) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_date DATETIME NOT NULL,
    action_by VARCHAR(20) NOT NULL CHECK (action_by IN ('student','DOCTOR')),
    action_name VARCHAR(20) not NULL
);

CREATE TABLE audit_insurance_providers(
    provider_id INT,
    provider_name VARCHAR(50) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_date DATETIME NOT NULL,
    action_by VARCHAR(20) NOT NULL CHECK (action_by IN ('student','DOCTOR')),
    action_name VARCHAR(20) not NULL
);





CREATE TABLE audit_prescriptions (
    prescription_id INT,
    medical_record_id INT NOT NULL,
    medication_name VARCHAR(150) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    instructions VARCHAR(600) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_date DATETIME NOT NULL,
    action_by VARCHAR(20) NOT NULL CHECK (action_by IN ('student','DOCTOR')),
    action_name VARCHAR(20) not NULL
);

CREATE TABLE audit_appointments (
    appointment_id INT,
    student_id INT NOT NULL,
    doctor_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    room_number VARCHAR(50) NOT NULL,
    notes VARCHAR(700) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_date DATETIME NOT NULL,
    action_by VARCHAR(20) NOT NULL CHECK (action_by IN ('student','DOCTOR')),
    action_name VARCHAR(20) not NULL
);

CREATE TABLE audit_medical_records (
    medical_record_id INT,
    student_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date DATE NOT NULL,
    diagnosis VARCHAR(400) NOT NULL,
    treatment VARCHAR(600) NOT NULL,
    doctor_notes VARCHAR(1000) NOT NULL,
    action_type VARCHAR(50) NOT NULL,
    action_date DATETIME NOT NULL,
    action_by VARCHAR(20) NOT NULL CHECK (action_by IN ('student','DOCTOR')),
    action_name VARCHAR(20) not NULL
);


CREATE TABLE user(
	username varchar(20),
	userpassword varchar(100),
	user_is varchar(20) NOT NULL CHECK (user_is IN ('DOCTOR','STUDENT')),
    user_id INT,
    INDEX(user_id)
);

DELIMITER //
CREATE FUNCTION get_username(userid INT,useris varchar(20))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  DECLARE uname VARCHAR(50);
  SELECT username INTO uname FROM user WHERE user_id = userid and user_is = useris;
  RETURN uname;
END //

DELIMITER ; 
select 'hello';







DROP TRIGGER IF EXISTS trigger_before_update_for_student;
DELIMITER //
CREATE TRIGGER trigger_before_update_for_student
BEFORE UPDATE ON students
FOR EACH ROW
BEGIN
	INSERT INTO audit_students (student_id, first_name, last_name, dob, email, phone_number, insurance_id, action_type, action_date,action_by,action_name) 
    VALUES (OLD.student_id, OLD.first_name, OLD.last_name, OLD.dob, OLD.email, OLD.phone_number, OLD.insurance_id, 'Updated', NOW(),'student',get_username(OLD.student_id));
END //
DELIMITER ;




DROP TRIGGER IF EXISTS trigger_before_update_for_appointment;
DELIMITER //
CREATE TRIGGER trigger_before_update_for_appointment
BEFORE UPDATE ON appointments
FOR EACH ROW
BEGIN
	INSERT INTO audit_appointments (appointment_id,student_id, doctor_id, start_time, end_time, room_number, notes, action_type, action_date,action_by,action_name) 
    VALUES (OLD.appointment_id,OLD.student_id, OLD.doctor_id, OLD.start_time, OLD.end_time, OLD.room_number, OLD.notes, 'Updated', NOW(),'DOCTOR',get_username(OLD.doctor_id));
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_before_update_for_insurance;
DELIMITER //
CREATE TRIGGER trigger_before_update_for_insurance
BEFORE UPDATE ON insurance_details
FOR EACH ROW
BEGIN
	INSERT INTO audit_insurance_details (insurance_id, provider_id, policy_number, action_type, action_date,action_by,action_name) 
    VALUES (OLD.insurance_id,OLD.provider_id, OLD.policy_number, 'Updated', NOW(),'student',
    get_username((select student_id from students where insurance_id = OLD.insurance_id)));
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_before_update_for_medical_records;
DELIMITER //
CREATE TRIGGER trigger_before_update_for_medical_records
BEFORE UPDATE ON medical_records
FOR EACH ROW
BEGIN
	INSERT INTO audit_medical_records (medical_record_id,student_id, doctor_id, date, diagnosis, treatment, doctor_notes, action_type, action_date,action_by,action_name) 
    VALUES (OLD.medical_record_id,OLD.student_id, OLD.doctor_id, OLD.date, OLD.diagnosis, OLD.treatment, OLD.doctor_notes, 'Updated', NOW(),'DOCTOR',
    get_username( (select distinct doctor_id from appointments where student_id = OLD.student_id) ));
END //
DELIMITER ;
#not running
DROP TRIGGER IF EXISTS trigger_before_update_for_prescriptions;
DELIMITER //
CREATE TRIGGER trigger_before_update_for_prescriptions
BEFORE UPDATE ON prescriptions
FOR EACH ROW
BEGIN
	INSERT INTO audit_prescriptions (prescription_id, medical_record_id, medication_name, dosage, instructions, action_type, action_date,action_by,action_name) 
    VALUES (OLD.prescription_id,OLD.medical_record_id, OLD.medication_name, OLD.dosage, OLD.instructions, 'Updated', NOW(),'DOCTOR',
    get_username( (select  doctor_id from medical_records where medical_record_id = OLD.medical_record_id),'DOCTOR' ));
END //
DELIMITER ;

#---------------


DROP TRIGGER IF EXISTS trigger_after_insert_for_students;
DELIMITER //
CREATE TRIGGER trigger_after_insert_for_students
AFTER INSERT ON students
FOR EACH ROW
BEGIN
	INSERT INTO audit_students (student_id, first_name, last_name, dob, email, phone_number, insurance_id, action_type, action_date,action_by,action_name) 
    VALUES (NEW.student_id, NEW.first_name, NEW.last_name, NEW.dob, NEW.email, NEW.phone_number, NEW.insurance_id, 'Inserted', NOW(),'student',NEW.first_name);
END //
DELIMITER ;






DROP TRIGGER IF EXISTS trigger_after_insert_for_appointments;
DELIMITER //
CREATE TRIGGER trigger_after_insert_for_appointments
AFTER INSERT ON appointments
FOR EACH ROW
BEGIN
	INSERT INTO audit_appointments (appointment_id,student_id, doctor_id, start_time, end_time, room_number, notes, action_type, action_date,action_by,action_name) 
    VALUES (NEW.appointment_id,NEW.student_id, NEW.doctor_id, NEW.start_time, NEW.end_time, NEW.room_number, NEW.notes, 'Inserted', NOW(),'student',get_username(NEW.student_id));
END //
DELIMITER ;

#not
DROP TRIGGER IF EXISTS trigger_after_insert_for_insurance;
DELIMITER //
CREATE TRIGGER trigger_after_insert_for_insurance
AFTER INSERT ON insurance
FOR EACH ROW
BEGIN
	INSERT INTO audit_insurance (insurance_id,provider_id, provider_name, policy_number, action_type, action_date,action_by,action_name) 
    VALUES (NEW.insurance_id,NEW.provider_id, NEW.provider_name, NEW.policy_number, 'Inserted', NOW(),'student',
    get_username((select student_id from student_insurance where insurance_id = NEW.insurance_id)));
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_after_insert_for_medical_records;
DELIMITER //
CREATE TRIGGER trigger_after_insert_for_medical_records
AFTER INSERT ON medical_records
FOR EACH ROW
BEGIN
	INSERT INTO audit_medical_records (medical_record_id, student_id, doctor_id, date, diagnosis, treatment, doctor_notes, action_type, action_date,action_by,action_name) 
    VALUES (NEW.medical_record_id,NEW.student_id, NEW.doctor_id, NEW.date, NEW.diagnosis, NEW.treatment, NEW.doctor_notes, 'INSERTED', NOW(),'DOCTOR',
    get_username( (select distinct doctor_id from appointments where student_id = NEW.student_id) ));
END //
DELIMITER ;
#not working
DROP TRIGGER IF EXISTS trigger_after_insert_for_prescriptions;
DELIMITER //
CREATE TRIGGER trigger_after_insert_for_prescriptions
AFTER INSERT ON prescriptions
FOR EACH ROW
BEGIN
	INSERT INTO audit_prescriptions (prescription_id, medical_record_id, medication_name, dosage, instructions, action_type, action_date,action_by,action_name) 
    VALUES (NEW.prescription_id,NEW.medical_record_id, NEW.medication_name, NEW.dosage, NEW.instructions, 'Inserted', NOW(),'DOCTOR',
    get_username( (select distinct doctor_id from appointment where student_id = NEW.student_id) ));
END //
DELIMITER ;

#---------------



DROP TRIGGER IF EXISTS trigger_before_delete_for_appointments;
DELIMITER //
CREATE TRIGGER trigger_before_delete_for_appointments
BEFORE DELETE ON appointments
FOR EACH ROW
BEGIN
	INSERT INTO  audit_appointments (appointment_id,student_id, doctor_id, start_time, end_time, room_number, notes, action_type, action_date,action_by,action_name) 
    VALUES (OLD.appointment_id,OLD.student_id, OLD.doctor_id, OLD.start_time, OLD.end_time, OLD.room_number, OLD.notes, 'Deleted', NOW(),'student',get_username(OLD.student_id));
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_before_delete_for_insurance_details;
DELIMITER //
CREATE TRIGGER trigger_before_delete_for_insurance_details
BEFORE DELETE ON insurance_details
FOR EACH ROW
BEGIN
	INSERT INTO audit_insurance_details (insurance_id,provider_id, policy_number, action_type, action_date,action_by,action_name) 
    VALUES (OLD.insurance_id,OLD.provider_id, OLD.policy_number, 'Deleted', NOW(),'student',
    get_username((select student_id from students where insurance_id = OLD.insurance_id)));
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_before_delete_for_medical_records;
DELIMITER //
CREATE TRIGGER trigger_before_delete_for_medical_records
BEFORE DELETE ON medical_records
FOR EACH ROW
BEGIN
	INSERT INTO audit_medical_records (medical_record_id, student_id, doctor_id, date, diagnosis, treatment, doctor_notes, action_type, action_date,action_by,action_name)  
    VALUES (OLD.medical_record_id,OLD.student_id, OLD.doctor_id, OLD.date, OLD.diagnosis, OLD.treatment, OLD.doctor_notes, 'Deleted', NOW(),'DOCTOR',
    get_username( (select distinct doctor_id from appointment where student_id = OLD.student_id) ));
END //
DELIMITER ;
#not working
DROP TRIGGER IF EXISTS trigger_before_delete_for_prescriptions;
DELIMITER //
CREATE TRIGGER trigger_before_delete_for_prescriptions
BEFORE DELETE ON prescriptions
FOR EACH ROW
BEGIN
	INSERT INTO audit_prescriptions (prescription_id, medical_record_id, medication_name, dosage, instructions, action_type, action_date,action_by,action_name) 
    VALUES (OLD.prescription_id,OLD.medical_record_id, OLD.medication_name, OLD.dosage, OLD.instructions, 'Deleted', NOW(),'DOCTOR',
    get_username( (select distinct doctor_id from appointments where student_id = OLD.student_id) ));
END //
DELIMITER ;

#-----------
DROP TRIGGER IF EXISTS trigger_before_delete_for_appointments;
DELIMITER //
CREATE TRIGGER trigger_before_delete_for_appointments
BEFORE DELETE ON appointments
FOR EACH ROW
BEGIN
	INSERT INTO audit_appointments (appointment_id,student_id, doctor_id, start_time, end_time, room_number, notes, action_type, action_date,action_by,action_name) 
    VALUES (OLD.appointment_id,OLD.student_id, OLD.doctor_id, OLD.start_time, OLD.end_time, OLD.room_number, OLD.notes, 'Deleted', NOW(),'student',
    get_username(OLD.student_id,'student'));
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_before_delete_for_insurance_details;
DELIMITER //
CREATE TRIGGER trigger_before_delete_for_insurance_details
BEFORE DELETE ON insurance_details
FOR EACH ROW
BEGIN
	INSERT INTO audit_insurance_details (insurance_id,provider_id, policy_number, action_type, action_date,action_by,action_name) 
    VALUES (OLD.insurance_id,OLD.provider_id, OLD.policy_number, 'Deleted', NOW(),'student',
    get_username((select student_id from students where insurance_id = OLD.insurance_id)));
END //
DELIMITER ;

DROP TRIGGER IF EXISTS trigger_before_delete_for_medical_records;
DELIMITER //
CREATE TRIGGER trigger_before_delete_for_medical_records
BEFORE DELETE ON medical_records
FOR EACH ROW
BEGIN
	INSERT INTO audit_medical_records (medical_record_id, student_id, doctor_id, date, diagnosis, treatment, doctor_notes, action_type, action_date,action_by,action_name)  
    VALUES (OLD.medical_record_id,OLD.student_id, OLD.doctor_id, OLD.date, OLD.diagnosis, OLD.treatment, OLD.doctor_notes, 'Deleted', NOW(),'DOCTOR',
    get_username( (select distinct doctor_id from appointments where student_id = OLD.student_id) ));
END //
DELIMITER ;
#not working
DROP TRIGGER IF EXISTS trigger_before_delete_for_prescriptions;
DELIMITER //
CREATE TRIGGER trigger_before_delete_for_prescriptions
BEFORE DELETE ON prescriptions
FOR EACH ROW
BEGIN
	INSERT INTO audit_prescriptions (prescription_id, medical_record_id, medication_name, dosage, instructions, action_type, action_date,action_by,action_name) 
    VALUES (OLD.prescription_id,OLD.medical_record_id, OLD.medication_name, OLD.dosage, OLD.instructions, 'Deleted', NOW(),'DOCTOR',
    get_username( (select distinct doctor_id from appointments where student_id = OLD.student_id) ));
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE list_students_by_diagnosis(
    IN diagnosis VARCHAR(300)
)
BEGIN
    SELECT s.first_name, s.last_name, s.dob, s.email, s.phone_number, s.insurance_id
    FROM students s
    JOIN medical_records mr ON s.student_id = mr.student_id
    WHERE mr.diagnosis LIKE CONCAT('%', diagnosis, '%');
END //

DELIMITER ;
CALL list_students_by_diagnosis ('asthama');


