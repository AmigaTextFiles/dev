/* Einstellen der diversen Preferences-Parameter          */
/* AskEnv ruft die diversen Prefs-Programme asynchron auf */

/* trace results */

OPTIONS RESULTS
LF='0A'X
HOST = ADDRESS()

DO FOREVER
Call StartRequester
ADDRESS command
'AskEnv gadfile PIPE:pm_req'
IF rc >= 5 THEN DO
 'delete >NIL: t:pm_req env:selPref'
 Exit 5
END
END		/* do forever */



StartRequester: PROCEDURE

IF ~Open(reqFile, 'PIPE:pm_req', Write) THEN DO
 SAY 'File für AskEnv nicht geöffnet'
 Exit 10
 END
ELSE DO
 CALL WriteLn reqFile, "WINDOW"
 CALL WriteLn reqFile, "CENTER 100 125"
 CALL WriteLn reqFile, "NAME PM"
 CALL WriteLn reqFile, 'BUTTON POSITION 10 20 80 13 LABEL Fonts ASYNCRUN sys:prefs/Font #'
 CALL WriteLn reqFile, 'BUTTON POSITION 10 40 80 13 LABEL Screen ASYNCRUN sys:prefs/ScreenMode #'
 CALL WriteLn reqFile, 'BUTTON POSITION 10 60 80 13 LABEL OvrScan ASYNCRUN sys:prefs/Overscan #'
 CALL WriteLn reqFile, "BUTTON POSITION 10 80 80 13 LABEL Input ASYNCRUN sys:prefs/Input #"
 CALL WriteLn reqFile, "BUTTON POSITION 10 100 80 13 LABEL IControl ASYNCRUN sys:prefs/IControl #"

 Call Close(reqFile)
END
RETURN



/* GetEnv  	: liest Umgebungsvariable des ENV: Verzeichnisses 	*/
/* 	Eingabe : Name der Variable					*/
/* 	Ausgabe : in Variable gespeicherter Wert, bzw Leerstring 	*/

GetEnv: PROCEDURE
arg name
 IF Open(infile, 'env:'name, r) THEN DO
  text = ReadLn(infile)
  CALL Close infile
  RETURN text
 END
 RETURN ''
