#!/bin/bash
#
# Script para estudio de situacion patrimonial
#

############## DECLARACIONES ###########################

declare INDICE

declare COLUMNA_REFERENCIA

declare VALOR

declare CONTADOR

declare VAR

declare VAR_a

declare -r DB="MIDOKA_PGC_B"

declare -r pass="macaco12"


################# FUNCIONES ############################




###############  SCRIPT ###########################


mysql -u "${USER}" --password="${pass}" --execute="USE MIDOKA_PGC_B;SELECT SUM((IFNULL(CANTIDAD_CST,0) + IFNULL(CANTIDAD_ING,0) + IFNULL(CANTIDAD_DEVOL,0) - IFNULL(CANTIDAD_EGR,0) - IFNULL(CANTIDAD_AR,0)) * CANTIDAD_MINIMA * IF(IFNULL(PRECIO_A,0) > IFNULL(PRECIO_B,0),IFNULL(PRECIO_A,0) * (1 - (DESCUENTO / 100)),IFNULL(PRECIO_B,0) * (1 - (DESCUENTO / 100)))) AS 'VALOR STOCK' FROM ARMADO JOIN (RUBRO,CATEGORIA,MODELO,MOTIVO,PROOVEDOR,PRECIOS,ARTICULOS) ON (RUBRO.ruID=PRECIOS.RUBRO_pr AND CATEGORIA.claID=PRECIOS.CATEGORIA_pr AND MODELO.mdID=PRECIOS.MODELO_pr AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR AND ARTICULOS.RUBRO=PRECIOS.RUBRO_pr AND ARTICULOS.CATEGORIA=PRECIOS.CATEGORIA_pr AND ARTICULOS.MODELO=PRECIOS.MODELO_pr AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND ARTICULOS.MOTIVO=MOTIVO.mtID);"

mysql -u "${USER}" --password="${pass}" --execute="USE MIDOKA_PGC_B;SELECT SUM(IFNULL(DEBE,0) - IFNULL(HABER,0) - IFNULL(DEVOLUCION,0) - IFNULL(PERDIDAS,0)) AS 'SALDO CLIENTES' FROM CUENTA_CORRIENTE;"

CALLE="$(mysql -u "${USER}" --password="${pass}" --execute="USE MIDOKA_PGC_B;SELECT SUM(IFNULL(DEBE,0) - IFNULL(HABER,0)) AS 'SALDO PROVEEDOR' FROM SALDO_PROOVEDOR;")"


mysql -u "${user}" --password="${pass}" --execute="USE "${DB}";SELECT SUM(IF(DENOMINACION IS NULL,0,ROUND(IF(CONDICION = CONDICION_REFERENCIA AND DESCUENTO_ESPECIAL <> '-',1 - DESCUENTO_ESPECIAL/100 * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),IF(DESCUENTO_ESPECIFICO > '0',(1 - DESCUENTO_ESPECIFICO/100 ) * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),cond_num_cd * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA))),2))) AS 'CUENTA' FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR) ON(PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE pooID=3 AND OPERACIONES.FECHA>='${FECHA_INICIO_ACTIVIDADES_IVO}' AND t2.VIGENCIA IS NULL ORDER BY OPERACIONES.FECHA;"

############# VENTAS ##############

SELECT DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m'),SUM(IF(DENOMINACION IS NULL,0,ROUND(IF(CONDICION = CONDICION_REFERENCIA AND DESCUENTO_ESPECIAL <> '-',1 - DESCUENTO_ESPECIAL/100 * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),IF(DESCUENTO_ESPECIFICO > '0',(1 - DESCUENTO_ESPECIFICO/100 ) * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),cond_num_cd * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA))),2))) AS 'CUENTA' FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR) ON(PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL GROUP BY DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') ORDER BY DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') ASC;

################# COBRO REAL  #######################

SELECT CONCAT(MONTH(FECHA),'/',YEAR(FECHA)) AS MES,ROUND(SUM(HABER),0) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES) ON(OPERACIONES.opID=OPERACION_REF_CC) GROUP BY CONCAT(MONTH(FECHA),'/',YEAR(FECHA)) ORDER BY YEAR(FECHA),MONTH(FECHA) ASC;

################# COBRO + 50% DEVOL - COMISION PABLO #######################


