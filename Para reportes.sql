--Reporte 1

CREATE OR REPLACE VIEW REPORTE1 AS
    SELECT p.FOTO FOTO, p.NOMBRE NOMBER1, p.NOMBRE1 NOMBRE2, p.APELLIDO APELLIDO1, p.APELLIDO1 APELLIDO2, p.FECHA_NAC NACIMIENTO, p.GENERO GENERO, pa.nombre PAIS, pa.foto PAISF, l.nombre ESTADO,
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
                    REPLACE(REPLACE(UPPER(GENERO), 'M', 'Masculino'), 'F', 'Femenino') GENERO, PAIS, PAISF, ESTADO, NVL(PATOLOGIAS, 'N/A') PATOLOGIAS
        FROM REPORTE1
            WHERE (INSTR(LOWER(PATOLOGIAS), LOWER(patologia)) <> 0 OR patologia IS NULL)
                    AND (FLOOR((sysdate - NACIMIENTO) / 365.242199) >= menor OR menor IS NULL)
                    AND (FLOOR((sysdate - NACIMIENTO) / 365.242199) <= mayor OR mayor IS NULL)
                    AND (LOWER(PAIS) = LOWER(paiss) OR paiss IS NULL)
                    AND (LOWER(ESTADO) = LOWER(estadoo) OR estadoo IS NULL);
    END;

--Reporte 2

CREATE OR REPLACE VIEW REPORTE2 AS
    SELECT p.doc_identidad DOCUMENTO, p.FOTO FOTO, p.NOMBRE NOMBER1, p.NOMBRE1 NOMBRE2, p.APELLIDO APELLIDO1, p.APELLIDO1 APELLIDO2, p.FECHA_NAC NACIMIENTO, p.GENERO GENERO, pa.nombre PAIS, pa.foto PAISF, l.nombre ESTADO,
            (SELECT LISTAGG(pat.nombre, chr(13)) within group (order by pat.nombre) FROM PATOLOGIA pat INNER JOIN PADECIMIENTOS pad ON pat.id = pad.id_patologia WHERE pad.id_persona = p.doc_identidad) PATOLOGIAS,
            (SELECT LISTAGG(sin.nombre, chr(13)) within group (order by sin.nombre) FROM SINTOMA sin INNER JOIN SINTOMAS sins ON sin.id= sins.id_sintoma WHERE sins.id_persona = p.doc_identidad) SINTOMAS,
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(f.estado, 'desconido', 'No'), 'cuarentena', 'Si'), 'curado', 'Si'), 'fallecido', 'Si'), 'infectado', 'Si'), 'sano', 'Si') ATENDIDO
        FROM PERSONA p INNER JOIN HISTORICO_RESIDENCIA h ON p.doc_identidad = h.id_persona
                        INNER JOIN LUGAR l ON h.id_lugar = l.id
                        INNER JOIN FICHA_MEDICA f ON p.doc_identidad = f.id_persona
                        INNER JOIN LUGAR pa ON l.id_lugar = pa.id;

create or replace PROCEDURE REPORT2(info OUT sys_refcursor, paiss IN VARCHAR2, estadoo IN VARCHAR2, menor IN NUMBER, mayor IN NUMBER) AS
    BEGIN
        OPEN info
        FOR SELECT r.DOCUMENTO DOCUMENTO, r.FOTO FOTO, r.NOMBER1 NOMBER1, NVL(r.NOMBRE2, 'N/A') NOMBRE2, r.APELLIDO1 APELLIDO1,
            NVL(r.APELLIDO2, 'N/A') APELLIDO2, CONCAT(FLOOR((sysdate - r.NACIMIENTO) / 365.242199), ' Años') EDAD, TO_CHAR(r.NACIMIENTO , 'DD/MM/YYYY') NACIMIENTO,
            REPLACE(REPLACE(UPPER(GENERO), 'M', 'Masculino'), 'F', 'Femenino') GENERO, PAIS, PAISF, ESTADO, NVL(PATOLOGIAS, 'N/A') PATOLOGIAS, SINTOMAS, ATENDIDO
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
            l2.nombre RESIDE, l2.foto PAISF, (select MAX(v.fecha_vuelo) FROM VUELO v WHERE v.id_destino <> l2.id AND pas.id_vuelo = v.n_vuelo) IDA,
            (select lu.foto FROM LUGAR lu INNER JOIN VUELO vue ON lu.id = vue.id_destino WHERE vue.id_destino <> l2.id AND pas.id_vuelo = vue.n_vuelo) DESTINO,
            (select lu.nombre FROM LUGAR lu INNER JOIN VUELO vue ON lu.id = vue.id_destino WHERE vue.id_destino <> l2.id AND pas.id_vuelo = vue.n_vuelo) DESTINOL,
            (select MAX(vu.fecha_vuelo) FROM VUELO vu WHERE vu.id_destino = l2.id AND pas.id_vuelo = vu.n_vuelo) RETORNO,
            (SELECT LISTAGG(CONCAT('-', l3.nombre), chr(13)) within group (order by l3.nombre) FROM LUGAR l3 INNER JOIN VISITA vi ON l3.id = vi.ID_LUGAR 
                WHERE p.doc_identidad = vi.ID_PERSONA 
                    AND vi.fecha_ingreso >= (select MAX(v.fecha_vuelo) FROM VUELO v WHERE v.id_destino <> l2.id AND pas.id_vuelo = v.n_vuelo)) LUGARES
        FROM PERSONA p INNER JOIN HISTORICO_RESIDENCIA h ON p.doc_identidad = h.id_persona
                        INNER JOIN LUGAR l ON h.id_lugar = l.id
                        INNER JOIN LUGAR l2 ON l.id_lugar = l2.id
                        INNER JOIN PASAJERO pas ON pas.id_persona = p.doc_identidad;
                        
create or replace PROCEDURE REPORT3(info OUT sys_refcursor, fecha_inicio IN DATE, fecha_fin IN DATE) AS
    BEGIN
        OPEN info
        FOR SELECT r.DOCUMENTO DOCUMENTO, r.FOTO FOTO, r.NOMBER1 NOMBER1, NVL(r.NOMBRE2, 'N/A') NOMBRE2, r.APELLIDO1 APELLIDO1, r.RESIDE RESIDE, r.PAISF PAISF,
                    r.DESTINO DESTINO, r.DESTINOL, NVL(r.APELLIDO2, 'N/A') APELLIDO2, CONCAT(FLOOR((sysdate - r.NACIMIENTO) / 365.242199), ' Años') EDAD,
                    TO_CHAR(r.ida, 'DD/MM/YYYY') IDA, NVL(TO_CHAR(r.retorno, 'DD/MM/YYYY'), 'No ha  regresado') VUELTA, r.LUGARES
            FROM REPORTE3 r
                WHERE (r.ida >= fecha_inicio OR fecha_inicio IS NULL)
                    AND (NVL(r.retorno, SYSDATE-1) <= fecha_fin OR fecha_fin IS NULL);
    END;