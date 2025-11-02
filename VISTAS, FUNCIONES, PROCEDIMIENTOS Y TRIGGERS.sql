CREATE OR REPLACE VIEW vw_clienteprestamo AS
SELECT c.id_cliente, c.nombre_cliente, c.direccion, pr.id_libro, pr.fecha_prestamo, pr.fecha_devolucion FROM clientes AS c
JOIN prestamos AS pr ON c.id_cliente = pr.id_cliente
WHERE pr.fecha_prestamo >= "2025-08-01" AND pr.fecha_devolucion <= "2025-08-30";

CREATE OR REPLACE VIEW vw_clientesypedidosentregados AS
SELECT c.id_cliente, c.nombre_cliente, c.direccion, p.id_libro, p.fecha_pedido, p.estado_de_pedido FROM clientes AS c
JOIN pedidos AS p ON c.id_cliente = p.id_cliente
WHERE p.estado_de_pedido = "ENTREGADO";



DELIMITER //

CREATE FUNCTION f_editorial_local(p_id_editorial INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE v_pais VARCHAR(50);
    DECLARE resultado VARCHAR(50);

    SELECT pais INTO v_pais
    FROM editoriales
    WHERE id_editorial = p_id_editorial;

    IF LOWER(TRIM(v_pais)) = 'argentina' THEN
        SET resultado = 'Editorial local';
    ELSE
        SET resultado = 'No es editorial local';
    END IF;

    RETURN resultado;
END //

DELIMITER ;


SELECT id_editorial, f_editorial_local(id_editorial) FROM editoriales;


DROP FUNCTION f_suma_ventas_entregadas;

DELIMITER //

CREATE FUNCTION f_suma_ventas_entregadas()
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE total_ventas FLOAT;

    SELECT IFNULL(SUM(total), 0)
    INTO total_ventas
    FROM pedidos 
    WHERE estado_de_pedido = 'ENTREGADO';

    RETURN total_ventas;
END //

DELIMITER ;

SELECT f_suma_ventas_entregadas();



DELIMITER //

CREATE PROCEDURE p_crear_cliente(
  IN p_nombre_cliente VARCHAR(50),
  IN p_direccion VARCHAR(50),
  IN p_correo VARCHAR(100),
  IN p_autor_favorito VARCHAR(50)
)
BEGIN
  INSERT INTO clientes(nombre_cliente, direccion, correo, autor_favorito)
  VALUES(p_nombre_cliente, p_direccion, p_correo, p_autor_favorito);
END //

DELIMITER ;

CALL p_crear_cliente(
  'Gabriel Romero',
  'Libertad 784',
  'soyelmascapo@gmail.com',
  'Isabel Allende'
);






DELIMITER //

CREATE PROCEDURE p_cambiar_estado_pedido(
  IN p_id_pedido INT,
  IN p_nuevo_estado VARCHAR(50),
  OUT p_mensaje VARCHAR(100)
)
BEGIN
  IF EXISTS (SELECT 1 FROM pedidos WHERE id_pedido = p_id_pedido) THEN
    UPDATE pedidos
    SET estado_de_pedido = p_nuevo_estado
    WHERE id_pedido = p_id_pedido;

    SET p_mensaje = CONCAT('El estado del pedido ', p_id_pedido, ' se actualizó a "', p_nuevo_estado, '"');
  ELSE
    SET p_mensaje = CONCAT('El pedido ', p_id_pedido, ' no existe.');
  END IF;
END //

DELIMITER ;






ALTER TABLE clientes
ADD COLUMN fecha_creacion DATETIME NULL;

DELIMITER //

CREATE TRIGGER tr_creacion_cliente_fecha
BEFORE INSERT ON clientes
FOR EACH ROW
BEGIN
  SET NEW.fecha_creacion = CURRENT_DATE();
END //

DELIMITER ;








ALTER TABLE promociones
ADD COLUMN estado VARCHAR(20) DEFAULT 'NO ACTIVA';

DELIMITER //

CREATE TRIGGER tr_promocion_estado_insert
BEFORE INSERT ON promociones
FOR EACH ROW
BEGIN
    IF CURDATE() BETWEEN NEW.fecha_inicio AND NEW.fecha_final THEN
        SET NEW.estado = 'ACTIVA';
    ELSE
        SET NEW.estado = 'NO ACTIVA';
    END IF;
END$$

DELIMITER ;

DELIMITER //

CREATE TRIGGER tr_promocion_estado_update
BEFORE UPDATE ON promociones
FOR EACH ROW
BEGIN
    IF CURDATE() BETWEEN NEW.fecha_inicio AND NEW.fecha_final THEN
        SET NEW.estado = 'ACTIVA';
    ELSE
        SET NEW.estado = 'NO ACTIVA';
    END IF;
END$$

DELIMITER ;

INSERT INTO promociones(nombre_promocion, descuento, fecha_inicio, fecha_final)
VALUES ('Black Friday', 20, '2025-11-01', '2025-11-10');










