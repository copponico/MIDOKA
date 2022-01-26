#!/bin/bash
#
#
#
# 
# 
#
# 
#
# 
# # SCRIPT para el seleccionado de la orden de carga a realizar

################### MANTENIMIENTO INICIAL #####################


#shopt -s -o unset

################### DECLARACIONES ########################

declare -r TABLA="$1"

declare TOTAL

declare CONTADOR

declare ENTRADA="9"

declare CLIENTE="$2"

declare BRUTO

declare DESCUENTO

declare -a COMISIONES=("VENTA" "DEPOSITO" "ADMINISTRACION")

declare OPERACION="$3"

################### FUNCIONES #############################



function buscar_asignantes {


  
    mysql -u "${user}" --password="${pass}" --execute="SELECT rhdID,nombre_rhd FROM "${DB}".RECURSOS_HUMANOS_DISPONIBLES JOIN ("${DB}".RECURSOS_HUMANOS) ON ("${DB}".RECURSOS_HUMANOS_DISPONIBLES.tipo_rhd="${DB}".RECURSOS_HUMANOS.rhID) WHERE tipo_rhd=1 ;" | tail -n +2 | column -t -s $'\t'>${temp}"tmp2.ed"
    
    cat "./"${temp}"/tmp2.ed" | awk '{print $1}' >"./"${temp}"/tmp3.ed"

    ID=()
    CONTADOR=0
    while read line ; do
	
	ID+=("${line}") 
        
    done <"./"${temp}"/tmp3.ed"

    cat "./"${temp}"/tmp2.ed" | sed 's/^[0-9]\+//' >"./"${temp}"/tmp4.ed"

    foraneos=()
    while read line ; do
	
	foraneos+=("${ID[${CONTADOR}]}" """${line}""")  
	
	let CONTADOR+=1
	
    done <"./"${temp}"/tmp4.ed"


    while true; do

	exec 3>&1
	RECURSO=$(dialog \
			--backtitle "CONTABILIDAD" \
			--title """SELECCIONE VENDEDOR QUE REALIZO LA OPERACION""" \
			--clear \
			--cancel-label "SALIR" \
			--help-button \
			--help-label "SIN ASIGNAR" \
			--menu "PULSE EL BOTON SIN ASIGNAR EN CASO OMISO" 0 0 0 "${foraneos[@]}" \
			2>&1 1>&3)
	exit_status=$?
	exec 3>&-
	case $exit_status in
	    $DIALOG_CANCEL)
		clear
		
		exit 192
		;;
	    $DIALOG_ESC)
		clear
		
		exit 204
		;;
	    $DIALOG_ITEM_HELP)
		RECURSO=""
		return
		;;
	esac

	
	
	break
	
    done

    
    
}




#@@@@@@@@@@@@@@@@@@ SCRIPT ##################################	


buscar_asignantes

declare -a RECURSO_HUMANO=("${RECURSO}" "4" "5")

for i in ${COMISIONES[@]};do

    rm ${temp}${i}

done


mysql -u "${user}" --password="${pass}" --execute="SELECT ROUND(ADMINISTRACION * IF(CONDICION = CONDICION_REFERENCIA AND DESCUENTO_ESPECIAL <> '-',ROUND(ROUND(1 - DESCUENTO_ESPECIAL/100,2) * IF(UMBRAL>0 AND CANTIDAD_RE>=UMBRAL,CANTIDAD_RE * CANTIDAD_MINIMA,CANTIDAD_RE * CANTIDAD_MINIMA) * IF((VIGENCIA_A <= CURDATE() AND VIGENCIA_A > VIGENCIA_B) OR (VIGENCIA_A <= CURDATE() AND VIGENCIA_B > CURDATE()) OR (PRECIO_B IS NULL),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_A,PRECIO_A),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_B,PRECIO_B)),2),IF(DESCUENTO_ESPECIFICO > '0',ROUND(ROUND(1 - DESCUENTO_ESPECIFICO/100,2) * IF(UMBRAL>0 AND CANTIDAD_RE>=UMBRAL,CANTIDAD_RE * CANTIDAD_MINIMA,CANTIDAD_RE * CANTIDAD_MINIMA) * IF((VIGENCIA_A <= CURDATE() AND VIGENCIA_A > VIGENCIA_B) OR (VIGENCIA_A <= CURDATE() AND VIGENCIA_B > CURDATE()) OR (PRECIO_B IS NULL),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_A,PRECIO_A),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_B,PRECIO_B)),2),ROUND(cond_num_cd * IF(UMBRAL>0 AND CANTIDAD_RE>=UMBRAL,CANTIDAD_RE * CANTIDAD_MINIMA,CANTIDAD_RE * CANTIDAD_MINIMA) * IF((VIGENCIA_A <= CURDATE() AND VIGENCIA_A > VIGENCIA_B) OR (VIGENCIA_A <= CURDATE() AND VIGENCIA_B > CURDATE()) OR (PRECIO_B IS NULL),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_A,PRECIO_A),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_B,PRECIO_B)),2))),2) AS 'SUB-TOTAL#' FROM "${DB}"."${TABLA}" JOIN("${DB}".PRECIOS,"${DB}".CATEGORIA,"${DB}".MODELO,"${DB}".CONDICION,"${DB}".ARTICULOS,"${DB}".CLIENTE,"${DB}".OPERACIONES,"${DB}".PROOVEDOR,"${DB}".TIPO_COMISION) ON("${DB}".PRECIOS.RUBRO_pr="${DB}".ARTICULOS.RUBRO AND "${DB}".PRECIOS.CATEGORIA_pr="${DB}".ARTICULOS.CATEGORIA AND "${DB}".PRECIOS.MODELO_pr="${DB}".ARTICULOS.MODELO AND "${DB}".CATEGORIA.claID="${DB}".ARTICULOS.CATEGORIA AND "${DB}".MODELO.mdID="${DB}".ARTICULOS.MODELO AND "${DB}".CONDICION.cdID="${DB}".CLIENTE.CONDICION AND "${DB}".ARTICULOS.artID="${DB}"."${TABLA}".ID_ARTICULO_RE AND "${DB}".PROOVEDOR.pooID="${DB}".PRECIOS.PROOVEDOR AND "${DB}".PRECIOS.TIPO_COMISION="${DB}".TIPO_COMISION.tcoID) WHERE clID="${CLIENTE}" GROUP BY repID ;" | tail -n +2 >${temp}"ADMINISTRACION"

