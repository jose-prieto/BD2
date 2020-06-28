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

--Reporte 5

CREATE OR REPLACE VIEW REPORTE5 AS
    SELECT l.FOTO FOTO, l.NOMBRE NOMBRE, h.FECHA_INICIO Fechai, h.FECHA_FIN Fechaf, 'Modelo'||' '||m.TIPO||' - '||m.DESCRIPCION Modelo
    FROM LUGAR l, HISTORICO_MODELO h, MODELO m
    WHERE (m.ID = h.ID_MODELO) AND (l.ID = h.id_lugar) AND (l.tipo = 'Pais');

create or replace PROCEDURE REPORT5(info OUT sys_refcursor, lugar IN VARCHAR2, model IN VARCHAR2) AS
    BEGIN
        OPEN info
            FOR SELECT FOTO, NOMBRE, Fechai, NVL(Fechaf, 'Aun en vigencia') Fechaf, Modelo
        FROM REPORTE5
        WHERE (INSTR(LOWER(NOMBRE), LOWER(lugar)) <> 0 OR NOMBRE IS NULL)
        AND (Modelo = model OR Modelo IS NULL);
    END;
            
                                                               