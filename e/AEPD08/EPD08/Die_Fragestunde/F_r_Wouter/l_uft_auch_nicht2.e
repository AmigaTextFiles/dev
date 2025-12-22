/*
temporär:
11-Mai-94

in den Listen stehen jetzt auch die Abbruchzeichen, damit rekursive
Verwendung von Regeln möglich wird. Bis Ausgabe der Listen alles OK.

5-Mai-94

getword von datei auf zeichenkette umgestellt
index bei fktns.-aufruf eingeführt

6-Mai-94
klassenzketteerstellen() erstellt
läuft soweit

TODO:

Rekursive Regeln? Dafür zu tun: Regeln ohne Anführungszeichen angeben, sie
werden dann Wort für Wort in eine Liste gepackt. Vor ParsePattern() die
einzelnen Elemente mit dazwischenliegendem ' ' aneinander klatschen, nicht
ohne jedoch vorher das ranzuklatschende Element auf Gleichheit mit einem
Regelnamen zu untersuchen (isinlist()); ggf. wird dann eben jener
Regelklartext da angefügt. Sollte einfach sein.


Aus der Datei 'ram:quelltext' werden Klassen und Regeln eingelesen.
Syntax:
KLASSE <Wortklasse> <beliebige viele Worte>
REGEL <Regelname> <beliebige viele Worte>
ENDE

Die Schlüsselwörter KLASSE und REGEL können in beliebiger Reihenfolge
beliebig auf auftreten, das Schüsselwort ENDE steht jedoch stets am Ende.
Eine Regel besteht aus einzelnen Wörtern, die die Wortklassen bezeichnen.
DOS-Wildcards können verwendet werden.
Beispiel: Artikel #(Adjektiv #(Konjunktion|Komma))
*/


MODULE 'dos/dos', 'dos/dosextens'

DEF	keywordlist[255]:LIST,
	regelliste[255]:LIST,klassenliste[255]:LIST,
	textdigitus=0 /* der zeigefinger, der auf die position zeigt, bis zu der */
				/* schon gesucht wurde */

PROC getword(quellzeichenkette, zielzeichenkette,positionszaehler)
/*

Liest ein Wort aus der Quell-Zeichenkette und schreibt es ab
Adresse Zeichenkette in den Speicher. Als Worttrenner werden betrachtet:
Tabulator (8), Return (10), Leertaste (32), Komma, Punkt, Semikolon und
Doppelpunkt u.a., s. Source. Führende Tabs, CRs, Spaces werden übergangen,
der Backslash "\" kann benutzt werden, um das nächste Zeichen zu überlesen
(es wird in die Zeichenkette übernommen, führt jedoch nicht zum Abbruch).
Doppelte Anführungszeichen setzen die Worttrenner außer Funktion, bei CR
tritt zwar kein Fehler auf, abgebrochen wird aber trotzdem.
positionszahler ist die ADRESSE einer Variablen, in der der Startindex für
die Suche steht; er wird von der Funktion automatisch erhöht.
Rückgabewert ist das Zeichen, das zum Abbruch geführt hat.

Erste lauffähige Version: 1. Mai 1994
Autor: Gregor Goldbach

*/

