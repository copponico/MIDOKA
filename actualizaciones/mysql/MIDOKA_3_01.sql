USE las_rocas_g

START TRANSACTION;

INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('46','FALTANTE');
INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('54','46','7','7','7','46','7','18','5','10','1','3');
DELETE FROM COMISIONES WHERE OPERACION_REF_C;
DROP TABLE COMISIONES;
CREATE TABLE IF NOT EXISTS COMISIONES (comiID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,OPERACION_REF_C INT NOT NULL,TRABAJADOR INT NOT NULL,MONTO DOUBLE NOT NULL,VIGENCIA DATE,CANCELACION DATE,UNIQUE index_COMISION (OPERACION_REF_C,TRABAJADOR),CONSTRAINT `COMISIONES` FOREIGN KEY (OPERACION_REF_C) REFERENCES OPERACIONES (opID) ON DELETE CASCADE ON UPDATE RESTRICT) ENGINE = InnoDB;
INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('47','COMPOSICION DE SALDOS');
INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('22','composicion_saldos.sh');
INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('55','47','19','1','22','3','6','47','1','255','1','3');
INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('48','ACTUALIZAR ESPECIFICIONES ARTICULO');
INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('23','actualiza_contables.sh');
INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('56','48','15','1','23','3','6','47','1','255','1','3');
ALTER TABLE CLIENTE AUTO_INCREMENT=300;INSERT INTO CLIENTE (LOCALIDAD,PROVINCIA,CONDICION,NACIONALIDAD,COMERCIO,TIPO) VALUES(3,3,1,1,1,1);

CREATE TABLE IF NOT EXISTS CHINO (chinoID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,TEMA VARCHAR(200),UNO VARCHAR(1000),DOS VARCHAR(1000),TRES VARCHAR(100),CUATRO VARCHAR(100),CINCO VARCHAR(100),SEIS VARCHAR(100),SIETE VARCHAR(100),OCHO VARCHAR(100),NUEVE VARCHAR(100),DIEZ VARCHAR(100),ONCE VARCHAR(100),DOCE VARCHAR(100),TRECE VARCHAR(100))
CHARACTER SET utf8 COLLATE utf8_unicode_ci;


INSERT INTO CHINO (TEMA,UNO,DOS,TRES,CUATRO,CINCO,SEIS,SIETE) VALUES ('ENCABEZADO REMITO','发货单','日期','客戶','箱数','地址','区名','营业时间');

INSERT INTO CHINO (TEMA,UNO,DOS,TRES,CUATRO,CINCO,SEIS,SIETE,OCHO) VALUES ('PARTES FACTURACION','条码','产品描述','数量','单价','原价小计','折扣','小计','总');

