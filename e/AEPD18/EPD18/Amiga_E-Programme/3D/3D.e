/*
***************************************************************************
	Programmname    : 3D-Routinen
	
	Compiler		: PD-Compiler Amiga-E V2.1b von Wouter van Oortmerssen

	Version         : 1.00
	Beschreibung    : Grundgerüst von 3D-Routinen in "E"
===========================================================================
	geschrieben von Marcel Bennicke

	begonnen        : 21.10.1994
	letzte Änderung : 08.01.1995
***************************************************************************
*/


MODULE	'intuition/intuition','intuition/screens',
		'exec/memory','exec/ports','exec/nodes','exec/lists',
		'graphics/rastport','graphics/view','graphics/text','graphics/displayinfo','graphics/gfx',
		'reqtools','libraries/reqtools',
		'utility/tagitem'


OBJECT prgprefs
	scrwidth,scrheight: INT
	scrdisplayid: LONG
	scrdepth: CHAR

	globaltattr: LONG
	reqtattr: LONG
ENDOBJECT


/* nur zur Berechnung des Schattens notwendig, da großer Wertebereich nötig */ 
OBJECT vektor
	x1,x2,x3: LONG
ENDOBJECT


/* enthält 2D-Bildschirmkoordinaten eines 3D-Punktes */
OBJECT p2d
	x,y: INT
ENDOBJECT


/* 3D-Punkt
	trotz LONG-Variable nur für 16Bit Werte ausgelegt!
  	(bei Datentyp INT gibt es Probleme mit dem Vorzeichen) */
OBJECT p3d
	x1,x2,x3:LONG
ENDOBJECT


ENUM IS_UNUSED,IS_POINT,IS_LINE,IS_AREA

/* Ein Element ist nicht nur als Fläche zu verstehen, sondern eher als
   eine Verbindung von Punkten oder ein Punkt selbst. Wie die Struktur
   interpretiert wird, hängt von der Punktanzahl ab, die bei setElement()
   angegeben wird:
	   1  Punkt: Darstellung des Images auf der Punktposition oder 1 Pixel
	   2 Punkte: Verbindung dieser Punkte zu einer Linie
	3..n Punkte: Polygon mit n Ecken, die alle in EINER Ebene
		         liegen müssen (wird nicht vom Programm überprüft!)
*/

OBJECT element
	img: LONG			/* ^Image-Struktur als Textur */
	basiccolor: CHAR	/* Grundfarbe (Pen-Nr.) */
	realcolor: CHAR		/* Farbe nach Schattierung */
	depth: LONG			/* Abstand zum Beobachter, wird von sortElemente() eingetragen */

	points: INT			/* Anzahl der Punkte, die zu diesem Element zählen */
	pnr: LONG			/* ^Array, das die Nummern (von 0 beginnend) der
						   Punkte enthält, die zu diesem Element gehören.
						   Alle angegebenen Punkte müssen in 1 Ebene liegen! */ 
/* --- private ----------------- */
	type: CHAR			/* Verbindungstyp */
ENDOBJECT


/* Objekteigenschaften:
   -------------------- */
SET OB_ISSETUP,			/* !!! programmintern, nie benutzen !!! */
	OB_OUTLINE,			/* jede Fläche wird umrandet */
	OB_SHADOW,			/* Objekt wird schattiert */
	OB_NOSORT			/* Die Flächen sollen nicht sortiert werden! Nur
						   nützlich bei Drahtgittermodellen o.ä., da sonst
						   Darstellungsfehler auftauchen */

CONST	ZOOMBASE = 1024,	/* Basiszahl für die ein Objekt in 1:1 Größe */
	 	ZOOMBASE_BITS = 10	/* dargestellt wird */

OBJECT objekt
/* --- public ----------------- */
	z1,z2,z3:INT		/* Nullpunkt des Objektes in der 3D-Welt*/
	w1,w2,w3:INT		/* Drehwinkel um x1/2/3-Achse des gesamten Objektes */
	x0,y0: INT			/* Offset für Bildschirmdarstellung */
	zoom3: INT			/* 3-dimensionaler Vergrößerungsfaktor vergrößert
						   das Volumen des Objektes in der 3D-Welt 
							1024 = Originalgröße
							2048 = doppelt...
						*/
	zoom2: INT			/* 2-dimensionaler Vergrößerungsfaktor vergrößert
						   nur die Bildschirmdarstellung eines Objektes,
						   wirkt also wie ein Fernglas */

	flags: CHAR			/* Objekteigenschaften */

	pcount: LONG		/* Anzahl der Punkte */
	p3list: LONG		/* ^Array von p3d-Punkte (Original) */
	pdest: LONG			/* ^Array von p3d-Punkten nach Convert3Dto2d */
	p2list: LONG		/* ^Array von p2d-Punkten nach Convert3dto2d */

	ecount: LONG		/* Anzahl der Elemente */
	elist: LONG			/* ^Array von Zeigern auf je 1 Element */

	outline: CHAR		/* Umrandungsfarbe */

/* --- private ----------------- */
	remkey: LONG		/* remember-Key */
ENDOBJECT	


CONST	BD_IDCMP = IDCMP_MENUPICK OR IDCMP_MOUSEBUTTONS,
		BD_WFLG = WFLG_BACKDROP OR WFLG_BORDERLESS OR WFLG_ACTIVATE OR WFLG_REPORTMOUSE


		/* -------- Fehlercodes */
ENUM	E_NONE=0,E_REQTOOLS,E_SCR,E_WIN,E_PORTIDCMP,E_MEM,E_SIGBIT,

		/* -------- Fehlerbereich bei Speicherplatzmangel */
		MEM_GETPORT=0,MEM_OBJECT,MEM_RAS,MEM_AREA,MEM_RPORT,MEM_BITMAP,
		MEM_PLANE,MEM_ELEMENT,

		/* -------- Entscheidungen */
		D_OK=0,

		/* -------- Reaktionsflags */
		DO_OK=0,DO_ERROR,DO_ABBRUCH



DEF g_error:PTR TO LONG,g_decision:PTR TO LONG,g_memerror:PTR TO LONG,

	g_prefs:prgprefs,g_oldreqwin,g_reqwin,
	g_portIDCMP:PTR TO mp,g_maskIDCMP,
	g_versionstring[60]:STRING,g_progname[55]:STRING,g_port[50]:STRING,
	g_running,
	g_scr:PTR TO screen,g_win:PTR TO window,

	g_tmpmem,g_tmpras:tmpras,				/* zum Flächenfüllen */
	g_areamem,g_areainfo:areainfo,			/* fÜr Area-Befehle */

	g_sin:PTR TO INT,g_cos:PTR TO INT
	

PROC funktion(x,y,xmax,ymax)
/* Hier steht die 3D-Funktion, die von zwei Parametern (x,y) abhängig ist
   und auf einer Fläche mit der Breite xmax und Höhe ymax abgebildet werden soll.
   Alle Werte beziehen sich hier auf die Anzahl der Stützpunkte in x- und
   y-Richtung. Die Werte von x und y beginnen bei 1!
   Die Fläche hat im 3D-Raum immer die Ausmaße von 400x400. Um Verzerrungen
   zu vermeiden sollten die berechneten Werte auch in diesem Bereich liegen.
*/

	DEF z,x2,y2

	x2:=(x-1)*900/xmax
	y2:=(y-1)*512/ymax

	z:=Shr(g_sin[x2 AND 511]*g_cos[y2 AND 511],16)
