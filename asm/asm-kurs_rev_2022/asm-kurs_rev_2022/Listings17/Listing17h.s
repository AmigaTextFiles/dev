
; Listing17h.s
; wenn der Copper mit dem Blitter
; Amiga-Magazin 1991-02, S.157
; Listing 1
; Achtung, das Programm hat keinen Startup-Code. Das führt zu Problemen beim
; Starten anderer Programme

	org $40000
	load $40000
	JUMPPTR x

bobs = 109						; Zahl der BOBs
ho = 17							; Hoehe der BOBs
br = 28							; Breite des Screens in Byte
hoe = 200						; Hoehe des Screens
bs = hoe*br						; Planesize Bild
brs = 4*17						; Planesize Brush
bild1 = $50000
bild2 = $60000
bild3 = $70000
;brush = bild1+[3*bs]			; hier den konvertierten Brush hinladen

x: 
	move #$4000,$dff09a
	move #-1,$dff02e			; Blitterzugriff fuer Copper erlauben
								
	bsr initcol					; den Brush zeilenweise verschachteln
	bsr initbrush				; und 109mal hintereinander schreiben
	bsr initcop					; Kopie der Copperliste erstellen
	bsr initmulutab
loop: 
	move.l $dff004,d0
	and.l #$000fff00,d0
	cmp.l #$00013700,d0

; auf Ende des-Rasterdurchlaufs warten
	bne.s loop
	bsr irq
	btst #6,$bfe001
	bne loop
	lea GRname(pc),a1

; Betriebssystem-CL zurueckholen
	moveq #0,d0
	move.l 4.w,a6
	jsr -552(a6)
	move.l 38(a0),$dff080
	rts  

GRname:
	 dc.b "graphics.library",0,0
xx:
	 blk.l bobs,br*4*$10000+hoe
merkd5:
	 dc.w 0
merka7:
	 dc.l 0
MULUTAB:
	 blk.w hoe
irq:
	bsr swap					; Bilder und Copperlisten vertauschen
	bsr clearbild
	bsr set						; Koordinaten aendern und in CL
	rts

set:
	move.l copper1(pc),a2		; nicht aktive CL
	move pic1(pc),S48+2-copl(a2)	; High 0
	move pic1(pc),S54+2-copl(a2)	; und D
	lea setbobs-copl(a2),a2
								; A2 zeigt auf Befehlsteil der CL
	lea mulutab(pc),a3			; A3 -> Mulutab
	move merkd5(pc),d5			; D5 = Zufallszahl
	lea xx(pc),a1				; A1 -> KOORDINATEN
	move #%100110010101010,d6	; addieren
	move #$f,d3
	move #%0000111111001010,d4 ; BLITCONO
	move #bobs-1,d7

main1:
	movem (a1),d0-d1			; X-Y
	btst #0,d5					; Koordinaten, einen Punkt
	bne.s sub1					; wandern zu lassen:
	addq #2,d0					; nach rechts. . .
sub1:
	subq #1,d0					; oder links
nosub1:
	btst #5,d5
	bne.s sub2
	addq #4,d1					; nach oben. . .
sub2:
	subq #2,d1					; oder unten
nosub2:
	ror #1,d5					; Zufallszahl aendern
	add d6,d5		

	movem d0-d1,(a1)
	move d0,d2
	lsr #3,d0					; X/8
	add (A3,d1.w),d0			; X/8+Y*BR*3 = OFFSET IN BILD								
	move d0,S4a+2-SETBOB(a2)	; C-POTH
	move d0,S56+2-SETBOB(a2)	; D-POTH
	and d3,d2					; X&$f
	ror #4,d2					; BLITCONl
	move d2,S42+2-SETBOB(a2)
	or d4,d2					; BLITCONO
	move d2,S40+2-SETBOB(a2)
	lea endsetbob-setbob(a2),a2	; -> Copper-Befehle fuer naechstes BOB								
	addq.l #4,a1
	dbf d7,main1
	move d5,merkd5
	rts

PIC1:
	dc.l bild1					; mit CPU loeschen
PIC2:
	dc.l bild2					; mit Blitter aufbauen
PIC3:
	dc.l bild3					; darstellen
COPPER1:
	dc.l copl					; Aufbau
COPPER2: 
	dc.l cop2					; darstellen

SWAP:
	movem.l copper1(pc),d0-d1
	move.l d0,copper2
	move.l d1,copper1
	move.l d0,$dff080			; CL
	move.l d0,a0
	movem.l pic1(pc),d0-d2
	movem.l d0-d1,PIC2
	move.l d2,PIC1
	moveq #3-1,d7				; ->> naechstes fertige Bild in CL

l:
	move d1,adr-copl+6(a0)
	swap d1
	move d1,adr-copl+2(a0)
	swap d1
	add.l #br,d1
	addq.l #8,a0
	dbf d7,l
rts   

clearbild:
	move.l PIC1(pc),a0
	lea 3*bs(a0),a0				; -> Ende des Bildes
	move.l a7,merka7
	movem.l free(pc),a1-a7/d0-d7
