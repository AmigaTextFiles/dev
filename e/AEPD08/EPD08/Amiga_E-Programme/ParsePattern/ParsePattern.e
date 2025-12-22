/*

Beispiel für PatternMatching ab OS 2.0

Ohne Gewähr auf Korrektheit der Angaben, Benutzung auf eigene Gefahr.
Public Domain.
Glotter Giger, 2. Mai 1994

Zulässige Wildcards:

'#':
Beliebige Anzahl (auch 0) des nachstehenden Ausdrucks

'?':
Ein Zeichen.

'(1|2|drei)':
Zwischen den '|' steht jeweils eine Alternative.
'h(i|o|a!)' -> 'hi' ODER 'ho' ODER 'ha!'

'%':
Steht für nichts, kann sehr nützlich sein bei z.B: hi(!| |%).

'[abc]':
Einer der drei Buchstaben

'~':
Logisches NICHT

'[a-z]':
Bereich 'a' bis 'z'

Die Wildcards '#' und '~' beziehen sich immer auf den nächsten 'Ausdruck'.
Ein 'Ausdruck' ist a) ein Zeichen oder b) Eine mit '()' umschlossene
Zeichenkette.

'#?' -> Beliebig viele Zeichen
'~H' -> Kein 'H'
'~(H|ka|op)#?' -> Keine Wörter, die mit 'H', 'ka' oder 'op' beginnen.


Und jetzt die Preisfrage: Wofür ist derdiedas Carrot ('^') da?
*/

MODULE 'dos/dos', 'dos/dosextens'

PROC main()
DEF quelle[80]:STRING, ziel[80]:STRING, zaehler=0

  WriteF('Beispiel für die DOS-Routinen (Parse|Match)Pattern.\n')
  WriteF('Glotter Giger 1994\n\n')

/*	Zeichenkette mit DOS-Wildcards kopieren: */

  StrCopy(quelle, '<Art> #(<Adj> #((<Konj>|<Komma>) <Adj> ))<Noun>', ALL)

  WriteF('Parameter für ParsePattern:\n  \s\n\n', quelle)

/*	Umwandeln für ParsePattern: */
  
  IF ParsePattern(quelle,ziel,80) = -1
	WriteF('Fehler bei ParsePattern - Puffer zu klein?\n')
	CleanUp(20)
  ENDIF

/* kleine Ausgabe: 'A'/65
  REPEAT
	WriteF('\a\c\a/\d ', ziel[zaehler],ziel[zaehler])
	zaehler++
  UNTIL ziel[zaehler] = 0
  WriteF('\n')
*/

  muster(ziel, '<Art> <Noun>')
  muster(ziel, '<Art> <Adj> <Noun>')
  muster(ziel, '<Art> <Adj> <Adj> <Noun>')
  muster(ziel, '<Art> <Adj> <Konj> <Adj> <Noun>')
  muster(ziel, '<Art> <Adj> <Komma> <Adj> <Konj> <Adj> <Noun>')
  muster(ziel, '<Art> <Adj>')

  WriteF('\n\nAchtung, gleich kommt noch mehr!\n\n\n')
  Delay(150)

  StrCopy(quelle, 'Das ????e (~H|K|L|%)#?', ALL)
  WriteF('Parameter für ParsePattern:\n  \s\n\n', quelle)
  IF ParsePattern(quelle,ziel,80) = -1
	WriteF('Fehler bei ParsePattern - Puffer zu klein?\n')
	CleanUp(20)
  ENDIF
  muster(ziel, 'Das grüne Haus')
  muster(ziel, 'Das große Kind')
  muster(ziel, 'Der große Hans')
  muster(ziel, 'Der grüne Kerl')
  muster(ziel, 'Das kleine Land')
  muster(ziel, 'Das gnaze Platinenlayout')

ENDPROC

PROC muster(dasmuster, zeichenkette)
/*	Aufruf von MatchPattern plus Ausgabe

	dasmuster		- Ergebnisstring von ParsePattern
	zeichenkette	- der zu überprüfende String
*/

  WriteF('MatchPattern mit \a\s\a:\n', zeichenkette)
  IF MatchPattern(dasmuster, zeichenkette) = 1
	WriteF('  Muster passt!\n\n')
  ELSE
	WriteF('  Muster passt nicht!\n\n')
  ENDIF
ENDPROC
