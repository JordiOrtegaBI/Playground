<<<<<<< HEAD

-- Evitamos errores si relanzamos códigos
DROP TABLE IF EXISTS departamento CASCADE;
DROP TABLE IF EXISTS recursos_humanos CASCADE;
DROP TABLE IF EXISTS bootcamp CASCADE;
DROP TABLE IF EXISTS recursos_humanos_bootcamp CASCADE;
DROP TABLE IF EXISTS modulo CASCADE;
DROP TABLE IF EXISTS bootcamp_modulo CASCADE;
DROP TABLE IF EXISTS alumno CASCADE;
DROP TABLE IF EXISTS bootcamp_alumno CASCADE;
DROP TABLE IF EXISTS calificaciones CASCADE;
DROP TABLE IF EXISTS transacciones CASCADE;
DROP TABLE IF EXISTS metodo_pago CASCADE;
DROP TABLE IF EXISTS asistencia CASCADE;

-- Creamos la tabla departamento
CREATE TABLE departamento (
    departamento_id SERIAL PRIMARY KEY,
    departamento_ds VARCHAR(255) NOT NULL
);

INSERT INTO departamento (departamento_ds) VALUES
('Recursos Humanos'),
('Administracion'),
('Bolsa de Empleo'),
('Marketing'),
('Profesorado');

-- Creamos la tabla recursos_humanos
CREATE TABLE recursos_humanos (
	empleado_id SERIAL PRIMARY KEY,
    departamento_id INT NOT NULL REFERENCES departamento(departamento_id),
    fecha_alta_dt DATE NOT NULL DEFAULT CURRENT_DATE,
    salario_nm INT NOT NULL CHECK (salario_nm > 0),
    email_ds VARCHAR(255) NOT NULL UNIQUE,
    telefono_ds VARCHAR(255) NOT NULL UNIQUE,
    direccion_ds VARCHAR(255),
    nombre_ds VARCHAR(255) NOT NULL,
    primer_apellido_ds VARCHAR(255) NOT NULL,
    segundo_apellido_ds VARCHAR(255) NOT NULL 
);

INSERT INTO recursos_humanos (departamento_id, fecha_alta_dt, salario_nm, email_ds, telefono_ds, direccion_ds, nombre_ds, primer_apellido_ds, segundo_apellido_ds) VALUES
(1, '2024-01-10', 30000, 'juan.perez@example.com', '555-1234', 'Calle Falsa 123', 'Juan', 'Pérez', 'García'),
(2, '2024-02-15', 45000, 'maria.gonzalez@example.com', '555-5678', 'Avenida Siempre Viva 456', 'María', 'González', 'López'),
(3, '2024-03-20', 50000, 'carlos.martinez@example.com', '555-8765', 'Plaza Mayor 789', 'Carlos', 'Martínez', 'Fernández'),
(4, '2024-04-25', 60000, 'luisa.sanchez@example.com', '555-4321', 'Boulevard de la Vida 321', 'Luisa', 'Sánchez', 'Romero'),
(5, '2024-05-30', 55000, 'pedro.rodriguez@example.com', '555-2468', 'Calle de los Sueños 654', 'Pedro', 'Rodríguez', 'Hernández');

-- Creamos la tabla bootcamp
CREATE TABLE bootcamp (
	bootcamp_id SERIAL PRIMARY KEY,
    bootcamp_ds VARCHAR(255) NOT NULL,
    capacidad_nm INT NOT NULL
);

ALTER SEQUENCE bootcamp_bootcamp_id_seq RESTART WITH 101;

INSERT INTO bootcamp (bootcamp_ds, capacidad_nm) VALUES
('Desarrollo Web', 30),             -- Bootcamp para aprender desarrollo web
('Data Science', 25),               -- Bootcamp para aprender ciencia de datos
('Inteligencia Artificial', 20),    -- Bootcamp para aprender IA
('Marketing Digital', 15),          -- Bootcamp sobre marketing en línea
('Ciberseguridad', 18);             -- Bootcamp sobre seguridad informática

