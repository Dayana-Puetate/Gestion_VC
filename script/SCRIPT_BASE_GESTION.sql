CREATE DATABASE BASE_GESTION;
USE BASE_GESTION;

Select * From Clientes;
Select * From Ventas;

CREATE TABLE CLIENTES
(id_cliente INT PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
email VARCHAR(20) NOT NULL,
telefono VARCHAR(20) NOT NULL,
direccion VARCHAR(20) NOT NULL);

CREATE TABLE VENDEDORES
(id_vendedor INT PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
apellido VARCHAR(20) NOT NULL,
email VARCHAR(20) NOT NULL,
direccion VARCHAR(20) NOT NULL);

CREATE TABLE ZONAS
(id_zona INT PRIMARY KEY,
nombre_zona VARCHAR(20) NOT NULL,
descripcion VARCHAR(20));

CREATE TABLE PRODUCTOS
(id_producto INT PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
descripcion VARCHAR(20) NOT NULL,
precio DECIMAL(10,2) NOT NULL,
stock INT NOT NULL,
categoria VARCHAR(20));

CREATE TABLE VENTAS
(id_venta INT PRIMARY KEY,
id_cliente INT FOREIGN KEY REFERENCES CLIENTES(id_cliente),
id_vendedor INT FOREIGN KEY REFERENCES VENDEDORES(id_vendedor),
id_zona INT FOREIGN KEY REFERENCES ZONAS(id_zona),
fecha DATETIME NOT NULL,
monto_total DECIMAL(10,2) NOT NULL);

CREATE TABLE DETALLE_VENTAS
(id_detalle_venta INT PRIMARY KEY,
id_venta INT FOREIGN KEY REFERENCES VENTAS(id_venta),
id_producto INT FOREIGN KEY REFERENCES PRODUCTOS(id_producto),
cantidad INT NOT NULL,
precio_unitario DECIMAL(10,2) NOT NULL,
subtotal DECIMAL(10,2) NOT NULL);


INSERT INTO CLIENTES (id_cliente, nombre, email, telefono, direccion)
VALUES 
(1, 'Juan', 'juan@example.com', '123456789', 'Calle Principal 123'),
(2, 'María', 'maria@example.com', '987654321', 'Avenida Central 456'),
(3, 'Pedro', 'pedro@example.com', '555444333', 'Plaza Mayor 789');
