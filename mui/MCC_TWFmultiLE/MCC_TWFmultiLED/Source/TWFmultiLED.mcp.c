//     ___       ___
//   _/  /_______\  \_     ___ ___ __ _                       _ __ ___ ___
//__//  / _______ \  \\___/                                               \___
//_/ | '  \__ __/  ` | \_/        © Copyright 1999, Christopher Page       \__
// \ | |    | |__  | | / \   Released as Free Software under the GNU GPL   /
//  >| .    |  _/  . |<   >--- --- -- -                       - -- --- ---<
// / \  \   | |   /  / \ /   This file is part of the TWFmultiLED source   \
// \  \  \_/   \_/  /  / \  and it is released under the GNU GPL. Please   /
//  \  \           /  /   \   read the "COPYING" file which should have   /
// //\  \_________/  /\\ //\    been included in the distribution arc.   /
//- --\   _______   /-- - --\      for full details of the license      /-----
//-----\_/       \_/---------\   ___________________________________   /------
//                            \_/                                   \_/
//
// Description:
//
//  Preferences class for TWFmultiLED.
//
// Functions:
//
//  void  INIT_3_InitClass    (struct TWFmultiLEDBasestruct *base);
//  void  EXIT_3_ExitClass    (void);
//  ULONG MCC_Query           (REG(d0) LONG Which);
//  void  LoadPenSpec         (Object *Dest, ULONG SpecID, ULONG DefRed, ULONG DefGreen, ULONG DefBlue, struct MUIP_Settingsgroup_ConfigToGadgets *msg);
//  ULONG PrefsNew            (struct IClass *cl, Object *obj, Msg msg);
//  ULONG PrefsSetup          (struct IClass *cl, Object *obj, struct MUIP_Setup *msg);
//  ULONG PrefsConfigToGadgets(struct IClass *cl, Object *obj, struct MUIP_Settingsgroup_ConfigToGadgets *msg);
//  ULONG PrefsGadgetsToConfig(struct IClass *cl, Object *obj, struct MUIP_Settingsgroup_GadgetsToConfig *msg);
//  ULONG PrefsDispatcher     (struct IClass *cl, Object *obj, Msg msg);
//
// Detail:
//
//  This file contains all the routines required to implement a preferences
//  class for the TWFmultiLED indicator class.
//
// Fold Markers:
//
//  Start: /*GFS*/
//    End: /*GFE*/

#include "TWFmultiLED.mcp.h"

// Declare the library base..
struct TWFmultiLEDPrefsBase
{
    struct Library led_Library  ;
};

#pragma libbase TWFmultiLEDPrefsBase

extern char _VERSION, _REVISION;
       struct Library  *MUIMasterBase = NULL;

// The custom class pointer.
struct MUI_CustomClass *PrefsClass = NULL;

// Prototypes.
// -=-=-=-=-=-
// This is declared in storm.lib, shuts everything down if the INIT dies
extern void  abortLibInit   (void);
       ULONG MCC_Query      (REG(d0) LONG Which);
       ULONG PrefsDispatcher(REG(a0) struct IClass *, REG(a2) Object *, REG(a1) Msg);


// These are used in the cycle gadgets.
STRPTR TypeNames[] =
{
    "5 pixel diameter round LED",
    "11 pixel diameter round LED",
    "5x5 square LED",
    "11x11 square LED",
    "11x5 rectangular LED",
    "15x11 rectangular LED",
    NULL
};

STRPTR PageNames[] =
{
    "Settings",
    "Test",
    NULL
};


/* INIT_7_InitClass(TWFmultiLEDBasestruct *)                                 */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                                 */
/* Custom initialisation function. Opens muimaster.library and then creates  */
/* my custom class. I have to admit it's neater than having to write all the */
/* LibInit(), LibOpen() etc, but StormC's library code leaves a lot to be    */
/* desired... if using SAS you'll need to rewrite these!                     */

