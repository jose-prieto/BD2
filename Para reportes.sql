--Reporte 1

CREATE OR REPLACE VIEW REPORTE1 AS
    SELECT p.FOTO FOTO, p.NOMBRE NOMBER1, p.NOMBRE1 NOMBRE2, p.APELLIDO APELLIDO1, p.APELLIDO1 APELLIDO2, p.FECHA_NAC NACIMIENTO, p.GENERO GENERO, pa.nombre PAIS, l.nombre ESTADO,
            (SELECT LISTAGG(pat.nombre, chr(13)) within group (order by pat.nombre) FROM PATOLOGIA pat INNER JOIN PADECIMIENTOS pad ON pat.id = pad.id_patologia WHERE pad.id_persona = p.doc_identidad) PATOLOGIAS
        FROM PERSONA p INNER JOIN HISTORICO_RESIDENCIA h ON p.doc_identidad = h.id_persona
                        INNER JOIN LUGAR l ON h.id_lugar = l.id
                        INNER JOIN FICHA_MEDICA f ON p.doc_identidad = f.id_persona
                        INNER JOIN LUGAR pa ON l.id_lugar = pa.id
            WHERE UPPER(f.estado) = 'INFECTADO';

create or replace PROCEDURE REPORT1(info OUT sys_refcursor, paiss IN VARCHAR2, estadoo IN VARCHAR2, menor IN NUMBER, mayor IN NUMBER, patologia IN VARCHAR2) AS
    BEGIN
        OPEN info
        FOR SELECT FOTO, NOMBER1, NVL(NOMBRE2, 'N/A') NOMBRE2, APELLIDO1, NVL(APELLIDO2, 'N/A') APELLIDO2, TO_CHAR(NACIMIENTO , 'DD/MM/YYYY') NACIMIENTO,
                    REPLACE(REPLACE(UPPER(GENERO), 'M', 'Masculino'), 'F', 'Femenino') GENERO, PAIS, ESTADO, NVL(PATOLOGIAS, 'N/A') PATOLOGIAS
        FROM REPORTE1
            WHERE (INSTR(LOWER(PATOLOGIAS), LOWER(patologia)) <> 0 OR patologia IS NULL)
                    AND (FLOOR((sysdate - NACIMIENTO) / 365.242199) >= menor OR menor IS NULL)
                    AND (FLOOR((sysdate - NACIMIENTO) / 365.242199) <= mayor OR mayor IS NULL)
                    AND (LOWER(PAIS) = LOWER(paiss) OR paiss IS NULL)
                    AND (LOWER(ESTADO) = LOWER(estadoo) OR estadoo IS NULL);
    END;

--Reporte 2

CREATE OR REPLACE VIEW REPORTE2 AS
    SELECT p.doc_identidad DOCUMENTO, p.FOTO FOTO, p.NOMBRE NOMBER1, p.NOMBRE1 NOMBRE2, p.APELLIDO APELLIDO1, p.APELLIDO1 APELLIDO2, p.FECHA_NAC NACIMIENTO, p.GENERO GENERO, pa.nombre PAIS, l.nombre ESTADO,
            (SELECT LISTAGG(pat.nombre, chr(13)) within group (order by pat.nombre) FROM PATOLOGIA pat INNER JOIN PADECIMIENTOS pad ON pat.id = pad.id_patologia WHERE pad.id_persona = p.doc_identidad) PATOLOGIAS,
            (SELECT LISTAGG(sin.nombre, chr(13)) within group (order by sin.nombre) FROM SINTOMA sin INNER JOIN SINTOMAS sins ON sin.id= sins.id_sintoma WHERE sins.id_persona = p.doc_identidad) SINTOMAS,
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(f.estado, 'desconido', 'No'), 'cuarentena', 'Si'), 'curado', 'Si'), 'fallecido', 'Si'), 'infectado', 'Si'), 'sano', 'Si') ATENDIDO
        FROM PERSONA p INNER JOIN HISTORICO_RESIDENCIA h ON p.doc_identidad = h.id_persona
                        INNER JOIN LUGAR l ON h.id_lugar = l.id
                        INNER JOIN FICHA_MEDICA f ON p.doc_identidad = f.id_persona
                        INNER JOIN LUGAR pa ON l.id_lugar = pa.id;

create or replace NONEDITIONABLE PROCEDURE REPORT2(info OUT sys_refcursor, paiss IN VARCHAR2, estadoo IN VARCHAR2, menor IN NUMBER, mayor IN NUMBER) AS
    BEGIN
        OPEN info
        FOR SELECT r.DOCUMENTO DOCUMENTO, r.FOTO FOTO, r.NOMBER1 NOMBER1, NVL(r.NOMBRE2, 'N/A') NOMBRE2, r.APELLIDO1 APELLIDO1,
            NVL(r.APELLIDO2, 'N/A') APELLIDO2, CONCAT(FLOOR((sysdate - r.NACIMIENTO) / 365.242199), ' Años') EDAD, TO_CHAR(r.NACIMIENTO , 'DD/MM/YYYY') NACIMIENTO,
            REPLACE(REPLACE(UPPER(GENERO), 'M', 'Masculino'), 'F', 'Femenino') GENERO, PAIS, ESTADO, NVL(PATOLOGIAS, 'N/A') PATOLOGIAS, SINTOMAS, ATENDIDO
        FROM REPORTE2 r
            WHERE SINTOMAS IS NOT NULL
                AND (FLOOR((sysdate - r.NACIMIENTO) / 365.242199) >= menor OR menor IS NULL)
                AND (FLOOR((sysdate - r.NACIMIENTO) / 365.242199) <= mayor OR mayor IS NULL)
                AND (LOWER(PAIS) = LOWER(paiss) OR paiss IS NULL)
                AND (LOWER(ESTADO) = LOWER(estadoo) OR estadoo IS NULL);
    END;

--Reporte 3

CREATE OR REPLACE VIEW REPORTE3 AS
    SELECT p.doc_identidad DOCUMENTO, p.FOTO FOTO, p.NOMBRE NOMBER1, p.NOMBRE1 NOMBRE2, p.APELLIDO APELLIDO1, p.APELLIDO1 APELLIDO2, p.FECHA_NAC NACIMIENTO,
            l2.nombre RESIDE, lida.nombre DESTINO, vuida.fecha_vuelo FECHAIDA
        FROM PERSONA p INNER JOIN HISTORICO_RESIDENCIA h ON p.doc_identidad = h.id_persona
                        INNER JOIN LUGAR l ON h.id_lugar = l.id
                        INNER JOIN LUGAR l2 ON l.id_lugar = l2.id
                        INNER JOIN VUELO vuIda ON vuida.id_destino = h.id_lugar
                        INNER JOIN LUGAR lIda ON vuida.id_destino = lida.id;

create or replace NONEDITIONABLE PROCEDURE REPORT3(info OUT sys_refcursor) AS
    BEGIN
        OPEN info
        FOR SELECT r.DOCUMENTO DOCUMENTO, r.FOTO FOTO, r.NOMBER1 NOMBER1, NVL(r.NOMBRE2, 'N/A') NOMBRE2, r.APELLIDO1 APELLIDO1, r.RESIDE RESIDE,
            NVL(r.APELLIDO2, 'N/A') APELLIDO2, CONCAT(FLOOR((sysdate - r.NACIMIENTO) / 365.242199), ' Años') EDAD
        FROM REPORTE3 r;
    END;