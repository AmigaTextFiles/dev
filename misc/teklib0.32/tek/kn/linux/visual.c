
/*
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	Linux/X11 visual backend
*/


#include <tek/type.h>
#include <tek/visual.h>
#include <tek/kn/visual.h>

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>


#define DEFAULT_X11_FONT_NAME	"-misc-fixed-medium-r-normal-*-14-*-*-*-*-*-*-*"


typedef struct
{
	Display *display;
	int screen;
	Visual *visual;

	Window win;
	Colormap colormap;
	GC gc;
	XFontStruct *font;
	XTextProperty title_prop;
	Atom atom_wm_delete_win;
	
	XImage *image;
	int imw, imh;
	
	int cursor_x, cursor_y;		/* pixel position */
	int font_w, font_h;		/* fixed font metrics */
	int win_w, win_h;		/* window size */
	int text_w, text_h;		/* text windows size */
	long mask;			/* window's eventmask */
	long base_mask;			/* window's base eventmask (will not be influenced by visual's setmask) */
	unsigned int width, height;

	/*TAPTR pen_ht;*/

	TBOOL mousein;

	int depth;
	int pixfmt;
	int bpp;			/* bytes per pixel */
	int swap;

} VisualX;


static const char* eventname(int eventtype)
{
	static const char *name[] =
	{
		"",
		"",
		"KeyPress",
		"KeyRelease",
		"ButtonPress",
		"ButtonRelease",
		"MotionNotify",
		"EnterNotify",
		"LeaveNotify",
		"FocusIn",
		"FocusOut",
		"KeymapNotify",
		"Expose",
		"GraphicsExpose",
		"NoExpose",
		"VisibleNotify",
		"CreateNotify",
		"DestroyNotify",
		"UnmapNotify",
		"MapNotify",
		"MapRequest",
		"ReparentNotify",
		"ConfigureNotify",
		"ConfigureRequest",
		"GravityNotify",
		"ResizeRequest",
		"CirculateNotify",
		"CirculateRequest",
		"PropertyNotify",
		"SelectionClear",
		"SelectionRequest",
		"SelectionNotify",
		"ColormapNotify",
		"ClientMessage",
		"MappingNotify"
	};
	return name[eventtype];
}



static void kn_window_resize(VisualX *x, int width, int height)
{
	x->win_w = width;
	x->win_h = height;
	x->text_w = (x->font_w) ? width / x->font_w : 0;
	x->text_h = (x->font_h) ? height / x->font_h : 0;
}






#define PIXFMT_UNDEFINED	0
#define PIXFMT_RGB			1
#define PIXFMT_RBG			2
#define PIXFMT_BRG			3
#define PIXFMT_BGR			4
#define PIXFMT_GRB			5
#define PIXFMT_GBR			6

static char *strpixfmt(int pixfmt)
{
	static char *names[] = {
		"PIXFMT_UNDEFINED", "PIXFMT_RGB", "PIXFMT_RBG", "PIXFMT_BRG", "PIXFMT_BGR", "PIXFMT_GRB", "PIXFMT_GBR" };
		
	return names[pixfmt];
}

