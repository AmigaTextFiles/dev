/*
**	$Filename: Example_2.c $
**	$Revision: 1.0 $
**	$Date: 93/04/06 $
**
**	Example to demonstrate DateSelector gadget class library.
**	This example shows how easy to make a DateRequester like
**	window by attaching three BOOPSI gadgets together linked
**	with one ICClass BOOPSI object.
**
**	Copyright (C) 1993 Markus Aalto
**
**	This file is distributed under the GNU General Public License. Please
**	refer to the file COPYING for details.
*/

#include	<exec/types.h>
#include	<intuition/intuition.h>
#include	<intuition/gadgetclass.h>
#include	<intuition/icclass.h>
#include	<libraries/gadtools.h>
#include	<dos/dos.h>
#include	<utility/tagitem.h>
#include	<utility/date.h>

#include	<clib/exec_protos.h>
#include	<clib/intuition_protos.h>
#include	<clib/gadtools_protos.h>
#include	<clib/utility_protos.h>
#include	<clib/graphics_protos.h>
#include	<clib/alib_protos.h>

#include	"BoopsiObjects/DateSelectorGadClass.h"
#include	"stdlib.h"
#include	"stdio.h"

#define		DSG_ID			1
#define		SCROLLERG_ID	2
#define		YEARG_ID		3

struct my_date {
	ULONG Year, Month, Day;
};

struct myiccdata {
	ULONG YearBottomVal;
	ULONG MonthBottomVal;
};

/*	These tags must be different from DSG ones. */
#define	MID_YEARBOTTOM		( DSG_SUNDAYFIRST + 1 )
#define	MID_MONTHBOTTOM		( DSG_SUNDAYFIRST + 2 )
#define	MID_NEWYEAR			( DSG_SUNDAYFIRST + 3 )
#define	MID_NEWMONTH		( DSG_SUNDAYFIRST + 4 )

struct TagItem prop2year[] = {
	{ PGA_TOP,	MID_NEWYEAR },
	{ GA_ID,	TAG_IGNORE },	/*	To prevent DSG gadget changing its GA_ID. */
	{ TAG_END,  NULL }
};

struct TagItem prop2month[] = {
	{ PGA_TOP,	MID_NEWMONTH },
	{ GA_ID,	TAG_IGNORE },	/*	To prevent DSG gadget changing its GA_ID. */
	{ TAG_END,	NULL }
};

struct	GfxBase *GfxBase;
struct	IntuitionBase *IntuitionBase;
struct	Library *GadToolsBase;
struct 	Library *UtilityBase;

UBYTE 	version[] = "\0$VER: DSG_example2 1.0 (6.4.1993)";

VOID 	DoAll( VOID );
VOID	OpenAll( Class *, struct Screen *, struct TextFont * );
VOID 	HandleIDCMP( struct Window *, ULONG );
ULONG 	__saveds myiccDispatcher( Class *cl, Object *o, Msg msg );
VOID 	freemyicclass( Class *myicclass );
Class 	*initmyicclass( VOID );
VOID 	RefreshTexts( struct Window *win, ULONG width, struct my_date *myd );

int main( int argc, char **argv )
{
	if( GfxBase = (struct GfxBase *)OpenLibrary("graphics.library",37L) ) {
		if( IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",37L) ) {
			if( GadToolsBase = OpenLibrary("gadtools.library",37L) ) {
				if( UtilityBase = OpenLibrary("utility.library",37L) ) {

					DoAll();

					CloseLibrary(UtilityBase);
				}
				CloseLibrary(GadToolsBase);
			}
			CloseLibrary((struct Library *)IntuitionBase);
		}
		CloseLibrary((struct Library *)GfxBase);
	}

	return(0);
}

VOID DoAll()
{
	Class *DSGClass;
	struct Screen *myscreen;
	struct DrawInfo *dri;
	struct TextFont *tf;

	if( DSGClass = initDateSelectorGadClass() ) {
		if( myscreen = LockPubScreen(NULL) ) {
			if( dri = GetScreenDrawInfo(myscreen) ) {
				tf = dri->dri_Font;
				FreeScreenDrawInfo(myscreen,dri);

    			OpenAll(DSGClass,myscreen,tf);
			}
			UnlockPubScreen(NULL,myscreen);
		}
		(VOID)freeDateSelectorGadClass( DSGClass );
	}
}

