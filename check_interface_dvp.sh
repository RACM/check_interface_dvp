#!/bin/bash
#
#-Ruben Calzadilla
##################

#Interface name attribute
INT=$1

if [ -z $INT ]; then
    echo " "
    echo "which interface?"
    echo "Example check_interface_dvp eth0.2998"
    echo " "
    exit 1
fi

  echo " "
  echo "----- Press Control+C to Quit -----"
  echo " "

#Average measurement time in seconds
TIMEDELTA=5

#8 bits per Byte
let BPB=8

#Result on Kbps
MEG=$( echo ${TIMEDELTA} | awk '{print $1*1000}')


#infinite loop probing the interface
while true
do

  RES1=`/bin/cat /sys/class/net/${INT}/statistics/rx_bytes` > /dev/null 2>&1
  TES1=`/bin/cat /sys/class/net/${INT}/statistics/tx_bytes` > /dev/null 2>&1

  sleep ${TIMEDELTA}

  RES2=`/bin/cat /sys/class/net/${INT}/statistics/rx_bytes` > /dev/null 2>&1
  TES2=`/bin/cat /sys/class/net/${INT}/statistics/tx_bytes` > /dev/null 2>&1

  RX1=`echo ${RES1}`
  RX2=`echo ${RES2}`
  TX1=`echo ${TES1}`
  TX2=`echo ${TES2}`

  RXD=`expr ${RX2} - ${RX1}`
  TXD=`expr ${TX2} - ${TX1}`

  RXBITS=$(echo $RXD | awk '{print $1*8}')
  TXBITS=$(echo $TXD | awk '{print $1*8}')
  RXT=`expr ${RXBITS} / ${MEG}`
  TXT=`expr ${TXBITS} / ${MEG}`

  echo " -----------------------------------------------------------------------------" 
  printf "|%-15s|%-30s|%-30s|\n" " ${INT}" " Transmitting ${TXT} Kbps" " Receiving ${RXT} Kbps"
  echo " -----------------------------------------------------------------------------" 

done

exit 0
