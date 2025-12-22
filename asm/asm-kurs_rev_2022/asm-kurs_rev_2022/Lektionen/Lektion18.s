
ASSEMBLERKURS - LEKTION 18: 3D

Hinweis: In dieser Lektion sind sämtliche Dateien, die im Kurs enthalten sind
hintereinander angeordnet. Die italienischen sind ins deutsche übersetzt. Die
englischen sind unverändert.

1. 3dLezione
2. 3D-GFX
3. 3d-wsb
4. LEZIONE_MAT
5. Texture_Wasb
6. TextureMapping
7. DOOM.txt	(en)
8. DoomSpecs.txt (en)
9. DoomTechniques.txt (en)
10. FIRE.txt (en)
11. Voxel.txt (en)
12. Clip.PolyArticle (en)


*******************************************************************************
*  1. Datei - 3dLezione														  *	
*******************************************************************************

PROJEKT FÜR DIE 3D LEKTION:

Im Moment gibt es nur Teile des Dokuments anderer und meine vorläufigen
Schriften. Sie sind ein wenig in der Reihenfolge enthalten, die auf jeden Fall
als STARTBASIS dienen.
Beachten Sie, dass diese Lektion platziert wird nach den Lektionen in
denen copper, Blitter, Interrupt usw., erklärt wurden, sodass der Leser für
das worum es im Hardware-Handbuch geht, geimpft ist.


Hier ist das "Projekt" dieser Lektion:

		1 - PERSPEKTIVE

1)  Erklärung der Perspektive bis zur einfachen Routine. Es gibt bereits
    Lektion 3d-1, die eine Idee ist: nur Translationen zu machen, um es den
    Leuten verständlich zu machen... am Anfang nur PLOT von Punkten, klarer ...
1b) Nach der Erläuterung der Perspektive können auch andere Beispiele angeführt
    werden, wie z.B. klassische 3D Sterne, die aus der Mitte kommen, gibt
    Idee von Referenz ...
1c) Ich weiß nicht, ein 3D-Boden, etwas, das nur die Perspektive benutzt
    ohne Rotationen, nur Translationen.

		2 - ROTATION

2) Jetzt, da die Perspektive verstanden ist, können wir die ersten Umdrehungen
   machen, aber am Anfang ist es gut, sie nur um eine Achse zu machen, dann um
   zwei und schließlich um 3, aber mit vielen Beispiellistings für jeden Schritt
   und eine anständige Erklärung, warum sich die Punkte drehen. In Verbindung
   mit Rotationen können Sie auch Linien verwenden ... aber vorerst nur normaler
   WIREFRAME ...

2b ) Sobald die Drehungen vorgenommen wurden, können Sie auch die Vektorkugeln
   einfügen, das dabei die Sortierroutine erklärt, mit dem Blitter, da an
   diesem Punkt der Blitter bereits bekannt ist.

		3- VERSTECKT

3) Dann müssen wir erklären, wie man den Vektor der versteckten Linie macht und
   später auch füllt .... Ich empfehle die Einfachheit und die verschiedenen
   Schritte mit verschiedenen kleinen Listings, die die Entwicklung
   veranschaulichen ...

		4 - LICHTQUELLE oder anderes

4) Der Zweck der Lektion ist es, JEDEM verständlich zu machen, wie man einen 
   altmodischen gefüllten Vektor bekommt, ohne übertriebene Optimierungen das 
   erschwert nur das Verständnis und verwirrt auch, d.h. nicht mit Kreuzungen
   oder echten Lichtquellen etc. Wir könnten jedoch veranschaulichen, wie eine
   Lichtquelle erstellt wird mit pos. Z Mittelwert der Flächen oder wie man
   Festkörper unkonvex macht usw...
 
Was die Textur, den Bildzoom und die Rotationen oder die DOOM-Labyrinthe
betrifft da es sie seit 1992-93 gibt, also neuer als die Träger, würde ich sie
in eine separate Lektion später setzen. Hier behandeln wir die Entwicklung von
Vektoren von 1987 mit Linevektoren bis 1990-91 mit Lichtquelle.

In den 3 Verzeichnissen gibt es verschiedene Beispiele, einschließlich Ihrer
Listings, nur als Referenz bei der Zusammenstellung der Beispiele und Theorie:

DIR:

3d0 - diese Lektion und die Listings vom Punkt- / Linienvektor zum versteckten
	  Linienvektor
3d1 - die Vektorkugeln!
3d2 - gefüllte Vektoren, auch Lichtquelle.
3d3 - nur für Füllung, schattierte Vektoren und Darkman chunkyvecs, nichts
      weiter, aber zumindest füllen sie den leeren Teil der Diskette ... !!!

******************* Beginn der Lektion: **********************************

- Repräsentationssystem

Hinweis: Um einen Linienvektor zu erstellen, müssen Sie nur die Mathematik
der dritten Ebene kennen. (Die Sprache ist für einen gefüllten Vektor mit
Lichtquellen unterschiedlich).
Denken Sie jedoch daran, niemals weiterzulesen, bis Sie ALLES verstanden haben
oder gehen Sie mindestens zurück und lesen Sie noch einmal, was Sie nicht
verstanden haben. Grundsätzlich sind es ein paar Formeln, die einmal in
680x0-Routinen "übersetzt" "von selbst" funktionieren. Erhöhen Sie einfach die
Anzahl von loop dbra, um Objekte komplexer erscheinen zu lassen.
Also sehen Sie, wie sie funktionieren, auf diese Weise können Sie Ihre eigenen
Modifikationen oder "Erfindungen" machen, ansonsten würden Sie nur die Objekte
ändern und die Beispielroutine verwenden, die von geringem Wert ist. Das
Wichtigste ist, kleine Schritte zu unternehmen, ohne zu hoffen, alles an einem
Nachmittag zu verstehen.
Sie müssen auch viel Vorstellungskraft in Bezug auf Dreidimensionalität haben.
Das heißt, Sie müssen sich vorstellen können, wie ein bestimmtes Objekt
hergestellt wird, wenn von oben oder von der Seite gesehen usw. In der Praxis
ist es die Kenntnis orthogonaler Projektionen, die ein Repräsentationssystem
wie uns bekannte 3D-Programme wie Imagine oder Real 3D verwenden darstellen.

******************************************************************************
*				DIE PERSPEKTIVE												 *
******************************************************************************

Angenommen, wir sind in einer Prärie in Arizona und fahren extrem schnell
Motorrad und dann stoppen wir um den Horizont zu beobachten.
Plötzlich erscheint ein Würfel am Himmel! Ein UFO!?
Nun, UFO oder nicht UFO, es ist ein gutes Beispiel, um zu erklären, wie die
Perspektive funktioniert. Wie Sie wissen, haben wir 2 Augen. Stellen wir uns
vor, wir haben nur eins. Andernfalls müssten wir zu viele Dinge
berücksichtigen, die zu den Helmen der visuellen Realität und in Stereometrien.
Wir sind also allein mit dem UFO, und da wir hart sind, bringen wir die
Augenbinde mit, die auf das Auge kommt wie ein Pirat (zusätzlich zum Zopf,
Ohrring usw.) und sehen das UFO nur mit dem freigelegten einem Auge.
Wir sind so überrascht, dass es uns nicht einmal einfällt, die Augenbinde zu
heben um besser zu sehen. Andererseits nähert sich der Würfel, indem er sich
bedrohlich dreht. Da wir hart sind, anstatt wegzulaufen, beginnen wir, die
Perspektive zu studieren. Hier ist eine Illustration:
	   ___
	 /__ /|	<-- UFO							  !
	|   | |
	|___|/									 -O. <--- WIR
											  ||
______________________________________________/\_____________

Dieses Bild ist die "Profil" -Ansicht.

Wir werden das Bild jedoch "in der Perspektive" sehen:

	 _______________________________
	|								|
	|		      ____				|
	|		     /   /\				|
	|			/___/  \			|
	|			\   \  /			|
	|			 \___\/				|
	|								|
	|-------------------------------| <- Linie des Horizonts
	|								|
	|								|
	|_______________________________|


Dies ist das Bild, wie es auf dem Monitor erscheinen sollte, d.h. ähnlich wie
man es mit den Augen sehen kann. Aber wie bekommt man es?
Das Problem ist, dass die VOLLE-Figur 3 Dimensionen hat, während der Monitor 
nur 2 hat! Höhe und Breite! Es fehlt das Z, das ist die Tiefe.
Wir versuchen also, es in eine zweidimensionale Figur zu verwandeln
etwas, das stattdessen dreidimensional ist. Das machen wir, wenn wir 
ein Foto schießen: Ein Würfel würde in zwei Dimensionen dargestellt.
Jetzt wissen wir, wonach wir suchen. Lassen Sie uns die Situation besser sehen:

Lassen Sie uns ein Schema machen:

									|
	      ______________ _			|
	     /|			   /|	 _		|
	    / |			  / |	     _	|
	   /  |			 /  |			-   _
	  /   |			/   |			|      -  _  _
	 /____|________/    |			|   _   - _-¢_> AUGE
	|     |       |     |		 _   -     _ -    
	|     |_______|____ |_  -		| _ -
	|    /	      |    /	      _ -
	|   /         |   /       _ -	|
	|  /	      |  /    _ -		|
	| /			  | / _ -			|
	|/____________|/-				|
									|
									|
	
		^			^
	     OBJEKT X,Y,Z			  BILD


Wir sehen das Objekt im Raum, unser Auge und zwischen dem Auge und dem Objekt
ein mysteriöses Bild.
Also dann. Wir haben das Objekt durch seine X-, Y- und Z-Punkte definiert.
Mal sehen, welchen Weg diese Punkte nehmen, um ins Auge zu gelangen: Alle
Strahlen gehen zum Auge, und die Strahlen des Auges gehen zu den Punkten,
abhängig von philosophischen Interpretationen. Es ist jedoch sicher, dass
eine Figur auf dem Bild gezeichnet ist. Mmmmh ... ABER SICHER!
Es ist die perspektivische Projektion! In der Praxis ist das Bild nichts
anderes als unser MONITOR, auf dem die Figur gebildet wird und die Perspektive
verzerrt. In der Tat, würden Sie bemerken, falls sich der Würfel wegbewegen
würde, dass die Figur auf dem Bild kleiner werden würde, wenn sie sich ihr
nähern würde es sich vergrößern, so wie es auch passiert, wenn wir uns uns
Objekten nähern oder uns von ihnen wegbewegen!
Jetzt kennen wir das zweidimensionale (vom Monitor druckbare) Äquivalent von
unserem dreidimensionalen Objekt welches wir durch Platzieren einer Glasplatte
zwischen uns und dem Objekt erhalten würden. Die Figur, die wir sehen, bekommen
wir durch Zeichnen mit einem Filzstift auf dem Glas. Logisch oder? Aber wir
haben hier keinen Stift oder Glasplatte auf dem das Bild erscheint. Wir 
haben Koordinaten ...

										 |
										/|
									   / |
									  /  |
									 /   |
									/    |
	      ______________ _	       /     |
	     /|			   /|	 _     |     |
	    / |			  / |	     _ |     |
	   /  |			 /  |	       |-___ |
	  /   |			/   |	       |/__/||-  _  _
	 /____|________/    |	       ||  ||| - _-¢_> Auge
	|     |       |     |	    _  ||  ||| -    
	|     |_______|____ |_  -      ||__|/|
	|    /	      |    /	      _|-    |
	|   /         |   /       _ -  |     |
	|  /	      |  /    _ -      |     /
	| /			  | / _ -	       |    /
	|/____________|/-			   |   /
								   |  /
								   | /
								   |/

			^						^
	     Auge					 Bild


Wir haben das Bild leicht gekippt, und wir bemerken, dass es tatsächlich
unseren Würfel zeigt und es sind NUR ZWEI ABMESSUNGEN! X und Y!

Versuchen wir, unsere Rede etwas wissenschaftlicher zu gestalten: wir haben
einen 2-dimensionalen Monitor, X und Y, in dem wir Punkte, Linien oder
was Sie wollen zeichnen können, indem Sie die Koordinaten der Punkte angeben:


		  0,0		Achse X
		  o---------------------------------> 320,0
		A |
		c |
		h |
		s |
		e |
		  |
		Y |								   |
		  |  							___| 320,256
	      \/
		 0,256

Die obere linke Ecke des Monitors ist der 0,0-Punkt.


Jetzt müssen wir unser dreidimensionales Objekt X, Y und Z entwerfen, wobei 
wir Z "Tiefe" nennen können:

					  +
			 		/|
					/
			       /
			      /
		     /
			    /
	    0,0,0  /		Achse X
			  o--------------------------------->
			 /|
		   Z/ |
	       /  |
	    e / A |
	   s /  c |
	  h /   h |
	 c /	s |
	A /		e |
	 /		  |
	/		Y |
   |/		  |
   -          \/


Wie Sie sehen können, wurde eine Achse hinzugefügt, die auf uns zukommt, als ob
die X- und Y-Achse die Verbindungen eines Fensters waren, und Z war ein 
Verschluss zum Öffnen:
				___		-> X
			  /|   |
			 / |   |
			/  |   |
			|  |   |
			|  |___|
			| /
			|/

	       /   |

	     Z	   Y


Wenn wir ein Punkt im Fenster wären, würde das Gehen nach rechts unser X
erhöhen, ein Abstieg würde unser Y erhöhen und aus dem Haus gehen in Richtung 
von Ihnen würde das Z vergrößern. 
Der Z-Wert nimmt zu, wenn das Objekt sich vom Beobachter entfernt.
Der Beobachter, das heißt das Auge, befindet sich normalerweise am Punkt
Z = 0 und das Z ist negativ, wenn das Objekt "hinter" uns vorbei geht und wir
es dann nicht sehen.

In der Zwischenzeit entwerfen wir unseren Würfel im X-, Y- und
Z-Koordinatensystem: Dazu können Sie quadratisches oder Millimeterpapier
verwenden oder es "im Kopf" entwerfen, wenn Sie ein Genie sind.
Hier ist eine Art Design eines Würfels, der, wie Sie wissen, 6 Flächen hat und
nicht weniger als 6 Kanten. Das sind die Punkte, die uns interessieren.


	WENIGER< X >MEHR'		WENIGER			MEHR'
							 ^				/|
							 Y		       Z
							 v		     |/
							MEHR'		WENIGER


	      (P4) -50,-50,+50______________+50,-50,+50 (P5)
						 /|			   /|
						/ |			  / |
					   /  |			 /  |
					  /   |			/   |
	 (P0) -50,-50,-50/____|________/+50,-50,-50 (P1)
					|     |       |     |
					|     |_______|_____|+50,+50,+50 (P6)
					|    /-50,+50,+50 (P7)
					|   /	      |   /
					|  /	      |  /
					| /			  | /
				|/____________|/+50,+50,-50 (P2)
	 (P3) -50,+50,-50


Wie Sie sehen können, ist X der Versatz von rechts nach links, Y ist das
"Auf-Ab" und Z ist die Tiefe oder "vorwärts-rückwärts".

Wie Sie bemerkt haben, befindet sich in diesem Beispiel der Punkt 0,0,0 in der
Mitte des Würfels, um das System klarer zu machen. Tatsächlich die 4 Punkte,
die die Fläche auf der linken Seite bilden haben alle die Koordinate X = -50,
während die Seite, die ihr gegenübersteht alle die Koordinate X = +50 haben.
Andererseits haben die 4 Punkte, die die Oberseite bilden, alle die Koordinate
Y = -50, während diejenigen, die die Unterseite bilden, Y = +50 haben.
(Vorsicht, hier erhöht sich Y, wenn Sie "nach unten" gehen).
Schließlich haben die 4 Punkte, die die "Vorderseite" bilden, die Koordinate
Z = -50, während die 4 Punkte der "Rückseite" die Koordinate Z = +50 haben,
das heißt Tiefer.

Mit diesen Informationen können wir eine Datenstruktur eines Würfels aus 
Punkten erstellen, um unser Objekt zu bilden:

CubeObject:	; Mega Simple Mythical Cube, 8 Punkte.
; Hier sind die 8 Punkte, die durch die Koordinaten X, Y, Z definiert sind.

	dc.w	-50,-50,-50	; P0 (X,Y,Z)
	dc.w	+50,-50,-50	; P1 (X,Y,Z)
	dc.w	+50,+50,-50	; P2 (X,Y,Z)
	dc.w	-50,+50,-50	; P3 (X,Y,Z)
	dc.w	-50,-50,+50	; P4 (X,Y,Z)
	dc.w	+50,-50,+50	; P5 (X,Y,Z)
	dc.w	+50,+50,+50	; P6 (X,Y,Z)
	dc.w	-50,+50,+50	; P7 (X,Y,Z)

NPuntiOggetto	= 8

Ok, wir haben den Gegenstand! Das Problem ist nun, wie man es relativiert.

******************************************************************************
*	Berechnen wir die Y-Koordinate der auf der Platte projizierten Punkte    *
******************************************************************************

Kehren wir zum vorherigen Augendiagramm zurück, um zu sehen, wie Sie die 
Y-Koordinaten der auf dem Bildschirm projizierten Punkte finden. Nehmen wir an,
dass das Auge auf dem Boden, an Position Y = 0 ist. Ich weiß, es ist unmöglich,
aber stellen Sie sich vor, sie befinden sich in einem Graben und sehen den
Würfel aus der Erde herausragen:

Vision von "PROFIL":

				<---------------- Achse Z (Tiefe') --------------->
 ^
 |										|
 A							P			|	
 c			  ______________ _			|	
 h			 /|			   /|	 _		|	
 s			/ |			  / |		 _	| P¹	
 e		   /  |			 /  |			-  _
 		  /   |			/   |			|	 -  _  _			BODEN
 Y ----- /____|________/    |-----------+-----------¢_> AUGE -------------
 |		|     |       |     |T			|T¹
 |		|     |_______|____ |			|
 |		|    /	      |    /			|
 v		.   .	      .   .
		^			^
		   OBJEKT X,Y,Z				  BILD


Punkte:

Auge = Beobachterposition, nennen wir es O.
P	= Punkt des Objekts im XYZ-Raum
P¹	= Punkt P auf das Bild projiziert
T	= Y=0 (Bodenhöhe) an der Stelle, an der der Würfel "auftaucht".
T¹	= Y=0 (Bodenniveau) an dem Punkt, an dem das Bild "gepflanzt" wird.

Mal sehen, wie man die Y-Koordinate des Punktes P¹ auf dem Bild (dem Monitor)
findet. Das ist seine perspektivische Projektion. Wie Sie bemerken "erscheinen"
2 Dreiecke, ähnliche Dreiecke, nämlich "O-P-T" und "O-P¹-T¹":

		P
	       |-_      |(Bild)
	       |  -_    |
	A      |    -_  |
	c      |      -_|P¹
	h      |		+_	
	s      |		| -_
	e      |		|   -_
	       |		|     -_
	Y      |		|       -_
	       |T_______|T¹_______-O (Auge)

			<---- Achse Z ---->


Segmente:

PT	= Y-Koordinate von Punkt P im Raum (Yogg)
P¹T¹ = Y-Koordinate des Punktes P¹ im Bild (INCOGNITA Y¹)
OT	= Abstand Z des Punktes P vom Beobachter (DistZPunto)
OT¹	= Abstand Z des Beobachters vom Rahmen (DistZossSchermo)

Wenn wir wissen, was PT, OT und OT¹ sind, müssen wir dies berücksichtigen, um
P¹T¹ zu finden. Die Höhe des großen Dreiecks ist die Höhe des kleinen Dreiecks
(was wir brauchen), da die Basis des großen Dreiecks die des kleinen Dreieck
ist. Es scheint klar zu sein, oder?
Daher ist PT zu P¹T¹ wie OT zu OT¹, mit anderen Worten: PT:X=OT:OT¹

Um das zu bekommen, wonach wir suchen, ist das P¹T¹ (die Y-Koordinate des
Punktes auf die Leinwand projiziert) müssen wir die Extreme des Anteils
multiplizieren, d.h. PT * OT¹ und dividieren das Ergebnis durch OT:

	P¹T¹=(PT*OT¹)/OT

Wir könnten "übersetzen" in:

	Yproiettato = (Yogg*DistZossSchermo)/DistZPunto

Und deshalb grob, in:

	move.w	Yogg,d0				; Koordinate Y des Objekts
	muls.w	DistZossSchermo,d0	; DistZossSchermo*Yogg
	divs.w	DistZPunto,d0	    ; In d0 haben wir die Y-Koordinate des Punktes P¹

Natürlich muss eine Schleife erstellt werden, die alle Punkte projiziert.

******************************************************************************
*	Berechnen wir die X-Koordinate der auf dem Bild projizierten Punkte	     *
******************************************************************************

Nun, jetzt sollten Sie schon erahnen, das um das X des Punktes P¹ zu berechnen
die Vorgehensweise analog ist. Wir haben eben die Profilszene gesehen, bei der
die Y-Achse als "stehend" betrachtet wurde, dh senkrecht zum Boden, wie ein
Lichtmast. Die X-Achse hingegen kam theoretisch auf uns zu.
Es gab nur einen Punkt, wie einen Pfeil, der in unsere Augen kommt. Die Z-Achse
war dagegen die horizontale Linie, die mit dem Boden identifizierbar war.
Jetzt bewegen wir uns, um die Szene von oben zu sehen, auf diese Weise 
bleibt die Z-Achse unverändert, während die X-Achse den Platz des Y einnimmt:

Gehen wir nun zu einer Ansicht von "OBEN":

		P
	       |-_      |(Bild)
	       |  -_    |
	A      |    -_  |
	c      |      -_|P¹
	h      |		+_	
	s      |		| -_
	e      |		|   -_
	       |		|     -_
	X      |		|       -_
	       |T_______|T¹_______-O (Auge)

			<---- Achse Z ---->

Der Punkt P ist in diesem Fall nach rechts vom Betrachter verschoben.

Segmente:

PT	= X-Koordinate von Punkt P im Raum (Xogg)
P¹T¹ = X-Koordinate des Punktes P¹ im Bild (INCOGNITA X¹)
OT	= Abstand Z des Punktes P vom Beobachter (DistZpunto)
OT¹	= Abstand Z des Betrachters vom Bild (DistZossSchermo)

Mal sehen, wie man die X-Koordinate des Punktes P¹ findet.
Auch diesmal müssen wir berechnen:

	P¹T¹=(PT*OT¹)/OT

Wir könnten "übersetzen" in:

	Xproiettato = (Xogg*DistZossSchermo)/DistZPunto

Und dann ungefähr in:

	move.w	Xogg,d0				; Koordinate X des Objekts
	muls.w	DistZossSchermo,d0	; DistZossSchermo*Xogg
	divs.w	DistZPunto,d0		; In d0 haben wir die X-Koordinate des Punktes P¹

Letztendlich müssen wir das "Gleiche" tun, um Y und X zu finden.

	move.w	Xogg,d0				; Koordinate X des Objekts
	move.w	Yogg,d1				; Koordinate Y des Objekts
	muls.w	DistZossSchermo,d0	; DistZossSchermo*Xogg
	muls.w	DistZossSchermo,d1	; DistZossSchermo*Yogg
	divs.w	DistZPunto,d0		; In d0 haben wir die X-Koordinate des Punktes P¹
	divs.w	DistZPunto,d1		; In d1 haben wir die Y-Koordinate des Punktes P¹

******************************************************************************
*		ENDGÜLTIGE PERSPEKTIVE PROJEKTIONSROUTINE							 *
******************************************************************************

Aber jetzt müssen wir darüber nachdenken, wie wir eine grobe Routine erstellen
können, die einen 3D Punkt XYZ projiziert, wobei wir X¹ und Y¹ am Ausgang
erhalten werden. Dazu müssen einige Überlegungen zu den bereits gemachten
hinzugefügt werden. Beginnen wir mit der Berechnung der X-Koordinate von P¹.
Wir sagten, dass das Verfahren das folgende ist:

	P¹T¹	    = (PT     * OT¹	   )/OT

	Xproiettato = (Xogg*DistZossSchermo)/DistZPunto

Es muss jedoch gesagt werden, dass, um den Abstand Z des Punktes P vom
Beobachter zu finden, dass wir uns mit OT (distZPunto) identifiziert haben,
hinzugefügt werden muss:

	DistZPunto = Zogg + DistZossSchermo	(OT=Zogg+OT¹)

Das heißt, wir müssen den Abstand des Oss (Auges) vom Bildschirm zur
Z-Koordinate von Punkt P addieren:

			P
	       |-_      |(Bild)
	       |  -_    |
	A      |    -_  |
	c      |      -_|P¹
	h      |		+_	
	s      |		| -_
	e      |		|   -_
	       |		|     -_
	X      |		|       -_
	       |T_______|T¹_______-O (Auge)			-
			316		256		   0

			<---- Achse Z ---->

In diesem Fall haben wir, dass sich das Bild an der Position Z = 256 befindet,
während P an der Z-Koordinate = 316 und das Auge bei 0 ist.
Wir haben also Zogg = 60 und DistZossScreen = 256. Der Abstand von O nach T
ist 316, erhalten durch Zogg+DistZossScreen.

Die endgültige Formel lautet daher:

	P¹T¹	    = (PT     * OT¹	   )/OT
	P¹T¹	    = (PT     * OT¹	   )/(Zogg+OT¹)

	Xproiettato = (Xogg*DistZossSchermo)/(Zogg+DistZossSchermo)

Nichts, über das man sich sorgen sollte. Unsere "Pseudo-Routine" wird:

	move.w	Xogg,d0
	move.w	DistZossSchermo,d1
	muls.w	d0,d1		; Xogg*DistZossSchermo
	move.w	DistZossSchermo,d2
	add.w	Zogg,d2		; Zogg+DistZossSchermo = DistZPunto
	divs.w	d2,d1		; (Xogg*DistZossSchermo)/DistZPunto
						; In d1 haben wir die X-Koordinate des Punktes P¹

Beachten Sie, dass wir Xogg und Zogg benötigen, um die X-Koordinaten einzugeben
und Z des Punktes P und DistZossSchermo, der die Entfernung des Beobachters vom
Bildschirm ist, der einen Wert haben muss, der der tatsächlichen Entfernung
des Betrachters des Monitors entspricht!
												  __________
	     ìììììììììì								 /			\
	    ììììììì    \							||			 \
	   ìììììì     <O  <--- DistZossSchermo  --->||			  \
	   ììì(			\							||			   |
	   ììì '		_|							||			   |
	    ìì			\							||			  /
	     |			<							||			 /
	     |	\		/							 \__________/
				---'

	     BEOBACHTER								MONITOR


Schließlich muss berücksichtigt werden, dass der Betrachter sein Auge zur
Bildschirmmitte ausgerichtet hat...
Und dass wir das Objekt zentrieren müssen! Also müssen wir (am Ende) die 
Koordinaten der Mitte des Bildschirms hinzufügen oder die Mitte wäre der
Punkt 0,0, das heißt die obere linke Ecke und unser Würfel würde nur für 
ein Viertel in dieser Ecke angezeigt werden:
			 ___
			/__/| 0,0
	       | x---------------
	       |_|_|/			 |
			 |				 |
			 |				 |
			 |				 |
			 |				 |
			 |				 |
			 |				 |
			  --------------- 320,256

Wenn Sie stattdessen am Ende der Berechnungen CentroX und CentroY hinzufügen,
verschieben wir den Würfel selbst in das Zentrum. Wenn sich der Bildschirm in
LowRes 320 * 256 befindet, ist die Mitte 160,128 (320/2, 256/2).

			0,0
			  ---------------
			 |				 |
			 |		 ___	 |
			 |		/__/|	 |
			 |     | x ||	 |	-> Das Zentrum ist 160,128
			 |     |___|/	 |
			 |				 |
			 |				 |
			  --------------- 320,256


Schauen wir uns also die ENDGÜLTIGE Formel an:

 P¹T¹	     = (PT     * OT¹	    )/OT
 Xproiettato = (Xogg*DistZossSchermo)/(Zogg+DistZossSchermo) / + CentroX

Hier ist die letzte Routine:

PROSPETTIVA:
	LEA	PuntiXYZtraslati(PC),A0  ; Adresse Tab. der X,Y,Z aus
								 ; Projektion (bereits bewegt)
	LEA	PuntiXYproiettati(PC),A1 ; Tabelle, wo die Koordinaten platziert werden
								 ; sollen X¹, Y¹ projiziert.
	MOVE.w	#LarghSchermo/2,D3	 ; X Mitte des Bildschirms (zur Mitte)
	MOVE.W 	#LunghSchermo/2,D4	 ; Y Mitte des Bildschirms (zur Mitte)

	MOVE.w	#NPuntiOggetto-1,D7 ; Anzahl der zu projizierenden Punkte
PERLOP:
	MOVEM.W	(a0)+,d0/d1/d2		; Koord. X in d0, Y in d1, Z in d2
	MULS.W	DistZoss,d0			; DistSchermoOss*Xogg
	MULS.W	DistZoss,d1			; DistSchermoOss*Yogg
	ADD.W	DistZoss,d2			; Zogg+DistZossSchermo in d2
	DIVS.w	D2,D0	   ; (DistZossSchermo*Xogg)/(Zogg+DistZossSchermo)
	DIVS.w	D2,D1	   ; (DistZossSchermo*Yogg)/(Zogg+DistZossSchermo)
	ADD.W	d3,D0	   ; + X Bildschirmmitte (zur Mitte)
	ADD.W 	d4,D1	   ; + Y Bildschirmmitte (zur Mitte)
	MOVEM.W	D0-D1,(A1) ; speichern der projizierten und bewegten X¹- und Y¹-Werte
	ADDQ.W	#2+2,A1	   ; zu den nächsten 2 Werten springen
	DBRA 	D7,PERLOP  ; Wiederholen Sie NumberPoints-Zeiten für alle Punkte.
	RTS				   ; bis alle gescreent sind

Wir können jedoch den Abstand zwischen dem Bildschirm und der Beobachtung
selbst entscheiden und festlegen. Bei 256 können wir auf diese Weise die
2 muls in "ASL.L #8" transformieren:

PROSPETTIVA:
	LEA	PuntiXYZtraslati(PC),A0	 ; Adresse Tab. der X,Y,Z aus
								 ; Projektion (bereits bewegt)
	LEA	PuntiXYproiettati(PC),A1 ; Tabelle, wo die Koordinaten platziert werden
								 ; sollen X¹, Y¹ projiziert.
	MOVE.w	#LarghSchermo/2,D3	 ; X Mitte des Bildschirms (zur Mitte)
	MOVE.W 	#LunghSchermo/2,D4	 ; Y Mitte des Bildschirms (zur Mitte)

	MOVE.w	#NPuntiOggetto-1,D7	; Anzahl der zu projizierenden Punkte
Proiez:
	MOVEM.W	(a0)+,d0-d2 ; Koord. X in d0, Y in d2, Z in d2
->	ASL.L	#8,d0	   ; (MULS #256) DistZossSchermo*Xogg
->	ASL.L	#8,d1	   ; (MULS #256) DistZossSchermo*Yogg
->	ADD.W	#256,d2	   ; Zogg+DistZossSchermo (finde dist. oss<->punto)
	DIVS.w	D2,D0	   ; (DistZossSchermo*Xogg)/(Zogg+DistZossSchermo)
	DIVS.w	D2,D1	   ; (DistZossSchermo*Yogg)/(Zogg+DistZossSchermo)
	ADD.W	d3,D0	   ; + X Bildschirmmitte (zur Mitte)
	ADD.W 	d4,D1	   ; + Y Bildschirmmitte (zur Mitte)
	MOVEM.W	D0-D1,(A1) ; speichern der projizierten und bewegten X¹- und Y¹-Werte
	ADDQ.W	#2+2,A1	   ; zu den nächsten 2 Werten springen
	DBRA 	D7,Proiez  ; Wiederholen Sie NumberPoints-Zeiten für alle Punkte.
	RTS				   ; bis alle gescreent sind

(Achtung durch Null: aber es ist nicht notwendig, wenn Sie vorsichtig sind ...)

->	ADD.W	#256,d2	   ; Zogg+DistZossSchermo (finde dist. oss<->Punkt)
	bne.s	NonZero
	moveq	#1,d2	   ; Vermeiden Sie die Division durch Null
NonZero:
	DIVS.w	D2,D0	   ; (DistZossSchermo*Xogg)/(Zogg+DistZossSchermo)

*****************************************************************************
				TRANSLATION

In der Praxis wird allen Punkten x, y, z ... der gleiche Wert addiert oder
subtrahiert.
*****************************************************************************

Hier veranschaulichen wir mit einer Art Pilz (oder Lutscher) die Wirkung der
einfachen Translation:

------------------------------------------------------------------------------

X¹=X+XF
				 _		 __		 ___	  __	   _
	- 	/\___	/ \__	/. \_	/ . \	_/ .\	__/ \	___/\	+
		\/		\_/		\__/	\___/	 \__/	  \_/	   \/

WENIGER	<		<		<		 NULL	  >		 >		  >		MEHR'

* Wir bewegen uns mehr nach rechts oder mehr nach links ... als ob wir es aus
  dem Fenster eines fahrenden Zuges gesehen hätten.

------------------------------------------------------------------------------

Y¹=Y+YF

			   -		WENIGER
			  ___
			 <___>		 /\
			   |
			  ___
			 /   \		 /\
			 \___/
			   |
			  ___
			 /   \
			 |   |		NULL
			 \___/

			  _|_
			 /   \
			 \___/		 \/

			   |
			  _|_
			 <___>		 \/

			   +		MEHR'

* Wir sehen das Objekt von einem höheren Ort oder von einem niedrigeren ... 
  als ob wir in einem Aufzug wären.

------------------------------------------------------------------------------

Z¹=Z+ZF
			  ___				
	  - 	 /   \ 			 ___		   				+
 			(     )			/   \		  .-.
			 \___/			\___/		  \_/	   <>	.

 WENIGER	<	<	<		 NULL		 >	  >	  >		MEHR'


* Das Objekt wächst oder schrumpft: es nähert sich oder bewegt sich weg

******************************************************************************
*				ROTATION				     *
******************************************************************************

Erklären Sie die Ebene ... zuerst 2D Drehung nur in Bezug auf eine Achse, dann
allmählich bis zur Routine schnell ok ..


a = in Radiant (Radiant=Grad/57.295779 - Bsp. 1 Grad = 1/57.xx=0,017453)

360° = 2*Pi

Um

Xnew = X*COS(a)-Y*SIN(a)

Z-Achse:

Ynew = X*SIN(a)-Y*COS(a)
Znew = Z

Um

Xnew = X

X-Achse:

Ynew = Y*COS(a)-Z*SIN(a)
Znew = Y*SIN(a)+Z*COS(a)

Um

Xnew = X*COS(a)+Z*SIN(a)

Y-Achse:

Ynew = Y
Znew = X*SIN(a)+Z*COS(a)

ODER ANDERS AUSGEDRÜCKT:

xr = Drehwinkel X
yr = Drehwinkel Y
zr = Drehwinkel Z

X¹ ist das neue X, das beim nächsten Mal verwendet werden soll. Es werden
2 Achsen gleichzeitig mit den Werten der vorherigen Berechnung berechnet.

Y¹=Y*COS(xr)-Z*SIN(xr)		;\ X
Z¹=Y*SIN(xr)+Z*COS(xr)		;/

X¹=X*COS(zr)-Y*SIN(zr)		;\ Z
Y¹=X*SIN(zr)+Y*COS(zr)		;/

X¹=X*COS(yr)-Z*SIN(yr)		;\ Y
Z¹=X*SIN(yr)+Z*COS(yr)		;/

Cos(a) = 	X1*X2+Y1*Y2+Z1*Z2
	-------------------------------------
	sqrt((x1^2+y1^2+z1^2)*(x2^2+y2^2+z2^2)


------------------------------------------------------------------------------

YY = Y*Cos(AX) + Z*Sin(AX)
 Z = Z*Cos(AX) - Y*Sin(AX)
 Y = YY

XX = X*Cos(AY) + Z*Sin(AY)
 Z = Z*Cos(AY) - X*Sin(AY)
 X = XX

XX = X*Cos(AZ) + Y*Sin(AZ)
 Y = Y*Cos(AZ) - X*Sin(AZ)
 X = XX

------------------------------------------------------------------------------

; ROTATION: Winkel r1,r2,r3
;			Koordinate x,y,z
; xa,ya,za  temporäre Variablen

xa=cos(r1)*x-sin(r1)*z
za=sin(r1)*x+cos(r1)*z
x=cos(r2)*xa+sin(r2)*y
ya=cos(r2)*y-sin(r2)*xa
z=cos(r3)*za-sin(r3)*ya
y=sin(r3)*za+cos(r3)*ya

----------------------------------------------------------------------------

ACHSE X:

		 	 					 ___	 ___	 ___	 ___
 +		 _|_	  |		 _L_	/   \	<_ _>	  |		<_i_>	-
		<_'_>	 _|_	<___> 	\___/	  T		  |		  |
 MEHR'														WENIGER

Es dreht sich selbst um eine Achse ________ X

Diese Bewegung kann der Rotation eines Ventilators oder eines Schiffspropellers
ähneln... eines Schiffes von der Seite gesehen.
	
------------------------------------------------------------------------------

ACHSE Y:


		  _				  __	 ___	 __ 		     _
 +		___\	___/\	_/  \	/   \	/  \_	/\___	/ __	-
		 \_/	   \/	 \__/	\___/	\__/	\/		\_/

 MEHR'		<	<	<			 NULL		 >	  >	  >			WENIGER


Es dreht sich selbst um eine Achse  | Y
									|
									|
									|

Diese Drehung erinnert an einen Hubschrauberpropeller!

------------------------------------------------------------------------------

ACHSE Z:

			___|_	 	_|_		_|___
	 +		   |	 X	 |	X	 |			-
					/ 	 |	 \	
	 MEHR'								WENIGER

Dreht sich selbst um die Z-Achse (Achse zeigt zu Ihnen!)

In der Praxis dreht sich das Objekt im Uhrzeigersinn, wenn die Drehung POSITIV
ist, wenn es NEGATIV ist dann gegen den Uhrzeigersinn.

------------------------------------------------------------------------------

(Panel machen:

 + X TRANSL -

 + Y TRANSL -

usw. mit der Maus...


******************************************************************************
*			HIDDEN LINES and FILLED				     *
******************************************************************************

(Aus dem Artikel Slave/Perspex in Grapevine #16.)

Filled vectors

Das Grundprinzip von Vektoren besteht darin, dass Objekte aus Punkten bestehen,
die durch Linien miteinander verbunden sind, um die "Flächen" zu bilden. Die 
Punkte können durch 3 Koordinaten in den 3 Achsen X, Y, Z identifiziert werden.
X ist der Links-Rechts-Versatz, Y ist das "Auf-Ab" und Z ist die Tiefe, das 
ist "vorwärts-rückwärts".


Hier ist eine Art Design eines Würfels, der, wie Sie wissen, 6 Flächen hat und
nicht weniger als 6 Kanten, das sind die Punkte, die uns interessieren.


			50,+50,+100______________+100,+100,+100
					 /|			   /|
					/ |			  / |
				   /  |			 /  |
				  /   |		    /   |
	- 50,+100,-50/____|________/+100,+100,-50
				|     |		   |    |
				|     |______ _|____|+100,-50,+100
				|    /-100,-100,+100/
				|   /		   |   /
				|  /		   |  /
				| /			   | /
				|/____________ |/+100,-100,-100
		   -100,-100,-100


Mit diesen Informationen können wir eine Datenstruktur eines Würfels aus 
Punkten und Flächen erstellen, um unser Objekt zu bilden:

CubeObject:	; Mega Simple Cube, 8 Punkte und 6 Flächen.

CubePts:
	dc.w	8-1		; 8 Punkte (Lassen Sie uns -1 setzen, weil wir einen
	; DBRA machen werden für die Schleife, die diesen Wert annimmt.
	; Wie Sie wissen, benötigt der DBRA num.loop-1
	dc.w	-100,+100,-100	; Hier sind die 8 Punkte, die durch die
	dc.w	+100,+100,-100	; Koordinaten X, Y, Z definiert sind.
	dc.w	+100,-100,-100
	dc.w	-100,-100,-100
	dc.w	-100,+100,+100
	dc.w	+100,+100,+100
	dc.w	+100,-100,+100
	dc.w	-100,-100,+100

; Hier ist jetzt die Information von jeder Fläche: Das erste Wort ist die
; Anzahl der Punkte-1 (für die Dbra), dann gibt es die Punkte, die diese Fläche
; ausmachen, das heißt, welche 4 der 8 Punkte des Würfels diese Fläche bilden.
; Beachten Sie, dass die Reihenfolge der Punkte "im Uhrzeigersinn" ist (dh das
; Zählen der Punkte dreht sich in Richtung der Zeiger der Uhr), wenn sich das
; Ziffernblatt vor dem Bildschirm befindet, während es gegen den Uhrzeigersinn
; geht, wenn die Fläche hinten ist, dann ist es "gedreht".
; Diese Reihenfolge ist hilfreich, um zu verstehen, wann ein Fläche sichtbar
; oder hinter anderen versteckt ist.

CubeFace1Pts:
	dc.w	4-1			; 4 Punkte
CubeFace1Cons:
	dc.w	0*4,1*4,2*4,3*4,0*4	; 0-> 1-> 2-> 3->0 (Fläche vorn)
; Die Punkte der Fläche (* 4, um das Zeigen von der Tabelle zu finden)
; nach rechts
; Versatz durch einfaches Hinzufügen
; wo die Punkte in der Tabelle beginnen.
CubFace1Col:
	dc.w	VCol01		; Farbe der Fläche ($RGB)

	dc.w	4-1
	dc.w	4*4,7*4,6*4,5*4,4*4		; 4->7->6->5->4	(Fläche hinten)
	dc.w	VCol02

	dc.w	4-1
	dc.w	0*4,3*4,7*4,4*4,0*4		; 0->3->7->4->0 (Fläche unten)
	dc.w	VCol03

	dc.w	4-1
	dc.w	1*4,5*4,6*4,2*4,1*4		; 1->5->6->2->1	(Fläche oben)
	dc.w	VCol04

	dc.w	4-1
	dc.w	0*4,4*4,5*4,1*4,0*4		; 0->4->5->1->0 (Fläche links)
	dc.w	VCol05

	dc.w	4-1
	dc.w	3*4,2*4,6*4,7*4,3*4		; 3->2->6->7->3 (Fläche rechts)
	dc.w	VCol06

CubeEnd:
	dc.w	0		; Die Liste endet mit Null

Die durch Linien zu verbindenden Punkte werden der Reihe nach aufgelistet. Der
Punkt mit dem wir beginnen setzen wir dann am Ende der Liste.
					
Linie1 = Punkt0->Punkt1
Linie2 = Punkt1->Punkt2
Linie3 = Punkt2->Punkt3
Linie4 = Punkt3->Punkt0


Hier ist der gruseligste Teil: die Berechnungen.


AX, AY + AZ = Drehwinkel für X,Y O Z

CX + CY = Werte des Zentrums für X + Y

CX = 160	; Größe für einen Bildschirm 320x200
CY = 100

YY = Y*Cos(AX) + Z*Sin(AX)
 Z = Z*Cos(AX) - Y*Sin(AX)
 Y = YY

XX = X*Cos(AY) + Z*Sin(AY)
 Z = Z*Cos(AY) - X*Sin(AY)
 X = XX

XX = X*Cos(AZ) + Y*Sin(AZ)
 Y = Y*Cos(AZ) - X*Sin(AZ)
 X = XX

 Z = 512/(512+Z)
 X = X*Z+CX
 Y = Y*Z+CY

Wir haben jetzt alles, was wir brauchen, um einen Drahtgitterwürfel
herzustellen.

; Das Objekt besteht aus Punkten, Verbindungen zwischen diesen Punkten und
; Flächen. Punkte sind ALLE Punkte im Objekt
; Verbindungen sind "welche Punkte verbunden werden müssen, um eine Fläche
; zu machen"
; Die Flächen sind die ersten 3 Punkte, die im Uhrzeigersinn sortiert sind
; Implementieren Sie mit Leichtigkeit die "versteckte Linie", dh die
; hidden lines.

; Bevor die Fläche gefüllt + kopiert wird, berechnet eine kleine Routine
; die Fläche (so klein wie möglich), dass der Blitter füllen, reinigen und
; kopieren kann. Dies erfolgt für die X- und Y-Achse.

; Eine vorberechnete perspektivische TAB kann verwendet werden, um durch
; Berechnung aller möglichen Kombinationen von Z (Z = 640 / (640 + Z)) zu
; beschleunigen. Auf diese Weise können Sie die langsamen DIVS entfernen
; und durch eine Routine ersetzen, die den richtigen Wert in der TAB findet,
; mit dem Klassiker:
;
;	lea	PROSPTAB,a0
;	add.l   d0,d0
;	move.w  (a0,d0.w),d0
;

; Die SINUS-Tabelle kann dank der bekannten Regel COS (n) = SIN (n-90 °)
; als COSINUS-Tabelle verwendet werden.

Hier ist die Liste der Dinge, die zu tun sind:

1) Suchen Sie das Objekt.
2) Nehmen Sie die Anzahl der Punkte aus der Objektstruktur.
3) Drehen Sie alle Punkte des Objekts in einem speziell erstellten Puffer.
4) Zeigen Sie auf den Datenblock der ersten Fläche.
5) Lesen Sie die Anzahl der Flächen (Wenn = 0, dann das Ende des Objekts).
6) Lesen Sie die Punkte paarweise und senden Sie sie an die 
   Linienzeichnungsroutine.
7) Die Routine zum Zeichnen der Linie zeichnet in einen separaten Puffer.
8) Berechnen Sie die Fläche X Y (so klein wie möglich) für die FÜLLUNG.
9) Füllen Sie die Fläche (mit der Blitterfüllung) in den Puffer.
10) Kopieren Sie die Fläche aus dem Puffer auf den Bildschirm (3 Bitebenen).
Mit:
					
; a0 = Quelle
; a4 = Ziel

	move.l	A3,Bltapth(A6)	; a
	move.l	A4,Bltbpth(A6)	; b
	move.l	A4,Bltdpth(A6)	; d
	btst.l	#0,D7			; testen, ob wir diese Plane brauchen
	beq.s	PlaneVuoto
PlaneFull:
	move.l	#$0DFC0000,BltCon0(A6)	; Minterms für ODER
	bra.s	BlitPlane
PlaneVuoto:
	move.l	#$0D0C0000,BltCon0(A6)	; Minterms für Maske
BlitPlane:
	move.w	D4,Bltsize(A6)			; Dimension

Für eine volle oder leere plane. Dies muss für alle 3 Bitpanes erfolgen. Wir
müssen den Puffer der Fläche mit dem kleinsten X + Y reinigen (wir haben ihn
bereits berechnet). Wiederholen Sie den Vorgang für alle Flächen des Objekts.
Berechnen Sie das kleinste X + Y-Rechteck für den Bildschirm und reinigen Sie
den Bildschirm vor der nächsten Schleife.

PS: Vergessen wir nicht, den Doppelpuffer (double buffer) zu verwenden.
Der doppelte Puffer wird benötigt, da Sie beim Anzeigen eines Frames das neue
an einer anderen Stelle reinigen und schreiben können und es sich am Ende
des frames ansehen. Andernfalls wird der Zeitpunkt der Löschung des Designs
des Festkörpers angezeigt, aufgrund der Langsamkeit dieser Operationen, in
Beziehung zur Videoaktualisierung. (In der Praxis scheint es auf einem
beschissenen PC-MSDOS gemacht zu sein.)

Der Code wird so zusammengestellt, dass ein Lev6 mit einem Double ausgeführt
wird. Der Pufferwechsel wird durch ein Flag aktiviert. Sie haben einen Zähler,
der die Anzahl von Frames zählt, bis der Doppelpuffer zuletzt aktiviert wurde.
Und Sie aktualisieren die Drehung der Winkel in jedem frame.
					

Ruota:
	move.l	FaceBuffer(PC),A0
	lea	STab+$80*2(PC),A5		; Adresse SinTab
	lea	STab+$80(PC),A6			; Adresse CosTab
	move.l	Object(PC),A1		; Adresse Struktur Objekt
	lea	XYPoints(PC),A2			; Wo werden die berechneten Punkte abgelegt?
;	lea	Perspective(PC),A3		; Tab mit vorberechneter Perspektive
	moveq	#0,D5
	move.w	(A1)+,D5			; N. von Punkten

; Lib. = A4

PointLoop:
	move.w	(A1)+,D0			; D0 = X
	move.w	(A1)+,D1			; D1 = Y
	move.w	(A1)+,D2			; D2 = Z

	move.w	AngleY(PC),D7
	move.w	(A5,D7.W),D6		; D6 = Sin(AX)
	move.w	(A6,D7.W),D7		; D7 = Cos(AX)

	; D0 = X
	; D1 = Y
	; D2 = Z
	; D6 = Sin(AY)
	; D7 = Cos(AY)

; YY = Y*Cos(AY) + Z*Sin(AY)
;  Z = Z*Cos(AY) - Y*Sin(AY)
;  Y = YY

	move.w	D1,D3				; D3 = Y
	move.w	D2,D4				; D4 = Z

	Muls.W	D6,D4				; D4 = Z*Sin(AY)
	Muls.W	D7,D2				; D2 = Z*Cos(AY)
	Muls.W	D6,D1				; D1 = Y*Sin(AY)
	Muls.W	D7,D3				; D3 = Y*Cos(AY)

	ADD.L	D4,D3				; D3 = Y*Cos(AY) + Z*Sin(AY)
	Sub.L	D1,D2				; D2 = Z*Cos(AY) - Y*Sin(AY)

	ADD.L	D3,D3
	ADD.L	D2,D2
	SWAP	D3					; D3 = Y
	SWAP	D2					; D2 = Z

	MOVE.W	AngleX(PC),D7
	MOVE.W	(A5,D7.W),D6		; D6 = Sin(AX)
	MOVE.W	(A6,D7.W),D7		; D7 = Cos(AX)

	; D0 = X
	; D2 = Z
	; D3 = Y
	; D6 = Sin(AY)
	; D7 = Cos(AY)

; XX = X*Cos(AX) + Z*Sin(AX)
;  Z = Z*Cos(AX) - X*Sin(AX)
;  X = XX

	move.w	D0,D1				; D1 = X
	move.w	D2,D4				; D4 = Z

	Muls.W  D6,D4				; D4 = Z*Sin(AX)
	Muls.W  D7,D2				; D2 = Z*Cos(AX)
	Muls.W  D6,D0				; D0 = X*Sin(AX)
	Muls.W  D7,D1				; D1 = X*Cos(AX)

	ADD.L	D4,D1				; D1 = X*Cos(AX) + Z*Sin(AX)
	Sub.L	D0,D2				; D2 = Z*Cos(AX) - X*Sin(AX)

	ADD.L	D1,D1           
	ADD.L	D2,D2           
	SWAP	D1					; D1 = X
	SWAP	D2					; D2 = Z

	MOVE.W	AngleZ(PC),D7
	MOVE.W	(A5,D7.W),D6		; D6 = Sin(AZ)
	MOVE.W	(A6,D7.W),D7		; D7 = Cos(AZ)

	; D1 = X
	; D2 = Z
	; D3 = Y
	; D6 = Sin(AZ)
	; D7 = Cos(AZ)

; XX = X*Cos(AZ) + Y*Sin(AZ)
;  Y = Y*Cos(AZ) - X*Sin(AZ)
;  X = XX

	MOVE.W	D1,D0				; D0 = X
	MOVE.W	D3,D4				; D4 = Y

	Muls.W	D6,D4				; D4 = Y*Sin(AZ)
	Muls.W	D7,D3				; D3 = Y*Cos(AZ)
	Muls.W	D6,D1				; D1 = X*Sin(AZ)
	Muls.W	D7,D0				; D0 = X*Cos(AZ)

	ADD.L	D4,D0				; D0 = X*Cos(AZ) + Y*Sin(AZ)
	Sub.L	D1,D3				; D3 = Y*Cos(AZ) - X*Sin(AZ)

	ADD.L	D0,D0
	ADD.L	D3,D3
	SWAP	D0					; D0 = X
	SWAP	D3					; D3 = Y

	; D0 = X
	; D2 = Z
	; D3 = Y

;  Z = 512/(512+Z)
;  X = X*Z+CX
;  Y = Y*Z+CY                           

	ADD.W	Zoom,D2
	MoveQ	#8,D7
	Ext.L	D0
	Ext.L	D3
	Asl.L	D7,D0
	Asl.L	D7,D3
	Tst.W	D2
	Bpl.S	ZNotZero
	MoveQ	#1,D2
ZNotZero:
	Divs.W	D2,D0
	Divs.W	D2,D3

;	ADD.W	Zoom(PC),D2	; D2 = Z+Zoom
;	ADD.L	D2,D2
;	MOVE.W	(A3,D2.W),D2		; D2 = Z Wert der Perspektive

;	Muls.W	D2,D0				; D0 = X*Z
;	Muls.W	D2,D3				; D3 = Y*Z

;	ADD.L	D0,D0
;	ADD.L	D3,D3
;	SWAP	D0
;	SWAP	D3

	ADD.W	#ScreenX/2,D0		; D0 = X*Z+CX
	ADD.W	#ScreenY/2,D3		; D3 = Y*Z+CY

	; D0 = X
	; D3 = Y

	Move.W	D2,MaxPts*2(A2)		; Salva Z
	Move.W	D0,(A2)+			; Salva X
	Move.W	D3,(A2)+			; Salva Y

	DBRA	D5,PointLoop		; alle Punkte berechnen

Um zu wissen, welche Fläche verborgen ist und damit welche nicht zu zeichnen
ist, müssen Sie die ersten 3 gedrehten Punkte (x + y) der Fläche nehmen und 
die Berechnung durchführen:

Se:

	((Bx-Ax)*(Cy-By))-((Cx-Bx)*(By-Ay))

Es ist dann gut, die Fläche nicht zu zeichnen!


; Hier ist der SINTAB, der zweimal wiederholt wird, um ihn als COSTAB verwenden
; zu können.

SineTableOfWordsX2:

	dc.w	1,$324,$648,$96A,$C8C,$FAB,$12C8,$15E2,$18F9
	dc.w	$1C0B,$1F1A,$2223,$2528,$2826,$2B1F,$2E11,$30FB
	dc.w	$33DF,$36BA,$398C,$3C56,$3F17,$41CE,$447A,$471C
	dc.w	$49B4,$4C3F,$4EBF,$5133,$539B,$55F5,$5842,$5A82
	dc.w	$5CB3,$5ED7,$60EB,$62F1,$64E8,$66CF,$68A6,$6A6D
	dc.w	$6C23,$6DC9,$6F5E,$70E2,$7254,$73B5,$7504,$7641
	dc.w	$776B,$7884,$7989,$7A7C,$7B5C,$7C29,$7CE3,$7D89
	dc.w	$7E1D,$7E9C,$7F09,$7F61,$7FA6,$7FD8,$7FF5,$7FFF
	dc.w	$7FF5,$7FD8,$7FA6,$7F61,$7F09,$7E9C,$7E1D,$7D89
	dc.w	$7CE3,$7C29,$7B5C,$7A7C,$7989,$7884,$776B,$7641
	dc.w	$7504,$73B5,$7254,$70E2,$6F5E,$6DC9,$6C23,$6A6D
	dc.w	$68A6,$66CF,$64E8,$62F1,$60EB,$5ED7,$5CB3,$5A82
	dc.w	$5842,$55F5,$539B,$5133,$4EBF,$4C3F,$49B4,$471C
	dc.w	$447A,$41CE,$3F17,$3C56,$398C,$36BA,$33DF,$30FB
	dc.w	$2E11,$2B1F,$2826,$2528,$2223,$1F1A,$1C0B,$18F9
	dc.w	$15E2,$12C8,$FAB,$C8C,$96A,$648,$324,1,$FCDC
	dc.w	$F9B8,$F696,$F374,$F055,$ED38,$EA1E,$E707,$E3F5
	dc.w	$E0E6,$DDDD,$DAD8,$D7DA,$D4E1,$D1EF,$CF05,$CC21
	dc.w	$C946,$C674,$C3AA,$C0E9,$BE32,$BB86,$B8E4,$B64C
	dc.w	$B3C1,$B141,$AECD,$AC65,$AA0B,$A7BE,$A57E,$A34D
	dc.w	$A129,$9F15,$9D0F,$9B18,$9931,$975A,$9593,$93DD
	dc.w	$9237,$90A2,$8F1E,$8DAC,$8C4B,$8AFC,$89BF,$8895
	dc.w	$877C,$8677,$8584,$84A4,$83D7,$831D,$8277,$81E3
	dc.w	$8164,$80F7,$809F,$805A,$8028,$800B,$8001,$800B
	dc.w	$8028,$805A,$809F,$80F7,$8164,$81E3,$8277,$831D
	dc.w	$83D7,$84A4,$8584,$8677,$877C,$8895,$89BF,$8AFC
	dc.w	$8C4B,$8DAC,$8F1E,$90A2,$9237,$93DD,$9593,$975A
	dc.w	$9931,$9B18,$9D0F,$9F15,$A129,$A34D,$A57E,$A7BE
	dc.w	$AA0B,$AC65,$AECD,$B141,$B3C1,$B64C,$B8E4,$BB86
	dc.w	$BE32,$C0E9,$C3AA,$C674,$C946,$CC21,$CF05,$D1EF
	dc.w	$D4E1,$D7DA,$DAD8,$DDDD,$E0E6,$E3F5,$E707,$EA1E
	dc.w	$ED38,$F055,$F374,$F696,$F9B8,$FCDC,2,$66E8,0
	dc.w	$240,0,0,0,0,1,$324,$648,$96A,$C8C,$FAB,$12C8
	dc.w	$15E2,$18F9,$1C0B,$1F1A,$2223,$2528,$2826,$2B1F
	dc.w	$2E11,$30FB,$33DF,$36BA,$398C,$3C56,$3F17,$41CE
	dc.w	$447A,$471C,$49B4,$4C3F,$4EBF,$5133,$539B,$55F5
	dc.w	$5842,$5A82,$5CB3,$5ED7,$60EB,$62F1,$64E8,$66CF
	dc.w	$68A6,$6A6D,$6C23,$6DC9,$6F5E,$70E2,$7254,$73B5
	dc.w	$7504,$7641,$776B,$7884,$7989,$7A7C,$7B5C,$7C29
	dc.w	$7CE3,$7D89,$7E1D,$7E9C,$7F09,$7F61,$7FA6,$7FD8
	dc.w	$7FF5,$7FFF,$7FF5,$7FD8,$7FA6,$7F61,$7F09,$7E9C
	dc.w	$7E1D,$7D89,$7CE3,$7C29,$7B5C,$7A7C,$7989,$7884
	dc.w	$776B,$7641,$7504,$73B5,$7254,$70E2,$6F5E,$6DC9
	dc.w	$6C23,$6A6D,$68A6,$66CF,$64E8,$62F1,$60EB,$5ED7
	dc.w	$5CB3,$5A82,$5842,$55F5,$539B,$5133,$4EBF,$4C3F
	dc.w	$49B4,$471C,$447A,$41CE,$3F17,$3C56,$398C,$36BA
	dc.w	$33DF,$30FB,$2E11,$2B1F,$2826,$2528,$2223,$1F1A
	dc.w	$1C0B,$18F9,$15E2,$12C8,$FAB,$C8C,$96A,$648,$324
	dc.w	1,$FCDC,$F9B8,$F696,$F374,$F055,$ED38,$EA1E,$E707
	dc.w	$E3F5,$E0E6,$DDDD,$DAD8,$D7DA,$D4E1,$D1EF,$CF05
	dc.w	$CC21,$C946,$C674,$C3AA,$C0E9,$BE32,$BB86,$B8E4
	dc.w	$B64C,$B3C1,$B141,$AECD,$AC65,$AA0B,$A7BE,$A57E
	dc.w	$A34D,$A129,$9F15,$9D0F,$9B18,$9931,$975A,$9593
	dc.w	$93DD,$9237,$90A2,$8F1E,$8DAC,$8C4B,$8AFC,$89BF
	dc.w	$8895,$877C,$8677,$8584,$84A4,$83D7,$831D,$8277
	dc.w	$81E3,$8164,$80F7,$809F,$805A,$8028,$800B,$8001
	dc.w	$800B,$8028,$805A,$809F,$80F7,$8164,$81E3,$8277
	dc.w	$831D,$83D7,$84A4,$8584,$8677,$877C,$8895,$89BF
	dc.w	$8AFC,$8C4B,$8DAC,$8F1E,$90A2,$9237,$93DD,$9593
	dc.w	$975A,$9931,$9B18,$9D0F,$9F15,$A129,$A34D,$A57E
	dc.w	$A7BE,$AA0B,$AC65,$AECD,$B141,$B3C1,$B64C,$B8E4
	dc.w	$BB86,$BE32,$C0E9,$C3AA,$C674,$C946,$CC21,$CF05
	dc.w	$D1EF,$D4E1,$D7DA,$DAD8,$DDDD,$E0E6,$E3F5,$E707
	dc.w	$EA1E,$ED38,$F055,$F374,$F696,$F9B8,$FCDC,2,$66E8
	dc.w	0,$240,0,0,0,0

Eine Einführung von Asterix of Movement
==========================================

Geschrieben von Carl-Henrik Skårstedt während seines Urlaubs.

     _              _
     /|            |\
/|\ /                \
 | /                  \
 |/_______\
	  /


1. Vorwort
=============

Um diesen Text zu verstehen, wäre es gut, die lineare Algebra zu kennen.
Grundsätzlich, weil Sie durch das Lesen dieses Textes auch in der Lage sein
sollten zu verstehen, was sie tun und nicht nur gegebene Formeln in 680x0 Code
konvertieren. Wenn Sie die Theorie hinter Ihrer Routine kennen, wissen Sie auch,
wie sie optimieren oder modifizieren können!

Dieser Text ist nicht nur zum Programmieren von 3D-Grafiken auf dem Amiga
nützlich, sondern für alle Computer, die eine gute grafische Oberfläche
unterstützen, schnell genug zum Erstellen von konkaven Objekten in einem Frame
(nicht auf dem PC).

sqr() bedeutet in diesem Text SQUARE ROOT.

Die Bedeutung dieses Textes ist, dass er ein Teil von Code.txt sein wird
und die gleichen Regeln funktionieren hierfür und auch dafür.
Die Rechte an diesem Teil verbleiben beim Autor.
Quellcodes sollten mit den meisten Assemblern funktionieren außer bei
Eingabe, für die ein 68020-Assembler erforderlich ist.

*******************************************************************************

2. Einführung in Vektoren
=========================

Was ist ein Vektor?
-------------------
Wenn Sie Demos gesehen haben, werden diese sich drehenden Würfel als Vektoren
bezeichnet. Es können auch Kugeln, gefüllte Polygone, Linien oder andere Dinge
sein. Gemeinsam ist in diesen Demos die Positionsvektorberechnung von Objekten.
Es kann ein-, zwei- oder dreidimensional sein.

Nehmen wir zum Beispiel einen Würfel. Jede Ecke des Würfels repräsentiert einen
Vektor im Rotationszentrum.
Alle Vektoren gehen von irgendwo zu einem anderen, normalerweise benutzen wir
Vektoren im Bereich von einem Punkt (0,0) bis zu einem Punkt (a, b).
Dieser Vektor hat als Größe (a, b).

Vektordefinition:
Eine Menge an Wert und Richtung

oder, in flotten Begriffen: eine Linie.
Eine Linie hat eine Länge, die wir r nennen können, und eine Richtung, die
wir können t nennen.
Wir können diesen für diesen Vektor (r, t) = (Länge, Winkel) schreiben.
Es gibt aber auch einen anderen Weg, der eher für Vektorobjekte mit Koordinaten 
angegeben verwendet wird.

Die Linie von (0,0) nach (x, y) hat die Länge sqr (x * x + y * y), und dies ist
der Wert des Vektors. Die Richtung kann als Winkel zwischen der x-Achse und der
beschriebenen Linie vom Vektor gesehen werden.

Wenn wir dies in zwei Dimensionen untersuchen, können wir einen Beispielvektor
haben wie folgt:

		 ^ y
		 |     _.(a,b)
		 |     /|
		 |    /
		 |   /
		 |  /  V
		 | /
		 |/\ - t= Winkel zwischen x-Achse und Vektor V.
	  ---+------------>
		(0,0)          x


Wir können diesen Vektor V nennen, und wie wir sehen können, geht er von
Punkt (0,0) bis (a, b). Wir können diesen Vektor als V = (a, b) bezeichnen.
Wir haben jetzt sowohl einen Wert von V (Die Länge zwischen (0,0) und (a, b))
als auch dessen Richtung (der Winkel im Diagramm)

Wenn wir uns das Diagramm ansehen, können wir sehen, dass die Länge des Vektors
mit dem Satz von Pythagoras berechnet werden kann:

	r=sqr(a*a+b*b)

der Winkel (kann mit t = tan (y / x) berechnet werden)


Drei Dimensionen?
-----------------
Wenn wir nun gesehen haben, was ein Vektor in zwei Dimensionen ist, was ist ein
Vektor in drei Dimensionen?

In drei Dimensionen hat jeder Punkt drei Koordinaten, daher muss auch der
Vektor drei Koordinaten haben.

	V=(a,b,c)

Nun wird die Länge des Vektors:

	r=sqr(a*a+b*b+c*c)

Was ist jetzt an der Ecke?

Hier können wir verschiedene Definitionen haben, aber lassen Sie uns einen Moment
darüber nachdenken. Wenn wir mit einem AN-Winkel beginnen, können wir nur einen
Punkt auf einem PLAN erreichen, aber wir wollen eine Richtung im Raum einschlagen.

Wenn wir es mit ZWEI Winkeln versuchen, haben wir ein besseres Ergebnis.
Ein Winkel kann den Winkel zwischen der Z-Achse und dem Vektor darstellen, der
andere die Drehung um die Z-Achse.

Für andere Probleme auf diesem Gebiet (es gibt viele) studieren Sie die
Berechnung mit vielen Variablen und insbesondere polare Transformationen in
Dreifachintegrale oder zumindest Oberflächenintegrale in Vektorfeldern.

*******************************************************************************

2.1 Vektoroperationen:
======================

(Wenn Sie zwei oder eine Dimension haben, haben Sie zwei oder eine Variable
 anstelle von drei. Wenn Sie mehr haben, haben Sie natürlich so viele Variablen
 wie die Größe)

* Die Summe zweier Vektoren (U = V + W) ist definiert als:

	V=(vx,vy,vz), W=(wx,wy,wz)=>

	=> U=(vx+wx,vy+wy,vz+wz)

* Die Negation eines Vektors U = -V ist definiert als:

	V=(x,y,z) => U=(-x,-y,-z)

* Die Differenz zwischen zwei Vektoren U = V-W ist definiert als:

	U=V+(-W)

* Ein Vektor zwischen zwei Punkten (von P1 (x1, y1, z1) bis P2 (x2, y2, z2))
  kann verarbeitet werden:

	V=(x2-x1,y2-y1,z2-z1,...)

	(V geht von P1 nach P2)

* Ein Vektor kann mit einer Konstanten multipliziert werden:

	U=k*V

	(x*k,y*k,z*k)=k*(x,y,z)

* Ein Koordinatensystem kann an einen neuen Punkt "bewegt" werden mit der
  Translationsformel:

	x'=x-k
	y'=y-l
	z'=z-m

  Wobei (k, l, m) der ALTE Punkt ist, an dem das NEUE Koordinatensystem 
  seinen Punkt (0,0,0) sein sollte.
  Dies ist eine gute Operation, wenn Sie um einen NEUEN PUNKT drehen möchten!

* Ein Vektor kann gedreht werden (siehe Kapitel 4).
  Der Vektor wird immer um den Punkt (0,0,0) gedreht, damit Sie ihn bewegen
  können.

* Wir können ein Punktprodukt und ein Kreuzprodukt auf Vektoren herstellen
  (siehe jedes Buch über die Einführung der linearen Algebra)

*******************************************************************************

3.PROGRAMMIERTECHNIKEN
======================

******************************************************************************

Eine Möglichkeit, reelle Zahlen mit ganzen Zahlen zu verwenden
--------------------------------------------------------------

Bisher haben wir nur einige Formeln gesehen, aber wie können wir sie in
Assembler verwenden, wo wir nur Byte / Wort / Langwort haben?
(Wenn Sie keine FPU haben und nicht möchten, dass nur Personen mit FPUs
Ihre Demo sehen können, dann natürlich!)

Für die 68000-Programmierung (kompatibel mit allen 680x0-Prozessoren) ist dies
der Fall. Praktisch, um Multiplikationen, Divisionen usw. mit Worten
durchführen zu können.
(68020+ Prozessoren können dies auch mit Langwörtern tun)

Wir brauchen aber auch die gebrochenen Teile von Zahlen, das heißt die Zahlen
"nach dem Komma", aber wie machen wir das, wenn es kein Komma gibt? Wir können
versuchen, Zahlen zu verwenden, die mit einer Konstanten p multipliziert
werden. Dann können wir Folgendes tun:

 [cos(a)*p] * 75 (zum Beispiel aus einer Liste mit cos (x) multipliziert mit p)

Aber wie Sie sehen, wächst diese Zahl jedes Mal, wenn wir eine neue
Multiplikation machen, so dass wir es wieder durch p teilen müssen:

  [cos(a)*p] * 75 / p

Wenn Sie ein Codierungsexperte sind, werden Sie sicherlich sagen: "Oh nein!
keine Division, das verliert zu viel Zeit!"
Wenn Sie jedoch p sorgfältig auswählen (d.h. p = 2 oder 4 oder 8 ...), können
Sie SHIFT verwenden statt einer Teilung! Schauen Sie sich dieses Beispiel an:

	mulu.w	10(a0),d0	; 10(a0) stammt aus einer Liste von cos * 256-Werten
	asr.l	#8,d0		; und wir "teilen" durch 256!

Jetzt haben wir eine Festpunktzahl multipliziert!
(Ein Trick, um eine geringere Fehlerquote zu erzielen:
Bereinigen Sie ein Dx-Datenregister und verwenden Sie nach dem ASR ein Addx
Fehler "gerundet", (Abrundung):
 
	moveq	#0,d7		; Register d7 zurücksetzen
	:
	:
	mulu.w	10(a0),d0	; Wert aus der Tabelle nehmen (cos*256)
	asr.l	#8,d0		; wir "teilen" durch 256
	addx.l	d7,d0		; wir runden nur mit dem eXtend-Flag (d7=0)
	:
	rts

 Dies halbiert den Fehler!

Das gleiche System wird für die Division verwendet, jedoch auf andere Weise:

	:
	ext.l	d0
	ext.l	d1
	asl.l	#8,d0		; "Multiplikation" mit 256
	divs.w	d1,d0		; und Division mit z*256 ...
	:
	rts

Additionen und Subtraktionen sind die gleichen wie bei normalen Operationen an
Ganzzahlen: (kein Shift erforderlich)

	:
	add.w	10(a0),d0
	:

	:
	sub.w	16(a1),d1
	:


Also zuerst mit MUL-Multiplikationen, dann mit LSR.
Zuerst mit den LSL-Divisionen, dann mit DIV.

Wenn Sie mit Multiplikationen eine höhere Genauigkeit erzielen möchten, bieten
die Prozessoren 68020 und höher eine kostengünstige Möglichkeit, Punktoperationen
(32-Bit insgesamt) durchzuführen.
Sie können auch Ganzzahlen 32 * 32-> 32 multiplizieren und Cosinus und Sinus mit
16-Bit verwenden, da Sie 'SWAP' anstelle von 'LSR' verwenden können.

*******************************************************************************

Wie kann ich Sin und Cos in meinem Assembler-Code verwenden?
------------------------------------------------------------
Der einfachste und schnellste Weg ist das Einfügen einer Sinusliste
häufig SINUS TAB genannt, im Listing.
Erstellen Sie ein Programm, das von 0 bis 2 * pi zählt, beispielsweise 1024
Mal. Speichern Sie die Werte und fügen Sie sie in Ihren Code ein.

Wenn Sie WORTE und 1024 verschiedene Sinuswerte haben, können Sie Sinus und 
COSINUS wie folgt nehmen:

	lea	sinuslist(pc),a0	; Liste (Tabelle) der bereits berechneten Sinuswerte
	and.w	#$7fe,d0		; d0 ist der Winkel (ungerade Zahl ausschließen)
	move.w	(a0,d0.w),d1    ; d1=sin(d0)
	add.w	#(1024/4)*2,d0	; 90° hinzufügen (1/4 Drehwinkel)
							; den Sinus finden. * 2 weil es 
							; Wörter sind in der Tabelle zu erreichen.
	and.w	#$7fe,d0
	move.w	(a0,d0.w),d0	; d0=cos (original d0)
	:
	:

Um die Tabelle zu erstellen, können Sie den praktischen Befehl "IS" oder "CS"
von ASMONE verwenden. oder Sie können mit mathematischen Bibliotheken oder mit
anderen Sprachen rechnen:

pi=3.141592654
vals=1024

mit einem Zyklus, der L immer von 0 auf 1024 erhöht:

Winkel = L/vals*2*pi

Sie können natürlich ein Programm erstellen, der den SINUS im Assembler-Code
berechnet. Verwenden Sie die IEEE-Bibliotheken oder programmieren Sie Ihre
eigene Gleitkomma-Routine. Der Algorithmus ist .. (für Sinus)

 Indata: v = Winkel (im Bogenmaß angegeben)
 Runden = Anzahl der Begriffe (minus = schneller, aber mehr Fehler, Ganzzahl)

   1> Mlop=1						1> Mlop = 1
      DFac=1						   DFac = 1	
      Ang2=angolo*angolo			   Ang2 = Winkel * Winkel
      Talj=angolo					   Talj = Winkel	
      segno=1						   Vorzeichen = 1
      Result=0						   Ergebnis = 0
   2> FOR terms=1 TO Laps			2> FOR-Begriffe = 1 TO Runden
   2.1> Temp=Talj/Dfac				2.1> Temp = Talj / Dfac
   2.2> Result=segno*(Result+Temp)	2.2> Ergebnis=Vorzeichen*(Ergebnis+Temp)	
   2.3> Talj=Talj*Ang2				2.3> Talj = Talj * Ang2
   2.4> Mlop=Mlop+1					2.4> Mlop = Mlop + 1
   2.5> Dfac=Dfac*Mlop				2,5> Dfac = Dfac * Mlop
   2.6> segno=-segno				2.6> Vorzeichen = -Vorzeichen
   3> RETURN sin()=Result			 3> RETURN sin () = Ergebnis

wobei sin () zwischen -1 und 1 liegt ...
Der Algorithmus verwendet MacLaurin-Polynome und wird daher nur für Werte
empfohlen, die nicht sehr weit von 0 entfernt sind.

4. Die Rotation von Vektoren
============================

* In zwei Dimensionen

Jetzt wissen wir, was ein Vektor ist und wir wollen ihn drehen.
Dies ist sehr einfach, wenn wir einen gegebenen Vektor mit Länge und Winkel
haben, addieren wir einfach den Drehwinkel zum Winkel und lassen die Länge wie
sie ist:

	drehe V=(r,t) mit -> V'=(r,t+a)

Aber normalerweise haben wir diesen einfachen Fall nicht, wir haben einen Vektor
durch zwei Koordinaten gegeben:

	V=(x,y) wobei x und y Koordinaten in der xy-Ebene sind

In diesem Text kennzeichnen wir die Drehung eines Vektors V = (r, t) mit
rot (V, a). Damit meine ich die Drehung des Vektors V mit dem Winkel a.

Die Drehung dieses Vektors ist möglich, indem V in einen Vektor 
in Länge und Richtung umgewandelt wird, aber da dies Quadrate, Tangenten,
Quadratwurzeln usw. wäre es besser, eine schnellere Methode zu verwenden.
Hier kommt die Trigonometrie ins Spiel.

Stellen wir uns zunächst vor, wir hätten einen Vektor V = (x, 0)
Was könnte die Rotation dieses Vektors sein?

       V
  ----------->

Jetzt drehen wir es mit einem Winkel a:

      _
/|\y' /|
 |   /
 |V'/
 | /
 |/\a x'
  ----->

  Was sind die neuen Komponenten des Vektors? (x',y') ?

	Denken Sie an diese "Definitionen":

Kosinus:
	cos(a)=Ankathete/Hypothenuse

Sinus:
	sin(a)=Gegenkathete/Hypothenuse

			 ,
			/|
	     Länge>/ |< Länge * sin(a)
		      /a |
		     '---+
		 Länge * cos(a)


Wenn wir dies in die ursprüngliche Rotationsformel setzen
(V'= rot (V,a) = V (r,t+a))  können wir sehen, dass wir
r und t in x und y konvertieren können:

	x=r*cos(t)
	y=r*sin(t)

Kehren wir zum Problem der gedrehten Vektoren zurück V=(x,0).
Hier ist r = x(=sqrt(x*x+0*0)), t=0 (=arctan(0/x)
Wenn wir dies in unsere Formel aufnehmen, haben wir:

	V=(r,t) mit r=x, t=0

Wenn wir diesen Vektor mit dem Winkel a drehen, dann haben wir:

	V=(r,t+a)

Und wenn wir zurück zu unserer angegebenen Koordinate übersetzen:

	V=(r*cos(t+a),r*sin(t+a))=(x*cos(a),x*sin(a))
				 ^Wir fügen für x=r, t=0 ein

Und dies ist die Formel für die Drehung eines Vektors ohne Y-Komponente.

Für einen Vektor V = (0, y) haben wir:


	r=y, t=pi/2 (=90 Grad) denn jetzt sind wir in der y-Achse, die 90
		Grad von der X-Achse ist.


	V=(r,t) => V'=(r,t+a) => V'=(r*cos(t+a),r*sin(t+a)) =>
	V'=(y*cos(pi/2+a),y*sin(pi/2+a))

Nun gibt es einige trigonometrische Formeln, die Folgendes besagen:

 cos(pi/2+a)=sin(a) und sin(pi/2+a)=-cos(a)

Also haben wir:

	V'=( y * sin(a) , y * ( -cos(a) ) )


Wenn wir uns aber den allgemeinen Fall ansehen, haben wir einen Vektor V, der
beide x- und y-Komponenten hat.
Jetzt können wir die Einzelfall-Rotationsformeln verwenden, um den 
allgemeiner Fall mit einem Zusatz zu berechnen:


  Vx'=rot((x,0),a) = (x*cos(a)         ,x*sin(a))
+ Vy'=rot((0,y),a) = (        +y*sin(a),        -y*cos(a))
----------------------------------------------------------
  V' =rot((x,y),a) = (x*cos(a)+y*sin(a),x*sin(a)-y*cos(a))


(Vx' bedeutet Drehung von V=(x,0) und Vy' ist Drehung von V=(0,y))
Und wir haben die Drehung eines Vektors in Koordinaten!

*****************************************************************************
		ENDGÜLTIGE DREHFORMEL IN ZWEI ABMESSUNGEN
*****************************************************************************

.. .
 . rot( (x,y), a)=( x*cos(a)+y*sin(a) , x*sin(a)-y*cos(a) )
       Komponente X ^^^^^^^^^^^^^^^^    ^^^^^^^^^^^^^^^^^ Komponente Y

*****************************************************************************

* Drei Dimensionen

Bei den beiden Dimensionen haben wir die x- und y-Koordinaten gedreht und
wir sehen, dass keine Z-Koordinaten geändert wurden.
Wir nennen dies eine Drehung um die Z-Achse.

In drei Dimensionen ist es jetzt am einfachsten, dasselbe noch einmal zu tun.
Drehen Sie einfach um eine beliebige Achse, um die neue Koordinate zu erhalten.
Lassen Sie die Variable weg, die die Koordinate der aktuellen Achse der
Rotation darstellt und Sie können den gleichen Ausdruck verwenden.

Wenn Sie nur eine oder zwei Koordinaten drehen möchten, können Sie die normale
Rotationsmethode verwenden, da keine 3x3-Transformationsmatrix berechnet
werden muss.
Wenn Sie jedoch mehr Punkte haben, empfehle ich die optimierte Version.

In diesem Bereich gibt es Optimierungen, aber lassen Sie uns zuerst
einen Weg sehen einen Vektor mit 3 angegebenen Winkeln zu drehen:

*******************************************************************************
     NORMALE VERFAHREN ZUM DREHEN EINES VEKTORS MIT 3 3D-DATENWINKELN:
*******************************************************************************

Angenommen, wir möchten V = (x, y, z) um die Z-Achse mit dem Winkel a, drehen.
um y mit b und um x mit c.

Die erste Drehung, die wir machen, ist um die Z-Achse:

	U=(x,y) (x,y vom V-Vektor) =>
	=> U'=rot(U,a)=rot((x,y),a)=(x',y')

Jetzt wollen wir uns um die Y-Achse drehen:

	W=(x',z) (x' ist von U' und z ist von V) =>
	=> W'=rot(W,b)=rot((x',z),b)=(x'',z')

Und schließlich um die X-Achse:

	T=(y',z') (y' ist von U' und z' ist von W') =>
	=> T'=rot(T,c)=rot((y',z'),c)=(y'',z'')

Der gedrehte Vektor V' ist der Koordinatenvektor

	(x'',y'',z'') !

Mit dieser Methode können wir den Rotationsbefehl erweitern auf:


	V''= rot(V,Winkel1,Winkel2,Winkel3) wobei V der ursprüngliche Vektor ist!
	( V''= rot((x,y,z),Winkel1,Winkel2,Winkel3) )


Ich hoffe es klingt nicht zu kompliziert.
Wie gesagt, es gibt Optimierungen dieser Methode.
Diese Optimierungen können durchgeführt werden, indem eine Drehung wie
oben gesehen übersprungen wird oder eine Vorberechnung.

DIE ORDNUNG ist sehr wichtig. Sie erhalten nicht die gleiche Antwort, wenn Sie
X, Y, Z mit den gleichen Winkeln wie zuvor drehen.

******************************************************************************

Optimierungen:
==============
Für die xyz-Vektoren können wir die Gleichungen schreiben, um die Rotationen
zu bilden:

Beachten:
	c1=cos(Winkel1)
	c2=cos(Winkel2)
	c3=cos(Winkel3)
	s1=sin(Winkel1)
	s2=sin(Winkel2)
	s3=sin(Winkel3)

		(x*cos(a)+y*sin(a),x*sin(a)-y*cos(a))

	x' = x*c1+y*s1
	y' = x*s1-y*c1

	x''= x'*c2+z*s2	  <- gedrehte X-Koordinate
	z' = x'*s2-z*c2

	y''= y'*c3+z'*s3  <- gedrehte Y-Koordinate
	z''= y'*s3-z'*c3  <- gedrehte Z-Koordinate

das gibt:

   x''= (x*c1+y*s1)*c2+z*s2= c2*c1 *x + c2*s1 *y + s2 *z
	^^^^^^^^^^^=x'       ^^^^^ xx   ^^^^^ xy   ^^ xz

   y''= (x*s1-y*c1)*c3+((x*c1+y*s1)*s2-z*c2)*s3=
	c3*s1 *x - c3*c1 *y + s3*s2*c1 *x + s3*s2*s1 *y - s3*c2 *z=

	(s3*s2*c1+c3*s1) *x + (s3*s2*s1-c3*c1) *y + (-s3*c2) *z
	^^^^^^^^^^^^^^^^ yx   ^^^^^^^^^^^^^^^^ yy   ^^^^^^^^ yz

   z''= (x*s1-y*c1)*s3-((x*c1+y*s1)*s2-z*c2)*c3=
	s3*s1 *x - s3*c1 *y - c3*s2*c1 *x - c3*s2*s1 *y + c3*c2 *z=

	(-c3*s2*c1+s3*s1) *x + (-c3*s2*s1-c3*c1) *y + (c3*c2) *z
	^^^^^^^^^^^^^^^^^ zx   ^^^^^^^^^^^^^^^^^ zy   ^^^^^^^ zz


Schauen Sie sich nun das Feature und die Struktur der Lösungen an:
für x'' haben wir das Original (x, y, z) berechnet, multipliziert mit ein paar
Mal, das gleiche gilt für y'' und z'', was ist die Verbindung?

Nehmen wir das Beispiel, dass viele Datenvektoren mit drei Winkeln gedreht
werden müssen. 
Gleich für alle Vektoren, dann haben wir dieses Multiplikationsschema.
Wenn Sie wie oben gedreht haben, mussten Sie zwölf Multiplikationen für eine 
Umdrehung machen, aber jetzt berechnen wir diese 'Konstanten' vor, um auf
nur neun Multiplikationen runter zu kommen!
	^^^^

*******************************************************************************
	ENDGÜLTIGE ROTATIONS-FORMEL IN 3 DIMENSIONEN MIT 3 WINKELN:
*******************************************************************************

x, y, z ist die ursprüngliche (x, y, z) Koordinate.

	c1=cos(Winkel1)
	c2=cos(Winkel2)
	c3=cos(Winkel3)
	s1=sin(Winkel1)
	s2=sin(Winkel2)
	s3=sin(Winkel3)

Wenn Sie mehrere Koordinaten mit denselben Winkeln drehen möchten, müssen Sie zuerst
diese Werte berechnen:

		xx=c2*c1
		xy=c2*s1
		xz=s2
		yx=c3*s1+s3*s2*c1
		yy=-c3*c1+s3*s2*s1
		yz=-s3*c2
		zx=s3*s1-c3*s2*c1	; s2*c1+c3*s1
		zy=-s3*c1-c3*s2*s1	; c3*c1-s2*s1
		zz=c3*c2

Für jede Koordinate müssen Sie also die folgende Multiplikation mit den 
gedrehten Koordinaten verwenden:

	x''=xx * x + xy * y + xz * z
	y''=yx * x + yy * y + yz * z
	z''=zx * x + zy * y + zz * z

Sie müssen die Konstanten also nur einmal für jeden neuen Winkel berechnen und
dann einfach NEUN Multiplikationen für jeden Punkt, den Sie drehen möchten
verwenden, um die neue Menge von Punkten zu erhalten.

Am Ende dieses Textes finden Sie ein Beispiel dafür, wie dies aussehen kann
implementiert in Assembler 68000.

Wenn Sie eine Ecke überspringen möchten, können Sie weiter optimieren. Wenn Sie
die Ecke 3 entfernen möchten, weisen Sie c3=1 und s3=0 zu. Setzen Sie sie
in die Berechnung der Konstanten ein und es wird nach Ihren Wünschen optimiert.

Welche Methode Sie verwenden sollen, hängt natürlich davon ab, wie viel Sie
programmieren möchten. Ich persönlich bevorzuge die optimierte Version, weil
sie kraftvoller ist.
Wenn Sie nur wenige Punkte mit den gleichen Winkeln drehen möchten, könnte die
erste Version (nicht optimiert) die Wahl sein.

Wenn Sie möchten, können Sie überprüfen, ob die Determinante der
Transformationsmatrix gleich 1 ist.

*******************************************************************************

5. Polygone!
============

Das Wort "Polygon" bedeutet viele Winkel, was auch bedeutet, dass es 
mehrere Punkte (Ecken) mit gezeichneten Linien hat.
Wenn wir zum Beispiel 5 Punkte haben, können wir die Linien zeichnen:
von Punkt 1 bis Punkt 2
von Punkt 2 bis Punkt 3
von Punkt 3 bis Punkt 4
von Punkt 4 bis Punkt 5
Und wenn wir ein GESCHLOSSENES Polygon wollen, müssen wir auch eine Linie
von Punkt 5 nach Punkt 1 zeichnen

Punkte: 2
       .

       .3
  1
  .
  5..4

OFFENES-Polygon, bestehend aus den oben gezeigten Punkten:


       /|
      / |
     /  /
    /  /
     _/


GESCHLOSSENES Polygon, bestehend aus den oben gezeigten Punkten:

       /|
      / |
     /  /
    /  /
    \_/


Die "Gefüllten Vektoren", dh "Gefüllte Vektoren", werden durch Zeichnen von 
Polygonen und füllen ihres Inneren erzeugt.
Normalerweise wird der folgende Algorithmus verwendet:

Zuerst definieren wir alle "Winkel" auf dem Polygon als Vektoren, was uns
erlaubt es zu drehen und nach der Drehung den neuen Winkeln zu zeichnen,
zeichnen wir eine Linie von Punkt 1 nach Punkt 2 und so weiter.
Die letzte Zeile führt von Punkt 5 zu Punkt 1.
Wenn wir fertig sind, verwenden wir ein BLITTER-FILL, um den Bereich zu füllen.

Wir benötigen eine spezielle Linienzeichnungsroutine zum Zeichnen dieser Linien,
damit die BLITTER-FILL gut funktioniert.
Ein Beispiel für eine geeignete Routine für diese Aufgabe finden Sie im Anhang
zum Text. Weitere Theorie darüber, welche Anforderungen an die Zeichnen-Routine
der Linie gestellt werden wird später besprochen (Anhang B 2).

	Erstellen Sie Objekte aus Polygonen
	===================================

Ein "Objekt" ist eine dreidimensionales Ding, das mit Polygonen erzeugt wird.
Aber was passiert mit den Oberflächen auf der anderen Seite des Objekts?
Was können wir tun, wenn das Objekt versteckte Teile enthält?

Beginnen wir mit einem Würfel, den man sich leicht vorstellen kann.
Wir können sehen, dass in den Augen des Beobachters kein Teil des Würfels über
dem anderen liegt (im Gegensatz zu einem Torus zum Beispiel).
Einige Gebiete sind natürlich außer Sicht, aber wir können berechnen, in welche
Richtung das Polygon zeigt (in Richtung des Beobachters oder versteckt
dahinter)

Polygone müssen in Objekten in derselben Richtung definiert werden (in oder
gegen den Uhrzeigersinn) im gesamten Objekt. Es spielt keine Rolle, an welchem
Punkt Sie beginnen, die Reihenfolge ist wichtig.

Nehmen Sie drei Punkte aus einer Ebene (Punkt1, Punkt2 und Punkt 3).
Wenn alle drei Punkte keinem der anderen Punkte entsprechen, definieren 
diese Punkte eine Ebene.

Dann benötigen Sie nur 3 Punkte, um die Richtung der Ebene zu definieren.
Untersuchen Sie die folgende Berechnung:

	c=(x3-x1)*(y2-y1)-(x2-x1)*(y3-y1)

(Dies ist nach der 3d-> 2d-Projektion, es gibt also keine Z-Koordinate.
Wenn Sie wissen möchten, wie es funktioniert, lesen Sie Anhang b)

Diese Formel benötigt drei Punkte, was der Mindestanzahl von Koordinaten
entspricht um ein anderes Polygon als eine Linie oder einen Punkt zu
definieren. Dies beinhaltet zwei Multiplikationen pro Ebene, aber es wird
nicht sehr viel verglichen bei der Drehung und 3d-> 2d Projektion.

Aber mal sehen, was diese Gleichung gibt:

Wenn c negativ ist, ist der Normalenvektor der Ebene der durch die drei Punkte
bestimmt wird auf den Beobachter "gerichtet" (= Die Ebene befindet sich vor
dem Beobachter => d.h. die Fläche sollte gezeichnet werden) ...

Wenn c positiv ist, ist der Normalenvektor der Ebene vom Beobachter aus der
Zone "gerichtet" (= Die Ebene kann vom Beobachter nicht gesehen
werden => die Fläche nicht zeichnen) ...

Aber was ist mit den Objekten, deren Teile andere Teile bedecken?
Vom Objekt selbst muss zwischen konkav und konvex unterschieden werden.

	Konvexe und konkave Objekte	
	===========================

"Definition"

Ein konvexes Objekt hat nirgendwo überdeckte andere Teile des
gleichen Objekts, aus allen Winkeln gesehen.

Ein konkaves Objekt hat Teile, die andere Teile desselben Objekts abdecken,
aus einem bestimmten Winkel gesehen.

Bei konvexen Objekten kann von jedem Punkt aus eine gerade Linie innerhalb 
des Objekts zu einem anderen Punkt auf dem Objekt gezeichnet werden, ohne
Linien zu haben, die die "Domäne" des Objektes verlässt.

Bei einem konvexen Objekt können Sie alle Linien um die sichtbaren Ebenen herum
zeichnen und dann mit dem Blitter füllen, weil kein gezeichnetes Polygon
niemals ein anderes Polygon abdecken wird.
Mit einigen Tricks können Sie auch einen Weg finden, einige Zeilen wegzulassen,
wenn diese zweimal gezeichnet werden.

Kokave-Objekte bieten zusätzliche Probleme. Der einfachste Weg konkave Objekte
zu nutzen ist sie in kleinere konvexe-Objekte zu unterteilen. Dies funktioniert
für alle Objekte, obwohl Sie möglicherweise Probleme dabei haben.

Natürlich können Sie mehrere Stockwerke überspringen, die "innen" ein
konkaves Objekt sind.

Wenn Sie das Objekt geteilt haben, zeichnen Sie einfach jedes konvexe Objekt in
einen temporären Speicherpuffer und behandeln Sie diese Objekte als
VEKTORBÄLLE mit Sortierroutinen (Sortieren), die die Teile finden, die
vor den anderen stehen.

Die Z-Koordinate kann aus dem Durchschnitt aller Z-Werte im Objekt entnommen
werden (Das heißt: die Summe aller Z-Werte im Objekt geteilt durch die Anzahl
von Koordinaten).

Wenn Sie Artikel sortieren, kann es zu Problemen kommen, das
konkave Teile des Objekts, die in der falschen Reihenfolge ausgewählt werden,
weil wir einen Punkt zufällig AUSSERHALB des konvexen Objekts genommen haben.
Das aktuelle Objekt wird mit einem anderen konvexen Objekt geteilt.
Eine Möglichkeit, dieses Problem zu lösen, besteht darin, einen Mittelpunkt zu
nehmen. Fügen Sie im konvexen Objekt alle Z-Werte um das Objekt hinzu und 
dividieren sie durch die Anzahl der hinzugefügten Koordinaten.
In diesem Fall sollten Punkte aus mindestens zwei Ebenen im Objekt entnommen
werden.

	Objektoptimierung
	=================

Nehmen wir an, wir haben ein KONVEXES-Objekt.
Wenn es geschlossen ist, haben Sie fast so wenige Punkte wie planes. (Wenn es 
geschlossen ist, haben wir so wenige Punkte wie es nur wenige Stockwerke
gibt???) Wenn wir eine Liste haben, die jede vorhandene Koordinate enthält
(kein Punkt muss wiederholt werden), zeigt dies für jedes Polygon, welche
Punkte genommen werden müssen für diese Koordinate und die Anzahl der
Umdrehungen kann weit geschnitten werden.

Als Beispiel:

  Ein Würfel
  Ordnung ist wichtig! Hier ist es Zeit

  fine_piano=0

pointlist:

	dc.l	pt4,pt3,pt2,pt1,fine_piano
	dc.l	pt5,pt6,pt2,pt1,fine_piano
	dc.l	pt6,pt7,pt3,pt2,fine_piano
	dc.l	pt7,pt8,pt4,pt3,fine_piano
	dc.l	pt8,pt5,pt1,pt4,fine_piano
	dc.l	pt5,pt6,pt7,pt8,fine_piano

pt1:	dc.w -1,-1,-1
pt2:	dc.w 1,-1,-1
pt3:	dc.w 1,-1,1
pt4:	dc.w -1,-1,1
pt5:	dc.w -1,1,-1
pt6:	dc.w 1,1,-1
pt7:	dc.w 1,1,1
pt8:	dc.w -1,1,1

Drehen Sie jetzt einfach die pt1-pt8-Punkte, die acht Punkte sind.
Wenn wir für jeden Plan vier Punkte ausgearbeitet hätten, hätten wir 
24 Umdrehungen rechnen müssen!

6. Böden in drei Dimensionen
=============================

Lightsourcing (Lichtquelle)
--------------------------------

Mit Lightsourcing können Sie herausfinden, wie viel Licht eine Fläche von
einem Lichtpunkt (sphärisch) oder von einer Fläche Lichtebene (planar)
empfängt. Die Farbe des Bodens stellt das Licht dar, das darauf fällt.
Das Objekt wird etwas realistischer.

Was uns interessiert, ist der Winkel des Vektors von der Normalen der Ebene zum
Lichtpunkt. (Dies ist für eine sphärische Lichtquelle wie eine Lampe.)
Für planare Beleuchtung wie die der Sonne benötigen Sie den Winkel zwischen
der Normalen der Ebene und des Vektors der Lichtquelle.

Wir brauchen den Kosinus des gegebenen Winkels.

Um jedoch die Normale der Fläche zu erhalten, können Sie drei Punkte in der
Ebene des Polygons nehmen und zwei Vektoren von diesen erstellen.

 Beispiel:

*  Wir nehmen (x1,y1,z1) , (x2,y2,z2) und (x3,y3,z3)

   Wir erzeugen zwei Vektoren V1 und V2:

   V1=(x2-x1,y2-y1,z2-z1)
   V2=(x3-x1,y3-y1,z3-z1)

Um die Normale von diesen zu haben, nehmen wir ihr Produkt (Kreuzprodukt?):	

		|  i     j     k  |
    N = V1xV2 = |x2-x1 y2-y1 z2-z1| =
		|x3-x1 y3-y1 z3-z1|

	       n1                                       n2
*   = ((y2-y1)*(z3-z1)-(y3-y1)*(z2-z1),-((x2-x1)*(z3-z1)-(x3-x1)*(z2-z1)),
*      ,(x2-x1)*(y3-y1)-(x3-x1)*(y2-y1))
		 n3

Wir haben jetzt N. Wir haben auch die Koordinaten der LIGHTSOURCE (Daten).

Um den COS des Winkels zwischen zwei Vektoren zu nehmen, können wir das Skalar-
Produkt zwischen N und L (= Lichtquellenvektor) geteilt durch die Länge von
N und L verwenden :

   <N,L>/(||N||*||L||) =

*  (n1*l1+n2*l2+n3*l3)/(sqr(n1*n1+n2*n2+n3*n3)*sqr(l1*l1+l2*l2+l3*l3))
|
*  (könnte sein (n1*l1+n2*l2+n3*l3)/k wenn k eine vorberechnete Konstante ist)

Wenn Sie etwas nicht verstehen, sehen Sie sich die Formeln mit einem '*' am Rand an.
n1 bedeutet "X-Koordinate von N", n2 "Y-Koordinate" usw. und das
gleiche gilt für L.

Diese Zahl liegt zwischen -1 und 1 und ist der COS des Winkels zwischen den
L- und N-Vektoren.
Quadratwurzeln sind zeitaufwändig, aber wenn wir das Objekt intakt halten
(nur Rotationen / Translation usw.) und wir nehmen immer die gleichen Punkte
im Objekt dann ist || N || intakt und kann vorberechnet werden.

Wenn wir feststellen, dass die Länge von L immer 1 ist, ist es nicht notwendig
zu teilen. Dies spart viele Zyklen.

Die Zahl könnte, wie erwähnt, zwischen -1 und 1 liegen. Es wird notwendig sein,
den Wert mit etwas zu multiplizieren, bevor Sie ihn teilen, damit Sie eine
größere Spanne von Farben für die Wahl der "Tonalität" der Fläche haben.
Wenn die Zahl negativ ist, muss sie zurückgesetzt werden.

Die Zahl kann negativ sein, wenn sie positiv sein soll. Das liegt daran
dass sie die Punkte in der falschen Reihenfolge genommen haben, aber dann
einfach das Ergebnis negieren.

Spezielle Verhaltensweisen - Sortieralgorithmen
===============================================

Wenn es notwendig ist zu ordnen, können wir das normalerweise mit "Bubble-
sorting" machen, die ist jedoch ziemlich langsam, obwohl leicht zu verstehen.
Es ist besser, "Insert Sorting" oder "Quick Sorting" oder andere schnelle
zu verwenden.

Methode 1) Bubble Sorting
-------------------------

Nehmen wir an, wir haben eine Liste von Werten, die mit Gewichten verknüpft
sind (Metall!).
Die schwersten Gewichte müssen auf den Boden fallen und die Werte mitnehmen.
Die Werte können in diesem Fall x¹- und y¹-Koordinaten oder andere sein
Dinge, wie Vektorball Bobs.
Gewichte (schwer?) können die Z-Koordinaten vor der Projektion sein.

Wir beginnen mit den ersten beiden Elementen und prüfen, welches Element am
"schwersten" ist, und wenn es über dem "leichteren" Element liegt, werden
alle Daten verschoben verbunden mit dem Gewicht...
Diese Prozedur wird als "Swap" -Operation bezeichnet.

Dann gehen Sie unter 1 Element und überprüfen die Elemente 2 und 3 ...
Sie machen mehrere Schritte, bis Sie am Ende der Liste stehen.

Der erste Zyklus führt jedoch nicht die "endgültige" Reihenfolge aus, sondern
es ist erforderlich, die Liste genauso oft wie die Elemente -1 zu sortieren!
Wenn es also 30 Objekte gibt, müssen Sie 29 Schleifen wie die beschriebene
ausführen.

Eine etwas "intelligentere" Version ist jedes Mal wenn ein Austausch
stattfindet ein Flag zu setzen, wenn also die Liste sortiert wurde.
Bevor alle Schleifen ausgeführt wurden, stoppt die Routine.
In der Tat, wenn die Liste wäre: 2,1,3,4,5,6,7,8,9,10, würde nur 1 Schleife 
zum Ordnen ausreichen und nicht 9!

Hier ist ein Beispiel für diesen Algorithmus, nach dem eine Worttabelle von
kleiner bis größer sortiert wird:

Bubble:
	lea	Positions(PC),a0	; Liste der zu sortierenden Wörter
	moveq	#0,d0			; löscht d0 (Flag des Austauschs aufgetreten)
Loop:
	move.w	(a0),d1			; Element 1
	cmp.w	2(a0),d1		; Element 2
	ble.s	NoSwap			; Elem. 2 kleiner als Elem. 1? Wenn ja OK
	move.w	2(a0),(a0)		; Andernfalls tauschen Sie die Elemente aus
	move.w	d1,2(a0)
	st	d0					; und Marken, die wir gehandelt haben
NoSwap:
	addq.w	#2,a0			; nächster Vergleich
	cmp.l	#EndPos-2,a0	; Sind wir am Ende?
	bcs.s	Loop			; Wenn Sie die "Runde" noch nicht beendet haben
	tst.w	d0				; Sind wir mit dem Austausch fertig?
	bne.s	Bubble			; Wenn noch nicht, gehen Sie noch einmal auf
	rts

Positions:
	dc.w	8,3,4,5,6,7,8,1,-1,2,6
EndPos:

Methode 2) Insert sorting
-------------------------

Betrachten wir die gleichen Werte und Gewichte wie zuvor.
Für dieses System müssen Sie eine Länge (Byte, Wort, long) auswählen
für jede Sortiertabelle von (Sortiertabelle oder Checkliste)
eine Checklistengröße.

  Die Wortlänge hängt von der Anzahl Ihrer Einträge ab
  und der Größe jeden Eintrags. Normalerweise ist es praktisch
  ____ benutze Wörter. Die Größe der Checkliste ist der Bereich
  von Z-Werten ____ sortieren oder transformierte Z-Werte.
  Wenn Sie zum Beispiel wissen, dass Ihre Z-Werte innerhalb 512-1023
  liegen können Sie zuerst jeden z-Wert um 512 verringern,
  und dann lsr 'es einmal, was Ihnen eine Checklistengröße 
  von 256 Wörtern gibt.
  Sie benötigen außerdem einen zweiten Puffer ____, um Ihren sortierten
  einzugegeben, dieser 2ndBUF wird wie eine Kopie des Originals sein,
  aber mit den sortierten Werten.

  Für diese Methode stelle ich nur einen Algorithmus vor um
  einfach zu sehen, wie es funktioniert.

  Checkliste (x) ist das x-te Wort in der Checkliste.

Algorithmus:
  1> Reinigen Sie die Checkliste (weisen Sie alle Wörter zu = 0)
  2> Transformieren Sie gegebenenfalls alle Gewichte.
  3> Für L = 0 Zur Anzahl der Objekte
  3.1> ENTRYSIZE eingeben Eine Checkliste (transformiertes Gewicht)
  4>  Für L = 0 Eine Checkliste Größe-1
  4.1> Checkliste (L), Checkliste (L + 1) hinzufügen
  5> Für L = 0 Zur Anzahl der Objekte
  5.1> Eintrag bei 2ndBUF platzieren (Checkliste (transformiertes Gewicht))
  5.2> Checkliste ENTRYSIZE TO hinzufügen (transformiertes Gewicht)

  Jetzt sind Ihre Daten in der 2ndBUF-Liste. Die ursprüngliche
  Liste bleibt unverändert (mit Ausnahme der Z-Transformation).
  (ENTRYSIZE ist die Größe des Eintrags. Wenn Sie also x-, y- und
  z-Koordinaten haben in Worten, Ihre Größe beträgt 3 Wörter = 6 Bytes.)
  Denken Sie auch ein wenig darüber nach, was Sie dabei bekommen verwandeln. 
  Subtraktion ist nützlich, solange sie die Schleife minimiert, aber 
  lsr-ing die Gewichte brauchen Zeit und bringen ein schlechteres Ergebnis.
  Natürlich müssen Sie die Liste nicht jedes Mal durchgehen,
  Stellen Sie einfach sicher, was das niedrigstmögliche und
  das höchstmögliche Gewicht ist.


Methode 3) die schnelle Sortierung
----------------------------------
 Dies ist eine andere Art der Ordnung, und hier ist es effizienter ____
 Verwenden Sie Zeiger, damit jeder Eintrag einen Zeiger auf den nächsten
 Eintrag hat.

  Sie können so eingeben:

  Nächster Versatz = Wort
  x,y,z=Koordinaten.

  (Offsets stammen von der Startadresse der Sortierliste...)

  Um auf diese Routine zugreifen zu können, müssen Sie einen ersten Eintrag
  und die Anzahl der Einträge eingeben. In der ursprünglichen Ausführung 
  ist der erste Eintrag natürlich 0 (= erster Eintrag) und die Anzahl der
  Einträge ist natürlich die Gesamtzahl der Einträge.
  Sie müssen alle vorherigen / nächsten Zeiger ____ zuweisen, um eine Kette
  zu verbinden.

  Quicksort ist rekursiv, was bedeutet, dass Sie die Routine aus sich heraus
  aufrufen müssen. Das ist nicht allzu kompliziert. Sie müssen nur einige
  alte Variablen auf dem Stapel zur sicheren Aufbewahrung setzen.

  Was es tut, ist Folgendes:
+> Der erste Eintrag in der Liste ist der PIVOT-Eintrag.
|  Für jeden anderen Eintrag setzen wir ihn entweder vor oder nach
|  dem PIVOT. Wenn es PIVOT leichter ist, setzen wir es zuerst,
|  sonst setzen wir es danach.
|  Wir haben jetzt zwei neue Listen, Alle Einträge zuerst PIVOT,
|  und alle Einträge nach dem PIVOT (aber nicht der Pivot selbst,
|  welches bereits sortiert ist).
|  Jetzt sortieren wir alle Einträge schnell. Zuerst Pivot separat
+ <und dann sortieren wir alle Einträge nach dem Pivot schnell.
  (Wir tun dies, indem wir die Routine aufrufen, in der wir uns bereits
   befinden.) Dies kann Probleme mit dem Stapel verursachen, wenn zu viel 
   viele Dinge vorhanden sind ____ zu sortieren.

   Die Rekursionsschleife wird unterbrochen, wenn <= 1 Eintrag vorhanden ist
   ____ Sortieren.

   Im Gegensatz zum Glauben einiger Leute brauchen Sie keine Extras
   Liste ____ um das zu lösen.

Algorithmus:

Inparameters: (PivotEntry=erstes Element der Liste
	       Listengröße = aktuelle Listengröße)
1> Wenn die Listengröße <= 1 ist, beenden Sie das Programm
2> PivotWeight=Weight(PivotEntry)
3> für l=2nd Eintrag ____ Listrengröße-1
3.1> wenn weight(l) > PivotWeight
3.1.1> Eintrag in Liste 1 einfügen
3.2> Andernfalls
3.2.1> Eintrag in Liste 2 einfügen
4> Sortierliste 1 (bsr quicksort(erster Eintrag zur Liste 1, Listengröße 1))
5> Sortierliste 1 (bsr quicksort(erster Eintrag zur Liste 2, Listengröße 2))
6> Link zur Liste 1 -> PivotEntry -> auflisten 2

  (PivotEntry = FirstEntry, es muss nicht so aussehen, aber ich bevorzuge es
   bis ich es leichter finde.)
   

Spezielle Techniken - Vektorkugeln
==================================
  Vektorkugeln sind einfach. Berechnen Sie einfach, wo die Bälle sind (mit
  Rotationen, Translationen oder was es sein kann). Manchmal berechnet man
  auch die Größe vom Ball und so weiter.

  Sie müssen keine Bälle haben. Sie können die konvexen Teile eines konkav
  gefüllten Objekts haben, oder Sie können Bilder haben von dem, was sie
  mögen. In drei Dimensionen haben Sie das Problem mit Bildern (Bälle oder
  anderes) das vor anderen sein sollte, weil es weiter von Ihnen entfernt ist.
  Hier ist wie die Reihenfolge herein kommt. Wenn Sie anfangen, das Bild zu
  blitten, das weiter von Ihnen entfernt ist und tritt näher an sie heran.
  Für jedes Objekt erhalten Sie einen 3D-screen. Das nächstgelegene Bild ist
  das nächste.

  Normalerweise beginnen Sie mit der Reinigung des Bildschirms, den Sie im
  Moment nicht zeigen (Teile davon sowieso. Eine ruhige Person reinigt nur
  jede zweite Zeile...)

  Also während der Blitter arbeitet, fängt es an sich zu drehen, zu ordnen
  und vorzubereiten, um schliesslich die Bilder auszugeben und wenn Sie
  überprüft haben, dass der Blitter fertig ist und  wenn Sie fertig sind,
  fangen Sie an, alle Bilder herauszuholen und wenn der frame angezeigt wird,
  tauschen Sie die Bildschirme aus, damit Sie Ihren fertigen Bildschirm im
  nächsten Bild anzeigen.


Anhang A: Beispielquellen.

  1  Optimierte Matrix der Rotationsberechnung
  2  Eine Linienzeichnungsroutine für gefüllte Vektoren
  3  Quicksort in 68000 assembler
  4  Ordnung eingeben in 68020 assembler


  Optimierte Berechnung der Rotationsmatrix

A 1. Ein Beispiel für eine optimierte Rotationsmatrixberechnung
===============================================================

* Für diese Routine müssen Sie eine Sinustabelle mit 1024 Werten haben
* und drei Wörter mit Ecken und einem Platz (9 Wörter) ____ zu halten
* die Transformationsmatrix.
*    __   .
*  /( |( )|\/ '(|)
* /  )|(|\|/\   |)

Konstanten berechnen

		lea     Coses_Sines(pc),a0
		lea     Angles(pc),a2
		lea     Sintab(pc),a1

		move.w  (a2),d0
		and.w   #$7fe,d0
		move.w  (a1,d0.w),(a0)
		add.w   #$200,d0
		and.w   #$7fe,d0
		move.w  (a1,d0.w),2(a0)
		move.w  2(a2),d0
		and.w   #$7fe,d0
		move.w  (a1,d0.w),4(a0)
		add.w   #$200,d0
		and.w   #$7fe,d0
		move.w  (a1,d0.w),6(a0)
		move.w  4(a2),d0
		amd.w   #$7fe,d0
		move.w  (a1,d0.w),8(a0)
		add.w   #$200,d0
		and.w   #$7fe,d0
		move.w  (a1,d0.w),10(a0)

		;xx=c2*c1
		;xy=c2*s1
		;xz=s2
		;yx=c3*s1+s3*s2*c1
		;yy=-c3*c1+s3*s2*s1
		;yz=-s3*c2
		;zx=s3*s1-c3*s2*c1;s2*c1+c3*s1
		;zy=-s3*c1-c3*s2*s1;c3*c1-s2*s1
		;zz=c3*c2

		lea     Constants(pc),a1
		move.w  6(a0),d0
		move.w  (a0),d1
		move.w  d1,d2
		muls    d0,d1
		asr.l   #8,d1
		move.w  2(a0),d3
		muls    d3,d0
		asr.l   #8,d0
		move.w  d0,(a1)
		;neg.w  d1
		move.w  d1,2(a1)
		move.w  4(a0),4(a1)
		move.w  8(a0),d4
		move.w  d4,d6
		muls    4(a0),d4
		asr.l   #8,d4
		move.w  d4,d5
		muls    d2,d5
		muls    10(a0),d2
		muls    d3,d4
		muls    10(a0),d3
		add.l   d4,d2
		sub.l   d5,d3
		asr.l   #8,d2
		asr.l   #8,d3
		move.w  d2,6(a1)
		neg.w   d3
		move.w  d3,8(a1)
		muls    6(a0),d6
		asr.l   #8,d6
		neg.w   d6
		move.w  d6,10(a1)
		move.w  10(a0),d0
		move.w  d0,d4
		muls    4(a0),d0
		asr.l   #8,d0
		move.w  d0,d1
		move.w  8(a0),d2
		move.w  d2,d3
		muls    (a0),d0
		muls    2(a0),d1
		muls    (a0),d2
		muls    2(a0),d3
		sub.l   d1,d2
		asr.l   #8,d2
		move.w  d2,12(a1)
		add.l   d0,d3
		asr.l   #8,d3
		neg.w   d3
		move.w  d3,14(a1)
		muls    6(a0),d4
		asr.l   #8,d4
		move.w  d4,16(a1)

		rts

Coses_Sines     dc.w    0,0,0,0,0,0
Angoli          dc.w    0,0,0
Costanti        dc.w    0,0,0,0,0,0,0,0,0

; Sintab ist eine Tabelle mit 1024 Sinuswerten mit einem Radius von 256
; dass ich weiter unten meinen Code habe...




Eine Linienzeichnungsroutine für gefüllte Vektoren

A 2. Routinen zum Zeichnen einer Linie für gefüllte Vektoren in Assembler:
==========================================================================

* geschrieben für kuma-seka vor Ewigkeiten, funktioniert super und
* kann für Sonderfälle optimiert werden ...
* die Linie ist (x0, y0) - (x1, y1) = (d0, d1) - (d2, d3) ...
* Denken Sie daran, dass Sie DFF000 in a6 und haben müssen
* Die Startadresse des Bildschirms in a0.
* Nur a1-a7 und d7 bleiben unverändert.
*    __   .
*  /( |( )|\/ '(|)
* /  )|(|\|/\   |)

Schermo_widht=40	; 40 byte großer Bildschirm...
riempire_linee:     ; (a6=$dff000, a0=ohne Bitplane ____ einziehen)

	cmp.w   d1,d3
	beq.s   noline
	ble.s   lin1
	exg     d1,d3
	exg     d0,d2
lin1:   sub.w   d2,d0
	move.w  d2,d5
	asr.w   #3,d2
	ext.l   d2
	sub.w   d3,d1
	muls    #Schermo_Widht,d3        ; kann hier optimiert werden..
	add.l   d2,d3
	add.l   d3,a0
	and.w   #$f,d5
	move.w  d5,d2
	eor.b   #$f,d5
	ror.w   #4,d2
	or.w    #$0b4a,d2
	scambiare    d2
	tst.w   d0
	bmi.s   lin2
	cmp.w   d0,d1
	ble.s   lin3
	move.w  #$41,d2
	exg     d1,d0
	bra.s   lin6
lin3:   move.w  #$51,d2
	bra.s   lin6
lin2:   neg.w   d0
	cmp.w   d0,d1
	ble.s   lin4
	move.w  #$49,d2
	exg     d1,d0
	bra.s   lin6
lin4:   move.w  #$55,d2
lin6:   asl.w   #1,d1
	move.w  d1,d4
	move.w  d1,d3
	sub.w   d0,d3
	ble.s   lin5
	and.w   #$ffbf,d2
lin5:   move.w  d3,d1
	sub.w   d0,d3
	or.w    #2,d2
	lsl.w   #6,d0
	add.w   #$42,d0
bltwt:  btst    #6,2(a6)
	bne.s   bltwt
	bchg    d5,(a0)
	move.l  d2,$40(a6)
	move.l  #-1,$44(a6)
	move.l  a0,$48(a6)
	move.w  d1,$52(a6)
	move.l  a0,$54(a6)
	move.w  #Schermo_Widht,$60(a6)   ; Breite
	move.w  d4,$62(a6)
	move.w  d3,$64(a6)
	move.w  #Schermo_Widht,$66(a6)   ; Breite
	move.l  #-$8000,$72(a6)
	move.w  d0,$58(a6)
noline: rts




  Quicksort in 68000 assembler

A 3. quicksort in 68000 assembler
=====================================

* Ordnen Sie eine Liste, die aussieht wie:
* Nächster Eingangsoffset.w, (x, y, z) .w.
* Alle Offsets müssen zugewiesen werden, mit Ausnahme des
* vorherigen Offsets des ersten Eintrags
* und der nächste Versatz des letzten Eintrags.
* Offsets sind von der ersten Adresse zur Sortierliste
* a5 = erste Adresse zur Sortierliste!
*    __   .
*  /( |( )|\/ '(|)
* /  )|(|\|/\   |)


WghtOffs=6
NextOffs=0

QuickSort       ; (a5=Abfahrt der Sortierliste,
		; d0=0 (Zeiger auf den ersten Eintrag, beim ersten Mal=0)
		; d1=Anzahl der Einträge)


    cmp.w   #1,d1
    ble.s   .NothingToSort          ; Sortieren Sie nicht, wenn Sie <= 1 eingeben
    moveq   #0,d4                   ; Größenliste 1
    moveq   #0,d5                   ; Größenliste 2
    move.w  d0,d6					; erster Eingang=d0

    move.w  WghtOffs(a5,d0.w),d2	; d2=Schwenkgewicht
    move.w  NextOffs(a5,d0.w),d3	; d3=2nd Eingang
    subq.w  #2,d1                   ; Dbf-loop+springe zuerst

.Permute       
    cmp.w  WghtOffs(a5,d3.w),d2     ; Einstiegsgewicht <Pivotgewicht?
    ble.s   .Inferiore

    move.w  d6,NextOffs(a5,d3.w)	; Geben Sie zuerst Nentry ein
    addq.w  #1,d4                   ; Listengröße erhöhen 1
    move.w  d3,d6					; Weisen Sie einen neuen Nentry zu

    bra.s   .Fatto                  ; mach weiter loop...

.Inferiore         
    move.w  NextOffs(a5,d0.w),NextOffs(a5,d3.w)
    move.w  d3,NextOffs(a5,d0.w)	; Nach der ersten Eingabe eingeben
    addq.w  #1,d5                   ; Listengröße 2

.Fatta           
	move.w  NextOffs(a5,d3.w),d3	; nächsten Eingang nehmen
    dbf     d1,.permute

    move.w  d0,-(a7)				; Fentry retten..

    move.w  NextOffs(a5,d0.w),d0	; sortieren nach dem Ersten
    move.w  d5,d1					; Listengröße 2

    movem.w d4/d6,-(a7)             ; Speichern wichtige Register
    bsr     QuickSort               ; und Sortierliste 2
    movem.w (a7)+,d4/d6             ; d1 ist jetzt Erster Eintrag...
    move.w  (a7)+,d1

    move.w  d0,NextOffs(a5,d1.w)	; Setzen Sie den ersten Eintrag von
				    ; Liste 2 nach Fentry ...
    move.w  d6,d0					; Reihenfolge Nentry
    move.w  d4,d1					 ; Listengröße 1

    bsr     QuickSort               ; keine wichtigen Register
				    ; links...
.NothingToSort
    ; Jetzt ist der Offset beim ersten Eintrag bei d0!
    ; ____ Nehmen Sie die anderen Werte in der richtigen Reihenfolge
    ; Gehen Sie einfach die Liste durch (mit nextoffs).
    ; Rimo-Objekt ist das schwerste...

    rts



  Ordnung eingeben in 68020 assembler

A 4. Ordnung eingeben in 68020 assembler:
========================================

* Dies ist nicht genau wie der oben beschriebene Algorithmus,
* Es beginnt mit der Erstellung einer Liste und behält dann die Adressen von 
* Daten bei stattdessen in 2ndBUF sortiert ...
* Hiermit werden alle Listen sortiert. Geben Sie einfach Offset ____ Gewicht (Wort) und an
* Größe jedes Eintrags. Sie benötigen keine Vorformatierung.
* Beachten Sie, dass Sie eine Zeile ändern müssen, wenn dies ____ funktionieren soll
* über 68000 .. Ich habe einen Index auf einen Punkt skaliert. ersetze es
* mit Zeilen nach dem Semikolon.
*    __   .
*  /( |( )|\/ '(|)
* /  )|(|\|/\   |)

WghtOffs=4
EntrySize=6

InsertSort
    ; (a5=Datenabgang
    ; a4=Start checklist
    ; a3=Start 2ndBUF
    ; d0 es ist niedrigerer Wert des Umsatzes
    ; d1 es ist ein höherer Wert
    ; d2 ist die Anzahl der Einträge

    movem.l a4/a5,-(a7)

    sub.w   d0,d1				; maximale Größe der Checkliste dieser Art.
    subq.w  #1,d2
    subq.w  #1,d1				; Dbf-loop...

    move.w  d1,d3				; gebrauchte Eingänge reinigen
.ClearChecklist 
	clr.w   (a4)+
    dbf     d3,.ClearCheckList

    move.w  d2,d3				; pendeln...
.Trasformare      
	sub.w   d0,WghtOffs(a5)
    addq.w  #EntrySize,a5
    dbf     d3,.Trasformare

    movem.l	(a7),a4/a5

    move.w  d2,d3				; Fügen Sie stattdessen die nächste Zeile ein
.AddisList      
	move.w  WghtOffs(a5),d0		; 68000 Kompatibilität...
	addq.w  #4,(a5,d0.w*2)		; add.w d0,d0 addq.w #4,(a5,d0.w)
	addq.w  #EntrySize,a5
	dbf     d3,.AddisList

	moveq   #-4,d0				; #-lwdsize
.GetMemPos    
	add.w   d0,(a4)
    move.w  (a4)+,d0
    dbf     d1,.GetMemPos

    movem.l (a7)+,a4/a5
.PutNewList     
	move.w  WghtOffs(a5),d0
    move.w  (a4,d0.w),d0
    move.l  a5,(a3,d0.w)
    addq.w  #EntrySize,a5
    dbf     d2,.PutNewList

	; In diesem Fall haben Sie eine Liste von Adressen an
    ; jedes Objekt. Ich habe es so gemacht
    ; Machen Sie es flexibler (Sie haben vielleicht mehr
    ; Daten in jedem Eintrag, als ich?).

    rts



  Weitere Informationen

Anhang B: Weitere Informationen

B 1: Probieren Sie die Eliminierungsgleichung für versteckte Flächen aus
========================================================================

  Ich habe die folgende Gleichung vorgestellt:
  c=(x3-x1)*(y2-y1)-(x2-x1)*(y3-y1)
  als Berechnung des normalen Ebenenvektors
  dass das betreffende Polygon überspannt ist.

  Wir hatten drei Punkte:
  p1(x1,y1)
  p2(x2,y2)
  p3(x3,y3)

Wenn wir p1 als Basiswert auswählen, können wir die folgenden 
Vektoren mit den restlichen Punkte konstruieren:

  V1=(x3-x1,y3-y1,p)
  V2=(x2-x1,y2-y1,q)
  
  Wobei p und q im z-Wert hervorheben, an denen wir nicht interessiert sind
  diesen Wert, aber wir müssen ihn trotzdem in unsere Berechnungen einbeziehen.
  (Diese Werte stimmen nicht mit den ursprünglichen Z-Werten überein
  nach 2d-> 3d Projektion)


  Nun können wir den normalen Ebenenvektor dieser Vektoren nehmen
  Spanne von einem einfachen Kreuzprodukt:

   V1 x V2 =

  |  io       j     k|
= |(x3-x1) (x2-x1)  p|  (wenn ich=(1,0,0), j=(0,1,0), k=(0,0,1))
  |(y3-y1) (y2-y1)  q|  (p und q unwichtig)
  
  Wir interessieren uns aber nur für die Z-Richtung des Ergebnisvektors dieser
  Operation, der dasselbe ist wie, als wenn wir nur die Z-Koordinate aus dem
  Kreuzprodukt herausnehmen:

   Z di (V1xV2) = (x3-x1)*(y2-y1)-(x2-x1)*(y3-y1)

  Wenn nun Z positiv ist, bedeutet dies, das der resultierende Vektor
  auf den Bildschirm zeigt (positive Z-Werte)
  QED /Asterix

B 2. Wie man eine Fülllinie aus der Blitters-Zeichnungslinie macht
==================================================================
  Sie können die Blitter-Zeichenlinie nicht so verwenden, wie sie ist und
  Zeichnen Sie Linien um ein Polygon ohne besondere Änderungen.

  So machen Sie aus einer normalen Lineroutine eine Fülllinienroutine:

   Stellen Sie zunächst sicher, dass Linien so gezeichnet werden, wie sie
   sollten. Bei vielen Linienzeichnungen habe ich Zeichnungslinien an den
   falschen Stellen gesehen. Stellen Sie sicher, dass Sie Exclusive o-
   anstelle von o-minterm verwenden. Zeichnen Sie immer Linien bergab.
   (oder Up, wenn Sie das bevorzugen) vor dem Zeichnen der Linie und dem
   ersten Blit-Check und / oder dem ersten zeigen Sie auf dem Bildschirm,
   dass die Linie gekreuzt wird.
   Es wird der Typ zum Ausfüllen von Zeilen verwendet.



B 3: Ein alternativer Ansatz zu 3-Raum-Rotationen von M. Vissers
================================================================

Dies ist ein Text von Michael Vissers und er war ursprünglich länger. Ich habe
den Teil über die Projektion von 3d-> 2d entfernt, da er identisch war mit den
Teilen meines Textes in Kapitel 3.
Wenn Sie die grundlegende lineare Algebra kennen, könnte dieser Text 
leichter aufzulösen sein, als die in Kapitel 4 beschriebene längere Version.
Wenn Sie nicht wissen, wie Sie das Ergebnis von Kapitel 4 verwenden sollten,
dann versuchen Sie diesen Teil stattdessen.

[ ] Sie müssen lediglich diese 3D-Matrizen verwenden :

(A/B/G sind Alpha,Beta und Gamma.)  A,B,C = Winkel der Rotation 

|  cosA  -sinA  0  |    |  cosB   0  -sinB  |    |   1    0      0		 |
|  sinA   cosA  0  |    |   0     1    0    |    |   0   cosG  -cantare  |
|   0      0    1  |    |  sinB   0   cosB  |    |   0   cantare   cosG  |

Dies sind die Rotationsmatrizen um die x-, y- und z'-Achse. Wenn du diese
verwenden würdest nimmst du 12 muls'. 4 vier für jede Achse. Aber wenn Sie
multiplizieren mit diesen drei Matrizen rechnen, nehmen Sie nur 9 Mul. Warum 9?
Einfach: Nach dem Multiplizieren erhalten Sie eine 3x3-Matrix. und 3*3=9 !

Es spielt keine Rolle, ob Sie diese Matrizen nicht multiplizieren können. Es
ist nict von Bedeutung hier, daher werde ich einfach die 3x3-Matrix nach der
Multiplikation angeben:

(c = cos, s = sin, A/B/G sind Alpha,Beta und Gamma.)

	|     cA*cB               -cB*sA          sB   |
	| cG*sA-sB*cA*sG      cA*cG+sG*sA*sB     cB*sG |
	|-sG*sA-sB*cA*cG     -cA*sG+sA*sB*cG     cG*cB |

Ich hoffe ich habe alles ohne Fehler geschrieben :) Ok, wie können wir welche
machen? Koordinaten unter Verwendung dieser Matrix. Auch hier dreht sich alles
um das Multiplizieren.
Um die neuen (x, y, x) zu erhalten, benötigen wir die ursprünglichen Punkte
und multiplizieren Sie diese mit der Matrix. Ich werde mit einer einfachen
Matrix arbeiten. (zum Beispiel H = cA * cB etc ...)

						  x   y   z   ( <= Originalkoordinaten)
						-------------
	Nuovo X =     |   H   Io  J   |
	Nuovo Y =     |   K   L   M   |
	Nuovo Z =     |   N   O   P   |

So...

	Nuovo X = x * H + y * Io + z * J
	Nuovo Y = x * K + y * L + z * M
	Nuovo Z = x * N + y * O + z * P

Ha ! Das sind viel mehr als 9 Mul. Naja eigentlich nicht. Um die Matrix zu
verwenden müssen Sie die Matrix vorberechnen.

Drehen Sie immer mit Ihren Originalpunkten und bewahren Sie sie an einem
anderen Ort auf. Ändern Sie einfach die Winkel mit der Sintable ____ drehen Sie
die Form. Wenn Sie die gedrehten Punkte des vorherigen frames drehen, verlieren
Sie alle Details solange nichts mehr übrig ist.

Jeder Frame sieht also so aus :      - neue Matrix mit vorberechneten
				       gegebenen Winkel.
				     - Tip zu Berechnung mit preserved Matrix.
[ ]
Die resultierenden Punkte berücksichtigen (0,0). Sie können also negativ sein.
Verwenden Sie einfach ein Add ____ und nehmen Sie es in die Mitte des
Bildschirms.

Hinweis: Verwenden Sie immer muls, divs, asl, asr usw. Daten können sowohl
      positiv als auch negativ sein. Weisen Sie außerdem die größtmöglichen
	  Originalkoordinaten zu und nach dem Drehen teilen Sie sie wieder. Dies
	  wird die Bewegungsqualität entwickeln.

(Michael Vissers)


B 4: Ein kleiner mathematischer Hinweis für genauere Vektorberechnungen
======================================================================

In dem Moment, in dem mit einem Wert ein Mul ausgeführt wird und dann der Wert
heruntergeshiftet wird, verwenden Sie ein 'addx' ____ nehmen Rundungsfehler
anstelle von abgeschnittenem Fehler, zum Beispiel:

	moveq	#0,d7
DoMtxMul
	:
	muls	(a0),d0		; einen Mul mit einem Sinuswert von * 256 machen
	asr.l	#8,d0
	addx.w	d7,d0		; roundoff < trunc
	:

Wenn Sie ein 'asr' ausführen, geht das letzte herausgeschobene Bit zum x-Flag.
Wenn Sie ein Addx mit source = 0 => dest = dest + 'x-flag' verwenden.
Dies halbiert den Fehler und macht Vektorobjekte weniger kompliziert "hacky".


 /)    __   .
((   /( |( )|\/  '(|)
 )) /  )|(|\|/\    |)
(/




				3D


NB: Kenntnis von Linien machen mit dem Blitter -, Füllung, Cookie Cut
(Ausstechen), Füllen, es ist nützlich, um bestimmte Teile der Lektion
besser zu verstehen

EINFÜHRUNG:

Die grundlegende und synthetische Form jedes Objekts, die wir uns wünschen
wird auf dem Bildschirm als eine Reihe von x-, y- und z-Koordinaten
ausgedrückt. Jede Koordinatentriade (drei, vah) entspricht den Abständen vom
Ursprung (platziert an den Koordinaten 0,0,0) von den x-, y- und z-Achsen.
Folglich entspricht jedes Koordinatentrio einem einzelnen Ort innerhalb des
3D-Systems.
Die WELTKORDINATEN (Koordinaten in Bezug auf die Welt) eines Objekts sind
einfach seine Koordinaten in diesem Achsensystem. Mit anderen Worten, die
WELTKORDINATEN repräsentieren die Welt, die wir erschaffen.

GRUNDLAGEN:

Es gibt 3 Hauptschritte, um das Objekt einmal auf dem Bildschirm zu generieren
wenn wir unsere WELTKORDINATEN der verschiedenen Objekte haben:

1:	Weltkoordinaten - Wahre Form eines Objekts

2:	Koordinaten anzeigen - Die Koordinaten des
    Objekts nach jeder Rotation oder Translation.

3:	Koordinaten anzeigen (projizierte Koordinaten) - Die Koordinaten des
 Bildschirms repräsentatieren das Objekt, nachdem die 3D-Koordinaten angezeigt
 (konvertiert) sind, perspektivisch von 3d nach 2d (weil der Monitor 2 Größen
 hat!).
 
4: Zeichnen Sie das Objekt gemäß den in 2D transformierten Koordinaten.

Während der Lektion werden die Objekte als "Flächen" oder "Pläne"
betrachtet. (Beachten Sie, dass ich "planes" nicht als unendliche Flächen
meine!) So hat beispielsweise ein Würfel 6 Flächen.

Diese polygonalen Flächen können durch Verbinden der Koordinatengruppen
von Objekten "zusammengeklebt" oder "zusammengefügt" werden, um
komplexe Objekte wie ein Hubschrauber oder eine Kathedrale (Well ..) zu bilden.

Eine Ebene (Fläche), die nur von einer Seite gesehen werden kann, und derzeit 
versteckt ist, heißt es HIDDEN surface. Das Ausarbeiten, Herausfinden, welche
Flächen sichtbar und welche VERSTECKT sind ist eine der Hauptaufgaben der
komplexesten 3D-Routinen von FILLED VECTORS, das heißt, Festkörper mit
"gefüllten" Flächen.
Infolgedessen wurden viele Methoden erfunden, um verborgene Flächen zu finden,
sogar Spezialisierung der Routinen für bestimmte Arten von Objekten.
Dies natürlich im Namen der Höchstgeschwindigkeit.
Wir werden jedoch mit den 3D-Routinen in WIREFRAME beginnen, die wir übersetzen
könnten als "FIL DI FERRO", bei dem der Körper nur aus Linien besteht, damit
sie sichtbar sind wie sogar versteckte Linien. Dies erleichtert jedoch den
Einstieg.

HANDHABUNG:

Wie bereits gesagt, um unser Objekt bei den VIEW COORDINATES zu sehen, das
heißt zu den Koordinaten von Vista müssen wir Koordinaten nach verschiedenen
Winkeln verschieben und drehen (oder der Körper steht dort, die
Bewegung ist schön in 3D!).
Nun, die allgemeinen Formeln zum Transformieren der Koordinate WORLD (d.h.
unseres "statischen" Objekts in den VIEW-Koordinaten (auf verschiedene
Arten gedreht) ist:

----------------------------------------------------------------------------

;ROTAZIONI: Winkel r1,r2,r3
;			Koordinate x,y,z
; xa,ya,za  temporäre Variablen

xa=cos(r1)*x-sin(r1)*z
za=sin(r1)*x+cos(r1)*z
x=cos(r2)*xa+sin(r2)*y
ya=cos(r2)*y-sin(r2)*xa
z=cos(r3)*za-sin(r3)*ya
y=sin(r3)*za+cos(r3)*ya

----------------------------------------------------------------------------

;TRANSLATION: Variablen der Translation mx,my,mz
x=x+mx
y=y+my
z=z+mz

(EINFACH!!! Einfach hinzufügen mx zu x, my zu y und mz zu z!)

----------------------------------------------------------------------------

;PROIEZIONE:  d = Bildschirmabstand
;     scx,scy = Bildschirmmitte (Beispiel: 160,128 für 320 * 256-Bildschirm)
sx=(d*x/z)+scx
sy=(d*y/z)+scy

----------------------------------------------------------------------------

Ich hoffe, niemand gerät in Panik, ich gebe zu, dass es diejenigen gibt, die
Trigonometrie und Mathe im Allgemeinen hassen, aber wenden Sie einfach die
Formeln an und sonst nichts !

Die erste Manipulation ist die Rotation - unter Berücksichtigung des
Rollens, die Höhe und das Gieren des Objekts. (Aber sind wir in Italien?)

Für ROLLEN
; Ich meine die Drehung wie die eines Rades, von der Seite eines gesehen
; Maschine oder eine Drehung wie eine Scheibe, die den Plattenteller von
  oben sieht)
Scheiße alles falsch (ROLLER-Achse - d.h.
Luftfahrt ist die Drehbewegung des Flugzeugs um die X-Achse, sagte
ROLL-Achse in der kartesischen Triade der Körperachsen.
oder bei Schiffen die Schwingung um eine Längsachse, also das Schiff
neigt sich nach links und rechts.


Für PITCH meinen wir "Steigung", "Neigung" (Peck-Achse) im Navi ist es die
oszillierende Bewegung um seine Querachse mit abwechselndes Absenken von Bug
und Heck. Kurz gesagt, das Schiff rutscht die "Nase" d.h. der Bug unter
Wasser und die Propeller auf der anderen Seite (achtern) treten aus.


	PICK!								 PICK!

	   |\								   /|
	   | \								  / |
	   |  \								 /  /
	    \  \_						   _/  /
	-- - \  \/ - - - - - - 		- - - \/  /- - - - - 
	      \  \						  /  /
	       \  \						 /  /
		\  \					 ---
		 \---

Für YAW meinen wir einen Begriff aus der Luftfahrt, nicht weniger als "das
Gieren" die Drehung eines Flugzeugs um die Achse senkrecht zur Ebene
identifiziert durch die Nick- und Rollachse und durch den Schwerpunkt
des Flugzeugs selbst. (Z ??)

R1 entspricht der Drehung des Objekts um eine vertikale Achse (Y)

R2 in Bezug auf eine Achse, die so platziert ist, als hätten wir Pinocchios
   Nase von denen wir nur einen Punkt sehen, da er sich bei 90° (Z) von uns
   wegbewegt.

R3 in Bezug auf eine horizontale Achse (X)

Die Translation ist ziemlich selbsterklärend, da sie einfach aus dem
Hinzufügen einer festen Menge zu den verschiedenen Koordinaten besteht.

Die Projektionsformeln werden von ähnlichen Dreiecken abgeleitet,
vorausgesetzt, dass ein 2d (Flachbildschirm) in einem Abstand d zwischen
Ihnen und dem Objekt platziert wurde. Das Bild kann unter Berücksichtigung von
zwei Dreiecken mit demselben Winkel, einer für die x-Koordinate und einer
für y berechnet werden.

Beachten Sie, dass wenn d nicht richtig zugeordnet ist, das Bild des Objekts
verzerrt erscheint - das Objekt erscheint zu flach und auch nicht '3d'
im gegenteiligen Fall zu verzerrt.
Dies ist darauf zurückzuführen, dass versucht wird, einen zu großen Teil des
Objektes auf dem Bildschirm anzuzeigen - vergleichen Sie dies mit dem zu Fuß
Gehen von einem Glockenturm oder einem Wolkenkratzer: Wenn Sie zu nahe sind,
können Sie nicht die ganze Konstruktion sehen. Um alle Konstruktionen (Objekte)
zu sehen, sollten Sie Schritte zurücktreten und etwas weggehen.
In ähnlicher Weise ist die Winkelverzerrung auf dem Bildschirm auf die Tatsache
zurückzuführen, dass auch versucht wird anzuzeigen, was Sie auf Ihrem
Bildschirm nicht sehen würden, die Entfernung vom Objekt!
Glücklicherweise ist dieser Wert nicht besonders kritisch - er reicht gerade
aus. Versuchen Sie, ihn zu ändern, bis Sie eine akzeptable "Ansicht" finden.

; hier, um Beispiele für WIREFRAME zu laden...

Jetzt können wir eine Reihe von Punkten auf dem Bildschirm platzieren
um unser Objekt in 3d darzustellen, verbinden Sie diese Punkte mit einigen
Linien, die eine WIREFRAME-Ansicht dieses Objekts bilden.
Obwohl die Darstellung dreidimensional korrekt ist, ist sie nicht gut um
besonders komplizierte Objekte darzustellen, da Sie nicht versteht
welche Punkte vorne und welche hinten sind, weil uns Informationen 
zur Tiefe des Bildes fehlen. Wir müssen die versteckten Linien loswerden
um unser Objekt nicht transparent zu machen.

*******************************************************************************

VERSTECKTE OBERFLÄCHEN (HIDDEN SURFACES):

Zuerst machen wir wireframe, nur Linien, aber mit versteckten Oberflächen...


*******************************************************************************

VERSTECKTE OBERFLÄCHEN und FESTE FÄCHEN (FILLED VECTORS):

Offensichtlich müssen wir unser Objekt "füllen", um einen Körper zu erzeugen
der wirklich ein "festes" Aussehen hat.
Um dies zu tun, müssen wir sicherstellen, dass, wenn wir die Flächen ausfüllen
Beschränken Sie sich darauf, nur die richtigen Flächen zu füllen, d.h. diese
VORNE, SICHTBAR, wir wollen sicher nicht das "Hinten" eines Würfels sehen
Sie schauen auf ihre "Front".

Ich werde zwei Methoden zur realistischen Darstellung "gefüllter" 3D-Objekte
beschreiben: die Vektoren CONVEX und ICONVEX

1) ENTFERNEN DER HINTEREN FLÄCHEN. (CONVEX VECTORS)

Diese Methode funktioniert nur bei CONVEX-Objekten.
Ein CONVEX-Objekt ist eines, bei dem eine Oberfläche nicht teilweise von
einem anderen verdeckt sein kann.
Beispiele: Polyeder, Würfel, Tetraeder, Prismen und sogar eine Art "Raumschiff"
nicht zu kompliziert.
Das Definieren eines konvexen Objekts bietet uns einen Ausgangspunkt - 
Wir können einfach die Flächen vor uns zeichnen und ignorieren
den Rest, solange sie vollständig vor der Definition verborgen sein müssen.

Es ist möglich zu berechnen, ob sich eine flache Ebene vor uns befindet, indem
Sie den "normalen" Vektor zu dieser Ebene berechnen, und sehen, ob es eine
positive oder negative Z-Komponente hat.

Ein "normaler" Vektor zu einem anderen ist einfach ein Vektor, der "herauskommt"
von der Ebene senkrecht zu seiner Oberfläche (oder Fläche).
"NORMAL" kann auch als senkrecht mit 90° definiert werden ...
Zum Beispiel kann man in Bezug auf ein Tischbein eines Tisches sagen, dass er
"normal" zum Tisch ist, weil er (zumindest hoffentlich) zur flachen 
oberen Tischplatte senkrecht ist, der vielleicht auch ausgelegt ist.

Es gibt jedoch eine bessere Methode. Berücksichtigen Sie die Ausrichtung der
Punkte am Oberflächenrand ...
Stellen Sie sich vor, Sie nummerieren die Ecken einer Scheibe gegen den
Uhrzeigersinn, um seinen Rand.
Drehen Sie nun die Diskette um und sehen Sie sich die Reihenfolge der Zahlen
an: Jetzt sind sie in stündlicher Reihenfolge!
Mit dieser Ordnungsänderung können wir entscheiden, in welche Richtung
er zur Fläche zeigt.

Bei drei Anzahlen von Punkten und Koordinaten ist es möglich, ihre Reihenfolge
abzuleiten:

; Orientierung:	p1,p2,p3 - Punkte der Fläche (2D-Koordinaten!)
;		        v1,v1 - temporäre 2d Vektoren für p1>p2 und p2>p3

v1.x=p2.x-p1.x		
v1.y=p2.y-p1.y	

v2.x=p3.x-p2.x
v2.y=p3.y-p2.y
Orientierung = Zeichen(v1.x*v2.y-v1.y*v2.x)

; Die Orientierung beträgt +/- 1 in Bezug auf die Orientierung.
; Das Kreuzprodukt des 2d-Vektors ist schneller als ein normaler 3d-Vektor.
; weil weniger Multiplikationen für die Berechnung ausreichen

Um unser FILLED CONVEX VECTOR OBJECT zu entwerfen, transformieren wir die
Objekt-Koordinaten wie beschrieben, und dann zeichnen wir nur die Polygone im
Uhrzeigersinn, unter Verwendung einer Liste von Punkten, die in unserem Objekt
definiert sind.
Solange wir sicher sind, dass alle Polygone Punktnummern haben, so dass wenn
das Polygon sichtbar ist, sie sich im Uhrzeigersinn befinden und das Objekt
vollständig konvex ist werden wir keine Probleme haben.

An diesem Punkt bleibt nur noch das Laden der Quelle v_convex.s, die eine Routine
mit konvexer Vektorbasis ist. Die Quelle enthält genügend Kommentare.


*******************************************************************************

2) der Farbalgorithmus "PAINTER". (INCONVEX-VEKTOREN)

Der Name dieser Technik erklärt alles.
Die Idee ist, dass ein Maler beim Malen vom Hintergrund ausgeht von seiner
Szene, mit den Bergen, dann allmählich die verschiedenen Ebenen zeichnet.
Ich zeichne und bewege mich vorwärts, bis ich die nächsten Dinge zeichne.
Also wird nichts, was vor anderen Dingen steht, abgedeckt. Es werden nur die 
tatsächlich abgedeckten Dinge abgedeckt und es ergibt das richtige Bild.
Diese Idee lässt sich leicht auf unser 3D-System anwenden.
Wir filtern alle versteckten Ebenen nach ihrer Ausrichtung heraus (wie oben),
und dann zeichnen wir sie alle in der Reihenfolge vom Negativsten als
Z-Koordinate zu denen, die Z = 0 am nächsten sind.
Die negativen Z-Koordinaten liegen vor dem Beobachter, also vor uns. In Z = 0
befindet sich der Beobachter. Die positiven Z-Koordinaten liegen hinter dem
Beobachter und wie Sie wissen, können Sie die Dinge hinter sich nicht sehen !!!

Wie können wir das in der Praxis tun?

Nun, wenn wir ein plane (eine Fläche) betrachten, und wir entschieden haben,
dass sie sichtbar ist, wenn sie richtig ausgerichtet ist, finden wir heraus,
wie weit sie in der Szene ist, d.h. seine Tiefe.
Es gibt verschiedene Möglichkeiten, dies zu tun, aber aus Gründen werde ich es
weiter hinten erklären. Wir können nur den Durchschnitt der Z-Koordinate des
Winkels der Fläche (oder der Ebene) berechnen.
Dann setzen wir diesen Wert und einen Zeiger auf die Flächendefinition in einer
Tabelle (oder Array, kurz eine Tabelle).
Wir werden dies für jede Fläche (oder jede Ebene) tun, dann sortieren wir die
Tabelle (oder Array) in der Reihenfolge vom negativsten Z-Mittelwert bis zum
nächstgelegenen Wert von 0.
An dieser Stelle nehmen wir einfach die Werte aus dem Array (aus der TABELLE)
und zeichnen Sie die Flächen in der Reihenfolge der Tabelle.

Wenn Sie jedoch die konvexe Quelle gesehen haben, werden Sie feststellen, dass
die Flächen direkt über dem 'was zuerst gemacht wird' gezeichnet sind - dies
ist im konvexen Fall in Ordnung, weil eine Fläche nie darüber kommt!

Im INCONVEX-Fall können sich die Flächen jedoch überlappen der "Maler" -
Algorithmus und die Tiefenordnung (SORT).
Wir können einfach unsere Flächen in einen temporären Puffer zeichnen, und
"Ausschneiden + Kopieren" Sie sie mit dem Blitter (Cookie Cut) auf dem
Bildschirm. (Natürlich "doppelt gepuffert"!).

Um einen ICONVEX-Vektor tatsächlich zu sehen, lautet die Quelle v_inconvex.s.

Es wurde zuvor gesagt, dass nur der Mittelwert jeder Z-Koordinate genommen wird
und die Winkel der Flächen erzeugen anständige Tiefen.
Der Grund für die Verwendung dieser Methode anstelle des Satzes von Pythagoras:
Berechnen Sie x^2+y^2+z^2 (vergessen Sie die Wurzel) und nehmen Sie den
Durchschnitt. Es ist nur so, dass ich nicht denke, dass die "Anstrengung"
notwendig ist.
Der "Maler" -Algorithmus hat einen Nachteil: Er zieht folgende Tatsache nicht
in Betracht, Bedenken sie, dass sich eine Fläche über ein beträchtlichen
Bereich von Z-Werten erstrecken kann, wodurch er nur mit einem Nicht-Mittelwert
dargestellt wird gibt ein wahres Bild der Situation.
Dieses Problem kann gelöst werden, Sie sollten vorsichtig sein bei
zu großen Böden, bei zu ausgedehnten Flächen, die sie vielleicht in zwei
Teile teilen sollten, oder berücksichtigen sie auch die minimalen und
maximalen Z-Werte


*******************************************************************************

Mehrere Objekte:

Vor nicht allzu langer Zeit gab es in der Demoszene eine große Aufregung
darüber in der Lage zu sein, eine große Anzahl von unabhängigen Objekten mit
einmal anzuzeigen... so wurde die "wie viele Würfelszene" geboren und so
weiter, das heißt ja sie traten gegeneinander an, indem er Bildschirme
voller Würfel präsentierte, und wer auch immer sie hineinlegte, gewann
eine weitere, die sich dann oft als animiertes Sprite herausstellte (HAHAHAHA!)
Dies ist jedoch nicht das Schwierigste. Sie müssen nur einige Anordnungen
von Code tun, die für ein einzelnes Objekt geeignet sind und es modifizieren.

Was getan werden muss, um alle Objekte zu positionieren und zu drehen, ist,
Sie müssen eine Tabelle mit "benutzerdefinierten" Informationen haben, aber
die "Engine" die alles bewegt ist gleich.
Wichtig ist eine schnelle und leistungsstarke SORT-Routine (Sortierroutine)
der Tiefe, die sich darum kümmert, nur das zu zeichnen, was benötigt wird.
Darüber hinaus müssen Sie viele Tabellen und Strukturen erstellen, die die
Definitionen aller Objekte enthalten.

*******************************************************************************

Linien/Bob:

Um die VECTORBALLS zu implementieren, müssen wir nur die Koordinaten wie bei
Flächen sortiert setzen, sortieren Sie ihre Z-Werte mit einer SORT-Routine.
Zeichnen Sie dann die Szene mit den Bobs in der richtigen Tiefe.
Bitmaps für Bobs können einfach mit dem Blitter "Cookie Cut" auf dem
Bildschirm kopiert werden.

Linien können einfach eingefügt werden, indem der Durchschnitt der Linien
berechnet wird Z-Koordinaten (alle 2) und dann Einfügen dieses Mittelwerts
als Zeiger auf die Linienstruktur in der Tiefentabelle (DEPTH ARRAY), und
ähnlich wie beim Bob vorgehen.

Übrigens könnte es hilfreich sein, eine Art Marker zur Identifikation
dieser Definitionen von Linie / Bob / Ebene anzubringen, damit 
wenn wir durch die geordneten Tiefen springen, wenn der Code aufgelistet wird,
verstehen womit wir es zu tun hat (eine Linie oder ein Bob ..)

*******************************************************************************

SCHATTEN (SHADING):

METHODE DES "BILDSCHIRMS" ODER "PUNKTE" EINIGER FLÄCHEN
Um die gepunkteten Farben anzuzeigen, müssen wir die Farbe der benachbarten
Pixel ändern... Dazu können wir eine Maske im Speicher zuweisen
(01010101010 usw.) und diese verwenden, um die Flächen herunterzuwerfen.
Was wir tun können, ist die beiden Farben zu überprüfen, die wir für den 
Punkt verwenden werden und das Bitpaar für die jede jeweilige Bitebene.
Wenn beide auf 1 gesetzt sind, bedeutet dies, dass wir für diese Bitplane
unser Fläche wie gewohnt ausschlagen müssen (Cookie mit unserer Fläche
gezeichnet mit seiner eigenen Maske).
Wenn beide zurückgesetzt werden, machen wir dasselbe und löschen
den Bereich des Bildschirms, in dem sich die Fläche befindet.
Wenn sie unterschiedlich sind (zB Farbe 1 gesetzt und Farbe 2 nicht), kopieren
wir mit dem "Cookie" Flächen-Blitter, aber benutzen die Maske 010101 als 
unsere Quellebene und sehen es als Maske an.
Dies senkt die Bits in der Reihenfolge 010101, in der sich die Ebene auf dem
Bildschirm befindet.
Wenn die andere mögliche Situation eintritt, setzen Sie Farbe1 zurückgesetzt
und Farbe2 gesetzt, müssen wir eine Maske verwenden, die mit 1010 beginnt ...
Dazu verwenden wir den Blitter auf andere Weise, indem wir die Maske umkehren.

Diese Methode ist zwar schnell, hat jedoch den Nachteil, dass Tonnen von 
Speicher für die Maske verwendet werden, die die gleiche Größe haben muss wie
die Bitplane oder zumindest wie die größte Fläche, die Sie anzeigen möchten.
Um dies zu vermeiden, können Sie den Blitter-Kanal durch deaktivieren
welche Daten 1010 übergeben. Auf diese Weise können Sie sie einfach 
diese alternierenden Werte im Register BLTxDAT legen.
Jetzt werden jedoch zwei Blittings pro Bitplane benötigt, da nur eine Zeile
vorhanden ist. Alle 2 verwenden dieselbe Maske:

Linie1: 10101010 \
Linie2: 01010101 | Nur die Masken für die Zeilen 1,3,5 .. sind gleich.
Linie3: 10101010 / Die Zeilen 2,4,6 .. sind umgekehrt.

Nämlich: Blitte jede gerade Linie der Fläche, kehre den Wert von BLTxDAT um,
mache die übersprungenen Zeilen auf der ersten Blittata (ungerade!) ...
Dies beinhaltet die Verwendung der halben Höhe für BLTSIZE und das Hinzufügen
zum Blitter von Modulo-Werte, sodass nur eine von zwei Zeilen berührt wird.

*******************************************************************************

LICHTQUELLE (LIGHT SOURCING):

Das "Light Sourcing" besteht darin, sicherzustellen, dass die Farben der
Flächen die Reflexion der Lichtquelle auf ihnen repräsentieren.
Zwei Methoden werden häufig verwendet:

Nur Z-Wert - Dies besteht einfach darin, die am nächsten zum Betrachter mit der
hellsten Farbe zu zeichnen, während die am weitesten weg mit dunklere Farben.
Es ist einfach, da es ausreicht, den Z-Wert als Abstand zu verwenden, aber aus 
illusionistischer Sicht nicht der überzeugendste Weg. Dies kann vollständig
durch Mitteln der Z-Koordinaten der Flächen erfolgen. Implementieren Sie
einfach eine Tabelle mit den Farben gemäß den Werten Z oder auf andere Wege.
(Zum Beispiel kann die Farbe mit z / 128 berechnet werden, was der Abstand
geteilt durch 128 ist, wenn die erzeugte Farbe ein gültiges RGB ist).

Lamberts Cosinus-Regel - Diese kleine Regel gibt die Menge des von einer
Oberfläche reflektierten Lichts an, sie folgt dem Kosinus des Winkels zwischen
der Oberflächennormalen und der Richtung des reflektierten Strahls.
Um langwierige Erklärungen zu vermeiden, ist hier einfach die Methode:

Berechnen Sie die Oberflächennormale.

Sie wird berechnet, indem zwei Vektoren auf der Oberfläche gefunden und die
Normalen erhalten werden durch das Kreuzprodukt der 2 Vektoren. 
Die beiden Vektoren können von einem der 3 Punkte der Fläche kommen -
Also a=p2-p1, b=p3-p1 Dabei sind p1-3 die xyz-Koordinaten von drei Punkten
der Fläche. a-b sind Vektoren.

Das Normal ist gegeben durch: a*b= (a2*b3-a3*b2,a3*b1-a1*b3,a1*b2-a2*b1)

Der "normale" Vektor muss durch Teilen von seinem Modulo zu einem
Einheitsvektor reduziert werden... Ebenso muss der Vektor vom Beobachter
zur Ebene in einen Einheitsvektor verwandelt werden.

Der Kosinus des Winkels zwischen diesen beiden Einheitsvektoren ist jetzt
einfach das "Punkt" -Produkt oder "*" -Produkt von ihnen
Das bedeutet a1*b1+a2*b2+a3*b3

Dieser Wert liegt zwischen 0 und 1 (daher hier arithmetischer Fixpunkt)
gibt den Beleuchtungsfaktor der Oberfläche an, dann ihre Farbe mit
einer Methode ähnlich der Technik des Z-Wertes allein.

*******************************************************************************

"FLEXIBLE" oder "JELLY" VEKTOREN (FLEXY, JELLY & RUBBER VECTORS):

Einige Demos haben Vektoren, die sich "biegen", als wären sie aus Gummi 
(rubber) oder Gelee (jelly) gemacht.
Das "Verdrehen" unserer 3D-Vektoren ist nicht so komplex, wie es scheint, da
die Verformung häufig mit beiden einfachen horizontalen Wackeln durch die
BPLCON2 ($dff102) wiederholt in jeder copper line erfolgt, beide im Modus
analog zu einem Sinusroller, wobei der Vektor "richtig" in einen Puffer
gezeichnet wird und in Streifen geblittet wird, damit es schwankt.
Wenn wir dann diese beiden Methoden kombinieren, wird es noch mehr scheinen.
Es gibt jedoch viele Möglichkeiten, diese Festkörper wie Gelatine "erscheinen"
zu lassen, aber meistens handelt es sich entweder um vorberechnete oder zu
90% falsche Effekte.
Es würde ein Ray-Tracing-Programm wie Real3d oder Imagine erfordern, um es 
echt zu erstellen oder einige von Ihnen, wenn Sie Genies sind.

*******************************************************************************

STENCIL VECTORS (verzierter Schablonenvektor"):

Um die Flächen mit einem geometrischen Muster zu dekorieren, muss eine ähnliche
Technik durch Dithering / Interpunktion zu schattieren angewendet werden.
Beachten Sie, dass die Grafiken auf den Flächen der STENCIL VECTORS prospektiv
nicht verzerrt sind, aber sie bleiben "stationär" auf den sich bewegenden
Flächen.
Im Speicher müssen wir ein sich wiederholendes oder eher wiederholbares
grafisches Muster haben ähnlich wie die Fliesen eines Badezimmers oder vielmehr
eines Mosaiks.
Wenn wir die Flächen ablegen, müssen wir diese Bitebenen als Grafik-Quelle
verwenden anstelle der Fläche im temporären Puffer. Wir werden dann einen
anderen temporärer Puffer für eine Maske (wie üblich) verwenden.
Um zu vermeiden, dass sich zu große Raw-Grafiken im Speicher befinden, können
Sie dies tun. Führen Sie den "Cookie" -Kopiervorgang mit dem Blitter in
kleineren Stücken aus, kurz gesagt durch Aufteilen der Transaktion "in Raten".

*******************************************************************************

WRAPPED-Vektoren auf den Flächen anderer Vektoren:

Diese Vektoren sind normalerweise Würfel, die eine Art von "Monitor" auf einer
oder mehreren Flächen haben, auf dem sich ein anderer Vektor dreht, und es
kann in dem Vektor einen anderen Vektor auf der Fläche des Vektors im Vektor
geben.
Ein beispielhafter italienischer Fall ist die Demo "TRIPLE HERMAPHRODITE CUBE"
von DIVINA programmiert von LUYZ, es zeigt einen Lichtquellenwürfel mit einer
"Monitor" -Fläche mit einem anderen Würfel, auf dessen einer Seite sich ein
weiterer "Monitor" befindet, ein Würfel, ebenfalls aus Lichtquellen.

*******************************************************************************

OPTIMIERUNG:

Wenn Sie v_convex.s und v_iconvex.s untersuchen, haben Sie einige Optimierungen
festgestellt.

-Reinigen oder blitten Sie nur einen Teil des Bildschirms oder des temporären
 Puffers. Klingt offensichtlich und wahr, aber um dies zu tun, schauen wir uns
 ein "Fenster" an, das aus minimalen und maximalen x / y-Koordinaten besteht,
 also kopieren / bereinigen wir nur die minimal benötigte Anzahl von Wörtern.

-Sperren Sie den Prozessor jedoch nicht in einen WaiBlit-Wartezyklus für Blitter
 es ist nicht wirklich notwendig. Die CPU und der BLITTER können zur selben
 Zeit arbeiten, dann stoppen sie die CPU in einer Schleife, um auf den Blitter
 zu warten, wenn die CPU den gleichen Job wie der Blitter ausführen könnte oder
 andere Berechnungen und Gaunereien.
 Es ist notwendig, nur auf das Ende des Blitts zu warten, bevor Sie einen
 weiteren Blitt machen. Sie sollten allerdings auch die Routinen so
 organisieren, dass der Blitter arbeitet, wenn der Prozessor Multiplikation und
 Division durchführt. Dies ist sehr wichtig, damit sie vermeiden, dass der
 Prozessor auf nichts wartet.
 Sie können einen Interrupt nutzen, der bei Bedarf den Blitt auslöst.
 Ein einfaches Beispiel für die Optimierung ist das Löschen des Bildschirms.
 Anstatt nur den Blitter zu verwenden, können Sie die Hälfte mit dem Blitter
 und die andere Hälfte mit dem Prozessor in "Multitasking" reinigen. Das
 Gleichgewicht der Arbeit zwischen den CPUs und dem Blitter ist sehr wichtig.
 Auf 68020+ Prozessoren zahlt es sich aus. Lassen Sie den Prozessor fast alles
 tun, aber auf dem 68000 bleibt das Problem bestehen.

-Ein anderes Beispiel ist die Extrusion. Extrusion ist das, was mit der
 Zahnpasta passiert, wenn die Tube zusammengedrückt wird: sie kommt mit der
 Form der Röhre selbst heraus. Wenn die Röhre ein Stern ist, kommt ein
 Sternkörper heraus, wenn es ein Kreis ist, sind es Zylinder usw.
 In Bezug auf Vektoren bedeutet dies, dass wir einen konstanten Querschnitt
 in einem Objekt haben. Dies bedeutet auch, dass die Punkte an jedem Ende des
 Objekts alle durch einen gemeinsamen Vektor verbunden sind.
 Um die Berechnung vieler Punkte zu speichern, kann nur ein Ende berechnet
 werden, und dieser gemeinsame Vektor.
 Um dann die Koordinaten am anderen Ende zu generieren, fügen Sie diese einfach 
 dem Vektor mit den Koordinaten der Punkte am anderen Ende hinzu.

- Sortieren Sie die Tiefe. Wenn die Szene komplex ist, wird die SORT-Routine
 entscheidend für die Gesamtgeschwindigkeit sein

*******************************************************************************

CLIPPING:

In einigen Fällen müssen Sie auch Linien auf dem Bildschirm zeichnen, die 
die Koordinaten "out of it" haben, zum Beispiel, wenn wir sehr nahe 
zu einem Objekt kommen und einigen seiner Teile "vom Bildschirm" kommen.
Quelle laden "polygon clipper"...
Es können verschiedene Methoden verwendet werden, die sich normalerweise mit
den Flächen überschneiden
Ich lasse den Autoren die Freiheit, darüber nachzudenken.

Landschaften (LANDSCAPE):

Nun ... ich weiß nicht wie...

*******************************************************************************

Verweise:

Wenn Sie diese Bücher finden und verrückt sind, können Sie sie studieren:

COMPUTER GRAPHICS - Steven Harrington. ISBN 0-07-100472-6
			Sehr genaue Behandlung von Grafiktechniken
			sowohl 2d als auch 3d, SEHR TECHNISCH (Hallo Anfänger!)
			und nicht spezifisch für Amiga, daher eine "abstrakte"
			Behandlung von 2d-3d Grafiken.
			Wenn Sie Dinge für die virtuelle Realität 
			basierend auf A4000 Turbo entwerfen möchten ...

Dank an:

Insbesondere die Autoren von ACC (Amiga Coders Club)

	Paul Kent

*******************************************************************************
*	2. Datei 3D-GFX															  *	
*******************************************************************************

   ************************************************************************
 ****************************************************************************
************                                                      ************
**********            aLGORITHMEN und aNWENDUNGENSTECHNIKEN          **********
**********				fÜR dIE rEALISIERUNG vON eNGINES			 **********
**********				  fÜR 3d gRAFIKEN mIT cOMPUTERN              **********
************                                                      ************
 ****************************************************************************
   ************************************************************************

	Realisiert von    :  -+- Cristiano Tagliamonte -+- Aceman/BSD -+-

	Letzte Überarbeitung :  29 September 1996


				    !     !
		      _..-/\        |\___/|        /\-.._
		   ./||||||\\.      |||||||      .//||||||\.
		./||||||||||\\|..   |||||||   ..|//||||||||||\.
	     ./||||||||||||||\||||||||||||||||||||/|||||||||||||\.
	   ./|||||||||||||||||||||||||||||||||||||||||||||||||||||\.
	  /|||||||||||||||||||||||||||||||||||||||||||||||||||||||||\
	 '|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||`
	'||||'     `|||||/'   ``\|||||||||||||/''   `\||||||'     `|||`
	|/'          `\|/         \!|||||||!/         \|/'          `\|
	V              V            \|||||/            V              V
	`              `             \|||/             '              '
				      \./
				       V


				Inhalt					
==========================================================================

	       °    Einführung
	       °    Vektoren
	       °    Perspektive
	       °    Rotation
	       °    Optimierung von Rotationen
	       °    Wireframe
	       °    Hidden face
	       °    Filled vector und scan line
	       °    Flat shading
	       °    Optimierungen zur Berechnung der Lichtquelle
	       °    Gouraud shading
	       °    Phong shading
	       °    Reflection mapping
	       °    Texture mapping
	       °    Free direction texture mapping
	       °    Texture mapping bilinear
	       °    Texture mapping biquadrat
	       °    Bump mapping
	       °    Clipping 2D
	       °    Optimierungen zum Füllen
	       °    Anhang A: Festpunktnotation
	       °    Anhang B: Polarkoordinaten
	       °    Anhang C: Objektverwaltung
	       °    Schlussbemerkung


				eINFÜHRUNG
==========================================================================

Dieser kurze Text soll diejenigen helfen, die die mühsame und faszinierende
Reise zur Programmierung einer 3D-Grafik-Engine unternehmen wollen. Zuerst 
um die Grundkonzepte zu entdecken und später die mehr ansprechenden komplexen
und spektakulären erreichbaren Effekte.
Mit dem Begriff "engine" wird ein Satz an Routinen für die Verwaltung und
Bearbeitung von spezifischen Daten bezeichent, die, sobald sie richtig
verarbeitet wurden, als Ergebnis die Visualisierung der 3D-Umgebung in Echtzeit
angeben. Der folgende Text ist nicht als programmierorientierter Kurs zu
3D-Anwendungen gedacht, sondern eher als eine Arbeit, in der einfach die
Konzepte, auf denen viele 3D-Engines basieren zur Verfügung gestellt werden.
Für ein vollständiges Verständnis ist ein Grundwissen der Trigonometrie,
lineare Algebra und eine Programmiersprache (besser wenn nicht
weiterentwickelt) erforderlich.


				vEKTOREN
==========================================================================

Ein Vektor ist nichts anderes als eine Wertemenge mit einer Richtung und
einer Länge oder lebhaft eine Zeile. Im Kontext werden sie immer als
spezifizierte Vektoren kommen, die von einem Koordinatenpunkt (0,0,0)
(dem Ursprung der Achsen) zu einem anderen Punkt (x, y, z) reichen, auf diese
Weise können wir sagen, dass dieser Vektor als Größe (x, y, z) hat. 
	  _
       |  /|               Ein Vektor wird mit einem Buchstaben angezeigt. Das
       | /                 Beispiel in der nächsten Abbildung ist der Vektor
(0,0,0)|/         x        V (x, y, z). Das verwendete Referenzsystem wird
   ----+------------>      durch drei Variablen gegeben, die vorstellbar sind
      /|\                  als einfache senkrechte kartesische Ebenen zur
   z / | \                 z-Achse. Der Einfachheit halber betrachten wir das 
    /  |  \                Wachstum von y nach unten (und nicht in Richtung
       |   \               hoch) um die durchzuführenden Berechnungen zu
       |    \. V           reduzieren um einen Punkt auf dem Bildschirm
      y|                   anzuzeigen. Die z-Achse wächst, wenn sie sich vom
       v                   Beobachter (der stationär ist) wegbewegt, während
						   es abnimmt, wenn es sich dem Betrachter nähert.
Wir werden Vektoren verwenden, um jeden Punkt im Raum zu definieren.
In der Praxis bedeutet dies, dass ein Vektor eine Linie darstellt, die
auf dem Bildschirm angezeigt wird, es bezeichnet das enthaltene imaginäre
Segment zwischen dem Ursprung der Achsen und einem Punkt im Raum.



				pERSPEKTIVE
==========================================================================

Eines der allerersten Probleme, die beim Bau einer 3D-Engine auftreten ist
das Betrachten eines Punktes im Raum auf dem Bildschirm. Tatsächlich enthält
jeder Punkt drei Koordinaten, während wir auf dem Monitor nur eine 
Anordnung von zwei haben: die z-Achse fehlt! Um das Ganze zu lösen
müssen Sie lediglich die Projektion der Punkte in der Ebene berechnen, die
mit dem Bildschirm zusammenfällt, was in Wirklichkeit nichts Komplexes ist. 
Stellen wir uns vor, unser Monitor ist transparent, das heißt, wir können
sehen, was sich darin befindet. Nehmen wir an, es gibt im Inneren einen
Würfel der springt. Dies ist das Bild, das wir auf unserem Bildschirm sehen
würden:
					     ________________________________
					    |                                |
						|                                |
						|             ____               |
						|            /   /\              |
  Bildschirm -->		|           /___/  \             |
						|           \   \  /             |
						|            \___\/              |
						|                                |
						|                                |
						|________________________________|

Wir sehen, dass unser Blick mit der z-Achse und dem Zentrum des Monitors
übereinstimmt. Es fällt mit dem Ursprung der drei Achsen zusammen:

			  + Monitor                    +----------+ Monitor
	  Achse Z |           _                |          |
	<---------|- - - - - ¢_>               |    .     |
			  |         Auge               | (0,0,0)  |
			  +                            +----------+

Nun ist die Situation, in der wir uns von der Seite gesehen sehen, die
folgende:

				(Würfel)
			  ___________________ A
			 |                   |-_      + (Bildschirm)
			 |                   |  -_    |
      A      |                   |    -_  |
      c      |                   |      -_|A'
      h      |                   |        +_    
      s      |                   |        | -_
	  e	     |                   |        |   -_
	     |                   |        |     -_
	  Y		 |                   |        |       -_   _
			 |___________________|B_______|B'_______- ¢_> (Auge)
						   (0,0,0)
						 <---- Achse Z ---->

Auge  = unser Standpunkt (nennen wir es O, es ist nicht der Ursprung!)
A,B   = Punkte im Raum xyz
A',B' = auf den Monitor projizierte Punkte (B' stimmt mit dem Ursprung überein)
AB    = Segment gleich der y-Koordinate von A in drei Dimensionen
A'B'  = Segment gleich der y-Koordinate von A' (weil das von B' = 0)
			      ^^^^^^^^^^^^^^^^^^ y auf den Monitor projiziert!
BO    = Entfernung Beobachter-Punkt
B'O   = Entfernung Beobachter-Bildschirm (Nennen wir es d)

Die Koordinaten auf dem Monitor entsprechen genau denen der projizierten
Punkte, was wir dann berechnen müssen. Es ist zu beachten, dass die Dreiecke
AOB- und A'OB'- insofern ähnlich sind, weil sie einen gemeinsamen Winkel
haben und beide eine Gerade haben, so dass wir folgendes schreiben können.

Proportion:
		A'B'/AB=B'O/BO             das ist gleich...
		A'B'=AB*B'O/BO

Da der Ursprung der xyz-Achsen B' entspricht, ist BB' die Koordinate z
von Punkt A, also BO = BB'+ B'O = z + d. Es ist möglich, willkürlich
die Position des Beobachterbildschirms  festzustellen (es wird empfohlen,
einen Wert zu verwenden gleich 256, auf diese Weise wird es möglich sein,
Multiplikationen durch Ausführen von Linksverschiebung um 8 Bit zu vermeiden).

Die projizierte y-Koordinate (yp), definiert als A'B', ist daher gleich:
 
		yp=d*y/(z+d)     weil  A'B'=yp  AB=y  B'O=d  BO=z+d

Wir haben also die y-Koordinate unseres Punktes auf dem Bildschirm berechnet!
In Bezug auf die Abszisse x ist das Argument analog: Es reicht aus, die
Situation von oben gesehen zu betrachten, wo der Würfel leicht nach rechts
versetzt ist:

				(Würfel)
			  ___________________ A
			 |                   |-_      |(Bildschirm)
			 |                   |  -_    |
      A		 |                   |    -_  |
      c      |                   |      -_|A'
      h      |                   |        +_    
      s      |                   |        | -_
	  e		 |                   |        |   -_
	     |                   |        |     -_
	  X		 |                   |        |       -_   _
		     |___________________|B_______|B'_______- ¢_> (Auge)
						   (0,0,0)
						 <---- Achse Z ---->
		xp=d*x/(z+d)

Um die Unterschiede zwischen Draufsicht und Seitenansicht zu verdeutlichen,
folgen zwei Bilder des gleichen Modells. Die erste Figur ist keine andere als
die Enterprise (das Raumschiff aus dem StarTrek-Film) von der Seite gesehen,
während das zweite von oben zu sehen ist.


 \==================================|                    _=_
  \_________________________________/              ___/==+++==\___
	       """\__      \"""       |======================================/
		     \__    \_          / ..  . _/--===+_____+===--""
			\__   \       _/.  .. _/         `+'
     USS ENTERPRISE      \__ \   __/_______/                      \ /
	NCC-1701          ___-\_\-'---==+____|                  ---==O=-
		    __--+" .    . .        "==_                     / \
		    /  |. .  ..     -------- | \
		    "==+_    .   .  -------- | /          Seitenansicht
			 ""\___  . ..     __=="
			       """"--=--""

					  _____
				      _.-'     `-._
				   .-'  ` || || '  `-.
	 _______________  _      ,'   \\          //  `.
	/               || \    /'  \   _,-----._   /   \
	|_______________||_/   /  \\  ,' \ | | / `.  //  \
	   |    |             _] \   / \  ,---.  / \   // \
	   |     \__,--------/\ `   | \  /     \  / |/   - |
	   )   ,-'       _,-'  |- |\-._ | .---, |  -|   == |
	   || /_____,---' || |_|= ||   `-',--. \|  -| -  ==|
	   |:(==========o=====_|- ||     ( O  )||  -| -  --|
	   || \~~~~~`---._|| | |= ||  _,-.`--' /|  -| -  ==|
	   )   `-.__      `-.  |- |/-'  | `---' |  -|   == |
	   |     /  `--------\/ ,   | /  \     /  \ |\   - |
	 __|____|_______  _    ] /   \ /  `---'  \ /   \\ /
	|               || \   \  //  `._/ | | \_.'  \\  /
	\_______________||_/    \   /    `-----'    \   /
				 `.  //           \\  ,'  Blick von oben
				   `-._   || ||   _,-'
				       `-._____,-'


Es muss berücksichtigt werden, dass im Videofenster die Koordinaten den
Ursprungspunkt oben links haben, während sie für die 3D-> 2D-Transformation
in der Mitte des Monitors betrachtet werden. Um dieses Problem zu lösen, reicht
es aus am Ende der Projektionsberechnungen eine Konstante zu xp und yp 
hinzuzufügen. Dadurch werden die relativen Achsen um eine Anzahl von 
Pixel äquivalent zur Konstante verschoben. Zusammenfassenend: Bei d = 256
entsprechen die projizierten Koordinaten auf den Bildschirm  
von A (x, y, z) bis A' (xp, yp)) :

cx = Bildschirmbreite / 2, um die Abszisse nach rechts zu verschieben
cy = Bildschirmhöhe / 2, um die Ordinate nach unten zu verschieben

	  xp=256*x/(z+256)+cx
	  yp=256*y/(z+256)+cy

Achten Sie darauf, dass die z-Koordinate des Punktes nicht mit dem 
Beobachtungspunkt übereinstimmen kann, da eine Division durch Null auftreten
würde. Die Tiefe eines Punktes sollte auch nicht geringer als die des
Blickpunktes sein: Es wäre absurd, hinter dem Beobachter stehende Punkte
visualisieren zu können!



				rOTATION
==========================================================================

Wir werden uns nur mit Rotationen um die x-, y- und z-Achse befassen. Andere
Formeln von Rotation um eine beliebige Achse sind ableitbar von denen die
wir sehen werden.
Zunächst erklären wir die Bedeutung der Rotation um eine Achse.
Betrachten wir eine analoge Uhr, deren Zeiger sich um die Achse drehen
(durch die Mitte der Uhr) senkrecht zur Uhr selbst:

					   \
						\ ______________
						 X____________ /
						//\   12     // Uhr
					   //  \  /     //
					  //9   \/___ 3//
					 //           //
					//           //
				   //     6     //
				  //___________/X
				 /_____________/ \  imaginäre Achse auf der
								  \ Die Zeiger drehen sich

Technisch sprechen wir von der Drehung eines Punktes auf einer Achse, wenn der
Punkt sich auf der Ebene bewegt, der zum Punkt selbst gehört und senkrecht
zur Achse steht, um den Punkt-Achsen-Abstand nicht zu verändern (der konstant
bleibt). Auf diese Weise bewegt sich der Punkt kreisförmig um die Achse, dh
sie dreht sich um uns herum und der Abstand zwischen Punkt und Achse wirkt als
Radius für den durch die Drehung des betreffenden Punktes beschriebenen Umfang.
Die Drehung um die y-Achse kann man sich als Flugbahn vorstellen. Die Reise
von einem Punkt, der sich um die y-Achse dreht, ohne seine eigene Ordnug zu
ändern, was unverändert bleibt.

Nun wollen wir wirklich sehen, wie man Rotationen macht. Bei Verwendenung eines
Bezugssystems einer zweidimensionale Ebene ist es möglich, die kartesischen 
Koordinaten (x, y) eines Punktes in Polarkoordinaten (r, t) zu konvertieren:

       _ V           V(x,y)=V'(r,t)             _ V'	 r=Distanz
  y|   /|                                   |   /|         Punkt-Nullpunkt
   |  /              r=sqrt(x*x+y*y)        | r/
   | /               t=arctan(y/x)          | /          t=Winkel zwischen
   |/                                       |/) t          dem Vektor und
   +------->         x=r*cos(t)             +------->      der positiven
	x				 y=r*sin(t)                            Halbachse x

Um den Punkt um den Ursprung zu drehen, müssen Sie den Winkel hinzufügen, um 
den Sie den Punkt auf die Variable t drehen möchten und konvertieren sie die
resultierenden Polarkoordinaten in kartesische. Diese Methode fällt zu viel
langsam für Echtzeitanwendungen aus, da es Quadrate gibt, Arkustangens und
Quadratwurzeln, außerdem durch Einführung der Variablen z würde es  mit einem
starken Management der Polarkoordinaten konfrontiert sein
(Verwendung von Dreifachintegralen usw.): Es ist besser, eine andere Lösung
zu finden - schnell und einfach.
Stellen wir uns vor, wir haben einen Vektor mit der Ordinate Null V (x, 0) und
wir wollen es um einen Winkel a drehen:

  y               Vektor				y     _ Vr(xr,yr)   Vektor
    |             zufällig				  |   /|            im Bogenmaß
    |             die Abszisse            |  /              gedreht
    |                                     | /               
    |    V(x,0)                           |/) a
    +----->->                             +------->
	    x                                     x

Wenn wir die Koordinaten von V in polar umwandeln wollten, wäre es r = x
(x=sqr(x*x+0*0)) e t=0 (0=arctan(0/x). Um den Vektor genug zu drehen
addiere zu t den Drehwinkel a. Deshalb:

(V   = Vektor in kartesischen Koordinaten)
(V'  = Vektor in Polarkoordinaten)
(Vr  = gedrehter Vektor Bogenmaß in kartesische Koordinaten)
(Vr' = gedrehter Vektor Bogenmaß in Polarkoordinaten)
(Vxr = Vektor nur mit der x-Komponente in kartesische Koordinaten gedreht)
(Vyr = Vektor nur mit der y-Komponente in kartesische Koordinaten gedreht)

	V(x,y) = V'(r,t)
	Vr(xr,yr) = Vr'(r,t+a)    ->    xr=r*cos(t+a)  yr=r*sin(t+a)
Ersetzen wir xr und yr durch die relativen Formeln:
	Vr(r*cos(t+a),r*sin(t+a)) ->    r=x  t=0
Ersetzen wir r durch x und t durch 0:
	Vxr(x*cos(a),x*sin(a))

Und dies ist die Formel für die Rotation eines Vektors, der die y-Komponente
nicht hat. Betrachten wir nun einen Vektor mit der Nullabszisse V (0, y):

	r=y    (=sqr(0*0+y*y))  
	t=pi/2 (=arctan(y/0)=arctan(infinito))
	Vyr(y*cos(pi/2+a),y*sin(pi/2+a))

Einige trigonometrische Formeln sagen uns:

	cos(pi/2+a)=-sin(a)
	sin(pi/2+a)=cos(pi/2)

aber da wir ein Referenzsystem mit der "invertierten" y-Achse verwenden
müssen wir ein Zeichen in beide Formeln ändern, um sie auszunutzen,
die dann werden:

	cos(pi/2+a)=sin(a)
	sin(pi/2+a)=-cos(a)

Die Formel zum Drehen eines Vektors ohne Komponente x ist nun dieselbe:

	Vyr(y*sin(a),-y*cos(a))

Wenn wir uns aber den allgemeinen Fall ansehen, haben wir einen Vektor V, der
beides hat x- und y-Komponenten. In der Tat ein Vektor mit den Komponenten
x und y entspricht:

	V1(x,0)+V2(0,y)=V(x+0,0+y)=V(x,y)

Jetzt können wir die Einzelfallrotationsformeln zur Berechnung 
des allgemeinen Falls mit einer Addition zwischen Vektoren verwenden:

	Vxr(x*cos(a)         ,x*sin(a)         ) +
	Vyr(        +y*sin(a),        -y*cos(a)) =
	------------------------------------------
	Vr (x*cos(a)+y*sin(a),x*sin(a)-y*cos(a))

Dank dieser Formel ist es möglich, jeden Vektor auf einem zweidimensionalen
Raum zu drehen. In einer 3D-Umgebung fällt die gerade beschriebene Formel
mit der Drehung um die z-Achse zusammen (es gibt keine geänderte z-Koordinate).
Um den Punkt um eine andere Achse zu drehen, lassen Sie ihn einfach 
seine Variable weg und verwenden Sie die anderen im vorherigen Ausdruck,
was zusammengefasst werden kann als:

    um die z-Achse           um die y-Achse           um die x-Achse
  --------------------     --------------------     --------------------
  xr=x*cos(a)+y*sin(a)     xr=x*cos(a)+z*sin(a)     yr=y*cos(a)+z*sin(a)
  yr=x*sin(a)-y*cos(a)     zr=x*sin(a)-z*cos(a)     zr=y*sin(a)-z*cos(a)


			oPTIMIERUNG vON rOTATIONEN
==========================================================================

Gegeben ist ein Drehwinkel für jede Achse (x, y und z) mit den vorherigen
Formeln hätten 12 Multiplikationen benötigt, nur um einen Punkt drehen zu
können. Hier sehen wir, wie man dreht, indem man 9 Multiplikationen
für jeden Punkt durchführt. Betrachten wir:

  ax=Drehwinkel um die Achse x      s1=sin(ax)   c1=cos(ax)
  ay=Drehwinkel um die Achse y      s2=sin(ay)   c2=cos(ay)
  az=Drehwinkel um die Achse z      s3=sin(az)   c3=cos(az)

Jede der Variablen x, y und z wirkt sich auf Rotationen um zwei Achsen aus
(bei der Drehung um die eigene Achse bleibt die Variable unverändert).
Wir können also mit x' y' und z' die teilweise gedrehten Variablen anzeigen
(d.h. nach der ersten Drehung) und mit x'' y'' und z'' die Variablen
voll gedreht. Wie gesagt entsprechen die zuvor gesehenen Formeln:

	x' = x*c1+y*s1
	y' = x*s1-y*c1

	x''= x'*c2+z*s2   <-  x-Koordinate vollständig gedreht
	z' = x'*s2-z*c2

	y''= y'*c3+z'*s3  <-  y-Koordinate vollständig gedreht
	z''= y'*s3-z'*c3  <-  z-Koordinate vollständig gedreht
	
das ist gleichbedeutend mit Schreiben von:

   x''= (x*c1+y*s1)*c2+z*s2=c2*c1 *x + c2*s1 *y + s2 *z

   y''= (x*s1-y*c1)*c3+((x*c1+y*s1)*s2-z*c2)*s3=
	c3*s1 *x - c3*c1 *y + s3*s2*c1 *x + s3*s2*s1 *y - s3*c2 *z=
	(s3*s2*c1+c3*s1) *x + (s3*s2*s1-c3*c1) *y + (-s3*c2) *z

   z''= (x*s1-y*c1)*s3-((x*c1+y*s1)*s2-z*c2)*c3=
	s3*s1 *x - s3*c1 *y - c3*s2*c1 *x - c3*s2*s1 *y + c3*c2 *z=
	(-c3*s2*c1+s3*s1) *x + (-c3*s2*s1-c3*c1) *y + (c3*c2) *z

Aus der letzten Passage jeder dieser Formeln ist ersichtlich, dass teilweise
nicht gedrehte Koordinaten berechnet werden und jede gedrehte Koordinate
die Summe der (nicht gedrehten) Variablen  ist multipliziert für einen 
bestimmten Faktor. Wenn wir diese Faktoren vorberechnen, werden wir in der Lage
sein sie für alle Punkte, die darin in die Richtung gedreht werden müssen zu
verwenden. Auf diese Weise haben wir einfach 9 Multiplikationen durchgeführt
für jeden Punkt (ohne Vorberechnungen der Faktoren).
Grundsätzlich müssen wir zuerst diese Konstanten berechnen:

	xx=c2*c1
	xy=c2*s1
	xz=s2
	yx=c3*s1+s3*s2*c1
	yy=-c3*c1+s3*s2*s1
	yz=-s3*c2
	zx=s3*s1-c3*s2*c1=s2*c1+c3*s1
	zy=-s3*c1-c3*s2*s1=c3*c1-s2*s1
	zz=c3*c2

dann müssen diese Berechnungen für jeden Punkt durchgeführt werden (unter
Verwendung der gleichen Faktoren):

	x''=xx * x + xy * y + xz * z
	y''=yx * x + yy * y + yz * z
	z''=zx * x + zy * y + zz * z

Und wir werden die drei gedrehten Koordinaten erhalten.
Dieser Algorithmus wäre weniger effizient als der vorherige, wenn wenige
Punkte verwendet werden, während im Falle einer hohen Menge von Vektoren 
es möglich ist, erhebliche Einsparungen bei den Berechnungszeiten 
zu erzielen.


				wIREFRAME
==========================================================================

Das Wireframe (Drahtmodell) ist die einfachste und älteste zu reproduzierende
Polygone- Technik. Es besteht einfach aus dem Zeichnen von Linien, die die
Eckpunkte des darzustellenden Polygons verbinden, sonst nichts. Die Verfolgung
von Linien müssen sich mit den projizierten Koordinaten der Punkte entfalten
(und nicht) diejenigen mit drei Variablen xyz).
Lassen Sie uns sehen, wie Sie Linien zeichnen, falls Sie in einer Sprache
programmieren, die diese Funktion nicht direkt ausführen kann (wie C 
und Assembler). Lassen Sie uns den Bresenham-Algorithmus analysieren. Wir haben
zwei Punkte P1 (x1, y1) und P2 (x2, y2) und wir wollen die Linie anzeigen, die
sie verbinden kann:

    P1(x1,y1)
	.------______                                 ^
		     ------______         P2(x2,y2)   | dy
				 ------______.        v
			  dx
	<------------------------------------>

betrachten:
		x2 > x1
		y2 > y1
		dx = x2-x1
		dy = y2-y1
		dx > dy

Alle anderen Linientypen werden von diesem Typ abgeleitet.
Dann berechnen wir diese Werte:

		xl = x1            -> aktuelle Abszisse des Punktes
		yl = y1            -> aktuelle Ordinate des Punktes
		 d = 2*dx-dy       -> Entscheidungsvariable
		d1 = 2*dy          -> erhöht d (wenn d<0)
		d2 = 2*(dy-dx)     -> erhöht d (wenn d=>0)

Schließlich sehen wir den tatsächlichen Algorithmus:

   > Schleife der dx Iterationen
      > zeigt Pixel an der Position an (xl,yl)
      > xl=xl+1
      > wenn d <0 dann:
	 > d=d+d1
      > andernfalls:
	 > d=d+d2
	 > yl=yl+1
   > nächste Iteration

Eine Linie besteht aus einer Reihe von Pixeln. In unserem Fall ist
die Anzahl der Pixel aus der die Linie besteht dx, daher müssen wir eine
Schleife erstellen, die zur richtigen Zeit wiederholt wird in welcher für
jede Iteration es erforderlich ist einen Punkt anzuzeigen.
Aber welche Koordinaten sollte dieser Punkt haben?
Wir geben mit xl und yl die Koordinaten des Punktes an, der auf das Video
projiziert werden soll, was anfänglich mit denen von P1 (x1, y1)
zusammenfällt. Am Ende jeder Iteration erhöhen wir xa und verlassen auf diese
Weise den Zyklus wenn xa  mit x2 zusammenfällt (weil x2 = x1 + dx). Was
passiert mit dem sauberen vom Pixel? Wir erhöhen es einfach, wenn die
Variable d positiv ist.
Es ist auch möglich, einen anderen Algorithmus zum Zeichnen von Linien zu
verwenden, welche oft effizienter als das von Bresenham ist (besonders
wenn in der Assembler gemacht), die das Prinzip der linearen Interpolation 
ausnutzt, wir werden es detaillierter im Abschnitt über das Füllen
und Scanlinie sehen.


				 hIDDEN fACE
==========================================================================

Hiden Face bedeutet versteckte Ansicht. In diesem Absatz werden wir sehen, wie
es gelöscht wird. In Wirklichkeit sind in einem nicht transparenten Feststoff
nicht alle Ansichten aus offensichtlichen Gründen sichtbar. Nur sichtbare
Ansichten auf dem Monitor anzeigen ist sind sicherlich realistischer als sie
alle zu zeichnen.

Der einfachste und intuitivste Algorithmus ist der des "Malers". Besteht aus
Reihenfolge der Flächen, aus denen das Objekt besteht, gemäß der z-Komponente.
Dann müssen die Seitenflächen ab dem am weitesten entfernten gezeichnet werden
bis zum nächsten. Auf diese Weise werden die zuletzt gezeichneten Seitenflächen
sichtbar sein, während die versteckten nicht sichtbar gezeichnet werden.
Zu seinem Nachteil enthält dieser Algorithmus eine schwere Verschwendung von
Maschinenzeit ist es also praktisch unbrauchbar für Grafiken in
Drahtgitter, es erlaubt jedoch jedem Objekt (andere als Drahtgitter),
korrekt angezeigt zu werden.

Eine andere Möglichkeit besteht darin, die Normale (die senkrechte Linie) zu
berechnen. Überprüfen Sie auf jeder Fläche, ob es auf den Betrachter zeigt,
wenn ja zeigen, andernfalls wird es nicht angezeigt. Dieser Algorithmus ist nur
gültig, wenn die Eckpunkte die die Fläche begrenzen, im Uhrzeigersinn 
gespeichert werden. Die Berechnungen, die wir sehen werden, nutzen diese
Funktion. Plus die Objekte, die notwendigerweise konvex sein müssen, dh es
dürfen keine Flächen vorhanden sein, die andere Flächen "verdunkeln" (nicht
verbergen!) können.
Die normale Linie kann als Vektorgröße betrachtet werden, die
im Raum als gemeinsamer Vektor mit drei Komponenten bezeichnet wird.

Die Sichtbarkeit eines Polygons hängt ausschließlich von seiner eigenen 
Ausrichtung entlang der z-Achse ab. Genauer gesagt können wir sagen, dass nur
die Komponente z benötigt wird, um zu wissen, ob das Gesicht verborgen ist oder
nicht.
Betrachten wir unsere Fläche wie folgt:

					Drei Punkte reichen aus, um einen Plan zu identifizieren.
	A(x1,y1)			Folglich, um die Normalen in der Ebene abzuleiten
	 /\					unser Gesicht zusammenfallen wird genug sein
	/  \				die Koordinaten der ersten drei Eckpunkte des Gesichts.
     D /    \ B(x2,y2)  Abgesehen von Demonstrationen ist dies der Fall
       \    /           Es kann angegeben werden, dass die z-Komponente des
	\  /				normal gleichbedeutend ist mit:
	 \/
	C(x3,y3)              (x2-x1)*(y3-y1)-(x3-x1)*(y2-y1)

Wenn das Ergebnis kleiner oder gleich Null ist, wird die Fläche ausgeblendet,
sonst ist sie sichtbar. Um einfach zu wissen, ob diese z-Komponente 
größer oder kleiner als Null ist könnten wir auch projizierte Koordinaten
verwenden, das heißt:

			  (xp2-xp1)*(yp3-yp1)-(xp3-xp1)*(yp2-yp1)

Der beste Weg, um ein konkaves Objekt zu visualisieren, ist das Speichern der
nicht ausgeblendeten Flächen (durch Überprüfen der Ausrichtung der Normalen)
in einem Puffer, sortieren Sie dann die Flächen nach ihrer z-Komponente
und verfolgen sie sie vom weitesten bis zum nächsten.


			fILLED vECTOR und sCANLINE
==========================================================================

Gefüllte Vektoren repräsentieren nichts weiter als "gefüllte" Polygone
bestimmter Farbe. Eine Füllroutine zu erstellen bedeutet, den Inhalt eines 
Polygons durch Kenntnis seiner projizierten Koordinaten Eckpunkte zu färben. 
Stellen wir uns vor, das zu füllende Polygon lautet wie folgt:

|        A|\            Wir könnten folgendermaßen vorgehen:
|         | \           ausgehend von der kleinen y-Koordinate des Polygons
|         |  \          (in diesem Fall das von A) und allmählich ankommen
|         |   \         bis zur letzten vertikalen Position (d.h. y von D)
|         |    \        Wir färben die durch die x-Positionen begrenzte Linie
|         |     \ B     der Seiten in dieser Position y.
|        D \     |
|           \    |      Das Prinzip der Füllung basiert auf der Füllung von
|            \   |      horizontale Linien ab der obersten Reihe
|             \  |      des Polygons bis zum unteren.
|y             \ |
v               \|C     Sehen wir uns ein Beispiel für eine einzelne Zeile an:

|        A|\
|         | \           Wir müssen die in der Abbildung angegebene Zeile
|         |  \          ausfüllen. Wir beginnen mit der x-Koordinate der
|  Zeile  |   \         AD-Seite. Beginnen wir mit dem Färben dieses Punktes.
|   zu -->|****\        Fahren wir mit dem nächsten Punkt fort (d.h. den
| füllen  |     \ B     rechts) und färben ihn auch. Lass uns fortfahren
|        D \     |      färben die nächsten Pixel, bis wir an dem Punkt auf der 
|           \    |      Seite AB zum Färben ankommen. Danach gehen wir
|            \   |      zur nächsten Zeile.
|             \  |      Dies bedeutet, dass wir für jede Zeile die 
|y             \ |      x Koordinaten des äußerst rechten Punktes und des
v               \|C     äußerst linken Punktes benötigen.

Nachdem wir verstanden haben, was zu tun ist, wollen wir sehen, wie alles zu
tun ist. Im Speicher müssen zwei Tabellen (eindimensionale Arrays) verwendet
werden mit den Abmessungen, die der Anzahl der vertikalen Pixel entsprechen,
die auf dem Bildschirm dargestellt werden können (Beispiel: bei einer Auflösung
von 320 * 200 benötigen wir zwei Tabellen von jeweils 200 Werten).
Wir betrachten jede Position der Tabellen als eine y - Position auf dem
Bildschirm und den Inhalt des ersten Arrays als entsprechende x-Komponente des
am weitesten links stehenden Punktes während des Wertes des zweiten Arrays als
x-Komponente des äußersten rechten Punktes. 
Dabei reicht es aus, alle Pixel in der entsprechenden Zeile einzufärben die
Position der Tabellen ab Position x in erste Tabelle bis zur Position x in
der zweiten Tabelle (alle Punkte einer Reihe haben die gleiche Ordinate).
Nehmen wir ein praktisches Beispiel:

 0| x=0 ->A. <- x=0        Der Einfachheit halber betrachten wir die um 45 Grad 
 1| x=0 -> .. <- x=1       geneigten Segmente AB und CD. Die Eckpunkte sind:
 2| x=0 -> . . <- x=2      A(0,0)  B(5,5)  C(5,10)  D(0,5)
 3| x=0 -> .  . <- x=3     Unsere beiden Tabellen werden sein:
 4| x=0 -> .   . <- x=4    +-------------------------------------------+
 5| x=0 ->D.    .B<- x=5   |TAB1| 0| 0| 0| 0| 0| 0| 1| 2| 3| 4| 5|..|..|
 6|  x=1 -> .   . <- x=5   +-------------------------------------------+
 7|   x=2 -> .  . <- x=5   |TAB2| 0| 1| 2| 3| 4| 5| 5| 5| 5| 5| 5|..|..|
 8|    x=3 -> . . <- x=5   +-------------------------------------------+
 9|     x=4 -> .. <- x=5   Um das Polygon zu füllen, färben Sie einfach die 
10|y     x=5 -> .C<- x=5   Pixel zwischen den entsprechenden Werten der beiden
  v                        Tabellen als Komponente der Index der Tabellen
						   (Welcher für beide gleich ist).
Manchmal ist es möglich, die beiden Extremwerte der Tabellen zu eliminieren,
wenn diese Zeilen nur ein Pixel enthalten (wie bei unserem Beispiel). Jetzt
müssen wir nur noch den Inhalt der zwei Arrays bekommen.
 Die Tabellen enthalten einfach die x-Koordinaten aller Punkte, die
bilden die Seiten des Polygons. Außerdem sind diese Abszissen basierend auf
ihrer y-Komponente geordnet. Grundsätzlich müssen wir eine Routine zum
Zeichnen von Linien für alle Seiten der Fläche durchführen, wobei wir nicht
die Pixel anzeigen, aber wir speichern die Komponente x in einem Array, dessen
Position dem y dieses Punktes entspricht. Diese Prozedur wird "Scanline" 
benannt. Mit anderen Worten die Scanlinie, mit zwei gegebenen Punkten
repräsentiert es die Koordinaten aller platzierten Punkte entlang des
Segments, das die beiden bekannten Punkte verbindet. Das Verfahren bei dem
das für alle Seiten eines Polygons realisiert wird, nennt man eine Scanlinie
"Scan-Konvertierung" und bedeutet im Grunde, das Polygon in einen Satz von
Zeilen und Spalten zu teilen.
Um eine Scanlinie zu erstellen, kann der Algorithmus von Bresenham verwendet
werden, aber es ist besser, das lineare Interpolationsverfahren zu verwenden,
was effizienter ist. Mal sehen, aus was es besteht.
 Betrachten wir zwei allgemeine Punkte A(x1,y1) und B(x2,y2) mit y2>y1.
Berechnen wir jetzt:

       dx=x2-x1     <-- Länge der Verbindungslinie A und B
       dy=y2-y1     <-- Höhe der Verbindungslinie A und B
       stepx=dx/dy  <-- Anzahl der horizontalen Pixel in jeder Zeile

Während der allgemeine Algorithmus lautet:

       > x=x1
       > y=y1
       > Schleife von dy-Iterationen
	  > wenn die y-Position von tab1 frei ist:
	     > speichern x an Position y von Tab1
	  > andernfalls:
	     > speichern x in Position y von tab2
	  > x=x+stepx
	  > y=y+1
       > nächste Iteration

Dieser Algorithmus ermöglicht die Berechnung einer Scanline im Fall y2 > y1, im
Fall y1 > y2, reicht es  aus, beide Koordinaten der beiden Punkte auszutauschen
(d. h. betrachte y1 als y2 und x1 als x2).
Tab1 ist das Array, das die äußersten linken Punkte enthält, während tab2 die
Extrempunkte rechts enthält. Mit unserem Algorithmus kann es passieren, dass
einige in tab1 geschriebene Werte zu tab2 gehören und umgekehrt. Mal sehen
Was tun, um diese Unannehmlichkeiten zu vermeiden?

Wenn wir die Punkte im Uhrzeigersinn gespeichert haben, ist alles einfacher.
Es ist schnell.Bei zwei Punkten A (x1, y1) und B (x2, y2) im Uhrzeigersinn,
wenn y1 größer als y2 ist, gehört die Scanlinie zu tab1 (das enthält die
kleinen x-Positionen), sonst gehört es zu tab2 (enthält die Haupt-x). Hier ist
der vollständige Algorithmus für die Verfolgung einer Scanlinie:

       > vergleiche y1 mit y2
	  > wenn y1>y2:
	    > die richtige Tabelle ist tab1
	  > wenn y1<y2:
	    > die richtige Tabelle ist tab2
	    > tausche y1 mit y2
	    > tausche x1 mit x2
	  > wenn y1=y2: nicht die scan line zeichnen!
       > dy=y1-y2
       > dx=x1-x2
       > stepx=dx/dy
       > x=x2
       > y=y2
       > Schleife von dy-Iterationen
	  > speichern x an Position y in der richtigen Tabelle
	  > x=x+stepx
	  > y=y+1
       > nächste Iteration

Sobald die Scan-Konvertierung des Polygons durchgeführt wurde, müssen wir die
y-Komponente kleiner als die vier Punkte berechnen, aus denen die Eckpunkte des 
Polygons bestehen und die Höhe des Polygons in Pixel selbst. Die kleine
y-Koordinate stellt den Index der Tabellen dar, ab denen das Polygon gefüllt
werden soll und daher die obere y-Position des Polygons. Die Höhe des Polygons
ist äquivalent zur Differenz zwischen dem Meisten-y und dem Wenigsten-y (und
wir müssen wissen)
um zu wissen, wie viele Zeilen wir für das aktuelle Polygon füllen müssen.

Zusammenfassend müssen folgende Schritte ausgeführt werden, um ein Polygon
zu füllen:

    - Definieren Sie im Speicher zwei Tabellen mit der Größe ys-Werte (wobei ys
      die Höhe des Bildschirms in Pixel darstellt);
    - Berechnen Sie das Kleinste y der Eckpunkte und die Höhe des Polygons.
    - Erhalten Sie die Scanlinie jeder Seite des Polygons, indem Sie 
      entsprechend in der richtigen Tabelle speichern (Scan-Konvertierung);
    - Füllen Sie ausgehend von der kleinen y-Position die durch abgegrenzte
	  Zeile aus x Positionen, die mehrmals in den Tabellen selbst enthalten
	  sind entspricht der Höhe des Polygons.

				
				fLAT sHADING
==========================================================================

 Wir sind zur Analyse des ersten (und einfacheren) Algorithmus von 
Schattierungen gekommen, dank derer wir jedem Polygon dem Objekt eine genaue
Lichtintensität zuordnen können, die basierend auf der Ausrichtung der Fläche
in Bezug auf die Lichtquelle bestimmt wird.
Mit der flachen Schattierung können Sie jeder Flächet nur eine bestimmte
Farbe geben, wie hell das Polygon ist. Nehmen wir ein Beispiel:

	     +-------------+
  Blick      |             |
von oben	 |             |         <--- Objekt in theoretischem 3D
	     |             |              (theoretisch denn in Wirklichkeit 
	     |             |              ist es nicht, wir sehen die
	     +-------------+              projizierten Koordinaten)
		    |					  
		    |                <--- Richtung der Lichtquelle
      ______________|_____________   <--- Bildschirm
		    |
		    |
		    o                <--- Sicht des Betrachters

Wir gehen davon aus, dass die Lichtquelle der Sicht des Beobachters entspricht,
seine Richtung ist senkrecht zum Bildschirm. Wir definieren den Winkel der
Neigung der Fläche in Bezug auf die Lichtquelle als Winkel zwischen der Linie,
die der Richtung des Lichts entspricht, und dem Einheitsvektor der Fläche
(d.h. der normalen Linie). Je kleiner dieser Winkel ist, desto stärker ist das
Polygon dem Beobachter ausgerichtet. Wir können vermuten, dass beide die Fläche
genau vor dem Betrachter platziert ist und je größer die Intensität des
aufgebrachten Lichts dieser Fläche ist. Folglich entspricht ein kleinerer
Winkel einer größeren Helligkeit der Fläche. Hier ist ein weiteres Beispiel:

			 /\
			/  \         Blick von oben
		       /    \
       Objekt 3D -->  /      \
       fiktiv	     /        \
		    /          \
		    \          /
		     \        /   a = Winkel zwischen dem Vektor der
		      \      /        Fläche und der Lichtrichtung
		     /|\    /
		    /-| \  /
		   / a|  \/
      Vektor      /   |
      Fläche --> /    | <-- Lichtrichtung (in diesem Fall
		/     |     zufälliger Standpunkt)
	       /      |
	   -----------|------------- <-- Bildschirm
		      o              <-- Sicht des Betrachters

Die dem Polygon zuzuschreibende Lichtunempfindlichkeit ist proportional zum
Kosinus dieser Ecke. Wir wissen, dass das Ergebnis von cos (a) zwischen
-1 und 1 liegt. Beachten Sie, dass wenn das Polygon sichtbar ist, unsere Ecke
von 0 bis 90 Grad variiert, sonst ist die Fläche verborgen (es ist möglich
diese Funktion zu verwenden, um die verborgene Fläche zu beseitigen!).
Der Kosinuswert relativ zu unserem Winkel deckt also einen Wertebereich von
von 0 und 1 ab.
Mit 256 Farben multiplizieren Sie einfach den Kosinus mit 256
(oder machen Sie eine 8-Bit-Verschiebung nach links) und wir erhalten das
chunky Pixel, mit dem wir seine Fläche füllen müssen!
Mal sehen, wie man diesen Wert ableitet.

Zuerst müssen wir die zu verwendende Farbpalette angeben.
Dies ist möglich, indem Sie eine Startpalette im Videospeicher definieren
von der Farbe geringerer Leuchtkraft bis zum allmählichen Erreichen der 
helleren Farbe
Für die Berechnung des Kosinus ist es ratsam, die Lambert-Regel, die besagt,
dass das Skalarprodukt zwischen zwei Linien als Vektorgrößen entsprechen
dem Produkt der Länge von relative Vektoren ausgedrückt werden und der Kosinus
durch die Linien des selbst begrenzten Winkels, das ist der Winkel a. 
Um cos (a) zu kennen, müssen wir daher nichts anderes tun als
Spielen Sie dieses Punktprodukt und teilen Sie das Ergebnis durch das Produkt
der Längen der beiden Vektoren.

Um das Skalarprodukt zweier Vektoren zu berechnen, führen wir das Produkt 
der entsprechenden Komponenten aus und dann werden die Ergebnisse
hinzugefügt, zum Beispiel:

      H=(xh,yh,zh)  ;  K=(xk,yk,zk)
      H*K=xh*xk+yh*yk+zh*zk         <-- Skalarprodukt

Um eine Länge eines Vektors abzuleiten, können wir den Satz von Pythagoras
verwenden, dank dessen kann gesagt werden, dass die Länge äquivalent
zur Quadratwurzel der Summe der Quadrate jeder Komponente ist.

Lassen Sie uns überprüfen, wie die Koeffizienten x, y und z der Vektoreinheit
von der Fläche berechnet werden:

	 Nx=(y2-y1)*(z3-z1)-(y3-y1)*(z2-z1)    <-+--- die drei Koeffizienten
	 Ny=(z2-z1)*(x3-x1)-(z3-z1)*(x2-x1)    <-|    der normalen Linie
	 Nz=(x2-x1)*(y3-y1)-(x3-x1)*(y2-y1)    <-+

 N.B.: Punkte müssen im Uhrzeigersinn gespeichert werden!

	 x1, y1, z1 = Komponenten des ersten Punktes des Polygons
	 x1, y2, z2 = Komponenten des zweiten Punktes des Polygons
	 x3, y3, z3 = Komponenten des dritten Punktes des Polygons

Schließlich ist hier die Formel zur Berechnung des chunky Pixels:

			     Nx*lx + Ny*ly + Nz*lz
	 cos(a)=-------------------------------------------------
		sqrt(Nx*Nx+Ny*Ny+Nz*Nz) * sqrt(lx*lx+ly*ly+lz*lz)

	 pixel chunky = 256*cos(a)

a = Winkel zwischen dem Einheitsvektor und der Richtung der Lichtquelle
	 lx = Komponente x der Lichtquelle
	 ly = Komponente y der Lichtquelle
	 lz = Komponente z der Lichtquelle

Die Koordinaten lx, ly und lz repräsentieren die Position der Lichtquelle.
Wenn das Licht mit dem Standpunkt des Betrachters übereinstimmt, sind die
relativen Koordinaten :

	 lx=0  ;  ly=0  ;  lz=-256

zl ist gleich dem Gegenteil des Abstandes zwischen dem Betrachter und dem
Bildschirm (In unserem Fall beträgt der Abstand zwischen dem Beobachter
und dem Bildschirm 256).


		oPTIMIERUNGEN fÜR dIE bERECHNUNG dER lICHTQUELLE
==========================================================================

In diesem Teil sehen wir, wie wir unsere 3D-Engine in diesem Fall beschleunigen
können. Es beinhaltet die Implementierung einer echten Lichtquelle.

Eine erste Optimierung besteht darin, einen Puffer zu verwenden, in den wir
alle vorab berechneneten Normalen jeder Fläche (oder jeder Ecke von Gouraud
-Schattierung in diesem Fall) eingeben. Dann anstatt alle zu berechnen drehen
wir unsere vorberechneten Vektoren um den gleichen Winkel mit die wir die 
Eckpunkte des Objekts mit genau dem gleichen oben beschriebenes Verfahren
drehen (vorzugsweise unter Verwendung des Algorithmus mit 9 Multiplikationen).

Wir haben gesagt, dass das Skalarprodukt zwischen dem Normalenvektor und dem
Vektor entsprechend der Lichtquelle multipliziert mit 256 uns erlaubt das
chunky Pixel zu kennen.Nun wollen wir sehen, wie man die Wurzeln Quadrate und
Divisionen entfernt. Lassen Sie uns die Formel noch einmal analysieren:
 
			      Nx*lx + Ny*ly + Nz*lz
	 cos(a)=-------------------------------------------------
		sqrt(Nx*Nx+Ny*Ny+Nz*Nz) * sqrt(lx*lx+ly*ly+lz*lz)

Um diese Optimierung zu implementieren, müssen wir den Vektor einheitlich 
normal und der entsprechende Vektor die Lichtquelle machen. Einen Vektor
Einheitlich machen bedeutet, jede der Komponenten durch ihren Abstand vom
Ursprung zu teilen; Das heißt, die neuen Komponenten haben eine Reihe
zwischen -1 und +1, deshalb heißt es unitary.
 Lassen Sie uns algebraisch sehen, wie man einen Einheitsvektor macht:

				      Nx
		      uNx=---------------------------
			  sqrt(Nx*Nx + Ny*Ny + Nz*Nz)

				      Ny
		      uNy=---------------------------
			  sqrt(Nx*Nx + Ny*Ny + Nz*Nz)

				      Nz
		      uNz=---------------------------
			  sqrt(Nx*Nx + Ny*Ny + Nz*Nz)

Allgemeiner ausgedrückt, wenn ein Vektor V (x, y, z) gegeben ist, um die 
Komponenten des relativen Einheitsvektors uV (ux, uy, uz) zu berechnen:

				      x
			  ux=---------------------
			     sqrt(x*x + y*y + z*z)

				      y
			  uy=---------------------
			     sqrt(x*x + y*y + z*z)

				      z
			  uz=---------------------
			     sqrt(x*x + y*y + z*z)

 Um die Lichtquelle einheitlich zu machen, können wir es auch vermeiden
jede Komponente durch ihre Länge zu teilen. Wir entscheiden, wo es ist, damit
können wir willkürlich Einheitenkoordinaten zuweisen. Zum Beispiel zurück
zu dem Fall, dass das Licht mit dem Standpunkt übereinstimmt:

		       ulx=0  ;  uly=0  ;  ulz=-1

Dann wird die Formel zur Berechnung der Lichtintensität reduziert auf :

		     cos(a) = uNx*ulx + uNy*uly + uNz*ulz
		     pixel chunky = 256*cos(a)

Machen Sie einen Vektor einheitlich und drehen Sie ihn dann oder drehen Sie
einen Vektor und machen ihn dann einheitlich, es bedeutet, dieselbe Funktion
auszuführen. so im Moment in dem wir die Normalen vorberechnen, können wir sie
sofort einheitlich machen, später werden wir die bereits einheitlich gemachten
Vektoren drehen. Auf diese Weise vermeiden wir es, jeweils 2 Quadratwurzeln und
eine Division durch den Scheitelpunkt bei jedem frame zu machen!

N.B.: falls Sie die Lichtquelle bewegen möchten, ist es durch diese
      Optimierung nicht möglich, Bewegungen der Lichtquelle zu implementieren,
      aber nur Rotationen, wie der Ursprung-Licht-Abstand muss
      gleich bleiben.

Die letzte Optimierung besteht darin, sie an einem Punkt der Lichtquelle
festzuhalten, genauer gesagt sagen wir, dass es immer mit der Standpunkt des
Beobachters übereinstimmen muss.  Natürlich werden wir einheitliche Koordinaten
für die Vektoren und das Licht verwenden. Sehen wir uns die Formel zur
Berechnung der chunky Pixel in diesem speziellen Fall an:

	    pixel chunky = 256*( uNx*ulx + uNy*uly + uNz*ulz) =
			 = 256*( uNx*0   + uNy*0   + uNz*(-1))=
			 = -256*uNz

Jetzt hängt unser chunky Pixel nur noch von uNz ab, also können wir jeden 
Scheitelpunkt -256 * uNz vorberechnen anstelle des einfachen uNz, und drehen
und diesen Wert sofort als chunky Pixel verwenden. Auf diese Weise können 
vermeiden wir 3 Multiplikationen und 2 Additionen. Auch weil wir nur uNz
brauchen, können wir sehr gut vermeiden, uNx und uNy zu drehen, und sparen
weitere 6 Multiplikationen pro Fläche (oder pro Scheitelpunkt im Fall von
Gouraud). Insgesamt sparen wir 9 Multiplikationen und 2 Additionen pro
Fläche (oder pro Scheitelpunkt im Gouraud)!
Natürlich müssen wir zusätzlich zu -256 * uNz auch uNx und uNy vorberechnen
multipliziert mit 256 (256 * uNx, 256 * uNy), die zum Drehen von -256 * uNz
benötigt werden. Auch wenn wir unsere Palette invertieren, können wir
256 * uNz verwenden anstelle von -256 * uNz.


				gOURAUD sHADING
==========================================================================

 Mit diesem Schattierungsalgorithmus können Sie das Innere jedes einzelnen
Polygons verwischen im Gegensatz zu flachen Schattierungen, denen eine einzelne
Flächenfarbe zugewiesen ist.

 Zuerst müssen wir den Einheitsvektor jedes Eckpunktes des Objekts berechnen
anstelle eines Polygons. Die Komponenten der Eckpunktnormalen sind
äquivalent zum arithmetischen Mittel der Komponenten der Normalen aller
Flächen, die diesen Scheitelpunkt berühren. Nehmen wir ein Beispiel:

	    ____        sei V ein generischer Eckpunkt eines Würfels, der
	   /f2 /\       zu den Flächen f1, f2 und f3 gehört. Betrachten wir
	  /___/V \      die Normalen dieser Flächen und nennen wir diese 
	  \f1 \f3/      N1, N2, N3.
	   \___\/       N1(Nx1,Ny1,Nz1)  N2(Nx2,Ny2,Nz2)  N3(Nx3,Ny3,Nz3)


Dann ist die Normale auf V äquivalent zu:

	   NV( (Nx1+Nx2+Nx3)/3, (Ny1+Ny2+Ny3)/3, (Nz1+Nz2+Nz3)/3 )
		   
In diesem Fall sind die zu V gehörenden Flächen 3. Sie ändert sich mit der
Anzahl der zum Eckpunkt gehörenden Polygone des Objekts, welches Sie verwenden
möchten.

Sobald alle Normalen vorberechnet wurden (vorzugsweise schon einheitlich)
müssen wir an jeder Kante die Lichtmenge berechnen, die auf jede der
Eckpunkte fällt, das ist das chunky Pixel, unter Verwendung des bereits
untersuchten Gesetzes in flacher Schattierung (möglicherweise unter Ausnutzung
aller Optimierungen aus dem vorherigen Absatz).

Dann führen wir die Scan-Konvertierung durch (im entsprechenden Abschnitt
erläutert) zum Füllen und Scanline aller sichtbaren Polygone.

 Jetzt müssen wir die chunky Pixel für jede Fläche linear interpolieren
gemäß der Zugehörigkeit der Eckpunkte der Flächen. In der Praxis müssen wir
eine einfache Scan-Konvertierung des Polygons durchführen durch chunky Pixel
anstatt durch die x-Koordinaten der Eckpunkte. Das ist alles. Das muss
natürlich nur gemacht werden wenn die Fläche sichtbar ist.

Alles, was bleibt, ist das eigentliche Füllen der Polygone. Wie für eine
normale Füllung ist es erforderlich, eine Schleife mit äquivalenten Iterationen
in Höhe der Anzahl der Pixel des Polygons durchzuführen. Bei jeder Iteration
rufen wir von Zeit zu Zeit die Anfangs- und End-x-Koordinaten aus den
Scan-Linientabellen ab (wie bei einer normalen Füllung), aber diesmal nehmen
wir auch die chunky Pixel Anfänge und Endungen.
Jetzt müssen wir das beginnende chunky Pixel mit dem endenden Pixel
interpolieren von der Anfangs x-Koordinate bis zum Letzten. Um dies zu tun 
verwenden Sie einfach den Algorithmus dazu, um eine Scanlinie mit
folgenden Änderungen zu zeichnen:

     - verwenden des ersten chunky pixels anstelle der x1-Koordinate.
     - verwenden des letzten chunky pixels anstelle der x2-Koordinate.
     - verwenden des anfänglichen x anstelle der y1-Koordinate.
     - verwenden des letzten x anstelle der y2-Koordinate.
     - verwenden der chunky Bildschirmzeile, um sie als Tabelle zu "füllen"
       wo die Scanlinie gespeichert wird.

Und hier ist gouraud shading!


				pHONG sHADING
==========================================================================

Mit der Phong-Schattierung können Sie jedem Pixel seine echte Lichtintensität
zuweisen im Gegensatz zum Gouraud, bei dem die Schattierungen jeder Fläche
zwischen den Lichtintensitäten von jedem Scheitelpunkt des Objekts erzeugt
werden. Die höhere Definition, die wir mit dem Phong im Vergleich zum Gouraud
erhalten, bedeutet gleichzeitig eine drastische Zunahme der Operationen, die
der Prozessor ausführen muss. Die Menge der durchzuführenden Berechnungen
ist derart, dass sie verhindern, dass aktuelle Computer zufriedenstellende
Szenen Echtzeit-Phong-Schattierung verfolgen.

Im Gouraud berechnen wir die tatsächliche Lichtintensität an jedem Eckpunkt.
Danach wird jede Farbe entlang jeder Seite des Polygons integriert. Schließlich
werden die Farben der äußersten linken Seite mit den Farben die ganz rechts
platziert sind interpoliert, um das ganze Polygon zu füllen.

Im Phong hingegen interpolieren wir immer die Normalen, sie interpolieren nie
die Farben. Sobald die Vektoren auf jedem Scheitelpunkt bestimmt wurden,
müssen sie entlang jeder Seite interpoliert werden. Anschließend werden die
Vektoren der äußersten linken Seiten mit denen die ganz rechts platziert
interpoliert, sodass jede einzelne Farbe berechnet wird unter Verwendung der
traditionellen Formel die wir berits mehrmals untersucht haben.

Das Phong hindert uns daran, die verschiedenen möglichen Optimierungen
mit Gouraud-Schattierung und flacher Schattierung zu nutzen. In der Tat ist
es im Phong unmöglich Einheitsnormalen zu verwenden, wie sie als wenn sie durch
ihre Länge interpolieren wären (entspricht dem Ergebnis des Ausdrucks
sqrt (Nx * Nx + Ny * Ny + Nz * Nz)) kann variieren. Also müssen sie
zumindest eine Division und eine Quadratwurzel pro Pixel machen, was keine
Kleinigkeit ist.


				rEFLECTION mAPPING
==========================================================================

Wenn ein Volumenkörper immer nur ein einzelnes Bild widerspiegelt (im
Jargon "Textur" genannt) dann können wir sagen, dass auf diesem Festkörper
Reflection Mapping angewendet wurde.
Falls die Textur ungefähr der zweidimensionalen Darstellung eines Lichts
entspricht (Bsp.: ein Kreis, dessen Mittelpunkt sehr hell ist, während es
zu den Rändern hin in einen dunkleren Farbton verblasst), ist es möglich,
ähnliche (und manchmal überlegene) Effekte wie bei Phong und Gouraud
zu erzielen.

Dieser Effekt wird fälschlicherweise oft mit dem environment mapping
verwechselt, das es stattdessen ermöglicht, eine gesamte Umgebung zu
reflektieren, die das Objekt umgibt (die Umgebung wird der Einfachheit halber
häufig wie ein Würfel definiert, also werden in diesem Fall sechs Bilder auf
dem Körper reflektiert).

In diesem Abschnitt wollen wir beschreiben, wie reflection mapping 
mit nur 256 * 256 Pixel Texturen realisiert wird.
Das Implementieren von Texturen unterschiedlicher Größe ist einfach
ableitbar.

Lassen Sie uns im Detail sehen, wie man ein gemeinsames Objekt in
refelction mapping macht.
Zunächst werden wir alle Einheitsvektoren für jeden Eckpunkt (wie für
den Gouraud) vorberechnen und mit 128 multiplizieren (oder eine einfache 
7-Bit-Verschiebung nach links anwenden - mathematisch übersetzt
bedeutet es:
	    _                                            _
	   |  PVx = 128*Nx / sqrt(Nx*Nx + Ny*Ny + Nz*Nz)  |
	PV |  PVy = 128*Ny / sqrt(Nx*Nx + Ny*Ny + Nz*Nz)  |
	   |_ PVz = 128*Nz / sqrt(Nx*Nx + Ny*Ny + Nz*Nz) _|

Wir nennen PV den Vektor, der diese 3 Werte als Komponenten hat. Die 
Einheitennormale hat 3 Werte als Koordinaten, die Zahlen enthalten real 
zwischen -1 und +1. Wir haben jetzt PVx, PVy und PVz, die mit den
Einheitsvektoren mit 128 multipliziert werden, was bedeutet, dass sie einen
Radius von Werten zwischen -128 und +128 abdecken (obwohl in Wirklichkeit 
diese Werte niemals +127 überschreiten). Und hier endet die
Vorberechnungsphase.

In Echtzeit müssen wir den PV-Vektor für jeden Eckpunkt drehen (nur für den
Fall, der Ausnutzung der gleichen Rotationsfaktoren der Punkte, wenn es
realisiert wurde durch die 9-Multiplikationsrotation). Vom PV-Träger brauchen
wir nur die gedrehte x- und y-Komponenten, so dass wir auch PVz nicht
vermeiden können. So müssen mindestens 3 Multiplikationen und 2 Additionen pro
Eckpunkt durchgeführt werden. (Natürlich ist es notwendig, PVz für jeden
Eckpunkt vorab zu berechnen, um PVx und PVy zu drehen). Zu jeder der
gedrehten x- und y-Komponenten des Vektors PV addiere den Wert 128. Am
Ende dieser Berechnungen wird der Bereich der Werte, die PVx und PVy
verstehen können, zwischen 0 und 255 liegen.

Tatsächlich repräsentieren ((PVx gedreht) +128) und ((PVy gedreht) +128) die
Koordinaten der Textur, die auf dem Polygon abgebildet (d.h. verfolgt) werden
sollen.
Das bedeutet, dass wir ein Polygon haben müssen, das durch 4 Punkte begrenzt
ist. Wir müssen den Teil der Textur, der durch die 4 relativen PVx begrenzt
ist zuordnen und um PVy gedreht (und zu 128 hinzugefügt).
Es wird also ausreichen, das "Stück" der Textur auf diesem Polygon abzubilden
und es für jede sichtbar Fläche zu wiederholen um reflection mapping zu
realisieren!

Nun wollen wir sehen, wie man den Texturteil verfolgt, sobald ich die
neuen PVx und PVy berechnet habe. Zuerst müssen wir zusätzlich die Scan-
Konvertierung des Polygons durchführen. Zusätzlcih müssen wir PVx und PVy
auf allen Seiten unserer Fläche interpolieren, was bedeutet, dass 2 weitere
Scan-Konvertierungen des Polygons mit PVx und PVy anstelle der x-Koordinaten
der Eckpunkte durchgeführt werden.
Also in allem gibt es 3 Scan-Konvertierungen: Die erste ist die traditionelle,
die zweite erfolgt durch Ersetzen der x der Eckpunkte durch PVx, während die
dritte PVy statt x verwendet (wir machen genau wie beim normalen Phong,
mit dem Unterschied, dass wir 2 Komponenten (PVx und PVy) anstelle von 3
betrachten (Nx, Ny und Nz)).
Wir haben die Scan-Konvertierung des Polygons durchgeführt, was wir haben
ist ein Algorithmus, mit dem jeder Punkt der Fläche ein bestimmtes Pixel
der Textur zugeordnet werden kann.
Betrachten wir die folgende Abbildung als unsere auf den Bildschirm
projizierte Fläche:

	       .                 Nach Interpolation von PVx und PVy und 
	      . .                abgeschlossene Scan-Konvertierung für jedes
	     .   .               Paar von Punkten auf die gleiche Position y
      P1 -> .     . <- P2        zeigt der Bildschirm, zum Beispiel P1 und P2,
	   .       .             wir kennen ihre x-Koordinate zusammen mit PVx
	    .     .              und PVy. Jetzt müssen wir PVx und PVy von
	     .   .               Punkt P1 nach Punkt P2 interpolieren, so dass
	      . .                wir die Wert von PVx und PVy für alle Punkte
	       .                 des Polygons kennen. Um diese 2 Werte entlang
				 einer Linie zu interpolieren müssen Sie den
   P1 -> x1, y, PVx1, PVy1       allgemeinen Algorithmus für die Verfolgen
   P2 -> x2, y, PVx2, PVy2       einer canlinie anwenden mit dx statt dy, dPVx
   dPVx = PVx1-PVx2              (um PVx zu interpolieren) und dPVy (um PVy zu 
   dPVy = PVy1-PVy2              interpolieren) genau wie wir es bei Gouraud
     dx = x1-x2                  getan haben, um die chunky Pixel zu
								 interpolieren.

 Wie bereits erwähnt, repräsentieren PVx und PVy die Koordinaten des Pixels
Textur zu verfolgen. Sobald die 3 Scan-Konvertierungen durchgeführt wurden,
kennen wir PVx und PVy der zu jedem Eckpunkt der Fläche gehört. Daher durch
Interpolation von PVx und PVy entlang des gesamten Polygons erhalten wir die
Koordinaten der Punkte des Textur für alle Punkte der Fläche!
Nun mit einigen einfachen Kopieroperationen können wir das Polygon abbilden,
indem wir jedem Punkt das chunky Texturpixel an Ort und Stelle (PVx, PVy)
zuordnen.


				tEXTURE mAPPING
==========================================================================

Dieser Effekt ermöglicht die Verfolgung eines ganzen Bildes auf einem Polygon.
In der Praxis ist es so, als hätten wir auf jede Fläche eine Textur "geklebt".
In diesem Abschnitt werden wir die Texturabbildung ohne Perspektive
diskutieren. Dies ist der schnellste Algorithmus, bei dem ein Bild einem
Polygon zugeordnet werden kann, aber gleichzeitig ist es weniger realistisch.

Betrachten wir die Verwendung eines 4-seitigen Polygons bei der jede Kante des 
Polygons mit einer Kante der Fläche zusammenfällt. Was wir tun müssen ist, die
gesamte Textur auf das Polygon zeichnen. In der Praxis ist es so, als ob
wir eine reflection mapping durchführen, mit dem Wissen, dass die Koordinaten
der zuzuordnenden Texturen immer konstant sind und genau mit den 4 Eckpunkten
der Textur selbst übereinstimmen. Wenn die Textur 256 * 256 Pixel ist, werden
wir einen reflection mapping Algorithmus durchführen, der weiß, dass PV1 (0,0),
PV2 (255,0), PV3 (255,255), PV4 (0,255) für jedes Polygon gleich ist. Mit
anderen Wörtern, interpolieren wir die x- und y-Koordinaten der langen Textur
das gesamte Polygon, so dass für jeden Pixel, der zur Fläche gehört verfolgen,
welches der relative Punkt der Textur ist. Das ist alles.


			fREE dIRECTION tEXTURE mAPPING 
==========================================================================


			tEXTURE mAPPING bILINEAR
==========================================================================


			tEXTURE mAPPING bIQUADRATISCH
==========================================================================


				bUMP mAPPING
==========================================================================


				cLIPPING 2d
==========================================================================


				oPTIMIERUNG dER fÜLLUNG
==========================================================================


			aNHANG a: aNMERKUNG zU fESTKOMMA
==========================================================================

 Bei der Ausarbeitung von 3D-Objekten muss man sich oft mit reellen und nicht
mit ganzen Zahlen auseinandersetzen. Die meisten fortgeschrittenen Sprachen
erlauben die direkte Verarbeitung dieser Zahlen, durch Ausnutzung
mathematischer Koprozessoren oder Emulation über Software. Die Emulation
die aktuelle Compiler bringen, ist definitiv zu langsam für Anwendungen in
Echtzeit, auch wenn Sie in Assembler arbeiten, haben Sie nicht
die direkte Verwaltung von reellen Zahlen verfügbar, sofern nicht
der Mathe-Coprozessor benutzt wird. Als Alternative zur FPU (welche
Gleitkommazahlen verwendet) können sie sich für das Kommaformat entscheiden,
dass trotz einer geringeren Genauigkeit als das GleitkommaFormat, 
die beste Wahl bleibt, da die Operationen in solchen Format schneller
ausgeführt werden.
Grundsätzlich werden in einem elektronischen Computer alle Zahlen
(auch echte) als ganze Zahlen dargestellt. Die Fixpunkt-Notation
basiert auf der direkten vereinfachten Darstellung, mal sehen wie.

Eine reelle Zahl wird durch einen ganzzahlige Wert dargestellt durch
das Produkt der reellen Zahl multipliziert mit einer vorher definierten
Konstante. Genau von dieser Konstante hängt die Präzision ab, durch die
nicht ganzzahlige Zahlen dargestellt werden können  Hier ist ein Beispiel:

	   3.25             <- reelle Zahl
	   256              <- Konstante

	   3.25*256 = 832   <- 3.25 im festen Punkt

Auf diese Weise können wir alle reellen Zahlen mit eriner diskreten Fehlerquote
darstellen, die für unsere Anwendungen praktisch unrelevant ist. Es ist
zweckmäßig, eine Potenz von 2 als Konstante zu verwenden (Bsp.: 256, 65536),
mit dem die Manipulation von Zahlen in dieser Notation beschleunigt werden
kann.
In der Tat ist es bekannt, dass der Computer eine beliebige Zahl als Folge
von Bits darstellt. Mit einer konstanten Potenz von 2 können jeweils
2 Bitfelder definiert werden Abbildung: Eine für den gesamten Teil, die
andere für den Bruchteil.
Wenn eine Festkommazahl eine Anzahl von Bits hat, bei dem der Teil Ganzzahl
gleich <a> zugeordnet ist und eine Anzahl von Bits, die dem Bruchteil
gleich <b> zugeordnet ist, dann soll diese Zahl das Format "a: b" haben. Es
muss außerdem angegeben werden, dass der ganzzahlige Teil einer Festkommaziffer
zum höchsten Bitfeld gehört, während der Bruchteil zum untersten Bitfeld gehört.

	   3.25        <- reelle Zahl
	   256=2^8     <- Konstante
	   832         <- 3.25 in Fixpunkt
	   8:8         <- Festkommazahlformat.
			  Wir verwenden 1 Wort (16 Bit), wir haben 8 Bit, die
			  MSB, die dem gesamten Teil gewidmet sind und die
						  anderen 8 Bit LSB, die weniger signifikanten Bits
			  für den Rest.

Mal sehen, wie man eine Ganzzahl in das Festkommaformat konvertiert und
umgekehrt:

	   ganze Zahl        = (Zahl Festpunkt) / (Konstante)
	   Zahl Festpunkt	 = (ganze Zahl)     * (Konstante)

Lassen Sie uns abschließend verstehen, wie die 4 Operationen mit solchen
Zahlen ausgeführt werden:

	   (a:b) + (c:d) = unmöglich!!
	   (a:b) + (a:b) = a:b
	   (a:b) * (c:d) = (a+c):(b+d)
	   (a:b) / (c:d) = (a-c):(b-d)

Wir erkennen sofort, dass es unmöglich ist, 2 Komma-Zahlen die in einem anderen
Format festgelegt sind hinzuzufügen. Sie müssen zuerst die 2 Ziffern homogen
machen (Dies bedeutet, dass die 2 Ziffern das gleiche Format haben müssen).
Beachten Sie, dass jede Ganzzahl als feste Kommazahl im Format "a: 0"
verstanden werden kann. Daher ist es möglich, direkt Multiplikationen und
Divisionen zwischen Festkommazahlen und ganzen Zahlen durchzuführen.


			aNHANG B: pOLARKOORDINATEN
==========================================================================

Wie wir bereits wissen, um einen Punkt in einer Ebene darzustellen
können wir die kartesischen Achsen verwenden. Die x- und y-Komponenten 
repräsentieren nichts weiter als die Projektionen unseres Punktes auf
die Abszisse und die Ordinate.
Stellen wir uns stattdessen vor, wir möchten einen Punkt mit einem anderen
Bezugssystem anzeigen, in unserem Fall die Polarkoordinaten.

  ^                    Wir betrachten r als den Abstand zwischen dem Punkt P
y |     .P(x,y)        und dem Ursprung, während t als der Winkel zwischen dem
  |    /               Segment OP und der positiven Halbachse x ist.
  |   /                Es ist möglich, jeden Punkt mit diesen 2 Variablen
  | r/                 (r und t)  anzugeben, die nur die Polarkoordinaten 
  | /                  darstellen. Für jedes P (x, y) gibt es ein P '(r, t).
  |/) t                Mal sehen wie man diese Konvertierungen macht.
  +------------>       
 O            x
		       Sei R (x, 0) die Projektion von P (x, y) auf die
  ^                    x-Achse (d.h. der Ordinatenpunkt 0 und Äquivalent
y |     .P(x,y)        Abszisse von P). Das Dreieck ORP ist in R
  |    /|              rechtwinklig, daher nach dem Satz von Pythagoras:
  |   / |
  | r/  |                         r = OP = sqrt( x*x + y*y )
  | /   |
  |/) t |              Wir können auch sagen:
  +-----+------>
 O      R     x        PR = r*sin(t)   =>   sin(t) = PR/r
		       OR = r*cos(t)   =>   cos(t) = OR/r
					 
Wenn wir aufpassen, können wir das bestätigen (unter Berücksichtigung des
Punktes) P (x, y)) PR = y und OR = x. Die Tangente eines Winkels entspricht
dem Verhältnis des Sinus dieses Winkels mit dem relativen Cosinus daher:

	tan(t) = sin(t)/cos(t) = (PR/r)/(OR/r) = PR/OR = x/y
	x/y = tan(t)

	t = arctan(x/y)
	r = sqrt(x*x+y*y)

	x = r*cos(t)
	y = r*sin(t)

Jetzt wissen wir, wie man kartesische Koordinaten in polare und 
umgekehrt umwandelt. Dies ist hilfreich, um zu verstehen, wie die 
Drehung um einen Punkt durchgeführt wird.
 

			aNHANG C: oBJEKTMANAGEMENT
==========================================================================

Wir möchten unser Objekt auf dem Bildschirm verfolgen, sei es im Drahtmodell,
Gouraud-Shading, Textur-Mapping oder andere Rendering-Techniken, die wir
mögen. Wir wissen genau, wie man eine einzelne Fläche visualisiert, aber
wie können wir mit all den Flächen umgehen, aus denen der dreidimensionale
Körper besteht?
Wir müssen ein "Format" definieren, mit dem sich das Objekt im Speicher
befindet basierend darauf können wir jede 3D-Figur mit immer den gleichen
Routinen anzeigen, aus denen unsere 3D-Engine besteht.
Sehen wir uns ein praktisches Beispiel an:

	    V5 _____________ V6   Wir definieren zuerst einen einfachen Würfel.
	     /|	           /|     Zuerst geben wir die Anzahl aller Eckpunkte
	    / |	          / |     und Flächen an, aus denen es besteht.
	   /  |	         /  |     Dann listen wir alle Koordinaten (x, y, z)
	  /   |	        /   |     der Eckpunkte des Würfels auf.
      V1 /____|_______ /V2  |     Schließlich geben wir die Eigenschaften von
	|     |       |     |     allen Flächen an. Im einfachsten Fall um ein
	|   V8|_______|_____|V7   Fläche zu definieren, geben Sie einfach
	|    /        |    /      die Eckpunkte an. (zur Vereinfachung der
	|   /         |   /       Entfernung der verborgenen Flächen und der
	|  /          |  /        Berechnung der Normalen in einer geordneten
	| /           | /         Reihenfolge) So ist es möglich
	|/____________|/          einen Würfel im Speicher zu definieren:
      V4               V3         

    8            <- Anzahl der Eckpunkte des Objekts
    6            <- Anzahl der Flächen des Objekts
    -50,-50,-50  <- Koordinate x,y,z der Ecke V1
    +50,-50,-50  <- Koordinate x,y,z der Ecke V2
    +50,+50,-50  <- Koordinate x,y,z der Ecke V3
    -50,+50,-50  <- Koordinate x,y,z der Ecke V4
    -50,-50,+50  <- Koordinate x,y,z der Ecke V5
    +50,-50,+50  <- Koordinate x,y,z der Ecke V6
    +50,+50,+50  <- Koordinate x,y,z der Ecke V7
    -50,+50,+50  <- Koordinate x,y,z der Ecke V8
    1,2,3,4      <- Zeiger auf die Eckpunkte, aus denen die Fläche besteht 1
    2,6,7,3      <- Zeiger auf die Eckpunkte, aus denen die Fläche besteht 2
    6,5,8,7      <- Zeiger auf die Eckpunkte, aus denen die Fläche besteht 3
    5,1,4,8      <- Zeiger auf die Eckpunkte, aus denen die Fläche besteht 4
    5,6,2,1      <- Zeiger auf die Eckpunkte, aus denen die Fläche besteht 5
    4,3,7,8      <- Zeiger auf die Eckpunkte, aus denen die Fläche besteht 6

Lassen Sie uns analysieren, wie Polygone definiert sind, nehmen wir die
Fläche 1:

    1,2,3,4      <- es bedeutet, dass die Fläche aus den ersten 4
		    Punkten in der Liste der Eckpunkte besteht, nämlich:

    -50,-50,-50  <- Koordinate x,y,z der Ecke V1
    +50,-50,-50  <- Koordinate x,y,z der Ecke V2
    +50,+50,-50  <- Koordinate x,y,z der Ecke V3
    -50,+50,-50  <- Koordinate x,y,z der Ecke V4

Jede Seite wird durch die lineare Zugehörigkeit von 2 Eckpunkten dargestellt.
In dem gerade vorgeschlagenen Beispiel sind die Seiten von Fläche 1 die
Segmente vom ersten bis zum zweiten Punkt (V1 und V2), vom zweiten bis zum
dritten Punkt (V2und V3) vom dritten zum vierten (V3 und V4) und vom vierten
zum ersten Punkt (V4 undV1) abgegrenzt.
In unserem Fall ist jede Fläche ein Viereck, natürlich ist es möglich eine
eigene 3D-Engine zu erstellen, die eine andere Anzahl von Seiten verwendet.
Wichtig ist, dass jedes Polygon konvex ist, ansonsten wäre der Algorithmus
die Scan-Konvertierung deutlich komplexer als die untersuchte im Punkt über
Füll- und Scanlinie.


				sCHLUSSBEMERKUNG 
==========================================================================

Zunächst danke ich Randy / RamJam (Fabio Ciucci), von dem ich die soliden 
Grundlagen des Assemblers auf 680x0 lernte und das unverzichtbare Wissen
über die OCS/ECS / AGA -Custom-Chips des legendären Amigas erwarb.
Nicht gleichgültig ist die Dankbarkeit, die ich für Igel (Hedgehog) habe
(Marco Ricci), Anbieter von vielen Informationen (die mir das Schreiben 
dieses Dokumentes erlaubt haben) einen nützlichen Ratgeber für
"Codierungstechniken".
Danke auch an Psyko / Vajrayana (Pasquale Mauriello), der mir
freundlicherweise Papiermaterial zum Studieren und Überprüfen
Teil meiner Kultur schickte.
Ich grüße alle italienischen Szeener, die hart arbeiten um eine 
Produktion zu erstellen, ob gut oder schlecht:
Wichtig ist, dass die Ergebnisse die Früchte der eigenen Arbeit sind.

Wenn jemand daran interessiert ist, die neueste Version dieser 
Textdatei kostenlos per E-Mail oder zur Kommunikation zu bekommen. Bei
Fehlern oder Ungenauigkeiten können Sie mich per E-Mail kontaktieren:

	  dayco@rgn.it

oder schreiben Sie mir per Post:

	  Cristiano Tagliamonte
	  Via Filippo Masci, 86/G
	  66100 Chieti


				______ ____ _    _    ___   _
			       / || __|| __||\  /|   / ||\ ||
			      //||||   ||_  | \/ |  //||| \||
			     /__ |||__ ||__ ||\/|| /__ |||\ |
			    //  |||___||___|||  ||//  |||| \|
			   ========================aCEmAN/bSd


*******************************************************************************
*	3. Datei 3d-wsb															  *	
*******************************************************************************

Il treddi' in Asm
			by Washburn / DarkAge

Zutaten:
1  Amiga 
1  cpu 68020+ (und Kenntnisse von asm)
2+ Mb Speicher (besser wenn mindestens 1MB fast)
1  hard disk
1  Assembler (besser wenn AsmOne v1.29)
1  chunky 2 planar

Einige Routinen für den Start eines Intro / Demos und die Initialisierung
der copperlist.


Also ... was bedeutet treddi '(von nun an 3d) ?
Dies bedeutet, dass sie nicht nur zur Darstellung geometrischer Figuren 
mit 2 Koordinaten (x, y) verwendet werden, sondern 3 (x, y, z), um auch die
"Tiefe" von einem Punkt im Raum zu identifizieren.

Wie können Sie ein 3D-Objekt auf einem 2D-Bildschirm visualisieren?
Es gibt verschiedene Methoden, um diese "Konvertierung" von 3d nach 2d
durchzuführen, die Projektion axonometrisch (die bei 120 Grad) oder die
die Projektion der Perspektive verwendet.

Die perspektivische Projektion funktioniert so:
Wenn ein Punkt eine Z-Koordinate hat, die kleiner ist als ein anderer Punkt,
dann wird dieser Punkt näher sein, d.h. eine kleinere Z-Koordinate entspricht
einem näheren Objekt.
All dies führt in der Praxis zu einer Punktteilung;
Teilen Sie einfach das X durch Z und das Y durch Z und das war's!
Einige Dinge müssen geklärt werden:

Was ist, wenn Z=0?
1) Eine Prozessor Trap Division-durch-0-(Fehler) tritt auf.
2) Warum möchten Sie ein Objekt zeichnen, das Sie eigentlich nicht sehen? =)

Der Bildschirm hat eine andere Ausrichtung der X- und Y-Achse als
die Ausrichtung der 3D-Achsen (siehe Abbildung), also bei den Berechnungen
der perspektivischen Projektion eines Punktes denken Sie daran, die 
Koordinaten der Bildschirmmitte hinzuzufügen.

Achsenorientierung

	^ Y					+---------------> X
	|  					|
	|  / Z				|       . -> Mitte des Bildschirms
	| /					|
	|/					|
	+------------> X	V Y

Lassen Sie uns jetzt mit AsmOne bewaffnen und versuchen, etwas zu entwerfen
(strickt in chunky).

Dann ist der Code für die perspektivische Projektion sehr einfach:

; chunky Bildschirmgröße
widht=320
height=256

	lea	punti3d,a0
	lea	chunky,a1
	move.w	punti,d7
	subq	#1,d7
Proj:
	movem	(a0)+,d0-d2	; liest die 3D-Koordinaten
	tst	d2				; wenn Z<=0
	ble.s	noproj		; projizieren Sie den Punkt nicht
	divs	d2,d0		; projiziert das X
	neg	d1				; das Y hat eine andere Ausrichtung
						; auf dem Bildschirm!
	divs	d2,d1		; projiziert das Y
	move.l	a1,a2		; Berechnung der Adressen der Punkte
	move	d1,d3		;
	and.l	#$ffff,d3	;
	mulu.l	#width,d3	;
	add.l	d3,a2		;
	add.w	d1,a2		;
	move.b	#$ff,(a2)	; Zeichnen Sie den Punkt
noproj	dbf	d7,proj
	rts

punti	dc.w	4		; 4 Punkte zu zeichnen
punti3d
	dc.w	0,0,1		; Koordinaten eines Quadrats
	dc.w	0,50,1
	dc.w	50,50,1
	dc.w	50,0,1

chunky	ds.b	width*height

Hinweis: Um den Punkt auf dem chunky Bildschirm zu zeichnen, müssen Sie die
Adresse des betreffenden Punktes berechnen und dann geben Sie die Farbe des
Punktes ein.


*******************************************************************************
*	4. Datei LEZIONE_MAT											    	  *	
*******************************************************************************

Mathe Lektion by Antonello Mincone
		

Für alle, die Spiele wie DOOM, ELITE oder andere Spiele die die Verwendung von
Polygonen erfordert mögen oder Effekte, die mittlerweile zum Standard in DEMOS
geworden sind, z.B. Textur-Mapping.
Ich glaube, es ist wichtig, einige der Grundformeln der Mathematik zu kennen,
insbesondere in Bezug auf analytische Geometrie und Trigonometrie. Wenn Sie 
diese Themen in der Schule noch nie verdaut haben oder sich einfach nicht
selbst gestellt haben und Sie haben immer davon gehört, das es etwas
unglaubliches kompliziertes ist, kann ich Ihnen versichern, dass es absolut
nicht wahr ist.
Die wahre Schwierigkeit ist es, das Thema sorgfältig zu verfolgen, aber vor
allem es zu verstehen.
In der Praxis ist der Rat, den ich Ihnen gebe, (auch basierend auf dem Wissen,
dass Sie haben) nach und nach sowohl mit dieser Lektion als auch mit dem Kurs
im Allgemeinen von dass alle Computer- und Mathematikbücher dieser Welt nur
die wesentlichen (aber nicht ausreichende) Grundlagen abbilden um ein gültiges
Programm zu schreiben: Sie werden vor allem mit Erfahrung gut, versuchen und
wiederholen Sie die Routinen, ändern Sie sie, kurz gesagt, experimentieren Sie.

Auf dieser Grundlage habe ich beschlossen, diesen Artikel zu schreiben, ohne
Ihnen einen Teil der Technik von 3D (auch weil es dafür absichtlich eine
Lektion gibt), beizubringen, aber die Basis, wird es Ihnen ermöglichen, die
Formeln selbst abzuleiten, um vorberechnete Tabelle, die Ihren Anforderungen
entsprechen zu machen.

Also fange ich von vorne an (na ja, nicht wirklich, da ich hoffe, dass Sie die
vier grundlegenden Operationen kennen, auch weil, wenn nicht, müssen Sie nicht
den Kurs nehmen, sondern die Grundlagen).

Lassen Sie uns zunächst darüber sprechen, wie Experten dieses Thema nennen
"ORTHOGONALES KOORDINATENSSYSTEM". Eigentlich verbirgt sich unter diesem Namen
eine sehr einfache Sache: zwei gemeinsame Linien (eine Linie die weder einen
Anfang noch ein Ende hat. Eine Linie, die einen Anfang und ein Ende hat,
heißt SEGMENT) so angeordnet, dass, wenn sie gekreuzt werden, vier Winkel von
90 Grad bilden, die herkömmlicherweise die Namen X und Y haben.
Praktisch wie folgt angeordnet:


			   ^
			 Y | 
			   |
			   |
			   |
			   |
			   |
			   |
	      -------------+-------------------->
			  O|                   X
			   |
			   |
			

Der Punkt O entspricht dem Schnittpunkt der Achsen und heißt Ursprung.   
Die X- und Y-Achse werden als Abszissenachse bzw. Ordinatenachse bezeichnet und
sie geben uns einen Hinweis auf jeden Punkt, der sich durch die Verfolgung der
Parallele zur X-Achse und der Parallele zur Y-Achse ergeben, was uns in der
Praxis die Entfernung X und die Höhe Y des Punktes in Bezug auf den Ursprung
sagt.

ein Punkt P:



			      ^     
			    Y |
			      |
			      |  x1  
			      |-----.P
			      |     |
			      |     |y1
			      |     |
		--------------+------------------>
			     O|                 X
			      |
			      |
			      



Das mit x1 markierte Segment gibt seine Abszisse an, während das mit y1
markierte Segment seine Ordinate angibt. Die Maßeinheit werden wir weglassen,
da wir mit dem AMIGA das Pixel verwenden. 
Beachten Sie, dass die Abszisse positiv ist, wenn der Punkt rechts von der
Y-Achse liegt (größer als 0 ist), während er auf der linken Seite negativ ist
(kleiner als 0 ist). Der Grenzfall ist, wenn es sich auf der Y-Achse befindet,
dann ist es 0.
Das gleiche gilt für die X-Achse: wenn der Punkt darüber liegt ist die Ordinate
positiv, darunter ist sie negativ, auf der x-Achse ist sie 0.
Wenn wir jedoch alles auf die Realität beziehen, erkennen wir, dass zwei
Dimensionen nicht ausreichend sind, da alle Objekte neben einer Höhe und
einer Breite, auch eine Tiefe haben, also brauchen wir eine dritte Dimension,
und gerade die Tiefe, erlaubt es uns, auf den individuellen Punkt im Raum zu
zeigen.

Ein Graph, das uns ein vollständiges Bild von einem Objekt im Raum geben will
wird von dieser Art sein:

		
				^
			  Y	|
				|
				|
				|         
				|        /
       			|     P / z1
		  x1 ___|_____./
		    	|     |
		    	|     |
		    	|     |y1
		    	|     | 
		       O+-----+---------------------->   
 		       /      |			    X                       
 		      /	      |	 
		     /	      |
		    /                                
		   /
		  /
		 /
	  Z /
	       	

Die neue Achse Z gibt die neue Dimension an. Es ist zu beachten, dass im Raum,
der Winkel zwischen der X-Achse und der Z-Achse und der zwischen der Y-Achse und
der Achse Z, gerade ist, also 90 Grad, die sich leider in der Projektion 
axonometrisch verformen (das ist genau diejenige, mit der alle Graphen
dargestellt werden).  
Bisher haben wir nur von Punkten gesprochen, während der uns umgebende Raum aus
viel komplexeren Objekten besteht, die im Allgemeinen aus Linien bestehen, die
die Kanten verbinden, die sie bestimmen. Oft ist es notwendig, krummlinige
Objekte, wie der einfache Kreis oder komplexere Kurven, durch komplizierte
goniometrische Formeln bestimmt darzustellen: in diesen Fällen mit
dem AMIGA, möchte ich die Kurve immer auf ein Polygon reduzieren, vielleicht
sogar mit 20 Seiten, aber das ist sicherlich schneller, in Rotationen oder
Translationen (Bewegungen, die nur eine Verschiebung beinhalten) zu zeichnen und
zu berechnen, aber Sie werden am Ende der Lektion die Formeln der wichtigsten
Kurven finden.
Um die Punkte der Polygone zu verbinden, können Sie im Allgemeinen die LINE-
Funktion des Blitters verwenden, aber das ist nicht immer das schnellste und
es könnte notwendig sein, diese Arbeit dem Prozessor anzuvertrauen: Daher ist
es nützlich, die grundlegende Formel des Linienzeichnens zu kennen.
Beginnen wir damit, dass jede Gerade auf den kartesischen Achsen durch
folgende Multiplikation beschrieben wird:

		Y = m*X + q
	 
Die fragliche Formel gibt uns die Ordinaten aller Punkte der zweiten Linie
zu seiner Abszisse. Es genügt, x durch einen beliebigen Wert zu ersetzen
und Sie erhalten das entsprechende y der Linie. Die Werte m und q in der
Formel sind Konstanten: Das erste m heißt Winkelkoeffizient und bestimmt
den Winkel (den Anstieg), den die Linie mit der X-Achse bildet (genauer gesagt
die Tangente dieses Winkels, aber wir werden dieses Thema später behandeln),
um so größer m ist, desto größer ist der gebildete Winkel; q bestimmt
stattdessen den Punkt, an dem die Linie die y-Achse schneidet, im Wesentlichen
den Punkt der Linie mit der Koordinaten: (0, q), daraus ist leicht zu
verstehen, dass bei q = 0 die Gerade durch den Ursprung der Achsen geht.	
Dann gibt es eine Formel, die meiner Meinung nach sehr wichtig ist, um ein 3D-
Programm zu erstellen. Gegeben sei ein Punkt P1 mit den Koordinaten (P1x, P1y)
und ein Punkt P2 mit den Koordinaten (P2x, P2y). Dann können wir die Gerade,
die durch diese beiden Punkte geht, mit dieser Formel berechnen:

	
		Y-P1y = (P2y-P1y)/(P2x-P1x)*(X-P1x)

Aus der fraglichen Formel leiten wir das ab :

		Y = (P2y-P1y)/(P2x-P1x)*X + (-P1x*(P2y-P1y)/(P2x-P1x))+P1y
		
Dies ist genau die Formel der Geraden, die durch die berücksichtigten Punkte
geht.
Der Wert, der vor dem X steht, entspricht dem m, während in der ganzen Formel
als nächstes das q erscheint, aber natürlich wird diese Berechnung nur einmal
für jede Zeile durchgeführt. Sie kann zum Beispiel für eine Linie
verwendet werden, die vom Bildschirm verschwindet: mit dem Extrem davon können
wir die Formel finden, die es bestimmt und daher ersetzen
Wenn wir die Abszisse der Bildschirmränder auf das X nehmen, können wir die
Koordinaten der Extrempunkte des sichtbaren Bereichs finden.

Andere Formeln, die sich oft als nützlich erweisen, wenn man die Koordinaten
von zwei Punkten P1 (P1x,P1y) und P2 (P2x,P2y) kennt, sind:

1) Um ihre Distanz zu finden (was in der Praxis eine Anwendung von des 
Satz des Pythagoras ist, den Sie weiter unten finden):

	Distanz = sqr((P2x-P1x)^2+(P2y-P1y)^2)

(sqr ist nichts anderes als die Anweisung, die von den meisten Hochsprachen 
verwendet wird, um die Quadratwurzel anzuzeigen, während das Symbol ^ bedeutet
Potenz (hoch): In diesem Fall ist der Abstand gleich der Quadratwurzel aus
der Differenz der Abszisse zum Quadrat addiert zur Differenz der Ordinate
zum Quadrat, als Formel:

			 _________________________________________
			/
		       / (P2x-P1x)*(P2x-P1x)+(P2y-P1y)*(P2y-P1y)
		   \  /
		    \/

Versuchen Sie Sqr und ^ zu verstehen und warum wir sie später oft wiederverwenden
werden)


Diese Formel ist zum Beispiel nützlich, um die Länge einer Seite eines
Polygons zu bestimmen, wenn wir die anderen beiden Seiten kennen.



2) Wenn wir die einzelnen zwei Punkte P1 (Px1, Py1) und P2 (Px2, Py2) kennen,
können wir die Koordinaten des Mittelpunkts M (XM, YM) mit der Formel finden:

			XM = (Px1 + Px2)/2

			YM = (Py1 + Py2)/2	   

******************************************************************************
An dieser Stelle würde ich sagen, dass sie auch die Lektion der Perspektive
nehmen können, da Sie jetzt jedes Objekt im Raum darstellen können (zeichnen
Sie einfach die Kanten und verbinden Sie sie mit dem Blitter, um eine Figur
flach oder fest zu bilden). Beachten Sie jedoch, dass Sie mit diesem Wissen
Objekte noch nicht drehen, sondern nur zoomen können. (dazu vergrößern oder
verkleinern Sie das Z jedes Punktes einfach).
Um einen Punkt zu drehen, müssen wir in die Trigonometrie eingehen, indem
wir den Sinus und Kosinus einführen. Diese beiden sind nichts anderes als die
Abszisse und die Ordinate eines Punktes, der die Eigenschaft hat, sich auf
einem Umkreis zu befinden, der den Ursprung als Mittelpunkt hat.

		   ^ 
   				 Y |
   				   |
   				   |
   				   |
	 			___|___
   		       /   |   \.P
   		      |	   |    |
   	     ---------+----+----+-------->
   		      |	  O|    |       X
   		       \___|___/
   				   | 
   				   |
   				   |
   				   |	
				
Auch wenn das, was ich gezeichnet habe, ein unregelmäßiges Achteck ist (aber
was wollen sie?, da es mit ASCII-Zeichen erstellt ist, konnte ich es nicht
besser machen), aber mit ein bisschen Fantasie sollten sie eine Vorstellung
davon haben, was ich meine. Kurz gesagt der Kosinus ist der Abstand des
Punktes P von der Y-Achse, während der Sinus der Abstand des Punktes P von
der X-Achse ist. 
Konventionell (aber nicht nur dafür) wird der Radius des Kreises als gleich 1
angesehen. Auf diese Weise oszillieren sowohl der Sinus als auch der Kosinus
immer zwischen Werten zwischen 1 und -1 (im Wesentlichen Zahlen mit
Dezimalstellen).
Es ist auch zu beachten, dass der Punkt P auch einen Winkel auf dem Umfang
bezeichnet, der zwischen der X-Achse und der durch den Punkt P und dem
Achsenursprung verlaufenden Geraden gebildet wird.
Wenn wir beispielsweise sagen, dass der Sinus von 30 Grad 0,5 beträgt, bedeutet
dies, dass der Punkt P, der, verbunden ist mit dem O (Ursprung der Achsen), mit
der X-Achse einen Winkel von 30 Grad, ist 0,5 bildet.
Um auch den Kosinus des betrachteten Winkels zu finden, können wir eine einfache
Beobachtung, basierend auf dem Satz des Pythagoras machen (nicht Coder).
Für diejenigen, die dies nicht wissen, was hier einer der Hauptsätze der
Geometrie ist hier eine kurze Erklärung:
Gegeben ist ein rechtwinkliges Dreieck (das einen Winkel von 90 Grad hat), wenn
man die Länge der beiden Seiten (das wären die kürzeren Seiten) nimmt, können
wir die Hypotenuse (die lange Seite) berechnen, da dies gleich der
Quadratwurzel aus der Summe der Quadrate der beiden Seiten ist.


		|\
		| \
		|  \
		|   \  c
	      a |    \ 
		|     \
		|      \
		|       \
		|________\
		    
		    b 


In diesem Fall sind a und b die Seiten. Um c zu finden, müssen wir die Quadrat-
wurzel von a * a + b * b berechnen (was wir auch als a^2+b^2 schreiben können).
Im Allgemeinen dann:

		    c^2 = a^2 + b^2

Um auf den Umfang zurückzukommen, den wir betrachtet haben, bemerken wir hier
auch das Vorhandensein eines rechtwinkligen Dreiecks, dessen Seiten die
Abszisse und die Ordinate des Punktes P und als Hypotenuse die Strecke OP ist,
die in der Praxis gleich dem Radius und dann 1 ist. Im obigen Beispiel, wo
wir den Sinus von 30 Grad kannten, können wir den entsprechenden Kosinus finden
(was in der Praxis die Abszisse wäre):
  
			     ^
			   Y |
 							 |
 							 |
 							 |
 							 |
 						  ___|___
 						 /   |___\.P 
 						|    | b  |a 
 				   -------------+----+----+-------------->
 						|   O|    |             X
 						 \___|___/ 
 							 |
 							 |
 							 |
 							 |
 							 |
 							 |
 							 |
 			     
		     	
Tatsächlich ist in diesem Fall a = 0,5 und OP (den ich aus grafischen Gründen
nicht gezeichnet habe) ist gleich 1. Dabei ist der Winkel zwischen a und b von
90 Grad, ersetzt die Terme.
Beachten Sie in der vorherigen Gleichung, dass wir Folgendes haben:

		      1^2 = 0.5^2 + b^2
		       
Wenn wir die Bruchform 1/2 für 0,5 setzen, können wir schreiben:

		      1 = 1/2^2 + b^2
		      
Aus denen dann wird:
		     
					  1 = 1/4 + b^2

und dann:

					  b^2 = 1 - 1/4

		      b^2 = 3/4

Wir können daraus schließen, dass b = sqr (3/4) (sqr ist nichts anderes als die
aus den meisten Hochsprachen, um hier die Wurzel quadratisch anzugeben
In unserem Fall gelesen ist b ist gleich der Wurzel von 3/4)   

*******************************************************************************
*	5. Datei Texture_Wasb													  *	
*******************************************************************************

HAHAAA!! Ich hätte nie gedacht, dass ich ein Dokument über tmap schreiben
würde; es gibt so viele im Internet; Wenn Sie eine interessante bekommen
möchten, gehen Sie auf www.altavista.digital.com und suchen Sie nach
"Textur-Mapping" (streng mit dem <">) und Sie sollten eine ~ 63k-Datei finden;
die sehr interessant ist, weil es die Grundlagen erklärt; Ansonsten sollten
sie alles haben, was sie brauchen :-)

Haben Sie zuerst eine Scanline-Routine? Wenn Sie es nicht haben, lesen Sie
hier sonst direkt zum nächsten springen.

*** Scanline ***

Was ist eine Scanline-Routine?
Da der Bildschirm beim Füllen eines Polygons aus Linien besteht (jede Form)
muss dieses Polygon in Linien horizontal "konvertiert" werden, so dass nur
Linien auf dem Bildschirm gefüllt werden. Beispielsweise wird ein solches
Dreieck in horizontale Linien umgewandelt.
	 .                   .
	/ \       --\       ...
       /   \      --/      .....
      /     \             .......
	  ¯¯¯¯¯¯¯
Um ein Polygon zu füllen, müssen Sie wissen, wie viele horizontale Linien es sind
Format plus die Zeilenenden. Dazu werden normalerweise zwei Tabellen verwendet
so groß wie die Zeilenlänge des Bildschirms. Eine enthält die Extreme rechts von
den Linien und die anderen die für links.

An diesem Punkt fragen Sie sich vielleicht, wie Sie die Tabellen richtig machen
sollen? Nun, das ist alles sehr einfach, Sie müssen nur die x-Koordinate
entlang der y interpolieren (sie rieten mir, den Bresenham-Algorithmus nicht
zu verwenden, weil die normale Interpolation etwas schneller ist).

Kehren wir also zum Dreieck zurück (unter Berücksichtigung der Eckpunkte).

      1->.         p1=(25,0)
	/ \        p2=(0,25)
       /   \       p3=(50,25)
   2->/     \<-3
      ¯¯¯¯¯¯¯
In den Tabellen müssen Sie also Folgendes haben:

     tab1   tab2      Um die Tabellen zu erstellen, machen wir das ± so:
0     25     25
1     24     26       dx=(p2.x-p1.x)/(p2.y-p1.y)
2     23     27       dann
3     22     28       x=p1.x;
4     21     29       for y=p1.y to p2.y
5     20     30        if tab1[y]<>0 then tab1[y]=x else tab2[y]=p1.x
6     19     31        x=x+dx
:     :      :        next
:     :      :
23    2      48
24    1      49
25    0      50
:
:
(andere Werte, die uns nicht interessieren)

Dort 6? An diesem Punkt machen Sie eine Schleife, die für jeden Wert von y
nachsieht, ob es von Zeichnen einer horizontale Linie gibt (dh wenn Tab1 [y]
und Tab2 [y] unterschiedlich sind von 0), dann haben Sie also die Endpunkte
der Linie und ihre y-Koordinate.
Im Beispiel machen Sie einen typischen Zyklus:
	for y=0 to 50
	 line (tab1[y],y,tab2[y],y)
	next
und es ist geschafft! Sie haben ein Dreieck 1 gefüllt! :-)
Ich hoffe ich war einfach genug in der Erklärung :-)

*** Texture Mapping ***

Was ist Textur-Mapping? Es ist nichts weiter als das Füllen eines Polygons,
jedoch anstatt immer die gleiche Farbe zu verwenden, wird eine Reihe von Farben
von einem anderen Bild genommen. Das Problem liegt darin, die Farben in die
Reihenfolge zu bringen und dafür gibt es verschiedene Algorithmen:
1) polygon grandients: Werte berechnen (aus einigen Vektorberechnungen 
   entnommen) und verwendet, um die Pixelfarbe mit Formeln zu berechnen
   u=k1+a/c
   v=k2+b/c
   Farbe= txt[u,v] -> gewöhnen sie sich daran, denn die Koordinaten auf der
			 Textur werden immer  durch die Variablen u, v identifiziert :)
   Dies ist die Methode zum Texturieren von Polygonen in 3D. Schönes Gefühl,
   die Textur als 3D-Ebene zu sehen, es ist die "Perspektive Korrektur"
   die (glaube ich) in Hardware-3D-Beschleunigern verwendet wird :)
   es per Software zu machen ist sehr langsam !!
2) zwei Divs pro Scanline: berechnet das u, v an den Enden der Scanlinie (wie
   in der Scanlinie, nur anstatt nur das x zu interpolieren, interpolieren wir
   hier auch das u, v auf der Seite des Polygons) und dann interpolieren wir
   die u, v entlang der Scanlinie:
   u=u0+du*(x-x0)
   v=v0+dv*(x-x0)
   wo es ist 
   u0=u am Anfang der Scanlinie     u1=u  am Ende
   v0=v  """""""""""""""""""""""    v1=v  "    "
   du=(u1-u0)/(tab2[y]-tab1[y])
   dv=(v1-v0)/ """"""""""""""
   x-x0 = Differenz zwischen dem aktuellen x (x) und x am Anfang der Scanlinie
   >>> Funktioniert mit jedem Polygon
3) zwei Divs pro Polygon: berechnet die Inkremente dv/dx und du/dx für das
   ganze Polygon und verwendet es, um die Koordinaten zu interpolieren:
   u=u0+du*(x-x0)
   v=v0+dv*(x-x0)
   du=(u1-u0)/(Länge der maximalen Scanlinie)
   dv=(v1-v0)/(""""""""""""""""""""""""""""")
   u1,u0,v1,v0: Werte von u, v an den Extremen der maximalen Scanlinie
   >>>> Funktioniert nur mit Dreiecken
   Diese beiden Methoden sind das sogenannte "Textur Mapping" zu 2d, weil in
   der Praxis, wird die Textur zwischen den Eckpunkten der Polygone "skaliert"
   und jedem Scheitelpunkt des Polygons ist ein Punkt auf der Textur
   zuwgewiesen und interpoliert dann linear das u, v entlang der Scanlinie.   
   Die Verwendung dieser Methoden führt zu einem sehr schnellen Textur-Mapping,
   aber leider sehr ungenau, weil sie Verzerrungen entlang der Textures
   beachten können (insbesondere bei der Verwendung Dreiecke :( 
   und ich weiß etwas darüber!   
   Versuche die Karte zu sehen, die ich gemacht habe und Sie werden
   feststellen, dass beim Drehen, die Textur in zwei Teile "geteilt" ist
   entlang der Diagonale der Fläche!

Grundsätzlich sind dies die bekanntesten Routinen zur Herstellung von Textur
Mapping. Jetzt zeige ich Ihnen ein Beispiel für einen möglichen Zyklus von
Textur Mapping (pwr-Dreiecke):

loop:
 scanline(); <- Scanline-Tabellen berechnen
 tmap()
 goto loop;

tmap()
 Berechnung du/dy,dv/dy
 interpoliere das u, v entlang der linken Seite des Dreiecks
 berechnet du/dx, dv/dx für die maximale Scanlinie
 for y=ymin to ymax (des Dreiecks)
  u=u[y]
  v=v[y]
  for x=tab1[y] to tab2[y]
   plot(x,y,txt[u,v])
   u=u+du
   v=v+dv
  next x
 next y
endproc tmap

Jetzt wissen Sie ± oder nicht, was ich auch über die tmap weiß. Es ist nur eine
Frage des  alles in asm übersetzens und fang an etwas zu drehen .... :) Ich
bin jetzt zu env-mapping gekommen, um viel komplexere Objekte zu erfassen als 
die "üblichen" Würfel. Ich mache die Objekte mit Bildern und konvertiere sie
dann mit der tddd2raw und einem anderen von mir hergestellter Konverter und ich
habe auf Modem  ein Beispiel für env-map gestellt. Ergebnis? Auf meinem
dürftigen a1200 gehen die Routinen zu 1x1 in 5fps; auf seine bei 50fps!!!! :))) 
Alles erklärt sich aus der Tatsache, dass der 030 den Datencache hat und 
sein Ami hat das fast (sehr wichtig).

Wenn Sie noch etwas zu fragen haben, fahren Sie fort! :-)

Ps: Ich habe den Rotator noch einmal überprüft, weil ich einige Dinge sehen
	wollte. Sie wissen anscheinend nicht, wie man Dezimalstellen hinzufügt!
    Der Rotator ist nicht so genau, wie Sie möchten. Jetzt erkläre ich ihnen
	den "Trick" (erklärt von Hedgehog):

Wenn Sie etwas interpolieren müssen, tun Sie so etwas:

x=a0+da/db*b
was zu einem Zyklus führt
a=a0
loop:
 a=a+da/db  da/db ist das Inkrement von "a", wenn zu "b" gewechselt wird.
 :
goto loop

im Assembler übersetzt sich alles in:

; Berechnung da/db
; a1,a0 Werte, die entlang b1, b0 interpoliert werden sollen
	move.w   a1,d0
	sub.w    a0,d0 ; a1-a0
	move.w   b1,d1
	sub.w    b0,d1 ; b1-b0
	swap     d0    ; (a1-a0)<<16
	divs.l   d1,d0 ; da/db verschobenes Inkrement von 16 für den Dezimalteil
				   ; so dass Bit 31..16 15..0
				   ;                   d0 = ganze Dezimalstelle

	move.l   d0,dadb  ;  das Inkrement speichern
	:
	: andere Anweisungen
	:
	move.w   a0,d0 ; Ursprünglicher Wert
	swap     d0    ; a0<<16
	move.l   dadb,d1
	loop:
	add.l    d1,d0 ; (a+da/db)<<16
	move.l   d0,d2
	swap     d2    ; Ganzzahliger Wert in d2.w, den Sie benötigen
	:
	:
	dbra     d4,loop

Alles kann vereinfacht werden (und vor allem 1 oder sogar 2 Anweisungen 
entfernen in der Schleife) mit dem Addx:

Die Berechnung von da/db ist nur in Ordnung, wenn Sie vor dem Speichern einen
"Swap d0" durchführen, um den Dezimalteil im oberen und im unteren Wort den
ganzen Teil (derjenige, der uns am meisten interessiert) zu haben. Dann, wenn
Sie das Inkrement zur aktuellen Variablen hinzufügen müssen sie Folgendes
machen:

add.l    d1,d0
addx.w   d3,d0 ; >>> in d3 muss es 0 sein!!! <<<

In d0.w haben Sie also sofort die nutzbare Variable und einen Swap gespart!
(4 Zyklen von 020) was nicht schlecht ist! ;))
Das Addx wird verwendet, weil wenn es zu einem Übetrag vom Dezimalteil kommt,
dieser hinzugefügt word (dafür muss d3 gleich 0 sein), also der Dezimalteil ;))
Es überrascht nicht, dass Sie in der Datei mit den schnellsten inneren
Schleifen das Addx anstelle von adds gefolgt von einem swap finden!

Pss: Wenn Sie möchten, geben Sie auch dieses Dokument weiter, damit ich
     vielleicht berühmter werde! ;))


Liebenswürdig,

/
\/\/ashburn / X-Zone & DeGeNeRaTiOn

Email: simon@digicolor.lognet.it
Snail:
 Aversa Simone
 Via F.Novati 27
 26100 Cremona
 Italy

 
*******************************************************************************
*	6. Datei TextureMapping													  *	
*******************************************************************************


	    ----- ZUSAMMENFASSUNG DER THEMEN -----

 - Prämisse

 - Hinweise zum Format von Festkommazahlen

 - Was ist Textur-Mapping?

 - Wie wird Textur-Mapping in Echtzeitanwendungen implementiert?
   - EIN ERSTES EINFACHES BEISPIEL
   - Kommen wir zu etwas Konkreterem
   - Böden und Decken

 - Die Berechnung der zu verfolgenden Szene
   - Ray-casting
   - BSP trees

 - Wir gehen die Treppe hoch !

 - Wir erleuchten unsere Welt

 - Texture mapping und Amiga
   - Umwandlung chunky to planar
   - Das copper chunky


----------------------------------------------------------------------


Prämisse
--------

 Dieser Artikel hat den Zweck (und den Anspruch), auf möglichst einfache
Weise die Prinzipien hinter dem Texturmapping in Echtzeit zu erklären,
mit besonderem Bezug auf einige von mir bei der Erstellung der
BREATHLESS-Videospiel-Engine verwendeten Techniken.
Es wurde in der kurzen Zeit geschrieben, von der ich frei war von der
BREATHLESS Programmierung, Arbeitsverpflichtungen und mein Mädchen,
daher kann und sollte es nicht als Quelle unerschöpfliches Wissens
angesehen werden, sondern nur als hervorragender Ausgangspunkt
für ein so spannendes und aktuelles Thema. Trotzdem kann ich
zweifellos jedem Leser dieses Artikels versichern, dass Sie sich 
eine Menge schlafloser Nächte ersparen werden, Nächte, die ich
verzweifelt versucht habe herauszufinden, wie sie es gemacht haben,
mit Software, dieses Meisterwerk zu schaffen, das Doom ist. 

 Aufgrund der Komplexität des Themas wird eine gewisse Erfahrung 
in der Assemblerprogrammierung und auf jeden Fall eine große Dosis von
guten Willen vorausgesetzt. Mein Rat ist, den Artikel mehrmals zu lesen,
sowie die Quellen und die angehängte Dokumentation. Für jedes
vertiefende Studium, auch bezogen auf 3D im Allgemeinen, Verweise
ich auf Bücher und andere Artikel.

 Ein gutes Lesen dieses Artikels ist ohne gute Kenntnisse der
Amiga-Struktur und des 68000+ Aufbaus nicht möglich. Der Leser sollte
also mit solchen Argumenten vertraut sein. Es ist aus offensichtlichen
Gründen unmöglich darauf einzugehen.

 Der Artikel ist absichtlich sehr einfach gehalten um zu komplexe oder
zu starre Ausführungen nmathematischer Formalismen zu vermeiden, um ein
leichtes Lesen für so viele Menschen wie möglich zu erreichen.

 Sofern nicht anders angegeben, beziehen sich alle Referenzen bezüglich
des Hardware-Teils auf AGA-Maschinen.

 Die gezeigten Codebeispiele sind in Pseudosprache geschrieben,
oder in Assembler und dienen nur zu Bildungszwecken. Dies
bedeutet, dass sie nicht optimal optimiert sind und dass sie nicht
getestet wurden, so dass das Vorliegen von Fehlern nicht ausgeschlossen
ist.

Die Achsen des Bezugssystems im Raum sind wie folgt orientiert:


      Y ^
	|
	|
	|
	| 
	+--------> X
       /
      /
     /
    Z




Hinweise zum Format von Festkommazahlen
---------------------------------------------

 Bei der Ausarbeitung von dreidimensionalen Objekten gibt es sehr oft etwas
mit Nicht-Ganzzahlen zu machen. Diese Art von Datentypen sind häufig in 
Hochsprachen wie C und BASIC implementiert, die das Gleitkommaformat
verwenden. Mit diesem Format ist es möglich einen großen Satz von
Dezimalzahlen darzustellen, die an Genauigkeit nur wenn unbedingt
notwendig verlieren.

  In Assembler sind die Dinge entschieden anders nicht nur dass man
keine FPU zur Verfügung hat, ist die Verwendung des Gleitkommaformats
von Zahlen absolut undenkbar, denn selbst eine einfache Addition sollte
aus einer Routine von einer gewissen Komplexität erreicht werden.

 Wir verwenden dann das Festkommaformat, mit dem es möglich ist,
Dezimalzahlen mit normalen Zahlen (Ganzzahlen) darzustellen und dann die
Register von 68000. Es ist jedoch notwendig im Voraus zu entscheiden,
wie viele Bits Sie dem ganzen Teil und wie viele dem Bruchteil widmen
möchten und dies führt zu einer knappen Flexibilität dieser Art der
Darstellung. Unser Ziel ist es jedoch die Operationen auf dem 
Dezimalzahlen so schnell wie möglich auszuführen, für die ein gewisser
Kompromiss eingegangen werden muss.

Indem man angibt, dass eine Zahl im Festkommaformat vorliegt, muss man also
angeben, aus wie vielen Bits der Integer-Anteil besteht und wie viele Bits
der der composed Bruchteil hat. Als Notation wird im Allgemeinen x.y
verwendet, wobei x die Anzahl der Bits ist, die dem ganzzahligen Teil
gewidmet sind und y die Anzahl der Bits für den Bruchteil. Also wenn wir zum
Beispiel 24.8 schreiben, sagen wir, dass die Zahl aus 24 Bit für den
Ganzzahl-Teil und 8-Bit für den Bruchteil besteht. Normalerweise wird die
Übergröße 16,16 verwendet (16 Bit ganzzahliger Teil und 16 Bit Bruchteil),
und darauf wird im Folgenden Bezug genommen. Aus offensichtlichen
Gründen ist es praktisch, dass die Summe der Bits, der beiden
Teile gleich der Anzahl der Bits des längsten Wortes ist, die der
Prozessor in der Lage ist, in unserem Fall 32.

 Die Umrechnung von einer Dezimalzahl in eine Festkommazahl und
umgekehrt erfolgt unter Berücksichtigung der einfachen Formel:

 Festpunkt = INT(dezimal * 2^bit_fractional_part)

 Zum Beispiel ist die Dezimalzahl 12.3456, umgewandelt in das Format 16.16,
gleich 12,3456 * 65536 = 809081 (der Bruchteil geht offensichtlich
verloren), während die Rückumwandlung 809081/65536 = 12,34559631 ist.  Wie
vielleicht festgestellt haben werden, gibts es einen Präzisionsverlust,
der umso begrenzter ist, je höher die Anzahl der Bits ist, die dem Bruchteil
zugeordnet sind.

Die Summe zweier Festkommazahlen erfolgt ohne besondere Vorsicht in
Bezug auf ganze Zahlen. Mit der Anweisung

    add.l  d0,d1

mehr braucht es nicht um zwei Festkommazahlen die in d0 bzw. d1 enthalten
sind zu addieren.

 Die Rede ist in Bezug auf die Divisionen und Multiplikationen etwas 
komplexer. Bitte erlauben Sie mir die Näherung, in der
folgenden Aussage: eine Dezimalzahl A, in ihrer Form in
Fixpunkt ist gleich A * K, wobei K 2 ^ bit_fractional_part ist. Das
Produkt der beiden Dezimalzahlen A und B im Festkommaformat,
ist gültig:

    A*K * B*K = (A * B) * K^2

 Um das gewünschte Ergebnis (A * B * K) zu erhalten, ist es daher eine 
Division durch K (oder besser eine Verschiebung um 16 Bit nach rechts)
notwendig.

 Ebenso gilt die Division zweier Zahlen A und B:

    A*K / B*K = A / B

 Um zu verhindern, dass der Bruchteil gelöscht wird, reicht es aus
den Dividenden mit K zu multipliziere:

    A*K*K / B*K = (A / B) * K

 Mikroprozessoren ab 68020 sind besonders vielseitig als die Implementierung
von Festkommazahlen, da sie mit präzisen Multiplikations- und
Divisionsanweisungen verlängert ausgestattet sind. Wir dürfen jedoch nicht
vergessen, dass diese Anleitung sowieso langsamer als normal ist, daher
kann es in einigen Fällen sein, das es vorzuziehen ist, Festkommazahlen
zu verwenden, die ein Wort anstatt in einem langen Wort eingeben.



Was ist Textur-Mapping?
-------------------------

 Texture Mapping ist eine Technik zum "Aufkleben" eines grafischen Bildes
in eine Bitmap (Pinsel) oder einem mathematisch berechneten Bild (Textur
algorithmisch) zu Polygonen oder allgemeiner zu einer beliebigen 
dreidimensionalen Entität.
 Normale Vektorgrafiken wirken etwas kahl und unwirklich, in wenn jedes
Objekt aus einer Menge von Polygonen besteht, die jede mit einer einzigen
Farbe gefüllt ist.
Textur-Mapping verleiht einfachen Polygonen mehr Realismus
und größere Tiefe, sodass Sie virtuelle Umgebungen erstellen können
viel schöner und daher spektakulärer.

 Wir haben also ein zweidimensionales Bild mit bekannten Dimensionen
(unsere Textur), auf die wir durch Koordinaten (u,v) zugreifen können,
um die Farbe eines Punktes zu kennen.Aus offensichtlichen Gründen wird 
die Textur im chunky pixelformat im Speicher abgelegt (jedes Pixel
entspricht einem Byte), also als Array von Bytes.
 Wenn wir die Textur einem Polygon im Raum zuordnen möchten, müssen wir
ein System finden, das es uns ermöglicht, jedem Punkt (x,y z) 
des Polygons im Raum, ein Punkt (u, v) der Textur zuzuordnen.
Das Polygon im Raum gehört zu einer Ebene, der wir ein zweidimensionales
Bezugssystem zuordnen, definiert durch einen Ursprung und zwei Vektoren.
 Wenn das Polygon ein Rechteck ist, wählen Sie einfach als Ursprung
die erste Ecke aus und berechnen die Komponenten der Vektoreinheiten
ausgehend von zwei Seiten, die den ersten Eckpunkt gemeinsam haben.

 So sagte:

  P(x,y,z) der generische Punkt des Polygons, dessen Farbe wir berechnen
	   wollen;

  T(u,v)   der mit P . verbundene Texturpunkt;

  O        der Ursprung des Bezugssystems des Polygons;

  i, j     die Vektoreinheiten des Bezugssystems des Polygons;

  *        das Punktproduktsymbol;

 wir können schreiben:

  T = ((P-O)*i,(P-O)*j)

 Wir kennen nun die Koordinaten des Punktes T (u,v), für die wir 
die Farbe von Punkt P aus der Textur ablesen.

 Wie Sie sehen, sind die Berechnungen für jeden Punkt vielzu 
komplex für eine Echtzeitanwendung.  Wie ist es ein
vereinfachen und beschleunigen möglich?

 Ein wichtiger erster Schritt besteht darin, das Problem zu vereinfachen.
Unser Ziel ist es, einen engine zu schaffen, die es uns ermöglicht in
einer dreidimensionalen Welt zu "Wandern", dazu genügt es, sich nach
links oder rechts bewegen zu können und zu schauen.  Dies führt zu einigen
Vereinfachungen, die den engine deutlich schneller machen:

 a) Wände und Böden müssen senkrecht zueinander stehen
 b) es ist möglich, die Position des Beobachters nur auf den Achsen X und Z
    zu ändern und nicht auf der Y-Achse
 c) Sie können Ihren Blick nur um die Y-Achse drehen

   Das bedeutet, dass unsere Welt eigentlich zweidimensional ist.
Unsere Absicht ist es, es dreidimensional aussehen zu lassen.



Wie wird Textur-Mapping in Echtzeitanwendungen implementiert?
----------------------------------------------------------------------

EIN ERSTES EINFACHES BEISPIEL
-----------------------------

 Nehmen wir an, wir möchten einen Pinsel mit einer Dimension von 128x128 Pixel
als Textur verwenden und möchten es einem quadratischen Polygon zuordnen,
welcher einmal gedreht, verschoben und in 2D projiziert, auf dem Bildschirm
als Quadrat mit einer Größe von 64x64 Pixeln erscheint. Trivialerweise,
ist es notwendig, auf dem Quadrat auf dem Bildschirm nur ein Pixel alle 2
(2 = 128/64) zu zeichnen. Hat das Quadrat auf dem Bildschirm hingegen die
Abmessungen 32x32 Pixel, zeichnen Sie einfach alle 4 Pixel ein Pixel
(4 = 128/32).
Es ist daher leicht zu verstehen, wie wichtig die einfache Beziehung ist:

   Step = BrushDim / ScreenDim

 dove:

   Step      : Tonhöhe (dies ist eine Kommazahl)
   BrushDim  : Anfangsgröße des Strahls
   ScreenDim : Bildschirmgröße des Strahls

 Wenn Sie die Textur einem Quadrat auf dem Bildschirm zuordnen möchten,
 von der Seite gleich ScreenDim könnten wir so etwas schreiben wie:

 Step = BrushDim / ScreenDim
 for y=0 to ScreenDim 
     v = y * Step;
     for x=0 to ScreenDim
	 u = x * Step
	 WriteScreenPixel(x,y,ReadTexturePixel(u,v))
     endfor
 endfor

dove:

 Step, u, v               es sind Variablen mit Gleitkomma

 ReadTexturePixel(u,v)    ist die Funktion, die die Farbe des Pixels liest
			  Koordinaten (u,v) der Textur;

 WriteScreenPixel(x,y,c)  ist die Funktion, die ein Farbpixel auf dem 
			  Bildschirm bei (x,y)-Koordinaten schreibt.

 Aber was uns wichtig ist, ist Geschwindigkeit, und diese Routine ist immer
noch definitiv langsam. Zuallererst braucht es einen direkten Zugang
zum Speicher und langsame Anweisungen zu eliminieren (wie Multiplikationen):

 Step = BrushDim / ScreenDim
 v = 0
 for y=0 to ScreenDim
     u = 0
     screen = ScreenBase + 320 * y
     for x=0 to ScreenDim
	 screen[x] = texture[v][u]
	 u += Step
     endfor
     v += Step
 endfor

dove:

 ScreenBase    ist die Adresse eines Bildschirms in chunky pixel;

 Wie Sie sehen, wurden Multiplikationen durch Summen ersetzt, während zum
Lesen von Pixeln aus der Textur und zum Schreiben in den Speicher auf dem
Bildschirm die Arrays screen [] und texture [][]verwendet wurden.
Darüber hinaus sind sowohl die Textur als auch der Bildschirm in chunky
Pixel organisiert.

 Um es besser zu machen, ist es bequemer, zum Assembler zu wechseln:

;a0 = ptr zur Textur
;a1 = ptr Bildschirm chunky
;d0 = u (im 16.16-Format, d.h. 16 ganzzahlige Bits und 16 fraktionierte Bits)
;d1 = v (im Format 16.16)
;d2 = offset innerhalb der Textur
;d4 = Step (im Format 16.16)
;d5 = ScreenDim * 320
;d6 = x
;d7 = y

	moveq   #0,d1           ; v=0
	move.w  ScreenDim,d5
	mulu.w  #320,d5         ; sie wissen, wie man das optimiert, oder?
	moveq   #0,d7           ; initialisieren x
loopy   moveq   #0,d0           ; u=0
	move.l  ScreenBase,a0
	add.l   d7,a0           ; a0=ptr zur aktuellen Zeile auf dem Bildschirm
	move.l  d1,d2
	clr.w   d2
	swap    d2
	lsl.w   #8,d2           ; d2=offset aktuelle Texturreihe
	move.w  ScreenDim,d6
	subq.w  #1,d6           ; initialisieren y
loopx   swap    d0
	move.b  d0,d2
	swap    d0
	move.b  (a1,d2.l),(a0)+	; Textur-auf-Bildschirm-Pixel kopieren
	add.l   d4,d0           ; u+=Step
	dbra    d6,loopx
	add.l   d4,d1           ; v+=Step
	add.l   #320,d7
	cmp.l   d5,d7
	bne     loopy


 Wie Sie leicht erraten können, funktioniert das hier gezeigte Beispiel nicht
anders als der Zoom eines Pinsels, da der ScreenDim variiert, aber es ist
von großer Bedeutung für das Verständnis der Prinzipien, die
die Basis des Textur-Mappings und seiner Implementierung in
Echtzeitanwendungen ist.

 Es ist wichtig zu beachten, dass das obige Quadrat in eine Reihe von
horizontalen Strichen unterteilt ist. Jeder Strich ist wiederum aus einer
bestimmten Anzahl von Pixeln zusammengesetzt. An dieser Stelle werden die zu
verfolgenden Pixel auf dem Bildschirm vom Strahl immer mit einem Schritt
im gleichen Abstand voneinander "abgetastet".

 Schauen Sie sich dieses einfache Beispiel an, wo der Originalpinsel die
Abmessungen von 10x10 Pixeln hat, während die Videoabmessungen 5x5 betragen.
 Der Step-Wert ist offensichtlich 10/5 = 2, also vom Pinsel. Es werden nur
horizontale gerade Striche ausgewählt und in jedem Strich nur die geraden Pixel:


	 Brush 10x10               Auf video 5x5

     A . B . C . D . E .
     . . . . . . . . . .
     F . G . H . I . J .            A B C D E
     . . . . . . . . . .            F G H I J
     K . L . M . N . O .     --->   K L M N O
     . . . . . . . . . .            P Q R S T
     P . Q . R . S . T .            U V W X Y
     . . . . . . . . . .
     U . V . W . X . Y .
     . . . . . . . . . .


Wenn die Abmessungen auf dem Bildschirm hingegen 4x4 sind, hat Step einen
geraden Wert, d.h. 10/4 = 2,5 und das Ergebnis ist:


	 Brush 10x10               Auf video 4x4

     A . B . . C . D . .
     . . . . . . . . . .
     E . F . . G . H . .            A B C D
     . . . . . . . . . .            E F G H
     . . . . . . . . . .     --->   I J K L
     I . J . . K . L . .            M N O P
     . . . . . . . . . .
     M . N . . O . P . .
     . . . . . . . . . .
     . . . . . . . . . .




Kommen wir zu etwas Konkreterem
------------------------------------

 Es wurde bereits gesagt, dass die dreidimensionale Welt, in der wir uns
befinden nur vertikale Wände hat und die einzige Drehung die erlaubt ist,
ist um die Y-Achse. Jede Wand ist einfach durch ein Polygon dargestellt.
Das gleiche gilt für jedes Stück Boden oder Decke.

 Nehmen wir also an, wir müssen die Textur einem um die Y-Achse gedrehten
Quadrat zuordnen. Das Quadrat erscheint auf dem Bildschirm als Trapez
um 90 Grad gedreht und stellt eine Wand dar:

     |\
     | \
     |  \
     |   \
     |    |
     |    |
     |    |
     |   /
     |  /
     | /
     |/

 Wie Sie unschwer erkennen können, besteht diese Figur aus einer Serie
von vertikalen Strichen abnehmender Länge, demzufolge auch einer 
Anzahl der Pixel die sinkt. Für jeden vertikalen Strich ist es
 einfach einen Zyklus ähnlich dem folgenden auszuführen:


loop    move.b  (a0,d0.w),(a1)  ; Kopiere das Pixel
	add.w   d3,d1           ; den Bruchteil hinzufügen 
	addx.w  d2,d0           ; den ganzzahligen Teil hinzufügen (+ Übertrag)
	adda.l  d4,a1           ; Bewegen Sie den Ptr. zum Bildschirm
	dbra    d7,loop

dove:

 d0 = ganzer Teil des Zählers
 d1 = Bruchteil des Meters
 d2 = ganzer Teil des Schrittes
 d3 = Bruchteil des Schrittes
 d4 = Anzahl der Pixel für jede Bildschirmzeile
 d7 = Anzahl der Pixel, die für den aktuellen Strich gezeichnet werden sollen
 a0 = ptr. in die Texturspalte, die dem Bindestrich entspricht
 a1 = ptr. zum aktuellen Pixel im Bildschirm

 Die Textur wird im Speicher als Array gespeichert das nach Spalten organisiert
ist, um den Zugriff auf jedes Pixel der Spalte in Strömung der Textur zu
vereinfachen. Die Berechnung der zu visualisierenden Texturspalte, muss
unter Berücksichtigung der Gesetze der Perspektive erfolgen.




Böden und Decken
--------------------

In der Art der 3D-Engine, die Sie erstellen möchten, sind die Böden und Decken
perfekt horizontal sowie senkrecht zu den Wänden.
Textur-Mapping von Polygonen dieser Art sind etwas komplexer als die der Wände,
da die Textur entsprechend der schrägen Linien gescrollt werden muss.
Sie müssen auch ein Tracking für horizontale Pixelstreifen durchführen und
nicht vertikal, wie es bei Wänden der Fall ist.
Schauen Sie sich die folgende Abbildung an, die die Textur (von 64x64
Pixel) darstellt, um einem Stück Boden (oder Decke) zuzuordnen:

	 ____________________________ 
	|                            |
	|                            |
	|                            |
	|                         ***|
	|                      ***   |
	|                    **      |
	|                 ***        |
	|              ***           |
	|           ***              |
	|         **                 |
	|      ***                   |
	|   ***                      |
	|***                         |
	|____________________________|


Für jeden horizontalen Bodenstreifen (oder Deckenstreifen) ist es ein scrollen 
der Textur entlang einer Linie erforderlich, die nicht unbedingt horizontal
oder vertikal ist. Diese Linie ist in der Abbildung durch ein Sternchen (*) 
dargestellt. Die Textur-Mapping-Schleife ist so etwas wie die folgendes:

	for x = x1 to x2
	    WriteScreenPixel(x,y,ReadTexturePixel(u & 63, v & 63))
	    u += du
	    v += dv
	endfor

dove:

 x1   = Startspalte des horizontalen Pixelstreifens
 x2   = letzte Spalte des horizontalen Pixelstreifens
 y    = Zeile, auf der sich der Pixelstreifen befindet
 u, v = Koordinaten innerhalb der Textur
 du   = Summenwert für u
 dv   = Summenwert für v

 Das Problem an dieser Stelle ist die Berechnung der Anfangswerte
von u, v, du, dv.  Die Methode zur Berechnung solcher Werte hängt 
von der Herangehensweise bei der Erstellung der engine ab.

 Um die Ideen etwas besser zu verdeutlichen, denken Sie daran, dass das Polygon
nachzuverfolgen gehört zum Boden und damit zu einem Boden.  Auf diesem
Boden "verkleben", nebeneinander die 64x64 Texturen
Pixel, um es vollständig abzudecken. Jeder Punkt dieser Ebene wird
 durch das Koordinatenpaar (u, v) identifiziert und nach den
Regeln der Perspektive, entspricht einem Pixel auf dem Bildschirm von
Koordinaten (x, y).

Die Bildschirmkoordinaten der Start- und Endpunkte der
horizontalen Pixelstreifen sind bekannt und sind jeweils (x1, y)
und (x2, y). Diese Punkte entsprechen den Punkten (u1, v1) und (u2, v2) in der
Texturebene, die berechnet werden muss.  Der Anfangswert des Paares
(u, v) ist gleich (u1, v1), während der Wert von (du, dv) gegeben ist durch:

	du=(u2-u1)/(x2-x1+1)
	dv=(v2-v1)/(x2-x1+1)


Als Beispiel empfehle ich einen Blick auf die AMOS-Quelle
in der Datei  "TMapFloor.lha" vorhanden.




Die Berechnung der zu verfolgenden Szene
-----------------------------------

In Bezug auf Textur-Mapping sind die beiden Begriffe "ray-casting" und
"BSP" weit verbreitet, aber nicht jeder weiß, was es genau ist.
 Um eine Szene auf dem Bildschirm zu verfolgen, müssen Sie nicht nur 
wissen, wie verfolgen geht, sondern auch und vor allem wissen, was zu
verfolgen ist. Ray-Casting und BSP-Bäume sind zwei der beliebtesten
Berechnungsmethoden, was basierend auf der Sicht des Beobachters
dargestellt werden soll.
In einem klassischen Wolfestein-Labyrinth sind viele hohe Polygone
enthalten und sie möchten alle analysieren, um zu entscheiden, welche
die eigentlichen Teil der zu betrachtenden Szene sind, das ist absurd.
Es besteht der Bedarf an schnelleren Techniken und sowohl Ray-Casting
als auch BSPs sind vorhanden und kommen um zu helfen.


RAY-CASTING
-----------

 Es liegt auf der Hand, dass Ray-Casting höchstens einen ähnlichen Namen
wie das berühmte Raytracing (der für 3D-Bilder verwendete Algorithmus,
fotorealistisch) hat, und tatsächlich hört die Ähnlichkeit nicht beim
Namen auf.
 Der Raytracing-Algorithmus besteht darin, einen Strahl (eine Linie) zu
verfolgen zwischen dem Betrachter und jedem Pixel, auf dem Bildschirm.
Für jeden dieser Strahlen werden dann Kollisionen und Brechungen
berechnet, um die Farbe des entsprechenden Pixels zu erhalten.

 Ray Casting ist nichts anderes als eine Vereinfachung des Raytracings:
für jede Spalte des Bildschirms wird nur ein Strahl gezeichnet. Der
Geschwindigkeitsgewinn ist sofort ersichtlich, wenn man darüber nachdenkt
dass 320 Strahlen benötigt werden, um einen 320x200 Pixel Frame für den
Ray-Casting-Algorithmus gegenüber die 64000 des Ray-Tracing zu berechnen!

 Was wie eine übertriebene Näherung erscheinen mag, ist stattdessen
eine ebenso einfache wie geniale Idee. Eigentlich ist es nicht nötig
vergiss, dass die Welt, die wir visualisieren wollen, Grenzen unterworfen ist
und die Böden und Wände senkrecht zueinander stehen. Außerdem ist es möglich,
sich nur in einer Ebene zu bewegen (die Y-Koordinate kann nicht variieren).

 Sehen Sie sich die Grafik unten an:

       0    64  128  192  256  320  384  448  512 X
	+----+----+----+----+----+----+----+----+--->
	|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|
	|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|
     64 +----+----+----+----+----+----+----+----+
	|XXXX|    |    |    |    |    |    |XXXX|
	|XXXX|    |    |    |    |    |    |XXXX|
    128 +----+----+----+----+----+----+----+----+
	|XXXX|    |XXXX|XXXX|    |XXXX|    |XXXX|
	|XXXX|    |XXXX|XXXX|    |XXXX|    |XXXX|
    192 +----+----+----+----+----+----+----+----+
	|XXXX|    |XXXX|    |    |XXXX|    |XXXX|
	|XXXX|    |XXXX|    |    |XXXX|    |XXXX|
    256 +----+----+----+----+----+----+----+----+
	|XXXX|    |XXXX|    |    |XXXX|    |XXXX|
	|XXXX|    |XXXX|    |    |XXXX|    |XXXX|
    320 +----+----+----+----+----+----+----+----+
	|XXXX|    |XXXX|XXXX|XXXX|XXXX|    |XXXX|
	|XXXX|    |XXXX|XXXX|XXXX|XXXX|    |XXXX|
    384 +----+----+----+----+----+----+----+----+
	|XXXX|    |    |    |    |    |    |XXXX|
	|XXXX|O-> |    |    |    |    |    |XXXX|
    448 +----+----+----+----+----+----+----+----+
	|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|
	|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|XXXX|
    512 +----+----+----+----+----+----+----+----+
	|
      Z |
	V


 Es stellt eine einfache zweidimensionale Karte dar, die in Blöcke
geordnet ist, die voll oder leer sein können. Ein vollständiger Block
kann nicht gekreuzt werden, ein leerer Block ja. Jeden Block muss man
sich als eine Art Würfel fester Größe vorstellen, normalerweise einer 64
Einheit (oder Pixel) pro Seite, deren Unterseite auf der Karte aufliegt,
in der durch das Raster gekennzeichneten Position. Die untere 
und die obere Fläche repräsentieren den Boden bzw. die Decke der 
leeren Blöcke. Die vier Flächen senkrecht zum Boden repräsentieren so
viele Teile der Wand. Jede Fläche assoziiert eine Textur mit
Abmessungen von 64x64 Pixeln.

 Ein Block hat also sechs Parameter: ein Zeiger auf die Textur des
Bodens, ein Zeiger auf die Deckentextur und vier Zeiger zu den Texturen 
der verbleibenden vier Flächen. Wenn der Block voll ist, werden die 
Decken- und Bodentexturzeiger nicht benötigt (sind auf null gesetzt),
während, wenn es leer ist, werden keine Zeiger auf die Texturen der vier
Wandstücke benötigt.

 Der Beobachter hat drei Parameter:  x-Koordinate, z-Koordinate und Winkel
Überwachung. In der vorherigen Grafik ist der Beobachter durch ein O
und einen Pfeil, der die Blickrichtung anzeigt, dargestellt.
Durch das Teilen der x- und z-Koordinaten durch die Größe der Blöcke kann
leicht berechnet werden, auf welchem Block sich der Beobachter befindet. 


 Stellen Sie sich nun vor, dass der Bildschirm aus 320 Spalten mal
200 Pixel besteht.

 Der Ray-Casting-Algorithmus lässt sich in den folgenden Schritten
zusammenfassen:

   1) Berechnen Sie den Radius unter Berücksichtigung des Betrachtungswinkels
      (die Linie), die zwischen dem Beobachter und jeder der 320 Spalten
	  die den Bildschirm bilden gezogen werden soll.
  
   2) Beginnend mit dem Block, den der Beobachter aktiviert hat und verwendet
      den Bresenhams Linienzeichnungsalgorithmus, untersuchen
      jeder Block, den der aktuelle Strahl durchläuft, bis
      wenn du einen vollen findest.
	  
   3) Wenn der Block voll ist, bedeutet dies, dass es einen Schnittpunkt
      zwischen dem Radius und zwei der 4 Seiten des Blocks gibt. Berechnen
	  Sie die Koordinaten des Schnittpunkts der dem Betrachter am nächsten
	  liegenden Seite.Auf diese Weise ist es dank einer einfachen 
	  AND-Operation möglich, zu ermitteln, welches der 64 Pixel auf der
	  Seite vom Strahl betroffen war. Dieses Tatsache ist äußerst nützlich
      während der eigentlichen Textur-Zuordnung.

   4) Berechnen Sie die Entfernung zwischen dem Beobachter und dem Punkt
      der Überschneidung.

   5) Berechnen Sie die Höhe der Wand in Pixeln (unter Berücksichtigung
      der Gesetze der Perspektive) am Schnittpunkt.

   6) Zeichnen Sie auf dem Bildschirm in der aktuellen Spalte mit einer
      Routine des Textur-Mappings, das ausgeschnittene Stück Wand.

   7) Gehen Sie zurück zu Schritt 2, bis 320 Zeilen gezeichnet wurden.

Der Algorithmus ist, wie Sie sehen können, sehr einfach, aber ihn effektiv
zu implementieren ist eine ganz andere Sache. In dieser Hinsicht empfehle
ich die Quellen und vor allem die Dokumentationsdatei "notes.txt" welche
im angehängten Archiv "ack3d.zip" enthalten ist zu studieren.
 Dieses Archiv enthält neben den Quellen eine eingehende Analyse einer
der möglichen Implementierungen des Ray-Castings. An diejenigen, die es
geschafft haben, ein Programm in Bearbeitung der vom Autor des Archivs
vorgeschlagenen Lösungenzu implementieren, der Rat nach neuen und
effizientere Wege zu forschen, um bessere Ergebnisse zu erreichen.
Ich kann aus erster Hand bezeugen, dass es viel besser 
gemacht werden kann.

 Die Quellen sind für PC, aber ihr didaktischer Wert bleibt unverändert.



BSP TREES
---------

 Komplexer ist jedoch die Grundidee der BSP-Bäume.  Zunächst, BSP-Baum
bedeutet in vollem Umfang: Binärer SPlit-Baum, also binär teilende Bäume.

 Mal sehen wie sie funktionieren:

Beachten Sie die folgende Abbildung, in der sich 3 Linien auf der Ebene
befinden:



		       ------------------
			     Linie 1
		    \
		     \
		      \
		       \ Linie 2
	------------    \
	   Linie 3       \
			  \

		       ^
		       Beobachter



 Wenn Sie die Szene mit dem klassischen Maler Algorithmus zeichnen möchten,
sollten die Linien zuerst nach dem Abstand geordnet werden, dann zeichnen
sie sie in der Reihenfolge vom weitesten zum nächsten. Diese Technik ist
nicht nur sehr langsam, sondern unterliegt auch erheblichen Ungenauigkeiten
die oft schwer zu entfernen sind.

 Mit den BSPs wird die Tracking-Reihenfolge-Berechnung einmal 
für alle außerhalb der 3D-Engine durchgeführt. Es wird ein binärer Baum
erstellt mit allen für die Rückverfolgung notwendigen Informationen um
in der richtigen Reihenfolge die Zeilen, egal an welcher Position
des Beobachters zu verfolgen.

 Beachten Sie zunächst, dass Sie für jeden beliebigen Punkt (x, y)
immer sagen könnnen, ob es sich auf der einen oder anderen Seite einer
Linie befindet. Selbst der Punkt sollte zur Linie gehören, er kann als
einer der beiden Seiten angehörend betrachtet werden.

 Der BSP-Binärbaum besteht aus einer Reihe von Knoten, die
die Linien darstellen, die Sie zeichnen möchten. Rechts von jedem
Knoten legen Sie alle Linien, die auf einer Seite sind und
links alle Linien, die auf der anderen Seite sind.
In Bezug auf das vorherige Beispiel könnte der Baum also sein:

	 1
	/
       2
      /
     3

 Aber jede andere Linie kann als Kopfknoten verwendet werden:

	 2
	/ \
       3   1

Wenn Sie jedoch Zeile 3 als Kopfknoten verwenden möchten, gibt es ein
Problem: Auf welcher Seite von Linie 3 befindet sich Linie 2?
 Die Antwort ist einfach: auf beiden. Wir teilen dann Linie 2 in zwei
Teile in der Hälfte bei der Verlängerung von Zeile 3.
Der Baum übernimmt daher diesen Aspekt:

	 3
	/ \
       2a  2b
	    \
	     1

 Die Zeilen 2a und 2b sind Teile der ursprünglichen Zeile 2. Zeichnen
der beiden Linien auf dem Bildschirm und Sie erhalten genau Linie 2.

Wenn Sie einen BSP-Baum erstellen, müssen Sie versuchen, die Anzahl 
der Linienunterteilungen aufgrund einer unverhältnismäßigen Erhöhung
der Größe des Baumes selbst zu minimieren und damit zur notwendigen
Zeit, um eine Szene zu verfolgen.

Um eine Szene zu verfolgen, müssen Sie vom Kopfknoten aus beginnen und
berechnen auf welcher Seite der Linie sich der Beobachter befindet.
Wir besuchen den Knoten relativ zur anderen Seite, zeichnen Sie die
aktuelle Linie und besuchen Sie dann den Knoten relativ zu der Seite,
auf der sich der Beobachter befindet, alles in rekursive Weise.
Zum Beispiel der folgende Baum:

		5
	      /   \
	     /     \
	    3       6
	   / \     /
	  1   2   4

erzeugt die folgende Sequenz, wenn sich der Beobachter rechts von
allen Zeilen befindet:

   4 - 6 - 5 - 2 - 3 - 1


 Die Erweiterung dieser Konzepte auf 3D ist einfach. Betrachten Sie
alle Stellen von Linien, Polygonen und nehmen an, dass Polygon 1 der
Kopfknoten ist. Um zu wissen, wo man Polygon 2 in den Baum einfügen
muss, genügt es zu berechnen, auf welcher Seite sich alle seine Punkte 
bezüglich Polygon 1 befinden. Wenn ein Teil von Polygon 2 oben wäre
eine Seite und die andere Seite auf der anderen Seite von Polygon 1,
sollten Sie Polygon 2 in zwei Teile teilen. Dazu ist es ausreichend
die Linie zu berücksichtigen, die durch den Schnittpunkt des
Polygons 2 und der Ebene, zu der Polygon 1 gehört, gebildet wird
und unterteilen Sie Polygon 2 entlang dieser Linie.

 Es sollte jedoch beachtet werden, dass es, um eine Doom-ähnliche Engine
zu bauen, einfach die BSP-Bäume im zweidimensionalen Fall verwenden. Der
Grund wird klar, wenn man den nächsten Absatz liest.



 Wie leicht zu verstehen ist, haben BSP-Bäume beträchtliche Vorteile 
beim Raycasting: sie sind schneller, sie geben die Möglichkeit schräge 
Wände aller Größen zu verfolgen und allgemeiner sie bieten die Möglichkeit,
komplexere und realistischere Umgebungen zu erstellen.
 Auf der anderen Seite gibt es eine größere Schwierigkeit der Verwendung.




Wir gehen die Treppe hoch !
---------------------------

 Die bis hierhin beschriebenen Techniken ermöglichen die Visualisierung
von Szenen aus einer zweidimensionalen Welt. Es geht nicht von echtem
3D aus, sondern nur von einem Schein.

 Ein Schritt vorwärts bei der Verwirklichung einer dreidimensionalen Welt
kann mit einer ziemlich einfachen Technik gemacht werden. Betrachten Sie
einen leeren Block des Raycasting Algorithmus wie oben beschrieben. Wenn
der Beobachter im Block war, natürlich wäre es zwischen Boden und Decke.
Die Sektion Seite des Blocks sieht so aus:


		     Decke
		     ________
		    |        |
		    |        |
		    |        |
		    |________|

		     Fußboden

  Betrachten Sie immer noch einen Seitenabschnitt und nähern Sie sich
2 Blocks zum Vorherigen:
		1        2        3
	    ________.________.________
	   |                          |
	   |  O->                     |
	   |                          |
	   |________.________.________|


 Der Beobachter, der sich auf Block 1 befindet, sieht (ungefähr)
diese Szene (einen Korridor):

	       _____________________
	      |\                   /|
	      |  \               /  |
	      |    \           /    |
	      |      \ _____ /      |
	      |       |     |       |
	      |       |     |       |
	      |       |_____|       |
	      |      /       \      |
	      |    /           \    |
	      |  /               \  |
	      |/___________________\|




Die drei Blöcke sind auf der gleichen Höhe, aber was wäre wenn, sich zum
Beispiel, der zentrale Block höher als die anderen zwei befindet?


		1        2        3
		     ________
	    ________|        |________
	   |                          |
	   |  O->                     |
	   |         ________         |
	   |________|        |________|



Der Betrachter sieht nicht mehr nur einen einfachen Korridor, sondern sieht auch
eine Stufe. Das Erhöhen von Block 3 gegenüber Block 2 ergibt:


		1        2        3
			      ________
		     ________|        |
	    ________|                 |
	   |                          |
	   |  O->             ________|
	   |         ________|
	   |________|        


 Der Betrachter sieht an dieser Stelle eine kleine Treppe, zusammengesetzt
aus zwei Schritten. Dies bedeutet, dass für die sechs Parameter des Blocks
müssen Sie die Bodenhöhe und die Deckenhöhe hinzufügen.

 Allerdings gibt es ein kleines Problem: zwischen zwei Etagen (oder Decken)
die sich auf unterschiedlichen Höhen befinden, bleibt etwas Platz, der
irgendwie ausgefüllt werden muss. Wir kommen dann zu einer neuen
Blockdefinition und fügen andere Parameter hinzu. Beobachten Sie
die folgende Abbildung, die den seitlichen Schnitt eines Blocks darstellt
was seine neue Definition ist:

		    .         .
		    .         .
		    |Decke	  | <-- Upper texture
		    |_________|
		    |         |
		    |         | <-- Normal texture
		    |         |
		    |_________|
		    |Boden    |
		    |         | <-- Lower texture
		    .         .
		    .         .


 Für jede der vier Seitenflächen (also für jede Wand) 
definiere sie jetzt drei Texturen:

  - Normal : ist die zwischen Decke und Boden angezeigte Textur, wenn
	     der Block ist voll

  - Upper  : ist die Textur, die zwischen zwei benachbarten Decken angezeigt
			 wird, die unterschiedlich hoch gefunden werden

  - Lower  : ist die Textur, die zwischen zwei benachbarten Etagen angezeigt
			 wird, die unterschiedlich hoch gefunde nwerden 


Die Anzahl der Parameter jedes Blocks ist jetzt auf Sechszehn gestiegen.

 Um die Ideen zu verdeutlichen, sehen Sie sich die folgende Abbildung an:

				    Upper texture
		   Upper texture    des Blocks 2
		   des Blocks 1      |
			    |        |
			    |        V________
			    V________|       |
		    ________|          Block | <- Normal texture
		   |          Block     3    |     des Blocks 3
 Normal texture -> | Block     2     ________|
  des Blocks 1     |   1     ________|
		   |________|        ^ 
			    ^        |
			    |        | Lower texture
			    |          des Blocks 3
			Lower texture
			des Blocks 2


Wie man sieht, ist die Welt, die sich aus dieser neuen Definition ergibt,
ist im Wesentlichen auch zweidimensional. Realismus ist aber
definitiv überlegen. Ein Beweis dafür ist der enorme Erfolg von Doom.

 Die Anwendung der in diesem Absatz beschriebenen Konzepte auf die BSP-Bäume
ist einfach.Zunächst einmal besteht die Grundeinheit nicht aus Blöcken
aber natürlich von den Linien. Jede Linie steht für eine Wand und ist daher
mit den drei Texturen (Upper, Normal und Lower) ausgestattet. Die Linien
bilden die Seiten von Polygonen, die als Sektoren bezeichnet werden. Jeder
Sektor hat als Parameter die Höhe und Beschaffenheit des Bodens und der Decke.

 Für weitere Informationen empfehle ich, die Spezifikationen der Doom
 WAD-Dateien, die in der Datei "DoomSpecs.guide" enthalten sind zu lesen.




DIE "MALERTECHNIK"
------------------------

Wir kennen jetzt die beiden am häufigsten verwendeten Techniken zur
Entscheidung was zu zeichnen ist, um eine Szene zu visualisieren.
 Mit Ray-Casting erhalten wir am Ende eine Liste von vertikalen
Sstrichen, jeweils relativ zu einer Wand, während wenn die BSP-Bäume
verwendet werden, erhalten wir am Ende eine Liste von Flächen, die
in vertikale Striche unterteilt werden können.

[FERTIGSTELLEN]



Wir erleuchten unsere Welt
---------------------------

Es ist möglich Blöcke (bei Raycasting) oder Sektoren auszurüsten
(bei BSPs) des Beleuchtungsparameters. Dieser Parameter wird während
des Textur-Mappings verwendet, um auf die  Beleuchtungstabelle zuzugreifen
und die Helligkeit jedes Pixels der Blocktextur zu variieren.

 Angenommen, die Texturen haben 256 Farben. Dies bedeutet, dass jedes
Pixel einer beliebigen Textur Werte zwischen 0 und 255 annehmen kann.
Die 256-Farbpalette muss aus einer bestimmten Anzahl von Schattierungen
einer Reihe von Grundfarben (z.B. 32 Grau-, 32 Braun-, 32 Rot-,
16 Blautöne usw.) bestehen, für alle chromatischen Bedürfnisse jedes Bildes.
Also jede Farbe ist mehrfach in der Palette vorhanden, jedoch mit
unterschiedlicher Lichtintensität.

Es ist daher möglich, eine Tabelle zu erstellen, die jeder Farbe der
Palette eine andere Farbe der gleichen Palette zugeordnet ist, aber mit
einer anderen Helligkeit. Die Elemente dieser Tabelle nehmen offensichtlich 
Werte zwischen 0 und 255 an.

 Durch die Konstruktion von M Tabellen dieses Typs, die sich jeweils auf
eine andere Helligkeit beziehen (zwischen 100% und 0%), erhalten wir
eine N x M-Matrix, wobei N die Anzahl der Farben in der Palette ist (256).
Mit 32 Stufen der Beleuchtung (und damit 32 Tabellen) erhalten wir eine 
Matrix, die 256 * 32 = 8192 Byte belegt.

Angenommen, Farbe 0 der Palette ist schwarz, kann die Matrix so
präsentiert werden:

			      FARBEN DER PALETTE
		    
		     0   1   2   3  ............  253 254 255
		 +--------------------------------------------+
	   100%  |   0   1   2   3  ............  253 254 255 |
	    .    |   .   .   .   .  ............    .   .   . |
	    .    |   .   .   .   .  ............    .   .   . |
    H       .    |   .   .   .   .  ............    .   .   . |
    E       75%  |   .   .   .   .  ............    .   .   . |
    L       .    |   .   .   .   .  ............    .   .   . |
    L       .    |   .   .   .   .  ............    .   .   . |
    I       .    |   .   .   .   .  ............    .   .   . |
    G       50%  |   .   .   .   .  ............    .   .   . |
    K       .    |   .   .   .   .  ............    .   .   . |
    E       .    |   .   .   .   .  ............    .   .   . |
    I       .    |   .   .   .   .  ............    .   .   . |
    T       25%  |   .   .   .   .  ............    .   .   . |
	    .    |   .   .   .   .  ............    .   .   . |
	    .    |   .   .   .   .  ............    .   .   . |
	    .    |   .   .   .   .  ............    .   .   . |
	    0%   |   0   0   0   0  ............    0   0   0 |
		 +--------------------------------------------+


 Wie Sie sehen, ist die erste Tabelle (die sich auf die Helligkeit von 100%
bezieht) entspricht jeder Farbe der Palette, der Farbe selbst.
Theoretisch könnten Sie also den Zugriff auf die Tabelle vermeiden.
In der letzte Tabelle, die sich auf die minimale Helligkeit bezieht,
entsprechen stattdessen, alle Farben der Palette, der Farbnull, also
schwarz. Zwischentabellen müssen mit einer besonderen Routine berechnet
werden. Diesem Artikel beigefügt ist eine geeignete C-Quelle.
Er heißt:  MakeLTable.c

Um die Beleuchtung zu verwalten, wird der Textur-Mapping-Zyklus
auf diese Weise modifiziert:

	moveq	#0,d5
loop
    move.b  (a0,d0.w),d5	; Liest das Pixel aus der Textur
	move.b  (a2,d5.l),(a1)	; Liest vom Licht Tabelle und schreibt
    add.w   d3,d1           ; Füge den Bruchteil hinzu
    addx.w  d2,d0           ; Addiere den ganzzahligen Teil (+ Carry)
    adda.l  d4,a1           ; Bewegen Sie den Ptr. zum Bildschirm
    dbra    d7,loop

wobei a2 der Zeiger auf die benötigte Licht-Tabelle ist, der offensichtlich 
außerhalb des Zyklus berechnet wurde, unter Berücksichtigung der
Helligkeit der Welt an diesem Punkt und der Entfernung zum Beobachter.
In einer hell erleuchteten Umgebung zielt a2 immer auf die erste Tabelle
ab, während er in einer völlig dunklen Umgebung es auf den letzten zeigt.




TEXTURE MAPPING UND AMIGA
-------------------------

 Ich denke, jeder weiß, dass Id, das Softwarehaus ist, dass Doom realisiert
hat. Er glaubte immer, es sei unmöglich, Doom auf Amiga zu bringen. Demnach
wäre der 4000/40 schnell genug für Doom wäre da nicht ein Grafikmodus in
chunky Pixel und der hohe Preis einer solchen Maschine.  Um festzustellen
Doom für eine 1200, ganz zu schweigen davon. Haben Sie recht ? Teilweise ja.
Doom wird meistens in C gemacht, und nur ein minimaler Teil des Codes wurde
in Assembler geschrieben, also nur schnellere Prozessoren können es mit einer
anständigen Geschwindigkeit ausführen. Das komplett in Assembler für den
Amiga neu zu schreiben wäre gar nicht so praktisch, also würde ich es
vorziehen, keine Umwandlung zu machen.

Aus kaufmännischer Sicht hat id daher sicher recht, aber rein technisch?
 Wie Id feststellt, gibt es im Wesentlichen zwei Probleme: die knappe
Verbreitung schneller Prozessoren (und folglich hoher Kosten) und das Fehlen
eines Grafikmodus in chunky Pixeln.

 Entgegen der landläufigen Meinung ist das Fehlen von chunky Pixel nicht das
Hauptproblem beim Textur-Mapping auf dem Amiga. Ich glaube, dass es achtmal
mehr planare Grafikmodi gibt Objektive der entsprechenden Modi in chunky Pixel,
aber das gehört nicht zur ganzen Wahrheit. Es ist wahr, wenn Sie nur ein Pixel
gleichzeitig schreiben möchten auf einem planaren Bildschirm muss achtmal auf
den Speicher zugegriffen werden und schreibe jedes der acht Bits, aus denen
das Pixel besteht, aber es ist wahr was bei bestimmten Anwendungen überhaupt
nicht notwendig ist, einen Pixel gleichzeitig zu schreiben.
 Tatsächlich gibt es Techniken, die es ermöglichen, den Zugang auf den
Videospeicher zu optimieren und das ermöglicht es Ihnen, in gewisser Weise
zufriedenstellend für die Leistung von Chunky-Grafikmodi Pixel nahe zu kommen.
Dies ist bei der Konvertierung von "chunky to planar" der Fall.




UMWANDLUNG CHUNKY TO PLANAR
----------------------------

 Diese Technik beinhaltet die Verwendung eines falschen Puffers in chunky
Pixeln, den das Programm behandelt, als wäre es ein echter chunky
Pixelbildschirm. Wenn Sie mit der Verarbeitung eines Frames fertig sind, führen
Sie einfach eine Routine aus, die sich darum kümmert, den Fake so schnell wie
möglich von chunky Pixelbildschirm im planaren Bildschirm zu konvertieren, der
vom Amiga Chipsatz angezeigt wird.
Es gibt verschiedene Techniken (und Variationen davon), um die Konvertierung,
und es ist möglich, im öffentlichen Bereich eine bestimmte Anzahl fertiger
Routinen mit Quellen zu finden.
 Generell kann man sagen, dass es zwei große Familien von Umwandlungs-Routinen
gibt:  diejenigen, die den Blitter verwenden und diejenigen, die keinen
Gebrauch davon machen.  Erstere eignen sich hervorragend für Maschinen, die
nicht zu schnell sind, wie die 1200er Basis oder die 1200er mit Fast. Letztere
sind stattdessen vorzugsweise auf schnellen Maschinen, die mit 68030 50Mhz oder
68040 ausgestattet sind. Versuchen wir zu verstehen, warum. 

 Es ist allgemein bekannt, dass der Speicher chip auch viel langsamer ist als
der Speicher fast, weil es durch DMA-Zugriffe verlangsamt wird und weil es mit
einem Takt von nur 7 Mhz arbeitet. Der 68040 25Mhz, der auf den RAM in nur
2 Zyklen (80 ns) zugreifen könnte benötigt etwa 16 Zyklen (640 ns) um auf den
Chip zuzugreifen (d.h. 14 Wartezyklen werden eingefügt): der Engpass ist genau
dort, beim Zugriff auf den RAM-Chip. Dank der Pipeline, nach einem
Schreibzugriff auf den Arbeitsspeicher, Prozessoren ab 68020 können sofort
andere Befehle ausführen, die nicht auf den Speicher zugreifen, ohne darauf zu
warten, bis das Schreiben beendet ist, solange wie der Code im Cache läuft.
Anweisungen die "im Schatten" der Speicherschreibzugriffsanweisung ausgeführt
werden allgemein als "kostenlose Anweisungen" oder free instruction bezeichnet.
 Angesichts der höheren Geschwindigkeit des 68040 im Vergleich zum 68020 und
unter Berücksichtigung des Engpasses, der durch den RAM-Chip repräsentiert
wird, können Sie leicht sehen, wie der 68040 in der Lage ist, eine gute Anzahl
freier Anweisungen zu leisten. Um ein einfaches Beispiel zu geben, die Menge
von Anweisungen:

 move.l d0,(a0)+
 move.l d1,(a0)+

es ist so schnell wie folgt:

 move.l d0,(a0)+
 add.l	d2,d0            <--- freie Bildung
 move.l d1,(a0)+

Die Anzahl der freien Anweisungen variiert je nach Anzahl der dem Prozessor
auferlegten Wartezyklen und der Geschwindigkeit des Prozessors selbst.
Je größer diese beiden Parameter sind, desto größer sind die
Einschränkungen durch  den Chip-RAM repräsentierten Flaschenhals.
Folglich erhöht sich die Anzahl der freien Befehle.

 All dies bedeutet zusammen mit einer einfachen Kopie der Daten
von Fast bis RAM-Chip, es kann auf einem Prozessor schnell laufen,
gleichmäßige Datenverarbeitung, alles ohne zusätzliche Zeit.

Was die Umwandlung von chunky to planar betrifft, ist dies leider nicht der
Fall. Sie können den gesamten Code so schreiben, dass alle Anweisungen, die
nicht auf den Speicher zugreifen, frei sind, aber es ist möglich, diesem
Ergebnis nahe zu kommen.

Als ob das nicht genug wäre, scheint der Blitter merklich 
langsamer zu sein auf Maschinen mit schnelleren Prozessoren.

 Abschließend berichte ich einen Vergleich der Ausführungszeiten, auf 1200
und 4000, von der chunky to planar Routine, die ich für die 1200 verwende, 
und sowohl den Blitter als auch den Prozessor verwendet:

 - A1200+fast:
	  68020   :  41 msec
	  Blitter :  66 msec
	  ------------------
	  Gesamt  : 107 msec

 - A4000:
	  68040   :  24 msec
	  Blitter :  80 msec
	  ------------------
	  Gesamt  : 104 msec

 Wie Sie sehen, ist der 4000er Blitter deutlich langsamer als der von 1200,
also die Gesamtleistung des chunky to planar ist zwischen 1200 und 4000
nahezu identisch.
 In Wahrheit sind die Dinge auf dem 4000 immer noch besser als auf dem 1200,
da der dem Prozessor anvertraute Umwandlungsteil 17 ms mehr schnell beträgt.




COPPER CHUNKY
-------------

 Es gibt einen Trick, um eine Art Grafikmodus chunky Pixel
auf dem Amiga zu aktivieren:  es ist der "copper chunky".
Mal sehen, was es ist.
 Wir wissen, dass copper den Registerinhalt der Farbe verändern kann
und damit die Pixel auf dem Bildschirm.
Versuchen wir also, eine copperliste zu schreiben, die die Farbe
unten so ändert:

 $0180, $0f00
 $0180, $0000
 $0180, $0f00
 $0180, $0000
 $0180, $0f00
 $0180, $0000
 $0180, $0f00
 $0180, $0000
 $0180, $0f00
 $0180, $0000
 
 Wie Sie sehen können, wechselt dieses Stück copperliste zwischen rot und
schwarz als Hintergrundfarbe. Auf das zweite Wort jeder copperanweisung
könnte dann zugegriffen werden, als wäre es ein chunky Pixel auf einem
Bildschirm.

 Die Geschwindigkeit des coppers setzt jedoch eine Grenze, die durch die
Anzahl der Pixel in verschiedenen Farben, die angezeigt werden können und
die Größe von sich. Tatsächlich ändert die copperliste im Beispiel die Farbe
unten alle 8 Pixel in niedriger Auflösung, also könnten wir einen bekommen
chunky Bildschirm mit nur 40 Pixeln in der Größe 8x1: praktisch
nutzlos, sowohl für die reduzierte Pixelzahl als auch für die Abmessungen
von dem selben.
Wir können dann versuchen, auch die anderen Farbregister zu ändern,
denn Sie brauchen einen Bildschirm, der in jeder Zeile etwas dieser
Art enthält:

 Color0,Color1,Color2,Color3,......

Die entsprechende copperliste für jede Zeile des Bildschirms kann dann
sein:

 $0180, $0rgb
 $0182, $0rgb
 $0184, $0rgb
 $0186, $0rgb
 .....  .....

 Leider leistet der copper nicht mehr als fünfzig Anweisungen pro Zeile, also
wird sich die Anzahl der Pixel unseres chunky Bildschirms sowieso als zu
niedrig erweisen. Dies bedeutet jedoch, dass in zwei Zeilen das copper
hundert Befehle ausführen und daher eine zufriedenstellende Anzahl von
Farb-Registern (knapp 100) modifizieren kann. Wir können dann einen
Bildschirm mit 7 bitplane öffnen, wobei jede Zeile beispielsweise vom Typ ist:

 Color0,Color0,Color1,Color1,Color2,Color2,...,Color95,Color95

 und schreibe eine copperliste, die alle zwei Zeilen den Inhalt der 96
Farbregister (natürlich unter Verwendung des BPLCON3 = $dff106, um die
Farbregisterbank zu ändern).
Wir haben also einen copper chunky Bildschirm mit 2x2 Pixeln erstellt,
der leider jedoch nicht immer optimal funktioniert. Tatsächlich jedes
2x2 Pixel erscheint nicht in einer einzigen Farbe, weil der copper die
Farbregister nicht schnell genug ändert. Eine Art Doppelpufferung wäre
erforderlich. Glücklicherweise kommt uns ein Feature des AGA-Chipsatzes
zu Hilfe, der die Möglichkeit bietet, den Farbsatz der Anzeige zu ändern.
 Immer wenn die Videohardware ein Pixel anzeigen muss, muss sie die
RGB-Farbe aus einem der 256 Farbregister lesen. Tatsächlich der in die
Bitplanes geschriebene Wert ist nichts anderes als ein Index in der Tabelle
von Farbregistern. Bevor Sie sich in die Farbregister zugreifen wird ein
exklusives ODER zwischen dem gelesenen Wert der Bitplane und dem Inhalt der
oberen 8 Bits des Registers BPLCON4 = $dff10c gemacht.
Die hohen 8 Bits von BPLCON4 werden BPLAMx genannt (wobei x = 1-8).
es ist daher leicht zu verstehen, dass bei einer Einstellung von
BPLAM = $80 die angezeigten Farben diejenigen von 128 bis 255 und nicht
die von 0 bis 127 sind.

 Die copperliste wird daher geschrieben, um die
Farben von 0 bis 95 zu ändern, während die ab 128 angezeigt werden, und
ändern Sie die Farben von 129 auf 224, während diese 0 angezeigt werden
auf:

 $010c,$8000          ; zeigt Farben von 128 bis 255 an
 $0106,$0020          ; wählt die erste Bank mit 32 Farben aus
 $0180,$0rgb          ; Farbe ändern des Registers 0
 $0182,$0rgb          ; Farbe ändern des Registers 1
 $0184,$0rgb          ; Farbe ändern des Registers 2
 $0186,$0rgb          ; Farbe ändern des Registers 3
 ...........           .................................
 $01be,$0rgb          ; Farbe ändern des Registers 31
 $0106,$2020          ; wählt die zweite Bank mit 32 Farben aus
 $0180,$0rgb          ; Farbe ändern des Registers 32
 $0182,$0rgb          ; Farbe ändern des Registers 33
 $0184,$0rgb          ; Farbe ändern des Registers 34
 $0186,$0rgb          ; Farbe ändern des Registers 35
 ...........           .................................
 $01be,$0rgb          ; Farbe ändern des Registers 63
 $0106,$6020          ; wählt die dritte Bank mit 32 Farben aus
 $0180,$0rgb          ; Farbe ändern des Registers 64
 $0182,$0rgb          ; Farbe ändern des Registers 65
 $0184,$0rgb          ; Farbe ändern des Registers 66
 $0186,$0rgb          ; Farbe ändern des Registers 67
 ...........           .................................
 $01be,$0rgb          ; Farbe ändern des Registers 95

 $xx01,$fffe          ; wartet auf die nächste 2-Pixel-Zeile
 $010c,$0000          ; zeigt Farben von 0 bis 127 an
 $0106,$8020          ; wählt die fünfte Bank mit 32 Farben aus
 $0180,$0rgb          ; Farbe ändern des Registers 128
 $0182,$0rgb          ; Farbe ändern des Registers 129
 $0184,$0rgb          ; Farbe ändern des Registers 130
 $0186,$0rgb          ; Farbe ändern des Registers 131
 ...........           .................................
 $01be,$0rgb          ; Farbe ändern des Registers 159
 $0106,$a020          ; wählt die sechste Bank mit 32 Farben aus
 $0180,$0rgb          ; Farbe ändern des Registers 160
 $0182,$0rgb          ; Farbe ändern des Registers 161
 $0184,$0rgb          ; Farbe ändern des Registers 162
 $0186,$0rgb          ; Farbe ändern des Registers 163
 ...........           .................................
 $01be,$0rgb          ; Farbe ändern des Registers 191
 $0106,$e020          ; wählt die siebte Bank mit 32 Farben aus
 $0180,$0rgb          ; Farbe ändern des Registers 192
 $0182,$0rgb          ; Farbe ändern des Registers 193
 $0184,$0rgb          ; Farbe ändern des Registers 194
 $0186,$0rgb          ; Farbe ändern des Registers 195
 ...........           .................................
 $01be,$0rgb          ; Farbe ändern des Registers 223


Ein gutes Beispiel für die copper-Chunky-Technik ist in der Datei
"chunky.lha" enthalten, angehängt an diesen Artikel.





---------------------------------------------------------------------

 Alberto Longo   --- Fields of Vision   software design ---


  fidonet:   Alberto Longo   2:335/206.15

  e-mail:    alblon@maxonline.it


  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



*******************************************************************************
*  7. Datei DOOM.TXT														  *
*******************************************************************************

******************************************************************************
*                       'Doom' 3D Engine techniques                          *
******************************************************************************
By Brian 'Neuromancer' Marshall
(Email: brianm@vissci.demon.co.uk)

	This document is submitted subject to certain conditions:

1. This Document is not in any way related to Id Software, and is 
   not meant to be representive of their techniques : it is based
   upon my own investigations of a realtime 3d engine that produces
   a screen display similar to 'Doom' by Id software.

2. I take no responsibility for any damange to data or computer equipment
   caused by attempts to implement these algorithms.

3. Although I have made every attempt to ensure that this document is error
   free i take no responsability for any errors it may contain.

4. Anyone is free to use this information as they wish, however I would
   appreciate being credited if the information has been useful.

5. I take no responsability for the spelling or grammar.
   (My written english is none too good...so I won't take offence
    at any corrections: I am a programmer not a writer...)

	Right now that that little lot is out of the way I will start this
document proper....

1:  Definition of Terms
======================

	Throughout this document I will be making use of many graphical terms
using my understanding of them as they apply to this algorithm. I will
explain all the terms below. Feel free to skip this part....

Texture:
	A texture for the purpose of this is a square image.

U and V:
	U and V are the equivelants of x and y but are in texture space.
ie They are the the two axies of the two dimensional texture.

Screen:
	For my purposes 'screen' is the window we wish to fill: it doesn't
have to be the whole screen.

Affine Mapping:
	A affine mapping is a texture map where the texture is sampled
in a linear fashion in both U and V.

Biquadratic Mapping:
	A biquadratic mapping is a mapping where the texture is sampled
along a curve in both U and V that approximates the perspective transform.
This gives almost proper forshortening.


Projective Mapping:
	A projective mapping is a mapping where a changing homogenous
coordinated is added to the texture coordinateds to give (U,V,W) and
a division is performed at every pixel. This is the mathematically and
visual correct for of texture mapping for the square to quadrilateral
mappings we are using.
	(As an aside it is possible to do a projective mapping without
the divide (or 3 multiplies) but that is totally unrelated to the matter
in hand...)

Ray Casting:
	Ray Casting in this context is back-firing 'rays' along a two
dinesional map. The rays do however follow heights... more on that later

Sprite:
	A Sprite is a bitmap that is either a monster or an object. To
put it another way it is anything that is not made out of wall or
floor sectins.

Sprite Scaling:
	By this I mean scaling a bitmap in either x or y or both.

Right... Now thats over with onto the foundation:

2:   Two Dimensional Ray Casting Techniques
===========================================

	In order to make this accessible to anyone I will start by
explaining 2d raycasting as used in Wolfenstein 3d style games.

  2.1: Wolfenstien 3D Style Techniques...
  =======================================

	  Wolfenstein 3d was a game that rocked the world (well me anyway!).
  It used a technique where you fire a ray accross a 2d grid based map to
  find all its walls and objects. The walls were then drawn vertically
  using sprite scaling techniques to simulate texture mapping.

	  The tracing accross the map looked something like this;


	=============================================
	=   =   =   =   =   =  /=   =   =   =   =   =
	=   =   =   =   =   = / =   =   =   =   =   =
	=   =   =   =   =   =/  =   =   =   =   =   =
	====================/========================
	=   =   =   =   =  /=   =   =   =   =   =   =
	=   =   =   =   = / =   =   =   =   =   =   =
	=   =   =   =   =/  =   =   =   =   =   =   =
	================/============================
	=   =   =   =  /#   =   =   =   =   =   =   =
	=   =   =   = / #   =   =   =   =   =   =   =
	=   =   =   =/  #   =   =   =   =   =   =   =
	============/===#########====================
	=   =   =  /=   =   =   #   =   =   =   =   =
	=   =   = / =   =   =   #   =   =   =   =   =
	=   =   =/  =   =   =   #   =   =   =   =   =
	========/===============#====================
	=   =  /=   =   =   =   #   =   =   =   =   =
	=   = P =   =   =   =   #   =   =   =   =   =
	=   =  \=   =   =   =   #   =   =   =   =   =
	========\===============#====================
	=   =   =\  =   =   =   #   =   =   =   =   =
	=   =   = \ =   =   =   #   =   =   =   =   =
	=   =   =  \=   =   =   #   =   =   =   =   =
	============\=======#####====================
	=   =   =   =\  =   #   =   =   =   =   =   =
	=   =   =   = \ =   #   =   =   =   =   =   =
	=   =   =   =  \=   #   =   =   =   =   =   =
	================\===#========================
	=   =   =   =   =\  #   =   =   =   =   =   =
	=   =   =   =   = \ #   =   =   =   =   =   =
	=   =   =   =   =  \#   =   =   =   =   =   =
	=============================================

	(#'s are walls, = is the grid....)

	This is just a case of firing a ray for each vertical
  line on the screen. This ray is traced accross the map to
  see where it crosses a grid boundry. Where it crosses a
  boundry you cjeck to see if there is a wall there we see how
  far away it it and draw a scaled vertical line from the texture
  on screen. The line we draw is selected from the texture by
  seeing where the line has intersected on the side of the square it
  hit.
	This is repeated with a ray for each vertical line on the
  screen that we wish to display.
	This is a very quick explaination of how it works missing
  out how the sprites are handled. If you want a more detailed 
  explaination then I suggest getting acksrc.zip from
  ftp.funet.fi in /pub/msdos/games/programming

	This is someone's source for a Wolfenstien engine written
  in Borland C and Assembly language on the Pc.
	Its is not the fastest or best but has good documentation
  and solves similiar sprite probelms, distance probelms and has
  some much better explaination of the tracing technique tahn I have
  put here. I recommend to everyone interested taht you get a copy
  and have a thorough play around with it.
  (Even if you don't have a Pc: Everything but the drawing and video
   mode setting is done in 'C' so it should not be too hard to port
   ....)

 
  2.2 Ray Casting in the Doom Environment
  =======================================

	When you look at a screen from Doom you see floors, steps
  walls and lots of other trappings.
	You look out of windows and accross courtyards and you
  say WOW! what a great 3d game!!
	Then you fire your gun a baddie who's in line with you but
  above you and bang! he's a corpse.
	Then you climb up to the level where the corpse is and look
  out the window to where you were and you say Gosh! a 3d game!!

	Hmmm....

	Stop gawping at the graphics for a minute and look at the map
  screen. Nice line vectors. But isn't the map a bit simple???
	Notice how depite colours showing you that there are different
  heights. Then notice that despite the fact that there is NEVER a
  place where you can exist on two different levels. Smelling a little
  2d yet???
	Look where there are bridges (or sort of bridges) : managed to
  see under them yet??

	The whole point to this is that Doom is a 2D games just like
  its ancestor Wolfenstein but it has rather more advanced raycasting
  which does a very nice job of fooling the player into thinking its a
  3d game that shifting loads of polygons and back-culling, depth
  sorting etc... 

	Right the explaination of how you turn a 2d map into the 3d
  doom screen is complex so if you are having difficulty try reading
  it a few times and if all else fails mail me....


  2.3 What is actually done!
  ==========================

	Right to start with the raycasting is started in the same
  way as Wolfenstien. That is find out where the player is in the 2d
  map and get a ray setup for the first vertical line on the screen.

	Now we have an extra stage from the Wolfenstein I described
  whcih involves a data srtucture that we will use later to actually
  draw the screen.

	In this data structure we start the ray off as at the bottom
  of the screen. This is shown in the diagram below;

	=================================
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=*                              =
	=================================


	Where the '=' show the boundry of the screen and '*' is the virtual
  position of the ray.

	Note: the Data structure is really two structures:
	One which is a set of list for each vertical 'scanline' and
	One which is a corresponding list for horizontal scanlines.

	Now we start tracing the ray. We skip accross the 2d map until
  we hit something interesting. By something interesting I mean something
  that is an actual wall or florr section edge.
	Right we have hit the edge of either a floor or wall section.
  We have several things to do know. These are;

	If it was a wall we hit:

  1: Find out how 'high' of screen this section of wall should be
     due to the distance it is accross the 2d map.
  2: Find out at what 'virtual height' it is: This is so that we can see
     where in the vertical scanline in comes for testing where to insert
     it and for clipping it.
  3: Test in our structure to see if you draw it or not.
     (This is done so that you can look through windows : how this works
      will become apparent later.)
  4: If any of the wall segment is visible then we find out where along
     the texture we have hit it and write into the structure the area of
     the screen it takes up as well as the texture, the point where we
     have hit the texture and the size it should be on screen. (This is
     so that we can draw it correctly even if the whole span is not on
     screen.


	If it was a floor section that we hit:

  1: Find out where on the vertical line we are working the floor section
     that the ray has hit is. (We know the height of the the floor in the
     virtual map (2d) and we know the height of the player and the distance
     of the floor square from the player so it is easy).
     As a side effect of this we now know the U,V value where the ray has
     hit the floor square.

  2: Trace Accross the floor square till we hit the far edge of the floor
     square : we then workout where this is on the vertical scanline using
     the same technique as above. We now know the vertical span of the
     floor section, and where on the span it is.

  3: We check to see if the span is visible on the vertical span.
     If it is or part of it is used then we mark that part of the vertical
     scanline as used.
     We also have to make use of the horizontal buffer I mentioned. We
     insert into this in 2 places. The first is the x coordinate of where
     we hit the floor square into the y line where we where on the screen.
     Phew got that bit?? We also insert here the U,V value which we knew 
     from the tracing. (I told you we'd need it later....)                                                                


	As you can see there's a little more to hiting a floor segment than
a wall segment. Also note that a you exit a floor segment you may also hit
a wall segment.

	Tracing the individual ray is continued until we hit a special kind
of wall. This wall is marked as a wall that connects to the ceiling.
This is one place to stop tracing this ray. However we can stop tracing early
if we have found enough to fill the whole vertical scanline then we can stop
whenevr we have done this.

	Next come a trick. I said we were tracing along a 2d map. Well I
lied a bit. There are (In my implementation at least..) TWO 2d maps. One is
basically from the floor along including all the 'floor' walls and everything
up to and including the walls that join onto the ceiling. The other map
is basically the ceiling (with anything coming down from the ceiling on it
if you are doing this: this makes life a little more complex as I'll explain
below..)
	Now when we have traced along the bottom map and hit a wall that 
connects to the ceiling then we go back and trace along the ceiling from
the start to fill in the gaps. There is a problem with this however.
The problem is when you have things like a monolith or something else built
out of walls jutting down from the ceiling. you have to decide whether to
draw it or draw whatever was already in the scanline structure. This means
either storing extra information in the buffer ie z coordinates or tracing
along both the ceiling and floor at the same time.... for most people I would
suggest just not having anything jutting down from the ceiling.
	Also you could trace backwards instead of starting a new ray. This 
would be fasterfor many cases as you wouldn't be tracing through lots
of floor squares that aren't on screen. By tracing backwards you can keep
going up the vertical scanline and you know that you are on the screen. As
soon as something goes off the top of the screen you can handle that and then
stop tracing.

	Phew. has everyone got that???

	Now we just go back and fire rays up the rest of the vertical
scanlines. Easy!!???

	At the end of this lot we have the necessary data in the two buffers
to go back and draw the screen background.
(There is one more thing done while tracing but I'll explain that later...)


	Oh... one other thing... you have may want to change the raycasting
a bit to subdivide the map... it helps with speed.
	And don't forget the added complexity that walls aren't all at
90 degrees to each other...

3: Drawing the walls and Why it works!!
=======================================

	If you are familiar with Wolfenstein then please still read this
as it is esential background to understanding the floor routine.


	As all of you probably know the walls are drawn by scaling the line
of the texture to the correct size for the screen. The information in the
vertical buffer makes this easy. What you probably don't know is why this
creates texture mapping that is good enough to fool us.

	The wall function is a Affine texture mapping. (well almost)
Now affine texture mappings look abysmal unless you do quite a lot of
subdivision (The amount needed varies according to the angle the projected
square is at.). So why does the Doom technique work??

	Well when we traced the rays we found out exactly where along the
side of the square we hit we were in relation to the width of the texture.
This means that the top and bottom pixels of the scaled wall piece are
calculated correctly. This means that we have effecively subdivided the
texture along vertical scanlines and as the effective subdidvisons are
calculated exactly with proper forshortening as a result of the tracing.
So the ray casting has made the texture mapping easy for us.
	(We have enough subdivision by this scanline effect as the wall
only rotates about one axis and we have proper foreshortening.)

	This knowlege helps us understand how to do the floors and why
that works.

	We can now draw all the wall segments by just looking at the buffer
and drawing the parts marked as walls.(Skiping where we put in the bits used
by the floor/ceiling bits: we draw them later.)

4:  Drawing the Floor/Ceiling and why it works!
===============================================

	If you have grasped why the walls work then you have just about
won for the floors.
	We have the information needed to draw the floors from the horizontal
buffer.
	All we have to do is look at the horizontal spans in the buffer
and draw them in all.
	Each of these spans has 2 end coordinates for which we have
exact texture coorinates. This tells us which line across the texture
we have to step along to do an Affine or linear mapping.
	This is shown below;


	=================================
	=                               =
	=                               =
	=                               =
	=                               = U1,V1 (exit)
	=                              **
	=                           *** =
	=                        ***    =
	=                     ***       =
	=                  ***          =
	=               ***             =
	=            ***                =
	=         ***                   =
	=       **                      =
	=     **                        =
	=   **                          =
	= **                            =
  U0,V0 **                              =
(entry) =                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=                               =
	=================================

(apologies for the wonky line: it should be straight!!)

	Now...as the end coordinates are correct and the axis along
which forshortening takes place is not involved (this is a fudge)
we can step linearly along this line across the texture to approximate
the mapping. (This is far easier than a proper texture map).
	This is effectivly a wall lying on its side which works as the
texture coordinates at the ends of the span have been calculated correctly.
This is a benefit of the raycasting we used to find everything.
	Easy huh??


5: Sprites
==========

	The Sprites are really quite easy to do. The basic technique is the
same as used in Wolfenstein 3d.
	This is done as follows:

When you enter a 'square' on the floor map you test to see if there are
any sprites in the square. If there are you flag that sprite as visible
and add it to a list of visible sprites.

When you have finished tracing and drawing the walls and floor you
depth sort the sprites and draw them from the back to the front. (painters
algorithm). The only complication in drawing them is that you have to check 
buffer that has the walls in, in order to clip the sprites correctly.

	(If you're interested in Doom you can occasionally see large 
explosions (ie BFG) slip partially behind a wall segment.)

	On possibly faster way of handling the sprites would be to mark
them like wall segments as you find them in the buffer. The only (ONLY!)
complication to this approach is that sprites can have holes in them. By
this I mean things like the gap between an arm and a leg which should be 
the background colour.


6: Lighting and Depth Cueing
============================

	Lighting and Depth Cueing fits nicely in with the way that we have
prepared the screen ready for drawing.
	All we have to do is see how far away we are when we found either
the floor or wall section and set the light level according to the distance.
	The other thing that is applied is a light level. This is taken from
the map at the edges where you have hit something. As the map is 2D it is
easy to manage lighting, flickering etc.
	For things like pools of light on the floor all you have to do
is subdivide that patch of floor so that you can set the bit under the 
skylight to a lighter colour. Its also very easy to frig this for the
lighting goggles.


7: Controlling the Baddies
==========================
	

	This is pretty easy: all you have to think about is moving and
reacting on a 2d map. the only complications are things like the monsters
looking through windows and seeing a player but this all degenerates into
a simple 2d problem. Things like deciding whether the player has been hit or
has he/she hit a monster is just another case of firing a ray. (Or do it
another way...)


8: Where next???
================

	Thats all folks... hopefully a useful and intersting insight into
my Doom engine works.
	As to the question where next... well I already have some enhancements
to my Doom enigine and others are in the works...

Some of what you may eventually see are:

	Proper lighting (I have done this already...its easier than you
			think)
	Non-Vertical walls (i.e. Aliens style corridors...)
	Orgranic Walls (i.e. Curved like the Aliens nest...)
	Fractal Landscapes (This one is still very much a theory but how
			about being able to go outside and walk up and down
			hills etc??)

	If there are bits people are really shaky about I may post a new
version of this... but I cannot get into implimentation issues as all
implementation work is under copyright...

	By the way if anyone out there implements this I'd love to here
how you get on...

	Anyone got any comments or any other interesting algorithms???

Brian 'Neuromancer' Marshall         'When do graphics not look like graphics?
( Email: brianm@vissci.demon.co.uk )  :when we get it RIGHT.'

EOF

*******************************************************************************
*  11. DoomSpecs.txt														  *
*******************************************************************************




------------------------------------------------------------------------------
			   T H E   U N O F F I C I A L
=================     ===============     ===============   ========  ========
\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //
||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||
|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||
||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||
|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||
||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||
|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||
||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||
||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||
||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||
||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||
||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||
||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||
||   .=='    _-'          `-__\._-'         `-_./__-'         `' |. /|  |   ||
||.=='    _-'                                                     `' |  /==.||
=='    _-'         S         P         E         C         S          \/   `==
\   _-'                                                                `-_   /
 `''                                                                      ``'
			Release v1.3 - April 13, 1994 EST
		 Written by: Matt Fell (matt.burnett@acebbs.com)
	   Distributed by: Hank Leukart (ap641@cleveland.freenet.edu)
	    "DOOM: Where hackers gnaw the bones left from the banquet
		 of data prepared by the mighty wizards of id."
	   "The poets talk about love, but what I talk about is DOOM,
		  because in the end, DOOM is all that counts."
	    - Alex Machine/George Stark/Stephen King, _The Dark Half_
-----------------------------------------------------------------------------

----------
DISCLAIMER
----------

	These specs are to aid in informing the public about the game DOOM,
by id Software.  In no way should this promote your killing yourself, killing
others, or killing in any other fashion.  Additionally, neither Hank Leukart
nor Matt Fell claim ANY responsibility regarding ANY illegal activity
concerning this file, or indirectly related to this file.  The information
contained in this file only reflects id Software indirectly, and questioning
id Software regarding any information in this file is not recommended.

----------------
COPYRIGHT NOTICE
----------------

This article is Copyright 1993, 1994 by Hank Leukart.  All rights reserved.
You are granted the following rights:

I.  To make copies of this work in original form, so long as
      (a) the copies are exact and complete;
      (b) the copies include the copyright notice and these paragraphs
	  in their entirety;
      (c) the copies give obvious credit to the author, Matt Fell;
      (d) the copies are in electronic form.
II. To distribute this work, or copies made under the provisions
    above, so long as
      (a) this is the original work and not a derivative form;
      (b) you do not charge a fee for copying or for distribution;
      (c) you ensure that the distributed form includes the copyright
	  notice, this paragraph, the disclaimer of warranty in
	  their entirety and credit to the author;
      (d) the distributed form is not in an electronic magazine or
	  within computer software (prior explicit permission may be
	  obtained from Hank Leukart);
      (e) the distributed form is the NEWEST version of the article to
	  the best of the knowledge of the distributor;
      (f) the distributed form is electronic.

	You may not distribute this work by any non-electronic media,
including but not limited to books, newsletters, magazines, manuals,
catalogs, and speech.  You may not distribute this work in electronic
magazines or within computer software without prior written explicit
permission.  These rights are temporary and revocable upon written, oral,
or other notice by Hank Leukart. This copyright notice shall be governed
by the laws of the state of Ohio.
	If you would like additional rights beyond those granted above,
write to the distributor at "ap641@cleveland.freenet.edu" on the Internet.

------------------------------
INTRODUCTION FROM HANK LEUKART
------------------------------

	Here are the long awaited unofficial specs for DOOM.  These specs
should be used for creating add-on software for the game. I would like to
request that these specs be used in making utilities that ONLY work on the
registered version of DOOM.
	I did not write these specs.  I am handling the distribution so
Matt Fell is not bombarded with E-mail with requests for the specs, etc.
If you would like a copy of the specs, E-mail Hank Leukart at
"ap641@cleveland.freenet.edu" on the Internet.  If you would like to ask
technical questions or give technical suggestions about the specs, please
write to Matt Fell at "matt.burnett@acebbs.com".

	Literature also written/distributed by Hank Leukart:

	- The "Official" DOOM FAQ:  A comprehensive guide to DOOM
	- DOOM iNsAnItY: A humorous look at DOOM and its players

--------
CONTENTS
--------

[1] Author's Notes
	[1-1] id Software's Copyright
	[1-2] What's New in the 1.3 Specs
	[1-3] Acknowledgments
[2] Basics
[3] Directory Overview
[4] The Maps, The Levels
	[4-1] ExMy
	[4-2] THINGS
		[4-2-1] Thing Types
		[4-2-2] Thing Attributes
	[4-3] LINEDEFS
		[4-3-1] Linedef Attributes
		[4-3-2] Linedef Types
	[4-4] SIDEDEFS
	[4-5] VERTEXES
	[4-6] SEGS
	[4-7] SSECTORS
	[4-8] NODES
	[4-9] SECTORS
		[4-9-1] Special Sector Types
	[4-10] REJECT
	[4-11] BLOCKMAP
		[4-11-1] Automatically Generating the BLOCKMAP
[5] Pictures
	[5-1] Headers
	[5-2] Pointers
	[5-3] Pixel Data
[6] Floor and Ceiling Textures
	[6-1] Animated floors, see [8-4-1]
[7] Songs and Sounds
	[7-1] Songs
	[7-2] Sounds
[8] Some Important Non-Picture Resources
	[8-1] PLAYPAL
	[8-2] COLORMAP
	[8-3] DEMOs
	[8-4] TEXTURE1 and TEXTURE2
		[8-4-1] Animated Walls
	[8-5] PNAMES


*******************************************************************************


---------------------------
CHAPTER [1]: Author's Notes
---------------------------

[1-1]: id Software's Copyright and the Shareware Version
========================================================

The LICENSE.DOC says:

       `You may not:  rent, lease, modify, translate, disassemble, decompile,
	reverse engineer, or create derivative works based upon the Software.
	Notwithstanding the foregoing, you may create a map editor, modify
	maps and make your own maps (collectively referenced as the "Permitted
	Derivative Works") for the Software. You may not sell or distribute
	any Permitted Derivative Works but you may exchange the Permitted
	Derivative Works at no charge amongst other end-users.'

       `(except for backup purposes) You may not otherwise reproduce, copy or
	disclose to others, in whole or in any part, the Software.'

	I think it is clear that you may not distribute a wad file that
contains any of the original data resources from DOOM.WAD. A level that only
has new things should be distributed as a pwad with only two entries in its
directory (explained below, in chapter [2]) - e.g. E3M1 and THINGS. And the
THINGS resource in the pwad should be substantially different from the
original one in DOOM.WAD. You should not distribute any pwad files that
contain episode one maps. Here's an excerpt from README.EXE:

       `id Software respectfully requests that you do not modify the levels
	for the shareware version of DOOM.  We feel that the distribution of
	new levels that work with the shareware version of DOOM will lessen a
	potential user's incentive to purchase the registered version.

       `If you would like to work with modified levels of DOOM, we encourage
	you to purchase the registered version of the game.'

	Recently, Jay Wilbur of id Software announced the formulation of a
policy on third-party additions to the game. You can find the announcement on
alt.games.doom, and probably lots of other places too. Or you can send me
mail asking for a copy of the announcement. Basically, they are preparing a
document, and if it was done, then I could tell you more, but it isn't
finished at the time I'm writing this.
	If you're making add-ons, plan on them not working on the shareware
game, and plan on including statements about the trademarks and copyrights
that id Software owns, as well as disclaimers that they won't support your
add-on product, nor will they support DOOM after it has been modified.

[1-2]: What's New in the 1.3 Specs
==================================

	The main reason for this release of the specs, 1.3, is of course the
explanation of the NODES structure. I've been delaying a little bit, because
I wanted to see if it would be feasible to include a good algorithm herein.
Also, I wanted to wait and see if someone could actually implement "node
theory" in a level editor, thereby verifying it.
	Now the theory HAS been verified. However, the actual implementation
is still being worked on (debugged) as I'm writing this. Also, I don't want
to steal anyone's hard work outright. This means that there is NOT a node
creation algorithm here, but I do outline how one can be done. I have tried
to come up with one on my own, but it is too difficult for me, especially
with all the other things I'm simultaneously doing.
	Where you WILL find pseudo-code is in the BLOCKMAP section. I
borrowed an excellent idea from a contributor, and code based on the
algorithm given here should be very fast. Even huge levels should
recalculate in seconds.
	Another new section completely explains the REJECT resource.
	This entire document has been re-formatted, and there have been
several other additions, and hopefully the last of the typos has been rooted
out. I consider these specs to be at least 95% complete. There are only minor
gaps in the information now. If the promised "official specifications" were
released today, I expect this would compare favorably with them (although
I know exactly what parts of it I would look to first).
	I've been notified of something very disappointing, and after a
couple weeks of trying there seems to be no way around it. The pictures that
are used for sprites (things like barrels, demons, and the player's pistol)
all have to be listed together in one .WAD file. This means that they don't
work from pwad files. The same thing goes for the floor pictures. Luckily,
the walls are done in a more flexible way, so they work in pwads. All this is
explained in chapter [5].

[1-3]: Acknowledgments
======================

	I have received much assistance from the following people. They
either brought mistakes to my attention, or provided additional information
that I've incorporated into these specs:

Ted Vessenes (tedv@geom.umn.ed)
	I had the THING angles wrong in the original specs.
Matt Tagliaferri (matt.tagliaferri@pcohio.com)
	The author of the DOOMVB40 editor (aka DOOMCAD). I forgot to describe
	the TEXTURE1/2 pointer table in the 1.1 specs. Also, helped with
	linedef types, and provided a good BLOCKMAP algorithm.
Raphael Quinet (quinet@montefiore.ulg.ac.be)
	The author of the NEWDEU editor, now DEU 5, the first editor that can
	actually do the nodes. Go get it. Gave me lots of rigorous
	contributions on linedef types and special sectors.
Robert Fenske (rfenske@swri.edu)
	Part of the team that created the VERDA editor. Gave me a great list
	of the linedef attributes; also helped with linedef types, a blockmap
	list, special sectors, and general tips and suggestions.
John A. Matzen (jamatzen@cs.twsu.edu)
	Instrument names in GENMIDI.
Jeff Bird (jeff@wench.ece.jcu.edu.au)
	Good ideas and suggestions about the NODES, and a blockmap algorithm.
Alistair Brown (A.D.Brown@bradford.ac.uk)
	Helped me understand the NODES; and told me how REJECT works.
Robert D. Potter (potter@bronze.lcs.mit.edu)
	Good theory about what BLOCKMAP is for and how the engine uses it.
Joel Lucsy (jjlucsy@mtu.edu)
	Info on COLORMAP and PLAYPAL.
Tom Nettleship (mastn@midge.bath.ac.uk)
	I learned about BSP trees from his comp.graphics.algorithms messages.
Colin Reed (dyl@cix.compulink.co.uk)
	I had the x upper and lower bounds for node bounding boxes backwards.
Frans P. de Vries (fpdevries@hgl.signaal.nl)
	Thanks for the cool ASCII DOOM logo used for the header.

	Thanks for all the help! Sorry if I left anyone out. If you have
any comments or questions, have spotted any errors, or have any possible
additions, please send me e-mail.



*******************************************************************************


-------------------
CHAPTER [2]: Basics
-------------------

	There are two types of "wad" files. The original DOOM.WAD file is an
"IWAD", or "Internal wad", meaning it contains all of the data necessary to
play. The other type is the "PWAD" file, "Patch wad", an external file which
has the same structure, but with far fewer entries in the directory
(explained below). The data in a pwad is substituted for the original data in
the DOOM.WAD, thus allowing for much easier distribution of new levels. Only
those resources listed in the pwad's directory are changed, everything else
stays the same.
	A typical pwad might contain new data for a single level, in which
case in would contain the 11 entries necessary to define the level. Pwad
files need to have the extension .WAD, and the filename needs to be at least
four characters: X.WAD won't work, but rename it XMEN.WAD, and it will work.
Most of the levels available now are called something like E2L4BOB.WAD,
meaning episode 2, level 4, by "Bob". I think a better scheme is the one just
starting to be used now, two digits for the episode and level, then up to six
letters for the level's name, or its creator's name. For example, if Neil
Peart were to create a new level 6 for episode 3, he might call it
36NEILP.WAD.
	To use this level instead of the original e3m6 level, a player would
type DOOM -FILE 36NEILP.WAD at the command line, along with any other
parameters. More than one external file can be added at the same time, thus
in general:

DOOM -FILE [pwad_filename] [pwad_filename] [pwad_filename] ...

	When the game loads, a "modified game" message will appear if there
are any pwads involved, reminding the player that id Software will not give
technical support or answer questions regarding modified levels.
	A pwad file may contain more than one level or parts of levels, in
fact there is apparently no limit to how many entries may be in a pwad. The
original doom levels are pretty complicated, and they are from 50-200
kilobytes in size, uncompressed. Simple prototype levels are just a few k.
	The first twelve bytes of a wad file are as follows:

Bytes 0 to 3    must contain the ASCII letters "IWAD" or "PWAD"
Bytes 4 to 7    contain a long integer which is the number of entries in the
		"directory"
Bytes 8 to 11   contain a pointer to the first byte of the "directory"

	Bytes 12 to the start of the directory contain resource data. The
directory referred to is a list, located at the end of the wad file, which
contains the pointers, lengths, and names of all the resources in the wad
file. The resources in the wad include item pictures, monster's pictures for
animation, wall patches, floor and ceiling textures, songs, sound effects,
map data, and many others.
	As an example, the first 12 bytes of the DOOM.WAD file might be
"49 57 41 44 d4 05 00 00 c9 fd 6c 00" (in hexadecimal). This is "IWAD", then
5d4 hex (=1492 decimal) for the number of directory entries, then 6cfdc9 hex
(=7142857 decimal) for the first byte of the directory.
	Each directory entry is 16 bytes long, arranged this way:

First four bytes:       pointer to start of resource (a long integer)
Next four bytes:        length of resource (another long integer)
Last eight bytes:       name of resource, in ASCII letters, ending with
			00s if less than eight bytes.


*******************************************************************************


-------------------------------
CHAPTER [3]: Directory Overview
-------------------------------

	This is a list of most of the directory entries. It would take 2000
lines to list every single entry, and that would be silly. All the ST entries
are for status bar pictures, so why list every one? And the naming convention
for the 700 sprites is easy (see chapter [5]), so there's no need to list
them all individually.

PLAYPAL   contains fourteen 256 color palettes, used while playing Doom.
COLORMAP  maps colors in the palette down to darker ones, for areas of less
	    than maximum brightness (quite a few of these places, huh?).
ENDOOM    is the text message displayed when you exit to DOS.
DEMOx     x=1-3, are the demos which will play if you just sit and watch.
E1M1      etc, to E3M9, along with its 10 subsequent entries, defines the
	  map data for a single level or mission.
TEXTURE1  is a list of wall type names used in the SIDEDEF portion of each
	    level , and their composition data, i.e. what wall patches make
	    up each texture.
TEXTURE2  contains the walls that are only in the registered version.
PNAMES    is the list of wall patches, which are referenced by number in the
	    TEXTURE1/2 resources.
GENMIDI   has the names of every General Midi standard instrument in order
	    from 0-127. Anyone know more...?
DMXGUS    obviously has to do with Gravis Ultra Sound. It's a text file, easy
	    to read. Just extract it (WadTool works nicely).
D_ExMy    is the music for episode x level y.
D_INTER   is the music played on the summary screen between levels.
D_INTRO   is the 4 second music played when the game starts.
D_INTROA  is also introductory music.
D_VICTOR  is the music played on the victory text-screen after an episode.
D_BUNNY   is music for while a certain rabbit has his story told...
DP_xxxxx  DP and DS come in pairs and are the sound effects. DP_ are the PC
DS_xxxxx    speaker sounds, DS_ are the sound card sounds.

	All the remaining entries in the directory, except the floor textures
at the end, and the "separators" like S_START, refer to resources which are
pictures, in the doom/wad picture format described in chapter [5]. The floor
textures are also pictures, but in a raw format described in chapter [6].
	The next seven are full screen (320 by 200 pixel) pictures:

HELP1     The ad-screen that says Register!, with some screen shots.
HELP2     The actual help, all the controls explained.
TITLEPIC  Maybe this is the title screen? Gee, I dunno...
CREDIT    The credits, the people at id Software who created this great game.
VICTORY2  The screen shown after a victorious end to episode 2.
PFUB1     A nice little rabbit minding his own peas and queues...
PFUB2     ...maybe a hint of what's waiting in Doom Commercial version.
ENDx      x=0-6, "THE END" text, with (x) bullet holes.
AMMNUMx   x=0-9, are the gray digits used in the status bar for ammo count.
STxxxxxx  are small pictures and text used on the status bar.
M_xxxxxx  are text messages (yes, in picture format) used in the menus.
BRDR_xxx  are tiny two pixel wide pictures use to frame the viewing window
	    when it is not full screen.
WIxxxxxx  are pictures and messages used on the summary screen after
	    the completion of a level.
WIMAPx    x=0-2, are the summary-screen maps used by each episode.
S_START   has 0 length and is right before the item/monster "sprite" section.
	    See chapter [5] for the naming convention used here.
S_END     is immediately after the last sprite.
P_START   marks the beginning of the wall patches.
P1_START    before the first of the shareware wall patches.
P1_END      after the last of the shareware wall patches.
P2_START    before the first of the registered wall patches.
P2_END      before the first of the registered wall patches.
P_END     marks the end of the wall patches.
F_START   marks the beginning of the floors.
F1_START    before the first shareware floor texture.
F1_END      after the last shareware floor texture.
F2_START    before the first registered floor texture.
F2_END      after the last registered floor texture.
F_END     marks the end of the floors.

	And that's the end of the directory.

	It is possible to include other entries and resources in a wad file,
e.g. an entry called CLOWNS could point to a resource that includes the
level creator's name, date of completion, or a million other things. None of
these non-standard entries will be used by DOOM, nor will they cause it
problems. Some of the map editors currently out add extra entries. There is
a debate going on right now as to the merits of these extras. Since they are
all non-standard, and potentially confusing, for now I'm in favor of not
using any extra entries, and instead passing along a text file with a pwad.
However, I can see some possible advantages, and I might change my mind...


*******************************************************************************


---------------------------------
CHAPTER [4]: The Maps, The Levels
---------------------------------

	Each level needs eleven resources/directory entries: E[x]M[y],
THINGS, LINEDEFS, SIDEDEFS, VERTEXES, SEGS, SSECTORS, NODES, SECTORS,
REJECT, and BLOCKMAP.
	In the DOOM.WAD file, all of these entries are present for every
level. In a pwad external file, they don't all need to be present. Whichever
entries are in a pwad will be substituted for the originals. For example, a
pwad with just two entries, E3M1 and THINGS, would use all the walls and such
from the original E3M1, but could have a completely different set of THINGS.
	A note on the coordinates: the coordinate system used for the
vertices and the heights of the sectors corresponds to pixels, for purposes of
texture- mapping. So a sector that's 128 high, or a multiple of 128, is pretty
typical, since many wall textures are 128 pixels high.

[4-1]: ExMy
===========

	x is a single digit 1-3 for the episode number and y is 1-9 for the
mission/level number.
	This is just the name resource for a (single) level, and has zero
length. It marks any map-data resources that follow it in the directory list
as being components of that level. The assignment of resources to this level
stops with either the next ExMy entry, or with a non-map entry like TEXTURE1.

[4-2]: THINGS
=============

	Each thing is ten bytes, consisting of five (integer) fields:

(1) X coordinate of thing
(2) Y coordinate of thing
(3) Angle the thing faces. On the automap, 0 is east, 90 is north, 180 is
    west, 270 is south. This value is only used for monsters, player
    starts, deathmatch random starts, and teleporter incoming spots.  Others
    look the same from all directions. Values are rounded to the nearest 45
    degree angle, so if the value is 80, it will actually face 90 - north.
(4) Type of thing, see next subsection, [4-2-1]
(5) Attributes of thing, see [4-2-2]

[4-2-1]: Thing Types
--------------------

	Bytes 6-7 of each thing are an integer which specifies its kind:

Dec/Hex The thing's number
Sprite  The sprite name associated with this thing. This is the first four
	  letters of the directory entries that are pictures of this thing.
seq.    The sequence of frames displayed. "-" means it displays nothing.
	  Unanimated things will have just an "a" here, e.g. a backpack's
	  only sprite can be found in the wad under BPAKA0. Animated things
	  will show the order that their frames are displayed (they cycle
	  back after the last one). So the blue key uses BKEYA0 then BKEYB0,
	  etc. The soulsphere uses SOULA0-SOULB0-C0-D0-C0-B0 then repeats.

	  Thing 15, a dead player, is PLAYN0.
+       Monsters and players and barrels. They can be hurt, and they have
	  a more complicated sprite arrangement. See chapter [5].
CAPITAL Monsters, counts toward the KILL ratio at the end of a level.
*       An obstacle, players and monsters can't move through it.
^       Hangs from the ceiling, or floats (if a monster).
$       A regular item that players may get.
!       An artifact item; counts toward the ITEM ratio at level's end.

Dec. Hex Sprite seq.    Thing is:

0    0000 ---- -        (nothing)
1    0001 PLAY +        Player 1 start (Player 1 start is needed even on)
2    0002 PLAY +        Player 2 start (levels intended for deathmatch only.)
3    0003 PLAY +        Player 3 start (Player starts 2-4 are only needed
for)
4    0004 PLAY +        Player 4 start (cooperative mode multiplayer games.)
5    0005 BKEY ab     $ Blue keycard
6    0006 YKEY ab     $ Yellow keycard
7    0007 SPID +      * SPIDER DEMON: giant walking brain boss
8    0008 BPAK a      $ Backpack
9    0009 SPOS +      * FORMER HUMAN SERGEANT: black armor shotgunners
10   000a PLAY w        Bloody mess (an exploded player)
11   000b ---- -        Deathmatch start positions. Must be at least 4/level.
12   000c PLAY w        Bloody mess, this thing is exactly the same as 10
13   000d RKEY ab     $ Red Keycard
14   000e ---- -        Marks the spot where a player (or monster) lands when
			they teleport to the SECTOR that contains this thing.
15   000f PLAY n        Dead player
16   0010 CYBR +      * CYBER-DEMON: robo-boss, rocket launcher
17   0011 CELP a      $ Cell charge pack
18   0012 POSS a        Dead former human
19   0013 SPOS a        Dead former sergeant
20   0014 TROO a        Dead imp
21   0015 SARG a        Dead demon
22   0016 HEAD a        Dead cacodemon
23   0017 SKUL a        Dead lost soul, invisible (they blow up when killed)
24   0018 POL5 a        Pool of blood
25   0019 POL1 a      * Impaled human
26   001a POL6 ab     * Twitching impaled human
27   001b POL4 a      * Skull on a pole
28   001c POL2 a      * 5 skulls shish kebob
29   001d POL3 ab     * Pile of skulls and candles
30   001e COL1 a      * Tall green pillar
31   001f COL2 a      * Short green pillar
32   0020 COL3 a      * Tall red pillar
33   0021 COL4 a      * Short red pillar
34   0022 CAND a        Candle
35   0023 CBRA a      * Candelabra
36   0024 COL5 ab     * Short green pillar with beating heart
37   0025 COL6 a      * Short red pillar with skull
38   0026 RSKU ab     $ Red skullkey
39   0027 YSKU ab     $ Yellow skullkey
40   0028 BSKU ab     $ Blue skullkey
41   0029 CEYE abcb   * Eye in symbol
42   002a FSKU abc    * Flaming skull-rock
43   002b TRE1 a      * Gray tree
44   002c TBLU abcd   * Tall blue firestick
45   002d TGRE abcd   * Tall green firestick
46   002e TRED abcd   * Tall red firestick
47   002f SMIT a      * Small brown scrub
48   0030 ELEC a      * Tall, techno column
49   0031 GOR1 abcb   *^Hanging victim, swaying, legs gone
50   0032 GOR2 a      *^Hanging victim, arms out
51   0033 GOR3 a      *^Hanging victim, 1-legged
52   0034 GOR4 a      *^Hanging victim, upside-down, upper body gone
53   0035 GOR5 a      *^Hanging severed leg
54   0036 TRE2 a      * Large brown tree
55   0037 SMBT abcd   * Short blue firestick
56   0038 SMGT abcd   * Short green firestick
57   0039 SMRT abcd   * Short red firestick
58   003a SARG +      * SPECTRE: invisible version of the DEMON
59   003b GOR2 a       ^Hanging victim, arms out
60   003c GOR4 a       ^Hanging victim, upside-down, upper body gone
61   003d GOR3 a       ^Hanging victim, 1-legged
62   003e GOR5 a       ^Hanging severed leg
63   003f GOR1 abcb    ^Hanging victim, swaying, legs gone
2001 07d1 SHOT a      $ Shotgun
2002 07d2 MGUN a      $ Chaingun, gatling gun, mini-gun, whatever
2003 07d3 LAUN a      $ Rocket launcher
2004 07d4 PLAS a      $ Plasma gun
2005 07d5 CSAW a      $ Chainsaw
2006 07d6 BFUG a      $ BFG9000
2007 07d7 CLIP a      $ Ammo clip
2008 07d8 SHEL a      $ 4 shotgun shells
2010 07da ROCK a      $ 1 rocket
2011 07db STIM a      $ Stimpak
2012 07dc MEDI a      $ Medikit
2013 07dd SOUL abcdcb ! Soulsphere, Supercharge, +100% health
2014 07de BON1 abcdcb ! Health bonus
2015 07df BON2 abcdcb ! Armor bonus
2018 07e2 ARM1 ab     $ Green armor 100%
2019 07e3 ARM2 ab     $ Blue armor 200%
2022 07e6 PINV abcd   ! Invulnerability
2023 07e7 PSTR a      ! Berserk Strength
2024 07e8 PINS abcd   ! Invisibility
2025 07e9 SUIT a      ! Radiation suit
2026 07ea PMAP abcdcb ! Computer map
2028 07ec COLU a      * Floor lamp
2035 07f3 BAR1 ab+    * Barrel; blown up (BEXP sprite) no longer an obstacle.
2045 07fd PVIS ab     ! Lite goggles
2046 07fe BROK a      $ Box of Rockets
2047 07ff CELL a      $ Cell charge
2048 0800 AMMO a      $ Box of Ammo
2049 0801 SBOX a      $ Box of Shells
3001 0bb9 TROO +      * IMP: brown fireball hurlers
3002 0bba SARG +      * DEMON: pink bull-like chewers
3003 0bbb BOSS +      * BARON OF HELL: cloven hooved minotaur boss
3004 0bbc POSS +      * FORMER HUMAN: regular pistol shooting slimy human
3005 0bbd HEAD +      *^CACODEMON: red one-eyed floating heads. Behold...
3006 0bbe SKUL +      *^LOST SOUL: flying flaming skulls, they really bite

	I couldn't figure out a way to squeeze the following information into
the above table. RAD is the thing's radius, they're all circular for
collision purposes. HT is its height, for purposes of crushing ceilings and
testing if monsters or players are too tall to enter a sector. SPD is a
monster's speed. So now you know that a player is 56 units tall. Even though
this table implies that they're 16*2 wide, players can't enter a corridor
that's 32 wide. It must be at least 34 units wide (48 is the lowest width
divisible by 16). Although obstacles and monsters have heights, they are
infinitely tall for purposes of a player trying to go through them.

Dec. Hex   RAD   HT  SPD       Thing or class of things:

-       -   16   56    -       Player
7    0007  128  100   12       Spider-demon
9    0009   20   56    8       Former sergeant
16   0010   40  110   16       Cyber-demon
58   003a   30   56    8       Spectre
3001 0bb9   20   56    8       Imp
3002 0bba   30   56    8       Demon
3003 0bbb   24   64    8       Baron of Hell
3004 0bbc   20   56    8       Former human
3005 0bbd   31   56    8       Cacodemon
3006 0bbe   16   56    8       Lost soul
2035 07f3   10   42            barrel
	    20   16            all gettable things
	    16   16            most obstacles
54   0036   32   16            large brown tree

[4-2-2]: Thing attributes
-------------------------

	The last two bytes of a THING control a few attributes, according to
which bits are set:

bit 0   the THING is present at skill 1 and 2
bit 1   the THING is present at skill 3 (hurt me plenty)
bit 2   the THING is present at skill 4 and 5 (ultra-violence, nightmare)
bit 3   indicates a deaf guard.
bit 4   means the THING only appears in multiplayer mode.
bits 5-15 have no effect.

	The skill settings are most used with the monsters, of course...the
most common skill level settings are hex 07/0f (on all skills), 06/0e (on
skill 3-4-5), and 04/0c (only on skill 4-5).
	"deaf guard" only has meaning for monsters, who will not attack until
they see a player if they are deaf. Otherwise, they will activate when they
hear gunshots, etc (including the punch!). Sound does not travel through
solid walls (walls that are solid at the time of the noise). Also, lines can
be set so that sound does not pass through them (see [4-3-1] bit 6). This
attribute is also known as the "ambush" attribute.

[4-3]: LINEDEFS
===============

	Each linedef represents a line from one of the VERTEXES to another,
and each is 14 bytes, containing 7 (integer) fields:

(1) from the VERTEX with this number (the first vertex is 0).
(2) to the VERTEX with this number (31 is the 32nd vertex).
(3) attributes, see [4-3-1] below.
(4) types, see [4-3-2] below.
(5) is a "trigger" or "tag" number which ties this line's effect type to all
      SECTORS that have the same trigger number in their last field.
(6) "right" SIDEDEF, indexed number.
(7) "left" SIDEDEF, if this line adjoins 2 SECTORS. Otherwise, it is equal
      to -1 (FFFF hex).

	"right" and "left" are based on the direction of the linedef as
indicated by the "from" and "to" VERTEXES. This attempt at a sketch should
make it clear what I mean:

	    left side              right side
    from -----------------> to <----------------- from
	    right side             left side

	IMPORTANT: All lines must have a right side. If it is a one-sided
line, then it must go the proper direction, so its single side is facing
the sector it is part of.

[4-3-1]: Linedef Attributes
---------------------------

	The third field of each linedef is an integer which controls that
line's attributes with bits, as follows:

bit #  condition if it is set (=1)

bit 0   Impassable. Players and monsters cannot cross this line, and
	  projectiles explode or end if they hit this line. Note, however,
	  that if there is no sector on the other side, things can't go
	  through this line anyway.
bit 1   Monster-blocker. Monsters cannot cross this line.
bit 2   Two-sided. If this bit is set, then the linedef's two sidedefs can
	  have "-" as a texture, which means "transparent". If this bit is not
	  set, the sidedefs can't be transparent: if "-" is viewed, it will
	  result in the hall of mirrors effect. However, the linedef CAN have
	  two non-transparent sidedefs, even if this bit is not set, if it is
	  between two sectors.
	Another side effect of this bit is that if it is set, then
	  projectiles and gunfire (pistol, etc.) can go through it if there
	  is a sector on the other side, even if bit 0 is set.
	Also, monsters see through these lines, regardless of the line's
	  other attribute settings and its textures ("-" or not doesn't matter).
bit 3   Upper texture is "unpegged". This is usually done at windows.
	  "Pegged" textures move up and down when the neighbor sector moves
	  up or down. For example, if a ceiling comes down, then a pegged
	  texture on its side will move down with it so that it looks right.
	  If the side isn't pegged, it just sits there, the new material is
	  spontaneously created. The best way to get an idea of this is to
	  change a linedef on an elevator or door, which are always pegged,
	  and observe the result.
bit 4   Lower texture is unpegged.
bit 5   Secret. The automap will draw this line like a normal solid line that
	  doesn't have anything on the other side, thus protecting the secret
	  until it is opened. This bit is NOT what determines the SECRET
	  ratio at the end of a level, that is done by special sectors (#9).
bit 6   Blocks sound. Sound cannot cross a line that has this bit set.
	  Sound normally travels from sector to sector, so long as the floor
	  and ceiling heights allow it (e.g. sound wouldn't go from a sector
	  with 0/64 floor/ceiling height to one with 72/128, but sound WOULD
	  go from a sector with 0/64 to one with 56/128).
bit 7   Not on map. The line is not shown on the regular automap, not even if
	  the computer all-map power up is gained.
bit 8   Already on map. When the level is begun, this line is already on the
	  automap, even though it hasn't been seen (in the display) yet.

bits 9-15 are unused, EXCEPT for a large section of e2m7, where every
wall on the border of the section has bits 9-15 set, so they have values like
1111111000000000 (-511) and 1111111000010000 (-495). This area of e2m7 is
also the only place in all 27 levels where there is a linedef 4 value of -1. But
the linedef isn't a switch. These unique values either do nothing, or
something that is as yet unknown. The currently prevailing opinion is that
they do nothing.
	Another rare value used in some of the linedef's attribute fields is
ZERO. It occurs only on one-sided walls, where it makes no difference whether
or not the impassibility bit (bit 0) is set. Still, it seems to indicate a
minor glitch in the DOOM-CAD editor (on the NExT), I suppose.

[4-3-2]: Linedef Types
----------------------

	The integers in field 4 of a linedef control various special effects,
mostly to do with what happens to a triggered SECTOR when the line is crossed
or activated by a player.
	Except for the ones marked DOOR, the end-level switches, and the
special type 48 (hex 30), all these effects need trigger/tag numbers. Then
any and all sectors whose last field contains the same trigger number are
affected when the linedef's function is activated.
	All functions are only performed from the RIGHT side of a linedef.
Thus switches and doors can only be activated from the right side, and
teleporter lines only work when crossed from the right side.
	What the letters in the ACT column mean:

W means the function happens when a player WALKS across the linedef.
S means a player must push SPACEBAR near the linedef to activate it (doors
    and switches).
G means a player or monster must shoot the linedef with a pistol or shotgun.
1 means it works once only.
R means it is a repeatable function.

	Some functions that appear to work only once can actually be made to
work again if the conditions are reset. E.g. a sector ceiling rises, opening
a little room with baddies in it. Usually, that's it. But perhaps if some
other linedef triggered that sector ceiling to come down again, then the
original trigger could make it go up, etc...
	Doors make a different noise when activated than the platform type
(floor lowers and rises), the ones that exhibit the door-noise are so called
in the EFFECT column. But only the ones marked DOOR in capitals don't need
trigger numbers.

Dec/Hex   ACT   EFFECT

-1 ffff   ? ?   None? Only once in whole game, on e2m7, (960,768)-(928,768)
0    00   - -   nothing
1    01   S R   DOOR. Sector on the other side of this line has its
		ceiling rise to 8 below the first neighbor ceiling on the
		way up, then comes back down after 6 seconds.
2    02   W 1   Open door (stays open)
3    03   W 1   Close door
5    05   W 1   Floor rises to match highest neighbor's floor height.
7    07   S 1   Staircase rises up from floor in appropriate sectors.
8    08   W 1   Stairs

Note: The stairs function requires special handling. An even number of steps
will be raised, starting with the first sector that has the same trigger
number as this linedef. Then the step sector's trigger number alternates
between 0 and any other value. The original maps use either 99 or 999, and
this is wise. The steps don't all have to start at the same altitude. All the
steps rise up 8, then all but the first rise another 8, etc. If a step hits
a ceiling, it stops. Some interesting effects are possible with steps that
aren't the same size or shape as previous steps, but in general, the most
reliable stairways will be just like the originals, congruent rectangles.

9    09   S 1   Floor lowers; neighbor sector's floor rises and changes
		TEXTURE and sector type to match surrounding neighbor.
10   0a   W 1   Floor lowers for 3 seconds, then rises
11   0b   S -   End level. Go to next level.
13   0d   W 1   Brightness goes to 255
14   0e   S 1   Floor rises to 64 above neighbor sector's floor
16   10   W 1   Close door for 30 seconds, then opens.
18   12   S 1   Floor rises to equal first neighbor floor
19   13   W 1   Floor lowers to equal neighboring sector's floor
20   14   S 1   Floor rises, texture and sector type change also.
21   15   S 1   Floor lowers to equal neighbor for 3 seconds, then rises back
		up to stop 8 below neighbor's ceiling height
22   16   W 1   Floor rises, texture and sector type change also
23   17   S 1   Floor lowers to match lowest neighbor sector
26   1a   S R   DOOR. Need blue key to open. Closes after 6 seconds.
27   1b   S R   DOOR. Yellow key.
28   1c   S R   DOOR. Red key.
29   1d   S 1   Open door, closes after 6 seconds
30   1e   W 1   Floor rises to 128 above neighbor's floor
31   1f   S 1   DOOR. Stays open.
32   20   S 1   DOOR. Blue key. Stays open.
33   21   S 1   DOOR. Yellow key. Stays open.
34   22   S 1   DOOR. Red key. Stays open.
35   23   W 1   Brightness goes to 0.
36   24   W 1   Floor lowers to 8 above next lowest neighbor
37   25   W 1   Floor lowers, change floor texture and sector type
38   26   W 1   Floor lowers to match neighbor
39   27   W 1   Teleport to sector. Only ONE sector can have the same tag #
40   28   W 1   Ceiling rises to match neighbor ceiling
41   29   S 1   Ceiling lowers to floor
42   2a   S R   Closes door
44   2c   W 1   Ceiling lowers to 8 above floor
46   2e   G 1   Opens door (stays open)
48   30   - -   Animated, horizontally scrolling wall.
51   33   S -   End level. Go to secret level 9.
52   34   W -   End level. Go to next level
56   38   W 1   Crushing floor rises to 8 below neighbor ceiling
58   3a   W 1   Floor rises 32
59   3b   W 1   Floor rises 8, texture and sector type change also
61   3d   S R   Opens door
62   3e   S R   Floor lowers for 3 seconds, then rises
63   3f   S R   Open door, closes after 6 seconds
70   46   S R   Sector floor drops quickly to 8 above neighbor
73   49   W R   Start crushing ceiling, slow crush but fast damage
74   4a   W R   Stops crushing ceiling
75   4b   W R   Close door
76   4c   W R   Close door for 30 seconds
77   4d   W R   Start crushing ceiling, fast crush but slow damage
80   50   W R   Brightness to maximum neighbor light level
82   52   W R   Floor lowers to equal neighbor
86   56   W R   Open door (stays open)
87   57   W R   Start moving floor (up/down every 5 seconds)
88   58   W R   Floor lowers quickly for 3 seconds, then rises
89   59   W R   Stops the up/down syndrome started by #87
90   5a   W R   Open door, closes after 6 seconds
91   5b   W R   Floor rises to 8 below neighbor ceiling
97   61   W R   Teleport to sector. Only ONE sector can have the same tag #
98   62   W R   Floor lowers to 8 above neighbor
102  66   S 1   Floor lowers to equal neighbor

103  67   S 1   Opens door (stays open)
104  68   W 1   Light drops to lowest light level amongst neighbor sectors

[4-4]: SIDEDEFS
===============

	A sidedef is a definition of what wall texture to draw along a
LINEDEF, and a group of sidedefs define a SECTOR.
	There will be one sidedef for a line that borders only one sector,
since it is not necessary to define what the doom player would see from the
other side of that line because the doom player can't go there. The doom
player can only go where there is a sector.
	Each sidedef is 30 bytes, comprising 2 (integer) fields, then 3
(8-byte string) fields, then a final (integer) field:

(1) X offset for pasting the appropriate wall texture onto the wall's
      "space": positive offset moves into the texture, so the left portion
      gets cut off (# of columns off left side = offset). Negative offset
      moves texture farther right, in the wall's space
(2) Y offset: analogous to the X, for vertical.
(3) "upper" texture name: the part above the juncture with a lower ceiling
      of an adjacent sector.
(4) "lower" texture name: the part below a juncture with a higher floored
      adjacent sector.
(5) "full" texture name: the regular part of the wall
(6) SECTOR that this sidedef faces or helps to surround

	The texture names are from the TEXTURE1/2 resources. 00s fill the
space after a wall name that is less than 8 characters. The names of wall
patches in the directory are not directly used, they are referenced through
the PNAMES.
	Simple sidedefs have no upper or lower texture, and so they will have
"-" instead of a texture name. Also, two-sided lines can be transparent, in
which case "-" means transparent (no texture).
	If the wall is wider than the texture to be pasted onto it, then the
texture is tiled horizontally. A 64-wide texture will be pasted at 0, 64,
128, etc. If the wall is taller than the texture, than the same thing is
done, it is vertically tiled, with one very important difference: it starts new
ones ONLY at 128, 256, 384, etc. So if the texture is less than 128 high,
there will be junk filling the undefined areas, and it looks ugly.

[4-5]: VERTEXES
===============

	These are the beginnings and ends for LINEDEFS and SEGS, each is 4
bytes, 2 (integer) fields:

(1) X coordinate
(2) Y coordinate

	On the automap within the game, with the grid on (press 'G'), the
lines are hex 80 (decimal 128) apart, two lines = hex 100, dec 256.

[4-6]: SEGS
===========

	The SEGS are in a sequential order determined by the SSECTORS, which
are part of the NODES recursive tree. Each seg is 12 bytes, having 6
(integer)
fields:

(1) from VERTEX with this number
(2) to VERTEX
(3) angle: 0= east, 16384=north, -16384=south, -32768=west.
      In hex, it's 0000=east, 4000=north, 8000=west, c000=south.
      This is also know as BAMS for Binary Angle Measurement.
(4) LINEDEF that this seg goes along
(5) 0 = this seg is on the right SIDEDEF of the linedef.
    1 = this seg is on the left SIDEDEF.
      This could also be thought of as direction: 0 if the seg goes the same
      direction as the linedef it's on, 1 if it goes the opposite direction.
(6) Offset distance along the linedef to the start of this seg (the vertex in
      field 1). The offset is in the same direction as the seg. If field 5 is
      0, then the distance is from the "from" vertex of the linedef to the
      "from" vertex of the seg. If feild 5 is 1, it is from the "to" vertex
of the linedef to the "from" vertex of the seg. So if the seg begins at
one of the two endpoints of the linedef, this will be 0.

	For diagonal segs, the offset distance can be obtained from the
formula DISTANCE = SQR((x2 - x1)^2 + (y2 - y1)^2). The angle can be
calculated from the inverse tangent of the dx and dy in the vertices, multiplied
to convert PI/2 radians (90 degrees) to 16384. And since most arctan functions
return a value between -(pi/2) and (pi/2), you'll have to do some tweaking
based on the sign of (x2-x1), to account for segs that go "west".

[4-7]: SSECTORS
===============

	SSECTOR stands for sub-sector. These divide up all the SECTORS into
convex polygons. They are then referenced through the NODES resources. There
will be (number of nodes) + 1 ssectors. Each ssector is 4 bytes, having 2
(integer) fields:

(1) This many SEGS are in this SSECTOR...
(2) ...starting with this SEG number

[4-8]: NODES
============

	The full explanation of the nodes follows this list of a node's
structure in the wad file. Each node is 28 bytes, composed of 14 (integer)
fields:

(1)  X coordinate of partition line's start
(2)  Y coordinate of partition line's start
(3)  DX, change in X to end of partition line
(4)  DY, change in Y to end of partition line
       64, 128, -64, -64 would be a partition line from (64,128) to (0,64)
(5)  Y upper bound for right bounding-box.\
(6)  Y lower bound                         All SEGS in right child of node
(7)  X lower bound                         must be within this box.
(8)  X upper bound                        /
(9)  Y upper bound for left bounding box. \
(10) Y lower bound                         All SEGS in left child of node
(11) X lower bound                         must be within this box.
(12) X upper bound                        /
(13) a NODE or SSECTOR number for the right child. If bit 15 is set, then the
       rest of the number represents the child SSECTOR. If not, the child is
       a recursed node.
(14) a NODE or SSECTOR number for the left child.

	The NODES resource is by far the most difficult to understand of all
the data structures in DOOM. A new level won't display right without a valid
set of precalculated nodes, ssectors, and segs. This is why so much time has
passed without a fully functional map-editor, even though many people are
working on them.
	Here I will explain what the nodes are for, and how they can be
generated automatically from the set of linedefs, sidedefs, and vertices. I
do NOT have a pseudo-code algorithm. There are many reasons for this. I'm not
actually programming a level editor myself, so I have no way of testing and
debugging a fully elaborated algorithm. Also, it is a very complicated
process, and heavily commented code would be very long. I'm not going to put
any language-specific code in here either, since it would be of limited
value. Finally, there are some implementations of automatic node generation
out there, but they are still being worked on, i.e. they still exhibit some
minot bugs.
	The NODES are branches in a binary space partition (BSP) that divides
up the level and is used to determine which walls are in front of others, a
process know as hidden-surface removal. The SSECTORS (sub-sectors) and SEGS
(segments) resources are necessary parts of the structure.
	A BSP tree is normally used in 3d space, but DOOM uses a simplified
2d version of the scheme. Basically, the idea is to keep dividing the map into
smaller spaces until each of the smallest spaces contains only wall segments
which cannot possibly occlude (block from view) other walls in its own space.
The smallest, undivided spaces will become SSECTORS. Each wall segment is
part or all of a linedef (and thus a straight line), and becomes a SEG. All
of the divisions are kept track of in a binary tree structure, which is used
to greatly speed the rendering process (drawing what is seen).
	Only the SECTORS need to be divided. The parts of the levels that are
"outside" sectors are ignored. Also, only the walls need to be kept track of.
The sides of any created ssectors which are not parts of linedefs do not
become segs.
	Some sectors do not require any dividing. Consider a square sector.
All the walls are orthogonal to the floor (the walls are all straight up and
down), so from any viewpoint inside the square, none of its four walls can
possibly block the view of any of the others. Now imagine a sector shaped
like this drawing:

+---------------.------+    The * is the viewpoint, looking ->, east. The
|                .     |    diagonal wall marked @ @ can't be seen at all,
|                /\    |@   and the vertical wall marked @@@ is partially
|   *->        /   @\  |@   occluded by the other diagonal wall. This sector
|            /       @\|@   needs to be divided. Suppose the diagonal wall
+----------/                is extended, as shown by the two dots (..):

now each of the two resulting sub-sectors are sufficient, because while in
either one, no wall that is part of that sub-sector blocks any other.
	In general, being a convex polygon is the goal of a ssector. Convex
means a line connecting any two points that are inside the polygon will be
completely contained in the polygon. All triangles and rectangles are convex,
but not all quadrilaterals. In doom's simple Euclidean space, convex also
means that all the interior angles of the polygon are <= 180 degrees.
	Now, an additional complication arises because of the two-sided
linedef. Its two sides are in different sectors, so they will end up in
different ssectors too. Thus every two-sided linedef becomes two segs (or
more), or you could say that every sidedef becomes a seg. Creating segs from
sidedefs is a good idea, because the seg can then be associated with a
sector.  Two segs that aren't part of the same sector cannot possibly be in
the same ssector, so further division is required of any set of segs that
aren't all from the same sector.
	Whenever a division needs to be made, a SEG is picked, somewhat
arbitrarily, which along with its imaginary extensions, forms a "knife" that
divides the remaining space in two (thus binary). This seg is the partition
line of a node, and the remaining spaces on either side of the partition line
become the right and left CHILDREN of the node. All partition lines have a
direction, and the space on the "right" side of the partition is the right
child of the node; the space on the "left" is the left child (there's a cute
sketch in [4-3]: LINEDEFS that shows how right and left relate to the start
and end of a line). Note that if there does not exist a seg in the remaining
space which can serve as a partition line, then there is no need for a
further partition, i.e. it's a ssector and a "leaf" on the node tree.
	If the "knife" passes through any lines/segs (but not at vertices),
they are split at the intersection, with one part going to each child. A two
sided linedef, which is two segs, when split results in four segs. A two
sider that lies along an extension of the partition line has each of its two
segs go to opposite sides of the partition line. This is the eventual fate of
ALL segs on two-sided linedefs.
	As the partition lines are picked and the nodes created, a strict
ordering must be maintained. The node tree is created from the "top" down.
After the first division is made, then the left child is divided, then its
left child, and so on, until a node's child is a ssector. Then you move back
up the tree one branch, and divide the right child, then its left, etc.
ALWAYS left first, on the way down.
	Since there will be splits along the way, there is no way to know
ahead of time how many nodes and ssectors there will be at the end. And the
top of the tree, the node that is created first, is given the highest number.
So as nodes and ssectors are created, they are simply numbered in order from
0 on up, and when it's all done, nothing's left but ssectors, then ALL the
numbers, for nodes and ssectors, are reversed. If there's 485 nodes, then 485
becomes 0 and 0 becomes 485.
	Here is another fabulous drawing which will explain everything. + is
a vertex, - and | indicate linedefs, the . . indicates an extension of a
partition line. The <, >, and ^ symbols indicate the directions of partition
lines. All the space within the drawing is actual level space, i.e. sectors.

      +-----+-------+-------+            0                     (5)
      |     |       |       |         /     \      ==>       /     \
      |  e  |^  f   |^  g   |       1         4           (4)       (1)
      |     |4      |5      |     /   \      / \         /   \      / \
+---- + . . +-------+-------+    2     3    e   5      (3)   (2)   2  (0)
|     |           < 0       |   / \   / \      / \     / \   / \      / \
|  a  |       b             |  a   b c   d    f   g   6   5 4   3    1   0
|     |^                    |
| . . |2. . . . . +---------+ The order in which      How the elements are
|     |           |1 >        the node tree's         numbered when it's
|  c  |^    d     |           elements get made.      finished.
|     |3          |           0 = node, a = ssector   (5) = node, 6 = ssector
+-----+-----------+

	1. Make segs from all the linedefs. There are 5 two-sided lines here.
	2. Pick the vertex at 0 and go west (left). This is the first
	partition line. Note the . . extension line.
	3. Pick the vertex at 1, going east. The backwards extension . . cuts
	the line 3>2>, and the unlabeled left edge line. The left edge was
	one seg, it becomes two. The 3>2> line was two segs, it becomes four.
	New vertices are created at the intersection points to do this.
	4. Pick the (newly created) vertex at 2. Now the REMAINING spaces on
	both sides of the partition line are suitable for ssectors. The left
	one is first, it becomes a, the right b. Note that ssector a has 3
	segs, and ssector b has 5 segs. The . . imaginary lines are NOT segs.
	5. Back up the tree, and take 1's right branch. Pick 3. Once again,
	we can make 2 ssectors, c and d, 3 segs each. Back up the tree to 0.
	6. Pick 4. Now the left side is a ssector, it becomes e. But the
	right side is not, it needs one more node. Pick 5, make f and g.
	7. All done, so reverse all the ordination of the nodes and the
	ssectors. Ssector 0's segs become segs 0-2, ssector 1's segs become
	segs 3-7, etc. The segs are written sequentially according to the
	ssector numbering.

	If we want to create an algorithm to do the nodes automatically, it
needs to be able to pick partition lines automatically. From studying the
original maps, it appears that they usually choose a linedef which divides
the child's space roughly in "half". This is restricted by the availability of
a seg in a good location, with a good angle. Also, the "half" refers to the
total number of ssectors in any particular child, which we have no way of
knowing when we start! Optimization methods are probably used, or maybe brute
force, trying every candidate seg until the "best" one is found.
	What is the best possible choice for a partition line? Well, there
are apparently two goals when creating a BSP tree, which are partially
exclusive. One is to have a balanced tree, i.e. for any node, there are about
the same total number of sub-nodes on either side of it. The other goal is to
minimize the number of "splits" necessary, in this case, the number of seg
splits needed, along with the accompanying new vertexes and extra segs. Only
a very primitive and specially constructed set of linedefs could avoid having
any splits, so they are inevitable. It's just that with some choices of
partition lines, there end up being fewer splits. For example,

+--------------+       If a and b are chosen as partition lines, there will
|              |       be four extra vertices needed, and this shape becomes
+---+      +---+ < A   five ssectors and 16 segs. If A and B are chosen,
    |^    ^|           however, there are no extra vertices, and only three
+---+a    b+---+ < B   ssectors and 12 segs.
|              |
+--------------+

	I've read that for a "small" number of polygons (less than 1000?),
which is what we're dealing with in a doom level, one should definitely try
to minimize splits, and not worry about balancing the tree. I can't say for
sure, but it does appear that the original levels strive for this. Their
trees are not totally unbalanced, but there are some parts where many successive
nodes each have a node and a ssector as children (this is unbalanced). And
there are a lot of examples to prove that the number of extra segs and
vertices they create is very low compared to what it could be. I think the
algorithm that id Software used tried to optimize both, but with fewer splits
being more important.

[4-9]: SECTORS
==============

	A SECTOR is a horizontal (east-west and north-south) area of the map
where a floor height and ceiling height is defined. It can have any shape.
Any change in floor or ceiling height or texture requires a new sector (and
therefore separating linedefs and sidedefs).
	Each is 26 bytes, comprising 2 (integer) fields, then 2 (8-byte
string) fields, then 3 (integer) fields:

(1) Floor is at this height for this sector
(2) Ceiling height
      A difference of 24 between the floor heights of two adjacent sectors
      is passable (upwards), but a difference of 25 is "too high". The player
      may fall any amount.
(3) name of floor texture, from the directory.
(4) name of ceiling texture, from directory.
      All the pictures in the directory between F_START and F_END work as
      either floors or ceilings. F_SKY1 is used as a ceiling to indicate that
      it is transparent to the sky above/behind.
(5) brightness of this sector: 0 = total dark, 255 (ff) = maximum light
(6) special sector: see [4-9-1] immediately below.
(7) is a "trigger" number corresponding to a certain LINEDEF with the same
      trigger number. When that linedef is crossed, something happens to this
      sector - it goes up or down, etc...

[4-9-1]: Special Sector Types
-----------------------------

	These numbers control the way the lighting changes, and whether or
not a player gets hurt while standing in the sector. -10/20% means that the
player takes 20% damage at the end of every second that they are in the
sector, except at skill 1, they take 10% damage. If the player has armor,
then the damage is split between health and armor.
	For all the lighting effects, the brightness levels alternates
between the value given for this sector, and the lowest value amongst all the
sector's neighbors. Neighbor means a linedef has a side in each sector. If no
neighbor sector has a lower light value, then there is no lighting effect.
"blink off" means the light goes to the lower value for just a moment. "blink
on" means the light is usually at the neighbor value, then jumps up to the
normal value for a moment. "oscillate" means that the light level goes
smoothly from one value to the other; it takes about 2 seconds to go from
maximum to minimum and back (255 to 0 to 255).

Dec Hex Condition or effect

0   00  is normal, no special characteristic.
1   01  light blinks off at random times.
2   02  light blinks on every 0.5 second
3   03  light blinks on every 1.0 second
4   04  -10/20% health AND light blinks on every 0.5 second
5   05  -5/10% health
7   07  -2/5% health, this is the usual NUKAGE acid-floor.
8   08  light oscillates
9   09  SECRET: player must move into this sector to get credit for finding
	this secret. Counts toward the ratio at the end of the level.
10  0a  ?, ceiling comes down 30 seconds after level is begun
11  0b  -10/20% health. When player's HEALTH <= 10%, then the level ends. If
	it is a level 8, then the episode ends.
12  0c  light blinks on every 1.0 second
13  0d  light blinks on every 0.5 second
14  0e  ??? Seems to do nothing
16  10  -10/20% health

	All other values cause an error and exit to DOS.

[4-10]: REJECT
==============

	The REJECT resource is optional. Its purpose in the original maps is
to help speed the process of calculating when monsters detect the player(s).
It can also be used for some special effects.
	The size of a REJECT in bytes is (number of SECTORS ^ 2) / 8, rounded
up. It is an array of bits, with each bit controlling whether monsters in a
given sector can detect players in another sector.
	Make a table of sectors vs. sectors, like this:

	 sector that the player is in
	      0  1  2  3  4
	    +---------------
sector    0 | 0  1  0  0  0
that      1 | 1  0  1  1  0
the       2 | 0  1  0  1  0
monster   3 | 0  1  1  1  0
is in     4 | 0  0  1  0  0

	A 1 means the monster cannot become activated by seeing a player, nor
can it attack the player. A 0 means there is no restriction. All non-deaf
monsters still become activated by weapon sounds that they hear (including
the bare fist!). And activated monsters will still pursue the player, but they
will not attack if their current sector vs. sector bit is "1". So a REJECT
that's set to all 1s gives a bunch of pacifist monsters who will follow the
player around and look menacing, but never actually attack.
	How the table turns into the REJECT resource:
	Reading left-to-right, then top-to-bottom, like a page, the first bit
in the table becomes bit 0 of byte 0, the 2nd bit is bit 1 of byte 0, the 9th
bit is bit 0 of byte 1, etc. So if the above table represented a level with
only 5 sectors, its REJECT would be 4 bytes:

10100010 00101001 01000111 xxxxxxx0 (hex A2 29 47 00, decimal 162 41 71 0)

	In other words, the REJECT is a long string of bits which are read
from least significant bit to most significant bit, according to the
multi-byte storage scheme used in a certain "x86" family of CPUs.
	Usually, if a monster in sector A can't detect a player in sector B,
then the reverse is true too, thus if 0/1 is set, 1/0 will be set also. Same
sector prohibitions, e.g. 0/0, 3/3, etc. are very rarely set, only in tiny
sectors that monsters can't get to anyway. If a large sector with monsters
in it has this assignment, they'll exhibit the pacifist syndrome.
	I think the array was designed to help speed the monster-detection
process. If a sector pair is prohibited, the game engine doesn't even bother
checking line-of-sight feasibility for the monster to "see" the player and
thus become active. I suppose it can save some calculations if there are lots
of monsters.
	It is possible to automatically generate some reject pairs, but to
calculate whether or not one sector can "see" another can be very complicated.
You can't judge line-of-sight just by the two dimensions of the map, you also
have to account for the floor and ceiling heights. And to verify that every
point in the 3d volume of one sector is out of sight of every point in the
other sector...whew! The easy way is to just leave them all 0, or have a user
interface which allows them to use their brains to determine which reject
pairs should be set.

[4-11]: BLOCKMAP
================

	The BLOCKMAP is a pre-calculated structure that the game engine uses
to simplify collision-detection between moving things and walls. Below I'll
give a pseudo-code algorithm that will automatically construct a blockmap
from the set of LINEDEFS and their vertices.
	If a level doesn't have a blockmap, it can display fine, but
everybody walks through walls, and no one can hurt anyone else.
	The whole level is cut into "blocks", each is a 128 (hex 80) wide
square (the grid lines in the automap correspond to these blocks).
	All of the blockmap's fields are integers.
	The first two integers are XORIGIN and YORIGIN, which specify the
coordinates of the bottom-left corner of the bottom-left (southwest) block.
These two numbers are usually equal to 8 less than the minimum values of x
and y achieved in any vertex on the level.
	Then come COLUMNS and ROWS, which specify how many "blocks" there are
in the X and Y directions. COLUMNS is the number of blocks in the x
direction.
	For a normal level, the number of blocks must be large enough to contain
every linedef on the level. If there are linedefs outside the blockmap, they
will not be able to prevent monsters or players from crossing them, which can
cause problems, including the hall of mirrors effect.
	Then come (ROWS * COLUMNS) integers which are pointers to the offset
within the blockmap resource for that "block". These "offsets" refer to the
INTEGER number, NOT the byte number, where to find the block's list. The
blocks go right (east) and then up (north). The first block is at row 0,
column 0; the next at row 0, column 1; if there are 34 columns, the 35th
block is row 1, column 0, etc.
	After all the pointers, come the block lists. Each blocklist
describes the numbers of all the LINEDEFS which are partially or wholly "in"
that block. Note that lines and points which seem to be on the "border"
between two blocks are actually only in one. For example, if the origin of
the blockmap is at (0,0), the first column is from 0 to 127 inclusive, the
second column is from 128 to 255 inclusive, etc. So a vertical line with x
coordinate 128 which might seem to be on the border is actually in the
easternmost/rightmost column only. Likewise for the rows - the north/upper
rows contain the border lines.
	An "empty" block's blocklist consists of two integers: 0 and then -1.
A non-empty block will go something like: 0 330 331 333 -1. This means that
linedefs 330, 331, and 333 are "in" that block. Part of each of those line
segments lies within the (hex 80 by 80) boundaries of that block. What about
the block that has linedef 0? It goes: 0 0 ... etc ... -1.
	Here's another way of describing blockmap as a list of the integers,
in order:

	Coordinate of block-grid X origin
	Coordinate of block-grid Y origin
	# of columns (blocks in X direction)
	# of rows (blocks in Y direction)
	Block 0 offset from start of BLOCKMAP, in integers
	  .
	  .
	Block N-1 offset (N = number of columns * number of rows)
	Block 0 list: 0, numbers of every LINEDEF in block 0, -1 (ffff)
	  .
	  .
	Block N-1 list: 0, numbers of every LINEDEF in block N-1, -1 (ffff)

[4-11-1]: How to automatically generate the BLOCKMAP
----------------------------------------------------

	Here is an algorithm that can create a blockmap from the set of
linedefs and their vertices' coordinates. For reasons of space and different
programming tastes, I won't include every little detail here, nor is the
algorithm in any particular language. The pseudocode below is like BASIC or
PASCAL, sort of. I'm not being very formal about variable declarations and
such, since that's such a pain.
	There are basically two ways that the blockmap can be automatically
generated. The slow way is to do every block in order, and check every
linedef to see if part of the linedef is in the block. This method is slow
because it has to perform (number of blocks) * (number of linedefs)
iterations, and in most iterations it will have to do at least one fairly
complicated formula do determine an intersection. With the number of blocks
at 500-2500 for a typical level, and linedefs at 500-1500, this can really
bog down on a big level.
	The better way is to do the linedefs in order, keeping a dynamic list
for every block, and adding the linedef number to the end of the blocklist
for every block it passes through. We won't have to test every block to see if
the line passes through it; in fact, we won't be testing ANY blocks, we'll be
calculating exactly which blocks it goes through based on its coordinates and
slope. This method will have to go through one cycle for each linedef, with
very few calculations needed for most cycles, since most linedefs are in only
one or two blocks.

' Pseudo-code algorithm to generate a BLOCKMAP. The goal is speed. If you
' can top this approach, I'd be surprised.
' Most variables are of type integer, except slope and its pals, see below.
' Some of the ideas here are borrowed from Matt Tagliaferri.
' x_minimum is the minimum x value in the set of vertices, etc.
' the -8 is to make the blockmaps just like the original ones.

  x_origin = -8 + x_minimum
  y_origin = -8 + y_minimum
  Columns = ((x_maximum - x_origin) DIV 128) + 1
  Rows = ((y_maximum - y_origin) DIV 128) + 1

' DIV is whatever function performs integer division, e.g. 15 DIV 4 is 3.

  number_of_blocks = Rows * Columns
  INITIALIZE Block_string(number_of_blocks - 1)
  FOR count = 0 to number_of_blocks DO
    Block_string(count) = STRING(0)
  NEXT count

' STRING is whatever function or typecast will change the integer "int"
' to its two-byte string format. Here we set up an array to hold all the
' blocklists. All blocklists start with the integer 0, and end with -1;
' we'll add the -1s at the end.
' A string array is best, because we need to haphazardly add to the
' blocklists. line 0 might be in blocks 34, 155, and 276, for instance.
' And string's lengths are easily determined, which we'll need at the end.
' To save on memory requirements, the size of each array element can be
' limited to c. 200 bytes = 100 integers, since what is the maximum number
' of linedefs which will be in a single block? Certainly less than 100.

  FOR line = 0 TO Number_Of_Linedefs DO
    x0 = (x coordinate of that linedef's vertex 0) - x_origin
    y0 = (y coordinate of vertex 0) - y_origin
    x1 = (x coordinate of vertex 1) - x_origin
    y1 = (y coordinate of vertex 1) - y_origin

' subtracting the origins shifts the axes and makes calculations simpler.

    blocknum = (y0 DIV 128) * COLUMNS + (x0 DIV 128)
    Block_string(blocknum) = Block_string(blocknum) + STRING(line)

    boolean_column = ((x0 DIV 128)=(x1 DIV 128))
    boolean_row = ((y0 DIV 128)=(y1 DIV 128))

' This is meant to assign boolean values for whether or not the linedef's
' two vertices are in the same column and/or row. I'm assuming that the
' expressions will be evaluated as 1 if "true" and 0 if "false".
' So if both vertices are in the same block, both of these booleans will be
' true and we can go to the next linedef, because it's only in one block.
' If a line is horizontal or vertical, it is easy to calculate exactly which
' blocks it occupies. Since many, if not most, lines are orthogonal and
' short, that is where this algorithm gets most of its speed.

    CASE (boolean_column * 2 + boolean_row):
      CASE 3: NEXT line
      CASE 2: block_step = SIGN(y1-y0) * Columns
	      FOR count = 1 TO ABS((y1 DIV 128) - (y0 DIV 128)) DO
		blocknum = blocknum + block_step
		Block_string(blocknum) = Block_string(blocknum) +
STRING(line)
	      NEXT count
	      NEXT line
      CASE 1: block_step = SIGN(x1-x0)
	      count = 1 TO ABS((x1 DIV 128) - (x0 DIV 128)) DO
		blocknum = blocknum + block_step
		Block_string(blocknum) = Block_string(blocknum) +
STRING(line)
	      NEXT count
	      NEXT line
    END CASE

' now to take care of the longer, diagonal lines...

    y_sign = SIGN(y1-y0)
    x_sign = SIGN(x1-x0)

' Important: the variables "slope", "x_jump", "next_x" and "this_x" need to
' be of type REAL, not integer, to maintain the accuracy. "slope" will not
' be 0 or undefined, these situations were weeded out by CASE 1 and 2 above.
' An alternative was pointed out to me, but I haven't implemented it in this
' algorithm. If you scale these numbers by 1000, then 32 bit integer
' arithmetic will be precise enough, you won't need sloppy and slow real #s.

    slope = (y1-y0)/(x1-x0)
    x_jump = (128/slope) * y_sign
    CASE (y_sign):
      CASE -1: next_x = x0 + ((y0 DIV 128) * 128 - 1 - y0)/slope
      CASE 1: next_x = x0 + ((y0 DIV 128) * 128 + 128 - y0)/slope
    END CASE

' Suppose the linedef heads northeast from its start to its end. We'll
' first calculate all the blocks in the start row, which will all be
' successively to the right of the first block (blocknum). Then we'll move
' up to the next row, set the block, and go right, then the next row, etc.
' until we've passed the second/end vertex. (the three other directions
' NW SE SW are taken care of too, all by proper use of sign)

' x_jump is how far x goes right or left when y goes up/down 128.
' next_x will be the x coordinate of the next intercept with a "critical"
' y value. When the line goes up, the critical values are equal to 128, 256,
' etc, the first y-values in a new block. If the line goes down, then the
' intercepts occur when y equals 255, 127, etc. Remember, all this is in the
' "shifted" coord system.

' INT is whatever function will discard the decimal part of a real number,
' converting it to an integer. It doesn't matter which way it rounds
' negatives, since next_x and this_x are always positive.

    last_block = INT(next_x/128) - (x0 DIV 128) + blocknum
    IF last_block > blocknum THEN
      FOR count = (blocknum + x_sign) TO last_block STEP x_sign DO
	Block_string(count) = Block_string(count) + STRING(line)
      NEXT count

    REPEAT
      this_x = next_x

      next_x = this_x + x_jump
      IF (x_sign * next_x) > (x_sign * x1) THEN next_x = x1
      first_block = last_block + y_sign * Columns
      last_block = first_block + INT(next_x/128) - INT(this_x/128)
      FOR count = first_block TO last_block STEP x_sign DO
	Block_string(count) = Block_string(count) + STRING(line)
      NEXT count
    UNTIL INT(next_x) = x1


  NEXT line

' That's it. Now all we have to do is write the BLOCKMAP to wherever.

  WRITE Blockmap, AT OFFSET 0, x_origin
  WRITE Blockmap, AT OFFSET 2, y_origin
  WRITE Blockmap, AT OFFSET 4, Columns
  WRITE Blockmap, AT OFFSET 6, Rows

  pointer_offset = 8
  blocklist_offset = 8 + 2 * number_of_blocks
  FOR count = 0 TO number_of_blocks - 1 DO
     WRITE Blockmap, AT OFFSET pointer_offset, blocklist_offset / 2
     WRITE Blockmap, AT OFFSET blocklist_offset, Block_string(count)
     blocklist_offset = blocklist_offset + LENGTH(Block_string(count)) + 2
     WRITE Blockmap, AT OFFSET (blocklist_offset - 2), STRING(-1)
     pointer_offset = pointer_offset + 2
  NEXT count

' Done! blocklist_offset will equal the total size of the BLOCKMAP, when
' this last loop is finished


*******************************************************************************


----------------------------
CHAPTER [5]: Pictures' Format
-----------------------------

	The great majority of the entries if the directory reference
resources that are in a special picture format. The same format is used for
the sprites (monsters, items), the wall patches, and various miscellaneous
pictures for the status bar, menu text, inter-level map, etc. The floor and
ceiling textures are NOT in this format, they are raw data; see chapter [6].
	After much experimenting, it seems that sprites and floors cannot be
added or replaced via pwad files. However, wall patches can (whew!). This is
apparently because all the sprites' entries must be in one "lump", in the
IWAD file, between the S_START and S_END entries. And all the floors have to
be listed between F_START and F_END. If you use those entries in pwads,
either nothing will happen, or an error will occur. There are also P_START
and P_END entries in the directory, which flank the wall patch names, so how
come they work in pwads? I think it is somehow because of the PNAMES
resource, which lists all the wall patch names that are to be used. Too bad
there aren't SNAMES and FNAMES resources!
	It is still possible to change and manipulate the sprites and floors,
its just more difficult to do, and very difficult to figure out a scheme for
potential distribution of changes. The DOOM.WAD file must be changed, and
that is a pain.
	All the sprites follow a naming scheme. The first four letters are
the sprite's name, or and abbreviation. TROO is for imps, BKEY is for the
blue key, etc. See [4-2-1] for a list of them.
	For most things, the unanimated ones, the next two characters of the
sprite's name are A0, like SUITA0, the radiation suit. For simple animated
things, there will be a few more sprites, e.g. PINVA0, PINVB0, PINVC0, and
PINVD0 are the four sprites for the Invulnerability power-up. Monsters are
the most complicated. They have several different sequences, for walking,
firing, dying, etc, and they have different sprites for different angles.
PLAYA1, PLAYA2A8, PLAYA3A7, PLAYA4A6, and PLAYA5 are all for the first frame
of the sequence used to display a walking (or running) player. 1 is the view
from the front, 2 and 8 mean from front-right and front-left (the same sprite
is used, and mirrored appropriately), 3 and 7 the side, 5 the back.
	Each picture has three sections, basically. First, a four-integer
header. Then a number of long-integer pointers. Then the picture pixel color
data.

[5-1]: Header
=============

	The header has four fields:

(1) Width. The number of columns of picture data.
(2) Height. The number of rows.
(3) Left offset. The number of pixels to the left of the center; where the
      first column gets drawn.
(4) Top offset. The number of pixels above the origin; where the top row is.

	The width and height define a rectangular space or limits for drawing
a picture within. To be "centered", (3) is usually about half of the total
width. If the picture had 30 columns, and (3) was 10, then it would be
off-center to the right, especially when the player is standing right in
front of it, looking at it. If a picture has 30 rows, and (4) is 60, it will
appear to "float" like a blue soul-sphere. If (4) equals the number of rows,
it will appear to rest on the ground. If (4) is less than that for an object,
the bottom part of the picture looks awkward.
	With walls patches, (3) is always (columns/2)-1, and (4) is always
(rows)-5. This is because the walls are drawn consistently within their own
space (There are two integers in each SIDEDEF which can offset the beginning
of a wall's texture).
	Finally, if (3) and (4) are NEGATIVE integers, then they are the
absolute coordinates from the top-left corner of the screen, to begin drawing
the picture, assuming the VIEW is FULL-SCREEN (the full 320x200). This is
only done with the picture of the doom player's current weapon - fist,
chainsaw, bfg9000, etc. The game engine scales the picture down appropriately
if the view is less than full-screen.

[5-2]: Pointers
===============

	After the header, there are N = (# of columns) long integers (4 bytes
each). These are pointers to the data for each COLUMN. The value of the
pointer represents the offset in bytes from the first byte of the picture
resource.

[5-3]: Pixel Data
=================

	Each column is composed of some number of BYTES (NOT integers),
arranged in "posts":
	The first byte is the row to begin drawing this post at. 0 means
whatever height the header (4) upwards-offset describes, larger numbers move
correspondingly down.
	The second byte is how many colored pixels (non-transparent) to draw,
going downwards.
	Then follow (# of pixels) + 2 bytes, which define what color each
pixel is, using the game palette. The first and last bytes AREN'T drawn, and
I don't know why they are there. Probably just leftovers from the creation
process on the NExT machines. Only the middle (# of pixels in this post) are
drawn, starting at the row specified in byte 1 of the post.
	After the last byte of a post, either the column ends, or there is
another post, which will start as stated above.
	255 (hex FF) ends the column, so a column that starts this way is a
null column, all "transparent". Goes to the next column.
	Thus, transparent areas can be defined for either items or walls.


*******************************************************************************


---------------------------------------
CHAPTER [6]: Floor and Ceiling Textures
---------------------------------------

	All the names for these textures are in the directory between the
F_START and F_END entries. There is no look-up or meta-structure as with the
walls. Each texture is 4096 raw bytes, making a square 64 by 64 pixels, which
is pasted onto a floor or ceiling, with the same orientation as the automap
would imply, i.e. the first byte is the color at the NW corner, etc. The
blocks in the grid are 128 by 128, so four floor tiles will fit in each
block.
	The data in F_SKY1 isn't even used since the game engine interprets
that special ceiling as see-through to the SKY texture beyond. So the F_SKY1
entry can have zero length.
	As discussed in chapter [5], replacement and/or new-name floors don't
work right from pwad files, only in the main IWAD.
	You can change all the floors and ceilings you want by constructing a
new DOOM.WAD, but you have to make sure no floor or ceiling uses an entry
name which isn't in your F_ section. And you have to include these four entries,
although you can change their contents (pictures): FLOOR4_8, SFLR6_1,
MFLR8_4, and FLOOR7_2. The first three are needed as backgrounds for the
episode end texts. The last is what is displayed "outside" the display window
if the display is not full-screen.

[6-1]: Animated floors
----------------------

	See Chapter [8-4-1] for a discussion of how the animated walls and
floors work. Unfortunately, the fact that the floors all need to be lumped
together in one wad file means that its not possible to change the animations
via a pwad file, unless it contains ALL the floors, which amounts to several
hundred k. Plus you can't distribute the original data, so if you want to
pass your modification around, it must either have all the floors all-new,
or you must create some sort of program which will construct the wad from
the original DOOM.WAD plus your additions.


*******************************************************************************


-----------------------------
CHAPTER [7]: Sounds and Songs
-----------------------------

[7-1]: D_[xxxxxx]
=================

	Songs.  What format are they? Apparently the MUS format, which I have
absolutely no knowledge of. But it's obvious what each song is for, from
their names.

[7-2]: DP[xxxxxx] and DS[xxxxxx]
================================

	These are the sound effects. They come in pairs - DP for pc speaker
sounds, DS for sound cards.
	The DS sounds are in RAW format: they have a four integer header,
then the sound samples (each is 1 byte since they are 8-bit samples).
	The headers' four (unsigned) integers are: 3, then 11025 (the sample
rate), then the number of samples, then 0. Since the maximum number of
samples is 65535, that means a little less than 6 seconds is the longest
possible sound effect.


*******************************************************************************


-------------------------------------------------
CHAPTER [8]: Some Important Non-picture Resources
-------------------------------------------------

[8-1]: PLAYPAL
==============

	There are 14 palettes here, each is 768 bytes = 256 rgb triples. That
is, the first three bytes of a palette are the red, green, and blue portions
of color 0. And so on.
	Note that standard VGA boards whose palettes only encompass 262,144
colors only accept values of 0-63 for each channel (rgb), so the values would
need to be divided by 4.
	Palette 0 is the one that is used for almost everything.
	Palettes 10-12 are used (briefly) when an item is picked up, the more
items that are picked up in quick succession, the brighter it gets, palette
12 being the brightest.
	Palette 13 is used while wearing a radiation suit.
	Palettes 3, 2, then 0 again are used after getting berserk strength.
	If the player is hurt, then the palette shifts up to X, then comes
"down" one every half second or so, to palette 2, then palette 0 (normal)
again. What X is depends on how badly the player got hurt: Over 100% damage
(add health loss and armor loss), X=8. 93%, X=7. 81%, X=6. 55%, X=5. 35%,
X=4. 16%, X=2.

[8-2]: COLORMAP
===============

	This contains 34 sets of 256 bytes, which "map" the colors "down" in
brightness. Brightness varies from sector to sector. At very low brightness,
almost all the colors are mapped to black, the darkest gray, etc. At the
highest brightness levels, most colors are mapped to their own values,
i.e. they don't change.
	In each set of 256 bytes, byte 0 will have the number of the palette
color to which original color 0 gets mapped.
	The colormaps are numbered 0-33. Colormaps 0-31 are for the different
brightness levels, 0 being the brightest (light level 248-255), 31 being the
darkest (light level 0-7).
	Colormap 32 is used for every pixel in the display window (but not
the status bar), regardless of sector brightness, when the player is under the
effect of the "Invulnerability" power-up. This map is all whites/greys.
	Colormap 33 is all black for some reason.

[8-3]: DEMO[1-3]
================

	These are the demos that will be shown if you start doom, and do
nothing else. Demos can be created using the devparm parameter:

DOOM -devparm -record DEMONAME

	The extension .LMP is automatically added to the DEMONAME. Other
parameters may be used simultaneously, such as -skill [1-5], -warp [1-3]
[1-9], -file [pwad_filename], etc. The demos in the WAD are in exactly the
same format as these LMP files, so a LMP file may be simply pasted or
assembled into a WAD, and if its length and pointer directory entries are
correct, it will work.
	This is assuming the same version of the game, however. For some
illogical reason, demos made with 1.1 doom don't work in 1.2 doom, and vice
versa. If I had a pressing need to convert an old demo, I might try to
figure out why, but I don't.
	The game only accesses DEMO1, DEMO2, and DEMO3, so having more than
that in a pwad file is pointless.

[8-4]: TEXTURE1 and TEXTURE2
============================

	These resources contains a list of the wall names used in the various
SIDEDEFS sections of the level data. Each wall name actually references a
meta-structure, defined in this list. TEXTURE2 has all the walls that are
only in the registered version.
	First is a table of pointers to the start of the entries. There is a
long integer (say, N) which is the number of entries in the TEXTURE resource.
Then follow N long integers which are the offsets in bytes from the beginning
of the TEXTURE resource to the start of that texture's definition entry.
	Then follow N texture entries, which each consist of a 8-byte name
field and then a variable number of 2-byte integer fields:

(1) The name of the texture, used in SIDEDEFS, e.g. "STARTAN3".
(2) always 0.
(3) always 0.
(4) total width of texture
(5) total height of texture

	The fourth and fifth fields define a "space" (usually 128 by 128 or
64 by 72 or etc...) in which individual wall patches are placed to form the
overall picture. This is done because there are some wall patches that are
used in several different walls, like computer screens, etc. Note that to
tile properly in the vertical direction on a very tall wall, a texture has to
have height 128, the maximum. The maximum width is 256. The sum of the sizes
of all the wall patches used in a single texture must be <= 64k.

(6) always 0.
(7) always 0.
(8) Number of 5-field patch descriptors that follow. This is why each texture
    entry has variable length. Many entries have just 1 patch, one has 64!

	1. x offset from top-left corner of texture space defined in field
	   4/5 to start placement of this patch
	2. y offset
	3. number, from 0 to whatever, of the entry in the PNAMES resource,
	   which contains the name from the directory, of the wall patch to
	   use...
	4. always 1, is for something called "stepdir"...
	5. always 0, is for "colormap"...

	The texture's entry ends after the last of its patch descriptors.
	Note that patches can have transparent parts, since they are in the
same picture format as everything else. Thus there can be (and are)
transparent wall textures. These should only be used on a border between two
sectors, to avoid the "displaying nothing" problems.
	Here is how one can add walls, while still retaining any of the
original ones it came with: in a pwad, have replacement entries for PNAMES
and TEXTURE2. These will be the same as the originals, but with more entries,
for the wall patches and assembled textures that you're adding. Then have
entries for every new name in PNAMES, as well as old names which you want to
associate to new pictures. You don't need to use the P_START and P_END
entries.

[8-4-1]: Animated walls
-----------------------

	It is possible to change the walls and floors that are animated, like
the green blocks with a sewer-like grate that's spewing green slime
(SLADRIPx). The game engine sets up as many as 8 animation cycles for walls
based on the entries in the TEXTURE resources, and up to 5 based on what's
between F_START and F_END. The entries in FirstTexture and LastTexture,
below, and all the entries between them (in the order that they occur in a
TEXTURE list), are linked. If one of them is called by a sidedef, that sidedef
will change texture to the next in the cycle about 5 times a second , going back
to First after Last. Note that the entries between First and Last need not
be the same in number as in the original, nor do they have to follow the same
naming pattern, though that would probably be wise. E.g. one could set up
ROCKRED1, ROCKREDA, ROCKREDB, ROCKREDC, ROCKREDD, ROCKREDE, ROCKRED3 for
a 7-frame animated wall!
	If First and Last aren't in either TEXTURE, no problem. Then that
cycle isn't used. But if First is, and Last either isn't or is listed
BEFORE First, then an error occurs.

FirstTexture    LastTexture     Normal # of frames

BLODGR1         BLODGR4         4
BLODRIP1        BLODRIP4        4
FIREBLU1        FIREBLU2        2
FIRELAV3        FIRELAVA        2
FIREMAG1        FIREMAG3        3
FIREWALA        FIREWALL        3
GSTFONT1        GSTFONT3        3
ROCKRED1        ROCKRED3        3
SLADRIP1        SLADRIP3        3


(floor/ceiling animations) -

NUKAGE1         NUKAGE3         3
FWATER1         FWATER3         3
SWATER1         SWATER4         4
LAVA1           LAVA4           4
BLOOD1          BLOOD3          3

	Note that the SWATER entries aren't in the regular DOOM.WAD.

[8-5]: PNAMES
=============

	This is a lookup table for the numbers in TEXTURE[1 or 2] to
reference to an actual entry in the directory which is a wall patch (in the
picture format described in chapter [5]).
	The first two bytes of the PNAMES resource is an integer P which is
how many entries there are in the list.
	Then come P 8-byte names, each of which duplicates an entry in the
directory. If a patch name can't be found in the directory (including the
external pwad's directories), an error will occur. This naming of resources
is apparently not case-sensitive, lowercase letters will match uppercase.
	The middle integer of each 5-integer "set" of a TEXTURE1 entry is
something from 0 to whatever. Number 0 means the first entry in this PNAMES
list, 1 is the second, etc...

	Thanks for reading the "Official" DOOM Specs!



*******************************************************************************
*  9. Datei DoomTechniques.txt												  *
*******************************************************************************




			 Doom 3D Engine Techniques
		      By Brian 'Neuromancer' Marshall
		    (Email: brianm@vissci.demon.co.uk)

	This document is submitted subject to certain conditions:

1. This Document is not in any way related to Id Software, and is 
   not meant to be representive of their techniques : it is based
   upon my own investigations of a realtime 3d engine that produces
   a screen display similar to 'Doom' by Id software.

2. I take no responsibility for any damange to data or computer equipment
   caused by attempts to implement these algorithms.

3. Although I have made every attempt to ensure that this document is error
   free i take no responsability for any errors it may contain.

4. Anyone is free to use this information as they wish, however I would
   appreciate being credited if the information has been useful.

5. I take no responsability for the spelling or grammar.
   (My written english is none too good...so I won't take offence
    at any corrections: I am a programmer not a writer...)

	Right now that that little lot is out of the way I will start this
document proper....

1:  Definition of Terms
======================

	Throughout this document I will be making use of many graphical terms
using my understanding of them as they apply to this algorithm. I will
explain all the terms below. Feel free to skip this part....

Texture:
	A texture for the purpose of this is a square image.

U and V:
	U and V are the equivelants of x and y but are in texture space.
ie They are the the two axies of the two dimensional texture.

Screen:
	For my purposes 'screen' is the window we wish to fill: it doesn't
have to be the whole screen.

Affine Mapping:
	A affine mapping is a texture map where the texture is sampled
in a linear fashion in both U and V.

Biquadratic Mapping:
	A biquadratic mapping is a mapping where the texture is sampled
along a curve in both U and V that approximates the perspective transform.
This gives almost proper forshortening.


Projective Mapping:
	A projective mapping is a mapping where a changing homogenous
coordinated is added to the texture coordinateds to give (U,V,W) and
a division is performed at every pixel. This is the mathematically and
visual correct for of texture mapping for the square to quadrilateral
mappings we are using.
	(As an aside it is possible to do a projective mapping without
the divide (or 3 multiplies) but that is totally unrelated to the matter
in hand...)

Ray Casting:
	Ray Casting in this context is back-firing 'rays' along a two
dinesional map. The rays do however follow heights... more on that later

Sprite:
	A Sprite is a bitmap that is either a monster or an object. To
put it another way it is anything that is not made out of wall or
floor sectins.

Sprite Scaling:
	By this I mean scaling a bitmap in either x or y or both.

Right... Now thats over with onto the foundation:

2:   Two Dimensional Ray Casting Techniques
===========================================

	In order to make this accessible to anyone I will start by
explaining 2d raycasting as used in Wolfenstein 3d style games.

  2.1: Wolfenstien 3D Style Techniques...
  =======================================

	  Wolfenstein 3d was a game that rocked the world (well me anyway!).
  It used a technique where you fire a ray accross a 2d grid based map to
  find all its walls and objects. The walls were then drawn vertically
  using sprite scaling techniques to simulate texture mapping.

	  The tracing accross the map looked something like this;


	=============================================
	=   =   =   =   =   =  /=   =   =   =   =   =
	=   =   =   =   =   = / =   =   =   =   =   =
	=   =   =   =   =   =/  =   =   =   =   =   =
	====================/========================
	=   =   =   =   =  /=   =   =   =   =   =   =
	=   =   =   =   = / =   =   =   =   =   =   =
	=   =   =   =   =/  =   =   =   =   =   =   =
	================/============================
	=   =   =   =  /#   =   =   =   =   =   =   =
	=   =   =   = / #   =   =   =   =   =   =   =
	=   =   =   =/  #   =   =   =   =   =   =   =
	============/===#########====================
	=   =   =  /=   =   =   #   =   =   =   =   =
	=   =   = / =   =   =   #   =   =   =   =   =
	=   =   =/  =   =   =   #   =   =   =   =   =
	========/===============#====================
	=   =  /=   =   =   =   #   =   =   =   =   =
	=   = P =   =   =   =   #   =   =   =   =   =
	=   =  \=   =   =   =   #   =   =   =   =   =
	========\===============#====================
	=   =   =\  =   =   =   #   =   =   =   =   =
	=   =   = \ =   =   =   #   =   =   =   =   =
	=   =   =  \=   =   =   #   =   =   =   =   =
	============\=======#####====================
	=   =   =   =\  =   #   =   =   =   =   =   =
	=   =   =   = \ =   #   =   =   =   =   =   =
	=   =   =   =  \=   #   =   =   =   =   =   =
	================\===#========================
	=   =   =   =   =\  #   =   =   =   =   =   =
	=   =   =   =   = \ #   =   =   =   =   =   =
	=   =   =   =   =  \#   =   =   =   =   =   =
	=============================================

	(#'s are walls, = is the grid....)

	This is just a case of firing a ray for each vertical
  line on the screen. This ray is traced accross the map to
  see where it crosses a grid boundry. Where it crosses a
  boundry you cjeck to see if there is a wall there we see how
  far away it it and draw a scaled vertical line from the texture
  on screen. The line we draw is selected from the texture by
  seeing where the line has intersected on the side of the square it
  hit.
	This is repeated with a ray for each vertical line on the
  screen that we wish to display.
	This is a very quick explaination of how it works missing
  out how the sprites are handled. If you want a more detailed 
  explaination then I suggest getting acksrc.zip from
  ftp.funet.fi in /pub/msdos/games/programming

	This is someone's source for a Wolfenstien engine written
  in Borland C and Assembly language on the Pc.
	Its is not the fastest or best but has good documentation
  and solves similiar sprite probelms, distance probelms and has
  some much better explaination of the tracing technique tahn I have
  put here. I recommend to everyone interested taht you get a copy
  and have a thorough play around with it.
  (Even if you don't have a Pc: Everything but the drawing and video
   mode setting is done in 'C' so it should not be too hard to port
   ....)

 
  2.2 Ray Casting in the Doom Environment
  =======================================

	When you look at a screen from Doom you see floors, steps
  walls and lots of other trappings.
	You look out of windows and accross courtyards and you
  say WOW! what a great 3d game!!
	Then you fire your gun a baddie who's in line with you but
  above you and bang! he's a corpse.
	Then you climb up to the level where the corpse is and look
  out the window to where you were and you say Gosh! a 3d game!!

	Hmmm....

	Stop gawping at the graphics for a minute and look at the map
  screen. Nice line vectors. But isn't the map a bit simple???
	Notice how depite colours showing you that there are different
  heights. Then notice that despite the fact that there is NEVER a
  place where you can exist on two different levels. Smelling a little
  2d yet???
  	Look where there are bridges (or sort of bridges) : managed to
  see under them yet??

  	The whole point to this is that Doom is a 2D games just like
  its ancestor Wolfenstein but it has rather more advanced raycasting
  which does a very nice job of fooling the player into thinking its a
  3d game that shifting loads of polygons and back-culling, depth
  sorting etc... 

	Right the explaination of how you turn a 2d map into the 3d
  doom screen is complex so if you are having difficulty try reading
  it a few times and if all else fails mail me....


  2.3 What is actually done!
  ==========================

  	Right to start with the raycasting is started in the same
  way as Wolfenstien. That is find out where the player is in the 2d
  map and get a ray setup for the first vertical line on the screen.

	Now we have an extra stage from the Wolfenstein I described
  whcih involves a data srtucture that we will use later to actually
  draw the screen.

	In this data structure we start the ray off as at the bottom
  of the screen. This is shown in the diagram below;

	=================================
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=*				=
	=================================


	Where the '=' show the boundry of the screen and '*' is the virtual
  position of the ray.

	Note: the Data structure is really two structures:
	One which is a set of list for each vertical 'scanline' and
	One which is a corresponding list for horizontal scanlines.

  	Now we start tracing the ray. We skip accross the 2d map until
  we hit something interesting. By something interesting I mean something
  that is an actual wall or florr section edge.
	Right we have hit the edge of either a floor or wall section.
  We have several things to do know. These are;

	If it was a wall we hit:

  1: Find out how 'high' of screen this section of wall should be
     due to the distance it is accross the 2d map.
  2: Find out at what 'virtual height' it is: This is so that we can see
     where in the vertical scanline in comes for testing where to insert
     it and for clipping it.
  3: Test in our structure to see if you draw it or not.
     (This is done so that you can look through windows : how this works
      will become apparent later.)
  4: If any of the wall segment is visible then we find out where along
     the texture we have hit it and write into the structure the area of
     the screen it takes up as well as the texture, the point where we
     have hit the texture and the size it should be on screen. (This is
     so that we can draw it correctly even if the whole span is not on
     screen.


	If it was a floor section that we hit:

  1: Find out where on the vertical line we are working the floor section
     that the ray has hit is. (We know the height of the the floor in the
     virtual map (2d) and we know the height of the player and the distance
     of the floor square from the player so it is easy).
     As a side effect of this we now know the U,V value where the ray has
     hit the floor square.

  2: Trace Accross the floor square till we hit the far edge of the floor
     square : we then workout where this is on the vertical scanline using
     the same technique as above. We now know the vertical span of the
     floor section, and where on the span it is.

  3: We check to see if the span is visible on the vertical span.
     If it is or part of it is used then we mark that part of the vertical
     scanline as used.
     We also have to make use of the horizontal buffer I mentioned. We
     insert into this in 2 places. The first is the x coordinate of where
     we hit the floor square into the y line where we where on the screen.
     Phew got that bit?? We also insert here the U,V value which we knew 
     from the tracing. (I told you we'd need it later...)


	As you can see there's a little more to hiting a floor segment than
a wall segment. Also note that a you exit a floor segment you may also hit
a wall segment.

	Tracing the individual ray is continued until we hit a special kind
of wall. This wall is marked as a wall that connects to the ceiling.
This is one place to stop tracing this ray. However we can stop tracing early
if we have found enough to fill the whole vertical scanline then we can stop
whenevr we have done this.

	Next come a trick. I said we were tracing along a 2d map. Well I
lied a bit. There are (In my implementation at least..) TWO 2d maps. One is
basically from the floor along including all the 'floor' walls and everything
up to and including the walls that join onto the ceiling. The other map
is basically the ceiling (with anything coming down from the ceiling on it
if you are doing this: this makes life a little more complex as I'll explain
below..)
	Now when we have traced along the bottom map and hit a wall that 
connects to the ceiling then we go back and trace along the ceiling from
the start to fill in the gaps. There is a problem with this however.
The problem is when you have things like a monolith or something else built
out of walls jutting down from the ceiling. you have to decide whether to
draw it or draw whatever was already in the scanline structure. This means
either storing extra information in the buffer ie z coordinates or tracing
along both the ceiling and floor at the same time.... for most people I would
suggest just not having anything jutting down from the ceiling.
	Also you could trace backwards instead of starting a new ray. This 
would be fasterfor many cases as you wouldn't be tracing through lots
of floor squares that aren't on screen. By tracing backwards you can keep
going up the vertical scanline and you know that you are on the screen. As
soon as something goes off the top of the screen you can handle that and then
stop tracing.

	Phew. has everyone got that???

	Now we just go back and fire rays up the rest of the vertical
scanlines. Easy!!???

	At the end of this lot we have the necessary data in the two buffers
to go back and draw the screen background.
(There is one more thing done while tracing but I'll explain that later...)


	Oh... one other thing... you have may want to change the raycasting
a bit to subdivide the map... it helps with speed.
	And don't forget the added complexity that walls aren't all at
90 degrees to each other...

3: Drawing the walls and Why it works!!
=======================================

	If you are familiar with Wolfenstein then please still read this
as it is esential background to understanding the floor routine.


	As all of you probably know the walls are drawn by scaling the line
of the texture to the correct size for the screen. The information in the
vertical buffer makes this easy. What you probably don't know is why this
creates texture mapping that is good enough to fool us.

	The wall function is a Affine texture mapping. (well almost)
Now affine texture mappings look abysmal unless you do quite a lot of
subdivision (The amount needed varies according to the angle the projected
square is at.). So why does the Doom technique work??

	Well when we traced the rays we found out exactly where along the
side of the square we hit we were in relation to the width of the texture.
This means that the top and bottom pixels of the scaled wall piece are
calculated correctly. This means that we have effecively subdivided the
texture along vertical scanlines and as the effective subdidvisons are
calculated exactly with proper forshortening as a result of the tracing.
So the ray casting has made the texture mapping easy for us.
	(We have enough subdivision by this scanline effect as the wall
only rotates about one axis and we have proper foreshortening.)

	This knowlege helps us understand how to do the floors and why
that works.

	We can now draw all the wall segments by just looking at the buffer
and drawing the parts marked as walls.(Skiping where we put in the bits used
by the floor/ceiling bits: we draw them later.)

4:  Drawing the Floor/Ceiling and why it works!
===============================================

	If you have grasped why the walls work then you have just about
won for the floors.
	We have the information needed to draw the floors from the horizontal
buffer.
	All we have to do is look at the horizontal spans in the buffer
and draw them in all.
	Each of these spans has 2 end coordinates for which we have
exact texture coorinates. This tells us which line across the texture
we have to step along to do an Affine or linear mapping.
	This is shown below;


	=================================
	=				=
	=				=
	=				=
	=				= U1,V1 (exit)
	=			       **
	=			    ***	=
	=			 ***	=
	=		      ***    	=
	=		   ***		=
	=		***		=
	=	     ***      		=
	=	  ***			=
	=	**			=
	=     **			=
	=   **				=
	= **				=
  U0,V0	**				=
(entry)	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=				=
	=================================

(apologies for the wonky line: it should be straight!!)

	Now...as the end coordinates are correct and the axis along
which forshortening takes place is not involved (this is a fudge)
we can step linearly along this line across the texture to approximate
the mapping. (This is far easier than a proper texture map).
	This is effectivly a wall lying on its side which works as the
texture coordinates at the ends of the span have been calculated correctly.
This is a benefit of the raycasting we used to find everything.
	Easy huh??


5: Sprites
==========

	The Sprites are really quite easy to do. The basic technique is the
same as used in Wolfenstein 3d.
	This is done as follows:

When you enter a 'square' on the floor map you test to see if there are
any sprites in the square. If there are you flag that sprite as visible
and add it to a list of visible sprites.

When you have finished tracing and drawing the walls and floor you
depth sort the sprites and draw them from the back to the front. (painters
algorithm). The only complication in drawing them is that you have to check 
buffer that has the walls in, in order to clip the sprites correctly.

	(If you're interested in Doom you can occasionally see large 
explosions (ie BFG) slip partially behind a wall segment.)

	On possibly faster way of handling the sprites would be to mark
them like wall segments as you find them in the buffer. The only (ONLY!)
complication to this approach is that sprites can have holes in them. By
this I mean things like the gap between an arm and a leg which should be 
the background colour.


6: Lighting and Depth Cueing
============================

	Lighting and Depth Cueing fits nicely in with the way that we have
prepared the screen ready for drawing.
	All we have to do is see how far away we are when we found either
the floor or wall section and set the light level according to the distance.
	The other thing that is applied is a light level. This is taken from
the map at the edges where you have hit something. As the map is 2D it is
easy to manage lighting, flickering etc.
	For things like pools of light on the floor all you have to do
is subdivide that patch of floor so that you can set the bit under the 
skylight to a lighter colour. Its also very easy to frig this for the
lighting goggles.


7: Controlling the Baddies
==========================
	

	This is pretty easy: all you have to think about is moving and
reacting on a 2d map. the only complications are things like the monsters
looking through windows and seeing a player but this all degenerates into
a simple 2d problem. Things like deciding whether the player has been hit or
has he/she hit a monster is just another case of firing a ray. (Or do it
another way...)


8: Where next???
================

	Thats all folks... hopefully a useful and intersting insight into
my Doom engine works.
	As to the question where next... well I already have some enhancements
to my Doom enigine and others are in the works...

Some of what you may eventually see are:

	Proper lighting (I have done this already...its easier than you
			think)
	Non-Vertical walls (i.e. Aliens style corridors...)
	Orgranic Walls (i.e. Curved like the Aliens nest...)
	Fractal Landscapes (This one is still very much a theory but how
			about being able to go outside and walk up and down
			hills etc??)

	If there are bits people are really shaky about I may post a new
version of this... but I cannot get into implimentation issues as all
implementation work is under copyright...

	By the way if anyone out there implements this I'd love to here
how you get on...

	Anyone got any comments or any other interesting algorithms???



*******************************************************************************
*  10. Datei FIRE.txt														  *
*******************************************************************************

		  How to code youre own "Fire" Routines        

    Hopefully this information file will give you all the information you
    need to code youre own fire routines, seen in many demo's and also to
    actually take it all further and develop youre own effects..

    Ok, so lets get on....

    Setting up


    first thing we need to do is set up two arrays, the size of the arrays
    depends on the many things, screen mode, speed of computer etc, its not
    really important, just that they should both be the same size... I'll
    use 320x200 (64000 byte) arrays for this text, because that happens to
    be the size needed for using a whole screen in vga mode 13h.

    The next thing we need to do is set a gradient palette, this can be
    smoothly gradiated through ANY colours, but for the purpose of this
    text lets assume the maximum value is a white/yellow and the bottom
    value is black, and it grades through red in the middle.

    Ok, we have two arrays, lets call them startbuffer and screenbuffer, so
    we know whats going on. Firstly, we need to setup an initial value for
    the start buffer...  so what we need is a random function, that returns
    a value between 0 and 199 (because our screen is 200 bytes wide) this
    will give us the initial values for our random "hotspots" so we do this
    as many times as we think is needed, and set all our bottom line values
    of the start buffer to the maximum colour value. (so we have the last
    300 bytes of the start buffer set randomly with our maximum colour,
    usually if we use a full palette this would be 255 but it can be
    anything that is within our palette range.)

    Ok, thats set the bottom line up.. so now we need to add the effect,
    for this we need to copy the start buffer, modify it and save it to the
    screenbuffer, we do this by averaging the pixels (this is in effect
    what each byte in our array represents) surrounding our target....

    It helps to think of these operations in X,Y co-ordinates....

    Lets try a little diagram for a single pixel.....

    This is the startbuffer             This is our screenbuffer

    ÚÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄ¿               ÚÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄ¿
    ³0,0³0,1³0,2³0,3³0,4³ etc...        ³   ³   ³   ³   ³   ³
    ÃÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄ´               ÃÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄ´
    ³1,0³1,1³1,2³1,3³1,4³ etc..         ³   ³X,Y³   ³   ³   ³
    ÃÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄ´               ÃÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄÅÄÄÄ´
    ³2,0³2,1³2,2³2,3³2,4³ etc..         ³   ³   ³   ³   ³   ³
    ÀÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÙ               ÀÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÙ

    Here we're going to calulate the value for X,Y (notice I didnt start at
    0,0 for calculating our new pixel values?? thats because we need to
    average the 8 surrounding pixels to get out new value.. and the pixels
    around the edges wouldn't have 8 pixels surrounding them), so what we
    need to do to get the value for X,Y is to average the values for all
    the surrounding pixels... that means adding 0,0 0,1 0,2 + 1,0 1,2 + 2,0
    2,1 2,2 and then dividing the total by 8 (the number of pixels we've
    takes our averages from), but there's two problems still facing us..

    1) The fire stays on the bottom line....
    2) Its slow....
    3) The fire colours dont fade...

    Ok, so first thing, we need to get the fire moving! :) this is really
    VERY easy. All we need to do is to take our average values from the
    pixel value BELOW the pixel we are calculating for, this in effect,
    moves the lines of the new array up one pixel... so for example our old
    X,Y value we were calculating for was 1,1 so now we just calculate for
    2,1 and put the calculated value in the pixel at 1,1 instead.. easy..

    The second problem can be approached in a few ways.. first and easiest
    is to actually calculate less pixels in our averaging.. so instead of
    the 8 surrounding pixels we calculate for example, 2 pixels, the one
    above and the one below our target pixel (and divide by 2 instead of 8)
    this saves a lot of time, another approach is to use a screen mode,
    where you can set 4 pixels at a time, or set up the screen so that you
    can use smaller arrays (jare's original used something like 80X50 mode)
    which in effect reduces to 1/4 the number of pixels needed to be
    calculated.

    The third problem is just a matter of decrementing the calculated value
    that we get after averaging by 1 (or whatever) and storing that value.

    Last but not least, we need to think about what else can be done...
    well, you can try setting a different palette, you can also try setting
    the pixel value we calculated from to another place, so say, instead of
    calculating from one pixel below our target pixel, you use one pixel
    below and 3 to the right of our target... FUN! :))

    Well, I hope I didnt confuse you all too much, if you need anything
    clearing up about this, then email me at pc@espr.demon.co.uk ok?

    Written by  Phil Carlisle (aka Zoombapup // CodeX) 1994.

EOF

*******************************************************************************
*  11. Datei Voxel.txt														  *
*******************************************************************************




		     Voxel Landscapes and How I Did It
			       By Tim Clarke
		      Email: tjc1005@hermes.cam.ac.uk

 This document describes the method I used in my demo of a Martian terrain,
which can be found at garbo.uwasa.fi:/pc/demo/mars10.zip.
 It's similar to a floating horizon hidden line removal algorithm, so you'll
find discussion of the salient points in many computer graphics books. The
difference is the vertical line interpolation.


First, some general points
--------------------------

 The map is a 256x256 grid of points, each having an 8-bit integer height
and a colour. The map wraps round such that, calling w(u,v) the height at
(u,v), then w(0,0)=w(256,0)=w(0,256)=w(256,256). w(1,1)=w(257,257), etc.

 Map co-ords: (u,v) co-ordinates that describe a position on the map. The
map can be thought of as a height function h=w(u,v) sampled discretely.

 Screen co-ords: (x,y) co-ordinates for a pixel on the screen.


To generate the map
-------------------

 This is a recursive subdivision, or plasma, fractal. You start of with
a random height at (0,0) and therefore also at (256,0), (0,256), (256,256).
Call a routine that takes as input the size and position of a square, in the
first case the entire map.
 This routine get the heights from the corners of the square it gets given.
Across each edge (if the map has not been written to at the point halfway
along that edge), it takes the average of the heights of the 2 corners on that
edge, applies some noise proportional to the length of the edge, and writes
the result into the map at a position halfway along the edge. The centre of
the square is the average of the four corners+noise.
 The routine then calls itself recursively, splitting each square into four
quadrants, calling itself for each quadrant until the length of the side is
2 pixels.
 This is probably old-hat to many people, but the map is made more realistic
by blurring:

     w(u,v)=k1*w(u,v)+k2*w(u+3,v-2)+k3*w(u-2,v+4) or something.

 Choose k1,k2,k3 such that k1+k2+k3=1. The points at which the map is sampled
for the blurring filter do not really matter - they give different effects,
and you don't need any theoretical reason to choose one lot as long as it
looks good. Of course do everything in fixed point integer arithmetic.
 The colours are done so that the sun is on the horizon to the East:

     Colour=A*[ w(u+1,v)-w(u,v) ]+B

with A and B chosen so that the full range of the palette is used.
 The sky is a similar fractal but without the colour transformation.


How to draw each frame
----------------------

 First, draw the sky, and blank off about 50 or so scan lines below the
horizon since the routine may not write to all of them (eg. if you are on top
of a high mountain looking onto a flat plane, the plane will not go to the
horizon).
 Now, down to business. The screen is as follows:

     ---------------------------
     |                         |
     |                         |
     |           Sky           |
     |                         |
     |                         |
     |a------------------------| Horizon
     |                         |
     |                         |    Point (a)=screen co-ords (0,0)
     |          Ground         |     x increases horizontally
     |                         |     y increases downwards
     |                         |
     ---------------------------

 Imagine the viewpoint is at a position (p,q,r) where (p,q) are the (u,v)
map co-ordinates and r is the altitude. Now, for each horizontal (constant v)
line of map from v=q+100 (say) down to v=q, do this:

  1. Calculate the y co-ordinate of map co-ord (p,v,0) (perspective transform)


    you:->------------------------ Horizontal view
	 :
      r  :
	 :
	 :
     -----------------------------P Ground
	 ......................... (q-v)
	 q                       v

 You have to find where the line between P and you intersects with the 
screen (vertical, just in front of 'you'). This is the perspective transform:
   y=r/(q-v).

  2. Calculate scale factor f which is how many screen pixels high a mountain
of constant height would be if at distance v from q. Therefore, f is small
for map co-ords far away (v>>q) and gets bigger as v comes down towards q.

  So, f is a number such that if you multiply a height from the map by f, you 
get the number of pixels on the screen high that height would be. For 
example, take a spot height of 250 on the map. If this was very close, it 
could occupy 500 pixels on the screen (before clipping)->f=2.

  3. Work out the map u co-ord corresponding to (0,y). v is constant along
each line.

  4. Starting at the calculated (u,v), traverse the screen, incrementing the
x co-ordinate and adding on a constant, c, to u such that (u+c,v) are the map
co-ords corresponding to the screen co-ords (1,y). You then have 256 map
co-ords along a line of constant v. Get the height, w, at each map co-ord and
draw a spot at (x,y-w*f) for all x.

 I.e. the further away the scan line is, the more to the "left" u will start,
and the larger c will be (possibly skipping some u columns if c > 1); the
closer the scan line, the lesser u will start on the "left", and c will be
smaller.


 Sorry, but that probably doesn't make much sense. Here's an example:
Imagine sometime in the middle of drawing the frame, everything behind a
point (say v=q+50) will have been drawn:

     ---------------------------
     |                         |
     |                         |
     |                         |
     |           ****          |
     |        *********        | <- A mountain half-drawn.
     |-----**************------|
     |*************************|
     |*********       *********|
     |******             ******|
     |.........................| <- The row of dots is at screen co-ord y
     |                         |   corresponding to an altitude of 0 for that
     ---------------------------   particular distance v.

 Now the screen-scanning routine will get called for v=q+50. It draws in a
point for every x corresponding to heights at map positions (u,v) where u
goes from p-something to p+something, v constant. The routine would put points
at these positions: (ignoring what was there before)

     ---------------------------
     |                         |
     |                         |
     |                         |
     |                         |
     |                         |
     |-------------------------|
     |          *****          |
     |       ***     ***       |
     |*******           *******|
     |.........................|
     |                         |
     ---------------------------

 So, you can see that the screen gets drawn from the back, one vertical
section after another. In fact, there's more to it than drawing one pixel
at every x during the scan - you need to draw a vertical line between
(x,y old) to (x,y new), so you have to have a buffer containing the y values
for every x that were calculated in the previous pass. You interpolate
along this line (Gouraud style) from the old colour to the new colour also,
so you have to keep a buffer of the colours done in the last pass.
 Only draw the vertical lines if they are visible (ie. going down,
y new>y old). The screen is drawn from the back so that objects can be drawn
inbetween drawing each vertical section at the appropriate time.

 If you need further information or details, mail me or post here... Posting
will allow others to benefit from your points and my replies, though.

 Thank you for the response I have received since uploading this program.


*******************************************************************************
*  12. Datei - Clip.PolyArticle												  *	
*******************************************************************************

TABSIZE = 8
								Paul Kent
								9 Pendean
								Burgess Hill
								West Sussex
								RH15 ODW.

POLGON CLIPPER
~~~~~~~~~~~~~~
As I said last month, I thought I'd show how to clip a polygon. Any vector
based code, whether 3d,2d rotation to sizing has to ensure that only the
visible parts of the vector graphics are displayed. EG To avoid screen
corruption due to drawing lines off the side of one bitplane onto another...
If you can guarantee that none of your graphics will go off-screen then
you avoid clipping altogether - but there are only so many situations in 
which you can guarantee this!

The method I shall describe unbundles the problem into 2 distinct parts:
1-only drawing lines within given limits, the viewing window.
2-ensuring that the polygon doesnt decompose so much as to make it impossible
  to fill using the blitter.

PART 1
~~~~~~ 
For the first part, we step round the edges of the polygon, looking at the
start/end points for the lines on each side. If these lines start or finish
outside of our viewing window, we clip the line to the edge of the viewing 
boundary.(See example lower down!). If a line is completely beyond the
viewing window, we just skip it altogether.
The standard equation for a line can be used to work out where it intersects
the viewing window:

			Y=MX+C where M = gradient of line
				     C = y-intercept (y value when x=0)
				   Y,X = coordinates
This poses another problem: this formula is for an infinitely long line, not
our 'short' line. So we obtain M,the gradient from our coordinates (change
in Y divided by change in X), then use

	  	    dY=MdX where dY,dX = Change of X,Y coords
	  	    
to chop away the offending part of the line, and obtain some new coords.

Suppose our line has start coords x1,y1 & end coords x2,y2:

Then,		     M=(y2-y1)/(x2-x1)	  		

Suppose we are clipping to the righthand boundary, with x2 greater than
the x value for the window boundary.(I'll call this RHSIDE).I will
also assume that x1 is less than RHSIDE - else we would have skipped this
line because it would be to the right of the viewing window.

Then
		dY=(x2-RHSIDE)(y2-y1)/(x2-x1)
		
	y3 = y2-dY = y2-(x2-RHSIDE)(y2-y1)/(x2-x1)
	
			     x3 = RHSIDE					

This is repeated for the top/bottom/left of the viewing window as necessary.
We then draw a line between points x1,y1 and x3,y3. We then repeat the whole
process for the next side of the polygon.

PART 2
~~~~~~
For the blitter to fill an object coorectly, it must be joined up!
(Simple but true!). The polygon only needs to be joined up at side the
blitter will be filling from however - the blitter fills right>left,
and so it never 'sees' if an object is joined at the top and bootom.
To join up the right hand side of the polygon, when some of it has been
clipped away (PART 1) we just need to look for pairs of coordinates
where the line cuts the window boundary on the right hand side, and draw
a line between the two. For example in the example below, we would draw
a line between points 3 & 4. This part can be integrated into PART 1
by simply putting in some code around when we get coordinates 3 or 4
from the line clipping code.

EG.            Window Boundary
		    ^
					|
		1	       3|	    2			
		x---------------+-------x
	   /			|		   /
					|		  /
					|		 /
					|       /
	 Rest of		|      /
	Polygon.		|     /
					|    /
					|   /
					|  /
					| /
			       4|/
			       /|
				
When examining line 1,2, we see that it cuts the viewing window at 3.
Consequently we then pass the coordinates  1,3 for the lines new start and
end points, after clipping. We also note down point 3 as being on a 
window boundary so that we can later seal the polygon for filling (as problem
part 2).

CODING IT
~~~~~~~~~
This isn't particualrly problematical - the most easy mistake to make
is dividing values before the last possible moment - no decimal points
in ASSEMBLY remember! - try to preserve accuracy.

A rough outline of the code is given below:

- For each pair of coordinates in each polygon:
	- Check against right boundary
		- If line all to right, skip line
		  ELSE Clip line
		- Save line colour & coordinates at rh intersection.
		  (For sealing polygon PART 2!)
	- Check against left boundary
		- If line all to left, skip line	
		  ELSE Clip line

	- Repeat above for top, bottom boundaries

	- Draw line between (now) clipped coords.

- When all lines in all polys drawn:
	- Get coordinate pair from saved coord list
	  also get colour, ignoring secondary saved colour
	- Draw line
	- Repeat for all saved coord pairs

When drawing polygons for filling,the only points to watch out for
are to avoid drawing horizontal lines (will cause random results when
filling), setting the SING bit so that only 1 pixel is set per line for
each line (same reason as before), and the cunning trick to ensure
that line endings meet/dont meet as necessary for a correct fill by
subtracting 1 from a y coordinate in the line routine... (see source).

The only problem I had, which you lot won't have is debugging the clipping
code!
The code is currently designed to print a list of polygons onto the
screen, in order specified.A polygon at present consists of a list
of words only in the form:

POLY:	dc.w	1	;colour
	dc.w	0,1	;First edge point no.s for start/end
	dc.w	1,2	;2nd edge...
	dc.w	2,6	;3rd edge.(Point no.s don't need to be sequential!)
	dc.w	...
	dc.w	POLYEND ;Constant used to terminate polygon ($8001 - unlikely
			 coord)

The code also just scales a polygon into & outof the screen at the moment.
If you just want to clip a line, it should be easy to disect the polygon
line clipping code for the single line case!

If you have any problems with this code write to me and I'll try to
help.(Address as top)

Paul Kent.4/2/92.One step closer.
		 

