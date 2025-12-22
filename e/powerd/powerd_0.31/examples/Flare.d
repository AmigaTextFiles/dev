// flare.d - simple lens flare renderer, it generates 24bit result in ram:flares.tga file

OPT	OPTIMIZE

MODULE	'intuition/intuition','intuition/screens','graphics/modeid','exec/memory',
			'utility/tagitem'

CONST	W=320,H=240,MODEID=VGALORESDBL_KEY
//CONST	W=640,H=480,MODEID=VGAPRODUCT_KEY

PROC main()
	DEF	flist:PTR TO flare,r,x,y
	//
	// flare definition
	//
	flist:=[
		FL_Linear	, 50.0, 0.00,1.00,1.00,1.00,
		FL_Power		, 60.0, 0.00,0.00,0.30,1.00,
		FL_FadeRing	, 30.0,-0.10,0.20,0.00,0.00,
		FL_Circle	, 10.0, 0.20,0.10,0.15,0.10,
		FL_Ring		, 34.0, 0.25,0.15,0.10,0.10,
		FL_Circle	, 20.0, 0.30,0.10,0.10,0.20,
		FL_Circle	, 14.0, 0.40,0.10,0.10,0.10,
		FL_Power		,  2.0, 0.47,0.10,0.70,1.00,
		FL_Circle	,  4.0, 0.55,0.10,0.10,0.10,
		FL_Circle	, 26.0, 0.60,0.10,0.10,0.20,
		FL_Circle	, 12.0, 0.70,0.10,0.20,0.10,
		FL_Linear	, 16.0, 0.85,0.00,0.10,0.40,
		FL_FadeRing	,100.0, 1.00,0.30,0.05,0.00,
		FL_FadeRing	,200.0, 1.50,0.05,0.20,0.10,
		FL_Last]:flare
/*
	DEFF	i
	i:=Flare(flist,160,160,120,120)
	PrintF('\d\n',i*1000)
*/
	PrintF('Flare by MarK 23.2.2000\n')
	PrintF('Press:\n\tLMB to change light position\n\tRMB to render flares\n\tany key for exit\n')
	r,x,y:=Preview(flist)
	IF r THEN Render(flist,x,y)
ENDPROC

ENUM	FL_Last,
		FL_Linear,
		FL_Power,
		FL_Circle,
		FL_Ring,
		FL_FadeRing

OBJECT flare
	type:LONG,		// type of the flare (see FL... above)
	size:FLOAT,		// size of the flare
	pos:FLOAT,		// position on the flare line (0=light, 1.0=opposite the light)
	r:FLOAT,			// colour of the flare
	g:FLOAT,
	b:FLOAT

//
// preview and setup for rendering
//
PROC Preview(flist:PTR TO flare)(LONG,LONG,LONG)
	DEF	s:PTR TO Screen,w:PTR TO Window,m:PTR TO IntuiMessage,end=FALSE,r=FALSE,mx,my
	IF s:=OpenScreenTags(NIL,
			SA_Width,W,
			SA_Height,H,
			SA_Depth,1,
			SA_DisplayID,MODEID,
			SA_Colors,[0,0,0,0,1,15,15,15,-1]:WORD,
			TAG_END)
		IF w:=OpenWindowTags(NIL,
				WA_Width,W,
				WA_Height,H,
				WA_CustomScreen,s,
				WA_IDCMP,IDCMP_MOUSEBUTTONS|IDCMP_VANILLAKEY,
				WA_Flags,WFLG_RMBTRAP|WFLG_ACTIVATE|WFLG_BORDERLESS,
				TAG_END)
			SetAPen(w.RPort,1)
			DrawFlare(w.RPort,flist,w.MouseX,w.MouseY)
			mx:=w.MouseX
			my:=w.MouseY
			WHILE WaitPort(w.UserPort)
				IF m:=GetMsg(w.UserPort)
					IF m.Class=IDCMP_MOUSEBUTTONS
						IF m.Code=SELECTDOWN
							SetRast(w.RPort,0)
							DrawFlare(w.RPort,flist,mx:=w.MouseX,my:=w.MouseY)
						ELSEIF m.Code=MENUDOWN
							r:=TRUE
							end:=TRUE
						ENDIF
					ELSE
						end:=TRUE
					ENDIF
					ReplyMsg(m)
				ENDIF
			EXITIF end=TRUE
			ENDWHILE

