/*
**	$Filename: Example_1.c $
**	$Revision: 1.0 $
**	$Date: 93/04/36 $
**
**	Example to demonstrate DateSelector gadget class library.
**	This example shows all the three different button layout
**	methods available. They are DSG_FIXEDPOSITION enabled,
**	DSG_FIXEDPOSITION disabled and DSG_SUNDAYFIRST enabled.
**
**	Copyright (C) 1993 Markus Aalto
**
**	This file is distributed under the GNU General Public License. Please
**	refer to the file COPYING for details.
*/

#include	"exec/types.h"
#include	"intuition/intuition.h"
#include	"intuition/gadgetclass.h"
#include	"intuition/icclass.h"
#include	"libraries/gadtools.h"
#include	"dos/dos.h"
#include	"utility/tagitem.h"
#include	"utility/date.h"

#include	"clib/exec_protos.h"
#include	"clib/intuition_protos.h"
#include	"clib/gadtools_protos.h"
#include	"clib/utility_protos.h"
#include	"clib/graphics_protos.h"

#include	"BoopsiObjects/DateSelectorGadClass.h"
#include	"stdlib.h"

#define		OK_GADG_ID	1
#define		DSG_ID		2

struct	GfxBase *GfxBase;
struct	IntuitionBase *IntuitionBase;
struct	Library *GadToolsBase;
struct 	Library *UtilityBase;

UBYTE 	version[] = "\0$VER: DSG_example1 1.0 (6.4.1993)";

VOID 	DoAll( VOID );
VOID	OpenAll( Class *, struct Screen *, struct TextFont * );
UWORD 	HandleIDCMP( struct Window *, struct Gadget *);

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
	ULONG width = 0, height = 0, secs, mics;
	struct Gadget *DSG;
	struct Window *win;
	struct ClockData cd;
	struct Gadget *glist = NULL, *gad;
	struct NewGadget ng;
	APTR vi;

	CurrentTime(&secs,&mics);
	Amiga2Date(secs,&cd);

	/*	We get minimum dimension gadget size for this font, if DSG
	**	isn't DSG_FIXEDPOSITION.
	*/
	if( DateSelectorGadDimensions(tf, &width, &height, FALSE) == FALSE ) return;

	win = OpenWindowTags(NULL,
			WA_Left,			20,
			WA_Top,				tf->tf_YSize + scr->WBorTop + 1,
			WA_InnerWidth,		(2*INTERWIDTH)+ width,
			WA_InnerHeight,		(4*INTERHEIGHT)+ tf->tf_YSize + height,
			WA_IDCMP,			IDCMP_IDCMPUPDATE|BUTTONIDCMP|IDCMP_REFRESHWINDOW,
			WA_Title,			"DSG_Example1",
			WA_PubScreen,		scr,
			WA_DragBar,			TRUE,
			WA_DepthGadget,		TRUE,
			WA_Activate,		TRUE,
			WA_SimpleRefresh,	TRUE,
			WA_AutoAdjust,		TRUE,
			TAG_END);

	if(win) {
		if( vi = GetVisualInfoA(scr,NULL) ) {

			ng.ng_Width = INTERWIDTH + TextLength(win->RPort,"Okey",4);
			ng.ng_LeftEdge = (win->Width - ng.ng_Width )/2;
			ng.ng_TopEdge = win->Height - ((2*INTERHEIGHT) + win->BorderBottom + tf->tf_YSize);
			ng.ng_Height = INTERHEIGHT + tf->tf_YSize;
			ng.ng_GadgetText = "Okey";
			ng.ng_TextAttr = scr->Font;
			ng.ng_GadgetID = OK_GADG_ID;
			ng.ng_Flags = PLACETEXT_IN;
			ng.ng_VisualInfo = vi;

			gad = CreateContext(&glist);

			gad = CreateGadget(BUTTON_KIND, gad, &ng, TAG_END );

			if( gad ) {
                (VOID)AddGList(win,gad, -1, -1, NULL);
                RefreshGList(gad,win,NULL,-1);
                GT_RefreshWindow(win,NULL);

				DSG = NewObject( DSGClass, NULL,
						GA_Top,				INTERHEIGHT + win->BorderTop,
						GA_Left,			INTERWIDTH + win->BorderLeft,
						GA_Width,			width,
						GA_Height,			height,
						GA_ID,				DSG_ID,
						ICA_TARGET,			ICTARGET_IDCMP,
						DSG_YEAR,			cd.year,
						DSG_MONTH,			cd.month,
						DSG_DAY,			cd.mday,
						DSG_TEXTFONT,		tf,
						TAG_END);

				if( DSG ) {
					cd.mday = HandleIDCMP(win,DSG);
					DisposeObject(DSG);

					DSG = NewObject( DSGClass, NULL,
							GA_Top,				INTERHEIGHT + win->BorderTop,
							GA_Left,			INTERWIDTH + win->BorderLeft,
							GA_Width,			width,
							GA_Height,			height,
							GA_ID,				DSG_ID,
							ICA_TARGET,			ICTARGET_IDCMP,
							DSG_YEAR,			cd.year,
							DSG_MONTH,			cd.month,
							DSG_DAY,			cd.mday,
							DSG_TEXTFONT,		tf,
							DSG_FIXEDPOSITION,	FALSE,
							TAG_END);

					if( DSG ) {
						cd.mday = HandleIDCMP(win,DSG);
						DisposeObject(DSG);

						DSG = NewObject( DSGClass, NULL,
								GA_Top,				INTERHEIGHT + win->BorderTop,
								GA_Left,			INTERWIDTH + win->BorderLeft,
								GA_Width,			width,
								GA_Height,			height,
								GA_ID,				DSG_ID,
								ICA_TARGET,			ICTARGET_IDCMP,
								DSG_YEAR,			cd.year,
								DSG_MONTH,			cd.month,
								DSG_DAY,			cd.mday,
								DSG_TEXTFONT,		tf,
								DSG_FIXEDPOSITION,	FALSE,
								DSG_SUNDAYFIRST,	TRUE,
								TAG_END);

						if( DSG ) {
							cd.mday = HandleIDCMP(win,DSG);
							DisposeObject(DSG);
						}
					}
				}
                RemoveGList(win,gad,-1);
			}
			FreeGadgets(glist);
			FreeVisualInfo(vi);
		}

    	CloseWindow(win);
	}
}