/*GFS*/  void INIT_7_InitClass(struct TWFmultiLEDBasestruct *base)
{
    if(MUIMasterBase = OpenLibrary("muimaster.library", MUIMASTER_VMIN)) {
        if(PrefsClass = MUI_CreateCustomClass((struct Library*)base, MUIC_Mccprefs, NULL, sizeof(struct PrefsData), PrefsDispatcher)) {
            return;
        }
        CloseLibrary(MUIMasterBase);
    }

    abortLibInit();

}/*GFE*/


/* EXIT_7_ExitClass(void)                                                    */
/* -=-=-=-=-=-=-=-=-=-=-=                                                    */
/* Custom destructor function for the library base, just deletes the custom  */
/* class and frees muimaster.                                                */

/*GFS*/  void EXIT_7_ExitClass(void)
{
    if(PrefsClass   ) MUI_DeleteCustomClass(PrefsClass);
    if(MUIMasterBase) CloseLibrary(MUIMasterBase);

}/*GFE*/


/* ULONG MCC_Query(LONG)                                                     */
/* -=-=-=-=-=-=-=-=-=-=-                                                     */
/* Arcane little dooda which is largely undocumented but is crucial to the   */
/* operation of the library - mui uses this to get a pointer to your class   */
/* and preferences image.                                                    */

/*GFS*/  ULONG MCC_Query(REG(d0) LONG Which)
{
    switch(Which)
    {
        // MUI wants a pointer to the class...
        case 1: return((ULONG)PrefsClass);

        // MUI wants an object to show as your prefs image.
        case 2: return((ULONG)BodychunkObject,
                                MUIA_FixWidth             , Prefs_Image_Width,
                                MUIA_FixHeight            , Prefs_Image_Height,
                                MUIA_Bitmap_Width         , Prefs_Image_Width,
                                MUIA_Bitmap_Height        , Prefs_Image_Height,
                                MUIA_Bodychunk_Depth      , Prefs_Image_Depth,
                                MUIA_Bodychunk_Body       , (UBYTE *)Prefs_Image_Data,
                                MUIA_Bodychunk_Compression, Prefs_Image_Compression,
                                MUIA_Bodychunk_Masking    , Prefs_Image_Masking,
                                MUIA_Bitmap_SourceColors  , (ULONG *)Prefs_Image_Colors,
                                MUIA_Bitmap_Transparent   , 0,
                                End);
    }
    return(NULL);
}/*GFE*/


/* ULONG PrefsNew(IClass *, Object *, Msg)                                   */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                                   */
/* Object constructor. Creates a new preferences object, which is really     */
/* just the interface shown in the MUI prefs. All it does is create a group  */
/* which the user then uses to set the class preferences                     */

