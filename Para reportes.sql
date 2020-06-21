--Reporte 1

CREATE OR REPLACE VIEW REPORTE1 AS
    SELECT p.FOTO FOTO, p.NOMBRE NOMBER1, p.NOMBRE1 NOMBRE2, p.APELLIDO APELLIDO1, p.APELLIDO1 APELLIDO2, p.FECHA_NAC NACIMIENTO, pa.FOTO PAIS, p.GENERO GENERO,
            es.NOMBRE ESTADO, (SELECT LISTAGG(NOMBRE, chr(13)) FROM PATOLOGIA pat) PATOLOGIAS
        FROM PERSONA p INNER JOIN FICHA_MEDICA fi ON p.DOC_IDENTIDAD = fi.ID_PERSONA
                       INNER JOIN PADECIMIENTOS pad ON p.DOC_IDENTIDAD = pad.id_persona
                       INNER JOIN PATOLOGIA pat ON pad.id_patologia = pat.id
                       INNER JOIN HISTORICO_RESIDENCIA h ON p.doc_identidad = h.id_persona
                       INNER JOIN LUGAR pa ON h.id_lugar = pa.id_lugar
                       INNER JOIN LUGAR es ON es.id_lugar = pa.id;

create or replace NONEDITIONABLE PROCEDURE REPORT1(info OUT sys_refcursor, pais lugar.nombre%TYPE,estado lugar.nombre%type,
                                                    edad persona.fecha_nac%type, patologia patologia.nombre%type) AS
    BEGIN
        OPEN info
        FOR SELECT r.FOTO, r.NOMBER1, r.NOMBRE2, r.APELLIDO1, r.APELLIDO2, r.NACIMIENTO, r.PAIS, r.GENERO, r.ESTADO, r.PATOLOGIAS 
        FROM REPORTE1 r
        WHERE (estado is null or r.estado = estado) AND (patologia is null or INSTR(r.patologias, patologia) <> 0);
    END;