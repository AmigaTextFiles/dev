// This example RayTraces an image and saves it in targa format as 24bit image
// This example requires AGA and FPU or PPC

OPT	OPTIMIZE	//,IEEE

CONST	WIDTH=800,HEIGHT=600
//#define GFX_OUTPUT

MODULE	'intuition/intuition',
			'intuition/screens',
			'graphics/modeid',
			'utility/tagitem'
MODULE	'graphics/rastport'
MODULE	'exec/memory',			// for saving
			'dos/dos'

OBJECT Scene
	Objects:PTR TO Object,
	Lights:PTR TO Light,
	Iar:FLOAT,						// global ambient intensity
	Iag:FLOAT,						// global ambient intensity
	Iab:FLOAT,						// global ambient intensity
	FogLength:FLOAT				// max visible distance in the fog

OBJECT Object
	x:FLOAT,			// position for sphere, normal for plane
	y:FLOAT,
	z:FLOAT,
	r:FLOAT,			// radius for sphere, offset for plane
	ir:FLOAT,			// intensity (0-1)
	ig:FLOAT,			// intensity (0-1)
	ib:FLOAT,			// intensity (0-1)
	ri:FLOAT,		// reflection intensity (0-1)
	ra:FLOAT,		// ambient intensity (0-1)
	h:UWORD,
	type:UWORD,		// OT...
	Next:PTR TO Object,
	Surface:UWORD

OBJECT PolyObject
	x:FLOAT,			// position for sphere, normal for plane
	y:FLOAT,
	z:FLOAT,
	r:FLOAT,			// radius for sphere, offset for plane
	ir:FLOAT,			// intensity (0-1)
	ig:FLOAT,			// intensity (0-1)
	ib:FLOAT,			// intensity (0-1)
	ri:FLOAT,		// reflection intensity (0-1)
	ra:FLOAT,		// ambient intensity (0-1)
	h:UWORD,
	type:UWORD,		// OT...
	Next:PTR TO Object,
	Surface:UWORD,
	Poly:PTR TO Vector,
	Count:LONG

OBJECT Light
	x:FLOAT,
	y:FLOAT,
	z:FLOAT,
	ir:FLOAT,			// intensity
	ig:FLOAT,			// intensity
	ib:FLOAT,			// intensity
	Next:PTR TO Light

OBJECT Vector
	x:FLOAT,
	y:FLOAT,
	z:FLOAT

OBJECT Vector2D
	x:FLOAT,
	y:FLOAT

OBJECT Line
	x|x0:FLOAT,
	y|y0:FLOAT,
	z|z0:FLOAT,
	u|vx:FLOAT,
	v|vy:FLOAT,
	w|vz:FLOAT

OBJECT Plane
	a:FLOAT,
	b:FLOAT,
	c:FLOAT,
	d:FLOAT

OBJECT Intersection
	nx:FLOAT,				// normal
	ny:FLOAT,
	nz:FLOAT,
	x:FLOAT,					// position
	y:FLOAT,
	z:FLOAT,
	t:FLOAT					// parameter

OBJECT RGB
	r:UBYTE,
	g:UBYTE,
	b:UBYTE

OBJECT BGR					// for targa saving
	b:UBYTE,
	g:UBYTE,
	r:UBYTE

OBJECT RImage
	Width:LONG,
	Height:LONG,
	Pixel:PTR TO RGB,
	ZBuffer:PTR TO FLOAT,
	Antialias:PTR TO UBYTE

ENUM	OT_Sphere,
		OT_IPlane,			// infinite
		OT_PolyObject

ENUM	SURFACE_None,
		SURFACE_Stripes,
		SURFACE_Checks,
		SURFACE_Dots

PROC Gen(image:PTR TO RImage,rp:PTR TO RastPort)
	DEFF	x,y,scene:PTR TO Scene,o:PTR TO Object,l:PTR TO Light
	DEFF	r,g,b
	DEF	ds:DateStamp,ir,ig,ib
	DEF	ix,iy
	o:=[-100.0,-20.0,100.0, 20.0, 1.0,0.2,0.2, 0.0,0.1,6,OT_Sphere,NIL,SURFACE_None]:Object
	o:=[ -60.0, 80.0, 80.0, 60.0, 0.8,0.7,0.6, 0.0,1.0,4,OT_Sphere,o,SURFACE_None]:Object
	o:=[   0.0,  0.0,  0.0, 40.0, 0.6,0.7,0.8, 0.0,1.0,5,OT_Sphere,o,SURFACE_None]:Object
	o:=[ 120.0,  0.0,  0.0, 30.0, 1.0,1.0,1.0, 0.8,0.4,3,OT_Sphere,o,SURFACE_None]:Object
	o:=[ -40.0, 20.0,100.0, 15.0, 0.4,0.6,0.8, 0.6,0.2,7,OT_Sphere,o,SURFACE_None]:Object
	o:=[  20.0, 40.0, 60.0, 25.0, 0.8,0.6,0.4, 0.2,0.3,5,OT_Sphere,o,SURFACE_None]:Object
	o:=[   0.0, -1.0,  0.1, 80.0, 0.0,0.3,0.6, 0.0,0.5,4,OT_IPlane,o,SURFACE_Checks]:Object