ENDPROC z


PROC main() HANDLE
	DEF gotsigs,msg:PTR TO intuimessage,
		class,code,

		beo:p3d,mx,my,bm,title[80]:STRING,
		drawrp:PTR TO rastport,hiddenrp:PTR TO rastport,
		obj1:PTR TO objekt,breite,hoehe,flaechenanzahl


	IF setup()<>DO_OK THEN Raise(E_NONE)

	breite:=11		/* Anzahl der Stützpunkte des Funktionsrasters */
	hoehe:=11
	flaechenanzahl:=(breite-1)*(hoehe-1)*2

	IF openVisuals({drawrp},10)<>DO_OK THEN Raise(E_NONE)

	bm:=getBitmap(g_win.width,g_win.height,g_prefs.scrdepth)
	IF bm=NIL THEN Raise(E_NONE)
	hiddenrp:=getRPort(bm)
	IF hiddenrp=NIL THEN Raise(E_NONE)

	/* da hiddenrp die gleichen Ausmaße wie drawrp hat, können beide
	   1 gemeinsamen Layer benutzen. Dadurch werden auch im verschteckten
	   Rastport hiddenrp über den Rand hinauslaufende Linien und Flächen
	   korrekt abgeschnitten, d.h. für den hiddenrp gelten die gleichen
	   ClippingRects wie für drawrp. Ansonsten würde es bei überstehenden
	   Pixeln zu Systemabstürzen kommen. */

	hiddenrp.layer:=drawrp.layer

	obj1:=setupObjekt(breite*hoehe,flaechenanzahl,OB_SHADOW)
	IF obj1=NIL THEN Raise(E_NONE)

	IF setupvals(obj1,breite,hoehe)<>DO_OK THEN Raise(E_NONE)

	beo.x1:=-300
	beo.x2:=0
	beo.x3:=0

	StringF(title,'\s  [\d Flächen]',g_progname,flaechenanzahl)
	SetWindowTitles(g_win,-1,title)

	g_running:=TRUE

	WHILE g_running
		displayObjekt(g_scr.viewport,hiddenrp,obj1,beo)
		ClipBlit(hiddenrp,0,0,drawrp,0,0,g_win.width,g_win.height,$c0)

		obj1.w1:=(obj1.w1+8) AND 511
		obj1.w2:=(obj1.w2-7) AND 511
		obj1.w3:=(obj1.w3+12) AND 511

		IF (msg:=GetMsg(g_portIDCMP))<>NIL
			class:=msg.class
			mx:=msg.mousex
			my:=msg.mousey
			ReplyMsg(msg)

			SELECT class
				CASE IDCMP_MENUPICK
					g_running:=FALSE

				CASE IDCMP_MOUSEBUTTONS
					beo.x2:=-g_win.width/2+mx
					beo.x3:=g_win.height/2-my
			ENDSELECT					
		ENDIF
	ENDWHILE

	closeObjekt(obj1)
	deleteRPort(hiddenrp)
	deleteBitmap(bm)
	closeVisuals()
	closeall()
	CleanUp(0)
EXCEPT
	closeObjekt(obj1)
	deleteRPort(hiddenrp)
	deleteBitmap(bm)
	closeVisuals()
	closeall()
ENDPROC



PROC displayObjekt(vp:PTR TO viewport,rp:PTR TO rastport,o:PTR TO objekt,beobachter:PTR TO p3d)

	/* Darstellung eines einzelen Objektes o vom Beobachter-Standpunkt
	   beobachter auf dem Rastport rp. Dieser rp muß auf das Füllen von
	   Flächen und die Benutzung der Area-Befehle vorbereitet sein!
	   Es werden die verschiedenen Objekt-Eigenschaften berücksichtigt.
	 	  Wichtig ist, daß wenn das Objekt in einen Rastport gezeichnet
	   wird, der keine Layer-Struktur besitzt, über den Rand hinauslaufende
	   Punkte, Linien und Flächen nicht abgeschnitten werden, so daß
	   Systemabstürze vorprogrammiert sind.

		vp			^viewport, auf dem das Objekt gezeichnet wird
		rp			^rastport
		o			Zeiger auf das Objekt
		beobachter	^p3d-Punkt; gibt Beobachterposition an
	*/


	DEF i,j,p2:PTR TO p2d,ep:PTR TO LONG,
		e:PTR TO element,nr:PTR TO LONG,typ

	convertObjekt(o,beobachter)

	IF (o.flags AND OB_NOSORT)=0 THEN sortElemente(o,beobachter)
	IF o.flags AND OB_SHADOW THEN schatten(vp,o,beobachter,40)
	IF o.flags AND OB_OUTLINE
		bndryOn(rp)
		setOPen(rp,o.outline)
	ELSE
		bndryOff(rp)
	ENDIF

	p2:=o.p2list
	ep:=o.elist

	SetRast(rp,2)

	typ:=IS_UNUSED

	FOR i:=0 TO o.ecount-1
		e:=ep[i]

		typ:=e.type
		nr:=e.pnr

		SELECT typ
			CASE IS_POINT
				IF e.img<>NIL
					DrawImage(rp,e.img,0,0)
				ELSE
					SetAPen(rp,e.realcolor)
					WritePixel(rp,p2[nr[0]].x,p2[nr[0]].y)
				ENDIF

			CASE IS_LINE
				SetAPen(rp,e.realcolor)
				Move(rp,p2[nr[0]].x,p2[nr[0]].y)
				Draw(rp,p2[nr[1]].x,p2[nr[1]].y)

			CASE IS_AREA
				SetAPen(rp,e.realcolor)

				AreaMove(rp,p2[nr[0]].x,p2[nr[0]].y)
				FOR j:=1 TO e.points-1
					AreaDraw(rp,p2[nr[j]].x,p2[nr[j]].y)
				ENDFOR
				AreaDraw(rp,p2[nr[0]].x,p2[nr[0]].y)
				AreaEnd(rp)
		ENDSELECT
	ENDFOR
ENDPROC


PROC convertObjekt(o:PTR TO objekt,b:PTR TO p3d)
/*
	Umrechnung der 3-dimensionalen Koorinaten:
	~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	Projektion eines 3D-Objekts auf die Bildschirmkoordinaten
	x/y (in p2list) vom Beobachterpunkt b. Die x2/x3-Ebene ist dabei
	der Schirm. Vor der Projektion wird das Objekt um die x1/2/3-Achse
	gedreht (zugehörige Winkel w1/2/3 ist in Objekt-Struktur eintragen),
	auf das Zentrum (z1|z2|z3) verschoben und um zoom3 und zoom2 vergrößert.
*/

	DEF difx1,i,p3:PTR TO p3d,p2:PTR TO p2d,
		p:PTR TO p3d,x1s,x2s,x3s,si,co

	p3:=o.p3list
	p2:=o.p2list
	p:=o.pdest

	FOR i:=1 TO o.pcount