-- Creamos la tabla recursos_humanos_bootcamp
CREATE TABLE recursos_humanos_bootcamp (
	rec_humanos_bootcamp_id SERIAL PRIMARY KEY,
    empleado_id INT NOT NULL,
    bootcamp_id INT NOT NULL
);

INSERT INTO recursos_humanos_bootcamp (empleado_id, bootcamp_id) VALUES
(1, 101),  -- Juan Pérez da clases en Bootcamp 101
(2, 102),  -- María González da clases en Bootcamp 102
(3, 101),  -- Carlos Martínez da clases en Bootcamp 101
(4, 103),  -- Luisa Sánchez da clases en Bootcamp 103
(5, 102);  -- Pedro Rodríguez da clases en Bootcamp 102

-- Creamos la tabla modulo
CREATE TABLE modulo (
	modulo_id SERIAL PRIMARY KEY,
    modulo_ds VARCHAR(255) NOT NULL,
    creditos_nm INT NOT NULL,
    horas_lectivas_nm INT NOT NULL
);

INSERT INTO modulo (modulo_ds, creditos_nm, horas_lectivas_nm) VALUES
('Introducción a la Programación', 5, 40),      -- Módulo 1
('Fundamentos de Data Science', 6, 50),         -- Módulo 2
('Desarrollo Web Avanzado', 5, 45),             -- Módulo 3
('Marketing Digital Estratégico', 4, 30),       -- Módulo 4
('Ciberseguridad Básica', 3, 35);               -- Módulo 5

-- Creamos la tabla recursos_humanos_bootcamp
CREATE TABLE bootcamp_modulo (
	bootcamp_modulo_id SERIAL PRIMARY KEY,
    bootcamp_id INT NOT NULL REFERENCES bootcamp(bootcamp_id),
    modulo_id INT NOT NULL REFERENCES modulo(modulo_id)
);

INSERT INTO bootcamp_modulo (bootcamp_id, modulo_id) VALUES
(101, 1),  -- Bootcamp 101 tiene el módulo 1
(101, 2),  -- Bootcamp 101 tiene el módulo 2
(102, 1),  -- Bootcamp 102 tiene el módulo 1
(102, 3),  -- Bootcamp 102 tiene el módulo 3
(103, 4);  -- Bootcamp 103 tiene el módulo 4

-- Creamos la tabla alumno
CREATE TABLE alumno (
	alumno_id SERIAL PRIMARY KEY,
    nombre_ds VARCHAR(255) NOT NULL,
    primer_apellido_ds VARCHAR(255) NOT NULL,
    segundo_apellido_ds VARCHAR(255),
    sexo_ds VARCHAR(1),
    fecha_alta_dt DATE NOT NULL,
    email_ds VARCHAR(255) NOT NULL UNIQUE,
    telefono_ds VARCHAR(255) NOT NULL UNIQUE,
    direccion_ds VARCHAR(255) NOT NULL
);

INSERT INTO alumno (nombre_ds, primer_apellido_ds, segundo_apellido_ds, sexo_ds, fecha_alta_dt, email_ds, telefono_ds, direccion_ds) VALUES
('Juan', 'Dominguez', 'García', 'M', '2024-09-01', 'juan.dominguez@example.com', '123433789', 'Calle Llacuna 123'),
('María', 'López', 'Martínez', 'F', '2024-09-02', 'maria.lopez@example.com', '987654321', 'Avenida Siempre Viva 742'),
('Pedro', 'Gómez', NULL, 'M', '2024-09-03', 'pedro.gomez@example.com', '456789123', 'Calle Real 456'),
('Ana', 'Torres', 'Sánchez', 'F', '2024-09-04', 'ana.torres@example.com', '321654987', 'Calle del Sol 789'),
('Luis', 'Martínez', 'Fernández', 'M', '2024-09-05', 'luis.martinez@example.com', '159753486', 'Plaza Mayor 1');

