OPT NATIVE
MODULE 'target/graphics/clip', 'target/graphics/gfx', 'target/graphics/text', 'target/exec/ports', 'target/graphics/view'
MODULE 'target/exec/types'

NATIVE {Screen} OBJECT screen
    {NextScreen}	nextscreen	:PTR TO screen		/* linked list of screens */
    {FirstWindow}	firstwindow	:PTR TO window		/* linked list Screen's Windows */

    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT		/* parameters of the screen */
    {Width}	width	:INT
	{Height}	height	:INT			/* parameters of the screen */

    {MouseY}	mousey	:INT
	{MouseX}	mousex	:INT		/* position relative to upper-left */

    {Flags}	flags	:UINT			/* see definitions below */

    {Title}	title	:ARRAY OF UBYTE			/* null-terminated Title text */
    {DefaultTitle}	defaulttitle	:ARRAY OF UBYTE		/* for Windows without ScreenTitle */

    /* Bar sizes for this Screen and all Window's in this Screen */
    /* Note that BarHeight is one less than the actual menu bar
     * height.	We're going to keep this in V36 for compatibility,
     * although V36 artwork might use that extra pixel
     *
     * Also, the title bar height of a window is calculated from the
     * screen's WBorTop field, plus the font height, plus one.
     */
    {BarHeight}	barheight	:BYTE
	{BarVBorder}	barvborder	:BYTE
	{BarHBorder}	barhborder	:BYTE
	{MenuVBorder}	menuvborder	:BYTE
	{MenuHBorder}	menuhborder	:BYTE
    {WBorTop}	wbortop	:BYTE
	{WBorLeft}	wborleft	:BYTE
	{WBorRight}	wborright	:BYTE
	{WBorBottom}	wborbottom	:BYTE

    {Font}	font	:PTR TO textattr		/* this screen's default font	   */

    /* the display data structures for this Screen */
    {ViewPort}	viewport	:viewport		/* describing the Screen's display */
    {RastPort}	rastport	:rastport		/* describing Screen rendering	   */
    {BitMap}	bitmap	:bitmap		/* SEE WARNING ABOVE!		   */
    {LayerInfo}	layerinfo	:layer_info	/* each screen gets a LayerInfo    */

    /* Only system gadgets may be attached to a screen.
     *	You get the standard system Screen Gadgets automatically
     */
    {FirstGadget}	firstgadget	:PTR TO gadget

    {DetailPen}	detailpen	:UBYTE
	{BlockPen}	blockpen	:UBYTE		/* for bar/border/gadget rendering */

    /* the following variable(s) are maintained by Intuition to support the
     * DisplayBeep() color flashing technique
     */
    {SaveColor0}	savecolor0	:UINT

    /* This layer is for the Screen and Menu bars */
    {BarLayer}	barlayer	:PTR TO layer

    {ExtData}	extdata	:PTR TO UBYTE

    {UserData}	userdata	:PTR TO UBYTE	/* general-purpose pointer to User data extension */

    /**** Data below this point are SYSTEM PRIVATE ****/
ENDOBJECT


NATIVE {Menu} OBJECT menu
    {NextMenu}	nextmenu	:PTR TO menu	/* same level */
    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT	/* position of the select box */
    {Width}	width	:INT
	{Height}	height	:INT	/* dimensions of the select box */
    {Flags}	flags	:UINT		/* see flag definitions below */
    {MenuName}	menuname	:ARRAY OF BYTE		/* text for this Menu Header */
    {FirstItem}	firstitem	:PTR TO menuitem /* pointer to first in chain */

    /* these mysteriously-named variables are for internal use only */
    {JazzX}	jazzx	:INT
	{JazzY}	jazzy	:INT
	{BeatX}	beatx	:INT
	{BeatY}	beaty	:INT
ENDOBJECT

NATIVE {MenuItem} OBJECT menuitem
    {NextItem}	nextitem	:PTR TO menuitem	/* pointer to next in chained list */
    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT	/* position of the select box */
    {Width}	width	:INT
	{Height}	height	:INT		/* dimensions of the select box */
    {Flags}	flags	:UINT		/* see the defines below */

    {MutualExclude}	mutualexclude	:VALUE		/* set bits mean this item excludes that */

    {ItemFill}	itemfill	:APTR		/* points to Image, IntuiText, or NULL */

    /* when this item is pointed to by the cursor and the items highlight
     *	mode HIGHIMAGE is selected, this alternate image will be displayed
     */
    {SelectFill}	selectfill	:APTR		/* points to Image, IntuiText, or NULL */

    {Command}	command	:BYTE		/* only if appliprog sets the COMMSEQ flag */

    {SubItem}	subitem	:PTR TO menuitem	/* if non-zero, points to MenuItem for submenu */

    /* The NextSelect field represents the menu number of next selected
     *	item (when user has drag-selected several items)
     */
    {NextSelect}	nextselect	:UINT
