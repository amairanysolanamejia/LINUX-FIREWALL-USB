#!/bin/bash
# -*- ENCODING: UTF-8 -*-
#Este script debe ejecutarse cuando se conecta una nueva usb al sistema.
#Para ello, debe ejecutar como superusuario (sudo sh script.sh)
#Programa hecho por Casillas Muñoz, D.A. y por Solana Mejía, H.A.
#Como aún no hemos descubierto la manera de demonizarlo, el código
#está pensado bajo la suposición de que para proteger la computadora /media/ 
#carece de permisos para usuarios convencionales (700) y además el automontaje
#está desactivado (aunque se pueda montar fácilmente con el entorno gráfico 
#de GNOME, es un detalle que falta solucionar.
listanegra=/bin/listanegra.txt #Variable que almacena la lista negra
listablanca=/bin/listablanca.txt #Variable que almacena la whitelist
usuario=$(whoami) #Define como variable al usuario mismo
memoria= #Definir como variable la memoria USB conectada, tomando como referencia su número de serie para identificarla (pendiente...)
echo "$usuario"
echo "Identifiquese como root antes de usar la USB\nSi falla su autenticación de usuario, /media/ continuará bloqueado hasta que\nsu administrador acuda e intente conectar la USB."
if [ $(whoami) != "root" ];#Esta parte aún no funciona :/
  then
    if [ $(grep -c $memoria $listablanca) -ne 0 ];#Se verifica si la memoria ya está en alguna lista (en este caso, la lista blanca)
     then
      #En esta parte del ciclo se describirá qué debe suceder si la USB conectada ya está en la whitelist
    fi
    else
      if [ $(grep -c $memoria $listanegra) -ne 0 ];
       then
        #Por el contrario, aquí se tendrá que describir qué pasará cuando se encuentre en la blacklist
        exit 0;
      fi
fi

if [ $(whoami) != "root" ]; #A partir de aquí, el código se ejecuta si la USB es una unidad o reconocida
  then
    echo "Has fallado en la autenticación. Ejecuta este script con permisos de superusuario para usar tu USB"
  else
    echo "¿Conoces la USB que conectaste o al menos confías en ella? (si/no)"
    read eleccion
    if [ $eleccion = si ];
      then
        echo "Tu dispositivo será añadido a la lista blanca."
        #Aquí básicamente haremos que el dispositivo sea añadido a la whitelist, lo montaremos y permitiremos al usuario que la use
        exit 0;
      elif [ $eleccion = no ];then
        echo "Presiona 1 para añadir el dispositivo a una lista negra"
        echo "Presiona 2 para ignorar el dispositivo (esta opción mantendrá"
        echo "/media/ sin permisos y no montará la USB)"
        read adiosohastapronto #La variable se llama así porque dependiendo de su valor, la memoria será vetada permanentemente o sólo ignorada.
        case $adiosohastapronto in
          1)
            echo "El dispositivo se añadió a la lista negra.\nLos permisos permanecen sólo para el administrador."
            #aquí, añadiremos el dispositivo a la blacklist para que sea vetada del sistema
          2)
            #la idea es mencionar un mensaje de salida e ignorar el dispositivo conectado
          *) 
            echo "Presiona 1 o 2";;
        esac
    fi
fi
exit 0