clear:
	blk.l 3*bs/15/4				; MOVEM-Befehle
	move.l merka7(pc),a7
	rts

free:
	blk.l 16,0
cleari:
	movem.l a1-a7/d0-d7,-(a0)	; Code MOVEM

initcol:
	lea brush+[4*brs]+16,a0
	lea col,a1
	move #$180,d0
	move #7,d7
cl:
	move d0,(a1)+
	move (a0)+,(a1)+
	addq #2,d0
	dbf d7,cl
	rts

initbrush:
	lea brushes,a4				; dest
	lea masks,a5				; dest
	move #bobs-1,d7
ibl1:
	lea brush+[0*brs],a0		; Plane 0
	lea brush+[1*brs],a1		; Plane 1
	lea brush+[2*brs],a2		; Plane 2
	lea brush+[3*brs],a3		; Maske
	move #ho-1,d6

ibl2:
	move.l (a0)+,(a4)+			; Plane 0
	move.l (a1)+,(a4)+			; Plane 1
	move.l (a2)+,(a4)+			; Plane 2
	move.l (a3),(a5)+			; Mask Plane 0
	move.l (a3),(a5)+			; Mask Plane 1
	move.l (a3)+,(a5)+			; Mask Plane 2
	dbf d6,ibl2					; alle 17 Zeilen
	dbf d7,ibl1					; 109 Brushes hintereinander
; damit man A und B nicht setzten muss
	lea clear(pc),a0			; MOVEMS plazieren
	move.l cleari(pc),d0
	move #3*bs/15/4-1,d7
ic1:
	move.l d0,(a0)+
	dbf d7,ic1
	rts

initcop:
	lea setbobs,a1				; 109 Blitterbefehlsbloecke in CL
	moveq #bobs-1,d7
icopl1:
	lea setbob,a0
	moveq #endsetbob-setbob-1,d6
icopl2:
	move.b (a0)+,(a1)+
	dbf d6,icopl2
	dbf d7,icopl1
	lea copl,a0
; Kopie der gesamten CL anfertigen
	lea cop2,a1
	move #endcopl-copl-1,d7
icop:
	move.b (a0)+,(a1)+
	dbf d7,icop
	rts
initmulutab:
	lea mulutab(pc),a0
	move #hoe-1,d7
	clr d0
imtl:
	move d0,(a0)+
	add #3*br,d0
	dbf d7,imtl
	rts   

wait: macro
	dc.w 1,0,1,0,1,0
	endm

brushes:						; 109mal verschachtelte BOBs
	blk.b 3*brs*bobs
masks:							; die dazugehoerenden Brushes
	blk.b 3*brs*bobs
SETBOB:							; Copperbefehlsblock fuer ein BOB
	Wait
S4a: dc.w $4a,0					; C-LOW
S56: dc.w $56,0					; D-LOW
S40: dc.w $40,0					; BLITCONO
S42: dc.w $42,0					; BLITCONl
	 dc.w $58,64*17*3+2			; Blitsize
ENDSETBOB:

copl: 
	dc.w $8e,$30b1,$90,$f891,$92,$50
	dc.w $94,$b8,$108,br*2,$10a,br*2
	dc.w $100,$3200,$96,$20
col: 
	blk.l 8	
adr: 
	dc.w $e0,0,$e2,0,$e4,0,$e6,0,$e8,0,$ea,0

; FIXE PARAMETER:
	wait
	dc.w $50,masks/$10000,$52,masks&$ffff	
	dc.w $4c,brushes/$10000,$4e,brushes&$ffff
	; A = MASKE B = Source
	dc.w $64,0,$62,0,$60,br-4,$66,br-4	; MOD.
	dc.w $44,%1111111111111111			; A MASK L
	dc.w $46,%1000000000000000			; A MASK R
S48: dc.w $48,bild1/$10000				; C High
S54: dc.w $54,bild1/$10000				; D High

; VARIABLE PARAMETER:
SETBOBS: 
	blk.b [endsetbob-setbob]*bobs
	dc.l $fffffffe
endcopl:
cop2: 
	blk.b endcopl-copl
	
brush:			
	 incbin "/Sources/square_17x17x4cmb.raw"	; cmb - colormap behind 
;>EXTERN "df1:brush.104",brush,4*brs+32  

	end
;------------------------------------------------------------------------------