-- Creamos la tabla bootcamp_alumno
CREATE TABLE bootcamp_alumno (
	bootcamp_modulo_id SERIAL PRIMARY KEY,
    bootcamp_id INT NOT NULL REFERENCES bootcamp(bootcamp_id),
    alumno_id INT NOT NULL REFERENCES alumno(alumno_id)
);

INSERT INTO bootcamp_alumno (bootcamp_id, alumno_id) VALUES
(101, 1),  -- Bootcamp 101 incluye al alumno 1
(101, 2),  -- Bootcamp 101 incluye al alumno 2
(102, 2),  -- Bootcamp 102 incluye al alumno 2
(103, 3),  -- Bootcamp 103 incluye al alumno 3
(104, 4);  -- Bootcamp 104 incluye al alumno 4

-- Creamos la tabla calificaciones
CREATE TABLE calificaciones (
	calificacion_id SERIAL PRIMARY KEY,
    calificacion_ds VARCHAR(2) NOT NULL, --nota máxima 2 dígitos
    alumno_id INT NOT NULL REFERENCES alumno(alumno_id),
    bootcamp_id INT NOT NULL REFERENCES bootcamp(bootcamp_id),
    modulo_id INT NOT NULL REFERENCES modulo(modulo_id),
    fecha_evaluacion_dt DATE NOT NULL
);

INSERT INTO calificaciones (calificacion_ds, alumno_id, bootcamp_id, modulo_id, fecha_evaluacion_dt) VALUES
('A', 1, 101, 1, '2024-09-15'),  -- Alumno 1 en Bootcamp 101, Módulo 1
('B', 2, 102, 2, '2024-09-16'),  -- Alumno 2 en Bootcamp 102, Módulo 2
('C', 3, 103, 3, '2024-09-17'),  -- Alumno 3 en Bootcamp 103, Módulo 3
('A', 4, 104, 4, '2024-09-18'),  -- Alumno 4 en Bootcamp 104, Módulo 4
('B', 5, 105, 5, '2024-09-19');  -- Alumno 5 en Bootcamp 105, Módulo 5


-- Creamos la tabla transacciones
CREATE TABLE transacciones (
	transaccion_id SERIAL PRIMARY KEY,
    alumno_id INT NOT NULL REFERENCES alumno(alumno_id),
    fecha_transaccion_dt DATE NOT NULL,
    metodo_pago_id VARCHAR(255) NOT NULL
);

INSERT INTO transacciones (alumno_id, fecha_transaccion_dt, metodo_pago_id) VALUES
(1, '2023-09-10', 'Tarjeta de Crédito'),
(2, '2023-09-11', 'PayPal'),
(3, '2023-09-12', 'Transferencia Bancaria'),
(4, '2023-09-13', 'Efectivo'),
(5, '2023-09-14', 'Tarjeta de Débito');

-- Creamos la tabla metodo_pago
CREATE TABLE metodo_pago (
	metodo_pago_id SERIAL PRIMARY KEY,
    metodo_pago_ds VARCHAR(255) NOT NULL
);

INSERT INTO metodo_pago (metodo_pago_ds) VALUES
('Tarjeta de Crédito'),
('PayPal'),
('Transferencia Bancaria'),
('Efectivo'),
('Tarjeta de Débito');

-- Creamos la tabla asistencia
CREATE TABLE asistencia (
	asistencia_id SERIAL PRIMARY KEY,
    alumno_id INT NOT NULL REFERENCES alumno(alumno_id),
    modulo_id INT NOT NULL REFERENCES modulo(modulo_id),
    fecha_clase_dt DATE NOT NULL
);

INSERT INTO asistencia (alumno_id, modulo_id, fecha_clase_dt) VALUES
(1, 1, '2024-09-15'),
(2, 1, '2024-09-15'),
(3, 2, '2024-09-16'),
(4, 3, '2024-09-16'),
(5, 2, '2024-09-17');

=======

