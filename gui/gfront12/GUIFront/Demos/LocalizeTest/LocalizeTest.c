
/* Locale.c - Localizing example
 *
 * This demo illustrates the basic concepts of GUIFront localizing. It opens
 * up a GUI exactly like the "FramePrefs" example in the parent directory,
 * but localized this time.
 * This is the basic GUI setup code. It is not much different from the
 * 'Generic.c' file in the parent directory, only it contains extra code to
 * open locale.library, a routine to fetch localized strings, and the localizer
 * hook code used by GUIFront.
 */

/* Include everything */

#include <libraries/guifront.h>
#include <proto/guifront.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/locale.h>

#define CATCOMP_ARRAY
#include "strings.h"

/* Library bases */

struct Library *GUIFrontBase;
struct Library *LocaleBase;

/* Global data */

struct Catalog *catalog;

/* Imported from the demo module */

extern STRPTR DEMO_Version,
              DEMO_LongDesc,
              DEMO_Author,
              DEMO_Date;

extern BOOL   DEMO_Backfill;

extern STRPTR DEMO_AppID;

extern DEMO_InitialOrientation;
extern ULONG DEMO_LayoutList[];
extern GadgetSpec *DEMO_GadgetSpecList[];

extern struct NewMenu DEMO_NewMenu[];

/* Function prototypes */

static GUIFront *buildgui(ExtErrorData * const, GUIFrontApp * const guiapp, short const left, short const top);

/* Code */

/* First, a tiny function which returns catalog strings */

STRPTR cat(const int num)
{
	short i;

	for (i = 0; CatCompArray[i].cca_ID != num; i++)
		;

	if (LocaleBase)
		return((char *)GetCatalogStr(catalog,num,CatCompArray[i].cca_Str));
	else
		return(CatCompArray[i].cca_Str);
}

/* This is the localizer hook used by (called by) GUIFront */

__saveds __asm STRPTR localizerfunc(register __a0 struct Hook * hook,
                                    register __a2 GUIFront *gui,
                                    register __a1 LocaleHookMsg *lhm)
{
    /* What type of data does GUIFront want us to localize? */

	switch (lhm->lhm_Kind)
	{
		case LHMK_StringID:

            /* A simple string */

			return (cat(lhm->lhm_Data.lhmd_StringID));

		case LHMK_GadgetSpec:
		{
            /* A GadgetSpec (the gadget label). We grab the catalog string
             * id we stored in the GadgetText field of the GadgetSpec,
             * and return the corresponding catalog string.
             */

			ULONG str_id = (ULONG)lhm->lhm_Data.lhmd_GadgetSpec->gs_ng.ng_GadgetText;

            /* We don't want to localize gadgets which don't have labels */

			if (str_id > 0)
				return (cat(str_id));

			return(NULL);
		}

		case LHMK_NewMenu:
		{
            /* A newmenu entry. We take the catalog string id we stored
             * in the nm_Label field of the NewMenu entry and return
             * the corresponding catalog string
             */

			struct NewMenu *nm = lhm->lhm_Data.lhmd_NewMenu;

            /* We take care not to attempt localizing something we
             * shouldn't. A NULL return tells GUIFRont we can't localize
             * this label.
             */

			if ((nm->nm_Type != NM_END) && (nm->nm_Label != NM_BARLABEL))
				return (cat((ULONG)nm->nm_Label));

			return (NULL);
		}
	}
}

/* Trivial hook interface to the above routine */

struct Hook localizerhook =
{
	{NULL, NULL},
	(ULONG (*)())localizerfunc,
	NULL, NULL
};

main()
{
    /* Attempt to open library */

    if (GUIFrontBase = OpenLibrary(GUIFRONTNAME, GUIFRONTVERSION))
    {
        GUIFrontApp *guiapp;

		/* Attempt to open a catalog */

		if (LocaleBase = OpenLibrary("locale.library",0))
			catalog = OpenCatalogA(NULL,"localizetest.catalog",NULL);

        /* Create our application anchor structure */

        if (guiapp = GF_CreateGUIApp(DEMO_AppID,
            GFA_Version,    DEMO_Version,
            GFA_LongDesc,   DEMO_LongDesc,
            GFA_Author,     DEMO_Author,
            GFA_Date,       DEMO_Date,
            GFA_VisualUpdateSigBit, SIGBREAKB_CTRL_F, /* For simplicity */
            TAG_DONE))
        {
            GUIFront *gui;
            ExtErrorData exterr;
			short left = -1, top = -1;

            /* Create a gui for our application */

creategui:  if (gui = buildgui(guiapp,&exterr,left,top))
            {
                BOOL done = FALSE;

                /* Process input events */

                while (!done)
                {
                    struct IntuiMessage *imsg;
                    ULONG signals;

                    /* Wait for an event to occur */

                    signals = GF_Wait(guiapp,SIGBREAKF_CTRL_F);

                    if (signals & SIGBREAKF_CTRL_F) /* Update visuals? */
                    {
						/* Extract current left & topedge of our GUI
						 * window, so we can open it at the same
						 * location.
						 */

                    	GF_GetGUIAttr(gui, GUI_LeftEdge, &left,
                                           GUI_TopEdge,  &top,
                                           TAG_DONE);

                        GF_DestroyGUI(gui);
                        goto creategui;
                    }

                    /* We only bother to listen for CLOSEWINDOW events.
                     * Of course, in a real application, you would be
                     * examining the Class field for IDCMP_GADGETUP
                     * messages and act accordingly.
                     */

                    while (imsg = GF_GetIMsg(guiapp))
                    {
                        if (imsg->Class == IDCMP_CLOSEWINDOW)
                            done = TRUE;

                        GF_ReplyIMsg(imsg);
                    }
                }

                /* We're done with the GUI, so free it. GF_DestroyGUIApp
                 * actually does this for us, but it still looks nicer if
                 * we do it manually (I think :-)
                 */

                GF_DestroyGUI(gui);
            }
            else
            	Printf(cat(MSG_CantCreateGUI), exterr.ee_ErrorCode, exterr.ee_ErrorData);

            /* Destroy application anchor strucuture */

            GF_DestroyGUIApp(guiapp);
        }
        else
            PutStr(cat(MSG_CantCreateApplication));

		if (LocaleBase)
		{
			if (catalog) CloseCatalog(catalog);
			CloseLibrary(LocaleBase);
		}

        CloseLibrary(GUIFrontBase);
    }
    else
        PutStr("Requires guifront.library V37+\n");
}

/* (Re)create a gui for our application */

static GUIFront *buildgui(GUIFrontApp * const guiapp, ExtErrorData * const exterr, short const left, short const top)
{
    return (GF_CreateGUI(guiapp, DEMO_LayoutList,DEMO_GadgetSpecList,
        GUI_InitialOrientation, DEMO_InitialOrientation,
        GUI_Backfill,           DEMO_Backfill,
        GUI_ExtendedError,      exterr,
        GUI_WindowTitle,        cat(MSG_WindowTitle),
        GUI_OpenGUI,            TRUE,
        GUI_LocaleFunc,         &localizerhook,
        GUI_NewMenuLoc,         DEMO_NewMenu,
		GUI_LeftEdge,			left,
		GUI_TopEdge,			top,
		TAG_DONE));
}
