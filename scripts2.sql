-- Borramos tablas en caso de ya existir
DROP TABLE IF EXISTS preguntas;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS respuestas;

-- Creación de la tabla Preguntas
CREATE TABLE preguntas (
    id_pregunta SERIAL PRIMARY KEY,
    pregunta VARCHAR(255) NOT NULL,
    respuesta_correcta VARCHAR NOT NULL
);

-- Creación de la tabla Usuarios
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    edad INTEGER NOT NULL
);

-- Creación de la tabla Respuestas
CREATE TABLE respuestas (
    id_respuesta SERIAL PRIMARY KEY,
    respuesta VARCHAR(255) NOT NULL,
    pregunta_id INTEGER NOT NULL,
    usuario_id INTEGER NOT NULL,
    FOREIGN KEY (pregunta_id) REFERENCES preguntas(id_pregunta),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id_usuario)
);

-- Consultamos datos de tablas

SELECT * FROM preguntas;
SELECT * FROM usuarios;
SELECT * FROM respuestas;


-- Insertar 5 Usuarios
INSERT INTO usuarios (nombre, edad) VALUES ('Usuario 1', 25);
INSERT INTO usuarios (nombre, edad) VALUES ('Usuario 2', 30);
INSERT INTO usuarios (nombre, edad) VALUES ('Usuario 3', 35);
INSERT INTO usuarios (nombre, edad) VALUES ('Usuario 4', 40);
INSERT INTO usuarios (nombre, edad) VALUES ('Usuario 5', 45);



-- Insertar 5 Preguntas
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cual es la mejor generación de DesafioLatam Full Stack Javascript Trainee?', 'G64');
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cuál es el resultado de 2 + 2?', '4');
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿En qué año comenzó la Segunda Guerra Mundial?', '1939');
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cuál es la capital de Francia?', 'París');
INSERT INTO preguntas (pregunta, respuesta_correcta) VALUES ('¿Cuál es el río más largo del mundo?', 'Amazonas');


-- La primera pregunta contestada dos veces correctamente por distintos usuarios
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('G64', 1, 1); -- Respuesta Correcta
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('G64', 2, 1); -- Respuesta Correcta

-- La segunda pregunta contestada correctamente por un usuario y las otras 2 respuestas deben estar incorrectas
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('4', 3, 2); -- Respuesta Correcta
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('5', 4, 2); -- Respuesta incorrecta
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('3', 5, 2); -- Respuesta incorrecta

-- Respuestas para las demás preguntas (no especificadas, así que agregaré algunas correctas e incorrectas)
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('1939', 1, 3); -- Correcta
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('1945', 2, 3); -- Incorrecta

INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('París', 3, 4); -- Respuesta Correcta
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('París', 4, 4); -- Respuesta Correcta

INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('Amazonas', 5, 5); -- Correcta
INSERT INTO respuestas (respuesta, usuario_id, pregunta_id) VALUES ('Nilo', 1, 5); -- Incorrecta




/* 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta).*/
SELECT usuario_id, COUNT(*) AS respuestas_correctas
FROM Respuestas
JOIN preguntas ON respuestas.pregunta_id = preguntas.id_pregunta
WHERE respuestas.respuesta = preguntas.respuesta_correcta
GROUP BY usuario_id;


-- Incluyendo nombres y alas mas cortos y representativos
SELECT 
    u.id_usuario, 
    u.nombre, 
    COUNT(*) AS respuestas_correctas
FROM 
    respuestas as r
    JOIN preguntas p ON r.pregunta_id = p.id_pregunta
    JOIN usuarios u  ON r.usuario_id = u.id_usuario
WHERE 
    r.respuesta = p.respuesta_correcta
GROUP BY 
    u.id_usuario, 
    u.nombre;
	

/* 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
respuesta correcta.*/

SELECT 
    p.id_pregunta, 
    p.pregunta, 
    COUNT(DISTINCT r.usuario_id) AS usuarios_con_respuesta_correcta
FROM 
    preguntas p
    LEFT JOIN respuestas r ON p.id_pregunta = r.pregunta_id AND p.respuesta_correcta = r.respuesta
GROUP BY 
    p.id_pregunta;


/*
8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
primer usuario para probar la implementación.
*/
-- Opcion 2
-- Eliminamos todos los registros
Truncate table usuarios cascade;


-- Opcion 2
-- restricción.
ALTER TABLE respuestas DROP CONSTRAINT IF EXISTS respuestas_usuario_id_fkey; 

ALTER TABLE respuestas
ADD CONSTRAINT respuestas_usuario_id_fkey
FOREIGN KEY (usuario_id) REFERENCES usuarios (id_usuario) ON DELETE CASCADE;

--Una vez realizado el borrado en cascada

DELETE FROM usuarios WHERE id_usuario = 1;

/*
9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos.
*/

ALTER TABLE usuarios
ADD CONSTRAINT edad_minima CHECK (edad >= 18);

INSERT INTO usuarios (nombre, edad) VALUES ('Usuario 6', 18);

/*
10. Altera la tabla existente de usuarios agregando el campo email con la restricción de
único.
*/

-- Como la tabla usuarios ya contine datos no podemos agregarla como NOT NULL
ALTER TABLE usuarios
ADD COLUMN email VARCHAR,
ADD CONSTRAINT email_unico UNIQUE (email);


INSERT INTO usuarios (nombre, edad, email) VALUES ('Usuario 7', 45, 'nuevo@correo.cl');