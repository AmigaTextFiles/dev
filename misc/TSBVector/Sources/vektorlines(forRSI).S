;-----------------------------------------------------------------------
; Beispiel eines Vektorobjekt-Sourcecodes for including an 
; object made with THE SPECIAL BROTHERS Vectordesigner ..
;-----------------------------------------------------------------------
; Normales Linienobjekt 
;-----------------------------------------------------------------------
;(Seka-format)
;Benutzung:
;a (return)
;ri (return)
;name.r (return)
;polylist (return)
;return
;wi (return)
;name (return)
;start (return)
;end (return)
;Danach kann das Objekt vom Demomaker aus unter "name" eingeladen werden.
;------------------------------------------------------------------------

start:
dc.l	"VECT"	;Kennung fuer Objekt!!!

filledob5:
dc.l polylist-filledob5		;offset zu Punktstruktur
dc.l verbindung-filledob5	;offset zu Verbindungsstruktur
dc.w 400			;zoom = 400
				;when you designed it to BIG try
			        ;a BIGGER zoom
dc.w 0,$fff,0,0,0,0,0,0		;8 Farben	(2.Farbe is Objektfarbe)
dc.b 0	;kein sync
dc.b 2	;2-Linienobjekt
dc.w 0	;hier keine Funktion
dc.l 0	;keine Zusatzroutinen
dc.l 0	;...

polylist:	;Punktstruktur

blk.b 1024,0    

verbindung:	;Verbindungstruktur

blk.b 2048,0

end:

