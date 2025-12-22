OPT NATIVE
MODULE 'target/graphics/clip', 'target/graphics/gfx', 'target/graphics/text', 'target/exec/ports', 'target/graphics/view'
MODULE 'target/exec/types'

NATIVE {screen} OBJECT screen
    {nextscreen}	nextscreen	:PTR TO screen		/* linked list of screens */
    {firstwindow}	firstwindow	:PTR TO window		/* linked list Screen's Windows */

    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT		/* parameters of the screen */
    {width}	width	:INT
	{height}	height	:INT			/* parameters of the screen */

    {mousey}	mousey	:INT
	{mousex}	mousex	:INT		/* position relative to upper-left */

    {flags}	flags	:UINT			/* see definitions below */

    {title}	title	:ARRAY OF UBYTE			/* null-terminated Title text */
    {defaulttitle}	defaulttitle	:ARRAY OF UBYTE		/* for Windows without ScreenTitle */

    {barheight}	barheight	:BYTE
	{barvborder}	barvborder	:BYTE
	{barhborder}	barhborder	:BYTE
	{menuvborder}	menuvborder	:BYTE
	{menuhborder}	menuhborder	:BYTE
    {wbortop}	wbortop	:BYTE
	{wborleft}	wborleft	:BYTE
	{wborright}	wborright	:BYTE
	{wborbottom}	wborbottom	:BYTE

    {font}	font	:PTR TO textattr		/* this screen's default font	   */

    {viewport}	viewport	:viewport		/* describing the Screen's display */
    {rastport}	rastport	:rastport		/* describing Screen rendering	   */
    {bitmap}	bitmap	:bitmap		/* SEE WARNING ABOVE!		   */
    {layerinfo}	layerinfo	:layer_info	/* each screen gets a LayerInfo    */

    {firstgadget}	firstgadget	:PTR TO gadget

    {detailpen}	detailpen	:UBYTE
	{blockpen}	blockpen	:UBYTE		/* for bar/border/gadget rendering */

    {savecolor0}	savecolor0	:UINT

    {barlayer}	barlayer	:PTR TO layer

    {extdata}	extdata	:PTR TO UBYTE

    {userdata}	userdata	:PTR TO UBYTE	/* general-purpose pointer to User data extension */
ENDOBJECT


NATIVE {menu} OBJECT menu
    {nextmenu}	nextmenu	:PTR TO menu	/* same level */
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT	/* position of the select box */
    {width}	width	:INT
	{height}	height	:INT	/* dimensions of the select box */
    {flags}	flags	:UINT		/* see flag definitions below */
    {menuname}	menuname	:ARRAY OF BYTE		/* text for this Menu Header */
    {firstitem}	firstitem	:PTR TO menuitem /* pointer to first in chain */

    /* these mysteriously-named variables are for internal use only */
    {jazzx}	jazzx	:INT
	{jazzy}	jazzy	:INT
	{beatx}	beatx	:INT
	{beaty}	beaty	:INT
ENDOBJECT

NATIVE {menuitem} OBJECT menuitem
    {nextitem}	nextitem	:PTR TO menuitem	/* pointer to next in chained list */
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT	/* position of the select box */
    {width}	width	:INT
	{height}	height	:INT		/* dimensions of the select box */
    {flags}	flags	:UINT		/* see the defines below */

    {mutualexclude}	mutualexclude	:VALUE		/* set bits mean this item excludes that */

    {itemfill}	itemfill	:APTR		/* points to Image, IntuiText, or NULL */

    {selectfill}	selectfill	:APTR		/* points to Image, IntuiText, or NULL */

    {command}	command	:BYTE		/* only if appliprog sets the COMMSEQ flag */

    {subitem}	subitem	:PTR TO menuitem	/* if non-zero, points to MenuItem for submenu */

    {nextselect}	nextselect	:UINT
ENDOBJECT