/* Drehungen um x1/2/3-Achse */
		/* x1 */
		si:=g_sin[o.w1]
		co:=g_cos[o.w1]
		x2s:=Shr((p3.x2*co)-(p3.x3*si),11)
		x3s:=Shr((p3.x2*si)+(p3.x3*co),11)

		/* x2 */
		si:=g_sin[o.w2]
		co:=g_cos[o.w2]
		x1s:=Shr((p3.x1*co)-(x3s*si),11)
		p.x3:=Shr(Shr((p3.x1*si)+(x3s*co),11)*o.zoom3,ZOOMBASE_BITS)+o.z3

		/* x3 */
		si:=g_sin[o.w3]
		co:=g_cos[o.w3]
		p.x1:=Shr(Shr((x1s*co)-(x2s*si),11)*o.zoom3,ZOOMBASE_BITS)+o.z1
		p.x2:=Shr(Shr((x1s*si)+(x2s*co),11)*o.zoom3,ZOOMBASE_BITS)+o.z2
		
/* Schnittpunkt mit x2/3-Ebene = Schirm */

		difx1:=(b.x1-p.x1)
		IF difx1=0
			p2.x:=o.x0;p2.y:=o.y0
		ELSE
			p2.x:=Shr((p.x2-(p.x1*(b.x2-p.x2)/difx1))*o.zoom2,ZOOMBASE_BITS)+o.x0
			p2.y:=Shr((p.x3-(p.x1*(b.x3-p.x3)/difx1))*o.zoom2,ZOOMBASE_BITS)+o.y0
		ENDIF
		p2++
		p3++
		p++
	ENDFOR
ENDPROC


PROC sortElemente(o:PTR TO objekt,b:PTR TO p3d)
	DEF	i,j,ep:PTR TO LONG,e:PTR TO element,pd:PTR TO p3d,
		nr:PTR TO LONG,x1m,x2m,x3m

	ep:=o.elist
	pd:=o.pdest
	FOR i:=0 TO o.ecount-1
		e:=ep[i]
		IF e.type=IS_POINT
			e.depth:=betrag([b.x1-pd[nr[0]].x1,b.x2-pd[nr[0]].x2,b.x3-pd[nr[0]].x3]:vektor)
		ELSEIF (e.type=IS_LINE) OR (e.type=IS_AREA)
			x1m:=0;x2m:=0;x3m:=0
			nr:=e.pnr
			FOR j:=0 TO e.points-1
				x1m:=x1m+pd[nr[j]].x1
				x2m:=x2m+pd[nr[j]].x2
				x3m:=x3m+pd[nr[j]].x3
			ENDFOR
			e.depth:=betrag([b.x1-(x1m/e.points),b.x2-(x2m/e.points),b.x3-(x3m/e.points)]:vektor)
		ELSE
			e.depth:=0			/* noch ungenutzte Elemente haben Tiefe 0 */
		ENDIF
	ENDFOR

	quick(o.elist,0,o.ecount-1)
ENDPROC


PROC quick(ep:PTR TO LONG,min,max)
	/* Flächen abwärts sortieren */

	DEF u,o,vgl,mitte,tausch,e:PTR TO element

	u:=min;o:=max
	mitte:=Shr(u+o,1)
	e:=ep[mitte]
	vgl:=e.depth
	REPEAT
		e:=ep[u]
		WHILE vgl<e.depth
			INC u
			e:=ep[u]
		ENDWHILE
		e:=ep[o]
		WHILE vgl>e.depth
			DEC o
			e:=ep[o]
		ENDWHILE
		IF u<=o
			tausch:=ep[o]
			ep[o]:=ep[u]
			ep[u]:=tausch
			INC u
			DEC o
		ENDIF
	UNTIL o<u

	IF u<max THEN quick(ep,u,max)
	IF min<o THEN quick(ep,min,o)
ENDPROC


PROC sqrt(rad)
	DEF erg

	MOVE.L	rad,D0

	/* bin wurzel2 aus Amiga-Magazin Sonderheft 2 */

	MOVE.L	#$40000000,D1
	MOVE.L	#$30000000,D7
start2:
	LSR.L	#1,D1
	EOR.L	D7,D1
	CMP.L	D1,D0
	BMI.S	loop2
	SUB.L	D1,D0
	OR.L	D7,D1
loop2:
	LSR.L	#2,D7
	BCC.S	start2
	LSR		#1,D1

	MOVE.L	D1,erg
ENDPROC erg


PROC bndryOn(rp:PTR TO rastport)
	rp.flags:=rp.flags OR RPF_AREAOUTLINE
ENDPROC

PROC bndryOff(rp:PTR TO rastport)
	rp.flags:=rp.flags AND ($FFFF-RPF_AREAOUTLINE)
ENDPROC

PROC setOPen(rp:PTR TO rastport,f)
	rp.aolpen:=f
ENDPROC


PROC setupObjekt(pnum,enum,fl) HANDLE
/* Reserviert alle nötigen Speicherbereiche und legt Ausgangswerte fest.
   Die Prozedur kann für jedes Objekt nur 1 mal ausgeführt werden.

   pnum		max. Anzahl der Punkte dieses Objektes
   enum		max. Anzahl der Elemente dieses Objektes
   fl		Objekteigenschaften (mit OR verknüpft) */

	RAISE E_MEM IF AllocRemember()=NIL,
		  E_MEM IF New()=NIL

	DEF i,o:PTR TO objekt,ep:PTR TO LONG,e:PTR TO element,
		psize,arrsize,listsize


	fl:=fl AND ($FFFFFFF-OB_ISSETUP)	/* unerlaubte Flags sicherheitshalber ausblenden */

	IF (fl AND OB_ISSETUP)=0
		o:=New(SIZEOF objekt)
		o.ecount:=enum
		o.pcount:=pnum
		o.remkey:=NIL
		o.zoom3:=ZOOMBASE
		o.zoom2:=ZOOMBASE
		o.flags:=fl OR OB_ISSETUP
		o.outline:=1


		/* nur 1 großes Stück Speicher für alle Arrays besorgen, um
		   Zerstückelung zu vermeiden
		*/

		psize:=o.pcount*SIZEOF p3d
		arrsize:=o.ecount*4
		listsize:=o.ecount*SIZEOF element

		o.p3list:=AllocRemember(o.remkey,psize*3+arrsize+listsize,MEMF_CLEAR)
		o.pdest:=o.p3list+psize
		o.p2list:=o.pdest+psize
		o.elist:=o.p2list+psize

		ep:=o.elist
		e:=ep+arrsize
		FOR i:=0 TO o.ecount-1
			e.type:=IS_UNUSED
			ep[i]:=e++
		ENDFOR
	ENDIF	
EXCEPT
	closeObjekt(o)
	request(g_error[exception],g_decision[D_OK],[g_memerror[MEM_OBJECT]])
	o:=NIL
ENDPROC o


PROC closeObjekt(o:PTR TO objekt)
/* gibt alle Speicherbereiche für 1 Objekt wieder frei */

	DEF ep:PTR TO LONG,e:PTR TO element,i

	IF o<>NIL
		ep:=o.elist
		FOR i:=0 TO o.ecount-1
			e:=ep[i]
			IF e.pnr<>NIL THEN Dispose(e.pnr)
		ENDFOR
		FreeRemember(o.remkey,TRUE)
		Dispose(o)
	ENDIF
ENDPROC


