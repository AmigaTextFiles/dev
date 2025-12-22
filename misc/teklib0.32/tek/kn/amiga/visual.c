
/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	AmigaOS 3.x visual backend
*/


#include <tek/type.h>
#include <tek/array.h>
#include <tek/visual.h>
#include <tek/kn/visual.h>
#include <tek/kn/amiga/exec.h>

#include <intuition/intuition.h>
#include <libraries/cybergraphics.h>
#include <guigfx/guigfx.h>
#include <exec/execbase.h>

#include <proto/graphics.h>
#include <proto/cybergraphics.h>
#include <proto/intuition.h>
#include <proto/diskfont.h>
#include <proto/gadtools.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/exec.h>
#include <proto/guigfx.h>


#define SysBase *((struct ExecBase **) 4L)


/*
**	structures
**
*/

struct screen_amiga
{
	struct Screen *screen;
	char *title;

	struct Library *intuitionbase;
	struct Library *gfxbase;
	struct Library *guigfxbase;
	struct Library *gadtoolsbase;
};


struct window_amiga
{
	struct Window *window;

	UWORD winwidth, winheight;
	UWORD innerwidth, innerheight;

	WORD otherwinpos[4];			/* alternate window position x,y,w,h */

	ULONG idcmpmask;

	struct screen_amiga *scr;

	int windowbusycount;			/* nest count */

	BOOL sizable;
};


struct visual_amiga
{
	struct screen_amiga *screen;
	struct window_amiga *window;

	UWORD amigapentab[256];
	ULONG bgpen, fgpen;
	
	APTR drawhandle;			/* guigfx drawhandle */
	APTR ddh;					/* guigfx directdrawhandle */
	TINT16 ddhw, ddhh;			/* directdrawhandle dimensions */
};



/*
**	internal prototypes
**
*/

static void amiga_deletescreen(struct screen_amiga *amigascreen);
static struct screen_amiga *amiga_createscreen(char *title);
static void amiga_updatewindowparameters(struct window_amiga *win);
static void amiga_deletewindow(struct window_amiga *win);
static struct window_amiga *amiga_createwindow(struct screen_amiga *scr, int width, int height, int x, int y, BOOL borderless, BOOL sizable);




/* 
**	screen_amiga = amiga_createscreen(scrtitle)
*/

static struct screen_amiga *amiga_createscreen(char *title)
{
	struct screen_amiga *scr = kn_alloc0(sizeof(struct screen_amiga));
	if (scr)
	{	
		scr->title = TStrDup(TNULL, title ? title : "TEKlib visual");
		if (scr->title)
		{
			#define GfxBase			scr->gfxbase
			#define IntuitionBase	scr->intuitionbase
			#define GadToolsBase	scr->gadtoolsbase
			#define GuiGFXBase		scr->guigfxbase
	
			/* 
			**	required libraries
			*/
	
			GfxBase = OpenLibrary("graphics.library", 0);
			IntuitionBase = OpenLibrary("intuition.library", 0);
			GadToolsBase = OpenLibrary("gadtools.library", 0);
			GuiGFXBase = OpenLibrary("guigfx.library", 16);
		
			if (GfxBase && IntuitionBase && GadToolsBase && GuiGFXBase)
			{
				scr->screen = LockPubScreen(NULL);
				if (scr->screen)
				{
					ScreenToFront(scr->screen);
					return scr;
				}
			}

			CloseLibrary(GuiGFXBase);
			CloseLibrary(GadToolsBase);
			CloseLibrary(IntuitionBase);
			CloseLibrary(GfxBase);
	
			#undef GfxBase
			#undef IntuitionBase
			#undef GadToolsBase
			#undef GuiGFXBase
			
			TMMUFree(TNULL, scr->title);
		}
		
		kn_free(scr);
	}
	
	return NULL;
}


/*
**
**	amiga_deletescreen(scr)
**	
**	delete amiga screen
**
*/

