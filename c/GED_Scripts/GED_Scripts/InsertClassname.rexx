/* $VER: InsertClassname.rexx 1.2 (23.08.99)    */
/* Freeware, ©1998 Christian Hattemer           */
/* email: Chris@mail.riednet.wh.tu-darmstadt.de */
/*                                              */
/* Inserts the Name of the Class                */

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

Pos = LASTPOS('.c', Filename) - 1
if (Pos = -1) then
do
   Pos = LASTPOS('.h', Filename) - 1
end

Classname = LEFT(Filename, Pos)

'SET NAME=INSERT VALUE=TRUE'

'TEXT T="'Classname'"'

/* ------------------------- END OF YOUR CODE ------------------------ */

'UNLOCK'                                    /* unlock GUI              */

exit

SYNTAX:

SAY "Error in line" SIGL ":" ERRORTEXT(RC)

'UNLOCK'
