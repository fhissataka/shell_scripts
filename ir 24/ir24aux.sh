# /bin/sh 
# programa auxiliar ir24aux
# parametros de entrada:
# $1 = diretorio de trabalho
# $2 = arquivo de saida

seleciona_arquivo()
{
   arquivo=`grep -l "$1[+-z]\{1,40\} Test Case Started" $dir_trabalho/* | tail -1` 
   # nao achou o teste em nenhum arquivo; cria arquivo nulo para nao travar
   if [ `echo $arquivo | wc -c` -lt 2 ]
   then
      touch $dir_trabalho/empty
      arquivo=$dir_trabalho/empty
   fi
}

pega_data()
{
   dateoftest=""
   # se o nome do arquivo é valido pega a data do nome do arquivo
   if [ `echo $1 | wc -c` -gt 30 ]
   then
      tam_nome_arq=`echo $arquivo | wc -c`
      inicio_data=`expr $tam_nome_arq - 19`
      fim_data=`expr $tam_nome_arq - 5`
      data=`echo $1 | cut -c $inicio_data-$fim_data`
      ano=20`echo $data | cut -c1,2`
      mes=`echo $data | cut -c3,4`
      dia=`echo $data | cut -c5,6`
      dateoftest=$dia/$mes/$ano
   fi
}

###########################################################################
# Inicio do script
###########################################################################

dir_trabalho=$1
signature=`cat $2 | grep Signature | cut -d';' -f 2`
# dateoftest=`cat $2 | grep "Date of test" | cut -d';' -f 2`

# 2.1.3
echo "------------------------------------"
echo "Teste;2.1.3"

seleciona_arquivo IR24_2.1.3 

# (b) number keyed
num=`cat $arquivo | grep IR24_2.1.3 | grep "Dialing" | awk '{print $5}'`
echo "Number keyed;$num"

# TimeStart / TimeEnd
start=`cat $arquivo | grep IR24_2.1.3 | grep "Dialing" | awk '{print $1}' | CUT -c 1-8`
end=`cat $arquivo | grep IR24_2.1.3 | grep "Phone status = <2>" | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of call;$start"
echo "Time of perceived answer;$end"

# Time Hangup / Time Answer
answer=`cat $arquivo | grep IR24_2.1.3 | grep "Answer Phone 1B" | head -1 | awk '{print $1}' | CUT -c 1-8`
hangup=`cat $arquivo | grep IR24_2.1.3 | grep "Hang Up" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of Answer;$answer"
echo "Time of Hang Up;$hangup"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.1.3 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"

# IR 2.1.4
echo "------------------------------------"
echo "Teste;2.1.4"

# (b) Number keyed
seleciona_arquivo IR24_2.1.4
num=`cat $arquivo | grep IR24_2.1.4 | grep "Dialing Number" | awk '{print $5}'`
echo "Number keyed;$num"

# (c) Time of start of successfull call (SEND)
start=`cat $arquivo | grep IR24_2.1.4 | grep "Dialing Number" | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of call;$start"

# (e) Time of perceived call
answer=`cat $arquivo | grep IR24_2.1.4 | grep "Answer Phone" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of perceived answer;$answer"

# Time Hangup / Time Answer
answer=`cat $arquivo | grep IR24_2.1.4 | grep "Phone status = <1>" | awk '{print $1}' | CUT -c 1-8`
hangup=`cat $arquivo | grep IR24_2.1.4 | grep "Hang Up" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of Answer;$answer"
echo "Time of Hang Up;$hangup"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.1.4 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"

# IR 2.1.5
echo "------------------------------------"
echo "Teste;IR 2.1.5"

# (b) Number keyed
seleciona_arquivo IR24_2.1.5 
num=`cat $arquivo | grep IR24_2.1.5 | grep "Dialing Number" | awk '{print $5}'`
echo "Number keyed;$num"

# (c) Time of start of call (SEND)
start=`cat $arquivo | grep IR24_2.1.5 | grep "Dialing Number" | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of call;$start"

# (d) Time of not reachable
nr=`cat $arquivo | grep IR24_2.1.5 | grep "DELAY" | awk '{print $1}' | CUT -c 1-8`
echo "Time of perceived answer;$nr"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.1.5 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


# IR 2.1.6
echo "------------------------------------"
echo "Teste;IR 2.1.6"

# (b) Number keyed 
seleciona_arquivo IR24_2.1.6 
num=`cat $arquivo | grep IR24_2.1.6 | grep "Dialing Number" | awk '{print $5}'`
echo "Number keyed;$num"

