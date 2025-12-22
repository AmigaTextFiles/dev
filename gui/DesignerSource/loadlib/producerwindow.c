/*********************************************/
/*                                           */
/*       Designer (C) Ian OConnor 1994       */
/*                                           */
/*      Designer Produced C include file     */
/*                                           */
/*********************************************/

#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dosextens.h>
#include <intuition/screens.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <libraries/gadtools.h>
#include <diskfont/diskfont.h>
#include <utility/utility.h>
#include <graphics/gfxbase.h>
#include <workbench/workbench.h>
#include <graphics/scale.h>
#include <clib/exec_protos.h>
#include <clib/wb_protos.h>
#include <clib/intuition_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/utility_protos.h>
#include <string.h>
#include <clib/diskfont_protos.h>

#include "ProducerWindow.h"


UBYTE pwnWinFirstRun = 0;
UWORD BackgroundFrameTag4Data[] = {
  21845,43690
  };

ULONG pwnWinGadgetTags[] =
	{
	(ULONG)(-2147352575),0,
	(ULONG)(-2147352574),0,
	(ULONG)(-2147352573),0,
	(ULONG)(-2147352572),0,
	(ULONG)(-2147352560),(ULONG)&BackgroundFrameTag4Data[0],
	(ULONG)(-2147352559),(ULONG)(1),
	(ULONG)(-2147352558),(ULONG)(0),
	(ULONG)(-2147352571),(ULONG)(2),
	(TAG_END),
	(ULONG)(-2147352575),0,
	(ULONG)(-2147352574),0,
	(ULONG)(-2147352573),0,
	(ULONG)(-2147352572),0,
	(ULONG)(-2147352555),1,
	(TAG_END),
	(GT_Underscore), '_',
	(TAG_END),
	(GT_TagBase+74), 0,  /* Justification in V39 */
	(TAG_END),
	(GTTX_Text), (ULONG)"Initiating",
	(GT_TagBase+74), 0,  /* Justification in V39 */
	(TAG_END),
	(GT_TagBase+74), 0,  /* Justification in V39 */
	(TAG_END),
	};

UWORD pwnWinGadgetTypes[] =
	{
	198,
	198,
	BUTTON_KIND,
	TEXT_KIND,
	TEXT_KIND,
	NUMBER_KIND,
	};

struct NewGadget pwnWinNewGadgets[] =
	{
	0, 0, 346, 68, (UBYTE *)"fillrectclass", NULL, BackgroundFrame, 1, NULL,  (APTR)&pwnWinGadgetTags[0],
	9, 4, 327, 44, (UBYTE *)"frameiclass", NULL, RecessedFrame, 1, NULL,  (APTR)&pwnWinGadgetTags[17],
	140, 51, 64, 14, (UBYTE *)"_Abort", NULL, AbortButton, 16, NULL,  (APTR)&pwnWinGadgetTags[28],
	90, 7, 236, 12, (UBYTE *)"File :", NULL, FileDisplayGadget, 1, NULL,  (APTR)&pwnWinGadgetTags[31],
	90, 20, 236, 12, (UBYTE *)"Action :", NULL, ActionDisplayGadget, 1, NULL,  (APTR)&pwnWinGadgetTags[34],
	90, 33, 236, 12, (UBYTE *)"Lines :", NULL, LinesDisplayGad, 1, NULL,  (APTR)&pwnWinGadgetTags[39],
	};

APTR WaitPointer = NULL;
UWORD WaitPointerData[] =
    {
    0x0000,0x0000,0x0400,0x07c0,
    0x0000,0x07c0,0x0100,0x0380,
    0x0000,0x07e0,0x07c0,0x1ff8,
    0x1ff0,0x3fec,0x3ff8,0x7fde,
    0x3ff8,0x7fbe,0x7ffc,0xff7f,
    0x7ffc,0xffff,0x7ffc,0xffff,
    0x3ff8,0x7ffe,0x3ff8,0x7ffe,
    0x1ff0,0x3ffc,0x07c0,0x1ff8,
    0x0000,0x07e0,0x0000,0x0000
    };

