
/* DEMO ARexx script to fill a block of memory with values from 00h to FFh. */
/* As part of the MEM-EDIT_AREXX.lha archive. Issued as Public Domain */
/* August 2009, B.Walker, G0LCU. */
/* $VER: MEM-FILL.rexx_Version_00-00-40_Public_Domain_August_2009_B.Walker_G0LCU. */

/* !!!WARNING!!! */

/* THERE IS SOME ERROR DETECTION IN THIS CODE - HOWEVER BEWARE!!! */

/* It is deliberately limited to a maximum of 16 bytes for this DEMO but it */
/* can easily be changed as required as this code is Public Domain. */

/* Use ECHO for normal printing and SAY for printing with variables inside. */

/* Set up required variables... */
checkforerror = 1
checkstring = ''
nothing = ''
numberofbytes = 1
fillstartaddress = '00070000'
fillvalue = '00'

/* Note the variable, <fillstartaddresshex>, below, MUST be a string */
/* representation of a hexadecimal, preferably, EVEN address. */
/* The leading zero(s) and trailing 'x' ARE BOTH IMPORTANT!!! */
/* !!!The DEMO address, '00070000', is inside the classic AMIGA RAM area!!! */
fillstartaddresshex = '00070000'x

/* Similarly for the byte <fillvaluehex> below. */
fillvaluehex = '00'x

/* Use the default window. */
ECHO 'c'x
ECHO 'This DEMO script will WRITE a series of bytes to a VALID RAM address.'
ECHO 'It is LIMITED to a maximum of 16 bytes but as the code IS Public Domain it'
ECHO 'is simple to make it much larger.'
ECHO ''
ECHO '!!!WARNING!!!'
ECHO ''
ECHO 'THIS IS A DANGEROUS TOOL, SO YOU USE IT AT YOUR OWN RISK. THERE IS LITTLE'
ECHO 'ERROR DETECTION OR CORRECTION SO AN INCORRECT TYPO MAY GENERATE AN ERROR'
ECHO 'AND _STOP_ THE SCRIPT AT BEST OR CAUSE A SERIOUS SYSTEM CRASH AT WORST!!!'
ECHO 'SO BE VERY AWARE OF THIS...'
ECHO ''
OPTIONS PROMPT 'Press <RETURN/ENTER> to continue:- '
PARSE UPPER PULL nothing

/* Ask for confirmation first! */
ECHO 'c'x
ECHO '!!!WARNING!!!'
ECHO ''
ECHO 'WRITING TO MEMORY CAN CAUSE A SERIOUS SYSTEM FALIURE!!!'
ECHO ''
OPTIONS PROMPT 'ARE YOU SURE YOU WANT TO CONTINUE?, (Y/N<RETURN/ENTER>):- '
PARSE UPPER PULL nothing
IF nothing ~= 'Y' THEN CALL getout

/* Manual hexadecimal memory address entry point... */
ECHO 'c'x
OPTIONS PROMPT 'Enter a VALID hexadecimal address, (00FC0000<RETURN/ENTER>):- '
PARSE UPPER PULL fillstartaddress
/* Do error checks on the hexadecimal string and QUIT if ANY. */
IF LENGTH(fillstartaddress) ~= 8 THEN CALL getout
DO checkforerror = 1 TO 8
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "0" THEN checkstring = checkstring||"0"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "1" THEN checkstring = checkstring||"1"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "2" THEN checkstring = checkstring||"2"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "3" THEN checkstring = checkstring||"3"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "4" THEN checkstring = checkstring||"4"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "5" THEN checkstring = checkstring||"5"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "6" THEN checkstring = checkstring||"6"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "7" THEN checkstring = checkstring||"7"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "8" THEN checkstring = checkstring||"8"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "9" THEN checkstring = checkstring||"9"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "A" THEN checkstring = checkstring||"A"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "B" THEN checkstring = checkstring||"B"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "C" THEN checkstring = checkstring||"C"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "D" THEN checkstring = checkstring||"D"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "E" THEN checkstring = checkstring||"E"
  IF SUBSTR(fillstartaddress, checkforerror, 1) = "F" THEN checkstring = checkstring||"F"
END
IF fillstartaddress ~= checkstring THEN CALL getout
ECHO ''
OPTIONS PROMPT 'Is "'||fillstartaddress||'" correct? (Y/N<RETURN/ENTER>):- '
PARSE UPPER PULL nothing
IF nothing ~= 'Y' THEN CALL getout