# LAS DEVOLUCIONES VUELVEN AL 50% DE SU VALOR DE VENTA


 SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,ROUND(SUM(HABER + .5 * DEVOLUCION - .03 * HABER),0) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES) ON(OPERACIONES.opID=OPERACION_REF_CC) GROUP BY DATE_FORMAT(FECHA,'%Y-%m') ORDER BY YEAR(FECHA),MONTH(FECHA) ASC;

 # COMISIONES

 SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,IFNULL(SUM(MONTO),0) AS COMISIONES FROM COMISIONES JOIN(OPERACIONES) ON(opID=OPERACION_REF_C) WHERE VIGENCIA IS NOT NULL AND CANCELACION IS NOT NULL  GROUP BY DATE_FORMAT(FECHA,'%Y-%m') ORDER BY YEAR(FECHA),MONTH(FECHA) ASC

 # COSTO MERCA NO ANDA

 SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,IFNULL(SUM(MONTO / .03),0) AS COSTO_MERCA FROM COMISIONES JOIN(OPERACIONES) ON(opID=OPERACION_REF_C) WHERE VIGENCIA IS NULL AND CANCELACION IS NOT NULL AND TRABAJADOR=4 GROUP BY DATE_FORMAT(FECHA,'%Y-%m') ORDER BY YEAR(FECHA),MONTH(FECHA) ASC;
 
 ############ JUNTO COMISIONES Y COBRO - PABLO####################

 SELECT * FROM (SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,ROUND(SUM(HABER + .5 * DEVOLUCION - .03 * HABER),0) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES) ON(OPERACIONES.opID=OPERACION_REF_CC) GROUP BY DATE_FORMAT(FECHA,'%Y-%m') ORDER BY YEAR(FECHA),MONTH(FECHA) ASC) t1 LEFT JOIN (SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,IFNULL(SUM(MONTO),0) AS COMISIONES FROM COMISIONES JOIN(OPERACIONES) ON(opID=OPERACION_REF_C) WHERE VIGENCIA IS NOT NULL AND CANCELACION IS NOT NULL AND DATE_FORMAT(FECHA,'%Y-%m') GROUP BY DATE_FORMAT(FECHA,'%Y-%m') ORDER BY DATE_FORMAT(FECHA,'%Y-%m') ASC) t2 ON(t1.MES=t2.MES) ORDER BY t1.MES,t2.MES ASC;

 ##################### COSTO MERCA$################

SELECT DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') AS MES,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 GROUP BY DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') ORDER BY YEAR(OPERACIONES.FECHA),MONTH(OPERACIONES.FECHA) ASC
 
######################### COSTO MERCA - JUNTO COMSIONES + COBRO - PABLO #########

SELECT * FROM (SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,ROUND(SUM(HABER + .5 * DEVOLUCION - .03 * HABER),0) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES) ON(OPERACIONES.opID=OPERACION_REF_CC) GROUP BY DATE_FORMAT(FECHA,'%Y-%m') ORDER BY YEAR(FECHA),MONTH(FECHA) ASC) t1 LEFT JOIN (SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,IFNULL(SUM(MONTO),0) AS COMISIONES FROM COMISIONES JOIN(OPERACIONES) ON(opID=OPERACION_REF_C) WHERE VIGENCIA IS NOT NULL AND CANCELACION IS NOT NULL AND DATE_FORMAT(FECHA,'%Y-%m') GROUP BY DATE_FORMAT(FECHA,'%Y-%m') ORDER BY DATE_FORMAT(FECHA,'%Y-%m') ASC) t2 ON(t1.MES=t2.MES) LEFT JOIN(SELECT DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') AS MES,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 GROUP BY DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') ORDER BY YEAR(OPERACIONES.FECHA),MONTH(OPERACIONES.FECHA) ASC) t3 ON(t1.MES=t3.MES) ORDER BY t1.MES,t2.MES ASC;


################################ TODO #############

