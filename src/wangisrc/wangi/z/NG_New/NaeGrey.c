#include "gst.c"

extern struct Library *IconBase = NULL;
extern struct IntuitionBase *IntuitionBase = NULL;
extern struct GfxBase *GfxBase = NULL;

#define GFX_BLANK_FLAG (1<<5)

#define BLANK_ON 0
#define BLANK_OFF 1
#define BLANK_TOGGLE 2

char vertag[] = "$VER: NaeGrey 2.0 "__AMIGADATE__;

void main(int argc, char **argv)
{
	if( (GfxBase = (struct GfxBase *)OpenLibrary("graphics.library", 0)) &&
	    (IntuitionBase = (struct IntutuionBase *)OpenLibrary("intuition.library", 0)) &&
	    (IconBase = OpenLibrary("icon.library", 0)) )
	{
		STRPTR actionstr = NULL;
		struct RDArgs *rdargs = NULL;
		struct DiskObject *dobj = NULL;
		LONG action;
		/* Get tooltypes */
		if (argc ? FALSE : TRUE) {
			BPTR oldcd;
			struct WBStartup *wbs;
			#define PROGNAME wbs->sm_ArgList->wa_Name
			#define PDIRLOCK wbs->sm_ArgList->wa_Lock
			wbs = (struct WBStartup *)argv;
			/* Run from WB */
			oldcd = CurrentDir(PDIRLOCK);
			if (dobj = GetDiskObject(PROGNAME)) {
				actionstr = FindToolType(dobj->do_ToolTypes, "SPEED");
			}
			CurrentDir(oldcd);
		} else {
			#define OPT_ACTION 0
			LONG args[1] = {0};
			#define TEMPLATE "ACTION"
			/* Run from Shell */
			if (rdargs = ReadArgs(TEMPLATE, (LONG *)&args, NULL)) {
				if (args[OPT_ACTION]) {
					actionstr = (STRPTR)args[OPT_ACTION];
				}
			}
		}
		action = BLANK_ON;
		if( MatchToolValue(actionstr, "OFF") )
			action = BLANK_OFF;
		if( MatchToolValue(actionstr, "TOGGLE") )
			action = BLANK_TOGGLE;

		if( dobj )
			FreeDiskObject(dobj);
		if( rdargs )
			FreeArgs(rdargs);
		
		switch( action )
		{
			case BLANK_ON:
				GfxBase->BP3Bits |= GFX_BLANK_FLAG;
				break;
			case BLANK_OFF:
				GfxBase->BP3Bits &= !(GFX_BLANK_FLAG);
				break;
			case BLANK_TOGGLE:
				if( GfxBase->BP3Bits & GFX_BLANK_FLAG )
					GfxBase->BP3Bits &= !(GFX_BLANK_FLAG);
				else
					GfxBase->BP3Bits |= GFX_BLANK_FLAG;
				break;
		}
		
		RemakeDisplay();
		
		CloseLibrary(IconBase);
		CloseLibrary((struct Library *)IntuitionBase);
		CloseLibrary((struct Library *)GfxBase);
	}
}