ENDOBJECT

NATIVE {Requester} OBJECT requester
    {OlderRequest}	olderrequest	:PTR TO requester
    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT		/* dimensions of the entire box */
    {Width}	width	:INT
	{Height}	height	:INT			/* dimensions of the entire box */
    {RelLeft}	relleft	:INT
	{RelTop}	reltop	:INT		/* for Pointer relativity offsets */

    {ReqGadget}	reqgadget	:PTR TO gadget		/* pointer to a list of Gadgets */
    {ReqBorder}	reqborder	:PTR TO border		/* the box's border */
    {ReqText}	reqtext	:PTR TO intuitext		/* the box's text */
    {Flags}	flags	:UINT			/* see definitions below */

    /* pen number for back-plane fill before draws */
    {BackFill}	backfill	:UBYTE
    /* Layer in place of clip rect	*/
    {ReqLayer}	reqlayer	:PTR TO layer

    {ReqPad1}	reqpad1[32]	:ARRAY OF UBYTE

    /* If the BitMap plane pointers are non-zero, this tells the system
     * that the image comes pre-drawn (if the appliprog wants to define
     * its own box, in any shape or size it wants!);  this is OK by
     * Intuition as long as there's a good correspondence between
     * the image and the specified Gadgets
     */
    {ImageBMap}	imagebmap	:PTR TO bitmap	/* points to the BitMap of PREDRAWN imagery */
    {RWindow}	rwindow	:PTR TO window	/* added.  points back to Window */

    {ReqImage}	reqimage	:PTR TO image	/* new for V36: drawn if USEREQIMAGE set */

    {ReqPad2}	reqpad2[32]	:ARRAY OF UBYTE
ENDOBJECT

NATIVE {Gadget} OBJECT gadget
    {NextGadget}	nextgadget	:PTR TO gadget	/* next gadget in the list */

    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT	/* "hit box" of gadget */
    {Width}	width	:INT
	{Height}	height	:INT		/* "hit box" of gadget */

    {Flags}	flags	:UINT		/* see below for list of defines */

    {Activation}	activation	:UINT		/* see below for list of defines */

    {GadgetType}	gadgettype	:UINT		/* see below for defines */

    /* appliprog can specify that the Gadget be rendered as either as Border
     * or an Image.  This variable points to which (or equals NULL if there's
     * nothing to be rendered about this Gadget)
     */
    {GadgetRender}	gadgetrender	:APTR2

    /* appliprog can specify "highlighted" imagery rather than algorithmic
     * this can point to either Border or Image data
     */
    {SelectRender}	selectrender	:APTR2

    {GadgetText}	gadgettext	:PTR TO intuitext   /* text for this gadget */

    /* MutualExclude, never implemented, is now declared obsolete.
     * There are published examples of implementing a more general
     * and practical exclusion in your applications.
     *
     * Starting with V36, this field is used to point to a hook
     * for a custom gadget.
     *
     * Programs using this field for their own processing will
     * continue to work, as long as they don't try the
     * trick with custom gadgets.
     */
    {MutualExclude}	mutualexclude	:VALUE  /* obsolete */

    /* pointer to a structure of special data required by Proportional,
     * String and Integer Gadgets
     */
    {SpecialInfo}	specialinfo	:APTR

    {GadgetID}	gadgetid	:UINT	/* user-definable ID field */
    {UserData}	userdata	:APTR	/* ptr to general purpose User data (ignored by In) */
ENDOBJECT

NATIVE {IntuiText} OBJECT intuitext
    {FrontPen}	frontpen	:UBYTE
	{BackPen}	backpen	:UBYTE	/* the pen numbers for the rendering */
    {DrawMode}	drawmode	:UBYTE		/* the mode for rendering the text */
    {LeftEdge}	leftedge	:INT		/* relative start location for the text */
    {TopEdge}	topedge	:INT		/* relative start location for the text */
    {ITextFont}	itextfont	:PTR TO textattr	/* if NULL, you accept the default */
    {IText}	itext	:ARRAY OF UBYTE		/* pointer to null-terminated text */
    {NextText}	nexttext	:PTR TO intuitext /* pointer to another IntuiText to render */
ENDOBJECT

NATIVE {Border} OBJECT border
    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT	/* initial offsets from the origin */
    {FrontPen}	frontpen	:UBYTE
	{BackPen}	backpen	:UBYTE	/* pens numbers for rendering */
    {DrawMode}	drawmode	:UBYTE		/* mode for rendering */
    {Count}	count	:BYTE			/* number of XY pairs */
    {XY}	xy	:PTR TO INT			/* vector coordinate pairs rel to LeftTop */
    {NextBorder}	nextborder	:PTR TO border	/* pointer to any other Border too */