NATIVE {requester} OBJECT requester
    {olderrequest}	olderrequest	:PTR TO requester
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT		/* dimensions of the entire box */
    {width}	width	:INT
	{height}	height	:INT			/* dimensions of the entire box */
    {relleft}	relleft	:INT
	{reltop}	reltop	:INT		/* for Pointer relativity offsets */

    {reqgadget}	reqgadget	:PTR TO gadget		/* pointer to a list of Gadgets */
    {reqborder}	reqborder	:PTR TO border		/* the box's border */
    {reqtext}	reqtext	:PTR TO intuitext		/* the box's text */
    {flags}	flags	:UINT			/* see definitions below */

    {backfill}	backfill	:UBYTE
    {reqlayer}	reqlayer	:PTR TO layer

    {reqpad1}	reqpad1[32]	:ARRAY OF UBYTE

    {imagebmap}	imagebmap	:PTR TO bitmap	/* points to the BitMap of PREDRAWN imagery */
    {rwindow}	rwindow	:PTR TO window	/* added.  points back to Window */

    {reqimage}	reqimage	:PTR TO image	/* new for V36: drawn if USEREQIMAGE set */

    {reqpad2}	reqpad2[32]	:ARRAY OF UBYTE
ENDOBJECT

NATIVE {gadget} OBJECT gadget
    {nextgadget}	nextgadget	:PTR TO gadget	/* next gadget in the list */

    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT	/* "hit box" of gadget */
    {width}	width	:INT
	{height}	height	:INT		/* "hit box" of gadget */

    {flags}	flags	:UINT		/* see below for list of defines */

    {activation}	activation	:UINT		/* see below for list of defines */

    {gadgettype}	gadgettype	:UINT		/* see below for defines */

    {gadgetrender}	gadgetrender	:APTR2

    {selectrender}	selectrender	:APTR2

    {gadgettext}	gadgettext	:PTR TO intuitext   /* text for this gadget */

    {mutualexclude}	mutualexclude	:VALUE  /* obsolete */

    {specialinfo}	specialinfo	:APTR

    {gadgetid}	gadgetid	:UINT	/* user-definable ID field */
    {userdata}	userdata	:APTR	/* ptr to general purpose User data (ignored by In) */
ENDOBJECT

NATIVE {intuitext} OBJECT intuitext
    {frontpen}	frontpen	:UBYTE
	{backpen}	backpen	:UBYTE	/* the pen numbers for the rendering */
    {drawmode}	drawmode	:UBYTE		/* the mode for rendering the text */
    {leftedge}	leftedge	:INT		/* relative start location for the text */
    {topedge}	topedge	:INT		/* relative start location for the text */
    {itextfont}	itextfont	:PTR TO textattr	/* if NULL, you accept the default */
    {itext}	itext	:ARRAY OF UBYTE		/* pointer to null-terminated text */
    {nexttext}	nexttext	:PTR TO intuitext /* pointer to another IntuiText to render */
ENDOBJECT

NATIVE {border} OBJECT border
    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT	/* initial offsets from the origin */
    {frontpen}	frontpen	:UBYTE
	{backpen}	backpen	:UBYTE	/* pens numbers for rendering */
    {drawmode}	drawmode	:UBYTE		/* mode for rendering */
    {count}	count	:BYTE			/* number of XY pairs */
    {xy}	xy	:PTR TO INT			/* vector coordinate pairs rel to LeftTop */
    {nextborder}	nextborder	:PTR TO border	/* pointer to any other Border too */
ENDOBJECT

NATIVE {image} OBJECT image
    {leftedge}	leftedge	:INT		/* starting offset relative to some origin */
    {topedge}	topedge	:INT		/* starting offsets relative to some origin */
    {width}	width	:INT			/* pixel size (though data is word-aligned) */
    {height}	height	:INT
    {depth}	depth	:INT			/* >= 0, for images you create		*/
    {imagedata}	imagedata	:ARRAY OF UINT		/* pointer to the actual word-aligned bits */

    {planepick}	planepick	:UBYTE
	{planeonoff}	planeonoff	:UBYTE

    {nextimage}	nextimage	:PTR TO image