static void amiga_deletescreen(struct screen_amiga *scr)
{
	if (scr)
	{
		#define GfxBase			scr->gfxbase
		#define IntuitionBase	scr->intuitionbase
		#define GadToolsBase	scr->gadtoolsbase
		#define GuiGFXBase		scr->guigfxbase

		if (scr->screen)
		{
			UnlockPubScreen(NULL, scr->screen);
		}

		CloseLibrary(GuiGFXBase);
		CloseLibrary(GadToolsBase);
		CloseLibrary(IntuitionBase);
		CloseLibrary(GfxBase);

		#undef GfxBase
		#undef IntuitionBase
		#undef GadToolsBase
		#undef GuiGFXBase

		TMMUFree(TNULL, scr->title);
		kn_free(scr);
	}
}



/*
**	window_amiga = amiga_createwindow(scr, int w, int h, int x, int y, borderless, sizable)
**
**	open an amiga window.
**
*/

static struct window_amiga *amiga_createwindow(struct screen_amiga *scr, int width, int height, int x, int y, BOOL borderless, BOOL sizable)
{
	#define IntuitionBase scr->intuitionbase
	#define GfxBase scr->gfxbase
	#define GuiGFXBase scr->guigfxbase
	#define GadToolsBase scr->gadtoolsbase

