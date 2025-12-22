//     ___       ___
//   _/  /_______\  \_     ___ ___ __ _                       _ __ ___ ___
//__//  / _______ \  \\___/                                               \___
//_/ | '  \__ __/  ` | \_/        © Copyright 1999, Christopher Page       \__
// \ | |    | |__  | | / \   Released as Free Software under the GNU GPL   /
//  >| .    |  _/  . |<   >--- --- -- -                       - -- --- ---<
// / \  \   | |   /  / \ / This file is part of the <--NAME-> source code  \
// \  \  \_/   \_/  /  / \  and it is released under the GNU GPL. Please   /
//  \  \           /  /   \   read the "COPYING" file which should have   /
// //\  \_________/  /\\ //\    been included in the distribution arc.   /
//- --\   _______   /-- - --\      for full details of the license      /-----
//-----\_/       \_/---------\   ___________________________________   /------
//                            \_/                                   \_/
//
// Description:
//
//  LED gadget class
//
// Functions:
//
//  void  INIT_7_InitClass(struct Library *base)
//  void  EXIT_7_ExitClass(void)
//  ULONG MCC_Query       (REG(d0) LONG Which)
//  void  ClassReleasePen (struct MUI_RenderInfo *RendInfo, LONG *PenNum)
//  void  ClassObtainPen  (struct MUI_RenderInfo *RendInfo, LONG *PenNum, struct MUI_PenSpec *Spec)
//  BOOL  LoadPenSpec     (struct ClassData *data, Object *obj, ULONG Entry, ULONG SpecID, ULONG DefRed, ULONG DefGreen, ULONG DefBlue)
//  void  DrawRectangle   (Object *obj, struct ClassData *data)
//  void  DrawSmallRound  (Object *obj, struct ClassData *data)
//  void  DrawLargeRound  (Object *obj, struct ClassData *data)
//  ULONG LEDSecTrigger   (struct IClass *cl, Object *obj, Msg msg)
//  ULONG LEDNew          (struct IClass *cl, Object *obj, Msg msg)
//  ULONG LEDSetup        (struct IClass *cl, Object *obj, struct MUIP_Setup *msg)
//  ULONG LEDCleanup      (struct IClass *cl, Object *obj, Msg msg)
//  ULONG LEDAskMinMax    (struct IClass *cl, Object *obj, struct MUIP_AskMinMax *msg)
//  ULONG LEDDraw         (struct IClass *cl, Object *obj, struct MUIP_Draw *msg)
//  ULONG LEDSet          (struct IClass *cl, Object *obj, struct opSet *msg)
//  ULONG LEDGet          (struct IClass *cl, Object *obj, struct opGet *msg)
//  ULONG ClassDispatcher (REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
//
// Detail:
//
//  This file contains the full source for the TWFmultiLED class, now available under
//  GNU GPL. Apparently there are numerous hits caused by this class, although I am
//  unable to track down their exact source. If you locate the cause of these hits,
//  I would be grateful if you email me and tell me what I did wrong! I fear however
//  that a lot of the problems will have been caused by StormC's amazing Library
//  handling, if so the source should compile - with some modifications - under SAS
//  or Dice and work correctly... Either way, if you use this source, drop me a line
//  if you have any comments (although comments along the lines of "Your code suxx"
//  will not be warmly welcomed ;))
//
// Modification History:
//
//
// Fold Markers:
//
//  Start: /*GFS*/
//    End: /*GFE*/

#include "TWFmultiLED.mcc.h"

// Declare the library base..
struct TWFmultiLEDBase
{
    struct Library led_Library  ;
};

#pragma libbase TWFmultiLEDBase

extern char _VERSION, _REVISION;
extern struct ExecBase *SysBase;
       struct Library  *MUIMasterBase = NULL;

// The custom class pointer.
struct MUI_CustomClass *LEDClass = NULL;


// Prototypes.
// -=-=-=-=-=-
// This is declared in storm.lib, shuts everything down if the INIT fails
extern void  abortLibInit   (void);
       ULONG MCC_Query      (REG(d0) LONG Which);
       ULONG ClassDispatcher(REG(a0) struct IClass *, REG(a2) Object *, REG(a1) Msg);
       ULONG LEDSet         (        struct IClass *,         Object *, struct opSet *msg);


