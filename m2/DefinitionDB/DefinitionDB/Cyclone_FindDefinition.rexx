/* $VER: V0.5
** Call MSearchDB from BED with ARexx
*/

msearchpath= "am2:prgs/DefinitionDB/bin/msearchdb"


OPTIONS RESULTS

'GetWord'
searchword = RESULT

IF searchword="" THEN DO
	'SetStatusBar "Cursor not on a word"'
	RETURN
END


ADDRESS "MSEARCHDB"

IF ~SHOW(PORTS,"MSEARCHDB") THEN DO
   IF EXISTS(msearchpath) THEN DO
      IF ~SHOW("L", "rexxsupport.library") THEN DO
         ADDLIB("rexxsupport.library",0,-30,0)
      END
      IF SHOW("L", "rexxsupport.library") THEN DO
         IF OPENPORT("marexxport") THEN DO
            ADDRESS COMMAND "run " msearchpath
            CALL WAITPKT "marexxport"
            CALL REPLY(GETPKT("marexxport"))
            CALL CLOSEPORT "marexxport"
         END
      END
   END
END


IF SHOW(PORTS,"MSEARCHDB") THEN DO
   ADDRESS "MSEARCHDB"
   "SEARCH" searchword
END


