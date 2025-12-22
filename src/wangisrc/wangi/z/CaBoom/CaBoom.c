/*
 * CaBoom, 1995 Lee Kindness.
 *
 * Patches:
 *  intuition.library OpenWindow()
 *  intuition.library OpenWindowTagList()
 *  intuition.library CloseWindow()
 *
 * When windows open or close a small 'explosion' is done.
 *
 * This source is in the public domain, do with it as you wish...
 *
 * version 1.3
 *
 ***************************************************************************/

#include "gst.c"


/********************************* download dev/c/SFPatch.lha for documentation */

#include "SFPatch.h"


/********************************* DONT auto open... */

extern struct IntuitionBase *IntuitionBase = NULL;
extern struct Library *CxBase = NULL;
extern struct Library *IconBase = NULL;
extern struct Library *UtilityBase = NULL;
extern struct GfxBase *GfxBase = NULL;
extern struct Library *LayersBase = NULL;

/* Save a bit of typing */
#define REG(x) register __ ## x


/********************************* The function offsets */

#define OW_OFFSET -204
#define OWTL_OFFSET -606
#define CW_OFFSET -72 


/********************************* Default prefs */

#define DEF_NOBACKDROPS FALSE
#define DEF_SPEED 10000
#define DEF_LINE 0xFFFF
#define DEF_NSTEPS 21
#define MAXSTEPS 21


/********************************* types */

typedef struct Window * __asm (*OW_Caller)( REG(a0) struct NewWindow *, 
                                            REG(a6) struct Library *);
typedef struct Window * __asm (*OWTL_Caller)( REG(a0) struct NewWindow *,
                                              REG(a1) struct TagItem *,
                                              REG(a6) struct Library *);
typedef void __asm (*CW_Caller)( REG(a0) struct Window *,
                                 REG(a6) struct Library *);
struct Prefs {
	LONG Speed, Line, nSteps, Pri;
	BOOL NoBackdrops;
  struct {
    struct {
      int x, y;
    } topleft, botright;
  } step[MAXSTEPS];
};


/********************************* Prototypes */

struct Window * __asm OW_New( REG(a0) struct NewWindow *, 
                              REG(a6) struct Library *);
struct Window * __asm OWTL_New( REG(a0) struct NewWindow *,
                                REG(a1) struct TagItem *,
                                REG(a6) struct Library *);
void __asm CW_New( REG(a0) struct Window *,
                   REG(a6) struct Library *);

BOOL OpenLibs(void);
void CloseLibs(void);
BOOL ShowWindow(void);
void line (struct RastPort *rp, LONG x1, LONG y1, LONG x2, LONG y2);
void DrawOutline(struct RastPort *rp, struct Screen *screen, LONG xi, LONG yi, LONG xf, LONG yf);
void MoveOutline(struct NewWindow *nwin, struct TagItem *tags, struct Window *window, BOOL reverse);

/********************************* Global vars */

SetFunc *OW_SetFunc, *OWTL_SetFunc, *CW_SetFunc;
struct Remember *grk;
BOOL Active;
char vertag[] = "$VER: CaBoom 1.3 "__AMIGADATE__;
struct Prefs prefs = {
 DEF_SPEED, DEF_LINE, DEF_NSTEPS, -1, DEF_NOBACKDROPS,
 {
  {    0,    0,    0,    0},	/* left, top, right, bottom */
  {  135,  -22,  135,  -22 },
  {  265,  -30,  265,  -30 },
  {  389,  -25,  389,  -25 },
  {  506,   -6,  506,   -6 },
  {  615,   23,  615,   23 },
  {  717,   62,  717,   62 },
  {  811,  111,  811,  111 },
  {  895,  168,  895,  168 },
  {  971,  231,  971,  231 },
  { 1036,  300, 1036,  300 },
  { 1090,  373, 1090,  373 },
  { 1134,  449, 1134,  449 },
  { 1166,  527, 1166,  527 },
  { 1186,  605, 1186,  605 },
  { 1194,  683, 1194,  683 },
  { 1188,  759, 1188,  759 },
  { 1169,  833, 1169,  833 },
  { 1135,  902, 1135,  902 },
  { 1087,  966, 1087,  966 },
  { 1024, 1024, 1024, 1024 }	/* 21st entry */
 }
};
/*
 *  The points above were generated using an HP-28S and a bezier curve
 * plotting program. The curve was broken in 20 line segments and the
 * control points were: (0, 0) ; (922, -205) ; (1587, 665) ; (1024, 1024)
 */