VOID OpenAll( Class *DSGClass, struct Screen *scr, struct TextFont *tf )
{
	ULONG width, height = 0, secs, mics;
	struct Gadget *DSG, *MonthGad, *YearGad;
	struct my_date my_d;
	Object *mic;
	Class *myicclass;
	struct Window *win;
	struct ClockData cd;

	myicclass = initmyicclass();
	if( myicclass == NULL ) return;

	CurrentTime(&secs,&mics);
	Amiga2Date(secs,&cd);
	my_d.Year = cd.year;
	my_d.Month = cd.month;
	my_d.Day = cd.mday;

	width = 7 + 7*(INTERWIDTH + 3*tf->tf_XSize);

	if( DateSelectorGadDimensions(tf, &width, &height, FALSE) ) {
		DSG = (struct Gadget *)NewObject(DSGClass, NULL,
				GA_Top,				(1 + INTERHEIGHT) + 2*tf->tf_YSize + scr->WBorTop,
				GA_Left,			(INTERWIDTH) + scr->WBorLeft,
				GA_ID,				DSG_ID,
				GA_Width,			width,
				GA_Height,			height,
				ICA_TARGET,			ICTARGET_IDCMP,
				DSG_YEAR,			cd.year,
				DSG_MONTH,			cd.month,
				DSG_DAY,			cd.mday,
				DSG_TEXTFONT,		tf,
				DSG_FIXEDPOSITION,	FALSE,
				TAG_END);

		if( DSG) {
			mic = NewObject(myicclass,NULL,
					ICA_TARGET,			DSG,
					MID_YEARBOTTOM,		1978,
					MID_MONTHBOTTOM,	1,
					TAG_END);
			if( mic ) {

				MonthGad = (struct Gadget *)NewObject(NULL,"propgclass",
						GA_Top,			(1 + INTERHEIGHT) + 2*tf->tf_YSize + scr->WBorTop,
						GA_Left,		(3*INTERWIDTH) + scr->WBorLeft + width,
						GA_ID,			SCROLLERG_ID,
						GA_Width,		16,
						GA_Height,		height,
        				ICA_TARGET,		mic,
						ICA_MAP,		prop2month,
						GA_Highlight,	GADGHCOMP,
						GA_Previous,	DSG,
						PGA_Freedom,	FREEVERT,
						PGA_Total,		12,		/* 0-11 */
						PGA_Top,		cd.month - 1,
						PGA_Visible,	1,
						PGA_NewLook,	TRUE,
						TAG_END);

				if( MonthGad ) {
					YearGad = (struct Gadget *)NewObject(NULL,"propgclass",
							GA_Top,			(1 + INTERHEIGHT) + 2*tf->tf_YSize + scr->WBorTop,
							GA_Left,		(16 + 5*INTERWIDTH) + scr->WBorLeft + width,
							GA_ID,			YEARG_ID,
							GA_Width,		16,
							GA_Height,		height,
							ICA_TARGET,		mic,
							ICA_MAP,		prop2year,
							GA_Highlight,	GADGHCOMP,
							GA_Previous,	MonthGad,
							PGA_Freedom,	FREEVERT,
							PGA_Total,		122,		/* 1978-2099 */
							PGA_Top,		cd.year - 1978,
							PGA_Visible,	1,
							PGA_NewLook,	TRUE,
							TAG_END);

					if( YearGad ) {
							win = OpenWindowTags(NULL,
								WA_Left,			20,
								WA_Top,				tf->tf_YSize + scr->WBorTop + 1,
								WA_InnerWidth,		(2*16 + 6*INTERWIDTH)+ width,
								WA_InnerHeight,		(2*INTERHEIGHT) + tf->tf_YSize + height,
								WA_IDCMP,			IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|IDCMP_IDCMPUPDATE,
								WA_Title,			"DSG_Example2",
								WA_PubScreen,		scr,
								WA_DragBar,			TRUE,
								WA_DepthGadget,		TRUE,
								WA_Activate,		TRUE,
								WA_SimpleRefresh,	TRUE,
								WA_AutoAdjust,		TRUE,
								WA_CloseGadget,		TRUE,
								WA_Gadgets,			DSG,
								TAG_END);

						if( win ) {
							win->UserData = (char *)&my_d;
							SetFont(win->RPort,tf);
							RefreshTexts( win, width, &my_d);
							HandleIDCMP( win , width);

							CloseWindow(win);
						}
						DisposeObject(YearGad);
					}
					DisposeObject(MonthGad);
				}
				DisposeObject(mic);
			}
			DisposeObject(DSG);
		}
	}

	freemyicclass( myicclass );
}

Class *initmyicclass()
{
	Class *newicc;
	extern ULONG HookEntry();

	newicc = MakeClass(NULL, "icclass", NULL, sizeof(struct myiccdata), NULL);
	if( newicc ) {
		newicc->cl_Dispatcher.h_Entry = HookEntry;
		newicc->cl_Dispatcher.h_SubEntry = myiccDispatcher;
	}

	return(newicc);
}

VOID freemyicclass( Class *myicclass )
{
	(VOID)FreeClass( myicclass );
}

