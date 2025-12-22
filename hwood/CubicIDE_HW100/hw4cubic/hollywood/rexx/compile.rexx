/* rexx macro */

options results                             /* enable return codes     */

arg EXETYPE

if (left(address(), 6) ~= "GOLDED") then    /* not started by editor ? */

    address 'GOLDED.1'

'LOCK CURRENT RELEASE=4'                    /* lock GUI, gain access   */

if (RC ~= 0) then

    exit

options failat 6                            /* ignore warnings         */

signal on syntax                            /* ensure clean exit       */

/* ---------------------- INSERT YOUR CODE HERE ----------------------

 Author:      Copyright 2008 by Michael "Clyde Radcliffe" Jurisch
 Description: Compile Hollywood script for specified target
 Version:     1.2
 To-Do:       make it generate beer

*/

'QUERY CAT VAR=CAT'

if (CAT = "deutsch") then do
    STRING.sSAVEAS       = "Speichere Programm als ..."
    STRING.sSAVEFOR      = "Speichere %-Programm als ..."
    STRING.sSAVEASAPPLET = "Speichere Applet als ..."
    STRING.sOVERWRITE    = "Ungültige Auswahl! Sie überschreiben damit Ihren Quelltext!"
    STRING.sERROR        = "Unbekannte Ziel-Plattform!"
end
else do
    STRING.sSAVEAS       = "Save program as ..."
    STRING.sSAVEFOR      = "Save % program as ..."
    STRING.sSAVEASAPPLET = "Save applet as ..."
    STRING.sOVERWRITE    = "Invalid choice! You are going to overwrite your source code!"
    STRING.sERROR        = "Unknown target platform!"
end

/* validate command line argument */

SELECT
    when (EXETYPE = "CLASSIC") then

        do
            OS      = "OS3"
            EXETYPE = "classic"
        end
        
    when (EXETYPE = "CLASSIC881") then

        do
            OS      = "OS3 (FPU)"
            EXETYPE = "classic881"
        end        

    when (EXETYPE = "AMIGAOS4") then

        do
            OS      = "OS4"
            EXETYPE = "amigaos4"
        end

    when (EXETYPE = "MORPHOS") then

        do
            OS      = "MorphOS"
            EXETYPE = "morphos"
        end

    when (EXETYPE = "WARPOS") then

        do
            OS      = "WarpOS"
            EXETYPE = "warpos"
        end

    when (EXETYPE = "AROS") then

        do
            OS      = "AROS (x86)"
            EXETYPE = "aros"
        end
        
    when (EXETYPE = "WIN32") then

        do
            OS      = "Windows (x86)"
            EXETYPE = "win32"
        end
        
    when (EXETYPE = "WIN32CONSOLE") then

        do
            OS      = "Windows Console (x86)"
            EXETYPE = "win32console"
        end
        
    when (EXETYPE = "WIN64") then

        do
            OS      = "Windows (x64)"
            EXETYPE = "win64"
        end
        
    when (EXETYPE = "WIN64CONSOLE") then

        do
            OS      = "Windows Console (x64)"
            EXETYPE = "win64console"
        end        
        
    when (EXETYPE = "MACOS") then

        do
            OS      = "macOS (ppc)"
            EXETYPE = "macos"
        end

    when (EXETYPE = "MACOS86") then

        do
            OS      = "macOS (x86)"
            EXETYPE = "macos86"
        end
        
    when (EXETYPE = "MACOS64") then

        do
            OS      = "macOS (x64)"
            EXETYPE = "macos64"
        end        
        
    when (EXETYPE = "LINUX") then

        do
            OS      = "Linux (x86)"
            EXETYPE = "linux"
        end        

    when (EXETYPE = "LINUXPPC") then

        do
            OS      = "Linux (ppc)"
            EXETYPE = "linuxppc"
        end   
        
    when (EXETYPE = "LINUXARM") then

        do
            OS      = "Linux (arm)"
            EXETYPE = "linuxarm"
        end   
        
    when (EXETYPE = "LINUX64") then

        do
            OS      = "Linux (x64)"
            EXETYPE = "linux64"
        end          
                
    when (EXETYPE = "APPLET") then

        do
            OS      = ""
            EXETYPE = "applet"
        end

    otherwise

        if (EXETYPE ~= "") then do

            'REQUEST PROBLEM="' || STRING.sERROR || '"'

            'UNLOCK'

            exit
        end
        else
            OS = ""
end

'SAVE ALL SMART'

if (RC = 0) then do

    'QUERY DOC  VAR=SCRIPT'
    'QUERY PATH VAR=PATH'
    'QUERY FILE VAR=FILE'

    /* strip suffix from script name*/

    POS = lastpos(".", FILE)

    if (POS ~= 0) then

        FILE = delstr(FILE, POS)

    /* suggest new suffix for target file */

    if (EXETYPE = "applet") then

        FILE = FILE || ".hwa"

    if (EXETYPE = "win32") then

        FILE = FILE || ".exe"

    /* build file requester title (indicate target OS) */

    if (OS = "") then do

        if (EXETYPE = "applet") then
            TITLE = STRING.sSAVEASAPPLET;
        else
            TITLE = STRING.sSAVEAS;
    end
    else do

        PLACE = pos("%", STRING.sSAVEFOR)

        TITLE = left(STRING.sSAVEFOR, PLACE - 1) || OS || substr(STRING.sSAVEFOR, PLACE + 1)
    end

    do forever

        /* query target file (until a valid choice is made) */

        'REQUEST FILE SAVE TITLE="' || TITLE || '" PATH="' || PATH || '/' || FILE || '" VAR=TARGET'

        if ((RC = 0) & (TARGET ~= "")) then do

            /* script and target must not be the same file */

            if (~samefile(TARGET, SCRIPT)) then do

                /* compile */

                if (EXETYPE = "") then
                    'HOLLYWOOD OPTIONS="-compile *"' || TARGET || '*""'
                else
                    'HOLLYWOOD OPTIONS="-compile *"' || TARGET || '*" -exetype ' || EXETYPE || '"'

                'UNLOCK'

                exit
            end
            else
                'REQUEST PROBLEM="' || STRING.sOVERWRITE || '"'
        end
        else
            break
    end
end

/* ------------------------- END OF YOUR CODE ------------------------ */

'UNLOCK' /* unlock user interface   */

exit

SYNTAX:

SAY "Error in line" SIGL ":" ERRORTEXT(RC)

'UNLOCK'

/* /// functions */

samefile: procedure

    /* check if FILE1 and FILE2 refer to the same file (return BOOL) */

    parse arg FILE1, FILE2

    /* split file names into path part and name part */

	'PATHPART FILE="' || FILE1 || '" VAR=PATH1'
	'FILEPART FILE="' || FILE1 || '" VAR=NAME1'

	'PATHPART FILE="' || FILE2 || '" VAR=PATH2'
	'FILEPART FILE="' || FILE2 || '" VAR=NAME2'

    /* expand paths (resolve assigns) to permit comparision */

    'EXPAND NAME="'   || PATH1 || '" VAR=PATH1'
    'EXPAND NAME="'   || PATH2 || '" VAR=PATH2'

    FILE1 = PATH1 || NAME1
    FILE2 = PATH2 || NAME2

    return(FILE1 = FILE2)

/* /// */
