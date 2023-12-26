USE student_electronic_medical_record2;
INSERT INTO appointments (appointment_id, student_id, doctor_id, start_time, end_time, room_number, notes)
VALUES (4, 4, 2, '2023-03-25 09:00:00', '2023-03-25 09:30:00', 'Room 102', 'Annual checkup'),
       (5, 4, 2, '2023-03-24 09:00:00', '2023-03-25 09:30:00', 'Room 102', 'Abdominal pain'),
	   (1, 1, 1, '2023-03-23 09:00:00', '2023-03-23 09:30:00', 'Room 101', 'Annual checkup'),
       (2, 2, 2, '2023-03-24 10:00:00', '2023-03-24 10:30:00', 'Room 102', 'Sore throat'),
       (3, 3, 3, '2023-03-25 11:00:00', '2023-03-25 11:30:00', 'Room 103', 'Suffering from memory loss');
       
 -- Insert data into ClinicalCare table
INSERT INTO clinicalcare (CareID, Visit_id, SignsAndSymptoms, DischargeDiagnosis, Prescriptions, ExamOrders, TestOrders)
VALUES
(1, 1, 'Fever, cough', 'Upper respiratory infection', 'Amoxicillin', 'Physical examination', 'None'),
(2, 2, 'Abdominal pain, nausea', 'Gastritis', 'Omeprazole', 'Abdominal exam', 'Stool culture'),
(3, 3, 'Headache, fatigue', 'Migraine', 'Sumatriptan', 'Neurological exam', 'None'),
(4, 4, 'Back pain', 'Muscle strain', 'Ibuprofen', 'Musculoskeletal exam', 'None');

INSERT INTO diagnosis (diagnosis_id, visit_id, diagnosis_name)
VALUES
(1, 1, 'Upper respiratory infection'),
(2, 2, 'Gastritis'),
(3, 3, 'Migraine'),
(4, 4, 'Muscle strain'),
(5, 5, 'Sinusitis'),
(6, 6, 'Anxiety disorder');
#(7, 7, 'Depression'),
#(8, 8, 'Sprained ankle');

-- Insert data into doctors table
INSERT INTO doctors (doctor_id, first_name, last_name, specialty)
VALUES (1, 'John', 'Smith', 'Cardiology'),
       (2, 'Sarah', 'Johnson', 'Pediatrics'),
       (3, 'Michael', 'Lee', 'Neurology'),
       (4, 'Jennifer', 'Garcia', 'Obstetrics'),
       (5, 'David', 'Kim', 'Dermatology');
       
       
-- Insert data into insurance_details table
INSERT INTO insurance_details (insurance_id, provider_id, policy_number)
VALUES (1, 1, 'ABC123'),
       (2, 2, 'DEF456'),
       (3, 3, 'GHI789'),
       (4, 4, 'JKL012'),
       (5, 5, 'MNO345');

-- Insert data into insurance_providers table
INSERT INTO insurance_providers (provider_id, provider_name)
VALUES (1, 'Blue Cross Blue Shield'),
       (2, 'Aetna'),
       (3, 'UnitedHealthcare'),
       (4, 'Cigna'),
       (5, 'Humana');
       
-- Insert data into medical_records table       
INSERT INTO medical_records (medical_record_id, student_id, doctor_id, date, diagnosis, treatment, doctor_notes)
VALUES
(1, 1, 1, '2022-01-15', 'Upper respiratory infection', 'Antibiotics', 'Patient advised to rest and drink plenty of fluids.'),
(2, 2, 2, '2022-02-01', 'Gastritis', 'Antacids', 'Patient advised to avoid spicy and acidic foods.'),
(3, 3, 3, '2022-02-15', 'Migraine', 'Painkillers', 'Patient advised to avoid triggers and get enough sleep.'),
(4, 4, 4, '2022-03-01', 'Muscle strain', 'Physical therapy', 'Patient advised to do stretching exercises.'),
(5, 5, 5, '2022-03-15', 'Sinusitis', 'Antibiotics', 'Patient advised to use saline nasal spray and avoid allergens.');
#(6, 6, 6, '2022-04-01', 'Anxiety disorder', 'Counseling and medication', 'Patient advised to practice relaxation techniques.'),
#(7, 7, 7, '2022-04-15', 'Depression', 'Counseling and medication', 'Patient advised to continue therapy and medication regimen.');

