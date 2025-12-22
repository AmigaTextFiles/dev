OPT NATIVE

NATIVE {VSprite} OBJECT vs
/* SYSTEM VARIABLES */
    {NextVSprite}	nextvsprite	:PTR TO vs
    {PrevVSprite}	prevvsprite	:PTR TO vs

    {IntVSprite}	drawpath	:PTR TO vs /*??? IntVSprite*/
    {ClearPath}	clearpath	:PTR TO vs

    {OldY}	oldy	:INT
	{OldX}	oldx	:INT

/* COMMON VARIABLES */
    {Flags}	vsflags	:INT

/* USER VARIABLES */
    {Y}	y	:INT
	{X}	x	:INT

    {Height}	height	:INT
    {Width}	width	:INT
    {Depth}	depth	:INT

    {MeMask}	memask	:INT
    {HitMask}	hitmask	:INT

    {ImageData}	imagedata	:PTR TO INT

    {BorderLine}	borderline	:PTR TO INT
    {CollMask}	collmask	:PTR TO INT

    {SprColors}	sprcolors	:PTR TO INT

    {VSBob}	vsbob	:PTR TO bob	      

    {PlanePick}	planepick	:BYTE
    {PlaneOnOff}	planeonoff	:BYTE

    {VUserExt}	vuserext	:/*VUserStuff*/ INT      /* user definable:  see note above */
ENDOBJECT

NATIVE {Bob} OBJECT bob
/* SYSTEM VARIABLES */

/* COMMON VARIABLES */
    {Flags}	bobflags	:INT

/* USER VARIABLES */
    {SaveBuffer}	savebuffer	:PTR TO INT
    {ImageShadow}	imageshadow	:PTR TO INT
    {Before}	before	:PTR TO bob
    {After}	after	:PTR TO bob
    {BobVSprite}	bobvsprite	:PTR TO vs 
    {BobComp}	bobcomp	:PTR TO ac
    {DBuffer}	dbuffer	:PTR TO dbp
    {BUserExt}	buserext	:/*BUserStuff*/ INT
ENDOBJECT

NATIVE {AnimComp} OBJECT ac
/* SYSTEM VARIABLES */

/* COMMON VARIABLES */
    {Flags}	compflags	:INT
    {Timer}	timer	:INT

/* USER VARIABLES */
    {TimeSet}	timeset	:INT

    {NextComp}	nextcomp	:PTR TO ac
    {PrevComp}	prevcomp	:PTR TO ac
    {NextSeq}	nextseq	:PTR TO ac
    {PrevSeq}	prevseq	:PTR TO ac

    {AnimCRoutine}	animcroutine	:NATIVE {WORD (*)()} PTR

    {YTrans}	ytrans	:INT     
    {XTrans}	xtrans	:INT

    {HeadOb}	headob	:PTR TO ao

    {AnimBob}	animbob	:PTR TO bob
ENDOBJECT

NATIVE {AnimOb} OBJECT ao
/* SYSTEM VARIABLES  */
    {NextOb}	nextob	:PTR TO ao
	{PrevOb}	prevob	:PTR TO ao

    {Clock}	clock	:VALUE

    {AnOldY}	anoldy	:INT
	{AnOldX}	anoldx	:INT	   

/* COMMON VARIABLES */
    {AnY}	any	:INT
	{AnX}	anx	:INT

/* USER VARIABLES  */
    {YVel}	yvel	:INT
	{XVel}	xvel	:INT
    {YAccel}	yaccel	:INT
	{XAccel}	xaccel	:INT

    {RingYTrans}	ringytrans	:INT
	{RingXTrans}	ringxtrans	:INT

    {AnimORoutine}	animoroutine	:NATIVE {WORD (*)()} PTR

    {HeadComp}	headcomp	:PTR TO ac

    {AUserExt}	auserext	:/*AUserStuff*/ INT
ENDOBJECT

NATIVE {DBufPacket} OBJECT dbp
    {BufY}	bufy	:INT
	{BufX}	bufx	:INT		    
    {BufPath}	bufpath	:PTR TO vs

    {BufBuffer}	bufbuffer	:PTR TO INT
ENDOBJECT

NATIVE {collTable} OBJECT colltable
    {collPtrs}	collptrs[16]	:ARRAY OF NATIVE {int (*)()} PTR
ENDOBJECT