/* INIT_3_InitClass(TWFmultiLEDBasestruct *)                                 */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                                 */
/* Custom initialisation function. Opens muimaster.library and then creates  */
/* my custom class. I have to admit it's neater than having to write all the */
/* LibInit(), LibOpen() etc.                                                 */

/*GFS*/  void INIT_7_InitClass(struct Library *base)
{
    if(SysBase -> LibNode.lib_Version > 38 && SysBase -> AttnFlags & AFF_68030) {
        if(MUIMasterBase = OpenLibrary(MUIMASTER_NAME, MUIMASTER_VMIN)) {
            if(LEDClass = MUI_CreateCustomClass(base, MUIC_Area, NULL, sizeof(struct ClassData), ClassDispatcher)) {
                return;
            }
            CloseLibrary(MUIMasterBase);
        }
    }
    abortLibInit();

}/*GFE*/


/* EXIT_3_ExitClass(void)                                                    */
/* -=-=-=-=-=-=-=-=-=-=-=                                                    */
/* Custom destructor function for the library base, just deletes the custom  */
/* class and frees muimaster.                                                */

/*GFS*/  void EXIT_7_ExitClass(void)
{
    if(LEDClass) MUI_DeleteCustomClass(LEDClass);
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
        case 0: return((ULONG)LEDClass);
    }
    return(NULL);
}/*GFE*/


/* void ClassReleasePen(MUI_REnderInco *, LONG *)                            */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=                            */
/* This frees a pen allocated by ClassObtainPen(). It checks that the pen has*/
/* been allocated before it attempts to free it.                             */

/*GFS*/  void ClassReleasePen(struct MUI_RenderInfo *RendInfo, LONG *PenNum)
{
    if(*PenNum != -1) {
        if(RendInfo) MUI_ReleasePen(RendInfo, *PenNum);
        *PenNum = -1;
    }
}/*GFE*/


/* void ClassObtainPen(MUI_RenderInfo *, LONG *, MUI_PenSpec *)              */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=              */
/* Just a wrapper for MUI_ObtainPen() that handles releasing of pens before  */
/* allocating a new one, this means the function can be called on the same   */
/* pen number several times without the need to call ClassRealsePen()        */

/*GFS*/  void ClassObtainPen(struct MUI_RenderInfo *RendInfo, LONG *PenNum, struct MUI_PenSpec *Spec)
{
    DEBUGLOG(kprintf("ClassObtainPen(): obtaining pen\n");)
    if(RendInfo) {
        ClassReleasePen(RendInfo, PenNum);
        *PenNum = MUI_ObtainPen(RendInfo, Spec, 0);
    }
    DEBUGLOG(kprintf("ClassObtainPen(): pen obtained\n");)

}/*GFE*/


/* BOOL LoadPenSpec(ClassData *, Object *, ULONG, ULONG, ULONG, ULONG, ULONG)*/
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- */
/* This tries to load and allocate a pen from the configuration, if the pen  */
/* is not found in the config then the provided default values are used      */

/*GFS*/  BOOL LoadPenSpec(struct ClassData *data, Object *obj, ULONG Entry, ULONG SpecID, ULONG DefRed, ULONG DefGreen, ULONG DefBlue)
{
    struct MUI_PenSpec  *PenSpec = NULL;
           Object       *PD_Temp = NULL;;

    DEBUGLOG(kprintf("LoadPenSpec(): Loading pen for entry %d\n", Entry);)

    // Used later on...
    if(!(PD_Temp = MUI_NewObject(MUIC_Pendisplay, TAG_DONE))) return(FALSE);

    // Load the pin info...
    if(SpecID) {
        if(!(DoMethod(obj, MUIM_GetConfigItem, SpecID, &PenSpec))) {
            DoMethod(PD_Temp, MUIM_Pendisplay_SetRGB, DefRed, DefGreen, DefBlue);
            get(PD_Temp, MUIA_Pendisplay_Spec    , &PenSpec);
        }
    } else {
        DoMethod(PD_Temp, MUIM_Pendisplay_SetRGB, DefRed, DefGreen, DefBlue);
        get(PD_Temp, MUIA_Pendisplay_Spec    , &PenSpec);
        CopyMem(&PenSpec, &data -> CustomPen, sizeof(struct MUI_PenSpec));
        data -> GotCustom = TRUE;
    }

    ClassObtainPen(data -> RendInfo, &data -> Pens[Entry], PenSpec);

    MUI_DisposeObject(PD_Temp);

}/*GFE*/