-- Evitamos errores si relanzamos códigos
DROP TABLE IF EXISTS departamento CASCADE;
DROP TABLE IF EXISTS recursos_humanos CASCADE;
DROP TABLE IF EXISTS bootcamp CASCADE;
DROP TABLE IF EXISTS recursos_humanos_bootcamp CASCADE;
DROP TABLE IF EXISTS modulo CASCADE;
DROP TABLE IF EXISTS bootcamp_modulo CASCADE;
DROP TABLE IF EXISTS alumno CASCADE;
DROP TABLE IF EXISTS bootcamp_alumno CASCADE;
DROP TABLE IF EXISTS calificaciones CASCADE;
DROP TABLE IF EXISTS transacciones CASCADE;
DROP TABLE IF EXISTS metodo_pago CASCADE;
DROP TABLE IF EXISTS asistencia CASCADE;

-- Creamos la tabla departamento
CREATE TABLE departamento (
    departamento_id SERIAL PRIMARY KEY,
    departamento_ds VARCHAR(255) NOT NULL
);

INSERT INTO departamento (departamento_ds) VALUES
('Recursos Humanos'),
('Administracion'),
('Bolsa de Empleo'),
('Marketing'),
('Profesorado');

-- Creamos la tabla recursos_humanos
CREATE TABLE recursos_humanos (
	empleado_id SERIAL PRIMARY KEY,
    departamento_id INT NOT NULL REFERENCES departamento(departamento_id),
    fecha_alta_dt DATE NOT NULL DEFAULT CURRENT_DATE,
    salario_nm INT NOT NULL CHECK (salario_nm > 0),
    email_ds VARCHAR(255) NOT NULL UNIQUE,
    telefono_ds VARCHAR(255) NOT NULL UNIQUE,
    direccion_ds VARCHAR(255),
    nombre_ds VARCHAR(255) NOT NULL,
    primer_apellido_ds VARCHAR(255) NOT NULL,
    segundo_apellido_ds VARCHAR(255) NOT NULL 
);

INSERT INTO recursos_humanos (departamento_id, fecha_alta_dt, salario_nm, email_ds, telefono_ds, direccion_ds, nombre_ds, primer_apellido_ds, segundo_apellido_ds) VALUES
(1, '2024-01-10', 30000, 'juan.perez@example.com', '555-1234', 'Calle Falsa 123', 'Juan', 'Pérez', 'García'),
(2, '2024-02-15', 45000, 'maria.gonzalez@example.com', '555-5678', 'Avenida Siempre Viva 456', 'María', 'González', 'López'),
(3, '2024-03-20', 50000, 'carlos.martinez@example.com', '555-8765', 'Plaza Mayor 789', 'Carlos', 'Martínez', 'Fernández'),
(4, '2024-04-25', 60000, 'luisa.sanchez@example.com', '555-4321', 'Boulevard de la Vida 321', 'Luisa', 'Sánchez', 'Romero'),
(5, '2024-05-30', 55000, 'pedro.rodriguez@example.com', '555-2468', 'Calle de los Sueños 654', 'Pedro', 'Rodríguez', 'Hernández');

-- Creamos la tabla bootcamp
CREATE TABLE bootcamp (
	bootcamp_id SERIAL PRIMARY KEY,
    bootcamp_ds VARCHAR(255) NOT NULL,
    capacidad_nm INT NOT NULL
);

ALTER SEQUENCE bootcamp_bootcamp_id_seq RESTART WITH 101;

INSERT INTO bootcamp (bootcamp_ds, capacidad_nm) VALUES
('Desarrollo Web', 30),             -- Bootcamp para aprender desarrollo web
('Data Science', 25),               -- Bootcamp para aprender ciencia de datos
('Inteligencia Artificial', 20),    -- Bootcamp para aprender IA
('Marketing Digital', 15),          -- Bootcamp sobre marketing en línea
('Ciberseguridad', 18);             -- Bootcamp sobre seguridad informática