INSERT INTO CHINO (TEMA,UNO,DOS,TRES,CUATRO) VALUES ('AVISO Y CABECERA FALTANTES','Los articulos, que a continuación se encuentran detallados, no han sido incluidos en el presente remito debido a una falta temporaria de los mismos. Por favor, si es que aun los desea, tenga la amabilidad de comunicarse por cualquiera de los medios disponibles para confirmarnoslo. Una vez recibida dicha confirmación, le seran entregados ni bien dispongamos de ellos. Les agradecemos mucho por su comprensión.','以下所列的产品因暂时缺货， 所以没有被列入发票里， 也没有收费。如果您还需要那些货， 请透过平常的联络方式通知我们。这样， 新货品一到我们会马上送到贵店去。
在此感谢谅解， 并祝贵店生意兴隆','产品描述','缺货数量');
INSERT INTO CONDICION (cdID,cond_cd,cond_num_cd,moratoria_cd,cond_num_fact) VALUES ('11','35%','.65','15','35');
INSERT INTO CONDICION (cdID,cond_cd,cond_num_cd,moratoria_cd,cond_num_fact) VALUES ('12','42%','.58','15','42');
INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('50','CONTROL PEDIDOS HISTORICOS');
INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('25','pedido_en_listado.sh');

INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('58','50','5','1','25','3','6','47','1','255','1','3');



INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('51','CORRECCION GENERAL');

INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('52','ADECUACION DE STOCK');

INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('53','CONSULTA DE STOCK');

INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('26','correccion_stock_adecuacion.sh');

INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('27','visualiza_stock.sh');



INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('59','52','15','1','26','3','6','52','1','255','1','3');

INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('60','53','19','1','27','3','6','53','1','255','1','3');

INSERT INTO OPERACIONES (INTERESADO,SOLICITUD,FECHA,COMPLETADO) VALUES ('300','51','2017-08-29','2017-08-29');
ALTER TABLE ARMADO ADD COLUMN (CANTIDAD_ING INT);
ALTER TABLE ARMADO ADD COLUMN (CANTIDAD_EGR INT);
ALTER TABLE ARMADO ADD COLUMN (CANTIDAD_DEVOL INT);
ALTER TABLE ARMADO ADD COLUMN (CANTIDAD_CST INT);
ALTER TABLE ARMADO ADD COLUMN (REMITO VARCHAR(100));
ALTER TABLE ARMADO ADD COLUMN (FECHA DATE);

ALTER TABLE OPERACIONES ADD COLUMN (PROVEEDOR_REFERENCIA INT DEFAULT NULL);

DELETE FROM INGRESOS WHERE ingID;

DELETE FROM DEVOLUCIONES WHERE devolID;

DROP TABLE INGRESOS;

DROP TABLE EGRESOS;

DROP TABLE DEVOLUCIONES;

DROP TABLE SALDO_PROOVEDOR;

CREATE TABLE IF NOT EXISTS SALDO_PROOVEDOR (saldopID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,FECHA DATE,REFERENCIA VARCHAR(100),PROOVEDOR INT NOT NULL,DEBE DOUBLE,HABER DOUBLE,OPERACION_ASOCIADA INT NOT NULL,UNIQUE index_proovedor (REFERENCIA,PROOVEDOR),UNIQUE index_operacion_pro (OPERACION_ASOCIADA),CONSTRAINT PROOVEDOR_REMITO FOREIGN KEY (PROOVEDOR) REFERENCES PROOVEDOR (pooID) ON DELETE CASCADE ON UPDATE RESTRICT,CONSTRAINT DALEQUEANDA FOREIGN KEY (OPERACION_ASOCIADA) REFERENCES OPERACIONES (opID) ON DELETE CASCADE ON UPDATE RESTRICT) ENGINE = InnoDB;

INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('54','VISTA GLOBAL ORDEN');

INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('28','vista_global_ariel.sh');


INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('61','54','12','1','28','3','6','54','1','255','1','3');

INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('55','COMISIONES');

INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('29','cierre_comisiones_efectivas.sh');


INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('62','55','19','1','29','3','6','55','1','255','1','3');

INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('56','LISTA DE PRECIOS');

INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('30','generado_lista_precios.sh');


INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('63','56','19','1','30','3','6','55','1','255','1','3');

INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('57','ESTIMADOR VENTAS');

INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('31','estimador_venta.sh');


INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('64','57','5','1','31','3','6','57','1','255','1','3');


INSERT INTO NOMBRE_MENU (nmID,nombre_nm) VALUES ('58','PROGRAMACION COMPRA');

INSERT INTO SCRIPTS (scID,tipo_sc) VALUES ('32','compras_general.sh');


INSERT INTO MENU (mID,nombre_m,ubicacion_m,proxubi_m,cont_m,para1_m,para2_m,para3_m,para4_m,para5_m,para6_m,para7_m) VALUES ('65','58','15','1','32','3','6','58','1','255','1','3');


CREATE TABLE IF NOT EXISTS COMPRAS (comID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,FECHA DATE,RUBRO INT NOT NULL,TIEMPO INT NOT NULL,CONSTRAINT RUBRO_COMPRA FOREIGN KEY(RUBRO) REFERENCES RUBRO (ruID) ON DELETE CASCADE ON UPDATE RESTRICT) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS DEMANDAS (demID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,COMPRA INT NOT NULL,ARTICULO INT NOT NULL,D_REAL INT,PVENTA DOUBLE,COSTO DOUBLE,n INT,D_EST DOUBLE,d DOUBLE,METODO INT,CONFIANZA DOUBLE,REALIDAD DOUBLE,STOCK INT,VOLUMEN DOUBLE,PEDIDO INT,CONSTRAINT ID_COMPRA FOREIGN KEY (COMPRA) REFERENCES COMPRAS (comID) ON DELETE CASCADE ON UPDATE RESTRICT) ENGINE = InnoDB;


COMMIT;