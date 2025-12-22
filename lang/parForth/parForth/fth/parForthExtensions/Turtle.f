include? time&date.f parForthExtensions/time&date.f
include? Random.f    parForthExtensions/Random.f
include? MS.f        parForthExtensions/MS.f
include? API.f       parForthExtensions/API.f
include? GadTools.f  parforthExtensions/GadTools.f

ANEW Turtle.f
\ ndh 2/2/23 Turtle Graphics 0.2
	
\ Turtle Graphics Words
\	Basic Commands
\		TURTLE							open Turtle Graphics window
\											black ink
\											white canvas
\											canvas width 10,000 points
\											canvas height proportional to window width/height
\											origin, point (0,0), in center of canvas
\											see SAVEPREFS
\		SQUASH							close Turtle Graphics window
\		BYE								close graphics window and ends program
\
\		PENUP							moving turtle will not draw anything
\		PENDOWN							moving turtle draws a line along its path
\		90 LEFT							rotate the turtle left by 90 degrees
\		45 RIGHT						rotate the turtle right by 45 degrees
\		0 HEADING						change the turtle heading to 0 degrees (pointed to right of screen)
\		500 FORWARD						move the turtle forward 500 points
\		-250 500 GOTO					goto point (-250,500)
\		HOME							move the turtle to point (0,0)
\											see NEWHOME
\		500 180 ARC						draw a semi-circle to the left with a radius of 500 points
\		-500 90 ARC						draw a 90 degree arc to the right with a radius of 500 points
\		500 CIRCLE						same as 500 360 ARC
\		RED INK							change the drawing ink to red
\		BLACK CANVAS					change the canvas color to black on the next CLEAR
\		CLEAR							clear the window, move to ORIGIN, 0 HEADING, PENDOWN, SHOWTURTLE
\		REFRESHWINDOW					after resizing window, establish a canvas encompassing new dimensions
\		SAVEPREFS						save ink, window size & placement, canvas width & color, colors for next session 
\
\	Basic Programming
\		100 VALUE MyVariable			define a variable named 'MyVariable' and set it to 100
\		10 TO MyVariable				change MyVariable's value to 10
\		DEFINE name ... END				define 'name' which executes commands ... until END
\		24 REPEAT[ ... ]				repeat commands ... 24 times
\
\		500 VALUE Length				assign 500 to variable 'Length'
\		DEFINE Square 4 REPEAT[ Length FORWARD 90 LEFT ] END
\		Square							draw a square with sides of length 500
\
\	Advanced Commands
\		HIDETURTLE						suppress display of turtle (speeds drawing)
\		SHOWTURTLE						display turtle if previously hidden
\		0 SPEED							FASTEST drawing speed (0 millisecond delay between draws)
\		RNDCOLOR INK					set ink to a random color
\		0 0 0 COLOR BLACK				define the color 'black' with rgb values (0-255) of 0 0 0
\		COLORS							list defined colors
\		INK?							print current ink color
\		CANVAS?							print current canvas color
\		500 BACKWARD					same as -500 FORWARD
\		250 5 POLYGON					draw a pentagram with sides of length 250
\		10 1000 5 POLYGONAL				draw 10 pentagrams with sides of length 1000
\		DOT								draw a dot at current point if PENDOWN
\		XY								leave coordinates of turtle's location on stack
\		X								leave only X coordinate
\		Y								leave only Y coordinate
\		LEFTMOST						leave minimum X on stack
\		RIGHTMOST						leave maximum X on stack
\		BOTTOMMOST						leave minimum Y on stack
\		TOPMOST							leave maximum Y on stack
\		NEWHOME							make the current location the new home (origin)
\		500 MOVEHOME					PENUP 500 FORWARD NEWHOME PENDOWN
\		ORIGIN							restore the original origin as home and go there
\		20000 CANVASWIDTH				set canvas width to 20,000 (-10,000 to 10,000) and CLEAR
\		BOTTOMLEFT						move to bottom left of canvas
\		BOTTOMRIGHT						move to bottom right of canvas
\		TOPLEFT							move to top left of canvas
\		TOPRIGHT						move to top right of canvas
\		FLOOD							replace color of adjacent pixels below turtle with current ink
\		BEGINFILL						begin drawing outline of a shape to be filled
\		ENDFILL							fill shape just drawn with current ink
\		USEPREFS						save prefs to file ENV:pfTurtle.prefs but not to ENVARC:
\		5 WIDTH							set pen width to 5 pixels
\
\		Advanced Programming			all parForth words are available; ] redefined as OLD]
 
\ Some structures ***************************************************
:STRUCT ViewPort			\ intuition/screens.j
	APTR	vp_Next
	APTR 	vp_ColorMap
	APTR 	vp_DspIns
	APTR 	vp_SprIns
	APTR 	vp_ClrIns
	APTR 	vp_UCopIns
	SHORT 	vp_DWidth
	SHORT 	vp_DHeight
	SHORT 	vp_DxOffset
	SHORT 	vp_DyOffset
	USHORT 	vp_Modes
	UBYTE 	vp_SpritePriorities
	UBYTE 	vp_ExtendedModes
	APTR 	vp_RasInfo
;STRUCT
-1	constant PRECISION_EXACT
0   constant PRECISION_IMAGE
16  constant PRECISION_ICON
32  constant PRECISION_GUI
$ 84000000   constant OBP_Precision
$ 84000001   constant OBP_FailIfBad

:STRUCT RastPort			\ graphics/rastport.j
	APTR	rp_Layer
	APTR 	rp_BitMap
	APTR 	rp_AreaPtrn
	APTR 	rp_TmpRas
	APTR 	rp_AreaInfo
	APTR 	rp_GelsInfo
	UBYTE 	rp_Mask
	BYTE 	rp_FgPen
	BYTE 	rp_BgPen
	BYTE 	rp_AOlPen
	BYTE 	rp_DrawMode
	BYTE 	rp_AreaPtSz
	BYTE 	rp_linpatcnt
	BYTE 	rp_dummy
	USHORT 	rp_Flags
	USHORT 	rp_LinePtrn
	SHORT 	rp_cp_x
	SHORT 	rp_cp_y
    8 BYTES rp_minterms
	SHORT 	rp_PenWidth
	SHORT 	rp_PenHeight
	APTR 	rp_Font
	UBYTE 	rp_AlgoStyle
	UBYTE 	rp_TxFlags
	USHORT 	rp_TxHeight
	USHORT 	rp_TxWidth
	USHORT 	rp_TxBaseline
	SHORT 	rp_TxSpacing
	APTR 	rp_RP_User
	2 4 * BYTES rp_longreserved
    7 2 * BYTES rp_wordreserved
    8 BYTES rp_reserved
;STRUCT
0   constant JAM1
1   constant JAM2
2   constant COMPLEMENT
4   constant INVERSVID
$ 01   constant FRST_DOT
$ 02   constant ONE_DOT
$ 04   constant DBUFFER
$ 08   constant AREAOUTLINE
$ 20   constant NOCROSSFILL

:STRUCT TmpRas
	APTR tr_RasPtr
	LONG tr_Size
;STRUCT

:STRUCT AreaInfo
	APTR ai_VctrTbl
	APTR ai_VctrPtr
	APTR ai_FlagTbl
	APTR ai_FlagPtr
	SHORT ai_Count
	SHORT ai_MaxCount
	SHORT ai_FirstX
	SHORT ai_FirstY
;STRUCT

\ colors *****************************************************************************************************
: _ObtainBestPenA ( cm r g b tags -- pen|-1 ) 140 GfxBase CALL5 ;
: _ReleasePen	  ( cm pen -- )               158 GfxBase CALL2NR ;		\ pen=-1 is OK

STRUCTURE pfColor														\ parForth color ( co)
	ADDR:	co_Next														\ Next color
	SHORT:	co_Pen														\ AROS pen
	SHORT:	co_R														\ Red ( 0 - 255)
	SHORT:	co_G														\ Green
	SHORT:	co_B														\ Blue
	LONG:	co_Location													\ HEAP or DICT
	LONG:	co_Kept														\ keep pen rather than releasing in PenFree
STRUCTURE.END

CREATE -fg 0 ,															\ ptr to current fg
CREATE -bg 0 ,															\ ptr to current bg
CREATE Colors 0 ,								 						\ colors list

: cm ( -- cm ) sc sc_ViewPort S@ vp_ColorMap ;							\ sc's color map

: KEEP   ( co -- ) 1 ? TRUE  SWAP S! co_Kept ;							\ flag keep pen
: UNKEEP ( co -- ) 1 ? FALSE SWAP S! co_Kept ;							\ flag don't keep pen

: coNew   ( mem -- co )	DUP >R pfColor SWAP MEMORY DUP co_Next Colors	\ new color to colors list
	LINK R> OVER S! co_Location ;
