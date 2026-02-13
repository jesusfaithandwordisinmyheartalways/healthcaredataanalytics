
DROP TABLE IF EXISTS patient_visits_original;
DROP TABLE IF EXISTS patient_visits_updated;
DROP TABLE IF EXISTS combined_patient_visits;


CREATE TABLE patient_visits_original (
    Practice_ID VARCHAR(10),
    Patient_ID VARCHAR(10),
    Visit_Date TIMESTAMP,
    Visit_Type VARCHAR(50),
    Doctor VARCHAR(50),
    Department VARCHAR(50),
    Billing_Amount NUMERIC(10,2),
    Outcome VARCHAR(50)
);

INSERT INTO patient_visits_original
(Practice_ID, Patient_ID, Visit_Date, Visit_Type, Doctor, Department, Billing_Amount, Outcome)
VALUES
('P004','PT1000','2025-09-07','Follow-up','Dr. Johnson','Orthopedics',3408.81,'Successful'),
('P005','PT1001','2025-07-09','Follow-up','Dr. Lee','Pediatrics',680.87,'Successful'),
('P003','PT1002','2025-07-18','Follow-up','Dr. Johnson','Orthopedics',3491.97,'Ongoing');


CREATE TABLE patient_visits_updated (
    Patient_ID VARCHAR(10),
    Attending_Doctor VARCHAR(50),
    Dept VARCHAR(50),
    Charge NUMERIC(10,2),
    Outcome_Status VARCHAR(50)
);


INSERT INTO patient_visits_updated
(Patient_ID, Attending_Doctor, Dept, Charge, Outcome_Status)
VALUES
('PT1000','Dr. Johnson','Orthopedics',3408.81,'Successful'),
('PT1001','Dr. Lee','Pediatrics',680.87,'Successful'),
('PT1002','Dr. Johnson','Orthopedics',3491.97,'Ongoing');


CREATE TABLE combined_patient_visits AS
SELECT 
    o.Practice_ID,
    o.Patient_ID,
    o.Visit_Date,
    o.Visit_Type,
    o.Doctor,
    o.Department,
    o.Billing_Amount,
    o.Outcome,
    u.Attending_Doctor,
    u.Dept,
    u.Charge,
    u.Outcome_Status,

   
    RANK() OVER (PARTITION BY o.Doctor ORDER BY o.Billing_Amount DESC) AS doctor_billing_rank,
    SUM(o.Billing_Amount) OVER (PARTITION BY o.Department ORDER BY o.Visit_Date) AS running_total_by_department,
    COUNT(*) OVER (PARTITION BY o.Outcome) AS outcome_count,
    ROW_NUMBER() OVER (PARTITION BY o.Doctor ORDER BY o.Visit_Date DESC) AS latest_visit_rank,
    PERCENT_RANK() OVER (PARTITION BY o.Department ORDER BY o.Billing_Amount) AS billing_percent_rank_by_dept,
    o.Billing_Amount * 100.0 / SUM(o.Billing_Amount) OVER () AS percent_of_total_billing

FROM patient_visits_original o
JOIN patient_visits_updated u
ON o.Patient_ID = u.Patient_ID;


SELECT * FROM combined_patient_visits
ORDER BY Visit_Date;