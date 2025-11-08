drop database if exists db_opel;
create database db_opel;
use db_opel;

CREATE TABLE tbl_categoria (
    id BIGINT NOT NULL AUTO_INCREMENT,
    codigo VARCHAR(255),
    descripcion VARCHAR(255),
    nombre VARCHAR(255),
    PRIMARY KEY (id),
    UNIQUE KEY UK_tbl_categoria_codigo (codigo),
    UNIQUE KEY UK_tbl_categoria_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE tbl_producto (
    id BIGINT NOT NULL AUTO_INCREMENT,
    codigo_base VARCHAR(255),
    descripcion VARCHAR(255),
    fecha_actualizacion DATETIME(6),
    fecha_creacion DATETIME(6),
    nombre VARCHAR(255),
    categoria_id BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY UK_tbl_producto_codigo_base (codigo_base),
    CONSTRAINT FK_tbl_producto_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES tbl_categoria (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE tbl_sku_producto (
    id BIGINT NOT NULL AUTO_INCREMENT,
    codigo_barra VARCHAR(255),
    codigo_sku VARCHAR(255),
    color VARCHAR(255),
    corte VARCHAR(255),
    dimensiones VARCHAR(255),
    estado_sku_producto ENUM('ACTIVO', 'INACTIVO'),
    peso VARCHAR(255),
    talla VARCHAR(255),
    producto_id BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY UK_tbl_sku_producto_codigo_barra (codigo_barra),
    UNIQUE KEY UK_tbl_sku_producto_codigo_sku (codigo_sku),
    CONSTRAINT FK_tbl_sku_producto_producto
        FOREIGN KEY (producto_id)
        REFERENCES tbl_producto (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE tbl_stock (
    id BIGINT NOT NULL AUTO_INCREMENT,
    cantidad INT NOT NULL,
    estado VARCHAR(50) NOT NULL,
    fecha_actualizacion DATETIME(6),
    fecha_creacion DATETIME(6),
    sku_id BIGINT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY UK_stock_sku_id (sku_id),
    CONSTRAINT FK_stock_sku_producto
        FOREIGN KEY (sku_id)
        REFERENCES tbl_sku_producto (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE tbl_orden_confeccion (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(50) NOT NULL DEFAULT 'PENDIENTE',
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    fecha_entrega_estimada DATE NULL,
    observacion TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tbl_orden_confeccion_detalle (
    orden_confeccion_id BIGINT NOT NULL,
    sku_id BIGINT NOT NULL,
    cantidad_pedida INT NOT NULL,
    cantidad_entregada INT NOT NULL DEFAULT 0,
    
    PRIMARY KEY (orden_confeccion_id, sku_id),
    
	CONSTRAINT fk_sku_producto
		FOREIGN KEY (sku_id)
		REFERENCES tbl_sku_producto(id)
		ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_orden_confeccion_detalle_orden
        FOREIGN KEY (orden_confeccion_id)
        REFERENCES tbl_orden_confeccion(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO tbl_categoria (codigo, nombre, descripcion) VALUES
('CAT-001', 'Pantalones Jean', 'Pantalones jean producidos en Gamarra con diferentes cortes y tallas'),
('CAT-002', 'Polos Basicos', 'Polos de algodon en colores neutros y variados, ideales para uso diario'),
('CAT-003', 'Casacas de Invierno', 'Casacas acolchadas y cortavientos para clima frio, disponibles en varias tallas'),
('CAT-004', 'Camisas Formales', 'Camisas para oficina y eventos formales, en telas de alta calidad'),
('CAT-005', 'Ropa Deportiva', 'Conjunto de prendas deportivas para entrenamiento y uso casual'),
('CAT-006', 'Vestidos de Verano', 'Vestidos frescos y coloridos para temporada de verano'),
('CAT-007', 'Ropa Infantil', 'Ropa comoda y resistente para ninos y ninas de todas las edades'),
('CAT-008', 'Ropa Interior', 'Conjunto de ropa interior para damas y caballeros, en algodon y microfibra'),
('CAT-009', 'Ropa de Bano', 'Bikinis, trajes de bano y short playeros para toda la familia'),
('CAT-010', 'Accesorios de Moda', 'Cinturones, gorras, bufandas y otros accesorios para complementar tu look');

INSERT INTO tbl_producto (codigo_base, nombre, descripcion, fecha_creacion, fecha_actualizacion, categoria_id) VALUES
('PROD-001', 'Jean Slim Fit', 'Jean de corte ajustado, ideal para uso casual', NOW(), NOW(), 1),
('PROD-002', 'Jean Clasico', 'Jean tradicional con corte recto y tela gruesa', NOW(), NOW(), 1),
('PROD-003', 'Jean Rasgado Urbano', 'Jean con diseño rasgado y detalles modernos', NOW(), NOW(), 1),
('PROD-004', 'Jean Cargo', 'Jean con bolsillos laterales, estilo streetwear', NOW(), NOW(), 1),
('PROD-005', 'Jean Oversize', 'Jean de corte amplio y comodo, tendencia actual', NOW(), NOW(), 1);

INSERT INTO tbl_sku_producto (codigo_barra, codigo_sku, color, talla, corte, dimensiones, peso, estado_sku_producto, producto_id) VALUES
('100000000001', 'SKU-001', 'Azul Oscuro', '30', 'Slim', '100x40x3', '0.85kg', 'ACTIVO', 1),
('100000000002', 'SKU-002', 'Celeste', '32', 'Slim', '102x41x3', '0.87kg', 'ACTIVO', 1),
('100000000003', 'SKU-003', 'Negro', '34', 'Slim', '104x42x3', '0.89kg', 'INACTIVO', 1),

('200000000001', 'SKU-004', 'Azul Medio', '30', 'Clasico', '101x41x3', '0.9kg', 'ACTIVO', 2),
('200000000002', 'SKU-005', 'Azul Oscuro', '32', 'Clasico', '103x42x3', '0.91kg', 'ACTIVO', 2),

('300000000001', 'SKU-006', 'Celeste', '28', 'Rasgado', '99x39x3', '0.82kg', 'ACTIVO', 3),
('300000000002', 'SKU-007', 'Azul', '30', 'Rasgado', '101x40x3', '0.83kg', 'INACTIVO', 3),

('400000000001', 'SKU-008', 'Verde Militar', '32', 'Cargo', '105x43x3', '0.95kg', 'ACTIVO', 4),
('400000000002', 'SKU-009', 'Negro', '34', 'Cargo', '107x44x3', '0.97kg', 'ACTIVO', 4),

('500000000001', 'SKU-010', 'Denim Claro', '30', 'Oversize', '108x45x3', '0.93kg', 'ACTIVO', 5),
('500000000002', 'SKU-011', 'Azul Oscuro', '32', 'Oversize', '110x46x3', '0.96kg', 'ACTIVO', 5);

INSERT INTO tbl_stock (cantidad, estado, fecha_actualizacion, fecha_creacion, sku_id) VALUES
(150, 'ACTIVO', NOW(), NOW(), 1),
(0, 'INACTIVO', NOW(), NOW(), 2),
(35, 'ACTIVO', NOW(), NOW(), 3),
(10, 'ACTIVO', NOW(), NOW(), 4),
(250, 'ACTIVO', NOW(), NOW(), 5),
(5, 'INACTIVO', NOW(), NOW(), 6),
(80, 'ACTIVO', NOW(), NOW(), 7),
(120, 'ACTIVO', NOW(), NOW(), 8),
(0, 'INACTIVO', NOW(), NOW(), 9),
(60, 'ACTIVO', NOW(), NOW(), 10);

INSERT INTO tbl_orden_confeccion (estado, fecha_creacion, fecha_actualizacion, fecha_entrega_estimada, observacion) VALUES
('PENDIENTE', NOW(), NOW(), DATE_ADD(CURDATE(), INTERVAL 5 DAY), 'Pedido inicial de temporada verano'),
('EN_PROCESO', NOW(), NOW(), DATE_ADD(CURDATE(), INTERVAL 10 DAY), 'Reposicion urgente de stock'),
('ENTREGADO', NOW(), NOW(), DATE_ADD(CURDATE(), INTERVAL 1 DAY), 'Pedido completado y entregado');

-- Detalles para la orden 1
INSERT INTO tbl_orden_confeccion_detalle (orden_confeccion_id, sku_id, cantidad_pedida, cantidad_entregada) VALUES
(1, 1, 50, 0),
(1, 2, 100, 10),
(1, 3, 75, 0);

-- Detalles para la orden 2
INSERT INTO tbl_orden_confeccion_detalle (orden_confeccion_id, sku_id, cantidad_pedida, cantidad_entregada) VALUES
(2, 1, 30, 15),
(2, 4, 20, 0);

-- Detalles para la orden 3
INSERT INTO tbl_orden_confeccion_detalle (orden_confeccion_id, sku_id, cantidad_pedida, cantidad_entregada) VALUES
(3, 5, 10, 10),
(3, 6, 25, 25);
