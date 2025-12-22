/*
** SDL display adapter Hollywood plugin
** Copyright (C) 2014-2017 Andreas Falkenhahn <andreas@airsoftsoftwair.de>
**
** Permission is hereby granted, free of charge, to any person obtaining a copy
** of this software and associated documentation files (the "Software"), to deal
** in the Software without restriction, including without limitation the rights
** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
** copies of the Software, and to permit persons to whom the Software is
** furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included in
** all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
** SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
** NOTE: This is just a very basic example that shows how to replace Hollywood's
** inbuilt display adapter with a *minimal* custom display adapter (here based on
** SDL). It is not optimized in any way and only the most basic functionality has
** been implemented. Its aim is to get you started with writing custom display
** adapters, that's why this plugin has been kept as simple as possible to make
** it easy to understand the code.
**
** Once you have understood this plugin, here are some ideas how you can optimize
** it:
**
** 1) Add support for hardware double buffers
** 2) Add support for video bitmaps that can be drawn to hardware double buffers
** 3) Add support for scaling and transforming video bitmaps using the GPU
** 4) Add support for offscreen drawing to video bitmaps
** 5) Add audio support through SDL
** ...
**
** RebelSDL can do all that and in fact this plugin is nothing else than a cut-down
** version of RebelSDL so as a little exercise you can try to implement all features
** that have been cut from this plugin :-)
*/

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <ctype.h>

#include <SDL.h>

#include <hollywood/errors.h>
#include <hollywood/plugin.h>

#include "keymap.h"
#include "plugin.h"
#include "version.h"

// this is a trick to force the optimizer to preserve our version string
static const char plugin_name[] = PLUGIN_NAME "\0$VER: " PLUGIN_MODULENAME ".hwp " PLUGIN_VER_STR " (" PLUGIN_DATE ") [" PLUGIN_PLAT "]";
static const char plugin_modulename[] = PLUGIN_MODULENAME;
static const char plugin_author[] = PLUGIN_AUTHOR;
static const char plugin_description[] = PLUGIN_DESCRIPTION;
static const char plugin_copyright[] = PLUGIN_COPYRIGHT;
static const char plugin_url[] = PLUGIN_URL;
static const char plugin_date[] = PLUGIN_DATE;

static hwPluginAPI *hwcl = NULL;
static hwPluginBase *plugin_self = NULL;

static struct sdldisplayinfo *firstdisplay = NULL;

static int mustquit = FALSE;
static int initcalled = FALSE;

static struct hwos_TimeVal lastevttime;

static int ERR_SDL, ERR_TEXTURE;

/*
** WARNING: InitPlugin() will be called by *any* Hollywood version >= 5.0. Thus, you must
** check the Hollywood version that called your InitPlugin() implementation before calling
** functions from the hwPluginAPI pointer or accessing certain structure members. Your
** InitPlugin() implementation must be compatible with *any* Hollywood version >= 5.0. If
** you call Hollywood 6.0 functions here without checking first that Hollywood 6.0 or higher
** has called your InitPlugin() implementation, *all* programs compiled with Hollywood
** versions < 6.0 *will* crash when they try to open your plugin! 
*/
HW_EXPORT int InitPlugin(hwPluginBase *self, hwPluginAPI *cl, STRPTR path)
{
	// see note above
	if(self->hwVersion < 6) return FALSE;
	
	// identify as a display adapter plugin to Hollywood	
	self->CapsMask = HWPLUG_CAPS_DISPLAYADAPTER|HWPLUG_CAPS_REQUIRE;
	self->Version = PLUGIN_VER;
	self->Revision = PLUGIN_REV;
	
	// require at least Hollywood 6.0
	self->hwVersion = 6;
	self->hwRevision = 0;
	
	// set plugin information; note that these string pointers need to stay
	// valid until Hollywood calls ClosePlugin()		
	self->Name = (STRPTR) plugin_name;
	self->ModuleName = (STRPTR) plugin_modulename;
	self->Author = (STRPTR) plugin_author;
	self->Description = (STRPTR) plugin_description;
	self->Copyright = (STRPTR) plugin_copyright;
	self->URL = (STRPTR) plugin_url;
	self->Date = (STRPTR) plugin_date;
	self->Settings = NULL;
	self->HelpFile = NULL;

	// NB: "cl" can be NULL in case Hollywood or Designer just wants to obtain information
	// about our plugin	
	if(cl) {
		
		hwcl = cl;
		
		ERR_SDL = hwcl->SysBase->hw_RegisterError("Error initializing SDL!");	
		ERR_TEXTURE = hwcl->SysBase->hw_RegisterError("Error creating texture!");				
		plugin_self = self;
	}
	
	return TRUE;
}

