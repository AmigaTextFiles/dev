
; Listing9a2.s		Kopie von $10 Wörtern durch den BLITTER

	SECTION Blit,CODE

Inizio:
	move.l	4.w,a6				; Execbase in a6
	jsr	-$78(a6)				; Disable - stoppt multitasking
	lea	GfxName,a1				; Adresse des Namens der zu öffnenden Bibliothek in a1
	jsr	-$198(a6)				; OpenLibrary
	move.l	d0,a6				; benutze eine Routine von graphics library:
	jsr	-$1c8(a6)				; OwnBlitter, das gibt uns den exklusiven Zugang auf den Blitter
								; verhindert, dass er vom Betriebssystem verwendet wird.
	btst	#6,$dff002			; warte auf das Ende des Blitters (leerer Test)
								; für den BUG von Agnus
waitblit:
	btst	#6,$dff002			; freier Blitter?
	bne.s	waitblit

; Hier erfahren Sie, wie Sie eine Kopie erstellen

;	   __&__
;	  /     \
;	 |      |
;	 |  (o)(o)
;	 c   .---_)
;	  | |.___|
;	  |  \__/
;	  /_____\
;	 /_____/ \
;	/         \

	move.w	#$09f0,$dff040		; BLTCON0: Kanal A und D ist aktiviert
								; die MINTERMS (d.h. Bits 0-7) nehmen den
								; Wert $f0 an. Auf diese Weise ist  
								; das Kopieren von A nach D definiert

	move.w	#$0000,$dff042		; BLTCON1: Wir werden dieses Register später erklären
	move.l	#SORG,$dff050		; BLTAPT: Adresse des Quellkanals
	move.l	#DEST,$dff054		; BLTDPT: Adresse des Zielkanals
	move.w	#$0000,$dff064		; BLTAMOD: Wir werden dieses Register später erklären
	move.w	#$0000,$dff066		; BLTDMOD: Wir werden dieses Register später erklären
	move.w	#(1*64)+$10,$dff058 ; BLTSIZE: definiert die Dimension des
								; Rechtecks. In diesem Fall haben wir				 
								; $10 Wörter Breite und eine Höhe von 1 Zeile.
								; Weil die Höhe des Rechtecks in die Bits 6-15 von 
								; BLTSIZE geschrieben werden
								; müssen wir sie 6 Bits nach links verschieben.
								; Dies entspricht der Multiplikation seines Wertes
								; mit 64. Die Breite wird in die niedrigen
								; 6 Bits geschrieben und werden daher nicht
								; geändert.
								; Außerdem beginnt diese Anweisung den Blitt
					
	btst	#6,$dff002			; warte auf das Ende des Blitters (leerer Test)
waitblit2:
	btst	#6,$dff002			; freier Blitter?
	bne.s	waitblit2

	jsr	-$1ce(a6)				; DisOwnBlitter, das Betriebssystem
								; kann den Blitter jetzt wieder benutzen
	move.l	a6,a1				; Basis der Grafikbibliothek zum Schließen
	move.l	4.w,a6
	jsr	-$19e(a6)				; Closelibrary - schließe die Grafikbibliothek
	jsr	-$7e(a6)				; Enable - Multitasking einschalten
	rts

GfxName:
	dc.b	"graphics.library",0,0

******************************************************************************

	SECTION THE_DATA,DATA_C
	
; Beachten Sie, dass die Daten, die wir kopieren, im CHIP-Speicher liegen müssen
; Tatsächlich funktioniert der Blitter nur im CHIP-Speicher

; Dies ist die Quelle

SORG:
	dc.w	$1111,$2222,$3333,$4444,$5555,$6666,$7777,$aaaa
	dc.w	$8888,$2222,$3333,$4444,$5555,$6666,$7777,$ffff
THEEND1:
	dc.b	'Die Quelle endet hier'
	even

; Das ist das Ziel

DEST:
	dcb.w	$10,$0000
THEEND2:
	dc.b	'Das Ziel endet hier'

	even

	end

Dieses Beispiel zeigt eine einfache Kopie mit dem Blitter.
Assemblieren Sie, ohne Jump und überprüfen Sie mit dem ASMONE-Befehl "M SORG".
Ab der Adresse SORG gibt es im Speicher $10 Wörter, die verschiedene Werte
annehmen. Das ist die Quelle der Kopie, die von der Größe ist. Wir werden die
Daten lesen. Überprüfen Sie auf die gleiche Weise mit dem Befehl "M DEST"
das Ziel. Ausgehend von der Adresse DEST sind $10 Wörter genullt.

Führen Sie an diesem Punkt das Beispiel aus.
Jetzt wieder den ASMONE-Befehl "M DEST" eingeben und sie können sehen, was im
Speicher passiert ist: Die Daten bei SORG blieben die gleichen wie zuvor. Das
ist normal, weil der Blitter einfach die Daten liest, ohne sie zu bearbeiten.
Stattdessen sind die Wörter beginnend ab der Adresse DEST nicht mehr
gelöscht, sondern haben die gleichen Werte wie die der Quelldaten angenommen.

Der Kopiervorgang erfordert die Verwendung eines Lese- und eines Schreibkanals.
In diesem Fall verwenden wir A zum Lesen und D (offensichtlich) zum Schreiben.
Um von Kanal A nach Kanal D zu kopieren, müssen die MINTERMS auf den Wert $F0
eingestellt werden. Daher ist der Wert, der in das BLTCON0-Register geladen
werden muss, $09f0.

Beachten Sie, dass wir auch mit einem anderen Kanal zum Lesen (B oder C) hätten
kopieren können. Sie können es selbst in einer Übung versuchen. Die Änderungen
sind sehr einfach:

- Aktivieren Sie den Kanal, den Sie anstelle von Kanal A verwenden möchten
  (Bit 8-11 von BLTCON0)

- Ändern Sie den Wert der MINTERMS (Bit 0-7 von BLTCON0), um eine Kopie
  von dem Kanal, den Sie verwenden möchten in Kanal D zu bekommen.
  Um von Kanal B nach D zu kopieren, ist der korrekte Wert $CC,
  während zum Kopieren von C nach D der richtige Wert $AA ist.

- Schreiben Sie die Startadresse der zu kopierenden Daten statt in den Zeiger
  für Kanal A (BLTAPT) in den Kanalzeiger, den Sie verwenden möchten. Die
  Adressen der Register BLTBPT und BLTCPT werden in der Lektion gezeigt.