/***************************************************************************/

/* main */
int main(int argc, char **argv)
{
	int ret;		
	ret = RETURN_OK;
	Active = TRUE;
	grk = NULL;
	
	/* check version */
	if (OpenLibs()) {
		struct NewBroker nb = {
			NB_VERSION,
			"CaBoom",
			&vertag[6],
			"Window explosions",
			NBU_UNIQUE | NBU_NOTIFY,
			COF_SHOW_HIDE,
			-1,
			NULL,
			0
		};
		CxObj *broker;
		
		/* Get tooltypes */
		if (argc ? FALSE : TRUE) {
			BPTR oldcd;
			struct DiskObject *dobj;
			struct WBStartup *wbs;
			#define PROGNAME wbs->sm_ArgList->wa_Name
			#define PDIRLOCK wbs->sm_ArgList->wa_Lock
			wbs = (struct WBStartup *)argv;
			/* Run from WB */
			oldcd = CurrentDir(PDIRLOCK);
			if (dobj = GetDiskObject(PROGNAME)) {
				STRPTR s;
				if (s = FindToolType(dobj->do_ToolTypes, "SPEED")) {
					stcd_l(s, &prefs.Speed);
				}
				if (s = FindToolType(dobj->do_ToolTypes, "LINE")) {
					stcd_l(s, &prefs.Line);
				}
				if (s = FindToolType(dobj->do_ToolTypes, "NOBACKDROPS")) {
					prefs.NoBackdrops = TRUE;
				}
				if (s = FindToolType(dobj->do_ToolTypes, "CX_PRIORITY")) {
					stcd_l(s, &prefs.Pri);
				}
				FreeDiskObject(dobj);
			}
			CurrentDir(oldcd);
		} else {
			struct RDArgs *rdargs;
			#define OPT_SPEED 0
			#define OPT_LINE 1
			#define OPT_NOBACKDROPS 2
			#define OPT_CXP 3
			LONG args[4] = {0, 0, 0, 0};
			#define TEMPLATE "SPEED/K/N,LINE/K/N,NOBACKDROPS/S,CX_PRIORITY/K/N"
			/* Run from Shell */
			if (rdargs = ReadArgs(TEMPLATE, (LONG *)&args, NULL)) {
				if (args[OPT_SPEED]) {
					prefs.Speed = *((LONG *)args[OPT_SPEED]);
				}
				if (args[OPT_LINE]) {
					prefs.Line = *((LONG *)args[OPT_LINE]);
				}
				 if (args[OPT_NOBACKDROPS]) {
					prefs.NoBackdrops = TRUE;
				}
				if (args[OPT_CXP]) {
					prefs.Pri = *((LONG *)args[OPT_CXP]);
				}
				FreeArgs(rdargs);	
			}
		}
		
		if (prefs.Speed < 0)
			prefs.Speed = 0;
	
		nb.nb_Pri = prefs.Pri;
				
		if ((nb.nb_Port = CreateMsgPort()) && (broker = CxBroker(&nb, NULL))) {
			
			/* Alloc our SetFunc's */
			if((OW_SetFunc = AllocVec(sizeof(SetFunc), MEMF_CLEAR)) &&
			   (OWTL_SetFunc = AllocVec(sizeof(SetFunc), MEMF_CLEAR)) &&
			   (CW_SetFunc = AllocVec(sizeof(SetFunc), MEMF_CLEAR))) {

				/* init. sfs */
				OW_SetFunc->sf_Func = OW_New;
				OW_SetFunc->sf_Library = (struct Library *)IntuitionBase;
				OW_SetFunc->sf_Offset = OW_OFFSET;
				OW_SetFunc->sf_QuitMethod = SFQ_COUNT;
				OWTL_SetFunc->sf_Func = OWTL_New;
				OWTL_SetFunc->sf_Library = (struct Library *)IntuitionBase;
				OWTL_SetFunc->sf_Offset = OWTL_OFFSET;
				OWTL_SetFunc->sf_QuitMethod = SFQ_COUNT;
				CW_SetFunc->sf_Func = CW_New;
				CW_SetFunc->sf_Library = (struct Library *)IntuitionBase;
				CW_SetFunc->sf_Offset = CW_OFFSET;
				CW_SetFunc->sf_QuitMethod = SFQ_COUNT;

				/* Replace the functions */
				if ((SFReplace(OW_SetFunc)) &&
				    (SFReplace(OWTL_SetFunc)) &&
				    (SFReplace(CW_SetFunc))) {
					
					ULONG sig, sret;
					BOOL finished;
					
					ActivateCxObj(broker, 1L);

					finished = FALSE;
					sig = 1 << nb.nb_Port->mp_SigBit;
					
					do {
						sret = Wait(SIGBREAKF_CTRL_C | sig);
						if (sret & sig) {
							CxMsg *msg;
							while(msg = (CxMsg *)GetMsg(nb.nb_Port)) {
								switch(CxMsgType(msg)) {
									case CXM_COMMAND:
										switch(CxMsgID(msg)) {
											case CXCMD_DISABLE:
												ActivateCxObj(broker, 0L);
												Active = FALSE;
												break;
											case CXCMD_ENABLE:
												ActivateCxObj(broker, 1L);
												Active = TRUE;
												break;
											case CXCMD_KILL:
												finished = TRUE;
												break;
											case CXCMD_UNIQUE:
												finished = ShowWindow();
												break;
											case CXCMD_APPEAR:
												finished = ShowWindow();
												break;
										}
										break;
								}
								ReplyMsg((struct Message *)msg);
							}
						}
						if (sret & SIGBREAKF_CTRL_C)
							finished = TRUE;
					} while (!finished);
					ActivateCxObj(broker, 0L);
	
					/* Restore functions */
					SFRestore(CW_SetFunc);
					SFRestore(OWTL_SetFunc);
					SFRestore(OW_SetFunc);
				}
				FreeVec(CW_SetFunc);
				FreeVec(OWTL_SetFunc);
				FreeVec(OW_SetFunc);
			}
			DeleteCxObj(broker);
			DeletePort(nb.nb_Port);
		}
	}
	CloseLibs();
	return(ret);
}