/* The next three routines are used by the LEDDraw routine to render the LED */
/* image. The DrawRectangle() routine can be used for all the rectagular and */
/* square LEDs, but specific routines are required for the round ones..      */

/*GFS*/  void DrawRectangle (Object *obj, struct ClassData *data)
{
    ULONG OldPen = GetAPen(_rp(obj));

    DEBUGLOG(kprintf("DrawRectangle(): pen is %ld, rp is 0x%08lX\n", MUIPEN(data -> BackPen), _rp(obj));)

    // Draw the background...
    SetAPen (_rp(obj), MUIPEN(data -> BackPen));
    RectFill(_rp(obj), _mleft(obj), _mtop(obj), _mright(obj), _mbottom(obj));

    // Draw the frame...
    SetAPen (_rp(obj), _dri(obj) -> dri_Pens[SHADOWPEN]);
    Move(_rp(obj), _mleft (obj), _mbottom(obj));
    Draw(_rp(obj), _mleft (obj), _mtop   (obj));
    Draw(_rp(obj), _mright(obj), _mtop   (obj));

    SetAPen (_rp(obj), _dri(obj) -> dri_Pens[SHINEPEN]);
    Draw(_rp(obj), _mright(obj)    , _mbottom(obj));
    Draw(_rp(obj), _mleft (obj) + 1, _mbottom(obj));

    // Draw fancy stuff.
    if(_mheight(obj) > 7) {
        WritePixel(_rp(obj), _mleft (obj) + 2, _mtop   (obj) + 3);
        WritePixel(_rp(obj), _mleft (obj) + 3, _mtop   (obj) + 2);
        WritePixel(_rp(obj), _mright(obj) - 2, _mbottom(obj) - 3);
        WritePixel(_rp(obj), _mright(obj) - 3, _mbottom(obj) - 2);
        WritePixel(_rp(obj), _mright(obj) - 2, _mbottom(obj) - 2);
    }

    WritePixel(_rp(obj), _mleft(obj) + 2, _mtop(obj) + 2);

    // Restore pen..
    SetAPen(_rp(obj), OldPen);
}/*GFE*/

/*GFS*/  void DrawSmallRound(Object *obj, struct ClassData *data)
{
    ULONG OldPen = GetAPen(_rp(obj));

    DEBUGLOG(kprintf("DrawSmallRound(): pen is %d, rp is 0x%08lX\n", MUIPEN(data -> BackPen), _rp(obj));)

    // Draw the background...
    SetAPen (_rp(obj), MUIPEN(data -> BackPen));
    RectFill(_rp(obj), _mleft(obj) + 1, _mtop(obj) + 1, _mright(obj) - 1, _mbottom(obj) - 1);

    // Draw the frame...
    SetAPen (_rp(obj), _dri(obj) -> dri_Pens[SHADOWPEN]);
    Move(_rp(obj), _mleft(obj), _mtop(obj) + 4);
    Draw(_rp(obj), _mleft(obj), _mtop(obj) + 2);
    Draw(_rp(obj), _mleft(obj) + 2, _mtop(obj));
    Draw(_rp(obj), _mleft(obj) + 4, _mtop(obj));
    WritePixel(_rp(obj), _mleft (obj) + 1, _mbottom(obj) - 1);
    WritePixel(_rp(obj), _mright(obj) - 1, _mtop   (obj) + 1);

    SetAPen (_rp(obj), _dri(obj) -> dri_Pens[SHINEPEN]);
    Move(_rp(obj), _mright(obj)    , _mtop   (obj) + 2);
    Draw(_rp(obj), _mright(obj)    , _mbottom(obj) - 2);
    Draw(_rp(obj), _mright(obj) - 2, _mbottom(obj));
    Draw(_rp(obj), _mleft (obj) + 2, _mbottom(obj));

    // Draw fancy stuff.
    WritePixel(_rp(obj), _mleft(obj) + 2, _mtop(obj) + 2);

    // Restore pen..
    SetAPen(_rp(obj), OldPen);
}/*GFE*/