: NoPen   ( co -- ) -1 SWAP S! co_Pen ;									\ -1 indicates no pen
: coFill  ( r g b co -- ) DUP NoPen TUCK S! co_B TUCK S! co_G S! co_R ; \ store rgb and -1 (no pen) for pen
: (COLOR) ( r g b mem -- co ) coNew DUP >R coFill R> ;					\ unnamed color
: COLOR   ( r g b -- ) 3 ? CREATE DICT (COLOR) DROP ( -- co ) ;			\ named color

: RndRGB   ( -- r g b ) 256 CHOOSE 256 CHOOSE 256 CHOOSE ;				\ random RGB
: RNDCOLOR ( -- co ) RndRGB HEAP (COLOR) ;								\ random color

: (>c32) ( c8 -- c32 ) -1 UM* 255 UM/MOD NIP ;							\ byte to 32bit
: >c32   ( r g b -- r32 g32 b32 ) ROT (>c32) ROT (>c32) ROT (>c32) ;	\ 3 c8s to c32s
: (pen)  ( r g b -- pen ) >c32 >R cm -ROT R> 0 _ObtainBestPenA 0 MAX ;	\ closest pen or 0
: rgb@   ( co -- r g b ) DUP S@ co_R OVER S@ co_G ROT S@ co_B ;			\ fetch rgb
: PEN    ( co -- pen ) 1 ?												\ get a pen for color co
	DUP S@ co_Pen 0< IF DUP rgb@ (pen) OVER S! co_Pen THEN S@ co_pen ;

: ?Release ( co -- ) DUP S@ co_Pen DUP -1 >									\ release pen if present
	IF cm SWAP _ReleasePen NoPen ELSE 2DROP THEN ;
: kept?    ( co -- f ) S@ co_Kept ;											\ is pen kept?
: PenFree  ( co -- ) DUP kept? NOT IF ?Release ELSE DROP THEN ;				\ release unkept pen

: InUse?     ( co -- f ) DUP -fg @ = SWAP -bg @ = OR ;									\ color in use?
: Foreground ( co -- ) DUP InUse? IF DROP EXIT THEN	-fg @ IF -fg @ PenFree THEN -fg ! ;	\ set new foreground color
: Background ( co -- ) DUP InUse? IF DROP EXIT THEN -bg @ IF -bg @ PenFree THEN -bg ! ;	\ set new background color
: DefaultColors ( -- ) 0 Foreground 0 Background ;										\ use screen defaults

: heap?  ( co -- f ) S@ co_Location HEAP = ;								\ is color in heap?
: coFree ( co -- ) DUP heap? IF DUP Colors UNLINK FREE ELSE DROP THEN ;		\ free color if in heap

: FreeColors ( -- )															\ release all pens, free colors in heap
	Colors BEGIN @ ?DUP WHILE DUP UNKEEP DUP PenFree DUP coFree REPEAT ;	\ included in TurtleEnd on BYE

\ pre-defined colors ---------------------------------------------------------------------------------------------
\ SAVEPREFS will save any user-defined colors
255 255 255 color White		\ 10 pre-defined colors
  0	  0	  0	color Black
127	127	127	color Grey		' Grey 'SYNONYM Gray
139	 69	 19	color Brown
255	  0	  0	color Red
255	120	  0	color Orange
255	216	  0	color Yellow
 74	154  38 color Green
 36	 17	145 color Blue
128	  0	128	color Purple

\ .Colors -----------------------------------------------------------------------------------------------------------
CREATE Many$ 1 C, BL C,
: many      ( u c -- c$ ) Many$ 1+ C! Many$ STRING $! 1- 0 ?DO Many$ LS $+! LOOP LS ;	\ create a string of u c's
: RJUSTIFY  ( c-addr1 u1 u2 c -- c-addr2 >u1|u2 )		\ create right justified string of width u2 with leading c's
	>R 2DUP >=							\ c-addr1 u1 u2 f	R: c		count greater than desired width u2? 
	IF DROP R> DROP						\ c-addr1 u1						yes, drop u2 and c
	ELSE DUP R> many					\ c-addr1 u1 u2 c$2					no, create a string of u2 chars c$2
		SWAP >R +PLACE				    \					R: u2				append c-addr1 u1 to c2$
		LS COUNT R> RIGHT				\ c-addr2 u2							leave right(c$2,u2)
	THEN ;
: $RJUSTIFY ( c$1 u2 c -- c$2 ) 2>R COUNT 2R> RJUSTIFY >STRING ;

: LJUSTIFY  ( c-addr1 u1 u2 c -- c-addr2 >u1|u2 )		\ create left justified string of width u2 with trailing c's
	>R 2DUP >=							\ c-addr1 u1 u2 f	R: c		count greate than desired width u2?
	IF DROP R> DROP						\ c-addr1 u1						yes, drop u2 and c
	ELSE DUP R> many					\ c-addr1 u1 u2 c$2					no, create a string of us chars c$2
		2>R STRING PLACE				\					R: c$2 u2			store c-addr1 u1 as c1$
		2R> LS $+!						\ u2									append c$2 to c1$
		LS COUNT ROT LEFT				\ c-addr2 u2							leave left(c$1,u2)
	THEN ;
: $LJUSTIFY ( c$1 u2 c -- c$2 ) 2>R COUNT 2R> LJUSTIFY >STRING ;

: 000     ( c$1 -- c$2 ) 3 [ CHAR 0 ] LITERAL $RJUSTIFY ;							\ 3 char RGB value
: $STR+|  ( n -- c$ ) $STR 000 C" |" OVER $+! ;										\ convert n to c$ and append "|"
: r|g|b$  ( r g b -- c$ ) ROT $STR+| ROT $STR+| OVER $+! SWAP $STR 000 OVER $+! ;	\ create r|g|b$
: .coRGB  ( co -- ) rgb@ r|g|b$ $. ;												\ print color's r|g|b$
: coName  ( co -- c-addr1 u ) BODY> >NAME COUNT 31 AND ;							\ convert color to name
: .coName ( co -- ) DUP heap? IF DROP S" IN HEAP" ELSE coName THEN 11 BL LJUSTIFY TYPE ; 
: .Color  ( co -- ) DUP .coName SPACE .coRGB CR ;									\ color name and r|g|b
: .Colors ( -- ) Colors BEGIN @ ?DUP WHILE DUP .Color REPEAT ;						\ print list of colors
: .Kept   ( -- ) Colors BEGIN @ ?DUP WHILE DUP kept? IF DUP .Color THEN REPEAT ;	\ print list of kept colors	

\ some graphics words ********************************************************************************************
: _SetAPen     ( rp pen -- )                     57 GfxBase CALL2NR ;
: _SetDrMd     ( rp mode -- )                    59 GfxBase CALL2NR ;
: _Move        ( rp x y -- )                     40 GfxBase CALL3NR ;
: _Draw        ( rp x y -- )                     41 GfxBase CALL3NR ;
: _WritePixel  ( rp x y -- f )                   54 GfxBase CALL3 ; 		\ 0=good, -1=pixel outside of RastPort
: _ReadPixel   ( rp x y -- pen )                 53 GfxBase CALL3 ;			\ -1=invalid
: _SetRast     ( rp pen -- )                     39 GfxBase CALL2NR ;
: _AllocRaster ( width height -- addr )          82 GfxBase CALL2 ;
: _FreeRaster  ( addr width height -- )          83 GfxBase CALL3NR ;
: _InitTmpRas  ( TmpRas buffer size -- TmpRas )  78 GfxBase CALL3 ;
: _Flood       ( rp mode x y -- f )              55 GfxBase CALL4 ;			\ 0=failure 
: _InitArea    ( areaInfo buffer maxVectors -- ) 47 GfxBase CALL3NR ;
: _AreaDraw    ( rp x y -- f )                   43 GfxBase CALL3 ;			\ 0=success, -1=buffer full
: _AreaMove    ( rp x y -- f )                   42 GfxBase CALL3 ;			\ 0=success, -1=buffer full
: _AreaEnd     ( rp -- f )                       44 GfxBase CALL1 ;			\ 0=success, -1=failure
: RASSIZE      ( width height -- bytes ) SWAP 15 + 3 ARSHIFT $ FFFE AND * ;	\ JForth/JForth/Util/graph_support

0 VALUE rp																	\ window's RastPort for drawing
: GetRP ( -- ) wd S@ wd_RPort TO rp ;

\ coordinate scaling and translation *******************************************
 10000 CONSTANT    10^4			\ 4 decimal places (10^4) held for scaling sines
100000 CONSTANT    10^5			\ 5 decimal places (10^5) held for scaling PI/180
  1745 CONSTANT IPI/180			\ integer PI/180 * 10^5