mysql -u "${user}" --password="${pass}" --execute="SELECT ROUND(VENTA * IF(CONDICION = CONDICION_REFERENCIA AND DESCUENTO_ESPECIAL <> '-',ROUND(ROUND(1 - DESCUENTO_ESPECIAL/100,2) * IF(UMBRAL>0 AND CANTIDAD_RE>=UMBRAL,CANTIDAD_RE * CANTIDAD_MINIMA,CANTIDAD_RE * CANTIDAD_MINIMA) * IF((VIGENCIA_A <= CURDATE() AND VIGENCIA_A > VIGENCIA_B) OR (VIGENCIA_A <= CURDATE() AND VIGENCIA_B > CURDATE()) OR (PRECIO_B IS NULL),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_A,PRECIO_A),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_B,PRECIO_B)),2),IF(DESCUENTO_ESPECIFICO > '0',ROUND(ROUND(1 - DESCUENTO_ESPECIFICO/100,2) * IF(UMBRAL>0 AND CANTIDAD_RE>=UMBRAL,CANTIDAD_RE * CANTIDAD_MINIMA,CANTIDAD_RE * CANTIDAD_MINIMA) * IF((VIGENCIA_A <= CURDATE() AND VIGENCIA_A > VIGENCIA_B) OR (VIGENCIA_A <= CURDATE() AND VIGENCIA_B > CURDATE()) OR (PRECIO_B IS NULL),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_A,PRECIO_A),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_B,PRECIO_B)),2),ROUND(cond_num_cd * IF(UMBRAL>0 AND CANTIDAD_RE>=UMBRAL,CANTIDAD_RE * CANTIDAD_MINIMA,CANTIDAD_RE * CANTIDAD_MINIMA) * IF((VIGENCIA_A <= CURDATE() AND VIGENCIA_A > VIGENCIA_B) OR (VIGENCIA_A <= CURDATE() AND VIGENCIA_B > CURDATE()) OR (PRECIO_B IS NULL),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_A,PRECIO_A),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_B,PRECIO_B)),2))),2) AS 'SUB-TOTAL#' FROM "${DB}"."${TABLA}" JOIN("${DB}".PRECIOS,"${DB}".CATEGORIA,"${DB}".MODELO,"${DB}".CONDICION,"${DB}".ARTICULOS,"${DB}".CLIENTE,"${DB}".OPERACIONES,"${DB}".PROOVEDOR,"${DB}".TIPO_COMISION) ON("${DB}".PRECIOS.RUBRO_pr="${DB}".ARTICULOS.RUBRO AND "${DB}".PRECIOS.CATEGORIA_pr="${DB}".ARTICULOS.CATEGORIA AND "${DB}".PRECIOS.MODELO_pr="${DB}".ARTICULOS.MODELO AND "${DB}".CATEGORIA.claID="${DB}".ARTICULOS.CATEGORIA AND "${DB}".MODELO.mdID="${DB}".ARTICULOS.MODELO AND "${DB}".CONDICION.cdID="${DB}".CLIENTE.CONDICION AND "${DB}".ARTICULOS.artID="${DB}"."${TABLA}".ID_ARTICULO_RE AND "${DB}".PROOVEDOR.pooID="${DB}".PRECIOS.PROOVEDOR AND "${DB}".PRECIOS.TIPO_COMISION="${DB}".TIPO_COMISION.tcoID) WHERE clID="${CLIENTE}" GROUP BY repID ;" | tail -n +2 >${temp}"VENTA"

