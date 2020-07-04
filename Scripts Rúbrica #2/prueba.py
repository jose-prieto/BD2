from faker import Faker
from random import randint
fake = Faker()
i = 300
j = 0
fic = open("personas.sql","w")
id_persona = 50
gender = ""
id_lugar = 0
id_centro = 0
id_patologia = 0
id_sintoma = 0
cantidad = 0
aux = 0
aux1 = 0
while j <= i:
    #Arregla el id al formato del la BD
    id_str = str(id_persona)
    if id_persona >= 10 and id_persona < 100:
        id = "000" + id_str
    elif id_persona >= 100 and id_persona < 1000:
        id = "00" + id_str
    elif id_persona >= 1000:
        id = "0" + id_str
    #Selecciona un sexo
    if id_persona%2 == 0:
        gender = "m"
    else:
        gender = "f"
    ##Selecciona su residencia
    id_lugar = randint(18, 45)
    #TO_DATE(f.FECHA_INFECCION,'YYYY-MM-DD')
    fic.write(f"""INSERT INTO EX.PERSONA(DOC_IDENTIDAD, NOMBRE, NOMBRE1, APELLIDO, APELLIDO1, FECHA_NAC, GENERO, FOTO) VALUES
                  ('{id}', '{fake.first_name()}', '{fake.first_name()}', '{fake.last_name()}', '{fake.last_name()}', TO_DATE('{fake.date()}','YYYY-MM-DD'), '{gender}', NULL);""")
    fic.write("\n")
    fic.write(f"""INSERT INTO EX.HISTORICO_RESIDENCIA(FECHA_INICIO, ID_LUGAR, ID_PERSONA, FECHA_FIN) VALUES
                  (TO_DATE('{fake.date()}','YYYY-MM-DD'), {id_lugar}, '{id}', NULL);""")
    ###Selecionar su clinica
    if id_lugar == 16:
        id_centro = 1
    elif id_lugar == 17:
        id_centro = 2
    elif id_lugar == 18:
        id_centro = 3
    elif id_lugar == 19:
        id_centro = 4
    elif id_lugar == 20:
        id_centro = 5
    elif id_lugar == 21:
        id_centro = 6
    elif id_lugar == 22:
        id_centro = 7
    elif id_lugar == 23:
        id_centro = 8
    elif id_lugar == 24:
        id_centro = 9
    elif id_lugar == 25:
        id_centro = 10
    elif id_lugar == 26:
        id_centro = 11
    elif id_lugar == 27:
        id_centro = 12
    elif id_lugar == 28:
        id_centro = 13
    elif id_lugar == 29:
        id_centro = 14
    elif id_lugar == 30:
        id_centro = 15
    elif id_lugar == 31:
        id_centro = 16
    elif id_lugar == 32:
        id_centro = 17
    elif id_lugar == 33:
        id_centro = 18
    elif id_lugar == 34:
        id_centro = 19
    elif id_lugar == 35:
        id_centro = 20
    elif id_lugar == 36:
        id_centro = 21
    elif id_lugar == 37:
        id_centro = 22
    elif id_lugar == 38:
        id_centro = 23
    elif id_lugar == 39:
        id_centro = 24
    elif id_lugar == 40:
        id_centro = 25
    elif id_lugar == 41:
        id_centro = 26
    elif id_lugar == 42:
        id_centro = 27
    elif id_lugar == 43:
        id_centro = 28
    elif id_lugar == 44:
        id_centro = 29
    elif id_lugar == 45:
        id_centro = 30
    ###Seleccionar su cinica
    fic.write("\n")
    fic.write(f"""INSERT INTO EX.FICHA_MEDICA(ID, ID_PERSONA, ID_CENTRO_SALUD, ID_LUGAR, ESTADO, FECHA_INFECCION, FECHA_RECUPERACION) VALUES
                                             ({id_persona}, '{id}', {id_centro}, {id_lugar}, 'desconido', NULL, NULL);""")
    fic.write("\n")
    aux1 = randint(0, 1)
    if (aux1):
        cantidad = randint(1, 15)
        if(cantidad):
            cantidad -= 1
            while aux<=cantidad:
                fic.write(f"""INSERT INTO EX.PADECIMIENTOS(ID_PATOLOGIA, ID_PERSONA, ID_FICHA_MEDICA) VALUES
                            ({aux + 1}, '{id}', {id_persona});""")
                fic.write("\n")
                aux += 1
            aux = 0
            aux1 = 0
    aux1 = randint(0, 1)
    if (aux1):
        cantidad = randint(1, 19)
        if (cantidad):
            cantidad -= 1
            while aux<=cantidad:
                fic.write(f"""INSERT INTO EX.SINTOMAS(FECHA_INICIO, ID_SINTOMA, ID_PERSONA, ID_FICHA_MEDICA) VALUES
                            (TO_DATE('{fake.date_this_year(before_today=True, after_today=False)}','YYYY-MM-DD'), {aux + 1}, '{id}', {id_persona});""")
                fic.write("\n")
                aux += 1
            aux = 0
            aux1 = 0
    j += 1
    id_persona += 1
fic.close()
