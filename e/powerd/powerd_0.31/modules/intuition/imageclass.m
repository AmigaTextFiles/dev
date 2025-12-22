MODULE 'graphics/rastport','intuition/intuition'

#define GADGET_BOX(g) ((g)+GD_LEFTEDGE)
#define IM_BOX(im)    ((im)+IG_LEFTEDGE)
#define IM_FGPEN(im)  (im::Image.PlanePick)
#define IM_BGPEN(im)  (im::Image.PlaneOnOff)

CONST CUSTOMIMAGEDEPTH=-1,
    IMAGE_Attributes=$80020000,
    IA_Dummy=$80020000,
    IA_Left=$80020001,
    IA_Top=$80020002,
    IA_Width=$80020003,
    IA_Height=$80020004,
    IA_FgPen=$80020005,
    IA_BgPen=$80020006,
    IA_Data=$80020007,
    IA_LineWidth=$80020008,
    IA_Pens=$8002000E,
    IA_Resolution=$8002000F,
    IA_APattern=$80020010,
    IA_APatSize=$80020011,
    IA_Mode=$80020012,
    IA_Font=$80020013,
    IA_Outline=$80020014,
    IA_Recessed=$80020015,
    IA_DoubleEmboss=$80020016,
    IA_EdgesOnly=$80020017,
    SYSIA_Size=$8002000B,
    SYSIA_Depth=$8002000C,
    SYSIA_Which=$8002000D,
    SYSIA_DrawInfo=$80020018,
    SYSIA_Pens=$8002000E,
    IA_ShadowPen=$80020009,
    IA_HighlightPen=$8002000A,
    SYSIA_ReferenceFont=$80020019,
    IA_SupportsDisable=$8002001A,
    IA_FrameType=$8002001B,
    IA_Underscore=$8002001C,
    IA_Scalable=$8002001D,
    IA_ActivateKey=$8002001E,
    IA_Screen=$8002001F,
    IA_Precision=$80020020,
    SYSISIZE_MedRes=0,
    SYSISIZE_LowRes=1,
    SYSISIZE_HiRes=2,
    DEPTHIMAGE=0,
    ZOOMIMAGE=1,
    SIZEIMAGE=2,
    CLOSEIMAGE=3,
    SDEPTHIMAGE=5,
    LEFTIMAGE=10,
    UPIMAGE=11,
    RIGHTIMAGE=12,
    DOWNIMAGE=13,
    CHECKIMAGE=14,
    MXIMAGE=15,
    MENUCHECK=16,
    AMIGAKEY=17,
    FRAME_DEFAULT=0,
    FRAME_BUTTON=1,
    FRAME_RIDGE=2,
    FRAME_ICONDROPBOX=3,
    IM_DRAW=$202,
    IM_HITTEST=$203,
    IM_ERASE=$204,
    IM_MOVE=$205,
    IM_DRAWFRAME=$206,
    IM_FRAMEBOX=$207,
    IM_HITFRAME=$208,
    IM_ERASEFRAME=$209,
    IM_DOMAINFRAME=$20A,
    IDS_NORMAL=0,
    IDS_SELECTED=1,
    IDS_DISABLED=2,
    IDS_BUSY=3,
    IDS_INDETERMINATE=4,
    IDS_INACTIVENORMAL=5,
    IDS_INACTIVESELECTED=6,
    IDS_INACTIVEDISABLED=7,
    IDS_SELECTEDDISABLED=8,
    IDS_INDETERMINANT=4

OBJECT impFrameBox
  MethodID:ULONG,
  ContentsBox:PTR TO IBox,
  FrameBox:PTR TO IBox,
  DrInfo:PTR TO DrawInfo,
  FrameFlags:ULONG

CONST FRAMEB_SPECIFY=0,
    FRAMEF_SPECIFY=1

OBJECT impDraw
  MethodID:ULONG,
  RPort:PTR TO RastPort,
  OffsetX:WORD,
  OffsetY:WORD,
  State:ULONG,
  DrInfo:PTR TO DrawInfo,
  DimensionsWidth:WORD,
  DimensionsHeight:WORD

OBJECT impDrawFrame
  MethodID:ULONG,
  RPort:PTR TO RastPort,
  OffsetX:WORD,
  OffsetY:WORD,
  State:ULONG,
  DrInfo:PTR TO DrawInfo,
  DimensionsWidth:WORD,
  DimensionsHeight:WORD

OBJECT impErase
  MethodID:ULONG,
  RPort:PTR TO RastPort,
  OffsetX:WORD,
  OffsetY:WORD,
  DimensionsWidth:WORD,
  DimensionsHeight:WORD

OBJECT impEraseFrame
  MethodID:ULONG,
  RPort:PTR TO RastPort,
  Offsetx:WORD,
  Offsety:WORD,
  Dimensionswidth:WORD,
  Dimensionsheight:WORD

OBJECT impHitTest
  MethodID:ULONG,
  PointX:WORD,
  PointY:WORD,
  DimensionsWidth:WORD,
  DimensionsHeight:WORD

OBJECT impHitFrame
  MethodID:ULONG,
  PointX:WORD,
  PointY:WORD,
  DimensionsWidth:WORD,
  DimensionsHeight:WORD

OBJECT impDomainFrame
  MethodID:ULONG,
  DrInfo:PTR TO DrawInfo,
  RPort:PTR TO RastPort,
  Which:LONG,
  Domain:IBox,
  Attrs:PTR TO TagItem

CONST IDOMAIN_MINIMUM=0,
 IDOMAIN_NOMINAL=1,
 IDOMAIN_MAXIMUM=2
