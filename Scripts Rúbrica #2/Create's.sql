CREATE SEQUENCE id_modelo
	INCREMENT BY 1
	START WITH 1;

CREATE TABLE modelo(
    id number PRIMARY KEY,
    tipo varchar2(2) NOT NULL,
    descripcion varchar2(100) NOT NULL
);

CREATE SEQUENCE pk_lugar
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE TABLE lugar(
    id number PRIMARY KEY,
    nombre varchar2(20) NOT NULL,
    tipo varchar2(20) NOT NULL,
    id_lugar number,
    foto BLOB DEFAULT EMPTY_BLOB(),
    codigo_postal varchar2(5),
    CONSTRAINT fk_lugar_recursivo FOREIGN KEY (id_lugar) REFERENCES lugar(id),
    CONSTRAINT check_tipo CHECK(tipo in('Pais','Estado','Avenida','Urbanizacion'))
);
CREATE INDEX lugar_recursivo on lugar(id_lugar);

CREATE TABLE historico_modelo(
    --pk
    fecha_inicio DATE NOT NULL,
    id_modelo number NOT NULL, --fk1
    id_lugar number NOT NULL, --fk2
    --pk
    fecha_fin DATE,
    CONSTRAINT pk_historico_modelo PRIMARY KEY(fecha_inicio,id_modelo,id_lugar),
    CONSTRAINT fk_modelo FOREIGN KEY (id_modelo) REFERENCES modelo(id),
    CONSTRAINT fk_lugar_modelo FOREIGN KEY (id_lugar) REFERENCES lugar(id)
);

CREATE TABLE cierre_frontera(
    --pk
    fecha_inicio DATE NOT NULL,
    id_lugar number NOT NULL, --fk1
    --pk
    fecha_fin DATE,
    CONSTRAINT pk_cierre_frontera PRIMARY KEY(fecha_inicio,id_lugar),
    CONSTRAINT fk_id_lugar FOREIGN KEY (id_lugar) REFERENCES lugar(id)
);
CREATE INDEX cf_fk_idlugar ON cierre_frontera(id_lugar);

CREATE TABLE ayuda_humanitaria(
    --pk
    fecha_recibida DATE NOT NULL,
    id_lugar_recibe number NOT NULL,--fk1
    id_lugar_envia number NOT NULL,--fk2
    --pk
    dinero_donado number,
    CONSTRAINT pk_ayuda_humanitaria PRIMARY KEY(fecha_recibida,id_lugar_recibe,id_lugar_envia),
    CONSTRAINT fk_recibe FOREIGN KEY (id_lugar_recibe) REFERENCES lugar(id),
    CONSTRAINT fk_envia FOREIGN KEY (id_lugar_envia) REFERENCES lugar(id)
);
CREATE INDEX ah_fk_recibe ON ayuda_humanitaria(id_lugar_recibe);
CREATE INDEX ah_fk_envia ON ayuda_humanitaria(id_lugar_envia);

CREATE SEQUENCE pk_insumo
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;
CREATE TABLE insumo(
    id number PRIMARY KEY,
    nombre varchar2(20)
);

CREATE TABLE insumos_donados(
    --pk
    id_insumo number NOT NULL,--fk1
    id_ayuda_humanitaria DATE NOT NULL,--fk2
    id_pais_recibe number NOT NULL, --f2
    id_pais_envia number NOT NULL, --fk2
    --pk
    cantidad number NOT NULL,
    CONSTRAINT pk_insumos_donados PRIMARY KEY(id_insumo,id_ayuda_humanitaria,id_pais_recibe,id_pais_envia),
    CONSTRAINT fk_insumo FOREIGN KEY (id_insumo) REFERENCES insumo(id),
    CONSTRAINT fk_ayudare FOREIGN KEY (id_ayuda_humanitaria,id_pais_envia,id_pais_recibe) REFERENCES ayuda_humanitaria(fecha_recibida,id_lugar_envia,id_lugar_recibe)
);
CREATE INDEX id_fk_insumo ON insumos_donados(id_insumo);
CREATE INDEX id_fk_ayudare ON insumos_donados(id_ayuda_humanitaria,id_pais_envia,id_pais_recibe);

CREATE SEQUENCE pk_centro_salud
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;
CREATE TABLE centro_salud(
    id number NOT NULL,
    nombre varchar(20) NOT NULL,
    tipo varchar(8) NOT NULL,
    camas_disponibles number NOT NULL,
    id_lugar number NOT NULL,--fk
    CONSTRAINT pk_centro_salud PRIMARY KEY(id,id_lugar),
    CONSTRAINT fk_lugar_centro_salud FOREIGN KEY (id_lugar) REFERENCES lugar(id),
    CONSTRAINT check_tipo_centro_salud CHECK(tipo in ('publico','privado'))
);
CREATE INDEX cs_fk_lugar ON centro_salud(id_lugar);