//			WaitPort(w.UserPort)
			CloseWindow(w)
		ELSE PrintF('Unable to open window!\n')
		CloseScreen(s)
	ELSE PrintF('Unable to open screen!\n')
ENDPROC r,mx,my

//
// draw circles as flares
//
PROC DrawFlare(rp,flist:PTR TO flare,mx:FLOAT,my:FLOAT)
	DEFF	cx,cy,dx,dy,x,y
	cx:=W/2
	cy:=H/2
	dx:=cx-mx
	dy:=cy-my
	REPEAT
		x:=dx*(flist.pos*2.0-1.0)
		y:=dy*(flist.pos*2.0-1.0)
//		PrintF('x=$\z\h[8]\ny=$\z\h[8]\n',x,y)
		DrawEllipse(rp,x+cx,y+cy,flist.size/2,flist.size/2)
		flist[]++
	UNTIL flist.type=FL_Last
ENDPROC

//
// open output screen and window
//
PROC Render(flist:PTR TO flare,mx:FLOAT,my:FLOAT)
	DEF	s:PTR TO Screen,w:PTR TO Window,vp,n,image:PTR TO RImage
	IF s:=OpenScreenTags(NIL,
			SA_Width,W,
			SA_Height,H,
			SA_Depth,8,
			SA_DisplayID,MODEID,
			TAG_END)
		IF w:=OpenWindowTags(NIL,
				WA_Width,W,
				WA_Height,H,
				WA_CustomScreen,s,
				WA_IDCMP,IDCMP_MOUSEBUTTONS|IDCMP_VANILLAKEY,
				WA_Flags,WFLG_RMBTRAP|WFLG_ACTIVATE|WFLG_BORDERLESS,
				TAG_END)
			vp:=ViewPortAddress(w)
			FOR n:=0 TO 255 SetRGB32(vp,n,n<<24,n<<24,n<<24)
			SetAPen(w.RPort,255)

			IF image:=NewImage(W,H)
//				DrawFlare(w.RPort,flist,mx,my)
				RenderFlare(w.RPort,image,flist,mx,my)
				SaveTarga(image)
				DeleteImage(image)
			ENDIF

			WaitPort(w.UserPort)
			CloseWindow(w)
		ELSE PrintF('Unable to open window!\n')
		CloseScreen(s)
	ELSE PrintF('Unable to open screen!\n')
ENDPROC

//
// render flare list
//
PROC RenderFlare(rp,im:PTR TO RImage,flist:PTR TO flare,mx:FLOAT,my:FLOAT)
	DEFF	cx,cy,dx,dy,x,y,xx,yy,i,sx,sy,li:L
	cx:=im.Width/2
	cy:=im.Height/2
	dx:=cx-mx
	dy:=cy-my
	REPEAT
		x:=dx*(flist.pos*2.0-1.0)
		y:=dy*(flist.pos*2.0-1.0)
		sx:=x-flist.size/2
		FOR xx:=sx TO x+flist.size/2
		NEXTIF xx<=-cx
		EXITIF xx>=cx
			sy:=y-flist.size/2
			FOR yy:=sy TO y+flist.size/2
			NEXTIF yy<=-cy
			EXITIF yy>=cy
				i:=Flare(flist,xx,yy,x,y)
				li:=RRePlot(im,xx+cx,yy+cy,i*flist.r,i*flist.g,i*flist.b)
				IF li
					SetAPen(rp,li)
					WritePixel(rp,xx+cx,yy+cy)
				ENDIF
			ENDFOR
			IF Mouse()=3 THEN RETURN
		ENDFOR
		flist[]++
	UNTIL flist.type=FL_Last
ENDPROC

//
// get flare intensity
//
PROC Flare(flare:PTR TO flare,x:FLOAT,y:FLOAT,fx:FLOAT,fy:FLOAT)(FLOAT)
	DEFF	i,l