Es gibt eine Unzahl von Kniffen und Methoden, Programme schnell zu machen und
quasi das Letzte aus dem Amiga herauszuquetschen. In dieser Folge des Hardware-
Programmierkurses werden wir uns hierzu ein paar besondere Tricks am Beispiel
zweier komplexer Programme ansehen: Wir werden eine Routine schreiben, die
über hundert Objekte (acht Farben, 17 x 17 Punkte groß) gleichzeitig am
Bildschirm bewegt...
Und wir werden in einem zweiten Beispiel ca. 5000 Punkte über den Bildschirm
flitzen lassen...
Beginnen wir mit dem ersten Programm (Seite 160), um 100 Objekte tanzen zu
lassen. Natürlich bringen wir die Objekte mit dem Blitter auf den Bildschirm.
Wir verwenden BOBs. Und damit der Blitter genug Zeit für 100 BOBs hat, löschen
wir den Bildschirm zwischen den einzelnen Bewegungsphasen mit dem Prozessor.
Wenn wir >>movem<< verwenden, ist der 68000er dabei sogar schneller, als es der
Blitter wäre: In A0 laden wir bei diesem Verfahren einen Zeiger auf den zu
löschenden Bereich.   

* Prozessor überholt den Blitter *

Alle anderen 15 Register setzen wir auf Null. Mit movem.l a1-a7/d0-d7,(a0)
werden ab der Adresse in A0 15 Langwörter (60 Byte!) gelöscht - und das mit nur
einem Befehl. Um den kompletten Bildschirm zu löschen, brauchen wir für drei
Planes je nach Bildschirmgröße ca. 300 bis 500 solcher Befehle. Wollen wir eine
Schleife vermeiden - die benötigt Zeit -, werden wir die vielen >>movem<< -
Befehle hintereinanderschreiben. Eine kleine Routine erledigt dies:

cleari:
	movem.l a1-a7/d0-d7,-(a0)

Dieser Befehl entspricht einem Langwort lang. Seinen Code holen wir uns mit
	move.l cleari(pc),d0
nach D0 und schreiben ihn 300mal in einen reservierten Bereich:

	lea clear(pc),a0	; reservierter Bereich
	move #3*bs/60-1,d7  ; bs = Größe einer Bitplane
icl:
	move.l d0,(a0)+
	dbf d7,icl

Die Bildlöschroutine läuft dann so: Zuerst merken wir uns den Wert des
Stackpointers, denn den brauchen wir noch:

	move.l a7,merka7   

Dann löschen wir alle Register bis auf A0, das aufs Ende des zu löschenden
Speicherbereichs zeigt.

	movem.l free(pc),a1-a7/d0-d7	; free zeigt auf 60 Nullbyte

Nun folgen die 300 bis 500 >>movem<<-Befehle, welche die beschriebene Routine
im reservierten Bereich platziert hat:

clear:
	blk.l 3*bs/60

Zum Schluss holen wir wieder den alten Wert von A7 zurück:
	move.l merka7(pc),a7
	rts
free:
	blk.l 15,0
merka7:
	dc.l 0

Jetzt müssen wir noch den Blitter dazu bringen, ununterbrochen seine BOBs zu
kopieren - auch dann, wenn der Prozessor das Bild löscht oder die Koordinaten
der BOBs bewegt. Dazu verwenden wir die Copperliste als Puffer. Wir erinnern
uns: Auch der Copper kann auf die Register des Blitters zugreifen, wenn Bit 0
in $2e gesetzt ist:

	move #-1,$dff02e	; Blitterzugriff von Copper ok

Wir verwenden zwei Copperlisten. Während die eine abläuft und dem Blitter
ständig neue Befehle erteilt, wird die andere vom Prozessor beschrieben, z.B.
mit den neuen Koordinaten der BOBs. Zuerst soll der Copper warten, bis der
Blitter verfügbar ist. Hierfür gibt es den Copper-Befehl >>Waitblit<<
(dc.w 1,0), der jedoch nicht einwandfrei arbeitet. Sie müssen den Befehl je
nach Herstellungsdatum Ihres Amiga bis zu dreimal ausführen, bis es wirklich
funktioniert. Zu Beginn jeder Copperliste initialisieren wir die Bitplane-
pointer, Farben usw. Danach setzen wir all jene Blitterparameter, die während
der Routine >>BOB-setz<< nicht geändert werden.

wait: macro
; Blitter-Wait-Macro für Copper
	dc.w 1,0,1,0,1,0
; dreimal auf Blitter warten
endm
; Copper setzt fixe Parameter

Beim Kopieren mit Maske haben wir bis jetzt immer Quelle A auf die Maske,
Quelle B auf das BOB und Quelle C und Ziel D auf die richtige Position in der
Grafik zeigen lassen. Dies behalten wir bei:

	wait
	dc.w $50,masks/$lOOOO
	dc.w $52,masks&$ffff
	dc.w $4c,brushes/$10000
	dc.w $4e,brushes&$ffff

Die Blitterkanäle C und D ändern sich von BOB zu BOB. Wenn wir das Bild an
einer Adresse beginnen lassen, deren Low-Word $0000 ist, bleibt das High-Word
immer gleich. Wir brauchen nur den Offset des BOBs in der Zielgrafik ins
Low-Word zu schreiben. Das High-Word ist dann nur einmal zu initialisieren:

S48: dc.w $48,bild1/$10000			; 0 High
S54: dc.w $54,bild1/$10000			; 0 HIGH

