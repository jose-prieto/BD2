--Reporte 8

CREATE OR REPLACE VIEW REPORTE8 AS
    SELECT c.nombre, c.CAMAS_DISPONIBLES, ('- ' || estado.nombre || ', ' || pais.nombre) direccion,
            (SELECT COUNT(*) FROM FICHA_MEDICA f1 WHERE LOWER(f1.estado) <> 'desconido' AND f1.ID_CENTRO_SALUD = c.id) atendidos,
            (SELECT COUNT(*) FROM FICHA_MEDICA f1 WHERE LOWER(f1.estado) = 'fallecido' AND f1.ID_CENTRO_SALUD = c.id) fallecidos,
            (SELECT COUNT(*) FROM FICHA_MEDICA f1 WHERE LOWER(f1.estado) = 'curado' AND f1.ID_CENTRO_SALUD = c.id) recuperados,
            (SELECT LISTAGG(CONCAT('-', i.nombre), chr(13)) within group (order by i.nombre) FROM insumo i INNER JOIN INSUMO_DISPONIBLE ins ON ins.id_insumo = i.id
                    WHERE ins.id_centro_salud = c.id) insumos
        FROM CENTRO_SALUD c INNER JOIN LUGAR estado ON c.id_lugar = estado.id
                            INNER JOIN LUGAR pais ON estado.id_lugar = pais.id;
    
create or replace PROCEDURE REPORT8(info OUT sys_refcursor) AS
    BEGIN
        OPEN info
        FOR SELECT c.nombre,c.camas_disponibles, c.atendidos, c.fallecidos, c.recuperados, c.insumos, c.direccion
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

--Reporte 10

CREATE OR REPLACE VIEW REPORTE10 AS
    SELECT pais.foto, ('Modelo: ' || m.tipo || ', ' || m.descripcion) modelo, TO_CHAR(hm.fecha_inicio,'YYYY-MM-DD') fecha
        FROM LUGAR pais INNER JOIN HISTORICO_MODELO hm ON pais.id = hm.id_lugar
                                INNER JOIN MODELO m ON hm.id_modelo = m.id;
    
create or replace PROCEDURE REPORT10(info OUT sys_refcursor) AS
    BEGIN
        OPEN info
        FOR SELECT *
        FROM REPORTE10;
    END;

--Reporte 11

CREATE OR REPLACE VIEW REPORTE11 AS
    SELECT ((SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'infectado')) infectados,
    ((SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'fallecido')) fallecidos,
    ((SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'curado')) recuperados,
    (ROUND(((SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'infectado') / ((SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'infectado')
    + (SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'fallecido') + (SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'curado')) * 100),2) || '%') PorcentajeInfectados,
    (ROUND(((SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'fallecido') / ((SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'infectado')
    + (SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'fallecido') + (SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'curado')) * 100),2) || '%') PorcentajeFallecidos,
    (ROUND(((SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'curado') / ((SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'infectado')
    + (SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'fallecido') + (SELECT COUNT(*) FROM FICHA_MEDICA f WHERE LOWER(f.estado) = 'curado')) * 100),2) || '%') PorcentajeRecuperados
        FROM FICHA_MEDICA fi
            WHERE LOWER(fi.id) = 1;
    
create or replace PROCEDURE REPORT11(info OUT sys_refcursor) AS
    BEGIN
        OPEN info
        FOR SELECT *
        FROM REPORTE11;
    END;

--Reporte 13

CREATE OR REPLACE VIEW REPORTE13 AS
    SELECT pais.foto, cierre.fecha_inicio, cierre.fecha_fin
        FROM LUGAR pais INNER JOIN CIERRE_FRONTERA cierre ON cierre.id_lugar = pais.id;
    
create or replace PROCEDURE REPORT13(info OUT sys_refcursor) AS
    BEGIN
        OPEN info
        FOR SELECT r.foto pais, r.fecha_inicio, NVL(TO_CHAR(r.fecha_fin, 'YYYY-MM-DD'), 'Frontera aún cerrada') fecha_fin
        FROM REPORTE13 r;
    END;