//	o:=[   0.0,  0.0,  1.0, 70.0, 0.3,0.3,0.2, 0.0,0.5,4,OT_PolyObject,o,SURFACE_Stripes,[0.0,-50.0,0.0,80.0,-60.0,0.0,100.0,100.0,0.0,-50.0,50.0,0.0]:Vector,4]:PolyObject
/*
	o:=[   0.0,  0.0,  0.0,  0.0, 1.0,1.0,1.0, 0.0,0.5,4,OT_PolyObject,o,SURFACE_Checks,
			[-100.0, -60.0, 50.0,
			  -50.0, -60.0, 50.0,
			  -50.0, -10.0, 20.0,
			 -100.0, -10.0, 20.0]:Vector,4]:PolyObject
*/
/*
	o:=[   0.0,  1.0,  0.0,  0.0, 0.3,0.3,0.2, 0.0,0.5,4,OT_PolyObject,o,SURFACE_Checks,
			[-100.0, -60.0,  0.0,
			  -50.0, -60.0,  0.0,
			  -50.0, -10.0,  0.0,
			 -100.0, -10.0,  0.0]:Vector,4]:PolyObject
*/
	l:=[ -60.0, -40.0, 150.0,0.8,0.9,1.0,NIL]:Light
	l:=[  80.0,   0.0,  20.0,0.5,0.2,1.0,l]:Light
	l:=[  80.0,-250.0,-150.0,0.6,0.6,0.6,l]:Light
	l:=[ 120.0, -50.0, 150.0,0.5,0.8,0.4,l]:Light
	scene:=[o,l,0.0,0.0,0.0,10000.0]:Scene

	DateStamp(ds)
	s_startday:=ds.Days
	s_startmin:=ds.Minute
	s_starttick:=ds.Tick

	FOR iy:=0 TO image.Height-1 STEP 1
		y:=iy-image.Height/2
		FOR ix:=0 TO image.Width-1 STEP 1
			x:=ix-image.Width/2
			r,g,b:=RayTrace(scene,[0.0,0.0,1000.0,x*320/image.Width,y*240/image.Height,-1000.0]:Line)
			ir,ig,ib:=RPlot(image,ix,iy,r,g,b)
			IF rp && (ir+ig+ib)>0
				SetAPen(rp,ir/4)
				WritePixel(rp,ix*2,iy*2)
				SetAPen(rp,ig/4+64)
				WritePixel(rp,ix*2+1,iy*2)
				SetAPen(rp,ib/4+128)
				WritePixel(rp,ix*2,iy*2+1)
				SetAPen(rp,(ir/4+ig/4+ib/4)/3+192)
				WritePixel(rp,ix*2+1,iy*2+1)
			ENDIF
//			IF x\10=0 THEN PrintF(' \d[3],\d[3]\b',ix,iy)
		ENDFOR
		IF Mouse()=3 THEN RETURN	// only to skip Antialias()
		IF rp
			SetAPen(rp,255)
			WritePixel(rp,0,iy*2)
		ELSE PrintF('RayTracing: \d/\d\b',ir:=iy,image.Height)
	ENDFOR
	IF rp=NIL THEN PrintF('\n')

	Antialias(rp,image,scene)
/*
	DEFF	c
	c:=RayTrace(scene,[-10.0,0.0,1000.0,0.0,-30.0,-1000.0]:Line)
	PrintF('fff: $\z\h[8]\n',c)
*/
ENDPROC

// here follows global statistical variables
DEFL	s_raycount=0,
		s_interattemps=0,
		s_intersections=0,
		s_raysinfog=0,
		s_reflectedrays=0,
		s_antialias4=0,
		s_antialias9=0,
		s_antialias16=0,
		s_antialias25=0,
		s_startday,s_startmin,s_starttick,
		s_stopday,s_stopmin,s_stoptick

PROC RayTrace(scene:PTR TO Scene,line:PTR TO Line,level=0)(FLOAT,FLOAT,FLOAT)
	DEF	object:PTR TO Object,
			zobj=NIL:PTR TO Object,
			light:PTR TO Light
	DEFF	Ivr=0.0,						// vysledna intenzita
			Ivg=0.0,
			Ivb=0.0,
			Is=0.0,						// intenzita zrcadlove slozky
			q,qr,qg,qb
	DEFF	t,tott=1000000.0,
			tobj=NIL:PTR TO Object,
			inter:Intersection
	DEF	shadow:BOOL,n
	DEF	r:Vector,	// reflected vector
			l:Vector		// vector light-point
	s_raycount++
	object:=scene.Objects
	WHILE object
		s_interattemps++
		IF object.type=OT_Sphere
			t:=IntersectSphere(NIL,line,object)
		ELSEIF object.type=OT_IPlane
			t:=IntersectPlane(NIL,line,object)
		ELSEIF object.type=OT_PolyObject
			t:=IntersectPolyObject(NIL,line,object)
		ENDIF