/*
** WARNING: ClosePlugin() will be called by *any* Hollywood version >= 5.0.
** --> see the note above in InitPlugin() for information on how to implement this function
*/
HW_EXPORT void ClosePlugin(void)
{
	if(initcalled) SDL_Quit();
}
	
/*
** Because we have set HWPLUG_CAPS_REQUIRE, this function will be called whenever the user @REQUIREs our plugin
*/				
HW_EXPORT int RequirePlugin(lua_State *L, int version, int revision, ULONG flags, struct hwTagList *tags)
{
	struct hwTagList t[10];	
	int error, c = 0;

	// we only need video and timer functionality
	if(SDL_Init(SDL_INIT_VIDEO|SDL_INIT_TIMER) != 0) return ERR_SDL;

	initcalled = TRUE;
								
	t[c].Tag = HWSDATAG_PIXELFORMAT;
	t[c++].Data.iData = HWSDLPLUG_PIXFMT;			
	t[c].Tag = 0;
			
	// this function does all the magic: it replaces Hollywood's inbuilt display adapter with the one
	// provided by this plugin; see the SDK manual for more information on the individual parameters		
	error = hwcl->GfxBase->hw_SetDisplayAdapter(plugin_self, HWSDAFLAGS_PERMANENT|HWSDAFLAGS_CUSTOMSCALING|HWSDAFLAGS_ALPHADRAW|HWSDAFLAGS_MONITORINFO, t);
	if(error) return error;
			
	hwcl->SysBase->hw_GetSysTime(&lastevttime);
		
	return 0;
}

static struct sdldisplayinfo *getdisplayhandle(ULONG id)
{
	SDL_Window *window = SDL_GetWindowFromID(id);
	struct sdldisplayinfo *sdlw = NULL;
	
	if(window) sdlw = SDL_GetWindowData(window, "sdlw");
		
	return sdlw;
}

#define GETDISPLAYHANDLE if(!(sdlw = getdisplayhandle(se.motion.windowID))) break;	
	
