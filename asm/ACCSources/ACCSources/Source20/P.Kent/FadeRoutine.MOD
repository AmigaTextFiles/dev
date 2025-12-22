**********************************************************************

* FadeRoutine:

*	Call by 'BSR FADE' once each frame, until result from d0 = '0'

*	On entry:	d0 : Number of colours to fade
*			d1 : Speed Of Fading
*			d2 : '0' = Fade colours out, '1' = Fade colours in
*			a0 : Start address of colours (in copperlist)
*			a1 : Pointer to colours to fade in or blank table
*			     for old colour values

*	On exit:	d0 : '0' = All fading finished, '1' = Fading not 
*			     yet finished

Fade	cmpi.b	#1,FadeStarted		Was fade started earlier?
	bne.s	PrepFade		No? Then initialise certain things

DoFade	cmp.l	#0,FadeSpeed		Do we want a slow fade?
	beq.s	.Cont			Fade this time round
	subq.l	#1,FadeSpeed		Decrement delay
	moveq.l	#1,d0			Fade not yet finished
	rts

.Cont	move.l	FadeSpeed2,FadeSpeed	Restore fade delay
	cmp.b	#0,FadeInOut		Want to fade screen out?
	beq.s	InitFadeOut		Fade screen out then
	bra	InitFadeIn		Otherwise fade screen in

**********

FadeCompleted
	cmpi.b	#1,FadeDone		Were any colours faded?
	bne.s	.Yes			Yes they were!
	moveq.l	#0,d0			All fading done!
	move.b	#0,FadeStarted		Ready for next time!
	bra.s	.Cont			Skip next two lines
.Yes	moveq.l	#1,d0			Fading not yet finished

.Cont	rts				Need I say more?

**********

PrepFade
	move.b	#1,FadeStarted		So we know we've init'ed stuff
	move.l	d0,NoCols		Store number of colours
	move.l	d1,FadeSpeed		Store speed of fade
	move.l	d1,FadeSpeed2		Store speed of fade
	move.b	d2,FadeInOut		Store type of fade
	move.l	a0,ColStore		Store location of colours
	move.l	a1,ColTable		Store location of colour table

	cmpi.l	#0,d2			Want to fade screen out?
	bne.s	DoFade			Get ready to fade

**********	This stores the original colour values in a table

PrepFadeOut
	addq.l	#2,a0			Make a0 point to actual colours
	subq.l	#1,d0			Correct d0 for dbra loop
.Loop	move.w	(a0),(a1)+		Copy colours into a table
	addq.l	#4,a0			Point a0 to next colour
	dbra	d0,.Loop		Do all colours
	bra	DoFade			Get ready to fade

InitFadeOut
	move.l	ColStore,a0		Address of colours (in CopList)
	move.l	NoCols,d2		Number of colours to fade
	subq.l	#1,d2			Correct d2 for dbra loop
	move.b	#1,FadeDone		To test if the fade has finished

DoFadeOut
	moveq.l	#0,d0			Clear d0
	move.w	2(a0),d0		Get actual colour

**********	Fade blue component out:

	move.l	d0,d1			Store colour in d1
	andi.w	#$000f,d0		Mask all but blue component
	cmpi.w	#0,d0			Is blue '0'?
	bne.s	.Cont			No
	move.l	d1,d0			Restore original colour
	bra.s	.Cont1			Skip 'Fade Blue' section

.Cont	subi.b	#1,d0			Subtract 1 from blue component
	move.b	#0,FadeDone		Colour fading not yet finished
	andi.w	#$fff0,d1		Kill original blue component
	or.w	d1,d0			Insert new blue colour

**********	Fade green component out:

.Cont1	move.l	d0,d1			Store colour in d1
	andi.w	#$00f0,d0		Mask all but green component
	ror.w	#4,d0			Rotate to get green into LSB
	cmpi.w	#0,d0			Is green '0'?
	bne.s	.Cont2			No
	move.l	d1,d0			Restore original colour
	bra.s	.Cont3			Skip 'Fade Green' section

.Cont2	subi.b	#1,d0			Subtract 1 from green component
	move.b	#0,FadeDone		Colour fading not yet finished
	andi.w	#$ff0f,d1		Kill original green component
	rol.w	#4,d0			Restore green's correct position
	or.w	d1,d0			Insert new green colour

**********	Fade red component out:

.Cont3	move.l	d0,d1			Store colour in d1
	andi.w	#$0f00,d0		Mask all but red component
	ror.w	#8,d0			Rotate to get red into LSB
	cmpi.w	#0,d0			Is red '0'?
	bne.s	.Cont4			No
	move.l	d1,d0			Restore original colour
	bra.s	.Cont5			Skip 'Fade Red' section

