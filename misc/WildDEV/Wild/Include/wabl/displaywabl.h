#ifndef	WABL_DISPLAY_H
#define WABL_DISPLAY_H
/*
** Display includes for WABL
*/

struct WABLDIVek
{ 
 LONG 	vx;
 LONG 	vy;
 LONG 	vz;
};

struct WABLDIPoint
{
 struct MinNode		pnt_node;
 ULONG			pnt_WDID;
 struct	WABLDIVek	pnt_pos;
 struct WABLDIVek	pnt_view;
 UWORD			pnt_id;
 ULONG			*pnt_original;
};

struct WABLDIEdge
{
 struct	MinNode		edg_node;
 ULONG			edg_WDID;
 struct WABLDIPoint	*edg_pa;
 struct WABLDIPoint	*edg_pb;
 UWORD			edg_id;
 ULONG			*edg_original;
};

struct WABLDITXPos
{
 ULONG	tx;
 ULONG	ty;
};

struct WABLDIFace
{
 struct MinNode		fac_node;
 ULONG			fac_WDID;
 struct WABLDIFace	*fac_plus;
 struct WABLDIFace	*fac_minus;
 struct WABLDIPoint	*fac_pa;
 struct WABLDIPoint	*fac_pb;
 struct WABLDIPoint	*fac_pc;
 struct WABLDIEdge	*fac_ea;
 struct WABLDIEdge	*fac_eb;
 struct WABLDIEdge	*fac_ec;
 ULONG			fac_flags;
 struct WABLDITXPos	fac_ta;
 struct WABLDITXPos	fac_tb;
 struct WABLDITXPos	fac_tc;
 UWORD			fac_id;
 ULONG			*fac_original;
};

struct WABLDisplay
{
 struct MinList *wdi_Aliens;
 struct MinList	wdi_FacesPK;
 struct MinList	wdi_EdgesPK;
 struct MinList	wdi_PointsPK;
 
};

#define	WABLDIID	0x57494944		// WIID

#endif