	if (scr)
	{
		struct window_amiga *win = kn_alloc(sizeof(struct window_amiga));
		if (win)
		{
			WORD viswidth, visheight, visleft, vistop, vismidx, vismidy;
			WORD borderwidth = 0, borderheight = 0;
			ULONG modeID, flags;
		
			struct TagItem taglist[20], *tp;
			tp = taglist;


			/* 
			**	determine the screen's visible area.
			*/

			viswidth = scr->screen->Width;
			visheight = scr->screen->Height;

			modeID = GetVPModeID(&scr->screen->ViewPort);
			if (modeID)
			{
				DisplayInfoHandle dih = FindDisplayInfo(modeID);
				if (dih)
				{
					struct DimensionInfo di;
					if (GetDisplayInfoData(dih, (UBYTE *) &di, sizeof(di), DTAG_DIMS, modeID))
					{
						viswidth = di.TxtOScan.MaxX - di.TxtOScan.MinX + 1;
						visheight = di.TxtOScan.MaxY - di.TxtOScan.MinY + 1;
					}
				}
			}
			
			visleft = -scr->screen->ViewPort.DxOffset;
			vistop = -scr->screen->ViewPort.DyOffset;
			
			vismidx = (viswidth >> 1) - scr->screen->ViewPort.DxOffset;
			vismidy = (visheight >> 1) - scr->screen->ViewPort.DyOffset;


			/* 
			**	by default, don't let our window obscure the screen's title bar.
			*/
			
			if (vistop < scr->screen->BarHeight + 1)
			{
				vistop += scr->screen->BarHeight + 1;
				visheight -= scr->screen->BarHeight + 1;
				vismidy += (scr->screen->BarHeight + 1) >> 1;
			}



			/* 
			**	determine window size
			*/
			
			if (width > 0 || height > 0)
			{
				/*
				**	use preferred size
				*/

				if (!borderless)
				{
					borderwidth = scr->screen->WBorLeft + scr->screen->WBorRight;
					borderheight = scr->screen->WBorTop + scr->screen->Font->ta_YSize + 1 + scr->screen->WBorBottom;
				
					if (sizable)
					{
						borderheight += 8;		

						/* WFLG_SIZEBBOTTOM default. that does not cover hacks like sysihack or visualprefs.
						** i don't know a legal way to determine the patched value. */
					}
				}


				tp->ti_Tag = WA_InnerWidth; tp->ti_Data = width; tp++;
				tp->ti_Tag = WA_InnerHeight; tp->ti_Data = height; tp++;
			}
			else
			{
				/* 
				**	by default, let the window be 2/3 the size of the screen's visible area
				*/

				width = (viswidth << 1) / 3;
				height = (visheight << 1) / 3;
				
				tp->ti_Tag = WA_InnerWidth; tp->ti_Data = width; tp++;
				tp->ti_Tag = WA_InnerHeight; tp->ti_Data = height; tp++;
			}


			/* 
			**	determine window position
			*/
	
			if (x < 0 && y < 0)
			{
				/* 
				**	by default, open centered
				*/
				
				x = vismidx - ((width + borderwidth) >> 1);
				y = vismidy - ((height + borderheight) >> 1);
			}
	
			tp->ti_Tag = WA_Left; tp->ti_Data = x; tp++;
			tp->ti_Tag = WA_Top; tp->ti_Data = y; tp++;


			/* 
			**	misc initializations.
			*/
			
			tp->ti_Tag = WA_PubScreen; tp->ti_Data = (ULONG) scr->screen; tp++;
			tp->ti_Tag = WA_NewLookMenus; tp->ti_Data = TRUE; tp++;
			tp->ti_Tag = WA_RMBTrap; tp->ti_Data = TRUE; tp++;

			flags = WFLG_SMART_REFRESH | WFLG_REPORTMOUSE;

			if (!borderless)
			{
				tp->ti_Tag = WA_Title; tp->ti_Data = (ULONG) scr->title; tp++;
				
				flags |= WFLG_DRAGBAR | WFLG_GIMMEZEROZERO | WFLG_DEPTHGADGET | WFLG_ACTIVATE | WFLG_CLOSEGADGET;
							
				if (sizable)
				{
					flags |= WFLG_SIZEBBOTTOM | WFLG_SIZEGADGET;

					tp->ti_Tag = WA_MinWidth; tp->ti_Data = borderwidth + 1; tp++;
					tp->ti_Tag = WA_MinHeight; tp->ti_Data = borderheight + 1; tp++;
					tp->ti_Tag = WA_MaxWidth; tp->ti_Data = viswidth; tp++;
					tp->ti_Tag = WA_MaxHeight; tp->ti_Data = visheight; tp++;

					/* 
					**	alternate window position.
					*/
		
					win->otherwinpos[0] = visleft;
					win->otherwinpos[1] = vistop;
					win->otherwinpos[2] = viswidth;
					win->otherwinpos[3] = visheight;
					tp->ti_Tag = WA_Zoom; tp->ti_Data = (ULONG) win->otherwinpos; tp++;
				}
			}
			else
			{
				flags |= WFLG_BORDERLESS | WFLG_BACKDROP;
			}

			tp->ti_Tag = WA_Flags; tp->ti_Data = flags; tp++;

			win->idcmpmask = 0;
			tp->ti_Tag = WA_IDCMP; tp->ti_Data = win->idcmpmask; tp++;

			tp->ti_Tag = TAG_DONE;
			
			if ((win->window = OpenWindowTagList(NULL, taglist)))
			{
				win->scr = scr;
				win->sizable = sizable;

				amiga_updatewindowparameters(win);

				SetABPenDrMd(win->window->RPort, 1, 0, JAM2);

			#if 0				
				if (scr->screenfont)
				{
					SetFont(win->window->RPort, scr->screenfont);
				}
			#endif
				
				ActivateWindow(win->window);
		
				return win;
			}
			
			kn_free(win);
		}
	}		

	#undef GadToolsBase
	#undef IntuitionBase
	#undef GfxBase
	#undef GuiGFXBase
	
	return NULL;
}


/*
**
**	amiga_deletewindow(window)
**
**	delete an amiga window
**
*/

static void amiga_deletewindow(struct window_amiga *win)
{
	if (win)
	{
		#define IntuitionBase win->scr->intuitionbase
		CloseWindow(win->window);
		#undef IntuitionBase
		kn_free(win);
	}
}





/*
**	amiga_updatewindowparameters(win)
**
**	get current window dimensions
**
*/

static void amiga_updatewindowparameters(struct window_amiga *win)
{
	if (win)
	{
		win->winwidth = win->window->Width;
		win->winheight = win->window->Height;
		win->innerwidth = win->winwidth - win->window->BorderLeft - win->window->BorderRight;
		win->innerheight = win->winheight - win->window->BorderTop - win->window->BorderBottom;
	}
}





/* 
**	kn_createvisual
**
*/

