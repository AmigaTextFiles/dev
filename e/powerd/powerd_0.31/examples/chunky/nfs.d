// this only a small example chunky lib and rtg library usage
// it's a bit stupid, not a control yet

MODULE	'rtgmaster',
			'rtgmaster/rtgmaster',
			'rtgmaster/rtgc2p',
			'rtgmaster/rtgsublibs',
			'rtgmaster/rtgami'
MODULE	'exec/memory',
			'utility/tagitem',
			'intuition/screens',
			'intuition/intuition'
MODULE	'lib/chunky'

DEF	nbuf=0,	// rendering buffer
		c2psig,	// c2p signal

		width,	// buffer dimensions
		height

//#define GET_TIME TRUE

OBJECT chunky
	wi/he:LONG,
	chunky:PTR TO UBYTE

PROC Go(rsc:PTR TO RtgScreenAMI,chunky:PTR TO chunky,track:PTR TO track)
	DEF	n=0,imsg:PTR TO IntuiMessage,c:PTR TO camera
	DEFD	micros,sum_micros
	c:=[
		-50.0,1.00,0.0,
		  0.0,0.00,0.0,
		  1.0,1.00,1.0,
		  0.0,0.00,0.0,
		  100.0]:camera
	WHILE n<4096
		IF imsg:=RtgGetMsg(rsc)
			SELECT imsg.Class
			CASE IDCMP_MOUSEBUTTONS
			CASE IDCMP_RAWKEY
/*
				SELECT imsg.Code AND $ff
				CASE $4f;	car.udir:=-1
				CASE $4e;	car.udir:=1
				CASE $4c;	car.uacc:=car.acceleration
				CASE $4d;	car.uacc:=-car.acceleration
				CASE $cc,$cd;	car.uacc:=0
				CASE $cf,$ce;	car.udir:=0
				CASE $40
				ENDSELECT
*/
			ENDSELECT
			RtgReplyMsg(rsc,imsg)
		ENDIF
//		MoveCar(car,track)
		c.z+=2
/*
#ifdef GET_TIME
		sum_micros:=0.0
		polycount:=polydraw:=transcount:=0
		ReadEClock(time0)
#endif
*/
		FillChunky(chunky,3)
		RenderTrack(chunky,track,c)
/*
#ifdef GET_TIME
		ReadEClock(time1)
		micros:=(time1.Lo-time0.Lo)*micros_per_eclock
		sum_micros+=micros
		PrintF('\d[4]: \d[6] \d[6] \d[6] \d[9] µs\n',n,polycount,polydraw,transcount,micros)
#endif
*/
	EXITIF ChangeBuffer(rsc,chunky)=FALSE
		n++
	EXITIF Mouse()=2
	ENDWHILE
ENDPROC

PROC ChangeBuffer(rsc:PTR TO RtgScreen,chunky:PTR TO chunky)(LONG)
	DEF	buf
	IF buf:=GetBufAdr(rsc,nbuf)
		CopyRtgBlit(rsc,buf,chunky.chunky,0,0,0,chunky.wi,chunky.he,chunky.wi,chunky.he,0,0)
		RtgWaitTOF(rsc)
		SwitchScreens(rsc,nbuf)
		IF nbuf=2 THEN nbuf:=0
	ELSE RETURN FALSE
ENDPROC TRUE

DEF	RTGMasterBase