# (c) Time of start of call (SEND)
start=`cat $arquivo | grep IR24_2.1.6 | grep "DIAL NUMBER" | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of call;$start"

# (d) Time of not reachable
nr=`cat $arquivo | grep IR24_2.1.6 | grep "STEP9" | awk '{print $1}' | CUT -c 1-8`
echo "Time of perceived answer;$nr"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.1.6 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


# IR 2.2.1
echo "------------------------------------"
echo "Teste;IR 2.2.1"

# (b) Time of activation of BAOC
seleciona_arquivo IR24_2.2.1 
enable=`cat $arquivo | grep IR24_2.2.1 | grep "Last Cmd Time" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of activation of BAOC;$enable"

# (c) Time of start of emergency call 
time_start=`cat $arquivo | grep IR24_2.2.1 | grep "Dialing Number <112>" | awk '{print $1}'`
echo "Time of start of emergency call;$time_start"

# (e) Time of perceived answer of call
start=`cat $arquivo | grep IR24_2.2.1 | grep "Phone status"| head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of perceived answer of call;$start"

# (f) End of call
end=`cat $arquivo | grep IR24_2.2.1 | grep "Hang Up" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of hang up;$end"

# (h) PSTN number keyed
nr=`cat $arquivo | grep IR24_2.2.1 | grep "Dialing Number" | tail -1 | awk '{print $5}'`
echo "PSTN number keyed;$nr"

# Time of deactivation of BAOC
enable=`cat $arquivo | grep IR24_2.2.1 | grep "Last Cmd Time" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of deactivation of BAOC;$enable"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.2.1 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


# IR 2.2.2
echo "------------------------------------"
echo "Teste;IR 2.2.2"

# (b) Time of activation of BOIC
seleciona_arquivo IR24_2.2.2 
enable=`cat $arquivo | grep IR24_2.2.2 | grep "Last Cmd Time" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of activation of BOIC;$enable"

# (c) Operator Service Number of PSTN(b) number keyed
osnr=`cat $arquivo | grep IR24_2.2.2 | grep "Dialing Number" | head -1 | awk '{print $5}'` 
echo "PSTN number keyed;$osnr"

# (d) Time of start of national PSTN call
time_start=`cat $arquivo | grep IR24_2.2.2 | grep "Dialing Number" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of national PSTN call;$time_start"

# (e) Time of MS(a) receiving alert indication
alert=`cat $arquivo | grep IR24_2.2.2 | grep "Phone status ="| head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of MS(a) receiving alert indication;$alert"

# (f) Time of perceived answer of call
answer=`cat $arquivo | grep IR24_2.2.2 | grep "Answer Phone" | awk '{print $1}' | CUT -c 1-8`
echo "Time of perceived answer of call;$answer"

# (g) End of call
end=`cat $arquivo | grep IR24_2.2.2 | grep "Hang Up" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of hang up;$end"

# (i) Home PLMN Country number keyed
home=`cat $arquivo | grep IR24_2.2.2 | grep "Dialing Number" | tail -1 | awk '{print $5}'` 
echo "Home PLMN Country number keyed;$home"

# (k) Time of deactivation of BOIC
enable=`cat $arquivo | grep IR24_2.2.2 | grep "Last Cmd Time" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of deactivation of BOIC;$enable"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.2.2 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


# IR 2.2.3
echo "------------------------------------"
echo "Teste;IR 2.2.3"

# (c II) Time of activation of BOICexHC
seleciona_arquivo IR24_2.2.3 
enable=`cat $arquivo | grep IR24_2.2.3 | grep "Last Cmd Time" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of activation of BOICexHC;$enable"

# (d) Home PSTN Country number keyed
home=`cat $arquivo | grep IR24_2.2.3 | grep "Dialing Number" | head -2 | tail -1 | awk '{print $5}'` 
echo "PSTN number keyed;$home"

# (e) Time of start of home PSTN country call
time_start=`cat $arquivo | grep IR24_2.2.3 | grep "Dialing Number" | head -2 | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of home PSTN country call;$time_start"

# (f) Time of perceived answer of call
answer=`cat $arquivo | grep IR24_2.2.3 | grep "Answer" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of perceived answer of call;$answer"

# (g) End of call
end=`cat $arquivo | grep IR24_2.2.3 | grep "Hang Up Phone 1A" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of hang up;$end"

# chamada para numero local
# (h) PSTN number of the country keyed, where MS(A) is presently located
home=`cat $arquivo | grep IR24_2.2.3 | grep "Dialing Number" | head -1 | awk '{print $5}'` 
echo "PSTN number of the country keyed;$home"

