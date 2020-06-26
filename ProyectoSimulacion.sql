set serveroutput on size unlimited;

CREATE OR REPLACE PROCEDURE  Simulacion_patologia IS 
Begin
dbms_Output.put_line(' Inicia simulacion patologia'); 

end;

CREATE OR REPLACE PROCEDURE  Simulacion_Virus(fecha in date, P in number, pt in number, pv in number) IS 
    Cursor Estados is
    Select * from lugar where tipo='Estado';
    
    E number;
    Registro_tabla Lugar%rowtype;
    ran number;
Begin
dbms_Output.put_line(' Inicia simulacion virus 1'); 

    open Estados;
    fetch Estados into Registro_tabla;
    while Estados%Found
    LOOP
    E:=Registro_tabla.id;
    dbms_Output.put_line('-------Estado--------'); 
    dbms_Output.put_line(E); 
    dbms_Output.put_line(Registro_tabla.nombre); 
    Simulacion_infeccion(fecha , P , E );
    Simulacion_recuperacion(fecha , E );
    Simulacion_muertes(fecha , E );
    
    Simulacion_telecomunicacionesA(fecha, pt,E);
    Simulacion_telecomunicacionesB(fecha, pt,E);
    ran:=dbms_random.value(1, 100);
    
    if p=0.70 and ran<50 then
    Simulacion_vuelos(fecha , pv ,E);
    end if;
    
     dbms_Output.put_line('------------------------');    
    fetch Estados into Registro_tabla;
    End loop;

Close Estados;
End;

CREATE OR REPLACE PROCEDURE  Simulacion_infeccion(fecha in date, P in number, E in number) IS 
    por number;
    numero number;
    per ficha_medica%rowtype;
    contagiados number;
    pcontagiados number;
Begin
    dbms_Output.put_line('--Inicia simulacion infeccion--'); 
    SELECT COUNT(*) INTO numero  FROM historico_residencia where id_lugar=E  ;
    por:=numero*P;
	por:= round(por,0);
    contagiados:=0;
    dbms_Output.put_line(por); 
    
    for i in 1..por
	loop
    
	select * into per from(select * from ficha_medica where id_lugar=E ORDER BY DBMS_RANDOM.RANDOM)WHERE  rownum <= 1;
    SELECT COUNT(*) INTO numero  FROM ficha_medica where estado='infectado' and id_persona=per.id_persona;
	
	if per.estado='infectado'  then
    contagiados:=1+contagiados;
    end if;

    end loop;    
    
    if p=0.70 then
    contagiados:=contagiados*2;
    end if;
    
    for i in 1..contagiados
	loop
	select * into per from(select * from ficha_medica where id_lugar=E ORDER BY DBMS_RANDOM.RANDOM)WHERE  rownum <= 1;
    SELECT COUNT(*) INTO numero  FROM ficha_medica where estado='infectado' and id_persona=per.id_persona;
	
	if per.estado='desconocido' or per.estado='sano' then
    dbms_Output.put_line('Se infecta a la persona:'); 
    dbms_Output.put_line(per.id_persona); 
    end if;
    
    
    End loop;
    
    dbms_Output.put_line('--Fin simulacion infeccion--'); 
end;

CREATE OR REPLACE PROCEDURE  Simulacion_recuperacion(fecha in date, E in number) IS 
    numero number;
    por number;
    cura number;
    per ficha_medica%rowtype;
    posi number;
Begin
dbms_Output.put_line('--Inicia simulacion recuperacion--'); 
    SELECT COUNT(*) INTO numero  FROM ficha_medica where id_lugar=E and estado='infectado' ;
    por:=numero*0.70;
	por:= round(por,0);


    dbms_Output.put_line(por); 
    
    for i in 1..por
	loop
    
	select * into per from(select * from ficha_medica where id_lugar=E ORDER BY DBMS_RANDOM.RANDOM)WHERE  rownum <= 1;
    SELECT COUNT(*) INTO numero  FROM ficha_medica where estado='infectado' and id_persona=per.id_persona;
	
    posi:=dbms_random.value(1, 100);
    dbms_Output.put_line('posi'); 
    dbms_Output.put_line(posi); 
	if per.estado='infectado' and posi<5 then
    
    dbms_Output.put_line('Se curo la persona:'); 
    dbms_Output.put_line(per.id_persona); 
    end if;

    end loop;    