CREATE SINES				\ sin table (scaled by 10^4) at a degree of resolution
\  0       1	   2       3       4       5       6       7       8       9
0000 W, 0175 W, 0349 W, 0523 W, 0698 W, 0872 W, 1045 W, 1219 W, 1392 W, 1564 W,
1737 W, 1908 W, 2079 W, 2250 W, 2419 W, 2588 W, 2756 W, 2924 W, 3090 W, 3256 W,
3420 W, 3584 W, 3746 W, 3907 W, 4067 W, 4226 W, 4384 W, 4540 W, 4695 W, 4848 W,
5000 W, 5150 W, 5299 W, 5446 W, 5592 W, 5736 W, 5878 W, 6018 W, 6157 W, 6293 W,
6428 W, 6561 W, 6691 W, 6820 W, 6947 W, 7071 W, 7193 W, 7314 W, 7431 W, 7547 W,
7660 W, 7772 W, 7880 W, 7986 W, 8090 W, 8192 W, 8290 W, 8387 W, 8480 W, 8572 W,
8660 W, 8746 W, 8830 W, 8910 W, 8988 W, 9063 W, 9136 W, 9205 W, 9272 W, 9336 W,
9397 W, 9455 W, 9511 W, 9563 W, 9613 W, 9659 W, 9703 W, 9744 W, 9782 W, 9816 W,
9848 W, 9877 W, 9903 W, 9926 W, 9945 W, 9962 W, 9976 W, 9986 W, 9994 W, 9999 W,
10000 W,  

: sine    ( 0<=x<=90Deg -- sin*res ) DUP 0 91 WITHIN IF 2* SINES + W@ ELSE TRUE ABORT" Invalid sine" THEN ;
: degrees ( deg -- 0<=x<=360Deg ) 360 /MOD DROP 360 + 360 MOD ;	\ normalize angle
: sin     ( deg -- sin*10^4 ) degrees
	DUP  91 < IF sine ELSE								\ deg		quadrant 1
	DUP 181 < IF 180 SWAP - sine ELSE					\ deg       quadrant 2
	DUP 271 < IF 180 - sine NEGATE ELSE					\ deg		quadrant 3
	360 SWAP - sine NEGATE THEN THEN THEN ; 			\ deg		quadrant 4
: cos 	  ( deg -- cos*10^4 ) 90 SWAP - sin ;

CREATE Rotation 0 ,		\ cumulative rotation based on RIGHT and LEFT
: RotateX  ( hyp -- y ) Rotation @ COS 10^4 */ ;		\ find x given hypotenuse and angle
: RotateY  ( hyp -- x ) Rotation @ SIN 10^4 */ ;		\ find y given hypotenuse and angle

0 VALUE GZZWidth										\ window drawing width
0 VALUE GZZHeight	 									\ window drawing height
: GetGZZWidth  ( -- ) wd S@ wd_GZZWidth  TO GZZWidth ;
: GetGZZHeight ( -- ) wd S@ wd_GZZHeight TO GZZHeight ;

: ClipX   ( x1 -- x2 ) 0 MAX GZZWidth  MIN ;
: ClipY   ( y1 -- y2 ) 0 MAX GZZHeight MIN ;
: ClipXY  ( x1 y1 -- x2 y2 ) SWAP ClipX SWAP ClipY ;
: ClipX?  ( x -- f ) DUP 0< SWAP GZZWidth  > OR ;
: ClipY?  ( y -- f ) DUP 0< SWAP GZZHeight > OR ;
: ClipXY? ( x y -- f ) ClipY? SWAP ClipX? OR ;

0 VALUE XOrigin 										\ x-offset to origin
0 VALUE YOrigin 										\ y-offset to origin
: GetXOrigin ( -- ) GZZWidth  2 / TO XOrigin ;
: GetYOrigin ( -- ) GZZHeight 2 / TO YOrigin ;
: GetOrigin  ( -- ) GetXOrigin GetYOrigin ;

0 VALUE XHome											\ x coordinate for home
0 VALUE YHome											\ y coordinate for home
: REHOME  ( -- ) XOrigin TO XHome YOrigin TO YHome ;	\ restore home to origin

CREATE MyTmpRas TmpRas ALLOT							\ my temporary rastport structure
CREATE RWorkspace 0 ,									\ pointer to buffer provided by _AllocRaster
: DetachTmpRas  ( -- ) 0 rp S! rp_TmpRas RWorkspace @ GZZWidth GZZHeight _FreeRaster RWorkspace OFF ;
: ?DetachTmpRas ( -- ) RWorkspace @ IF DetachTmpRas THEN ;
: AttachTmpRas  ( -- ) ?DetachTmpRas					\ attach a temporary rastport for area fills
	GZZWidth GZZHeight _AllocRaster DUP 0= ABORT" Can't allocate temporary raster." RWorkspace !
	MyTmpRas RWorkspace @ GZZWidth GZZHeight RASSIZE _InitTmpRas 0= ABORT" Can't initialize temporary raster."
	MyTmpRas rp S! rp_TmpRas ;
: GetWindowSize ( -- ) ?DetachTmpRas GetGZZWidth GetGZZHeight GetOrigin ;

: X@  ( -- x ) rp S@ rp_cp_x ;							\ curr x
: Y@  ( -- y ) rp S@ rp_cp_y ;							\ curr y
: XY@ ( -- x y ) X@ Y@ ;								\ curr xy

\ pen width ------------------------------------------------------------------------------------
CREATE Wide 1 ,											\ pen width
CREATE OldWide 1 ,										\ width stored during area draw
CREATE WSign 0 ,										\ each course rotates outside then inside of baseline
CREATE WdX 0 ,											\ width delta X
CREATE WdY 0 ,											\ width delta Y

: Quad1?  ( -- f ) Rotation @ DUP 0 45 WITHIN SWAP 315 360 WITHIN OR ;
: Quad2?  ( -- f ) Rotation @  45 135 WITHIN ;
: Quad3?  ( -- f ) Rotation @ 135 225 WITHIN ;
: Quad4?  ( -- f ) Rotation @ 225 315 WITHIN ;
: WToggle ( -- ) WSign DUP @ -1 * SWAP ! ;
: WDelta  ( I -- ) >R									\ delta X Y for Ith course stored in WdX and WdY
	Quad1? IF  0  1 ELSE								\ 1st course is outside of left square
	Quad2? IF  1  0 ELSE
	Quad3? IF  0 -1 ELSE
	Quad4? IF -1  0 ELSE
	TRUE ABORT" Bad wide delta" THEN THEN THEN THEN
	R@ * WSign @ * WdY ! R> * WSign @ * WdX ! ;			\ courses alternate outside then inside of base line
: IncXY  ( x0 y0 -- x1 y1 ) WdY @ + SWAP WdX @ + SWAP ;
: Inc2XY ( x0 y0 x1 y1 -- x2 y2 x3 y3 ) 2>R IncXY 2R> IncXY ;
: WDraw  ( rp x y -- )									\ draw wide no. of lines
	Wide @ 1 = IF _Draw ELSE ROT DROP WSign ON			\ dest								drop rp, WSign=-1
	2DUP XY@											\ final dest src
	Wide @ 0 DO											\ final dest src					for each course of width
		2OVER 2OVER I 2 /MOD + WDelta Inc2XY			\ final dest+d src+d dest+d src+d	4DUP, IncXY for Ith course
		rp -ROT _Move rp -ROT _Draw						\ final dest+d src+d				goto src, draw to dest  
		WToggle											\ final dest+d src+d				toggle inside/outside baseline
	LOOP 2DROP 2DROP									\ final
	rp -ROT _Move THEN ;								\									move to final baseline position					

\ turtle stamp ************************************************************************************************
CREATE TurtleOpen 0 ,									\ is turtle window open?
: ?Turtle ( -- ) TurtleOpen @ NOT ABORT" Turtle window unopened" ;

\ turtle is a 10 x 10 (or 7 x 7) black arrowhead with a red pixel at the head
\ red buttock is 9 ( or 13) 
CREATE Hidden -1 ,										\ ON|OFF turtle hidden?
CREATE LastStamp 0 , 0 ,								\ coordinates of last turtle stamp
CREATE StampOrientation 0 ,								\ 0 to 7 (45 degree increments); last stamp
CREATE UnderStampIndex 0 ,								\ Index into array below
CREATE UnderStamp 30 CELLS ALLOT						\ pen number array underneath turtle stamp
														\ 0=point, 1-10 backleft, 11-20 backright, 21-30 buttock
CREATE BackLefts ( starting at head)					\ delta xy array by orientation for back left arrow half
-1 -1 2,	\ delta xy for 0 (0) orientation
-1  0 2,	\ 1  (45) orientation
-1  1 2,	\ 2  (90)
 0  1 2,	\ 3 (135)
 1  1 2,	\ 4 (180)
 1  0 2,	\ 5 (225)
 1 -1 2,	\ 6 (270)
 0 -1 2,	\ 7 (315)

