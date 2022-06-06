#!/bin/sh

limpa_arquivo()
{
   rm $dir_trabalho/temp1 $dir_trabalho/temp2 2> /dev/null
   mv $1 $dir_trabalho/temp2

   sed -e '/^[-\!\#\+\%\*]/d' $dir_trabalho/temp2 > $dir_trabalho/temp1

   limpo=`grep "Test Case Failed" $dir_trabalho/temp1 | grep -v "%%" | wc -l`
   while [ $limpo -ne 0 ]
   do
        linha=`grep -n "Test Case Failed" $dir_trabalho/temp1 | grep -v "%%" | head -1`
        linha_final=`echo $linha | cut -d':' -f 1`
        num_teste=`echo $linha | cut -d',' -f 2 | awk '{print $1}'`
        linha_inicial=`grep -n "$num_teste Test Case Started" $dir_trabalho/temp1 | head -1 | cut -d':' -f 1`
        sed "$linha_inicial,$linha_final d" < $dir_trabalho/temp1 > $dir_trabalho/temp2
        mv $dir_trabalho/temp2 $dir_trabalho/temp1
        limpo=`grep "Test Case Failed" $dir_trabalho/temp1 | grep -v "%%" | wc -l`
   done

   limpo=`grep "Test Case Non-Determined" $dir_trabalho/temp1 | grep -v "%%" | wc -l`
   while [ $limpo -ne 0 ]
   do
        linha=`grep -n "Test Case Non-Determined" $dir_trabalho/temp1 | grep -v "%%" | head -1`
        linha_final=`echo $linha | cut -d':' -f 1`
        num_teste=`echo $linha | cut -d',' -f 2 | awk '{print $1}'`
        linha_inicial=`grep -n "$num_teste Test Case Started" $dir_trabalho/temp1 | head -1 | cut -d':' -f 1`
        sed "$linha_inicial,$linha_final d" < $dir_trabalho/temp1 > $dir_trabalho/temp2
        mv $dir_trabalho/temp2 $dir_trabalho/temp1
        limpo=`grep "Test Case Non-Determined" $dir_trabalho/temp1 | grep -v "%%" | wc -l`
   done

   mv $dir_trabalho/temp1 $1
   rm $dir_trabalho/temp2 2> /dev/null
}

pega_data()
{
   # se o nome do arquivo é valido pega a data do nome do arquivo
   if [ `echo $1 | wc -c` -gt 10 ]
   then
      tam_nome_arq=`echo $arquivo | wc -c`
      inicio_data=`expr $tam_nome_arq - 19`
      fim_data=`expr $tam_nome_arq - 14`
      data=`echo $1 | cut -c $inicio_data-$fim_data`
   fi
}


############################################
# INICIO
############################################

query_file='/work/log_users.txt'
#dir_entrada='/cygdrive/c/atpusers/administrator/data/logs'
dir_entrada='/work/logs'
dir_saida='/work'
dir_trabalho='/work_temp'
resp='/work/resposta.txt'
dir_waves='/cygdrive/c/Inetpub/wwwroot/RCATSQoSDirector/ftproot/Administrator/data/VoiceData'
signature=`grep '0\:' $query_file | cut -d':' -f 2 | awk '{print $1}'`


