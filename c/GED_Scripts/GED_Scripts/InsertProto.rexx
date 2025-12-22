/* $VER: InsertProto.rexx 1.2 (12.01.99)        */
/* Freeware, ©1998-99 Christian Hattemer        */
/* email: Chris@mail.riednet.wh.tu-darmstadt.de */
/*                                              */
/* Inserts a Method Prototype                   */

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

/* Singe * must be written as ** because GoldEd uses them as Esc */

'TEXT STAY T="METHOD _(Class **cl, Object **obj, Msg msg);"'
'GOTO COLUMN=8'
'TEXT T="'Classname'"'
'RIGHT'

/* ------------------------- END OF YOUR CODE ------------------------ */

'UNLOCK'                                    /* unlock GUI              */

exit

SYNTAX:

SAY "Error in line" SIGL ":" ERRORTEXT(RC)

'UNLOCK'
