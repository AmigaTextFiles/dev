//+ Includes
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <exec/types.h>
#include <exec/memory.h>
#include <cybergraphx/cybergraphics.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/dos.h>
#include <proto/cybergraphics.h>
#include <proto/asl.h>
#include <proto/Warp3D.h>
#include <readlevel.h>
#include <render.h>
#include <text.h>
#include <loadpng.h>
#include <libutil.h>
#include <textures.h>
//-
//+ Stoff
struct Library *Warp3DBase;
struct Library *CyberGfxBase;
struct IntuitionBase *IntuitionBase;
struct GfxBase *GfxBase;
struct Screen *screen;
struct Window *window;
struct BitMap *bm = NULL;
W3D_Context *context = NULL;

BOOL DoLight = TRUE;
BOOL OutlineMode = FALSE;
BOOL DoFPS = TRUE;
/*
	If DoMultiBuffer is true, uses V39 multibuffering. Sadly, I didn't
	get this to work, and I didn't have time to look after it, so leave
	this alone, please.
*/
BOOL DoMultiBuffer = FALSE;
BOOL DoFilter = FALSE;
BOOL running=TRUE;
UWORD *DisplayBase;
ULONG BytesPerRow;

struct ScreenBuffer *Buf1, *Buf2;

BMFont *font;

int MouseX, MouseY;
int LMB;

extern W3D_Scissor s;

