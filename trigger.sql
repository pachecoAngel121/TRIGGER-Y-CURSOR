-----------------------------------TRIGGER------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION TR_TEST() RETURNS TRIGGER AS
$$
DECLARE 
session int;
BEGIN 
select count (*) into session from pago_tutoria where id_session = new.id_session;
if (session>=1)then
raise exception 'NO PUEDE INGRESAR A LA SESSION POR FALTA DE PAGO';
END IF;
RETURN NEW;
END
$$
lANGUAGE plpgsql;
create trigger TR_TEST before insert
on pago_tutoria for each row
execute procedure TR_TEST();

insert into session values('id_pago_tutoria','id_session','pago_tutoria','descripicon_tutoria','fecha_pago');



insert into session values ('10','10','10','VIRTUAL','7:00AM','10:00AM','15','TRANSFERENCIA','Rechazado');
select * from session


-----------------------------------------------------CURSOR-----------------------------------------------------------
/*
Cursor de base de datos que muestre  nombre del estudiante, apellido, nombre provincia, tipo session, calificacion 
*/ 
-----------------------------------
-- CURSOR HISTORICO POR ESTUDIANTE
-----------------------------------
SELECT * FROM estudiante
select * from session
select * from calificacion_de_sesicion
DO $$
DECLARE
		PERIODO RECORD;
		CUR_ALUMNO CURSOR FOR 
				   SELECT
				     estudiante.nombre_estudiante as Nombre_Estudiante,
				     estudiante.apellido_estudiante as Apellido_Estudiante,
				     provincia.nombre_provincia as Nombre_Provincia,
				     calificacion_de_sesicion.nota_session as Nota_Session
				     from estudiante
				     inner join provincia on provincia.id_provincia = estudiante.id_estudiante 
				     inner join calificacion_de_sesicion on calificacion_de_sesicion.id_calificacion = estudiante.id_estudiante
					 group by  estudiante.nombre_estudiante, estudiante.apellido_estudiante, provincia.nombre_provincia,
				     calificacion_de_sesicion.nota_session;
							  
BEGIN
OPEN CUR_ALUMNO;
FETCH CUR_ALUMNO INTO PERIODO;
WHILE(FOUND)LOOP
RAISE NOTICE 'nombre_estudiante: %, apellido_estudiantea: %, nombre_provincia: %, nota_session: %',
	PERIODO.Nombre_Estudiante,
	PERIODO.Apellido_Estudiante,
	PERIODO.Nombre_Provincia,
	PERIODO.Nota_Session;	
FETCH CUR_ALUMNO INTO PERIODO;
END LOOP;
END $$
LANGUAGE PLPGSQL;
