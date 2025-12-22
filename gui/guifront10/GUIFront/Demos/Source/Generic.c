
/* This generic driver is used as a template for the demos contained in this
 * directory. To build an example, compile this file and the example your're
 * interested in into object files, and then link the two together.
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

extern STRPTR DEMO_WindowTitle;
extern STRPTR DEMO_AppID;

extern DEMO_InitialOrientation;
extern ULONG DEMO_LayoutList[];
extern GadgetSpec *DEMO_GadgetSpecList[];

/* Code */

main()
{
    /* Attempt to open library */

    if (GUIFrontBase = OpenLibrary(GUIFRONTBASE, GUIFRONTVERSION))
    {
        GUIFrontApp *guiapp;

        /* Create our application anchor structure */

        if (guiapp = GF_CreateGUIApp(DEMO_AppID,
            GFA_Version,    DEMO_Version,
            GFA_LongDesc,   DEMO_LongDesc,
            GFA_Author,     DEMO_Author,
            GFA_Date,       DEMO_Date,
            TAG_DONE))
        {
            GUIFront *gui;
            ExtErrorData exterr;

            /* Create a gui for our application */

            if (gui = GF_CreateGUI(guiapp, DEMO_LayoutList,DEMO_GadgetSpecList,
                GUI_InitialOrientation, DEMO_InitialOrientation,
                GUI_ExtendedError,      &exterr,
                GUI_WindowTitle,        DEMO_WindowTitle,
                GUI_OpenGUI,            TRUE,
                TAG_DONE))
            {
                BOOL done = FALSE;

                /* Process input events */

                while (!done)
                {
                    struct IntuiMessage *imsg;

                    /* Wait for an event to occur */

                    GF_Wait(guiapp,0);

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
            PutStr("Unable to open guifront.library\n");

        CloseLibrary(GUIFrontBase);
    }
    else
        PutStr("Requires guifront.library V37+\n");
}