PROC setupvals(o:PTR TO objekt,b,h) HANDLE
/* Legt die Punkte des Objektes fest und installiert alle Elemente.
   Ist hier nur als Beispiel für ein Objekt gedacht und kann beliebig
   eigenen Wünschen verändert werden.
*/


	DEF success=DO_OK,x,y,i

	o.w1:=0;o.w2:=0;o.w3:=0
	o.z1:=400;o.z2:=0;o.z3:=0
	o.x0:=g_win.width/2
	o.y0:=g_win.height/2
	
	i:=1
	FOR y:=1 TO h
		FOR x:=1 TO b
			setPunkt(o,i,[x*400/b-200,y*400/h-200,funktion(x,y,b,h)]:p3d)
			INC i
		ENDFOR
	ENDFOR
	recenterObjekt(o)

	/* 3 verschiedene Arten der Darstellung eines Objektes, nur 1 davon
	   compilieren lassen, die anderen in Kommentare setzen !!! */

	/* Stützpunkte durch 1 Punkt markieren:
	   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	   als Objekteigenschaft OB_NOSORT setzen, da sortieren nicht nötig
	
	FOR i:=1 TO b*h
		IF setElement(o,i,NIL,1,[i]:LONG)<>DO_OK THEN Raise(E_NONE)
	ENDFOR
	*/


	/* Stützpunkte durch Linien zu einem Raster verbinden:
	   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	   Objekteigenschaft OB_NOSORT kann gesetzt werden

	i:=1
	FOR y:=1 TO h-1
		FOR x:=1 TO b-1
			IF setElement(o,i,NIL,1,[y*b+x,(y-1)*b+x]:LONG)<>DO_OK THEN Raise(E_NONE)
			INC i
			IF setElement(o,i,NIL,1,[y*b+x,y*b+x+1]:LONG)<>DO_OK THEN Raise(E_NONE)
			INC i
		ENDFOR
	ENDFOR
	*/

	/* Stützpunkte mit Dreiecksflächen verbinden:
	   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	   Objekteigenschaft OB_NOSORT verursacht Fehler!
	   OB_SHADOW schattiert das Objekt
	   OB_OUTLINE umrahmt alle Flächen mit der Farbe in o.outline
	*/
	i:=1
	FOR y:=1 TO h-1
		FOR x:=1 TO b-1
			IF setElement(o,i,NIL,2,[y*b+x,(y-1)*b+x+1,(y-1)*b+x]:LONG)<>DO_OK THEN Raise(E_NONE)
			INC i
			IF setElement(o,i,NIL,2,[y*b+x,y*b+x+1,(y-1)*b+x+1]:LONG)<>DO_OK THEN Raise(E_NONE)
			INC i
		ENDFOR
	ENDFOR

EXCEPT
	success:=DO_ERROR
ENDPROC success


PROC recenterObjekt(o: PTR TO objekt)
	/* verschiebt alle Originalpunkte des Objektes so, daß sein Mittelpunkt
	   Nullage hat (Objekt rotiert immer um Nullpunkt)
	*/

	DEF i,x1m=0,x2m=0,x3m=0,p:PTR TO p3d

	p:=o.p3list
	FOR i:=1 TO o.pcount
		x1m:=x1m+p.x1
		x2m:=x2m+p.x2
		x3m:=x3m+p.x3
		p++
	ENDFOR
	x1m:=x1m/o.pcount
	x2m:=x2m/o.pcount
	x3m:=x3m/o.pcount

	p:=o.p3list
	FOR i:=1 TO o.pcount
		p.x1:=p.x1-x1m
		p.x2:=p.x2-x2m
		p.x3:=p.x3-x3m
		p++
	ENDFOR
ENDPROC


PROC setPunkt(o:PTR TO objekt,nr,p:PTR TO p3d) HANDLE
	/* Festlegen eines 3D-Punktes für ein Objekt

	o:		Zeiger auf das Objekt
	nr:		Nr. des Punktes (von 1 bis der Anzahl der Punkte des Objektes)
	p:		Zeiger auf die p3d-Struktur des Punktes
	*/


	DEF	success=DO_OK,p3:PTR TO p3d,pd:PTR TO p3d

	IF (nr<1) OR (nr>o.pcount) THEN Raise(E_NONE)
	IF (Abs(p.x1)>32767) OR (Abs(p.x3)>32767) OR (Abs(p.x3)>32767) THEN Raise(E_NONE)

	p3:=o.p3list
	pd:=o.pdest
	DEC nr

	p3[nr].x1:=p.x1
	p3[nr].x2:=p.x2
	p3[nr].x3:=p.x3

	pd[nr].x1:=p.x1
	pd[nr].x2:=p.x2
	pd[nr].x3:=p.x3
EXCEPT
	success:=DO_ABBRUCH
ENDPROC success


PROC setElement(o:PTR TO objekt,nr,textur,bcol,pn:PTR TO LONG) HANDLE
	/* ein Element für ein Objekt festlegen

	die Anzahl der Punkte, die in der LIST pn angegeben werden, entscheiden
	über die Darstellungsart des Elementes:
			1 Punkt		-> Punkt
			2 Punkte	-> Linie
			>=3 Punkte	-> Polygon mit n Ecken; dabei entscheidet die
						   Reihenfolge der Punkte darüber, auf welcher Seite
						   der Fläche "oben" ist (wichtig bei Schattierung).
						   Am besten probieren!

	o:		^objekt-Struktur
	nr:		Nr. des Elements
	textur:	^Image-Struktur, die bei Elementen mit 1 Punkt gezeichnet wird
	bcol:	Grundfarbe (Pen-Nr.)
	pn:		(immidiate) LIST, die die Nummern, der Punkte eines Objektes
			enthält, die das Element bilden sollen
		 	Punktanzahl wird über ListLen bestimmt
	*/

	RAISE E_MEM IF New()=NIL

	DEF success=DO_OK,i,ep:PTR TO LONG,e:PTR TO element,
		p:PTR TO LONG,punkte

	punkte:=ListLen(pn)

	IF (nr>=1) AND (nr<=o.ecount) AND (punkte>=1)
		ep:=o.elist
		DEC nr
		e:=ep[nr]

		e.img:=textur
		e.basiccolor:=bcol
		e.realcolor:=bcol

		e.points:=punkte
		IF e.pnr<>NIL
			Dispose(e.pnr)
			e.pnr:=NIL
		ENDIF
		e.pnr:=New(punkte * 4)
		p:=e.pnr
		FOR i:=0 TO punkte-1 DO p[i]:=pn[i]-1

		IF punkte=1
			e.type:=IS_POINT
		ELSEIF punkte=2
			e.type:=IS_LINE
		ELSE
			e.type:=IS_AREA
		ENDIF
	ELSE
		success:=DO_ABBRUCH
	ENDIF
EXCEPT
	request(g_error[exception],g_decision[D_OK],[g_memerror[MEM_ELEMENT]])
	success:=DO_ERROR
ENDPROC success


