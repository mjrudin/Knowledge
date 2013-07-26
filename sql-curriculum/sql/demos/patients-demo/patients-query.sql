-- You can use multiple joins in one query. Here I first join patients
-- with appointments (I give the join criteria in the 'ON' clause),
-- then again join with doctors.
--
-- If I had a 'WHERE' clause, it would go after the last 'ON'. The
-- order is SELECT to specify the columns you want, FROM for the
-- table, any and all JOINS (each with their own join criteria), and
-- then finally WHERE to filter the results.
--
-- Also, note that 'ON' and 'WHERE', even though they have
-- functionally the same effect with an INNER JOIN (the default JOIN
-- type), are used differently. ON expresses a criteria for joining a
-- record. WHERE is to filter down results.
SELECT 
  patients.name,
  doctors.name
FROM 
  patients
JOIN 
  appointments
  ON patients.id = appointments.patient_id
JOIN doctors
  ON doctors.id = appointments.doctor_id;