-- Creamos la tabla recursos_humanos_bootcamp
CREATE TABLE recursos_humanos_bootcamp (
	rec_humanos_bootcamp_id SERIAL PRIMARY KEY,
    empleado_id INT NOT NULL,
    bootcamp_id INT NOT NULL
);

INSERT INTO recursos_humanos_bootcamp (empleado_id, bootcamp_id) VALUES
(1, 101),  -- Juan Pérez da clases en Bootcamp 101
(2, 102),  -- María González da clases en Bootcamp 102
(3, 101),  -- Carlos Martínez da clases en Bootcamp 101
(4, 103),  -- Luisa Sánchez da clases en Bootcamp 103
(5, 102);  -- Pedro Rodríguez da clases en Bootcamp 102

-- Creamos la tabla modulo
CREATE TABLE modulo (
	modulo_id SERIAL PRIMARY KEY,
    modulo_ds VARCHAR(255) NOT NULL,
    creditos_nm INT NOT NULL,
    horas_lectivas_nm INT NOT NULL
);

INSERT INTO modulo (modulo_ds, creditos_nm, horas_lectivas_nm) VALUES
('Introducción a la Programación', 5, 40),      -- Módulo 1
('Fundamentos de Data Science', 6, 50),         -- Módulo 2
('Desarrollo Web Avanzado', 5, 45),             -- Módulo 3
('Marketing Digital Estratégico', 4, 30),       -- Módulo 4
('Ciberseguridad Básica', 3, 35);               -- Módulo 5

-- Creamos la tabla recursos_humanos_bootcamp
CREATE TABLE bootcamp_modulo (
	bootcamp_modulo_id SERIAL PRIMARY KEY,
    bootcamp_id INT NOT NULL REFERENCES bootcamp(bootcamp_id),
    modulo_id INT NOT NULL REFERENCES modulo(modulo_id)
);

INSERT INTO bootcamp_modulo (bootcamp_id, modulo_id) VALUES
(101, 1),  -- Bootcamp 101 tiene el módulo 1
(101, 2),  -- Bootcamp 101 tiene el módulo 2
(102, 1),  -- Bootcamp 102 tiene el módulo 1
(102, 3),  -- Bootcamp 102 tiene el módulo 3
(103, 4);  -- Bootcamp 103 tiene el módulo 4

-- Creamos la tabla alumno
CREATE TABLE alumno (
	alumno_id SERIAL PRIMARY KEY,
    nombre_ds VARCHAR(255) NOT NULL,
    primer_apellido_ds VARCHAR(255) NOT NULL,
    segundo_apellido_ds VARCHAR(255),
    sexo_ds VARCHAR(1),
    fecha_alta_dt DATE NOT NULL,
    email_ds VARCHAR(255) NOT NULL UNIQUE,
    telefono_ds VARCHAR(255) NOT NULL UNIQUE,
    direccion_ds VARCHAR(255) NOT NULL
);

INSERT INTO alumno (nombre_ds, primer_apellido_ds, segundo_apellido_ds, sexo_ds, fecha_alta_dt, email_ds, telefono_ds, direccion_ds) VALUES
('Juan', 'Dominguez', 'García', 'M', '2024-09-01', 'juan.dominguez@example.com', '123433789', 'Calle Llacuna 123'),
('María', 'López', 'Martínez', 'F', '2024-09-02', 'maria.lopez@example.com', '987654321', 'Avenida Siempre Viva 742'),
('Pedro', 'Gómez', NULL, 'M', '2024-09-03', 'pedro.gomez@example.com', '456789123', 'Calle Real 456'),
('Ana', 'Torres', 'Sánchez', 'F', '2024-09-04', 'ana.torres@example.com', '321654987', 'Calle del Sol 789'),
('Luis', 'Martínez', 'Fernández', 'M', '2024-09-05', 'luis.martinez@example.com', '159753486', 'Plaza Mayor 1');

