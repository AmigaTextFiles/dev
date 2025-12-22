/* -- Programm: Ackermanns Revenge ;-)                               -- *
 * -- Autor   : Daniel Kasmeroglu                                    -- *
 * --                                                                -- *
 * -- In eurem "beginner.guide" ist unter dem Stichwort "Rekursion"  -- *
 * -- die sog. Drachenkurve als Beispiel aufgeführt. Diese           -- *
 * -- Drachenkurve ist zwar schön anzusehen, zeigt aber nicht, wie   -- *
 * -- "gefährlich" Rekursionen bei unüberlegter Anwendung sein kann. -- *
 * -- Ich habe deshalb ein altbekanntes Beispiel in E umgesetzt, das -- *
 * -- ursprünglich dazu gedacht war die Rechenleistung eines         -- *
 * -- Computers zu messen. Die sog. Ackermann-Funktion ist ohne      -- *
 * -- weiteres in der Lage den Stack zu "sprengen" oder das System   -- *
 * -- lahmzulegen und dies bei rel. kleinen Parametern.              -- *
 * -- User mit 68000 sollten für m Werte kleiner 4 wählen !          -- * 
 * --                                                                -- *
 * -- ACHTUNG: Ich habe den Stack vergrößert um das Programm eine    -- *
 * -- Weile am Laufen zu lassen.                                     -- */

OPT STACK=200000 -> Stack sollte noch eine Weile halten 

DEF rekursionen  -> Rekursionen sollen gezählt werden

PROC main()
DEF winhandle,oldout,kette,m,n

  kette := String(10)

  -> öffnen eines Windows in AmigaDOS-Manier
  winhandle := Open('CON:50/50/500/150/Ackermann Funktion',NEWFILE)

  -> Schade, aber kein Fenster ist zu öffnen
  IF winhandle = NIL THEN RETURN 5

  oldout := SetStdOut(winhandle) -> Ausgabe umlenken

  -> Kleiner Hilfstext
  WriteF('(c) written by Daniel Kasmeroglu\n')
  WriteF('Dieses Programm benutzt die sog. Ackermann-Funktion.\n')
  WriteF('Mit Hilfe dieser Funktion kann man sehen, was der\n')
  WriteF('eigene Rechner alles auf dem Kasten hat. Dabei sollte\n')
  WriteF('man nicht vergessen, daß selbst kleine Parameter\n')
  WriteF('extreme Rechenzeiten mit sich bringen (wirklich extrem) !\n')
  WriteF('HINWEIS: Die Funktion dauert besonders lang, wenn `m\a\n')
  WriteF('         sehr groß ist !\n\n')


  REPEAT

    rekursionen := 0 -> Anzahl der Rekursionen = 0

    -> Parameter einlesen
    WriteF(' m := '); ReadStr(winhandle,kette); m := Val(kette,NIL)
    WriteF(' n := '); ReadStr(winhandle,kette); n := Val(kette,NIL)

    -> Ausgabe mit gleichzeitiger Berechnung
    WriteF(' ackermann(m=\d,n=\d) = \d\n',m,n,ack(m,n))
    WriteF(' Rekursionen          = \d\n',rekursionen)

    -> evtl. nochmal ausprobieren ?
    WriteF('Nochmal [j/n] => ')
    ReadStr(winhandle,kette)

    kette := LowerStr(kette)

  UNTIL StrCmp(kette,'n',1) = TRUE  -> User hat keine Lust mehr =>.-)

  -> alles wieder schliessen
  SetStdOut(oldout)
  Close(winhandle)

ENDPROC


PROC ack(m,n)                    

/* -- einige werden vielleicht bemerken, daß diese Funktion relativ       -- *
 * -- simpel konstruiert ist. man sollte sie dennoch nicht unterschätzen. -- *
 * -- bei Parametern wie `ack(3,7)' muß man aufs Ergebnis schon warten.   -- *
 * -- ich habe eine zusätzliche globale Variable eingesetzt, die die      -- *
 * -- Anzahl der Rekursionen zählen soll. viel Spaß =:-)                  -- */

  rekursionen := rekursionen + 1    -> eine Rekursion mehr

  IF m = 0                          -> Abbruchbedingung
    RETURN n+1
  ELSEIF n = 0 
    RETURN ack(m-1,1)               -> simple Rekursion
  ELSE
    RETURN ack(m-1,ack(m,n-1))      -> Hardcore-Rekursion
  ENDIF

ENDPROC