TAPTR kn_createvisual(TAPTR mmu, TSTRPTR preftitle, TINT prefw, TINT prefh)
{
	struct visual_amiga *visual;
	BOOL success = FALSE;

	visual = kn_alloc0(sizeof(struct visual_amiga));
	if (visual)
	{
		visual->screen = amiga_createscreen(preftitle);
		if (visual->screen)
		{
			BOOL borderless = FALSE;
			BOOL sizable = TRUE;	

			int winleft, wintop;
			
			winleft = -1;
			wintop = -1;
		
			visual->window = amiga_createwindow(visual->screen, prefw, prefh, winleft, wintop, borderless, sizable);
			if (visual->window)
			{
				success = TRUE;
			}
		}	
	}

	if (!success)
	{
		kn_destroyvisual(visual);
		visual = NULL;
	}

	return visual;
}



/* 
**	kn_destroyvisual
**
*/

TVOID kn_destroyvisual(TAPTR v)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase
	#define GuiGFXBase visual->screen->guigfxbase

	if (visual)
	{
		int i;
		
		DeleteDirectDrawHandle(visual->ddh);
		ReleaseDrawHandle(visual->drawhandle);
		
		for (i = 0; i < 256; ++i)
		{
			while (visual->amigapentab[i]--)
			{
				ReleasePen(visual->screen->screen->ViewPort.ColorMap, (ULONG) i);
			}
		}
	
		amiga_deletewindow(visual->window);
		amiga_deletescreen(visual->screen);
		kn_free(visual);
	}
	
	#undef GuiGFXBase
	#undef GfxBase
}



/*
**
**	newinput = kn_getnextinput(visual, newimsg, eventmask)
**
**	get next input event from visual object
**	and fill it into the supplied TIMSG structure.
**
**	returns TTRUE, when there was a new message filled into the
**	newimsg structure, otherwise TFALSE
**
*/