ENDOBJECT

NATIVE {Image} OBJECT image
    {LeftEdge}	leftedge	:INT		/* starting offset relative to some origin */
    {TopEdge}	topedge	:INT		/* starting offsets relative to some origin */
    {Width}	width	:INT			/* pixel size (though data is word-aligned) */
    {Height}	height	:INT
    {Depth}	depth	:INT			/* >= 0, for images you create		*/
    {ImageData}	imagedata	:ARRAY OF UINT		/* pointer to the actual word-aligned bits */

    /* the PlanePick and PlaneOnOff variables work much the same way as the
     * equivalent GELS Bob variables.  It's a space-saving
     * mechanism for image data.  Rather than defining the image data
     * for every plane of the RastPort, you need define data only
     * for the planes that are not entirely zero or one.  As you
     * define your Imagery, you will often find that most of the planes
     * ARE just as color selectors.  For instance, if you're designing
     * a two-color Gadget to use colors one and three, and the Gadget
     * will reside in a five-plane display, bit plane zero of your
     * imagery would be all ones, bit plane one would have data that
     * describes the imagery, and bit planes two through four would be
     * all zeroes.  Using these flags avoids wasting all
     * that memory in this way:  first, you specify which planes you
     * want your data to appear in using the PlanePick variable.  For
     * each bit set in the variable, the next "plane" of your image
     * data is blitted to the display.	For each bit clear in this
     * variable, the corresponding bit in PlaneOnOff is examined.
     * If that bit is clear, a "plane" of zeroes will be used.
     * If the bit is set, ones will go out instead.  So, for our example:
     *	 Gadget.PlanePick = 0x02;
     *	 Gadget.PlaneOnOff = 0x01;
     * Note that this also allows for generic Gadgets, like the
     * System Gadgets, which will work in any number of bit planes.
     * Note also that if you want an Image that is only a filled
     * rectangle, you can get this by setting PlanePick to zero
     * (pick no planes of data) and set PlaneOnOff to describe the pen
     * color of the rectangle.
     *
     * NOTE:  Intuition relies on PlanePick to know how many planes
     * of data are found in ImageData.	There should be no more
     * '1'-bits in PlanePick than there are planes in ImageData.
     */
    {PlanePick}	planepick	:UBYTE
	{PlaneOnOff}	planeonoff	:UBYTE

    /* if the NextImage variable is not NULL, Intuition presumes that
     * it points to another Image structure with another Image to be
     * rendered
     */
    {NextImage}	nextimage	:PTR TO image
ENDOBJECT

NATIVE {IntuiMessage} OBJECT intuimessage
    {ExecMessage}	execmessage	:mn

    /* the Class bits correspond directly with the IDCMP Flags, except for the
     * special bit IDCMP_LONELYMESSAGE (defined below)
     */
    {Class}	class	:ULONG

    /* the Code field is for special values like MENU number */
    {Code}	code	:UINT

    /* the Qualifier field is a copy of the current InputEvent's Qualifier */
    {Qualifier}	qualifier	:UINT

    /* IAddress contains particular addresses for Intuition functions, like
     * the pointer to the Gadget or the Screen
     */
    {IAddress}	iaddress	:APTR

    /* when getting mouse movement reports, any event you get will have the
     * the mouse coordinates in these variables.  the coordinates are relative
     * to the upper-left corner of your Window (WFLG_GIMMEZEROZERO
     * notwithstanding).  If IDCMP_DELTAMOVE is set, these values will
     * be deltas from the last reported position.
     */
    {MouseX}	mousex	:INT
	{MouseY}	mousey	:INT

    /* the time values are copies of the current system clock time.  Micros
     * are in units of microseconds, Seconds in seconds.
     */
    {Seconds}	seconds	:ULONG
	{Micros}	micros	:ULONG

    /* the IDCMPWindow variable will always have the address of the Window of
     * this IDCMP
     */
    {IDCMPWindow}	idcmpwindow	:PTR TO window

    /* system-use variable */
    {SpecialLink}	speciallink	:PTR TO intuimessage
ENDOBJECT