PROC main()
	DEF	req:PTR TO ScreenReq,
			rsc:PTR TO RtgScreen,
			bin:PTR TO UBYTE,ok,
			track:PTR TO track
	DEF	tags:PTR TO TagItem

	// open the rtgmaster.library
	IF RTGMasterBase:=OpenLibrary('rtgmaster.library',23)

		// open the rtg screen requester to select screenmode and dimensions
		IF req:=RtgScreenModeReq([
				smr_MinWidth,320,
				smr_MinHeight,200,
				smr_MaxWidth,1024,
				smr_MaxHeight,768,
				smr_ChunkySupport,512,
				smr_PlanarSupport,-1,
				smr_Buffers,2,								// double buffering
				smr_PrefsFileName,'simul.prefs',		// preferences file
				TAG_END])

			// open requested screen
			IF rsc:=OpenRtgScreen(req,NIL)

				GetRtgScreenData(rsc,tags:=[
					grd_Width,0,
					grd_Height,0,
					TAG_END])
				width:=tags[0].Data
				height:=tags[1].Data

				IF RtgInitRDCMP(rsc)

					// get c2p signal
					IF (c2psig:=AllocSignal(-1))<>-1

						// lock the screen for private use
						LockRtgScreen(rsc)

						// setup colours of the screen
						LoadPalette(rsc,'palette')

						IF pool:=CreatePool(MEMF_PUBLIC|MEMF_CLEAR,16384,2048)
							IF ok,track:=LoadTrack(0)
								IF bin:=AllocPooled(pool,width*height)

									IF get_timer()
										Go(rsc,[width,height,bin]:chunky,track)
										free_timer()
									ENDIF

								ELSE PrintF('Not enough memory!\n')
								UnLoadTrack(track)
							ENDIF
							DeletePool(pool)
						ELSE PrintF('Not enough memory!\n')

						// unlock locked screen
						UnlockRtgScreen(rsc)

						FreeSignal(c2psig)
					ELSE PrintF('Can''t get c2p signal!\n')
				ENDIF

				CloseRtgScreen(rsc)
			ELSE PrintF('Can''t open rtg screen!\n')

			FreeRtgScreenModeReq(req)
		ELSE PrintF('Can''t open rtg requester!\n')

		CloseLibrary(RTGMasterBase)
	ELSE PrintF('Can''t open rtgmaster.library v23+!\n')
ENDPROC

PROC LoadPalette(rsc,name:PTR TO CHAR)
	DEF rgb[800]:ULONG,f
	IF f:=Open(name,OLDFILE)
		Read(f,rgb,FileLength(name))
		LoadRGBRtg(rsc,rgb)
		Close(f)
	ENDIF
ENDPROC

DEF	pool

OBJECT track
	line:PTR TO trackline,
	count:WORD

OBJECT trackline
	next/prev:PTR TO trackline,
	data:PTR TO trackdata,
	count:WORD

OBJECT trackdata
	texture:WORD,			// TX...
	x/y/z:FLOAT

ENUM	TX_End=0,
		TX_Black=1,
		TX_White=15,
		TX_Yellow=88,
		TX_Grass=58,
		TX_Grass1=57,
		TX_Grass2=56,
		TX_Road=7

OBJECT kxy
	kind:W,
	x/y:F

OBJECT xyz
	x/y/z:F

OBJECT xy
	x/y:F