TBOOL kn_getnextinput(TAPTR v, TIMSG *newimsg, TUINT eventmask)
{	
	struct visual_amiga *visual = (struct visual_amiga *) v;
	struct IntuiMessage *amiga_imsg;

	if (!visual->window->window->UserPort)
	{
		return TFALSE;
	}

	#define GadToolsBase visual->screen->gadtoolsbase

	newimsg->type = TITYPE_NONE;
	amiga_imsg = GT_GetIMsg(visual->window->window->UserPort);
	if (amiga_imsg)
	{
		switch (amiga_imsg->Class)
		{
			case ACTIVEWINDOW:
				newimsg->type = TITYPE_VISUAL_FOCUS;
				break;

			case INACTIVEWINDOW:
				newimsg->type = TITYPE_VISUAL_UNFOCUS;
				break;

			case MOUSEMOVE:
				newimsg->type = TITYPE_MOUSEMOVE;
				break;
				
			case MOUSEBUTTONS:
				switch (amiga_imsg->Code)
				{
					case SELECTUP:
						newimsg->type = TITYPE_MOUSEBUTTON;
						newimsg->code = TMBCODE_LEFTUP;
						break;				
	
					case SELECTDOWN:
						newimsg->type = TITYPE_MOUSEBUTTON;
						newimsg->code = TMBCODE_LEFTDOWN;
						break;				

					case MENUUP:
						newimsg->type = TITYPE_MOUSEBUTTON;
						newimsg->code = TMBCODE_RIGHTUP;
						break;				
	
					case MENUDOWN:
						newimsg->type = TITYPE_MOUSEBUTTON;
						newimsg->code = TMBCODE_RIGHTDOWN;
						break;				
				}
				break;
			
			case CLOSEWINDOW:
				newimsg->type = TITYPE_VISUAL_CLOSE;
				break;
			
			case NEWSIZE:
				amiga_updatewindowparameters(visual->window);
				newimsg->type = TITYPE_VISUAL_NEWSIZE;
				newimsg->width = visual->window->innerwidth;
				newimsg->height = visual->window->innerheight;
				break;
			
			case REFRESHWINDOW:
				break;

			case RAWKEY:
				if (amiga_imsg->Code >= 80 && amiga_imsg->Code <= 89)
				{
					newimsg->type = TITYPE_KEY;
					newimsg->code = TKEYCODE_F1 + amiga_imsg->Code - 80;
				}
				else
				{
					switch (amiga_imsg->Code)
					{
						case 95:
							newimsg->type = TITYPE_KEY;
							newimsg->code = TKEYCODE_HELP;
							break;
						case 76:
							newimsg->type = TITYPE_KEY;
							newimsg->code = TKEYCODE_CRSRUP;
							break;
						case 77:
							newimsg->type = TITYPE_KEY;
							newimsg->code = TKEYCODE_CRSRDOWN;
							break;
						case 78:
							newimsg->type = TITYPE_KEY;
							newimsg->code = TKEYCODE_CRSRRIGHT;
							break;
						case 79:
							newimsg->type = TITYPE_KEY;
							newimsg->code = TKEYCODE_CRSRLEFT;
							break;
					}
				}
				break;

			case VANILLAKEY:
				switch (amiga_imsg->Code)
				{
					case 27:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_ESC;
						break;

					case 8:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_BCKSPC;
						break;

					case 9:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_TAB;
						break;

					case 13:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_ENTER;
						break;

					case 127:
						newimsg->type = TITYPE_KEY;
						newimsg->code = TKEYCODE_DEL;
						break;

					default:
						newimsg->type = TITYPE_KEY;
						newimsg->code = (TUINT) amiga_imsg->Code;
				}
				break;		
		}

		if (newimsg->type & eventmask)
		{
			newimsg->mousex = amiga_imsg->MouseX - visual->window->window->BorderLeft;
			newimsg->mousey = amiga_imsg->MouseY - visual->window->window->BorderTop;
			newimsg->qualifier = 0;
		
			if (amiga_imsg->Qualifier & IEQUALIFIER_LSHIFT)
			{
				newimsg->qualifier |= TKEYQUAL_LEFT_SHIFT;		
			}
			if (amiga_imsg->Qualifier & IEQUALIFIER_RSHIFT)
			{
				newimsg->qualifier |= TKEYQUAL_RIGHT_SHIFT;		
			}
			if (amiga_imsg->Qualifier & IEQUALIFIER_CONTROL)
			{
				newimsg->qualifier |= TKEYQUAL_LEFT_CONTROL;
			}
			if (amiga_imsg->Qualifier & IEQUALIFIER_LALT)
			{
				newimsg->qualifier |= TKEYQUAL_LEFT_ALT;
			}
			if (amiga_imsg->Qualifier & IEQUALIFIER_RALT)
			{
				newimsg->qualifier |= TKEYQUAL_RIGHT_ALT;
			}
			if (amiga_imsg->Qualifier & IEQUALIFIER_LCOMMAND)
			{
				newimsg->qualifier |= TKEYQUAL_LEFT_PROPRIETARY;
			}
			if (amiga_imsg->Qualifier & IEQUALIFIER_RCOMMAND)
			{
				newimsg->qualifier |= TKEYQUAL_RIGHT_PROPRIETARY;
			}
			if (amiga_imsg->Qualifier & IEQUALIFIER_NUMERICPAD)
			{
				newimsg->qualifier |= TKEYQUAL_NUMBLOCK;
			}
		}
		
		GT_ReplyIMsg(amiga_imsg);
	}

	#undef GadToolsBase

	return (newimsg->type & eventmask);
}



/*
**	kn_setinputmask(visual, inputmask)
**
**	set a new mask of input events to be reported
**	
*/

