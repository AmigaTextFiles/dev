/* Bereitstellen des Briefformat-Kopfes für LaTex-Briefformat */
/* Verzeichnis TeX: muss existieren sowie ein dinbrief.sty für LaTeX */
/* Bengt Giger, Schmiedgasse 48, CH-8640 Rapperswil */

/* $VER: Brief 2.0 (23.1.93) */

/* trace results */

OPTIONS RESULTS
LF='0A'X
HOST = ADDRESS()

/* zum Anpassen der Absender-Adresse */
  myName = 'Bengt Giger'
  myStreet= 'Schmiedgasse 48'
  myTown = '8640 Rapperswil'
  myPhone= '055 27 98 79'

editor = GetEnv('EDITOR')   /* User-Editor */

DO FOREVER
 Call SetRequester
 ADDRESS command

 'AskEnv gadfile PIPE:br_req'
 IF rc >= 5 THEN DO
  Exit 5
 END
 file = GetEnv('file')
 fullName = 'TeX:'file'.tex'

 IF OPEN(file, fullName, 'R') THEN DO
  'AskEnv SREQ "File existiert schon." BODY Ueberschreiben? NEG Nein POS Ja'
  IF rc = 0 THEN DO
   num = CLOSE(file)
   shell command "delete tex:"file".tex"
   LEAVE
   END
  ELSE DO
   num = Close(file)
   ITERATE
  END
 END
 ELSE LEAVE
END					/* DO FOREVER */
call OPEN file, fullName, Write

person = GetEnv('person')
strasse = GetEnv('strasse')
ort = GetEnv('ort')
adresstyp = GetEnv('adresstyp')
postvermerk = GetEnv('postvermerk')

call WRITELN file, "\documentstyle[norm,german]{dinbrief_ch}"
call WRITELN file, '\pagestyle{empty}'
call WRITELN file, '\Postvermerk{'postvermerk'}'
SELECT
 WHEN adresstyp = 0 THEN DO
   call WRITELN file, '\Absender{'myName' \\ 'myStreet' \\ 'myTown'}'
   END
 WHEN adresstyp = 1 THEN DO
   call WRITELN file, '\Retouradresse{'myName' --- 'myStreet' --- 'myTown'}'
   END
 WHEN adresstyp = 2 THEN DO
   call WRITELN file, '\Fenster'
   call WRITELN file, '\Retouradresse{'myName' --- 'myStreet' --- 'myTown'}'
   END
 OTHERWISE
END
call WRITELN file, '\begin{document}'
call WRITELN file, '\begin{letter}{'||person||' \\ '||strasse||' \\ {\bf '||ort||'}}'
call WRITELN file, ''
call WRITELN file, '\opening{   }'
call WRITELN file, ''
call WRITELN file, ''
call WRITELN file, '\closing{   }'
call WRITELN file, '\end{letter} \end{document}'

CALL CLOSE(file);
/* SAY 'fertig.' */

INTERPRET "editor' 'fullName"

shell command 'delete >NIL: env:person env:strasse env:ort env:file env:adresstyp env:postvermerk'

Exit 0

SetRequester: PROCEDURE

fileName = GetEnv("FileName")
person = GetEnv('person')
strasse = GetEnv('strasse')
ort = GetEnv('ort')
postvermerk = GetEnv('postvermerk')

IF ~Open(reqFile, 'PIPE:br_req', Write) THEN DO
 SAY 'File für AskEnv nicht geöffnet'
 Exit 10
 END
ELSE DO
 CALL WriteLn reqFile, "WINDOW"
 CALL WriteLn reqFile, "CENTER 320 240"
 CALL WriteLn reqFile, 'NAME "TeX-Brief: AREXX-Macro 23.1.93"'
 CALL WriteLn reqFile, 'TEXT POSITION 30 20 260 20 LABEL "Neuer Brief:" #'
 CALL WriteLn reqFile, 'STRING POSITION 100 50 192 13 GLOBAL file LABEL Filename PLACETEXT left ENTRY "'||filename||'" #'
 CALL WriteLn reqFile, 'STRING POSITION 100 70 192 13 GLOBAL person LABEL Name PLACETEXT left ENTRY "'person'" #'
 CALL WriteLn reqFile, 'STRING POSITION 100 90 192 13 GLOBAL strasse LABEL Strasse PLACETEXT left ENTRY "'strasse'" #'
 CALL WriteLn reqFile, 'STRING POSITION 100 110 192 13 GLOBAL ort LABEL PLZ/Ort PLACETEXT left ENTRY "'ort'" #'
 CALL WriteLn reqFile, 'STRING POSITION 100 130 192 13 GLOBAL postvermerk LABEL Postvermerk PLACETEXT LEFT ENTRY "'postvermerk'" #'
 CALL WriteLn reqFile, 'TEXT   POSITION 10  167 192 13 NOBOX LABEL "Art der Adressierung:" #'
 CALL WriteLn reqFile, 'MX     POSITION 200 160 1 1 GLOBAL adresstyp LABEL PLACETEXT RIGHT ENTRY Standard Kompakt Fenster #'
 CALL WriteLn reqFile, 'BUTTON POSITION 10  218 80 13 LABEL Weiter END #'
 CALL WriteLn reqFile, 'BUTTON POSITION 230 218 80 13 LABEL Abbruch CANCEL #'
 CALL WriteLn reqFile, 'BUTTON POSITION 120 218 80 13 LABEL Hilfe SYNCRUN "Askenv GADFILE BriefHilfe.req" WARN 20 #'

 Call Close(reqFile)
END
RETURN

/* GetEnv  	: liest Umgebungsvariable des ENV: Verzeichnisses 	*/
/* 	Eingabe : Name der Variable					*/
/* 	Ausgabe : in Variable gespeicherter Wert, bzw Leerstring 	*/

GetEnv:
arg name
 IF Open(infile, 'env:'name, r) THEN DO
  text = ReadLn(infile)
  CALL Close infile
  RETURN text
 END
 RETURN ''