CREATE BackRights ( starting at head)					\ delta xy array by orientation for back right arrow half 
-1  1 2,	\ delta xy for 0 (0) orientation
 0  1 2,	\ 1  (45) orientation
 1  1 2,	\ 2  (90)
 1  0 2,	\ 3 (135)
 1 -1 2,	\ 4 (180)
 0 -1 2,	\ 5 (225)
-1 -1 2,	\ 6 (270)
-1  0 2,	\ 7 (315)

CREATE Buttocks ( starting at tail of backright)		\ delta xy by orientation for buttock
 0 -1 2,	\ delta xy for 0 (0) orientation
-1 -1 2,	\ 1  (45) orientation
-1  0 2,	\ 2  (90)
-1  1 2,	\ 3 (135)
 0  1 2,	\ 4 (180)
 1  1 2,	\ 5 (225)
 1  0 2,	\ 6 (270)
 1 -1 2,	\ 7 (315)

: Rot>Stamp    ( -- ) Rotation @ 22 + degrees 45 / StampOrientation ! ;		\ convert rotation to stamp orientation
: USIInc       ( -- ) 1 UnderStampIndex +! ;								\ increment understamp index
: Underneath   ( -- addr ) UnderStamp UnderStampIndex @ CELLS + ;			\ index into UnderStamp array
: Pen@         ( -- pen ) Underneath @ ;									\ fetch pen# from UnderStamp array
: Pen!         ( pen -- ) Underneath ! ;									\ store pen# into UnderStamp array  
: (XYDelta)    ( x1 y1 dx dy -- x2 y2 ) ROT + -ROT + SWAP ;					\ add deltas to x1 y1
: XYDelta      ( x1 y1 BackL|Rs -- x2 y2 ) StampOrientation @ [ 2 CELLS ] LITERAL * + 2@ (XYDelta) ;
: BLDelta      ( x1 y1 -- x2 y2 ) BackLefts  XYDelta USIInc ;				\ add backleft delta and increment index
: BRDelta      ( x1 y1 -- x2 y2 ) BackRights XYDelta USIInc ;				\ add backright delta and increment index
: BuDelta      ( x1 y1 -- x2 y2 ) Buttocks   XYDelta USIInc ;				\ add buttock delta and increment index
: UnderSave    ( x2 y2 -- ) rp -ROT _ReadPixel Pen! ;						\ save pen under point
: UnderRestore ( x2 y2 -- ) rp Pen@ _SetAPen RP -ROT _WritePixel DROP ;		\ restore color under point
: BLSave       ( x1 y1 -- x2 y2 ) BLDelta 2DUP UnderSave ;					\ go backleft, save pen under point
: BRSave       ( x1 y1 -- x2 y2 ) BRDelta 2DUP UnderSave ;					\ go backright, save pen under point
: BuSave       ( x1 y1 -- x2 y2 ) BuDelta 2DUP UnderSave ;					\ go buttock, save pen under point
: BLRestore    ( x1 y1 -- x2 y2 ) BLDelta 2DUP UnderRestore ;				\ go backleft, restore pen under point
: BRRestore    ( x1 y1 -- x2 y2 ) BRDelta 2DUP UnderRestore ;				\ go backright, restore pen under point
: BuRestore    ( x1 y1 -- x2 y2 ) BuDelta 2DUP UnderRestore ;				\ go buttocks, restore pen under point

\ calculate upper bounds for loops (arrows on diagonals vs arrows on axes)
: UpBack       ( -- u ) 7 StampOrientation @ 2 MOD 3 * + ;					\ 7 for diagonals, 10 if on axes
: UpBut        ( -- u ) UpBack 7 = IF 13 ELSE 9 THEN ;						\ 13 for diagonals, 9 if on axes

: HeadSave      ( -- ) UnderStampIndex OFF xy@ UnderSave ;					\ save pen under arrow head  
: BackLeftSave  ( -- )        xy@ UpBack 0 DO BLSave LOOP 2DROP ;			\ save backleft arrow half
: BackRightSave ( --  x1 y1 ) xy@ UpBack 0 DO BRSave LOOP ;					\ save backright arrow half, leave last coord
: ButtockSave   ( x1 y1 -- )      UpBut  0 DO BuSave LOOP 2DROP ;			\ save buttock 
: StampSave     ( -- ) HeadSave BackLeftSave BackRightSave ButtockSave ;	\ save colors under stamp

: HeadRestore      ( -- ) UnderStampIndex OFF LastStamp 2@ UnderRestore ;	\ restore arrow head
: BackLeftRestore  ( -- ) LastStamp 2@ UpBack 0 DO BLRestore LOOP 2DROP ;	\ restore backleft arrow half
: BackRightRestore ( -- x1 y1 ) LastStamp 2@ UpBack 0 DO BRRestore LOOP ;	\ restore backright arrow half, leave last coord
: ButtockRestore   ( x1 y1 -- ) UpBut  0 DO BuRestore LOOP 2DROP ;			\ restore buttock
: StampRestore     ( -- ) HeadRestore BackLeftRestore BackRightRestore ButtockRestore ;	\ restore colors under stamp

: INK           ( co -- ) ?Turtle 1 ? DUP Foreground PEN rp SWAP _SetAPen ;	\ set ink color from defined color list
: ?Black        ( -- co ) Black -bg @ = IF White ELSE Black THEN ;			\ white stamp if black background
: HeadDraw      ( -- ) UnderStampIndex OFF Red INK rp xy@ _WritePixel DROP ;
: BackLeftDraw  ( -- ) ?Black INK xy@ UpBack 0 DO BLDelta rp 2OVER1 _WritePixel DROP LOOP 2DROP ;
: BackRightDraw ( -- x1 y1 ) ?Black INK xy@ UpBack 0 DO BRDelta rp 2OVER1 _WritePixel DROP LOOP ;
: ButtockDraw   ( x1 y1 -- ) Red INK UpBut 0 DO BuDelta rp 2OVER1 _WritePixel DROP LOOP 2DROP ;
: StampDraw     ( -- ) HeadDraw BackLeftDraw BackRightDraw ButtockDraw ;
 
: UnStamp		( -- ) Hidden @ NOT IF -fg @ StampRestore INK THEN ;
: Stamp         ( -- ) Hidden @ NOT IF -fg @ Rot>Stamp StampSave StampDraw INK xy@ LastStamp 2! THEN ;
: HIDETURTLE    ( -- ) ?Turtle UnStamp Hidden ON ;
: SHOWTURTLE    ( -- ) ?Turtle Hidden OFF Stamp ;

\ user coordinates ************************************************************************
\ drawing area is 10000 wide by proportional height in user coordinates
10000 VALUE UserWidth								\ canvas width in user coordinates
0 VALUE UserHeight									\ proportional height to UserWidth based upon window dimensions
0 VALUE XScale										\ divisor x 10^4 to translate between user and real X coordinates
0 VALUE YScale										\ divisor x 10^4 to translate between user and real Y coordinates
: GetUserHeight ( -- ) UserWidth GZZHeight * GZZWidth  / TO UserHeight ;
: GetXScale     ( -- ) UserWidth      10^4 * GZZWidth  / TO XScale ;
: GetYScale     ( -- ) UserHeight     10^4 * GZZHeight / TO YScale ;

CREATE XUser 0 ,		\ current x in user coordinates
CREATE YUser 0 ,		\ current y in user coordinates
: X  ( -- xuser ) XUser @ ;
: Y  ( -- yuser ) YUser @ ;
: XY ( -- xuser yuser ) X Y ;

: XUser>  ( userx -- x ) 10^4 XScale */ XHome + ;
: YUser>  ( usery -- y ) 10^4 YScale */ NEGATE YHome + ;
: XYUser> ( userx usery -- x y ) SWAP XUser> SWAP YUser> ;

\ area draw ********************************************************************************************
\ queue ------------------------------------------------------------------------------------------------
-1 CONSTANT FIFO		\ a conventional queue; uses LINK>
 0 CONSTANT LIFO		\ a convential stack; uses LINK

STRUCTURE QueueStruct
	LONG:	qu_Head		\ pointer to list head; 0 if empty queue
	LONG:	qu_Order	\ queueing type, FIFO or LIFO
	LONG:	qu_Width	\ width of each queue item
	XT:		qu_Pop		\ xt to call during queue pop  ( item -- ... )
	XT:		qu_Push		\ xt to call during queue push ( ... item -- )
STRUCTURE.END
 