SELECT * FROM (SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,ROUND(SUM(HABER + .5 * DEVOLUCION - .03 * HABER),0) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES) ON(OPERACIONES.opID=OPERACION_REF_CC) GROUP BY DATE_FORMAT(FECHA,'%Y-%m') ORDER BY YEAR(FECHA),MONTH(FECHA) ASC) t1 LEFT JOIN (SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,IFNULL(SUM(MONTO),0) AS COMISIONES FROM COMISIONES JOIN(OPERACIONES) ON(opID=OPERACION_REF_C) WHERE VIGENCIA IS NOT NULL AND CANCELACION IS NOT NULL AND DATE_FORMAT(FECHA,'%Y-%m') GROUP BY DATE_FORMAT(FECHA,'%Y-%m') ORDER BY DATE_FORMAT(FECHA,'%Y-%m') ASC) t2 ON(t1.MES=t2.MES) LEFT JOIN(SELECT DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') AS MES,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 GROUP BY DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') ORDER BY YEAR(OPERACIONES.FECHA),MONTH(OPERACIONES.FECHA) ASC) t3 ON(t1.MES=t3.MES) LEFT JOIN(SELECT DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') AS MES,.09 * SUM(IF(DENOMINACION IS NULL,0,ROUND(IF(CONDICION = CONDICION_REFERENCIA AND DESCUENTO_ESPECIAL <> '-',1 - DESCUENTO_ESPECIAL/100 * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),IF(DESCUENTO_ESPECIFICO > '0',(1 - DESCUENTO_ESPECIFICO/100 ) * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),cond_num_cd * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA))),2))) AS 'VARIABLES_ESTIMADOS' FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR) ON(PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL GROUP BY DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') ORDER BY DATE_FORMAT(OPERACIONES.FECHA,'%Y-%m') ASC) t4 ON(t4.MES=t1.MES) LEFT JOIN(SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,SUM(COSTO) AS FIJOS FROM COSTOS WHERE TIPO_COSTO=1 GROUP BY TIPO_COSTO,DATE_FORMAT(FECHA,'%Y-%m')) t5 ON(t5.MES=t1.MES) LEFT JOIN(SELECT DATE_FORMAT(FECHA,'%Y-%m') AS MES,SUM(COSTO) AS VARIABLES FROM COSTOS WHERE TIPO_COSTO=2 GROUP BY TIPO_COSTO,DATE_FORMAT(FECHA,'%Y-%m')) t6 ON(t6.MES=t1.MES) ORDER BY t1.MES,t2.MES ASC;


##################### VER PAGOS DE LOS CUALES NO HAY REGISTRO EN TABLA COMISIONES #################

SELECT opID,SOLICITUD,DENOMINACION,MONTO,VIGENCIA,CANCELACION FROM OPERACIONES t1 LEFT JOIN COMISIONES t2 ON(t1.opID=t2.OPERACION_REF_C AND t2.TRABAJADOR=4) JOIN(CLIENTE) ON(clID=INTERESADO) WHERE t2.TRABAJADOR IS NULL AND SOLICITUD=41 ORDER BY opID DESC LIMIT 100;

######################### COBRADO EFECTIVO DETALLADO POR CLIENTE POR MES #####################

SELECT opID,DENOMINACION,ROUND(HABER,2) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES,CLIENTE) ON(OPERACIONES.opID=OPERACION_REF_CC AND INTERESADO=clID) WHERE MONTH(OPERACIONES.FECHA)='2' AND YEAR(OPERACIONES.FECHA)='2018' AND HABER>0 ORDER BY opID ASC;

######################## COSTO MERCA DETALLADO POR CLIENTE POR MES #########################

SELECT opID,DENOMINACION,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 AND MONTH(OPERACIONES.FECHA)='2' AND YEAR(OPERACIONES.FECHA)='2018' GROUP BY opID ORDER BY opID ASC;


############################ COBROS Y PAGOS DETALLADOS POR MES #######################

SELECT t1.opID,t1.DENOMINACION,t2.COBRO,t1.opID AS PAGO,t1.COSTO,(t1.COSTO / t2.COBRO) AS REL FROM (SELECT opID,DENOMINACION,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 AND MONTH(OPERACIONES.FECHA)='2' AND YEAR(OPERACIONES.FECHA)='2018' GROUP BY opID ORDER BY opID ASC) t1 LEFT JOIN(SELECT opID,DENOMINACION,ROUND(HABER,2) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES,CLIENTE) ON(OPERACIONES.opID=OPERACION_REF_CC AND INTERESADO=clID) WHERE MONTH(OPERACIONES.FECHA)='2' AND YEAR(OPERACIONES.FECHA)='2018' AND HABER>0 ORDER BY opID ASC) t2 ON(t1.DENOMINACION=t2.DENOMINACION);

####################### COBROS CONTRASTADOS CON PAGOS #####################