/*GFS*/  void DrawLargeRound(Object *obj, struct ClassData *data)
{
    ULONG OldPen = GetAPen(_rp(obj));

    DEBUGLOG(kprintf("DrawLargeRound(): pen is %d, rp is 0x%08lX\n", MUIPEN(data -> BackPen), _rp(obj));)

    // Draw the background...
    SetAPen (_rp(obj), MUIPEN(data -> BackPen));
    RectFill(_rp(obj), _mleft(obj) + 2, _mtop(obj) + 2, _mright(obj) - 2, _mbottom(obj) - 2);
    Move(_rp(obj), _mleft(obj)  + 1, _mbottom(obj) - 4);
    Draw(_rp(obj), _mleft(obj)  + 1, _mtop   (obj) + 4);
    Move(_rp(obj), _mright(obj) - 1, _mbottom(obj) - 4);
    Draw(_rp(obj), _mright(obj) - 1, _mtop   (obj) + 4);
    Move(_rp(obj), _mleft(obj)  + 4, _mtop   (obj) + 1);
    Draw(_rp(obj), _mright(obj) - 4, _mtop   (obj) + 1);
    Move(_rp(obj), _mleft(obj)  + 4, _mbottom(obj) - 1);
    Draw(_rp(obj), _mright(obj) - 4, _mbottom(obj) - 1);

    // Draw the frame...
    SetAPen (_rp(obj), _dri(obj) -> dri_Pens[SHADOWPEN]);
    Move(_rp(obj), _mleft (obj) + 3, _mbottom(obj) - 1);
    Draw(_rp(obj), _mleft (obj)    , _mbottom(obj) - 4);
    Draw(_rp(obj), _mleft (obj)    , _mtop   (obj) + 4);
    Draw(_rp(obj), _mleft (obj) + 4, _mtop   (obj));
    Draw(_rp(obj), _mright(obj) - 4, _mtop   (obj));
    Draw(_rp(obj), _mright(obj)    , _mtop   (obj) + 4);

    SetAPen (_rp(obj), _dri(obj) -> dri_Pens[SHINEPEN]);
    Move(_rp(obj), _mright(obj)    , _mbottom(obj) - 4);
    Draw(_rp(obj), _mright(obj) - 4, _mbottom(obj));
    Draw(_rp(obj), _mleft (obj) + 4, _mbottom(obj));

    // Draw fancy stuff.
    WritePixel(_rp(obj), _mleft(obj) + 4, _mtop(obj) + 3);
    WritePixel(_rp(obj), _mleft(obj) + 3, _mtop(obj) + 4);

    // Restore pen..
    SetAPen(_rp(obj), OldPen);
}/*GFE*/



/* ULONG LEDSecTrigger(IClass *, Object *, Msg)                              */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=                              */
/* This is used to implement an 'auto-off' feature in the LED class, it is   */
/* called once every second (hence the name) and it decrements a counter,    */
/* turning the LEd off if the counter hits 0.                                */

/*GFS*/  static ULONG LEDSecTrigger(struct IClass *cl, Object *obj, Msg msg)
{
    struct ClassData *data = (struct ClassData *)INST_DATA(cl,obj);

    if(data -> LampPos > 0) {
        data -> LampPos --;
        if(data -> LampPos == 0) {
            set(obj, MUIA_TWFmultiLED_Colour, MUIV_TWFmultiLED_Colour_Off);
        }
    }

    return(FALSE);
}/*GFE*/


/* ULONG LEDNew(IClass *, Object *, Msg)                                     */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                                     */
/* This implements the OM_NEW method, initialising the instance variables to */
/* useful default states before calling the set routine to handle the user's */
/* settings.                                                                 */

/*GFS*/  ULONG LEDNew(struct IClass *cl, Object *obj, Msg msg)
{
    struct ClassData *data   = NULL;
           ULONG      Type   = NULL;
           ULONG      Pen    = NULL;

    DEBUGLOG(kprintf("LEDNew(): In new\n");)

    if(!(obj = (Object *)DoSuperMethodA(cl, obj, msg)))
        return(NULL);

    DEBUGLOG(kprintf("LEDNew(): Object created\n");)

    data = INST_DATA(cl, obj);

    DEBUGLOG(kprintf("LEDNew(): Obtained instance data\n");)

    data -> BackPen   = -1;
    data -> PenNum    =  0;
    data -> GotCustom = FALSE;

    data -> UserType  = TRUE;
    data -> UserTime  = FALSE;

    for(Pen = 0; Pen < 11; Pen ++) data -> Pens[Pen] = -1;

    DEBUGLOG(kprintf("LEDNew(): Instance data setup complete, obtaining type\n");)

    data -> Shape = MUIV_TWFmultiLED_Type_Round5;

    data -> ihnode.ihn_Object  = obj;
    data -> ihnode.ihn_Method  = MUIM_TWFmultiLED_SecTrigger;
    data -> ihnode.ihn_Flags   = MUIIHNF_TIMER;
    data -> ihnode.ihn_Millis  = 1000;

    data -> LampPos = 0;
    data -> LampMax = 0;
    data -> HandleOn = FALSE;

    DEBUGLOG(kprintf("LEDNew(): Coercing to Set\n");)

    msg -> MethodID = OM_SET;
    DoMethodA(obj, (Msg)msg);
    msg -> MethodID = OM_NEW;

    return((ULONG)obj);

}/*GFE*/


