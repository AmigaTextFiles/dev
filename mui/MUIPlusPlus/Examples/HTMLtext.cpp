/* A simple test and demonstration program using the HTMLtext custom class
   through C++ */


#define MUIPP_DEBUG         // Turn debugging mode on for invalid use of classes
//#define MUIPP_NOINLINES       // No inlines makes code compile quicker but the resulting
                            // executable is larger and slower. Best to use this
                            // option when developing and turn off for final release.

#include <mui/HTMLtext_mcc.hpp>

struct IntuitionBase *IntuitionBase = NULL;
struct Library *MUIMasterBase = NULL;

int
main (void)
{
    // Open libraries required

    if ((IntuitionBase = (struct IntuitionBase *)OpenLibrary ("intuition.library", 0)) == NULL)
    {
        printf ("Could not open intuition.library\n");
        return 10;
    }

    if ((MUIMasterBase = OpenLibrary ("muimaster.library", 0)) == NULL)
    {
        printf ("Could not open muimaster.library\n");
        return 10;
    }

    CMUI_Window window;
    CMUI_HTMLtext html;
    CMUI_String htmlString;
    CMUI_String htmlURL;

    // Create Application object. I am not using any shortcuts here to create
    // the objects. I actually prefer the layout like this than when using
    // shortcuts. If you prefer the old way of creating objects by using the
    // shortcuts then you can still do this. See the shortcuts.cpp example
    // for details as some shortcuts have had to change name so as not to clash
    // with class member functions.

    CMUI_Application app
    (
        MUIA_Application_Title, "HTMLtext test",
        MUIA_Application_Author, "Nicholas Allen",
        MUIA_Application_Base, "TEST",
        MUIA_Application_Copyright, "AllenSoft",
        MUIA_Application_Description, "Test Program For HTMLtext C++ class",
        MUIA_Application_Version, "$VER: Test 1.0 (17.9.96)",
        SubWindow, window = CMUI_Window
        (
            MUIA_Window_Title, "Test Program For HTML C++ class",
            MUIA_Window_ID, 10,
            WindowContents, CMUI_VGroup
            (
                Child, CMUI_Scrollgroup
                (
                    MUIA_Scrollgroup_Contents, html = CMUI_HTMLtext
                    (
                        MUIA_HTMLtext_Contents, "<b><center><h1>Test for HTMLtext class</b></center></h1>",
                        VirtualFrame,
                        TAG_DONE
                    ),
                    MUIA_CycleChain, 1,
                    TAG_DONE
                ),

                Child, htmlURL = CMUI_String
                (
                    MUIA_String_Contents, "",
                    MUIA_ShortHelp, "Enter a URL here!",
                    MUIA_CycleChain, 1,
                    StringFrame,
                    TAG_DONE
                ),

                Child, htmlString = CMUI_String
                (
                    MUIA_String_Contents, "",
                    MUIA_ShortHelp, "Enter some HTML text here!",
                    MUIA_CycleChain, 1,
                    StringFrame,
                    TAG_DONE
                ),

                TAG_DONE
            ),
            TAG_DONE
        ),
        TAG_DONE
    );

    // Any MUI object created as a C++ class can be tested for validity by
    // calling its IsValid() method. This method just checks that the
    // BOOPSI object pointer is not NULL.

    if (!app.IsValid())
    {
        printf ("Could not create application!\n");
        return 10;
    }

    // Setup close window notification.
    // Because Notify() is a variable args method we have to pass sva as the
    // first parameter. Failing to do this will result in an error at
    // COMPILE time so there won't be any weird crashes by forgetting to do
    // this.

    window.Notify(sva, MUIA_Window_CloseRequest, TRUE,
                  app, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

    htmlString.Notify(sva, MUIA_String_Acknowledge, MUIV_EveryTime,
                      html, 3, MUIM_Set, MUIA_HTMLtext_Contents, MUIV_TriggerValue);

    htmlURL.Notify(sva, MUIA_String_Acknowledge, MUIV_EveryTime,
                   html, 3, MUIM_Set, MUIA_HTMLtext_URL, MUIV_TriggerValue);

    window.SetOpen(TRUE);

    ULONG sigs = 0;
    BOOL running = TRUE;

    while (running)
    {
        switch (app.NewInput(&sigs))
        {
            case MUIV_Application_ReturnID_Quit:
                running = FALSE;
            break;
        }

        if (sigs)
        {
            sigs = Wait (sigs | SIGBREAKF_CTRL_C);
            if (sigs & SIGBREAKF_CTRL_C) break;
        }
    }

    // This disposes of the application and all windows and objects in the
    // windows.

    app.Dispose();

    CloseLibrary ((struct Library *)IntuitionBase);
    CloseLibrary (MUIMasterBase);

    return 0;
}