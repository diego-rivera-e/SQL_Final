
-- prueba SQL--

-- creaacion de Tablas 

Table "Peliculas" {
    "id" SERIAL (pk, increment)
    "nombre" varchar(255) [default: NULL]
    "anno" INT
}

Table "Tags" {
    "id" SERIAL (pk, increment)
    "tag" varchar (32)
}

Table "peliculas_tags" {
    "id" SERIAL (pk, increment)
    "pelicula_id" INT [default: NULL]
    "tag_id" INT (default: NULL)
}

Ref : "Peliculas"."id" < "peliculas_tags"."pelicula_id"

Ref: "Tags"."id" < "peliculas_tags"."tag_id"


--
-- 1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las claves primarias, foráneas y tipos de datos.

DROP TABLE IF EXISTS "peliculas_tags";
CREATE TABLE "peliculas_tags"(
    "id" SERIAL PRIMARY KEY,
    "pelicula_id" INT DEFAULT NULL,
    "tag_id" INT DEFAULT NULL
);

DROP TABLE IF EXISTS "Peliculas";
CREATE TABLE "Peliculas"(
    "id" SERIAL PRIMARY KEY,
    "nombre" varchar(255),
    "anno" INT
);

DROP TABLE IF EXISTS"Tags";
CREATE TABLE "Tags"(
    "id" SERIAL PRIMARY KEY,
    "tag" varchar(32)
);

ALTER TABLE "peliculas_tags" ADD FOREIGN KEY ("pelicula_id") REFERENCES "Peliculas" ("id");
ALTER TABLE "peliculas_tags" ADD FOREIGN KEY ("tag_id") REFERENCES "Tags" ("id");

-- 2 Inserta 5 películas y 5 tags

INSERT INTO "Peliculas" ("nombre", "anno") VALUES ('Dracula', 1992); --id 1
INSERT INTO "Peliculas" ("nombre", "anno") VALUES ('The Flash', 2023); -- id 2
INSERT INTO "Peliculas" ("nombre", "anno") VALUES ('Matrix', 1999); -- id 3
INSERT INTO "Peliculas" ("nombre", "anno") VALUES ('The Godfather', 1972); -- id 4
INSERT INTO "Peliculas" ("nombre", "anno") VALUES ('Lost Boys', 1987); -- id 5

INSERT INTO "Tags" ("tag") VALUES ('Action'); -- id 1
INSERT INTO "Tags" ("tag") VALUES ('Sci-Fi'); -- id 2
INSERT INTO "Tags" ("tag") VALUES ('Drama'); -- id 3
INSERT INTO "Tags" ("tag") VALUES ('Horror'); -- id 4
INSERT INTO "Tags" ("tag") VALUES ('Vampires'); -- id 5

-- la primera película tiene que tener 3 tags asociados, la segunda película debe tener dos tags asociados.

INSERT INTO "peliculas_tags" ("pelicula_id", "tag_id") VALUES (1,3); -- Dracula - Drama
INSERT INTO "peliculas_tags" ("pelicula_id", "tag_id") VALUES (1,4); -- Dracula - Horror
INSERT INTO "peliculas_tags" ("pelicula_id", "tag_id") VALUES (1,5); -- Dracula - Vampires

INSERT INTO "peliculas_tags" ("pelicula_id", "tag_id") VALUES (2,1); -- The Flash - Action
INSERT INTO "peliculas_tags" ("pelicula_id", "tag_id") VALUES (2,2); -- The Flash - Sci-Fi

-- 3 Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0. 

SELECT p.nombre, count(pet.id) FROM "Peliculas" as p LEFT JOIN "peliculas_tags" pet ON p.id = pet.pelicula_id GROUP BY p.nombre;

--4 Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de datos.

DROP TABLE IF EXISTS "Usuarios";
CREATE TABLE "Usuarios" (
    "id" SERIAL PRIMARY KEY,
    "nombre" varchar(255),
    "edad" INT 
);
DROP TABLE IF EXISTS "Preguntas";
CREATE TABLE "Preguntas" (
    "id" SERIAL PRIMARY KEY,
    "pregunta" varchar(255),
    "respuesta_correcta" varchar
);
DROP TABLE IF EXISTS "Respuestas";
CREATE TABLE "Respuestas" (
    "id" SERIAL PRIMARY KEY,
    "respuesta" varchar(255),
    "pregunta_id" INTEGER REFERENCES "Preguntas"(id),
    "usuario_id" INTEGER REFERENCES "Usuarios"(id)
); 



--5 Agrega datos, 
--5 usuarios y 5 preguntas


INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Juan', 20); -- id 1
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Pedro', 30); -- id 2
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Maria', 40); -- id 3
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Jose', 50); -- id 4
INSERT INTO "Usuarios" ("nombre", "edad") VALUES ('Luis', 60); -- id 5

INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('Cual es la capital de Chile', 'Santiago');  -- id 1
INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('Cual es la capital de Argentina', 'Buenos Aires');  -- id 2
INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('Cual es la capital de Brasil', 'Brasilia');  -- id 3
INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('Cual es la capital de Peru', 'Lima');  -- id 4
INSERT INTO "Preguntas" ("pregunta", "respuesta_correcta") VALUES ('Cual es la capital de Colombia', 'Bogota');  -- id 5

--la primera pregunta debe estar contestada dos veces correctamente por distintos usuarios
INSERT INTO "Respuestas" ("respuesta", "pregunta_id","usuario_id") VALUES ('Santiago',1 ,1);
INSERT INTO "Respuestas" ("respuesta", "pregunta_id","usuario_id") VALUES ('Santiago',1 ,2);


--la pregunta 2 debe estar contestada correctamente sólo por un usuario
INSERT INTO "Respuestas" ("respuesta", "pregunta_id","usuario_id") VALUES ('Buenos Aires',2 ,1);

-- y las otras 2 respuestas deben estar incorrectas.
INSERT INTO "Respuestas" ("respuesta", "pregunta_id","usuario_id") VALUES ('Arica',2 ,2);
INSERT INTO "Respuestas" ("respuesta", "pregunta_id","usuario_id") VALUES ('Concepcion',2 ,3);

--6 Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta)

SELECT u.nombre, COUNT (r.respuesta)FILTER (WHERE r.respuesta = p.respuesta_correcta) FROM "Usuarios" u LEFT JOIN "Respuestas" r ON u.id = r.usuario_id LEFT JOIN "Preguntas" p ON r.pregunta_id = p.id GROUP BY u.nombre;


-- 7 Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta.
SELECT p.id AS pregunta_id, p.pregunta, p.respuesta_correcta, COUNT(r.usuario_id) as usuarios_resp_correct FROM "Preguntas" AS p LEFT JOIN "Respuestas" AS r  ON p.id = r.pregunta_id WHERE r.respuesta = p.respuesta_correcta GROUP BY p.id, p.pregunta, p.respuesta_correcta;


--8 Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación

ALTER TABLE "Respuestas" DROP CONSTRAINT IF EXISTS respuestas_usuario_id_fkey, ADD CONSTRAINT respuestas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES "Usuarios"(id) ON DELETE CASCADE;
DELETE FROM "Usuarios" WHERE id = 1;

--9 Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.

ALTER TABLE "Usuarios" 
ADD CONSTRAINT min_edad CHECK (edad >= 18);

--10 Altera la tabla existente de usuarios agregando el campo email con la restricción de único.

ALTER TABLE "Usuarios" ADD COLUMN email VARCHAR(400) UNIQUE;