/*GFS*/  ULONG PrefsNew(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
{
    struct PrefsData *data;

    if(!(obj = (Object *)DoSuperMethodA(cl, obj, msg)))
        return(NULL);

    DEBUGLOG(kprintf("In PrefsNew()\n");)

    data = INST_DATA(cl, obj);

    DEBUGLOG(kprintf("PrefsNew(): Setting up interface\n");)

    // Make our preferences!!
    data -> GP_Prefs =  VGroup,
                            Child,RegisterGroup(PageNames),
                                MUIA_CycleChain    , 1,
                                MUIA_Register_Frame, TRUE,
                                Child, VGroup,
                                    Child, MUI_MakeObject(MUIO_BarTitle, "Colours"),
                                    Child, VSpace(0),
                                    Child, ColGroup(7),
                                        // Row
                                        Child, HSpace(0),
                                        Child, KeyLabel1("Inactive", 'i'),
                                        Child, data -> PP_Off =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for Inactive display",
                                                MUIA_ControlChar , 'i',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen it is \"off\"",
                                        End,
                                        Child, HSpace(0),
                                        Child, KeyLabel1("Loading", 'l'),
                                        Child, data -> PP_Load =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for Loading display",
                                                MUIA_ControlChar , 'l',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen loading",
                                        End,

                                        Child, HSpace(0),
                                        // Row
                                        Child, HSpace(0),

                                        Child, KeyLabel1("Active", 'a'),
                                        Child, data -> PP_On =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for Active display",
                                                MUIA_ControlChar , 'a',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen it is \"on\"",
                                        End,

                                        Child, HSpace(0),

                                        Child, KeyLabel1("Cancel", 'c'),
                                        Child, data -> PP_Cancel =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for Cancel display",
                                                MUIA_ControlChar , 'c',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen an operation has been cancelled",
                                        End,
                                        Child, HSpace(0),
                                        // Row
                                        Child, HSpace(0),
                                        Child, KeyLabel1("Ok", 'o'),
                                        Child, data -> PP_Ok =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for \"Ok\"",
                                                MUIA_ControlChar , 'o',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen an operation was successful",
                                        End,
                                        Child, HSpace(0),
                                        Child, KeyLabel1("Stop", 't'),
                                        Child, data -> PP_Stop =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for Stop display",
                                                MUIA_ControlChar , 't',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen an operation has been halted",
                                        End,
                                        Child, HSpace(0),
                                        // Row
                                        Child, HSpace(0),
                                        Child, KeyLabel1("Wait", 'w'),
                                        Child, data -> PP_Wait =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for Wait display",
                                                MUIA_ControlChar , 'w',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen the program is waiting",
                                        End,
                                        Child, HSpace(0),
                                        Child, KeyLabel1("Error", 'e'),
                                        Child, data -> PP_Error =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for Error display",
                                                MUIA_ControlChar , 'e',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen something has gone wrong",
                                        End,
                                        Child, HSpace(0),
                                        // Row
                                        Child, HSpace(0),
                                        Child, KeyLabel1("Work", 'k'),
                                        Child, data -> PP_Work =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for Work display",
                                                MUIA_ControlChar , 'k',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen the program is processing something",
                                        End,
                                        Child, HSpace(0),
                                        Child, KeyLabel1("Panic", 'p'),
                                        Child, data -> PP_Panic =  MUI_NewObject(MUIC_Poppen,
                                                MUIA_Window_Title, "Adjust Pen for Panic display",
                                                MUIA_ControlChar , 'p',
                                                MUIA_Draggable   , TRUE,
                                                MUIA_ShortHelp   , "\33cColour shown in the indicator\nwhen something has gone seriously wrong",
                                        End,
                                        Child, HSpace(0),
                                    End,
                                    Child, data -> CY_Type = CycleObject,
                                        MUIA_Cycle_Entries, TypeNames,
                                        MUIA_CycleChain   , 1,
                                        MUIA_ShortHelp    , "\33cShape of the indicator LED\nin programs using\nTWFmultiLED",
                                    End,
                                    Child, HGroup,
                                        Child, HSpace(0),
                                        Child, Label("LED reset delay"),
                                        Child, data -> SL_Timeout = NumericbuttonObject,
                                            MUIA_Numeric_Format, " %3ld ",
                                            MUIA_Numeric_Max   , 300,
                                            MUIA_Numeric_Min   ,   0,
                                            MUIA_CycleChain    ,   1,
                                            MUIA_ShortHelp     , "\33cDelay between the LED being set\nto a colour and being reset\nto zero (in seconds)\n0 = never reset",
                                        End,
                                        Child, HSpace(0),
                                    End,
                                End,
                                Child, VGroup,
                                    Child, ColGroup(5),
                                        MUIA_Group_SameSize, TRUE,
                                        GroupFrameT("Indicator Colour"),
                                        Child, data -> BT_Off   = SimpleButton("Off"),
                                        Child, data -> BT_On    = SimpleButton("On"),
                                        Child, data -> BT_Ok    = SimpleButton("Ok"),
                                        Child, data -> BT_Work  = SimpleButton("Working"),
                                        Child, data -> BT_Wait  = SimpleButton("Waiting"),
                                        Child, data -> BT_Load  = SimpleButton("Loading"),
                                        Child, data -> BT_Can   = SimpleButton("Cancelled"),
                                        Child, data -> BT_Stop  = SimpleButton("Stopped"),
                                        Child, data -> BT_Error = SimpleButton("Error"),
                                        Child, data -> BT_Panic = SimpleButton("Panic"),
                                    End,
                                    Child, ColGroup(4),
                                        MUIA_Group_SameSize, TRUE,
                                        GroupFrameT("Indicator Shape"),
                                        Child, data -> BT_TypeC5  = SimpleButton("Round 5"),
                                        Child, data -> BT_TypeC11 = SimpleButton("Round 11"),
                                        Child, data -> BT_TypeS5  = SimpleButton("Square 5"),
                                        Child, data -> BT_TypeS11 = SimpleButton("Square 11"),
                                        Child, HSpace(0),
                                        Child, data -> BT_TypeR11 = SimpleButton("Rect 11"),
                                        Child, data -> BT_TypeR15 = SimpleButton("Rect 15"),
                                        Child, HSpace(0),
                                    End,
                                    Child, VGroup,
                                        Child, VSpace(0),
                                        Child, HGroup,
                                            Child, HSpace(0),
                                            Child, data -> ML_LED = TWFmultiLEDObject,
                                                MUIA_TWFmultiLED_Type     , MUIV_TWFmultiLED_Type_User,
                                                MUIA_TWFmultiLED_TimeDelay, MUIV_TWFmultiLED_TimeDelay_User,
                                            End,
                                            Child, HSpace(0),
                                        End,
                                        Child, VSpace(0),
                                    End,

                                End,
                            End,
                        End;

    DEBUGLOG(kprintf("PrefsNew(): Setting up complete, checking\n");)

    if(!data -> GP_Prefs) {
        CoerceMethod(cl, obj, OM_DISPOSE);
        return(NULL);
    }

    DEBUGLOG(kprintf("PrefsNew(): finished setting up interface, setting up domethods\n");)

    DoMethod(data -> BT_Off    , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Off      );
    DoMethod(data -> BT_On     , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_On       );
    DoMethod(data -> BT_Ok     , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Ok       );
    DoMethod(data -> BT_Work   , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Working  );
    DoMethod(data -> BT_Wait   , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Waiting  );
    DoMethod(data -> BT_Load   , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Load     );
    DoMethod(data -> BT_Can    , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Cancelled);
    DoMethod(data -> BT_Stop   , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Stopped  );
    DoMethod(data -> BT_Error  , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Error    );
    DoMethod(data -> BT_Panic  , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Panic    );

    DoMethod(data -> BT_TypeC5 , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Round5    );
    DoMethod(data -> BT_TypeC11, MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Round11   );
    DoMethod(data -> BT_TypeS5 , MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Square5   );
    DoMethod(data -> BT_TypeS11, MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Square11  );
    DoMethod(data -> BT_TypeR11, MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Rect11    );
    DoMethod(data -> BT_TypeR15, MUIM_Notify, MUIA_Pressed, FALSE, data -> ML_LED, 3, MUIM_Set, MUIA_TWFmultiLED_Type  , MUIV_TWFmultiLED_Type_Rect15    );

    DoMethod(obj, OM_ADDMEMBER, data -> GP_Prefs);

    DEBUGLOG(kprintf("PrefsNew(): finished setting up domethods\n");)

    return((ULONG)obj);

}/*GFE*/


/* ULONG PrefsSetup(IClass *, Object *, MUIP_Setup)                          */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=                          */
/* Setup routine, this ensures the various gadgets are set correctly prior   */
/* to showing the preferences.                                               */

/*GFS*/  ULONG PrefsSetup(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) struct MUIP_Setup *msg)
{
    struct PrefsData *data = INST_DATA(cl, obj);
//         ULONG      PenSpec;

    if(!(DoSuperMethodA(cl,obj,(Msg)msg))) return(FALSE);

/*    get(data -> PP_Off      , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_Off      , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> PP_On       , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_On       , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> PP_Ok       , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_Ok       , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> PP_Wait     , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_Wait     , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> PP_Work     , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_Work     , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> PP_Load     , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_Load     , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> PP_Cancel   , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_Cancel   , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> PP_Stop     , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_Stop     , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> PP_Error    , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_Error    , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> PP_Panic    , MUIA_Pendisplay_Spec, &PenSpec);
    set(data -> PP_Panic    , MUIA_Pendisplay_Spec, PenSpec );
    get(data -> CY_Type     , MUIA_Cycle_Active   , &PenSpec);
    set(data -> CY_Type     , MUIA_Cycle_Active   , PenSpec );
    get(data -> SL_Timeout  , MUIA_Numeric_Value  , &PenSpec);
    set(data -> SL_Timeout  , MUIA_Numeric_Value  , PenSpec );*/

    return(TRUE);
}/*GFE*/


/* void LoadPenSpec(Object *, ULONG, ...)                                    */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=                                    */
/* This routine attempts to find the PenSpec identified by SpecID in the     */
/* settings configdata. If it finds it then it sets the Spec for Dest to the */
/* value loaded. Otherwise the default values are used.                      */

/*GFS*/  void LoadPenSpec(Object *Dest, ULONG SpecID, ULONG DefRed, ULONG DefGreen, ULONG DefBlue, struct MUIP_Settingsgroup_ConfigToGadgets *msg)
{
    struct MUI_PenSpec *PenSpec = NULL;
           Object      *PD_Temp = NULL;;

    // Used later on...
    PD_Temp = MUI_NewObject(MUIC_Pendisplay, TAG_DONE);

    if(PenSpec = (struct MUI_PenSpec *)DoMethod(msg -> configdata, MUIM_Dataspace_Find, SpecID)) {
        set(Dest, MUIA_Pendisplay_Spec, PenSpec);
    } else {
        if(PD_Temp) {
            DoMethod(PD_Temp, MUIM_Pendisplay_SetRGB, DefRed, DefGreen, DefBlue);
            get(PD_Temp, MUIA_Pendisplay_Spec, &PenSpec);
            set(Dest, MUIA_Pendisplay_Spec, PenSpec);
        }
    }

    if(PD_Temp) MUI_DisposeObject(PD_Temp);

}/*GFE*/


/* ULONG PrefsConfigToGadgets(IClass *, Object *, ...)                       */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                       */
/* This loads the settings for the class from the provided configuration and */
/* sets the various preference gadgets to the values loaded (or their def    */
/* value).                                                                   */

/*GFS*/  ULONG PrefsConfigToGadgets(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) struct MUIP_Settingsgroup_ConfigToGadgets *msg)
{
    struct PrefsData   *data    = INST_DATA(cl, obj);
           ULONG        TypeTemp= NULL;

    DEBUGLOG(kprintf("In PrefsConfigToGadgets()\n");)

    // Sort out the pens..
    LoadPenSpec(data -> PP_Off   , MUICFG_TWFmultiLED_Off      , 0x00000000, 0x00000000, 0x00000000, msg);
    LoadPenSpec(data -> PP_On    , MUICFG_TWFmultiLED_On       , 0x00000000, 0x77777777, 0x00000000, msg);
    LoadPenSpec(data -> PP_Ok    , MUICFG_TWFmultiLED_Ok       , 0x00000000, 0xFFFFFFFF, 0x00000000, msg);
    LoadPenSpec(data -> PP_Wait  , MUICFG_TWFmultiLED_Waiting  , 0x00000000, 0x00000000, 0x77777777, msg);
    LoadPenSpec(data -> PP_Work  , MUICFG_TWFmultiLED_Working  , 0x00000000, 0x00000000, 0xFFFFFFFF, msg);
    LoadPenSpec(data -> PP_Load  , MUICFG_TWFmultiLED_Load     , 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF, msg);
    LoadPenSpec(data -> PP_Cancel, MUICFG_TWFmultiLED_Cancelled, 0x77777777, 0x00000000, 0x00000000, msg);
    LoadPenSpec(data -> PP_Stop  , MUICFG_TWFmultiLED_Stopped  , 0xFFFFFFFF, 0x77777777, 0x00000000, msg);
    LoadPenSpec(data -> PP_Error , MUICFG_TWFmultiLED_Error    , 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, msg);
    LoadPenSpec(data -> PP_Panic , MUICFG_TWFmultiLED_Panic    , 0xFFFFFFFF, 0x00000000, 0x00000000, msg);

    DEBUGLOG(kprintf("PrefsConfigToGadgets(): Loaded all pens\n");)

    // Now deal with the type
    if(TypeTemp = DoMethod(msg -> configdata, MUIM_Dataspace_Find, MUICFG_TWFmultiLED_Type))
        set(data -> CY_Type, MUIA_Cycle_Active, *(ULONG *)TypeTemp);
    else
        set(data -> CY_Type, MUIA_Cycle_Active, 0);

    DEBUGLOG(kprintf("PrefsConfigToGadgets(): Loaded type\n");)

    // And the timout
    if(TypeTemp = DoMethod(msg -> configdata, MUIM_Dataspace_Find, MUICFG_TWFmultiLED_TimeOut))
        set(data -> SL_Timeout, MUIA_Numeric_Value, *(ULONG *)TypeTemp);
    else
        set(data -> SL_Timeout, MUIA_Numeric_Value, 0);

    DEBUGLOG(kprintf("PrefsConfigToGadgets(): Loaded Timeout\n");)


    return(0);
}/*GFE*/