//		PrintF('001: $\z\h[8],$\z\h[8]\n',t,object.r)
		IF t
			IF t<tott
				tott:=t
				tobj:=object
			ENDIF
		ENDIF
		object:=object.Next
	ENDWHILE
	IF scene.FogLength
		IF tott>scene.FogLength
			s_raysinfog++
			RETURN scene.Iar,scene.Iag,scene.Iab
		ENDIF
	ENDIF
	IF tobj
		s_intersections++
		IF tobj.type=OT_Sphere
			IntersectSphere(inter,line,tobj)
		ELSEIF tobj.type=OT_IPlane
			IntersectPlane(inter,line,tobj)
		ELSEIF tobj.type=OT_PolyObject
			IntersectPolyObject(inter,line,tobj)
		ENDIF
//		PrintF('      t: $\z\h[8],$\z\h[8]\n',tott,tobj.r)
//		PrintF('normala: $\z\h[8],$\z\h[8],$\z\h[8]\n',inter.nx,inter.ny,inter.nz)
//		PrintF(' pozice: $\z\h[8],$\z\h[8],$\z\h[8]\n',inter.x,inter.y,inter.z)
		light:=scene.Lights
		WHILE light
			l.x:=light.x-inter.x
			l.y:=light.y-inter.y
			l.z:=light.z-inter.z
			shadow:=FALSE
			object:=scene.Objects
			WHILE object
				IF object<>tobj
					s_interattemps++
					IF object.type=OT_Sphere
						t:=IntersectSphere(NIL,[inter.x,inter.y,inter.z,l.x,l.y,l.z]:Line,object)
					ELSEIF object.type=OT_IPlane
						t:=IntersectPlane(NIL,[inter.x,inter.y,inter.z,l.x,l.y,l.z]:Line,object)
					ELSEIF object.type=OT_PolyObject
						t:=IntersectPolyObject(NIL,[inter.x,inter.y,inter.z,l.x,l.y,l.z]:Line,object)
					ENDIF
//					PrintF('r $\z\h[8],$\z\h[8]\n',t,object.r)
					IF t
						s_intersections++
						shadow:=TRUE
					ENDIF
				ENDIF
				object:=object.Next
			EXITIF shadow=TRUE
			ENDWHILE
//			PrintF('n')
//			PrintF('normala: $\z\h[8],$\z\h[8],$\z\h[8],\d\n',inter.nx,inter.ny,inter.nz,shadow)
			IF shadow=FALSE
				IF (q:=VectorAngle(inter,l))>0.0
//					PrintF('surface: $\z\h[8],$\z\h[8],$\z\h[8],\d\n',inter.x,inter.y,inter.z,shadow)
					qr,qg,qb:=Surface(tobj.Surface,inter.x,inter.y,inter.z,tobj.ir,tobj.ig,tobj.ib)
//					PrintF('colours: $\z\h[8],$\z\h[8],$\z\h[8],\d\n',qr,qg,qb,shadow)
					Ivr+=light.ir*q*qr
					Ivg+=light.ig*q*qg
					Ivb+=light.ib*q*qb
				ENDIF
				Reflect3D(r,inter,l)
				IF (q:=VectorAngle(r,[line.u,line.v,line.w]:Vector))>0.0
					IF tobj.h>1
						FOR n:=1 TO tobj.h
							q*=q
						ENDFOR
					ENDIF
					Ivr+=light.ir*q
					Ivg+=light.ig*q
					Ivb+=light.ib*q
				ENDIF
			ENDIF
			light:=light.Next
		ENDWHILE
//		PrintF('intensity: $\z\h[8],$\z\h[8]\n',Ivr,tobj.r)
		IF level<4
//			PrintF(' object: $\z\h[8],$\z\h[8]\n',tobj.ri,tobj.r)
			IF tobj.ri
				s_reflectedrays++
				Reflect3D(r,inter,[line.u,line.v,line.w]:Vector)
				qr,qg,qb:=RayTrace(scene,[inter.x,inter.y,inter.z,r.x,r.y,r.z]:Line,level+1)
				Ivr:=Ivr*(1.0-tobj.ri)/1.0+tobj.ri*qr/1.0
				Ivg:=Ivg*(1.0-tobj.ri)/1.0+tobj.ri*qg/1.0
				Ivb:=Ivb*(1.0-tobj.ri)/1.0+tobj.ri*qb/1.0
//				PrintF('reflect: $\z\h[8],$\z\h[8]\n',q,Ivr)
			ENDIF
		ENDIF
//		PrintF('intensity: $\z\h[8],$\z\h[8]\n',Ivr,tobj.r)
//		PrintF('surface2: $\z\h[8],$\z\h[8],$\z\h[8],\d\n',inter.x,inter.y,inter.z,shadow)
		qr,qg,qb:=Surface(tobj.Surface,inter.x,inter.y,inter.z,tobj.ir,tobj.ig,tobj.ib)
