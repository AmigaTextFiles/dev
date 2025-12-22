/*
TABS=4 · Please try to keep the source with the executable.


                              The Fuel Guage

                   © COPYRIGHT 1994 Christian Catchpole

                            COLD COFFEE DESIGN
                   MADE IN AUSTRALIA - CONTAINS CAFFEINE

 Snail Mail: CHRISTIAN CATCHPOLE, P.O. BOX 388, CHERMSIDE 4032, AUSTRALIA

                             *** IMPORTANT ***

DISCLAIMER:   I  DO  NOT  CLAIM THAT THIS PROGRAM IS FIT FOR ANY PARTICULAR
PURPOSE AND THUS I CAN NOT BE HELD RESPONSIBLE FOR ANY DAMAGE CAUSED BY THE
USE OR MISUSE OF THIS PROGRAM.  USE THIS AT YOUR OWN RISK.

...other than that, enjoy yourself!

Q.  What is "The Fuel Guage"?

A.   A  little  program written in E by yours truely that opens a window on
the  defualt  public screen and not only displays a guage of available CHIP
and FAST memory, but throws a few vector images around to entertain you.

This program runs at priority -1 for your convenience.

I  gave  this to Wouter to release on the condition that he doesn't mind me
using  his  vector  routines (those from vec.e).  So, if your reading this,
it's  obvious  he  was  cool about it.  I've written a more appropriate one
myself but it would take too long to implement - in this version anyway.

I won't ask for any donation or such for using this since it is pritty weak
and  the vector code isn't mine to sell!  Although, nice letters, postcards
and  briefcases full of unmarked bills would be appreciated.  :-) What I do
ask  is  that  you  use and support the use of Amiga E.  Nothing else comes
close.   (when will Wouter think of a catchy slogan - he's already asked me
to appear in his prime time TV commercials :)

Wander  through  the source and see what you think.  I don't not claim that
this  is  written  to it's best efficiency - infact i know of several areas
that  are  just  plain  crap  (LONG shape Lists for example).  I have tried
though  to  show  good programming practices - perform() for example, shows
how  you  can use global vars and quoted expressions to your advantage when
multiple  processing  objects  (even  though  the  memlist  only contains 2
objects!  :-)

Oh  yair.   E users and all others please write (100% Legal :).  I would be
especialy interested in you if you...

	· Live far way away into the distance. (AND speak english!)
	· Have an interest in writing really tricky yet system friendly code.
	· Appreciate the importance of a good cup of coffee.
	· Are NOT under the influence of drugs.
	· Are NOT under the influence of XCopy (100% Legal :).
	· Sleep with one eye open so that if your Amiga gets up in the middle
	  of the night to conqure the world, you want to see it (and then read
	  the source code to see how it's done!)
	· Enjoy writing pages and pages of miscelaneousness.

Enjoy.

Christian.
Tue Jun 14 14:48:19 1994

*/

MODULE	'intuition/intuition',
		'gadtools','libraries/gadtools',
		'exec/memory',
		'graphics/displayinfo','graphics/text','graphics/rastport',
		'graphics/gfx',
		'diskfont','libraries/diskfont'

OBJECT form_gadget
	kind		:INT
	x			:INT
	y			:INT
	dx			:INT
	dy			:INT
	text		:LONG
	func		:LONG
ENDOBJECT

OBJECT form_bevel
	x			:INT
	y			:INT
	dx			:INT
	dy			:INT
	rec			:INT
	col			:INT
ENDOBJECT

OBJECT memblock
	type		:LONG
	text		:LONG
	position	:INT
	total		:LONG
	avail		:LONG
	lastavail	:LONG
ENDOBJECT

CONST	VERSION=37,		/* Minimum V2.0 (of course) */
		WIN_FLAGS	=	WFLG_CLOSEGADGET OR WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_NOCAREREFRESH OR WFLG_ACTIVATE,
		WIN_IDCMP	=	IDCMP_CLOSEWINDOW OR IDCMP_REFRESHWINDOW OR IDCMP_GADGETUP OR IDCMP_ACTIVEWINDOW,

		LEFT = 14,
		RIGHT = 244,
		CENTRE = 150,

		TOP1 = 24,
		TOP2 = 33,
		BOTTOM1 = 152,
		BOTTOM2 = 161,

		GRY=0,BLK=1,WHT=2,BLU=3,	/* WB 2.0 colours */

		RECESSED = 2,

		SLOW=10,
		FAST=2,

		R=120,
		MAXCOUNT=50		/* # of times to draw shap before changing it */

