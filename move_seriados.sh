#!/bin/sh


############################################
# INICIO
############################################

#diretorio onde os seriados sao baixados
dir_entrada='/downloads'

#diretorio raiz a partir de onde os seriados sao gravados
dir_saida='/seriados'


#Pesquisa por novos arquivos de seriados
lista_arquivos=`ls $dir_entrada | grep -v \.part`

for arquivo in $lista_arquivos 
do
   ###################
   # busca por Fringe
   if [ `echo $arquivo | grep -i 'Fringe' | wc -l` -eq 1 ]
   then
      indice=`expr index "$arquivo" '\([0-9][0-9]\)'`
      indice=`expr $indice + 1`
      ano=`echo $arquivo | cut -c$indice`
      diretorio="$dir_saida/Fringe/Season $ano"
      if [ ! -d "$diretorio" ]
      then
         mkdir -p "$diretorio"
      fi
      mv "$dir_entrada/$arquivo" "$diretorio"

   ###############################
   # busca por The Big Bang Theory
   elif [ `echo $arquivo | grep -i 'Bang' | wc -l` -eq 1 ]
   then
      indice=`expr index "$arquivo" '\([0-9][0-9]\)'`
      indice=`expr $indice + 1`
      ano=`echo $arquivo | cut -c$indice`
      diretorio="$dir_saida/TBBT/Season $ano"
      if [ ! -d "$diretorio" ]
      then
         mkdir -p "$diretorio"
      fi
      mv "$dir_entrada/$arquivo" "$diretorio"

   #################
   # busca por House
   elif [ `echo $arquivo | grep -i 'House' | wc -l` -eq 1 ]
   then
      indice=`expr index "$arquivo" '\([0-9][0-9]\)'`
      indice=`expr $indice + 1`
      ano=`echo $arquivo | cut -c$indice`
      diretorio="$dir_saida/House/Season $ano"
      if [ ! -d "$diretorio" ]
      then
         mkdir -p "$diretorio"
      fi
      mv "$dir_entrada/$arquivo" "$diretorio"
   
   fi
done