TVOID kn_setinputmask(TAPTR v, TUINT eventmask)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;
	ULONG idcmp = 0;

	#define IntuitionBase visual->screen->intuitionbase

	if (eventmask & TITYPE_VISUAL_CLOSE) idcmp |= IDCMP_CLOSEWINDOW;
	if (eventmask & TITYPE_VISUAL_FOCUS) idcmp |= IDCMP_ACTIVEWINDOW;
	if (eventmask & TITYPE_VISUAL_UNFOCUS) idcmp |= IDCMP_INACTIVEWINDOW;
	if ((eventmask & TITYPE_VISUAL_NEWSIZE) && visual->window->sizable) idcmp |= IDCMP_NEWSIZE;
	if (eventmask & TITYPE_KEY) idcmp |= IDCMP_VANILLAKEY | IDCMP_RAWKEY;
	if (eventmask & TITYPE_MOUSEMOVE) idcmp |= IDCMP_MOUSEMOVE;
	if (eventmask & TITYPE_MOUSEBUTTON) idcmp |= IDCMP_MOUSEBUTTONS;
	
	if (idcmp != visual->window->idcmpmask)
	{
		ModifyIDCMP(visual->window->window, idcmp);
		visual->window->idcmpmask = idcmp;
	}
	
	#undef IntuitionBase
}





/*
**	pen = kn_allocpen(visual, rgb)
**
**	allocate a coloured pen (rgbcolor format: 0x00rrggbb).
**	0xffffffff if out of pens.
*/

TAPTR kn_allocpen(TAPTR v, TUINT rgb)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	ULONG r, g, b;
	LONG amigapen;

	r = (rgb & 0xff0000); r = r | (r << 8); r = r | (r >> 16);
	g = (rgb & 0x00ff00); g = g | (g >> 8); g = g | (g << 16);
	b = (rgb & 0x0000ff); b = b | (b << 8); b = b | (b << 16);

	amigapen = ObtainBestPen(visual->screen->screen->ViewPort.ColorMap, r,g,b, TAG_DONE);

	visual->amigapentab[amigapen]++;

	#undef GfxBase
	
	return (TAPTR) amigapen;
}



/*
**	kn_freepen(visual, pen-nr)
**
**	free a coloured pen
*/

TVOID kn_freepen(TAPTR v, TAPTR pen)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	if ((ULONG) pen > 0)
	{
		ReleasePen(visual->screen->screen->ViewPort.ColorMap, (ULONG) pen);
		visual->amigapentab[(ULONG) pen]--;	
	}

	#undef GfxBase
}


/*
**	kn_setbgpen(visual, pen)
**
**	set background pen
*/

TVOID kn_setbgpen(TAPTR v, TAPTR pen)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	SetBPen(visual->window->window->RPort, (ULONG) pen);
	visual->bgpen = (ULONG) pen;

	#undef GfxBase
}


/*
**	kn_setfgpen(visual, pen)
**
**	set foreground pen
*/

TVOID kn_setfgpen(TAPTR v, TAPTR pen)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	SetAPen(visual->window->window->RPort, (ULONG) pen);
	visual->fgpen = (ULONG) pen;

	#undef GfxBase
}


/*
**	kn_line(visual, x,y,x2,y2)
**
**	line
*/

TVOID kn_line(TAPTR v, TINT x1, TINT y1, TINT x2, TINT y2)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	Move(visual->window->window->RPort, (LONG) x1, (LONG) y1);
	Draw(visual->window->window->RPort, (LONG) x2, (LONG) y2);
	
	#undef GfxBase
}



/*
**	kn_frect(visual, x, y, w, h)
**
**	filled rectangle
*/

TVOID kn_frect(TAPTR v, TINT x, TINT y, TINT w, TINT h)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	RectFill(visual->window->window->RPort, (LONG) x, (LONG) y, (LONG) x + w - 1, (LONG) y + h - 1);

	#undef GfxBase
}



/*
**	kn_rect(visual, x, y, w, h)
**
**	outline rectangle
*/

TVOID kn_rect(TAPTR v, TINT x, TINT y, TINT w, TINT h)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	Move(visual->window->window->RPort, (LONG) x, (LONG) y);
	Draw(visual->window->window->RPort, (LONG) x+w-1, (LONG) y);
	Draw(visual->window->window->RPort, (LONG) x+w-1, (LONG) y+h-1);
	Draw(visual->window->window->RPort, (LONG) x, (LONG) y+h-1);
	Draw(visual->window->window->RPort, (LONG) x, (LONG) y);
	
	#undef GfxBase
}