//		PrintF('colours2: $\z\h[8],$\z\h[8],$\z\h[8],\d\n',qr,qg,qb,tobj.r)
		Ivr+=scene.Iar*qr*tobj.ra
		Ivg+=scene.Iag*qg*tobj.ra
		Ivb+=scene.Iab*qb*tobj.ra
		IF Ivr>1.0 THEN Ivr:=1.0
		IF Ivr<0.0 THEN Ivr:=0.0
		IF Ivg>1.0 THEN Ivg:=1.0
		IF Ivg<0.0 THEN Ivg:=0.0
		IF Ivb>1.0 THEN Ivb:=1.0
		IF Ivb<0.0 THEN Ivb:=0.0
		IF scene.FogLength
			q:=tott/scene.FogLength
			Ivr:=scene.Iar*q+Ivr*(1.0-q)
			Ivg:=scene.Iag*q+Ivg*(1.0-q)
			Ivb:=scene.Iab*q+Ivb*(1.0-q)
		ENDIF
		RETURN Ivr,Ivg,Ivb
	ELSE
		s_raysinfog++
		RETURN scene.Iar,scene.Iag,scene.Iab
	ENDIF
ENDPROC 1.0,1.0,1.0

PROC VectorAngle(a:PTR TO Vector,b:PTR TO Vector)(FLOAT)
	DEFF	r
//	r:=(a.x*b.x+a.y*b.y+a.z*b.z)/(Sqrt(a.x*a.x+a.y*a.y+a.z*a.z)*Sqrt(b.x*b.x+b.y*b.y+b.z*b.z))
	r:=(a.x*b.x+a.y*b.y+a.z*b.z)/(Sqrt((a.x*a.x+a.y*a.y+a.z*a.z)*(b.x*b.x+b.y*b.y+b.z*b.z)))
ENDPROC r

PROC VectorSize(a:PTR TO Vector)(FLOAT)
	DEFF	r
	r:=Sqrt(a.x*a.x+a.y*a.y+a.z*a.z)
ENDPROC r

PROC ResizeVector(a:PTR TO Vector,l:FLOAT)
	DEFF	d
	d:=l/VectorSize(a)
//	PrintF('$\z\h[8]\n',d)
	a.x*=d
	a.y*=d
	a.z*=d
ENDPROC

PROC LineDistance(line:PTR TO Line,point:PTR TO Vector)(FLOAT)
	DEFF	plane:Plane,d,inter:Vector
	plane.a:=line.vx								// vytvoreni roviny kolme na danou primku
	plane.b:=line.vy
	plane.c:=line.vz
	plane.d:=point.x*plane.a+point.y*plane.b+point.z*plane.c
	plane.d:=-plane.d
//	PrintF('$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8]\n',plane.a,plane.b,plane.c,plane.d)
	PlaneIntersection(inter,line,plane)
//	PrintF('$\z\h[8],$\z\h[8],$\z\h[8]\n',inter.x,inter.y,inter.z)
	d:=PointDistance(inter,point)
//	PrintF('$\z\h[8]\n',d)
ENDPROC d

// tato funkce vypocita vzdalenost bodu od plochy v prostoru
PROC PlaneDistance(plane:PTR TO Plane,point:PTR TO Vector)(FLOAT)
	DEFF	a,b,c,d
	a:=plane.a
	b:=plane.b
	c:=plane.c
	d:=Sqrt(a*a+b*b+c*c)
	IF d
		d:=FAbs(a*point.x+b*point.y+c*point.z+plane.d)/d
	ENDIF
ENDPROC d

// tato funkce vypocita prusecik plochy a primky v prostoru
PROC PlaneIntersection(dst:PTR TO Vector,line:PTR TO Line,plane:PTR TO Plane)(FLOAT,FLOAT,FLOAT)
	DEFF	x,y,z,t,a,b,c
	a:=plane.a
	b:=plane.b
	c:=plane.c
	t:=(a*line.u+b*line.v+c*line.w)
//	PrintF('$\z\h[8],$\z\h[8],$\z\h[8]\n',a,b,c)
	IF t
		t:=-(a*line.x0+b*line.y0+c*line.z0+plane.d)/t
	ENDIF
	x:=line.x0+line.u*t
	y:=line.y0+line.v*t
	z:=line.z0+line.w*t
//	PrintF('$\z\h[8]\n',t)
//	PrintF('$\z\h[8],$\z\h[8],$\z\h[8]\n',x,y,z)
	IF dst
		dst.x:=x
		dst.y:=y
		dst.z:=z
	ENDIF
ENDPROC x,y,z

// tatu funkce vraci parametr, na kterem dochazi k pruniku
PROC PlaneIntersectionParameter(line:PTR TO Line,plane:PTR TO Plane)(FLOAT)
	DEFF	t,a,b,c
	a:=plane.a
	b:=plane.b
	c:=plane.c
//	PrintF('a,b,c: $\z\h[8],$\z\h[8],$\z\h[8]\n',a,b,c)
	t:=(a*line.u+b*line.v+c*line.w)
//	PrintF('t1: $\z\h[8]\n',t)
	IF t
//		PrintF('t2: $\z\h[8]\n',t)
		t:=-(a*line.x0+b*line.y0+c*line.z0+plane.d)/t
		IF t<=0.0 THEN RETURN 0.0
	ENDIF
ENDPROC t