/*
** This function polls all events from SDL, converts them into Hollywood events,
** and posts them to Hollywood's event queue
*/	
HW_EXPORT int HandleEvents(lua_State *L, ULONG flags, struct hwTagList *tags)
{
	SDL_Event se;
	int error;
	struct sdldisplayinfo *sdlw;
	struct hwos_TimeVal nowt;               
	int doevents;

	// it is important to call into the master server to give Hollywood a chance to update asynchronous tasks
	error = hwcl->SysBase->hw_MasterServer(L, HWMSFLAGS_DRAWVIDEOS, NULL);
	if(error) return error;																
	
	hwcl->SysBase->hw_GetSysTime(&nowt);
	hwcl->SysBase->hw_SubTime(&nowt, &lastevttime);
	
	// avoid aggressive polling because it kills the performance on Mac OS X; polling 100 times per second is enough
	doevents = (nowt.tv_secs > 0 || nowt.tv_micro >= 10000);
	
	if(!doevents) goto exit_handleevents;
			
	while(SDL_PollEvent(&se)) {
		
		switch(se.type) {
		case SDL_MOUSEMOTION: {
			struct hwEvtMouse e;
				
			GETDISPLAYHANDLE
							
			memset(&e, 0, sizeof(struct hwEvtMouse));

			e.Handle = sdlw;
		 	e.X = se.motion.x;
	 		e.Y = se.motion.y;
 	
			error = hwcl->SysBase->hw_PostEventEx(sdlw->L, HWEVT_MOUSE, &e, NULL);						
			if(error) return error;
			break;
			}
			
		case SDL_MOUSEBUTTONDOWN:
		case SDL_MOUSEBUTTONUP: {
			struct hwEvtMouse e;			
							
			GETDISPLAYHANDLE
			
			memset(&e, 0, sizeof(struct hwEvtMouse));
			e.Button = -1;

			switch(se.button.button) {	
			case SDL_BUTTON_LEFT:
				e.Button = HWMBTYPE_LEFT;
				break;
			case SDL_BUTTON_RIGHT:
				e.Button = HWMBTYPE_RIGHT;
				break;
			case SDL_BUTTON_MIDDLE:
				e.Button = HWMBTYPE_MIDDLE;
				break;
			}
					
			if(e.Button != -1) {
		
				e.Handle = sdlw;
				e.Down = (se.button.state == SDL_PRESSED);				
			 	e.X = se.button.x;
		 		e.Y = se.button.y;
 	
				error = hwcl->SysBase->hw_PostEventEx(sdlw->L, HWEVT_MOUSE, &e, NULL);							
				if(error) return error;
			}
			
			SDL_CaptureMouse((se.type == SDL_MOUSEBUTTONDOWN));
			break;
			}
			
		case SDL_KEYDOWN:
		case SDL_KEYUP: {
			struct hwEvtKeyboard e;
			int k;
			int key = se.key.keysym.sym;
										
			GETDISPLAYHANDLE
				
			memset(&e, 0, sizeof(struct hwEvtKeyboard));
			e.ID = -1;
	
			e.Qualifiers = HWKEY_QUAL_MASK;
			if(se.key.keysym.mod & KMOD_LSHIFT) e.Qualifiers |= HWKEY_QUAL_LSHIFT;
			if(se.key.keysym.mod & KMOD_LALT) e.Qualifiers |= HWKEY_QUAL_LALT;	
			if(se.key.keysym.mod & KMOD_LGUI) e.Qualifiers |= HWKEY_QUAL_LCOMMAND;
			if(se.key.keysym.mod & KMOD_LCTRL) e.Qualifiers |= HWKEY_QUAL_LCONTROL;
			if(se.key.keysym.mod & KMOD_RSHIFT) e.Qualifiers |= HWKEY_QUAL_RSHIFT;
			if(se.key.keysym.mod & KMOD_RALT) e.Qualifiers |= HWKEY_QUAL_RALT;	
			if(se.key.keysym.mod & KMOD_RGUI) e.Qualifiers |= HWKEY_QUAL_RCOMMAND;
			if(se.key.keysym.mod & KMOD_RCTRL) e.Qualifiers |= HWKEY_QUAL_RCONTROL;
				
			sdlw->qualifiers = e.Qualifiers;
			
			for(k = 0; keymap[k].hwkey; k++) {
		
				if(key == keymap[k].sdlkey) {
					e.ID = keymap[k].hwkey;
					break;
				}	
			}	
	
			if(e.ID == -1 && ((key >= '0' && key <= '9') || (key >= 'a' && key <= 'z'))) e.ID = key;	
			
			if(e.ID != -1) {				
				if((e.ID >= 'a' && e.ID <= 'z') && (se.key.keysym.mod & KMOD_SHIFT)) e.ID = toupper(e.ID);
				e.Handle = sdlw;
				e.Down = (se.key.state == SDL_PRESSED);
				
				error = hwcl->SysBase->hw_PostEventEx(sdlw->L, HWEVT_KEYBOARD, &e, NULL);		
				if(error) return error;				
			}							
			break;
			}
		
		case SDL_TEXTINPUT:
			// must make sure that we have at least Hollywood 7 because earlier versions don't
			// support HWEVT_VANILLAKEY
			if(hwcl->hwVersion > 6) {
	
				struct hwEvtKeyboard e;
				int k, i = 0;
				
				GETDISPLAYHANDLE
				
				for(k = 0; k < (int) hwcl->UnicodeBase->strlen(se.text.text); k++) {
									
					memset(&e, 0, sizeof(struct hwEvtKeyboard));
					e.Handle = sdlw;
					e.ID = hwcl->UnicodeBase->getnextchar(se.text.text, &i);
				}
					
				error = hwcl->SysBase->hw_PostEventEx(sdlw->L, HWEVT_VANILLAKEY, &e, NULL);				
				if(error) return error;
			}
			break;
								
		case SDL_WINDOWEVENT: {			
			if(!(sdlw = getdisplayhandle(se.window.windowID))) break;

			switch(se.window.event) {
			case SDL_WINDOWEVENT_CLOSE: {
				struct hwEvtCloseDisplay e;
		
				memset(&e, 0, sizeof(struct hwEvtCloseDisplay));
	
				e.Handle = sdlw;
		
				error = hwcl->SysBase->hw_PostEventEx(sdlw->L, HWEVT_CLOSEDISPLAY, &e, NULL);
				if(error) return error;			

				if(!sdlw->userclose) mustquit = TRUE;					
				break;
				}
				
			case SDL_WINDOWEVENT_SHOWN:
			case SDL_WINDOWEVENT_HIDDEN:
			case SDL_WINDOWEVENT_MINIMIZED:
			case SDL_WINDOWEVENT_RESTORED: {
				struct hwEvtShowHideDisplay e;
						
				memset(&e, 0, sizeof(struct hwEvtShowHideDisplay));
	
				e.Handle = sdlw;
				e.Show = (se.window.event == SDL_WINDOWEVENT_SHOWN || se.window.event == SDL_WINDOWEVENT_RESTORED);
		
				error = hwcl->SysBase->hw_PostEventEx(sdlw->L, HWEVT_SHOWHIDEDISPLAY, &e, NULL);			
				if(error) return error;				
				break;
				}	
				
			case SDL_WINDOWEVENT_MOVED: {
				struct hwEvtMoveDisplay e;
		
				memset(&e, 0, sizeof(struct hwEvtMoveDisplay));
	
				e.Handle = sdlw;
				e.X = se.window.data1;
				e.Y = se.window.data2;
		
				error = hwcl->SysBase->hw_PostEventEx(sdlw->L, HWEVT_MOVEDISPLAY, &e, NULL);			
				if(error) return error;				
				break;
				}	
				
			case SDL_WINDOWEVENT_RESIZED:
				// when in fullscreen mode, we'll get a size message in case SDL changed to a screen mode that
				// isn't identical with the dimensions passed to SDL_CreateWindow(), e.g. passing 360x284
				// to SDL_CreateWindow() leads to a 640x480 fullscreen mode on Mac OS X and a resize message
				// ---> don't forward this message to Hollywood!
				if(!(sdlw->flags & SDL_WINDOW_FULLSCREEN)) {
					
					struct hwEvtSizeDisplay e;	
	
					memset(&e, 0, sizeof(struct hwEvtSizeDisplay));
	
					e.Handle = sdlw;
					e.Width = se.window.data1;
					e.Height = se.window.data2;
					
					error = hwcl->SysBase->hw_PostEventEx(sdlw->L, HWEVT_SIZEDISPLAY, &e, NULL);
					if(error) return error;					
				}
				break;
				
			case SDL_WINDOWEVENT_FOCUS_GAINED:
			case SDL_WINDOWEVENT_FOCUS_LOST: {
				struct hwEvtFocusChangeDisplay e;
		
				memset(&e, 0, sizeof(struct hwEvtFocusChangeDisplay));
	
				e.Handle = sdlw;
				e.Focus = (se.window.event == SDL_WINDOWEVENT_FOCUS_GAINED);
		
				error = hwcl->SysBase->hw_PostEventEx(sdlw->L, HWEVT_FOCUSCHANGEDISPLAY, &e, NULL);						
				if(error) return error;
				break;
				}

			case SDL_WINDOWEVENT_EXPOSED:
				hwcl->GfxBase->hw_RefreshDisplay(sdlw, 0, NULL); 					
				break;							
			}		
			break;
			}							
		}	
	}
	
	hwcl->SysBase->hw_GetSysTime(&lastevttime);	

exit_handleevents:					
	return (mustquit) ? ERR_USERABORT : 0;
}
	