ENDOBJECT

NATIVE {intuimessage} OBJECT intuimessage
    {execmessage}	execmessage	:mn

    {class}	class	:ULONG

    {code}	code	:UINT

    {qualifier}	qualifier	:UINT

    {iaddress}	iaddress	:APTR

    {mousex}	mousex	:INT
	{mousey}	mousey	:INT

    {seconds}	seconds	:ULONG
	{micros}	micros	:ULONG

    {idcmpwindow}	idcmpwindow	:PTR TO window

    {speciallink}	speciallink	:PTR TO intuimessage
ENDOBJECT

NATIVE {window} OBJECT window
    {nextwindow}	nextwindow	:PTR TO window		/* for the linked list in a screen */

    {leftedge}	leftedge	:INT
	{topedge}	topedge	:INT		/* screen dimensions of window */
    {width}	width	:INT
	{height}	height	:INT			/* screen dimensions of window */

    {mousey}	mousey	:INT
	{mousex}	mousex	:INT		/* relative to upper-left of window */

    {minwidth}	minwidth	:INT
	{minheight}	minheight	:INT		/* minimum sizes */
    {maxwidth}	maxwidth	:UINT
	{maxheight}	maxheight	:UINT		/* maximum sizes */

    {flags}	flags	:ULONG			/* see below for defines */

    {menustrip}	menustrip	:PTR TO menu		/* the strip of Menu headers */

    {title}	title	:ARRAY OF UBYTE			/* the title text for this window */

    {firstrequest}	firstrequest	:PTR TO requester	/* all active Requesters */

    {dmrequest}	dmrequest	:PTR TO requester	/* double-click Requester */

    {reqcount}	reqcount	:INT			/* count of reqs blocking Window */

    {wscreen}	wscreen	:PTR TO screen		/* this Window's Screen */
    {rport}	rport	:PTR TO rastport		/* this Window's very own RastPort */

    {borderleft}	borderleft	:BYTE
	{bordertop}	bordertop	:BYTE
	{borderright}	borderright	:BYTE
	{borderbottom}	borderbottom	:BYTE
    {borderrport}	borderrport	:PTR TO rastport


    {firstgadget}	firstgadget	:PTR TO gadget

    {parent}	parent	:PTR TO window
	{descendant}	descendant	:PTR TO window

    {pointer}	pointer	:PTR TO UINT	/* sprite data */
    {ptrheight}	ptrheight	:BYTE	/* sprite height (not including sprite padding) */
    {ptrwidth}	ptrwidth	:BYTE	/* sprite width (must be less than or equal to 16) */
    {xoffset}	xoffset	:BYTE
	{yoffset}	yoffset	:BYTE	/* sprite offsets */

    {idcmpflags}	idcmpflags	:ULONG	/* User-selected flags */
    {userport}	userport	:PTR TO mp
	{windowport}	windowport	:PTR TO mp
    {messagekey}	messagekey	:PTR TO intuimessage

    {detailpen}	detailpen	:UBYTE
	{blockpen}	blockpen	:UBYTE	/* for bar/border/gadget rendering */

    {checkmark}	checkmark	:PTR TO image

    {screentitle}	screentitle	:ARRAY OF UBYTE	/* if non-null, Screen title when Window is active */

    {gzzmousex}	gzzmousex	:INT
    {gzzmousey}	gzzmousey	:INT
    {gzzwidth}	gzzwidth	:INT
    {gzzheight}	gzzheight	:INT

    {extdata}	extdata	:PTR TO UBYTE

    {userdata}	userdata	:PTR TO BYTE	/* general-purpose pointer to User data extension */

    {wlayer}	wlayer	:PTR TO layer

    {ifont}	ifont	:PTR TO textfont

    {moreflags}	moreflags	:ULONG
ENDOBJECT
