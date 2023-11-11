/*Crear un tablespace*/
create tablespace TBS_PROYECTO datafile
'C:\USERS\FABIOLA\DESKTOP\ORADATA\ORCL\proyecto1.dbf ' size 20M default storage (initial
1m next 1m pctincrease 0);

/*MODIFCAR LA SESSION*/
alter session set "_ORACLE_SCRIPT"=true;

/*Habilitar outputs*/
SET SERVEROUTPUT ON;

/*Asigno a mi usuario el tablespack creado*/
alter user adm_proyecto quota unlimited on TBS_PROYECTO;

/*creacion de users y asignarles el tablespace TBS_PROYECTO*/
create user adm_db identified by "123456" default tablespace TBS_PROYECTO;
create user adm_cliente identified by "123456" default tablespace TBS_PROYECTO;
create user adm_membresias identified by "123456" default tablespace TBS_PROYECTO;

/*create user adm_clases identified by "123456" default tablespace TBS_PROYECTO;
create user adm_instructores identified by "123456" default tablespace TBS_PROYECTO;
create user adm_reservas identified by "123456" default tablespace TBS_PROYECTO;*/

/*Creacion de rols*/
create role rol_adm_db;
create role rol_adm_cliente;
create role rol_adm_membresias;

/*create role rol_adm_clases;
create role rol_adm_instructores;
create role rol_adm_reservas;*/

/*---------------------CREAR TABLA-------------------------*/

create table CLIENTE
(
    ID_CLIENTE INT NOT NULL PRIMARY KEY,
    NOMBRE VARCHAR (50) NOT NULL,
    APELLIDO VARCHAR (50) NOT NULL,
    FECHAINGRESO DATE NOT NULL,
    MENSUALIDAD INT NOT NULL
);

create table MEMBRESIAS
(
    ID_MEMBRESIA INT NOT NULL PRIMARY KEY,
    TIPO VARCHAR (50) NOT NULL,
    ESTADO VARCHAR (50) NOT NULL,
    FECHA_INICIO DATE NOT NULL,
    FECHA_EXPIRACION DATE NOT NULL,
    ID_CLIENTE INT NOT NULL
);

/*Agregar FK de tablas*/
ALTER TABLE MEMBRESIAS
ADD CONSTRAINT MEM_CLT_FK 
FOREIGN KEY(ID_CLIENTE)
REFERENCES CLIENTE(ID_CLIENTE);

/*DAR permisos especificos a un rol*/
/*GRANT SELECT,INSERT,UPDATE,DELETE ON CLIENTE TO rol_adm_cliente;*/

/*Dar permisos a users, en este caso a adm_db*/
/*grant create session to adm_db;
grant connect to adm_db;
grant dba to adm_db;*/

/*-------------------Inserts------------------------------*/
insert into CLIENTE values(1,'Fabiola','Rodriguez','09/10/2023',1)
insert into CLIENTE values(2,'Carlos','Rodriguez','15/03/2023',2)
insert into CLIENTE values(3,'Lucia','Vargas','03/09/2023',1)

insert into MEMBRESIAS values(1,'VIP','Activo','11/11/2023','11/12/2023',1)
insert into MEMBRESIAS values(2,'STANDARD','Activo','15/10/2023','15/11/2023',2)
insert into MEMBRESIAS values(3,'VIP','Activo','03/11/2023','03/12/2023',3)

/*Ver los inserts*/
SELECT * FROM CLIENTE;
SELECT * FROM MEMBRESIAS;


/*---------SP para insertar clientes-------------------*/
CREATE OR REPLACE PROCEDURE INSERT_CLIENTE(
	   c_ID_CLIENTE IN CLIENTE.ID_CLIENTE%TYPE,
	   c_NOMBRE IN CLIENTE.NOMBRE%TYPE,
	   c_APELLIDO IN CLIENTE.APELLIDO %TYPE,
	   c_FECHA_INGRESO IN CLIENTE.FECHA_INGRESO%TYPE,
	   c_MENSUALIDAD IN CLIENTE.MENSUALIDAD%TYPE)
IS
BEGIN

  INSERT INTO CLIENTE ("ID_CLIENTE", "NOMBRE", "APELLIDO", "FECHA_INGRESO","MENSUALIDAD") 
  VALUES (c_ID_CLIENTE, c_NOMBRE, c_APELLIDO, c_FECHA_INGRESO, c_MENSUALIDAD);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('El registro de ' || c_NOMBRE || ' ha sido insertado');

END;

