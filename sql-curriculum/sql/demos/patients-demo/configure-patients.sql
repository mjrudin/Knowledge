CREATE TABLE patients (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE doctors (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE appointments (
  id INTEGER PRIMARY KEY,
  patient_id INTEGER NOT NULL,
  doctor_id INTEGER NOT NULL,

  FOREIGN KEY (patient_id) REFERENCES patients(id),
  FOREIGN KEY (doctor_id)  REFERENCES doctors(id)
);

INSERT INTO patients ('name')
     VALUES ('Sickly Sam'), ('Healthy Hugo');

INSERT INTO doctors ('name')
     VALUES ('Jonas Salk'), ('Doctor Robert');

INSERT INTO appointments ('patient_id', 'doctor_id')
     VALUES (1, 1), (1, 2), -- sickly sam has two appointments
            (2, 2); -- Healthy Hugo has one.