static void getdisplaydata(VisualX *x)
{
	int max, maxn, i, num, clas;
	XVisualInfo xvi, *xvir;


	/* 
	**	client <-> server endianness
	*/
	
	if (htonl(1) == 1)
	{
		x->swap = (ImageByteOrder(x->display) == LSBFirst);
	}
	else
	{
		x->swap = (ImageByteOrder(x->display) == MSBFirst);
	}


	/* 
	**	depth
	*/
		
	x->depth = DefaultDepth(x->display, x->screen);
	

	/* 
	**	RGB ordering
	*/

	xvi.screen = x->screen;
	xvir = XGetVisualInfo(x->display, VisualScreenMask, &xvi, &num);
	if (xvir)
	{
		max = 0;
		for (i = 0; i < num; i++)
		{
			if (xvir[i].depth > max)
			{
				max = xvir[i].depth;		/* max depth supported */
			}
	    }
	    
		if (max > 8)
		{
			x->depth = max;
			clas = -1;
			maxn = -1;
			for (i = 0; i < num; i++)
			{
				if (xvir[i].depth == x->depth)
				{
					if ((xvir[i].class > clas) && (xvir[i].class != DirectColor))
					{
						maxn = i;
						clas = xvir[i].class;
					}
				}
			}
		}

		if (maxn >= 0)
		{
			unsigned long rmsk, gmsk, bmsk;
			
			x->visual = xvir[maxn].visual;
			rmsk = xvir[maxn].red_mask;
			gmsk = xvir[maxn].green_mask;
			bmsk = xvir[maxn].blue_mask;
			
			if ((rmsk > gmsk) && (gmsk > bmsk))
			{
				x->pixfmt = PIXFMT_RGB;
			}
			else if ((rmsk > bmsk) && (bmsk > gmsk))
			{
				x->pixfmt = PIXFMT_RBG;
			}
			else if ((bmsk > rmsk) && (rmsk > gmsk))
			{
				x->pixfmt = PIXFMT_BRG;
			}
			else if ((bmsk > gmsk) && (gmsk > rmsk))
			{
				x->pixfmt = PIXFMT_BGR;
			}
			else if ((gmsk > rmsk) && (rmsk > bmsk))
			{
				x->pixfmt = PIXFMT_GRB;
			}
			else if ((gmsk > bmsk) && (bmsk > rmsk))
			{
				x->pixfmt = PIXFMT_GBR;
			}
			else
			{
				x->pixfmt = PIXFMT_UNDEFINED;
			}
		}

		XFree(xvir);
	}

	if (x->depth == 16)
	{
		xvi.visual = x->visual;
		xvi.visualid = XVisualIDFromVisual(x->visual);
		xvir = XGetVisualInfo(x->display, VisualIDMask, &xvi, &num);
		if (xvir)
		{
			if (xvir->red_mask != 0xf800)
			{
				x->depth = 15;
			}
			XFree(xvir);
		}
	}

	switch (x->depth)
	{
		case 15:
		case 16:
			x->bpp = 2;
			break;
		case 24:
		case 32:
			x->bpp = 4;
			break;
	}

	dbvprintf1(1, "TEKLIB kn_createvisual: format: %s\n", strpixfmt(x->pixfmt));
	dbvprintf1(1, "TEKLIB kn_createvisual: depth: %d\n", x->depth);
	dbvprintf1(1, "TEKLIB kn_createvisual: bytesperpixel: %d\n", x->bpp);
	dbvprintf1(1, "TEKLIB kn_createvisual: swap: %d\n", x->swap);

}