// tato funkce vypocita vzdalenost mezi dvema body v prostoru
PROC PointDistance(a:PTR TO Vector,b:PTR TO Vector)(FLOAT)
	DEFF	d,x,y,z
	x:=b.x-a.x
	y:=b.y-a.y
	z:=b.z-a.z
	d:=Sqrt(x*x+y*y+z*z)
ENDPROC d

// tato funkce vypocita odrazeny vektor l podle normaly
PROC Reflect3D(r:PTR TO Vector,n:PTR TO Vector,l:PTR TO Vector)(FLOAT,FLOAT,FLOAT)
	DEFF	x,y,z,a
	ResizeVector(n,1.0)
	ResizeVector(l,1.0)
	a:=2.0*(n.x*l.x+n.y*l.y+n.z*l.z)
	x:=l.x-n.x*a
	y:=l.y-n.y*a
	z:=l.z-n.z*a
	IF r
		r.x:=x
		r.y:=y
		r.z:=z
	ENDIF
ENDPROC x,y,z

PROC IntersectSphere(inter:PTR TO Intersection,line:PTR TO Line,object:PTR TO Object)(FLOAT)
	DEFF	d,t,plane:Plane,vector:Vector,l
	d:=LineDistance(line,object)	// pozor, "object" je v tomto pripade to same jako bod
	IF d<=object.r
		// ano, koule je protnuta primkou
		plane.a:=line.vx								// vytvoreni roviny kolme na danou primku
		plane.b:=line.vy
		plane.c:=line.vz
		plane.d:=object.x*plane.a+object.y*plane.b+object.z*plane.c
		plane.d:=-plane.d
		t:=PlaneIntersectionParameter(line,plane)
//		PrintF('t=$\z\h[8]\n',t)
		IF t>0.0
			vector.x:=line.u*t
			vector.y:=line.v*t
			vector.z:=line.w*t
//			PrintF(' vektor: $\z\h[8],$\z\h[8],$\z\h[8]\n',vector.x,vector.y,vector.z)
//			PrintF('d $\z\h[8],$\z\h[8]\n',d,object.r)
			l:=Sqrt(object.r*object.r-d*d)		// vzdalenost kraje koule po dane primce od bodu nejblizsiho ke stredu
//			PrintF('l $\z\h[8],$\z\h[8]\n',l,object.r)
			l:=VectorSize(vector)-l
//			PrintF('l2$\z\h[8],$\z\h[8]\n',l,object.r)
			IF inter
				ResizeVector(vector,l)
//				PrintF('vektorP: $\z\h[8],$\z\h[8],$\z\h[8]\n',vector.x,vector.y,vector.z)
				inter.x:=vector.x+line.x0
				inter.y:=vector.y+line.y0
				inter.z:=vector.z+line.z0
//				PrintF('  inter: $\z\h[8],$\z\h[8],$\z\h[8]\n',inter.x,inter.y,inter.z)
//				PrintF(' objekt: $\z\h[8],$\z\h[8],$\z\h[8]\n',object.x,object.y,object.z)
				inter.t:=l
				inter.nx:=inter.x-object.x
				inter.ny:=inter.y-object.y
				inter.nz:=inter.z-object.z
//				PrintF('normala: $\z\h[8],$\z\h[8],$\z\h[8]\n',inter.nx,inter.ny,inter.nz)
			ENDIF
			IF l>0.0 THEN RETURN l
		ENDIF
	ENDIF
ENDPROC 0.0

PROC IntersectPlane(inter:PTR TO Intersection,line:PTR TO Line,object:PTR TO Object)(FLOAT)
	DEFF	t,plane:Plane,vector:Vector,l
	plane.a:=object.x
	plane.b:=object.y
	plane.c:=object.z
	plane.d:=object.r
//	PrintF('Yes: ')
	t:=PlaneIntersectionParameter(line,plane)
//	PrintF('Param: $\z\h[8]\n',t)
	IF t>0.0
//		PrintF('Yes($\z\h[8])\n',inter)
		vector.x:=line.u
		vector.y:=line.v
		vector.z:=line.w
		l:=VectorSize(vector)
		IF inter
			vector.x:=line.u*t
			vector.y:=line.v*t
			vector.z:=line.w*t
//			ResizeVector(vector,l)
			inter.x:=vector.x+line.x0
			inter.y:=vector.y+line.y0
			inter.z:=vector.z+line.z0
			inter.t:=t*l
			inter.nx:=object.x
			inter.ny:=object.y
			inter.nz:=object.z
		ENDIF
		t*=l
	ELSE
		t:=0.0
	ENDIF
