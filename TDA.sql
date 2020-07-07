CREATE OR REPLACE TYPE control_casos AS OBJECT(
    dummy NUMBER,
    STATIC FUNCTION total_poblacion_estado(lugar VARCHAR2) RETURN 
NUMBER,--listo
    STATIC FUNCTION total_poblacion_pais(lugar VARCHAR2) RETURN 
NUMBER,--listo
    STATIC FUNCTION cantidad_infectados(lugar VARCHAR2) RETURN 
NUMBER,--listo
    STATIC FUNCTION cantidad_fallecidos(lugar VARCHAR2) RETURN 
NUMBER,--listo
    STATIC FUNCTION cantidad_recuperados(lugar VARCHAR2) RETURN 
NUMBER,--listo
    STATIC FUNCTION cantidad_infectados2(lugar VARCHAR2,fechai 
DATE,fechaf DATE)RETURN NUMBER,--por implementar
    STATIC FUNCTION cantidad_fallecidos2(lugar VARCHAR2,fechai DATE, 
fechaf DATE)RETURN NUMBER,--por implementar
    STATIC FUNCTION cantidad_recuperados2(lugar VARCHAR2,fechai DATE, 
fechaf DATE)RETURN NUMBER,--por implmentar
    STATIC FUNCTION curva_infeccion(lugar VARCHAR2,fechai DATE, fechaf 
DATE)RETURN NUMBER,--por implmentar
    STATIC FUNCTION efectividad_modelo(lugar VARCHAR2, modelo 
VARCHAR2)RETURN NUMBER);  --por implementar  
    
CREATE OR REPLACE TYPE BODY control_casos AS
STATIC FUNCTION cantidad_infectados(lugar VARCHAR2) RETURN NUMBER
IS
    cantidad number(4);
BEGIN
    SELECT COUNT(h.id_persona)
    INTO cantidad
    FROM historico_residencia h, (SELECT id FROM lugar WHERE nombre = 
lugar)x, (SELECT DISTINCT(estado) FROM ficha_medica WHERE estado 
='infectado' OR estado='cuarentena')z
    WHERE (h.id_lugar = x.id) 
    AND (z.ESTADO IN (SELECT f.estado FROM ficha_medica f WHERE 
f.id_persona=h.id_persona) OR z.ESTADO IN (SELECT f.estado FROM 
ficha_medica f WHERE id_persona=h.id_persona));
    RETURN cantidad;
END;
STATIC FUNCTION total_poblacion_estado(lugar VARCHAR2) RETURN NUMBER
IS
    prueba number(4);
BEGIN
    SELECT COUNT(h.id_persona)
    INTO prueba
    FROM historico_residencia h, (SELECT id FROM lugar WHERE nombre = 
lugar)x
    WHERE (h.id_lugar = x.id);
    RETURN prueba;
END;
STATIC FUNCTION total_poblacion_pais(lugar VARCHAR2) RETURN NUMBER
IS
    prueba number(4);
BEGIN
    SELECT COUNT(h.id_persona)
    INTO prueba
    FROM historico_residencia h, (SELECT id FROM lugar WHERE nombre = 
lugar)x, lugar l
    WHERE (h.id_lugar = l.id) AND (x.id = l.id_lugar);
    RETURN prueba;
    END;
STATIC FUNCTION cantidad_fallecidos(lugar VARCHAR2) RETURN NUMBER
IS
    cantidad number(4);
BEGIN
    SELECT COUNT(h.id_persona)
    INTO cantidad
    FROM historico_residencia h, (SELECT id FROM lugar WHERE nombre = 
lugar)x, (SELECT DISTINCT(estado) FROM ficha_medica WHERE estado 
='fallecido')z
    WHERE (h.id_lugar = x.id) 
    AND (z.ESTADO IN (SELECT f.estado FROM ficha_medica f WHERE 
f.id_persona=h.id_persona));
    RETURN cantidad;
END;
STATIC FUNCTION cantidad_recuperados(lugar VARCHAR2) RETURN NUMBER
IS
    cantidad number(4);
BEGIN
    SELECT COUNT(h.id_persona)
    INTO cantidad
    FROM historico_residencia h, (SELECT id FROM lugar WHERE nombre = 
lugar)x, (SELECT DISTINCT(estado) FROM ficha_medica WHERE estado 
='curado')z
    WHERE (h.id_lugar = x.id) 
    AND (z.ESTADO IN (SELECT f.estado FROM ficha_medica f WHERE 
f.id_persona=h.id_persona));
    RETURN cantidad;
END;
STATIC FUNCTION cantidad_infectados2(lugar VARCHAR2,fechai DATE,fechaf 
DATE)RETURN NUMBER
IS
    cantidad number(4);
BEGIN
    cantidad := 0;
    RETURN cantidad;
END;
STATIC FUNCTION cantidad_fallecidos2(lugar VARCHAR2,fechai DATE, fechaf 
DATE)RETURN NUMBER
IS
    cantidad number(4);
BEGIN
    cantidad := 0;
    RETURN cantidad;
END;
STATIC FUNCTION cantidad_recuperados2(lugar VARCHAR2,fechai DATE, fechaf 
DATE)RETURN NUMBER
IS
    cantidad number(4);
BEGIN
    cantidad := 0;
    RETURN cantidad;
END;
STATIC FUNCTION curva_infeccion(lugar VARCHAR2,fechai DATE, fechaf 
DATE)RETURN NUMBER
IS
    cantidad number(4);
BEGIN
    cantidad := 0;
    RETURN cantidad;
END;
STATIC FUNCTION efectividad_modelo(lugar VARCHAR2, modelo 
VARCHAR2)RETURN NUMBER
IS
    cantidad number(4);
BEGIN
    cantidad := cantidad_infectados(lugar);
    RETURN cantidad;
END;
END;