/* ULONG LEDSetup(IClass *, Object *, MUIP_Setup)                            */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=                            */
/* This is called by the dispatcher when MUI is about to open the window in  */
/* which the object will appear. It attempts to get shared locks on ALL the  */
/* pens the class will need, I've done it this way for two reasons - the LED */
/* may be used in several places, so an exclusive lock per LED could quickly */
/* eat up a user's free pens, and it also makes redraw faster.               */

/*GFS*/  ULONG LEDSetup(struct IClass *cl, Object *obj, struct MUIP_Setup *msg)
{
    struct ClassData *data = INST_DATA(cl, obj);
           LONG       Type = NULL;

    DEBUGLOG(kprintf("LEDSetup(): In setup\n");)

    if(!(DoSuperMethodA(cl,obj,(Msg)msg))) return(FALSE);

    DEBUGLOG(kprintf("LEDSetup(): Done super class method\n");)

    data -> RendInfo = msg -> RenderInfo;

    DEBUGLOG(kprintf("LEDSetup(): Got render info, calling load\n");)

    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Off      , MUICFG_TWFmultiLED_Off      , 0x00000000, 0x00000000, 0x00000000);
    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_On       , MUICFG_TWFmultiLED_On       , 0x00000000, 0x77777777, 0x00000000);
    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Ok       , MUICFG_TWFmultiLED_Ok       , 0x00000000, 0xFFFFFFFF, 0x00000000);
    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Load     , MUICFG_TWFmultiLED_Load     , 0x00000000, 0xFFFFFFFF, 0xFFFFFFFF);
    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Error    , MUICFG_TWFmultiLED_Error    , 0xFFFFFFFF, 0xFFFFFFFF, 0x00000000);
    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Panic    , MUICFG_TWFmultiLED_Panic    , 0xFFFFFFFF, 0x00000000, 0x00000000);

    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Working  , MUICFG_TWFmultiLED_Working  , 0x00000000, 0x00000000, 0xFFFFFFFF);
    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Waiting  , MUICFG_TWFmultiLED_Waiting  , 0x00000000, 0x00000000, 0x77777777);
    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Cancelled, MUICFG_TWFmultiLED_Cancelled, 0x77777777, 0x00000000, 0x00000000);
    LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Stopped  , MUICFG_TWFmultiLED_Stopped  , 0xFFFFFFFF, 0x77777777, 0x00000000);

    if(data -> GotCustom) {
        LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Custom, NULL, data -> CustomRaw.Red, data -> CustomRaw.Green, data -> CustomRaw.Blue);
    }

    if(data -> UserType) {
        if(DoMethod(obj, MUIM_GetConfigItem, MUICFG_TWFmultiLED_Type, &Type)) {
            data -> Shape = *(ULONG *)Type;
        } else {
            data -> Shape = MUIV_TWFmultiLED_Type_Round5;
        }
    }

    if(data -> UserTime) {
        if(DoMethod(obj, MUIM_GetConfigItem, MUICFG_TWFmultiLED_TimeOut, &Type)) {
            data -> LampMax = *(ULONG *)Type;
        } else {
            data -> LampMax = 0;
        }
    }

    if(data -> LampMax) {
        DEBUGLOG(kprintf("Setup(): actiavated input handler\n");)
        DoMethod(_app(obj), MUIM_Application_AddInputHandler, &data->ihnode);
        data -> HandleOn = TRUE;
    }

    DEBUGLOG(kprintf("Setup(): type is %d\n", data -> Shape);)

    data -> BackPen = data -> Pens[data -> PenNum];

    return(TRUE);
}/*GFE*/


