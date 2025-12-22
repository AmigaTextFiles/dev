/* E-Error V0.4 by Juri Kern 08.12.95 */


OBJECT hilfe
a;s
ENDOBJECT

DEF gd,input[50]:STRING,con,altstd,y
DEF bef[50]:ARRAY OF hilfe

PROC main()
IF wbmessage = NIL
gd:='                           Weiter                                          '

SetTopaz(8)

  bef[].s := 'a4/a5 used'
  bef[].a := 'Diese Warnung wird ausgegeben, wenn sie Register A4 und A5\n' +
		  'in ihrem Assembler Code verwenden. Der Grund dafür ist, daß diese\n' +
		  'Register von E intern verwendet werden, um lokale und globale\n' +
		  'Variable richtig zu addressieren. Natürlich kann es gute Gründe\n' +
		  'geben, diese zu gebrauchen, wie MOVEM.L A4/A5,-(A7) vor einen großen\n'+
		  'Stück InlineAssembler-Code.\n'

	bef[1].s:= 'keep eye'
	bef[1].a:= 'Kann ausgegeben werden, wenn sie OPT STACK=<size> verwenden.\n' +
			'Der Compiler vergleicht einfach ihre Angabe mit seiner eigene\n' +
			'Schätzung, und gibt erstere Meldung aus, wenn er meint, die Größe\n' +
			'sei etwas knapp kalkuliert oder letztere, wenn sie definitiv zu\n' +
			'klein ist.'

	bef[2].s:= 'suspicious use'
	bef[2].a:= 'Diese Warnung erscheint, wenn sie den Ausdruck "a=1" als Anweisung\n' +
			'gebrauchen. Ein Grund ist, daß ein Vergleich als Anweisung wenig\n' +
			'Sinn macht, aber der Hauptgrund ist, daß dies oft vorkommende \n' +
			'Rechtschreibfehler bei "a:=1" ist. Den vergessenen ":" zu finden\n' +
			'ist schwer, aber er kann ernsthafte Konsequenzen haben.'

	bef[3].s:= 'syntax error'
	bef[3].a:= 'Häufigster Fehler. Diese Fehlermeldung erscheint, wenn entweder\n' +
			'keine andere Meldung passt, oder ihre Anordnung des Codes dem Compiler\n' +
			'etwas seltsam erscheint.'

bef[4].s:='unknown keyword/const'
bef[4].a:='Sie haben einen Identifier in Großbuchstaben (wie "IF" oder "TRUE")\n' +
			'verwendet, und der Compiler konnte keine Definition dafür finden.\n' +
			'Gründe:\n * falschgeschriebenes Schlüsselwort\n * sie haben eine' +
			'Konstante verwendet, diese aber nicht zuvor\n' +
			'mit CONST definiert\n * sie haben vergessen, das Modul anzugeben,' +
			'in dem ihre Konstante\n definiert ist.'

bef[5].s:= '":=" expected'
bef[5].a:='Sie haben eine FOR Anweisung oder eine Zuweisung geschrieben, und haben\n' +
			 'dabei etwas anderes als ":=" verwendet.'

bef[6].s:= 'unexpected characters'
bef[6].a:='Sie haben Zeichen verwendet die in E außerhalb von Strings keine\n' +
			 'syntaktische Bedeutung haben.\n\nBeispiel: "§!&Öß"'

bef[7].s:= 'label expected'
bef[7].a:='In bestimmten Fällen, zum Beispiel nach den Schlüsselwörtern PROC oder\n' +
			 'JUMP, ist ein Identifier notwendig. Sie haben irgendetwas anderes\n' +
			 'geschrieben.'

bef[8].s:='"," expected'
bef[8].a:='Innerhalb einer Gegenstandsliste (z.B. eine Parameter Liste), haben\n' +
			 'sie etwas anderes als ein Komma verwendet.'

bef[9].s:='variable expected'
bef[9].a:='Diese Konstruktion braucht eine Variable.\n\nBeispiel:\n' +
			  'FOR <var>:= ... etc.'

bef[10].s:= 'value does'
bef[10].a:='Beim spezifizieren einer Konstanten haben sie einen zu großen Wert' +
			  'einegegeben.\n\n Beispiel:\n $FFFFFFFFF, "abcdef"\n' +
			  'Diese Meldung erscheint auch, wenn ein SET-Befehl mit mehr als 32\n' +
			  'Elementen verwendet wird.'