void RendWindowpwnWin( struct Window *Win, void *vi, struct ProducerNode * pwn )
{
UWORD offx = Win->BorderLeft;
UWORD offy = Win->BorderTop;
ULONG scalex = 65535*Win->WScreen->RastPort.Font->tf_XSize/8;
ULONG scaley = 65535*Win->WScreen->RastPort.Font->tf_YSize/8;
if (Win != NULL) 
	{
	if (pwn->WinGadgets[BackgroundFrame - pwnWinFirstID])
	  DrawImageState(pwn->Win->RPort, (APTR)pwn->WinGadgets[BackgroundFrame - pwnWinFirstID], 0, 0, 0, pwn->WinDrawInfo);
	if (pwn->WinGadgets[RecessedFrame - pwnWinFirstID])
	  DrawImageState(pwn->Win->RPort, (APTR)pwn->WinGadgets[RecessedFrame - pwnWinFirstID], 0, 0, 0, pwn->WinDrawInfo);
	}
}

int OpenWindowpwnWin( struct ProducerNode * pwn)
{
struct Screen *Scr;
UWORD offx, offy;
UWORD loop;
struct NewGadget newgad;
struct Gadget *Gad;
struct Gadget *Gad2;
APTR Cla;
ULONG scalex,scaley;
if (pwnWinFirstRun == 0)
	{
	pwnWinFirstRun = 1;
	}
if (pwn->Win == NULL)
	{
	Scr = LockPubScreen(NULL);
	if (NULL != Scr)
		{
		offx = Scr->WBorLeft;
		offy = Scr->WBorTop + Scr->Font->ta_YSize+1;
		scalex = 65535*Scr->RastPort.Font->tf_XSize/8;
		scaley = 65535*Scr->RastPort.Font->tf_YSize/8;
		if (NULL != ( pwn->WinVisualInfo = GetVisualInfoA( Scr, NULL)))
			{
			if (NULL != ( pwn->WinDrawInfo = GetScreenDrawInfo( Scr)))
				{
				pwnWinGadgetTags[1] = (ULONG)(offx + 0*scalex/65535);
				pwnWinGadgetTags[3] = (ULONG)(offy + 0*scaley/65535);
				pwnWinGadgetTags[5] = (ULONG)(346*scalex/65535);
				pwnWinGadgetTags[7] = (ULONG)(68*scaley/65535);
				pwnWinGadgetTags[18] = (ULONG)(offx + 9*scalex/65535);
				pwnWinGadgetTags[20] = (ULONG)(offy + 4*scaley/65535);
				pwnWinGadgetTags[22] = (ULONG)(327*scalex/65535);
				pwnWinGadgetTags[24] = (ULONG)(44*scaley/65535);
				pwn->WinGList = NULL;
				Gad = CreateContext( &pwn->WinGList);
				for ( loop=0 ; loop<6 ; loop++ )
					if (pwnWinGadgetTypes[loop] != 198)
						{
						CopyMem((char * )&pwnWinNewGadgets[loop], ( char * )&newgad, (long)sizeof( struct NewGadget ));
						newgad.ng_VisualInfo = pwn->WinVisualInfo;
						newgad.ng_LeftEdge = newgad.ng_LeftEdge*scalex/65535;
						newgad.ng_TopEdge = newgad.ng_TopEdge*scaley/65535;
						if (pwnWinGadgetTypes[loop] != GENERIC_KIND)
							{
							newgad.ng_Width = newgad.ng_Width*scalex/65535;
							newgad.ng_Height = newgad.ng_Height*scaley/65535;
							};
						newgad.ng_TextAttr = Scr->Font;
						newgad.ng_LeftEdge += offx;
						newgad.ng_TopEdge += offy;
						pwn->WinGadgets[ loop ] = NULL;
						pwn->WinGadgets[ newgad.ng_GadgetID - pwnWinFirstID ] = Gad = CreateGadgetA( pwnWinGadgetTypes[loop], Gad, &newgad, newgad.ng_UserData );
						}
				for ( loop=0 ; loop<6 ; loop++ )
					if (pwnWinGadgetTypes[loop] == 198)
						{
						pwn->WinGadgets[ loop ] = NULL;
						Cla = NULL;
						if ( loop ==  ( BackgroundFrame  - pwnWinFirstID ))
							{
							}
						if ( loop ==  ( RecessedFrame  - pwnWinFirstID ))
							{
							}
						if (Gad)
							pwn->WinGadgets[ loop ] = Gad2 = (struct Gadget *) NewObjectA( (struct IClass *)Cla, pwnWinNewGadgets[ loop ].ng_GadgetText, pwnWinNewGadgets[ loop ].ng_UserData );
						if ( (loop ==  ( BackgroundFrame  - pwnWinFirstID )) && (Gad2))
							{
							}
						if ( (loop ==  ( RecessedFrame  - pwnWinFirstID )) && (Gad2))
							{
							}
						}
				if (Gad != NULL)
					{
					if (NULL != (pwn->Win = OpenWindowTags( NULL, (WA_Left), 48,
									(WA_Top), 23,
									(WA_InnerWidth), 346*scalex/65535,
									(WA_InnerHeight), 68*scaley/65535,
									(WA_Title), "Designer Producer",
									(WA_MinWidth), 150,
									(WA_MinHeight), 25,
									(WA_MaxWidth), 1200,
									(WA_MaxHeight), 1200,
									(WA_DragBar), TRUE,
									(WA_DepthGadget), TRUE,
									(WA_CloseGadget), TRUE,
									(WA_Activate), TRUE,
									(WA_RMBTrap), TRUE,
									(WA_Dummy+0x30), TRUE,
									(WA_SmartRefresh), TRUE,
									(WA_AutoAdjust), TRUE,
									(WA_Gadgets), pwn->WinGList,
									(WA_IDCMP),2097732,
									(TAG_END))))
						{
						RendWindowpwnWin(pwn->Win, pwn->WinVisualInfo , pwn);
						GT_RefreshWindow( pwn->Win, NULL);
						RefreshGList( pwn->WinGList, pwn->Win, NULL, ~0);
						UnlockPubScreen( NULL, Scr);
						return( 0L );
						}
					}
				FreeGadgets( pwn->WinGList);
				FreeScreenDrawInfo( Scr, pwn->WinDrawInfo );
				}
			FreeVisualInfo( pwn->WinVisualInfo );
			}
		UnlockPubScreen( NULL, Scr);
		}
	}
else
	{
	WindowToFront(pwn->Win);
	ActivateWindow(pwn->Win);
	return( 0L );
	}
return( 1L );
}

void CloseWindowpwnWin( struct ProducerNode * pwn )
{
if (pwn->Win != NULL)
	{
	FreeScreenDrawInfo( pwn->Win->WScreen, pwn->WinDrawInfo );
	pwn->WinDrawInfo = NULL;
	CloseWindow( pwn->Win);
	pwn->Win = NULL;
	FreeVisualInfo( pwn->WinVisualInfo);
	FreeGadgets( pwn->WinGList);
	if (pwn->WinGadgets[BackgroundFrame])
		DisposeObject( ( APTR ) pwn->WinGadgets[BackgroundFrame] );
	if (pwn->WinGadgets[RecessedFrame])
		DisposeObject( ( APTR ) pwn->WinGadgets[RecessedFrame] );
	}
}

int MakeImages( void )
{
UWORD failed = 0;
if (NULL != (WaitPointer=AllocMem( 72, MEMF_CHIP)))
	CopyMem( WaitPointerData, WaitPointer, 72);
else
	failed = 1;
if (failed==0)
	return( 0L );
else
	{
	FreeImages;
	return( 1L );
	}
}

void FreeImages( void )
{
if (WaitPointer != NULL)
	FreeMem( WaitPointer, 72);
WaitPointer = NULL;
}