dbms_Output.put_line('--Fin simulacion recuperacion--'); 
end;

CREATE OR REPLACE PROCEDURE  Simulacion_muertes(fecha in date, E in number) IS
    por number;
    numero number;
    per ficha_medica%rowtype;
    posi number;
Begin
    dbms_Output.put_line('--Inicia simulacion muertes--'); 
    SELECT COUNT(*) INTO numero  FROM ficha_medica where id_lugar=E and estado='infectado' ;
    por:=numero*0.70;
	por:= round(por,0);

    for i in 1..por
	loop
    
	select * into per from(select * from ficha_medica where id_lugar=E ORDER BY DBMS_RANDOM.RANDOM)WHERE  rownum <= 1;
    SELECT COUNT(*) INTO numero  FROM ficha_medica where estado='infectado' and id_persona=per.id_persona;
	
    posi:=dbms_random.value(1, 100);
    dbms_Output.put_line('posi'); 
    dbms_Output.put_line(posi); 
	if per.estado='infectado' and posi<3 then
    
    dbms_Output.put_line('F por :'); 
    dbms_Output.put_line(per.id_persona); 
    end if;

    end loop; 
    dbms_Output.put_line('--Fin simulacion muertes--'); 
end;

CREATE OR REPLACE PROCEDURE  Simulacion_vuelos(fecha in date, pv in number, E in number) IS 
    Cursor personas is
    Select * from historico_residencia where fecha_fin is NULL and id_lugar=E;  
    
    maximo number;
    aero aerolinea%rowtype;
    Registro_tabla historico_residencia%rowtype;
    visi visita%rowtype;
    numero number;
    ran number;
    
Begin
    select max(N_vuelo) into maximo from vuelo;
	select * into aero from(select * from aerolinea  ORDER BY DBMS_RANDOM.RANDOM)WHERE  rownum <= 1;
    maximo:=maximo+1;
    dbms_Output.put_line('--Inicia simulacion vuelos--'); 
    dbms_Output.put_line(maximo); 
    dbms_Output.put_line(aero.nombre); 
    
    open personas;
    fetch personas into Registro_tabla;
    while personas%Found
    LOOP

    SELECT COUNT(*) INTO numero  FROM visita where id_persona=Registro_tabla.id_persona and fecha_salida is not null;
 
 
    if numero=1 then
    ran:=dbms_random.value(1, 100);
    
        if ran<30 then
        dbms_Output.put_line('la siguiente persona viajo'); 
        dbms_Output.put_line(Registro_tabla.id_persona); 
        end if;
    
    end if;
    
    fetch personas into Registro_tabla;
    end loop;  
    dbms_Output.put_line('--Fin simulacion vuelos--'); 
end;

CREATE OR REPLACE PROCEDURE  Simulacion_telecomunicacionesA(fecha in date, pt in number, E in number) IS 
    por number;
    compa�ia proveedor_internet%rowtype;
    numero number;
    ran number;
    proba number;
Begin
dbms_Output.put_line('--Inicia simulacion telecomunicacionesA--');
    SELECT COUNT(*) INTO numero  FROM  proveedor_internet;
    por:=numero*pt;
	por:= round(por,0);
    proba:=pt*100;
    numero:=0;
dbms_Output.put_line(por);
    
    for i in 1..por
	loop
    select * into compa�ia from(select * from proveedor_internet ORDER BY DBMS_RANDOM.RANDOM)WHERE  rownum <= 1;
    SELECT COUNT(*) INTO numero  FROM interrupcion where fecha_fin is null and id_proveedor=compa�ia.id and id_lugar=E;

    if numero=0 then
    ran:=dbms_random.value(1, 100);
    
        if ran<proba then
        dbms_Output.put_line('Se genero una interrupcion con la compa�ia'); 
        dbms_Output.put_line(compa�ia.nombre); 
        end if;
    
    end if;
    
    
    end loop;
    dbms_Output.put_line('--Fin simulacion telecomunicacionesA--');
end;

CREATE OR REPLACE PROCEDURE  Simulacion_telecomunicacionesB(fecha in date, pt in number, E in number) IS 
    Cursor inter is
    Select * from interrupcion where fecha_fin is null and id_lugar=E;
    
    Registro_tabla interrupcion%rowtype;
    ran number;
