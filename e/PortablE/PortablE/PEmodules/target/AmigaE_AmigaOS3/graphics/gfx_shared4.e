OPT NATIVE

NATIVE {vs} OBJECT vs
    {nextvsprite}	nextvsprite	:PTR TO vs
    {prevvsprite}	prevvsprite	:PTR TO vs

    {drawpath}	drawpath	:PTR TO vs     /* pointer of overlay drawing */
    {clearpath}	clearpath	:PTR TO vs    /* pointer for overlay clearing */

    {oldy}	oldy	:INT
	{oldx}	oldx	:INT	      /* previous position */

    {vsflags}	vsflags	:INT	      /* VSprite flags */

    {y}	y	:INT
	{x}	x	:INT		      /* screen position */

    {height}	height	:INT
    {width}	width	:INT	      /* number of words per row of image data */
    {depth}	depth	:INT	      /* number of planes of data */

    {memask}	memask	:INT	      /* which types can collide with this VSprite*/
    {hitmask}	hitmask	:INT	      /* which types this VSprite can collide with*/

    {imagedata}	imagedata	:PTR TO INT	      /* pointer to VSprite image */

    {borderline}	borderline	:PTR TO INT	      /* logical OR of all VSprite bits */
    {collmask}	collmask	:PTR TO INT	      /* similar to above except this is a matrix */

    {sprcolors}	sprcolors	:PTR TO INT

    {vsbob}	vsbob	:PTR TO bob	      /* points home if this VSprite is part of
				   a Bob */

    {planepick}	planepick	:BYTE
    {planeonoff}	planeonoff	:BYTE

    {vuserext}	vuserext	:INT /*VUserStuff*/      /* user definable:  see note above */
ENDOBJECT

NATIVE {bob} OBJECT bob
    {bobflags}	bobflags	:INT	/* general purpose flags (see definitions below) */

    {savebuffer}	savebuffer	:PTR TO INT	/* pointer to the buffer for background save */

    {imageshadow}	imageshadow	:PTR TO INT

    {before}	before	:PTR TO bob /* draw this Bob before Bob pointed to by before */
    {after}	after	:PTR TO bob	/* draw this Bob after Bob pointed to by after */

    {bobvsprite}	bobvsprite	:PTR TO vs   /* this Bob's VSprite definition */

    {bobcomp}	bobcomp	:PTR TO ac	    /* pointer to this Bob's AnimComp def */

    {dbuffer}	dbuffer	:PTR TO dbp     /* pointer to this Bob's dBuf packet */

    {buserext}	buserext	:INT /*BUserStuff*/	    /* Bob user extension */
ENDOBJECT

NATIVE {ac} OBJECT ac
    {compflags}	compflags	:INT		    /* AnimComp flags for system & user */

    {timer}	timer	:INT

    {timeset}	timeset	:INT

    {nextcomp}	nextcomp	:PTR TO ac
    {prevcomp}	prevcomp	:PTR TO ac

    {nextseq}	nextseq	:PTR TO ac
    {prevseq}	prevseq	:PTR TO ac

    {animcroutine}	animcroutine	:PTR	/*WORD (*AnimCRoutine) __CLIB_PROTOTYPE((struct AnimComp *))*/

    {ytrans}	ytrans	:INT     /* initial y translation (if this is a component) */
    {xtrans}	xtrans	:INT     /* initial x translation (if this is a component) */

    {headob}	headob	:PTR TO ao

    {animbob}	animbob	:PTR TO bob
ENDOBJECT

NATIVE {ao} OBJECT ao
    {nextob}	nextob	:PTR TO ao
	{prevob}	prevob	:PTR TO ao

    {clock}	clock	:VALUE

    {anoldy}	anoldy	:INT
	{anoldx}	anoldx	:INT	    /* old y,x coordinates */

    {any}	any	:INT
	{anx}	anx	:INT		    /* y,x coordinates of the AnimOb */

    {yvel}	yvel	:INT
	{xvel}	xvel	:INT		    /* velocities of this object */
    {yaccel}	yaccel	:INT
	{xaccel}	xaccel	:INT	    /* accelerations of this object */

    {ringytrans}	ringytrans	:INT
	{ringxtrans}	ringxtrans	:INT    /* ring translation values */

    {animoroutine}	animoroutine	:PTR	/*WORD (*AnimORoutine) __CLIB_PROTOTYPE((struct AnimOb *))*/

    {headcomp}	headcomp	:PTR TO ac     /* pointer to first component */

    {auserext}	auserext	:INT /*AUserStuff*/	    /* AnimOb user extension */
ENDOBJECT

NATIVE {dbp} OBJECT dbp
    {bufy}	bufy	:INT
	{bufx}	bufx	:INT		    /* save the other buffers screen coordinates */
    {bufpath}	bufpath	:PTR TO vs	    /* carry the draw path over the gap */

    {bufbuffer}	bufbuffer	:PTR TO INT
	{bufplanes} bufplanes:PTR TO VALUE	->AmigaE "bufplanes" member is missing from C
ENDOBJECT

NATIVE {colltable} OBJECT colltable
    {collptrs}	collptrs[16]	:ARRAY OF PTR	/*LONG (*collPtrs[16]) __CLIB_PROTOTYPE((struct VSprite *,struct VSprite *))*/
ENDOBJECT
