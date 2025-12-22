				  __________________________________________
         ______  |::.                                    .::|  ______
        //_____\ |::::  ASSEMBLERKURS - LEKTION 11		::::| /_____\\
       _\\ O o / |::::::::::::::::::::::::::::::::::::::::::| \ o O //_
       \_/\_-_/_  ------------------------------------------' _\_-_/\_/
        / __|.  \/ /                                      \ \/  .|__ \
       /____|. \__/                                        \__/ .|____\
    .---/   |.  \--------------------------------------------/  .|   \---.
   /   /____|____\      INTERRUPT, CIAA/CIAB, DOSLIB        /____|____\   \
  /                                                                        \
  `-------------------------------------------------------------------------'

Autor: Fabio Ciucci

(Verzeichnis Sorgenti7) - dann schreibe "V Assembler3:sorgenti7"

Jetzt, da Sie den Blitter gründlich kennen, können sie auch weil sie wissen  
wie man den 68000 und den Copper programmiert mit Sicherheit sagen, das sie  
die Amiga-Hardware kennen. Man hört jedoch nie auf zu lernen, und in dieser 
Lektion werden wir weitere Informationen über den 68000 sehen, wie Interrupts,
sowie Listen, die Details von Blitter und Copper anzeigen und endlich die
Verwendung der CIAA- und CIAB-Chips, die wir bisher nur zum Testen der 
Maustaste verwendet haben.
Ich würde sagen, wir beginnen mit neuen Informationen zum 68000, um einen 
besseren Startup als bei LESSON8 zu machen.
Informationen zu exception vectors, Interrupts usw. wird erklärt. Es ist
nicht alles nützlich und unverzichtbar für die Programmierung von Spielen und
Demos, nur ein Teil von ihnen wird uns dienen. 
Also lassen Sie sich nicht von der Menge der genannten Dinge einschüchtern.
In der Praxis werden wir wenig verwenden!
Zunächst muss über die beiden Betriebs-Modi des 680x0 gesprochen werden, das ist
der User- und Supervisor-Modus. Bereits in 68000-2.txt wurde es erwähnt, ohne
zu erklären, dass es "privilegierte" Anweisungen gibt, welche im Supervisor-Modus
ausgeführt werden, dh während einer Ausnahme oder eines Interrupts.
Im Moment haben wir unsere Routinen immer im USER-Modus laufen lassen, dh
im Benutzermodus, da keine privilegierten Anweisungen ausgeführt werden mussten
und weil wir nicht die Vorteile der Prozessor-Interrupts ausgenutzt haben.
Ich muss sagen, dass sich die Ausführungsgeschwindigkeit zwischen User- und
Supervisor-Modus nicht ändert also lassen Sie Ihr Programm als Ausnahme laufen
oder ein Interrupt wird die Ausführung sicherlich nicht stören.
Andererseits wird eine "Ausnahme" so genannt, weil es eine ist. D.h. sie
darf nur in "Ausnahmefällen" vorkommen, zB bei Software Versagen, bekannt als
GURU. Beachten Sie, dass es Gurus gibt, die vom Amiga-Betriebssystem
(wie Exec-Fehler) und andere verursacht werden, die direkt von Motorola 
dem Hersteller vom 680x0 programmiert sind. Zum Beispiel die Fehler von
BUS, DIVISION DURCH NULL usw. oder Träger sind von diesem Typ.
Sie werden bemerkt haben, dass das Betriebssystem die Position des Mauszeigers 
aktualisieren kann, auch wenn wir unsere eigene Routine laufen lassen,
vorausgesetzt, Sie deaktivieren Multitasking nicht durch einen Aufruf von
Disable().
Nun, wie ist der Fall, wenn der Prozessor unsere Schleife ausführt um in jedem
Frame andere Dinge zu aktualisieren? Sie werden sich daran erinnern, wenn
sie die System-Interrupts deaktivieren friert alles ein. In der Tat 
werden Interrupts verwendet um die Ausführung unseres Programms in jedem
Frame zu "unterbrechen", um die eigene Routine durchzuführen und es setzt die
Ausführung unseres Programms an der Stelle fort, wo es verlassen wurde ohne 
dass wir es merkten! Neben Interrupts gibt es noch andere Möglichkeiten, Routinen
in Supervisor auszuführen, z. B. TRAP-Anweisungen, oder Fehler in einem Programm.
Zum Beispiel, wenn es eine Division durch Null gibt, oder der Prozessor
Daten findet, die keiner Anweisung entsprechen, wird Supervising der Routinen 
eine Guru-Meditation des Softwarefehlers ausgeführt.
Die Emulation anderer Prozessoren sorgt beispielsweise dafür, dass jedes
Anweisungsbinärwert des emulierten Prozessors, zum Beispiel ein 80286 oder
der 6502 des Commodores 64 einer Routine entspricht, die die Operationen ausführt, 
als wäre diese Anweisung für diesen Prozessor gemacht (ungefähr!).
In diesem Kurs geht es nicht darum zu lernen, wie man Betriebssysteme 
oder Emulatoren programmiert, da das Amiga-Betriebssystem bereits eins der
besten der Welt ist und die Emulatoren auf dem Amiga unschlagbar sind. 
Diejenigen, die einen Amiga haben, können ihre MacIntosh- und MSDOS-
Programme ausführen lassen und die Spiele des alten C64 und Spectrum spielen.
Aber auch wenn Sie ein Demo oder ein Spiel programmieren möchten oder ein 
Hilfsprogramm wie das protracker / octamed, ist es notwendig, einige Interrupts 
zu verarbeiten.
Viele Demos und Spiele im alten Stil begannen im Supervisor-Mode die 68000
zu senden, schreibt sofort auf die SR und macht seltsame Spiele mit dem Stack.
Nun, viele dieser Spiele funktionieren nicht auf Computern mit 68020, weil
das Statusregister in den fortschrittlicheren Prozessoren mehr Funktionen
hat, was manche Programmierer ignoriert haben und durch Setzen oder 
Zurücksetzen von Bits in großen Mengen haben Sie einen großen Fehler gemacht.
Im Supervisor-Modus ist der Stack (SP) ein "privater" Stack des Supervisor-Modus, 
während auf den User-Stack mit dem USP-Register (User Stack Pointer) zugegriffen 
wird. So ist es im Supervisor-Weg besser mit Bleifüßen dorthin zu gehen, es sei 
denn, sie kennen sich perfekt mit allen neuen Funktionen des 68020/30/40 und auch 
des 68060 aus!
Tatsächlich dient der Benutzermodus genau dazu, zu vermeiden das die Ausführung
von Anweisungen unterschiedliche Auswirkungen auf verschiedene Prozessoren haben 
können. Aber Programmierer haben sich immer größer gefühlt, die Register auf
Supervisor-Weise umzudrehen, mit dem Ergebnis das sie den Ruhm haben
"Programmierer, die nicht inkompatiblen Code können".
Aber lassen Sie uns vorher versuchen, einige Anweisungen im Supervisor-Mode
auszuführen, bevor wir mit der Theorie fortfahren. Unter den vielen Möglichkeiten 
die es gibt eine Routine In Ausnahmefällen laufen zu lassen ist es am "sichersten",
die entsprechende Funktion des Betriebssystems "exec.library / Supervisor" zu 
verwenden. Die Routine erfordert als Eingangsparamter in A5 die Adresse der 
auszuführenden Routine: 

	move.l	4.w,a6			; ExecBase in a6
	lea	SuperCode(PC),a5	; Routine zur Ausführung im Supervisor
	jsr	-$1e(a6)			; LvoSupervisor - Führen Sie die Routine aus
					; (Speichern Sie die Register nicht! Seien Sie vorsichtig!)
	rts				; beenden, nachdem Sie die Routine
					; "SuperCode" in supervisor ausgeführt haben.
					
			
SuperCode:
	movem.l	d0-d7/a0-a6,-(SP)	; Speichern Sie die Register auf dem Stapel
	...							; auszuführende Anweisungen
	...							; wie ein Unterprogramm....
	movem.l	(SP),d0-d7/a0-a6	; Register vom stack nehmen
	RTE	; Return From Exception: wie RTS, jedoch von Ausnahme.


Wie Sie sehen, gibt es nichts Einfacheres.
Die auszuführende Routine können Sie als Subroutine betrachten, mit JSR oder 
BSR aufzurufen, nur das sie mit "JSR - $1e(a6)" aufgerufen wird, nachdem 
die Adresse in A5 eingegeben wurde und natürlich die ExecBase in A6. Am Ende
der kurzen "Supervisor Subroutine", muss anstatt einen RTS für den Rücksprung
ein RTE verwendet werden. Dies ist speziell für die Rückkehr von Ausnahmen 
und Interrupts. An diesem Punkt kehrt der Prozessor zurück und führt die 
Anweisung unter "JSR -$1e(a6)"  genauso aus wie nach einem  "BSR" oder ein
"JSR".
Die Supervisor-Funktion speichert die Register nicht. Also stellen sie sie
mit dem movem wieder her. Ansonsten, falls sie während der Supervisor-Routine
geändert werden, bleiben diese Werte bei der Rückkehr von dieser Routine erhalten.
In dieser Hinsicht rate ich Ihnen, die Register manuell am Anfang und am Ende 
der Supervisor-Routinezu zu speichern und wiederherzustellen. Beachten Sie, dass
der Zugriff auf den SP oder A7 im Supervisor-Modus im Supervisor-Stack (SSP)
und nicht im User-Stack, der als USP aufrufbar ist, gespeichert wird. Das tut
es nicht. Es ist ein Problem, weil der Supervisor-Stack es speichert und 
wiederherstellt wie der User, aber im Falle einer gefährlichen Stack-
Programmierung könnten Sie Krabben mit allgemeiner Implantation nehmen.
In der Listing11a.s. führen wir eine privilegierte Anweisungen aus.
Hier sind die privilegierten Anweisungen, die nur als Supervisor ausgeführt 
werden können:

	ANDI.W	#xxxx,SR
	ORI.W	#xxxx,SR
	EORI.W	#xxxx,SR
	MOVE.W	xxxxx,SR
	MOVE.W	SR,xxxxx
	MOVEC	registro,registro	; 68010+ - Spezialregister für
					; Steuerung cache, MMU, Vektoren wie:
					; CAAR,CACR,DFC,ISP,MSP,SFC,USP,VBR.
	RTE

Es würde auch MOVES, RESET, STOP geben, aber das interessiert uns nicht.
Es ist von geringem Interesse, auf das Statusregister einzuwirken, da dieser Fall 
sehr gefährlich ist (angesichts des Unterschieds der Bits des SR zwischen 68000 
und der anderen 680x0) und es ist nicht wesentlich, ihn zu stören.
Übrigens, wenn Sie zu einer Ausnahme die im Stack gespeichert ist springen
wird neben dem Program Counter auch das Statusregister gespeichert
und zum Zeitpunkt der RTE werden der alte Wert des Programmcounters und der 
alte SR geommen um unter die "JSR - $1e(a6)" zurückzukehren,
es gibt also keine Änderungen, außer während der Ausführung der Ausnahme.
Stattdessen wird uns der MOVEC-Befehl viel mehr interessieren, denn damit können
Sie einen Interrupt verwenden, der auch auf Prozessoren ab 68020+ funktioniert
Sie müssen wissen, wo sich das VBR (Vector Base Register) befindet.
Was die Kontrolle von CACHE angeht, denke ich, ist es besser, sich nicht 
einzumischen, damit der User sie zuerst mit einem Dienstprogrammen aktivieren oder
deaktivieren kann um unser Demo oder unser Spiel zu starten, um die Unterschiede 
der Einstellung bewerten zu können.
Wenn wir stattdessen entscheiden, welche Caches aktiviert und deaktiviert
werden müssen, besteht außerdem die Gefahr, dass Code erstellt wird, der auf dem 
68060 nicht funktioniert und alle neuen RISC-Prozessoren, die es emulieren könnten.
Der MOVEC-Befehl, der erst ab 68010 verfügbar ist, wird zum Kopieren des Inhalts
eines An oder Dx Registers in ein spezielles Registers oder umgekehrt verwendet.
Wir sehen die Sonderregister der 68020:

	CAAR	- CAche Address Register
	CACR	- CAche Control Register
	VBR		- Vector Base Register

Es gibt auch DFC (Destination Function Code), SFC (Source Function Code),
ISP (Interrupt Stack Pointer), MSP (Master Stack Pointer), USP (User Stack
Pointer), aber wir sind nicht an ihnen interessiert, weil sie nur denen dienen, 
die Betriebssysteme programmieren, Emulatoren usw.
Wir müssen jetzt den Wert des speziellen VBR-Registers kennen, dann werden 
wir sehen warum. Um es zu bekommen, nur "MOVEC VBR, d0" zum Beispiel.
Aber was ist das Vector Base Register? Zunächst müssen wir erklären, was ein 
Vektor ist (nicht zu verwechseln mit mathematischen Vektoren oder 3D-Vektoren!).
Zuerst sehen wir die Vektortabelle, dann erklären wir es:

NUM. VEKTOR  OFFSET	Zuordnung und Bedeutung

	0	$0	dient nur zum Zeitpunkt des Resets (SSP start)
	1	$4	dient nur dem Reset, tatsächlich gibt es ExecBase (PC start)
	2	$8	GURU/soft. Fehler: BUS-Fehler
	3	$c	GURU/soft. Fehler: Adressfehler
	4	$10	GURU/soft. Fehler: illegale Anweisung
	5	$14	GURU/soft. Fehler: Division durch Null
	6	$18	Ausnahme generiert durch Anweisung CHK,CHK2 (68020+)
	7	$1c	Ausnahme generiert durch Anweisung  TRAPV (68020+ TRAPCC)
	8	$20	GURU/soft. Fehler: Rechteverletzung
	9	$24	Track (track exception)
	$A	$28	GURU/soft. Fehler: Zeilenemulator %1010 (LINE-A)
	$B	$2c	GURU/soft. Fehler: Zeilenemulator %1111 (LINE-F)
	$C	$30	nicht verwendet
	$D	$34	Coprozessor-Protokollverletzung (68020+)
	$E	$38	Formatfehler (nur 68020, dann CALLM,RTM)
	$F	$3c	Nicht initialisierte Unterbrechung
	...	...

	$18	$60	Versehentliche Unterbrechung

; Hier sind die Vektoren der Interrupts: Dies sind die, die uns interessieren!

	$19	$64	INTERRUPT Level 1 (softint,dskblk,tbe)
	$1a	$68	INTERRUPT Level 2 (ports: I/O,ciaa,int2)
	$1b	$6c	INTERRUPT Level 3 (coper,vblanc,blit)
	$1c	$70	INTERRUPT Level 4 (Kanal audio aud0/aud1/aud2/aud3)
	$1d	$74	INTERRUPT Level 5 (rbf,dsksync)
	$1e	$78	INTERRUPT Level 6 (exter: ciab,int6 + inten)
	$1f	$7c	INTERRUPT Level 7 (Karte hardware extern: NMI)

	$20	$80	abrufbarer Vektor mit TRAP #0
	$21	$84	abrufbarer Vektor mit TRAP #1
	$22	$88	abrufbarer Vektor mit TRAP #2
	$23	$8c	abrufbarer Vektor mit TRAP #3
	$24	$90	abrufbarer Vektor mit TRAP #4
	$25	$84	TRAP Vektor #5, etc. , Ende TRAP #15
	...

	es folgen Vektoren für Fehler des möglichen mathematischen Coprozessors
    und von der MMU, die uns nicht interessieren.


                             -|             |- 
         -|                  [-_-_-_-_-_-_-_-]                  |- 
         [-_-_-_-_-]          |             |          [-_-_-_-_-] 
          | o   o |           [  0   0   0  ]           | o   o | 
           |     |    -|       |           |       |-    |     | 
           |     |_-___-___-___-|         |-___-___-___-_|     | 
           |  o  ]              [    0    ]              [  o  | 
           |     ]   o   o   o  [ _______ ]  o   o   o   [     | ----__________
_____----- |     ]              [ ||||||| ]              [     | 
           |     ]              [ ||||||| ]              [     | 
       _-_-|_____]--------------[_|||||||_]--------------[_____|-_-_ 
      ( (__________------------_____________-------------_________) ) 


Stellen wir uns die Situation eines 68000-Prozessors vor, für den dies nicht
erforderlich ist. Suchen Sie nach dem Wert des VBR-Registers (es existiert nicht 
einmal!).
In diesem Fall ist der Offset genau der Speicherplatz! $0 = $00000000. Bei der
Adresse $4 finden wir die Execbase, während das erste Long (Adresse) bei $0  
normalerweise zurückgesetzt ist. Aber hier "innerhalb" der Position $8 finden 
wir die Adresse der Routine, bei der das Wort "GURU MEDITATION / SOFTWARE FAILURE" 
im Ereignis eines BUS ERROR angezeigt wird. Tatsächlich hat dieser Guru, wie
in 68000-2.TXT zu sehen, eine Nummer, Identifikationsnummer #00000002, dh die 
Trägernummer. Der dritte Vektor enthält die Adresse der Routine, die den Guru 
von ADDRESS ERROR (#00000003) erscheinen lässt und so weiter. In der Praxis 
springt der Prozessor zum Carrier, wenn er einen dieser Fehler findet
entsprechend, welches die Adresse der so auszuführenden Routine enthält
(im supervisor mode) (angesichts der Schwere der Situation!).
Zum Zeitpunkt des Resets werden alle Adressen in die Vektoren vom ROM geschrieben
vom ersten bis zum letzten. Wenn Sie Programme haben, die die Meldungen des
Software-Fehler oder Gurus so ändern, dass sie die Vektoren auf Ihre 
Routinen anstelle von normalen Systemroutinen "zeigen". Natürlich gibt es "legale" 
Möglichkeiten, die Vektoren zu ändern, dh vorbeizugehen an den
Betriebssystemstrukturen und -routinen. Schreiben Sie die Adresse brutal in
ihrer Routine im Träger kann unwirksam oder inkompatibel sein.

Zum Beispiel:

	MOVE.L	#MiaDivisionePerZero,$14.w	; Vektor ersetzen 
										; mit Guru für Div. durch Null.
	rts

MiaDivisionePerZero:
	...
	RTE
	
TUN SIE ES NIEMALS AUS VIELEN GRÜNDEN WIE IN DIESEM BEISPIEL. DER ERSTE IST DAS
BEIM 68020+ NICHT GESAGT WIRD, DASS DIESER VEKTOR AN DER ADRESSE $14 IST. DER 
ZWEITE,ES IST EINE INKOMPATIBLE METHODE MIT MMU UND STRUKTUREN DES AMIGA 
BETRIEBSSYSTEMS.
Theoretisch sollte dieses System jedoch funktionieren, und auf dem Amiga 500
funktioniert es fast immer, solange die Supervisor-Routine gut geschrieben ist.
Die Modifikation der Fehlervektoren / Guru interessiert uns jedoch nur minimal,
weil unser Programm keine zu korrigierenden Fehler enthalten sollte und wenn
zum Guru / Softwarefehler springt!
Auch die Vektoren der "TRAP #xx" -Anweisungen interessieren uns wenig.
Solche Träger wurden in der Vergangenheit verwendet, um in Ausnahmen zu gehen,
aber wir haben bereits einen sichereren Weg über das Betriebssystem gesehen.

Aus Neugier war der "alte" Weg jedoch:

	move.l	$80.w,OldVector		; speichern Sie den alten Vektor TRAP #0
	move.l	#SuperCode,$80.w	; Routine zur Ausführung im Supervisor
								; in den Vektor TRAP# 0 gelegt
	TRAP	#0					; Führen Sie Supercode als Ausnahme aus
	move.l	OldVector(PC),$80.w	; wiederherstellen alten Vektor TRAP #0
	rts							; exit, nach Ausführung der Routine
								; "SuperCode" in supervisor mode.
OldVector:
	dc.l	0
			
SuperCode:
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	...							; auszuführende Anweisungen
	...							; wie ein Unterprogramm....
	movem.l	(SP),d0-d7/a0-a6	; Register vom stack nehmen
	RTE	; Return From Exception: wie RTS, jedoch bei einer Ausnahme.

Wie Sie sehen, können Sie die Funktion des TRAP-Befehls leicht verstehen: In
der Übung, wenn Sie eine "TRAP #0" -Routine ausführen, wird als Ausnahme das 
ausgeführt was an der Adresse enthalten ist. 
Ich bin bei $80, während mit der Anweisung "TRAP #1" $84 usw. ausgeführt wird.
Ebenso enthalten Interrupts die Adresse der Routine die im Falle eines Interrupts 
ausgeführt werden soll. Die alte Art, einen Interrupt zu setzen, war:

	move.l	$6c.w,OldInt6c		; Speichern Sie den alten int Level 3
	move.l	#MioInt6c,$6c.w		; Meine Routine für int Level 3

Am Ende des Programms wurde der alte Interrupt in $6c wiederhergestellt.
In diesem Interrupt wird normalerweise "BSR.w MT_MUSIC" gesetzt, da
dieser Interrupt (VERTB) einmal pro Frame ausgeführt wird.

	                       _----|         _ _ _ _ _ 
	                        ----|_----|   ]-I-I-I-[ 
	    _ _ _ _ _ _ _----|      | ----|   \ `  ' / 
	    ]-I-I-I-I-[  ----|      |     |    |. ` | 
	     \ `   '_/       |     / \    |    | /^\| 
	      []  `__|       ^    / ^ \   ^    | |*|| 
	      |__   ,|      / \  / ^ ^`\ / \   | ===| 
	   ___| ___ ,|__   / ^  /=_=_=_=\ ^ \  |, `_| 
	   I_I__I_I__I_I  (====(_________)_^___|____|____ 
	   \-\--|-|--/-/  |     I  [ ]__I I_I__|____I_I_| 
	    |[] `    '|_  |_   _|`__  ._[  _-\--|-|--/-/ 
	   / \  [] ` .| |-| |-| |_| |_| |_| | []   [] | 
	  <===>      .|-=-=-=-=-=-=-=-=-=-=-|        / \ 
	  ] []|` ` [] | .   _________   .   |-      <===> 
	  <===>  `  ' ||||  |       |  |||  |  []   <===> 
	   \_/     -- ||||  |       |  |||  | .  '   \_/ 
	  ./|' . . . .|||||/|_______|\|||| /|. . . . .|\_ 
	- --------------------------------------------------- 

*******************************************************************************
*		DAS VBR-REGISTER IN DEN 68010 UND SUPERIOR-PROZESSOREN	      *
*******************************************************************************

Sie fragen sich vielleicht, was VBR mit den Trägern zu tun hat. Nun, das Vektor
Base Register ist die Basisadresse zum Hinzufügen von Offsets zum Finden der
der Adresse des Trägers. Wenn das VBR = 0 ist, wird der Interrupt Level 3 
bei $6c, wie in 68000 gefunden, und in ähnlicher Weise wird TRAP #0 gefunden
immer in  $80, und die oben gezeigten Beispiele würden funktionieren. Bei
einem VBR von $10000 würde der Level-3-Interrupt jedoch nicht mehr bei $6c sein,
aber bei VBR + $6c oder bei $1006c! Das selbe gilt für alle anderen Vektoren.
Daher gilt grundsätzlich:

	Adresse des Vekors = VBR + OFFSET

Auf dem 68000-Prozessor ist die Basis immer $0000, so dass das Register VBR nicht 
existiert. VBR ist der privilegierte MOVEC-Befehl. Aber ab 68010 kann der VBR
an andere Orte verschoben werden, auch in FAST RAM. Nach einem Reset wird der 
VBR jedoch immer zurückgesetzt, sowohl auf dem A3000 als auch auf dem A1200
oder A4000. Durch Ausführen von SETPATCH oder anderen Dienstprogrammen wird der 
VBR verschoben.
Tatsächlich funktionieren viele Demos / Spiele für Dateien, wenn sie alleine 
von der Diskette gestartet werden ohne vorheriges Laden des Setpatch. Sie 
funktionieren nicht, wenn sie von der Workbench-Shell geladen werden. 
Einige arbeiten, aber sie sind "stumm", weil sie ihren Interrupt, der nur 
Musik abspielt, in $6c schreiben, obwohl der VBR zum $0000 Vorsprung hat.
Da wir das wissen, überprüfen Sie einfach, ob der Prozessor ein 68000 oder 
ein 68010+ ist, und wenn es ein 68010 oder höher ist, nimm den Wert des VBR
und fügen Sie es dem Vektor, den Sie ändern möchten hinzu.
Hier steht, wie es in der Praxis gemacht wird:

	move.l	4.w,a6		; ExecBase in a6
	btst.b	#0,$129(a6)	; Testen Sie, ob wir auf einer 68010 oder höher sind
	beq.s	IntOK		; Es ist ein 68000! Dann ist die Basis immer Null.
	lea	SuperCode(PC),a5 ; Routine zur Ausführung im Supervisor
	jsr	-$1e(a6)		; LvoSupervisor - Führen Sie die Routine aus
						; (Speichern Sie die Register nicht! Seien Sie vorsichtig!)
	bra.s	IntOK		; Wir haben den Wert von VBR, wir machen weiter ...

;********************** CODE IN SUPERVISOR für 68010+ ************************
SuperCode:
	movem.l	a0-a1,-(SP)	; speichern a0 und a1 auf dem stack
	dc.l  	$4e7a9801	; Movec VBR,A1 (Anweisung 68010+).
						; Es ist hexadezimal, weil nicht alle Assembler
						; das movec assemblieren.
	lea	BaseVBR(PC),a0	; Label, wo der VBR-Wert gespeichert werden soll
	move.l	a1,(a0)		; Speichern Sie den Wert.
	movem.l	(SP)+,a0-a1	; Stellen Sie die alten Werte von a0 und a1 wieder her
	RTE					; Rückkehr von der Ausnahme (exception)
;*****************************************************************************

BaseVBR:
	dc.l	0

IntOK:
	move.l	BaseVBR(PC),a0		; In a0 der Wert von VBR
	move.l	$64(a0),OldInt64	; Sys int lev 1 gespeichert (softint,dskblk)
	move.l	$68(a0),OldInt68	; Sys int lev 2 gespeichert (I/O,ciaa,int2)
	move.l	$6c(a0),OldInt6c	; Sys int lev 3 gespeichert (coper,vblanc,blit)
	move.l	$70(a0),OldInt70	; Sys int lev 4 gespeichert (audio)
	move.l	$74(a0),OldInt74	; Sys int lev 5 gespeichert (rbf,dsksync)
	move.l	$78(a0),OldInt78	; Sys int lev 6 gespeichert (exter,ciab,inten)

	movem.l	d0-d7/a0-a6,-(Sp)	; speichern der Regsiter auf dem stack
	bsr.s	START				; Hauptroutine ausführen
	movem.l	(sp)+,d0-d7/a0-a6	; wiederherstellen der Register vom stack

	move.l	BaseVBR(PC),a0	     ; In a0 der Wert von VBR
	move.l	OldInt64(PC),$64(a0) ; Sys int lev1 gespeichert (softint,dskblk)
	move.l	OldInt68(PC),$68(a0) ; Sys int lev2 gespeichert (I/O,ciaa,int2)
	move.l	OldInt6c(PC),$6c(a0) ; Sys int lev3 gespeichert (coper,vblanc,blit)
	move.l	OldInt70(PC),$70(a0) ; Sys int lev4 gespeichert (audio)
	move.l	OldInt74(PC),$74(a0) ; Sys int lev5 gespeichert (rbf,dsksync)
	move.l	OldInt78(PC),$78(a0) ; Sys int lev6 gespeichert (exter,ciab,inten)
	rts

START:
	move.l	BaseVBR(PC),a0	     ; In a0 der Wert von VBR
	move.l	#MioInt6c,$6c(a0)	 ; Ich lege meine Rout. int. Level 3.
	...
	das Programm ausführen
	...
	rts

Es sollte beachtet werden, dass wenn man den TRAP-Befehl verwenden will,
in a0 das BaseVbr setzen und den Offset $80(a0) machen muss.
Das gleiches gilt für alle Vektoren.
Ab dieser Lektion ist ein neues Startup, include startup2.s, vorhanden
statt startup1.s. Der einzige Unterschied ist, dass es die Anweisungen 
siehe oben enthält, und das BaseVbr-Label beschrieben werden kann für 
ordnungsgemäße Interrupts auf allen Mikroprozessoren. Die Rettung und 
Wiederherstellung der alten Interrupts werden vom Start zusammen mit der
Rettung und Wiederherstellung von DMA- und INTENA-Kanälen durchgeführt.
Eine weitere Änderung ist das Hinzufügen einer Routine, die Mauseingaben 
blockiert und von der Tastatur zum Betriebssystem werden wir sehen, dass 
das Laden der Dateien dienen wird.
Jetzt, wo wir wissen, wie man einen System-Interrupt durch einen eigenen
ersetzt, müssen wir sehen, wie wir unseren Interrupt machen.
Um die folgenden Seiten vorwegzunehmen, spielen wir die Musik über Interrupt,
wie im Listing Beispiel Listing11b.s. Sie werden besser verstehen, wie es 
funktioniert, wenn Sie weiterlesen!

                                |||||
.__________________________.oOo_/o_O\_oOo.____________________________________.
*******************************************************************************
*		WIE MAN EINE INTERRUPT ROUTINE "BAUT"								  *
*******************************************************************************

Das Interrupt-System erlaubt einem externen Gerät oder den Custom Chips
die Ausführung des Programms zu unterbrechen. Um dies zu tun wird im
User mode zu der Routine mit der Adresse welche in einem der 
Interruptvektoradressen (z.B. $6c) steht gesprungen.
Diese Interrupts haben unterschiedliche PRIORITÄTSstufen, die von einem 
Minimumlevel (1) bis zum Höchstlevel (7) reichen. Diese Prioritäten dienen 
dem Fall, dass beim Auftreten eines oder mehrerer Interrupts während der 
Ausführung eines Interrupts. Wird zum Beispiel das normale Programm im Usermodus
durch einen Low-Level-Interrupt, z.B. 2 unterbrochen, und kommt während der 
Ausführung dieser Routine die Anforderung durch einen Interrupt höherer Ebene, 
z.B. 5, wird der Interrupt 2 durch den Interrupt 5, mit höhere Priorität 
unterbrochen. Nach Abarbeitung kehrt er zum Interrupt der Ebene 2 zurück, 
der dann zum normalen Programm im Benutzermodus zurückkehrt. Auf diese
Weise können mehr Interruptroutinen warten, bis die Ausführung abgeschlossen  
ist und je nach ihrem Level werden sie beendet oder zuerst ausgeführt.
Der Grund Interrupts bei den ersten Mikroprozessoren einzuführen ist damit 
verbunden, das unnötiger Strom (Leistung) der CPU aufgrund sehr langer
Warteschleifen verbraucht wird. Wenn Sie zum Beispiel auf den vertical blank 
warten um zu starten, können sie eine Schleife erstellen, die prüft ob die 
Zeile erreicht ist und solange diese Zeile nicht erreicht ist macht der
Prozessor nichts anderes, als in dieser lächerlichen Schleife stecken zu 
bleiben. Beim Warten auf ein bestimmtes Signal für ein paar Sekunden, stellen 
Sie sich vor, wie viel Leistung des Prozessors verschwendet werden würde!
Aus diesem Grund gibt es Interrupts, die dem Prozessor erlauben Programme 
auszuführen, ohne auf "Ereignisse" warten zu müssen. Wenn ein Level 3 Interrupt 
zu jedem vertikal blank generiert wird, kann der Prozessor ein Fraktal oder
ein 3D-Bild berechnen und wenn die Unterbrechung zum Zeitpunkt des vertikal
blank erfolgt wird die Berechnung unterbrochen. Anschließend wird die Routine 
mit der 3D Berechnung, die vor dem Vblank ausgeführt wurde weiter ausgeführt.
Wir kehren zurück, um die 3D-Routine dort fortzusetzen, wo sie vorher aufgehört
hat. Dadurch ist selbst Multitasking möglich, weil Sie drucken oder von der
Diskette lesen können während sie andere Dinge machen können. Auf dem MSDOS-PC 
kann der Prozessor eine Aufgabe ausführen, die von der Diskette oder der 
seriellen / parallelen Schnittstelle unterbrochen wird, und wird dann 
fortgesetzt, sobald diese Interrupts ausgeführt wurden. Der Amiga weist 
6 von 7 verfügbaren Interrupt-Leveln Interruptsignalen von custom chips 
(Blitter, copper, CIA) in bestimmten Situationen zu.
Der siebte Level wird von externen Karten wie dem Action Replay verwendet, weil
die IPL2-IPL0-Leitungen, die sie erzeugen, zum Erweiterungsport geführt werden.

                                 ||||
                            _A_  /oO\
.__________________________(iIi)_\\//_oOo.____________________________________.
*******************************************************************************
*			ANWENDUNG VON INTENA UND INTENAR			      *
*******************************************************************************

Über das INTENA-Register ($dff09a) ist es möglich, einige dieser Interrupts zu
maskieren, das heißt, zu verhindern, dass sie generiert werden.
Es gibt auch ein Register zum Anfordern von Interrupts, das INTREQ ($dff09c).
Diese Register funktionieren wie das DMACON ($dff09a). Tatsächlich entscheidet 
Bit 15, ob die angegebenen Bits gesetzt oder zurückgesetzt werden.
Wie beim DMACON / DMACONR in Lektion 8 sehen wir die "Belegung"
Das INTENA-Register ($dff09a) ist nur zum Schreiben und INTENAR-Register
($dff01c) ist nur zum Lesen:

INTENA/INTENAR ($dff09a/$dff01c)

BIT	NAME	 LEVEL	BESCHREIBUNG

15	SET/CLR			Steuerbit "Set/clear". Bestimmt, ob die Bits die 1 sind
					zurückgesetzt oder gesetzt werden, wie in DMACON.
					die Bits = 0 werden nicht auf Null gesetzt
14	INTEN			Master Interrupt (General Enable Schalter)
13	EXTER	6 ($78)	Externer Interrupt, an der INT6-Leitung angeschlossen
12	DSKSYN	5 ($74)	Wird generiert, wenn das DSKSYNC-Register mit den Daten 
					übereinstimmt. Lesen von der Diskette im Laufwerk. 
					Achten Sie auf Hardwarelader.
11	RBF		5 ($74)	UART-Puffer zum Empfangen des vollen seriellen Ports.
10	AUD3	4 ($70)	Lesen eines Datenblocks aus Kanal Audio 3 beendet.
09	AUD2	4 ($70)	Lesen eines Datenblocks aus Kanal Audio 2 beendet.
08	AUD1	4 ($70)	Lesen eines Datenblocks aus Kanal Audio 1 beendet.
07	AUD0	4 ($70)	Lesen eines Datenblocks aus Kanal Audio 0 beendet.
06	BLIT	3 ($6c)	Wenn der Blitter eine Blittata beendet hat, wird es auf 
					1 gesetzt
05	VERTB	3 ($6c)	Wird jedes Mal generiert, wenn der Elektronenstrahl
					zur Zeile 00 geht, dh zu jedem vertikal blank.
04	COPER	3 ($6c) Sie können es mit copper einstellen, um es zu einem bestimmten 
					Zeitpunkt (Videozeile) zu erzeugen.
					Fordern Sie es einfach nach einer gewissen Wartezeit an.
03	PORTS	2 ($68)	Input/Output Port und Timer, die an die Leitung INT2 
					angeschlossen sind
02	SOFT	1 ($64)	Reserviert für durch Software ausgelöste Interrupts.
01	DSKBLK	1 ($64)	Ende der Übertragung eines Datenblocks von der Diskette.
00	TBE		1 ($64)	Übertragungs-UART-Puffer der seriellen Port leer.

Wie zu sehen ist, ist die Analogie zu DMACON / DMACONR offensichtlich:
-Bit 15 ist sehr wichtig: Wenn es eingeschaltet ist, werden beim Schreiben in 
 $dff09A die Bits auf 1 gesetzt um die zugehörigen Interrupts zu aktivieren. Wenn
 das Bit 15 0 ist, dann werden die Bits mit 1 im Register zum Deaktivieren 
 verwendet, das heißt die damit verbundenen Interrupts werden maskiert.
 Um einen oder mehrere Interrupts wie in DMACON zu aktivieren oder zu deaktivieren
 müssen die relativen Bits auf 1 gesetzt werden. Was bestimmt ob die Interrupts 
 aktiviert oder deaktiviert werden ist Bit 15: wenn es 1 ist werden sie aktiviert,
 während sie bei 0 ausgeschaltet werden. (immer unabhängig von ihrem vorherigem 
 Zustand). Angenommen, Sie wählen aus, welche Bits benötigt werden und entscheiden 
 dann, ob Sie sie aktivieren (0) oder deaktivieren (1) möchten basierend auf 
 Bit 15. Die Bits mit 0 werden weder gesetzt noch zurückgesetzt.

 Nehmen wir ein Beispiel:
			;5432109876543210
	move.w #%1000000111000000,$dff09A ; AKTIVIERT sind die Bits 6,7 und 8
			;5432109876543210
	move.w #%0000000100100000,$dff09A ; DEAKTIVIERT sind die Bits 5 und 8.

- Bit 14 fungiert als allgemeiner Schalter (ebenso wie Bit 9 im DMACON).
  Es kann zum Beispiel zurückgesetzt werden, um vorübergehend alle Interruptlevel
  zu deaktivieren, ohne das gesamte Register zurücksetzen zu müssen.

Sie werden sich an das alte Listing3a.s erinnern, die mit:

	MOVE.W	#$4000,$dff09a	; INTENA - Stop Interrupt

Alle Interrupts wurden blockiert, und mit:

	MOVE.W	#$C000,$dff09a	; INTENA - Interrupt erlauben

								  ;5432109876543210
Alle wurden erlaubt. Nun, $4000 = %0100000000000000, mit anderen Worten, das
MASTER Bit, ist 14. Stattdessen $c000 = %1100000000000000, dh das MASTER Bit 
aktiviert alle Interrupts. In Listing11b.s, um VERTB zu aktivieren:

	move.w	#$c020,$9a(a5)	; INTENA - aktiviert interrupt "VERTB" per
							; Level 3 ($6c), was erzeugt wird
							; einmal pro Frame (an der Zeile 00).

					; 5432109876543210
Tatsächlich, $c020 = %1100000000100000 - Bit 5, VERTB, zusammen mit dem MASTER.

Wie Sie vielleicht bemerkt haben, reichen die Interrupts von der Verwaltung 
der seriellen Schnittstelle um die Synchronisation der Laufwerktracks zu lesen, 
ohne zu speichern weder Blitter noch CIA, noch copper. Alle Interrupt-Ebenen neu 
zu definieren ist aus Sicht der Kompatibilität sehr gefährlich, und es ist auch 
sehr schwierig und spezifisch für diejenigen, die ihr eigenes Betriebssystem 
machen wollen.
Demo- und Spielprogrammierer beeinflussen nur $6c, dh. den Interruptlevel 3, 
welches zB für die Erzeugung synchronisierter Interrupts durch den 
Elektronenstrahl (VERTB - Bit 5) oder auf bestimmte Videozeilen mit dem copper
(COPER - Bit 4) erzeugt werden. Seltener kann es passieren, dass sie es mit 
Interrupts für die Tastaturverwaltung oder andere zu tun haben.
Insbesondere das Laden von einer Diskette mit Hardwareloader ist veraltet, weil 
sie Spiele und Demos machen müssen, die Sie auf Ihrer Festplatte installieren 
können. Aus dem Grund werden uns Disk drive-Interrupts nicht interessieren. Auch
wenn sie ein Spiel machen wollen, welches die serielle Schnittstelle verwendet, die
per Kabel oder Modem verbunden sind, um auf 2 Computern gleichzeitig zu spielen
wäre es besser, legale Anrufe vom Betriebssystem des SERIAL.DEVICE zu verwenden,
anstatt kleine Interrupts die kompatibel mit allen multiseriellen Karten oder neuer
Hardware sind.
				 .
				      ·
				 :    :
				 ¦    ¦
				_|    l_
				\      /
				 \    /
				  \ _!_
				   \/¡

*******************************************************************************
*			WIE IST INTREQ UND INTREQR ANZUWENDEN?		      *
*******************************************************************************

In Listing11b.s haben wir auch INTREQ / INTREQR gesehen. Was ist das?
Möglicherweise haben Sie bemerkt, wie der $6c-Interrupt aufgebaut ist:

MioInt6c:	
	btst.b	#5,$dff01f			; INTREQR - Bit 5, ist VERTB zurückgesetzt?
	beq.s	NointVERTB			; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
nointVERTB:	; 6543210
	move.w	#%1110000,$dff09c	; INTREQ - Löschen Flag BLIT,VERTB,COPER
								; da der 680x0 es nicht von selbst löscht!!!
	rte							; Ende vom Interrupt BLIT,VERTB,COPER


HINWEIS: INTREQR ist das Wort $dff01e / 1f. In diesem Fall handeln wir auf seinem 
	 Byte $dff01f anstatt auf $dff01e, aber es ist immer das Low-Byte von INTREQR.

Die INTREQ / INTREQR-Map ist dieselbe wie die INTENA / INTENAR-Map:

INTREQ/INTREQR ($dff09c/$dff01e)

BIT	NAME	 LEVEL	BESCHREIBUNG

15	SET/CLR			Steuerbit "Set/clear". Bestimmt, ob die Bits die 1 sind
					zurückgesetzt oder gesetzt werden, wie in DMACON.
					die Bits = 0 werden nicht auf Null gesetzt
14	INTEN			Master Interrupt (General Enable Schalter)
13	EXTER	6 ($78)	Externer Interrupt, an der INT6-Leitung angeschlossen
12	DSKSYN	5 ($74)	Wird generiert, wenn das DSKSYNC-Register mit den Daten 
					übereinstimmt. Lesen von der Diskette im Laufwerk. 
					Achten Sie auf Hardwarelader.
11	RBF		5 ($74)	UART-Puffer zum Empfangen des vollen seriellen Ports.
10	AUD3	4 ($70)	Lesen eines Datenblocks aus Kanal Audio 3 beendet.
09	AUD2	4 ($70)	Lesen eines Datenblocks aus Kanal Audio 2 beendet.
08	AUD1	4 ($70)	Lesen eines Datenblocks aus Kanal Audio 1 beendet.
07	AUD0	4 ($70)	Lesen eines Datenblocks aus Kanal Audio 0 beendet.
06	BLIT	3 ($6c)	Wenn der Blitter eine Blittata beendet hat, wird es auf 
					1 gesetzt
05	VERTB	3 ($6c)	Wird jedes Mal generiert, wenn der Elektronenstrahl
					zur Zeile 00 geht, dh zu jedem vertikal blank.
04	COPER	3 ($6c) Sie können es mit copper einstellen, um es zu einem bestimmten 
					Zeitpunkt (Videozeile) zu erzeugen.
					Fordern Sie es einfach nach einer gewissen Wartezeit an.
03	PORTS	2 ($68)	Input/Output Port und Timer, die an die Leitung INT2 
					angeschlossen sind
02	SOFT	1 ($64)	Reserviert für durch Software ausgelöste Interrupts.
01	DSKBLK	1 ($64)	Ende der Übertragung eines Datenblocks von der Diskette.
00	TBE		1 ($64)	Übertragungs-UART-Puffer der seriellen Port leer.


Wofür ist ein Interrupt-request register?
Natürlich um Interrupts anzufordern. Und auch um die Interruptanforderung zu
löschen, nach dem der Interrupt ausgeführt wurde, wenn er automatisch (von den 
Custom Chips) oder manuell (aus unserem Programm) aufgerufen wurde, denn die 
Interruptanforderung wird nach der Interruptausführung nicht automatisch 
gelöscht.

Der INTREQ ($dff09c) wird vom 680x0 verwendet, um die Ausführung eines Interrupts 
zu erzwingen. In der Regel der Software-Interrupt oder vom COPPER, um den
Interrupt COPER an einer bestimmten Videozeile auszuführen. Natürlich sofern eine 
Interruptanfrage gestellt wurde, wenn dieser Interrupt in INTENA nicht aktiviert 
ist, können Sie ein Leben lang warten.

Wenn ein gesetztes Bit in INTREQ gleichzeitig auch in INTENA gesetzt ist und der
zu diesem Bit entsprechende Interrupt tritt auf. Beachten Sie die Besonderheit, 
dass wenn Bit 14 von INTREQ gesetzt ist überprüft es einen der Level 6 Interrupt
(solange das entsprechende Bit in INTENA, Master Enable, ebenfalls gesetzt ist). 
Andererseits werden die Interrupt-Anforderungsbits genutzt um die Interrupt-
anfoderungen die bereits ausgeführt wurden zu löschen, da Interruptanforderungen
nicht automatisch gelöscht werden.
Sie müssen vorsichtig sein, denn wenn Sie vergessen, das Anforderungsbit am Ende 
jedes ausgeführten Interrupts zu löschen, der Prozessor läuft wieder !!
Jetzt solltest du den letzten Teil des Interrupts verstehen:

			 ;6543210
	move.w	#%1110000,$dff09c ; INTREQ - Löschen Flag BLIT,VERTB,COPER
							  ; da der 680x0 es nicht von selbst löscht!!!
	rte						  ; Ende vom Interrupt BLIT,VERTB,COPER


Das INTREQR ($dff01e) ist schreibgeschützt, im Gegensatz zu INTREQ nur Schreiben.
Es muss bekannt sein, welcher Chip den Interrupt angefordert hat. In der Tat, wenn
der Level 3 Interrupt ausgeführt wird ($6c), kann es ein "Fehler" des Blitters
sein, bei vertikal blank oder copper. Durch Testen der INTREQR-Bits wissen wir,
welche dieser 3 Möglichkeiten die Ursache ist und wir bestimmen, welche Routine
durchzuführen ist oder ob die Routine ausgeführt werden soll, falls wir nur an 
einer dieser 3 Quellen interessiert sind. Bit 15 hat im INTREQR keine Bedeutung, 
da es sich um das Set / Clr handelt.
Lassen Sie uns nun die Verwendung in Listing11b.s überprüfen:

	btst.b	#5,$dff01f	; INTREQR - ist Bit 5, VERTB, zurückgesetzt?
	beq.s	NointVERTB	; Wenn ja, ist es kein "echter" int VERTB!

In diesem Fall, da das BTST für eine Adresse nur .BYTE sein kann, wird das $dff01f 
getestet, dh das Low-Byte des Wortes, anstelle des $dff01e. Wenn Sie zu Noint 
springen, ist klar, dass der Interrupt der generiert wurde vom copper oder Blitter
kommt, und Bit 4 oder 6 gesetzt wurden. Aus diesem Grund müssen diese Interrupt-
Anforderungen ebenfalls zurückgenommen werden, um zu verhindern das alle
Mikrosekunden eine erneute Interruptausführung für nichts auftritt.:

			 ;6543210
	move.w	#%1110000,$dff09c ; INTREQ - Löschen Flag BLIT,VERTB,COPER
							  ; da der 680x0 es nicht von selbst löscht!!!
	rte						  ; Ende vom Interrupt BLIT,VERTB,COPER

Es wird Ihnen seltsam erscheinen, dass, obwohl nur VERTB mit INTENA aktiviert ist,
es vorkommen kann, dass COPER- oder BLIT-Interrupts angefordert und ausgeführt
werden. In der Tat sollten sie nicht angefordert oder ausgeführt werden ...
Aber aus Gründen, die wahrscheinlich mit der MMU oder der Prozessorgeschwindigkeit 
zusammenhängen, kann es auf schnelleren Computern als dem Basis-1200, wie dem
A4000, sehr gut passieren, und dies führt in der Tat zu Problemen mit Demos, auch
mit einigen neueren für AGA. In der Tat kann es auf Basis A1200 vorkommen, dass der
Interrupt auch ohne BTST des VERTB-Bit arbeitet. Beim A4000 oder A1200 ist es 
jedoch nicht der Fall. Ich gebe zu, das es "theoretisch" funktionieren sollte, 
aber Tatsache ist, dass viele Demos für den A1200, wenn sie auf dem A4000 gespielt
werden zweimal pro Frame Musik spielen und das ist lächerlich. Seien Sie also 
kategorisch und testen Sie immer die Bits von intreq, bevor Sie den Interrupt 
ausführen, auch wenn alles auf Ihrem Computer funktioniert.

Zusammenfassend, sind folgende Dinge zu tun, um unseren Interrupt einzurichten:

- Holen Sie sich die VBR-Adresse, speichern Sie den alten Interrupt und stellen Sie
  ihn vor dem Ausgehen wieder her. Diese Aufgabe erledigt Startup2.s gut, es gibt
  kein Problem: Die VBR-Adresse befindet sich auf dem BaseVBR-Label.
- Setzen Sie alle Interrupts mit INTENA zurück. Diese Aufgabe wird auch von 
  startup2.s mit einem MOVE.W #$7fff,$9a(a5) ausgeführt.
- Tragen Sie die Adresse unseres Interrupts in den richtigen Eigenvektor ein.
- Aktivieren Sie nur den Interrupt oder die Interrupts, die wir benötigen

Und hier ist, woran Sie denken sollten, in unsere Interrupt-Routine einzubauen:

- Speichere und stelle alle Register mit einem netten MOVEM wieder her, denn stell
  dir vor, was würde passieren, wenn sie am Ende der Interruptroutine zurückkehren
  um das unterbrochene Programm auszuführen und einige Register sind "dirty". Wer 
  weiß welche Situation und wer weiß welche Werte in den Registern stehen!
- Testen Sie das $dff01e/1f (INTREQR) sofort, um herauszufinden, wer oder was den
  einen Interrupt dieser Ebene erzeugt hat. Zum Beispiel kann ein Level3-Interrupt
  durch COPER, VERTB oder BLITTER erzeugt werden und ein Level 4 Interrupt
  von AUD0, AUD1, AUD2 oder AUD3 usw. Achtung, auch wenn es manchmal auch ohne
  diesen Test zu funktionieren scheint, auf A4000 oder ähnlichem wird alles
  gestaffelt funktionieren, als wäre die CPU voll (das kann aber ein besonderer
  Effekt sein!)
- Löschen Sie die INTREQ-Bits ($dff09c), die den ausgeführten Interrupt verursacht
  haben, da sie nicht automatisch gelöscht werden. Wenn du es vergisst erhält der 
  Prozessor die feste Interruptanforderung und wird dadurch kontinuierlich 
  ausgeführt.
- Beenden Sie den Interrupt mit einem RTE, da ein Unterprogramm mit RTS endet.

In Anbetracht dieser Überlegungen schlage ich den ersten Interrupt erneut vor:

	btst.b	#5,$dff01f			; INTREQR - Bit 5, ist VERTB zurückgesetzt?
	beq.s	NointVERTB			; Wenn ja, ist es kein "echter" VERTB Interrupt!
	movem.l	d0-d7/a0-a6,-(SP)	; Register speichern auf dem stack
	bsr.w	mt_music			; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6	; Register vom stack nehmen
nointVERTB:	; 6543210
	move.w	#%1110000,$dff09c	; INTREQ - Löschen Flag BLIT,VERTB,COPER
								; da der 680x0 es nicht von selbst löscht!!!
	rte							; Ende vom Interrupt BLIT,VERTB,COPER


                                  ||||   
                              <---/oO\--®® 
._________________________________\--/________________________________________.
*******************************************************************************
*						INTERRUPT UND BETRIEBSSYSTEM						  *
*******************************************************************************

Der 680x0 hat nur 7 INTERRUPT-Ebenen, aber wie ist es dann möglich, dass ich
in der Praxis 15 Interrupts habe? Nun, der Paula-Chip sorgt für die Aufteilung
der 7 "echten" Interruptlevel in Pseudointerrupts. Zum Beispiel wirkt der Level 3 
Interrupt in drei Fällen: COPER, VERTB und BLIT, und der einzige Weg zu wissen, 
welche dieser drei Quellen den Interrupt ausgelöst hat ist in ein Register, das 
mit dem Paula-Chip selbst verbunden ist, dh INTREQR zu schauen!
Auf der anderen Seite, mit den 7 "echten" Interrupt-Level von 680x0, ist es nicht
möglich bei einem Interrupt der gleichen Ebene "split" durch Paula
zwischen ihnen anzuhalten. Während ein Level 5 Interrupt, wie der DSKSYNC,
die Ausführung eines Level 3 Interrupts, wie COPER unterbrechen kann.
Gleichzeitig ist es nicht möglich, mit BLIT den COPER zu unterbrechen,
auch wenn es laut "Priorität Paulesca" größer ist, da sie auf dem gleichen 
physischen Niveau wie 680x0 sind.
Aus diesem Grund, wenn die Anforderung während der Ausführung eines Interrupts
von einem Interrupt eines anderen Pseudo-Levels von Paula im selben Level 680x0 
auftritt, wie z.B. ein BLIT, während Sie einen COPER ausführen, am Ende des int
Wenn COPER ausgeführt wird, wird sofort der Interrupt von Level 3 ausgeführt.
Diesmal wird die Routine für COPER ausgeführt (entsprechend dem btst).
Auf dem INTREQR wird angegeben, welche Art von "int" ausgeführt werden soll.
Hier sind die Prioritäten der Interrupt-Ebenen im Betriebssystem, dh
in Exec.library, die wie Sie sehen der Hardwarepriorität folgt:


	Level 1: ($64)	KLEINSTE PRIORITÄT'

	1	Übertragungspuffer leeren	TBE
	2	Übertragung Block Disk		DSKBLK
	3	Software Interrupt 			SOFTINT

	Level 2: ($68)

	4	port extern					INT2 & CIAA	PORTS

	Level 3: ($6c)

	5	copper						COPER
	6	Intervall von vertical blank	VERTB
	7	Blitter fertig				BLIT

	Level 4: ($70)

	8	Audiokanal 2				AUD2
	9	Audiokanal 0				AUD0
	10	Audiokanal 3				AUD3
	11	Audiokanal 1				AUD1

	Level 5: ($74)

	12	Empfangspuffer voll			RBF
	13	Diskettensync				DSKSYNC

	Level 6: ($78)		MAXIMALSTE PRIORITÄT'

	14	external INT6 & CIAB		EXTER
	15	spezial (Master)			INTEN

	Level 7: ($7c) (externe Karten wie die Action Replay)

	-	Nicht maskierbare Interrupt	NMI

Die Tatsache, dass das Betriebssystem seine Interruptroutinen verarbeitet, macht
den Ersatz einiger von ihnen durch uns gefährlich.
Bezüglich der Priorität 6 verwendet die graphics.library den Interrupt des
CIAB Time Of Day (TOD) -Timer zur Steuerung des Bildschirms.
In Priorität 5 wird DSKSYNC von TrackDisk und RBF aus dem serial.device verwendet.
In Level 4 gibt es Audiokanäle, die von audio.device verwendet werden. In Level 3
der BLIT-Interrupt, der auftritt, wenn der Blitter eine Operation beendet hat.
Während des Betriebs werden Routinen häufig zur Wiederverwendung der Daten 
verwendet, die gerade vom Blitter geschrieben wurden, um Zeitverschwendung zu 
vermeiden. In Level 2 verwendet der CIAA-Chip Timer.device den TimerA-Interrupt für
die Tastatur-Handshake, der TimerB für den Mikrosekunden-Timer und der Interrupt
TOD-Alarm bei 50/60 Hz. Es gibt auch INT2 für alle äusseren Hardware-Karten.
In Level 1, der niedrigsten Stufe, wird der TBE-Interrupt von Serial.device 
verwendet. Der DSKBLK-Interrupt wird vom TrackDisk.device verwendet. Der SOFTINT-
Interrupts, dh Software, kann über das Betriebssystem definiert werden, zum
Beispiel mit der Funktion Ursachen von Exec oder durch Erstellen eines 
Nachrichtenports vom Typ SOFT_INT.

*******************************************************************************
*		DIE INTERRUPTS COPER AUFGERUFEN VON DER COPPERLIST					 *
*******************************************************************************

Wenn Sie den Interrupt COPER der Level3 ($6c) an einer bestimmten Video-Zeile 
aufrufen möchten, schreiben Sie einfach $8010 in den Intreq ($dff09c), nach einem
wait an dieser Videozeile.

COPPERLIST:
	dc.w	$100,$200	; BPLCON0 - keine bitplanes
	dc.w	$180,$00e	; color0 BLAU
	dc.w	$a007,$fffe	; WAIT - warte auf Zeile $a0
	dc.w	$9c,$8010	; INTREQ - Fordern Sie einen COPER-Interrupt an,
						; wodurch das color0 mit einem "MOVE.W" reagiert.
	dc.w	$FFFF,$FFFE	; Ende der copperlist

Tatsächlich ist der Wert $8010 = $8000 +%10000, dh Bit 4 wird auf COPER gesetzt.

In Listing11c.s sehen wir ein praktisches Beispiel.

Natürlich kann der Interrupt auch jedes Mal auf anderen Zeilen aufgerufen werden
und die "Wirkung" ändern. Sehen wir uns das in Listing11d.s an.

Angesichts der besonderen Komplexität der Interrupts werden wir vorerst keine
Beispiele in Bezug auf Disk Interrupts, serielle Schnittstelle usw nennen.
In Anwendungen, die uns interessieren, nämlich DEMOs und GAMES, sind oft genug
die zwei Arten von Interrupt Level 3 ($6c), die wir gesehen haben, nämlich VERTB,
der zu jedem Frame ausgeführt wird und der COPER der von Copper zu jeder 
Videozeile aufrufbar ist.
Die Anwendungen der anderen Interrupts werden so wie sie in den Beispiellistings
zu finden sind kommentiert, da sie in jedem Bereich reichen!
Im Moment können wir die Verwendung aller Interrupt-Ebenen vorwegnehmen:
In den Listings Listing11e.s und Listing11f.s sind ALLE Interrupts neu definiert
und ALLE Level werden neu defineiert, aber es gibt natürlich nur Routinen in
Level 3. Dieses Beispiel kann als "Start" zur Definition von von beliebigen 
Interrupt-Leveln nützlich sein: Sie können den Level der Sie interessiert
herausschneiden und die Routinen "reinstellen".

   ·          .   .                   .         .               .    .
        .              .             .       .           .               .
   .             .            .  .       .        .
       .           .    ,----|     .   _ _ _ _ _           .      .
            .         . `----|,----|   ]-I-I-I-[       .     .   _ _ _  _ _ _
     _ _ _ _ _ _ ,----|      |`----| . \_`_ '__/      .          ]-I-I--I-I-[
     ]-I-I-I-I-[ `----|  .   |     |    |. `  |.                  \_`__  '_/
      \ `   '_/       |     /^\  . |    | /¯\ |           .        |~_ [],|
       [¯] `__|       |    /  ^\   |    | |_| |     _ _ _  _ _ _  _|______|_
       |__   ,|      /^\  /  ^  \ /^\   | === |     I-I-I--I-I-I <=-=-==-=-=>
    ___| ___ ,|__   /-=-\/=_=_=_=\-=-\  |, `_ |     \ ` `  ' ' /  \__   _'_/
   (__I__I_I__I_ ) (====(_________)___)_| ___ |__    | çÅ$t£e |    |.   _ |
    \-\--|-|--/-/  |     I  [ ]  I  (  I|_I I |I )  _|____ ___|_   |   _  |
     |[] `    '|_  |_   _|`__  ._[  _\ \  | | / /  <=-=- øF -=-=>  |`    '|
    / \  [] ` .| |-| |-| |_| |_| |_| | []   [] |  /\\__ ___ ___/   | '    |
   <===>      .|-=-=-=-=-=-=-=-=-=-=-|  , ,   / \/  \|.    .  | /\ |[]    |
   |[ ]|` ` [] | .   _________   .   |-    , <=======|¦££u$¦øN|<==>|'   __|
   <===>  `  ' ||||  |       |  |||  |  []   <=======|        ||  || '  I-|
    \T/     -- ||||  | çOi!  |  |||  | .  '   \T/--T-T-T-T-T-T|T-T||__.   |
  __/|\   .   .||||| |       | ||||  |. . ¯¯. /|\__|_|_|_|_|_|||_|/ çO¦!`¶4\_
  ¯¯ : \       ||||! ! _o ,  |  ||!  |       / | \ ! ! ! | !.!|  /     ¦    ¯
     ¦  \      !||!   //\/   |  |!   |       \ | /       !   !| /      :
     :          `!   '/\     !  !    !        \!/             !      __¦__
___ _|_______________/ /_  /\________________________________________\  //_ ___
¯¯¯ ¯|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯ ¯¯\/  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯\//¯¯ ¯¯¯
     :                                                                 ¦

*******************************************************************************
* ERWEITERTE INFORMATIONEN ZUM COPPER - NUR FARBE ($180) - KEINE BITPLANES    *
*******************************************************************************

Wie der Titel sagt, werden wir jetzt die möglichen Anwendungen sehen, die nur eine 
copperliste ohne Bitplanes verwenden. Das heißt, Sie erstellen mit WAIT und MOVE 
die Zeichnungen oder Animationen.
Wenn Sie Bitplanes hinzufügen, können Sie natürlich "überkreuzen" und "überlappen".
Diese Effekte ändern die Farbe2 oder die Farbe3 für die copperliste zusätzlich zu
color0.
Zu Beginn ist es jedoch notwendig, einige Dinge zu erklären, die noch nicht 
behandelt wurden. Dies ist die "Zeit", die der copper braucht, um seinen eigenen
MOVE-Befehl zu erbringen. Wir haben bereits gesehen, wie man die gesamte Palette
von 32 Farben an einer bestimmte Videozeile ändert oder um einige Hundert Farben 
auf dem Bildschirm erscheinen zu lassen, wobei nur "32" oder "16" Farben offiziell
in BPLCON0 eingestellt sind.
Nun, in einer Zeile konnten wir 32 Farben ändern, dh die Anzeige
führt 32 MOVEs des coppers aus:

	dc.w	$180,xxx	; 1 move in color0
	dc.w	$182,xxx	; 1 move in color1
	...					; etc.

Nun, eigentlich, wenn wir anfangen, die Farben von der horizontalen Position 
$07 oder sogar $01 aus zu ändern, werden alle 32 Farben tatsächlich 
nur bis in die Mitte des Bildschirms geändert sein, da jede Bewegung 
8 Pixel lowres erfordert um ausgeführt zu werden. Aus diesem Grund ist es immer 
ratsam, 1 Farbe 1 Zeile, bevor die Zeichnung wirklich anfängt zu ändern. Wenn wir 
ein Reihe von MOVE unten setzen, würden wir mit der letzten Zeile unten ankommen!
Andererseits wäre es physikalisch unmöglich, Dutzende von Zügen weniger auszuführen
in einem fünfzigstel einer Sekunde!
Wir können diese offensichtliche Einschränkung jedoch für unsere Zwecke verwenden, 
zum Beispiel, um die Farbe horizontal alle 8 Pixel zu ändern, ohne die WAITs zu 
verwenden, aber einfach durch die Kombination von ungefähr fünfzig COLOR0s pro 
Zeile. Schauen wir uns ein praktisches Beispiel dafür in Listing11g1.s an
Eine Verwendung dieses Listings könnte darin bestehen, die $182 zu ändern, und
nicht die $180, in einem 1-Bit-Bildschirm: auf diese Weise "geschrieben"
würden sie statt von links nach rechts von oben nach unten wie bei der
copperliste üblich überlagert verschwimmen.

In Listing11g2.s und Listing11g3.s gibt es farbenfrohere Versionen dieses
Effekts, so sehr, dass es eine Basis für "PLASMA" -Effekte sein könnte.

Übrigens, wenn wir die Farben einer Zeile davon "rotieren" oder "cycle"
Was hätten wir gerne? Ein sehr bekannter Effekt, der vom Intro schon in den frühen 
Tagen im Amiga benutzt wurde: In Listing11g4.s sehen wir den "Supercar" -Effekt

Vielleicht begeistert das erhöhen des Zyklus von 2 Zeilen nicht. Lassen sie uns
einen Zyklus mehr versuchen, vielleicht einen verknoteten Effekt, wie in 
Listing11g5.s

Eine weitere "Fantasie", die das "Gedränge" von colorXX ausnutzt, ist im Beispiel 
Listing11g6.s zu sehen.

Jetzt sehen wir einen etwas "einfachen" Weg, um etwas Plasmaähnliches zu machen: 
Anstatt den Inhalt der vielen Farben zu ändern, warten Sie jeweils am Anfang der 
Zeile, von denen jede 52 color0 enthält: Wir können die Zeile nach rechts und 
links einfach durch Ändern der horizontalen Position durch verschiedene waits 
verschieben! In der Praxis ist dies in Listing11g7.s

* VERWENDUNG VON COPPER2 (COP2LC/COPJMP2):

Möglicherweise haben Sie bemerkt, dass es zusätzlich zu $dff080 und $dff088
die zum Setzen und Starten von copper 1 erforderlich sind auch $dff084 und 
$dff08a zum Setzen und Starten von copper2 gibt. Aber wie funktioniert copper2?
Und was kann es für uns tun? Mit jedem Frame-Start startet der copper das
copper1, dessen Adresse von $dff080 gelesen wird.
Manchmal fangen wir "on the fly" an, ohne auf das Ende des Frames zu warten,
und schreiben in COPJMP1 oder $dff088.
Wenn wir eine copperliste in $dff084 (COP2LC) einfügen, sollten wir auch das
Starten mit dem Schreiben in COPJMP2 ($dff08a) tun.
Aber am Ende des Frames würde es das copper1 teilen. Mit dieser Funktion
können nun mehrere copperlisten erstellt werden und wir können überspringen,
wie wir es für 680x0-Anweisungen mit "JMP" tun.
Wenn wir zum Beispiel copper1 bis zur Hälfte des Bildschirms ausführen möchten,
um dann die andere Hälfte von copper2 auszuführen würde es genügen die Adresse
von copper 2 am Anfang zu setzen und es dann von der copperliste über copjmp2
zu starten um zu copper2 zu springen.

	move.l	#copper1,$dff080	; COP1LC
	move.l	#copper2,$dff084	; COP2LC
	...
	
	section	copperissime,data_C

copper1:
	...	; verschiedenen Anweisungen...
	dc.w	$a007,$fffe	; warte auf Zeile $a0
	dc.w	$8a,0		; COPJMP2 - start copper 2


copper2:
	...	; verschiedenen Anweisungen
	dc.w	$ffff,$fffe	; Ende copperlist,  verlassen von
						; copper1!


Wenn der copper, angekommen ist bei "dc.w $8a,0" springt er (wie BRA oder JMP) nach
copper2, vorausgesetzt dass vorher in $dff08a geschrieben wurde. Beachten Sie,
dass der Sprung kein "bsr" ist, also nie unter das "dc.w $8a,0" von copper1 
zurückkehrt. Lassen Sie uns nun ein paar praktische Anwendungen von copper2 sehen.
Eine ist die sogenannte Copperdynamik, die sich aus 2 zu jedem Frame ausgetauschten
copperlisten zusammensetzt, wie eine "doppelte Pufferung" der Bitplanes. Damit
machen Sie die Farben "weicher", wenn Sie jeweils 2 Farben in jedem Frame tauschen
haben Sie einen Effekt wie Interlace, der wie die Zwischenfarbe "aussieht".
Bereiten Sie einfach 2 copperlisten mit dem gleichen Farbton vor, aber ein wenig
"außer Phase", und tauschen Sie sie kontinuierlich aus.

Schauen wir uns einen Dynamic Cop in Listing11h1.s an.
Haben Sie den Unterschied bemerkt? Sie können es als AGA-Schatten ausgeben!
Trotzdem wurde die Copperdynamik nur in wenigen Spielen verwendet obwohl es
nicht so schwer zu erstellen ist. Unter den Spielen, die dynamisches copper haben,
erinnere ich mich an AGONY und an das italienische Kampfspiel SHADOW FIGHTER von 
NAPS TEAM.

Nun sehen wir uns eine weitere Anwendung von copper2 an. Anstatt ein Copperlisten-
paar auszutauschen können wir ein paar Dutzend rotieren lassen. Wir können also 
sagen ein Coppereffekt kann "vorberechnet" werden, indem jeweils eine copperliste
pro "Phase" des Effekts berechnet wird: Da der Effekt dann zyklisch ist, reicht es
aus, jedes Mal auf die copperliste "danach" zu setzen.
Auf diese Weise erhalten wir den Coppereffekt, sparen aber VOLLSTÄNDIG Zeit,
was von den 68000-Routinen verwendet worden wäre! Also kannst du sagen, dass der 
fragliche Coppereffekt "KOSTENLOS" ist und wir können uns umdrehen zu der
Routine, die den Rest der Zeit verbraucht.

In Listing11h2.s sehen wir eine "normale" Routine und die vorberechnete Version
des "copper"-Frames, dh Listing11h3.s. Der einzige Nachteil ist das zusätzlicher
Speicher für die "turbulente / vorberechnete" Version verwendet wird, um alle
copperlisten-Frames zu speichern.

Da Sie die Copperprüfung der Stufe 2 bestehen möchten, müssen Sie auch wissen dass
sie die Y-Koordinate der WAITs "maskieren" können. In der Praxis funktioniert ein
Wait mit einem maskierten Y wie folgt:

	dc.w	$0007,$80FE	; Wait bei Y "Maske"

Und das heißt: Überprüfen Sie nicht die Y-Zeile, sondern warten Sie auf die 
X-Position $07 der aktuellen Zeile. Es handelt sich um ein "behindertes" WAIT, 
das nicht weiß, wie die Y-Position zu lesen ist.
In Wirklichkeit kann er die 7 niedrigen Bits der Y-Position nicht lesen, also
funktioniert es nach der Zeile $80. Aber worauf müssen wir dann das Wait maskieren?
Überprüfen Sie die Y-Position vor der Y-Position $80.
Wenn wir einen mythischen Balken verschieben müssten, von denen in Lektion 3,
sollten wir alle Wait-Zeiten ändern, die es ausmachen. Wenn wir stattdessen normal
am Anfang warten und unter allen wait maskiert, wird es genügen, den ersten wait
zu ändern und die anderen "werden folgen". Die Einsparungen beim 680x0-Befehl 
liegen auf der Hand: Ein ganzer Balken wird mit nur einem Add / Sub verschoben.

Wir sehen eine Implementierung in Listing11h4.s. (mythische Bar in Lekion 3!) Wir 
veröffentlichen eine Implementierung in Listing11h4.s (mythische Bar in Lektion 3!)

Beachten Sie, dass es auch unterhalb der vertikalen Linie $FF funktioniert, wenn 
die Nummerierung von $00 erneut gestartet hat. Jetzt wo sie es wissen, können Sie
diesen Trick nutzen, wenn sie in diesem Bereich etwas bewegen.

Jetzt könnten wir über den SKIP-Befehl sprechen, aber da ich die Verwendung noch
nie durch irgendjemanden gesehen habe und ich selbst sehe nicht, was es tun kann
(Sie können ziemlich alle Dinge die copper2 für Sprünge benutzen ...) lasse ich
ihn weg. Ich hoffe, Sie glauben an die völlige Nutzlosigkeit dieses Befehls.

Um das Thema "ONLY COPPER WITHOUT BITPLANES" zu beenden, schlage ich 6
Listings vor, die die häufigsten Auswirkungen dieses Typs zusammenfassen.

Listing11i1.s - eine Vollbild-Farbrolle

Listing11i2.s - eine Pseudoparallaxe mit 3 Stufen von Balken. Es kann als 
Hintergrund für ein Plattformspiel dienen während eines "Aufstiegs" zum Beispiel.

Listing11i3.s - eine kleine COP-Fantasie...

Listing11i4.s - eine pseudozufällige Nuance, die die Werte der Position mischt
horizontal vom Elektronenstrahl (in der Regel unterschiedliche Werte), um 
die Farben des Copperschattens zu machen.

Listing11i5.s - eine copperliste, die die Farben in einer Weise bewegt, die wie 
3D aussieht.

		                 .......
		              .::::::::::.
		       _______j::'__ __:::,__
		     _/¯     /. .-^-.-^-.¯\ ¬\_
		    /        \_ | ® | © |_/    \
		   /      __  T `---'\--'!      \
		  /     __/`  |  ¯¬ _ \¬ \       \
		 /     _/     | _/\ ¬_/ _,\       \
		(      '\     | `  ¯¯ ¯Y   \       \
		 \       \    l____________/        \
		  \      7________________\_        /
		   \     l       ____      (       /
		    \_____\       ¬T       /______/
		     /    \        |       /    /
		    C _ _ ( __     |   __ ( _ _(
		     ¯ T ¯   ¬     |   ¯   T ¯ ¯
		      /¯           ¯\      ¯\ xCz
		  ___/_______________\_______\__
		 (________________)_____________)


*******************************************************************************
*	ERWEITERTE INFORMATIONEN ZUM COPPER - AUCH AKTIVIERTE BITPLANES	          *
*******************************************************************************

Haben sie gesehen, dass wir mit den Copper mit moves und waits einiges anfangen
können? Aber was ist, wenn wir die copperliste komplizierter machen durch 
aktivieren der Bitplanes?
Wir können den bplmod in jeder Zeile ändern, um die Figuren zu dehnen oder
den bplcon1 ($dff102) verwenden, um sie zu schwingen, oder sogar in jeder
Zeile die Zeiger auf die Bitplanes ändern!!!

In den folgenden Listings wird unter anderem ein bestimmtes System verwendet.
Berechnen Sie diwstart / diwstop und ddfstart / ddfstop, dh durch einige
EQUATEs, die dank der Shift "<<" und ">>" sowie "&" (und) und die gebräuchlichen 
"*", "/", "+", "-" Operatoren zur Berechnung von Werten verwendet werden.
Wenn Sie einen normalen Bildschirm in 320 * 256 machen möchten, tun Sie dies
zuerst um die normalen Werte zu setzen oder ändern Sie sie von Hand. Wenn Sie
stattdessen einen Bildschirm mit einer bestimmten Größe machen wollten,
z. B. 256 * 256, kann das Zeit sparen.

scr_bytes	= 40	; Anzahl der Bytes für jede horizontale Linie.
			; Daraus berechnen wir die Bildschirmbreite,
			; multiplizieren von Bytes mit 8: normaler Bildschirm 320/8 = 40
			; zB für einen 336 Pixel breiten Bildschirm 336/8 = 42
			; Beispielbreiten:
			; 264 pixel = 33 / 272 pixel = 34 / 280 pixel = 35
			; 360 pixel = 45 / 368 pixel = 46 / 376 pixel = 47
			; ... 640 pixel = 80 / 648 pixel = 81 ...

scr_h		= 256	; Bildschirmhöhe in Zeilen
scr_x		= $81	; Startbildschirm, XX-Position (normal $xx81) (129)
scr_y		= $2c	; Startbildschirm, YY-Position (normal $2cxx) (44)
scr_res		= 1	; 2 = HighRes (640*xxx) / 1 = LowRes (320*xxx)
scr_lace	= 0	; 0 = non interlace (xxx*256) / 1 = interlace (xxx*512)
ham			= 0	; 0 = nicht ham / 1 = ham
scr_bpl		= 1	; Anzahl Bitplanes

; Parameter automatisch berechnet

scr_w		= scr_bytes*8		; Bildschirmbreite
scr_size	= scr_bytes*scr_h	; Größe des Bildschirms in Bytes 
BPLC0	= ((scr_res&2)<<14)+(scr_bpl<<12)+$200+(scr_lace<<2)+(ham<<11)
DIWS	= (scr_y<<8)+scr_x
DIWSt	= ((scr_y+scr_h/(scr_lace+1))&255)<<8+(scr_x+scr_w/scr_res)&255
DDFS	= (scr_x-(16/scr_res+1))/2
DDFSt	= DDFS+(8/scr_res)*(scr_bytes/2-scr_res)

dann, in copperlist einsetzen:

	dc.w	$8e,DIWS	; DiwStrt
	dc.w	$90,DIWSt	; DiwStop
	dc.w	$92,DDFS	; DdfStart
	dc.w	$94,DDFSt	; DdfStop
	dc.w	$100,BPLC0	; BplCon0

Es ist jedoch nicht "unfehlbar", wenn Sie Bildschirme mit seltsamen Größen
erstellen möchten. Es funktioniert möglicherweise nicht und es ist besser, es
"von Hand" zu machen. Sie können es auch verwenden, um den Wert zu berechnen
und ihn später zu überprüfen.
Assemblieren mit "? DIWS" oder "? xxxx" und dann den Wert von Hand schreiben.
Hier sind die Listings zu diesem Abschnitt:

Listing11l1.s - ändert in jeder Zeile sowohl die Farbe 0 als auch die Farbe 1 
($dff102). Verursachen der Welligkeit der Bitebenen.

Listing11l2.s - in jeder Zeile werden 3 von 4 Farben geändert (2 Bitplanes).

Listing11l3a.s, Listing11l3b.s e Listing113c.s - es sind 3 Schritte 
um den Welleneffekt des AMIGA ET-Logos zu erreichen um das kleine Demo 
auf Datenträger 1 präsentieren zu können. Wir haben alles in Teilen beschrieben!
Die Figur schwankt dank der negativen Modulos, die sich mit den Null Modulos 
abwechseln.

Listing11l4.s - dies ist eine andere Art zu beeinflussen: die 
bplpointers werden in jeder Zeile neu definiert!

Listing11l5.s - wenn Sie ein kleines Bild mit einer Breite von 40 * 29 Pixel
hätten und sie wollten den ganzen Bildschirm ausfüllen was könnten sie tun?
Versuchen Sie einen 8fach Zoom, um es in 320 * 232 zu verwandeln. Das, was
dieses Listing für die horizontale Verlängerung der Modulos verwendet, ist 
eine Routine welche jedes Bit testet und es in ein Byte (8 Bits) "transformiert".

Listing11l5b.s - ist eine optimierte Version des vorherigen Listings, die 
eine Tabelle mit den 256 möglichen Kombinationen eines "erweiterten" Bytes mit
8 Bytes verwendet. Die Ausführung dauert weniger als die Hälfte der Zeit! 
Lerne selbst diese Art von Optimierungen zu machen: Routinen, die unmöglich 
erscheinen schneller zu machen!

* WIE MAN EINEN BILDSCHIRM IN INTERLACE MACHT (Länge 512 Zeilen)

Im Interlaced-Modus können Sie doppelt so viele Videodaten anzeigen.
Dies ist möglich, indem die Anzahl der angezeigten Zeilen verdoppelt wird.
Normalerweise gibt es 256 vertikale Zeilen, während Sie mit dem Interlace 
auf 512 kommen können, sowohl in lowres als auch in hires.
Es gibt jedoch einige Besonderheiten. In der Tat ist es nicht ausreichend, die
Bitebenen auszurichten und das Interlace-Bit (Bit 2 des bplcon0) zu setzen.
Wie für eine RAW-Figur, wandle eine normale Zeichnung mit dem Umwandler
in Interlaced um und speichere es, also als eine Figur in 320x512 oder in
640x512.
Auch ein kleinerer Pinsel ist in Ordnung, aber denken Sie immer daran, dass
das Bild durch die doppelte Auflösung nicht vertikal "abgeflacht" werden darf. 
Bekanntlich ist interlaced "flackernd".
Das ist schlecht, aber auch gut. In der Tat auf normalen Fernsehern oder 
Monitoren wäre eine vertikale Auflösung von mehr als 256 Zeilen nicht möglich,
es wäre ein "VGA" -Monitor, dh Multisync oder Multiscan notwendig.
Der "Trick" wird gemacht, indem nur die 256 ungeraden Zeilen auf einmal 
angezeigt werden und beim nächsten Mal die anderen 256 geraden Zeilen.
Der Wechsel findet in jedem Frame statt, bei dem das Auge getäuscht wird, 
abgesehen nimmt das Flackern stark ab, wenn die Farben gut gewählt sind. 
Dieser Austausch ist jedoch nicht ganz "automatisch", es ist notwendig,
etwas "von Hand" zu tun.

  +-----------------------------------+----------------------------------+
  |    BILD 1 (ungerade Zeilen)       |        BILD 2 (gerade Zeilen)    |
  +-----------------------------------+----------------------------------+
  | ZEILE 1: ---> xxxxxxxxxxxx        |                                  |
  |                                   |       ZEILE 2: ---> xxxxxxxxxxxx |
  | ZEILE 3: ---> xxxxxxxxxxxx        |                                  |
  |                                   |       ZEILE 4: ---> xxxxxxxxxxxx |
  | ZEILE 5: ---> xxxxxxxxxxxx        |                                  |
  |                                   |       ZEILE 6: ---> xxxxxxxxxxxx |
  | ZEILE 7: ---> xxxxxxxxxxxx        |                                  |
  |                                   |       ZEILE 8: ---> xxxxxxxxxxxx |
  | ZEILE 9: ---> xxxxxxxxxxxx        |                                  |
  |                                   |       ZEILE 10: --> xxxxxxxxxxxx |
  |          [...]                    |                                  |
  |                                   |                 [...]            |
  | ZEILE 311: -> xxxxxxxxxxxx        |                                  |
  |                                   |       ZEILE 312: -> xxxxxxxxxxxx |
  | ZEILE 313: -> xxxxxxxxxxxx        |                                  |
  +-----------------------------------+----------------------------------+
 
Für den Interlaced-Modus muss das Modulo neu definiert werden, indem es auf 40
eingestellt wird, wenn wir in lowres sind oder 80, wenn wir in hires sind. In 
der Praxis ist es notwendig, das Modulo auf die Bildlänge einer Zeile zu setzen,
um sie zu überspringen: Das Modulo ist ein Wert, der am Ende jeder Videozeile 
hinzugefügt wird, um die Länge einer ganzen Zeile zu überspringen:
Die erste Zeile wird gelesen und angezeigt, am Ende wird die zweite übersprungen
und die dritte Zeile angezeigt. Am ende wird die vierte Zeile übersprungen und 
die fünfte Zeile angezeigt usw. In der Praxis haben wir dafür gesorgt, dass 
nur die ungeraden Zeilen angezeigt werden.
Die Anzeige kann aber aus Hardwaregründen nicht mehr als 256 Zeilen anzeigen. Aber
niemand zwingt uns, auch nicht ab wann wir anfangen zu visualisieren. Wenn wir
einmal die geraden Zeilen überpsringen und beim nächsten Mal die ungeraden
Zeilen, können wir einen Bildschirm mit 512 Zeilen als einem mit 256 Zeilen 
"alternierend" auf dem Bildschirm anzeigen!

Wir fassen zusammen: Wir haben ein Bild, zum Beispiel in interlaced 640x512, das
wir zu RAW konvertiert haben und möchten es anzeigen. Wir zeigen auf das Bild 
und stellen das Modulo auf 80 richtig ein und setzen Sie das Interlace-Bit
(neben dem von hires) in bplcon0 ($dff100).
Was bekommen wir? DIE FIGUR WIE ES IN LOWRES WAR! 256 ZEILEN HOCH, WIE ES
IN DER LOWRES AUFLÖSUNG IST!

So, jetzt ist die Zeit, diesen kleinen "Hand"-Teil der das Interlacing erlaubt zu 
zeigen. Es gibt ein spezielles Bit, das überprüft werden muss, das uns anzeigt
ob für den Frame ungerade oder gerade Zeilen angezeigt werden sollen. Dies ist
Bit 15 des VPOSR ($dff004), das als LOF oder Long Frame bezeichnet wird und uns
sagt ob wir im "langen Frame" sind oder nicht. Hier ist ein Routinebeispiel:

LACEINT:
	MOVE.L	#BITPLANE,D0	; Adresse Bitplane
	btst.b	#15-8,$dff004	; VPOSR LOF bit?
	Beq.S	Faidispari		; wenn ja, zeigen Sie auf ungerade Zeilen
	ADD.L	#80,D0			; Oder fügen Sie die Länge einer Zeile hinzu,
							; Starten der Ansicht von den geraden Zeilen!
							; zweitens: gerade Zeilen werden angezeigt!

FaiDispari:
	LEA	BPLPOINTERS,A1		; PLANE POINTERS IN COPLIST
	MOVE.W	D0,6(A1)		; Zeiger auf die Figur
	SWAP	D0
	MOVE.W	D0,2(A1)
	RTS

Wie Sie sehen, wenn das LOF-Bit Null ist, wird die Zeile ab dem ersten Bit 
angezeigt. Dadurch wird durch die Wirkung des Modulos die Zeilen 1,3,5,7 ... 
angezeigt etc. oder die ungeraden. Andernfalls überspringen Sie eine Zeile und die
Anzeige startet ab der Sekunde, dann bei den Zeilen 2,4,6,8 ... etc .: GERADE!

Es gibt diejenigen, die zwei Copperlisten erstellen, eine, die auf die eine 
und eine, die auf die andere zeigt und dann je nach Bit LOF wird auf den einen 
oder anderen Frame gezeigt. Ich denke aber es ist "schlauer", nur auf die Bitplane
zu setzen ... Sie können es jedoch tun, wie Sie möchten.
Verstehe einfach die Methode.

Listing11l6.s - ist ein Beispiel in 640x512 bei 1 Bitplane

Listing11l6b.s - ist ein Beispiel in 320x512 bei 4 Bitplanes

Um diesen Studiengang in "copper", Stufe 2 zu beenden, halten wir nicht, sondern
machen ein komplexeres Beispiel auch für Sprites.
Erinnerst du dich, wie wir sie in Lektion7 "wiederverwendet" haben, um die Sterne
zu machen? Was passiert, wenn wir alle 2 Zeilen Sprites wiederverwenden?

Listing11l7.s - hier sehen Sie eine Megaanwendung von Sprites (jeweils 128 Mal)

		        ____::::____
		      _/::__ ·· __  \_
		     ,|:·( o _, o )  |,
		     (|·    (_       |)
		     `l.   _        .j'
		       \   \____/   / Zs!
		  ______\   :l/    /____
		 /:::·· ¬\________/   ::\
		/::·                   ·:\


******************************************************************************
*		DIE 2 CHIPS 8520, DER CIAA UND CIAB									 *
******************************************************************************

Wenn Sie den Amiga zerlegen, finden Sie zusätzlich zum Agnus, Paula, Denise, 
und den 680x0 auch zwei 8520 Chips, genannt CIA. Diese Chips haben 16 Pins
Input / Output jeweils ein serielles Schieberegister, drei Timer, ein einzelner 
Pin Ausgang und einer nur Eingang. Beide haben 16 Register auf die Sie 
über die entsprechenden Adressen zugreifen können:

Karte der Adressen der CIAA
---------------------------------------------------------------------------
 Byte    Register                  Data bits
Addresse   Name     7     6     5     4     3     2     1    0
---------------------------------------------------------------------------
$BFE001    pra     /FIR1 /FIR0  /RDY /TK0  /WPRO /CHNG /LED  OVL
$BFE101    prb     Port parallel
$BFE201    ddra    Datenrichtung für Port A (BFE001);1=output (normalerweise $03)
$BFE301    ddrb    Datenrichtung für Port B (BFE101);1=output (kann sein in/out)
$BFE401    talo    CIAA Timer A Byte niedrig (7.15909 MHz NTSC; 7.09379 MHz PAL)
$BFE501    tahi    CIAA Timer A Byte hoch
$BFE601    tblo    CIAA Timer B Byte niedrig (7.15909 MHz NTSC; 7.09379 MHz PAL)
$BFE701    tbhi    CIAA Timer B Byte hoch
$BFE801    todlo   Timer zu 50/60 Hz - Bits 7-0 (VSync or line tick)
$BFE901    todmid  Timer zu 50/60 Hz - Bits 15-8
$BFEA01    todhi   Timer zu 50/60 Hz - Bits 23-16
$BFEB01            Nicht verwendet
$BFEC01    sdr     CIAA serial data register (mit der Tastatur verbunden)
$BFED01    icr     CIAA interrupt control register
$BFEE01    cra     CIAA control register A
$BFEF01    crb     CIAA control register B

Hinweis: Die CIAA kann einen INT2-Interrupt generieren, d.h. Lev.2, $68.


Karte der Adressen der CIAB
---------------------------------------------------------------------------
 Byte     Register                   Data bits
Addresse    Name     7     6     5     4     3     2     1     0
---------------------------------------------------------------------------
$BFD000    pra     /DTR  /RTS  /CD   /CTS  /DSR   SEL   POUT  BUSY
$BFD100    prb     /MTR  /SEL3 /SEL2 /SEL1 /SEL0 /SIDE  DIR  /STEP
$BFD200    ddra    Datenrichtung für Port A (BFD000);1 = output (normalerweise $FF)
$BFD300    ddrb    Datenrichtung für Port B (BFD100);1 = output (normalerweise $FF)
$BFD400    talo    CIAB Timer A Byte niedrig (7.15909 MHz NTSC; 7.09379 MHz PAL)
$BFD500    tahi    CIAB Timer A Byte hoch
$BFD600    tblo    CIAB Timer B Byte niedrig (7.15909 Mhz NTSC; 7.09379 Mhz PAL)
$BFD700    tbhi    CIAB Timer B Byte hoch
$BFD800    todlo   Timer für horizontalen Synchronisation -  Bits 7-0
$BFD900    todmid  Timer für horizontalen Synchronisation -  Bits 15-8
$BFDA00    todhi   Timer für horizontalen Synchronisation -  Bits 23-16
$BFDB00            Nicht verwendet
$BFDC00    sdr     CIAB serial data register (nNicht verwendet)
$BFDD00    icr     CIAB interrupt control register
$BFDE00    cra     CIAB Control register A
$BFDF00    crb     CIAB Control register B

Hinweis: CIAB kann ein INT6, d.h. Level 6, generieren: $78.

Aus dieser "Karte" können wir ersehen, wie sich die Aufgaben der beiden CIAs aus 
dem Lesen der Tastatur ergeben, zur Verwaltung der seriellen Schnittstelle, (zum 
Datenaustausch zwischen 2 Computern oder zwischen Computer und Modem), die
Verwaltung der parallelen Schnittstelle (z.B. Drucker), um die Laufwerksköpfe zu 
überprüfen, weiterhin die Timer die Mikrosekunden oder Stunden zählen können. 
In der Realität werden wir jedoch aus verschiedenen Gründen nicht an all diesen 
Merkmalen interessiert sein. Zunächst kann der Diskettenlaufwerk-Hardware-Teil 
weggelassen werden, da jedes gute Spiel / Demo respektwürdig sein muss, d.h. auf 
einer Festplatte (oder CD-ROM!) wie Brian The Lion installiert werden kann.
Wie für die Verwaltung des parallelen und des seriellen Anschlusses, die 
Verwendung könnte darin bestehen, einige Anweisungen für das Spiel zu drucken
oder einen Satz, den ein Charakter sagt, oder für die serielle Schnittstelle die
Möglichkeit zu zweit mit den Computern im Netz zu spielen, die mit einem Kabel 
verbunden sind. Aber es muss gesagt werden, dass die Verwaltung des Druckers gut 
ist, um es mit dem Betriebssystem zu tun, mit dem "parallel.device". Gleiches gilt 
für die serielle Schnittstelle: Das serial.device ist sicherlich sicherer als in
Hardware geschriebene Routinen, insbesondere für zukünftige Amigas oder
Multi-Serial-Karten. Wie für die Timer, da das Betriebssystem es für verschiedene 
Aufgaben verwendet. Wir werden sehen, ob und welche zu verwenden sind.
Interessieren wir uns dann aber fast ausschließlich für das Lesen von Tastaturen?
Ja, in der Tat, wenn Sie einen Blick in den Code eines Videospiels werfen würden, 
würden sie bemerken, das nur die Interrupts $6c (coper / vertb / vblank) und $68 
(int2 für Tastatur): Level 3 ($6c) verwendet werden, um Musik oder andere Routinen 
synchron zum Elektronenstrahl zu spielen, während Level 2 ($68) zum
Lesen der Tastatur verwendet wird. Natürlich mit dem Lesen der linken Maustaste 
oder auf andere Dinge wird auf Register zugegriffen, aber dies sind einfache 
Überprüfungen oder BIT-Einstellungen, lange Dissertationen auf  
"btst.b #6,$bfe001" sind nicht erforderlich.
In den Demos ist es sogar einfach, keinen Interrupt neu zu definieren
oder das nur die $6c verwendet wird, um die Musik einzuschalten. Beginnen 
wir also mit der Erklärung der CIAA über die Tastaturverwaltung mit den Registern
$bfec01 (sdr), $bfed01 (icr), $bfee01 (cra) und dem Level 2 Interrupt ($68). 
Zuerst sehen wir die 3 Register getrennt und dann nehmen wir Beispiele für ihre
korrekte Verwendung vor. Wenn eine Taste gedrückt wird, wird ein 8-Bit-Code von 
der Tastatur gesendet oder freigegeben und über $bfec01 wird ein Level 2 Interrupt
($68) erzeugt, welches der Tastatur "mitteilen" muss, dass der Code dieser Taste
(Key) empfangen worden ist.
Beachten Sie, dass dieser Code NICHT der ASCII-Code des gedrückten Zeichens ist, 
sondern ein Code mit der Position der gedrückten Taste in der Tastatur.

****************************************************************************
;* BFEC01    sdr     CIAA sdr (serial data register - verbunden mit der Tastatur)
****************************************************************************

Es ist ein synchrones 8-Bit-Schieberegister, das an die Tastatur angeschlossen ist.
Es kann auf zwei Arten funktionieren: EINGANG oder AUSGANG und die Auswahl unter 
diesen. Es gibt zwei Möglichkeiten, auf das Bit 6 von $bfee01 (cra) zu reagieren.
Im EINGANGS-Modus werden die von der Tastatur empfangenen Daten in das Register 
eingegeben. Ein Bit nach dem anderen und wenn alle 8 Bits des gedrücktem Zeichen,
die es bilden, angekommen sind wird ein Interrupt INT2 ($68) generiert. Um zu 
sehen welche Taste es ist, ist es es notwendig den Wert in eine Variable zu
schreiben. In diesem Fall wird das dem Zeichencode entsprechende Byte gelesen:

	move.b $bfec01,d0

In AUSGANGS-Mode wird stattdessen, in die Register geschrieben, 
z.B. "clr.b $bfec01".

****************************************************************************
;* BFED01    icr     CIAA interrupt control register
****************************************************************************

Dieses Register steuert Interrupts, die von der CIAA generiert werden können.
Tatsächlich erzeugen die CIAs bei verschiedenen Gelegenheiten Interrupts,
beispielsweise wenn ein Countdown-Timer abgelaufen ist oder wenn die serielle 
Schnittstelle eine Übertragung beendet hat.
Besonders interessiert uns der Interrupt INT2, Level 2, also der Vektor
Offset $68, der beim Drücken einer Taste generiert wird.
Die Funktion des icr ($bfed01 für CIAA und $bfdd00 für CIAB) ist sehr
besonders, sie bestehen in der Tat aus einer "Maske" zum Schreiben eines
Nur-Lese-Datenregisters. Aber was heißt das? Zuallererst ist es sehr einfach
Fehler zu machen und CIA-Interrupts können verrückte Sachen machen was nicht
wünschenswert ist. Jeder Interrupt wird aktiviert, wenn das entsprechende Bit der
Maske auf 1 gesetzt wird, und zwar bei jedem CIAA-Interrupt, wie dies der Fall bei 
INTREQ ($dff09c) wäre wo sein Anforderungsbit in diesem Register gesetzt ist.
Wenn dieser Interrupt aktiviert ist, wird zu diesem Zeitpunkt Bit 7 (IR) gesetzt
eine Art set / clr-Bit, wie in dmacon, dh wenn dieses Bit gelöscht wird werden
die anderen 6 gesetzten Bits auf 0 zurückgesetzt, wenn stattdessen Bit 7 gesetzt
ist, werden die anderen gesetzten Bits gesetzt, während diejenigen bei Null nicht
geändert werden.
Das Verwirrende ist, dass beim Lesen des Registers dessen Inhalt zurückgesetzt
wird, unabhängig davon, ob Sie eine "tst.b $bfed01" oder eine Aktion von Lesen
ausführen. Das Zurücksetzen des Registers beseitigt auch die Interruptanforderung,
ähnlich wie beim Nullsetzen der INTREQ-Bits ($dff09c).
Jetzt interessieren wir uns also nur für seine Funktion für den Tastatur-Interrupt.
Wir sehen seine Bits im Lesemodus in Kürze, mit Kommentaren nur, wo es interessant
ist:

CIAA ICR ($bfed01)

BIT	NAME	BESCHREIBUNG

07	IR	Bit, das, falls gesetzt, anzeigt, dass ein Interrupt ausgeführt wird
06	0
05	0
04	FLG
03	SP	Wenn gesetzt, befinden wir uns in einem von der Tastatur erzeugten
	    Interrupt
02	ALRM
01	TB
00	TA

Denken Sie daran, dass dies zurückgesetzt wird, wenn Sie das Register lesen.
Um zu wissen, welche Bits gesetzt wurden, müssen Sie es in ein Dx-Register
kopieren und Prüfungen in diesem Register ausführen: Durch Lesen von $bfed01
werden die Bits gelöscht.

****************************************************************************
;* BFEE01    cra     CIAA cra (control register A)
****************************************************************************

Dieses Register wird "Steuerung" genannt, weil seine Bits die Funktion 
anderer Register steuern. Hier ist eine "Karte", mit Kommentaren nur zu den
Bits, die uns zum Lesen der Tastatur interessieren:

CIA Control Register A

  BIT  NAME		FUNKTION
  ---  ----		--------
   0  START		Timer A
   1  PBON		Timer A
   2  OUTMODE	Timer A
   3  RUNMODE	Timer A
   4  LOAD		Timer A
   5  INMODE	Timer A
   6  SPMODE	Wenn es 1 ist = Register ($bfec01) AUSGANG (um zu schreiben)
				Wenn es 0 ist = Register ($bfec01) EINGANG (um es zu lesen)
   7  Nicht verwendet


Wie Sie sehen, ist das einzige Bit, welches uns interessiert, Bit 6, was die
Funktion des $bfec01 "entscheidet", dh wenn seine Richtung "in Richtung der
Tastatur" (Ausgabe) ist, was wir schreiben können, oder "von der Tastatur zum
Amiga" (Eingabe), so können wir das Zeichen relativ zur gedrückten Taste lesen.
Um den Modus zu wechseln, gehen Sie einfach so vor:

	bset.b	#6,$bfee01		; CIAA cra - sp ($bfec01) output
	....
	bclr.b	#6,$bfee01		; CIAA cra - sp (bfec01) input

Oder, wenn es eleganter erscheint, können Sie AND und OR für false verwenden:

	or.b	#$40,$bfee01	; SP OUTPUT (%0100000, wir setzen Bit 6!)
	...
	and.b	#$bf,$bfee01"	; SP INPUT  (%10111111, zurücksetzen Bit 6!)

Sie können auch "0000" in einem Register verschieben, mit 5 multiplizieren und
aufteilen durch 5, addiere 20, subtrahiere 10, addiere 1, subtrahiere 11, setze
oder zurücksetzen Bit 6 mit dem $bfee01. Der Assembler erlaubt endlose
Möglichkeiten um dasselbe zu tun. Aber das bset / clr kann ausreichen!
Es muss jedoch angegeben werden, dass zwischen dem Eingabemodus und dem
Ausgabemodus etwa neunzig Mikrosekunden gewartet werden muss, weil die CIAA-
Hardware und die die Tastatur im Eingabemodus keine Zeiteinstellung vornehmen kann.
Die 8 Bits des Zeichens, die der gedrückten Taste entsprechen, werden seriell ein 
Bit nach dem anderen vom Tastaturchip zur CIAA übertragen. Wenn alle Bits
übertragen wurden, MÜSSEN wir die KDAT-LINIE MINDESTENS FÜR EINE ZEIT VON 90
MIKROSEKUNDEN (oder 3/4 Rasterzeilen) ZUR BESTÄTIGUNG DER TASTATUR DASS WIR DIE
DATEN ERHALTEN HABEN SENKEN. Der KDAT "Thread" wird vom SP / SPMODE-Bit gesteuert
und in der Praxis müssen wir dies tun:

------------------------------------------------------------------------------
	move.b	$bfec01,d0	; CIAA sdr - Wir lesen den aktuellen Charakter
	bset.b	#6,$bfee01	; CIAA cra - sp ($bfec01) Ausgabe,
						; senken Sie die KDAT-Zeile, um zu bestätigen
						; Wir haben den Charakter erhalten.

	st.b	$bfec01		; $FF in $bfec01 - u ‚! Ich habe die Daten erhalten!

; Hier müssen wir eine Routine setzen, die auf 90 Millisekunden wartet, weil die
; die KDAT-Leitung genügend Zeit haben muss, um von allen Arten von 
; Tastaturen "verstanden" zu werden. Sie können beispielsweise auf 3 oder 4 
; Rasterzeilen warten.

	bclr.b	#6,$bfee01	; CIAA cra - sp (bfec01) erneut eingeben.
------------------------------------------------------------------------------

Wenn Sie die Tastatur über die Hardware lesen, müssen Sie sehr vorsichtig mit dem 
Timing umgehen, das auf 90 Millisekunden wartet, aus zwei Gründen:
1) Die Timing-Routine muss auf allen Prozessoren von 68000 bis 68060 dieselbe Zeit 
   warten. Hierfür können Sie den Elektronenstrahl verwenden oder sogar einen 
   CIA-Timer, aber machen Sie NIEMALS eine einfache Dbra-Schleife oder eine Reihe 
   von NOPs, weil auf 68020+ der Cache im Handumdrehen ausgeführt wird.

2) Wenn unsere Routine auf allen 680x0 gut "wartet", müssen wir auch den Fakt
   bedenken, dass nicht alle Tastaturen gleich sind!
   Beispielsweise können für eine Tastatur zwei Rasterzeilen ausreichen für 
   einen andere könnten es 4 sein! Tatsächlich enthalten die Tastaturen ein Chip,
   der sie steuert, und das kann in den verschiedenen Amiga-Modellen 
   unterschiedlich sein. Zum Beispiel in der A1200 ist die Tastatur
   "wirtschaftlich", in der Tat unterscheidet sie sich von den normalen Amiga-
   Tastaturen (Mitsumi im Allgemeinen) aufgrund der Tatsache, dass man nicht mehr
   als eine Taste zu einer Zeit registrieren kann ...  Wenn Sie eine Taste gedrückt 
   halten und gleichzeitig eine andere drücken, und die erste loslassen erscheint 
   nicht die zweite. Die Wait-Routine muss warten zwischen:
   "or.b #$40" oder "bset.b #6",$bfee01 und "and.b #$bf" oder "bclr.b #6",$bfee01
   Bestimmt, ob Ihr Programm die Tastatur richtig liest oder auf Tastendruck
   auf einigen Computern anschlägt.

In dieser Hinsicht sehen wir, wie man mit vblank richtig wartet:

; Wenn Sie die Adressregister nicht "durcheinander bringen" möchten:

------------------------------------------------------------------------------
	moveq	#4-1,d0		; we wait 4 rasterlines (3+random...!)
waitlines:
	move.b	$DFF006,d1
stepline:
	cmp.b	$DFF006,d1
	beq.s	stepline
	dbra	d0,waitlines
------------------------------------------------------------------------------

; Will man stattdessen noch ein Adressregister "dreckig" machen:

------------------------------------------------------------------------------
	lea	$dff006,a0	; VHPOSR
	moveq	#4-1,d0	; Anzahl der zu wartenden Zeilen = 4 (in der Praxis 3 mehr
					; der Bruchteil, in dem wir uns gerade befinden)
waitlines:
	move.b	(a0),d1		; $dff006 - aktuelle vertikale Zeile in d1
stepline:
	cmp.b	(a0),d1		; sind wir immer noch auf der gleichen Zeile?
	beq.s	stepline	; wenn du wartest
	dbra	d0,waitlines	; zu "wartende" Zeile, warte d0-1 Zeile
------------------------------------------------------------------------------

		                    _  ___
		         _æøæ,_  ¸æ¤³°¤¤4Øæ,
		       ,Ø° __¬¶_æ³       ¬VØø
		    __æV  Ø°4, Ø'  ___     0Ø
		  _ØØØØ#  #_,²J¹  æ°"°4,   IØ
		 ÁØ""ØØØþ_____ØL  #__,Ø¹   ØØ
		JØF  ØØ³°°0ØØØØØ_  ¬~~    JØ#
		ØØ1  ¶Ø_  ,Ø°¤ØØØØæ______øØØØ,
		#Ø1   °#ØØ#   ØØØØØØØØØØØØ¯¬ØQ
		¬ØN     `¢Ø&æØØØØØØØØØØØØ`  ØW
		 ¤Øb       °¢ØØØØØØØØØØ³   JØØ
		  `Øæ         ¬`°°°°"    _dØØ@
		   ¬¢Ø_               __øØØØØ
		     0Ø       ¸___,øøØØØØØØ³
		     VØL_   _øØØØØØØØØØØØ²  xCz
		     ¬ØØØØØØØØØØØØØØØ¤³°
		      ¬ØØØØØØØ°
		        °^°°¯

- MERKMAL DES ZEICHENCODES ZUGEWIESEN IN $bfec01

Wir haben bereits gesagt, dass der übertragene Code kein ASCII-Code ist, sondern
eine Informationen zu der Taste, die gedrückt wurde. Das liegt auch daran, das die
verschiedenen Tastaturen, in Englisch, Italienisch oder anderen, viele Tasten
haben die oben mit einem anderen Buchstaben bedruckt sind. Aber wenn ich sage: die
dritte Taste der zweiten Reihe, können Sie nichts falsch machen. Die 8 Bits
(1 Byte), die wir aus dem  $bfec01 nehmen enthält 7 Bits, die sich auf die
Tastenkennung beziehen, plus einem Bit mit dem festgelegt wird, ob die Taste
gedrückt oder losgelassen wurde. Tatsächlich wird die Tastenkennung gesendet, wenn
Sie drücken und wenn sie loslassen, mit dem Unterschied, dass das höchste Bit, das
achte, zu einer Zeit zurückgesetzt (Null) wird (losgelassen) oder gesetzt ist
(gedrückt). Außerdem werden alle übertragenen Codes vor ihrer Übertragung um ein
Bit nach links gedreht. Die Reihenfolge der Übertragung ist daher 6-5-4-3-2-1-0-7.
Verwenden Sie jedoch nur die Anweisung "ROR.B #1,xxx", um die Reihenfolge 
7-6-5-4-3-2-1-0 zu melden.
Die Übertragung eines Bits dauert 60 Mikrosekunden, daher wird das gesamte Byte
für das Zeichen in 480 Mikrosekunden übertragen. Es können 17000 Bits pro 
Sekunde übertragen werden. Aber was kümmert es uns? Nichts!
Mal sehen, wie man erkennt, ob die gedrückte Taste A, B oder eine andere ist.
Im Hardware-Handbuch gibt es eine Liste mit einem Code pro Taste,
wobei die Besonderheit darin besteht, dass der Code "01" der Taste "1" entspricht.
Um diesen Codes zu erhalten, müssen Sie zusätzlich ein NOT von dem Byte machen und
ein bisschen Rotation mit einem "ROR", um die Reihenfolge 76543210 zurückzugeben.
In der Praxis müssen wir Folgendes tun:

	move.b	$bfec01,d0	; CIAA sdr (serial data register - verbunden
						; mit der Tastatur - enthält das vom Tastaturchip
						; gesendete Byte) WIR LESEN DAS ZEICHEN!
	NOT.B	D0			; Wir passen den Wert durch Invertieren der Bits an
	ROR.B	#1,D0		; und Zurückkehren der Sequenz zu 76543210.

Jetzt haben wir in d0 das Byte mit der Bitfolge 76543210 anstelle von 65432107,
und zusätzlich werden alle Bits invertiert, um das "Konto" von der ersten Taste
oben links zu beginnen (nicht ESC, sondern die neben 1).
Hier ist die Reihenfolge der Codes mit dem relativen Zeichen (normal und
verschoben), aber Beachten Sie, dass die hier beschriebene Tastatur die 
US-Tastatur ist. (Weiterleitungstasten)

	cod.	$00		 ;` - ~
	cod.	$01      ;1 - ! 
	cod.	$02      ;2 - @
	cod.	$03      ;3 - #
	cod.	$04      ;4 - $
	cod.	$05      ;5 - %
	cod.	$06      ;6 - ^
	cod.	$07      ;7 - &
	cod.	$08      ;8 - *
	cod.	$09      ;9 - (
	cod.	$0A      ;0 - )
	cod.	$0B      ;- - _
	cod.	$0C      ;= - +
	cod.	$0D      ;\ - |
	cod.	$0e		 ;  << vuoto (leer)
	cod.	$0F      ;0  Ziffernblock
	cod.	$10      ;q - Q
	cod.	$11      ;w - W
	cod.	$12      ;e - E
	cod.	$13      ;r - R
	cod.	$14      ;t - T
	cod.	$15      ;y - Y
	cod.	$16      ;u - U
	cod.	$17      ;i - I
	cod.	$18      ;o - O
	cod.	$19      ;p - P
	cod.	$1A      ;[ - {
	cod.	$1B      ;] - }
	cod.	$1c		 ; << nicht verwendet
	cod.	$1D      ;1  Ziffernblock
	cod.	$1E      ;2  Ziffernblock
	cod.	$1F      ;3  Ziffernblock
	cod.	$20      ;a - A
	cod.	$21      ;s - S
	cod.	$22      ;d - D
	cod.	$23      ;f - F
	cod.	$24      ;g - G
	cod.	$25      ;h - H
	cod.	$26      ;j - J
	cod.	$27      ;k - K
	cod.	$28      ;l - L
	cod.	$29      ;; - :
	cod.	$2A      ;' - "
	cod.	$2B      ;(nur in Tastaturen international) - Nähe return
	cod.	$2c		 ; << nicht verwendet
	cod.	$2D      ;4  Ziffernblock
	cod.	$2E      ;5  Ziffernblock
	cod.	$2F      ;6  Ziffernblock
	cod.	$30      ;< (shift sin. nur in Tastaturen international)
	cod.	$31      ;z - Z
	cod.	$32      ;x - X
	cod.	$33      ;c - C
	cod.	$34      ;v - V
	cod.	$35      ;b - B
	cod.	$36      ;n - N
	cod.	$37      ;m - M
	cod.	$38      ;, - <
	cod.	$39      ;. - >
	cod.	$3A      ;/ - ?
	cod.	$3b		 ; << non utilizzato
	cod.	$3C      ;.  Ziffernblock
	cod.	$3D      ;7  Ziffernblock
	cod.	$3E      ;8  Ziffernblock
	cod.	$3F      ;9  Ziffernblock
	cod.	$40      ;space
	cod.	$41      ;back space <-
	cod.	$42      ;tab ->|
	cod.	$43      ;return Ziffernblock (enter)
	cod.	$44      ;return <-'
	cod.	$45      ;esc
	cod.	$46      ;del
	cod.	$47		 ; << nicht verwendet
	cod.	$48		 ; << nicht verwendet
	cod.	$49		 ; << nicht verwendet
	cod.	$4A      ;-  Ziffernblock
	cod.	$4b		 ; <<
	cod.	$4C      ;cursor hoch  ^
	cod.	$4D      ;cursor runter v
	cod.	$4E      ;cursor rechts   »
	cod.	$4F      ;cursor links «
	cod.	$50      ;f1
	cod.	$51      ;f2
	cod.	$52      ;f3
	cod.	$53      ;f4
	cod.	$54      ;f5
	cod.	$55      ;f6
	cod.	$56      ;f7
	cod.	$57      ;f8
	cod.	$58      ;f9
	cod.	$59      ;f10
	cod.	$5A      ;(  Ziffernblock
	cod.	$5B      ;)  Ziffernblock
	cod.	$5C      ;/  Ziffernblock
	cod.	$5D      ;*  Ziffernblock
	cod.	$5E      ;+  Ziffernblock
	cod.	$5F      ;help
	cod.	$60      ;lshift (links)
	cod.	$61      ;rshift (rechts)
	cod.	$62		 ;caps lock
	cod.	$63      ;ctrl
	cod.	$64      ;lalt (links)
	cod.	$65      ;ralt (rechts)
	cod.	$66      ;lamiga (links)
	cod.	$67      ;ramiga (rechts)


Wie Sie sehen, entspricht die Reihenfolge ungefähr der Reihenfolge der Tasten,
beginnend mit der Reihe mit 1,2,3,4,5 ... dann die Zeile darunter mit
q, w, e, r, t, y ... usw. Diese Codes beziehen sich auf die FORWARD-Tasten, wo
Bit 7, bestimmt, ob eine Taste gedrückt oder losgelassen wurde, wenn sie bei Null
ist. Tatsächlich haben wir ein NOT auf dem Byte ausgeführt, wodurch auch Bit 8
umgekehrt wurde: wenn die Taste gedrückt ist, ist Bit 8 = 0, wenn eine Taste
losgelassen wird, ist Bit 8 = 1. Wenn die Taste losgelassen wird, muss Bit 7
(das achte) als gesetzt betrachtet werden. So würde die obige Tabelle werden:

	cod.	$80		 ;` - ~
	cod.	$81      ;1 - ! 
	cod.	$82      ;2 - @
	...

Beachten Sie, dass der Amiga600 nicht über den Ziffernblock verfügt, d.h. wenn Sie
die Tasten der Tastatur auf solchen Computern verwenden, gibt es keine Möglichkeit
sie zu drücken! Ich rate Ihnen daher, die Tastaturtasten zu meiden.
In Anbetracht dieser Überlegungen können wir sehen, wie der Interrupt Level 2 ($68)
aussehen wird, mit dem wir in der "ActualKey" - Variable den Code der gedrückten 
Tasten speichern können:

		         ___________
		        /~~/~~|~~\~~\
		        \  \  |  /  /______
		       __\_________/__oOOo_Z________
		      |::888°_~_°888 o¯¯¯T::::Y~~~~~|
		 _    |:::\  °'°  /  __ ||::::|     |
		 \\/Z |::::\ `-' /¯]|··|T|::::|     |
		(\\  )|::::/\`='/\¯  ¯¯  |::::l_____j
		 \¯¯/ ~Z   \ ¯¯¯ /~~~~~~~/~~~~~~~~~~~
		 /¯¯\_/     \ _ /  _    /
		 \   /   /T  (Y)   |\__/
		  \_____/ |   ¯    |
		          |   :    |
		          |        |
		          |   .    | ppX

*****************************************************************************
*	INTERRUPTROUTINE $68 (Level 2) - Tastatur-Verwaltung
*****************************************************************************

;03	PORTS	2 ($68)	Input/Output Porte und Timer, verbunden mit INT2-Leitung

MioInt68KeyB:	; $68
	movem.l d0/a0,-(sp)	; speichern der Registerauf dem Stack
	lea	$dff000,a0		; Register custom für offset

	MOVE.B	$BFED01,D0	; Ciaa icr - in d0 (Lesen der ICR, die wir verursachen
						; auch seine Nullsetzung, so ist das int
						; "gelöscht" wie in intreq).
	BTST.l	#7,D0		; bit IR, (interrupt cia autorisiert), zurückgesetzt?
	BEQ.s	NonKey		; wenn ja, beenden
	BTST.l	#3,D0		; bit SP, (interrupt der Tastatur), zurückgesetzt?
	BEQ.s	NonKey		; wenn ja, beenden

	MOVE.W	$1C(A0),D0	; INTENAR in d0
	BTST.l	#14,D0		; Bit Master der Aktivierung zurückgesetzt?
	BEQ.s	NonKey		; wenn ja, interrupt ist nicht aktiv!
	AND.W	$1E(A0),D0	; INREQR - in d1 bleiben nur die Bits gesetzt
						; welche sowohl in INTENA als auch in INTREQ gesetzt sind
						; um sicher zu sein, dass wenn der Interrupt
						; auftritt, auch aktiviert ist.
	btst.l	#3,d0		; INTREQR - PORTS?
	beq.w	NonKey		; Wenn nicht, dann beenden!

; Wenn wir nach den Kontrollen hier sind, heißt das, dass wir das Zeichen
; übernehmen müssen!

	moveq	#0,d0
	move.b	$bfec01,d0	; CIAA sdr (serial data register - verbunden
						; mit der Tastatur - enthält das vom Tastaturchip
						; gesendete Byte) WIR LESEN DAS ZEICHEN!

; wir haben den char in d0, wir "arbeiten" daran...

	NOT.B	D0			; Wir passen den Wert durch Invertieren der Bits an
	ROR.B	#1,D0		; und Zurückkehren der Sequenz zu 76543210.
	move.b	d0,ActualKey	; speichern des Zeichens

; Jetzt müssen wir der Tastatur mitteilen, dass wir die Daten aufgenommen haben!

	bset.b	#6,$bfee01	; CIAA cra - sp ($bfec01) Ausgang, 
						; senken der KDAT-Zeile, um zu bestätigen
						; das wir den Charakter erhalten haben.

	st.b	$bfec01		; $FF in $bfec01 - Ich habe die Daten erhalten!

; Hier müssen wir eine Routine einstellen, die 90 Mikrosekunden wartet, weil die
; KDAT-Leitung genügend Zeit haben muss, um von allen Arten von Tastaturen 
; "verstanden" zu werden. Sie können beispielsweise auf 3 oder 4 Rasterzeilen
; warten.

	moveq	#4-1,d0	; Anzahl der zu wartenden Zeilen = 4 (in der Praxis 3 weitere)
					; der Bruchteil, in dem wir uns gerade befinden)
waitlines:
	move.b	6(a0),d1	; $dff006 - aktuelle vertikale Zeile in d1
stepline:
	cmp.b	6(a0),d1	; sind wir immer noch auf der gleichen Zeile?
	beq.s	stepline	; wenn ja, warte
	dbra	d0,waitlines	; "erwartete" Zeile, warte d0-1 Zeilen

; Nachdem wir gewartet haben, können wir $bfec01 im Eingabemodus melden ...

	bclr.b	#6,$bfee01	; CIAA cra - sp (bfec01) erneut eingeben.

NonKey:		; 3210
	move.w	#%1000,$9c(a0)	; INTREQ Anfrage entfernen, int ausgeführt!
	movem.l (sp)+,d0/a0		; wiederherstellend der Register vom Stack
	rte

-----------------------------------------------------------------------------

Sie hätten nichts Neues bemerken sollen, es ist nur eine "Zusammenfassung" der
Dinge, die wir bereits erklärt haben. Dann sind es letztendlich nur ein paar
Zeilen und wir verwenden nur die Register d0 und a0, es ist keine COMPLICATA -
Routine! Das Einzige, woran Sie sich erinnern müssen, ist, diesen Interrupt in
den Vektor $68 + VBR einzufügen, und aktivieren Sie es, indem Sie Bit 3 von
INTENA ($dff09a) setzen.
Zum Beispiel, wenn Sie einen Level 3 Interrupt ($6c) verwenden, um die
Musik zu spielen, die nur VERTB (Bit 5) verwendet, können Sie schreiben:

			 ; 5432109876543210
	move.w	 #%1100000000101000,$9a(a5)   ; INTENA - nur VERTB aktivieren
										  ; von Level 3 und Level 2

Oder anders ausgedrückt "move.w #$c028,$dff09a".

Wir können die korrekte Verwendung dieses Interrupts in Listing11m1.s sehen

In diesem Listing wird der Tastaturcode in Farbe 0 eingegeben, um
die tatsächliche Funktionsweise der Routine zu "sehen".
Zum Verlassen drücken Sie eine Taste: die Leertaste.

Der Einfachheit halber ist in Listing11m2.s eine rudimentäre Routine für die
Konvertierung von ASCII-Tastaturcodes enthalten, die bei Bedarf verwendet werden
kann damit Sie drucken können, was mit der Tastatur geschrieben wurde, zum
Beispiel, wenn Sie sich selbst ein Hilfsprogramm machen oder einfach Ihren Namen
schreiben möchten in den Highscore Ihres Spiels.

		             ___________
		            (          ¬)
		             \_       _/
		              L       L
		         ____/___   ___\____
		        //¯¯¯¯¯¯\\_//¯¯¯¯¯¯\\
		       ((     ___¯¯¯___     ))
		        \\ _/\___\X/___/\_ //
		         \ T     \ /     T /
		           |      T      |
		         __|   - o|O -   |__
		     tS / ¬|      |      | ¬\ tS
		\      / / ¯\_____T_____/¯ \ \      /
		->----/ /\      /   \      /\ \----<-
		/     \   \    (_____)    /   /     \
		       \   \_/\_______/\_/   /
		        \_________A_________/

*****************************************************************************
;		TIMER CIAA UND CIAB
*****************************************************************************

Diese Timer werden in Spielen nur sehr wenig verwendet und in Demos fast
nie. Nur in bestimmten (komplizierten) Routinen, die Musik spielen, die
sich selbst einbeziehen und allein spielen.
Diese Timer werden unter anderem auch vom Betriebssystem verwendet, d.h.
wenn wir sie verwenden, können wir riskieren, das unser Programm verrückt 
aussteigt.
Wenn Sie mit $dff006 auf die Rasterzeilen warten, können Sie alle 
Erwartungen denen sie dienen ausführen, ohne diese Eventualitäten zu riskieren.
Aus diesem Grund gibt es in der Lektion nur einige Listings, die die 
Timer, als Beispiel verwenden. In weiterführenden Lektionen werden wir
nach Anwendungen für diese Timer suchen, und wir werden sie von Fall zu 
Fall prüfen.

Listing11n1.s	- Verwendung von Timer A von CIAA o CIAB

Listing11n1b.s	- Verwendung von Timer B von CIAA o CIAB

Listing11n2.s	- Verwendung von TOD (Time of day)

Berücksichtigen Sie bei der Verwendung von CIA-Timern, dass das Betriebssystem
diese für folgende Zwecke verwendet: (besser die CIAB verwenden!)

   CIAA, timer A	benutzt als Tastaturschnittstelle

!  CIAA, timer B	wird von EXEC für den Taskaustausch verwendet etc.

   CIAA, TOD		50/60 Hz Timer benutzt von Timer.device 
  
   CIAB, timer A	Nicht verwendet, für Programme verfügbar

   CIAB, timer B	Nicht verwendet, für Programme verfügbar

   CIAB, TOD		Wird von der graphics.library verwendet, um der
					Positionen des Elektronenstrahls zu folgen

Wenn Sie Timer verwenden müssen, die auch dem Betriebssystem dienen, dann
machen Sie das einfach, wenn Sie Multitasking und System-Interrupts deaktiviert 
haben, dh wenn sie die vollständige Kontrolle über das System haben. 
Niemals die CIAA, Timer B!

                                                              |||||
              |||||                                       _A_ /o O\
_   _ ___.oOo _o_O_ oOo. __ ____ ___ _ _ _____ _ _ _ _   (_^_)_\_/ _oOo. _  
*****************************************************************************
;		LADEN VON DATEIEN MIT DER DOS.LIBRARY
*****************************************************************************

Um diese Lektion voll von Verfeinerungen und verschiedenen Themen abzuschließen,
gibt es kein besseres Thema als das DATA LOADING.
Wenn Sie etwas "Großes" programmieren wollen, aus der Sicht der Größe von
verschiedenen Bildern, Musik und Daten, bei denen man nicht einfach alles mit 
incbin einbeziehen kann und in eine mega ausführbare Datei mit "WO" speichern
kann, da die Datei zu groß werden würde, um in den Speicher geladen zu werden.
Angenommen, Sie möchten eine Diashow erstellen, dh ein Programm, das eine Reihe 
von Bildern nacheinander anzeigt, z.B. bei 30 Bilder, mit jeweils 100 KB kommen 
3 MB an Daten zusammen. 
Wir sind nicht in der Lage, eine Serie von 30 INCBIN zu machen, um eine 3MB-Datei 
zu speichern und zu übergeben. Wir müssen einen Weg finden, um einen nach dem 
anderen zu "laden".
Aber welchen Weg soll man benutzen? Es gibt hauptsächlich 2:

1) AUTOBOOT-LADEN VON DEN TRACKS DER DISKETTE, das ist ein Nicht mit DOS
   kompatibler Modus. In der Tat werden Sie feststellen, dass viele Spiele-
   Disketten, wenn sie nach dem Laden der Workbench in das Laufwerk eingelegt
   werden, nicht lesbar mit Befehlen wie "DIR" sind und NOT DOS oder FALSCH sind
   ... kurz, sie scheinen wie faule Aufzeichnungen! Beim Kopieren über Kopierer
   wie XCOPY oder DCOPY werden einige dieser Nicht-Dos-Spiele als "ROTE" Titel
   angezeigt, das heißt sie sind nicht einmal vom Kopierer zu erkennen, während
   andere trotz das sie von der DOS her unleserlich sind, als "GESUND" 
   erscheinen, also mit grünen Spuren.
   Ich muss darauf hinweisen, dass die CRACKED-Spiele (ohne Schutz und von Piraten 
   vertrieben) alle vom zweiten Typ sind, dh saubere Spuren haben. In der Tat geht
   es beim Schutz oft darum, die Inkompatibilitäts-Spuren in kopierbare Spuren 
   umzuwandeln, aber oft bleiben sie von der DOS unleserlich. Die TRACKMOs sind
   die Mehrheit der Demos, und sie haben "kopierbare" Spuren, aber sind nicht über
   DOS lesbar. Eine Eigenschaft ist, dass wir Code für Adressen absolut schreiben
   müssen, die nicht verlagerbar sind, daher wird meist nur der erste Mega von CHIP
   RAM, oder für 1200 die ersten 2 MB verwendet, und etwaige Erweiterungen von FAST
   RAM wird nicht verwendet, außer solchen, die COMPLEX LOADERS WITH RELOCATORS
   verwenden, die wie Mini-Betriebssysteme aussehen, aber häufig Aussetzer auf 
   68040 aufgrund der übermäßigen "Überschwänglichkeit" der Programmierung haben.
   Dieses System hat den "Vorteil", etwas schneller von Diskette zu sein, von 
   der normalen DOS, aber der Nachteil, nicht in der Lage zu sein, das Programm auf
   die Festplatte zu installieren, noch kann es für CD32 etc. konvertiert werden.

2) "LEGALES" LADEN UNTER VERWENDUNG DER DOS.LIBRARY, ähnlich wie 
   es von jedem Programm verwendet wird, das das Betriebssystem verwendet,
   compiliert mit jeder Sprache wie C, AMOS etc.
   Eigentlich behalten wir unsere copperliste und arbeiten an den Hardware-
   Registern und wir machen ein "hybrides" System, dh wir verwenden die dos.library
   in einem und geben mit unserer copperliste und unseren Interrupts "besondere"
   an. Ein Merkmal der Programme, die dieses System verwenden, ist das das
   Betriebssystem "intakt" bleiben muss und der Code muss vollständig verlagerbar
   sein (Zugriff auf FAST RAM). Dieses System hat den Vorteil, dass es auf
   Festplatte, CD-ROM verwendet werden kann und jedes vom System unterstützte
   Laufwerk auch zukünftige Peripheriegeräte.

Obwohl das erste System für jemanden, der es in Hardware-Programmierung möchte, 
ansprechender erscheint, ist es in Wirklichkeit ein alter Modus,
OFT INKOMPATIBEL und einschränkend, da die Installation des Programms (oder Demos)
auf HD nicht möglich ist. Solange wir über ein Demo oder ein Spiel 
für den Amiga 500 für nur 1 Diskette sprechen, ist die Option Trackloader  
vielleicht akzeptabel, aber ab 2 Disketten führt das System nur noch zu Wut für
Festplattenbesitzer, die immer mehr werden.
Ein auf HD installiertes Spiel wird immer schneller geladen sein als eines von
der Diskette mit dem größtmöglichen Turbolader.
Dann gibt es den FAST RAM Ansatz: um es mit einem Trackloader benutzen zu können
wäre es notwendig, ein Mini-Betriebssystem zu erstellen, das findet, wo es sich
befindet und den Code an die richtige Adresse verschiebt. Ich habe nicht die
Absicht, Ihnen das Listing eines dieser Lader + Umsetzer anzubieten, um Sie nicht
auf den falschen Weg zu bringen. Denken Sie an die Zufriedenheit, Ihr Spiel in die
CD32 konvertieren zu können oder um zu sehen, wie es auf dem 68060 und einer
beliebigen Festplatte ausgeführt wird, stattdessen ist die Enttäuschung, wenn der
Umsetzer "von Hand" scheitert zu sehen oder zu bemerken das das Programm keinen
FAST RAM benutzt  .... hab ich dich überzeugt?

Es gibt noch eine andere Sache: Es wäre gut, den Befehl "assign" für unsere 
Produktionen zu verwenden, wo sie Dateien hochladen müssen. Zum Beispiel, wenn wir
eine Diskette abspielen und der Diskette den Namen "Cane" geben, können Sie die 
Datei mit "Cane: Datei1", "Cane: Datei2", "Cane2 / objects / ogg1" usw. laden
Wenn Sie auf der Festplatte installieren möchten, reicht es aus, ein Verzeichnis
zu erstellen, dort kopieren Sie den Inhalt des Datenträgers rein und fügen ihn der 
startup-sequence hinzu:

	assign	Cane: dh0:giococane	; zum Beispiel...

Wenn das Spiel über mehrere Disketten verfügt, kopieren Sie einfach alle
Disktetten in Verzeichnisse und nehmen die Zuordnung jedes Datensatzes vor:

	assign	Cane1: dh0:giococane
	assign	Cane2: dh0:giococane
	assign	Cane3: dh0:giococane

Hinzufügen "automatisch" zur startup-sequence oder zum user-start. Die
erforderlichen Zuweisungen können während der Installation des Spiels verwendet
werden Optionen des Commodore-Installers oder anderer Systeme, dies liegt jedoch
außerhalb des Kurses.

Nun, lassen Sie uns sehen, wie eine "path: xx" -Datei in ein Ziel-Speicher 
geladen wird. Es gibt verschiedene Möglichkeiten. Das einfachste ist das:

CaricaFile:
	move.l	#filename,d1	; Adresse mit String "Dateiname + Pfad"
	MOVE.L	#$3ED,D2		; AccessMode: MODE_OLDFILE - Datei, die 
							; schon existiert, damit wir lesen können.
	MOVE.L	DosBase(PC),A6
	JSR	-$1E(A6)			; LVOOpen - "Öffnen" der Datei
	MOVE.L	D0,FileHandle	; Speichern des handle
	BEQ.S	ErrorOpen		; Wenn d0 = 0 ist, liegt ein Fehler vor!

	MOVE.L	D0,D1			; FileHandle in d1 für das Lesen
	MOVE.L	#buffer,D2		; Ziel-Adresse in d2
	MOVE.L	#42240,D3		; Dateilänge (GENAU!)
	MOVE.L	DosBase(PC),A6
	JSR	-$2A(A6) ; LVORead - Lesen Sie die Datei und kopieren Sie sie in den Puffer

	MOVE.L	FileHandle(pc),D1	; FileHandle in d1
	MOVE.L	DosBase(PC),A6
	JSR	-$24(A6)				; LVOClose - schließe die Datei.
ErrorOpen:
	rts


FileHandle:
	dc.l	0

; Textzeichenfolge, um mit einer 0 zu enden, auf die Sie mit d1 vorher zeigen 
; müssen mach das ÖFFNEN der dos.lib. Es ist besser, den gesamten Pfad zu setzen.

Filename:
	dc.b	"Assembler3:sorgenti7/amiet.raw",0	; Pfad und Dateiname
	even

Dies ist perfekt, wenn Sie die genaue Länge der zu ladenden Datei kennen.
Als unser Programm sollten wir wissen, wie lang unsere Datendateien sind!

Schauen wir uns ein Beispiel in Listing11o1.s an. 

Wir sind jedoch mehr daran interessiert, eine Datei hochzuladen, während wir
gerade dabei sind unsere copperliste anzusehen und vielleicht Musik in Interrupt
abzuspielen. Wie vereinbaren Sie einen "legalen" Upload mit einem komplett
deaktivierten Betriebssystem? Inzwischen berücksichtigen wir die Tatsache, dass
nach Interrupts alle Systemeinstellungen reaktiviert werden müssen, während das
System die copperliste nicht nutzt und wir unsere behalten können. 

Dann, wenn man Musik spielt oder etwas anderes macht, während ein Upload Platz
nimmt? Die Systeme sind vielfältig. Wir könnten unsere Routinen im "legal" -Modus
zum System-Interrupt hinzufügen, mit einem AddIntServer(). Oder wir könnten
unseren Interrupt ausführen, der dann SKIP, um das System auszuführen.
Ein bisschen weniger respektvoll Weg, aber es funktioniert und ich bevorzuge
es zu benutzen, auch weil ich es in CD32-Spielen gesehen habe. In der Praxis
müssen wir Folgendes tun: alte Interrupts und alten DMA / INTENA-Status 
wiederherstellen, wiederherstellen von Multitasking und so weiter, wie
wir das am Ende tun, aber lassen unsere copperliste und "fädeln" unseren
Interrupt $6c mehr als den System-Interrupt ein. Laden Sie dann die Datei hoch 
und warten Sie, bis einige Sekunden verstrichen sind, bis das Laufwerk O
die Festplatte oder CD-ROM aus ist, dann schließen Sie alles und kehren zurück
um ohne Mitleid ins Metall zu schlagen.
Kurz gesagt, vor und nach dem Laden ist es notwendig, das Betriebssystem wieder 
herzustellen und zu aktivieren, verlassen unsere copperliste.
Das einzige Detail ist der Interrupt: Wie führen wir unsere aus
und springen dann zur alten? 
Ich möchte Ihnen ein System von echten Schmugglern anbieten,
aber das funktioniert, solange Sie die "ClearMyCache"-Routine aufrufen, die
den Anweisungscache des Prozessors (68020+) löscht.
Tatsächlich werden wir zum ersten (und letzten) Mal AUTOMODIFYING-Code verwenden!
Es sollte niemals verwendet werden, aber ich möchte, dass Sie einen der wenigen
Fälle sehen, in denen es funktioniert und es nützlich ist, nur zur Information. 
Sie wissen, dass jede Anweisung, wenn sie assembliert wird, ein
Satz von Hexadezimalwerten wird? Zum Beispiel wird rts zu $4e75 und so weiter.
Wir müssen zum alten Interrupt SPRINGEN, nachdem wir unseren ausgeführt haben.
So wird ein "JMP $12345" beispielsweise zu "$49f900012345" oder zu "$4ef9",
gefolgt von der Adresse, zu der gesprungen werden soll.
Wir müssen zum alten Interrupt SPRINGEN, nachdem wir unseren ausgeführt haben.
So wird ein "JMP $12345" beispielsweise zu "$49f900012345" oder zu "$4ef9",
gefolgt von der Adresse, zu der gesprungen werden soll.

	dc.w	$4ef9	; Hex-Wert von JMP
Crappyint:
	dc.l	0	; Adresse, zu der gesprungen werden soll, um zu automatisieren...

Wenn wir nun CrappyInt eingeben, unterbricht die Adresse des Systems mit:

	move.l	oldint6c(PC),crappyint	; per DOS LOAD - wir werden zum oldint springen

Wir würden den "JMP oldint6c" haben, den wir gesucht haben ... denn es ist der 
letzte Interrupt:


          :                                                     ||| |
          .  ||||                                            .  oO\ .
          : ([oO])                                          (^) \O/<:
          |__\--/__                                          |\__>  |
 -  - - --+------ - ---- ----- - ---------- ------ ------- - - -----+-  -   -
*****************************************************************************
; Interrupt Routine, die beim Laden ausgeführt werden soll. Die Routinen dafür
; wird in diesem Interrupt abgelegt und wird auch während des Ladens von einer 
; Diskette, einer Festplatte oder einer CD-ROM ausgeführt.
; BITTE BEACHTEN SIE, DASS WIR DEN INTERRUPT COPER VERWENDEN UND NICHT, DASS
; VBLANK, DER GRUND IST, DAS WÄHREND DES LADENS DER DISKETTE, INSBESONDERE UNTER
; KICK 1.3, DER INTERRUPT-VERTB NICHT STABIL IST, so dass die Musik einige Rucks
; bekommen würde. Wenn wir stattdessen "$9c,$8010" in unsere copperliste  
; aufnehmen, sind wir sicher, dass diese Routine nur einmal pro Frame ausgeführt
; wird.
*****************************************************************************
																				
myint6cLoad:
	btst.b	#4,$dff01f		; INTREQR - ist Bit 4, COPER zurückgesetzt?
	beq.s	nointL			; Wenn ja, ist es kein "echter" int COPER!
	move.w	#%10000,$dff09c	; Wenn nicht, ist es die richtige Zeit, lasst uns 
							; die Anforderung entfernen!
	movem.l	d0-d7/a0-a6,-(SP)
	bsr.w	mt_music		; Musik spielen
	movem.l	(SP)+,d0-d7/a0-a6
nointL:
	dc.w	$4ef9			; Hex-Wert von JMP
Crappyint:
	dc.l	0	; Adresse, zu der gesprungen werden soll, um zu automatisieren ...
				; ACHTUNG: Der selbstmodifizierende Code sollte nicht
				; verwendet werden. Wie auch immer, wenn Sie einen 
				; ClearMyCache vorher und nachher aufrufen funktioniert es!

Wie Sie sehen können, zeigen Sie einfach auf diesen Interrupt in $6c + VBR, um 
mt_music auszuführen und das alte System unterbrechen, bekommen die Musik + Laden
zeitgenössisch.

Schauen wir uns ein Beispiel in Listing11o2.s an.

An dieser Stelle können Sie sich vorstellen, was die Blockierroutine tun kann.
Eingabe über Intuition: Wenn wir eine Datei hochladen, aktivieren wir Multitasking 
und dann Systeminterrupts wieder, auch wenn unsere copperlist angezeigt wird.
Die Workbench funktioniert einwandfrei, so dass, wenn während des Ladens die
Maus "blind" fährt, man auch durch Klicken auf ein Menu oder Icon oder durch
Tastatur Befehle über das cli aktiviert werden.
Denken Sie an einen Spieler, der die Gewohnheit hat beim Laden, die Maus zu
bewegen und zu drücken um nicht nervös zu werden: Am Ende des Spieles könnte er
feststellen, dass er auf das Festplattensymbol geklickt hat und zufällig die
Formatierungsoption aus dem WB-Menü ausgewählt hat, die er nicht sah, und
vielleicht hat ihm die Tastatur durch drücken auch versehentlich einen obszönen 
Namen gegeben. Wenn einmal das Betriebssystem deaktiviert ist, der Aufruf
der Routine InputOff ist nicht unverzichtbar, in dem Fall wenn sie Dateien laden
oder andere Operationen ausführen und es ist gut, dass kein Schaden angerichtet
werden kann!

			-	-	-

Lassen Sie uns zum Abschluss der Lektion sehen, wie Sie eine Datei laden, bei der
wir die Länge im vorhinein nicht kennen und wir nutzen auch die Möglichkeit 
die AllocMem- und FreeMem-Routinen zu erklären.
Um die Länge einer Datei zu ermitteln, führen Sie einfach eine spezielle Funktion 
genannt Examine, solange die Datei gesperrt ist aus. Das ist nicht viel
schwieriger, mach einfach einen JSR.
Beachten Sie, dass Examine nichts anderes macht, als einen $104-Byte-Puffer 
zu füllen. Hier ist ein Beispiel für die verschiedenen Dateidaten:


	cnop	0,4	; Achtung! Der FileInfoBlock muss ausgerichtet sein
; ein Langwort, es reicht nicht aus, dass es an einer geraden Adresse ist!

fib:
	dcb.b	$104,0	; Struktur FileInfoBlock: offsets.
			; 0 = fib_DiskKey
			; 4 = fib_DirEntyType (<0 = file, >0 = directory)
			; 8 = FileName (max 30 Zeichen, Ende mit 0)
			; $74 = fib_Protection, $78 = fib_EntryType
			; $7c = fib_Size, $80 = fib_NumBlocks
			; $84 = fib_Date (3 longs: Days, Minute, Tick)
			; $90 = comment (endet mit einer 0)

Wie Sie sehen können, finden wir am Offset $7c die Länge. Die anderen Dinge dort
sind, die sie interessiert ... was machen wir mit dem Datum oder Kommentar?
Da wir jedoch Speicher für die Datei reservieren müssen, werden wir sie auch für 
den FileInfoBlock reservieren, um uns diese "dcb.b $104.0" zu sparen.
Wenn wir die Länge der Datei kennen, müssen wir einen Puffer im Speicher erstellen
mit der Länge der Datei, um uns drinnen zu halten. Dies geschieht mit AllocMem,
welcher die Anzahl der zuzuweisenden Bytes und die Art des eintreffenden Speichers 
ob Chip oder nicht erfordert, ähnlich wie in den Abschnitten mit "_C" oder nicht.
Im Gegensatz zu den Abschnitten müssen wir jedoch am Ende des Programms 
manuell alle über die FreeMem-Funktion zugewiesenen Blöcke frei machenen.

 AllocMem
 --------
 
Diese Exec-Routine wird verwendet, um einen Speicherblock für unsere Zwecke 
anzufordern. Geben Sie einfach den benötigten Speichertyp an (in der Praxis, ob
es CHIP-RAM sein muss oder nicht), und die Länge dieses Blocks in Bytes.
Die Routine ALLOC gibt uns für unseren exklusiven Einsatz das freie Stück RAM, 
den wir in Besitz nehmen, das beduetet das Betriebssystem schreibt nicht mehr 
in dieses Stück Speicher, bis "wir es mit Freemem freigeben".
Tatsächlich arbeitet das Amiga-Multitasking-System mit diesem System: Jedes
Programm, bekommt durch AllocMem so viel Speicher wie es benötigt, das System
benötigt freie RAM Teile als Reserve, denn weitere Programm, wird das
Multitasking andere Teile des freien RAM zuordnen.
Vorerst haben wir die "SECTION BSS" für die Null-Null-Speicherräume verwendet,
die wir brauchten, denn wir wussten ihre Größe am Anfang. Und es ist am besten,
BSSs für Bitplanes oder Puffer von bestimmter Größe zu verwenden, aus
verschiedenen Gründen, wie z.B. nicht in der Lage zu sein Routinen aufzurufen
und in der Lage zu sein, Label hier und da im Puffer, im Gegensatz zum zugewiesenen
Speicher, dem wir durch Zugriff über Offsets vom Anfang des Blocks hätten.
In unserem Listing laden wir im Speicher eine Datei hoch, von der wir die Länge 
nicht kennen, so dass es hier obligatorisch ist, AllocMem zu verwenden, nachdem 
wir wissen, wie viel Speicherplatz die Datei einnehmen wird.
Sehen wir uns im Detail die Funktion an: 

	move.l	Grandezza(PC),d0 ; Größe des Blocks in bytes
	move.l	TypeOfMem(PC),d1 ; Typ des Speichers (chip,public...)
	move.l	4.w,a6
	jsr	-$c6(a6)			 ; Allocmem
	move.l	d0,FileBuffer	 ; die Startadresse des mem-Blocks. zugeordnet
	beq.s	FineMem			 ; d0=0? dann Fehler!
	...

Wenn es nicht notwendig ist, Chip-RAM zuzuweisen (d.h. wenn der zugewiesene Puffer
nicht für Grafik oder Sound ist), dann immer "MEMF_PUBLIC" zuordnen, was bedeutet:
"FAST RAM, wenn es einen gibt, oder wenn es wirklich keinen Chip-RAM gibt."
Ich erinnere mich zum x-ten Mal, dass es gut ist, im Chip-RAM zu speichern, und
dass der Fast RAM schneller als der Chip RAM ist.
Beim Beenden, befindet sich in d0 die Adresse des angeforderten Speicherblocks, 
der unter anderen auf das Long-Wort ausgerichtet  wird (d.h. 32-Bit
ausgerichtet). Wenn stattdessen d0 = 0 ist, war es nicht möglich war, einen 
solchen Block zu reservieren!
Testen Sie immer dieses d0, denn im Falle eines "kein Speicher vorhanden", 
würden Sie alles nach $0 kopieren !!!

Wir können auch verlangen, dass der benötigte Speicher zurückgesetzt wird,
das Bit MEMF_CLEAR, das 16. (10000). Hier sind die nützlichsten Parameter, 
um in d1 setzen, um die verschiedenen Speichertypen anzufordern:

MEMF_CHIP	=	2	; Anfrage Chip Ram
MEMF_FAST	=	4	; Anfrage Fast Ram (nicht verwenden)
MEMF_PUBLIC	=	1	; Anfrage Fast, aber wenn nicht, es ist okay, Chip!

Und natürlich, wenn Sie wollen, dass die Blöcke auf Null gesetzt werden:

CHIP		=	$10002
FAST		=	$10004	; nicht verwenden...
PUBLIC		=	$10001

Ich empfehle nicht, nach MEMF_FAST zu fragen, da das Fast nicht auf allen 
Maschinen vorhanden ist. Verwenden Sie immer MEMF_PUBLIC, außer wenn Speicher
für Bitplane, copperliste oder Audio verwendet werden soll, was MEMF_CHIP ist.
Beachten Sie, dass die Länge des Blocks, den wir eingeben, durch das
Betriebssystem auf ein Vielfaches der Systemblöcke gerundet wird. Dies ist kein 
Problem für uns. In der Tat, wenn sie 39 eingeben, wird es wahrscheinlich 
40 reservieren, aber die 39 erforderlichen sind alle da, also ist es uns egal.
Wenn Sie das Programm verlassen, denken Sie daran, den Speicherblock freizugeben!

 FreeMem
 -------

Dies ist die aufrufbare Routine, um die zugewiesenen Speicherblöcke freizugeben.
Die Adresse des Blocks in a1 wird benötigt und die Länge in Bytes in d0.
VORSICHT: Wenn Sie versuchen, einen Block freizugeben, der nicht zugewiesen wurde,
wirst du ein verrücktes Durcheinander mit Guru Meditation / Soft Failure 
verursachen! So geben Sie den Speicherblock von zuvor frei:

	move.l	Grandezza(PC),d0  ; Größe des Blocks in Bytes
	move.l	FileBuffer(PC),a1 ; Adresse des Blocks im Speicher zugewiesen
	move.l	4.w,a6
	jsr	-$d2(a6)			  ; FreeMem

	                               /T /I
	                              / |/ | .-~/
	                          T\ Y  I  |/  /  _
	         /T               | \I  |  I  Y.-~/
	        I l   /I       T\ |  |  l  |  T  /
	     T\ |  \ Y l  /T   | \I  l   \ `  l Y
	 __  | \l   \l  \I l __l  l   \   `  _. |
	 \ ~-l  `\   `\  \  \\ ~\  \   `. .-~   |
	  \   ~-. "-.  `  \  ^._ ^. "-.  /  \   |
	.--~-._  ~-  `  _  ~-_.-"-." ._ /._ ." ./
	 >--.  ~-.   ._  ~>-"    "\\   7   7   ]
	^.___~"--._    ~-{  .-~ .  `\ Y . /    |
	 <__ ~"-.  ~       /_/   \   \I  Y   : |
	   ^-.__           ~(_/   \   >._:   | l______
	       ^--.,___.-~"  /_/   !  `-.~"--l_ /     ~"-.
	              (_/ .  ~(   /'     "~"--,Y   -=b-. _)
	               (_/ .  \  :           / l      c"~o \
	                \ /    `.    .     .^   \_.-~"~--.  )
	                 (_/ .   `  /     /       !       )/
	                  / / _.   '.   .':      /        '
	                  ~(_/ .   /    _  `  .-<_
	                    /_/ . ' .-~" `.  / \  \          ,z=.
	                     ~( /   '  :   | K   "-.~-.______//
	                       "-,.    l   I/ \_    __{--->._(==.
	                       //(     \  <    ~"~"     //
	                      /' /\     \  \     ,v=.  ((
	                    .^. / /\     "  }__ //===-  `
	                   / / ' '  "-.,__ {---(==-
	                 .^ '       :  T  ~"   ll
	                / .  .  . : | :!        \\
	               (_/  /   | | j-"          ~^ 
	                 ~-<_(_.^-~"

An dieser Stelle können wir auch das Programm sehen: Listing11o3.s