SELECT t2.DATE,t1.opID AS ENTREGA,t1.DENOMINACION,t2.opID AS PAGO,t2.COBRO,t1.COSTO,(t1.COSTO / t2.COBRO) AS REL,t1.VIGENCIA,t1.CANCELACION FROM (SELECT opID,DENOMINACION,COMISIONES.VIGENCIA,COMISIONES.CANCELACION,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 AND MONTH(COMISIONES.CANCELACION)='2' AND YEAR(COMISIONES.CANCELACION)='2018' GROUP BY opID ORDER BY opID ASC) t1 LEFT JOIN(SELECT opID,OPERACIONES.FECHA AS DATE,DENOMINACION,ROUND(HABER,2) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES,CLIENTE) ON(OPERACIONES.opID=OPERACION_REF_CC AND INTERESADO=clID) WHERE MONTH(OPERACIONES.FECHA)='2' AND YEAR(OPERACIONES.FECHA)='2018' AND HABER>0 ORDER BY opID ASC) t2 ON(t1.DENOMINACION=t2.DENOMINACION AND t1.CANCELACION=t2.DATE);

##################################### SOLO COSTOS FINAL

SELECT opID,OPERACIONES.FECHA,DENOMINACION,COMISIONES.VIGENCIA,COMISIONES.CANCELACION,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 AND MONTH(COMISIONES.CANCELACION)='2' AND YEAR(COMISIONES.CANCELACION)='2018' GROUP BY opID ORDER BY opID ASC;

#################################### COSTO TOTAL FINAL ###############

SELECT SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 AND MONTH(COMISIONES.CANCELACION)='2' AND YEAR(COMISIONES.CANCELACION)='2018';

################################### COSTOS NO CONSIDERADOS, PERO SE DUPLICAN LOS QUE PAGARON EN DIFERENTES DIAS ############

SELECT t2.DATE,t1.opID AS ENTREGA,t2.DENOMINACION,t2.opID AS PAGO,t2.COBRO,IFNULL(t1.COSTO,t2.COBRO * .93) AS COSTO,(t1.COSTO / t2.COBRO) AS REL,t1.VIGENCIA,t1.CANCELACION FROM (SELECT opID,DENOMINACION,COMISIONES.VIGENCIA,COMISIONES.CANCELACION,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 AND MONTH(COMISIONES.CANCELACION)='2' AND YEAR(COMISIONES.CANCELACION)='2018' GROUP BY opID ORDER BY opID ASC) t1 RIGHT JOIN(SELECT opID,OPERACIONES.FECHA AS DATE,DENOMINACION,ROUND(HABER,2) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES,CLIENTE) ON(OPERACIONES.opID=OPERACION_REF_CC AND INTERESADO=clID) WHERE MONTH(OPERACIONES.FECHA)='2' AND YEAR(OPERACIONES.FECHA)='2018' AND HABER>0 ORDER BY opID ASC) t2 ON(t1.DENOMINACION=t2.DENOMINACION AND t1.CANCELACION=t2.DATE) WHERE t1.opID IS NULL;

###################### SUMA DE LOS NO CONSIDERADOS CON EL ERROR DEL QUE PAGA DIFERIDO ###############

SELECT SUM(IFNULL(t1.COSTO,t2.COBRO * .93)) FROM (SELECT opID,DENOMINACION,COMISIONES.VIGENCIA,COMISIONES.CANCELACION,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 AND MONTH(COMISIONES.CANCELACION)='2' AND YEAR(COMISIONES.CANCELACION)='2018' GROUP BY opID ORDER BY opID ASC) t1 RIGHT JOIN(SELECT opID,OPERACIONES.FECHA AS DATE,DENOMINACION,ROUND(HABER,2) AS COBRO FROM CUENTA_CORRIENTE JOIN(OPERACIONES,CLIENTE) ON(OPERACIONES.opID=OPERACION_REF_CC AND INTERESADO=clID) WHERE MONTH(OPERACIONES.FECHA)='2' AND YEAR(OPERACIONES.FECHA)='2018' AND HABER>0 ORDER BY opID ASC) t2 ON(t1.DENOMINACION=t2.DENOMINACION AND t1.CANCELACION=t2.DATE) WHERE t1.opID IS NULL;

#################### VISTA DE LAS COMISIONES POR FECHA POR MONTO TOTAL DE BOLETA

