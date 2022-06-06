#!/bin/sh

############################################
# INICIO
# 
# by FH JDSU 10/2012
############################################

if [ $# -ne 1 ] 
then
   echo "Uso: $0 <arquivo de entrada>"
   exit
fi

arq_ent=$1

touch temp temp2 temp3 saida.csv
rm temp temp2 temp3 saida.csv
cp  $arq_ent temp2


existe_alarme=`grep "Alarm Log" temp2 | wc -l`

echo "Alarm Log;Unique ID;Date;Type;Status;Alarm" > saida.csv
while [ $existe_alarme -gt 0 ]
do
   # isolando o alarme e gerando arquivo temp com ele
   primeira_linha_alarme=`grep -n "Alarm Log" temp2 | head -1 | cut -d':' -f 1`
   ultima_linha_alarme=`expr $primeira_linha_alarme + 3`
   sed -n $primeira_linha_alarme,"$ultima_linha_alarme"p temp2 > temp

   # extraindo informacoes do arquivo temp e exportando para uma unica linha csv
   echo -n `cat temp | grep "Alarm Log" | cut -d':' -f 2`\; >> saida.csv
   echo -n `cat temp | grep "Unique ID" | cut -d':' -f 2`\; >> saida.csv
   echo -n `tail -2 temp | head -1 | awk '{ print $1" "$2" "$3";"$4";"} '` >> saida.csv
   echo -n `tail -2 temp | head -1 | cut -c43-`";" >> saida.csv
   tail -1 temp >> saida.csv
   
   # retirando o alarme do arquivo 
   ultima_linha_arquivo=`cat temp2 | wc -l`
   sed -n $ultima_linha_alarme,"$ultima_linha_arquivo"p temp2 > temp3
   rm temp temp2
   mv temp3 temp2
   existe_alarme=`grep "Alarm Log" temp2 | wc -l`
done

rm temp2
echo "Arquivo $1 processado. A saida encontra-se no arquivo saida.csv."
echo
