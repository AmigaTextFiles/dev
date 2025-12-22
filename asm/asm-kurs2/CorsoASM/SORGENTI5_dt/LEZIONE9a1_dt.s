; Lesson9a1.s - Löschen von $10 Wörter mit dem BLITTER
; Bevor Sie dieses Beispiel sich ansehen, schauen Sie sich LEZIONE2fs an, wo es herkommt
; gelöschter Speicher mit dem 68000

	SECTION Blit,CODE

Inizio:
	move.l	4.w,a6	; Execbase in a6
	jsr	-$78(a6)	; Disable - stop multitasking
	lea	GfxName,a1	; Adresse des Namens der zu öffnenden Bibliothek in a1
	jsr	-$198(a6)	; OpenLibrary
	move.l	d0,a6	; benutze eine Routine von graphics library:

	jsr	-$1c8(a6)	; OwnBlitter, 
					; das gibt uns den exklusiven Zugang auf dem Blitter
					; verhindert, das es vom Betriebssystem verwendet wird.
					; Wir müssen warten, bevor wir den Blitter benutzen
					; das es einen laufenden BLittervorgang beendet hat.
					; Die folgenden Anweisungen erledigen das

	btst	#6,$dff002	; warte auf das Ende des Blitters (leerer Test)
					    ; für den BUG von Agnus
waitblit:
	btst	#6,$dff002	; freier Blitter?
	bne.s	waitblit

; Hier ist, wie man eine Blittata macht !!! 
; Nur 5 Anweisungen zum Zurücksetzen !!!
;	     __
;	__  /_/\   __
;	\/  \_\/  /\_\
;	 __   __  \/_/   __
;	/\_\ /\_\  __   /\_\
;	\/_/ \/_/ /_/\  \/_/
;	     __   \_\/
;	    /\_\  __
;	    \/_/  \/

	move.w	#$0100,$dff040	 ; BLTCON0: nur Ziel D ist aktiviert				
					; die MINTERMS (dh die Bits 0-7) sind alle
					; zurückgesetzt. Auf diese Weise ist die 
					; Löschoperation definiert					

	move.w	#$0000,$dff042	 ; BLTCON1: Wir werden dieses Register später erklären
	move.l	#START,$dff054	 ; BLTDPT: Adresse des Zielkanals
	move.w	#$0000,$dff066	 ; BLTDMOD: Wir werden dieses Register später erklären
	move.w	#(1*64)+$10,$dff058 ; BLTSIZE: definiert die Dimension des
				    ; Rechtecks. In diesem Fall haben wir
				    ; $10 Wörter Breite und 1 Zeilenhöhe.
					; Weil die Höhe des Rechtecks in die Bits 6-15 von 
					; BLTSIZE ​​geschrieben wird
					; müssen wir es 6 Bits nach links verschieben.
					; Dies entspricht der Multiplikation seines Wertes
					; mit 64. Die Breite wird in die niedrigen
					; 6 Bits geschrieben und werden daher nicht
					; geändert.
					; Außerdem beginnt diese Anweisung die Blittata					 

	btst	#6,$dff002	; warte auf das Ende des Blitters (leerer Test)
waitblit2:
	btst	#6,$dff002	; freier Blitter?
	bne.s	waitblit2

	jsr	-$1ce(a6)	; DisOwnBlitter, das Betriebssystem
					; kann den Blitter jetzt wieder benutzen
	move.l	a6,a1	; Basis der Grafikbibliothek zum Schließen
	move.l	4.w,a6
	jsr	-$19e(a6)	; Closelibrary - schließe die Grafikbibliothek
	jsr	-$7e(a6)	; Enable - Multitasking einschalten
	rts

******************************************************************************

	SECTION THE_DATA,DATA_C

; Beachten Sie, dass die gelöschten Daten im CHIP-Speicher liegen müssen
; Tatsächlich funktioniert der Blitter nur im CHIP-Speicher

START:
	dcb.b	$20,$fe
THEEND:
	dc.b	'Hier loeschen wir nicht'

	even

GfxName:
	dc.b	"graphics.library",0,0

	end

Dieses Beispiel ist die Blitter-Version der Lektion2f.s-, in der ja
die Bytes durch eine Schleife von "clr.l (a0)+" zurückgesetzt werden.

In diesem Fall, assemblieren sie, ohne zu starten, und überprüfen erst mit einem "M START"
das unter dem Label $20 Bytes "$fe" vorhanden sind. An diesem Punkt führen wir das
Listing aus und aktivieren zum ersten Mal im Kurs den Blitter. Danach
wiederholen Sie "M START" und Sie werden bestätigen, dass diese Bytes bis zum
Label THEEND gelöscht wurden. In der Tat mit einem "M THEEND" finden Sie immer seinem
Platz.
Die Löschoperation erfordert nur die Verwendung des D-Kanals.
Außerdem müssen alle MINTERMS zurückgesetzt werden. Daher ist der Wert, der im 
BLTCON0-Register geladen werden soll $0100.

Beachten Sie den Wert, der in dem BLTSIZE-Register geschrieben wird. Wir müssen
ein Rechteck, das 10 Wörter breit und eine Zeile groß ist löschen. Wir müssen die Breite 
immer in die Bits 0-5 von BLTSIZE und die Höhe in die Bits 6-15 von BLTSIZE schreiben.
Um die Höhe in die Bits 6-15 zu schreiben, können wir sie 6 Bits nach links verschieben,
was einer Multiplikation mit 64 entspricht.
Die Dimensionen des Rechtecks, das in dem BLTSIZE-Register zu löschen ist, verwenden die
folgende Formel:

In BLTSIZE = (HEIGHT * 64) + WIDTH zu schreibender Wert

Ich erinnere Sie daran, dass die BREITE in Worten ausgedrückt wird.

HINWEIS: Es wurde eine Betriebssystemfunktion verwendet, die wir noch nie benutzt haben.
Das ist diejenige, die den Gebrauch des Blitters vom System verhindert, um zu vermeiden,
den Blitter zu verwenden, wenn die Workbench ihn auch benutzt.
Um die Verwendung des Blitters durch das Betriebssystem zu deaktivieren und zu reaktivieren 
ist es ausreichend, die entsprechenden bereits fertig im Kickstart vorhandenen Routinen
zu verwenden.
Wie in der graphics.library: Wenn man das GFXBASE in A6 hat, reicht es aus.

	jsr	-$1c8(a6)	; OwnBlitter, das gibt uns den exklusiven Zugang auf dem Blitter
	
Um sicherzustellen, dass wir die einzigen sind, die nach dem Blitter suchen.

	jsr	-$1ce(a6)	; DisOwnBlitter, das Betriebssystem
					; kann den Blitter jetzt wieder benutzen

Vor dem Beenden des Programms ist es erforderlich, die Workbench zu reaktivieren.

Erinnere dich also daran, dass wenn wir den Blitter in unseren Meisterwerken verwenden.
Sie müssen OwnBlitter am Anfang und DisownBlitter am Ende hinzufügen,
zusätzlich zu den bekannten Deaktivieren und Aktivieren.