ENDPROC t
/*
PROC IntersectPolyObject(inter:PTR TO Intersection,line:PTR TO Line,object:PTR TO PolyObject)(FLOAT)
	DEFF	t
	IF object.x=0.0 AND object.y=0.0 AND object.z=0.0
		NormalVector(object,object.Poly[0],object.Poly[1],object.Poly[2])
		object.r:=object.Poly[0].x*object.x*object.Poly[0].y*object.y*object.Poly[0].z*object.z
	ENDIF
	t:=IntersectPlane(inter,line,object)
	IF t>0.0
		IF IsPointInPoly(inter.x,inter.y,object.Poly,4)=FALSE THEN t:=0.0
	ENDIF
ENDPROC t

PROC NormalVector(dest:PTR TO Vector,a:PTR TO Vector,b:PTR TO Vector,c:PTR TO Vector)
	DEF	d=[a.x-b.x,a.y-b.y,a.z-b.z]:Vector,
			e=[c.x-b.x,c.y-b.y,c.z-b.z]:Vector
	dest.x:=d.y*e.z-d.z*e.y
	dest.y:=d.z*e.x-d.x*e.z
	dest.z:=d.x*e.y-d.y*e.x
ENDPROC
*/
PROC IntersectPolyObject(inter:PTR TO Intersection,line:PTR TO Line,object:PTR TO PolyObject)(FLOAT)
	DEFF	t,plane:Plane,vector:Vector,l,point:Vector
	plane.a:=object.x
	plane.b:=object.y
	plane.c:=object.z
	plane.d:=object.r
//	PrintF('Yes: ')
	t:=PlaneIntersectionParameter(line,plane)
//	PrintF('Param: $\z\h[8]\n',t)
	IF t>0.0
		vector.x:=line.u
		vector.y:=line.v
		vector.z:=line.w
		l:=VectorSize(vector)
		vector.x:=line.u*t
		vector.y:=line.v*t
		vector.z:=line.w*t
		point.x:=vector.x+line.x0		// bod pruniku primky plochou
		point.y:=vector.y+line.y0
		point.z:=vector.z+line.z0
//		PrintF('Pos: $\z\h[8],$\z\h[8]\n',line.u,line.v)
//		IF IsPointInPoly(line.u,line.v,object.Poly,object.Count)=1
		IF IsPointInPoly(point.x,point.y,object.Poly,object.Count)=1
//			PrintF('Yes($\z\h[8])\n',l)
			IF inter
				inter.x:=point.x
				inter.y:=point.y
				inter.z:=point.z
				inter.t:=t*l
				inter.nx:=object.x
				inter.ny:=object.y
				inter.nz:=object.z
			ENDIF
			t*=l
		ELSE
			t:=0.0
		ENDIF
	ELSE
		t:=0.0
	ENDIF
ENDPROC t

// this function if cutted off from my AmiRay package
PROC IsPointInPoly(x:FLOAT,y:FLOAT,p:PTR TO Vector,count)(BOOL)
	DEF	n=0,e=0
	DEFF	ys,x1,y1,x2,y2

//	PrintF('X,Y,C: $\z\h[8],$\z\h[8],\d\n',x,y,count)

	WHILE n<count
		x1:=p[n].x
		y1:=p[n].y
//		PrintF('X1,Y2: $\z\h[8],$\z\h[8]\n',x1,y1)
		IF n=(count-1)
			x2:=p[0].x
			y2:=p[0].y
		ELSE
			x2:=p[n+1].x
			y2:=p[n+1].y
		ENDIF

		IF (x1<=x AND x2>x) OR (x1>x AND x2<=x)
		// x coord is between the two points
			IF y1<=y AND y2<=y
				e++			// yes, there is line above the point
			ELSEIF (y1<y AND y2>y) OR (y1>y AND y2<y)
			// y coord is between the two points
				ys:=(x-x1)*((y2-p[n].y)/(x2-x1))+p[n].y
				IF ys<y THEN e++
			ENDIF
		ENDIF

		n++
	ENDWHILE
//	PrintF('Yes=\d\n',e)
ENDPROC e&1

PROC Antialias(rp:PTR TO RastPort,image:PTR TO RImage,scene:PTR TO Scene)
	DEFF	x,y,d,r,g,b
	DEF	a:PTR TO UBYTE,n,i,j,ir,ig,ib,ix,iy
	IF a:=FindSharp(rp,image)
		FOR iy:=0 TO image.Height-1 STEP 1
			y:=iy-image.Height/2
			FOR ix:=0 TO image.Width-1 STEP 1
				x:=ix-image.Width/2
				n:=a[iy*image.Width+ix]
				IF n
					d:=1.0/(n+1.0)
					r:=g:=b:=0.0
					FOR j:=0 TO n
						FOR i:=0 TO n
							r,g,b+=RayTrace(scene,[i*d,j*d,1000.0,x*320/image.Width,y*240/image.Height,-1000.0]:Line)
						ENDFOR
					ENDFOR
					d:=1.0/((n+1.0)*(n+1.0))
					r*=d
					g*=d
					b*=d
					ir,ig,ib:=RPlot(image,ix,iy,r,g,b)
					IF rp
						SetAPen(rp,ir/4)
						WritePixel(rp,ix*2,iy*2)
						SetAPen(rp,ig/4+64)
						WritePixel(rp,ix*2+1,iy*2)
						SetAPen(rp,ib/4+128)
						WritePixel(rp,ix*2,iy*2+1)
						SetAPen(rp,(ir/4+ig/4+ib/4)/3+192)
						WritePixel(rp,ix*2+1,iy*2+1)
					ENDIF
				ENDIF
			ENDFOR
			IF rp
			ELSE PrintF('Antialiasing: \d/\d\b',iy,image.Height)
		EXITIF Mouse()=3
		ENDFOR
		FreeVec(a)
	ENDIF
	IF rp=NIL THEN PrintF('\n')