CREATE TABLE insumo_disponible(
    --pk
    id_insumo number NOT NULL,--fk1
    id_centro_salud number NOT NULL,--fk2
    id_lugar number NOT NULL, --fk2
    --pk
    cantidad number NOT NULL,
    CONSTRAINT pk_insumos_disponibles PRIMARY KEY(id_insumo,id_centro_salud,id_lugar),
    CONSTRAINT fk_insumo_insumo_disponible FOREIGN KEY (id_insumo) REFERENCES insumo(id),
    CONSTRAINT fk_centro_lugar_insumo_disponible FOREIGN KEY (id_centro_salud,id_lugar) REFERENCES centro_salud(id,id_lugar)
);
CREATE INDEX id_fk_insumoCS ON insumo_disponible(id_insumo);
CREATE INDEX id_fk_centro_lugar ON insumo_disponible(id_centro_salud,id_lugar);

CREATE SEQUENCE pk_proveedor_internet
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;
CREATE TABLE proveedor_internet(
    id number PRIMARY KEY,
    nombre varchar2(20) NOT NULL,
    foto BLOB DEFAULT EMPTY_BLOB(),
    velocidad_subida number NOT NULL,
    velocidad_bajada number NOT NULL
);

CREATE TABLE interrupcion(
    --pk
    fecha_inicio DATE NOT NULL,
    id_proveedor number NOT NULL, --fk1
    id_lugar number NOT NULL, --fk2
    --pk
    fecha_fin DATE,
    CONSTRAINT pk_interrupcion PRIMARY KEY(fecha_inicio,id_proveedor,id_lugar),
    CONSTRAINT fk_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor_internet(id),
    CONSTRAINT fk_lugar_interrupcion FOREIGN KEY (id_lugar) REFERENCES lugar(id)
);
CREATE INDEX i_fk_proveedor ON interrupcion(id_proveedor);
CREATE INDEX i_fk_lugar ON interrupcion(id_lugar);

CREATE SEQUENCE id_aerolinea
INCREMENT BY 1
START WITH 1;

CREATE TABLE aerolinea(
    id number PRIMARY KEY,
    nombre varchar2(20) NOT NULL,
    foto BLOB DEFAULT EMPTY_BLOB()
);

CREATE TABLE vuelo(
    --pk
    n_vuelo number NOT NULL,
    fecha_vuelo DATE NOT NULL,
    id_aerolinea number NOT NULL,--fk1
    id_origen number NOT NULL,--fk2
    id_destino number NOT NULL,--fk3
    --pk
    CONSTRAINT pk_vuelo PRIMARY KEY(n_vuelo,fecha_vuelo,id_aerolinea,id_origen,id_destino),
    CONSTRAINT fk_aerolinea FOREIGN KEY (id_aerolinea) REFERENCES aerolinea(id),
    CONSTRAINT fk_origen FOREIGN KEY (id_origen) REFERENCES lugar(id),
    CONSTRAINT fk_destino FOREIGN KEY (id_destino) REFERENCES lugar(id)
);
CREATE INDEX v_fk_aerolinea ON vuelo(id_aerolinea);
CREATE INDEX v_fk_origen ON vuelo(id_origen);
CREATE INDEX v_fk_destino ON vuelo(id_destino);

CREATE TABLE persona(
    doc_identidad varchar2(20) PRIMARY KEY,
    nombre varchar2(20) NOT NULL,
    nombre1 varchar2(20) DEFAULT NULL,
    apellido varchar2(20) NOT NULL,
    apellido1 varchar2(20) DEFAULT NULL,
    fecha_nac DATE NOT NULL,
    genero varchar2(1) NOT NULL,
    foto BLOB DEFAULT EMPTY_BLOB(),
    CONSTRAINT check_genero CHECK(genero in ('M','F','m','f'))
);

CREATE TABLE pasajero(
    --pk
    id_persona varchar2(20) NOT NULL, --fk1
    id_vuelo number NOT NULL, --fk2
    id_fecha_vuelo DATE NOT NULL, --fk2
    id_aerolinea number NOT NULL,--fk2
    id_destino number NOT NULL,--fk2
    id_origen number NOT NULL,--fk2
    --pk
    CONSTRAINT pk_pasajero PRIMARY KEY(id_persona,id_vuelo,id_fecha_vuelo,id_aerolinea,id_destino,id_origen),
    CONSTRAINT fk_persona_pasajero FOREIGN KEY (id_persona) REFERENCES persona(doc_identidad),
    CONSTRAINT fk_vuelo_pasajero FOREIGN KEY (id_vuelo,id_fecha_vuelo,id_aerolinea,id_destino,id_origen) REFERENCES vuelo(n_vuelo,fecha_vuelo,id_aerolinea,id_destino,id_origen)
);
CREATE INDEX p_fk_persona ON pasajero(id_persona);
CREATE INDEX p_fk_vuelo ON pasajero(id_vuelo,id_fecha_vuelo,id_aerolinea,id_destino,id_origen);

