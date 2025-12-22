OPT NATIVE

NATIVE {VSprite} OBJECT vs
/* --------------------- SYSTEM VARIABLES ------------------------------- */
/* GEL linked list forward/backward pointers sorted by y,x value */
    {NextVSprite}	nextvsprite	:PTR TO vs
    {PrevVSprite}	prevvsprite	:PTR TO vs

/* GEL draw list constructed in the order the Bobs are actually drawn, then
 *  list is copied to clear list
 *  must be here in VSprite for system boundary detection
 */
    {DrawPath}	drawpath	:PTR TO vs  /* pointer of overlay drawing */
    {ClearPath}	clearpath	:PTR TO vs /* pointer for overlay clearing */

/* the VSprite positions are defined in (y,x) order to make sorting
 *  sorting easier, since (y,x) as a long integer
 */
    {OldY}	oldy	:INT
	{OldX}	oldx	:INT /* previous position */

/* --------------------- COMMON VARIABLES --------------------------------- */
    {Flags}	vsflags	:INT /* VSprite flags */


/* --------------------- USER VARIABLES ----------------------------------- */
/* the VSprite positions are defined in (y,x) order to make sorting
 *  sorting easier, since (y,x) as a long integer
 */
    {Y}	y	:INT
	{X}	x	:INT                /* screen position */

    {Height}	height	:INT
    {Width}	width	:INT      /* number of words per row of image data */
    {Depth}	depth	:INT      /* number of planes of data */

    {MeMask}	memask	:INT     /* which types can collide with this VSprite*/
    {HitMask}	hitmask	:INT    /* which types this VSprite can collide with*/

    {ImageData}	imagedata	:PTR TO INT /* pointer to VSprite image */

/* borderLine is the one-dimensional logical OR of all
 *  the VSprite bits, used for fast collision detection of edge
 */
    {BorderLine}	borderline	:PTR TO INT /* logical OR of all VSprite bits */
    {CollMask}	collmask	:PTR TO INT   /* similar to above except this is a matrix */

/* pointer to this VSprite's color definitions (not used by Bobs) */
    {SprColors}	sprcolors	:PTR TO INT

    {VSBob}	vsbob	:PTR TO bob /* points home if this VSprite is part of a Bob */

/* planePick flag:  set bit selects a plane from image, clear bit selects
 *  use of shadow mask for that plane
 * OnOff flag: if using shadow mask to fill plane, this bit (corresponding
 *  to bit in planePick) describes whether to fill with 0's or 1's
 * There are two uses for these flags:
 *      - if this is the VSprite of a Bob, these flags describe how the Bob
 *        is to be drawn into memory
 *      - if this is a simple VSprite and the user intends on setting the
 *        MUSTDRAW flag of the VSprite, these flags must be set too to describe
 *        which color registers the user wants for the image
 */
    {PlanePick}	planepick	:BYTE
    {PlaneOnOff}	planeonoff	:BYTE

    {VUserExt}	vuserext	:INT /*VUserStuff*/      /* user definable:  see note above */
ENDOBJECT

NATIVE {Bob} OBJECT bob
/* --------------------- SYSTEM VARIABLES --------------------------------- */

/* --------------------- COMMON VARIABLES --------------------------------- */
    {Flags}	bobflags	:INT /* general purpose flags (see definitions below) */

/* --------------------- USER VARIABLES ----------------------------------- */
    {SaveBuffer}	savebuffer	:PTR TO INT /* pointer to the buffer for background save */

/* used by Bobs for "cookie-cutting" and multi-plane masking */
    {ImageShadow}	imageshadow	:PTR TO INT

/* pointer to BOBs for sequenced drawing of Bobs
 *  for correct overlaying of multiple component animations
 */
    {Before}	before	:PTR TO bob /* draw this Bob before Bob pointed to by before */
    {After}	after	:PTR TO bob  /* draw this Bob after Bob pointed to by after */

    {BobVSprite}	bobvsprite	:PTR TO vs /* this Bob's VSprite definition */

    {BobComp}	bobcomp	:PTR TO ac    /* pointer to this Bob's AnimComp def */

    {DBuffer}	dbuffer	:PTR TO dbp    /* pointer to this Bob's dBuf packet */

    {BUserExt}	buserext	:INT /*BUserStuff*/           /* Bob user extension */
ENDOBJECT

NATIVE {AnimComp} OBJECT ac
/* --------------------- SYSTEM VARIABLES --------------------------------- */

