
;---;  graphicslib.r  ;--------------------------------------------------------
*
*	****	GRAPHICS LIBRARY OPEN AND CLOSE    ****
*
*	Author		Stefan Walter
*	Version		1.00
*	Last Revision	31.05.92
*	Identifier	glb_defined
*       Prefix		glb_	(graphics library)
*				 ¯        ¯ ¯
*	Functions	OpenGraphicsLib, GetGraphicsBase, CloseGraphicsLib
*
;------------------------------------------------------------------------------

;------------------
	ifnd	glb_defined
glb_defined	=0

;------------------
glb_oldbase	equ	__base
	base	glb_base
glb_base:

;------------------

;------------------------------------------------------------------------------
*
* OpenGraphicsLib	Open graphics.library once and use a nesting counter.
*
* RESULT:	d0	gfxbase
*		a6	also
*		ccr	on d0
*
;------------------------------------------------------------------------------

;------------------
OpenGraphicsLib:

;------------------
; open only if glb_nestcnt=0
;
\open:
	movem.l	d1-a5,-(sp)
	lea	glb_base(pc),a4
	move.l	glb_nestcnt(pc),d0
	bne.s	\isopen
	move.l	4.w,a6
	lea	glb_name(pc),a1
	jsr	-408(a6)		;OldOpenLibrary()
	move.l	d0,glb_gfxbase(a4)
\isopen:
	addq.l	#1,glb_nestcnt(a4)
	move.l	glb_gfxbase(pc),d0
	move.l	d0,a6
	movem.l	(sp)+,d1-a5
	rts

;------------------

;------------------------------------------------------------------------------
*
* GetGraphicsBase	Get gfxbase in a6.
*
* RESULT:	a6	gfxbase
*
;------------------------------------------------------------------------------

;------------------
GetGraphicsBase:

;------------------
; gfxbase => a6
;
\getbase:
	move.l	glb_gfxbase(pc),a6
	rts

;------------------

;------------------------------------------------------------------------------
*
* CloseGraphicsLib	Close graphics.library if glb_nestcnt gets zero.
*
;------------------------------------------------------------------------------

;------------------
CloseGraphicsLib:

;------------------
; decrease dlb_nestcnt and close library if finished
;
\close:
	movem.l	d0-a6,-(sp)
	lea	glb_nestcnt(pc),a4
	subq.l	#1,(a4)
	bhi.s	\end
	move.l	glb_gfxbase(pc),a1
	move.l	a1,d0
	beq.s	\end
	move.l	4.w,a6
	jsr	-414(a6)		;CloseLibrary()
\end:
	movem.l	(sp)+,d0-a6
	rts

;------------------

;--------------------------------------------------------------------

;------------------
; data for library handling
;
glb_name:	dc.b	"graphics.library",0,0
glb_gfxbase:	dc.l	0
glb_nestcnt:	dc.l	0

;------------------

;--------------------------------------------------------------------

;------------------
	base	glb_oldbase

;------------------
	endif

 end