Wenn wir auf verschiedene Bilder zugreifen (wegen Double-Buffering) müssen wir
nur die High-Words ändern, um alle Blitterzugriffe auf ein Bild umzulenken. Die
Startadressen aller Bilder müssen mit vier Nullen enden:

bild1 = $50000
bild2 = $60000
bild3 = $70000

Ebenfalls fix sind die Moduli und die Maske für A:

	dc.w $64,0,$62,0,$60,br-4
	dc.w $66,br-4					; Moduli
	dc.w $44,%1111111111111111
	dc.w $46,%1000000000000000

Mit >>br<< ist die Breite des Screens gemeint. Das Blitterfenster ist immer
4 Byte groß, weil alle BOBs 17 Punkte breit sind. Der Modulus für C und D ist
>>br-4<<. Mit der Maske sorgen wir dafür, daß nur die ersten 17 Punkte des BOBs
kopiert werden, das wie ein 32 Punkte großes BOB gelesen wird, (4 Byte als
Blitterfenstergröße).     

Um ein BOB mit nur einem Blitterstart zu kopieren, verschachteln wir die
Bitplanes wieder zeilenweise ineinander, wie bereits in der vierten Folge
beschrieben. Im Speicher stehen also erst die ersten Zeilen aller Planes, dann
alle zweiten Zeilen usw. Den Modulus für das Bild setzen wir bei drei Planes
auf >>(3-1)*Breite<<. Damit werden die Zeilen der anderen zwei Planes
übersprungen. Dasselbe machen wir mit dem Brush. Er soll die Ausmaße 17 x 17
haben. Wir zeichnen ihn im 16-Farben-Modus, damit die Masken-Plane gleich im
Brush enthalten ist. Alle Punkte, die zum Brush gehören, malen wir mit Farben
aus der zweiten Hälfte der Palette. Die Transparentfarbe muss aus der ersten
Hälfte stammen. Nachdem wir die Brush-Datei ins Raw-Format konvertiert haben,
ist jede Zeile 4 Byte lang (17 Punkte auf Wortgrenzen aufgerundet = 2 Words).
Nun rechnen wir den Brush ins beschriebene Format um. Die drei Planes sollen
also zeilenweise (in unserem Fall also 4 Byte = ein Langwort) ineinander
geschachtelt werden. Wir legen gleichzeitig ein zweites BOB im gleichen Format
ab, das nur die Maske (=Silhouette) enthält. 

; BOB im neuen Format
	lea masks,a5
	; Maske im neuen Format
	lea brush+[0*brs],a0		; Zeiger-:>Plane 0 des orig. 808
	lea brush+[l*brs],a1		; Zeiger auf Plane 1
	lea brush+[2*brs],a2		; Zeiger auf Plane 2
	lea brush+[3*brs],a3		; Zeiger auf Maske
	; BOB nach brush laden
	; brs = Größe einer BOB-Plane
	move #ho-1,d6				; ho: Höhe BOB --> 17
ibl:
	move.l (a0)+,(a4)+			; Zeile aus Plane 0
	move.l (a1)+,(a4)+			; Zeile aus Plane 1
	move.l (a2)+,(a4)+			; Zeile aus Plane 2
	move.l (a3),(a5)+			; Mask für Zelle aus Plane 0
	move.l (a3),(a5)+			; Mask für Zeile aus Plane 1
	move.l (a3)+,(a5)+			; Mask für Zeile aus Plane 2
	dbf d6,ibl

Die Maske ist ja für alle Planes identisch, bei Verwendung des Spezialformats
müssen die Maskenzeilen jedoch so oft hintereinanderstehen, wie es Planes gibt.
Dadurch benötigt unser Format mehr Speicher als das herkömmliche. Schauen wir
uns den Teil der Copperliste an, der benötigt wird, um ein BOB zu kopieren:

SETBOB: Wait
S4a: dc.w $48,0					; C Low
S56: dc.w $56,0					; D Low
S40: dc.w $40,0					; BLTCONO
S42: dc.w $42,0					; BLTCON1
	 dc.w $58,64*17*3+2			; Blitsize   

Der Teil steht so oft hintereinander, wie es BOBs zu kopieren gilt. Nun
berechnen wir den Offset der Zielposition innerhalb des Bildes und schreiben
sie in jene Befehle der Copperliste, die C- und D-Poth des Blitters
beschreiben. Jedoch berechnet sich der Offset bei Verwendung von ineinanderge-
schachtelten Bitplanes etwas ungewöhnlich: 
>>Offset = (X/8)+(Y * Breite einer Zeile in Byte x Anzahl der Planes)<<
Die Assembler-Routine sieht so aus:

	; D0 = X ; D1 = Y
	lsr #3,d0					; x / 8
	mulu #3*br,d1				; Y * Breite/Zeile * Anz. Planes
	add d1,d0					; D0 = Offset in der Grafik