//	PrintF('\d,\d,\d,\d\n',fx*1000,fy*1000,x*1000,y*1000)
	x-=fx
	y-=fy
	l:=Sqrt(x*x+y*y)					// l = distance of rendering pixel and flare center
	l/=flare.size/2.0					// unify
	IF l>1.0 THEN RETURN 0.0		// no intersection, end
	SELECT flare.type
	CASE FL_Linear
		i:=1.0-l
	CASE FL_Power
		i:=(1.0-l)*(1.0-l)
	CASE FL_Circle
		IF l>0.95
//			i:=20.0*(1.0-l)
			i:=(1.0-l)*20.0
		ELSE
			i:=1.0
		ENDIF
	CASE FL_Ring
		IF l>0.90
			i:=(1.0-l)*10.0
		ELSEIF l>0.80
			i:=(l-0.80)*10.0
		ELSE
			i:=0.0
		ENDIF
	CASE FL_FadeRing
		IF l>0.95
			i:=(1.0-l)*20.0
		ELSEIF l>0.50
			i:=(l-0.50)*2.0
		ELSE
			i:=0.0
		ENDIF
	DEFAULT
		i:=0.0
	ENDSELECT
	IF i>1.0 THEN i:=1.0
	IF i<0.0 THEN i:=0.0
ENDPROC i

//
// image definition
//
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
	Pixel:PTR TO RGB

PROC NewImage(w,h)(PTR TO RImage)
	DEF	image:PTR TO RImage
	IFN image:=New(SIZEOF_RImage) THEN RETURN NIL
	image.Width:=w
	image.Height:=h
	IFN image.Pixel:=New(SIZEOF_RGB*w*h)
		Dispose(image)
		RETURN NIL
	ENDIF
ENDPROC image

PROC RRePlot(image:PTR TO RImage,x,y,r:FLOAT,g:FLOAT,b:FLOAT)(LONG=0)
	DEF	c,pixel:PTR TO RGB
	IF x>=image.Width OR y>=image.Height OR x<0 OR y<0 THEN RETURN
	r*=255
	g*=255
	b*=255
	pixel:=image.Pixel[y*image.Width+x]

	r+=pixel.r
	g+=pixel.g
	b+=pixel.b

	IF r>255 THEN r:=255
	IF g>255 THEN g:=255
	IF b>255 THEN b:=255

	pixel.r:=r
	pixel.g:=g
	pixel.b:=b
	c:=(pixel.r+pixel.g+pixel.b)/3
ENDPROC c

PROC DeleteImage(image:PTR TO RImage)
	IF image.Pixel THEN Dispose(image.Pixel)
	Dispose(image)
ENDPROC

//
// save 24bit targa image
//
PROC SaveTarga(image:PTR TO RImage)
	DEF	buff:PTR TO BGR,f,x,y,length,comment:PTR TO CHAR
	PrintF('Saving...\b')
	IF buff:=New(image.Width*image.Height*SIZEOF_BGR)
		FOR y:=0 TO image.Height-1
			FOR x:=0 TO image.Width-1
				buff[y*image.Width+x].r:=image.Pixel[y*image.Width+x].r
				buff[y*image.Width+x].g:=image.Pixel[y*image.Width+x].g
				buff[y*image.Width+x].b:=image.Pixel[y*image.Width+x].b
			ENDFOR
		ENDFOR
		IF f:=Open('ram:flares.tga',NEWFILE)
			comment:='$VER:This picture is generated by Martin Kuchinka''s simple Flare renderer.'
			length:=StrLen(comment)
			Write(f,[length,0,2,0,0,0,0,24,0,0,0,0,image.Width,image.Width>>8,image.Height,image.Height>>8,24,$20]:UBYTE,18)
			Write(f,comment,length)
			Write(f,buff,image.Width*image.Height*SIZEOF_BGR)
			PrintF('Done.     \n')
			Close(f)
		ELSE PrintF('Unable to write image!\n')
		Dispose(buff)
	ELSE PrintF('Not enough memory!\n')
ENDPROC