/* Input the byte value to be used to fill. */
checkstring = ''
ECHO 'c'x
OPTIONS PROMPT 'Enter byte value in hexadecimal, for example, 7F<RETURN/ENTER>:- '
PARSE UPPER PULL fillvalue
/* Do error checks on the hexadecimal string and QUIT if ANY. */
IF LENGTH(fillvalue) ~= 2 THEN CALL getout
DO checkforerror = 1 TO 2
  IF SUBSTR(fillvalue, checkforerror, 1) = "0" THEN checkstring = checkstring||"0"
  IF SUBSTR(fillvalue, checkforerror, 1) = "1" THEN checkstring = checkstring||"1"
  IF SUBSTR(fillvalue, checkforerror, 1) = "2" THEN checkstring = checkstring||"2"
  IF SUBSTR(fillvalue, checkforerror, 1) = "3" THEN checkstring = checkstring||"3"
  IF SUBSTR(fillvalue, checkforerror, 1) = "4" THEN checkstring = checkstring||"4"
  IF SUBSTR(fillvalue, checkforerror, 1) = "5" THEN checkstring = checkstring||"5"
  IF SUBSTR(fillvalue, checkforerror, 1) = "6" THEN checkstring = checkstring||"6"
  IF SUBSTR(fillvalue, checkforerror, 1) = "7" THEN checkstring = checkstring||"7"
  IF SUBSTR(fillvalue, checkforerror, 1) = "8" THEN checkstring = checkstring||"8"
  IF SUBSTR(fillvalue, checkforerror, 1) = "9" THEN checkstring = checkstring||"9"
  IF SUBSTR(fillvalue, checkforerror, 1) = "A" THEN checkstring = checkstring||"A"
  IF SUBSTR(fillvalue, checkforerror, 1) = "B" THEN checkstring = checkstring||"B"
  IF SUBSTR(fillvalue, checkforerror, 1) = "C" THEN checkstring = checkstring||"C"
  IF SUBSTR(fillvalue, checkforerror, 1) = "D" THEN checkstring = checkstring||"D"
  IF SUBSTR(fillvalue, checkforerror, 1) = "E" THEN checkstring = checkstring||"E"
  IF SUBSTR(fillvalue, checkforerror, 1) = "F" THEN checkstring = checkstring||"F"
END
IF fillvalue ~= checkstring THEN CALL getout
ECHO ''
OPTIONS PROMPT 'Is "'||fillvalue||'" correct? (Y/N<RETURN/ENTER>):- '
PARSE UPPER PULL nothing
IF nothing ~= 'Y' THEN CALL getout

/* Convert the ASCII byte to the real HEX value. */
fillvaluehex = X2C(fillvalue)

/* Display where the memory write will be. */
ECHO 'c'x
SAY 'Memory start address to write to is $'||fillstartaddress||', byte value '||fillvalue||'h.'
ECHO ''
OPTIONS PROMPT 'Enter number of bytes to fill, for example, 13<RETURN/ENTER>:- '
PARSE UPPER PULL numberofbytes
ECHO ''
IF numberofbytes < 1 THEN CALL getout
IF numberofbytes > 16 THEN CALL getout
OPTIONS PROMPT 'Is "'||numberofbytes||'" correct? (Y/N<RETURN/ENTER>):- '
PARSE UPPER PULL nothing
IF nothing ~= 'Y' THEN CALL getout

/* Convert the string to a hexadecimal address... */
fillstartaddresshex = X2C(fillstartaddress)

/* Do the write to valid RAM memory... */
EXPORT(fillstartaddresshex, fillvaluehex, numberofbytes, fillvaluehex)

ECHO 'c'x
SAY numberofbytes||' byte(s), (value '||fillvalue||'h), of memory filled, starting at address $'||fillstartaddress||'.'
ECHO ''
OPTIONS PROMPT 'Press <RETURN/ENTER> to continue:- '
PARSE UPPER PULL nothing
ECHO 'c'x

/* Clean exit. */
getout:
OPTIONS PROMPT ''
ECHO 'c'x
ECHO 'Closing down...'
ECHO ''
ECHO 'Left click on the CLOSE gadget if required!'
EXIT(0)
/* Program End. */