ENUM	NOERROR=NIL,
		NOMEM,
		NOLIBRARY,
		NOKICK,
		NOLOCK,
		NOVISUAL,
		NOWINDOW,
		NOGADGETS

RAISE	NOMEM		IF New()=NIL,
		NOLIBRARY	IF OpenLibrary()=NIL,
		NOKICK		IF KickVersion()=NIL,
		NOLOCK		IF LockPubScreen()=NIL,
		NOVISUAL	IF GetVisualInfoA()=NIL,
		NOWINDOW	IF OpenWindow()=NIL,
		NOGADGETS	IF CreateGadgetA()=NIL,
		NOGADGETS	IF CreateContext()=NIL

DEF	wnd			:PTR TO window,
	rast		:PTR TO rastport,
	scr, visual, context, lastgad,
	thistask, origpri,

	gad			:PTR TO form_gadget,
	bev			:PTR TO form_bevel,

	sintab		:PTR TO INT,

	imes		:PTR TO intuimessage,
	iaddress	:PTR TO gadget,
	imclass, code,

	mem			:PTR TO memblock,
	memlist		:PTR TO LONG,

	messagelist	:PTR TO LONG,

	phi=NIL,
	theta=NIL,

	images=TRUE,
	speed=FAST,

	frameloop,
	shapelist	:PTR TO LONG,
	shapenames	:PTR TO LONG,
	shapesizes	:PTR TO LONG,
	currentshape=NIL, count,

	scrolldown=NIL,

	gstr[40]	:STRING,				/* a general purpose string */
	x,y