PROC schatten(vp:PTR TO viewport,o:PTR TO objekt, spot: PTR TO p3d, umgebung)

	/* Schattieren eines Objektes o durch das Anstrahlen mit parallelen 
	   Lichtstrahlen vom Ort spot ausgehend. Schatten_würfe_ werden nicht
	   erzeugt, nur Helligkeitsänderung der Flächen! Flächen, die der
	   Lichtseite abgewandt sind erhalten die Helligkeit der Umgebung (0-255).

	   Die Qualität des Ergebnisses hängt stark von der Farbpalette
	   ab. Die Ergebnisfarbe (Pen-Nr.) steht im Feld realcolor jedes Elements.

	   Die Prozedur rechnet mit den Punkten im Array pdest. Es sollten daher
	   gültige Werte darin stehen, obwohl Abstürze abgefangen werden.

	vp:			Zeiger auf den viewport, auf dem das Objekt dargestellt wird
	o:			^objekt-Struktur
	spot:		Punkt, von dem parallele Lichtstrahlen ausgehen; sie
				verlaufen parallel zur Strecke spot - Zentrum des Objektes
	umgebung:	Umgebungshelligkeit (0..255)
	*/


	DEF i,pd:PTR TO p3d,ep:PTR TO LONG,e:PTR TO element,nr: PTR TO LONG,
		n: vektor,lichtvektor: vektor,zaehler,hell,
		cm:PTR TO colormap,farbe,rt,gn,bl,
		betr_n,betr_licht

	cm:=vp.colormap

	lichtvektor.x1:=spot.x1-o.z1
	lichtvektor.x2:=spot.x2-o.z2
	lichtvektor.x3:=spot.x3-o.z3
	betr_licht:=betrag(lichtvektor)
	IF betr_licht=0 THEN RETURN DO_ERROR

	ep:=o.elist
	pd:=o.pdest

	FOR i:=0 TO o.ecount-1
		e:=ep[i]
		nr:=e.pnr

		/* nur Ebenen schattieren */
		IF e.type=IS_AREA
			vektorProdukt(n,[pd[nr[1]].x1-pd[nr[0]].x1,
						pd[nr[1]].x2-pd[nr[0]].x2,
						pd[nr[1]].x3-pd[nr[0]].x3]:vektor,

						[pd[nr[2]].x1-pd[nr[0]].x1,
						pd[nr[2]].x2-pd[nr[0]].x2,
						pd[nr[2]].x3-pd[nr[0]].x3]:vektor)

			zaehler:=Mul(n.x1,lichtvektor.x1)+Mul(n.x2,lichtvektor.x2)+Mul(n.x3,lichtvektor.x3)
			betr_n:=betrag(n)

			IF (zaehler<0) OR (betr_n=0) /* der Lichtseite abgewandt oder Fehler*/
				hell:=umgebung
			ELSE
				hell:=zaehler/betr_n*(255-umgebung)/betr_licht+umgebung
			ENDIF

			farbe:=GetRGB4(cm,e.basiccolor)
			rt:=Shr((Shr(farbe,8) AND $F)*hell,8)
			gn:=Shr((Shr(farbe,4) AND $F)*hell,8)
			bl:=Shr((farbe AND $F)*hell,8)

			/* rt,gn,bl enthalten die ideale Farbe mit der berechneten Helligkeit */
			/* -> aus der Palette die am besten passende Farbe heraussuchen */

			e.realcolor:=findBestColor(cm,rt,gn,bl)
		ENDIF
	ENDFOR
ENDPROC


PROC findBestColor(cm: PTR TO colormap,r,g,b)
	DEF i,farbe,nr=0,diff,diffmin=1000

	FOR i:=0 TO cm.count-1
		farbe:=GetRGB4(cm,i)
		diff:=Abs((Shr(farbe,8) AND $F)-r)+Abs((Shr(farbe,4) AND $F)-g)+Abs((farbe AND $F)-b)
		IF diff<diffmin
			diffmin:=diff
			nr:=i
		ENDIF
	ENDFOR
ENDPROC nr


PROC vektorProdukt(norm: PTR TO vektor, a: PTR TO vektor, b:PTR TO vektor)
	norm.x1:=(a.x2*b.x3)-(a.x3*b.x2)
	norm.x2:=(a.x3*b.x1)-(a.x1*b.x3)
	norm.x3:=(a.x1*b.x2)-(a.x2*b.x1)
ENDPROC


PROC betrag(p: PTR TO vektor)
	DEF erg

	erg:=sqrt(Mul(p.x1,p.x1)+Mul(p.x2,p.x2)+Mul(p.x3,p.x3))
ENDPROC erg


PROC request(body,gad,args) HANDLE
	RAISE E_NONE IF RtAllocRequestA()=NIL

	DEF ergebnis,ir:PTR TO rtreqinfo,tattr:PTR TO textattr

	tattr:=g_prefs.reqtattr

	IF AvailMem(MEMF_CHIP)<50 THEN Raise(E_NONE)

	ir:=RtAllocRequestA(RT_REQINFO,NIL)

	ergebnis:=RtEZRequestA(body,gad,ir,args,
			[RT_UNDERSCORE,"_",
			RT_REQPOS,REQPOS_POINTER,
			RT_SHAREIDCMP,g_portIDCMP,
			RT_TEXTATTR,tattr,
			RTEZ_FLAGS,EZREQF_CENTERTEXT,
			RTEZ_REQTITLE,'Information',
			TAG_DONE])

	RtFreeRequest(ir)
EXCEPT
	/* AutoRequest erstellt bei Speicherplatzmangel einen Alert */
	AutoRequest(g_reqwin,
			[0,1,0,10,tattr.ysize+2,tattr,'Zu wenig Speicher für die',
			[0,1,0,10,20,tattr.ysize*2+2,'Darstellung der Dialogbox!',NIL]:intuitext]:intuitext,
			[2,1,0,6,3,tattr,'OK',NIL]:intuitext,
			[2,1,0,6,3,tattr,'OK',NIL]:intuitext,
			0,0,320,70)
	ergebnis:=0
ENDPROC ergebnis


PROC getProcWindow()
	DEF process,processwindow

	process:=FindTask(0)
	MOVE.L	process,A0
	MOVE.L	184(A0),processwindow
ENDPROC processwindow


PROC setProcWindow(newwindow)
	DEF process,save

	save:=getProcWindow()

	process:=FindTask(0)
	MOVE.L	process,A0
	MOVE.L	newwindow,184(A0)
ENDPROC save


PROC getPort(name) HANDLE
	RAISE E_MEM IF New()=NIL

	DEF gport:PTR TO mp,sig,node:PTR TO ln

	IF (sig:=AllocSignal(-1))=-1 THEN Raise(E_SIGBIT)
	gport:=New(SIZEOF mp)
	node:=gport.ln
	node.type:=NT_MSGPORT
	node.pri:=0
	node.name:=name
	gport.sigbit:=sig
	gport.sigtask:=FindTask(0)
	AddPort(gport)
EXCEPT
	IF sig<>0 THEN FreeSignal(sig)
	IF gport<>NIL THEN Dispose(gport)
	gport:=NIL
	request(g_error[exception],g_decision[D_OK],[g_memerror[MEM_GETPORT]])
ENDPROC gport


PROC deletePort(delport:PTR TO mp)
	RemPort(delport)
	FreeSignal(delport.sigbit)
	Dispose(delport)
ENDPROC


