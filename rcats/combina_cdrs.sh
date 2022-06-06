#!/bin/sh

############################################
#
# script para pegar os cdrs obtidos a partir dos logs
# e preencher os campos de hora das chamadas de curta duracao (T1, T2 e T3)
# obtidas a partir do export via ODBC da tabela T_CallTable do BD do Rcats
#
# by FH JDSU 11/2012
############################################

dir_entrada='/cdrs_db'

if [ $# -ne 1 ] 
then
   echo "Uso: $0 <DDMMAA>"
   exit
fi

ddmmyy=$1

cdrs_log=/cdrs_log/cdrs_log_$ddmmyy.csv 
cdrs_db=$dir_entrada/cdrs_db_$ddmmyy.csv

if [ ! -f $cdrs_log ]
then
   echo Erro! Arquivo $cdrs_log nao existe!
   echo Gere-o antes com o script extrai_cdrs DDMMAA
   exit
fi

if [ ! -f $cdrs_db ]
then
   echo Erro! Arquivo $cdrs_db nao existe!
   echo Gere-o antes atraves de exportacao do DB do Rcats no Excel, via ODBC!
   exit
fi

# arquivo de saida, no diretorio /cdrs_finais
arq_saida=/cdrs_finais/cdrs_$ddmmyy.csv
touch $arq_saida
rm $arq_saida
touch $arq_saida

cdrs=`cat $cdrs_db`

for cdr in $cdrs
do
   # pegando hora de desconexao e verificando se eh nula
   call_end_time_db=`echo $cdr | cut -d';' -f 7`
   if [ "$call_end_time_db" == "" ] 
   then
      # se for nula, pegar os horarios de answer e desconexao do arquivo de logs 
      call_start_time_db=`echo $cdr | cut -d';' -f 1`

      # pega answer time, com precisao de segundos
      call_answer_time_log=`grep $call_start_time_db $cdrs_log | cut -d";" -f4 | cut -c1-8`
      # para precisao de mili-segundos, usar:
      # call_answer_time_log=`grep $call_start_time_db $cdrs_log | cut -d";" -f4`
      # pega end time, com precisao de segundos
      call_end_time_log=`grep $call_start_time_db $cdrs_log | cut -d";" -f5 | cut -c1-8`
      # para precisao de mili-segundos, usar:
      # call_end_time_log=`grep $call_start_time_db $cdrs_log | cut -d";" -f5`

      echo -n `echo $cdr | cut -d";" -f1-6` >> $arq_saida
      echo -n ";"$call_end_time_log";" >> $arq_saida
      echo -n `echo $cdr | cut -d";" -f8-11` >> $arq_saida
      echo -n ";"$call_answer_time_log";" >> $arq_saida
      echo $cdr | cut -d";" -f13-14 >> $arq_saida

   else
      # se nao, simplesmente imprimir a linha sem modificacoes
      echo $cdr >> $arq_saida
   fi
done

echo O arquivo de cdrs esta em: $arq_saida