rm $dir_trabalho/* 2> /dev/null

pais=`grep '1\:' $query_file | cut -d':' -f 2 | awk '{print $1}'`
operadora=`grep '2\:' $query_file | cut -d':' -f 2 | awk '{print $1}'`
probe=`grep '3\:' $query_file | cut -d':' -f 2 | awk '{print $1}'`
imsi=`grep '4\:' $query_file | cut -d':' -f 2 | awk '{print $1}'`
msisdn=`grep '5\:' $query_file | cut -d':' -f 2 | awk '{print $1}'`
imsib=`grep '6\:' $query_file | cut -d':' -f 2 | awk '{print $1}'`
msisdnb=`grep '7\:' $query_file | cut -d':' -f 2 | awk '{print $1}'`
msisdn_vivo=`grep '8\:' $query_file | cut -d':' -f 2 | awk '{print $1}'`

# echo -e "Dados a partir de: <DDMMYY>   \c"
# read data_aux
# dia_aux=`echo $data_aux | cut -c1,2`
# mes_aux=`echo $data_aux | cut -c3,4`
# ano_aux=`echo $data_aux | cut -c5,6`
# data_inicio="$ano_aux""$mes_aux""$dia_aux"

dia_aux=`date +'%d'`
mes_aux=`date +'%m'`
ano_aux=`date +'%g'`

if [ $mes_aux -eq 1 ]
then
   mes_aux=12
   ano_aux=`expr $ano_aux - 1`
   if [ $ano_aux -lt 10 ]
   then
      ano_aux="0$ano_aux"
   fi
else
   mes_aux=`expr $mes_aux - 1`
fi

if [ $mes_aux -lt 10 ]
then
   mes_aux="0$mes_aux"
fi

data_inicio="$ano_aux$mes_aux$dia_aux"

# pesquisa de logs
lista_arquivos=`ls $dir_entrada/*$pais*$operadora*$probe*.log`
#echo $lista_arquivos
for arquivo in $lista_arquivos 
do
   if [ `grep 'Test Case Passed' $arquivo | wc -l` -ge 2 ]
   then
      pega_data $arquivo
      if [ $data -ge $data_inicio ]
      then
         cp $arquivo $dir_trabalho
      fi
   fi
done

# limpeza de arquivos
if [ `ls $dir_trabalho/*$pais*$operadora*$probe*.log | wc -l ` -gt 0 ]
then
   lista_arquivos=`ls $dir_trabalho/*$pais*$operadora*$probe*.log`
   for arquivo in $lista_arquivos
   do
      limpa_arquivo $arquivo
   done
else
   echo "2 Nao foram encontrados logs correspondentes. Verifique a pesquisa." > $resp
   exit
fi

#echo -e "Nome do arquivo de saida: \c"
#read arquivo

arquivo_saida=$dir_saida/"$pais"_"$operadora"_"$probe".csv
#echo $arquivo_saida
rm $arquivo_saida 2> /dev/null
echo "Signature of tester;$signature;---" > $arquivo_saida
echo "Date of report;`date '+%2d/%2m/%Y'`;---" >> $arquivo_saida

/ir24aux $dir_trabalho $arquivo_saida >> $arquivo_saida
echo "IMSI A;<$imsi>" >> $arquivo_saida
echo "MSISDN A;<$msisdn>" >> $arquivo_saida
echo "MSISDN Vivo;<$msisdn_vivo>" >> $arquivo_saida
echo "IMSI B;<$imsib>" >> $arquivo_saida

echo "1 $arquivo_saida" > $resp

# Copiando arquivos WAV do 2.1.5 
# num_total_linhas=`wc -l $arquivo_saida | awk '{ print $1}'`
# inicio_215=`grep -n 2.1.5 $arquivo_saida |  cut -d':' -f 1`
# offset=`expr $num_total_linhas - $inicio_215`
# hora_215=`tail -$offset $arquivo_saida | head -6 | grep answer | cut -d';' -f 2 | cut -d':' -f1`
# data_215=`tail -$offset $arquivo_saida | head -6 | grep Date | cut -d';' -f 2`
# ano_215=`echo $data_215 | cut -d'/' -f 3`
# mes_215=`echo $data_215 | cut -d'/' -f 2`
# dia_215=`echo $data_215 | cut -d'/' -f 1`
# echo Arquivos .WAV correspondentes ao horario do teste 215:
# cd $dir_waves
# ls -1 *215_$ano_215$mes_215$dia_215$hora_215*.wav
# cp $dir_waves/*215_$ano_215$mes_215$dia_215$hora_215*.wav $dir_saida
# echo "Os arquivos acima foram copiados parao diretorio /resultados"
# echo


# Copiando arquivos WAV do 2.1.6 
# num_total_linhas=`wc -l $arquivo_saida | awk '{ print $1}'`
# inicio_216=`grep -n 2.1.6 $arquivo_saida |  cut -d':' -f 1`
# offset=`expr $num_total_linhas - $inicio_215`
# hora_216=`tail -$offset $arquivo_saida | head -6 | grep answer | cut -d';' -f 2 | cut -d':' -f1`
# data_216=`tail -$offset $arquivo_saida | head -6 | grep Date | cut -d';' -f 2`
# ano_216=`echo $data_215 | cut -d'/' -f 3`
# mes_216=`echo $data_215 | cut -d'/' -f 2`
# dia_216=`echo $data_215 | cut -d'/' -f 1`
# echo Arquivos .WAV correspondentes ao horario do teste 216:
# cd $dir_waves
# ls -1 *216_$ano_216$mes_216$dia_216$hora_216*.wav
# cp $dir_waves/*216_$ano_216$mes_216$dia_216$hora_216*.wav $dir_saida
# echo "Os arquivos acima foram copiados par ao diretorio /resultados"
# echo

# chmod 666 $dir_saida/*.wav