: QUEUE ( pushXT popXT width order -- ) 4 ? CREATE 0 , , , , ,  ;
: STACK ( pushXT popXT width -- ) LIFO QUEUE ;
: ?Link ( node qu -- ) DUP S@ qu_Order IF LINK>	ELSE LINK THEN ;
: PUSH  ( ... qu -- ) DUP S@ qu_Width HEAP MEMORY TUCK OVER ?Link S@ qu_Push ?EXECUTE ;
: POP   ( qu -- ... ) DUP @ DUP 0= ABORT" Queue empty" 2>R 2R@ SWAP S@ qu_Pop ?EXECUTE 2R> SWAP UNLINK> FREE ;  

\ actions ---------------------------------------------------------------------------------------------------
STRUCTURE Action
	LONG:	ac_Next							\ pointer to next action
	SHORT:	ac_X							\ x coordinate of action
	SHORT:	ac_Y							\ y coordinates of action
	LONG:	ac_Draw							\ true if we draw to this point, false if we move
STRUCTURE.END

: acPop    ( item -- x y draw ) DUP S@ ac_X OVER S@ ac_Y ROT S@ ac_Draw ;	\ pop xy and draw flag to stack
: acPush   ( x y draw item -- ) TUCK S! ac_Draw TUCK S! ac_Y S! ac_X ;		\ push xy and draw flag from stack
' acPush ' acPop Action FIFO QUEUE Actions									\ create FIFO queue called Actions
: .Actions ( -- ) Actions BEGIN @ ?DUP WHILE DUP acPop ROT . SWAP . . CR REPEAT ;

CREATE Record 0 ,							\ ON|OFF to record _Move and _Draw actions?

\ turtle graphics *******************************************************************************************
0 VALUE Delay										\ delay in milliseconds between draws
CREATE -PenDown TRUE ,								\ pen position

: PENDOWN ( -- ) -PenDown ON ;
: PENUP   ( -- ) -PenDown OFF ;

: SPEED   ( u -- ) 1 ? ABS TO Delay ;
: FASTEST ( -- )  0 SPEED ;
: FAST    ( -- )  1 SPEED ;
: SLOW    ( -- )  3 SPEED ;
: SLOWER  ( -- )  5 SPEED ;

: HEADING ( deg -- ) 1 ? UnStamp degrees Rotation ! Stamp ;
: LEFT    ( deg -- ) 1 ? Rotation @ + HEADING ;		\ counter clockwise
: RIGHT   ( deg -- ) 1 ? NEGATE LEFT ;				\ clockwise
 
: draw     ( rp x y -- ) Record @ IF 2DUP ClipXY TRUE  Actions PUSH THEN WDraw ;
: move     ( rp x y -- ) Record @ IF 2DUP ClipXY FALSE Actions PUSH THEN _Move ;
: ?draw    ( rp x y -- ) ?Turtle UnStamp -PenDown @ IF Draw ELSE Move THEN Stamp ;
: GOTO     ( userx usery -- ) 2 ? 2DUP YUser ! XUser ! XYUser> rp -ROT ?draw Delay IF Delay MS THEN ;
: FORWARD  ( n -- )
	?DUP 0= IF EXIT THEN DUP						\ n n
	DUP 0< IF 180 LEFT ABS THEN						\ n u
	DUP  RotateX X +								\ n u xuser
	SWAP RotateY Y +								\ n xuser yuser
	GOTO 0< IF 180 LEFT THEN ;						\
: BACKWARD ( n -- ) NEGATE FORWARD ;

: TopMost    ( -- usery ) UserHeight 2 / ;
: BottomMost ( -- usery ) TopMost NEGATE ;
: RightMost  ( -- userx ) UserWidth 2 / ;
: LeftMost   ( -- userx ) RightMost NEGATE ;

: BOTTOMLEFT  ( -- ) LeftMost  BottomMost GOTO ;
: BOTTOMRIGHT ( -- ) RightMost BottomMost GOTO ;
: TOPLEFT     ( -- ) LeftMost  TopMost    GOTO ;
: TOPRIGHT    ( -- ) RightMost TopMost    GOTO ;

: (dot) ( -- ) rp x@ y@ _WritePixel DROP ;
: DOT   ( -- ) ?Turtle -PenDown @ IF UnStamp (dot) Stamp THEN ;

: HOME     ( -- ) ?Turtle rp XHome YHome ?draw XUser OFF YUser OFF ;
: ORIGIN   ( -- ) REHOME HOME ;
: NEWHOME  ( -- ) ?Turtle x@ TO XHOME y@ TO YHOME XUser OFF YUser OFF ;
: MOVEHOME ( n -- ) 0 -PenDown <! HOME FORWARD NEWHOME !> ;

: FreeHeapColors ( -- )	Colors BEGIN @ ?DUP WHILE DUP InUse? NOT IF DUP PenFree DUP coFree THEN REPEAT ;
: CLEAR ( -- ) ?Turtle ORIGIN Rotation OFF rp -bg @ PEN _SetRast FreeHeapColors Hidden ON SHOWTURTLE PENDOWN ;

: CANVASWIDTH ( u -- ) ?Turtle 1 ? TO UserWidth GetUserHeight GetXScale GetYScale CLEAR ;
: CANVAS      ( co -- ) 1 ? Background ;

: INK?    ( -- ) -fg @ .color ;
: CANVAS? ( -- ) -bg @ .color ;

: WIDTH ( u -- ) ABS DUP Wide ! OldWide ! ;

: REPEAT[ ( u -- ) 0 POSTPONE LITERAL POSTPONE DO ; IMMEDIATE
' ]    'SYNONYM OLD]
' LOOP 'SYNONYM ]
' :    'SYNONYM DEFINE
' ;    'SYNONYM END

\ flood =================================================================================================
\ points -------------------------------------------------------------------------------------------------
STRUCTURE Point
	LONG:	po_Next		\ ptr to next coordinate
	SHORT:	po_X		\ x coordinate
	SHORT:	po_Y		\ y coordinate
STRUCTURE.END

-1 VALUE Target															\ target color to replace
CREATE PosX 0 ,															\ x coordinate of current position
CREATE PosY 0 ,															\ y coordinate of current position

: poPop   ( item -- x y ) DUP S@ po_X SWAP S@ po_Y ;					\ pop xy from stack
: poPush  ( x y item -- ) TUCK S! po_Y S! po_X ;						\ push xy onto stack
' poPush ' poPop Point STACK Points										\ create stack called Points
: .points ( -- ) Points BEGIN @ ?DUP WHILE DUP poPop SWAP . . CR REPEAT ;

: Target? ( x y -- f ) rp -ROT _ReadPixel Target = ;							\ is point the target color?
: poop    ( x y -- )   rp -ROT _WritePixel DROP ;								\ flood point
: ?Poop   ( x y -- ) 2DUP Target? IF 2DUP poop Points PUSH ELSE 2DROP THEN ;	\ if target color, flood and push point 
: ?Right  ( -- ) PosX @ 1+ ClipX? NOT IF PosX @ 1+ PosY @ ?Poop THEN ;			\ if right valid, flood and push point
: ?Left   ( -- ) PosX @ 1- ClipX? NOT IF PosX @ 1- PosY @ ?Poop THEN ;			\ if left valid, flood and push point
: ?Down   ( -- ) PosY @ 1+ ClipY? NOT IF PosX @ PosY @ 1+ ?Poop THEN ;			\ if down valid, flood and push point
: ?Up     ( -- ) PosY @ 1- ClipY? NOT IF PosX @ PosY @ 1- ?Poop THEN ;			\ if up valid, flood and push point
: wander  ( -- ) BEGIN Points POP PosY ! PosX ! ?Right ?Left ?Down ?Up Points @ 0= UNTIL ; 

: FLOOD ( -- ) -PenDown @ NOT IF EXIT THEN
	Hidden @ NOT DUP IF HIDETURTLE THEN
	xy@ 2DUP rp -ROT _ReadPixel TO Target Points PUSH (dot) wander
	IF SHOWTURTLE THEN ;

\ area drawing ========================================================================================
CREATE MyAreaInfo AreaInfo 0ALLOT						\ my AreaInfo structure
0 VALUE #Vectors										\ number of vectors required for polygon(s)
CREATE AWork 0 ,										\ holds address of area info vector buffer
2 CONSTANT wiggle										\ wiggle room for vectors

: !Wide        ( -- ) Wide @ OldWide ! 1 Wide ! ;
: @Wide        ( -- ) OldWide @ Wide ! ;
: BEGINFILL    ( -- ) !Wide Actions FREELIST AttachTmpRas Record ON XY@ FALSE Actions PUSH ;

