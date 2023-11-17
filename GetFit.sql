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

create table EMPLEADO(
    ID_EMPLEADO INT NOT NULL PRIMARY KEY,
    NOMBRE VARCHAR (20) NOT NULL,
    APELLIDO VARCHAR (25) NOT NULL,
    FECHA_INICIO DATE NOT NULL,
    ESTADO VARCHAR(45) NOT NULL,
    SALARIO NUMBER NOT NULL,
    EMAIL VARCHAR(50) NOT NULL,
    TELEFONO NUMBER NOT NULL,
    PUESTO VARCHAR(50) NOT NULL);

create table RESERVAS(
    ID_RESERVA INT NOT NULL PRIMARY KEY,
    FECHA DATE NOT NULL,
    HORA TIMESTAMP NOT NULL,
    ESTADO VARCHAR(45) NOT NULL,
    ID_CLIENTE INT NOT NULL);

create table HORARIO(
    ID_HORARIO INT NOT NULL PRIMARY KEY,
    DIA VARCHAR (20) NOT NULL,
    HORA_INICIO TIMESTAMP  NOT NULL,
    HORA_FIN TIMESTAMP  NOT NULL,
    CLASE VARCHAR(100) NOT NULL);
    
create table FACTURA(
    ID_FACTURA INT NOT NULL PRIMARY KEY,
    ID_CLIENTE INT NOT NULL,
    MONTO INT NOT NULL,
    FECHA DATE NOT NULL,
    DESCRIPCION VARCHAR (100) NOT NULL);
    
    
/*Agregar FK de tablas*/
ALTER TABLE MEMBRESIAS
ADD CONSTRAINT MEM_CLT_FK 
FOREIGN KEY(ID_CLIENTE)
REFERENCES CLIENTE(ID_CLIENTE);

ALTER TABLE RESERVAS
ADD CONSTRAINT RES_CLT_FK 
FOREIGN KEY(ID_CLIENTE)
REFERENCES CLIENTE(ID_CLIENTE);

ALTER TABLE FACTURA
ADD CONSTRAINT FACT_CLT_FK 
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

INSERT INTO RESERVAS (ID_RESERVA, FECHA, HORA, ESTADO, ID_CLIENTE)
VALUES (1, TO_DATE('2023-10-30', 'YYYY-MM-DD'), TO_TIMESTAMP('14:00', 'HH24:MI:SS'), 'Confirmada', 2),
    (2, TO_DATE('2023-11-05', 'YYYY-MM-DD'), TO_TIMESTAMP('09:30', 'HH24:MI:SS'), 'Pendiente', 1),
    (3, TO_DATE('2023-11-10', 'YYYY-MM-DD'), TO_TIMESTAMP('18:00', 'HH24:MI:SS'), 'Confirmada', 3);
    
INSERT INTO HORARIO (ID_HORARIO, DIA, HORA_INICIO, HORA_FIN, CLASE)
VALUES
    (1, 'Lunes', TO_DATE('08:30', 'HH24:MI:SS'), TO_TIMESTAMP('10:00', 'HH24:MI:SS'), 'Clase de Yoga'),
    (2, 'Martes', TO_DATE('14:00', 'HH24:MI:SS'), TO_TIMESTAMP('15:30', 'HH24:MI:SS'), 'Entrenamiento Funcional'),
    (3, 'Miercoles', TO_DATE('18:30', 'HH24:MI:SS'), TO_TIMESTAMP('20:00', 'HH24:MI:SS'), 'Spinning');

-- Insertar datos de ejemplo en la tabla FACTURA
INSERT INTO FACTURA (ID_FACTURA, ID_CLIENTE, MONTO, FECHA, DESCRIPCION)
VALUES
    (1, 1, 50000, TO_DATE('2023-10-30', 'YYYY-MM-DD'), 'Pago de membresia'),
    (2, 2, 30000, TO_DATE('2023-11-05', 'YYYY-MM-DD'), 'Pago de clases de yoga'),
    (3, 3, 75000, TO_DATE('2023-11-10', 'YYYY-MM-DD'), 'Pago de entrenamiento personal');

/*Ver los inserts*/
SELECT * FROM CLIENTE;
SELECT * FROM MEMBRESIAS;
SELECT * FROM EMPLEADO;
SELECT * FROM RESERVAS;
SELECT * FROM HORARIO;
SELECT * FROM FACTURA;


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

