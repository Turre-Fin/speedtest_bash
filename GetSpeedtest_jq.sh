#!/bin/bash

#$cmFle="[/path/to/my/]common.func"
#-f "$cmFle" && . [/path/to/my/]common.func
#$cmFle="common.func"
#-f "$cmFle" && source "common.func"

fErr() {
  echo "input file '$1' not found! Exiting."
  echo "Speedtest not delivering data."
  exit 1
}


exit_handler() {
    if [[ -f "$inputFile" ]]; then
        #rm -f "$inputFile"
        echo "En poistakkaan"
    fi
}


inputFile="/home/pi/rastemppi/w1/last_speedtest_result"
resultFile="/home/pi/rastemppi/w1/Data_Speedtest"
speedtest --json > $inputFile

#!-f "$inputFile" && fErr "$inputFile"

value=$(<"$inputFile")

ts=$( echo $value | jq '.timestamp' | sed 's/"//g' | sed 's/T/ /' | sed 's/Z//')
sec=$(TZ="UTC" date +'%s' -d "$ts")
ts=$(TZ="Europe/Helsinki" date -d "@$sec" "+%Y-%m-%d %H:%M:%S")

dl=$( echo $value | jq '.download')
dl=${dl%.*}
#dl=$( echo $value | jq '.download')
#dlMb=$(echo "scale=2;$dl/1024" | bc -l)
dl=$(echo "scale=2;$dl/1048576" | bc -l | sed 's/^\./0\./')
#dl=$(echo "scale=2;$dl/1048576" | bc -l )
#dl=echo ${'dl//#\./0\./'}


ul=$( echo $value | jq '.upload')
ul=${ul%.*}
#if [${#ul} -gt 6] && ulMb=$(echo "scale=2;$ul/1048576" | bc -l) || ulMb=$(echo "scale=2;$ul/1024" | bc -l)
#ulMb=$(echo "scale=2;$ul/1024" | bc -l)
ul=$(echo "scale=2;$ul/1048576" | bc -l | sed 's/^\./0\./')
#ul=$(echo "scale=2;$ul/1048576" | bc -l )
#ul=echo ${'ul//#\./0\./'}

if [[ ! -f "$resultFile" ]]; then

    //echo '{"resultData":[["timestamp","download","upload"]' > $resultFile
    echo '{"resultData":[["'$ts'",'$dl','$ul']' >> $resultFile

else

    echo ',["'$ts'",'$dl','$ul']' >> $resultFile

fi

#!-f "$resultFile" && fErr "$resultFile"

echo '["'$ts'",'$dl','$ul']'

