
mysql -u root --execute="USE MIDOKA_PGC_B;SELECT DENOMINACION AS 'DETALLE TRABAJO ARIEL CARNEVALE',REALIZACION FROM SOLICITUDES JOIN(CLIENTE,OPERACIONES) ON(CLIENTE.clID=OPERACIONES.INTERESADO AND OPERACIONES.opID=SOLICITUDES.REFERENCIA) WHERE ASIGNADA=4 AND COMIENZO>='2017-07-26' ORDER BY REALIZACION DESC;"