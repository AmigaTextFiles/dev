#ifndef GADGET_H
#define GADGET_H TRUE
/*
**	gadget.h, v 37.5
**	08.09.92 - 29.11.92
**
**	(c) copyright 1992 Steffen Gutmann
** 	all rights reserved
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif

#ifndef INTUITION_IMAGECLASS_H
#include <intuition/imageclass.h>
#endif

#define GAD_BEVELBOX_KIND 	0L
#define GAD_TEXT_KIND		1L
#define GAD_NUMBER_KIND   	2L		/* not yet supported */
#define GAD_BOOL_KIND 		3L
#define GAD_BUTTON_KIND		4L
#define GAD_ARROW_KIND   	5L
#define GAD_GETFILE_KIND  	6L
#define GAD_CHECKBOX_KIND 	7L
#define GAD_RADIOBUTTON_KIND 8L
#define GAD_MX_KIND       	9L
#define GAD_CYCLE_KIND    	10L
#define GAD_STRING_KIND   	11L
#define GAD_INTEGER_KIND  	12L
#define GAD_SCROLLER_KIND 	13L
#define GAD_SLIDER_KIND   	14L	/* not yet supported */
#define GAD_LISTVIEW_KIND 	15L
#define GAD_PALETTE_KIND  	16L

#define gad_TagBase	TAG_USER + 0x80000L

#define GAD_CallBack	(gad_TagBase+1)   /* void (*function)(struct Gadget *,
                                       struct Window *, struct Requester *,
                                       APTR special, ULONG class)
                                       Parameters are put on the stack,
													don't worry about Register a4,
													this package never uses a4 */
#define GAD_ShortCut 	GA_ID				/* (UBYTE) */

/* arrow gadgets: */

#define GADAR_Which 	SYSIA_Which		/* LEFTIMAGE | RIGHTIMAGE | UPIMAGE |
													DOWNIMAGE */

/* bevelboxes: */

#define GADBB_Recessed	IA_Recessed		/* (BOOL) */

/* string/integer gadgets: */

#define GADSTR_Justification	STRINGA_Justification	/* GACT_STRINGCENTER |
																			GACT_STRINGLEFT |
																			GACT_STRINGRIGHT */
#define GADSTR_LongVal	STRINGA_LongVal		/* (LONG)	*/
#define GADSTR_TextVal	STRINGA_TextVal		/* (BYTE *)	*/
#define GADSTR_BufferPos	STRINGA_BufferPos	/* (SHORT) 	*/
#define GADSTR_DispPos	STRINGA_DispPos		/* (SHORT	*/
#define GADSTR_MaxChars	STRINGA_MaxChars		/* (SHORT) 	*/
#define GADSTR_Min 	(gad_TagBase+2)			/* (LONG) 	*/
#define GADSTR_Max 	(gad_TagBase+3)			/* (LONG) 	*/
#define GADSTR_EndGadget (gad_TagBase+4)		/* (BOOL) 	*/
#define GADSTR_DispCount (gad_TagBase+22)  	/* (SHORT) 	*/

/* CycleGadgets: */

#define GADCYC_Labels	(gad_TagBase+11)	/* (BYTE **) NULL-terminated */
#define GADCYC_Active 	(gad_TagBase+12)	/* (USHORT) */

/* Scroller-Gadget: */

#define GADSC_Freedom	PGA_FREEDOM			/* FREEVERT | FREEHORIZ */
#define GADSC_NewLook	PGA_NewLook			/* (BOOL)	*/
#define GADSC_Total	PGA_Total				/* (USHORT) */
#define GADSC_Visible	PGA_Visible			/* (USHORT) */
#define GADSC_Top	PGA_Top						/* (USHORT) */
#define GADSC_Jump	(gad_TagBase+13)		/* (USHORT) */

/* ListviewGadget: */

#define GADLV_Top  	(gad_TagBase+5)	   /* (USHORT) */
#define GADLV_Labels 	(gad_TagBase+6)	/* (struct List *) */
#define GADLV_ReadOnly	(gad_TagBase+7)	/* (BOOL) not yet supported */
#define GADLV_ShowSelected	(gad_TagBase+8)/* (struct Gadget *) */
#define GADLV_Selected	(gad_TagBase+9)	/* (USHORT) */

/* MXGadget: */

#define GADMX_Labels		(gad_TagBase+20)	/* (BYTE **) NULL-terminated */
#define GADMX_Active		(gad_TagBase+21)	/* (USHORT) */

/* PaletteGadget: */

#define GADPA_Depth		(gad_TagBase+14)		/* (USHORT) */
#define GADPA_Color		(gad_TagBase+15)     /* (USHORT) */
#define GADPA_ColorOffset	(gad_TagBase+16)	/* (USHORT) */
#define GADPA_IndicatorWidth (gad_TagBase+17)/* (USHORT) */

/*
	reserved tags:

	(gad_TagBase+10)  new tag for unsupported viewport gadget (-> X11 Athena)
	(gad_TagBase+18)  was GADPA_IndicatorHeight
	(gad_TagBase+19)	internal tag
*/

#define GAD_IDCMPFlags (IDCMP_MOUSEMOVE | IDCMP_GADGETDOWN | \
								IDCMP_GADGETUP | IDCMP_RAWKEY | IDCMP_INTUITICKS | \
								IDCMP_ACTIVEWINDOW | IDCMP_MOUSEBUTTONS)

struct gadCycleInfo
{
	USHORT active;
	BYTE **labels;
};

struct gadListviewInfo
{
   USHORT total;
	USHORT visible;
	USHORT top;
	USHORT selected;
	struct List *list;
};

struct gadMXInfo
{
	USHORT active;
};

struct gadPaletteInfo
{
	USHORT color;
	USHORT coloroffset;
	USHORT depth;
};

struct gadScrollerInfo
{
	USHORT total;
	USHORT visible;
	USHORT top;
};

#define gadSetSelectedFlag(g, w, r, cond) gadSetGadgetAttrs(g, w, r, GA_Selected, (LONG)(cond), TAG_DONE)
#define gadSetDisabledFlag(g, w, r, cond) gadSetGadgetAttrs(g, w, r, GA_Disabled, (LONG)(cond), TAG_DONE)

struct IntuiText *gadAllocIntuiText(SHORT fp, SHORT bp, SHORT dm, SHORT x, SHORT y, struct TextAttr *ta, BYTE *text, struct IntuiText *ni);
void gadFreeIntuiText(struct IntuiText *it);
struct Gadget *gadAllocGadget(ULONG kind, ULONG tag1, ...);
struct Gadget *gadAllocGadgetA(ULONG kind, struct TagItem *tagList);
ULONG gadSetGadgetAttrs(struct Gadget *gad, struct Window *w, struct Requester *req, ULONG tag1, ...);
ULONG gadSetGadgetAttrsA(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList);
ULONG gadGetGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage);
void gadFreeGadget(struct Gadget *gad);
void gadFreeGadgetList(struct Gadget *first);
BOOL gadFilterMessage(struct IntuiMessage *message, ULONG amigakeys);

#endif