//-
//+ dummy breakpoint
void dummy(void)
{
	return;
}
//-
//+ GetScreenMode
ULONG GetScreenMode(ULONG width, ULONG height, ULONG *w, ULONG *h)
{
#if 0
	ULONG ModeID = (ULONG)CModeRequestTags(NULL,
		CYBRMREQ_WinTitle, "WarpEngine Screenmode",
		CYBRMREQ_MinDepth,  15,
		CYBRMREQ_MaxDepth,  15,
	TAG_DONE);

	if (ModeID == 0) return INVALID_ID;

	if (IsCyberModeID(ModeID)) {
		*w = (ULONG)GetCyberIDAttr(CYBRIDATTR_WIDTH, ModeID);
		*h = (ULONG)GetCyberIDAttr(CYBRIDATTR_HEIGHT, ModeID);
	} else return INVALID_ID;

	return ModeID;
#else
	struct DimensionInfo dinfo;
	ULONG res;
	ULONG ModeID = W3D_RequestModeTags(
		W3D_SMR_TYPE,       W3D_DRIVER_3DHW,
		W3D_SMR_DESTFMT,    W3D_FMT_R5G5B5,
	TAG_DONE);

	if (ModeID == INVALID_ID) return INVALID_ID;
	res = GetDisplayInfoData(NULL, (UBYTE *)&dinfo, sizeof(struct DimensionInfo), DTAG_DIMS, ModeID);
	if (!res) return INVALID_ID;

	*w = dinfo.Nominal.MaxX - dinfo.Nominal.MinX + 1;
	*h = dinfo.Nominal.MaxY - dinfo.Nominal.MinY + 1;

	printf("ModeID: (%d,%d)-(%d,%d)\n",
		dinfo.Nominal.MinX, dinfo.Nominal.MinY,
		dinfo.Nominal.MaxX, dinfo.Nominal.MaxY);

	return ModeID;
#endif

}
//-
//+ main
void main(int argc, char **argv)
{
	ULONG ModeID;
	ULONG Width, Height;
	ULONG OpenErr, CError;
	struct IntuiMessage *imsg;
	ULONG flags;
	BOOL drag = FALSE;
	void *handle;
	int fastfilter=1;
	extern int bufnum;
	ULONG rh;

	// Initialize the required libraries
	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 0);
	GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 0);
	CyberGfxBase = OpenLibrary("cybergraphics.library", 0L);
	if (!CyberGfxBase) {
		printf("Error opening CyberGraphX library\n");
		goto panic;
	}

	Warp3DBase = OpenLibrary("Warp3D.library", 0L);
	if (!Warp3DBase) {
		printf("Error opening Warp3D library\n");
		goto panic;
	}

	// Check for availability of drivers
	flags = W3D_CheckDriver();
	if (flags & W3D_DRIVER_3DHW) printf("Hardware driver available\n");
	if (flags & W3D_DRIVER_CPU)  printf("Software driver available\n");
	if (flags == 0) {
		printf("PANIC: no driver available!!!\n");
		goto panic;
	}

	ModeID = GetScreenMode(320, 200, &Width, &Height);

	if (ModeID == INVALID_ID) {
		printf("Error: No ModeID found\n");
		goto panic;
	}

	TIMER_init();

	printf("Selected Screenmode is %d×%d\n", Width, Height);

	s.width = Width;
	s.height = Height;

	if (DoMultiBuffer == TRUE) rh = s.height;
	else                       rh = 2*s.height;

	// Open Screen
	screen = OpenScreenTags(NULL,
		SA_Height,    rh,
		SA_Depth,     8L,
		SA_DisplayID, ModeID,
		SA_ErrorCode, (ULONG)&OpenErr,
		SA_ShowTitle, FALSE,
		SA_Draggable, FALSE,
	TAG_DONE);

	if (!screen) {
		printf("Unable to open screen. Reason: Error code %d\n", OpenErr);
		goto panic;
	}

	// Open window
	// While this is not strictly nessessary, we use it because
	// we want to get IDCMP messages. You can also use the screen's
	// bitmap to render
	window = OpenWindowTags(NULL,
		WA_CustomScreen,    screen,
		WA_Width,           screen->Width,
		WA_Height,          screen->Height,
		WA_Left,            0,
		WA_Top,             0,
		WA_Title,           NULL,
		WA_CloseGadget,     FALSE,
		WA_Backdrop,        TRUE,
		WA_Borderless,      TRUE,
		WA_Activate,        TRUE,
		WA_IDCMP,           IDCMP_CLOSEWINDOW|IDCMP_VANILLAKEY|IDCMP_RAWKEY|IDCMP_MOUSEBUTTONS|IDCMP_MOUSEMOVE|IDCMP_DELTAMOVE,
		WA_Flags,           WFLG_REPORTMOUSE|WFLG_RMBTRAP,
	TAG_DONE);

	if (!window) {
		printf("Unable to open window.\n");
		goto panic;
	}

	if (DoMultiBuffer == TRUE) {
		ULONG flag;
		// Do V39 Multibuffering.
		Buf1 = AllocScreenBuffer(screen, NULL, SB_SCREEN_BITMAP);
		if (!Buf1) {
			printf("ScreenBuffer allocation failed\n");
			goto panic;
		}
		flag = GetCyberMapAttr(Buf1->sb_BitMap, CYBRMATTR_ISCYBERGFX);
		if (!flag) {
			printf("Error: Buffer 1 is no cybergraphics bitmap");
			goto panic;
		}
		Buf2 = AllocScreenBuffer(screen, NULL, 0);
		if (!Buf2) {
			printf("ScreenBuffer 2 allocation failed\n");
			goto panic;
		}
		flag = GetCyberMapAttr(Buf2->sb_BitMap, CYBRMATTR_ISCYBERGFX);
		if (!flag) {
			printf("Error: Buffer 2 is no cybergraphics bitmap");
			goto panic;
		}
		Buf1->sb_DBufInfo->dbi_SafeMessage.mn_ReplyPort = NULL;
		while (!ChangeScreenBuffer(screen, Buf1));
		WaitTOF();
		bm = Buf1->sb_BitMap;
		bufnum = 0;
	} else {
		// We want to use this bitmap
		bm = window->RPort->BitMap;
	}

	if (DoMultiBuffer == FALSE) {
		context = W3D_CreateContextTags(&CError,
			W3D_CC_MODEID,      ModeID,
			W3D_CC_BITMAP,      bm,
			W3D_CC_YOFFSET,     0,
			W3D_CC_DRIVERTYPE,  W3D_DRIVER_BEST,
			W3D_CC_FAST,        TRUE,
			W3D_CC_GLOBALTEXENV,TRUE,
			W3D_CC_DOUBLEHEIGHT,TRUE,
		TAG_DONE);
	} else {
		context = W3D_CreateContextTags(&CError,
			W3D_CC_MODEID,      ModeID,
			W3D_CC_BITMAP,      bm,
			W3D_CC_YOFFSET,     0,
			W3D_CC_DRIVERTYPE,  W3D_DRIVER_BEST,
			W3D_CC_GLOBALTEXENV,TRUE,
			W3D_CC_FAST,        TRUE,
		TAG_DONE);
	}


	if (!context || CError != W3D_SUCCESS) {
		printf("Error creating context. Reason:");
		switch(CError) {
		case W3D_ILLEGALINPUT:
			printf("Illegal input to CreateContext function\n");
			break;
		case W3D_NOMEMORY:
			printf("Out of memory\n");
			break;
		case W3D_NODRIVER:
			printf("No suitable driver found\n");
			break;
		case W3D_UNSUPPORTEDFMT:
			printf("Supplied bitmap cannot be handled by Warp3D\n");
			break;
		case W3D_ILLEGALBITMAP:
			printf("Supplied bitmap not properly initialized\n");
			break;
		default:
			printf("An error has occured... gosh\n");
		}
		goto panic;
	}

	W3D_SetState(context, W3D_TEXMAPPING, W3D_DISABLE);

	/*
	** BIG NO-NO, but I'll do it anyway.
	** You should always do proper locking
	*/
	Forbid();
	handle = LockBitMapTags(bm,
		LBMI_BASEADDRESS, &DisplayBase,
		LBMI_BYTESPERROW, &BytesPerRow,
	TAG_DONE);
	UnLockBitMap(handle);
	Permit();

	font = TEXT_LoadFont("data/test.fnt");
	if (!font) goto panic;
	TEXT_SetFont(font);
	TEXT_SetColor(30,255,30);

	running=TRUE;

	TEXTURE_Init();

	if (FALSE == LEVEL_Read("data/level00.lvl")) {
		printf("Level refused to be loaded\n");
		goto panic;
	}

	SetRGB32(&(screen->ViewPort), 0, 0,0,0);
	RENDER_SwitchBuffer();
	RENDER_SetWindow(0,0, s.width, s.height);
	RENDER_SetCamera(32.f, 64.f , 32.f, 0.f, 0.f);

	RENDER_Print("Engine V1.0");
	RENDER_Print("(C) 1998 Hans-Joerg Frieden");
	RENDER_Print("Part of Warp3D");

	TIMER_StartElapsed();
	W3D_SetState(context, W3D_PERSPECTIVE, W3D_ENABLE);
	W3D_SetState(context, W3D_BLENDING, W3D_ENABLE);

	W3D_Hint(context, W3D_H_BILINEARFILTER, W3D_H_NICE);

	W3D_SetTexEnv(context, NULL, W3D_MODULATE, NULL);
	W3D_SetState(context, W3D_GOURAUD, W3D_ENABLE);

	LMB = 0;

	while (running) {
		RENDER_DrawScreen();
		/* Usually, you might want to use a
		   WaitPort(window->UserPort);
		   here, but we want a continous update, so that the
		   flashlights keep blinking.
		*/
		while (imsg = (struct IntuiMessage *)GetMsg(window->UserPort)) {
			if (imsg == NULL) break;
			switch(imsg->Class) {
			case IDCMP_MOUSEBUTTONS:
				if (imsg->Code == MENUUP)   drag = FALSE;
				if (imsg->Code == MENUDOWN) drag = TRUE;
				if (imsg->Code == SELECTDOWN) LMB = 1;
				if (imsg->Code == SELECTUP)   {
					extern void RENDER_HandleMenuUp(void);
					LMB = 0;
					RENDER_HandleMenuUp();
				}
				break;
			case IDCMP_MOUSEMOVE:
				MouseX = window->MouseX;
				MouseY = window->MouseY;
				if (drag) RENDER_TurnCamera((float)(imsg->MouseY),(float)(imsg->MouseX));
				break;
			case IDCMP_CLOSEWINDOW:
				running=FALSE;
				break;
			case IDCMP_RAWKEY:
				break;
			case IDCMP_VANILLAKEY:
				switch(imsg->Code) {
				case 27:
				case 'q':
					running=FALSE;
					break;
				case 'B':
					if (fastfilter) {
						fastfilter=0;
						W3D_Hint(context, W3D_H_BILINEARFILTER, W3D_H_NICE);
						RENDER_Print("Nice Filter");
					} else {
						fastfilter=1;
						W3D_Hint(context, W3D_H_BILINEARFILTER, W3D_H_FAST);
						RENDER_Print("Fast Filter");
					}
					break;
				case 'D':
					dummy();
					break;
				case 'P':
					if (W3D_GetState(context, W3D_PERSPECTIVE) == W3D_ENABLED) {
						W3D_SetState(context, W3D_PERSPECTIVE, W3D_DISABLE);
						RENDER_Print("Perspective off");
					} else {
						W3D_SetState(context, W3D_PERSPECTIVE, W3D_ENABLE);
						RENDER_Print("Perspective on");
					}
					break;
				case 'L':
					if (DoLight == FALSE) DoLight = TRUE;
					else                  DoLight = FALSE;
					if (DoLight) RENDER_Print("Lighting on");
					else         RENDER_Print("Lighting off");
					break;
				case 'O':
					if (OutlineMode == FALSE) OutlineMode = TRUE;
					else                      OutlineMode = FALSE;
					if (OutlineMode) RENDER_Print("Outline mode");
					else             RENDER_Print("Normal mode");
					break;
				case 'F':
					if (DoFPS == FALSE) DoFPS = TRUE;
					else                DoFPS = FALSE;
					break;
				case 's':
					RENDER_MoveCamera(5.f);
					break;
				case 'x':
					RENDER_MoveCamera((float)(-5.0));
					break;
				case 'd':
					RENDER_TurnCamera(0.f, 3.f);
					break;
				case 'a':
					RENDER_TurnCamera(0.f, (float)-3.0);
					break;
				case 'f':
					RENDER_TurnCamera(3.f, 0.f);
					break;
				case 'v':
					RENDER_TurnCamera((float)-3.0, 0.f);
					break;
				}
				break;
			}
			if (imsg) {
				ReplyMsg((struct Message *)imsg);
				imsg = NULL;
			}
		}
	}

panic:
	LEVEL_Free();
	if (font)           TEXT_FreeFont(font);
	if (context)        W3D_DestroyContext(context);
	if (Buf1)           FreeScreenBuffer(screen, Buf1);
	if (Buf2)           FreeScreenBuffer(screen, Buf2);
	if (window)         CloseWindow(window);
	if (screen)         CloseScreen(screen);
	if (Warp3DBase)     CloseLibrary(Warp3DBase);
	if (CyberGfxBase)   CloseLibrary(CyberGfxBase);
	if (IntuitionBase)  CloseLibrary((struct Library *)IntuitionBase);
	if (GfxBase)        CloseLibrary((struct Library *)GfxBase);
	exit(0);
}
//-