DEF abbruch=FALSE,
	zaehler=0, /* für ziel */
	quellindex=0, /* zeichenzähler der quelle */
	zeichen,
	skipit=FALSE, /* bei backslash */
	ziel:PTR TO CHAR, trennzeichen=" ", quelle:PTR TO CHAR

  quelle := quellzeichenkette
  ziel := zielzeichenkette

  IF positionszaehler THEN quellindex := ^positionszaehler

  WHILE ((abbruch=FALSE) AND (quelle[zaehler]<>0) AND (zaehler<255))

	zeichen := quelle[quellindex]
    ziel[zaehler] := zeichen /* gleich eintragen */

	IF (skipit=FALSE)
	  SELECT zeichen
		/*  tab, cr und space werden anfangs überlesen */
		CASE 9
		  IF (zaehler > 0)
			IF trennzeichen = " "
			  abbruch := TRUE
			ENDIF
		  ELSE
			zaehler--
		  ENDIF
		CASE 10
		  IF (zaehler > 0) THEN abbruch := TRUE ELSE zaehler--
		  trennzeichen:=" "
		CASE 32
		  IF (zaehler > 0)
			IF trennzeichen = " "
			  abbruch := TRUE
			ENDIF
		  ELSE
			zaehler--
		  ENDIF

		/* 0Byte, Komma ,Punkt, Strich- und Doppelpunkt führen auch am Anfang zum Abbruch */
		CASE 0;		abbruch := TRUE /* kann nich auftreten */
		CASE ",";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE ".";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE ";";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE ":";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "(";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE ")";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "[";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "]";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "{";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "}";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "+";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "-";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "*";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "/";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "=";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "%";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "!";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "?";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "^";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "#";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE "|";	IF trennzeichen=" " THEN abbruch := TRUE
		CASE $22 /* wenn auf Anführungszeichen getroffen */
		  IF trennzeichen=$22 THEN trennzeichen:=" " ELSE trennzeichen:= $22
		  zaehler--
		  
		CASE "\" /* backslash */
		  zaehler--
		  skipit := TRUE
	  ENDSELECT
	ELSE
	  skipit := FALSE
	ENDIF

	zaehler++
	quellindex++
  ENDWHILE
  IF (zeichen<>0) THEN zaehler-- /* bei 0Byte NICHT erniedrigen */
  ziel[zaehler] := 0 /* das ende markieren */

  IF positionszaehler THEN ^positionszaehler := quellindex /* Parameter: neu setzen */
  RETURN zeichen

ENDPROC


PROC putstringinlist(liste, zkette)
DEF laenge,kopie

  laenge := StrLen(zkette)
  kopie := String(laenge)
  StrCopy(kopie, zkette, ALL)
  ListAdd(liste, [kopie], 1)

ENDPROC