Sind diese Zeilen optimal programmiert? Ein Multiplikationsbefehl braucht
44 Taktzyklen. Das ist viel. Wir legen deshalb eine Multiplikationstabelle an,
die alle möglichen Ergebnisse für >>Y*3*BR<< enthält, für >>Y = 0<< bis
>>Y = Anzahl der Zeilen des Bildes<<. Folgende Routine berechnet die Tabelle
zu Beginn des Programms:

	hoe = 200					; Zeilen des Bildes
MULUTAB:
	blk.w hoe					; Ergebnisse von Y*br
initmulutab:
	lea mulutab(pc),a0
	move #hoe-1,d'7
	clr d0						; Ergebnis für 0*br
imtl:		
	move d0,(a0)+
	add #3*br,d0
	dbf d7,imtl
	rts   

Nun können wir die Offsetroutine optimieren:

	; D0 = X ; 131 = Y
	; A3 = Zeiger -> Tabelle
	lsr #3,d0					; X/8
	add d1,d1					; Y*2 (siehe Text)
	add (A3,d1.w),d0			; X/8+Y*BR*3 = Offset in Bild				

Die Y-Koordinate muss noch mit 2 multipliziert werden, da in der
Multiplikationstabelle alle Ergebnisse als Wort gespeichert sind. Wir können
auch diesen Befehl vergessen, wenn wir bei der Bewegung der BOBs darauf achten,
dass die Y-Koordinate immer als doppelt angesehen wird. Den Offset schreiben
wir jetzt in die Copperlste:

	; A2 = Zeiger auf SETBOB-Segment
	move d0,S4a+2-SETBOB(a2)	; C POTH
	move d0,S56+2-SETBOB(a2)	; D POTH

Nun berechnen wir noch die Verschiebung für Quelle A und B:

	; D2 = X
	and #$f,d2					; X&$f
	ror #4,d2					; BLITCON1
	move d2,S42+2-SETBOB(a2)
	or #%0000111111001010,d2
	move d2,S40+2-SETBOB(a2)

Das wär’s. Für das nächste BOB sollten wir eigentlich die Zeiger für A und B
neu setzen. Da dies aber vier zeitraubende Copper-Befehle erfordert, werden wir
einfach das originale BOB und die Maske so oft hintereinander im Speicher
ablegen, wie sie kopiert werden sollen:
Beim Kopieren des ersten BOBs wird auch das erste gelesen. Die internen
Blitterpointer für Kanal A und B zeigen anschließend aufs Ende des ersten BOBs,
wo es ein weiteres mal zu finden ist usw. Nun müssen wir uns noch überlegen,
wie wir den Prozessor "überreden", ein Bild zu löschen, während der Blitter,
gesteuert über die Copperliste, BOBs ins Bild kopiert und der Videochip nur das
fertige Bild anzeigt?
Wir verwenden hierzu drei Bilder und starten mit Bild 1. Es wird vom Prozessor
gelöscht. lm nächsten Durchgang (1/50s später) wird Bild1 zu Bild 2, dem sich
der Blitter widmet. Noch einen Durchgang später wird es zu Bild 3, das bereits
komplett aufgebaut ist und vom Videochip auf den Bildschirm gebracht wird.
Inzwischen behandelt der Blitter das jetzige Bild 2, während der Prozessor das
vorliegende Bild 1 löscht.   

* Der Prozessor mischt kräftig mit *

Das dargestellte Bild 3 machen wir im folgenden Durchgang wieder zu Bild 1.

bild1 = $50000
bild2 = $60000
bild3 = $70000
PICl:
	dc.l bild1					; 68000 löscht
PIC2:
	dc.l bild2					; Blitter baut auf
PIC3:
	dc.l bild3					; Videochip stellt der

Die folgende Routine vertauscht die Bilder:

SWAP:
	movem.l pic1(pc),d0-d2
	movem.l d0-d1,PIC2
	move.l d2,PICl

Es gibt auch mehr als eine Copperliste: Liste 1 wird immer vom Prozessor
modifiziert, nachdem er Bild 1 gelöscht hat. Gleichzeitig ist die Liste 2 aktiv
und erteilt dem Blitter Befehle. Diese Routine vertauscht beide Listen für den
nächsten Durchgang:

COPPER1: 
	dc.l cop1	; wird von 68000er mit Blitter-Befehlen beschrieben	
COPPER2:
	dc.l cop2					; läuft ab
	movem.l copperl(pc),d0-dl
	move.l d0,copper2
	move.l dl,copperl

Die jetzt aktiv werdende Liste 2 schreiben wir in den Copperlisten-Pointer:
	move.l d0,$dff080   

Außerdem schreiben wir in die Copperliste - noch rechtzeitig bevor sie startet
- die Adresse des Bildes, das im nächsten Durchlauf sichtbar sein soll. Das
jetzige Bild 2:

	; D1 = Zeiger -> Bild 2
	move.l d0,a0				; Zeiger -> nächste aktive CL
	moveq #3-1,d7				; 3 Planes
