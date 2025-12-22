/* $VER: Reference.rexx 1.0 (29.12.98)          */
/* Freeware, ©1998 Christian Hattemer           */
/* email: Chris@mail.riednet.wh.tu-darmstadt.de */
/*                                              */
/* Calls GoldED's XREF Function with the word   */
/* under the Cursor. If nothing is found it     */
/* tries again with an A appended to the end of */
/* the search word.                             */

options results                             /* enable return codes     */

if (left(address(), 6) ~= "GOLDED") then    /* not started by GoldEd ? */

    address 'GOLDED.1'

'LOCK CURRENT RELEASE=4'                    /* lock GUI, gain access   */

if (RC ~= 0) then

    exit

options failat 6                            /* ignore warnings         */

signal on syntax                            /* ensure clean exit       */

/* ---------------------- INSERT YOUR CODE HERE ---------------------- */

'SET NAME=HIDE VALUE=TRUE'

'XREF CURRENT PROTECT'

if (RC ~= 0) then do
   'QUERY WORD VAR=Searchword'
   Searchword = Searchword||"A"
   'XREF PHRASE="'Searchword'" PROTECT'
end

'SET NAME=HIDE VALUE=FALSE'

/* ------------------------- END OF YOUR CODE ------------------------ */

'UNLOCK'                                    /* unlock GUI              */

exit

SYNTAX:

SAY "Error in line" SIGL ":" ERRORTEXT(RC)

'UNLOCK'