TAPTR kn_createvisual(TAPTR mmu, TSTRPTR title, TINT prefwidth, TINT prefheight)
{
	VisualX *x;
	unsigned long swa_mask;
	unsigned long gcv_mask;
	XSetWindowAttributes swa;
	XGCValues gcv;
	int mapped = 0;
	TUINT in_win_w = 640, in_win_h = 480;
	
	if (prefwidth > 0)
	{
		in_win_w = prefwidth;
	}

	if (prefheight > 0)
	{
		in_win_h = prefheight;
	}

	if (!title)
	{
		title = "TEKlib visual";
	}


	
	x = (VisualX*) kn_alloc0(sizeof(VisualX));

	if (!x)
		goto err_return;


	
	/* open display */
	
	x->display = XOpenDisplay(TNULL);

	if (!x->display)
		goto err_free;

	x->screen = DefaultScreen(x->display);
	x->visual = DefaultVisual(x->display, x->screen);



	getdisplaydata(x);


	
	/* load default font and create gc */

	gcv_mask = 0;
	
	x->font = XLoadQueryFont(x->display, DEFAULT_X11_FONT_NAME );

	if (x->font)
	{
		gcv.font = x->font->fid;
		gcv_mask |= GCFont;
		
		x->font_w = XTextWidth(x->font," ", 1);
		x->font_h = x->font->ascent + x->font->descent;
	}
	else
	{
		dbvprintf(20, "can't load font\n");
	}

	
	/* create window */
	
	x->colormap = XCreateColormap(x->display, RootWindow(x->display, x->screen) , x->visual, AllocNone);

	swa_mask = CWBackPixel|CWColormap|CWEventMask;
	
	swa.background_pixel = BlackPixel(x->display, x->screen);
	swa.colormap = x->colormap;
	swa.event_mask = StructureNotifyMask;
	
	/* backing-store, per default.
	 * NOTE: no other auto-refreshing mode is supported (even no exposure-events are generated) */
	if ((swa.backing_store = DoesBackingStore(ScreenOfDisplay(x->display, x->screen))) != 0)
	{
		swa.backing_planes = -1L;			/* all planes per default */
		swa_mask |= CWBackingStore|CWBackingPlanes; 
	}


	x->base_mask = swa.event_mask;
	
	x->cursor_x = 0;
	x->cursor_y = 0;

	kn_window_resize(x, in_win_w, in_win_h);
	
	x->win = XCreateWindow(x->display, RootWindow(x->display, x->screen),
			       0, 0, in_win_w, in_win_h, 
			       0,  CopyFromParent, CopyFromParent, CopyFromParent,  
			       swa_mask, &swa);

	/* set wm properties */

	XStringListToTextProperty((char**)&title, 1, &x->title_prop);
	XSetWMProperties(x->display, x->win, &x->title_prop, NULL, NULL, 0, NULL, NULL, NULL);

	x->atom_wm_delete_win = XInternAtom(x->display, "WM_DELETE_WINDOW", True);
	
	XSetWMProtocols(x->display, x->win, &x->atom_wm_delete_win,1);
	
	
	/* setup graphics context */
	
	gcv.function = GXcopy;
	gcv.fill_style = FillSolid;
	gcv.graphics_exposures = False;
	
	gcv_mask |= GCFunction | GCFillStyle | GCGraphicsExposures;
	
	x->gc = XCreateGC(x->display, x->win, gcv_mask, &gcv);
	
	XCopyGC( x->display,
		 XDefaultGC(x->display, x->screen),
		 GCForeground|GCBackground, 
		 x->gc);

	
	/* map window */
	
	XMapWindow(x->display, x->win);
	
	
	/* wait for window */
	
	do
	{
		XEvent ev;
		
		XNextEvent(x->display, &ev);
		switch(ev.type)
		{
			case MapNotify:
				mapped = 1;
				break;
		}
	} while(!mapped);

	if (!mapped)
		goto err_free_font;

	x->mousein = TTRUE;

	return (TAPTR) x;

	
err_free_font:

	if (x->font)
	{
		XFreeFont(x->display, x->font);
	}
	
	XCloseDisplay(x->display);

err_free:

	kn_free(x);

err_return:

	return TNULL;
}