// Wait for events to arrive	
HW_EXPORT int WaitEvents(lua_State *L, ULONG flags, struct hwTagList *tags)
{
	SDL_WaitEvent(NULL);

	return 0;
}

// Note that this function might be called from a different thread
HW_EXPORT void ForceEventLoopIteration(struct hwTagList *tags)
{	
	SDL_Event dummy;

	memset(&dummy, 0, sizeof(SDL_Event));
	dummy.type = SDL_USEREVENT;
	
	SDL_PushEvent(&dummy);		
}	

// SDL doesn't allow us to determine border sizes so simply set them to 0		
HW_EXPORT void DetermineBorderSizes(ULONG flags, int *left, int *right, int *top, int *bottom)
{
	*left = 0;
	*right = 0;
	*top = 0;
	*bottom = 0;
}

/*
** We draw all graphics we receive from Hollywood into a back buffer. Whenever a frame needs to be drawn,
** we'll push the back buffer contents into an SDL texture and then draw the texture. Both, the back
** buffer and the texture, are allocated by this function
*/
static int setupbackbuffer(struct sdldisplayinfo *sdlw, int width, int height)
{
	if(sdlw->pbtexture) {
		SDL_DestroyTexture(sdlw->pbtexture);
		sdlw->pbtexture = NULL;
	}
	
	if(sdlw->pixbuf) {		
		free(sdlw->pixbuf);
		sdlw->pixbuf = NULL;
	}	
	
	// back buffer is just a raw memory buffer	
	if(!(sdlw->pixbuf = malloc(width * height * 4))) return ERR_MEM;
	
	if(sdlw->scalemode) SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "linear");					
	
	// make sure to allocate a streaming texture because we need to be able to update its contents
	if(!(sdlw->pbtexture = SDL_CreateTexture(sdlw->renderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, width, height))) {
		free(sdlw->pixbuf);
		sdlw->pixbuf = NULL;
		return ERR_TEXTURE;
	}
		
	if(sdlw->scalemode) SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "nearest");					
		
	sdlw->bufferwidth = width;
	sdlw->bufferheight = height;
				
	return 0;
}
	