ENDPROC

PROC FindSharp(rp:PTR TO RastPort,image:PTR TO RImage)(PTR TO UBYTE)
	DEF	x,y,c,a:PTR TO UBYTE
	IF a:=AllocVec(image.Width*image.Height,MEMF_PUBLIC|MEMF_CLEAR)
		DEF	min,max,dx,dy
		IF rp THEN SetAPen(rp,255)
		FOR y:=1 TO image.Height-2
			FOR x:=1 TO image.Width-2
				min:=255
				max:=0
				FOR dy:=-1 TO 1
					FOR dx:=-1 TO 1
						c:=RGet(image,x+dx,y+dy)
						IF c<min THEN min:=c
						IF c>max THEN max:=c
					ENDFOR
				ENDFOR
				c:=max-min
				IF c>100
					c:=4
					s_antialias25++
				ELSEIF c>50
					c:=3
					s_antialias16++
				ELSEIF c>25
					c:=2
					s_antialias9++
				ELSEIF c>8
					c:=1
					s_antialias4++
				ELSE
					c:=0
				ENDIF
				IF rp
					IF c
//						SetAPen(rp,c*10+200)
						WritePixel(rp,x*2,y*2)
					ENDIF
				ENDIF
				a[y*image.Width+x]:=c
			ENDFOR
		EXITIF Mouse()=3
		ENDFOR
	ENDIF
ENDPROC a

PROC SaveTarga(image:PTR TO RImage)
	DEF	buff:PTR TO BGR,f,x,y,length,comment:PTR TO CHAR
	PrintF('Saving...           \n')
	IF buff:=AllocMem(image.Width*image.Height*SIZEOF_BGR,MEMF_PUBLIC)
		FOR y:=0 TO image.Height-1
			FOR x:=0 TO image.Width-1
				buff[y*image.Width+x].r:=image.Pixel[y*image.Width+x].r
				buff[y*image.Width+x].g:=image.Pixel[y*image.Width+x].g
				buff[y*image.Width+x].b:=image.Pixel[y*image.Width+x].b
			ENDFOR
		ENDFOR
		IF f:=Open('ram:image.tga',MODE_NEWFILE)
			comment:='$VER:This picture is generated by Martin Kuchinka''s simple RayTracer.'
			length:=StrLen(comment)
			Write(f,[length,0,2,0,0,0,0,24,0,0,0,0,image.Width,image.Width>>8,image.Height,image.Height>>8,24,$20]:UBYTE,18)
			Write(f,comment,length)
			Write(f,buff,image.Width*image.Height*SIZEOF_BGR)
			Close(f)
		ELSE PrintF('Unable to write image!\n')
		FreeMem(buff,image.Width*image.Height*SIZEOF_BGR)
	ELSE PrintF('Not enough memory!\n')
ENDPROC

PROC Surface(s,x:FLOAT,y:FLOAT,z:FLOAT,r:FLOAT,g:FLOAT,b:FLOAT)(FLOAT,FLOAT,FLOAT)
	DEFF	l
	SELECT s
	CASE SURFACE_Stripes
		y\=50
		IF y<0
			y:=FAbs(y)
			IF y<25
				r/=2
				g/=2
				b/=2
			ENDIF
		ELSE
			IF y>25
				r/=2
				g/=2
				b/=2
			ENDIF
		ENDIF
	CASE SURFACE_Checks
//		PrintF('x,z: $\z\h[8],$\z\h[8]\n',x,z)
		x\=100
		z\=100
		IF x<0
			x:=-x
			IF z<0
				z:=-z
				IF (x>50 AND z>50) OR (x<50 AND z<50)
					r/=2
					g/=2
					b/=2
				ENDIF
			ELSE
				IF (x>50 AND z<50) OR (x<50 AND z>50)
					r/=2
					g/=2
					b/=2
				ENDIF
			ENDIF
		ELSE
			IF z<0
				z:=-z
				IF (x<50 AND z>50) OR (x>50 AND z<50)
					r/=2
					g/=2
					b/=2
				ENDIF
			ELSE
				IF (x<50 AND z<50) OR (x>50 AND z>50)
					r/=2
					g/=2
					b/=2
				ENDIF
			ENDIF
		ENDIF
	CASE SURFACE_Dots
		x\=100
		y\=100
		z\=100
		x-=50
		y-=50
		z-=50
		l:=Sqrt(x*x+z*z)
		IF l<25
			r/=2
			g/=2
			b/=2
		ENDIF
	ENDSELECT
ENDPROC r,g,b

PROC NewImage(w,h)(PTR TO RImage)
	DEF	image:PTR TO RImage
	IF (image:=AllocMem(SIZEOF_RImage,MEMF_PUBLIC|MEMF_CLEAR))=NIL THEN RETURN NIL
	image.Width:=w
	image.Height:=h
	IF (image.Pixel:=AllocMem(SIZEOF_RGB*w*h,MEMF_PUBLIC|MEMF_CLEAR))=NIL
		FreeMem(image,SIZEOF_RImage)
		RETURN NIL
	ENDIF