# (i) Time of start of call within the country where the MS(A) is presently
time_start=`cat $arquivo | grep IR24_2.2.3 | grep "Dialing Number"| head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of call within the country;$time_start"

# (j) Time of perceived answer of call
answer=`cat $arquivo | grep IR24_2.2.3 | grep "Answer Phone" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of perceived answer of call;$answer"

# (k) Hang-up time, for chargable call duration
hangup=`cat $arquivo | grep IR24_2.2.3 | grep "Hang Up Phone 1A" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of hang up;$hangup"

# (l) International number keyed
home=`cat $arquivo | grep IR24_2.2.3 | grep "Dialing Number" | tail -1 | awk '{print $5}'` 
echo "International number keyed;$home"

# (n) Time of deactivation of BOICexHC
disable=`cat $arquivo | grep IR24_2.2.3 | grep "Last Cmd Time" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of deactivation of BOICexHC;$disable"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.2.3 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


echo "------------------------------------"
echo "Teste;IR 2.2.4"

# (b) Time of activation of BAIC
seleciona_arquivo IR24_2.2.4 
enable=`cat $arquivo | grep IR24_2.2.4 | grep "Last Cmd Time" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of activation of BAIC;$enable"

# (d) PSTN number keyed
nr=`cat $arquivo | grep IR24_2.2.4 | grep "Dialing Number" | tail -1 | awk '{print $5}'`
echo "PSTN number keyed;$nr"

# (n) Time of deactivation of BAIC
disable=`cat $arquivo | grep IR24_2.2.4 | grep "Last Cmd Time" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of deactivation of BAIC;$disable"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.2.4 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


echo "------------------------------------"
echo "Teste;IR 2.2.5"

# (b) Time of activation of CFNRc
seleciona_arquivo IR24_2.2.5 
enable=`cat $arquivo | grep IR24_2.2.5 | grep "Last Cmd Time" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of activation of CNFRc;$enable"

# (d) DN forwarded to
forw=`cat $arquivo | grep IR24_2.2.5 | grep "Dialing Feature" | head -1 | awk '{print $6}'`
forw=`echo $forw | cut -d* -f3 | cut -d# -f1`
echo "DN forwarded to;<$forw>"

# (e) Time of start of call
start=`cat $arquivo | grep IR24_2.2.5 | grep "Dialing Number" | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of call;$start"

# (e2) Time ring
ring=`cat $arquivo | grep IR24_2.2.5 | grep "Wait For Event STATUS" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of ring;$ring"


# (fg) Time of perceived answer 
answer=`cat $arquivo | grep IR24_2.2.5 | grep "Phone status" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of perceived answer;$answer"

# (h) Time of hang up
hangup=`cat $arquivo | grep IR24_2.2.5 | grep "Hang Up" | awk '{print $1}' | CUT -c 1-8`
echo "Time of hangup;$hangup"

# (n) Time of deactivation of CFNRc
disable=`cat $arquivo | grep IR24_2.2.5 | grep "Last Cmd Time" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of deactivation of CFNRc;$disable"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.2.5 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


echo "------------------------------------"
echo "Teste;IR 2.2.6"

# (b) Time of activation of CFNRc
seleciona_arquivo IR24_2.2.6 
enable=`cat $arquivo | grep IR24_2.2.6 | grep "Last Cmd Time" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of activation of CNFRc;$enable"

# (d) DN forwarded to
forw=`cat $arquivo | grep IR24_2.2.6 | grep "Dialing Feature" | head -1 | awk '{print $6}'`
forw=`echo $forw | cut -d* -f3 | cut -d# -f1`
echo "DN forwarded to;<$forw>"

# (e) Time of start of call
start=`cat $arquivo | grep IR24_2.2.6 | grep "Dialing Number" | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of call;$start"

# (e2) Time ring
ring=`cat $arquivo | grep IR24_2.2.6 | grep "Wait For Event STATUS" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of ring;$ring"

# (f) Time of answer
answer=`cat $arquivo | grep IR24_2.2.6 | grep "Phone status" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of answer;$answer"

# (h) Time of hang up
hangup=`cat $arquivo | grep IR24_2.2.6 | grep "Hang Up" | awk '{print $1}' | CUT -c 1-8`
echo "Time of hangup;$hangup"

# (n) Time of deactivation of CFNRc
disable=`cat $arquivo | grep IR24_2.2.6 | grep "Last Cmd Time" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of deactivation of CFNRc;$disable"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.2.6 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


echo "------------------------------------"
echo "Teste;IR 2.2.7"

