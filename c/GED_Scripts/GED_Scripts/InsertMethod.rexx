/* $VER: InsertMethod.rexx 1.0 (20.12.98)       */
/* Freeware, ©1998 Christian Hattemer           */
/* email: Chris@mail.riednet.wh.tu-darmstadt.de */
/*                                              */
/* Inserts a blank Method                       */

options results                             /* enable return codes     */

if (left(address(), 6) ~= "GOLDED") then    /* not started by GoldEd ? */

    address 'GOLDED.1'

'LOCK CURRENT RELEASE=4'                    /* lock GUI, gain access   */

if (RC ~= 0) then

    exit

options failat 6                            /* ignore warnings         */

signal on syntax                            /* ensure clean exit       */

/* ---------------------- INSERT YOUR CODE HERE ---------------------- */

'QUERY FILE VAR=Filename'
Classname = LEFT(Filename, LASTPOS('.c', Filename) -1)

'SET NAME=INSERT VALUE=TRUE'

'FIRST'
            
'OPEN NAME="GoldED:add-ons/stormc/rexx/InsertMethod.data" INSERT'
'DOWN'
'PING SLOT 0'
'FIND STRING="_Data" NEXT'
'TEXT T="'Classname'"'

'PONG SLOT 0'
'FIND STRING="_(" NEXT'
'TEXT T="'Classname'"'
'RIGHT'

/* ------------------------- END OF YOUR CODE ------------------------ */

'UNLOCK'                                    /* unlock GUI              */

exit

SYNTAX:

SAY "Error in line" SIGL ":" ERRORTEXT(RC)

'UNLOCK'