/* ULONG PrefsGadgetToConfig(IClass *, Object *, ...)                        */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=                        */
/* This routine does the opposite of PrefsConfigToGadgets() above - it saves */
/* the settings held in the gadgets to the configuration.                    */

/*GFS*/  ULONG PrefsGadgetsToConfig(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) struct MUIP_Settingsgroup_GadgetsToConfig *msg)
{
    struct PrefsData   *data    = INST_DATA(cl, obj);
    struct MUI_PenSpec *PenSpec = NULL;
           ULONG        Type    = NULL;

    // Deal with the colours...
    get(data -> PP_Off  , MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_Off  );

    get(data -> PP_On   , MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_On   );

    get(data -> PP_Ok   , MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_Ok   );

    get(data -> PP_Wait , MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_Waiting);

    get(data -> PP_Work , MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_Working);

    get(data -> PP_Load , MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_Load );

    get(data -> PP_Cancel, MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_Cancelled);

    get(data -> PP_Stop , MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_Stopped);

    get(data -> PP_Error, MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_Error);

    get(data -> PP_Panic, MUIA_Pendisplay_Spec, &PenSpec);
    if(PenSpec) DoMethod(msg -> configdata, MUIM_Dataspace_Add, PenSpec, sizeof(struct MUI_PenSpec), MUICFG_TWFmultiLED_Panic);

    // Type...
    get(data -> CY_Type, MUIA_Cycle_Active, &Type);
    DoMethod(msg -> configdata, MUIM_Dataspace_Add, &Type, 4, MUICFG_TWFmultiLED_Type);

    // Timeout...
    get(data -> SL_Timeout, MUIA_Numeric_Value, &Type);
    DoMethod(msg -> configdata, MUIM_Dataspace_Add, &Type, 4, MUICFG_TWFmultiLED_TimeOut);

    return(0);
}/*GFE*/


/*GFS*/  ULONG PrefsDispatcher(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
{
    switch(msg->MethodID)
    {
        case OM_NEW                            : return(PrefsNew            (cl,obj,(APTR)msg));
        case MUIM_Setup                        : return(PrefsSetup          (cl,obj,(APTR)msg));
        case MUIM_Settingsgroup_ConfigToGadgets: return(PrefsConfigToGadgets(cl,obj,(APTR)msg));
        case MUIM_Settingsgroup_GadgetsToConfig: return(PrefsGadgetsToConfig(cl,obj,(APTR)msg));
        default                                : return(DoSuperMethodA(cl,obj,msg));
    }
    
}/*GFE*/
