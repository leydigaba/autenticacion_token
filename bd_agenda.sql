-- Eliminar la base de datos si ya existe
DROP DATABASE IF EXISTS contactos;

-- Crear la base de datos
CREATE DATABASE contactos;
USE contactos;

-- Crear tabla "personas"
CREATE TABLE personas (
  id_persona INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  primer_apellido VARCHAR(50) NOT NULL,
  segundo_apellido VARCHAR(50),
  email VARCHAR(100) NOT NULL,
  telefono VARCHAR(15),
  PRIMARY KEY (id_persona)
);

-- Insertar registros en la tabla "personas"
INSERT INTO personas (nombre, primer_apellido, segundo_apellido, email, telefono) VALUES
('Ana', 'Hernández', 'Ruiz', 'ana.hernandez@example.com', '321654987'),
('Pedro', 'Ramírez', 'Ortiz', 'pedro.ramirez@example.com', '789123456'),
('Sofía', 'Jiménez', 'Vega', 'sofia.jimenez@example.com', '159753486');

CREATE TABLE usuarios (
  id_usuario INT NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  hashed_password VARCHAR(50) NOT NULL,
  disabled BOOLEAN NOT NULL,
  token VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_usuario)
);

-- Insertar registros en la tabla "usuarios"
INSERT INTO usuarios (username, full_name, email, hashed_password, disabled, token) VALUES
('anaH', 'Ana Hernández', 'ana.hernandez@example.com', md5('54321'), FALSE, 'anaToken'),
('pedroR', 'Pedro Ramírez', 'pedro.ramirez@example.com', md5('98765'), TRUE, 'pedroToken');

-- Consultar la tabla "usuarios"
SELECT * FROM usuarios;

-- Consultar la tabla "personas"
SELECT * FROM personas;

-- Crear un usuario con acceso a la base de datos "contactos"
CREATE USER 'clarita'@'localhost' IDENTIFIED BY '456';

-- Otorgar todos los permisos sobre la base de datos "contactos" al usuario "clarita"
GRANT ALL PRIVILEGES ON contactos.* TO 'clarita'@'localhost';

-- Aplicar cambios de privilegios
FLUSH PRIVILEGES;
