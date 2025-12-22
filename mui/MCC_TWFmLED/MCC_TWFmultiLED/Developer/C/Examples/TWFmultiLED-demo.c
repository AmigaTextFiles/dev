//     ___       ___
//   _/  /_______\  \_     ___ ___ __ _                       _ __ ___ ___
//__//  / _______ \  \\___/                                               \___
//_/ | '  \__ __/  ` | \_/        © Copyright 1999, Christopher Page       \__
// \ | |    | |__  | | / \               All Rights Reserved               /
//  >| .    |  _/  . |<   >--- --- -- -                       - -- --- ---<
// / \  \   | |   /  / \ / This file may not be distributed, reproduced or \
// \  \  \_/   \_/  /  / \  altered, in full or in part, without written   /
//  \  \           /  /   \    permission from Christopher Page except    /
// //\  \_________/  /\\ //\       under the conditions given in the     /
//- --\   _______   /-- - --\           package documentation           /-----
//-----\_/       \_/---------\   ___________________________________   /------
//                            \_/                                   \_/
//

/* MUI             */
#include<libraries/mui.h>
#include<mui/TWFmultiLED_mcc.h>

/* System          */
#include<exec/exec.h>
#include<dos/dos.h>

/* Prototypes      */
#include<clib/alib_protos.h>
#include<clib/exec_protos.h>
#include<clib/dos_protos.h>
#include<clib/muimaster_protos.h>

#include<pragmas/exec_pragmas.h>
#include<pragmas/dos_pragmas.h>
#include<pragmas/muimaster_pragmas.h>

#include<stdlib.h>

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

struct Library       *MUIMasterBase ;

Object *MUI_App        ;
Object *WI_Demo        ;

Object *BT_Off         ;
Object *BT_On          ;
Object *BT_Ok          ;
Object *BT_Work        ;
Object *BT_Wait        ;
Object *BT_Load        ;
Object *BT_Can         ;
Object *BT_Stop        ;
Object *BT_Error       ;
Object *BT_Panic       ;
Object *BT_TypeC5      ;
Object *BT_TypeC11     ;
Object *BT_TypeS5      ;
Object *BT_TypeS11     ;
Object *BT_TypeR11     ;
Object *BT_TypeR15     ;

Object *SL_Time        ;

Object *BT_Done        ;
Object *ML_LED         ;


void InitMUI       (void);
void ExitMUI       (APTR , STRPTR);
int  wbmain        (struct WBStartup * );
int  main          (int  , char **);
void SetupInterface(void);


/* void ExitMUI(APTR, STRPTR)                                          */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=                                          */
/* If an error occurs, or when the window is closed, this routine is   */
/* called to clean up all the resources, display an error message if   */
/* required and then exit().                                           */
/*                                                                     */
/* Parameters:                                                         */
/*      errApp      Pointer to the MUI Application object to close.    */
/*      errString   String to display in an EasyRequest. If this is    */
/*                  NULL then nothing is displayed                     */

/*GFS*/  void ExitMUI(APTR errApp, STRPTR errString)
{
    LONG EntryNum = 0;

    struct EasyStruct ErrorDisplay =
    {
        sizeof(struct EasyStruct),
        0,
        "WARNING",
        "%s",
        "Ok",
    };

    if(errString) EasyRequest(NULL, &ErrorDisplay, NULL, errString, 0);

    if(errApp) {
        set(WI_Demo, MUIA_Window_Open, FALSE);
        MUI_DisposeObject(errApp);
    }

    /* Clean up */
    if(MUIMasterBase) CloseLibrary(MUIMasterBase);

    exit(0);
}/*GFE*/


/* void InitMUI(void)                                                  */
/* -=-=-=-=-=-=-=-=-=                                                  */
/* This routine opens the library. Bit poinless for this demo, but it  */
/* mucks up my template otherwise...                                   */

/*GFS*/  void InitMUI(void)
{
    if(!(MUIMasterBase = OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN))) {
        ExitMUI(NULL, "Unable to open "MUIMASTER_NAME".");
    }

}/*GFE*/


/* int wbmain(WBStartup *)                                             */
/* -=-=-=-=-=-=-=-=-=-=-=-                                             */
/* Entry point for WB started programs                                 */

/*GFS*/  int wbmain(struct WBStartup *wb_Startup)
{
    return (main(0, (char **)wb_Startup));
}/*GFE*/


/* int main(int char **)                                               */
/* -=-=-=-=-=-=-=-=-=-=-                                               */
/* Eh? You want COMMENTS?? For *MAIN*??? Oh, all right then main       */
/* routine.. there that's all your getting                             */

