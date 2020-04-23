#!/bin/bash

#$cmFle="[/path/to/my/]common.func"
#-f "$cmFle" && . [/path/to/my/]common.func

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

inputFile="/home/pi/rastemppi/w1/last_speedtest_result";
resultFile="/home/pi/rastemppi/w1/Data_Speedtest";
speedtest --json > $inputFile;

#if [[ -f "$inputFile" ]]; then
#    fErr("$inputFile")
#    echo "Tiedot Haettu"
#if

#if [[ ! -f "${inputFile}" ]]; then
#    fErr("$inputFile")
#if

value=$(<"$inputFile")

ts=$( echo $value | jq '.timestamp' | sed 's/"//g' | sed 's/T/ /' | sed 's/Z//')
sec=$(TZ="UTC" date +'%s' -d "$ts")
ts=$(TZ="Europe/Helsinki" date -d "@$sec" "+%Y-%m-%d %H:%M:%S")

dl=$( echo $value | jq '.download')
dl=${dl%.*}
#if [${#dl} -gt 6]; then
    dl=${dl::${#dl}-6}.${dl:${#dl}-6:2}
#else
#    dl=0.${dl:${#dl}-6:2}
#fi

ul=$( echo $value | jq '.upload')
ul=${ul%.*}
#if [${#ul} -gt 6]; then
    ul=${ul::${#ul}-6}.${ul:${#ul}-6:2}
#else
#    ul=0.${ul:${#ul}-6:2}
#fi

if [[ ! -f "$resultFile" ]]; then

    echo "[timestamp,download,upload]" > $resultFile
    echo ",[$ts,$dl,$ul]" >> $resultFile

else

    echo ",[$ts,$dl,$ul]" >> $resultFile

fi

echo "[$ts,$dl,$ul]" 

#if [[ ! -f $resultFile ]]; then
#    fErr($resultFile)
#fi



exit_handler;
