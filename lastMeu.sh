#!/bin/bash

# AUTOR: PABLO SIERRA VERSION: 1.0
#--------------------------------------------
# lastMeu.sh
#--------------------------------------------
#############################################
#  Script para controlar el historico de 
#  comandos
#
# -u usuario # mostrará qué comandos ha 
#     ejecutado el usuario introducido y
#    cuando se han empezado a ejecutar.
# -c comando # mostrará quién ha ejecutado 
#     los comandos introducidos y cuándo
#    han empezado a ejecutarse.
# -d aammdd # mostrará los comandos de 
#     cualquier usuario iniciados en la
#    fecha solicitada
# -f  flag# mostrará los comandos que tienen 
#     activo el flag indicado (S,F,D,X)
#############################################


trap no_SIGINT SIGINT
trap no_SIGTERM SIGTERM
no_SIGINT()
{
echo "No está permitido el uso de SIGINT"
}
no_SIGTERM()
{
echo "No está permitido el uso de SIGTERM"
}
# Help
Help() 
  { 
  echo "Uso: $0 [-u usuari ] [-c 'comanda1 comada2'...] [-d aammdd] [-f flag]" 1>&2
  echo "FUNCION : Script para controlar el historico de comandos."
  echo "OPCIONES----------------------------"
  echo "-u      usuario # mostrará qué comandos ha ejecutado el usuario introducido y cuando se han empezado a ejecutar."  
  echo "-c      comando # mostrará quién ha ejecutado los comandos introducidos y cuándo han empezado a ejecutarse."   
  echo "-d      aammdd # mostrará los comandos de cualquier usuario iniciados en la fecha solicitada"
  echo "-f      flag # mostrará los comandos que tienen activo el flag indicado (S,F,D,X) "     
  
  exit 1
  }
  
 
usuario_bool=false
usuario_info=""
comando_bool=false
comando_info=""
fecha_bool=false
flag_info=""
flag_bool=false
# mes -- mes de la fecha
# CAR -- es el dia de la fecha
while getopts ":u:c:d:f:" op; do

    case "${op}" in
        u)
            lines=`sudo lastcomm --user ${OPTARG} | wc -l`
            if [ $lines -eq 0 ]
            then
              echo "Usuario ${OPTARG} no encontrado..."
              Help
            fi
            if [ $# -lt 3 ]
            then
              echo "USUARIO: "${OPTARG}
              echo "[COMANDO] --> [FECHA]"
              sudo lastcomm --user ${OPTARG} | awk '{print $1" --> "$(NF-3)" "$(NF-2)" "$(NF-1)" "$(NF)}'
            else
              usuario_bool=true
              usuario_info=${OPTARG}
            fi
            ;;
        c)  
          
        
            if [ $# -lt 3 ]
            then
              
              commands=$OPTARG
              for val in $commands
              do
                echo "COMANDO: "$val
                echo "[USUARIO] --> [FECHA]"
                sudo lastcomm --command $val | awk '{print $(NF-7)" --> "$(NF-3)" "$(NF-2)" "$(NF-1)" "$(NF)}'
              done
            else
              comando_bool=true
              comando_info=$OPTARG
            fi
            ;;
        d)
          fecha=$OPTARG
          last=${#fecha}
          
                  CAR=${fecha:2:2};
                  case "${CAR}" in
                    01)
                      mes="Jan";;
                    02)
                      mes="Feb";;
                    03)
                      mes="Mar";;
                    04)
                      mes="Apr";;
                    05)
                      mes="May";;
                    06)
                      mes="Jun";;
                    07)
                      mes="Jul";;
                    08)
                      mes="Aug";;
                    09)
                      mes="Sep";;
                    10)
                      mes="Oct";;
                    11)
                      mes="Nov";;
                    12)
                      mes="Dec";;
                    *)
                      echo "FECHA INCORRECTA"
                      Help;;   
                  esac
                  CAR=${fecha:4:2};
                  CAR=$(echo $CAR | sed 's/^0*//')
                  if [ $# -lt 3 ]
                  then
                    sudo lastcomm | grep -e $mes"  "$CAR -e $mes" "$CAR
                  else
                    fecha_bool=true
                  fi
                  ;;
        f)
           flag_info=$OPTARG
           if [ $# -lt 3 ]
           then
            sudo lastcomm | awk -v argu=$flag_info '$2 == argu'
           else
            flag_bool=true
           fi
           ;;
        :)
          echo "La opcion $OPTARG requiere un argumento"
          Help
          ;;
        
        *)
            Help
            ;;
    esac
