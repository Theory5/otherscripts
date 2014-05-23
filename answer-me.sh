#!/bin/bash
# PURPOSE: Demonstrate how to read the answer to a question and take different actions for each response
# DEPENDENCIES: N/A
# DELIVERABLES: N/A
#. /opt/process-locking/process-locking-header.sh
#. /opt/disaster-recovery/monitor/push.source
#	
function Usage () {
cat <<EOF
USAGE:  $0 [-s]
	-s short options only
	-d Use a default value of y/yes on enter
        Asks a question and executes different commands based on your response.
        For demonstration purposes only.
EOF
}
# To add options: add the character to getopts and add the option to the case statement.
# Options with an argument must have a : following them in getopts.  The value is stored in OPTARG
# The lone : at the start of the getopts suppresses verbose error messages from getopts.
while getopts ":hsd" Option; do
	case ${Option} in

		s )	LONGOPTIONS="False";;

		d )	DEFAULT_YES="True";;

# Options are terminated with ;;

		h )	Usage 1>&2
			exit 0;;

		# This * ) option must remain last.  Any options past this will be ignored.
		* )	echo "ERROR: Unexpected argument: ${OPTARG}" 1>&2
			Usage 1>&2
			exit 1;;

	esac
done

# This function will allow you to repeat the question until you get a valid answer
function AnswerMe () {
	read -n1 -p "Answer the question with y/Y or n/N:" RESPONSE
	if [ "${DEFAULT_YES:-False}" = "True" ] && [ -z "$RESPONSE" ]; then
		RESPONSE="${RESPONSE:=Y}"
	else
		# echo is used here because read stops at the first character and does not
		# have a newline at the end of the prompt.
		echo
	fi
	#Force RESPONSE to uppercase, case is still preserved in the variable
	case ${RESPONSE^^} in
		Y )	echo You responded with $RESPONSE;;
		N )	echo You responded with $RESPONSE;;
		* )	echo Invalid response: $RESPONSE, try again;
			AnswerMe;;
	esac
}
# This function will allow both long and short options y and yes, n and no
function LongAnswerMe () {
	read -p "Answer the question with y/yes or n/no (case insensitive):" RESPONSE
	#Force REPONSE to lowercase, case is still preserved in the variable
	if [ "${DEFAULT_YES:-False}" = "True" ] && [ -z "$RESPONSE" ]; then
		RESPONSE="${RESPONSE:=Yes}"
	fi
	case ${RESPONSE,,} in
		y|yes )	echo You responded with $RESPONSE;;
		n|no )	echo You responded with $RESPONSE;;
		* )	echo Invalid response: $RESPONSE, try again;
			LongAnswerMe;;
	esac
}
# Use default value True for LONGOPTIONS if LONGOPTIONS is empty or not set
if [ "${LONGOPTIONS:-True}" = "True" ]; then
	LongAnswerMe
else
	AnswerMe
fi
#. /opt/process-locking/process-locking-footer.sh