l: move dl, adr-copl+6(a0)
	swap dl
	move dl,adr-copl+2(a0)
	swap dl
	add.l #br,dl				; nächste Plane
	addq.l #8,a0				; nächster Copper-Befehl
	dbf d7,1

Diese Stelle wird in der Copperliste beschrieben. Sie setzt die Bitplanepointer
auf das fertig gezeichnete Bild:

adr: 
	dc.w $e0„$e2„$e4„
	dc.w $e6„$e8„$ea„

Beim Start des Programms werden zuerst die Farben des Brushes in die
Copperliste geschrieben. Dann werden in einem reservierten Bereich der
Copperliste die >>setBOB<<-Copper-Befehle kopiert, und zwar so viele, wie es
BOBs am Bildschirm geben soll. Dieser Copper-Bereich heißt im Listing
>>SETBOBS<<. Anschließend wird eine Kopie der Copperliste erzeugt, da wir zwei
Listen benötigen. Das Hauptprogramm vertauscht am Ende eines Rasterdurchlaufs
(Rasterzeile $137) beide Copperlisten und verschiebt die drei Bilder um eine
Position (>>swap<<-Routine). Dann löscht man mit der CPU Bild 1. Anschließend
werden in die nicht aktive Copperliste die Offsets und die >>BLITCONO/1<<-Werte
für alle BOBs geschrieben. Da alles, was in die Liste geschrieben wird, erst
beim nächsten Rasterdurchlauf an den Blitter übertragen wird, müssen wir nicht
die High-Wörter von Bild 2, sondern die von Bild1 in die Liste schreiben, da
das Programm es im nächsten Durchgang zu Bild 2 erklärt.
Um Kanal 0 und D auf Bild 2 zu lenken, ist folgende Routine erforderlich:

set:
	move.l copper1(pc),a2			; nicht aktive Copperliste
	move pic1(pc),s48+2-copl(a2)	; High von Kanal 0
	move pic1(pc),s54+2-copl(a2)	; High Kanal D
	
Da Listing 1 nur ein Demonstrationsprogramm ist, haben wir die Bewegung der
BOBs simpel gehalten. Eine Zufallszahl in D5 bestimmt, ob ein BOB um einen
Punkt nach links oder rechts und einen Punkt nach oben oder unten wandern soll.
Die BOBs zittern also wie wild am Bildschirm. Alle Direktwerte in der
Hauptschleife wurden in Datenregister gelegt, um Zeit zu sparen. Aus:

	and #$f,d2
wurde z.B.:
	and d3,d2   

wobei D3 noch vor der Schleife mit dem Wert >>$f<< gefüttert wurde. Listing 1
zeigt das vollständige Programm. Es benötigt einen konvertierten, 17 x 17
Punkte großen und achtfarbigen Brush, wobei die Maske bereits im Brush als
vierte Plane enthalten sein muss (Bilddatei auf Programmservice-Diskette
dieser Ausgabe; siehe Seite 209).
Zeichnen Sie den Pinsel daher im 16-Farben-Modus und verwenden Sie nur die
acht Farben aus der zweiten Hälfte der Palette. Alle Farben, die aus der ersten
Hälfte stammen (Plane 4 = >>0<<) erscheinen beim BOB transparent. Das Programm
ist so getimet, dass sowohl der Prozessor als auch der Blitter ca. zwei
Rasterzeilen vor dem nächsten Durchgang fertig sind. Es gibt keinen Taktzyklus,
in dem der Prozessor auf den Blitter warten muss. Wenn der Blitter fertig ist,
braucht auch er nur kurze Zeit auf neue Befehle zu warten, denn der Copper
verwendet seine gesamte Rechenzeit nur damit, ihn ständig zu füttern.
Der Blitter ist in unserem Programm zu mehr als 99 Prozent ausgelastet. Um das
zu testen, sollte man vom Copper aus die Hintergrundfarbe ändern, nachdem alle
BOBs kopiert sind. Dazu fügt man vor der letzen Copperzeile
(>>dc.l $fffffffe<<) einen Farbänderungsbefehl (>>dc.w $180,$f00<<) ein.
Wenn das Programm perfekt getimet wurde, sollte diese Farbe ganz tief am
unteren Monitorrand gesetzt werden. Erst dort, knapp bevor der Amiga die
Copperliste erneut startet, ist der Blitter fertig.
Sollte die Farbänderung weiter oben stattfinden, hat der Blitter noch genügend
Rechenzeit übrig. Genauso können wir das Prozessorprogramm testen: In der
Hauptschleife (>>loop<<) setzen wir nach >>bsr irq<< den Hintergrund auf Weiß.

	move #$fff,$dffl80     