PROC setup() HANDLE
	DEF success=DO_OK,tattr:PTR TO textattr

	g_progname:='3D-Routinen'
	g_versionstring:='$VER: 3D-Routinen Version 1.00 (08.01.1995)'

	StrCopy(g_port,g_progname,ALL)
	StrAdd(g_port,'.port',ALL)

	setupSinCos()

	g_error:=['OK',
			'Reqtools.library?',
			'Bildschirm konnte nicht geöffnet werden!',
			'Fenster konnte nicht geöffnet werden!',
			'Kommunikationsport konnte\nnicht angelegt werden!',
			'Speicherplatzmangel während:\n\n%s!',
			'Kein Signal mehr für\ninterne Kommunikation frei!']

	g_memerror:=['Anlegen eines Kommunikationskanals',
				'Anlegen eines 3D-Objektes',
				'Anlegen des Puffers für Füllroutinen',
				'Anlegen des Puffers für Polygone',
				'Anlegen einer RastPort-Struktur',
				'Anlegen einer BitMap-Struktur',
				'Anlegen einer BitMap-Plane',
				'Anlegen eines Objektelements']

	g_decision:=['_OK']

	g_prefs.scrwidth:=320
	g_prefs.scrheight:=256
	g_prefs.scrdepth:=4
	g_prefs.scrdisplayid:=(IF g_prefs.scrwidth=640 THEN V_HIRES ELSE 0) OR (IF g_prefs.scrheight=512 THEN V_LACE ELSE 0)
	g_prefs.globaltattr:=['topaz.font',8,0,0]:textattr
	g_prefs.reqtattr:=['topaz.font',8,0,0]:textattr

	g_oldreqwin:=getProcWindow()
	g_reqwin:=g_oldreqwin

	IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(E_REQTOOLS)

	g_portIDCMP:=getPort(g_port)
	IF g_portIDCMP=NIL THEN Raise(E_PORTIDCMP)
	g_maskIDCMP:=Shl(1,g_portIDCMP.sigbit)

EXCEPT
	success:=DO_ERROR
	IF exception<>E_REQTOOLS
		request(g_error[exception],g_decision[D_OK],NIL)
	ELSE
		tattr:=g_prefs.reqtattr
		AutoRequest(g_oldreqwin,
			[0,1,0,10,tattr.ysize+2,tattr,'Benötige Reqtools.library V38+',
			[0,1,0,10,20,tattr.ysize*2+2,'im Verzeichnis "libs:" !',NIL]:intuitext]:intuitext,
			[2,1,0,6,3,tattr,'OK',NIL]:intuitext,
			[2,1,0,6,3,tattr,'OK',NIL]:intuitext,
			0,0,320,70)
	ENDIF		
	closeall()
ENDPROC success


PROC closeall()
	IF g_portIDCMP<>NIL THEN deletePort(g_portIDCMP) 
	IF reqtoolsbase<>NIL THEN CloseLibrary(reqtoolsbase)
ENDPROC


PROC getBitmap(width,height,depth) HANDLE
	RAISE	E_MEM IF New()=NIL,
			E_MEM IF AllocRaster()=NIL

	DEF i,bm:PTR TO bitmap,pl:PTR TO LONG,memnr

	memnr:=MEM_BITMAP
	bm:=New(SIZEOF bitmap+4)
	InitBitMap(bm,depth,width,height)
	PutLong(bm+SIZEOF bitmap,width)

	pl:=bm.planes
	memnr:=MEM_PLANE
	FOR i:=0 TO depth-1 DO pl[i]:=AllocRaster(width,height)
EXCEPT
	deleteBitmap(bm)
	IF exception<>E_NONE THEN request(g_error[exception],g_decision[D_OK],[g_memerror[memnr]])
	bm:=NIL
ENDPROC bm


PROC deleteBitmap(bm:PTR TO bitmap)
	DEF i,pl:PTR TO LONG,width,height

	IF bm<>NIL
		width:=Long(bm+SIZEOF bitmap)
		height:=bm.rows
		pl:=bm.planes
		FOR i:=0 TO bm.depth-1
			IF pl[i]<>NIL THEN FreeRaster(pl[i],width,height)
		ENDFOR
		Dispose(bm)
	ENDIF
ENDPROC


PROC getRPort(bm:PTR TO bitmap) HANDLE
	RAISE	E_MEM IF New()=NIL,
			E_MEM IF AllocRaster()=NIL

	DEF rp:PTR TO rastport

	rp:=New(SIZEOF rastport+8)
	IF (g_tmpras=NIL) OR (g_areainfo=NIL) THEN Raise(E_NONE)

	InitRastPort(rp)

	rp.bitmap:=bm
	rp.tmpras:=g_tmpras
	rp.areainfo:=g_areainfo
EXCEPT
	deleteRPort(rp)
	IF exception<>E_NONE THEN request(g_error[exception],g_decision[D_OK],[g_memerror[MEM_RPORT]])
	rp:=NIL
ENDPROC rp


PROC deleteRPort(rp:PTR TO rastport)	
	IF rp<>NIL
		Dispose(rp)
	ENDIF
ENDPROC


PROC openVisuals(rport,punktanz) HANDLE
/* öffnet alle sichtbaren Ressourcen

	rp			muß ein Zeiger auf ein Rastport sein - dorthin wird die 
				Adresse des sichtbaren Rastports geschrieben
	punktanz	gibt die maximale Anzahl von Punkten für ein gefülltes
				Polygon an; eine dementsprechende areainfo-Struktur wird
				angelegt und steht für das Anhängen an beliebige Rastports
				zur Verfügung (g_areainfo)
				außerdem wird g_tmpras angelegt
*/

	RAISE	E_SCR IF OpenScreen()=NIL,
			E_SCR IF OpenScreenTagList()=NIL,
			E_WIN IF OpenWindow()=NIL,
			E_MEM IF AllocRaster()=NIL,
			E_MEM IF New()=NIL

	DEF success=DO_OK,rp:PTR TO rastport,memnr

	IF KickVersion(37)
		g_scr:=OpenScreenTagList(NIL,
			[SA_PENS,[0,0,1,2,1,3,1,-1]:INT,
			SA_WIDTH,g_prefs.scrwidth,
			SA_HEIGHT,g_prefs.scrheight,
			SA_DEPTH,g_prefs.scrdepth,
			SA_TYPE,CUSTOMSCREEN,
			SA_DISPLAYID,(PAL_MONITOR_ID OR g_prefs.scrdisplayid),
			SA_TITLE,g_progname,
			TAG_DONE])
	ELSE
		g_scr:=OpenS(g_prefs.scrwidth,g_prefs.scrheight,g_prefs.scrdepth,
			g_prefs.scrdisplayid,g_progname)
	ENDIF
	setupColors(g_scr)
	
	g_win:=OpenW(0,0,g_scr.width,g_scr.height,
			0,BD_WFLG,NIL,g_scr,CUSTOMSCREEN,NIL)

	g_win.userport:=g_portIDCMP
	ModifyIDCMP(g_win,BD_IDCMP)
	setProcWindow(g_win)
	SetWindowTitles(g_win,-1,g_progname)
	
	memnr:=MEM_RAS
	g_tmpmem:=AllocRaster(g_prefs.scrwidth,g_prefs.scrheight)
	InitTmpRas(g_tmpras,g_tmpmem,Shr(g_prefs.scrwidth*g_prefs.scrheight,3))

	memnr:=MEM_AREA
	g_areamem:=New(punktanz*10)		/* zu jedem Punkt max 1 AreaEnd-Befehl */
	InitArea(g_areainfo,g_areamem,punktanz)

	rp:=g_win.rport
	rp.tmpras:=g_tmpras
	rp.areainfo:=g_areainfo
	SetRast(rp,2)

	^rport:=rp
