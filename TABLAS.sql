CREATE SCHEMA gestionLibreria;

USE gestionLibreria;

CREATE TABLE libros(
id_libro INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
titulo VARCHAR(50) NOT NULL,
genero VARCHAR(50) NOT NULL,
precio FLOAT,
fecha_publicacion DATE NOT NULL);

CREATE TABLE autores(
id_autor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_libro INT NOT NULL,
nombre_autor VARCHAR(50) NOT NULL);

CREATE TABLE editoriales(
id_editorial INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_libro INT NOT NULL,
nombre_editorial VARCHAR(50) NOT NULL,
pais VARCHAR(50) NOT NULL);

CREATE TABLE clientes(
id_cliente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre_cliente VARCHAR(50) NOT NULL,
direccion VARCHAR(50) NOT NULL,
correo VARCHAR(100) NOT NULL,
autor_favorito VARCHAR(50) NOT NULL);

CREATE TABLE prestamos(
id_prestamo INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_cliente INT NOT NULL,
id_libro INT NOT NULL,
fecha_prestamo DATE NOT NULL,
fecha_devolucion DATE);


CREATE TABLE pedidos(
id_pedido INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_cliente INT NOT NULL,
id_libro INT NOT NULL,
fecha_pedido DATE,
estado_de_pedido VARCHAR(50),
total FLOAT);

CREATE TABLE sucursales(
id_sucursal INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
direccion VARCHAR(70));

CREATE TABLE empleados(
id_empleado INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_sucursal INT NOT NULL,
nombre VARCHAR(50),
puesto VARCHAR(50));

CREATE TABLE ventas(
id_venta INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_pedido INT NOT NULL,
id_empleado INT NOT NULL,
fecha_venta DATE);

CREATE TABLE promociones(
id_promocion INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre_promocion VARCHAR(100),
descuento FLOAT,
fecha_inicio DATE,
fecha_final DATE);


ALTER TABLE autores ADD CONSTRAINT fk_autorLibro
FOREIGN KEY (id_libro) REFERENCES libros (id_libro);

ALTER TABLE editoriales ADD CONSTRAINT fk_editorialLibro
FOREIGN KEY (id_libro) REFERENCES libros (id_libro);

ALTER TABLE prestamos ADD CONSTRAINT fk_prestamoLibro
FOREIGN KEY (id_libro) REFERENCES libros (id_libro);

ALTER TABLE prestamos ADD CONSTRAINT fk_prestamoCliente
FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente);

ALTER TABLE pedidos ADD CONSTRAINT fk_pedidoCliente
FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente);

ALTER TABLE pedidos ADD CONSTRAINT fk_pedidoLibro
FOREIGN KEY (id_libro) REFERENCES libros (id_libro);

ALTER TABLE ventas ADD CONSTRAINT fk_ventaPedido
FOREIGN KEY (id_pedido) REFERENCES pedidos (id_pedido);

ALTER TABLE ventas ADD CONSTRAINT fk_ventaEmpleado
FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado);

ALTER TABLE empleados ADD CONSTRAINT fk_empleadosSucursal
FOREIGN KEY (id_sucursal) REFERENCES sucursales (id_sucursal);