Der Bildschirm sollte ungefähr zur gleichen Zeit wie vom Copper gefärbt werden.
Das heißt, dass sowohl Prozessor als auch der Copper/Blitter die gesamte
verfügbare Rechenzeit ausnutzen. Wenn nur einer der beiden Partner zu früh mit
dem Rechnen fertig ist, können wir trotzdem die Anzahl der BOBs nicht erhöhen.
In so einem Fall sollte jener Partner, der noch freie Zeit hat, Teile der
Arbeit des anderen übernehmen. Es gibt sicher weitere Tricks, um noch mehr
BOBs darzustellen, z.B. könnte man noch die Sprites als zusätzliche BOBS
verwenden oder das 68000er Programm beschleunigen, um auch mit dem Prozessor
noch zusätzliche BOBs zu setzen.
Wer eine bessere Routine findet, sollte Sie ans AMIGA-Magazin schicken. Wir
werden die beste Routine dann vorstellen. Zum nächsten >>Schmankerl<<:
Lassen wir, wie versprochen, 5000 Punkte in 16 Farben über den Bildschirm
flitzen. Da wir die Punkte mit dem Prozessor setzen, können wir den Blitter
zum Löschen des Bildschirms heranziehen - wir nutzen immer den Chip, der die
meiste Zeit übrig hat. Sollten Blitter und Prozessor gleich beschäftigt sein,
sollen sie zusammen den Bildschirm löschen.
Zuerst überlegen wir uns eine schnelle Routine zum Setzen von Punkten: Hierbei
müssen wir den Offset des betreffenden Bytes in der Grafik berechnen und dann
den richtigen Punkt innerhalb des Bytes setzen. Den Offset berechnen wir wie
gewohnt mit >>Offset = (Xl8)+(Y*Breite einer Zeile)<<. Die Multiplikation
erledigen wir abermals über eine Tabelle. Wir erinnern uns: Damit wir den
Y-Wert nicht verdoppeln müssen, wenn wir ihn als Offset innerhalb der
wortweise angelegten Multiplikationstabelie verwenden, rechnen wir mit
doppelten Y-Koordinaten. Um einen Punkt z.B. drei Zeilen tiefer zu setzen,
zählen wir 6 zu seiner Y-Koordinate dazu.

	; A1 zeigt auf Tabelle
	; d0 = X dl = Y*2
	lsr #3,d0					; (X/8)
	add (a1,dl.w),d0			; +(Y*Breite/Zeile) = Offset

Nun berechnen wir jenes Bit, das im Offset-Byte gesetzt werden soll. Die
Position innerhalb des Bits ist >>X and %111<<. Die Bits im Byte sind aber
nicht von links nach rechts, wie unsere Koordinaten, sondern umgekehrt
angeordnet. Bit 0 liegt ganz rechts, während Bit 7 immer links steht. Wir
müssen deshalb die X-Koordinate umdrehen. Die neue Formel lautet:
 >>7 - (X and %111)<<.

* Blitter bis aufs letzte ausgereizt *

Wir können dies in >>(7-X) and %111<< oder >>(-1-X) and %111<< umwandeln. Das
Ergebnis setzen wir im >>bset<<-Befehl ein. Da er von der angegebenen
Bitposition nur die unteren drei Bit nimmt, sparen wir den >>and<<-Befehl.
Die übriggebliebene Formel >>-1-X<< ist in einem Befehl berechnet:

	; D2 = x
	not d2						; d2 : (-1-d2)

Jetzt müssen wir den Offset zur Startadresse des Bildes addieren und in diesem
Byte das Bit D2 setzen. Das alles vollbringt ein Befehl:

	; A2 zeigt auf Bitplane
	bset d2,(aZ,d0.w)

So sieht der vollständige Punktsetzbefehl aus:

	; A1 -> Tabelle, A2 -> Bitplane
	; d0 = X ; d1 = Y*2
	move d0,d2
	lsr #3,d0
	add (a1,dl.w),d0
	not d2
	bset d2,(a2,d0.w)

Damit die Punkte schöne Formationen bilden, verwenden wir einen
Bewegungsalgorithmus, der mit der Maus kontrolliert werden kann. Die zweite
Hälfte des Listings 2 (>>EDIT<<) wertet Bewegungen der Maus aus, wobei das
Programm bei einem Positionswechsel der Maus jeweils die Differenzen der X- und
Y-Koordinaten in einer - riesigen - Tabelle ablegt. Die Werte in der Tabelle
zählen wir nacheinander zu den Koordinaten der zu bewegenden Punkte, jedoch
beginnen wir bei jedem Punkt an einer anderen Stelle der Differenztabelle. Pro
Punkt brauchen wir dessen X- und Y-Koordinaten und die Position in der
Differenztabelle. Um Befehle zu sparen, setzen wir mit jedem Schleifendurchgang
zwei Punkte. Mit nur einem >>movem<<-Befehl holen wir uns die Koordinaten und
Positionen in der Tabelle von zwei Punkten:

	; A0 ->> Tab. Koord. d. Punkte
	movem.w (a0)+,d0-d5

Jetzt gilt: D0,D1 sind die Koordinaten von Punkt 1, D2 ist deren Position in
der Delta-Tabelle. D3,D4 enthalten die Koordinaten des zweiten Punktes und DS
dessen Position in der Tabelle. Jetzt addieren wir die Differenzwerte aus der
Tabelle zu den Koordinaten:

	; a3 -> Differenztabelle für X
	; a5 -> Tabelle für Y
	add (a3,d2.w),d0			; Punkt 1
	add (a5,d2.w),d1
	add (a3,d5.w),d3			; Punkt 2
	add (a5,d5.w),d4   