UWORD HandleIDCMP( struct Window *win, struct Gadget *DSG)
{
	ULONG mask, signal;
	BOOL Ready = FALSE;
	struct IntuiMessage *imsg;
	ULONG mday;

   	(VOID)AddGList(win,DSG, -1, -1, NULL);
	RefreshGList(DSG,win,NULL,-1);

    mask = (1L << win->UserPort->mp_SigBit)|SIGBREAKF_CTRL_C;

	GetAttr(DSG_DAY, (APTR)DSG, &mday);

	while(!Ready) {
		signal = Wait(mask);
		if( signal & SIGBREAKF_CTRL_C ) {
			Ready = TRUE;
		}

		while( (!Ready) && (imsg = GT_GetIMsg(win->UserPort)) ) {
		 	switch( imsg->Class )
		 	{
		 		case IDCMP_GADGETUP:
		 			if( ((struct Gadget *)(imsg->IAddress))->GadgetID == OK_GADG_ID ) {
		 				Ready = TRUE;
					}
		 			break;
		 		case IDCMP_REFRESHWINDOW:
		 			GT_BeginRefresh(win);
		 			GT_EndRefresh(win,TRUE);
		 			break;
				case IDCMP_IDCMPUPDATE:
					switch( GetTagData(GA_ID, 0, imsg->IAddress ) )
					{
						case DSG_ID:
							mday = GetTagData(DSG_DAY,mday,imsg->IAddress);
							break;
					}
					break;
		 	}
		 	GT_ReplyIMsg(imsg);
		}
	}

	RemoveGList(win,DSG,-1);
	return( (UWORD)mday);
}