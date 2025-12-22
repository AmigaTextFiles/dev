
/* ($VER: MEM-EDIT.rexx_Version_00-00-10_Public_Domain_May_2009_B_Walker_G0LCU.) */

/* $VER: MEM-EDIT.rexx_Version_00-00-40_Public_Domain_June_2010_B_Walker_G0LCU. */

/* IMPORTANT! THIS IS DEMO CODE ONLY AND THERE IS LITTLE ERROR CORRECTION! */

/* This script works on OS2.0x too, NOT just OS3.xx. */

/* This is a DEMO only and dumps a 256 byte dump to 'S:<ADDRESS_TYPED_IN>'. */
/* A FULL standard AMIGA OS 3.0x install IS required for maximum usage. */

/* The 'T:' VOLUME MUST be assigned to a VALID 'VOLUME:Drawer', ('RAM:T'). */

/* It will also WRITE a single byte to a valid memory location, SO BEWARE!!! */

/* There ARE confirmation prompts to act as basic error checks throughout. */

/* Coded by Barry Walker, G0LCU. No copyright as it is offered as PD. */
/* Use ECHO for ordinary strings, and SAY for strings with variables inside. */

/* ---------------------------------------- */

/* Set up a basic startup screen... */
ECHO 'c'x
ECHO '$VER: MEM-EDIT.rexx_Version_00-00-40_PD_June_2010_B_Walker_G0LCU.'
ECHO ''
ECHO 'A simple hexadecimal memory EDITOR using standard ARexx for classic AMIGAs.'
ECHO 'SAVED memory dumps are to S:<ADDRESS_TYPED_IN> and of 256 bytes in size!'
ECHO ''
ECHO 'This is issued as Public Domain and donated by B.Walker, G0LCU...'
ECHO ''
ECHO 'The characters must be in the range 0123456789ABCDEF and there MUST be two or'
ECHO 'eight of them. Addresses and byte values are in hexadecimal AND leading zeros'
ECHO 'ARE important!!!'
ECHO ''
ECHO '!!!WARNING!!!'
ECHO '-------------'
ECHO ''
ECHO 'THERE IS LITTLE ERROR CORRECTION!!! THEREFORE ANY INPUTTING TYPOS MAY CAUSE'
ECHO 'AREXX TO STOP WITH AN ERROR REPORT _OR_ GENERATE A SERIOUS SYSTEM CRASH!!!'
ECHO ''
ECHO 'BE VERY AWARE OF THIS!!!'
CALL keyboardhold

/* ---------------------------------------- */

/* Set up general variables. */
checkforerror = 1
checkstring = ''
bytevalue = '00'
dumpstartaddress = '00FC0000'
dumpstring = ''
jobtodo = '0'
savefile = 'myfile'
simplecheck = 'Y'

/* Note the variable, <dumpstartaddresshex>, below, MUST be a string */
/* representation of a hexadecimal, preferably, EVEN address. */
/* The leading zero(s) and trailing 'x' ARE BOTH IMPORTANT!!! */
/* The DEMO address, '00FC0000', is inside the classic AMIGA ROM area. */
dumpstartaddresshex = '00FC0000'x

/* Similarly for the byte variable, <realbytehex>, below. */
realbytehex = '00'x

/* ---------------------------------------- */

/* Enter a hexadecimal address from '00000000' to '00FFFF00'. */
DO FOREVER
ECHO 'c'x
ECHO 'Hexadecimal memory reader and writer...'
ECHO ''
ECHO 'Type a number then <RETURN/ENTER>:-'
ECHO '-----------------------------------'
ECHO ''
ECHO '              (1) for a 256 byte memory dump to disk.'
ECHO '              (2) for a 256 byte memory read only.'
ECHO '              (3) for a SINGLE BYTE WRITE to memory.'
ECHO '              (4) for joining 2 or more binary files together.'
ECHO '              (5) for block clearing of memory to zeros, (NULLs).'
ECHO '              (6) for block filling of memory using values 00h to FFh.'
ECHO '              (7) for copying a block of memory to another location.'
ECHO ''
OPTIONS PROMPT '              (0) to QUIT:- '
PARSE UPPER PULL jobtodo
IF jobtodo = '0' THEN CALL getout
IF jobtodo = '1' THEN CALL saveandread
IF jobtodo = '2' THEN CALL readonly
IF jobtodo = '3' THEN CALL writebyte
/* Use ADDRESS COMMAND 'RX ?.rexx' instead of CALL '?.rexx'. */
IF jobtodo = '4' THEN ADDRESS COMMAND 'RX Join.rexx'
IF jobtodo = '5' THEN ADDRESS COMMAND 'RX MEM-CLEAR.rexx'
IF jobtodo = '6' THEN ADDRESS COMMAND 'RX MEM-FILL.rexx'
IF jobtodo = '7' THEN ADDRESS COMMAND 'RX MEM-COPY.rexx'
END

