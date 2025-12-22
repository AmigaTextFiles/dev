2:PTR TO p2d,ep:PTR TO LONG,
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
			IF setElement(o,i,NIL,1,[y*b+x,(y-1)*b+x]:LONG)<>DO_OK THEN Raise