// Open a new display
HW_EXPORT APTR OpenDisplay(STRPTR title, int x, int y, int width, int height, ULONG flags, struct hwTagList *tags)
{
	struct sdldisplayinfo *sdlw = NULL, *prev = NULL;
	int k, bufferwidth = 0, bufferheight = 0, scalemode = 0, error;
	lua_State *L = NULL;
	ULONG sdlflags = 0;

	for(sdlw = firstdisplay; sdlw; sdlw = sdlw->succ) prev = sdlw;
		
	// parse tag list Hollywood has passed to us	
	for(k = 0; tags[k].Tag; k++) {
		
		switch(tags[k].Tag) {
		case HWDISPTAG_BUFFERWIDTH:
			bufferwidth = tags[k].Data.iData;
			break;
		case HWDISPTAG_BUFFERHEIGHT:
			bufferheight = tags[k].Data.iData;
			break;
		case HWDISPTAG_LUASTATE:
			L = tags[k].Data.pData;
			break;	
		case HWDISPTAG_SCALEMODE:
			scalemode = tags[k].Data.iData;
			break;	
		}	
	}
	
	if(!bufferwidth || !bufferheight) return NULL;
			
	if(!(sdlw = (struct sdldisplayinfo *) calloc(sizeof(struct sdldisplayinfo), 1))) return NULL;
	
	sdlw->L = L;		
	sdlw->width = width;
	sdlw->height = height;
	sdlw->bufferwidth = bufferwidth;
	sdlw->bufferheight = bufferheight;
	sdlw->scalemode = scalemode;

	// handle different display flags
	if(flags & HWDISPFLAGS_FULLSCREEN) {	
		sdlflags |= SDL_WINDOW_FULLSCREEN;		
	} else {		
		if(flags & HWDISPFLAGS_SIZEABLE) sdlflags |= SDL_WINDOW_RESIZABLE;
		if(flags & HWDISPFLAGS_BORDERLESS) sdlflags |= SDL_WINDOW_BORDERLESS;
	}
		
	// create window and renderer	
	if(!(sdlw->window = SDL_CreateWindow(title, x, y, width, height, sdlflags))) goto error_opendisplay;			
	if(!(sdlw->renderer = SDL_CreateRenderer(sdlw->window, -1, SDL_RENDERER_PRESENTVSYNC))) goto error_opendisplay;

	// stuff pointer to self into our SDL window's data cookie
	SDL_SetWindowData(sdlw->window, "sdlw", sdlw);
		
	// allocate back buffer and texture	
	error = setupbackbuffer(sdlw, bufferwidth, bufferheight);
	if(error) goto error_opendisplay;
		
	// tell Hollywood that our drawing is expensive which is why we prefer to draw large parts
	// in low frequency than small parts in high frequency (see SDK documentation for details)
	for(k = 0; tags[k].Tag; k++) {
		
		switch(tags[k].Tag) {
		case HWDISPTAG_OPTIMIZEDREFRESH:
		case HWDISPTAG_SINGLEREFRESHFX:	
			*((int *) tags[k].Data.pData) = TRUE;
			break;
		}
	}
		
	sdlw->flags = sdlflags;
	
	if(prev) {
		prev->succ = sdlw;
	} else {
		firstdisplay = sdlw;
	}
											
	return sdlw;
	
error_opendisplay:
	if(sdlw->renderer) SDL_DestroyRenderer(sdlw->renderer);
	if(sdlw->window) SDL_DestroyWindow(sdlw->window);		
	
	free(sdlw);
	
	return NULL;		
}
	