bef[11].s:='missing apostrophe/quote'
bef[11].a:='Sie haben ein \a am Ende einer String vergessen.'

bef[12].s:= 'incoherrent program'
bef[12].a:='* sie haben eine neue PROCedure gestartet, ohne die vorherige zu\n' +
			  'beenden.\n* die Verzweigung ihrer Programme ist falsch, z.B.:\n' +
			  'FOR\n   IF\n   ENDFOR\nENDIF'

bef[13].s:= 'illegal command-line'
bef[13].a:='Innerhalb der Befehlszeile \aEC -opt source\a haben sie für -opt einen\n' +
			  'Ausdruck verwendet, der EC unbekannt ist.'

bef[14].s:= ' division and'
bef[14].a:='Der Compiler hat festgestellt, daß sie einen 32 bit Wert für * oder / \n' +
			  'verwendet haben. Dies würde nicht den erwünschten Wert im Runtime\n' +
			  'ergeben, z.B. bei Mul() und Div().'

bef[15].s:= 'superfluous items'
bef[15].a:='Nachdem der Compiler ihren Anweisung bearbeitet hat, hat er immer noch\n' +
			  'Zeichen anstelle eines Linefeeds gefunden. Sie haben wahrscheinlich\n' +
			  'den <lf> oder ";" vergessen, um zwei Anweisungen zu trennen.'

bef[16].s:= 'procedure "main"'
bef[16].a:='Ihre Programm hat keine \amain procedure\a.'

bef[17].s:='double declaration'
bef[17].a:='Sie haben eine Sprungmarke zweimal vergeben, z.B.:\nlabel:\nPROC label()'

bef[18].s:= 'unsafe use'
bef[18].a:='Dies hat wieder etwas mit 16 Bit anstelle von 32 Bit * und / zu tun.\n' +
			  'Siehe \adivision and multiplication 16 bit only\a.'

bef[19].s:= 'reading sourcefile'
bef[19].a:='Überprüfen sie ihre Angaben für die Quelle, die sie mit \aec mysource\a\n' +
			  'angegeben haben. Achten sie darauf, daß die Quelle und nicht die\n' +
			  'Kommandozeile auf \a.e\a endet.'

bef[20].s:= 'writing executable'
bef[20].a:='Der Versuch, das eben generierte ausführbare Programm zu schreiben\n' +
			  'verursachte einen DOS-Fehler. Unter umständen existierte das Programm\n' +
			  'bereits und konnte nicht überschrieben werden.'

bef[21].s:= 'no args'
bef[21].a:='"GEBRAUCH: ec [-opts] <Quellcodedateiname> (\a.e\a wird hinzugefügt)"\n' +
			  'Sie erhalten diese Meldung, wenn sie ec ohne Argumente verwenden.'

bef[22].s:= 'unknown/illegal addressing'
bef[22].a:='Dieser Fehler erscheint nur, wenn sie den inline Assembler verwenden.\n' +
			  'Mögliche Gründe:\n' +
			  '* sie haben eine Addressierungsweise verwendet, die es für den 68000er\n' +
			  'nicht gibt.\n* die Addressierungsmethode existiert, aber nicht für diesen' +
			  'Befehl.\nNicht alle Assembler-Befehle unterstützen alle Kombinationen der\n' +
			  'effektiven Addressen für Quelle und Ziel.'

bef[23].s:= 'unmatched parentheses'
bef[23].a:='Ihre Anweisung hat mehr "(" als ")" oder umgekehrt.'

bef[24].s:= 'double declaration'
bef[24].a:='Ein Identifier wird in zwei oder mehr Deklarationen verwendet.'

bef[25].s:= 'unknown'
bef[25].a:='Ein Identifier wird in keiner Deklaration verwendet; er ist unbekannt.\n' +
			  'Wahrscheinlich haben Sie vergessen, ihn in eine DEF-Anweisung zu setzen.'

bef[26].s:= 'incorrect #'
bef[26].a:='* Sie haben vergessen "(" oder ")" an die richtige Stelle zu setzen\n' +
			  '* Sie haben eine falsche Anzahl von Argumenten für eine Funktion verwendet'