PROC main() HANDLE
	/* typing 'thefuelguage ?' from a shell will print the about text. */
	IF Char(arg)="?"
		WriteF('\n\s\n',{txt_about})
		RETURN
	ENDIF
	KickVersion(VERSION)

	/* I didn't like Wouter's sintab(PC) - not very E at all! */

	sintab:=[	$0000,$0004,$0008,$000D,$0011,$0016,$001A,$001F,
				$0023,$0027,$002C,$0030,$0035,$0039,$003D,$0041,
				$0046,$004A,$004E,$0053,$0057,$005B,$005F,$0063,
				$0067,$006B,$006F,$0073,$0077,$007B,$007F,$0083,
				$0087,$008A,$008E,$0092,$0095,$0099,$009C,$00A0,
				$00A3,$00A7,$00AA,$00AD,$00B1,$00B4,$00B7,$00BA,
				$00BD,$00C0,$00C3,$00C6,$00C8,$00CB,$00CE,$00D0,
				$00D3,$00D5,$00D8,$00DA,$00DC,$00DF,$00E1,$00E3,
				$00E5,$00E7,$00E8,$00EA,$00EC,$00EE,$00EF,$00F1,
				$00F2,$00F3,$00F5,$00F6,$00F7,$00F8,$00F9,$00FA,
				$00FB,$00FB,$00FC,$00FD,$00FD,$00FE,$00FE,$00FE,
				$00FE,$00FE,$00FF,$00FE,$00FE,$00FE,$00FE,$00FE,
				$00FD,$00FD,$00FC,$00FB,$00FB,$00FA,$00F9,$00F8,
				$00F7,$00F6,$00F5,$00F3,$00F2,$00F1,$00EF,$00EE,
				$00EC,$00EA,$00E8,$00E7,$00E5,$00E3,$00E1,$00DF,
				$00DC,$00DA,$00D8,$00D5,$00D3,$00D0,$00CE,$00CB,
				$00C8,$00C6,$00C3,$00C0,$00BD,$00BA,$00B7,$00B4,
				$00B1,$00AD,$00AA,$00A7,$00A3,$00A0,$009C,$0099,
				$0095,$0092,$008E,$008A,$0087,$0083,$007F,$007B,
				$0077,$0073,$006F,$006B,$0067,$0063,$005F,$005B,
				$0057,$0053,$004E,$004A,$0046,$0041,$003D,$0039,
				$0035,$0030,$002C,$0027,$0023,$001F,$001A,$0016,
				$0011,$000D,$0008,$0004,$0000,$FFFC,$FFF8,$FFF3,
				$FFEF,$FFEA,$FFE6,$FFE1,$FFDD,$FFD9,$FFD4,$FFD0,
				$FFCB,$FFC7,$FFC3,$FFBF,$FFBA,$FFB6,$FFB2,$FFAD,
				$FFA9,$FFA5,$FFA1,$FF9D,$FF99,$FF95,$FF91,$FF8D,
				$FF89,$FF85,$FF81,$FF7D,$FF79,$FF76,$FF72,$FF6E,
				$FF6B,$FF67,$FF64,$FF60,$FF5D,$FF59,$FF56,$FF53,
				$FF4F,$FF4C,$FF49,$FF46,$FF43,$FF40,$FF3D,$FF3A,
				$FF38,$FF35,$FF32,$FF30,$FF2D,$FF2B,$FF28,$FF26,
				$FF24,$FF21,$FF1F,$FF1D,$FF1B,$FF19,$FF18,$FF16,
				$FF14,$FF12,$FF11,$FF0F,$FF0E,$FF0D,$FF0B,$FF0A,
				$FF09,$FF08,$FF07,$FF06,$FF05,$FF05,$FF04,$FF03,
				$FF03,$FF02,$FF02,$FF02,$FF02,$FF02,$FF01,$FF02,
				$FF02,$FF02,$FF02,$FF02,$FF03,$FF03,$FF04,$FF05,
				$FF05,$FF06,$FF07,$FF08,$FF09,$FF0A,$FF0B,$FF0D,
				$FF0E,$FF0F,$FF11,$FF12,$FF14,$FF16,$FF18,$FF19,
				$FF1B,$FF1D,$FF1F,$FF21,$FF24,$FF26,$FF28,$FF2B,
				$FF2D,$FF30,$FF32,$FF35,$FF38,$FF3A,$FF3D,$FF40,
				$FF43,$FF46,$FF49,$FF4C,$FF4F,$FF53,$FF56,$FF59,
				$FF5D,$FF60,$FF64,$FF67,$FF6B,$FF6E,$FF72,$FF76,
				$FF79,$FF7D,$FF81,$FF85,$FF89,$FF8D,$FF91,$FF95,
				$FF99,$FF9D,$FFA1,$FFA5,$FFA9,$FFAD,$FFB2,$FFB6,
				$FFBA,$FFBE,$FFC3,$FFC7,$FFCB,$FFD0,$FFD4,$FFD9,
				$FFDD,$FFE1,$FFE6,$FFEA,$FFEF,$FFF3,$FFF8,$FFFC,
				$0000,$0004,$0008,$000D,$0011,$0016,$001A,$001F,
				$0023,$0027,$002C,$0030,$0035,$0039,$003D,$0041,
				$0046,$004A,$004E,$0053,$0057,$005B,$005F,$0063,
				$0067,$006B,$006F,$0073,$0077,$007B,$007F,$0083,
				$0087,$008A,$008E,$0092,$0095,$0099,$009C,$00A0,
				$00A3,$00A7,$00AA,$00AD,$00B1,$00B4,$00B7,$00BA,
				$00BD,$00C0,$00C3,$00C6,$00C8,$00CB,$00CE,$00D0,
				$00D3,$00D5,$00D8,$00DA,$00DC,$00DF,$00E1,$00E3,
				$00E5,$00E7,$00E8,$00EA,$00EC,$00EE,$00EF,$00F1,
				$00F2,$00F3,$00F5,$00F6,$00F7,$00F8,$00F9,$00FA,
				$00FB,$00FB,$00FC,$00FD,$00FD,$00FE,$00FE,$00FE,
				$00FE,$00FE,$00FF,$00FE,$00FE,$00FE,$00FE,$00FE	]:INT

	/* Set the Rnd() seed with the current time */
	CurrentTime({x},{y})
	Rnd(-x)

	thistask:=FindTask(NIL)
	gadtoolsbase:=OpenLibrary({txt_gadtools},VERSION)
	CreateContext({context})
	lastgad:=context
	scr:=LockPubScreen(NIL)
	visual:=GetVisualInfoA(scr,NIL)

	/* make our gadgets (all 2 of them! :) */

	ForAll({gad},
		[	[BUTTON_KIND,5,167,290,12,'About and Options',`options()]:form_gadget,
			[BUTTON_KIND,5,180,290,12,'Jump Around The Place',`jumpabout()]:form_gadget	],
		`lastgad:=CreateGadgetA(gad.kind,lastgad,
			[	gad.x,gad.y,gad.dx,gad.dy,gad.text,
				['topaz.font',8,0,0]:textattr,
				2,0,visual,gad.func	]:newgadget,NIL) )

	/* open our window.. */

	wnd:=OpenWindowTagList(NIL,
	[	WA_FLAGS,WIN_FLAGS,WA_IDCMP,WIN_IDCMP,
		WA_LEFT,100,	WA_TOP,40,
		WA_WIDTH,300,	WA_HEIGHT,195,
		WA_TITLE,'The Fuel Guage',
		WA_GADGETS,context,NIL,NIL	])

	UnlockPubScreen(NIL,scr)
	scr:=NIL
	rast:=stdrast:=wnd.rport
	SetTopaz(8)

	/* fill the screen with BLU */

	SetAPen(rast,BLU)
	RectFill(rast,wnd.borderleft,wnd.bordertop,
		wnd.width-wnd.borderright-1,wnd.height-wnd.borderbottom-1)

	ForAll({bev},
		[	[5,15,290,150,RECESSED,GRY]:form_bevel,
			[65,38,170,105,NIL,BLK]:form_bevel,
			[10,38,50,105,NIL,GRY]:form_bevel,
			[240,38,50,105,NIL,GRY]:form_bevel	],
		`Box(bev.x,bev.y,bev.x+bev.dx-1,bev.y+bev.dy-1,
			bev.col) BUT DrawBevelBoxA(rast,bev.x,bev.y,bev.dx,bev.dy,
			[	GT_VISUALINFO,visual,
				IF bev.rec THEN GTBB_RECESSED ELSE NIL,NIL,NIL]))

	RefreshGadgets(context,wnd,NIL)
	Gt_RefreshWindow(wnd,NIL)

	messagelist:=	[	'Amiga E 2.1b','Yo!','COLD COFFEE DESIGN',
						'CONTAINS CAFFEINE','MADE IN AUSTRALIA',
						'The earth is flat.','Elvis is dead',
						'Morrissey is good','Needle Nardle Noo',
						'Yacabarcoo','Awooble','Caffine','Coffee',
						'Tea','Coke (tm)','Pizza','Supreem',
						'Ham and Pineapple','Alcohol','Hmmm.. Beer',
						'Southern Comfort','Confection','Chocolate',
						'Misc Sugar Products',':-)',':->',':-<',
						':-(','Tom Jones Rulz (joke)','Beverly Hills 90210',
						'Melrose Place','The Simpsons','I\am a tea pot',
						'SPAWN','Homer','Bart!','Maggie','Lisa','Marge',
						'Mr Burns','Smithers','Ned Flanders'	]

	/*	A LIST of LISTs containing LISTs of spacial coordinates.  These
		should only be CHARs but then they wouldn't be E Lists anymore. :-(

		format:		[	[	[1,2,3],	coords
							[4,5,6]		coords	]	object	]	shapelist
	*/

	shapelist:=[[ 	[	255,	0,	128,	0,	0,	255,	79,	243,	128,
						255,	0,	128,	79,	-243,	128,	0,	0,	255 ],
					[	-207,	-150,	128,	0,	0,	255,	-207,	150,	128,
						-207,	-150,	128,	79,	-243,	128 ],
					[	79,	243,	128,	-207,	150,	128 ],
					[	207,	150,	-128,	0,	0,	-255,	-79,	243,	-128,
						207,	150,	-128,	207,	-150,	-128,	0,	0,	-255 ],
					[	-79,	-243,	-128,	0,	0,	-255,	-255,	0,	-128,
						-79,	-243,	-128,	207,	-150,	-128 ],
					[	-79,	243,	-128,	-255,	0,	-128,	-207,	150,	128,
						-79,	243,	-128,	79,	243,	128,	207,	150,	-128,
						255,	0,	128,	207,	-150,	-128,	79,	-243,	128,
						-79,	-243,	-128,	-207,	-150,	128,	-255,	0,	-128 ] ],

				[	[R,R,R,R,R,-R,R,-R,-R,R,-R,R,R,R,R,R,-R,R,-R,-R,R,-R,R,R,R,R,R],
					[-R,-R,-R,-R,-R,R,-R,R,R,-R,R,-R,-R,-R,-R,-R,R,-R,R,R,-R,R,-R,-R,-R,-R,-R]	],

				[	[0,100,0, 100,-100,-100, 100,-100,100, 0,100,0, -100,-100,100, 100,-100,100],
					[0,100,0, -100,-100,100, -100,-100,-100, 0,100,0, 100,-100,-100, -100,-100,-100]]]

	shapenames:=['Icosahedron','Wouter\as Cube','A pointy thing.']

	/* I'v hiden the colours in the first byte of shapesizes as the values
	are so big, a few extra won't hurt - pritty silly, i know.  In general,
	not good practice - but ain't it fun!  */

	shapesizes:=[1800 OR WHT,1400 OR BLU,1200 OR GRY]

	/* All memtypes we must check - see:  OBJECT memblock (up there ^^^) */

	memlist:=[	[	MEMF_CHIP,'CHIP',LEFT, NIL,NIL,NIL	]:memblock,
				[	MEMF_FAST,'FAST',RIGHT,NIL,NIL,NIL	]:memblock ]

	perform([	`storetotal(available(MEMF_TOTAL OR mem.type)),
				`StringF(gstr,'\s',
					mem.text) BUT autotext(mem.position,BOTTOM1,gstr),
				`StringF(gstr,'\d K',
					mem.total) BUT autotext(mem.position,BOTTOM2,gstr),
				`level()	])

	autotext(CENTRE,TOP1,'· MEMORY AVAILABLE ·')
	autotext(CENTRE,BOTTOM2,'· MEMORY POOL TOTAL ·')

    setmiddle3d(150,90)
	origpri:=setpri(-1)
	setshape()
	LOOP
		IF images
			/*  only redraw display if available memory has changed since last time */

			perform([	`storeavail(available(mem.type)),
						`IF mem.avail<>mem.lastavail THEN level() ELSE NIL	])
			drawshape(BLK)	/* Delete old image */
			IF count++>MAXCOUNT
				count:=NIL
				IF currentshape++=(ListLen(shapelist)-1) THEN currentshape:=NIL
				setshape()
			ENDIF

			/* rotate image */

			init3d(	phi		:=	IF phi>358 THEN 0 ELSE phi+2,
					theta	:=	IF theta>358 THEN 0 ELSE theta+3	)

			/*	Draw new image and extract the colour from
				shapesizes[currentshape] */

			drawshape(shapesizes[currentshape] AND $FF)
		ENDIF
			/*  We  check Gt_GetIMsg() every frame (or there abouts - if we
				can)  but  only update vectors every 'speed' (or there abouts -
				if we can :).  A timer would be more appropiate but that
				would take time (funny that) */
		FOR frameloop:=1 TO speed
			WaitTOF()
			IF scrolldown=NIL
				/* scrolldown:=Rnd() # of frames to wait until next message */
				scrolldown:=Rnd(400)+100
				autotext(CENTRE,TOP2,messagelist[Rnd(ListLen(messagelist))])
			ELSEIF scrolldown<11
				ScrollRaster(rast,0,-2,65,26,235,36)
			ENDIF
			scrolldown--	/* decrement scrolldown counter */
			WHILE imes:=Gt_GetIMsg(wnd.userport)
				imclass:=imes.class
				code:=imes.code
				Gt_ReplyIMsg(imes)
				SELECT imclass
					CASE IDCMP_GADGETUP
						iaddress:=imes.iaddress
						Eval(iaddress.userdata)
					CASE IDCMP_CLOSEWINDOW
						autotext(CENTRE,TOP2,'BYE!   BYE!')
						/* Spilt the window down the middle! */
						FOR x:=1 TO 75
							WaitTOF()
							ScrollRaster(rast,2,0,0,0,150,195)
							ScrollRaster(rast,-2,0,150,0,300,195)
						ENDFOR
						setpri(origpri)
						Raise(NIL)
				ENDSELECT
			ENDWHILE
		ENDFOR
	ENDLOOP
