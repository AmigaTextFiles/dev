
/* This generic driver is used as a template for the demos contained in this
 * directory. To build an example, compile this file and the example your're
 * interested in into object files, and then link the two together.
 *
 * Note: This code serves as a simple container for the included example GUI
 * layouts. It is not intended to be a shining example of clear, well
 * written C, so please excuse typecast warnings, missing comments, badly
 * named variables and my blasphemic use of a ::shiver:: goto statement.
 *
 * 8.10.94: Added support for preferences update messages from prefs editor
 */

/* Include everything */

#include <libraries/guifront.h>
#include <proto/guifront.h>
#include <proto/dos.h>
#include <proto/exec.h>

/* Library bases */

struct Library *GUIFrontBase;

/* Imported from the demo module */

extern STRPTR DEMO_Version,
              DEMO_LongDesc,
              DEMO_Author,
              DEMO_Date;

extern BOOL   DEMO_Backfill;

extern STRPTR DEMO_WindowTitle;
extern STRPTR DEMO_AppID;

extern DEMO_InitialOrientation;
extern ULONG DEMO_LayoutList[];
extern GadgetSpec *DEMO_GadgetSpecList[];

/* Function prototypes */

static GUIFront *buildgui(ExtErrorData * const, GUIFrontApp * const guiapp, short const left, short const top);

/* Code */

main()
{
    /* Attempt to open library */

    if (GUIFrontBase = OpenLibrary(GUIFRONTNAME, GUIFRONTVERSION))
    {
        GUIFrontApp *guiapp;

        /* Create our application anchor structure */

        if (guiapp = GF_CreateGUIApp(DEMO_AppID,
            GFA_Version,  DEMO_Version,
            GFA_LongDesc, DEMO_LongDesc,
            GFA_Author,   DEMO_Author,
            GFA_Date,     DEMO_Date,
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
                Printf("Unable to create GUI (Error data: %ld.%ld)\n", exterr.ee_ErrorCode, exterr.ee_ErrorData);

            /* Destroy application anchor strucuture */

            GF_DestroyGUIApp(guiapp);
        }
        else
            PutStr("Unable to create guifront application\n");

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
        GUI_WindowTitle,        DEMO_WindowTitle,
        GUI_OpenGUI,            TRUE,
        GUI_LeftEdge,			left,
        GUI_TopEdge,			top,
        TAG_DONE));
}
