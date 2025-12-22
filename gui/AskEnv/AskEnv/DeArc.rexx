/* Entpacken von Files unter AskEnv >V2.1 ; Bengt Giger 16.9.92 */

/* Aufruf:  Dearc <fileName>				*/
/*							*/
/* ohne Filename wird Askenv-Requester aufgerufen	*/
/*							*/
/* ENV:-Variablen: Dearc_dir, Dearc_name		*/
/*							*/
/* erkannte Formate: LHA/LZH                            */
/*                   ZOO                                */
/*                   ZIP                                */
/*                   ARC                                */
/*                   DMS                                */
/* 							*/
/* Variablen zum Anpassen:				*/

askenvCmd = 'AskEnv'
lzLhaCmd  = 'LZ x'
zooCmd    = 'booz x'
zipCmd    = 'unzip'     /* Achtung: Option 'x' kommt nach dem File, ev ändern in Zeile 67 */
arcCmd    = 'arc x'


/* trace results */

/* OPTIONS RESULTS */
LF='0A'X
HOST = ADDRESS()

curNum = 0

PARSE UPPER ARG Commandline

ADDRESS command			/* Variablen initialisieren		*/
toDevice = GetEnv('Dearc_dir')
IF toDevice = '' THEN DO	/* erster Start				*/
 toDevice = 'RAM:'
 'SetEnv Dearc_dir 'toDevice
END
arcName = GetEnv(Dearc_name)
IF arcName  = '' THEN DO
 arcName = 'T:'
 'SetEnv Dearc_name ""'
END
 
start:
DO FOREVER
 fileNum = PRAGMA(Id)||curNum   /* eindeutiger Bezeichner fuer File	*/
 IF Commandline = "" THEN DO	/* kein Name übergeben --> Interface 	*/
  fileName = AskName()		/* dort ist die Abbruch-Option! 	*/
  END
 ELSE DO			/* Name einfach übernehmen		*/
  fileName = Commandline
 END
 ext = UPPER(fileName)
 DO FOREVER
  extension = ext
  PARSE VAR ext first "." ext   /* Name koennte auch einen Punkt haben, */
  IF ext = '' THEN LEAVE	/* darum so kompliziert			*/
 END
 CALL OPEN StartFile, 'PIPE:DeArc'||fileNum , 'W'
 CALL WriteLn StartFile, 'CD "'||toDevice||'"'
 CALL WriteLn StartFile, 'CHANGETASKPRI -1'
 SELECT
  WHEN extension = 'LHA' | extension = 'LZH' THEN CALL WriteLn StartFile, lzLhaCmd' "'||fileName||'"'
  WHEN extension = 'ZOO' THEN CALL WriteLn StartFile, zooCmd' 'fileName
  WHEN extension = 'ZIP' THEN CALL WriteLn StartFile, unzipCmd' '||LEFT(fileName, LENGTH(fileName)-4)||' x'
  WHEN extension = 'ARC' THEN CALL WriteLn StartFile, arcCmd' '||fileName
  WHEN extension = 'DMS' THEN CALL WriteLn StartFile, 'DMS write '||fileName||' TO df0:'
  OTHERWISE DO
   askenvCmd' SReq "Sorry, Archiv nicht erkannt" NEG Aufhören'
   EXIT
  END
 END
 CALL WriteLn StartFile, 'IF WARN'
 CALL WriteLn StartFile, ' QUIT'
 CALL WriteLn StartFile, 'ENDIF'
 CALL WriteLn StartFile, 'ENDCLI'
 CALL CLOSE StartFile		/* Befehl bereit, Shell starten		*/
 'run <NIL: >NIL: newshell "CON:60/10/640/190/Entpacke..." from PIPE:DeArc'||fileNum
 IF Commandline ~= "" THEN CALL Exit
 curNum = curNum + 1
END				/* Nur ein Durchlauf beim Start mit Argument */

AskName:
ADDRESS command askenvCmd' GADFILE Dearc.req'
IF rc = 5 THEN CALL Exit
arcName = GetEnv(Dearc_name)
toDevice = GetEnv(Dearc_dir)
RETURN arcName

Exit:
/* 'Unsetenv Dearc_dir' */
/* 'Unsetenv Dearc_name' */
Exit

/* GetEnv  	: liest Umgebungsvariable des ENV: Verzeichnisses 	*/
/* 	Eingabe : Name der Variable					*/
/* 	Ausgabe : in Variable gespeicherter Wert, bzw Leerstring 	*/

GetEnv: 	PROCEDURE
arg name
 IF Open(infile, 'env:'name, r) THEN DO
  text = ReadLn(infile)
  CALL Close infile
  RETURN text
 END
 RETURN ''