EXCEPT
	/* The advantages of exceptions are that they have stopped my IF ELSE
		ENDIF nests flying of into buggery.  Thankyou Wouter!  */

	IF scr THEN UnlockPubScreen(NIL,NIL)
	IF wnd THEN CloseWindow(wnd)
	IF context THEN FreeGadgets(context)
	IF visual THEN FreeVisualInfo(visual)
	IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)

	/* All the horrible things that could have gone wrong. */

	IF exception
		WriteF('COLD COFFEE ALERT: Failure occured with no \s\n\b\n\b',
			ListItem([	NIL,'Memory',{txt_gadtools},'Kick 2.0',
						'Screen Lock','Visual Info','Window',
						'Gadgets'],exception) )
	ENDIF
ENDPROC

/*	storetotal() and storeavail() where nessisary is E 2.1b does not allow..
		`mem.avail:=available(mem.type)
	..which would have been alot more fun. */

PROC storetotal(x)
	mem.total:=x
ENDPROC

PROC storeavail(x)
	mem.avail:=x
ENDPROC

/*  Note  the double nested ForAll() performs all quoted expressions in the
	list for all in 'memlist'.  */

PROC perform(list)
	DEF exp
ENDPROC ForAll({exp},list,`ForAll({mem},memlist,exp))

PROC level()
	DEF offset,percent

	/* I doubt if this is very acurate - maths is not my forte */

	percent:=(mem.avail/(IF (x:=mem.total/100) THEN x ELSE 1))
	offset:=mem.position
	Box(offset,40,offset+41,140-percent,BLK)	/* Top bit */
	Box(offset,140-percent,offset+41,140,BLU)	/* Bottom bit */
	mem.lastavail:=mem.avail
	StringF(gstr,'\d K',mem.avail) BUT autotext(mem.position,TOP1,gstr)
	StringF(gstr,'\d %',percent) BUT autotext(mem.position,TOP2,gstr)
ENDPROC

PROC setshape()
    setpers3d(shapesizes[currentshape],300)
	autotext(CENTRE,BOTTOM1,shapenames[currentshape])
ENDPROC

/* autotext() displays all text detecting position and justifing. */

PROC autotext(x,y,string)
	SELECT x
		CASE LEFT
			rast.cp_x:=14
		CASE RIGHT
			rast.cp_x:=284-tlen(string)
		CASE CENTRE
			Box(65,y-7,235,y+1,GRY)
			rast.cp_x:=150-(tlen(string)/2)
		DEFAULT
			rast.cp_x:=x
	ENDSELECT
	rast.cp_y:=y
	Colour(BLK,GRY)
ENDPROC Text(rast,string,StrLen(string))

PROC tlen(string)
ENDPROC TextLength(rast,string,StrLen(string))

PROC available(memf)
ENDPROC AvailMem(memf OR MEMF_PUBLIC)/1024

PROC setpri(pri)
ENDPROC SetTaskPri(thistask,pri)

PROC options()
	DEF result

	/* We create the options accordingly */

	StringF(gstr,'\s Images|Rotate \s|Thankyou',
		IF images THEN 'Stop' ELSE 'Start',
		IF speed=SLOW THEN 'Fast' ELSE 'Slow')
	result:=EasyRequestArgs(0,[20,0,0,{txt_about},gstr],0,NIL)
	SELECT result
		CASE 1
			images:=IF images THEN FALSE ELSE TRUE
		CASE 2
			speed:=IF speed=SLOW THEN FAST ELSE SLOW
	ENDSELECT
ENDPROC

/* I had a spare button and decided to do something useless with it.  */

PROC jumpabout()
	FOR x:=1 TO 5+Rnd(10) DO MoveWindow(wnd,100-Rnd(200),50-Rnd(100))
	autotext(CENTRE,TOP2,'Arrrrr! This is fun!')
ENDPROC

PROC drawshape(col)
  DEF polygon

  ForAll({polygon},shapelist[currentshape],`polygon3d(polygon,col))