PROC LoadTrack(n)(BOOL,PTR TO track)
	SELECT n
	CASE 0
		DEF	profile:PTR TO kxy,pos:PTR TO xyz
		profile:=[	// profile definition
			TX_Grass2,-10.0,  3,
			TX_Grass1, -7.0,  1,
			TX_Grass,  -4.0,  0,
			TX_White,  -3.0,  0,
			TX_Road,   -2.8,  0,
			TX_Yellow, -0.1,  0,
			TX_Road,    0.1,  0,
			TX_White,   2.8,  0,
			TX_Grass,   3.0,  0,
			TX_Grass1,  4.0,  0,
			TX_Grass2,  7.0,  1,
			TX_End,    10.0,  3]:kxy		// 12 pieces
		pos:=[		// profile positions
			-50.0,0.0,-100.0,
			-50.0,0.0, -90.0,
			-50.0,0.0, -80.0,
			-50.0,0.0, -70.0,
			-50.0,0.0, -60.0,
			-50.0,0.0, -50.0,
			-50.0,0.0, -40.0,
			-50.0,0.0, -30.0,
			-50.0,0.0, -20.0,
			-50.0,0.0, -10.0,		// 10

			-50.0,0.0,   0.0,
			-50.0,0.0,  10.0,
			-50.0,0.0,  20.0,
			-50.0,0.0,  30.0,
			-50.0,0.0,  40.0,
			-50.0,0.0,  50.0,
			-50.0,0.0,  60.0,
			-50.0,0.0,  70.0,
			-50.0,0.0,  80.0,
			-50.0,0.0,  90.0,		// 20

			-50.0,0.0, 100.0,
			-49.4,0.0, 107.8,
			-47.6,0.0, 115.5,
			-44.6,0.0, 122.7,
			-40.5,0.0, 129.4,
			-35.4,0.0, 135.4,
			-29.4,0.0, 140.5,
			-22.7,0.0, 144.6,
			-15.5,0.0, 147.6,
			 -7.8,0.0, 149.4,		// 30

			  0.0,0.0, 150.0,
			  7.8,0.0, 149.4,
			 15.5,0.0, 147.6,
			 22.7,0.0, 144.6,
			 29.4,0.0, 140.5,
			 35.4,0.0, 135.4,
			 40.5,0.0, 129.4,
			 44.6,0.0, 122.7,
			 47.6,0.0, 115.5,
			 49.4,0.0, 107.8,		// 40

			 50.0,0.0, 100.0,
			 50.0,0.0,  90.0,
			 50.0,0.0,  80.0,
			 50.0,0.0,  70.0,
			 50.0,0.0,  60.0,
			 50.0,0.0,  50.0,
			 50.0,0.0,  40.0,
			 50.0,0.0,  30.0,
			 50.0,0.0,  20.0,
			 50.0,0.0,  10.0,		// 50

			 50.0,0.0,   0.0,
			 50.0,0.0, -10.0,
			 50.0,0.0, -20.0,
			 50.0,0.0, -30.0,
			 50.0,0.0, -40.0,
			 50.0,0.0, -50.0,
			 50.0,0.0, -60.0,
			 50.0,0.0, -70.0,
			 50.0,0.0, -80.0,
			 50.0,0.0, -90.0,		// 60

			 50.0,0.0,-100.0,
			 49.4,0.0,-107.8,
			 47.6,0.0,-115.5,
			 44.6,0.0,-122.7,
			 40.5,0.0,-129.4,
			 35.4,0.0,-135.4,
			 29.4,0.0,-140.5,
			 22.7,0.0,-144.6,
			 15.5,0.0,-147.6,
			  7.8,0.0,-149.4,		// 70

			  0.0,0.0,-150.0,
			 -7.8,0.0,-149.4,
			-15.5,0.0,-147.6,
			-22.7,0.0,-144.6,
			-29.4,0.0,-140.5,
			-35.4,0.0,-135.4,
			-40.5,0.0,-129.4,
			-44.6,0.0,-122.7,
			-47.6,0.0,-115.5,
			-49.4,0.0,-107.8		// 80
			]:xyz

		DEF	track:PTR TO track,trackline:PTR TO trackline,trackdata:PTR TO trackdata,m
		DEFF	prev=NIL:PTR TO trackline,cos,sin

		IFN track:=AllocPooled(pool,SIZEOF_track) THEN RETURN FALSE,NIL

		FOR n:=0 TO 79

			IFN trackline:=AllocPooled(pool,SIZEOF_trackline) THEN RETURN FALSE,NIL
			IFN trackdata:=AllocPooled(pool,SIZEOF_trackdata*12) THEN RETURN FALSE,NIL

			IFN track.line THEN track.line:=trackline
			IF prev THEN prev.next:=trackline

			cos:=pos[n].x/50.0
			IF pos[n].z>100
				sin:=(pos[n].z-100)/50.0
			ELSEIF pos[n].z<-100
				sin:=(pos[n].z+100)/50.0
			ELSE sin:=0

			FOR m:=0 TO 11
				trackdata[m].texture:=profile[m].kind
				trackdata[m].x:=profile[m].x*cos+pos[n].x
				trackdata[m].y:=profile[m].y+pos[n].y
				trackdata[m].z:=profile[m].x*sin+pos[n].z
			ENDFOR

			IF trackdata[5].texture=TX_Yellow AND Even(n) THEN trackdata[5].texture:=TX_Road

			trackline.data:=trackdata
			trackline.prev:=prev
			trackline.count:=12

			prev:=trackline
		ENDFOR

		track.count:=80
	ENDSELECT
ENDPROC TRUE,track

PROC UnLoadTrack(tr:PTR TO track)
ENDPROC

PROC RenderTrackTop(dst:PTR TO chunky,track:PTR TO track)
	DEF	line=track.line:PTR TO trackline,data:PTR TO trackdata,n,next:PTR TO trackdata
	WHILE line
		data:=line.data
		next:=IF line.next THEN line.next.data ELSE track.line.data
		FOR n:=0 TO line.count-2
			DrawTriangle(dst,[data[n].z+160,data[n].x+100,data[n+1].z+160,data[n+1].x+100,next[n].z+160,next[n].x+100]:xy,data[n].texture)