mysql -u "${user}" --password="${pass}" --execute="SELECT ROUND(DEPOSITO * IF(CONDICION = CONDICION_REFERENCIA AND DESCUENTO_ESPECIAL <> '-',ROUND(ROUND(1 - DESCUENTO_ESPECIAL/100,2) * IF(UMBRAL>0 AND CANTIDAD_RE>=UMBRAL,CANTIDAD_RE * CANTIDAD_MINIMA,CANTIDAD_RE * CANTIDAD_MINIMA) * IF((VIGENCIA_A <= CURDATE() AND VIGENCIA_A > VIGENCIA_B) OR (VIGENCIA_A <= CURDATE() AND VIGENCIA_B > CURDATE()) OR (PRECIO_B IS NULL),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_A,PRECIO_A),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_B,PRECIO_B)),2),IF(DESCUENTO_ESPECIFICO > '0',ROUND(ROUND(1 - DESCUENTO_ESPECIFICO/100,2) * IF(UMBRAL>0 AND CANTIDAD_RE>=UMBRAL,CANTIDAD_RE * CANTIDAD_MINIMA,CANTIDAD_RE * CANTIDAD_MINIMA) * IF((VIGENCIA_A <= CURDATE() AND VIGENCIA_A > VIGENCIA_B) OR (VIGENCIA_A <= CURDATE() AND VIGENCIA_B > CURDATE()) OR (PRECIO_B IS NULL),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_A,PRECIO_A),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_B,PRECIO_B)),2),ROUND(cond_num_cd * IF(UMBRAL>0 AND CANTIDAD_RE>=UMBRAL,CANTIDAD_RE * CANTIDAD_MINIMA,CANTIDAD_RE * CANTIDAD_MINIMA) * IF((VIGENCIA_A <= CURDATE() AND VIGENCIA_A > VIGENCIA_B) OR (VIGENCIA_A <= CURDATE() AND VIGENCIA_B > CURDATE()) OR (PRECIO_B IS NULL),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_A,PRECIO_A),IF(VALOR_AGREGADO >'0',(1 + VALOR_AGREGADO/100) * PRECIO_B,PRECIO_B)),2))),2) AS 'SUB-TOTAL#' FROM "${DB}"."${TABLA}" JOIN("${DB}".PRECIOS,"${DB}".CATEGORIA,"${DB}".MODELO,"${DB}".CONDICION,"${DB}".ARTICULOS,"${DB}".CLIENTE,"${DB}".OPERACIONES,"${DB}".PROOVEDOR,"${DB}".TIPO_COMISION) ON("${DB}".PRECIOS.RUBRO_pr="${DB}".ARTICULOS.RUBRO AND "${DB}".PRECIOS.CATEGORIA_pr="${DB}".ARTICULOS.CATEGORIA AND "${DB}".PRECIOS.MODELO_pr="${DB}".ARTICULOS.MODELO AND "${DB}".CATEGORIA.claID="${DB}".ARTICULOS.CATEGORIA AND "${DB}".MODELO.mdID="${DB}".ARTICULOS.MODELO AND "${DB}".CONDICION.cdID="${DB}".CLIENTE.CONDICION AND "${DB}".ARTICULOS.artID="${DB}"."${TABLA}".ID_ARTICULO_RE AND "${DB}".PROOVEDOR.pooID="${DB}".PRECIOS.PROOVEDOR AND "${DB}".PRECIOS.TIPO_COMISION="${DB}".TIPO_COMISION.tcoID) WHERE clID="${CLIENTE}" GROUP BY repID ;" | tail -n +2 >${temp}"DEPOSITO"


CONTADOR=0

rm ${temp}"comision" ; touch ${temp}"comision"

for i in ${COMISIONES[@]};do

    declare SUMA=0    
    
    TOTAL=0

        
    while read line_c;do

	SUMA="$(echo "${line_c}" | awk '{print $NF}')"
	
	TOTAL="$(maxima --very-quiet --batch-string "fpprintprec:7$"${TOTAL}"+"${SUMA}";" | tail -n +3 | sed /^[0-9]/d | sed s/[[:blank:]]//g)"
	
    done<${temp}"${i}"
    

    VAR="${temp}${i}"

    ( test -s ${VAR} && test ! -z ${RECURSO_HUMANO[${CONTADOR}]} ) && echo "INSERT INTO "${DB}".COMISIONES (OPERACION_REF_C,TRABAJADOR,MONTO,VIGENCIA) VALUES ("${OPERACION}","${RECURSO_HUMANO[${CONTADOR}]}","${TOTAL}",'${DIA}');" >>${temp}"comision"

    
    let CONTADOR+=1
    
    
done


bash  ${scr}"transaccion.sh" ${temp}"comision"




################## MANTENIMIENTO FINAL ###################


#VAR_s=${temp}"*" 

#rm $VAR_s

exit 0