/* ULONG LEDCleanup(IClass *, Object *, Msg)                                 */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                                 */
/* Basically the opposite of LEDSetup, this released the pens allocated by   */
/* that routine and removes the InputHandler for the led timeout.            */

/*GFS*/  ULONG LEDCleanup(struct IClass *cl, Object *obj, Msg msg)
{
    struct ClassData *data = INST_DATA(cl, obj);

    DEBUGLOG(kprintf("LEDCleanup(): In cleanup, freeing pens\n");)

    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Off   ]);
    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_On    ]);
    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Ok    ]);
    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Load  ]);
    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Error ]);
    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Panic ]);
    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Custom]);

    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Working  ]);
    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Waiting  ]);
    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Cancelled]);
    ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Stopped  ]);

    data -> RendInfo = NULL;

    if(data -> HandleOn) {
        DoMethod(_app(obj), MUIM_Application_RemInputHandler, &data->ihnode);
    }

    DEBUGLOG(kprintf("LEDCleanup(): cleanup complete\n");)

    return(DoSuperMethodA(cl,obj,msg));
}/*GFE*/


/* ULONG LEDAskMinMax(IClass *, Object *, MUIP_AskMinMax *)                  */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=                  */
/* MUI calls this to establish the LED's required dimensions, I have used a  */
/* switch() to fill in the AskMinMax structure, but there are other ways you */
/* could so this (array look-up is a possibility... ?)                       */

/*GFS*/  ULONG LEDAskMinMax(struct IClass *cl, Object *obj, struct MUIP_AskMinMax *msg)
{
    struct ClassData  *data   = INST_DATA(cl, obj);
    struct MUI_MinMax *MinMax;

    DoSuperMethodA(cl, obj, (Msg)msg);

    MinMax = msg -> MinMaxInfo;

    DEBUGLOG(kprintf("LEDAskMinMax(): (%ld x %ld) - (%ld x %ld) - (%ld x %ld)\n", MinMax -> MinWidth, MinMax -> MinHeight,
                                                                            MinMax -> DefWidth, MinMax -> DefHeight,
                                                                            MinMax -> MaxWidth, MinMax -> MaxHeight);)

    DEBUGLOG(kprintf("LEDAskMinMax(): type is %d\n", data -> Shape);)

    switch(data -> Shape) {
        case MUIV_TWFmultiLED_Type_Round5  : MinMax -> MinWidth  =  7;
                                             MinMax -> MinHeight =  7;
                                             MinMax -> DefWidth  =  7;
                                             MinMax -> DefHeight =  7;
                                             MinMax -> MaxWidth  =  7;
                                             MinMax -> MaxHeight =  7;
            break;
        case MUIV_TWFmultiLED_Type_Round11 : MinMax -> MinWidth  = 13;
                                             MinMax -> MinHeight = 13;
                                             MinMax -> DefWidth  = 13;
                                             MinMax -> DefHeight = 13;
                                             MinMax -> MaxWidth  = 13;
                                             MinMax -> MaxHeight = 13;
            break;
        case MUIV_TWFmultiLED_Type_Square5 : MinMax -> MinWidth  =  7;
                                             MinMax -> MinHeight =  7;
                                             MinMax -> DefWidth  =  7;
                                             MinMax -> DefHeight =  7;
                                             if(!data -> FreeSize) {
                                                 MinMax -> MaxWidth  =  7;
                                                 MinMax -> MaxHeight =  7;
                                             } else {
                                                 MinMax -> MaxWidth  = 40;
                                                 MinMax -> MaxHeight = 40;
                                             }
            break;
        case MUIV_TWFmultiLED_Type_Square11: MinMax -> MinWidth  = 13;
                                             MinMax -> MinHeight = 13;
                                             MinMax -> DefWidth  = 13;
                                             MinMax -> DefHeight = 13;
                                             if(!data -> FreeSize) {
                                                 MinMax -> MaxWidth  = 13;
                                                 MinMax -> MaxHeight = 13;
                                             } else {
                                                 MinMax -> MaxWidth  = 40;
                                                 MinMax -> MaxHeight = 40;
                                             }
            break;
        case MUIV_TWFmultiLED_Type_Rect11  : MinMax -> MinWidth  = 13;
                                             MinMax -> MinHeight =  7;
                                             MinMax -> DefWidth  = 13;
                                             MinMax -> DefHeight =  7;
                                             if(!data -> FreeSize) {
                                                 MinMax -> MaxWidth  = 13;
                                                 MinMax -> MaxHeight =  7;
                                             } else {
                                                 MinMax -> MaxWidth  = 40;
                                                 MinMax -> MaxHeight = 40;
                                             }
            break;
        default                            : MinMax -> MinWidth  = 17;
                                             MinMax -> MinHeight = 13;
                                             MinMax -> DefWidth  = 17;
                                             MinMax -> DefHeight = 13;
                                             if(!data -> FreeSize) {
                                                 MinMax -> MaxWidth  = 17;
                                                 MinMax -> MaxHeight = 13;
                                             } else {
                                                 MinMax -> MaxWidth  = 40;
                                                 MinMax -> MaxHeight = 40;
                                             }
            break;
    }

    DEBUGLOG(kprintf("LEDAskMinMax(): (%ld x %ld) - (%ld x %ld) - (%ld x %ld)\n", MinMax -> MinWidth, MinMax -> MinHeight,
                                                                            MinMax -> DefWidth, MinMax -> DefHeight,
                                                                            MinMax -> MaxWidth, MinMax -> MaxHeight);)


    return(0);
}/*GFE*/