// Close a display	
HW_EXPORT int CloseDisplay(APTR handle)
{
	struct sdldisplayinfo *sdlw, *prev = NULL;
	
	for(sdlw = firstdisplay; sdlw; sdlw = sdlw->succ) {
		
		if(sdlw == (struct sdldisplayinfo *) handle) {
	
			SDL_DestroyTexture(sdlw->pbtexture);
			SDL_DestroyRenderer(sdlw->renderer);
			SDL_DestroyWindow(sdlw->window);
						
			free(sdlw->pixbuf);
			
			if(prev) {
				prev->succ = sdlw->succ;
			} else {
				firstdisplay = sdlw->succ;
			}		
			
			free(sdlw);
			
			return 0;
		}
		
		prev = sdlw;
	}	
		
	return 0;
}
	
/*
** Hollywood will call this function whenever the dimensions of the back buffer change; in
** that case we have to re-allocate it!
*/					
HW_EXPORT int ChangeBufferSize(APTR handle, int width, int height, ULONG flags, struct hwTagList *tags)
{	
	return setupbackbuffer((struct sdldisplayinfo *) handle, width, height);
}
				
HW_EXPORT int ShowHideDisplay(APTR handle, int show, struct hwTagList *tags)
{	
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;

	if(show) {
		SDL_RestoreWindow(sdlw->window);
	} else {
		SDL_MinimizeWindow(sdlw->window);
	}
			
	return 0;
}
	
HW_EXPORT int SizeMoveDisplay(APTR handle, int x, int y, int width, int height, ULONG flags, struct hwTagList *tags)
{	
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;
	
	SDL_SetWindowSize(sdlw->window, width, height);
	SDL_SetWindowPosition(sdlw->window, x, y);
		
	return 0;
}
	
HW_EXPORT void SetDisplayTitle(APTR handle, STRPTR title)
{
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;
	
	SDL_SetWindowTitle(sdlw->window, title);	
}	

HW_EXPORT void ActivateDisplay(APTR handle, ULONG flags)
{
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;
	
	SDL_RaiseWindow(sdlw->window);	
}
	
HW_EXPORT int SetDisplayAttributes(APTR handle, struct hwTagList *tags)
{		
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;
	int k;
	
	for(k = 0; tags[k].Tag; k++) {
		
		switch(tags[k].Tag) {
		case HWDISPSATAG_USERCLOSE:
			sdlw->userclose = tags[k].Data.iData;
			break;
		}
	}
			
	return 0;
}	

// Changing the mouse pointer is not supported to keep this plugin as simple as possible
HW_EXPORT APTR CreatePointer(ULONG *rgb, int hx, int hy, int *width, int *height, struct hwTagList *tags)
{	
	return NULL;
}
	
HW_EXPORT void FreePointer(APTR handle)
{
}
	
HW_EXPORT void SetPointer(APTR handle, int type, APTR data)
{
}
	
HW_EXPORT void ShowHidePointer(APTR handle, int show)
{
	SDL_ShowCursor(show);
}
	
HW_EXPORT void MovePointer(APTR handle, int x, int y)
{
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;
	
	SDL_WarpMouseInWindow(sdlw->window, x, y);	
}
	
HW_EXPORT void GetMousePos(APTR handle, int *mx, int *my)
{		
	SDL_GetMouseState(mx, my);	
}

HW_EXPORT ULONG GetQualifiers(APTR handle)
{
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;
	
	return sdlw->qualifiers;
}
	
/*
** This function uploads the contents of the back buffer into a texture which is then brought
** to the screen by using SDL_RenderCopy()
*/	
static void refreshdisplay(APTR handle, ULONG *pixbuf, int x, int y, int width, int height, int scalewidth, int scaleheight, int scalemode, int pbwidth)
{
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;

	SDL_SetRenderTarget(sdlw->renderer, NULL);
	SDL_UpdateTexture(sdlw->pbtexture, NULL, sdlw->pixbuf, sdlw->bufferwidth * 4);
	SDL_RenderCopy(sdlw->renderer, sdlw->pbtexture, NULL, NULL);		
	SDL_RenderPresent(sdlw->renderer);		
}