SELECT OPERACIONES.COMPLETADO,DENOMINACION,DEBE AS TOTAL,SUM(MONTO) AS COMISIONES,ROUND(SUM(MONTO)/DEBE,2) FROM COMISIONES JOIN(OPERACIONES,CLIENTE,CUENTA_CORRIENTE) ON(opID=OPERACION_REF_C AND clID=INTERESADO AND OPERACION_REF_CC=opID) WHERE (VIGENCIA IS NULL AND CANCELACION IS NULL) OR (VIGENCIA IS NULL AND CANCELACION IS NOT NULL) GROUP BY opID;

########################### FECHA OPERACION MONTO FACTURADO DESDE ARMADO #########################

SELECT opID AS OPERACION,OPERACIONES.FECHA AS FECHA,SUM(IF(DENOMINACION IS NULL,0,ROUND(IF(CONDICION = CONDICION_REFERENCIA AND DESCUENTO_ESPECIAL <> '-',1 - DESCUENTO_ESPECIAL/100 * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),IF(DESCUENTO_ESPECIFICO > '0',(1 - DESCUENTO_ESPECIFICO/100 ) * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),cond_num_cd * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA))),2))) AS 'FACTURACION' FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR) ON(PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL GROUP BY opID


################# OPERACION FECHA COSTO DESDE ARMADO ###########################

SELECT opID AS OPERACION,OPERACIONES.FECHA AS FECHA,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 GROUP BY opID LIMIT 5;

####################### OPERACION FECHA FACTURADO COSTO RELACION POR MES INDIVIDUALIZADO ############

SELECT t1.OPERACION,t1.FECHA,t1.DENOMINACION,t1.FACTURACION,t2.COSTO,ROUND((t2.COSTO/t1.FACTURACION)*100,2) AS PARTICIPACION FROM (SELECT opID AS OPERACION,DENOMINACION,OPERACIONES.FECHA AS FECHA,SUM(IF(DENOMINACION IS NULL,0,ROUND(IF(CONDICION = CONDICION_REFERENCIA AND DESCUENTO_ESPECIAL <> '-',1 - DESCUENTO_ESPECIAL/100 * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),IF(DESCUENTO_ESPECIFICO > '0',(1 - DESCUENTO_ESPECIFICO/100 ) * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA),cond_num_cd * IF(VALOR_AGREGADO>'0',(1 + VALOR_AGREGADO/100) * t1.PRECIO,t1.PRECIO) * IF(IFNULL(CANTIDAD_AR,0)>IFNULL(CANTIDAD_ING,0),CANTIDAD_AR * CANTIDAD_MINIMA,(-1 * CANTIDAD_ING) * CANTIDAD_MINIMA))),2))) AS 'FACTURACION' FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR) ON(PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL GROUP BY opID) t1 RIGHT JOIN (SELECT opID AS OPERACION,OPERACIONES.FECHA AS FECHA,SUM(CANTIDAD_AR*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO,0) / 100)) AS COSTO FROM ARMADO JOIN(PRECIOS,CATEGORIA,MODELO,CONDICION,ARTICULOS,CLIENTE,OPERACIONES,PROOVEDOR,COMISIONES) ON(opID=OPERACION_REF_C AND PRECIOS.RUBRO_pr=ARTICULOS.RUBRO AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA AND PRECIOS.MODELO_pr=ARTICULOS.MODELO AND CATEGORIA.claID=ARTICULOS.CATEGORIA AND MODELO.mdID=ARTICULOS.MODELO AND CONDICION.cdID=CLIENTE.CONDICION AND CLIENTE.clID=OPERACIONES.INTERESADO AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR) JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA AND PRECIOS.MODELO_pr=t1.MODELO AND t1.VIGENCIA<=OPERACIONES.FECHA) LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO AND t1.CATEGORIA=t2.CATEGORIA AND t1.MODELO=t2.MODELO AND t2.VIGENCIA > t1.VIGENCIA AND t2.VIGENCIA <=OPERACIONES.FECHA) WHERE t2.VIGENCIA IS NULL AND COMISIONES.VIGENCIA IS NULL AND COMISIONES.CANCELACION IS NOT NULL AND COMISIONES.TRABAJADOR=4 GROUP BY opID) t2 ON(t1.OPERACION=t2.OPERACION) WHERE t1.FECHA>='2018-07-01' AND ROUND((t2.COSTO/t1.FACTURACION)*100,2)>70;

########### OJO QUE TIENE METIDO LOS QUE REPRESENTAN MENOR GANANCIA###############

################### MANTENIMIENTO ########################################


exit 0