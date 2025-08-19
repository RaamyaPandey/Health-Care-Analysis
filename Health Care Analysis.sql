-- Task - 1 / Inner and Equi Joins
SELECT 
    a.appointment_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization,
    a.appointment_date,
    a.reason
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id
WHERE a.status = 'Completed';

-- Task - 2/ Left Join with Null Handling
SELECT 
    p.patient_id,
    p.name,
    p.contact_number,
    p.address
FROM patients p
LEFT JOIN appointments a 
    ON p.patient_id = a.patient_id
WHERE a.patient_id IS NULL;

-- Task - 3/ Right Join and Aggregate Functions
SELECT 
    d.name AS doctor_name,
    d.specialization,
    COUNT(diag.diagnosis_id) AS total_diagnoses
FROM doctors d
RIGHT JOIN diagnoses diag 
    ON d.doctor_id = diag.doctor_id
GROUP BY d.name, d.specialization
ORDER BY total_diagnoses DESC;

-- Task - 4 Full Join for Overlapping Data
SELECT 
    COALESCE(a.appointment_id, 'No Appointment') AS appointment_id,
    COALESCE(diag.diagnosis_id, 'No Diagnosis') AS diagnosis_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    d.specialization,
    a.appointment_date,
    diag.diagnosis_date,
    diag.diagnosis
FROM appointments a
 JOIN diagnoses diag 
    ON a.patient_id = diag.patient_id AND a.doctor_id = diag.doctor_id
JOIN patients p ON COALESCE(a.patient_id, diag.patient_id) = p.patient_id
JOIN doctors d ON COALESCE(a.doctor_id, diag.doctor_id) = d.doctor_id;

-- Task - 4
SELECT 
    d.name AS doctor_name,
    p.name AS patient_name,
    COUNT(a.appointment_id) AS total_appointments,
    RANK() OVER (PARTITION BY d.doctor_id ORDER BY COUNT(a.appointment_id) DESC) AS patient_rank
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY d.doctor_id, d.name, p.name;

-- Task - 5 Window Functions (Ranking)
SELECT 
    d.name AS doctor_name,
    p.name AS patient_name,
    COUNT(a.appointment_id) AS total_appointments,
    RANK() OVER (PARTITION BY d.doctor_id ORDER BY COUNT(a.appointment_id) DESC) AS patient_rank
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
JOIN patients p ON a.patient_id = p.patient_id
GROUP BY d.doctor_id, d.name, p.name;

-- Task - 6 Conditional Expressions
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '51+'
    END AS age_group,
    COUNT(*) AS total_patients
FROM patients
GROUP BY age_group;

-- Task - 7. Numeric and String Functions
SELECT 
    UPPER(name) AS patient_name,
    contact_number
FROM patients
WHERE contact_number LIKE '%1234';

-- Task - 8. Subqueries for Filtering
SELECT p.patient_id, p.name
FROM patients p
WHERE p.patient_id IN (
    SELECT patient_id
    FROM diagnoses
    GROUP BY patient_id
    HAVING COUNT(DISTINCT treatment) = 1
       AND MAX(treatment) = 'Insulin'
);

-- Task - 9. Date and Time Functions
SELECT 
    diagnosis,
    AVG(DATEDIFF(treatment, diagnosis_date)) AS avg_duration_days
FROM diagnoses
WHERE treatment IS NOT NULL
GROUP BY diagnosis;

-- Task 10 - Complex Joins and Aggregation
SELECT 
    d.name AS doctor_name,
    d.specialization,
    COUNT(DISTINCT a.patient_id) AS unique_patients
FROM appointments a
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.name, d.specialization
ORDER BY unique_patients DESC
LIMIT 1;