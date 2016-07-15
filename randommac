
#!/bin/bash
RANGE=255
#set integer ceiling

number=$RANDOM
numbera=$RANDOM
numberb=$RANDOM
#generate random numbers

let "number %= $RANGE"
let "numbera %= $RANGE"
let "numberb %= $RANGE"
#ensure they are less than ceiling

octets='00-60-2F'
#set mac stem

octeta=`echo "obase=16;$number" | bc`
octetb=`echo "obase=16;$numbera" | bc`
octetc=`echo "obase=16;$numberb" | bc`
#use a command line tool to change int to hex(bc is pretty standard)
#they're not really octets.  just sections.

macadd="${octets}-${octeta}-${octetb}-${octetc}"
#concatenate values and add dashes

echo $macadd
#echo result to screen
#note: need to figure out how to generate a leading zero, and pad any results that are single chars.