ENDPROC

/* Since we use this string twice, why not reference it through {}

	Hurry up Wouter and make:	CONST MYSTRING='E is cool'

*/

txt_gadtools:

CHAR 'gadtools.library',0

txt_about:

CHAR	'           The Fuel Guage\n\n',
		'© COPYRIGHT 1994 Christian Catchpole\n\n',
		'         COLD COFFEE DESIGN\n',
		'MADE IN AUSTRALIA - CONTAINS CAFFEINE\n\n',
		'Written in Wouter\as E2.1b using some\n',
		'routines from \avec.e\a. E users and\n',
		'all others please write (100%% Legal :).\n\n',
		'Snail Mail:  CHRISTIAN CATCHPOLE,\n',
		'             P.O. BOX 388,\n',
		'             CHERMSIDE 4032,\n',
		'             AUSTRALIA\n',0

/********* This is Wouter's from here down ********/

PROC polygon3d(list:PTR TO LONG,col)
  DEF n,i,sx,sy,ox,oy,f=FALSE
  n:=ListLen(list)/3
  FOR i:=1 TO n
    vec3d(list[]++,list[]++,list[]++,{sx},{sy})
    IF f THEN Line(ox,oy,sx,sy,col) ELSE f:=TRUE
    ox:=sx; oy:=sy;
  ENDFOR