.Cont4	subi.b	#1,d0			Subtract 1 from red component
	move.b	#0,FadeDone		Colour fading not yet finished
	andi.w	#$f0ff,d1		Kill original red component
	rol.w	#8,d0			Restore red's correct position
	or.w	d1,d0			Insert new red colour

**********	D0 now contains correct (faded) colour

.Cont5	move.w	d0,2(a0)		Insert new colour in CopList
	addq.l	#4,a0			Point a0 to next colour
	dbra	d2,DoFadeOut		Next colour, please!

AllDone	bra	FadeCompleted		That's all for now!

**********	Fade new colours in

InitFadeIn
	movem.l	d3-d4,-(sp)		Better save d3/d4!
	move.l	ColStore,a0		Address of colours (in CopList)
	move.l	ColTable,a1		Address of colours (in table)
	move.l	NoCols,d2		Number of colours to fade
	subq.l	#1,d2			Correct d2 for dbra loop
	move.b	#1,FadeDone		To test if the fade has finished

DoFadeIn
	moveq.l	#0,d0			Clear d0
	move.l	d0,d3			Clear d3
	move.w	2(a0),d0		Get actual colour
	move.w	(a1)+,d3		Get required colour

**********	Fade blue component in:

	move.l	d0,d1			Store colour in d1
	move.l	d3,d4			Store colour in d4
	andi.w	#$000f,d0		Mask all but blue component
	andi.w	#$000f,d3		Mask all but blue component
	cmp.w	d3,d0			Is blue correct?
	bne.s	.Cont			No
	move.l	d1,d0			Restore original colour
	move.l	d4,d3			Restore original colour
	bra.s	.Cont1			Skip 'Fade Blue' section

.Cont	addq.b	#1,d0			Add 1 to blue component
	move.b	#0,FadeDone		Colour fading not yet finished
	andi.w	#$fff0,d1		Kill original blue component
	or.w	d1,d0			Insert new blue colour
	move.l	d4,d3			Restore original colour

**********	Fade green component in:

.Cont1	move.l	d0,d1			Store colour in d1
	move.l	d3,d4			Store colour in d4
	andi.w	#$00f0,d0		Mask all but green component
	andi.w	#$00f0,d3		Mask all but green component
	cmp.w	d3,d0			Is green correct?
	bne.s	.Cont2			No
	move.l	d1,d0			Restore original colour
	move.l	d4,d3			Restore original colour
	bra.s	.Cont3			Skip 'Fade Green' section

.Cont2	ror.w	#4,d0			Move green into LSB
	addq.b	#1,d0			Add 1 to green component
	rol.w	#4,d0			Correct green's position
	move.b	#0,FadeDone		Colour fading not yet finished
	andi.w	#$ff0f,d1		Kill original green component
	or.w	d1,d0			Insert new green colour
	move.l	d4,d3			Restore original colour

**********	Fade red component in:

.Cont3	move.l	d0,d1			Store colour in d1
	move.l	d3,d4			Store colour in d4
	andi.w	#$0f00,d0		Mask all but red component
	andi.w	#$0f00,d3		Mask all but red component
	cmp.w	d3,d0			Is red correct?
	bne.s	.Cont4			No
	move.l	d1,d0			Restore original colour
	move.l	d4,d3			Restore original colour
	bra.s	.Cont5			Skip 'Fade Red' section

.Cont4	ror.w	#8,d0			Move red into LSB
	addq.b	#1,d0			Add 1 to red component
	rol.w	#8,d0			Correct red's position
	move.b	#0,FadeDone		Colour fading not yet finished
	andi.w	#$f0ff,d1		Kill original red component
	or.w	d1,d0			Insert new red colour
	move.l	d4,d3			Restore original colour


**********	D0 now contains correct (faded) colour

.Cont5	move.w	d0,2(a0)		Insert new colour in CopList
	addq.l	#4,a0			Point a0 to next colour
	dbra	d2,DoFadeIn		Next colour, please!

AllDone2
	movem.l	(sp)+,d3-d4		Better save d3/d4!
	bra	FadeCompleted		That's all for now!

**********	ColourFade Variables:

NoCols		dc.l	0
FadeSpeed	dc.l	0
FadeSpeed2	dc.l	0
ColStore	dc.l	0
ColTable	dc.l	0
FadeInOut	dc.b	0
FadeStarted	dc.b	0
FadeDone	dc.b	0
		even

**********************************************************************
