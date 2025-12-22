/*   $VER: GoFetchRexx.rexx 1.2 (24.2.96)
**
**   ARexx script to invoke FetchRefs from Shell (using rx).
*/

/* Set some options of ARexx */
OPTIONS RESULTS
OPTIONS FAILAT 21

/* Get the search strings */
PARSE ARG function

/* Define a temporary filename to put the reference into */
cutat = VERIFY(function, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890_")
filename = 'T:FR_' || LEFT(function, MAX(0, cutat - 1))

/* It doesn't matter whether we want a taglist, varargs og whatever function */
IF RIGHT(function, 7) = "TagList" THEN
    function = LEFT(function, LENGTH(function) - 7)
ELSE IF RIGHT(function, 4) = "Tags" THEN
    function = LEFT(function, LENGTH(function) - 4)
ELSE IF RIGHT(function, 1) = "A" THEN
    function = LEFT(function, LENGTH(function) - 1)

/* Now actually get the reference */
ADDRESS 'FETCHREFS'
FR_GET function || '(%|Tags|TagList|A)' filename FILEREF

/* Address editor again to load the file */
ADDRESS VALUE caller

IF rc ~= 0 THEN DO
    /* Some kind of error happend. Report it. This may be a simple
     * "Aborted" or "No reference" message.
     */
    say RC2

    /* Return */
    EXIT 0
END
ELSE DO
    /* Print the reference */
    ADDRESS COMMAND 'Type' filename

    /* Delete the temporary file */
    ADDRESS COMMAND 'C:Delete >NIL:' filename

    /* Return */
    EXIT 0
END