begin 
dbms_Output.put_line('--Inicia simulacion telecomunicaciones B--');
    open inter;
    fetch inter into Registro_tabla;
    while inter%Found
    LOOP
    ran:=dbms_random.value(1, 100);
    
        if ran<50 then
        dbms_Output.put_line('se termino la interrupcion de'); 
        dbms_Output.put_line(Registro_tabla.id_proveedor); 
        end if;

    fetch inter into Registro_tabla;
    End loop;

dbms_Output.put_line('--Fin simulacion telecomunicaciones B--');
end;



CREATE OR REPLACE PROCEDURE  Simulacion_Ayudah(fecha in date) IS 
    Cursor centros is
    select * from insumo_disponible;
    
    estado number;
    estado2 number;
    pais1 number;
    pais2 number;
    buscador number;
    condicion number;
    estadocentro number;
    paiscentro number;
    ran number;
    numeroi number;
    
    i1 number:=0;
    i2 number:=0;
    i3 number:=0;
    i4 number:=0;
    i5 number:=0;
    i6 number:=0;
    i7 number:=0;
    i8 number:=0;
    i9 number:=0;
    i10 number:=0;
    i11 number:=0;
    i12 number:=0;
    i13 number:=0;
    i14 number:=0;
    i15 number:=0;
    
    paisa lugar%rowtype;
    paisd lugar%rowtype;
    Registro_tabla insumo_disponible%rowtype;
    
Begin
dbms_Output.put_line('--Inicia simulacion ayuda humanitaria--'); 
    buscador:=1;
    condicion:=0;
    select id_lugar into estado from (select count(id_lugar),id_lugar from ficha_medica where estado='infectado' group by id_lugar order by count(id_lugar) desc)WHERE  rownum <= 1;
    select id_lugar into pais1 from lugar where id=estado;
    dbms_Output.put_line('pais mas necesitado'); 
    dbms_Output.put_line(pais1);

    WHILE condicion=0
    LOOP

    select id_lugar into estado2 from(select id_lugar, rownum as rn from(select count(id_lugar),id_lugar from ficha_medica where estado='infectado' group by id_lugar order by count(id_lugar) asc))where rn=buscador;
    select id_lugar into pais2 from lugar where id=estado2;
    
    if pais2<>pais1 then
    condicion:=1;
    else
    buscador:=buscador+1;
    end if;

    
    END loop;
    dbms_Output.put_line('pais menos necesitado'); 
    dbms_Output.put_line(pais2);


    open centros;
    fetch centros into Registro_tabla;
    while centros%Found
    LOOP
 
    select id_lugar into paiscentro from lugar where id=Registro_tabla.id_lugar;
    
    
        if paiscentro=pais2 then
        ran:=dbms_random.value(100, 1000);
        numeroi:= round(ran,0);
        dbms_Output.put_line('Donacion a'); 
        dbms_Output.put_line(Registro_tabla.id_centro_salud); 
        dbms_Output.put_line(Registro_tabla.id_insumo); 
        dbms_Output.put_line(numeroi);
    
            if 1=Registro_tabla.id_insumo then
            i1:=i1+numeroi;
        
            elsif 2=Registro_tabla.id_insumo then
            i2:=i2+numeroi;        
      
            elsif 3=Registro_tabla.id_insumo then
            i3:=i3+numeroi;
        
            elsif 4=Registro_tabla.id_insumo then
            i4:=i4+numeroi;
        
            elsif 5=Registro_tabla.id_insumo then
            i5:=i5+numeroi;
        
            elsif 6=Registro_tabla.id_insumo then
            i6:=i6+numeroi;
        
            elsif 7=Registro_tabla.id_insumo then
            i7:=i7+numeroi;
        
            elsif 8=Registro_tabla.id_insumo then
            i8:=i8+numeroi;
        
            elsif 9=Registro_tabla.id_insumo then
            i9:=i9+numeroi;
        
            elsif 10=Registro_tabla.id_insumo then
            i10:=i10+numeroi; 
        
            elsif 11=Registro_tabla.id_insumo then
            i11:=i11+numeroi; 
        
            elsif 12=Registro_tabla.id_insumo then
            i12:=i12+numeroi; 
        
            elsif 13=Registro_tabla.id_insumo then
            i13:=i13+numeroi; 
        
            elsif 14=Registro_tabla.id_insumo then
            i14:=i14+numeroi; 
        
            elsif 15=Registro_tabla.id_insumo then
            i15:=i15+numeroi; 
        
            end if;
        end if;


    fetch centros into Registro_tabla;
    End loop;
    