EXCEPT
	closeVisuals()
	IF exception<>E_NONE THEN request(g_error[exception],g_decision[D_OK],[g_memerror[memnr]])
	g_scr:=NIL;g_win:=NIL
	^rport:=NIL
	success:=DO_ERROR
ENDPROC success


PROC closeVisuals()
	IF g_areamem<>NIL
		Dispose(g_areamem)
		g_areamem:=NIL
	ENDIF

	IF g_tmpmem<>NIL
		FreeRaster(g_tmpmem,g_prefs.scrwidth,g_prefs.scrheight)
		g_tmpmem:=NIL
	ENDIF

	IF g_win<>NIL
		setProcWindow(g_oldreqwin)
		RtCloseWindowSafely(g_win)
		g_win:=NIL
	ENDIF
	IF g_scr<>NIL
		CloseS(g_scr)
		g_scr:=NIL
	ENDIF
ENDPROC


PROC setupColors(scr:PTR TO screen)
	DEF i
	LoadRGB4(scr.viewport,
		[$0aaa,$0000,$0fff,$068b]:INT,4)
	FOR i:=3 TO 14 DO SetRGB4(scr.viewport,i+1,i,i,i)
ENDPROC


PROC setupSinCos()
	/*	Wertetabellen für Sinus & Cosinus
		Winkelbereich     0-360 
		Anzahl der Werte  512
		Amplitude         2048
		Offset            0
	*/

	g_sin:=[$000D,$0026,$003F,$0058,$0071,$008A,$00A3,$00BC,$00D5,$00EE,
	$0107,$0120,$0139,$0152,$016B,$0183,$019C,$01B4,$01CD,$01E5,
	$01FE,$0216,$022E,$0246,$025F,$0276,$028E,$02A6,$02BE,$02D5,
	$02ED,$0304,$031B,$0332,$0349,$0360,$0377,$038E,$03A4,$03BA,
	$03D0,$03E7,$03FC,$0412,$0428,$043D,$0452,$0467,$047C,$0491,
	$04A6,$04BA,$04CE,$04E2,$04F6,$0509,$051D,$0530,$0543,$0556,
	$0569,$057B,$058D,$059F,$05B1,$05C3,$05D4,$05E5,$05F6,$0607,
	$0617,$0627,$0637,$0647,$0656,$0665,$0674,$0683,$0692,$06A0,
	$06AE,$06BC,$06C9,$06D6,$06E3,$06F0,$06FC,$0708,$0714,$0720,
	$072B,$0736,$0741,$074B,$0755,$075F,$0769,$0772,$077B,$0784,
	$078C,$0795,$079D,$07A4,$07AB,$07B2,$07B9,$07C0,$07C6,$07CB,
	$07D1,$07D6,$07DB,$07E0,$07E4,$07E8,$07EC,$07EF,$07F2,$07F5,
	$07F7,$07F9,$07FB,$07FD,$07FE,$07FF,$0800,$0800,$0800,$0800,
	$07FF,$07FE,$07FD,$07FB,$07F9,$07F7,$07F5,$07F2,$07EF,$07EC,
	$07E8,$07E4,$07E0,$07DB,$07D6,$07D1,$07CB,$07C6,$07C0,$07B9,
	$07B2,$07AB,$07A4,$079D,$0795,$078C,$0784,$077B,$0772,$0769,
	$075F,$0755,$074B,$0741,$0736,$072B,$0720,$0714,$0708,$06FC,
	$06F0,$06E3,$06D6,$06C9,$06BC,$06AE,$06A0,$0692,$0683,$0674,
	$0665,$0656,$0647,$0637,$0627,$0617,$0607,$05F6,$05E5,$05D4,
	$05C3,$05B1,$059F,$058D,$057B,$0569,$0556,$0543,$0530,$051D,
	$0509,$04F6,$04E2,$04CE,$04BA,$04A6,$0491,$047C,$0467,$0452,
	$043D,$0428,$0412,$03FC,$03E6,$03D0,$03BA,$03A4,$038E,$0377,
	$0360,$0349,$0332,$031B,$0304,$02ED,$02D5,$02BE,$02A6,$028E,
	$0276,$025F,$0246,$022E,$0216,$01FE,$01E5,$01CD,$01B4,$019C,
	$0183,$016A,$0152,$0139,$0120,$0107,$00EE,$00D5,$00BC,$00A3,
	$008A,$0071,$0058,$003F,$0026,$000D,$FFF3,$FFDA,$FFC1,$FFA8,
	$FF8F,$FF76,$FF5D,$FF44,$FF2B,$FF12,$FEF9,$FEE0,$FEC7,$FEAE,
	$FE95,$FE7D,$FE64,$FE4C,$FE33,$FE1B,$FE02,$FDEA,$FDD2,$FDBA,
	$FDA1,$FD8A,$FD72,$FD5A,$FD42,$FD2B,$FD13,$FCFC,$FCE5,$FCCE,
	$FCB7,$FCA0,$FC89,$FC72,$FC5C,$FC46,$FC30,$FC19,$FC04,$FBEE,
	$FBD8,$FBC3,$FBAE,$FB99,$FB84,$FB6F,$FB5A,$FB46,$FB32,$FB1E,
	$FB0A,$FAF6,$FAE3,$FAD0,$FABD,$FAAA,$FA97,$FA85,$FA73,$FA61,
	$FA4F,$FA3D,$FA2C,$FA1B,$FA0A,$F9F9,$F9E9,$F9D9,$F9C9,$F9B9,
	$F9AA,$F99B,$F98C,$F97D,$F96E,$F960,$F952,$F944,$F937,$F92A,
	$F91D,$F910,$F904,$F8F8,$F8EC,$F8E0,$F8D5,$F8CA,$F8BF,$F8B5,
	$F8AB,$F8A1,$F897,$F88E,$F885,$F87C,$F874,$F86B,$F863,$F85C,
	$F855,$F84E,$F847,$F840,$F83A,$F835,$F82F,$F82A,$F825,$F820,
	$F81C,$F818,$F814,$F811,$F80E,$F80B,$F809,$F807,$F805,$F803,
	$F802,$F801,$F800,$F800,$F800,$F800,$F801,$F802,$F803,$F805,
	$F807,$F809,$F80B,$F80E,$F811,$F814,$F818,$F81C,$F820,$F825,
	$F82A,$F82F,$F835,$F83A,$F840,$F847,$F84E,$F855,$F85C,$F863,
	$F86B,$F874,$F87C,$F885,$F88E,$F897,$F8A1,$F8AB,$F8B5,$F8BF,
	$F8CA,$F8D5,$F8E0,$F8EC,$F8F8,$F904,$F910,$F91D,$F92A,$F937,
	$F945,$F952,$F960,$F96E,$F97D,$F98C,$F99B,$F9AA,$F9B9,$F9C9,
	$F9D9,$F9E9,$F9F9,$FA0A,$FA1B,$FA2C,$FA3D,$FA4F,$FA61,$FA73,
	$FA85,$FA97,$FAAA,$FABD,$FAD0,$FAE3,$FAF7,$FB0A,$FB1E,$FB32,
	$FB46,$FB5B,$FB6F,$FB84,$FB99,$FBAE,$FBC3,$FBD8,$FBEE,$FC04,
	$FC1A,$FC30,$FC46,$FC5C,$FC72,$FC89,$FCA0,$FCB7,$FCCE,$FCE5,
	$FCFC,$FD13,$FD2B,$FD42,$FD5A,$FD72,$FD8A,$FDA2,$FDBA,$FDD2,
	$FDEA,$FE02,$FE1B,$FE33,$FE4C,$FE64,$FE7D,$FE96,$FEAE,$FEC7,
	$FEE0,$FEF9,$FF12,$FF2B,$FF44,$FF5D,$FF76,$FF8F,$FFA8,$FFC1,
	$FFDA,$FFF3]:INT

	g_cos:=[$0800,$0800,$07FF,$07FE,$07FD,$07FB,$07F9,$07F7,$07F5,$07F2,
	$07EF,$07EC,$07E8,$07E4,$07E0,$07DB,$07D6,$07D1,$07CB,$07C6,
	$07C0,$07B9,$07B2,$07AB,$07A4,$079D,$0795,$078C,$0784,$077B,
	$0772,$0769,$075F,$0755,$074B,$0741,$0736,$072B,$0720,$0714,
	$0708,$06FC,$06F0,$06E3,$06D6,$06C9,$06BC,$06AE,$06A0,$0692,
	$0683,$0674,$0665,$0656,$0647,$0637,$0627,$0617,$0607,$05F6,
	$05E5,$05D4,$05C3,$05B1,$059F,$058D,$057B,$0569,$0556,$0543,
	$0530,$051D,$0509,$04F6,$04E2,$04CE,$04BA,$04A6,$0491,$047C,
	$0467,$0452,$043D,$0428,$0412,$03FC,$03E6,$03D0,$03BA,$03A4,
	$038E,$0377,$0360,$0349,$0332,$031B,$0304,$02ED,$02D5,$02BE,
	$02A6,$028E,$0276,$025F,$0246,$022E,$0216,$01FE,$01E5,$01CD,
	$01B4,$019C,$0183,$016A,$0152,$0139,$0120,$0107,$00EE,$00D5,
	$00BC,$00A3,$008A,$0071,$0058,$003F,$0026,$000D,$FFF3,$FFDA,
	$FFC1,$FFA8,$FF8F,$FF76,$FF5D,$FF44,$FF2B,$FF12,$FEF9,$FEE0,
	$FEC7,$FEAE,$FE95,$FE7D,$FE64,$FE4C,$FE33,$FE1B,$FE02,$FDEA,
	$FDD2,$FDBA,$FDA1,$FD8A,$FD72,$FD5A,$FD42,$FD2B,$FD13,$FCFC,
	$FCE5,$FCCE,$FCB7,$FCA0,$FC89,$FC72,$FC5C,$FC46,$FC30,$FC19,
	$FC04,$FBEE,$FBD8,$FBC3,$FBAE,$FB99,$FB84,$FB6F,$FB5A,$FB46,
	$FB32,$FB1E,$FB0A,$FAF6,$FAE3,$FAD0,$FABD,$FAAA,$FA97,$FA85,
	$FA73,$FA61,$FA4F,$FA3D,$FA2C,$FA1B,$FA0A,$F9F9,$F9E9,$F9D9,
	$F9C9,$F9B9,$F9AA,$F99B,$F98C,$F97D,$F96E,$F960,$F952,$F944,
	$F937,$F92A,$F91D,$F910,$F904,$F8F8,$F8EC,$F8E0,$F8D5,$F8CA,
	$F8BF,$F8B5,$F8AB,$F8A1,$F897,$F88E,$F885,$F87C,$F874,$F86B,
	$F863,$F85C,$F855,$F84E,$F847,$F840,$F83A,$F835,$F82F,$F82A,
	$F825,$F820,$F81C,$F818,$F814,$F811,$F80E,$F80B,$F809,$F807,
	$F805,$F803,$F802,$F801,$F800,$F800,$F800,$F800,$F801,$F802,
	$F803,$F805,$F807,$F809,$F80B,$F80E,$F811,$F814,$F818,$F81C,
	$F820,$F825,$F82A,$F82F,$F835,$F83A,$F840,$F847,$F84E,$F855,
	$F85C,$F863,$F86B,$F874,$F87C,$F885,$F88E,$F897,$F8A1,$F8AB,
	$F8B5,$F8BF,$F8CA,$F8D5,$F8E0,$F8EC,$F8F8,$F904,$F910,$F91D,
	$F92A,$F937,$F945,$F952,$F960,$F96E,$F97D,$F98C,$F99B,$F9AA,
	$F9B9,$F9C9,$F9D9,$F9E9,$F9F9,$FA0A,$FA1B,$FA2C,$FA3D,$FA4F,
	$FA61,$FA73,$FA85,$FA97,$FAAA,$FABD,$FAD0,$FAE3,$FAF7,$FB0A,
	$FB1E,$FB32,$FB46,$FB5B,$FB6F,$FB84,$FB99,$FBAE,$FBC3,$FBD8,
	$FBEE,$FC04,$FC1A,$FC30,$FC46,$FC5C,$FC72,$FC89,$FCA0,$FCB7,
	$FCCE,$FCE5,$FCFC,$FD13,$FD2B,$FD42,$FD5A,$FD72,$FD8A,$FDA2,
	$FDBA,$FDD2,$FDEA,$FE02,$FE1B,$FE33,$FE4C,$FE64,$FE7D,$FE96,
	$FEAE,$FEC7,$FEE0,$FEF9,$FF12,$FF2B,$FF44,$FF5D,$FF76,$FF8F,
	$FFA8,$FFC1,$FFDA,$FFF3,$000D,$0026,$003F,$0058,$0071,$008A,
	$00A3,$00BC,$00D5,$00EE,$0107,$0120,$0139,$0152,$016B,$0183,
	$019C,$01B4,$01CD,$01E5,$01FE,$0216,$022E,$0246,$025F,$0277,
	$028E,$02A6,$02BE,$02D5,$02ED,$0304,$031B,$0332,$0349,$0360,
	$0377,$038E,$03A4,$03BA,$03D1,$03E7,$03FC,$0412,$0428,$043D,
	$0452,$0467,$047C,$0491,$04A6,$04BA,$04CE,$04E2,$04F6,$050A,
	$051D,$0530,$0543,$0556,$0569,$057B,$058D,$059F,$05B1,$05C3,
	$05D4,$05E5,$05F6,$0607,$0617,$0627,$0637,$0647,$0656,$0665,
	$0674,$0683,$0692,$06A0,$06AE,$06BC,$06C9,$06D6,$06E3,$06F0,
	$06FC,$0708,$0714,$0720,$072B,$0736,$0741,$074B,$0755,$075F,
	$0769,$0772,$077B,$0784,$078C,$0795,$079D,$07A4,$07AB,$07B2,
	$07B9,$07C0,$07C6,$07CB,$07D1,$07D6,$07DB,$07E0,$07E4,$07E8,
	$07EC,$07EF,$07F2,$07F5,$07F7,$07F9,$07FB,$07FD,$07FE,$07FF,
	$0800,$0800]:INT
ENDPROC