/***************************************************************************/
/* Show our window... currently only a requester */
BOOL ShowWindow(void)
{
	struct EasyStruct ez = {
		sizeof(struct EasyStruct),
		0,
		"CaBoom",
		"%s ©Lee Kindness.\n\n"
		"wangi@fido.zetnet.co.uk\n\n"
		"Window explosions\n\n"
		"Read \"CaBoom.guide\" for more information\n\n"
		"(Program may take a couple of seconds to quit)",
		"Quit|Hide"
	};
	return((BOOL)EasyRequest(NULL, &ez, NULL, &vertag[6]));
}


/***************************************************************************/
/* Open all used libraries */
BOOL OpenLibs(void)
{
	BOOL ret;
	IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library", 37);
	CxBase = OpenLibrary("commodities.library", 37);
	IconBase = OpenLibrary("icon.library", 37);
	UtilityBase = OpenLibrary("utility.library", 37);
	GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 37);
	LayersBase = OpenLibrary("layers.library", 37);
	ret = ((IntuitionBase) && 
	       (CxBase) && 
	       (IconBase) &&
	       (UtilityBase) &&
	       (GfxBase) &&
	       (LayersBase));
	return(ret);
}


/***************************************************************************/
/* Close all libraries */
void CloseLibs(void)
{
	if (LayersBase)
		CloseLibrary(LayersBase);
	if (GfxBase)
		CloseLibrary((struct Library *)GfxBase);
	if (UtilityBase)
		CloseLibrary(UtilityBase);
	if (IconBase)
		CloseLibrary(IconBase);
	if (CxBase)
		CloseLibrary(CxBase);
	if (IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);
}


/***************************************************************************/
/* Draws a line */
void line (struct RastPort *rp, LONG x1, LONG y1, LONG x2, LONG y2)
{
	Move(rp, x1, y1);
	Draw(rp, x2, y2);
}


/***************************************************************************/
/* Draws a box-outline */

#define MAX(a,b) (((a)>(b))?(a):(b))
#define MIN(a,b) (((a)<(b))?(a):(b))
#define xclip(x) (MAX(0, MIN(x, screen->Width - 1)))
#define yclip(y) (MAX(0, MIN(y, screen->Height - 1)))