: >#Vectors    ( -- ) Actions NODES wiggle + TO #Vectors ;				\ number of actions recorded
: InitAWork    ( -- ) #Vectors 5 * 2* ( SHORTS) HEAP MEMORY AWork ! ;	\ 5 words required per vector
: FreeAWork    ( -- ) AWork @ ?DUP IF FREE THEN ;						\ free buffer
: InitAreaDraw ( -- ) >#Vectors InitAWork MyAreaInfo AWork @ #Vectors _InitArea ;
: AreaDraw     ( rp x y -- ) _AreaDraw ABORT" AreaDraw buffer full" ;
: AreaMove     ( rp x y -- ) _AreaMove ABORT" AreaMove buffer full" ;
: DoAction     ( x y draw? -- ) IF rp -ROT AreaDraw ELSE rp -ROT AreaMove THEN ;
: DoActions    ( -- ) #Vectors wiggle - 0 ?DO Actions POP DoAction LOOP ;
: DoAreaDraw   ( -- ) InitAreaDraw MyAreaInfo rp S! rp_AreaInfo DoActions rp _AreaEnd ABORT" AreaEnd err" ;
: ENDFILL      ( -- ) 0 Hidden <! DoAreaDraw !> 0 rp S! rp_AreaInfo FreeAWork ?DetachTmpRas
	Actions FREELIST @Wide Record OFF ;

\ arc =================================================================================================
\ draw an arc for deg degrees (180=semi-circle, 360=circle) with center at 90 LEFT radius FORWARD

\ wide arc using 360 sided polygon -------------------------------------------------------------------
: Radius>Arc ( radius -- len ) IPI/180 10^5 */ 1+ ;
: WArcLeft  ( radius deg -- ) SWAP Radius>Arc SWAP 0 DO DUP FORWARD 1 LEFT  LOOP DROP ;
: WArcRight ( radius deg -- ) SWAP Radius>Arc SWAP 0 DO DUP FORWARD 1 RIGHT LOOP DROP ;
: WArc      ( radius deg -- ) SWAP DUP 0> IF SWAP WArcLeft ELSE ABS SWAP wArcRight THEN ;

\ 1 WIDTH arc more accurate than above ----------------------------------------------------------------
0 VALUE PenPosition
0 VALUE XCenter
0 VALUE YCenter
0 VALUE Radius

: ?Forward ( n -- ) 0 Record <! 1 Wide <! FORWARD !> !> ;
: ?Goto    ( x y -- ) 0 Record <! GOTO !> ;

: ??draw ( rp x y -- ) ?Turtle PenPosition IF WDraw ELSE _Move THEN ;
: arcleft ( deg prevx prevy -- heading prevx prevy )	\ arc left and leave heading
	2>R DUP Rotation @ + degrees SWAP 2R>				\ head deg xyprev		leave final heading
	90 LEFT Radius ?Forward Y TO YCenter X TO XCenter	\ head deg xyprev		goto center of circle and save point 
	180 LEFT											\ head deg xyprev		head toward starting point
	ROT 0 DO											\ head xyprev			do for each degree
		1 LEFT Radius ?Forward XY 2SWAP ?Goto			\ head xynext				leave next point, goto prev point
		rp 2OVER1 XYUser> ??draw						\ head xyprev				draw arc deg, next becomes prev
		XCenter YCenter ?Goto							\ head xyprev				goto circle center
	LOOP ;												\ head xyprev			loop

: arcright ( deg prevx prevy -- )						\ arc right and leave heading
	2>R Rotation @ OVER - degrees SWAP 2R>				\ head deg xyprev		leave final heading
	90 RIGHT Radius ?Forward Y TO YCenter X TO XCenter	\ head deg xyprev		goto center of circle and save point 
	180 LEFT											\ head deg xyprev		head toward starting point
	ROT 0 DO											\ head xyprev			do for each degree
		1 RIGHT Radius ?Forward XY 2SWAP ?Goto			\ head xynext				leave next point, goto prev point
		rp 2OVER1 XYUser> ??draw						\ head xyprev				draw arc deg, next becomes prev
		XCenter YCenter ?Goto							\ head xyprev				goto circle center
	LOOP ;												\ head xyprev			loop

: ARC ( radius deg -- ) 2 ?								\ if radius is positive, arc left otherwise arc right
	2DUP 0= SWAP 0= OR IF 2DROP EXIT THEN				\ radius deg			exit if either parameter is zero
	SWAP TO Radius										\ deg					assign radius
	Hidden @ TUCK NOT IF HIDETURTLE THEN				\ hid deg				HIDETURTLE if not hidden
	Wide @ 1 = IF
		-PenDown @ TO PenPosition PENUP XY				\ hid deg xyprev		save pen position, leave starting point
		Radius 0<										\ hid deg xyprev f		negative radius?
		IF Radius ABS TO Radius ArcRight				\ hid heading xyprev		yes, arc right
		ELSE ArcLeft									\ hid final xyprev			no, arc left
		THEN GOTO HEADING								\ hid					GOTO last point, set heading
		PenPosition -PenDown !							\ hid					restore pen position
	ELSE Radius SWAP WArc THEN							\ hid					use WArc if width>1 (less accurate)
	NOT IF SHOWTURTLE THEN ;							\						SHOWTURTLE if not hidde

: CIRCLE ( radius -- ) 1 ? 360 ARC ;

: POLYGON ( len sides -- ) 2 ? DUP 0> NOT IF 2DROP EXIT THEN
	360 OVER / SWAP	0 DO OVER FORWARD DUP LEFT LOOP 2DROP ;

: POLYGONAL ( qty len sides -- ) 3 ? 1OVER2 0> NOT IF 3DROP EXIT THEN
	ROT 360 OVER / SWAP 0 DO 2OVER1 POLYGON DUP LEFT LOOP 3DROP ;

\ preferences =================================================================================================
CREATE Prefs 0 ,													\ TRUE|FALSE have prefs been set?
CREATE PrefsWLeft 0 ,												\ window position left
CREATE PrefsWTop 0 ,												\ window position top
CREATE PrefsWWidth 0 ,												\ window size width
CREATE PrefsWHeight 0 ,												\ window size height
CREATE PrefsFG 0 ,													\ foreground color
CREATE PrefsBG 0 ,													\ background color
CREATE PrefsCWidth 0 ,												\ canvas width in user coordinates
CREATE PrefsSpeed 0 ,												\ milliseconds TO Delay
CREATE #Colors Colors NODES ,										\ save qty of predefined colors

\ name in-heap colors within save
\ colors created after #Colors are defined in prefs file

: Current>Prefs ( -- )												\ store current parametes in prefs
	wd S@ wd_LeftEdge PrefsWLeft ! wd S@ wd_TopEdge PrefsWTop !		\ window position
	wd S@ wd_Width PrefsWWidth ! wd S@ wd_Height PrefsWHeight !		\ window size
	-fg @ PrefsFG ! -bg @ PrefsBG !									\ store foreground and background colors
	UserWidth PrefsCWidth !											\ canvas width in user coordinates
	Delay PrefsSpeed ! Prefs ON ;									\ speed

: Prefs>Current  ( -- )												\ store current prefs in parameters
	PrefsFG @ INK PrefsBG @ CANVAS									\ set ink and canvas colors
	PrefsSpeed @ SPEED												\ set delay
	GetWindowSize													\ get new window size
	PrefsCWidth @ CANVASWIDTH ;										\ set CANVASWIDTH

\ create file pfTurtle.prefs ------------------------------------------------------------------------------------
CREATE BL$ 1 C, BL C,
: ECHO ( what$ where$ -- ) STRING >R C" ECHO >>" R@ $! R@ $+! BL$ R@ $+! R@ $+! R@ $>0$ R> (DOS) ;

\ where$s to ECHO; defer so we can also use for pfSpiro.prefs
DEFER ENV DEFER ENVARC
CREATE TurtleENV C" ENV:pfTurtle.prefs" $,
CREATE TurtleARC C" ENVARC:pfTurtle.prefs" $,
' TurtleENV IS ENV
' TurtleARC IS ENVARC

\ what$s to ECHO
\ CREATE  -$ 1 C, CHAR - C,
CREATE :$ 1 C, CHAR : C,
: 00         ( c$1 -- c$2 ) STRING >R " 0" R@ $! R@ $+! R> 2 $RIGHT ;
: Time&Date$ ( -- c$ ) Time&Date $STR >R -$ R@ $+! $STR 00 R@ $+! -$ R@ $+! $STR 00 R@ $+! BL$ R@ $+!
	$STR 00 R@ $+! :$ R@ $+! $STR 00 R@ $+! :$ R@ $+! $STR 00 R@ $+! R> ;