-- Insert data into prescriptions table
INSERT INTO prescriptions (prescription_id, medical_record_id, medication_name, dosage, instructions)
VALUES (1, 1, 'Lisinopril', '10mg', 'Take once daily'),
	   (3, 3, 'Amoxicillin', '500mg', 'Take 3 times daily for 10 days'),
       (4, 4, 'Metformin', '500mg', 'Take with food twice daily'),
       (5, 5, 'Ibuprofen', '200mg', 'Take every 4-6 hours as needed'),
       #(6, 6, 'Levothyroxine', '50mcg', 'Take once daily on an empty stomach'),
       #(7, 7, 'Albuterol', '90mcg', 'Inhale 2 puffs every 4-6 hours as needed'),
       (2, 2, 'Triamcinolone', '0.1%', 'Apply to affected area twice daily');
       
-- Insert data into signs_and_symptoms table
INSERT INTO signs_and_symptoms (signs_and_symptoms_id, visit_id, symptom)
VALUES (1, 1, 'Headache'),
(2, 2, 'Rash'),
(3, 3, 'Cough'),
(4, 4, 'Abdominal pain'),
(5, 5, 'Nausea'),
(6, 6, 'Dizziness');
#(7, 7, 'Shortness of breath'),
#(8, 8, 'Joint pain');

-- Insert data into staff table
INSERT INTO staff (staff_id, first_name, last_name, position)
VALUES (1, 'Mary', 'Jones', 'Receptionist'),
       (2, 'Robert', 'Brown', 'Nurse'),
       (3, 'Jessica', 'Taylor', 'Lab Technician'),
       (4, 'William', 'Davis', 'Pharmacist'),
       (5, 'Karen', 'Wilson', 'Medical Assistant');

-- Insert data into students table       
INSERT INTO students (student_id, first_name, last_name, dob, email, phone_number, insurance_id)
VALUES (1, 'Emily', 'Johnson', '2000-01-01', 'emily.johnson@example.com', '123-456-7890', 1),
(2, 'Alex', 'Garcia', '1999-02-02', 'alex.garcia@example.com', '234-567-8901', 2),
(3, 'Ava', 'Lee', '1998-03-03', 'ava.lee@example.com', '345-678-9012', 3),
(4, 'Ethan', 'Kim', '1997-04-04', 'ethan.kim@example.com', '456-789-0123', 4),
(5, 'Sophia', 'Chen', '1996-05-05', 'sophia.chen@example.com', '567-890-1234', 5);
#(6, 'Olivia', 'Martinez', '1995-06-06', 'olivia.martinez@example.com', '678-901-2345', 3),
#(7, 'Noah', 'Gonzalez', '1994-07-07', 'noah.gonzalez@example.com', '789-012-3456', 2),
#(8, 'Emma', 'Perez', '1993-08-08', 'emma.perez@example.com', '890-123-4567', 1),
#(9, 'William', 'Rodriguez', '1992-09-09', 'william.rodriguez@example.com', '901-234-5678', 4),
#(10, 'Isabella', 'Hernandez', '1991-10-10', 'isabella.hernandez@example.com', '012-345-6789', 5);

-- Insert data into visits table
INSERT INTO visits (visit_id, student_id, doctor_id, date, time_in, time_out, facility, notes)
VALUES (1, 1, 1, '2022-01-01', '2022-01-01 08:00:00', '2022-01-01 08:30:00', 'Student Health Center', 'Annual physical exam'),
(2, 2, 2, '2022-01-02', '2022-01-02 09:00:00', '2022-01-02 09:30:00', 'Student Health Center', 'Follow-up appointment for flu shot'),
(3, 3, 3, '2022-01-03', '2022-01-03 10:00:00', '2022-01-03 10:30:00', 'University Hospital', 'X-ray imaging for leg injury'),
(4, 4, 1, '2022-01-04', '2022-01-04 11:00:00', '2022-01-04 11:30:00', 'Student Health Center', 'Routine checkup'),
(5, 5, 2, '2022-01-05', '2022-01-05 12:00:00', '2022-01-05 12:30:00', 'Student Health Center', 'Eye exam'),
(6, 1, 3, '2022-01-06', '2022-01-06 13:00:00', '2022-01-06 13:30:00', 'University Hospital', 'Surgery consultation');

INSERT INTO user(username, userpassword, user_is, user_id)
VALUES#('Emily', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'STUDENT', 1),
#('Alex', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'STUDENT', 2),
#('sarah', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'DOCTOR', 2),
('Ava', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'STUDENT', 3),
('Ethan', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'STUDENT', 4),
('Sophia', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'STUDENT', 5),
('John', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'DOCTOR', 1),
('Michael', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'DOCTOR', 3),
('Jennifer', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'DOCTOR', 4),
('David', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'DOCTOR', 5);