void DrawOutline(struct RastPort *rp, struct Screen *screen, LONG xi, LONG yi, LONG xf, LONG yf)
{
	xi = xclip(xi);
	yi = yclip(yi);
	xf = xclip(xf);
	yf = yclip(yf);
	line(rp, xi, yi, xf, yi);
	line(rp, xf, yi, xf, yf);
	line(rp, xf, yf, xi, yf);
	line(rp, xi, yf, xi, yi);
}


/***************************************************************************/
/* The 'anim' */
void MoveOutline(struct NewWindow *nwin, struct TagItem *tags, struct Window *window, BOOL reverse)
{
	struct RastPort *rp;
	struct timerequest *tr;
	struct MsgPort *tmp;
	struct Screen *screen;
	LONG x, y, w, h;
	BOOL unlockscr, backdrop;
	struct TagItem *tag;
	
	if (Active)
	{
		unlockscr = FALSE;
		/* Get Screen that window will open/close on */
		if( reverse )
		{
			screen = window->WScreen;
		} else
		{
			screen = NULL;
			if (nwin)
			{
				if ((nwin->Type != WBENCHSCREEN))
					screen = nwin->Screen;
			}
			if (tag = FindTagItem(WA_CustomScreen, tags))
			{
				screen = (struct Screen *)tag->ti_Data;
			} else
			{
				if (tag = FindTagItem(WA_PubScreen, tags))
				{
					screen = (struct Screen *)tag->ti_Data;
				} else
				{
					if (tag = FindTagItem(WA_PubScreenName, tags))
					{
						screen = LockPubScreen((STRPTR)(tag->ti_Data));
						unlockscr = TRUE;
					}
				}
			}
		}
		
		if (screen == NULL)
		{
			screen = LockPubScreen(NULL);
			unlockscr = TRUE;
		}
	
		if (screen)
		{
			/* Calculate dimensions and positioning */
			if( reverse )
			{
				x = window->LeftEdge;
				y = window->TopEdge;
				w = window->Width;
				h = window->Height;
			} else
			{
				if (nwin)
				{
					x = nwin->LeftEdge;
					y = nwin->TopEdge;
					w = nwin->Width;
					h = nwin->Height;
				} else
				{
					x = 0;
					y = 0;
					w = screen->Width;
					h = screen->Height;
				}
				if (tag = FindTagItem(WA_Left, tags))
					x = tag->ti_Data;
				if (tag = FindTagItem(WA_Top, tags))
					y = tag->ti_Data;
				if (tag = FindTagItem(WA_InnerWidth, tags))
					w = tag->ti_Data + 8;
				if (tag = FindTagItem(WA_Width, tags))
					w = tag->ti_Data;
				if (tag = FindTagItem(WA_InnerHeight, tags))
					h = tag->ti_Data + 8;
				if (tag = FindTagItem(WA_Height, tags))
					h = tag->ti_Data;
			}
			
			/* findout if backdrop */
			backdrop = FALSE;
			if( reverse )
			{
				if( window->Flags & WFLG_BACKDROP )
					backdrop = TRUE;
			} else
			{
				if( (nwin) && (nwin->Flags & WFLG_BACKDROP) )
					backdrop = TRUE;
				if( (tag = FindTagItem(WA_Flags, tags)) && (tag->ti_Data & WFLG_BACKDROP) )
					backdrop = TRUE;
				if( (tag = FindTagItem(WA_Backdrop, tags)) && (tag->ti_Data) )
					backdrop = TRUE;
			}
			
			if ( !(prefs.NoBackdrops && backdrop) )
			{
				if ((rp = AllocVec(sizeof(struct RastPort), MEMF_CLEAR)) &&
	    	    (tmp = CreateMsgPort()) &&
	   	     (tr = (struct timerequest *)CreateIORequest(tmp, sizeof(struct timerequest))))
				{
					LONG timerres;
					register LONG i, n;
					LONG dxi, dyi, dxf, dyf;
					LONG nxi, nyi, nxf, nyf;
					LONG  xi,  yi,  xf,  yf;
					LONG x0, y0;
		
					timerres = OpenDevice("timer.device", UNIT_MICROHZ, (struct IORequest *)tr, 0);

					xi = 0;
					yi = 0;
					xf = 0;
					yf = 0;
	
					*rp = screen->RastPort;
	
					SetDrMd(rp, COMPLEMENT | JAM1);
  				SetDrPt(rp, prefs.Line);
  				SetAPen(rp, 1);
	
					x0 = screen->MouseX;
  				y0 = screen->MouseY;

					dxi = x - x0;
					dyi = y - y0;
					dxf = (x + w - 1) - x0;
					dyf = (y + h - 1) - y0;
	
					LockLayers (&screen->LayerInfo);

					for (i = 0; i < prefs.nSteps; i++)
					{
						if (reverse)
							n = prefs.nSteps - i;
						else
							n = i;
		
						nxi = x0 + ((prefs.step[n].topleft.x * dxi) / 1024);
						nyi = y0 + ((prefs.step[n].topleft.y * dyi) / 1024);
						nxf = x0 + ((prefs.step[n].botright.x * dxf) / 1024);
						nyf = y0 + ((prefs.step[n].botright.y * dyf) / 1024);
						if (n)
							DrawOutline(rp, screen, xi, yi, xf, yf);	/* erases outline */
						xi = nxi;
						yi = nyi;
						xf = nxf;
						yf = nyf;
						DrawOutline(rp, screen, xi, yi, xf, yf);	/* draws outline */
			
						if ((prefs.Speed) && (timerres == 0))
						{
							tr->tr_node.io_Command = TR_ADDREQUEST;
							tr->tr_node.io_Flags = 0;
							tr->tr_time.tv_secs = 0;
							tr->tr_time.tv_micro = prefs.Speed;
							DoIO((struct IORequest *)tr);
						}
					}
					DrawOutline(rp, screen, xi, yi, xf, yf);
					if (timerres == 0)
						CloseDevice((struct IORequest *)tr);
					DeleteIORequest((struct IORequest *)tr);
					DeleteMsgPort(tmp);
					FreeVec(rp);
				}
				UnlockLayers(&screen->LayerInfo);
			}

			if (unlockscr)
				UnlockPubScreen(NULL, screen);	
		}
	}
}