# (b) Time of activation of CFB
seleciona_arquivo IR24_2.2.7 
enable=`cat $arquivo | grep IR24_2.2.7 | grep "Last Cmd Time" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of activation of CFB;$enable"

# (d) DN forwarded to
forw=`cat $arquivo | grep IR24_2.2.7 | grep "Dialing Feature" | head -1 | awk '{print $6}'`
forw=`echo $forw | cut -d* -f3 | cut -d# -f1`
echo "DN forwarded to;<$forw>"

# (e) Party with which MS(a1) is in conversation
party=`cat $arquivo | grep IR24_2.2.7 | grep "Dialing Number" | head -1 | awk '{print $5}'` 
echo "Party with which MS(a1) is in conversation;$party"

# (f) Time of start of call
start=`cat $arquivo | grep IR24_2.2.7 | grep "Dialing Number" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of call;$start"

# (g) Time ring
ring=`cat $arquivo | grep IR24_2.2.7 | grep "Wait For Event STATUS" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of ring;$ring"

# (h) Time of answer
answer=`cat $arquivo | grep IR24_2.2.7 | grep "Phone status" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of answer;$answer"

# (i) Time of hang up
hangup=`cat $arquivo | grep IR24_2.2.7 | grep "Hang Up" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of hangup;$hangup"

# (n) Time of deactivation of CFB
disable=`cat $arquivo | grep IR24_2.2.7 | grep "Last Cmd Time" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of deactivation of CFB;$disable"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.2.7 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


echo "------------------------------------"
echo "Teste;IR 2.2.8"

# (b) Time of activation of CFNRY
seleciona_arquivo IR24_2.2.8 
enable=`cat $arquivo | grep IR24_2.2.8 | grep "Last Cmd Time" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of activation of CFNRY;$enable"

# (d) Time of start of SS activity
start=`cat $arquivo | grep IR24_2.2.8 | grep "QUERY Services" | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of SS;$start"

# (e) Time of display information
display=`cat $arquivo | grep IR24_2.2.8 | grep "CFNRy" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of display information;$display"

# (f) Information Displayed
info=`cat $arquivo | grep IR24_2.2.8 | grep "CFNRy" | cut -d, -f3`
echo "Information Displayed;<$info>"

# (i) DN forwarded to (same as above)
echo "DN forwarded to;<$info>"

# (j) Time of start of call
start=`cat $arquivo | grep IR24_2.2.8 | grep "Dialing Number" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of start of call;$start"

# (g) Time of ring
ring=`cat $arquivo | grep IR24_2.2.8 | grep "Phone status" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of ring;$ring"

# (m) Time of perceived answer call
answer=`cat $arquivo | grep IR24_2.2.8 | grep "Phone status" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of answer;$answer"

# (n) Time of hang up
hangup=`cat $arquivo | grep IR24_2.2.8 | grep "Hang Up" | awk '{print $1}' | CUT -c 1-8`
echo "Time of hangup;$hangup"

# (n) Time of deactivation of CFNRY
disable=`cat $arquivo | grep IR24_2.2.8 | grep "Last Cmd Time" | tail -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of deactivation of CCFNR;$disable"

# Teste Passou? 
passed=`cat $arquivo | grep IR24_2.2.8 | grep "Test Case Passed!!" | awk '{print $5}'`
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"


echo "------------------------------------"
echo "Teste;IR 2.3.1"

seleciona_arquivo IR24_2.3.1 

# (b) E164 address
e164=`cat $arquivo | grep IR24_2.3.1 | grep Response | cut -d \| -f 2`
e164="<"$e164
echo "E164 address;$e164"


# (c) Time of transmitting to SMS Service Center
send=`cat $arquivo | grep IR24_2.3.1 | grep "Send Time" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of transmitting;$send"

# (d) MSISDN of MS2(a)
msisdn=`cat $arquivo | grep IR24_2.3.1 | grep "Sending SMS" | awk '{print $9}'`
echo "MSISDN of MS2(a);$msisdn"

# (e) Time of switching on MS2(A)
switch=`cat $arquivo | grep IR24_2.3.1 | grep "VERIFY CMTMSG" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of switching on MS2(A);$switch"

# (e) Time of receipt of SMS
receipt=`cat $arquivo | grep IR24_2.3.1 | grep "Set message" | head -1 | awk '{print $1}' | CUT -c 1-8`
echo "Time of receipt of SMS;$receipt"
echo "Result;$passed"

# Tester & date
pega_data $arquivo
echo "Signature of tester;$signature"
echo "Date of test;$dateoftest"
echo "------------------------------------"
