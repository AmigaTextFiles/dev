OPT	PPC

MODULE	'rtgmaster',
			'rtgmaster/rtgmaster',
			'rtgmaster/rtgc2p',
			'rtgmaster/rtgsublibs'
MODULE	'exec/memory',
			'utility/tagitem'

DEF	nbuf=0,	// rendering buffer
		c2psig,	// c2p signal

		width,	// buffer dimensions
		height

PROC Go(rsc,bin:PTR TO UBYTE)
	DEF	x,y,n=0
	WHILE n<128
		FOR x:=0 TO width-1
			FOR y:=0 TO height-1
				bin[y*width+x]:=x*y+n
			ENDFOR
		ENDFOR
	EXITIF ChangeBuffer(rsc,bin)=FALSE
		n++
//	EXITIF Mouse()
//		IF n\10=0 THEN PrintF('\d\b',n)
	ENDWHILE
//	Delay(250)
ENDPROC

PROC ChangeBuffer(rsc:PTR TO RtgScreen,bin:PTR TO UBYTE)(LONG)
	DEF	buf
	IF buf:=GetBufAdr(rsc,nbuf)
//		CallRtgC2P(rsc,buf,bin,c2psig,0,0,width,height,c2p_1x1)
		CopyRtgBlit(rsc,buf,bin,0,0,0,width,height,width,height,0,0)
		RtgWaitTOF(rsc)
		SwitchScreens(rsc,nbuf)
//		nbuf++
		IF nbuf=2 THEN nbuf:=0
	ELSE RETURN FALSE
//	PrintF('\d,$\h\n',nbuf,buf)
ENDPROC TRUE

DEF	RTGMasterBase

PROC main()
	DEF	req:PTR TO ScreenReq,
			rsc:PTR TO RtgScreen,
			rgb[800]:ULONG,
			bin:PTR TO UBYTE
	DEF	n,tags:PTR TO TagItem,i

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
				smr_PrefsFileName,'rtgtest.prefs',	// preferences file
				smr_ForceOpen,TRUE,						// always open this requester
				TAG_END])

			// open requested screen
			IF rsc:=OpenRtgScreen(req,NIL)

				GetRtgScreenData(rsc,tags:=[
					grd_Width,0,
					grd_Height,0,
					TAG_END])
				width:=tags[0].Data
				height:=tags[1].Data

				// get c2p signal
				IF (c2psig:=AllocSignal(-1))<>-1

					// lock the screen for private use
					LockRtgScreen(rsc)

					// setup colours of the screen

					i:=0
					rgb[i++]:=256<<16
					FOR n:=000 TO 063 DO rgb[i++]:=n<<26;	rgb[i++]:=n<<26;	rgb[i++]:=n<<26
					FOR n:=064 TO 127 DO rgb[i++]:=n<<26;	rgb[i++]:=0;		rgb[i++]:=0
					FOR n:=128 TO 191 DO rgb[i++]:=0;		rgb[i++]:=n<<26;	rgb[i++]:=0
					FOR n:=192 TO 255 DO rgb[i++]:=0;		rgb[i++]:=0;		rgb[i++]:=n<<26
					rgb[i]:=0
					LoadRGBRtg(rsc,rgb)

					IF bin:=AllocVec(width*height,MEMF_PUBLIC|MEMF_CLEAR)

						Go(rsc,bin)

						FreeVec(bin)
					ELSE PrintF('Not enough memory!\n')

					// unlock locked screen
					UnlockRtgScreen(rsc)

					FreeSignal(c2psig)
				ELSE PrintF('Can''t get c2p signal!\n')

				CloseRtgScreen(rsc)
			ELSE PrintF('Can''t open rtg screen!\n')

			FreeRtgScreenModeReq(req)
		ELSE PrintF('Can''t open rtg requester!\n')

		CloseLibrary(RTGMasterBase)
	ELSE PrintF('Can''t open rtgmaster.library v23+!\n')
ENDPROC
