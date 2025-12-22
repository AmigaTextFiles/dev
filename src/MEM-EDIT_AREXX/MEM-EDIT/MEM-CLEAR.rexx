
/* DEMO ARexx script to clear a block of memory. */
/* As part of the MEM-EDIT_AREXX.lha archive. Issued as Public Domain */
/* July 2009, B.Walker, G0LCU. */
/* $VER: MEM-CLEAR.rexx_Version_00-00-30_Public_Domain_July_2009_B.Walker_G0LCU. */

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
clearstartaddress = '00070000'

/* Note the variable, <clearstartaddresshex>, below, MUST be a string */
/* representation of a hexadecimal, preferably, EVEN address. */
/* The leading zero(s) and trailing 'x' ARE BOTH IMPORTANT!!! */
/* !!!The DEMO address, '00070000', is inside the classic AMIGA RAM area!!! */
clearstartaddresshex = '00070000'x

/* Use the default window. */
ECHO 'c'x
ECHO 'This DEMO script will WRITE a series of zeros, (0), to a VALID RAM address.'
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
PARSE UPPER PULL clearstartaddress
/* Do error checks on the hexadecimal string and QUIT if ANY. */
IF LENGTH(clearstartaddress) ~= 8 THEN CALL getout
DO checkforerror = 1 TO 8
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "0" THEN checkstring = checkstring||"0"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "1" THEN checkstring = checkstring||"1"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "2" THEN checkstring = checkstring||"2"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "3" THEN checkstring = checkstring||"3"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "4" THEN checkstring = checkstring||"4"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "5" THEN checkstring = checkstring||"5"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "6" THEN checkstring = checkstring||"6"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "7" THEN checkstring = checkstring||"7"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "8" THEN checkstring = checkstring||"8"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "9" THEN checkstring = checkstring||"9"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "A" THEN checkstring = checkstring||"A"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "B" THEN checkstring = checkstring||"B"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "C" THEN checkstring = checkstring||"C"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "D" THEN checkstring = checkstring||"D"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "E" THEN checkstring = checkstring||"E"
  IF SUBSTR(clearstartaddress, checkforerror, 1) = "F" THEN checkstring = checkstring||"F"
END
IF clearstartaddress ~= checkstring THEN CALL getout
ECHO ''
OPTIONS PROMPT 'Is "'||clearstartaddress||'" correct? (Y/N<RETURN/ENTER>):- '
PARSE UPPER PULL nothing
IF nothing ~= 'Y' THEN CALL getout

/* Display where the memory write will be. */
ECHO 'c'x
SAY 'Memory address to write to is $'||clearstartaddress||'.'
ECHO ''
OPTIONS PROMPT 'Enter number of bytes to clear, for example, 13<RETURN/ENTER>:- '
PARSE UPPER PULL numberofbytes
ECHO ''
/* Do error checks and QUIT if ANY. */
IF numberofbytes < 1 THEN CALL getout
IF numberofbytes > 16 THEN CALL getout
OPTIONS PROMPT 'Is "'||numberofbytes||'" correct? (Y/N<RETURN/ENTER>):- '
PARSE UPPER PULL nothing
IF nothing ~= 'Y' THEN CALL getout

/* Convert the string to a hexadecimal address... */
clearstartaddresshex = X2C(clearstartaddress)

/* Do the write to valid RAM memory... */
EXPORT(clearstartaddresshex, '00'x, numberofbytes, '00'x)

ECHO 'c'x
SAY numberofbytes||' byte(s) of cleared memory starting at address $'||clearstartaddress||'.'
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
