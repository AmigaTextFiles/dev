
; Listing2m.s

; Beweis dafür, daß wenn auf den Registern a0..a7 operiert wird, immer
; mit dem ganzen Longword gearbeitet wird, auch mit einem .W


Anfang:
	move.l	#$FFFFFF,d0
	ADDQ.W	#4,d0			; Zählt 4 .W zu d0 dazu, es arbeitet 
							; aber nur auf dem WORD, da wir uns 
							; in einem Datenregister befinden, 
							; gleich wie bei einer Label
	
	lea	$FFFFFF,a0
	ADDQ.W	#4,a0			; Zählt 4 .W zu a0 dazu, da es aber auf 
							; einem ADRESSREGISTER agiert, wird die 
							; ganze Adresse davon in Mitleidenschaft 
							; gezogen, also das ganze Longword
	rts

	end

Probiert ein Debug dieses Listings zu machen (AD), und Schritt für Schritt
werdet  ihr den Unterschied zwischen einem Daten- und einem Adressregister
erkennen.  Das  gleiche  gilt  für   Label,   sie   verhalten   sich   wie
Datenregister.  Der Unterschied liegt darin, daß bei Adressregistern immer
auf der gesamten Adresse (Londword) gearbeitet  wird,  denn  es  ist  auch
nicht  möglich,  darauf  mit  .B-Befehlen  zu  arbeiten.  Wenn  wir ein .W
verwenden (nur möglich, wenn wir Zahlen subtrahieren/addieren/bewegen... ,
die  kleiner  als ein Word sind, dann ist das Resultat das gleiche, als ob
wir mit einem .L gespielt hätten. Deswegen kann man auch immer nur ein  .L
verwenden,  es  ist aber nützlich, den Befehl in ein .W zu "optimisieren",
wenn es möglich ist, da es schneller ist als ein .L. Mit  dem  Debug  seht
ihr,  daß  das ADDQ.W #4,d0 nur auf dem Word arbeitet, im d0, es ändert in
$00FF0003, da ja nach dem $FFFF von NULL ($0000) gestartet wird, und  dann
bis  $0003  raufzählt.  Der  "höhere"  (höherwertigere) Teil der Zahl wird
nicht beeinflußt. Wenn aber ein ADDQ.L #4,d0 gemacht  würde  (probiert!!),
dann  würde  die  GANZE  Longword angesprochen, und sie würde in $01000003
mutieren, denn nach dem $00FFFFFF kommt $01000000. Auf den Adressregistern
hingegen  wirkt  sich  das  ADDQ.W  wie  ein  ADDQ.L aus, da gibt´s keinen
Unterschied, nur kann es nicht immer verwendet werden, wie  z.B.  für  die
Zahl  $123456.  Es  ist  zwar  kein  Fehler,  aber  versucht, immer ein .W
einzusetzen, wenn es möglich ist, da es etwas schneller ist als das .L.

	ADD.L	#$123,a0		; Optimierbar in ADD.W #$123,a0
	ADD.L	#$12345,a0		; Nicht optimierbar