-- Funciones para la tabla EMPLEADO --
CREATE OR REPLACE FUNCTION GET_ALL_EMPLEADOS
RETURN SYS_REFCURSOR
IS
    emp_cursor SYS_REFCURSOR;
BEGIN
    OPEN emp_cursor FOR
        SELECT * FROM EMPLEADO;
    RETURN emp_cursor;
END;

CREATE OR REPLACE FUNCTION GET_EMPLEADOS_BY_SALARIO(
    E_SALARIO IN EMPLEADO.SALARIO%TYPE)
RETURN SYS_REFCURSOR
IS
    emp_cursor SYS_REFCURSOR;
BEGIN
    OPEN emp_cursor FOR
        SELECT * FROM EMPLEADO WHERE SALARIO = E_SALARIO;
    RETURN emp_cursor;
END;

DECLARE
    emp_cursor SYS_REFCURSOR;
BEGIN
    -- Llamar a la funciÃ³n para obtener todos los empleados
    emp_cursor := GET_ALL_EMPLEADOS;

    -- Iterar a travÃ©s del cursor y hacer algo con los resultados
    FOR emp_rec IN emp_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID_EMPLEADO: ' || emp_rec.ID_EMPLEADO || ', NOMBRE: ' || emp_rec.NOMBRE);
    END LOOP;

    -- Llamar a la funcion para obtener empleados por salario
    emp_cursor := GET_EMPLEADOS_BY_SALARIO(50000);

    -- Usar a travÃ©s del cursor y hacer algo con los resultados
    FOR emp_rec IN emp_cursor
    LOOP
        DBMS_OUTPUT.PUT_LINE('ID_EMPLEADO: ' || emp_rec.ID_EMPLEADO || ', NOMBRE: ' || emp_rec.NOMBRE);
    END LOOP;
END;
/


C:\Users\Fabiola\AppData\Roaming\SQL Developer\mywork

-- Cursor para la tabla FACTURA donde el monto es de 50000
    CURSOR c_factura IS
        SELECT 1 AS ID_FACTURA, 1 AS ID_CLIENTE, 50000 AS MONTO, TO_DATE('2023-10-30', 'YYYY-MM-DD') AS FECHA,
        'Pago de membresÃ­a' AS DESCRIPCION FROM DUAL;

   -- Cursor para la tabla RESERVAS confirmada
    CURSOR c_reservas IS
        SELECT 1 AS ID_RESERVA, TO_DATE('2023-10-30', 'YYYY-MM-DD') AS FECHA, TO_DATE('14:00', 'HH24:MI') AS HORA,
        'Confirmada' AS ESTADO, 2 AS ID_CLIENTE FROM DUAL;
    
    -- Cursor para la tabla HORARIO
    CURSOR c_horario IS
        SELECT 1 AS ID_HORARIO, 'Lunes' AS DIA, TO_DATE('08:30', 'HH24:MI') AS HORA_INICIO, TO_DATE('10:00', 'HH24:MI') AS HORA_FIN,
        'Clase de Yoga' AS CLASE FROM DUAL;

   -- Cursor para la tabla EMPLEADO
   CURSOR c_empleado IS
	SELECT * FROM EMPLEADO;
    
BEGIN
    -- Insertar datos en la tabla RESERVAS
    FOR reserva IN c_reservas
    LOOP
        INSERT INTO RESERVAS (ID_RESERVA, FECHA, HORA, ESTADO, ID_CLIENTE)
        VALUES (reserva.ID_RESERVA, reserva.FECHA, reserva.HORA, reserva.ESTADO, reserva.ID_CLIENTE);
    END LOOP;

    COMMIT; -- Confirmar la transacciÃ³n
END;

BEGIN
-- Insertar datos en la tabla HORARIO
    FOR horario IN c_horario
    LOOP
        INSERT INTO HORARIO (ID_HORARIO, DIA, HORA_INICIO, HORA_FIN, CLASE)
        VALUES (horario.ID_HORARIO, horario.DIA, horario.HORA_INICIO, horario.HORA_FIN, horario.CLASE);
    END LOOP;
END;

BEGIN
    -- Insertar datos en la tabla FACTURA
    FOR factura IN c_factura
    LOOP
        INSERT INTO FACTURA (ID_FACTURA, ID_CLIENTE, MONTO, FECHA, DESCRIPCION)
        VALUES (factura.ID_FACTURA, factura.ID_CLIENTE, factura.MONTO, factura.FECHA, factura.DESCRIPCION);
    END LOOP;
END;

-- Crear una vista que incluya la informaciÃ³n de la tabla CLIENTE
CREATE VIEW Vista_Cliente AS
SELECT
    ID_CLIENTE,
    NOMBRE,
    APELLIDO,
    FECHAINGRESO,
    MENSUALIDAD
FROM CLIENTE;

-- Consulta utilizando la vista
SELECT * FROM Vista_Cliente;
-- Crear una vista que incluya la informaciÃ³n de la tabla MEMBRESIAS
CREATE VIEW Vista_Membresias AS
SELECT
    ID_MEMBRESIA,
    TIPO,
    ESTADO,
    FECHA_INICIO,
    FECHA_EXPIRACION,
    ID_CLIENTE
FROM MEMBRESIAS;

-- Consulta utilizando la vista
SELECT * FROM Vista_Membresias;

-- Crear una vista que incluya la informaciÃ³n de la tabla EMPLEADO
CREATE VIEW Vista_Empleado AS
SELECT
    ID_EMPLEADO,
    NOMBRE,
    APELLIDO,
    FECHA_INICIO,
    ESTADO,
    SALARIO,
    EMAIL,
    TELEFONO,
    PUESTO
FROM EMPLEADO;


-- Consulta utilizando la vista
SELECT * FROM Vista_Empleado;

-- Crear una vista que incluya la información de la tabla RESERVAS
CREATE VIEW Vista_Reservas AS
SELECT
    ID_RESERVA,
    FECHA,
    HORA,
    ESTADO,
    ID_CLIENTE
FROM RESERVAS;

-- Consulta utilizando la vista
SELECT * FROM Vista_Reservas;

-- Crear una vista que incluya la informacion de la tabla FACTURA
CREATE VIEW Vista_Factura AS
SELECT
    ID_FACTURA,
    ID_CLIENTE,
    MONTO,
    FECHA,
    DESCRIPCION
FROM FACTURA;

-- Consulta utilizando la vista
SELECT * FROM Vista_Factura;

/*---------SP para modificar el estado de la reserva de los clientes-------------------*/
CREATE OR REPLACE PROCEDURE UPDATE_RESERVA(
	   r_ID_RESERVA IN RESERVAS.ID_RESERVA%TYPE,
	   r_ESTADO IN RESERVAS.ESTADO%TYPE)
AS
BEGIN

  UPDATE RESERVAS
    SET ESTADO = r_ESTADO
    WHERE ID_RESERVA = r_ID_RESERVA;
    COMMIT;
  DBMS_OUTPUT.PUT_LINE('El registro del estado con ID: ' || r_ID_RESERVA || ' ha sido modificado');

END;

/*---------------correr el procedimiento---------------*/
EXEC UPDATE_RESERVA(1,'Pendiente');

/*---------SP para modificar la clase segun el horario-------------------*/
CREATE OR REPLACE PROCEDURE UPDATE_HORARIO(
	   h_ID_HORARIO IN HORARIO.ID_HORARIO%TYPE,
	   h_CLASE IN HORARIO.CLASE%TYPE)
AS
BEGIN

  UPDATE HORARIO
    SET CLASE = h_CLASE
    WHERE ID_HORARIO = r_ID_HORARIO;
    COMMIT;
  DBMS_OUTPUT.PUT_LINE('La clase con el horario ID de: ' || h_ID_HORARIO || ' ha sido modificado');

END;

/*---------------correr el procedimiento---------------*/
EXEC UPDATE_HORARIO(1,2);


/*---------SP para modificar la clase segun el horario-------------------*/
CREATE OR REPLACE PROCEDURE UPDATE_FACTURA(
	   f_ID_FACTURA IN FACTURA.ID_FACTURA%TYPE,
	   f_ID_CLIENTE IN FACTURA.ID_CLIENTE%TYPE)
AS
BEGIN

  UPDATE FACTURA
    SET ID_CLIENTE = f_ID_CLIENTE
    WHERE ID_FACTURA = f_ID_FACTURA;
    COMMIT;
  DBMS_OUTPUT.PUT_LINE('La factura con el ID: ' || f_ID_FACTURA || ' ha sido modificado');

END;

/*---------------correr el procedimiento---------------*/
EXEC UPDATE_FACTURA(1,'Cardio');

/*---------SP para eliminar reservas-------------------*/
CREATE OR REPLACE PROCEDURE DELETE_RESERVAS(
	   r_ID_RESERVA IN RESERVAS.ID_RESERVA %TYPE)