done
if [ $usuario_bool == "true" ] && [ $comando_bool == "true" ] && [ $fecha_bool == "false" ] && [ $flag_bool == "false" ]
then
  echo "USUARIO Y COMANDO INPUTS"
  for val in $comando_info
  do
   echo "COMANDO: "$val
   echo "[USUARIO] --> [FECHA]"
   sudo lastcomm --command $val | grep $usuario_info | awk '{print $(NF-7)" --> "$(NF-3)" "$(NF-2)" "$(NF-1)" "$(NF)}'
  done
fi

if [ $usuario_bool == "true" ] && [ $fecha_bool == "true" ] && [ $comando_bool == "false" ] && [ $flag_bool == "false" ]
then
  echo "USUARIO Y FECHA INPUTS" 
  sudo lastcomm --user $usuario_info | grep -e $mes"  "$CAR -e $mes" "$CAR
fi

if [ $usuario_bool == "true" ] && [ $flag_bool == "true" ] && [ $fecha_bool == "false" ] && [ $comando_bool == "false" ]
then
  echo "USUARIO Y FLAG INPUTS"
  sudo lastcomm --user $usuario_info | awk -v argu=$flag_info '$2 == argu'
fi

if [ $fecha_bool == "true" ] && [ $comando_bool == "true" ] && [ $usuario_bool == "false" ] && [ $flag_bool == "false" ]
then
  echo "FECHA Y COMANDO INPUTS"
  for val in $comando_info
  do
   echo "COMANDO: "$val
   echo "[USUARIO] --> [FECHA]"
   sudo lastcomm --command $val | grep -e $mes"  "$CAR -e $mes" "$CAR | awk '{print $(NF-7)" --> "$(NF-3)" "$(NF-2)" "$(NF-1)" "$(NF)}'
  done 
fi

if [ $flag_bool == "true" ] && [ $comando_bool == "true" ] && [ $fecha_bool == "false" ] && [ $usuario_bool == "false" ]
then
  echo "FLAG Y COMANDO INPUTS"
  for val in $comando_info
  do
   echo "COMANDO: "$val
   sudo lastcomm --command $val | awk -v argu=$flag_info '$2 == argu'
  done
fi

if [ $fecha_bool == "true" ] && [ $flag_bool == "true" ] && [ $comando_bool == "false" ] && [ $usuario_bool == "false" ]
then
  echo "FECHA Y FLAG INPUTS"
  sudo lastcomm | grep -e $mes"  "$CAR -e $mes" "$CAR | awk -v argu=$flag_info '$2 == argu'
fi

if [ $usuario_bool == "true" ] && [ $comando_bool == "true" ] && [ $fecha_bool == "true" ] && [ $flag_bool == "false" ]
then
  echo "USUARIO, COMANDO Y FECHA INPUTS"
  for val in $comando_info
  do
   echo "COMANDO: "$val
   echo "[USUARIO] --> [FECHA]"
   sudo lastcomm --command $val | grep $usuario_info | grep -e $mes"  "$CAR -e $mes" "$CAR | awk '{print $(NF-7)" --> "$(NF-3)" "$(NF-2)" "$(NF-1)" "$(NF)}'
  done
fi

if [ $usuario_bool == "true" ] && [ $comando_bool == "true" ] && [ $flag_bool == "true" ] && [ $fecha_bool == "false" ]
then
  echo "USUARIO, COMANDO Y FLAG INPUTS"
  for val in $comando_info
  do
   echo "COMANDO: "$val
   sudo lastcomm --command $val | grep $usuario_info | awk -v argu=$flag_info '$2 == argu'
  done
fi

if [ $flag_bool == "true" ] && [ $comando_bool == "true" ] && [ $fecha_bool == "true" ] && [ $usuario_bool == "false" ]
then
  echo "FLAG, COMANDO Y FECHA INPUTS"
  for val in $comando_info
  do
   echo "COMANDO: "$val
   sudo lastcomm --command $val | awk -v argu=$flag_info '$2 == argu' | grep -e $mes"  "$CAR -e $mes" "$CAR
  done
fi

if [ $usuario_bool == "true" ] && [ $flag_bool == "true" ] && [ $fecha_bool == "true" ] && [ $comando_bool == "false" ]
then
  echo "USUARIO, FLAG Y FECHA INPUTS"
  sudo lastcomm --user $usuario_info | awk -v argu=$flag_info '$2 == argu' | grep -e $mes"  "$CAR -e $mes" "$CAR
fi

if [ $usuario_bool == "true" ] && [ $flag_bool == "true" ] && [ $fecha_bool == "true" ] && [ $comando_bool == "true" ]
then
  echo "USUARIO, FLAG, FECHA Y COMANDO INPUTS"
  for val in $comando_info
  do
   echo "COMANDO: "$val
   sudo lastcomm --command $val | grep $usuario_info | grep -e $mes"  "$CAR -e $mes" "$CAR | awk -v argu=$flag_info '$2 == argu'
  done
fi
shift $((OPTIND -1))
exit 0

