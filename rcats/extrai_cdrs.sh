#!/bin/sh

############################################
# INICIO
# 
# by FH JDSU 11/2012
############################################

dir_entrada='/logs'
#job_header='CPQD_CENARIO'
job_header='M2M'
imsi2msisdn='/rcats/imsi_to_msisdn'

touch temp temp2 temp3 

if [ $# -ne 1 ] 
then
   echo "Uso: $0 <DDMMAA>"
   exit
fi

ddmmyy=$1

dia_aux=`echo $1 | cut -c1,2`
mes_aux=`echo $1 | cut -c3,4`
ano_aux=`echo $1 | cut -c5,6`

data="$ano_aux$mes_aux$dia_aux"

arq_saida=/cdrs_log/cdrs_log_$ddmmyy.csv
touch $arq_saida
rm $arq_saida
echo "numA;numB;startTime;answerTime;CallEndTime" > $arq_saida

# pesquisa de logs
lista_arquivos=`ls $dir_entrada/*Job*$data*.log`
#echo $lista_arquivos
for arquivo in $lista_arquivos
do
   # so arquivos com testes que passaram
   if [ `grep 'Test Case Passed' $arquivo | wc -l` -ge 5 ]
   then

      # pega imsi a do cabecalho
      aux=`grep -n "PSIM on 1A" $arquivo | cut -d':' -f 1 `
      aux2=`expr $aux + 1`
      imsiA=`head -$aux2 $arquivo | tail -1 | cut -d ' ' -f 5 | cut -c1-15`
      msisdnA=`grep $imsiA $imsi2msisdn | awk '{print $2'}` 

      # pega imsi b do cabecalho
      aux=`grep -n "PSIM on 1B" $arquivo | cut -d':' -f 1 `
      aux2=`expr $aux + 1`
      imsiB=`head -$aux2 $arquivo | tail -1 | cut -d ' ' -f 5 | cut -c1-15`
      msisdnB=`grep $imsiB $imsi2msisdn | awk '{print $2'}` 

      # tirando tudo o que nao eh de test case
      grep $job_header $arquivo > temp

      existe_chamada=`grep "Test Case Passed" temp | wc -l`
      while [ $existe_chamada -gt 0 ]
      do
         primeira_linha_chamada=`grep -n "Test Case Started" temp | head -1 | cut -d':' -f 1`
         ultima_linha_chamada=`grep -n "Test Case Passed" temp | head -1 | cut -d':' -f 1`
         head -$ultima_linha_chamada temp | tail -`expr $ultima_linha_chamada - $primeira_linha_chamada` > temp2

         # processar o temp2
         dial_time=`cat temp2 | grep DialTime | awk '{print $6}'| cut -c1-12`
         dial_time_hhmmss=`echo $dial_time | cut -c1-8` 
	 dial_time_ms=`echo $dial_time | cut -c10-12`
         start_time=`cat temp2 | grep AllocateTime | awk '{print $8}'| cut -c1-12`
         start_time_hhmmss=`echo $start_time | cut -c1-8`
         start_time_ms=`echo $start_time | cut -c10-12`
         # echo $start_time
         end_time=`cat temp2 | grep "Send Command <t" | head -1 | cut -c1-8`
         rm temp2

         # retirando o teste do arquivo temp
         num_linhas=`wc -l temp | awk '{print $1}'`
         tail -`expr $num_linhas - $ultima_linha_chamada` temp > temp3
         mv temp3 temp

         existe_chamada=`grep "Test Case Passed" temp | wc -l`

         echo "$msisdnA;$msisdnB;$dial_time_hhmmss,$dial_time_ms;$start_time_hhmmss,$start_time_ms;$end_time" >> $arq_saida
      done
      rm temp
   fi
 
done