PROC isinlist(s,liste)
DEF x
  RETURN Exists({x}, liste, `StrCmp(x, s,ALL) )
ENDPROC

PROC liste_einlesen(quellzeichenkette,zkette)
/*
liest bis zum nächsten Ausftreten eines Schlüsselwortes aus
·quellzeichenkette·, zkette ist... eine Zeichenkette, genau.
Der Zeiger auf die Liste mit den eingelesenen Worten wird zurückgegeben
oder NIL, wenn kein Wort eingelesen werden konnte.
Im zweiten Parameter steht nach Ende der Funktion des nächste
Schlüsselwort oder NIL.
In der Liste wechseln sich Wort und Abbruchzeichen ab, wenn zwischen zwei
Abbruchzeichen kein Wort stand, fehlt das Wort eben. Also: Wenn Länge des
Listenelements > 1 ist, dann ist es ein Wort. */

DEF liste, abbruchzeichen[1]:STRING

  liste := List(255) /* dynamisch allokieren ! */

  abbruchzeichen[0] := getword(quellzeichenkette, zkette, {textdigitus})
  IF (abbruchzeichen[0]>0)
	REPEAT
	  IF (zkette[0]) THEN putstringinlist(liste, zkette)
	  putstringinlist(liste, abbruchzeichen)
	  abbruchzeichen[0] := getword(quellzeichenkette, zkette, {textdigitus})
	UNTIL isinlist(zkette,keywordlist) OR (abbruchzeichen[0] = FALSE)
  ELSE
	liste := NIL
  ENDIF

  RETURN liste
ENDPROC



PROC main()
DEF zaehler,sourcehandle,
	wort[255]:STRING, klassenliste_temp[255]:LIST, listenzeiger[255]:STRING,
	regelliste_temp[255]:LIST,
	textspeicher=NIL:PTR TO CHAR,
	dateilaenge

/* 
regelliste:
Hierin werden die Regeln stehen. Die Regeln können durchaus über
mehrere Listen verteilt sein (per Next() zu erreichen).

klassenliste:
Die Listen der 'Klassen' der Worte. Pro Liste eine Klasse, aber nicht
notwendigerweise pro Klasse nur eine Liste.

listenzeiger:
scratch
*/
/*
  putstringinlist(wortliste, 'Wort eins')
  putstringinlist(wortliste, 'Wort zwei')
  putstringinlist(wortliste, 'numero 3')
  putstringinlist(wortliste, 'Nº 4')

  listenlaenge := ListLen(wortliste)
  WriteF('Länge der Liste: \d\n', listenlaenge)
  FOR zaehler := 1 TO listenlaenge
	WriteF('  \s\n', ListItem(wortliste, zaehler-1))
  ENDFOR

  IF iskeyword('maus') THEN WriteF('Schlüsselwort\n')
  IF iskeyword('KLASSE') THEN WriteF('Schlüsselwort\n')
  IF iskeyword('REGEL') THEN WriteF('Schlüsselwort\n')
*/

  keywordlist := ['KLASSE', 'REGEL', 'ENDE']

  sourcehandle := Open('ram:quelltext', MODE_OLDFILE)
  IF (sourcehandle=NIL)
	WriteF('ram:quelltext ist source, wo isser?\n')
	CleanUp(20)
  ENDIF

  dateilaenge := FileLength('ram:quelltext')

  textspeicher := String(dateilaenge+1)
  Read(sourcehandle,textspeicher,dateilaenge)
  /* der Dateiinhalt sollte jetzt in ·textspeicher· stehen */
  textspeicher[dateilaenge] := 0

  Close(sourcehandle)


  regelliste_temp := regelliste := ['Regelindex']
  klassenliste_temp := klassenliste := ['Klassenindex']
  listenzeiger:=42

  zaehler:=0

  getword(textspeicher, wort, {textdigitus})
  WHILE(listenzeiger)
	IF isinlist(wort,keywordlist)

	  IF StrCmp(wort, 'KLASSE',ALL)
		listenzeiger := liste_einlesen(textspeicher,wort)
		IF(listenzeiger)
		  Link(klassenliste_temp, listenzeiger)
		  klassenliste_temp := listenzeiger
		  /* die erste Liste benutzen wir als Index */
		  ListAdd(klassenliste, [ListItem(listenzeiger,0)],1)
		ELSE
		  WriteF('Klassen-Fehler!\n')
		ENDIF
	  ELSEIF StrCmp(wort, 'REGEL',ALL)

		listenzeiger := liste_einlesen(textspeicher,wort)
		IF(listenzeiger)
		  Link(regelliste_temp, listenzeiger)
		  regelliste_temp := listenzeiger
		  /* die erste Liste benutzen wir als Index */
		  ListAdd(regelliste, [ListItem(listenzeiger,0)],1)
		ELSE
		  WriteF('Regel-Fehler!\n')
		ENDIF

	  ELSE /* weder KLASSE noch REGEL */
		listenzeiger := NIL
	  ENDIF

	ELSE /* kein schlüsselwort */
	  WriteF('Schlüsselwort erwartet!\n')
	  listenzeiger := NIL
	ENDIF
  ENDWHILE

  klassenliste[0] := 'Klassenindex'

/*
Ausgabe der klassenliste (klasse nummer 1 ist index)

  WriteF('Ausgabe der gelesenen Klassen:\n\n')

  klassenliste_temp := klassenliste

  WHILE(klassenliste_temp)
	WriteF('Klasse <\s>:\n', ListItem(klassenliste_temp, 0))
	FOR zaehler := 1 TO ListLen(klassenliste_temp)-1
	  WriteF('  <\s>\n', ListItem(klassenliste_temp, zaehler))
	ENDFOR
	WriteF('\n')
	klassenliste_temp := Next(klassenliste_temp)
  ENDWHILE


  WriteF('Ausgabe der gelesenen Regeln:\n\n')

  regelliste_temp := regelliste

  WHILE(regelliste_temp)
	WriteF('Regel <\s>:\n', ListItem(regelliste_temp, 0))
	FOR zaehler := 1 TO ListLen(regelliste_temp)-1
	  WriteF('  <\s>\n', ListItem(regelliste_temp, zaehler))
	ENDFOR
	WriteF('\n')
	regelliste_temp := Next(regelliste_temp)
  ENDWHILE
*/

  regel_zusammensetzen(['Nur ein Test',' ','simpel',' ','#','einfacher Satz',' ','affe',' ', 'ho'])
  WriteF('\s\n',klassenzkette_erstellen('der doofe Nasenmann kotzt'))
  WriteF('regelüberprüfung:\n')
  listenzeiger := ['Noch ein Test',' ',
			'#','Artikel',
			' ','#','Adjektiv',
			' ','Hauptwort',
			' ','Verb']
  Link(listenzeiger,NIL)
  regelueberpruefung(klassenzkette_erstellen('der doofe Nasenmann kotzt'),listenzeiger)


  CleanUp(20)

  isse_regelmaessig('der Apfel, die Banane laufen.')
  isse_regelmaessig('der doofe Nasenmann kotzt.')
  isse_regelmaessig('der Nasenmann kotzt')
  isse_regelmaessig('der Nasenmann kotzt.')
  isse_regelmaessig('der doofe, große und grüne Nasenmann')

  regel_zusammensetzen(['simpel','simpel 2', 'affe', 'ho', 'hi'])
ENDPROC


PROC klassenzkette_erstellen(eingabe)
DEF quelle:PTR TO CHAR, wort[255]:STRING, index=0, listenzeiger,
	klassenzkette:PTR TO CHAR,laenge, zeichen

  klassenzkette := String(255)

  listenzeiger := klassenliste
  quelle:=eingabe
  REPEAT
	zeichen := getword(quelle, wort, {index})>0
	IF wort[0]
	  listenzeiger := klassenliste
	  WHILE( (isinlist(wort, listenzeiger) = FALSE) AND (listenzeiger) ) DO listenzeiger := Next(listenzeiger)
	  IF listenzeiger
		StrAdd(klassenzkette, ListItem(listenzeiger,0), ALL)
		StrAdd(klassenzkette, ' ', ALL)
	  ELSE
		WriteF('unbekanntes Wort: \s\n', wort)
		StrAdd(klassenzkette, wort, ALL)
		StrAdd(klassenzkette, ' ', ALL)
	  ENDIF
	ENDIF
  UNTIL zeichen=0

  laenge := StrLen(klassenzkette)
  klassenzkette[ laenge-1 ] := 0 /* das letzte space löschen */

  RETURN klassenzkette

ENDPROC

PROC regelueberpruefung(proband, listenbeginn)
/*
	Der ·proband· wird mit den regeln in der liste verglichen, deren beginn bei
	·listenbeginn· liegt. ·proband· ist eine zeichenkette mit dos-wildcards.
	bei erfolg wird der zeiger auf die liste zurückgegeben, deren Element
	Nummer 0 den Regelnamen enthält, die zum Erfolg führte.
*/
DEF listenzeiger, matchargument[255]:STRING, zeichenkette[511]:STRING, zaehler

  listenzeiger := listenbeginn
  WHILE( listenzeiger )
	/* erst zeichenkette zusammensetzen: */
	zeichenkette[0] := 0 /* sozusagen löschen */
	FOR zaehler := 2 TO ListLen(listenzeiger)-1
	  StrAdd(zeichenkette, ListItem(listenzeiger,zaehler), ALL)
	ENDFOR
	WriteF('<\s>\n',zeichenkette)
	IF ParsePattern(zeichenkette,
					matchargument, 255) = -1
	  WriteF('Fehler von ParsePattern() bei Regel \s!\n', ListItem(listenzeiger,0))
	ELSE
	  IF MatchPattern(matchargument, proband)=1
		WriteF('ERFOLG!\n')
		RETURN listenzeiger
	  ENDIF
	ENDIF
	listenzeiger := Next(listenzeiger)
  ENDWHILE
  RETURN(NIL)
ENDPROC

PROC isse_regelmaessig(zkette)
DEF klassenzeichenkette, regelliste_temp=NIL

  klassenzeichenkette := klassenzkette_erstellen(zkette)

  regelliste_temp := Next(regelliste) /* erste liste ist index */
  WHILE(regelliste_temp)
	regelliste_temp := regelueberpruefung(klassenzeichenkette,regelliste_temp)
	IF regelliste_temp
	  WriteF('Regel \s bei \s erfolgreich angewandt.\n', ListItem(regelliste_temp,0), klassenzeichenkette)
	  regelliste_temp := Next(regelliste_temp) /* weiterschalten, da sonst endlos */
	ENDIF
  ENDWHILE
ENDPROC

PROC regel_zusammensetzen(regelzeiger)
/*
Da eine Regel nicht nur Klassen, sondern auch Regelnamen enthalten kann,
wird hier nachgesehen, ob die übergebene Regel Regelnamen enthält.
Diese werden dann ersetzt. Der Zeiger auf eine neue Liste wird zurückgegeben.
*/

DEF regelnummer, elementnummer, zeiger_auf_ersatz, zaehler, wort[511]:STRING,
	neue_liste, zkette:PTR TO CHAR

  neue_liste := List(512)
  StrAdd(wort,ListItem(regelzeiger, 0),ALL)
  StrAdd(wort,'+',1)
  putstringinlist(neue_liste, wort)
  ListAdd(neue_liste, [' '], 1)

  elementnummer := 0
  REPEAT

	regelnummer := 0
	REPEAT
	  regelnummer++
	  zkette := ListItem(regelzeiger, elementnummer)
/*	es wird solange gesucht, bis das ende der liste erreicht ist oder der
	Vergleiche erfolgreich war: */
	UNTIL (StrCmp(zkette, ListItem(regelliste, regelnummer),ALL) AND (StrLen(zkette)>1)) OR (elementnummer=ListLen(regelliste))
					/* das Wort */					/* indexelement */

/*	War der Vergleich erfolgreich, ist ·regelnummer· kleiner als die Länge
	der Liste: */

	IF regelnummer<ListLen(regelliste)
	  WriteF('\s gefunden! Nummer \d\n', ListItem(regelzeiger, elementnummer),regelnummer)

/*	  Der Inhalt der gefundenen Liste wird in die neue Liste kopiert und
	  umklammert, falls ein Wildcard davorstand */

	  zeiger_auf_ersatz := Forward(regelliste, regelnummer)
	  ListAdd(neue_liste, ['('], 1)
		FOR zaehler:=2 TO ListLen(zeiger_auf_ersatz)-2 /* name und erstes trennzeichen überspringen */
		  ListAdd(neue_liste, [ListItem(zeiger_auf_ersatz,zaehler)],1)
		ENDFOR
	  ListAdd(neue_liste, [')'], 1)
	ELSE

/*	  bei Mißerfolg der Suche wird lediglich das Wort kopiert */

	  ListAdd(neue_liste, [ListItem(regelzeiger, elementnummer)], 1)
	ENDIF

	elementnummer++
  UNTIL elementnummer = ListLen(regelzeiger)

/*
  FOR zaehler:= 2 TO ListLen(neue_liste)-1
	WriteF('\s', ListItem(neue_liste, zaehler))
  ENDFOR
  WriteF('\n')
*/

  RETURN neue_liste

ENDPROC