Close centros;
    dbms_Output.put_line('----------------------------------------------------------------------------');
    dbms_Output.put_line(i1);
    dbms_Output.put_line(i2);
    dbms_Output.put_line(i3);
    dbms_Output.put_line(i4);
    dbms_Output.put_line(i5);
    dbms_Output.put_line(i6);
    dbms_Output.put_line(i7);
    dbms_Output.put_line(i8);
    dbms_Output.put_line(i9);
    dbms_Output.put_line(i10);
    dbms_Output.put_line(i11);
    dbms_Output.put_line(i12);
    dbms_Output.put_line(i13);
    dbms_Output.put_line(i14);
    dbms_Output.put_line(i15);
    
dbms_Output.put_line('--Fin simulacion ayuda humanitaria--'); 
end;

 



CREATE OR REPLACE PROCEDURE  Simulacion_Abastecimiento(fecha in date) IS 
    Cursor centros is
    select * from insumo_disponible;
    
    centro number;
    Registro_tabla insumo_disponible%rowtype;
    centrosal centro_salud%rowtype;
    ran number;
    insumo number;

Begin
    dbms_Output.put_line('--Inicia simulacion abastecimiento--'); 

    open centros;
    fetch centros into Registro_tabla;
    while centros%Found
    LOOP

    select * into centrosal from centro_salud where id=Registro_tabla.id_centro_salud;

    
    if centrosal.tipo='privado' then
        if Registro_tabla.cantidad < 100 then
        dbms_Output.put_line('se compran insumos'); 
        dbms_Output.put_line(Registro_tabla.id_insumo); 
        dbms_Output.put_line('en el centro de salud');
        dbms_Output.put_line(centrosal.id);   
        ran:=dbms_random.value(100, 1000);
        insumo:= round(ran,0);
        dbms_Output.put_line(insumo);   
        end if;
    
    end if;
    

    fetch centros into Registro_tabla;
    End loop;

    dbms_Output.put_line('--fin simulacion abastecimiento--'); 
end;




CREATE OR REPLACE PROCEDURE  Simulacion(fecha_inicio in date, fecha_fin in date, modelo in number)IS 
    dias number;
    P number;
    pv number;
    pt number;
    factual date;
    ayuda number;
Begin
    dias:= fecha_fin- fecha_inicio;
    if dias>0 and modelo=0 or modelo=1 then
    dbms_Output.put_line(' Inicia simulacion'); 
    dbms_Output.put_line(dias); 
    
    if modelo=0 then 
    dbms_Output.put_line('Modelo libre movilidad');
    P:=0.70;
    pv:=0.10;
    pt:=0.08;
    else
    dbms_Output.put_line('Modelo movilidad reducida (3)');
    P:=0.25;
    pv:=0.02;
    pt:=0.40;
    end if;
    
    
    dbms_Output.put_line(P);
    Simulacion_patologia;
    factual:=fecha_inicio;
    ayuda:=15;
    for i in 1..dias+1
        loop
        dbms_Output.put_line('-------------------------------------------------------Dia -----------------------------------------------------------------');
        dbms_Output.put_line(i);
        dbms_Output.put_line(factual);
    
        Simulacion_Virus(factual, P, pt, pv);


        Simulacion_Abastecimiento(factual);
        
        if ayuda=i then
        Simulacion_Ayudah(factual);
        ayuda:=15+ayuda;
        end if;
        
        factual:=factual+1;
        end loop;
    else
    dbms_Output.put_line('Las fechas indicadas no son correctas o el numero de modelo no es correcto'); 
    end if;
end;

execute Simulacion(TO_DATE('2020-04-02','YYYY-MM-DD'),TO_DATE('2020-04-20','YYYY-MM-DD'),1);
execute Simulacion_patologia;

select * from insumo_disponible;
Select * from lugar where tipo='Pais';
select * from Historico_residencia where id_lugar=16;
select * from persona;
select * from ficha_medica where estado='desconido';
select * from(select * from ficha_medica where id_lugar=16 ORDER BY DBMS_RANDOM.RANDOM)WHERE  rownum <= 1;

select * from visita;