//			DrawTriangle(dst,[data[n+1].z+160,data[n+1].x+100,next[n+1].z+160,next[n+1].x+100,next[n].z+160,next[n].x+100]:xy,data[n].texture)
		ENDFOR
//		PrintF('Yeah (\d)\b',data[n].texture)
		line:=.next
	ENDWHILE
ENDPROC

OBJECT camera
	x/y/z:FLOAT,		// camera position
	ax/ay/az:FLOAT,	// camera angle
	cx/cy/cz:FLOAT,	// camera angle cosine
	sx/sy/sz:FLOAT,	// camera angle sine
	l:FLOAT				// camera length

PROC RenderTrack(dst:PTR TO chunky,track:PTR TO track,c:PTR TO camera)
	DEF	line=track.line:PTR TO trackline,data:PTR TO trackdata,n,next:PTR TO trackdata
	DEF	x0,y0,x1,y1,x2,y2,q=0,sh,isok:BOOL,totok:BOOL
	WHILE line
		data:=line.data
		next:=IF line.next THEN line.next.data ELSE track.line.data
		FOR n:=0 TO line.count-2
			totok:=FALSE
			x0,y0,isok:=ComputePersp(data[n].x,data[n].y,data[n].z,c);			totok|=isok
			x1,y1,isok:=ComputePersp(data[n+1].x,data[n+1].y,data[n+1].z,c);	totok|=isok
			x2,y2,isok:=ComputePersp(next[n].x,next[n].y,next[n].z,c);			totok|=isok

			polycount++
			IF totok=FALSE
				x0+=dst.wi>>1
				y0+=dst.he>>1
				x1+=dst.wi>>1
				y1+=dst.he>>1
				x2+=dst.wi>>1
				y2+=dst.he>>1

				sh:=(c.z-data[n].z)/10-8
				IF sh<-5 THEN sh:=data[n].texture-6 ELSE sh:=data[n].texture+sh-1

				DrawTriangle(dst,[x0,y0,x1,y1,x2,y2]:xy,sh)
				polydraw++

				x0,y0,isok:=ComputePersp(next[n+1].x,next[n+1].y,next[n+1].z,c);	totok|=isok
				polycount++
				IFN totok
					x0+=dst.wi>>1
					y0+=dst.he>>1
					DrawTriangle(dst,[x0,y0,x1,y1,x2,y2]:xy,sh)
					polydraw++
				ENDIF
			ENDIF

			IF Mouse()=2 THEN RETURN
		ENDFOR
		line:=.next
		q++
	EXITIF q>30
	ENDWHILE
ENDPROC

PROC ComputePersp(x:F,y:F,z:F,c:PTR TO camera)(F,F,BOOL)
	DEFF	x1,y1,z1,xx,yy,zz,l

	x:=c.x-x
	y:=c.y-y
	z:=c.z-z

	x1:=x*c.cz+y*c.sz
	y1:=y*c.cz-x*c.sz
	xx:=x1*c.cy+z*c.sy
	z1:=z*c.cy-x1*c.sy
	zz:=z1*c.cx+y1*c.sx
	yy:=y1*c.cx-z1*c.sx

	l:=c.l-zz
	IF l>0.0
		x:=xx*c.l/l
		y:=yy*c.l/l
	ELSE
		RETURN 0,0,TRUE
	ENDIF
	transcount++
ENDPROC x*10,y*10,FALSE

MODULE	'devices/timer','timer'

DEF	TimerBase
DEF	timerio:TimeRequest,
		time0:EClockVal,
		time1:EClockVal,
		micros_per_eclock:DOUBLE,
		timerclosed,
		polycount,
		polydraw,
		transcount

PROC get_timer()(L)
	DEFL	ok=0
	IFN timerclosed:=OpenDevice('timer.device',UNIT_VBLANK,timerio,0)
		TimerBase:=timerio.IO.Device
		micros_per_eclock:=1000000.0/ReadEClock(time0)
		ok:=1
	ENDIF
ENDPROC ok

PROC free_timer()
	IFN timerclosed THEN CloseDevice(timerio)
ENDPROC
