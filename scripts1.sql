-- Borramos tablas en caso de ya existir
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS peliculas;
DROP TABLE IF EXISTS peliculas_tags;


-- Creación de la tabla Películas
CREATE TABLE peliculas (
    id_pelicula SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    año INTEGER NOT NULL
);

-- Creación de la tabla Tags
CREATE TABLE tags (
    id_tag SERIAL PRIMARY KEY,
    tag VARCHAR(32) NOT NULL
);

-- Creación de una tabla de unión para la relación muchos a muchos
CREATE TABLE peliculas_tags (
    pelicula_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    PRIMARY KEY (pelicula_id, tag_id),
    FOREIGN KEY (pelicula_id) REFERENCES peliculas(id_pelicula), 
    FOREIGN KEY (tag_id) REFERENCES tags(id_tag)
);

SELECT * FROM peliculas;
SELECT * FROM tags;
SELECT * FROM peliculas_tags;


-- Registros para tabla Peliculas
INSERT INTO peliculas (nombre, año) VALUES ('Forest Gump', 1994);
INSERT INTO peliculas (nombre, año) VALUES ('Titanic', 1997);
INSERT INTO peliculas (nombre, año) VALUES ('El Padrino', 1972);
INSERT INTO peliculas (nombre, año) VALUES ('Gladiator', 2000);
INSERT INTO peliculas (nombre, año) VALUES ('El Señor de los Anillos: El Retorno del Rey', 2003);


-- Registros para tabla Tag
INSERT INTO tags (tag) VALUES ('Drama');
INSERT INTO tags (tag) VALUES ('Romance');
INSERT INTO tags (tag) VALUES ('Historia');
INSERT INTO tags (tag) VALUES ('Crimen');
INSERT INTO tags (tag) VALUES ('Acción');


-- Asignaciones para 'Forest Gump'
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES (1, 1); -- Drama
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES (1, 2); -- Romance
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES (1, 3); -- Historia

-- Asignaciones para 'Titanic'
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES (2, 1); -- Drama
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES (2, 2); -- Romance

-- Asignaciones para 'El Padrino'
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES (3, 4); -- Crimen

-- Asignaciones para 'Gladiator'
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES (4, 5); -- Acción

-- Asignaciones para 'El Señor de los anillos: El retorno del rey'
INSERT INTO peliculas_tags (pelicula_id, tag_id) VALUES (5, 5); -- Fantasía




-- Contar la cantidad de tags por pelicula
SELECT pelicula_id, COALESCE(COUNT(tag_id),0) as cantidad_tags  FROM peliculas_tags GROUP BY pelicula_id ORDER by cantidad_tags desc;

-- Contar la cantidad de tags por pelicula, incluyendo nombre
SELECT p.id_pelicula,p.nombre, COALESCE(COUNT(pt.tag_id), 0) AS cantidad_tags
FROM peliculas p
LEFT JOIN peliculas_tags pt ON p.id_pelicula = pt.pelicula_id
GROUP BY p.id_pelicula
ORDER BY cantidad_tags DESC;