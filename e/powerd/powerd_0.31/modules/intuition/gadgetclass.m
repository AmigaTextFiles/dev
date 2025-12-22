MODULE  'intuition/intuition','utility/tagitem'

CONST GA_Dummy=$80030000,
    GA_Left=$80030001,
    GA_RelRight=$80030002,
    GA_Top=$80030003,
    GA_RelBottom=$80030004,
    GA_Width=$80030005,
    GA_RelWidth=$80030006,
    GA_Height=$80030007,
    GA_RelHeight=$80030008,
    GA_Text=$80030009,
    GA_Image=$8003000A,
    GA_Border=$8003000B,
    GA_SelectRender=$8003000C,
    GA_Highlight=$8003000D,
    GA_Disabled=$8003000E,
    GA_GZZGadget=$8003000F,
    GA_ID=$80030010,
    GA_UserData=$80030011,
    GA_SpecialInfo=$80030012,
    GA_Selected=$80030013,
    GA_EndGadget=$80030014,
    GA_Immediate=$80030015,
    GA_RelVerify=$80030016,
    GA_FollowMouse=$80030017,
    GA_RightBorder=$80030018,
    GA_LeftBorder=$80030019,
    GA_TopBorder=$8003001A,
    GA_BottomBorder=$8003001B,
    GA_ToggleSelect=$8003001C,
    GA_SysGadget=$8003001D,
    GA_SysGType=$8003001E,
    GA_Previous=$8003001F,
    GA_Next=$80030020,
    GA_DrawInfo=$80030021,
    GA_IntuiText=$80030022,
    GA_LabelImage=$80030023,
    GA_TabCycle=$80030024,
    GA_GadgetHelp=$80030025,
    GA_Bounds=$80030026,
    GA_RelSpecial=$80030027,
    GA_TextAttr=$80030028,
    GA_ReadOnly=$80030029,
    PGA_Dummy=$80031000,
    PGA_Freedom=$80031001,
    PGA_Borderless=$80031002,
    PGA_HorizPot=$80031003,
    PGA_HorizBody=$80031004,
    PGA_VertPot=$80031005,
    PGA_VertBody=$80031006,
    PGA_Total=$80031007,
    PGA_Visible=$80031008,
    PGA_Top=$80031009,
    PGA_NewLook=$8003100A,
    STRINGA_Dummy=$80032000,
    STRINGA_MaxChars=$80032001,
    STRINGA_Buffer=$80032002,
    STRINGA_UndoBuffer=$80032003,
    STRINGA_WorkBuffer=$80032004,
    STRINGA_BufferPos=$80032005,
    STRINGA_DispPos=$80032006,
    STRINGA_AltKeyMap=$80032007,
    STRINGA_Font=$80032008,
    STRINGA_Pens=$80032009,
    STRINGA_ActivePens=$8003200A,
    STRINGA_EditHook=$8003200B,
    STRINGA_EditModes=$8003200C,
    STRINGA_ReplaceMode=$8003200D,
    STRINGA_FixedFieldMode=$8003200E,
    STRINGA_NoFilterMode=$8003200F,
    STRINGA_Justification=$80032010,
    STRINGA_LongVal=$80032011,
    STRINGA_TextVal=$80032012,
    STRINGA_ExitHelp=$80032013,
    SG_DefaultMaxChars=$80,
    LAYOUTA_Dummy=$80038000,
    LAYOUTA_LayoutObj=$80038001,
    LAYOUTA_Spacing=$80038002,
    LAYOUTA_Orientation=$80038003,
    LAYOUTA_ChildMaxWidth=$80038004,
    LAYOUTA_ChildMaxHeight=$80038005,
    LORIENT_NONE=0,
    LORIENT_HORIZ=1,
    LORIENT_VERT=2,
    GM_Dummy=-1,
    GM_HITTEST=0,
    GM_RENDER=1,
    GM_GOACTIVE=2,
    GM_HANDLEINPUT=3,
    GM_GOINACTIVE=4,
    GM_HELPTEST=5,
    GM_LAYOUT=6,
    GM_DOMAIN=7,
    GM_KEYTEST=8,
    GM_KEYGOACTIVE=9,
    GM_KEYGOINACTIVE=10

#define	GA_Underscore		(GA_Dummy+42)
#define	GA_ActivateKey		(GA_Dummy+43)
#define	GA_BackFill		(GA_Dummy+44)
#define	GA_GadgetHelpText		(GA_Dummy+45)
#define	GA_UserInput		(GA_Dummy+46)

OBJECT GPHitTest
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  MouseX:WORD,
  MouseY:WORD

OBJECT GPHelpTest
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  MouseX:WORD,
  MouseY:WORD

CONST GMR_GADGETHIT=4,
    GMR_NOHELPHIT=0,
    GMR_HELPHIT=-1,
    GMR_HELPCODE=$10000

OBJECT GPRender
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  RPort:PTR TO RastPort,
  ReDraw:LONG

CONST GREDRAW_UPDATE=2,
    GREDRAW_REDRAW=1,
    GREDRAW_TOGGLE=0

OBJECT GPInput
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  IEvent:PTR TO InputEvent,
  Termination:PTR TO LONG,
  MouseX:WORD,
  MouseY:WORD,
  TabletData:PTR TO TabletData

OBJECT GPGoActive
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  IEvent:PTR TO InputEvent,
  Termination:PTR TO LONG,
  MouseX:WORD,
  MouseY:WORD,
  TabletData:PTR TO TabletData

CONST GMR_MEACTIVE=0,
    GMR_NOREUSE=2,
    GMR_REUSE=4,
    GMR_VERIFY=8,
    GMR_NEXTACTIVE=16,
    GMR_PREVACTIVE=$20,
    GMRB_NOREUSE=1,
    GMRB_REUSE=2,
    GMRB_VERIFY=3,
    GMRB_NEXTACTIVE=4,
    GMRB_PREVACTIVE=5,
    GMRF_NOREUSE=2,
    GMRF_REUSE=4,
    GMRF_VERIFY=8,
    GMRF_NEXTACTIVE=16,
    GMRF_PREVACTIVE=$20

OBJECT GPGoInactive
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  Abort:ULONG

OBJECT GPLayout
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  Initial:ULONG

OBJECT GPDomain
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  RPort:PTR TO RastPort,
  Which:LONG,
  Domain:IBox,
  Attrs:PTR TO TagItem

CONST GDOMAIN_MINIMUM=0,
    GDOMAIN_NOMINAL=1,
    GDOMAIN_MAXIMUM=2

OBJECT GPKeyTest
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  IMsg:PTR TO IntuiMessage,
  VanillaKey:ULONG

OBJECT GPKeyInput
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  IEvent:PTR TO InputEvent,
  Termination:PTR TO LONG

#define GMR_KEYACTIVE	(1 << 4)
#define GMR_KEYVERIFY	(1 << 5)

OBJECT GPKeyGoInactive
  MethodID:ULONG,
  GInfo:PTR TO GadgetInfo,
  Abort:ULONG