/* ULONG LEDDraw(IClass *, Object *, MUIP_Draw *)                            */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=                            */
/* This does the actual rendering of the LED.. well, actually it calls one of*/
/* the Drawxxxxx() routines above which then render the LED.                 */

/*GFS*/  ULONG LEDDraw(struct IClass *cl, Object *obj, struct MUIP_Draw *msg)
{
    struct ClassData *data = INST_DATA(cl, obj);

    DoSuperMethodA(cl, obj, (Msg)msg);

    DEBUGLOG(kprintf("Draw(): working with shape %d\n", data -> Shape));

    switch(data -> Shape) {
        case MUIV_TWFmultiLED_Type_Round5 : DrawSmallRound(obj, data); break;
        case MUIV_TWFmultiLED_Type_Round11: DrawLargeRound(obj, data); break;
        default                           : DrawRectangle (obj, data); break;
    }

    return(0);
}/*GFE*/


/* ULONG LEDSet(IClass *, Object *, opSet *)                                 */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                                 */
/* This implements the OM_SET (note that this does *not* do any notify stuff)*/
/* It uses a method based onthat used by Kmel in the Tron class.             */

/*GFS*/  ULONG LEDSet(struct IClass *cl, Object *obj, struct opSet *msg)
{
    struct ClassData       *data       = INST_DATA(cl, obj);
    struct TWFmultiLED_RGB *RGBSetting = NULL;
    struct TagItem         *TagList    = NULL;
    struct TagItem         *Tag        = NULL;
           LONG             Type       = NULL;
           BOOL             Refresh    = TRUE;

    if(msg -> ops_AttrList) {
        for(TagList = msg -> ops_AttrList; Tag = NextTagItem(&TagList);) {

            switch(Tag -> ti_Tag) {
                case MUIA_TWFmultiLED_Colour: if((Tag -> ti_Data >= 0) && (Tag -> ti_Data < 11)) {
                                                  data -> BackPen = data -> Pens[Tag -> ti_Data];
                                                  data -> PenNum  = Tag -> ti_Data;
                                                  if(data -> PenNum > 0) {
                                                      data -> LampPos = data -> LampMax;
                                                  }
                                                  DEBUGLOG(kprintf("Set(): Changing colour to %ld, LampPos now %ld\n", data -> PenNum, data -> LampPos);)
                                              }
                    break;
                case MUIA_TWFmultiLED_Custom: if(Tag -> ti_Data) {
                                                  RGBSetting = (struct TWFmultiLED_RGB *)Tag -> ti_Data;
                                                  CopyMem(RGBSetting, &data -> CustomRaw, sizeof(struct TWFmultiLED_RGB));
                                                  LoadPenSpec(data, obj, MUIV_TWFmultiLED_Colour_Custom, NULL, RGBSetting -> Red, RGBSetting -> Green, RGBSetting -> Blue);
                                              } else {
                                                  data -> GotCustom = FALSE;
                                                  ClassReleasePen(data -> RendInfo, &data -> Pens[MUIV_TWFmultiLED_Colour_Custom]);
                                                  data -> BackPen = data -> Pens[0];
                                                  data -> PenNum  = 0;
                                              }
                    break;
                case MUIA_TWFmultiLED_Type  : if((Tag -> ti_Data >= 0) && (Tag -> ti_Data < 7)) {
                                                  if(Tag -> ti_Data == MUIV_TWFmultiLED_Type_User) {
                                                      if(data -> RendInfo) {
                                                          if(DoMethod(obj, MUIM_GetConfigItem, MUICFG_TWFmultiLED_Type, &Type)) {
                                                              data -> Shape = *(ULONG *)Type;
                                                          } else {
                                                              data -> Shape = MUIV_TWFmultiLED_Type_Round5;
                                                          }
                                                      } else {
                                                          data -> Shape = MUIV_TWFmultiLED_Type_User;
                                                      }
                                                      data -> UserType = TRUE;
                                                  } else {
                                                      data -> Shape    = Tag -> ti_Data;
                                                      data -> UserType = FALSE;
                                                  }
                                                  if(data -> RendInfo) {
                                                      set(obj, MUIA_ShowMe, FALSE);
                                                      set(obj, MUIA_ShowMe, TRUE );
                                                  }
                                                  Refresh = FALSE;
                                              }
                    break;
                case MUIA_TWFmultiLED_Free      : data -> FreeSize = (BOOL)Tag -> ti_Data;
                    break;
                case MUIA_TWFmultiLED_TimeDelay: if((LONG)Tag -> ti_Data >= 0) {
                                                     data -> LampMax = (LONG)Tag -> ti_Data;
                                                     data -> UserTime = FALSE;
                                                 } else {
                                                     if(data -> RendInfo) {
                                                         if(DoMethod(obj, MUIM_GetConfigItem, MUICFG_TWFmultiLED_TimeOut, &Type)) {
                                                             data -> LampMax = *(LONG *)Type;
                                                         } else {
                                                             data -> LampMax = 0;
                                                         }
                                                     } else {
                                                         data -> LampMax = MUIV_TWFmultiLED_TimeDelay_User;
                                                     }
                                                     data -> UserTime = TRUE;
                                                 }

                                                 // Make sure the timeout is activated.
                                                 if(data -> LampMax && data -> RendInfo && !data -> HandleOn) {
                                                     DoMethod(_app(obj), MUIM_Application_AddInputHandler, &data->ihnode);
                                                     data -> HandleOn = TRUE;
                                                 }
                    break;
            }
        }

        if(data -> RendInfo && Refresh) MUI_Redraw(obj, MADF_DRAWOBJECT);
    }

    return(DoSuperMethodA(cl, obj, (Msg)msg));
}/*GFE*/


