/* rexx */

options results                             /* enable return codes     */

if (left(address(), 6) ~= "GOLDED") then    /* not started by GoldEd ? */

    address 'GOLDED.1'

'LOCK CURRENT RELEASE=4'                    /* lock GUI, gain access   */

if (RC ~= 0) then

    exit

options failat 6                            /* ignore warnings         */

signal on syntax                            /* ensure clean exit       */

/* ---------------------- INSERT YOUR CODE HERE ---------------------- */

'QUERY CAT'

if (RESULT = "deutsch") then do

    STRING.sCOMPLETING   = "Vervollständigung der Installation der Hollywood-Erweiterung..."
    STRING.sGENEARTESKIP = "!ERZEUGEN|Überspringen"
end
else do

    STRING.sCOMPLETING   = "Completing installation of Hollywood add-on..."
    STRING.sGENEARTESKIP = "!GENERATE|Skip this step"
end

'REQUEST STATUS="' || STRING.sCOMPLETING || '"'

/* activate hollywood filetype */

'SET TYPE=".hws"'

/* reset size of add-ons */

'API UNDEF'

/* validate image cache */

'IMAGES VALIDATE'

/* generate reference databases */

'MAN BUILD QUIET'

/* save settings and exit */

'PREFS GLOBAL SAVE FORCE'

'TYPE RESET'

'REQUEST STATUS=""'

/* ------------------------- END OF YOUR CODE ------------------------ */

'UNLOCK'                                    /* unlock GUI              */

exit

SYNTAX:

SAY "Error in line" SIGL ":" ERRORTEXT(RC)

'UNLOCK'