Die geänderten Koordinaten schreiben wir wieder in den Speicher zurück. Da beim
Lesen der Koordinaten A0 um sechs Wörter erhöht wurde, um bereits auf die
Koordinaten der nächsten zwei Punkte zu zeigen, schreiben wir die Koordinaten
in eine andere Tabelle.

	; A4 zeigt auf zweite Tabelle
	move.w d0-d5,-(a4)

Die zweite Tabelle wird von hinten nach vorne beschrieben, da der
>>movem<<-Befehl beim Schreiben nur ein Verringern des Adressregisters zulässt.
Beim nächsten Durchgang lesen wir die Koordinaten aus der zweiten Tabelle,
modifizieren sie und schreiben sie in die erste Tabelle zurück. Nun setzen wir
Punkte an den Positionen D0,D1 und D3,D4 und beenden die Schleife. Damit unser
Programm beim nächsten Durchgang andere Werte zu den Koordinaten addiert,
erhöhen wir die Zeiger auf die Differenztabellen (A3 und A5). Als Spezialeffekt
werden wir die Punkte in ihrer Bewegung nachhinken lassen. Das heißt, wir
löschen die zuvor gezeichneten Bilder nicht, sondern lassen sie langsam dunkler
werden und zeigen nur das neue Bild in voller Helligkeit. Insgesamt stellen wir
das aktuelle Bild und die drei davorliegenden Bilder dar - natürlich
dementsprechend dunkler. Wir benötigen insgesamt sechs Bilder im Speicher.

BILDA: dc.l bild1				; Wird mit Blitter gelöscht
BILDB: dc.l bild2				; mit CPU Punkte schreiben
BILDC: dc.l bild3				; hell
BILDD: dc.l bild4				; dunkler
BILDE: dc.l bild5				; noch dunkler
BILDF: dc.l bild6				; ganz dunkel
		dc.l 0

Folgende Routine lässt alle Bilder zu Beginn eines Durchgangs um eine Position
weiter rücken:

SWAP:
	movem.l bilda,d0-d5
	movem.l d0-d5,bildb
	move.l d5,bilda

Die Bildadressen schreiben wir gleich in die Bitplanepointer:
	movem.l dl-d4,$dff0e0

Wir wählen die Farben so, dass die nachhinkenden Planes dunkler dargestellt
werden unter Berücksichtigung einer Überlagerung von Punkten. Allen neun
Punkte geben wir den Farbwert 8, den Punkten aus dem letzten Durchgang den
Wert 4, dann 2 und den ältesten den Wert 1. Sollte auf einer Stelle in allen
vier Planes ein Punkt gesetzt sein, soll er die Addition der 
Farbwerte 8,4,2 und 1 bekommen. All dies erreichen wir durch die Farbpalette:

	dc.w $180,0+0+0+0,$182,0+0+0+8
	dc.w $184,0+0+4+0,$186,0+0+4+8
	dc.w $188,0+2+0+0,$18a,0+2+0+8
	dc.w $180,0+2+4+0,$18e,0+2+4+8
	dc.w $190,1+0+0+0,$192,1+0+0+8
	dc.w $194,1+0+4+0,$196,1+0+4+8
	dc.w $198,1+2+0+0,$19a,1+2+0+8
	dc.w $19c,1+2+4+0,$19e,1+2+4+8 

Alle Zugriffe auf Hardware-Register erfolgen über A6. Das am häufigsten
angesprochene Register ($dff004) kann ohne Offset adressiert werden, bei allen
anderen muss vom regulären Offset noch 4 abgezogen werden, z.B.
>>$180-4(a6)<< fürs Hintergrundfarbregister.

Zu Listing 2: Wenn Sie noch keine Tabelle entworfen haben, starten Sie zuerst
den Editor mit >>J edit<<. Sie müssen nun einen langen Wurm mit der Maus
zeichnen. Nach ca. zehn Sekunden wird der Bildschirm gelb, das heißt, dass der
Wurm bald fertig ist und Sie zum Ausgangspunkt wandern sollen, damit der Wurm
eine geschlossene Linie bildet. Die Differenztabelle liegt zwischen
>>dat32<< und >>bild1<<. Auf der Programmservice-Diskette dieser Ausgabe sind
bereits einige nette Versionen gespeichert. Laden Sie diese mit >>ri<<
auf >>data2<< und überspringen Sie den Editor mit >>j prog<<.
Zum Schluss bleibt nur, Ihnen viel Spaß beim Experimentieren zu wünschen und
viel Erfolg beim Programmieren. Herzlichen Dank auch für die vielen Anregungen
zu diesem Kurs - wir werden das Thema Blitter und Copper sicher fortsetzen. ub   

