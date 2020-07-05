--Reporte 8

CREATE OR REPLACE VIEW REPORTE8 AS
    SELECT c.nombre, c.CAMAS_DISPONIBLES, (SELECT COUNT(*) FROM FICHA_MEDICA f1 WHERE LOWER(f1.estado) <> 'desconido' AND f1.ID_CENTRO_SALUD = c.id) atendidos,
            (SELECT COUNT(*) FROM FICHA_MEDICA f1 WHERE LOWER(f1.estado) = 'fallecido' AND f1.ID_CENTRO_SALUD = c.id) fallecidos,
            (SELECT COUNT(*) FROM FICHA_MEDICA f1 WHERE LOWER(f1.estado) = 'curado' AND f1.ID_CENTRO_SALUD = c.id) recuperados,
            (SELECT LISTAGG(CONCAT('-', i.nombre), chr(13)) within group (order by i.nombre) FROM insumo i INNER JOIN INSUMO_DISPONIBLE ins ON ins.id_insumo = i.id
                    WHERE ins.id_centro_salud = c.id) insumos
        FROM CENTRO_SALUD c;
    
create or replace PROCEDURE REPORT8(info OUT sys_refcursor) AS
    BEGIN
        OPEN info
        FOR SELECT c.nombre,c.camas_disponibles, c.atendidos, c.fallecidos, c.recuperados, c.insumos
        FROM REPORTE8 c;
    END;

--Reporte 9

CREATE OR REPLACE VIEW REPORTE9 AS
    SELECT envia.foto foto_envia, recibe.foto foto_recibe, TO_CHAR(c.fecha_recibida,'YYYY-MM-DD') fecha_recibida, CONCAT(c.dinero_donado, ' $') dinero_donado,
            envia.nombre nom_envia, recibe.nombre nom_recibe,
            (SELECT LISTAGG('-'||ins.cantidad||' '||i.nombre, chr(13)) within group (order by i.nombre) FROM insumo i INNER JOIN INSUMOS_DONADOS ins ON ins.id_insumo = i.id
                    WHERE ins.id_ayuda_humanitaria = c.fecha_recibida) insumosd
        FROM AYUDA_HUMANITARIA c INNER JOIN LUGAR envia ON envia.id = c.id_lugar_envia
                                INNER JOIN LUGAR recibe ON recibe.id = c.id_lugar_recibe;
    
create or replace PROCEDURE REPORT9(info OUT sys_refcursor) AS
    BEGIN
        OPEN info
        FOR SELECT *
        FROM REPORTE9;
    END;