-- Creamos la tabla bootcamp_alumno
CREATE TABLE bootcamp_alumno (
	bootcamp_modulo_id SERIAL PRIMARY KEY,
    bootcamp_id INT NOT NULL REFERENCES bootcamp(bootcamp_id),
    alumno_id INT NOT NULL REFERENCES alumno(alumno_id)
);

INSERT INTO bootcamp_alumno (bootcamp_id, alumno_id) VALUES
(101, 1),  -- Bootcamp 101 incluye al alumno 1
(101, 2),  -- Bootcamp 101 incluye al alumno 2
(102, 2),  -- Bootcamp 102 incluye al alumno 2
(103, 3),  -- Bootcamp 103 incluye al alumno 3
(104, 4);  -- Bootcamp 104 incluye al alumno 4

-- Creamos la tabla calificaciones
CREATE TABLE calificaciones (
	calificacion_id SERIAL PRIMARY KEY,
    calificacion_ds VARCHAR(2) NOT NULL, --nota máxima 2 dígitos
    alumno_id INT NOT NULL REFERENCES alumno(alumno_id),
    bootcamp_id INT NOT NULL REFERENCES bootcamp(bootcamp_id),
    modulo_id INT NOT NULL REFERENCES modulo(modulo_id),
    fecha_evaluacion_dt DATE NOT NULL
);

INSERT INTO calificaciones (calificacion_ds, alumno_id, bootcamp_id, modulo_id, fecha_evaluacion_dt) VALUES
('A', 1, 101, 1, '2024-09-15'),  -- Alumno 1 en Bootcamp 101, Módulo 1
('B', 2, 102, 2, '2024-09-16'),  -- Alumno 2 en Bootcamp 102, Módulo 2
('C', 3, 103, 3, '2024-09-17'),  -- Alumno 3 en Bootcamp 103, Módulo 3
('A', 4, 104, 4, '2024-09-18'),  -- Alumno 4 en Bootcamp 104, Módulo 4
('B', 5, 105, 5, '2024-09-19');  -- Alumno 5 en Bootcamp 105, Módulo 5


-- Creamos la tabla transacciones
CREATE TABLE transacciones (
	transaccion_id SERIAL PRIMARY KEY,
    alumno_id INT NOT NULL REFERENCES alumno(alumno_id),
    fecha_transaccion_dt DATE NOT NULL,
    metodo_pago_id VARCHAR(255) NOT NULL
);

INSERT INTO transacciones (alumno_id, fecha_transaccion_dt, metodo_pago_id) VALUES
(1, '2023-09-10', 'Tarjeta de Crédito'),
(2, '2023-09-11', 'PayPal'),
(3, '2023-09-12', 'Transferencia Bancaria'),
(4, '2023-09-13', 'Efectivo'),
(5, '2023-09-14', 'Tarjeta de Débito');

-- Creamos la tabla metodo_pago
CREATE TABLE metodo_pago (
	metodo_pago_id SERIAL PRIMARY KEY,
    metodo_pago_ds VARCHAR(255) NOT NULL
);

INSERT INTO metodo_pago (metodo_pago_ds) VALUES
('Tarjeta de Crédito'),
('PayPal'),
('Transferencia Bancaria'),
('Efectivo'),
('Tarjeta de Débito');

-- Creamos la tabla asistencia
CREATE TABLE asistencia (
	asistencia_id SERIAL PRIMARY KEY,
    alumno_id INT NOT NULL REFERENCES alumno(alumno_id),
    modulo_id INT NOT NULL REFERENCES modulo(modulo_id),
    fecha_clase_dt DATE NOT NULL
);

INSERT INTO asistencia (alumno_id, modulo_id, fecha_clase_dt) VALUES
(1, 1, '2024-09-15'),
(2, 1, '2024-09-15'),
(3, 2, '2024-09-16'),
(4, 3, '2024-09-16'),
(5, 2, '2024-09-17');

>>>>>>> 036ddaab8269a07ca23be39ae5811b52db80f250