AS
BEGIN

  DELETE FROM RESERVAS
    WHERE ID_RESERVA = r_ID_RESERVA;
  DBMS_OUTPUT.PUT_LINE('La reserva con ID: ' || r_ID_RESERVA || ' ha sido eliminada');

END;

/*---------------correr el procedimiento---------------*/
EXEC DELETE_RESERVAS(3);

/*---------SP para eliminar horarios-------------------*/
CREATE OR REPLACE PROCEDURE DELETE_HORARIO(
	   h_ID_HORARIO IN HORARIO.ID_HORARIO%TYPE)
AS
BEGIN

  DELETE FROM HORARIO
    WHERE ID_HORARIO = h_ID_HORARIO;
  DBMS_OUTPUT.PUT_LINE('El horario con ID: ' || h_ID_HORARIO || ' ha sido eliminado');

END;

/*---------------correr el procedimiento---------------*/
EXEC DELETE_HORARIO(3);

/*---------SP para eliminar horarios-------------------*/
CREATE OR REPLACE PROCEDURE DELETE_FACTURA(
	   f_ID_FACTURA IN FACTURA.ID_FACTURA%TYPE)
AS
BEGIN

  DELETE FROM FACTURA
    WHERE ID_FACTURA = f_ID_FACTURA;
  DBMS_OUTPUT.PUT_LINE('La factura con ID: ' || f_ID_FACTURA || ' ha sido eliminada');

END;

/*---------------correr el procedimiento---------------*/
EXEC DELETE_FACTURA(3);

--RESTO DEL CRUD DE EMPLEADO
-- Leer todos los empleados
SELECT * FROM EMPLEADO;

-- Leer un empleado específico por ID
SELECT * FROM EMPLEADO WHERE ID_EMPLEADO = 1;

-- Actualizar información de un empleado
UPDATE EMPLEADO
SET SALARIO = 55000, ESTADO = 'Inactivo'
WHERE ID_EMPLEADO = 1;

-- Eliminar un empleado por ID
DELETE FROM EMPLEADO WHERE ID_EMPLEADO = 1;

--Eliminar empleado inactivo con SP
CREATE OR REPLACE PROCEDURE EliminarEmpleadoInactivo AS
BEGIN
    -- Eliminar empleados inactivos
    DELETE FROM EMPLEADO WHERE ESTADO = 'Inactivo';
    
    -- Confirmar la transacción
    COMMIT;
    
    -- Mostrar mensaje de éxito
    DBMS_OUTPUT.PUT_LINE('Empleados inactivos eliminados correctamente.');
END EliminarEmpleadoInactivo;

BEGIN
    EliminarEmpleadoInactivo;
END;

--FUNCION DE FACTURA DE SU FECHA DE INICIO HASTA HOY
SELECT MONTHS_BETWEEN(FECHA_INICIO, SYSDATE) FROM EMPLEADO;

--Funcion del numero total de reservas por el estado que se tiene
SELECT ESTADO, COUNT(*) AS CANTIDAD
FROM RESERVAS
GROUP BY ESTADO;

--Funcion del promedio de montos de factura por cada cliente
SELECT ID_CLIENTE, AVG(MONTO) AS PROMEDIO_MONTO
FROM FACTURA
GROUP BY ID_CLIENTE;

--Funcion para ver todos los clientes--
CREATE OR REPLACE FUNCTION GET_ALL_CLIENTES
RETURN SYS_REFCURSOR
IS
    cliente_cursor SYS_REFCURSOR;
BEGIN
    OPEN cliente_cursor FOR
        SELECT * FROM CLIENTE;
    RETURN cliente_cursor;
END;

--Funcion para obtener todos los empleados--
CREATE OR REPLACE FUNCTION GET_ALL_EMPLEADOS
RETURN SYS_REFCURSOR
IS
    empleado_cursor SYS_REFCURSOR;
BEGIN
    OPEN empleado_cursor FOR
        SELECT * FROM EMPLEADO;
    RETURN empleado_cursor;
END;


--Funcion para obtener todas las reservas--
CREATE OR REPLACE FUNCTION GET_ALL_RESERVAS
RETURN SYS_REFCURSOR
IS
    reservas_cursor SYS_REFCURSOR;
BEGIN
    OPEN reservas_cursor FOR
        SELECT * FROM RESERVAS;
    RETURN reservas_cursor;
END;


--Funcion para obtener todas las facturas--
CREATE OR REPLACE FUNCTION GET_ALL_FACTURAS
RETURN SYS_REFCURSOR
IS
    factura_cursor SYS_REFCURSOR;