ENDPROC

PROC init3d(phi,theta)
	MOVE.L	sintab,A0		/* uses A0,A1,D0 */
	LEA	c1(PC),A1
	MOVE.L	phi,D0
	LSL.W	#1,D0
	MOVE.W	0(A0,D0.W),6(A1)
	ADD.W	#180,D0
	MOVE.W	0(A0,D0.W),2(A1)
	MOVE.L	theta,D0
	LSL.W	#1,D0
	MOVE.W	0(A0,D0.W),4(A1)
	ADD.W	#180,D0
	MOVE.W	0(A0,D0.W),(A1)
ENDPROC

PROC setpers3d(irho,id)        /* for average size rho:d = 5:2 */
	LEA	rho(PC),A0
	MOVE.W	irho.W,(A0)
	MOVE.W	id.W,2(A0)
ENDPROC

PROC setmiddle3d(x,y)
	LEA	midx(PC),A0
	MOVE.W	x.W,(A0)
	MOVE.W	y.W,2(A0)
ENDPROC

c1:	INT	$00c2
c2:	INT	$0045
s1:	INT	$00a3
s2:	INT	$00f5
rho:	INT	2000
d:	INT	900
midx:	INT	160
midy:	INT	128

PROC vec3d(x,y,z,sx,sy)
	MOVE.L	x,D0
	MOVE.L	y,D1
	MOVE.L	z,D2
	MOVE.L	A4,-(A7)
	MOVE.W	c1(PC),D3
	MOVE.W	c2(PC),D4
	MOVE.W	s1(PC),D5
	MOVE.W	s2(PC),D6
	MOVE	D0,D7			/* EXPECTS X,Y,Z IN D0-D2 */
	MULS	D5,D7			/* TRASHES ALL REGS BUT A5-A7 */
	ASR.L	#8,D7
	MOVE	D7,A0			/* TEMP1 = X*S1 */
	MOVE	D1,D7
	MULS	D3,D7
	ASR.L	#8,D7
	SUB	A0,D7
	MOVE	D7,A2			/* XE = Y*C1-TEMP1 */
	MOVE	D1,D7
	MULS	D5,D7
	ASR.L	#8,D7
	MULS	D4,D7
	ASR.L	#8,D7
	MOVE	D7,A0			/* TEMP1 = Y*S1*C2 */
	MOVE	D0,D7
	MULS	D3,D7
	ASR.L	#8,D7
	MULS	D4,D7
	ASR.L	#8,D7
	MOVE	D7,A1			/* TEMP2 = X*C1*C2 */
	MOVE	D2,D7
	MULS	D6,D7
	ASR.L	#8,D7
	SUB	A0,D7
	SUB	A1,D7
	MOVE	D7,A3			/* YE = Z*S2-TEMP1-TEMP2 */
	MULS	D6,D0
	ASR.L	#8,D0
	MULS	D3,D0
	ASR.L	#8,D0
	MOVE	D0,A0			/* TEMP1 = X*S2*C1 */
	MULS	D6,D1
	ASR.L	#8,D1
	MULS	D5,D1
	ASR.L	#8,D1
	MOVE	D1,A1			/* TEMP2 = Y*S2*S1 */
	NEG	D2
	MULS	D4,D2
	ASR.L	#8,D2
	ADD	rho(PC),D2
	SUB	A0,D2
	SUB	A1,D2			/* ZE(D2) = -Z*C2+RHO-TEMP1-TEMP2 */
	MOVE	A2,D3
	MOVE	A3,D4
	MOVE	d(PC),D0
	MOVE	D0,D1
	MULS	D3,D0
	DIVS	D2,D0
	ADD	midx(PC),D0		/* SX(D0) = D*XE/ZE+160 */
	NEG	D1
	MULS	D4,D1
	DIVS	D2,D1
	ADD	midy(PC),D1		/* SY(D1) = -D*YE/ZE+128 */
	MOVE.L	(A7)+,A4
	MOVE.L	sx,A0
	EXT.L	D0
	MOVE.L	D0,(A0)
	MOVE.L	sy,A0
	EXT.L	D1
	MOVE.L	D1,(A0)
ENDPROC
