/* 
   Example for including an IFF ILBM-picture into your code and display
   it. Source made by Karl-Erik Ruud. 
   This source is based on an iff.library source posted here earlier 
   (by Dave Higginson I think - please correct me if I'm wrong!)
   
   It is not neccesary to use IfFL_OpenIff().

   Change the name of the bitmap (at the end of the source) to your own
   picture path and name.
*/

MODULE	'iff',			/* Iff library funtions and registers */
	'libraries/iff',	/* Iff library header */
	'intuition/intuition',	/* Intuition header */
	'intuition/screens',	/* Screen types and flags */
	'exec/memory',		/* Memory flags */
	'graphics/display'	/* Display modes for screen */

ENUM	ER_NONE,		/* No error */
	ER_IFFLIB,		/* No iff-library */
	ER_OPENIFF,		/* Could not open iff */
	ER_NOBMHD,		/* No bitmap header (dimmensions) */
	ER_SCREEN,		/* Could not open screen */
	ER_WINDOW,		/* Could not open window */
	ER_DECODE		/* Could not decode picture */

DEF	s=NIL,			/* Screen */
	ct[256]:ARRAY OF INT,	/* Colour table (up to 256 colours) */
	bmhd,			/* Bitmap header (width (bmhd), height (bmhd+2), depth (bmhd+8)) */
	w=NIL:PTR TO window,	/* Pointer to window */
	quit=FALSE,		/* Variable to decide if the user quit */
	msg:PTR TO intuimessage, /* Pointer to intuition message */
	sprite=NIL,		/* Invisible sprite data */
	viewmode=NIL		/* Viewmode (f.ex. HOLDANDMODIFY+INTERLACE) */


PROC main() HANDLE

/* Open iff.library  */

	IF (iffbase:=OpenLibrary('iff.library',21))=NIL THEN Raise(ER_IFFLIB)

/* BMHD = BitMap Header (contains dimensions of picture)
   bmhd=picturewidth
   bmhd+2=pictureheight
   bmhd+8=number of bitplanes
*/

	IF (bmhd:=IfFL_GetBMHD({bitmap}))=NIL THEN Raise(ER_NOBMHD)

/* If no viewmode info in file, calculate it (a hack that fails sometimes) */

	IF (IfFL_FindChunk({bitmap},'CAMG'))=NIL
		IF Int(bmhd)>=640
			viewmode:=MODE_640
		ELSEIF Int(bmhd)<640
			viewmode:=0
			IF Char(bmhd+8)=6 THEN viewmode:=viewmode+$800
		ENDIF
		IF Int(bmhd+2)>300 THEN viewmode:=viewmode+INTERLACE
	ELSE
		viewmode:=IfFL_GetViewModes({bitmap})
	ENDIF

/* Open screen with correct dimensions */

	IF (s:=OpenScreenTagList(NIL,
		[SA_WIDTH,Int(bmhd),
		 SA_HEIGHT,Int(bmhd+2),
		 SA_DEPTH,Char(bmhd+8),
		 SA_DISPLAYID,viewmode,
		 SA_TYPE,PUBLICSCREEN,
		 0,0]))=NIL THEN Raise(ER_SCREEN)

/* Open a window based on the pictures dimmensions */

		IF (w:=OpenWindowTagList(NIL,
		[WA_LEFT,0,
		 WA_TOP,0,
		 WA_WIDTH,Int(bmhd),
		 WA_HEIGHT,Int(bmhd+2),
		 WA_FLAGS,WFLG_SIMPLE_REFRESH OR WFLG_NOCAREREFRESH OR WFLG_BORDERLESS OR WFLG_ACTIVATE,
		 WA_IDCMP,IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY,
		 WA_PUBSCREEN,s,
		 NIL,NIL]))=NIL THEN Raise(ER_WINDOW)

/* Blank the mouse pointer */

	IF sprite:=AllocMem(20,MEMF_CHIP OR MEMF_CLEAR)
		SetPointer(w,sprite,1,16,0,0)
	ENDIF

/* Set the palette of the screen */

	LoadRGB4(s+44,ct,IfFL_GetColorTab({bitmap},ct))

/* Try to load the picture */

	IF (IfFL_DecodePic({bitmap},s+184))=FALSE THEN Raise(ER_DECODE)

/* Wait for the user to press the mouse or a button */

	REPEAT
		IF msg:=GetMsg(w.userport)
			quit:=(msg.class AND (IDCMP_MOUSEBUTTONS OR IDCMP_RAWKEY))
		ELSE
			quit:=(Wait(-1) AND Shl(1,12))
		ENDIF
	UNTIL quit
	Raise(ER_NONE)		/* Do not give any error */
EXCEPT				/* Handle expections */

/* Clean up */

	IF w THEN CloseWindow(w)
	IF sprite THEN FreeMem(sprite,20)
	IF s THEN CloseScreen(s)
	IF iffbase THEN CloseLibrary(iffbase)

/* Display possible error message */

	IF exception>0
		WriteF('Error: \s.\n',
			ListItem(['',
				  'No IFF library version >21',
				  'Could not open IFF file',
				  'IFF File had no bitmap header',
				  'Could not open screen',
				  'Could not open window',
				  'Could not decode picture'],
				exception))
	ENDIF
ENDPROC

/* Include an IFF image in the code - replace this with your own */

bitmap:

INCBIN 'DEV:AMIGAE/INNE/Obrazek.iff'