/*---------------correr el procedimiento---------------*/
EXEC INSERT_CLIENTE(6,'Xinias','Lopez','09/10/2023',2);

/*---------SP para modificar la mensualidad de los clientes-------------------*/
CREATE OR REPLACE PROCEDURE UPDATE_CLIENTE(
	   c_ID_CLIENTE IN CLIENTE.ID_CLIENTE%TYPE,
	   c_MENSUALIDAD IN CLIENTE.MENSUALIDAD%TYPE)
AS
BEGIN

  UPDATE CLIENTE
    SET MENSUALIDAD = c_MENSUALIDAD
    WHERE ID_CLIENTE = c_ID_CLIENTE;
    COMMIT;
  DBMS_OUTPUT.PUT_LINE('El registro del cliente con ID: ' || c_ID_CLIENTE || ' ha sido modificado');

END;

/*---------------correr el procedimiento---------------*/
EXEC UPDATE_CLIENTE(6,1);


/*---------SP para eliminar clientes-------------------*/
CREATE OR REPLACE PROCEDURE DELETE_CLIENTE(
	   c_ID_CLIENTE IN CLIENTE.ID_CLIENTE%TYPE)
AS
BEGIN

  DELETE FROM CLIENTE
    WHERE ID_CLIENTE = c_ID_CLIENTE;
  DBMS_OUTPUT.PUT_LINE('El registro del cliente con ID: ' || c_ID_CLIENTE || ' ha sido eliminado');

END;

/*---------------correr el procedimiento---------------*/
EXEC DELETE_CLIENTE(6)


/*---------SP para insertar membresias-------------------*/
CREATE OR REPLACE PROCEDURE INSERT_MEMBRESIA(
	   m_ID_MEMBRESIA IN MEMBRESIAS.ID_MEMBRESIA%TYPE,
	   m_TIPO IN MEMBRESIAS.TIPO%TYPE,
	   m_ESTADO IN MEMBRESIAS.ESTADO%TYPE,
	   m_FECHA_INICIO IN MEMBRESIAS.FECHA_INICIO%TYPE,
	   m_FECHA_EXPIRACION IN MEMBRESIAS.FECHA_EXPIRACION%TYPE,
	   m_ID_CLIENTE IN MEMBRESIAS.ID_CLIENTE%TYPE)
IS
BEGIN

  INSERT INTO MEMBRESIAS("ID_MEMBRESIA", "TIPO", "ESTADO", "FECHA_INICIO","FECHA_EXPIRACION","ID_CLIENTE") 
  VALUES (m_ID_MEMBRESIA, m_TIPO, m_ESTADO, m_FECHA_INICIO, m_FECHA_EXPIRACION, m_ID_CLIENTE);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('El registro de ' || m_ID_MEMBRESIA || ' ha sido insertado');

END;

/*---------------correr el procedimiento---------------*/
EXEC INSERT_MEMBRESIA(4,'Standard','Activo','10/11/2023','10/12/2023',4);

/*---------SP para modificar el estado de membresia segun el ID del cliente-------------------*/
CREATE OR REPLACE PROCEDURE UPDATE_MEMBRESIAS(
	   m_ID_CLIENTE IN MEMBRESIAS.ID_CLIENTE%TYPE,
	   m_ESTADO IN MEMBRESIAS.ESTADO%TYPE)
AS
BEGIN

  UPDATE MEMBRESIAS
    SET ESTADO = m_ESTADO
    WHERE ID_CLIENTE = m_ID_CLIENTE;
    COMMIT;
  DBMS_OUTPUT.PUT_LINE('EL estado de la membresia del cliente con ID: ' || m_ID_CLIENTE || ' ha sido modificado');

END;

/*---------------correr el procedimiento---------------*/
EXEC UPDATE_MEMBRESIAS(4,'Inactivo');

/*---------SP para eliminar clientes-------------------*/
CREATE OR REPLACE PROCEDURE DELETE_MEMBRESIA(
	   m_ID_MEMBRESIA IN MEMBRESIAS.ID_MEMBRESIA %TYPE)
AS
BEGIN

  DELETE FROM MEMBRESIAS
    WHERE ID_MEMBRESIA = m_ID_MEMBRESIA;
  DBMS_OUTPUT.PUT_LINE('El registro de la membresia con ID: ' || m_ID_MEMBRESIA || ' ha sido eliminada');

END;

/*---------------correr el procedimiento---------------*/
EXEC DELETE_MEMBRESIA(4)


C:\Users\Fabiola\AppData\Roaming\SQL Developer\mywork