/* ---------------------------------------- */

/* Read a memory dump and auto-save to S:<ADDRESS_TYPED_IN>... */
saveandread:
CALL enteraddress
IF simplecheck ~= 'Y' THEN RETURN

/* Open up a filename to save to. */
OPEN(savefile, 'S:'||dumpstartaddress, 'W')
/* Save the filename... */
WRITECH(savefile, dumpstring)
/* Immediately close the file when dumped. */
CLOSE(savefile)

/* ---------------------------------------- */

/* Do a simple print to the screen of what is saved in hexadecimal */
/* ASCII readable format using AMIGADOS command 'Type'. */
readonly:
IF jobtodo = '2' THEN CALL enteraddress
IF simplecheck ~= 'Y' THEN RETURN
ECHO 'c'x
IF jobtodo = '1' THEN SAY 'File saved to the S: VOLUME as "[S:]'||dumpstartaddress||'"...'
IF jobtodo = '2' THEN SAY 'Memory start address is at $'||dumpstartaddress||', plus offset shown.'
ECHO ''
ECHO 'ASCII display of the hexadecimal dump of a 256 byte string...'
ECHO ''
IF jobtodo = '1' THEN ADDRESS COMMAND 'C:Type S:'||dumpstartaddress||' HEX'
IF jobtodo = '2' THEN CALL temporaryread
CALL keyboardhold
RETURN

/* ---------------------------------------- */

/* Do a temporary save to T: and read the contents... */
temporaryread:
/* Open up a temporary filename to save to... */
OPEN(savefile, 'T:'||dumpstartaddress, 'W')
/* Save the filename... */
WRITECH(savefile, dumpstring)
/* Immediately close the file when dumped. */
CLOSE(savefile)

/* Display contents of dump saved to T:. */
ADDRESS COMMAND 'C:Type T:'||dumpstartaddress||' HEX'
/* Delete the file when displayed. */
ADDRESS COMMAND 'C:Delete T:'||dumpstartaddress||' QUIET'
RETURN

/* ---------------------------------------- */

/* Manual hexadecimal memory address entry point... */
enteraddress:
ECHO 'c'x
OPTIONS PROMPT 'Enter a VALID hexadecimal address, (00FC0000<RETURN/ENTER>):- '
PARSE UPPER PULL dumpstartaddress
/* Do error checks on the hexadecimal string and CORRECT if ANY. */
IF LENGTH(dumpstartaddress) ~= 8 THEN dumpstartaddress = '00FC0000'
checkstring = ''
DO checkforerror = 1 TO 8
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "0" THEN checkstring = checkstring||"0"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "1" THEN checkstring = checkstring||"1"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "2" THEN checkstring = checkstring||"2"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "3" THEN checkstring = checkstring||"3"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "4" THEN checkstring = checkstring||"4"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "5" THEN checkstring = checkstring||"5"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "6" THEN checkstring = checkstring||"6"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "7" THEN checkstring = checkstring||"7"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "8" THEN checkstring = checkstring||"8"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "9" THEN checkstring = checkstring||"9"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "A" THEN checkstring = checkstring||"A"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "B" THEN checkstring = checkstring||"B"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "C" THEN checkstring = checkstring||"C"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "D" THEN checkstring = checkstring||"D"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "E" THEN checkstring = checkstring||"E"
  IF SUBSTR(dumpstartaddress, checkforerror, 1) = "F" THEN checkstring = checkstring||"F"
END
IF dumpstartaddress ~= checkstring THEN dumpstartaddress = '00FC0000'
ECHO ''
OPTIONS PROMPT 'Is "'||dumpstartaddress||'" correct? (Y/N<RETURN/ENTER>):- '
PARSE UPPER PULL simplecheck
IF simplecheck = 'Y' THEN CALL enteraddresscont
RETURN

/* If typed value is correct then carry on. */
enteraddresscont:
/* Convert the value to the contents of the address pointer... */
dumpstartaddresshex = X2C(dumpstartaddress)

/* Fetch the 256 byte binary string. */
dumpstring = IMPORT(dumpstartaddresshex, 256)
RETURN

/* ---------------------------------------- */