/*
**	kn_plot(visual, x, y)
**
**	plot
*/

TVOID kn_plot(TAPTR v, TINT x, TINT y)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	Move(visual->window->window->RPort, (LONG) x, (LONG) y);
	Draw(visual->window->window->RPort, (LONG) x, (LONG) y);
	
	#undef GfxBase
}



/*
**	kn_getparameters(visual, visualparameters)
**
**	fill a visual parameters structure
*/

TVOID kn_getparameters(TAPTR v, struct knvisual_parameters *p)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	amiga_updatewindowparameters(visual->window);	
	p->fontwidth = visual->window->window->RPort->TxWidth;
	p->fontheight = visual->window->window->RPort->TxHeight;
	p->pixelwidth = visual->window->innerwidth;
	p->pixelheight = visual->window->innerheight;
	p->textwidth = visual->window->innerwidth / p->fontwidth;
	p->textheight = visual->window->innerheight / p->fontheight;
}



/*
**	kn_scroll(visual, x, y, w, h, dx, dy)
**
**	scroll rectangle
**	
*/

TVOID kn_scroll(TAPTR v, TINT x, TINT y, TINT w, TINT h, TINT dx, TINT dy)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	ScrollRaster(visual->window->window->RPort, (LONG) dx, (LONG) dy, (LONG) x, (LONG) y, (LONG) x + w - 1, (LONG) y + h - 1);

	#undef GfxBase
}



/*
**	kn_drawtext(visual, x, y, text, len)
**
**	write text to text cursor position
**	
*/

TVOID kn_drawtext(TAPTR v, TINT x, TINT y, TSTRPTR text, TUINT len)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GfxBase visual->screen->gfxbase

	if (text && len > 0)
	{
		Move(visual->window->window->RPort, 
			(LONG) x * visual->window->window->RPort->TxWidth, 
			(LONG) y * visual->window->window->RPort->TxHeight +
			visual->window->window->RPort->TxBaseline);
			
		Text(visual->window->window->RPort, text, (ULONG) len);
	}

	#undef GfxBase
}



/*
**	kn_waitvisual(visual, timer, knevent)
**
**	wait for visual or supplied event, or optionally for a timer
**	
*/

TBOOL kn_waitvisual(TAPTR v, TKNOB *timer, TKNOB *evt)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;
	ULONG visualsig = (1L << visual->window->window->UserPort->mp_SigBit);

	return (Wait(visualsig | (1L << ((struct amievent *) evt)->signal)) & visualsig);
}



/* 
**	kn_sync	
**
*/

TVOID kn_flush(TAPTR v, TINT x, TINT y, TINT w, TINT h)
{
}



/*
**	kn_drawrgb(visual, buf, x,y,w,h,totwidth)
**
**	draw RGB buffer
**	
*/

TVOID kn_drawrgb(TAPTR v, TUINT *buf, TINT x, TINT y, TINT w, TINT h, TINT totwidth)
{
	struct visual_amiga *visual = (struct visual_amiga *) v;

	#define GuiGFXBase visual->screen->guigfxbase
	
	if (GuiGFXBase)
	{
		if (!visual->drawhandle)
		{
			visual->drawhandle = ObtainDrawHandleA(NULL, visual->window->window->RPort,
				visual->screen->screen->ViewPort.ColorMap, TNULL);
		}
		
		if (visual->drawhandle)
		{
			if (visual->ddh)
			{
				if (w != visual->ddhw || h != visual->ddhh)
				{
					DeleteDirectDrawHandle(visual->ddh);
					visual->ddh = TNULL;
				}
			}
		
			if (!visual->ddh)
			{
				visual->ddh = CreateDirectDrawHandleA(visual->drawhandle, w, h, w, h, TNULL);
				visual->ddhw = w;
				visual->ddhh = h;
			}
			
			if (visual->ddh)
			{
				DirectDrawTrueColor(visual->ddh, (ULONG *) buf, x, y, 
					GGFX_SourceWidth, totwidth, TAG_DONE);
			}
		}
	}
	
	#undef GuiGFXBase
}


#undef SysBase