: Header$       STRING >R C" \ parForth 0.2 Turtle Graphics prefs file created " R@ $! Time&Date$ R@ $+! R> ;
: PrefsWLeft$   STRING >R PrefsWLeft   @ $STR R@ $! C"  PrefsWLeft !"   R@ $+! R> ;
: PrefsWTop$    STRING >R PrefsWTop    @ $STR R@ $! C"  PrefsWTop !"    R@ $+! R> ;
: PrefsWWidth$  STRING >R PrefsWWidth  @ $STR R@ $! C"  PrefsWWidth !"  R@ $+! R> ;
: PrefsWHeight$ STRING >R PrefsWHeight @ $STR R@ $! C"  PrefsWHeight !" R@ $+! R> ;
: PrefsCWidth$  STRING >R PrefsCWidth  @ $STR R@ $! C"  PrefsCWidth !"  R@ $+! R> ;
: PrefsSpeed$   STRING >R PrefsSpeed   @ $STR R@ $! C"  PrefsSpeed !"   R@ $+! R> ;

: $STR+BL ( n -- c$ ) $STR BL$ OVER $+! ;
: rgb$    ( r g b -- c$ ) ROT $STR+BL >R SWAP $STR+BL R@ $+! $STR+BL R@ $+! R> ;
: coName$ ( co -- c$ ) DUP heap? IF rgb@ r|g|b$ ELSE coName >STRING THEN ;  
: PrefsFG$ STRING >R PrefsFG @ coName$ R@ $! C"  PrefsFG !"    R@ $+! R> ;
: PrefsBG$ STRING >R PrefsBG @ coName$ R@ $! C"  PrefsBG !" R@ $+! R> ; 

: color$      ( co -- c$ ) STRING >R DUP rgb@ rgb$ R@ $! C"  COLOR " R@ $+! coName$ R@ $+! R> ;
: EchoColor$s ( where$ -- )
	Colors NODES #Colors @ - DUP							\ where$ n f		extra colors added?
	IF Colors SWAP											\ where$ node n		do for n nodes
		0 DO @ DUP color$ 1OVER2 ECHO LOOP					\ where$ node			echo color$
	THEN 2DROP ;											\

DEFER (SavePrefs)											\ deferred for spiro
: (TurtleSavePrefs) ( where$ -- )							\ create prefs file at where$
	DUP COUNT DELETE-FILE DROP Header$ OVER ECHO
	PrefsWLeft$  OVER ECHO PrefsWTop$  OVER ECHO PrefsWWidth$ OVER ECHO PrefsWHeight$ OVER ECHO
	PrefsCWidth$ OVER ECHO PrefsSpeed$ OVER ECHO DUP EchoColor$s
	PrefsFG$     OVER ECHO PrefsBG$    SWAP ECHO ;
' (TurtleSavePrefs) IS (SavePrefs)

: FILE-STATUS ( c-addr u -- x ior )		\ ior=0 if exists, x is junk
	R/O OPEN-FILE 0= IF CLOSE-FILE DROP -1 0 ELSE DROP -1 -1 THEN ;
: ?LoadPrefs ( -- ) ENV COUNT FILE-STATUS 0= IF ENV $include Prefs ON THEN DROP ;

\ start turtle graphics ---------------------------------------------------------------------------
: COLORS ( -- ) .colors ;

: TURTLEDEFAULTS ( -- ) ?Turtle ORIGIN Prefs @ IF Prefs>Current ELSE Black INK White CANVAS GetWindowSize
	10000 CANVASWIDTH FASTEST Current>Prefs THEN 1 WIDTH ;

: REFRESHWINDOW ( -- ) ?Turtle GetWindowSize PrefsCWidth @ CANVASWIDTH ;
: USEPREFS      ( -- ) Current>Prefs ENV (SavePrefs) ;
: SAVEPREFS     ( -- ) USEPREFS ENVARC (SavePrefs) ;
 
" Turtle Graphics" WINDOW MyWindow
WFLG_SIZEGADGET WFLG_DRAGBAR | WFLG_DEPTHGADGET | WFLG_SMART_REFRESH | WFLG_GIMMEZEROZERO | CONSTANT TurtleFlags
: ?PrefsWindow ( -- l t w h ) Prefs @ IF PrefsWLeft @ PrefsWTop @ PrefsWWidth @ PrefsWHeight @
	ELSE #CENTER #CENTER 75 %scSize THEN ;
: TURTLE       ( -- ) TurtleOpen @ ABORT" Turtle already active" ?LoadPrefs MyWindow TurtleFlags ?PrefsWindow wOpen
	TurtleOpen ON GetRP	rp JAM1 _SetDrMd 0 RANDOMIZE Red KEEP White KEEP Black KEEP TURTLEDEFAULTS ;

: SQUASH ( -- ) TurtleOpen @ IF ?DetachTmpRas wClose TurtleOpen OFF THEN ;

: TurtleEnd ( -- ) SQUASH FreeColors ;
: auto.term PROTECT TurtleEnd auto.term ;						\ close window and free colors on BYE

\ Spirograph ***************************************************************************************
\ Formulae for Hypotrochoids and Epitrochoids are in radians so floating point is used for speed and convenience

CREATE StartRevolution 0 ,	\ revolution to start with (see 'revs' for qty needed to complete pattern)
CREATE StepSize 1 ,			\ step size; see 'StepClose' to calculate a step size which closes the pattern
CREATE Partialness 360 ,	\ degrees per revolution (360 will complete the pattern)
CREATE Revolutions 0 ,		\ revolutions to draw; ignored if = 0
FVARIABLE UserMultiplier	\ user can set this to adjust all spiro magnification to their setup; defaults to 1e
FVARIABLE -Magnification	\ scaling of ring and wheel radii and hole distance
 1e UserMultiplier F!		\ all set to work on my setup
28e -Magnification F!		\ magnification for spirograph tooth sizes for ring & wheel radii with 10,000 canvas width

\ preferences ========================================================================================
\ use turtle preferences but add UserMultiplier and -Magnification
CREATE SpiroENV C" ENV:pfSpiro.prefs" $,
CREATE SpiroARC C" ENVARC:pfSpiro.prefs" $,
' SpiroENV IS ENV
' SpiroARC IS ENVARC

: UserMultiplier$ STRING >R UserMultiplier F@ F$STR R@ $! C"  UserMultiplier F!" R@ $+! R> ;
: (SpiroSavePrefs) ( where$ -- ) DUP (TurtleSavePrefs) UserMultiplier$ SWAP ECHO ;
' (SpiroSavePrefs) IS (SavePrefs)

\ trochoids ===========================================================================================
-1e FACOS 180e F/ FCONSTANT PI/180
FVARIABLE Ring				\ ring radius
FVariable Wheel				\ wheel radius
FVariable Hole				\ distance from wheel perimeter to hole (virtually, negatives or greater than radius are ok)
FVariable FRotation			\ turtle graphics rotation in radians			
FVariable Theta				\ trochoid rotation in radians

: SPIROMAGNIFICATION ( n -- ) DUP 0< IF ABS S>F 100e F/ ELSE S>F THEN UserMultiplier F! ;
: MAGNIFICATION ( n -- )      DUP 0< IF ABS S>F 100e F/ ELSE S>F THEN UserMultiplier F@ F* -Magnification F! ;
: Magnify       ( F: r1 -- r2 ) -Magnification F@ F* ;
: DeMagnify     ( F: r1 -- r2 ) -Magnification F@ F/ ;
: radians       ( n -- , -- r*PI/180 ) S>F PI/180 F* ;

\ convert teeth movement on ring to degrees; spirograph instructions may say '2 teeth right' for example
: TEETH ( n -- deg ) Ring F@ 0e F= IF DROP 0 ELSE S>F Ring F@ DeMagnify F/ 360e F* F>S THEN ;

: revs      ( ring wheel -- revs )	\ calculates revolutions needed to complete pattern or use user value
	Revolutions @ 0= IF 0 BEGIN 1+ 1OVER2 OVER * 1OVER2 MOD 0= UNTIL NIP NIP ELSE 2DROP Revolutions @ THEN ;
: StepClose ( revs -- )
	StepSize DUP @ 1 MAX SWAP !						\ revs			make sure step is >=1
	360 * StepSize @ DUP 1- 0 ?DO					\ points step	do for 0 to step-1
		2DUP MOD 0=									\ points step		is step a multiple of points?
		IF LEAVE ELSE 1- THEN						\ points step			yes, leave; no, step=step-1
	LOOP NIP 1 MAX StepSize ! ;						\						no, loop

: FRotateX  ( F: x0 y0 -- x1 ) FRotation F@ FSIN F* FSWAP FRotation F@ FCOS F* F+ ;
: FRotateY  ( F: x0 y0 -- y1 ) FRotation F@ FCOS F* FSWAP FRotation F@ FSIN F* F- ;
: FRotateXY ( F: x0 y0 -- x1 y1 ) F2DUP FRotateX F-ROT FRotateY ;

\ tilt line from tilt origin to home by TiltRotation degrees --------------------------------------------
CREATE Tilted 0 ,									\ flag whether tilt is ON|OFF
CREATE TiltRotation 90 ,							\ tilt angle from tilt origin to home