// Draw bitmap graphics
HW_EXPORT void BltBitMap(APTR bmap, APTR handle, struct hwBltBitMapCtrl *ctrl, ULONG flags, struct hwTagList *tags)
{
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;	
	struct hwos_LockBitMapStruct lbm;
	APTR lock;
	ULONG *pixbuf = NULL;
	int pbwidth = 0;

	if(!(lock = hwcl->GfxBase->hw_LockBitMap(bmap, 0, &lbm, NULL))) return;
	
	// only draw to back buffer if HWBBFLAGS_IGNOREBKBUFFER isn't set	
	if(!(flags & HWBBFLAGS_IGNOREBKBUFFER)) {

		ULONG *src;
		ULONG *dst = sdlw->pixbuf;
		int x, y;

		src = (ULONG *) lbm.Data;

		src += ctrl->SrcY * lbm.Modulo;
		dst += ctrl->DstY * sdlw->bufferwidth;
	
		for(y = 0; y < ctrl->Height; y++) {

			src += ctrl->SrcX;
			dst += ctrl->DstX;
					
			for(x = 0; x < ctrl->Width; x++) *dst++ = *src++;
		
			src += (lbm.Modulo - ctrl->Width - ctrl->SrcX);
			dst += sdlw->bufferwidth - ctrl->Width - ctrl->DstX;
		}

		hwcl->GfxBase->hw_UnLockBitMap(lock);

	} else {

		pixbuf = (ULONG *) lbm.Data;
		pbwidth = lbm.Modulo;
	}

	// draw to window
	refreshdisplay(handle, pixbuf, ctrl->DstX, ctrl->DstY, ctrl->Width, ctrl->Height, ctrl->ScaleWidth, ctrl->ScaleHeight, ctrl->ScaleMode, pbwidth);

	if(flags & HWBBFLAGS_IGNOREBKBUFFER) hwcl->GfxBase->hw_UnLockBitMap(lock);	
}
	
// Draw a filled rectangle						
HW_EXPORT void RectFill(APTR handle, int x, int y, int width, int height, ULONG color, ULONG flags, struct hwTagList *tags)
{
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;	
	struct hwTagList t[10];
		
	t[0].Tag = HWRRFTAG_DSTWIDTH;
	t[0].Data.iData = sdlw->bufferwidth;
	t[1].Tag = HWRRFTAG_PIXFMT;
	t[1].Data.iData = HWSDLPLUG_PIXFMT;
	t[2].Tag = 0;
	
	// draw to back buffer
	hwcl->GfxBase->hw_RawRectFill(sdlw->pixbuf, x, y, width, height, color, HWRRFFLAGS_BLEND, t);
	
	// draw to window			
	refreshdisplay(handle, NULL, x, y, width, height, 0, 0, 0, 0);		
}
	
// Draw a single pixel	
HW_EXPORT void WritePixel(APTR handle, int x, int y, ULONG color, ULONG flags, struct hwTagList *tags)
{
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;
	struct hwTagList t[10];
		
	t[0].Tag = HWRWPTAG_DSTWIDTH;
	t[0].Data.iData = sdlw->bufferwidth;
	t[1].Tag = HWRWPTAG_PIXFMT;
	t[1].Data.iData = HWSDLPLUG_PIXFMT;
	t[2].Tag = 0;
	
	// draw to back buffer	
	hwcl->GfxBase->hw_RawWritePixel(sdlw->pixbuf, x, y, color, HWRWPFLAGS_BLEND, t);
	
	// draw to window	
	refreshdisplay(handle, NULL, x, y, 1, 1, 0, 0, 0, 0);		
}

// Draw a line
HW_EXPORT void Line(APTR handle, int x1, int y1, int x2, int y2, ULONG color, ULONG flags, struct hwTagList *tags)
{
	struct sdldisplayinfo *sdlw = (struct sdldisplayinfo *) handle;
	struct hwTagList t[10];
		
	t[0].Tag = HWRLITAG_DSTWIDTH;
	t[0].Data.iData = sdlw->bufferwidth;
	t[1].Tag = HWRLITAG_PIXFMT;
	t[1].Data.iData = HWSDLPLUG_PIXFMT;
	t[2].Tag = 0;
		
	// draw to back buffer	
	hwcl->GfxBase->hw_RawLine(sdlw->pixbuf, x1, y1, x2, y2, color, HWRLIFLAGS_BLEND, t);
	
	// draw to window	
	refreshdisplay(handle, NULL, min(x1, x2), min(y1, y2), max(x1, x2) - min(x1, x2) + 1, max(y1, y2) - min(y1, y2) + 1, 0, 0, 0, 0);	
}	 	