CREATE TABLE visita(
    --pk
    fecha_ingreso DATE NOT NULL,
    id_lugar number NOT NULL,--fk1
    id_persona varchar(20) NOT NULL, --fk2
    id_vuelo number NOT NULL,--fk2
    id_fecha_vuelo DATE NOT NULL, --fk2
    id_aerolinea number NOT NULL,--fk2
    id_origen number NOT NULL,--fk2
    id_destino number NOT NULL,--fk2
    --pk
    fecha_salida DATE,
    CONSTRAINT pk_visita PRIMARY KEY(fecha_ingreso,id_lugar,id_persona,id_vuelo,id_fecha_vuelo,id_aerolinea,id_origen,id_destino),
    CONSTRAINT fk_lugar_visita FOREIGN KEY (id_lugar) REFERENCES lugar(id),
    CONSTRAINT fk_pasajero_visita FOREIGN KEY (id_persona,id_vuelo,id_fecha_vuelo,id_aerolinea,id_origen,id_destino) REFERENCES pasajero(id_persona,id_vuelo,id_fecha_vuelo,id_aerolinea,id_origen,id_destino)
);
CREATE INDEX v_fk_lugar ON visita(id_lugar);
CREATE INDEX v_fk_pasajero ON visita(id_persona,id_vuelo,id_fecha_vuelo,id_aerolinea,id_origen,id_destino);

CREATE TABLE historico_residencia(
    --pk
    fecha_inicio DATE NOT NULL,
    id_lugar number NOT NULL, --FK1
    id_persona varchar2(20) NOT NULL, --FK2
    --pk
    fecha_fin DATE,
    CONSTRAINT pk_historico_residencia PRIMARY KEY(fecha_inicio,id_lugar,id_persona),
    CONSTRAINT fk_lugar FOREIGN KEY (id_lugar) REFERENCES lugar(id),
    CONSTRAINT fk_persona FOREIGN KEY (id_persona) REFERENCES persona(doc_identidad)
);
CREATE INDEX hr_fk_lugar ON historico_residencia(id_lugar);
CREATE INDEX hr_fk_persona ON historico_residencia(id_persona);

CREATE TABLE ficha_medica(
    --pk
    id number NOT NULL,
    id_persona varchar2(20) NOT NULL,--fk1
    --pk
    id_centro_salud number, --fk2
    id_lugar number,--fk2
    estado varchar2(12) NOT NULL,
    fecha_infeccion date,
    fecha_recuperacion date,
    CONSTRAINT pk_ficha_medica PRIMARY KEY(id,id_persona),
    CONSTRAINT fk_persona_fm FOREIGN KEY (id_persona) REFERENCES persona(doc_identidad),
    CONSTRAINT fk_centro_fm FOREIGN KEY (id_centro_salud,id_lugar) REFERENCES centro_salud(id,id_lugar),
    CONSTRAINT check_estado_ficha_medica CHECK(estado in ('desconido','fallecido','sano','infectado','curado','cuarentena'))
);
CREATE INDEX fm_fk_persona ON ficha_medica(id_persona);
CREATE INDEX fm_fk_centro ON ficha_medica(id_centro_salud);

CREATE SEQUENCE pk_patologia
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE TABLE patologia(
    id number PRIMARY KEY,
    nombre varchar2(100) NOT NULL
);

CREATE SEQUENCE pk_sintoma
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE TABLE sintoma(
    id number PRIMARY KEY,
    nombre varchar2(100) NOT NULL
);

CREATE TABLE sintomas(
    --pk
    fecha_inicio DATE NOT NULL,
    id_sintoma number NOT NULL,--fk1
    id_ficha_medica number NOT NULL,--fk2
    id_persona varchar(20) NOT NULL, --fk2
    --pk
    CONSTRAINT pk_sintomas PRIMARY KEY(fecha_inicio,id_sintoma,id_persona,id_ficha_medica),
    CONSTRAINT fk_sintoma FOREIGN KEY (id_sintoma) REFERENCES sintoma(id),
    CONSTRAINT fk_s_ficha_medica FOREIGN KEY (id_ficha_medica, id_persona) REFERENCES ficha_medica(id,id_persona)
);
CREATE INDEX w_fk_patologia ON sintomas(id_sintoma);
CREATE INDEX w_fk_ficha_medica ON sintomas(id_ficha_medica, id_persona);

CREATE TABLE padecimientos(
    --pk
    id_patologia number NOT NULL,--fk1
    id_ficha_medica number NOT NULL,--fk2
    id_persona varchar(20) NOT NULL, --fk2
    --pk
    CONSTRAINT pk_padecimientos PRIMARY KEY(id_patologia,id_persona,id_ficha_medica),
    CONSTRAINT fk_patologia FOREIGN KEY (id_patologia) REFERENCES patologia(id),
    CONSTRAINT fk_ficha_medica FOREIGN KEY (id_ficha_medica, id_persona) REFERENCES ficha_medica(id,id_persona)
);
CREATE INDEX z_fk_patologia ON padecimientos(id_patologia);
CREATE INDEX z_fk_ficha_medica ON padecimientos(id_ficha_medica, id_persona);