0 VALUE XTiltOrigin									\ XUser of tilt origin
0 VALUE YTiltOrigin									\ YUser of tilt origin

FVARIABLE FTilt										\ tilt rotation in radians
FVARIABLE FXTilt									\ float XTiltOrigin
FVARIABLE FYTilt									\ float YTiltOrigin

: TILT     ( -- ) Tilted ON ;
: HEADING  ( deg -- ) 1 ? Tilted @ IF degrees TiltRotation ! Tilted OFF ELSE HEADING THEN ;
: LeftTilt ( deg -- ) TiltRotation @ + degrees TiltRotation ! ;  
: LEFT     ( deg -- ) 1 ? Tilted @ IF LeftTilt Tilted OFF ELSE LEFT THEN ;
: RIGHT    ( deg -- ) 1 ? NEGATE LEFT ;

: TILTFROMABOVE ( ring -- ) 1 ?  S>F 2e F/ MAGNIFY F>S TO YTiltOrigin X TO XTiltOrigin ;
: TILTFROMBELOW ( ring -- ) 1 ? NEGATE TILTFROMABOVE ;
: NEWTILTORIGIN ( -- ) X TO XTiltOrigin Y TO YTiltOrigin ;

: XYTilt+ ( F: x0 y0 -- x1 y1 ) FYTilt F@ F+ FSWAP FXTilt F@ F+ FSWAP ;
: Vector  ( F: -- r ) FXTilt F@ 2e F** FYTilt F@ 2e F** F+ FSQRT ;
: TiltX   ( F: x0 -- x1 ) Vector FTilt F@ FCOS F* F+ ;
: TiltY   ( F: y0 -- y1 ) Vector FTilt F@ FSIN FNEGATE F* F+ ;
: TiltXY  ( F: x0 y0 -- x1 y1 ) XYTILT+ TiltY FSWAP TiltX FSWAP ;
: ScootXY ( F: x0 y0 -- x1 y0 ) FSWAP FXTilt F@ F+ TiltX FSWAP ;
\ end tilt definition ------------------------------------------------------------------------------------

: SPIRODEFAULTS ( -- ) 0 StartRevolution ! 1 StepSize ! 360 Partialness ! 0 Revolutions ! 28 MAGNIFICATION
	TILT 90 HEADING 90 HEADING PENUP ORIGIN PENDOWN NEWTILTORIGIN HIDETURTLE 1 WIDTH ;

: InitTrochoid ( ring wheel hole -- ) 3 ?						\ initialize trochoid variables
	Partialness DUP @ 1 MAX 360 MIN SWAP !						\ ring wheel hole		set between 1 and 360 degrees
	Rotation @ NEGATE radians FRotation F!						\ ring wheel hole		convert rotation to float
	TiltRotation @ NEGATE radians FTilt F!						\ ring wheel hole		convert tilt angle to float
	XTiltOrigin S>F FXTilt F!									\ ring wheel hole		convert XTiltOrigin to float
	YTiltOrigin S>F FYTilt F!									\ ring wheel hole		convert YTiltOrigin to float
	S>F Magnify Hole  F!										\ ring wheel			store magnified hole distance
	S>F Magnify Wheel F!										\ ring					store magnified wheel radius
	S>F Magnify Ring  F! ;										\						store magnified ring radius

: CalcUpper ( revs -- upper ) Partialness @ * StepSize @ + StartRevolution @ 360 * + ;
: CalcLower ( -- lower ) StartRevolution @ 360 * ;				\ calc lower bound

\ hypotrochoid -------------------------------------------------------------------------------------
\ wheel radius=wheel with a hole distance=hole from wheel's perimeter inward _within_ a ring radius=ring
: R-W     ( F: -- Ring-Wheel ) Ring F@ Wheel F@ F- ;
: (R-W)/W ( F: -- Ring-Wheel/Wheel ) R-W Wheel F@ F/ ;
: W-H     ( F: -- Wheel-Hole ) Wheel F@ Hole F@ F- ;

: XHypo  ( F: -- x0 ) R-W Theta F@ FCOS F* (R-W)/W Theta F@ F* FCOS W-H F* F+ ;
: YHypo  ( F: -- y0 ) R-W Theta F@ FSIN F* (R-W)/W Theta F@ F* FSIN W-H F* F- ;
: XYHypo ( theta -- x y ) radians Theta F! XHypo YHypo FRotateXY ScootXY ( TiltXY) F>S F>S SWAP ;

: HypoMove ( rev -- ) 0 -PenDown <! 360 * XYHypo GOTO !> ;		\ penup goto zeroeth point

: HYPOTROCHOID ( ring wheel hole -- ) 3 ?
	>R 2DUP R> InitTrochoid										\ ring wheel			initialize trochoid variables
	StartRevolution @ HypoMove									\ ring wheel			penup move to first point
	Revs DUP StepClose											\ revs					calculate revs and step
	CalcUpper CalcLower	DO I XYHypo GOTO StepSize @ +LOOP ;		\						draw pattern

\ epitrochoid -------------------------------------------------------------------------------------
\ wheel radius=wheel with a hole distance=hole from wheel's perimeter inward _around_ a ring radius=ring
: R+W     ( F: -- Ring+Wheel ) Ring F@ Wheel F@ F+ ;
: (R+W)/W ( F: -- Ring+Wheel/Wheel ) R+W Wheel F@ F/ ;

: XEpi  ( F: -- x0 ) R+W Theta F@ FCOS F* (R+W)/W Theta F@ F* FCOS W-H F* F- ;
: YEpi  ( F: -- y0 ) R+W Theta F@ FSIN F* (R+W)/W Theta F@ F* FSIN W-H F* F- ;
: XYEpi ( theta -- x y ) radians Theta F! XEpi YEpi FRotateXY F>S F>S SWAP ;

: EpiMove ( rev -- ) 0 -PenDown <! 360 * XYEpi GOTO !> ;		\ penup goto zeroeth point

: EPITROCHOID ( ring wheel hole -- ) 3 ?
	>R 2DUP R> InitTrochoid										\ ring wheel			initialize trochoid variables
	StartRevolution @ EpiMove									\ ring wheel			penup move to first point
	Revs DUP StepClose											\ revs					calculate revs and step
	CalcUpper CalcLower DO I XYEpi GOTO StepSize @ +LOOP ;		\						draw pattern

\ HSV to RGB -----------------------------------------------------------------------------------------------
\ convert from HSV to RGB		https:CodeSpeedy.com/hsv-to-rgb-in-cpp/
FVARIABLE HueH					\ hue        (0-360)	angle of color in the RGB color circle
FVARIABLE HueS					\ saturation   (0-1)	color intensity; 100% is purest form
FVARIABLE HueV					\ value        (0-1)	brightness of the color
FVARIABLE HueC					\ (V/100)*(S/100)
FVARIABLE HueX					\ C*(1-|((H/60)mod 2)-1|)
FVARIABLE Huem					\ (V/100)-C
FVARIABLE Huer					\ varies by angle
FVARIABLE Hueg					\ varies by angle
FVARIABLE Hueb					\ varies by angle

: HSV>F    ( H S V -- ) S>F 100e F/ HueV F! S>F 100e F/ HueS F! S>F HueH F! ;
: CalcHueC ( -- ) HueV F@ HueS F@ F* HueC F! ;
: CalcHueX ( -- ) HueC F@ 1e HueH F@ 60e F/ 2e FMOD 1e F- FABS F- F* HueX F! ;
: CalcHuem ( -- ) HueV F@ HueC F@ F- Huem F! ;
: CalcHSV  ( addr -- u ) F@ Huem F@ F+ 255e F* FROUND F>S ;

: HSV>RGB  ( H S V -- R G B ) 2>R DUP 2R> HSV>F CalcHueC CalcHueX CalcHuem
	DUP  60 < IF HueC F@ Huer F! HueX F@ Hueg F!      0e Hueb F! ELSE
	DUP 120 < IF HueX F@ Huer F! HueC F@ Hueg F!      0e Hueb F! ELSE
	DUP 180 < IF      0e Huer F! HueC F@ Hueg F! HueX F@ Hueb F! ELSE
	DUP 240 < IF      0e Huer F! HueX F@ Hueg F! HueC F@ Hueb F! ELSE
	DUP 300 < IF HueX F@ Huer F!      0e Hueg F! HueC F@ Hueb F! ELSE
	DUP 360 < IF HueC F@ Huer F!      0e Hueg F! HueX F@ Hueb F! ELSE
	TRUE ABORT" Invalid Hue" THEN THEN THEN THEN THEN THEN DROP
	Huer CalcHSV Hueg CalcHSV Hueb CalcHSV ;