NATIVE {Window} OBJECT window
    {NextWindow}	nextwindow	:PTR TO window		/* for the linked list in a screen */

    {LeftEdge}	leftedge	:INT
	{TopEdge}	topedge	:INT		/* screen dimensions of window */
    {Width}	width	:INT
	{Height}	height	:INT			/* screen dimensions of window */

    {MouseY}	mousey	:INT
	{MouseX}	mousex	:INT		/* relative to upper-left of window */

    {MinWidth}	minwidth	:INT
	{MinHeight}	minheight	:INT		/* minimum sizes */
    {MaxWidth}	maxwidth	:UINT
	{MaxHeight}	maxheight	:UINT		/* maximum sizes */

    {Flags}	flags	:ULONG			/* see below for defines */

    {MenuStrip}	menustrip	:PTR TO menu		/* the strip of Menu headers */

    {Title}	title	:ARRAY OF UBYTE			/* the title text for this window */

    {FirstRequest}	firstrequest	:PTR TO requester	/* all active Requesters */

    {DMRequest}	dmrequest	:PTR TO requester	/* double-click Requester */

    {ReqCount}	reqcount	:INT			/* count of reqs blocking Window */

    {WScreen}	wscreen	:PTR TO screen		/* this Window's Screen */
    {RPort}	rport	:PTR TO rastport		/* this Window's very own RastPort */

    /* the border variables describe the window border.  If you specify
     * WFLG_GIMMEZEROZERO when you open the window, then the upper-left of
     * the ClipRect for this window will be upper-left of the BitMap (with
     * correct offsets when in SuperBitMap mode; you MUST select
     * WFLG_GIMMEZEROZERO when using SuperBitMap).  If you don't specify
     * ZeroZero, then you save memory (no allocation of RastPort, Layer,
     * ClipRect and associated Bitmaps), but you also must offset all your
     * writes by BorderTop, BorderLeft and do your own mini-clipping to
     * prevent writing over the system gadgets
     */
    {BorderLeft}	borderleft	:BYTE
	{BorderTop}	bordertop	:BYTE
	{BorderRight}	borderright	:BYTE
	{BorderBottom}	borderbottom	:BYTE
    {BorderRPort}	borderrport	:PTR TO rastport


    /* You supply a linked-list of Gadgets for your Window.
     * This list DOES NOT include system gadgets.  You get the standard
     * window system gadgets by setting flag-bits in the variable Flags (see
     * the bit definitions below)
     */
    {FirstGadget}	firstgadget	:PTR TO gadget

    /* these are for opening/closing the windows */
    {Parent}	parent	:PTR TO window
	{Descendant}	descendant	:PTR TO window

    /* sprite data information for your own Pointer
     * set these AFTER you Open the Window by calling SetPointer()
     */
    {Pointer}	pointer	:PTR TO UINT	/* sprite data */
    {PtrHeight}	ptrheight	:BYTE	/* sprite height (not including sprite padding) */
    {PtrWidth}	ptrwidth	:BYTE	/* sprite width (must be less than or equal to 16) */
    {XOffset}	xoffset	:BYTE
	{YOffset}	yoffset	:BYTE	/* sprite offsets */

    /* the IDCMP Flags and User's and Intuition's Message Ports */
    {IDCMPFlags}	idcmpflags	:ULONG	/* User-selected flags */
    {UserPort}	userport	:PTR TO mp
	{WindowPort}	windowport	:PTR TO mp
    {MessageKey}	messagekey	:PTR TO intuimessage

    {DetailPen}	detailpen	:UBYTE
	{BlockPen}	blockpen	:UBYTE	/* for bar/border/gadget rendering */

    /* the CheckMark is a pointer to the imagery that will be used when
     * rendering MenuItems of this Window that want to be checkmarked
     * if this is equal to NULL, you'll get the default imagery
     */
    {CheckMark}	checkmark	:PTR TO image

    {ScreenTitle}	screentitle	:ARRAY OF UBYTE	/* if non-null, Screen title when Window is active */

    /* These variables have the mouse coordinates relative to the
     * inner-Window of WFLG_GIMMEZEROZERO Windows.  This is compared with the
     * MouseX and MouseY variables, which contain the mouse coordinates
     * relative to the upper-left corner of the Window, WFLG_GIMMEZEROZERO
     * notwithstanding
     */
    {GZZMouseX}	gzzmousex	:INT
    {GZZMouseY}	gzzmousey	:INT
    /* these variables contain the width and height of the inner-Window of
     * WFLG_GIMMEZEROZERO Windows
     */
    {GZZWidth}	gzzwidth	:INT
    {GZZHeight}	gzzheight	:INT

    {ExtData}	extdata	:PTR TO UBYTE

    {UserData}	userdata	:PTR TO BYTE	/* general-purpose pointer to User data extension */

    /** 11/18/85: this pointer keeps a duplicate of what
     * Window.RPort->Layer is _supposed_ to be pointing at
     */
    {WLayer}	wlayer	:PTR TO layer

    /* NEW 1.2: need to keep track of the font that
     * OpenWindow opened, in case user SetFont's into RastPort
     */
    {IFont}	ifont	:PTR TO textfont

    /* (V36) another flag word (the Flags field is used up).
     * At present, all flag values are system private.
     * Until further notice, you may not change nor use this field.
     */
    {MoreFlags}	moreflags	:ULONG

    /**** Data beyond this point are Intuition Private.  DO NOT USE ****/
ENDOBJECT