/*GFS*/  int main(int argc, char *argv[])
{
     BOOL running = TRUE ;
    ULONG     sig =     0;
    ULONG   Value =     0;

    /* Wake up MUI...                                         */
    InitMUI();
    SetupInterface();
    if(!MUI_App) ExitMUI(MUI_App, "Failed To Create Application.");

    set(WI_Demo, MUIA_Window_Open, TRUE);

    /* Ah the DoMethods.......                                */
    DoMethod(WI_Demo   , MUIM_Notify, MUIA_Window_CloseRequest, TRUE , MUI_App, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);
    DoMethod(BT_Done   , MUIM_Notify, MUIA_Pressed            , FALSE, MUI_App, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

    DoMethod(BT_Off    , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Off      );
    DoMethod(BT_On     , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_On       );
    DoMethod(BT_Ok     , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Ok       );
    DoMethod(BT_Work   , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Working  );
    DoMethod(BT_Wait   , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Waiting  );
    DoMethod(BT_Load   , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Load     );
    DoMethod(BT_Can    , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Cancelled);
    DoMethod(BT_Stop   , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Stopped  );
    DoMethod(BT_Error  , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Error    );
    DoMethod(BT_Panic  , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Panic    );

    DoMethod(BT_TypeC5 , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Round5    );
    DoMethod(BT_TypeC11, MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Round11   );
    DoMethod(BT_TypeS5 , MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Square5   );
    DoMethod(BT_TypeS11, MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Square11  );
    DoMethod(BT_TypeR11, MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Rect11    );
    DoMethod(BT_TypeR15, MUIM_Notify, MUIA_Pressed, FALSE, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Rect15    );

    DoMethod(SL_Time   , MUIM_Notify, MUIA_Numeric_Value, MUIV_EveryTime, ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_TimeDelay, MUIV_TriggerValue);

    while (running) {
        switch(DoMethod(MUI_App, MUIM_Application_Input, &sig)) {
            case MUIV_Application_ReturnID_Quit : running= FALSE; break;
        }
        if (running && sig)
            Wait(sig);
    }

    /* Go hence from this place MUI!                            */
    ExitMUI(MUI_App, NULL);

}/*GFE*/


/* void SetupInterface(void)                                           */
/* -=-=-=-=-=-=-=-=-=-=-=-=-                                           */
/* This routine simply creates the MUI interface                       */

/*GFS*/   void SetupInterface(void)
{
    MUI_App = ApplicationObject,
                MUIA_Application_Title      , "TWFmultiLED-Demo",
                MUIA_Application_Version    , "$VER: TWFmultiLED-Demo v1.0 (23-Nov-1998)",
                MUIA_Application_Copyright  , "(C)1998 Chris Page, The World Foundry",
                MUIA_Application_Author     , "Chris Page, TWF",
                MUIA_Application_Description, "TWFmultiLED.mcc demo program",
                MUIA_Application_Base       , "TWFLEDDEMO",
/*GFS*/         SubWindow, WI_Demo = WindowObject,
                                    MUIA_Window_Title      , "TWFmultiLED Demo",
                                    MUIA_Window_ID         , MAKE_ID('M','A','I','N'),
                                    MUIA_Window_ScreenTitle, "TWFmultiLED demo program",
                                    WindowContents, VGroup,
                                        Child, ColGroup(5),
                                            MUIA_Group_SameSize, TRUE,
                                            GroupFrameT("Indicator Colour"),
                                            Child, BT_Off   = SimpleButton("Off"),
                                            Child, BT_On    = SimpleButton("On"),
                                            Child, BT_Ok    = SimpleButton("Ok"),
                                            Child, BT_Work  = SimpleButton("Working"),
                                            Child, BT_Wait  = SimpleButton("Waiting"),
                                            Child, BT_Load  = SimpleButton("Loading"),
                                            Child, BT_Can   = SimpleButton("Cancelled"),
                                            Child, BT_Stop  = SimpleButton("Stopped"),
                                            Child, BT_Error = SimpleButton("Error"),
                                            Child, BT_Panic = SimpleButton("Panic"),
                                        End,
                                        Child, ColGroup(4),
                                            MUIA_Group_SameSize, TRUE,
                                            GroupFrameT("Indicator Shape"),
                                            Child, BT_TypeC5  = SimpleButton("Round 5"),
                                            Child, BT_TypeC11 = SimpleButton("Round 11"),
                                            Child, BT_TypeS5  = SimpleButton("Square 5"),
                                            Child, BT_TypeS11 = SimpleButton("Square 11"),
                                            Child, HSpace(0),
                                            Child, BT_TypeR11 = SimpleButton("Rect 11"),
                                            Child, BT_TypeR15 = SimpleButton("Rect 15"),
                                            Child, HSpace(0),
                                        End,
                                        Child, HGroup,
                                            Child, Label("Time Delay (Seconds)"),
                                            Child, SL_Time = SliderObject,
                                                MUIA_Numeric_Min  , 0,
                                                MUIA_Numeric_Max  , 300,
                                                MUIA_Numeric_Value, 0,
                                            End,
                                        End,
                                        Child, VGroup,
                                            Child, VSpace(0),
                                            Child, HGroup,
                                                Child, HSpace(0),
                                                Child, ML_LED = TWFmultiLEDObject, End,
                                                Child, HSpace(0),
                                            End,
                                            Child, VSpace(0),
                                        End,
                                        Child, BT_Done = SimpleButton("Done"),
                                    End,
/*GFE*/                    End,
    End;

}/*GFE*/

