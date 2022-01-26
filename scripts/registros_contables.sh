#!/bin/bash
#
# Script para la carga automatica de registros contables mediante CSV
#

############## DECLARACIONES ###########################

declare INDICE

declare -r OBJETIVO="PRECIOS"

declare COLUMNA_REFERENCIA

declare VALOR

declare -a BUSQUEDAS

declare CONTADOR

declare VAR

declare VAR_a

declare ACTOR=""${OBJETIVO}""

declare BUSQUEDA

declare -a CAMPOS_BUSQUEDA=("PROOVEDOR" "RUBRO" "CATEGORIA" "MODELO" "CODIGO_PROOVEDOR" "CODIGO_BARRAS")

declare -a REFERENCIAS_BUSQ=("NOMBRE_COMERCIAL" "rubro_rb" "clasificacion_cla" "modelo_md" "CODIGO_PROOVEDOR" "CODIGO_BARRAS")

################# FUNCIONES ############################

function menu {


    declare VAR_PRUEBA
    
    cat "./"${temp}"/tmp.ba" | awk '{print $1}' >"./"${temp}"/tmp3.ba"

    ID=()
    CONTADOR=0
    while read line ; do
	
	ID+=("${line}") 
        
    done <"./"${temp}"/tmp3.ba"

     	
    
    cat "./"${temp}"/tmp.ba"  >"./"${temp}"/tmp4.ba"
    
     
        

    foraneos=()
    while read line ; do
	
	foraneos+=("${ID[${CONTADOR}]}" """${line}""")  
	
	let CONTADOR+=1
	
    done <"./"${temp}"/tmp4.ba"


    while true; do

	exec 3>&1
	BUSQUEDA=$(dialog \
			--backtitle "CONTABILIDAD" \
			--title """CONSULTA STOCK""" \
			--clear \
			--cancel-label "SALIR" \
			--help-button \
			--help-label "DESCARGAR INFORMACION" \
			--menu "SELECCIONE EL CAMPO DE BUSQUEDA" 0 0 0 "${foraneos[@]}" \
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
		DATA_COMPOSC=""${RANDOM}"-"${DIA}".csv"
		
		mysql -u "${user}" --password="${pass}" --execute="${VAR_A}" | tr '\t' ';' >""${HOME}"/Dropbox/RODRIGO/ULTIMAS_ENTREGAS/"${DATA_COMPOSC}"" && dialog --msgbox "INFORMACION DISPONIBLE EN ARCHIVO: "${DATA_COMPOSC}"" 0 0
		exit 255;;
	    
	esac

	break
	
    done

    
    
}    


function transaccion {

    AGMYSQL=""${temp}"/"${RANDOM}".grabado"

    rm ${AGMYSQL}

    test -f "${AGMYSQL}" || touch "${AGMYSQL}"

      
    
    cat ""${HOME}"/Dropbox/RODRIGO/ULTIMAS_ENTREGAS/"${DATA_COMPOSC}"" | tail -n +2 | cut -d ',' -f1,3,4 | tr ',' '!' | sed "s/^/INSERT INTO CONTABLES (TIPO_REGISTRO,FECHA,REGISTRO) VALUES(\'/" | sed "s/$/\');/" | sed "s/!/\',\'/g" >>${AGMYSQL}


    bash ${scr}"transaccion.sh" "${AGMYSQL}" && dialog --msgbox "Operacion exitosa" 0 0
}


###############  SCRIPT ###########################

DATA_COMPOSC="REGISTROS-CONTABLES-"${DIA}".csv"

mysql -u "${user}" --password="${pass}" --execute="USE ${DB};SELECT rcoID AS ID,TIPO_COSTO,DATE(NOW()) AS 'ESTA FECHA DEBE CAER DENTRO DEL MES','MONTO TOTAL QUINCENAL' FROM TIPO_REGISTRO;" | tr '\t' ',' >""${HOME}"/Dropbox/RODRIGO/ULTIMAS_ENTREGAS/"${DATA_COMPOSC}"" && dialog --msgbox "INFORMACION DISPONIBLE EN ARCHIVO: "${DATA_COMPOSC}"" 0 0

dialog --msgbox "Efectue el registro de la informacion en el archivo creado y presione ENTER" 0 0


dialog --msgbox "La informacion fue guardada en el archivo con exito?" 0 0 


dialog --yesno "El programa Dropbox admite estar actualizado?" 0 0 


transaccion



################### MANTENIMIENTO ########################################

exit 192