/* ULONG LEDGet(IClass *, Object *, opGet *)                                 */
/* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-                                 */
/* A very simple OM_GET implementation which can return the version revision */
/* or one of the attributes of the superclass.                               */

/*GFS*/  ULONG LEDGet(struct IClass *cl, Object *obj, struct opGet *msg)
{
    ULONG ti_Data;
    switch(msg->opg_AttrID)
    {
        case MUIA_Version:
            ti_Data = (ULONG)&_VERSION;
        break;

        case MUIA_Revision:
            ti_Data = (ULONG)&_REVISION;
        break;

        default:
            return DoSuperMethodA(cl, obj, (Msg)msg);
        break;
    }
    *msg->opg_Storage = ti_Data;
    return TRUE;
}/*GFE*/


/*GFS*/  ULONG ClassDispatcher(REG(a0) struct IClass *cl, REG(a2) Object *obj, REG(a1) Msg msg)
{
    if(msg) {
        switch(msg->MethodID)
        {
            case OM_NEW                     : return(LEDNew        (cl, obj, (APTR)msg));
            case OM_SET                     : return(LEDSet        (cl, obj, (APTR)msg));
            case OM_GET                     : return(LEDGet        (cl, obj, (APTR)msg));
            case MUIM_Setup                 : return(LEDSetup      (cl, obj, (APTR)msg));
            case MUIM_Cleanup               : return(LEDCleanup    (cl, obj, (APTR)msg));
            case MUIM_AskMinMax             : return(LEDAskMinMax  (cl, obj, (APTR)msg));
            case MUIM_Draw                  : return(LEDDraw       (cl, obj, (APTR)msg));
            case MUIM_TWFmultiLED_SecTrigger: return(LEDSecTrigger (cl, obj, (APTR)msg));
        }
        return(DoSuperMethodA(cl, obj, msg));
    }

}/*GFE*/