/* --------------------- COMMON VARIABLES --------------------------------- */
    {Flags}	compflags	:INT /* AnimComp flags for system & user */

/* timer defines how long to keep this component active:
 *  if set non-zero, timer decrements to zero then switches to nextSeq
 *  if set to zero, AnimComp never switches
 */
    {Timer}	timer	:INT

/* --------------------- USER VARIABLES ----------------------------------- */
/* initial value for timer when the AnimComp is activated by the system */
    {TimeSet}	timeset	:INT

/* pointer to next and previous components of animation object */
    {NextComp}	nextcomp	:PTR TO ac
    {PrevComp}	prevcomp	:PTR TO ac

/* pointer to component component definition of next image in sequence */
    {NextSeq}	nextseq	:PTR TO ac
    {PrevSeq}	prevseq	:PTR TO ac

/* address of special animation procedure */
    {AnimCRoutine}	animcroutine	:NATIVE {WORD            (*)(struct GraphicsIFace *, struct AnimComp *)} PTR

    {YTrans}	ytrans	:INT /* initial y translation (if this is a component) */
    {XTrans}	xtrans	:INT /* initial x translation (if this is a component) */

    {HeadOb}	headob	:PTR TO ao

    {AnimBob}	animbob	:PTR TO bob
ENDOBJECT

NATIVE {AnimOb} OBJECT ao
/* --------------------- SYSTEM VARIABLES --------------------------------- */
    {NextOb}	nextob	:PTR TO ao
	{PrevOb}	prevob	:PTR TO ao

/* number of calls to Animate this AnimOb has endured */
    {Clock}	clock	:VALUE

    {AnOldY}	anoldy	:INT
	{AnOldX}	anoldx	:INT         /* old y,x coordinates */

/* --------------------- COMMON VARIABLES --------------------------------- */
    {AnY}	any	:INT
	{AnX}	anx	:INT               /* y,x coordinates of the AnimOb */

/* --------------------- USER VARIABLES ----------------------------------- */
    {YVel}	yvel	:INT
	{XVel}	xvel	:INT             /* velocities of this object */
    {YAccel}	yaccel	:INT
	{XAccel}	xaccel	:INT         /* accelerations of this object */

    {RingYTrans}	ringytrans	:INT
	{RingXTrans}	ringxtrans	:INT /* ring translation values */

                                 /* address of special animation
                                    procedure */
    {AnimORoutine}	animoroutine	:NATIVE {WORD (*)(struct GraphicsIFace *, struct AnimOb *)} PTR

    {HeadComp}	headcomp	:PTR TO ac  /* pointer to first component */

    {AUserExt}	auserext	:INT /*AUserStuff*/         /* AnimOb user extension */
ENDOBJECT

NATIVE {DBufPacket} OBJECT dbp
    {BufY}	bufy	:INT
	{BufX}	bufx	:INT         /* save the other buffers screen coordinates */
    {BufPath}	bufpath	:PTR TO vs /* carry the draw path over the gap */

/* these pointers must be filled in by the user */
/* pointer to other buffer's background save buffer */
    {BufBuffer}	bufbuffer	:PTR TO INT
	->AmigaE "bufplanes" member is missing
ENDOBJECT

NATIVE {collTable} OBJECT colltable
    /* NOTE:
     * This table actually consists of two different types of
     * pointers. The first table entry is for collision testing,
     * the other are for reporting collisions. The first function
     * pointer looks like this:
     *
     * LONG (*collPtrs[0])(struct GraphicsIFace *, struct VSprite *, WORD);
     *
     * when it points to PPC code and like this:
     *
     * LONG (* STDARGS collPtrs[0])(struct VSprite *, WORD);
     *
     * when it points to 68k code.
     *
     * The remaining 15 function pointers look like this:
     *
     * VOID (*collPtrs[1..15])(struct GraphicsIFace *,
     *                         struct VSprite *,
     *                         struct VSprite *);
     *
     * when they point to PPC code and like this:
     *
     * VOID (* STDARGS collPtrs[1..15])(struct VSprite *, struct VSprite *);
     *
     * when they point to 68k code.
     */
    {collPtrs}	collptrs[16]	:ARRAY OF NATIVE {LONG (*)(struct GraphicsIFace *,struct VSprite *,struct VSprite *)} PTR	/*LONG (*collPtrs[16])(struct GraphicsIFace *,struct VSprite *,struct VSprite *)*/
ENDOBJECT
