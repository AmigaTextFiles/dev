#ifndef		WILDBROKERTYPE5
#define		WILDBROKERTYPE5

#include	<wild/tdcore_typeA1.h>

/*
; type 5 of broker.
; this type : sorts the points (from high to low) and calcs
; the x steps, and cuts top and bottom the polygons.
; then calcs i startings and steps
; then resorts the txy a,b,c and calcs tx/ty startingt/steppings.

; IMPORTANT: SEE broker_typeA1C1.i to see my Y,DEY and more conventions!!
*/

struct	BrokerData
{
 UWORD			tbs_topY;
 UWORD			tbs_hiDEY;		/* how many rows for hi part ? */
 UWORD			tbs_hiIa;		/* 8.8 math */
 UWORD			tbs_hiSIa;		/* 8.8 math */
 UWORD			tbs_hiTXa;
 UWORD			tbs_hiTYa;
 WORD			tbs_hiSTXa;
 WORD			tbs_hiSTYa;
 LONG			tbs_hiXa;
 LONG			tbs_hiXb;		/* 16.16 math */
 LONG			tbs_hiSXa;
 LONG			tbs_hiSXb;		/* 16.16 math */
 struct EdgeTmp		*tbs_TopSxEdge;		/* for my use: POINTS TO TMP OF THE Highest SX EDGE */
 struct EdgeTmp		*tbs_TopDxEdge;		/* same of topsx! */
 struct EdgeTmp		*tbs_BotSxEdge;		/* same of topsx! */
 UWORD			tbs_loDEY;
 WORD			tbs_loSIa;
 WORD			tbs_loSTXa;
 WORD			tbs_loSTYa;
 LONG			tbs_loSXa;
 LONG			tbs_loSXb;		/* only steps: you have the X ! */
 WORD			tbs_HSI;		/* Horizontal Step of I (see note) */
 WORD			tbs_HSTX;		/* same TX */
 WORD			tbs_HSTY;		/* same TY */
};

/*
; NB: that struct is a bit unsorted: because of a my optim with movem !
;     Sorting is quite useless, also the Stop containing 0 is cutted.
;     It was used by me for a optim in a loop, but it's very useless,
;     i saw. I keep it on type 1 because i'm lazy.
; HSx note: That's the horizontal step of x.
; It's always the same during the y descending, because the interpolation of shading is linear.
; NOTE!! There is NO MORE BotDX EDGE !!! WAS USELESS !!!! Kept in type 2, i'm lazy.
*/

struct	BrokerDataEdge
{
 struct PointTmp	*ted_HighPoint;		/* NB: this POINT TO THE TEMP STRUCT, NOT TO THE REAL POINT STRUCT!*/
 struct PointTmp	*ted_LowPoint;
 WORD			ted_topCUT;
 WORD			ted_bottomCUT;
 WORD			ted_topY;
 WORD			ted_DEY;
 LONG			ted_X;
 LONG			ted_SX;
 WORD			ted_I;		
 WORD			ted_SI;
 WORD			ted_DEYT;		/* total dey, C added! not in the ASM modules ! */
};

#endif