/***************************************************************************/
/* The new OpenWindow() */
struct Window * __saveds __asm OW_New(REG(a0) struct NewWindow *nwin, 
                                      REG(a6) struct Library *lib)
{
	OW_Caller Caller;
	struct Window *ret;
	
	/* increment count */
	Forbid();
	OW_SetFunc->sf_Count += 1;
	Permit();
	
	MoveOutline(nwin, NULL, NULL, FALSE);
	
	Caller = (APTR)OW_SetFunc->sf_OriginalFunc;
	
	/* Pass the buck */
	ret = Caller(nwin, lib);
	
	/* decrement count */
	Forbid();
	OW_SetFunc->sf_Count -= 1;
	Permit();
	
	/* and return */
	return(ret);

}


/***************************************************************************/
/* The new OpenWindowTagList() */
struct Window * __saveds __asm OWTL_New(REG(a0) struct NewWindow *nwin, 
                                        REG(a1) struct TagItem *tags,
                                        REG(a6) struct Library *lib)
{
	struct Window *ret;
	OWTL_Caller Caller;
	
	/* increment count */
	Forbid();
	OWTL_SetFunc->sf_Count += 1;
	Permit();
	
	MoveOutline(nwin, tags, NULL, FALSE);
	
	Caller = (APTR)OWTL_SetFunc->sf_OriginalFunc;
	
	/* Pass the buck */
	ret = Caller(nwin, tags, lib);
	
	/* decrement count */
	Forbid();
	OWTL_SetFunc->sf_Count -= 1;
	Permit();
	
	/* and return */
	return(ret);
}


/***************************************************************************/
/* The new CloseWindow() */
void __saveds __asm CW_New(REG(a0) struct Window *win, 
                           REG(a6) struct Library *lib)
{
	CW_Caller Caller;
	struct Window *wincopy;
	
	/* increment count */
	Forbid();
	CW_SetFunc->sf_Count += 1;
	Permit();
	
	if( wincopy = AllocVec(sizeof(struct Window), MEMF_CLEAR) )
	{
		*wincopy = *win;
	}

	Forbid();

	/* Pass the buck */
	Caller = (APTR)CW_SetFunc->sf_OriginalFunc;
	Caller(win, lib);
	
	if ( wincopy )
	{
		MoveOutline(NULL, NULL, wincopy, TRUE);
		FreeVec(wincopy);
	}

	Permit();
	
	/* decrement count */
	Forbid();
	CW_SetFunc->sf_Count -= 1;
	Permit();
}
/***************************************************************************/
