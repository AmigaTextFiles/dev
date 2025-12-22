
; Listing2b.s

Anfang:
	Move.L	HUND,KATZE
	rts

HUND:
	dc.l	$123456

KATZE:
	dc.l	0

	END

Mit diesem Beispiel kann man verifizieren,  daß,  einmal  assembliert,  an
Stelle  der  Label  die  effektiven  Adressen von HUND: und KATZE: gesetzt
werden. Assembliert mit A, dann tippt ein "D Anfang" und  ihr  werdet  den
Tausch  bemerken.  Nach dem RTS werdet ihr einige ORI.B und andere Befehle
sehen: in Wirklichkeit sind das Versuche von Seiten  des  Assemblers,  die
zwei  Longword  HUND und KATZE zu interpretieren. Nach dem $4e75, dem RTS,
steht $00123456, das erste Longword von uns HUND genannt,  und  $00000000,
unsere  KATZE.  Jetzt führt es mit J aus und macht danach ein M KATZE, und
ihr werdet ein 00  12  34  56  erhalten:  das  Longword,  das  unter  HUND
enthalten  war, wurde unter KATZE kopiert. Nun modifiziert die erste Zeile
zu MOVE.L #HUND,KATZE, assembliert  und  dann  "D  Anfang"...  Auch  jetzt
wurden  die  Label  durch  die  realen  Adressen ersetzt, denn der einzige
Unterschied zu vorhin ist der Lattenzaun (#). Aber der  ändert  alles,  es
ist  ein  Unterschied  wie  Tag  und  Nacht!!!!!!  Wenn  ihr diesmal mit J
ausführt und dann ein M KATZE macht,  werdet  ihr  die  Adresse  von  HUND
erhalten!  Also,  wenn  der  Befehl  als MOVE.L #$34200,$34204 assembliert
worden wäre, dann wäre nachher in $34204 (also  KATZE),  die  FIXE  Nummer
nach  dem  Lattenzaun  (#)  eingefügt  worden,  eben die Adresse von HUND,
$34200.

	MOVE.B	$10,$200		; kopiert den .b-Wert, der in  der Speicher-
							; zelle $10 liegt, in die Speicherzelle $200
	MOVE.B	#$10,$200		; Gibt $10 in die Speicherzelle $200
	MOVE.B	#16,$200		; Das GLEICHE wie oben, denn $10 = 16!!
	MOVE.B	#%10000,$200	; Das GLEICHE wie oben, %10000 = 16!!

Bemerke: Der ASMONE positioniert (allocate) ein Programm jedesmal irgendwo
anders,  an einer anderen Adresse, genauso wie das Betriebssystem, wenn es
ein Programm lädt, da, wo gerade Speicher  frei  ist.  Das  ist  eine  der
Stärken des Multitaskings des AMIGA. Wenn ihr ein ausführbares File mit WO
abspeichert,  dann  wird  es  im  AMIGADOS-Format  gespeichert,  und   das
Betriebssystem  wird  es  dahin geben, wo es es für richtig hält. Deswegen
schreibe ich "wenn der Befehle als $34200 assembliert worden wäre....": es
kann  in  jedem  Punkt  im  Speicher  liegen.  Ladet  einige  Programme in
Multitasking, bevor  ihr  den  ASMONE  startet,  und  ihr  werdet  weniger
verfügbaren Speicher bei der anfänglichen Wahl (ALLOCATE CHIP/FAST) haben.
Wenn ihr dann ein "D ANFANG" macht, werden die Adressen "höher" sein, weil
der  darunterliegende  Speicher  schon  belegt  ist.  Mit  FIXEN  ADRESSEN
programmieren, also statt Label immer die Adresse angeben, geht  auch  bei
Spielen  und  Demos  nicht,  bei denen man danach zur Workbench aussteigt,
denn wenn z.B. der Grafikbildschirm auf $70000 definiert ist, und man  zur
Workbench  wechselt, die, welch Zufall, auch dort etwas verloren hat, dann
erntet man einen schönen GURU MEDITATION, auch KOMA genannt....  wenn  ihr
also  den  AMIGA  nicht dauernd ins Koma schicken wollt, dann programmiert
wie es dieser Kurs beschreibt. Fixe Adressen kann - und muß -man  manchmal
verwenden,  wenn  man  AUTOBOOT-Spiele oder Demos programmiert, also jene,
die nicht von der Workbench aus starten, sondern  automatisch,  und  deren
Directory  nicht  sichtbar ist (viele Spiele sind so aufgebaut). Bevor wir
aber Autoboot-Spiele machen, ist es, glaube ich, besser zu  lernen,  etwas
auf den Bildschirm zu bringen, deswegen reden wir später noch mal darüber.