bef[27].s:= 'unknown e/library'
bef[27].a:='Sie haben einen Identifier mit einem Großbuchstaben begonnen und dann\n' +
			  'mit Kleinbuchstaben fortgesetzt, aber der Compiler konnte keine\n' +
			  'Definition finden. Mögliche Gründe:\n' +
			  '* eine Funktion wurde falschgeschrieben\n' +
			  '* sie haben das Modul miteinzuschließen, das diesen Bibliotheksaufruf\n' +
			  'enthält'

bef[28].s:= 'illegal function call'
bef[28].a:='Erscheint selten. Sie erhalten diesen Fehler, wenn sie seltsame\n' +
			  'Funktionsaufrufe starten, wie z.B. verzweigte WriteF()\as :\n' +
			  'WriteF(WriteF(\ah\a))'

bef[29].s:= 'unknown format code following ""'
bef[29].a:='Sie haben in einer String einen Formatcode verwendet, der unzulässig\n' +
			  'ist. Siehe Kapitel 2F für eine Liste der Formatcodes.'

bef[30].s:= '/* not properly nested comment structure */'
bef[30].a:='Die Anzahl der \a/*\a stimmt nicht mit der Anzahl der \a*/\a überein,\n'+
			  'oder haben eine komische Reihenfolge.'

bef[31].s:= 'could not load binary'
bef[31].a:='<filespec> innerhalb von INCBIN <filespec> konnte nicht gelesen werden.'

bef[32].s:= '"}" expected'
bef[32].a:='Sie haben einen Ausdruck mit "{<var>" begonnen, aber das "}" vergessen.'

bef[33].s:= 'immediate value expected'
bef[33].a:='Manche Konstruktione erfordern einen direkten Wert anstelle eines Ausdrucks.\n' +
			  'Beispiel:\n' +
			  'DEF s[x*y]:STRING   /* falsch, nur etwas wie s[100]:STRING ist zulässig */'

bef[34].s:= 'incorrect size of value'
bef[34].a:='Sie haben einen unzulässig großen/kleinen Wert in einer Konstruktion\n' +
			  'verwendet. Beispiel:\n' +
			  'DEF s[-1]:STRING, +[1000000]:STRING    /* muß 0 ... 32000 sein */\n' +
			  'MOVEQ #1000,D2                         /* muß -128 ... 127 sein */'

bef[35].s:= 'no e code allowed in assembly modus'
bef[35].a:='Sie haben den Compiler als Assembler arbeiten lassen, aber, aus Versehen,\n' +
			'E-Code geschrieben.'

bef[36].s:= 'illegal/inappropriate type'
bef[36].a:='An einer Stelle wo eine <type> Spezifikation notwendig gewesen wäre, haben\n' +
			'sie etwas unpassendes eingegeben. Beispiele:\n' +
			'DEF a:PTR TO ARRAY        /* es gibt keinen solchen Typ */\n' +
			'[1,2,3]:STRING'

bef[37].s:= '"]" expected'
bef[37].a:='Sie haben mit einem "[" begonnen, aber nie mit einem "]" aufgehört.'

bef[38].s:= 'statement out of local/global scope'
bef[38].a:='Ein wesentlicher Punkt bei der Kontrolle ist die erste PROC-Anweisung.\n' +
			'Davor sind nur globale Definitionen (DEF, CONST,MODULE etc.) erlaubt,\n' +
			'und keinerlei Code. Im zweiten Teil sind nur Code, aber keine globalen\n' +
			'Definitionen erlaubt.'

bef[39].s:= 'could not read module correctly'
bef[39].a:='Es gab einen DOS-Fehler beim Versuch, ein Modul von einer MODULE\n' +
			'Anweisung einzulesen. Gründe:\n' +
			'* "emodules:" wurden nicht korrekt zugewiesen (assign emodules: ...)\n' +
			'* der Modulname wurde falsch geschrieben, oder es existiert nicht\n' +
			'* sie haben MODULE \abla.m\a anstelle von MODULE \abla\a'

bef[40].s:= 'workspace full'
bef[40].a:='Erscheint selten. Wenn dieser Fehler erscheint, müssen sie EC mit der\n' +
			  '"-m" Option dazu zwingen, die Schätzung über die benötigte Speichermenge\n' +
			  'höher anzusetzen. Versuchen sie es zuerst mit\a-m2\a, dann \a-m3\a, bis\n' +
			  'der Fehler verschwindet. Sie müssen aber schon riesige Anwendungs-\n' +
			  'programme, mit einer Unmenge Daten schreiben, damit dieser Fehler erscheint.'