ENDPROC image

PROC RPlot(image:PTR TO RImage,x,y,r:FLOAT,g:FLOAT,b:FLOAT/*,z=0.0:FLOAT*/)(LONG,LONG,LONG)
	DEFF	pixel:PTR TO RGB
	r*=255
	g*=255
	b*=255
	pixel:=image.Pixel[y*image.Width+x]
	pixel.r:=r
	pixel.g:=g
	pixel.b:=b
/*
	IF image.ZBuffer
		image.ZBuffer[y*image.Width+x]:=z
	ENDIF
*/
ENDPROC r,g,b

PROC RGet(image:PTR TO RImage,x,y)(LONG)
//	DEF	c
//	c:=image.Pixel[y*image.Width+x].r+image.Pixel[y*image.Width+x].g+image.Pixel[y*image.Width+x].b

	DEF	c,pixel:PTR TO RGB
	pixel:=image.Pixel[y*image.Width+x]
	c:=(pixel.r+pixel.g+pixel.b)/3
ENDPROC c

PROC DeleteImage(image:PTR TO RImage)
	IF image.Pixel THEN FreeMem(image.Pixel,image.Width*image.Height*SIZEOF_RGB)
	FreeMem(image,SIZEOF_RImage)
ENDPROC

PROC ShowInfo()
	DEFF	f
	DEF	str[24]:CHAR,ds:DateStamp,sec
	DateStamp(ds)
	s_stopday:=ds.Days
	s_stopmin:=ds.Minute
	s_stoptick:=ds.Tick
	IF s_startday=s_stopday
		sec:=s_stopmin*60+s_stoptick/50-s_startmin*60-s_starttick/50
	ENDIF
	PrintF('           Total rays: \d\n',s_raycount)
	PrintF('       Reflected rays: \d\n',s_reflectedrays)
	PrintF(' Intersection attemps: \d\n',s_interattemps)
	PrintF('        Intersections: \d\n',s_intersections)
	PrintF('     Rays lost in fog: \d\n',s_raysinfog)
	PrintF('   Antialiased pixels:\n')
	PrintF('       \d[2]x recomputed: \d\n',4,s_antialias4)
	PrintF('       \d[2]x recomputed: \d\n',9,s_antialias9)
	PrintF('       \d[2]x recomputed: \d\n',16,s_antialias16)
	PrintF('       \d[2]x recomputed: \d\n',25,s_antialias25)
	f:=WIDTH*HEIGHT+(s_antialias4*4+s_antialias9*9+s_antialias16*16+s_antialias25*25)
	f/=WIDTH*HEIGHT
	RealStr(str,f,4)
	PrintF(' Each pixel was recomputed \s times.\n',str)
	PrintF(' Rendering time: \d:\d (\d secs).\n',sec/60,sec\60,sec)
ENDPROC

PROC main()
	DEF	image:PTR TO RImage
#ifdef GFX_OUTPUT
	DEF	w:PTR TO Window,s:PTR TO Screen,vp,n=0,i
	IF s:=OpenScreenTags(NIL,
			SA_Width,WIDTH*2,
			SA_Height,HEIGHT*2,
			SA_Depth,8,
			SA_Title,'AmiRay Test Program',
//			SA_DisplayID,VGAPRODUCT_KEY,
			SA_DisplayID,HIRESLACE_KEY,
			SA_LikeWorkbench,TRUE,
			TAG_END)
		IF w:=OpenWindowTags(NIL,
				WA_InnerWidth,WIDTH*2,
				WA_InnerHeight,HEIGHT*2,
				WA_Flags,WFLG_ACTIVATE|WFLG_RMBTRAP|WFLG_BORDERLESS|WFLG_GIMMEZEROZERO,
				WA_IDCMP,IDCMP_CLOSEWINDOW,
				WA_CustomScreen,s,
				TAG_END)
			vp:=ViewPortAddress(w)
			FOR i:=000 TO 063 SetRGB32(vp,n++,i<<26,0,0)
			FOR i:=064 TO 127 SetRGB32(vp,n++,0,i<<26,0)
			FOR i:=128 TO 191 SetRGB32(vp,n++,0,0,i<<26)
			FOR i:=192 TO 255 SetRGB32(vp,n++,i<<26,i<<26,i<<26)
#endif
			IF image:=NewImage(WIDTH,HEIGHT)
#ifdef GFX_OUTPUT
				Gen(image,w.RPort)
#endif
#ifndef GFX_OUTPUT
				Gen(image,NIL)
#endif
				SaveTarga(image)
				ShowInfo()
#ifdef GFX_OUTPUT
				WaitPort(w.UserPort)
#endif
				DeleteImage(image)
			ENDIF
#ifdef GFX_OUTPUT
			CloseWindow(w)
		ELSE PrintF('unable to open window!\n')
		CloseScreen(s)
	ELSE PrintF('unable to open screen!\n')
#endif
ENDPROC