BEGIN
    OPEN factura_cursor FOR
        SELECT * FROM FACTURA;
    RETURN factura_cursor;
END;

	
--CRUD de Horarios
CREATE OR REPLACE PROCEDURE INSERT_HORARIO(
    h_ID_HORARIO IN HORARIO.ID_HORARIO%TYPE,
    h_DIA IN HORARIO.DIA%TYPE,
    h_HORA_INICIO IN HORARIO.HORA_INICIO%TYPE,
    h_HORA_FIN IN HORARIO.HORA_FIN%TYPE,
    h_CLASE IN HORARIO.CLASE%TYPE)
AS
BEGIN
    INSERT INTO HORARIO (ID_HORARIO, DIA, HORA_INICIO, HORA_FIN, CLASE)
    VALUES (h_ID_HORARIO, h_DIA, h_HORA_INICIO, h_HORA_FIN, h_CLASE);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El horario con ID: ' || h_ID_HORARIO || ' ha sido insertado.');
END;

--Actualizar horarios--
CREATE OR REPLACE PROCEDURE UPDATE_HORARIO(
    h_ID_HORARIO IN HORARIO.ID_HORARIO%TYPE,
    h_CLASE IN HORARIO.CLASE%TYPE)
AS
BEGIN
    UPDATE HORARIO
    SET CLASE = h_CLASE
    WHERE ID_HORARIO = h_ID_HORARIO;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('La clase con el horario ID de: ' || h_ID_HORARIO || ' ha sido modificada.');
END;

--Eliminar horarios--
CREATE OR REPLACE PROCEDURE DELETE_HORARIO(
    h_ID_HORARIO IN HORARIO.ID_HORARIO%TYPE)
AS
BEGIN
    DELETE FROM HORARIO
    WHERE ID_HORARIO = h_ID_HORARIO;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El horario con ID: ' || h_ID_HORARIO || ' ha sido eliminado.');
END;

--Consulta horario--
CREATE OR REPLACE FUNCTION GET_ALL_HORARIOS
RETURN SYS_REFCURSOR
IS
    horario_cursor SYS_REFCURSOR;
BEGIN
    OPEN horario_cursor FOR
        SELECT * FROM HORARIO;
    RETURN horario_cursor;
END;


--CRUD para facturas--
CREATE OR REPLACE PROCEDURE INSERT_FACTURA(
    f_ID_FACTURA IN FACTURA.ID_FACTURA%TYPE,
    f_ID_CLIENTE IN FACTURA.ID_CLIENTE%TYPE,
    f_MONTO IN FACTURA.MONTO%TYPE,
    f_FECHA IN FACTURA.FECHA%TYPE,
    f_DESCRIPCION IN FACTURA.DESCRIPCION%TYPE)
AS
BEGIN
    INSERT INTO FACTURA(ID_FACTURA, ID_CLIENTE, MONTO, FECHA, DESCRIPCION)
    VALUES (f_ID_FACTURA, f_ID_CLIENTE, f_MONTO, f_FECHA, f_DESCRIPCION);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El registro de factura con ID: ' || f_ID_FACTURA || ' ha sido insertado.');
END;

--Actualizar cliente de factura--
CREATE OR REPLACE PROCEDURE UPDATE_FACTURA(
    f_ID_FACTURA IN FACTURA.ID_FACTURA%TYPE,
    f_ID_CLIENTE IN FACTURA.ID_CLIENTE%TYPE)
AS
BEGIN
    UPDATE FACTURA
    SET ID_CLIENTE = f_ID_CLIENTE
    WHERE ID_FACTURA = f_ID_FACTURA;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El cliente de la factura con ID: ' || f_ID_FACTURA || ' ha sido modificado.');
END;

--Eliminar factura--
CREATE OR REPLACE PROCEDURE DELETE_FACTURA(
    f_ID_FACTURA IN FACTURA.ID_FACTURA%TYPE)
AS
BEGIN
    DELETE FROM FACTURA
    WHERE ID_FACTURA = f_ID_FACTURA;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('El registro de factura con ID: ' || f_ID_FACTURA || ' ha sido eliminado.');
END;

--Consulta de facturas--
CREATE OR REPLACE FUNCTION GET_ALL_FACTURAS
RETURN SYS_REFCURSOR
IS
    factura_cursor SYS_REFCURSOR;
BEGIN
    OPEN factura_cursor FOR
        SELECT * FROM FACTURA;
    RETURN factura_cursor;
END;