/* Write a single byte to memory. */
/* Ask for confirmation first! */
writebyte:
ECHO 'c'x
ECHO '!!!WARNING!!!'
ECHO ''
ECHO 'WRITING TO MEMORY CAN CAUSE A SERIOUS SYSTEM FALIURE!!!'
ECHO ''
OPTIONS PROMPT 'ARE YOU SURE YOU WANT TO CONTINUE?, (Y/N<RETURN/ENTER>):- '
PARSE UPPER PULL simplecheck
IF simplecheck = 'Y' THEN CALL writebytecont
RETURN

/* Continue after confirmation... */
writebytecont:
CALL enteraddress
IF simplecheck ~= 'Y' THEN RETURN

/* Display where the memory write will be. */
ECHO 'c'x
SAY 'Memory address to write to is $'||dumpstartaddress||'.'
ECHO ''
OPTIONS PROMPT 'Enter byte value in hexadecimal, for example, 7F<RETURN/ENTER>:- '
PARSE UPPER PULL bytevalue
/* Do error checks on the hexadecimal string and CORRECT if ANY. */
IF LENGTH(bytevalue) ~= 2 THEN bytevalue = 'FF'
checkstring = ''
DO checkforerror = 1 TO 2
  IF SUBSTR(bytevalue, checkforerror, 1) = "0" THEN checkstring = checkstring||"0"
  IF SUBSTR(bytevalue, checkforerror, 1) = "1" THEN checkstring = checkstring||"1"
  IF SUBSTR(bytevalue, checkforerror, 1) = "2" THEN checkstring = checkstring||"2"
  IF SUBSTR(bytevalue, checkforerror, 1) = "3" THEN checkstring = checkstring||"3"
  IF SUBSTR(bytevalue, checkforerror, 1) = "4" THEN checkstring = checkstring||"4"
  IF SUBSTR(bytevalue, checkforerror, 1) = "5" THEN checkstring = checkstring||"5"
  IF SUBSTR(bytevalue, checkforerror, 1) = "6" THEN checkstring = checkstring||"6"
  IF SUBSTR(bytevalue, checkforerror, 1) = "7" THEN checkstring = checkstring||"7"
  IF SUBSTR(bytevalue, checkforerror, 1) = "8" THEN checkstring = checkstring||"8"
  IF SUBSTR(bytevalue, checkforerror, 1) = "9" THEN checkstring = checkstring||"9"
  IF SUBSTR(bytevalue, checkforerror, 1) = "A" THEN checkstring = checkstring||"A"
  IF SUBSTR(bytevalue, checkforerror, 1) = "B" THEN checkstring = checkstring||"B"
  IF SUBSTR(bytevalue, checkforerror, 1) = "C" THEN checkstring = checkstring||"C"
  IF SUBSTR(bytevalue, checkforerror, 1) = "D" THEN checkstring = checkstring||"D"
  IF SUBSTR(bytevalue, checkforerror, 1) = "E" THEN checkstring = checkstring||"E"
  IF SUBSTR(bytevalue, checkforerror, 1) = "F" THEN checkstring = checkstring||"F"
END
IF bytevalue ~= checkstring THEN bytevalue = 'FF'
ECHO ''
OPTIONS PROMPT 'Is "'||bytevalue||'" correct? (Y/N<RETURN/ENTER>):- '
PARSE UPPER PULL simplecheck
IF simplecheck = 'Y' THEN CALL dowritebyte
RETURN

/* Do the write to memory!!! */
dowritebyte:
/* Convert the ASCII byte to the real HEX value. */
realbytehex = X2C(bytevalue)

/* Write a single hexadecimal byte to memory. */
EXPORT(dumpstartaddresshex, realbytehex, 1)

/* Read the BYTE, in LONGWORD form, from the changed address. */
dumpstring = IMPORT(dumpstartaddresshex, 4)

/* Display on screen the four contiguous bytes. */
ECHO 'c'x
SAY 'Address changed is $'||dumpstartaddress||', plus offset shown...'
ECHO ''
SAY '0000:  '||C2X(dumpstring)||'  for four bytes, (longword), only!'
CALL keyboardhold
RETURN

/* ---------------------------------------- */

/* Stop the display until the <RETURN/ENTER> key is pressed... */
keyboardhold:
ECHO ''
OPTIONS PROMPT 'Press <RETURN/ENTER> to continue:- '
PARSE UPPER PULL jobtodo
RETURN

/* ---------------------------------------- */

/* Clean exit... */
getout:
OPTIONS PROMPT ''
ECHO 'c'x
ECHO 'Click the CLOSE gadget to QUIT...'
ECHO ''
EXIT(0)
/* Program end. */
