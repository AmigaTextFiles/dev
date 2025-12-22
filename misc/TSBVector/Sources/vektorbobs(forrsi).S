;-----------------------------------------------------------------------
; Beispiel eines Vektorballobjekt-Sourcecodes for including an
; Objekt made with THE SPECIAL BROTHERS Vectordesigner....
;-----------------------------------------------------------------------
; Normales Vektorballsobjekt 
;-----------------------------------------------------------------------
;(Seka-format)
;Benutzung:
;a (return)
;ri (return)
;name.s (return)
;ballpoints (return)
;ballart (return)
;wi (return)
;name (return)
;start (return)
;end (return)
;Danach kann das Objekt vom Demomaker aus unter "name" eingeladen werden.
;------------------------------------------------------------------------
start:
dc.l	"BALL"	;Kennung fuer Ballsobjekt

ballsob1:
dc.l ballpoints-ballsob1	;offset fuer Punktstruktur
dc.l ballart-ballsob1		;offset fuer Ballartstruktur
dc.w 650			;zoom = 650
dc.w 0,$500,$710,$930,$a50,$d90,$fd0,$000,$5,$6,$118,$33a,$55b,$88c,$ccd
dc.w $fff	;16 farben
dc.l 0		;kein Initroutine
dc.l 0		;kein Zusatzroutine


ballpoints:	;Punktstruktur

blk.b 1024,0

ballart:	;Struktur fuer Ballarten

blk.b 1024,0

end:
