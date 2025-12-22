OPT NATIVE
MODULE 'target/graphics/clip', 'target/graphics/gfx', 'target/graphics/text', 'target/exec/ports', 'target/graphics/view'
MODULE 'target/exec/types'

NATIVE {Screen} OBJECT screen
    {NextScreen}	nextscreen	:PTR TO screen
    {FirstWindow}	firstwindow	:PTR TO window

    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT

    {MouseX}	mousey	:INT
    {MouseY}	mousex	:INT

    {Flags}	flags	:UINT
    {Title}	title	:ARRAY OF UBYTE
    {DefaultTitle}	defaulttitle	:ARRAY OF UBYTE

    {BarHeight}	barheight	:BYTE
    {BarVBorder}	barvborder	:BYTE
    {BarHBorder}	barhborder	:BYTE
    {MenuVBorder}	menuvborder	:BYTE
    {MenuHBorder}	menuhborder	:BYTE
    {WBorTop}	wbortop	:BYTE
    {WBorLeft}	wborleft	:BYTE
    {WBorRight}	wborright	:BYTE
    {WBorBottom}	wborbottom	:BYTE

    {Font}	font	:PTR TO textattr

    {ViewPort}	viewport	:viewport
    {RastPort}	rastport	:rastport
    {BitMap}	bitmap	:bitmap    /* OBSOLETE */
    {LayerInfo}	layerinfo	:layer_info

    {FirstGadget}	firstgadget	:PTR TO gadget

    {DetailPen}	detailpen	:UBYTE
    {BlockPen}	blockpen	:UBYTE

    {SaveColor0}	savecolor0	:UINT
    {BarLayer}	barlayer	:PTR TO layer
    {ExtData}	extdata	:PTR TO UBYTE
    {UserData}	userdata	:PTR TO UBYTE
ENDOBJECT

NATIVE {DrawInfo} OBJECT drawinfo
    {dri_Version}	version	:UINT /* see below */
    {dri_NumPens}	numpens	:UINT
    {dri_Pens}	pens	:PTR TO UINT    /* see below */
    {dri_Font}	font	:PTR TO textfont
    {dri_Depth}	depth	:UINT

    {dri_Resolution.X}	resolutionx	:UINT
    {dri_Resolution.Y}	resolutiony	:UINT

    {dri_Flags}	flags	:ULONG /* see below */

    {dri_CheckMark}	checkmark	:PTR TO image
    {dri_AmigaKey}	amigakey	:PTR TO image
    {dri_SubMenuImage}	submenuimage	:PTR TO image

    {dri_Reserved}	reserved[5]	:ARRAY OF ULONG
ENDOBJECT


NATIVE {Menu} OBJECT menu
    {NextMenu}	nextmenu	:PTR TO menu

    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT
    {Flags}	flags	:UINT    /* see below */
    {MenuName}	menuname	:ARRAY OF BYTE

    {FirstItem}	firstitem	:PTR TO menuitem

    /* PRIVATE */
    {JazzX}	jazzx	:INT
    {JazzY}	jazzy	:INT
    {BeatX}	beatx	:INT
    {BeatY}	beaty	:INT
ENDOBJECT

NATIVE {MenuItem} OBJECT menuitem
    {NextItem}	nextitem	:PTR TO menuitem

    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT
    {Flags}	flags	:UINT	 /* see below */
    {MutualExclude}	mutualexclude	:VALUE
    {ItemFill}	itemfill	:APTR
    {SelectFill}	selectfill	:APTR
    {Command}	command	:BYTE

    {SubItem}	subitem	:PTR TO menuitem
    {NextSelect}	nextselect	:UINT
ENDOBJECT

NATIVE {Requester} OBJECT requester
    {OlderRequest}	olderrequest	:PTR TO requester

    /* The dimensions of the requester */
    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT
    {RelLeft}	relleft	:INT
    {RelTop}	reltop	:INT

    {ReqGadget}	reqgadget	:PTR TO gadget /* First gadget of the requester */
    {ReqBorder}	reqborder	:PTR TO border /* First border of the requester */
    {ReqText}	reqtext	:PTR TO intuitext   /* First intuitext of the requester */

    {Flags}	flags	:UINT    /* see below */
    {BackFill}	backfill	:UBYTE /* a pen to fill the background of the requester */

    {ReqLayer}	reqlayer	:PTR TO layer /* The layer on which the requester is based */

    {ReqPad1}	reqpad1[32]	:ARRAY OF UBYTE /* PRIVATE */

    {ImageBMap}	imagebmap	:PTR TO bitmap /* you may use this to fill the requester
                                  with your own image */
    {RWindow}	rwindow	:PTR TO window   /* window, which the requester belongs to */
    {ReqImage}	reqimage	:PTR TO image  /* corresponds to USEREQIMAGE (see below) */

    {ReqPad2}	reqpad2[32]	:ARRAY OF UBYTE /* PRIVATE */
ENDOBJECT

NATIVE {Gadget} OBJECT gadget
    {NextGadget}	nextgadget	:PTR TO gadget

    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT

    {Flags}	flags	:UINT      /* see below */
    {Activation}	activation	:UINT /* see below */
    {GadgetType}	gadgettype	:UINT /* see below */

    {GadgetRender}	gadgetrender	:APTR2
    {SelectRender}	selectrender	:APTR2
    {GadgetText}	gadgettext	:PTR TO intuitext

    {MutualExclude}	mutualexclude	:VALUE /* OBSOLETE */

    {SpecialInfo}	specialinfo	:APTR
    {GadgetID}	gadgetid	:UINT
    {UserData}	userdata	:APTR
ENDOBJECT

NATIVE {IntuiText} OBJECT intuitext
    {FrontPen}	frontpen	:UBYTE
    {BackPen}	backpen	:UBYTE
    {DrawMode}	drawmode	:UBYTE
    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT

    {ITextFont}	itextfont	:PTR TO textattr
    {IText}	itext	:ARRAY OF UBYTE
    {NextText}	nexttext	:PTR TO intuitext
ENDOBJECT

NATIVE {Border} OBJECT border
    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {FrontPen}	frontpen	:UBYTE
    {BackPen}	backpen	:UBYTE
    {DrawMode}	drawmode	:UBYTE
    {Count}	count	:BYTE
    {XY}	xy	:PTR TO INT

    {NextBorder}	nextborder	:PTR TO border
ENDOBJECT

NATIVE {Image} OBJECT image
    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT

    {Depth}	depth	:INT
    {ImageData}	imagedata	:ARRAY OF UINT
    {PlanePick}	planepick	:UBYTE
    {PlaneOnOff}	planeonoff	:UBYTE

    {NextImage}	nextimage	:PTR TO image
ENDOBJECT

NATIVE {IntuiMessage} OBJECT intuimessage
    {ExecMessage}	execmessage	:mn

    {Class}	class	:ULONG
    {Code}	code	:UINT
    {Qualifier}	qualifier	:UINT
    {IAddress}	iaddress	:APTR

    {MouseX}	mousex	:INT
    {MouseY}	mousey	:INT
    {Seconds}	seconds	:ULONG
    {Micros}	micros	:ULONG

    {IDCMPWindow}	idcmpwindow	:PTR TO window
    {SpecialLink}	speciallink	:PTR TO intuimessage
ENDOBJECT

NATIVE {Window} OBJECT window
    {NextWindow}	nextwindow	:PTR TO window

    {LeftEdge}	leftedge	:INT
    {TopEdge}	topedge	:INT
    {Width}	width	:INT
    {Height}	height	:INT
    {MouseX}	mousey	:INT
    {MouseY}	mousex	:INT
    {MinWidth}	minwidth	:INT
    {MinHeight}	minheight	:INT
    {MaxWidth}	maxwidth	:UINT
    {MaxHeight}	maxheight	:UINT

    {Flags}	flags	:ULONG

    {MenuStrip}	menustrip	:PTR TO menu
    {Title}	title	:ARRAY OF UBYTE
    {FirstRequest}	firstrequest	:PTR TO requester
    {DMRequest}	dmrequest	:PTR TO requester

    {ReqCount}	reqcount	:INT

    {WScreen}	wscreen	:PTR TO screen
    {RPort}	rport	:PTR TO rastport

    {BorderLeft}	borderleft	:BYTE
    {BorderTop}	bordertop	:BYTE
    {BorderRight}	borderright	:BYTE
    {BorderBottom}	borderbottom	:BYTE
    {BorderRPort}	borderrport	:PTR TO rastport

    {FirstGadget}	firstgadget	:PTR TO gadget
    {Parent}	parent	:PTR TO window
    {Descendant}	descendant	:PTR TO window

    {Pointer}	pointer	:PTR TO UINT
    {PtrHeight}	ptrheight	:BYTE
    {PtrWidth}	ptrwidth	:BYTE
    {XOffset}	xoffset	:BYTE
    {YOffset}	yoffset	:BYTE

    {IDCMPFlags}	idcmpflags	:ULONG
    {UserPort}	userport	:PTR TO mp
    {WindowPort}	windowport	:PTR TO mp
    {MessageKey}	messagekey	:PTR TO intuimessage

    {DetailPen}	detailpen	:UBYTE
    {BlockPen}	blockpen	:UBYTE
    {CheckMark}	checkmark	:PTR TO image
    {ScreenTitle}	screentitle	:ARRAY OF UBYTE

    {GZZMouseX}	gzzmousex	:INT
    {GZZMouseY}	gzzmousey	:INT
    {GZZWidth}	gzzwidth	:INT
    {GZZHeight}	gzzheight	:INT

    {ExtData}	extdata	:PTR TO UBYTE
    {UserData}	userdata	:PTR TO BYTE

    {WLayer}	wlayer	:PTR TO layer
    {IFont}	ifont	:PTR TO textfont

    {MoreFlags}	moreflags	:ULONG
    
    {RelLeftEdge}	relleftedge	:INT -> relative coordinates of the window
    {RelTopEdge}	reltopedge	:INT  -> to its parent window. If it is 
                      -> a window on the screen then these
                      -> are the same as LeftEdge and TopEdge.
    
    {firstchild}	firstchild	:PTR TO window  -> pointer to first child
    {prevchild}	prevchild	:PTR TO window   -> if window is a child of a window
    {nextchild}	nextchild	:PTR TO window   -> then they are concatenated here.
    {parent}	parent2	:PTR TO window      -> parent of this window
ENDOBJECT

NATIVE {IBox} OBJECT ibox
    {Left}	left	:INT
    {Top}	top	:INT
    {Width}	width	:INT
    {Height}	height	:INT
ENDOBJECT


NATIVE {GadgetInfo} OBJECT gadgetinfo
    {gi_Screen}	screen	:PTR TO screen
    {gi_Window}	window	:PTR TO window
    {gi_Requester}	requester	:PTR TO requester
    {gi_RastPort}	rastport	:PTR TO rastport
    {gi_Layer}	layer	:PTR TO layer
    {gi_Domain}	domain	:ibox

    {gi_Pens.DetailPen}	detailpen	:UBYTE
    {gi_Pens.BlockPen}	blockpen	:UBYTE

    {gi_DrInfo}	drinfo	:PTR TO drawinfo

    {gi_Reserved}	reserved[6]	:ARRAY OF ULONG
ENDOBJECT