/*	This is just a simple dispatcher to take care of feeding right
**	values to DS gadget. It could be better, but should do the
**	job for now.
*/
ULONG __saveds myiccDispatcher( Class *cl, Object *o, Msg msg )
{
	struct myiccdata *mid;
	APTR retval;

	switch( msg->MethodID ) {
		case OM_NEW:
			if( retval = (APTR)DoSuperMethodA(cl,o,(Msg *)msg) ) {
				mid = INST_DATA(cl,retval);
				mid->YearBottomVal = GetTagData(MID_YEARBOTTOM,0,((struct opSet *)msg)->ops_AttrList);
				mid->MonthBottomVal = GetTagData(MID_MONTHBOTTOM,0,((struct opSet *)msg)->ops_AttrList);
			}
			break;
		case OM_SET:
			mid = INST_DATA(cl,o);
			retval = (APTR)DoSuperMethodA(cl,o,(Msg *)msg);
			mid->YearBottomVal = GetTagData(MID_YEARBOTTOM,mid->YearBottomVal,((struct opSet *)msg)->ops_AttrList);
			mid->MonthBottomVal = GetTagData(MID_MONTHBOTTOM,mid->MonthBottomVal,((struct opSet *)msg)->ops_AttrList);
			break;
		case OM_NOTIFY:
		case OM_UPDATE:
			mid = INST_DATA(cl,o);
			DoSuperMethodA(cl,o,(Msg *)msg);
			{
				struct TagItem *tag, tags[2], *taglist = ((struct opSet *)msg)->ops_AttrList;

				tag = FindTagItem(MID_NEWYEAR,taglist);
				if( tag ) {
					tags[0].ti_Tag = DSG_YEAR;
					tags[0].ti_Data = mid->YearBottomVal + tag->ti_Data;
					tags[1].ti_Tag = TAG_DONE;
					DoSuperMethod(cl,o,OM_NOTIFY, tags, ((struct opUpdate *)msg)->opu_GInfo,
							((struct opUpdate *)msg)->opu_Flags);
				}

				tag = FindTagItem(MID_NEWMONTH, taglist );
				if( tag ) {
					tags[0].ti_Tag = DSG_MONTH;
					tags[0].ti_Data = mid->MonthBottomVal + tag->ti_Data;
					tags[1].ti_Tag = TAG_DONE;
					DoSuperMethod(cl,o,OM_NOTIFY, tags, ((struct opUpdate *)msg)->opu_GInfo,
							((struct opUpdate *)msg)->opu_Flags);
				}
			}
			break;
		default:
			retval = (APTR)DoSuperMethodA(cl,o,(Msg *)msg);
			break;
	}

	return( (ULONG)retval);
}

VOID HandleIDCMP( struct Window *win, ULONG width )
{
	ULONG mask, signal;
	BOOL Ready = FALSE;
	struct IntuiMessage *imsg;
	struct my_date *myd;

	myd = (struct my_date *)win->UserData;
    mask = (1L << win->UserPort->mp_SigBit)|SIGBREAKF_CTRL_C;

	while(!Ready) {
		signal = Wait(mask);
		if( signal & SIGBREAKF_CTRL_C ) {
			Ready = TRUE;
		}

		while( (!Ready) && (imsg = (struct IntuiMessage *)GetMsg(win->UserPort)) ) {
		 	switch( imsg->Class )
		 	{
		 		case IDCMP_REFRESHWINDOW:
		 			BeginRefresh(win);
					RefreshTexts(win,width,myd);
		 			EndRefresh(win,TRUE);
		 			break;
				case IDCMP_CLOSEWINDOW:
					Ready = TRUE;
					break;
				case IDCMP_IDCMPUPDATE:
					if( GetTagData(GA_ID,0,imsg->IAddress) == DSG_ID ) {
						myd->Year = GetTagData(DSG_YEAR,myd->Year,imsg->IAddress);
						myd->Month = GetTagData(DSG_MONTH,myd->Month,imsg->IAddress);
						myd->Day = GetTagData(DSG_DAY,myd->Day,imsg->IAddress);

						RefreshTexts( win, width, myd );
					}
					break;
		 	}
		 	ReplyMsg((struct Message *)imsg);
		}
	}
}

VOID RefreshTexts( struct Window *win, ULONG width , struct my_date *myd)
{
	ULONG len, button_width, ypos, xpos, i;
	struct RastPort *rp = win->RPort;
	struct TextFont *tf = rp->Font;
	static char *day_names[] = {
		"Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
	};
    static char date[11];

	button_width = width / 7;
	ypos = INTERHEIGHT + win->BorderTop + tf->tf_Baseline;
	xpos = INTERWIDTH + win->BorderLeft;

	SetAPen(rp,1);
	SetDrMd(rp,JAM1);

	for(i=0; i < 7; i++ ) {
		len = TextLength(rp,day_names[i],3);
		Move(rp,xpos + (button_width-len)/2, ypos);
		Text(rp,day_names[i],3);
		xpos += button_width;
	}

	sprintf(date,"%02ld-%02ld-%04ld",myd->Day,myd->Month,myd->Year);
	SetWindowTitles(win,date, (UBYTE *)~0);
}