/*
** This function queries available monitors and display modes and makes the information
** available to Hollywood
*/
HW_EXPORT int GetMonitorInfo(int what, int monitor, APTR *data, struct hwTagList *tags)
{
	int k, count;
	
	switch(what) {
	case HWGMITYPE_MONITORS: {
		struct hwMonitorInfo *m;
		
		count = SDL_GetNumVideoDisplays();
		if(count < 1) return ERR_GETMONITORINFO;
		
		if(!(m = calloc(count + 1, sizeof(struct hwMonitorInfo)))) return ERR_MEM;
		
		for(k = 0; k < count; k++) {
			
			SDL_Rect r;
			
			SDL_GetDisplayBounds(k, &r);
			m[k].X = r.x;
			m[k].Y = r.y;
			m[k].Width = r.w;
			m[k].Height = r.h;
		}	
		
		*data = m;	
		break;
		}
	
	case HWGMITYPE_VIDEOMODES: {
		struct hwVideoModeInfo *m;
		
		count = SDL_GetNumDisplayModes(monitor);
		if(count < 1) return ERR_GETMONITORINFO;
		
		if(!(m = calloc(count + 1, sizeof(struct hwVideoModeInfo)))) return ERR_MEM;
		
		for(k = 0; k < count; k++) {
			
			SDL_DisplayMode mode;
			
			SDL_GetDisplayMode(monitor, k, &mode);
			
			m[k].Width = mode.w;
			m[k].Height = mode.h;
			m[k].Depth = SDL_BITSPERPIXEL(mode.format);
		}
		
		*data = m;		
		break;
		}
	}
		
	return 0;
}
	
HW_EXPORT void FreeMonitorInfo(int what, APTR data)
{
	free(data);	
}	

/*
** The following functions will never be called because we haven't set the appropriate HWSDAFLAGS when
** calling hw_SetDisplayAdapter() in RequirePlugin()
*/
#if defined(HW_WIN32) && defined(HW_64BIT)	
HW_EXPORT int _Sleep(lua_State *L, int ms)
#else
HW_EXPORT int Sleep(lua_State *L, int ms)
#endif
{
	return 0;
}
	
HW_EXPORT void VWait(APTR handle, struct hwTagList *tags)
{
}

HW_EXPORT int BeginDoubleBuffer(APTR handle, struct hwTagList *tags)
{		
	return 0;
}
	
HW_EXPORT int EndDoubleBuffer(APTR handle, struct hwTagList *tags)
{	
	return 0;
} 
	
HW_EXPORT int Flip(APTR handle, struct hwTagList *tags)
{	
	return 0;
}	
	
HW_EXPORT int Cls(APTR handle, ULONG color, struct hwTagList *tags)
{			
	return 0;
}

HW_EXPORT ULONG *GrabScreenPixels(APTR handle, int x, int y, int width, int height, ULONG flags, struct hwTagList *tags)
{
	return NULL;
}
	
HW_EXPORT void FreeGrabScreenPixels(ULONG *pixels)
{
}
	
HW_EXPORT APTR AllocVideoBitMap(int width, int height, ULONG flags, struct hwTagList *tags)
{
	return NULL;	
}
	
HW_EXPORT void FreeVideoBitMap(APTR handle)
{	
}

HW_EXPORT APTR ReadVideoPixels(APTR handle, struct hwTagList *tags)
{	
	return NULL;		
}	

HW_EXPORT void FreeVideoPixels(APTR pixels)
{
}	

HW_EXPORT int DoVideoBitMapMethod(APTR handle, int method, APTR data)
{				
	return 0;
}


HW_EXPORT APTR AllocBitMap(int type, int width, int height, ULONG flags, struct hwTagList *tags)
{
	return NULL;
}
	
HW_EXPORT void FreeBitMap(APTR handle)
{
}
	
HW_EXPORT APTR LockBitMap(APTR handle, ULONG flags, struct hwos_LockBitMapStruct *bmlock, struct hwTagList *tags)
{
	return NULL;
}
	
HW_EXPORT void UnLockBitMap(APTR handle)
{
}
	
HW_EXPORT int GetBitMapAttr(APTR handle, int attr, struct hwTagList *tags)
{		
	return 0;
}	