bef[41].s:= 'not enough memory while (re-)allocating'
bef[41].a:='Mögliche Lösungen für dieses Problem:\n' +
			  '1. Sie haben andere Programme im Multitasking laufen. Stoppen sie diese\n' +
			  'und versuchen sie es nocheinmal.\n' +
			  '2. Sie haben akuten Speichermangel und der Speicher war fragmentiert.\n' +
			  'Rebooten sie.\n3. Weder 1. noch 2., kaufen sie sich eine Speichererweiterung.'

bef[42].s:= 'incorrect object definition'
bef[42].a:='Sie haben bei einer Definition zwischen OBJECT und ENDOBJECT Blödsinn\n' +
			  'geschrieben. Siehe Kapitel 8F, um herauszufinden, wie\as richtig geht.'

bef[43].s:= 'incomplete if-then-else expression'
bef[43].a:='Wenn sie IF als einen Operator verwenden, dann muß ELSE ein Teil dieses\n' +
			  'Ausdrucks sein: ein Ausdruck mit einer IF-Anweisung muß immer einen Wert\n' +
			  'zurückgeben, aber wenn keine ELSE-Anweisung da ist, kann IF im Prinzip\n' +
			  'nichts tun.'

bef[44].s:= 'unknown object identifier'
bef[44].a:='Sie haben einen Identifier verwendet, den der Compiler als einen Teil\n' +
			  'eines Objekts erkannt hat, aber sie haben vergessen, ihn zu deklarieren.\n' +
			  'Gründe:\n' +
			  '* falsch geschriebener Name' +
			  '* fehlendes Modul' +
			  '* der Identifier innerhalb des Modules wird nicht so geschrieben, wie\n' +
			  'sie es aus den Rom-Kernel-Manuals erwartet haben. Überprüfen sie es mit\n' +
			  'ShowModule. Beachten sie, daß Amiga-System-Objekte auf Assembler\n' +
			  'Identifiern basieren und nicht auf C. Zweitens: Identifier folgen\n' +
			  'dem E-Syntax.'

bef[45].s:= 'double declaration of object identifier'
bef[45].a:='Ein Identifier wurde in zwei Objekt Definitionen verwendet.'

bef[46].s:= 'reference(s) out of 32K range: switch to LARGE model'
bef[46].a:='Ihr Programm wird größer als 32K. Fügen sie einfach \aOPT LARGE\a in\n' +
			  'ihren Quellcode mit ein. Siehe Kapitel 16B.'

bef[47].s:= 'reference(s) out of 256 byte range'
bef[47].a:='Sie haben wahrscheinlich BRA.S oder Bcc.S über eine zu große Distanz\n' +
			  'geschrieben.'

bef[48].s:= 'too sizy expression'
bef[48].a:='Sie haben wahrscheinlich eine Liste von [], möglicherweise [[]],\n' +
			  'geschrieben, die zu groß ist.'

bef[49].s:= 'incomplete exception handler definition'
bef[49].a:='Sie haben unter Umstaänden EXCEPT ohne HANDLE verwendet, oder aber\n' +
			  'auch anders herum. Siehe Kapitel 13 für "exception handling".'

IF con:=Open('con:0/30/640/100/Error Output',1006)
  altstd:=stdout
  stdout:=con
  LOOP
		  WriteF('Error-Name eingeben oder mit "stop" beenden:\n->')
		  ReadStr(con,input);
	IF StrCmp(input,'stop',ALL)
		 BRA x1
	ELSE
		 LowerStr(input);
		 goCLIArgs();
	ENDIF
  ENDLOOP
ELSE
x1: stdout:=stdout
	 Close(con)
ENDIF
	ELSE
	  WriteF('Das Programm muß vom CLI gestartet werden\nAufruf: E-Error')
	  CleanUp(0)
ENDIF
ENDPROC

PROC goCLIArgs()
FOR y:=0 TO 49
	IF InStr(bef[y].s,input,NIL)<>TRUE
	 req(bef[y].a); BRA x
	ELSEIF y=49
	 req('---------------------Unbekannt---------------------------')
	ENDIF
ENDFOR
x: NOP
ENDPROC


PROC req(body)
EasyRequestArgs(NIL,[20,NIL,'E-Error V0.5 von Juri Kern ©1995',body,gd],NIL,NIL)
ENDPROC
