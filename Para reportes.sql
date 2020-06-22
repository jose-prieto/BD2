--Reporte 1

CREATE OR REPLACE VIEW REPORTE1 AS
    SELECT p.FOTO FOTO, p.NOMBRE NOMBER1, p.NOMBRE1 NOMBRE2, p.APELLIDO APELLIDO1, p.APELLIDO1 APELLIDO2, p.FECHA_NAC NACIMIENTO, p.GENERO GENERO, l.nombre ESTADO,
            (SELECT LISTAGG(pat.nombre, chr(13)) FROM PATOLOGIA pat INNER JOIN PADECIMIENTOS pad ON pat.id = pad.id_ficha_medica WHERE pad.id_persona = p.doc_identidad) PATOLOGIAS
        FROM PERSONA p INNER JOIN HISTORICO_RESIDENCIA h ON p.doc_identidad = h.id_persona
                        INNER JOIN LUGAR l ON h.id_lugar = l.id
                        INNER JOIN FICHA_MEDICA f ON p.doc_identidad = f.id_persona;

create or replace PROCEDURE REPORT1(info OUT sys_refcursor) AS
    BEGIN
        OPEN info
        FOR SELECT FOTO, NOMBER1, NOMBRE2, APELLIDO1, APELLIDO2, TO_CHAR(NACIMIENTO , 'DD/MM/YYYY') NACIMIENTO, GENERO, ESTADO, PATOLOGIAS
        FROM REPORTE1;
    END;