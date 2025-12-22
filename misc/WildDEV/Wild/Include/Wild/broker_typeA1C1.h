#ifndef	WILD_BROKERTYPE_A1C1
#define	WILD_BROKERTYPE_A1C1

/*type 1 of broker.
; this type only: sorts the points (from high to low) and calcs
; the x steps, and cuts top and bottom the polygons.
; my conventions:
; the polygon is split in two parts, the hi (high) and the lo (low)
; the sx edge is a, the dx edge is b (Xa<Xb,always)

; 
;       .HiPoint				
;  	*
;	**	
;     a ***	
;	**** b  hi part (until MidP)
;MidP. .***** 	-----
;	  ****	lo part (after MidP)
;	  a ***
;	       *.LowPoint

; the polygon may have only one part: is always the hi part !
; may seem obvious, but see:

; *****         *	both these have only the hi part, not one the hi and the other the lo.
;  ***         ***
;   *         ***** 

; example to understand EXACTLY about DEY.
;
;	*****		ycnt=0	hiDEY=1 (after 2, you have to CHANGE STEPS, so =1, NOT 2 !!)
;	**********	ycnt=1	loDEY=2 (after 3, stop drawing, so 2!)
;	*******		ycnt=2
;	****		ycnt=3
;	*		ycnt=4
; That may seem stupid, but it's IMPORTANT TO AVOID DIFFERENT Draws, and eliminate
; bad LAMER gaps inter-polygons. If the broker says hiDEY=1, ALL MUST Draw only 2
; and then change, not a Draw do 1, a Draw do 2, and so.

; talking about code:
; that is a good draw cycle:	

;		move.w	loDEY,d0
;		move.l	loSXb,-(a7)
;		move.l	loSXa,-(a7)
;		move.l	hiSXa,d1
;		move.l	hiSXb,d2
;		move.l	hiXa,d3
;		move.l	hiXb,d4
;		move.w	hiDEY,d5

; NB: NO subq.w	#1,d5 and subq.w #1,d0 at first: DEYs are already ok for dbra !

;		bra.b	.drawpoly
; .drawpoly2	clr.w	d0		; to avoid infinite re-cycle low part.
;		move.l	(a7)+,d1
;		move.l	(a7)+,d2
; .drawpoly	add.l	d1,d3	(do FIRST, not LAST! Or the first line would be a NULL line!)
;		add.l	d2,d4	

;	here draw this line

;		dbra	d5,.drawpoly
;		move	d0,d5
;		bne.b	.drawpoly2	; just an example of how to change dey..
;

; NB: that's just an example, obviously you should use better the registers, and more...
*/

struct	BrokerData
{
 WORD	tbs_topY;		/* ok */
 LONG	tbs_hiXa;		/* =0 bad*/
 LONG	tbs_hiXb;		/* =0 bad*/
 WORD	tbs_hiDEY;		/* =0 bad*/
 LONG	tbs_hiSXa;		/* ok */
 LONG	tbs_hiSXb;		/* ok */
 WORD	tbs_loDEY;		/* =0 bad */
 LONG	tbs_loSXa;		/* !0 bad */
 LONG	tbs_loSXb;		/* !0 bad */
 WORD	tbs_Stop; 		/* ??? */
};

/*
		STRUCTURE	BrokerData1,t1bs_Broker
			WORD	t1bs_topY
			LONG	t1bs_hiXa
			LONG	t1bs_hiXb		; 16.16 math 
			WORD	t1bs_hiDEY		; how many rows for hi part ?
			LONG	t1bs_hiSXa
			LONG	t1bs_hiSXb		; 16.16 math
			WORD	t1bs_loDEY
			LONG	t1bs_loSXa
			LONG	t1bs_loSXb		; only steps: you have the X !
			WORD	t1bs_Stop		; contains 0.
			LABEL	t1bs_morethan1

		STRUCTURE	BrokerDataEdge1,t1ed_Broker
			APTR	t1ed_HighPoint		; NB: this POINT TO THE TEMP STRUCT, NOT TO THE REAL POINT STRUCT!
			APTR	t1ed_LowPoint
			WORD	t1ed_topCUT
			WORD	t1ed_bottomCUT
			WORD	t1ed_topY
			WORD	t1ed_DEY
			LONG	t1ed_X
			LONG	t1ed_SX
			LABEL	t1ed_morethan1

; Note that this base struct will be the same also for more types, adding Shading & TXMap.

	ENDC
*/	

#endif
