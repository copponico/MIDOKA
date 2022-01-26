USE MIDOKA_PGC_B;
SELECT 'Lsup' AS 'QUINCENA',
       ROUND(t8.COSTO, 0) AS 'costoMercaderias',
       ROUND(t12.FIJO, 0) AS 'costoFijo',
       ROUND(t10.comisionesFacturadas, 0) AS 'comisionesFacturadas',
       ROUND(t18.FACTURACION, 0)*.04 AS 'comisionGerencia',
       ROUND(t13.MOVILIDAD, 0) AS 'costoMovilidad',
       ROUND(t9.PERDIDAS, 0) AS 'perdidas',
       ROUND(t14.INSUMOS, 0) AS 'insumos',
       ROUND(t18.FACTURACION, 0) AS 'FACTURACION',
       ROUND(t20.DEVOLUCIONES, 0) AS 'DEVOLUCIONES'
FROM
  (SELECT 'ACTUAL' AS ACTUAL, SUM((CANTIDAD_AR-IF(OPERACIONES.SOLICITUD=42, CANTIDAD_ING, 0))*CANTIDAD_MINIMA*t1.PRECIO*(1 - IFNULL(DESCUENTO, 0) / 100)) AS 'COSTO'
   FROM ARMADO JOIN(PRECIOS, CATEGORIA, MODELO, CONDICION, ARTICULOS, CLIENTE, OPERACIONES, PROOVEDOR, SOLICITUDES) ON(PRECIOS.RUBRO_pr=ARTICULOS.RUBRO
                                                                                                          AND PRECIOS.CATEGORIA_pr=ARTICULOS.CATEGORIA
                                                                                                          AND PRECIOS.MODELO_pr=ARTICULOS.MODELO
                                                                                                          AND CATEGORIA.claID=ARTICULOS.CATEGORIA
                                                                                                          AND MODELO.mdID=ARTICULOS.MODELO
                                                                                                          AND CONDICION.cdID=CLIENTE.CONDICION
                                                                                                          AND CLIENTE.clID=OPERACIONES.INTERESADO
                                                                                                          AND ARTICULOS.artID=ARMADO.ID_ARTICULO_AR
                                                                                                          AND OPERACIONES.opID=ARMADO.OPERACION_REFERENCIA_AR
                                                                                                          AND PROOVEDOR.pooID=PRECIOS.PROOVEDOR
                                                                                                          AND opID=SOLICITUDES.REFERENCIA)
   JOIN PRHISTORICOS t1 ON(PRECIOS.RUBRO_pr=t1.RUBRO
                           AND PRECIOS.CATEGORIA_pr=t1.CATEGORIA
                           AND PRECIOS.MODELO_pr=t1.MODELO
                           AND t1.VIGENCIA<=SOLICITUDES.REALIZACION)
   LEFT JOIN PRHISTORICOS t2 ON(t1.RUBRO=t2.RUBRO
                                AND t1.CATEGORIA=t2.CATEGORIA
                                AND t1.MODELO=t2.MODELO
                                AND t2.VIGENCIA > t1.VIGENCIA
                                AND t2.VIGENCIA <=SOLICITUDES.REALIZACION)
   WHERE t2.VIGENCIA IS NULL
   	 AND CLASE=9
	 AND SOLICITUDES.REALIZACION>'Linf' AND SOLICITUDES.REALIZACION<='Lsup') t8 ON(t1.ACTUAL=t8.ACTUAL)
JOIN
  (SELECT 'ACTUAL' AS ACTUAL,
          ROUND(SUM(PERDIDAS), 2) AS PERDIDAS
   FROM CUENTA_CORRIENTE JOIN(OPERACIONES) ON(opID=OPERACION_REF_CC)
   WHERE OPERACIONES.FECHA>'Linf' AND OPERACIONES.FECHA<='Lsup') t9 ON(t1.ACTUAL=t9.ACTUAL)
JOIN
  (SELECT 'ACTUAL' AS ACTUAL,
          ROUND(SUM(DEVOLUCION), 2) AS DEVOLUCIONES
   FROM CUENTA_CORRIENTE JOIN(OPERACIONES) ON(opID=OPERACION_REF_CC)
   WHERE OPERACIONES.FECHA>'Linf' AND OPERACIONES.FECHA<='Lsup') t20 ON(t1.ACTUAL=t20.ACTUAL)   
JOIN
  (SELECT 'ACTUAL' AS ACTUAL,
          SUM(MONTO) AS 'comisionesFacturadas'
   FROM COMISIONES JOIN(OPERACIONES,SOLICITUDES) ON(opID=OPERACION_REF_C
   	AND opID=SOLICITUDES.REFERENCIA)
   WHERE ((VIGENCIA IS NULL
          AND CANCELACION IS NULL)
     OR (VIGENCIA IS NULL
         AND CANCELACION IS NOT NULL))
	AND CLASE=9 AND REALIZACION>'Linf' AND REALIZACION<='Lsup') t10 ON(t1.ACTUAL=t10.ACTUAL)
JOIN
  (SELECT 'ACTUAL' AS ACTUAL,
          REGISTRO AS FIJO
   FROM CONTABLES
   WHERE TIPO_REGISTRO=1 AND FECHA='Lsup') t12 ON(t1.ACTUAL=t12.ACTUAL)
JOIN
  (SELECT 'ACTUAL' AS ACTUAL,
          REGISTRO AS MOVILIDAD
   FROM CONTABLES
   WHERE TIPO_REGISTRO=2 AND FECHA='Lsup') t13 ON(t1.ACTUAL=t13.ACTUAL)
JOIN
  (SELECT 'ACTUAL' AS ACTUAL,
          REGISTRO AS INSUMOS
   FROM CONTABLES
   WHERE TIPO_REGISTRO=3 AND FECHA='Lsup') t14 ON(t1.ACTUAL=t14.ACTUAL)
JOIN
  (SELECT 'ACTUAL' AS ACTUAL,
          REGISTRO AS 'comisionesPagasExtra'
   FROM CONTABLES
   WHERE TIPO_REGISTRO=6 AND FECHA='Lsup') t16 ON(t1.ACTUAL=t16.ACTUAL)
JOIN
  (SELECT 'ACTUAL' AS ACTUAL, SUM(DEBE) AS 'FACTURACION' FROM CUENTA_CORRIENTE JOIN(OPERACIONES,SOLICITUDES) ON(opID=OPERACION_REF_CC AND REFERENCIA=opID) WHERE SOLICITUDES.REALIZACION<='Lsup' AND SOLICITUDES.REALIZACION>'Linf' AND CLASE=9) t18 ON(t1.ACTUAL=t18.ACTUAL);