TVOID kn_destroyvisual(TAPTR v)
{
	VisualX *x = (VisualX*) v;

	if (x->image)
	{
		x->image->data = NULL;
		XDestroyImage(x->image);
	}


	XUnmapWindow(x->display, x->win);
	
	XFreeGC(x->display, x->gc);
	
	XDestroyWindow(x->display, x->win);
	
	if (x->font)
		XFreeFont(x->display, x->font);
	
	XCloseDisplay(x->display);
	
	kn_free(x);
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

TBOOL kn_getnextinput(TAPTR visual, TIMSG *newimsg, TUINT eventmask)
{	
	VisualX *x = (VisualX*) visual;
	XEvent ev;
	int i;

	if ((i = XEventsQueued(x->display, QueuedAfterFlush)))
	{
		while(i--)
		{
			XNextEvent(x->display, &ev);

			dbvprintf1(1,"event: %s\n", eventname(ev.type));
			
			newimsg->qualifier = TKEYQUAL_NONE;

			switch(ev.type)
			{
			#if 0
				case LeaveNotify:
					x->mousein = TFALSE;
					break;

				case EnterNotify:
					x->mousein = TTRUE;
					break;
			#endif
			
				case FocusIn:
					if (eventmask & TITYPE_VISUAL_FOCUS)
					{
						newimsg->type = TITYPE_VISUAL_FOCUS;
						return TTRUE;
					}
					break;

				case FocusOut:
					if (eventmask & TITYPE_VISUAL_UNFOCUS)
					{
						newimsg->type = TITYPE_VISUAL_UNFOCUS;
						return TTRUE;
					}
					break;
			
				case ConfigureNotify:
				
					/*dbvprintf(2,"TEKLIB kn_getnextinput: configurenotify\n");*/
				
					if ((x->width  != ((XConfigureEvent*)&ev)->width) &&
					    (x->height != ((XConfigureEvent*)&ev)->height))
					{
						kn_window_resize(x, ((XConfigureEvent*)&ev)->width, ((XConfigureEvent*)&ev)->height);
						if (eventmask & TITYPE_VISUAL_NEWSIZE)
						{
							newimsg->type = TITYPE_VISUAL_NEWSIZE;
							newimsg->mousex = (TINT) x->win_w;
							newimsg->mousey = (TINT) x->win_h;
							return TTRUE;
						}
					}
					break;

				case MotionNotify:
					if (eventmask & TITYPE_MOUSEMOVE)
					{
						newimsg->type = TITYPE_MOUSEMOVE;
						newimsg->mousex = (TINT) ((XMotionEvent*)&ev)->x;
						newimsg->mousey = (TINT) ((XMotionEvent*)&ev)->y;
						return TTRUE;
					}
					break;

				case ButtonRelease:
				case ButtonPress:
					if (eventmask & TITYPE_MOUSEBUTTON)
					{
						unsigned int button;
						newimsg->type = TITYPE_MOUSEBUTTON;
						newimsg->mousex = (TINT) ((XButtonEvent*)&ev)->x;
						newimsg->mousey = (TINT) ((XButtonEvent*)&ev)->y;

						button = ((XButtonEvent*)&ev)->button;

						if (ev.type == ButtonPress)
						{
							switch(button)
							{
								case Button1:
									newimsg->code = TMBCODE_LEFTDOWN;
									break;
								case Button2:
									newimsg->code = TMBCODE_MIDDLEDOWN;
									break;
								case Button3:
									newimsg->code = TMBCODE_RIGHTDOWN;
									break;
							}
						}
						else
						{
							switch(button)
							{
								case Button1:
									newimsg->code = TMBCODE_LEFTUP;
									break;
								case Button2:
									newimsg->code = TMBCODE_MIDDLEUP;
									break;
								case Button3:
									newimsg->code = TMBCODE_RIGHTUP;
									break;
							}
						}
						return TTRUE;
					}
					break;

				case KeyPress:
					if (eventmask & TITYPE_KEY)
					{
						KeySym keysym;
						XComposeStatus compose;
						char buffer[10];
						XLookupString((XKeyEvent*)&ev,buffer,10,&keysym,&compose);

						if (((signed)keysym) < 0x100)
						{
							/* normal ascii */
							/*newimsg->code = (TUINT) ((XKeyEvent*)&ev)->keycode;*/
							newimsg->code = keysym;
						}
						else if ((keysym >= XK_F1) && (keysym <= XK_F12))
						{
							newimsg->code = (TUINT) (keysym-XK_F1 + TKEYCODE_F1);
						}
						else
						{
							switch(keysym)
							{
								case XK_Left:
									newimsg->code = TKEYCODE_CRSRLEFT;
									break;
								case XK_Right:
									newimsg->code = TKEYCODE_CRSRRIGHT;
									break;
								case XK_Up:
									newimsg->code = TKEYCODE_CRSRUP;
									break;
								case XK_Down:
									newimsg->code = TKEYCODE_CRSRDOWN;
									break;
									
								case XK_Escape:
									newimsg->code = TKEYCODE_ESC;
									break;
								case XK_Delete:
									newimsg->code = TKEYCODE_DEL;
									break;
								case XK_BackSpace:
									newimsg->code = TKEYCODE_BCKSPC;
									break;
								case XK_Tab:
									newimsg->code = TKEYCODE_TAB;
									break;
								case XK_Return:
									newimsg->code = TKEYCODE_ENTER;
									break;
									
								case XK_Help:
									newimsg->code = TKEYCODE_HELP;
									break;
								case XK_Insert:
									newimsg->code = TKEYCODE_INSERT;
									break;
									/* ?? newimsg->code = TKEYCODE_OVERWRITE; ?? */
								case XK_Page_Up:
									newimsg->code = TKEYCODE_PAGEUP;
									break;
								case XK_Page_Down:
									newimsg->code = TKEYCODE_PAGEDOWN;
									break;
								case XK_Begin:
									newimsg->code = TKEYCODE_POSONE;
									break;
								case XK_End:
									newimsg->code = TKEYCODE_POSEND;
									break;
								case XK_Print: 
									newimsg->code = TKEYCODE_PRINT;
									break;
								case XK_Scroll_Lock:
									newimsg->code = TKEYCODE_SCROLL;
									break;
								case XK_Pause:
									newimsg->code = TKEYCODE_PAUSE;
									break;
									
								case XK_KP_0:
									newimsg->code = 48;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_1:
									newimsg->code = 49;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_2:
									newimsg->code = 50;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_3:
									newimsg->code = 51;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_4:
									newimsg->code = 52;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_5:
									newimsg->code = 53;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_6:
									newimsg->code = 54;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_7:
									newimsg->code = 55;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_8:
									newimsg->code = 56;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_9:
									newimsg->code = 57;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_Enter:
									newimsg->code = 13;
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_Decimal:
									newimsg->code = '.';
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_Add:
									newimsg->code = '+';
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_Subtract:
									newimsg->code = '-';
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_Multiply:
									newimsg->code = '*';
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								case XK_KP_Divide:
									newimsg->code = '/';
									newimsg->qualifier = TKEYQUAL_NUMBLOCK;
									break;
								
								default:
									newimsg->code = 0;
							}
						}

						if (newimsg->code)
						{
							newimsg->type = TITYPE_KEY;
							newimsg->mousex = (TINT) ((XKeyEvent*)&ev)->x;
							newimsg->mousey = (TINT) ((XKeyEvent*)&ev)->y;
							return TTRUE;
						}
						else
						{
							return TFALSE;
						}
					}
					break;

				case ClientMessage:
					if ( ((XClientMessageEvent*)&ev)->data.l[0] == x->atom_wm_delete_win )
					{
						newimsg->type = TITYPE_VISUAL_CLOSE;
						return TTRUE;
					}
					break;

				default:
					/*TDebug( TLog(get_loglevel(), "getnextinput:event not handled") );*/
					return TFALSE;
			}
		}
	}
	
	return TFALSE;
}



/*
**	kn_setinputmask(visual, inputmask)
**
**	set a new mask of input events to be reported
**	
*/

TVOID kn_setinputmask(TAPTR v, TUINT eventmask)
{
	VisualX *x = (VisualX*) v;
	long x11_mask = 0;
	
	if (eventmask & (TITYPE_VISUAL_FOCUS|TITYPE_VISUAL_UNFOCUS))   x11_mask |= FocusChangeMask;
	if (eventmask & TITYPE_VISUAL_NEWSIZE) x11_mask |= StructureNotifyMask;
	if (eventmask & TITYPE_KEY)            x11_mask |= KeyPressMask;
	if (eventmask & TITYPE_MOUSEMOVE)      x11_mask |= PointerMotionMask|OwnerGrabButtonMask|ButtonMotionMask|ButtonPressMask|ButtonReleaseMask/*|LeaveWindowMask|EnterWindowMask*/;
	if (eventmask & TITYPE_MOUSEBUTTON)    x11_mask |= ButtonPressMask|ButtonReleaseMask|OwnerGrabButtonMask;

	if ((x->mask & TITYPE_MOUSEMOVE) &&
	    ((x11_mask & ~(TITYPE_MOUSEMOVE))))
	{
		/* flush pending motion events */
		
		XEvent ev;

		while (XCheckTypedWindowEvent(x->display, x->win, MotionNotify, &ev));
	}
	
	x->mask = x->base_mask | x11_mask;
	
	XSelectInput(x->display, x->win, x->mask);
	XFlush(x->display);
}





/*
**	pen = kn_allocpen(visual, pen-nr, rgbcolor)
**
**	allocate a coloured pen (rgbcolor format: 0x00rrggbb).
**	0xffffffff if out of pens.
*/

TVPEN kn_allocpen(TAPTR visual, TUINT rgb)
{
	VisualX *x = (VisualX *) visual;
	XColor color;

	color.red =   ((rgb >> 16) & 0xFF) << 8;
	color.green = ((rgb >> 8)  & 0xFF) << 8;
	color.blue =  ((rgb)       & 0XFF) << 8;
	color.flags = DoRed | DoGreen | DoBlue;
	
	if (!XAllocColor(x->display, x->colormap, &color))
	{
		return (TVPEN) 0xffffffff;
	}
	
	return (TVPEN) color.pixel;
}


/*
**	kn_freepen(visual, pen-nr)
**
**	free a coloured pen
*/

TVOID kn_freepen(TAPTR visual, TVPEN pen)
{
	VisualX *x = (VisualX *) visual;
	unsigned long color = (unsigned long) pen;
	XFreeColors(x->display, x->colormap, &color, 1, 0);		/* what's the last argument for? */
}


/*
**	kn_setbgpen(visual, pen)
**
**	set background pen
*/

TVOID kn_setbgpen(TAPTR visual, TVPEN pen)
{
	VisualX *x = (VisualX*) visual;
	XGCValues gcv;
	
	gcv.background = (long) pen;

	XChangeGC(x->display, x->gc, GCBackground, &gcv);
}


/*
**	kn_setfgpen(visual, pen)
**
**	set foreground pen
*/

TVOID kn_setfgpen(TAPTR visual, TVPEN pen)
{
	VisualX *x = (VisualX*) visual;
	XGCValues gcv;
	
	gcv.foreground = (long) pen;

	XChangeGC(x->display, x->gc, GCForeground, &gcv);
}


/*
**	kn_line(visual, x,y,x2,y2)
**
**	line
*/

TVOID kn_line(TAPTR visual, TINT x1, TINT y1, TINT x2, TINT y2)
{
	VisualX *x = (VisualX*) visual;
	XDrawLine(x->display, x->win, x->gc, x1, y1, x2, y2);
}



/*
**	kn_frect(visual, x, y, w, h)
**
**	filled rectangle
*/

TVOID kn_frect(TAPTR v, TINT x1, TINT y1, TINT w, TINT h)
{
	VisualX *x = (VisualX*) v;
	XFillRectangle(x->display, x->win, x->gc, x1, y1, w, h);
}



/*
**	kn_rect(visual, x, y, w, h)
**
**	outline rectangle
*/

TVOID kn_rect(TAPTR v, TINT x1, TINT y1, TINT w, TINT h)
{
	VisualX *x = (VisualX*) v;
	XDrawRectangle(x->display, x->win, x->gc, x1, y1, w, h);
}


/*
**	kn_plot(visual, x, y)
**
**	plot
*/

TVOID kn_plot(TAPTR v, TINT x1, TINT y1)
{
	VisualX *x = (VisualX*) v;
	XDrawPoint(x->display, x->win, x->gc, x1, y1);
}



/*
**	kn_getparameters(visual, visualparameters)
**
**	fill a visual parameters structure
*/

TVOID kn_getparameters(TAPTR v, struct knvisual_parameters *p)
{
	VisualX *x = (VisualX*) v;
	p->pixelwidth = (TUINT) x->win_w;
	p->pixelheight = (TUINT) x->win_h;
	p->textwidth = (TUINT) x->text_w;
	p->textheight = (TUINT) x->text_h;
	p->fontwidth = (TUINT) x->font_w;
	p->fontheight = (TUINT) x->font_h;
}



/*
**	kn_scroll(visual, x, y, w, h, dx, dy)
**
**	scroll rectangle
**	
*/

TVOID kn_scroll(TAPTR v, TINT posx, TINT posy, TINT w, TINT h, TINT dx, TINT dy)
{
	VisualX *x = (VisualX*) v;
	XCopyArea(x->display, x->win, x->win, x->gc, (int)posx, (int)posy, (int)w, (int)h, (int)-dx, (int)-dy);
}



/*
**	kn_drawtext(visual, x, y, text, len)
**
**	write text to text cursor position
**	
*/

TVOID kn_drawtext(TAPTR v, TINT xpos, TINT ypos, TSTRPTR text, TUINT len)
{
	VisualX *x = (VisualX*) v;
	XDrawImageString(x->display, x->win, x->gc, x->font_w * xpos, x->font_h * ypos + x->font->ascent, (char *) text, len);
}



/*
**	kn_waitvisual(visual, timer, event)
**
**	wait for visual or supplied event
**	
*/

TBOOL kn_waitvisual(TAPTR v, TKNOB *timer, TKNOB *evt)
{
	TTIME delay = {0, 10000};
	VisualX *x = (VisualX*) v;
	kn_timedwaitevent(evt, timer, &delay);
	return XPending(x->display);
}



/* 
**	kn_sync	
**
*/

TVOID kn_flush(TAPTR v, TINT x, TINT y, TINT w, TINT h)
{
	XFlush(((VisualX *) v)->display);
}


/* 
**	kn_drawrgb(v, buf, x,y,w,h,totw)
**
**	draw RGB buffer
*/

TVOID kn_drawrgb(TAPTR v, TUINT *buf, TINT x, TINT y, TINT w, TINT h, TINT totwidth)
{
	VisualX *visual = (VisualX*) v;
	XImage *image;

	if (w != visual->imw || h != visual->imh)
	{
		if (visual->image)
		{
			visual->image->data = NULL;
			XDestroyImage(visual->image);
			visual->image = NULL;
			visual->imw = -1;
		}

		visual->image = XCreateImage(visual->display, visual->visual,
			visual->depth, ZPixmap, 0, (char *) buf, w, h, visual->bpp << 3, w * visual->bpp);

		if (visual->image)
		{
			visual->imw = w;
			visual->imh = h;
		}
	}
	

	if (visual->image)
	{
		int xx, yy, i;
		TUINT p;

		switch ((visual->depth << 8) + visual->pixfmt)
		{
			case (15 << 8) + PIXFMT_RGB:
				for (yy = 0; yy < h; ++yy)
				{
					for (xx = 0; xx < w; ++xx)
					{
						p = buf[xx];
						XPutPixel(visual->image, xx, yy, 
							((p & 0xf80000) >> 9) | 
							((p & 0x00f800) >> 6) |
							((p & 0x0000f8) >> 3));
					}
					buf += totwidth;
				}
				break;

			case (16 << 8) + PIXFMT_RGB:
				for (yy = 0; yy < h; ++yy)
				{
					for (xx = 0; xx < w; ++xx)
					{
						p = buf[xx];
						XPutPixel(visual->image, xx, yy, 
							((p & 0xf80000) >> 8) | 
							((p & 0x00fc00) >> 5) |
							((p & 0x0000f8) >> 3));
					}				
					buf += totwidth;
				}
				break;

			case (24 << 8) + PIXFMT_RGB:
				for (yy = 0; yy < h; ++yy)
				{
					for (xx = 0; xx < w; ++xx)
					{
						XPutPixel(visual->image, xx, yy, buf[xx]);
					}				
					buf += totwidth;
				}
				break;
		}
			
		XPutImage(visual->display, visual->win, visual->gc, visual->image, 0, 0, x, y, w, h);
	}

}

