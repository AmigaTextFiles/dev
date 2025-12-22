#ifndef MULTIDESKTOP_MULTIWINDOWS_H
#define MULTIDESKTOP_MULTIWINDOWS_H
#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef MULTIDESKTOP_MULTIDESKTOP_H
#include "desk/multidesktop.h"
#endif

/* Std-Pointer und Wallpaper laden */
#define LOAD_ALL

#define MAXSCREENS 25
#define MAXWINDOWS 50

#define WindowID_InformationBox 49

/* === AppInfo()-Tags ================================================== */
#define AI_Tags          TAG_USER+0x75400
#define AI_MinStack      AI_Tags+1
#define AI_MinOSVersion  AI_Tags+2
#define AI_MinMemory     AI_Tags+3
#define AI_MinChipMem    AI_Tags+4
#define AI_Req020        AI_Tags+5
#define AI_Req030        AI_Tags+6
#define AI_ReqFPU        AI_Tags+7
#define AI_ReqLocale     AI_Tags+8
#define AI_NoMenuHelp    AI_Tags+9
#define AI_NoGadgetHelp  AI_Tags+10

/* === CreateScreen-Flags ============================================== */
#define CS_TEXTOVERSCAN  (1L<<0)
#define CS_STDOVERSCAN   (1L<<1)
#define CS_MAXOVERSCAN   (1L<<2)
#define CS_VIDEOOVERSCAN (1L<<3)
#define CS_NOAUTOSCROLL  (1L<<4)
#define CS_NOSTDCOLORS   (1L<<5)
#define CS_NOBACKDROP    (1L<<6)
/* ---- INTERN --------------- */
#define CS_SYSSCREEN     (1L<<15)

#define SCREENID_WORKBENCH 255

/* === CreateWindow-Flags ============================================== */
#define CW_DRAG         (1L<<0)
#define CW_DEPTH        (1L<<1)
#define CW_CLOSE        (1L<<2)
#define CW_SIZE         (1L<<3)
#define CW_SCROLLV      (1L<<4)
#define CW_SCROLLH      (1L<<5)
#define CW_BORDERLESS   (1L<<6)
#define CW_INACTIVATE   (1L<<7)
#define CW_INITGFX      (1L<<8)
/* ---- INTERN -------------- */
#define CW_SYSWINDOW    (1L<<15)

struct CWSpecial
{
 BOOL  SpecialZoom;
 UWORD ZoomMinW,ZoomMaxW,ZoomMinH,ZoomMaxH;

 BOOL  SpecialBitMap;
 UWORD SuperWidth,SuperHeight;
};

/* === AppObjects ====================================================== */
#define IF_NONE       0
#define IF_APPICON (1L<<1)
#define IF_APPMENU (1L<<2)

/* === MultiMessage-System ============================================= */
/* --- Window-Messages -------- */
#define MULTI_GADGETUP          1
#define MULTI_GADGETMOUSE       2
#define MULTI_GADGETDOWN        3
#define MULTI_CLOSEWINDOW       4
#define MULTI_NEWSIZE           5
#define MULTI_MENUPICK          6
#define MULTI_RAWKEY            7
#define MULTI_VANILLAKEY        8
#define MULTI_MOUSEBUTTONS      9
#define MULTI_MOUSEMOVE        10
#define MULTI_REFRESHWINDOW    11
#define MULTI_INTUITICKS       12
#define MULTI_ACTIVEWINDOW     13
#define MULTI_INACTIVEWINDOW   14
#define MULTI_NEWPREFS         15

/* --- App-Messages ----------- */
#define MULTI_APPICON         100
#define MULTI_APPMENUITEM     101
#define MULTI_APPWINDOW       102

/* --- Timer-Messages --------- */
#define MULTI_TIMERALARM      200

/* --- Error-Messages --------- */
#define MULTI_ERROR           300
#define MULTI_GURU            301
 /* ObjectID = Fehlercode */

/* --- Error-Messages --------- */
#define MULTI_SYSTEM          400

#define MSYS_BREAK_CTRL_C     (1<<0)
#define MSYS_BREAK_CTRL_D     (1<<1)
#define MSYS_BREAK_CTRL_E     (1<<2)
#define MSYS_BREAK_CTRL_F     (1<<3)

/* --- Systeminterne Messages - */
#define MULTI_RAWINTUIMESSAGE 500
#define MULTI_RAWAPPMESSAGE   501

struct MultiMessage
{
 UWORD                Class;           /* Message-Klasse               */
 ULONG                WindowID;        /* ID des Fensters, falls vorh. */
 ULONG                ObjectID;        /* ID des Objektes              */
 ULONG                ObjectCode;      /* Code, z. B. Listview-Auswahl */
 LONG                 ObjectData[4];   /* Andere Daten, z.B. Mauspos.  */
 APTR                 ObjectAddress;   /* Adresse des Objektes         */

 struct IntuiMessage *IntuiMessage;
 struct AppMessage   *AppMessage;
};

/* === Gadget-Actions ================================================== */
#define AGC_CYCLE                1
#define AGC_MX                   2
#define AGC_SLIDER               3
#define AGC_SCROLLER             4
#define AGC_PALETTE              5
#define AGC_STATUS               6
#define AGC_TX                   7
#define AGC_TEXT                 8
#define AGC_STRING               90
#define AGC_HEX                  91
#define AGC_FLOAT                92
#define AGC_NM                   10
#define AGC_NUMBER               11
#define AGC_INTEGER              12
#define AGC_LISTVIEW_SELECTION           130
#define AGC_LISTVIEW_LABEL               131
#define AGC_LISTVIEW_REMTEXT             132
#define AGC_LISTVIEW_CHANGESELECTEDLABEL 133
#define AGC_LISTVIEW_ADDHEAD             135
#define AGC_LISTVIEW_ADDTAIL             136
#define AGC_LISTVIEW_ADDSORTA            137
#define AGC_LISTVIEW_ADDSORTD            138
#define AGC_WHEEL                14
#define AGC_SELECTBOX            15

struct Action
{
 struct Action *NextAction;
 ULONG          TargetID;
 UBYTE          SourceCode;
 UBYTE          TargetCode;

 UWORD          Filter;
};

/* === Gadget-Flags ==================================================== */
/* Allgemeine Gadget-Flags: Textplatzierung, Disable */

#define CGA_DEFAULT      0
#define CGA_LEFT      (1L<<0)
#define CGA_RIGHT     (1L<<1)
#define CGA_ABOVE     (1L<<2)
#define CGA_BELOW     (1L<<3)
#define CGA_IN        (1L<<4)
#define CGA_HIGHLABEL (1L<<5)
#define CGA_RECESSED  (1L<<6)
#define CGA_DISABLE   (1L<<7)

/* Flags für Gadgets bestimmte Gadgets */

/* Listview */
#define CLV_SHOWSELECTED (1L<<14)
#define CLV_READONLY     (1L<<13)
#define CLV_NONPROPFONT  (1L<<12)

#define SLE_ASCENDING  SORT_ASCENDING
#define SLE_DESCENDING SORT_DESCENDING

#define ULP_HEAD  0
#define ULP_TAIL  1
#define ULP_SORTA 2
#define ULP_SORTD 3

/* String */
#define CST_LEFT    (1L<<15)
#define CST_RIGHT   (1L<<14)
#define CST_CENTER  (1L<<13)
#define CST_PASSWORD (1L<<12)

struct StringHook
{
 UWORD    Flags;
 ULONG  (*UserRoutine)();
 APTR     UserData;
 UBYTE   *CharTable;
};

#define SHF_USERROUTINE (1L<<0)
#define SHF_CHARTABLE   (1L<<1)
#define SHF_TOUPPER     (1L<<2)
#define SHF_TOLOWER     (1L<<3)

#define URR_RETURN   0 /* Zurück zu Intuition, Kommando nicht unterstützt */
#define URR_OKAY     1 /* Zurück zu Intuition, Kommando erfolgreich       */
#define URR_CONTINUE 2 /* CharTable, ToUpper/ToLower auch abarbeiten      */

/* Integer */
#define CIN_LEFT     CST_LEFT
#define CIN_RIGHT    CST_RIGHT
#define CIN_CENTER   CST_CENTER
#define CIN_PASSWORD CST_PASSWORD

/* Scroller */
#define CSC_ARROWS (1L<<15)

/* Palette */
#define CPL_IBOX  (1L<<15)

/* Text und TX */
#define CTX_NOBORDER (1L<<15)

/* Number und NM */
#define CNM_NOBORDER (1L<<15)
#define CNM_NOLOCALE (1L<<13)

/* Text und Number */
#define JSF_LEFT   0
#define JSF_RIGHT  1
#define JSF_CENTER 2

/* Status */
#define CSG_ANIMPOINTER (1L<<15)

/* Hex */
#define CHX_TOUPPER  (1L<<15)
#define CHX_TOLOWER  (1L<<14)

/* ClickBox */
#define CCB_NOBORDER (1L<<15)
#define CCB_CIRCLE   (1L<<14)
#define CCB_STAR     (1L<<13)

/* Wheel */
#define CWH_NOBORDER (1L<<15)

/* SelectBox */
#define CSB_NOBORDER (1L<<15)

/* Image */
#define CIM_NOBORDER (1L<<15)

/* Icon */
#define CIC_NOBORDER (1L<<15)

/* === StdPointer-Flags ================================================ */
#define STDP_DEFAULT 0
#define STDP_SLEEP   1
#define STDP_WORK    2
#define STDP_HELP    3

/* ===== Interne Verwaltungsstrukturen ================================= */

struct CommandTable
{
 UBYTE *CommandString;
 UBYTE  CommandKey;
 UBYTE  pad;
};

struct MWMenu
{
 /* --- Menu-Struktur ------------ */
 struct Menu    Menu;

 /* --- Verwaltung --------------- */
 ULONG          MenuID;
 ULONG          HelpID;
 UBYTE         *TextID;
 UWORD          Flags;

 /* --- Interne Zwischenspeicher - */
 struct MWMenu *FindPrevMenu;
 WORD           NextLeftEdge;
 WORD           BoxWidth;
 WORD           KeyLeft;
};

#define CME_DEFAULT    0
#define CME_DISABLE (1L<<0)
/* --- INTERN ----------- */
#define CME_SYSMENU (1L<<15)  /* nur für internen Gebrauch!!! */

/* InsertMenu() */
#define INSERTID_HEAD 0
#define INSERTID_TAIL 0xffffffff

/* FindMenuOrItem() */
#define FINDTYPE_ITEM  1
#define FINDTYPE_MENU  2

struct MWMenuItem
{
 /* --- Item-Struktur ------------- */
 struct MenuItem     MenuItem;
 struct IntuiText    ItemText[3];
 struct TextAttr     TextAttr[2];
 UBYTE              *String[2];

 /* --- Verwaltung ---------------- */
 ULONG               ItemID;
 ULONG               HelpID;
 UWORD               Flags;
 UBYTE               CommandKey;
 UBYTE               CommandFlags;
 struct ItemAction  *ItemAction;

 /* --- Interne Zwischenspeicher -- */
 struct MWMenu      *FindMenu;
 struct MWMenuItem  *FindPrevItem;
 struct MWMenuItem  *FindMasterItem;
 struct MultiRemember Remember;
 WORD                 SubBoxWidth;
 WORD                 SubKeyLeft;
 WORD                 NextTopEdge;
};

#define CMI_DEFAULT         0
#define CMI_DISABLE   (1L<<0)
#define CMI_T1BOLD    (1L<<1)
#define CMI_T1ITALIC  (1L<<2)
#define CMI_T2BOLD    (1L<<3)
#define CMI_T2ITALIC  (1L<<4)
#define CMI_CHECKIT   (1L<<5)
/* --- INTERN ------------- */
#define CMI_TOGGLE     (1L<<10)  /* werden bei AddToggleItem() und     */
#define CMI_CHECKED    (1L<<11)  /* AddSubToggleItem() intern benötigt */

#define CMI_MASTERITEM (1L<<12)  /* nur für internen Gebrauch!!!       */
#define CMI_BARITEM    (1L<<13)  /* nur für internen Gebrauch!!!       */
#define CMI_SUBITEM    (1L<<14)  /* nur für internen Gebrauch!!!       */
#define CMI_SYSITEM    (1L<<15)  /* nur für internen Gebrauch!!!       */

#define MICF_NONE         0
#define MICF_INTUITION (1L<<0)
#define MICF_ALT       (1L<<1)
#define MICF_CTRL      (1L<<2)
#define MICF_SHIFT     (1L<<3)
#define MICF_AMIGAL    (1L<<4)
#define MICF_AMIGAR    (1L<<5)
#define MICF_FKEY      (1L<<6)
#define MICF_HELP      (1L<<7)

/* ModifyItem()-ModifyFlags */
#define MIF_SUBITEM (1L<<0)
#define MIF_CHECKIT (1L<<1)
#define MIF_SET     (1L<<2)
#define MIF_UNSET   (1L<<3)
#define MIF_ASK     (1L<<4)

/* Reservierte Item-IDs */
#define STDITEM_ONLINEHELP 0xffff0001
#define STDITEM_LOADGUIDE  0xffff0002
#define STDITEM_ABOUTHELP  0xffff0003
#define STDITEM_DEVELOPER  0xffff0004

struct ItemAction
{
 struct ItemAction *NextItemAction;
 ULONG              TargetID;
 UWORD              Flags;
};

#define IAF_UNCHECK       0
#define IAF_CHECK         1
#define IAF_DISABLE       2
#define IAF_ENABLE        3

struct AppObject
{
 struct MinNode Node;
 ULONG          AppID;

 /* ---- Objektdaten ----- */
 APTR           AppObject;
 APTR           AppObjectData;
 UBYTE          AppObjectType;

 /* ---- Besitzerdaten --- */
 UBYTE          OwnerType;
 APTR           Owner;
};

#define AOT_ICON       1
#define AOT_MENUITEM   2
#define AOT_WINDOW     3

#define OT_USER        0
#define OT_WINDOWENTRY 1
#define OT_SCREENENTRY 2

/* --- MultiMessage->Code bei App-Messages */
#define APPCODE_USER   0
#define APPCODE_WINDOW 1
#define APPCODE_SCREEN 2

#define MWGAD_GADTOOLS  0
#define MWGAD_INTUITION 1
#define MWGAD_SPECIAL   2

#define MWGADGET_TAGS 10

#define TX_LEFT   0
#define TX_TOP    1
#define TX_WIDTH  2
#define TX_HEIGHT 3

struct MWGadget
{
 struct MinNode      MWGadgetNode;

 /* ---- Gadgetdaten ---------------------- */
 UBYTE               Type;
 UBYTE               CommandKey;
 UWORD               Kind;
 ULONG               GadgetID;
 ULONG               HelpID;
 UWORD               LeftEdge,
                     TopEdge,
                     Width,
                     Height;
 struct Action      *Action;
 APTR                ExtData;

 /* ---- Verwaltung ----------------------- */
 struct WindowEntry *WindowEntry;
 struct TagItem      TagList[MWGADGET_TAGS];

 /* ---- INTERN ------------------------------------------------- */
 UWORD               TextPos[4];   /* Textverwaltung              */
 UWORD               GadgetCount;  /* Anzahl der Gadgets          */
 struct NewGadget    NewGadget;    /* aktuelle Größe etc.         */
 struct Gadget      *Gadget;       /* Zeiger auf erstes Gadget    */
 struct Gadget      *Update;       /* GadTools-Verwaltung         */
 struct MultiRemember Remember;    /* für MakeAction/UnMakeAction */
};

struct ActionMessage
{
 struct ActionMessage *NextMessage;
 ULONG                 Class;
 ULONG                 ObjectID;
 ULONG                 ObjectCode;
 APTR                  ObjectAddress;
};

#define GADGET_UNDERSCORE 0
#define GADGET_DISABLE    1

#define TOGGLE_MAGIC  0x7466
#define TOGGLE_STATUS 4

#define CYCLE_LABELS   2
#define CYCLE_ACTIVE   3

struct CycleData
{
 UWORD  LabelCount;
 UBYTE *Labels[12];
 ULONG  Zero;
};

#define MX_LABELS  2
#define MX_ACTIVE  3

struct MXData
{
 UWORD  LabelCount;
 UBYTE *Labels[12];
 ULONG  Zero;

 /* --- INTERN --------------- */
 UBYTE  CommandKey[12];
 UWORD  X1,Y1,X2,Y2;
};

#define LISTVIEW_LABELS       2
#define LISTVIEW_TOP          3
#define LISTVIEW_READONLY     4
#define LISTVIEW_SELECTED     5
#define LISTVIEW_RECESSED     6
#define LISTVIEW_SHOWSELECTED 7

struct ListviewData
{
 struct List          List;

 /* --- INTERN --------------- */
 struct MultiRemember Remember;
 UWORD                X1,Y1,X2,Y2;
};

struct ListviewNode
{
 struct Node  Node;

 /* --- INTERN --------------- */
 UBYTE        Label[];
};

#define STRING_MAXCHARS      2
#define STRING_STRING        3
#define STRING_JUSTIFICATION 4

struct StringData
{
 /* --- String-Hook ------- */
 struct Hook *Hook;
 UBYTE       *WorkBuffer;
 UWORD        Flags;

 /* --- INTERN ------------ */
 UBYTE       *Buffer;
 UWORD        SpecialType;
 APTR         Special;
};

#define SST_STRING 0
#define SST_HEX    1
#define SST_FLOAT  2
#define SST_USER   3

struct HexData
{
 ULONG Min;
 ULONG Max;
};

struct FloatData
{
 FLOAT Min;
 FLOAT Max;
};

#define INTEGER_MAXCHARS      2
#define INTEGER_INTEGER       3
#define INTEGER_JUSTIFICATION 4

struct IntegerData
{
 LONG  Min;
 LONG  Max;
};

#define SLIDER_MIN         2
#define SLIDER_MAX         3
#define SLIDER_LEVEL       4
#define SLIDER_RELVERIFY   5
#define SLIDER_IMMEDIATE   6
#define SLIDER_FREEDOM     7
#define SLIDER_FOLLOWMOUSE 8

#define SCROLLER_TOP       2
#define SCROLLER_TOTAL     3
#define SCROLLER_VISIBLE   4
#define SCROLLER_ARROWS    5
#define SCROLLER_RELVERIFY 6
#define SCROLLER_IMMEDIATE 7
#define SCROLLER_FREEDOM   8

#define PALETTE_COLOR    2
#define PALETTE_OFFSET   3
#define PALETTE_DEPTH    4
#define PALETTE_IWIDTH   5

#define CHECKBOX_CHECKED 2

#define TEXT_TEXT     2
#define TEXT_BORDER   3
#define TEXT_RECESSED 4

#define NUMBER_NUMBER   2
#define NUMBER_BORDER   3
#define NUMBER_RECESSED 4

#define TOGGLE_KIND    0
#define STEXT_KIND     1
#define SNUMBER_KIND   2
#define CLICKBOX_KIND  3
#define STATUS_KIND    4
#define WHEEL_KIND     5
#define SELECTBOX_KIND 6
#define ICON_KIND      7
#define IMAGE_KIND     8

struct TextData
{
 UWORD Flags;
 UWORD Justification;
};

#define STEXT_TEXT 0

struct NumberData
{
 UWORD  Flags;
 UWORD  Justification;
 UBYTE *FormatString;
};

#define SNUMBER_NUMBER 0

struct StatusData
{
 UWORD  Flags;
 UBYTE *FormatString;
 ULONG  Min;
 ULONG  Max;
};

#define STATUS_LEVEL    0

struct ClickBoxData
{
 UWORD         Flags;

 /* --- INTERN ---------- */
 struct Gadget  Gadget;
};

#define CLICKBOX_STATUS 0

struct SelectBoxData
{
 UWORD            Flags;
 UBYTE            TitleCount;
 UBYTE            Selected;
 ULONG           *TitleArray;

 /* --- INTERN ---------- */
 struct Gadget       Gadget;
 struct ExtNewWindow NewWindow;
 struct TagItem      TagList[4];
};

struct WheelData
{
 UWORD          Flags;
 ULONG          Min;
 ULONG          Max;
 ULONG          Current;

 /* --- INTERN ---------- */
 struct Gadget  Gadget;
 UWORD          OldX,
                OldY;
};

struct IconData
{
 UWORD              Flags;
 struct DiskObject *Icon;

 /* --- INTERN ---------- */
 struct Gadget      Gadget;
};

struct ImageData
{
 UWORD              Flags;
 struct Image      *Image;

 /* --- INTERN ---------- */
 struct Gadget     *Gadget;
};

struct Frame
{
 struct MinNode Node;

 ULONG          ID;
 UWORD          Type;
 UWORD          LeftEdge,
                TopEdge,
                Width,
                Height;

 /* --- INTERN ---------- */
 UWORD          x,y,w,h;
};

#define FT_STANDARD 0
#define FT_RECESSED 1
#define FT_DOUBLE   2

struct WindowEntry
{
 struct Node           WindowNode;
 UWORD                 WindowID;
 UWORD                 WindowFlags;

 /* --- Strukturen ------------------- */
 struct Window        *Window;
 struct MsgPort       *UserPort;
 struct Screen        *Screen;
 struct ScreenEntry   *ScreenEntry;
 struct RastPort      *RastPort;
 struct ViewPort      *ViewPort;
 struct BitMap        *BitMap;
 struct TextFont      *TextFont;
 struct Layer         *Layer;
 struct Layer_Info    *LayerInfo;
 struct ColorMap      *ColorMap;
 struct DrawInfo      *DrawInfo;
 struct Wallpaper     *Wallpaper;
 struct Pointer       *Pointer;
 APTR                  VisualInfo;

 /* --- Größe ------------------------ */
 UWORD                 InnerLeftEdge,
                       InnerTopEdge,
                       InnerWidth,
                       InnerHeight;
 UWORD                 OWidth,OHeight,
                       Width,Height;
 FLOAT                 FactorX,FactorY;
 FLOAT                 AspectX,AspectY;

 /* --- Zeichenfunktionen ------------ */
 struct AreaInfo      *AreaInfo;
 struct TmpRas        *TmpRas;

 /* --- Workbench App-Strukturen ----- */
 BOOL                  Iconify;
 struct AppObject     *AppIcon;
 struct AppObject     *AppMenuItem;
 struct AppObject     *AppWindow;

 /* --- Schalter, Menüs, Frames ------ */
 struct List           GadgetList;
 struct List           FrameList;
 struct MWMenu        *FirstMenu;

 /* --- Erweiterungen ---------------- */
 ULONG                 WEUserData[4];   /* zur freien Verfügung     */
 ULONG                 WEExtData[4];    /* für MultiDesktop, INTERN */

 /* --- INTERN ---------------------------------------------------- */
 /* die folgenden Einträge dienen zur internen Verwaltung und       */
 /* sollten nach Möglichkeit nicht verwendet werden, auf keinen     */
 /* Fall jedoch Manipuliert werden!!                                */

 /* --- Gadgets, ActionLists, Gadget-Hilfe ------------------------ */
 struct MWGadget      *FMGadget;        /* für FollowMouse-Events   */
 struct MWGadget      *LastGadget;      /* für MakeAction()         */
 struct ActionMessage *ActionMessage;   /* für CallAction()         */
 struct Window        *GHWindow;        /* zur Verwaltung der       */
 UWORD                 GHMouseX,        /*  Gadget-Hilfe            */
                       GHMouseY;
 UWORD                 GHTime;
 struct MWGadget      *GHGadget;
 struct Screen        *MHScreen;        /* zur Verwaltung der       */
 struct MWMenu        *MHMenu;          /*  Menü-Hilfe              */
 struct MWMenuItem    *MHMenuItem;
 struct MWMenuItem    *MHSubItem;

 /* --- Menüs ----------------------------------------------------- */
 struct MWMenu        *LastMenu;        /* letztes Menü             */
 struct MWMenuItem    *LastMenuItem;    /* letztes Menü-Item        */
 struct MWMenuItem    *LastSubItem;     /* letztes Sub-Item         */
 struct MWMenuItem    *HelpOnItem,      /* Zeiger auf Items für     */
                      *DeveloperOnItem; /*  Globale Online-Hilfe    */
 UBYTE                 MenuOn;          /* Menü eingeschaltet?      */
 UBYTE                 MenuInUse;       /* Menü wird gerade gewählt */

 /* --- Wallpapers, Pointers, Verwaltung -------------------------- */
 struct RPBackup      *RPBackup;        /* BackupRP()/RestoreRP()   */
 struct Wallpaper     *SysWPAddress;    /* für Wallpaper()          */
 struct Pointer       *SysPOAddress;    /* für Pointer()            */
 struct Pointer       *ActivePointer;   /* aktueller Pointer        */
 UWORD                 ActivePointerImage;  /* Pointer-Bildnummer   */
 BOOL                  PubScreenLock;   /* zur PubScreen-Verwaltung */

 /* --- Zeichenfunktionen ----------------------------------------- */
 UWORD                 TmpRasCount;     /* für Create/DeleteTmpRas  */
 UBYTE                *AreaInfoTable;   /* Koordinatentabelle       */
 UBYTE                 GfxFlags;        /* Korrekturflag            */
 UBYTE                 GfxStyle;        /* Textstil                 */
 UWORD                 TextSpacing;     /* Zeichenabstand           */
 struct TextFont      *WindowFont;      /* Font-Cache-Verwaltung    */

 /* --- Öffnen und Ikonifizieren, Speicherverwaltung -------------- */
 struct MultiRemember  Remember;        /* Speicherliste            */
 struct ExtNewWindow   NewWindow;       /* Strukturen zur           */
 struct TagItem        TagList[5];      /*  Ikonifizierung und      */
 struct RastPort       IRastPort;       /*  Wiederherstellung       */

 /* --- INTERN ---------------------------------------------------- */
 struct AreaInfo       AreaInfoBuffer;  /* Speicher für Grafik-     */
 struct TmpRas         TmpRasBuffer;    /*  strukturen              */
 struct BitMap         BitmapBuffer;
 ULONG                 WESpecialData[2];  /* Interne Verwaltung     */
};

struct RPBackup
{
 struct RPBackup *NextBackup;

 UBYTE            Pens[3];
 UBYTE            DrawMode;
 UWORD            X,Y;
 struct TextFont *Font;
};

struct HelpLine
{
 UBYTE  Flags;
 UBYTE  Pen;
 UWORD  Width;
 UBYTE *String;
};

struct HelpText
{
 UWORD           Lines;
 UWORD           Height;
 UWORD           Width;
 struct HelpLine HelpLine[12];

 /* --- INTERN --------------- */
 UBYTE           HelpString[];
};

#define HLF_CENTER    (1L<<0)
#define HLF_RIGHT     (1L<<1)
#define HLF_BOLD      (1L<<2)
#define HLF_UNDERLINE (1L<<3)
#define HLF_ITALIC    (1L<<4)

#define ST_NORMAL        0
#define ST_BOLD       (1L<<0)
#define ST_ITALIC     (1L<<1)
#define ST_UNDERLINED (1L<<2)
#define ST_OUTLINE    (1L<<3)
#define ST_SHADOW     (1L<<4)
#define ST_WIDE       (1L<<5)

#define GFXF_OLDXY       0
#define GFXF_NEWXY       1

struct ScreenEntry
{
 UWORD                 ScreenID;
 UWORD                 ScreenFlags;

 /* --- Strukturen ------------- */
 ULONG                 ModeID;
 struct Screen        *Screen;
 struct RastPort      *RastPort;
 struct ViewPort      *ViewPort;
 struct BitMap        *BitMap;
 struct Layer_Info    *LayerInfo;
 struct ColorMap      *ColorMap;
 struct DisplayInfo   *DisplayInfo;

 /* --- Verwaltung ------------- */
 struct List           WindowList;
 struct Window        *BgWindow;
 struct Wallpaper     *BgWallpaper;

 /* --- Ikonifizierung --------- */
 BOOL                  Iconify;
 struct AppObject     *AppIcon;
 struct AppObject     *AppMenuItem;

 /* --- Erweiterungen ---------- */
 ULONG                 SEUserData[4];   /* zur freien Verfügung     */
 ULONG                 SEExtData[4];    /* für MultiDesktop, INTERN */

 /* --- INTERN ----------------- */
 UWORD                *CTabBackup;        /* Iconify/Uniconify        */
 struct DisplayInfo    DisplayInfoBuffer; /* Buffer für Strukturen    */
 struct TagItem        TagList[15];
};

struct VideoInfo
{
 struct Node           Node;

 /* --- Strukturen ------------- */
 ULONG                 ModeID;
 struct NameInfo      *NameInfo;
 struct DisplayInfo   *DisplayInfo;
 struct DimensionInfo *DimensionInfo;
 struct MonitorInfo   *MonitorInfo;

 /* --- INTERN ----------------- */
 struct NameInfo       NameInfoBuffer;
 struct DisplayInfo    DisplayInfoBuffer;
 struct DimensionInfo  DimensionInfoBuffer;
 struct MonitorInfo    MonitorInfoBuffer;
};

struct SignalList
{
 UWORD Count;
 ULONG WaitMask;
 BOOL  MenuInUse;

 UBYTE WindowID[MAXWINDOWS];
 ULONG SignalMask[MAXWINDOWS];

 ULONG TimerSignalMask;
 ULONG AppSignalMask;
 ULONG GuideSignalMask;
 ULONG BreakSignalMask;
};

struct UserNode
{
 struct Node              Node;
 ULONG                    Version;
 struct MultiWindowsUser *Address;
};

struct MultiWindowsUser
{
 /* --- Interne User-Verwaltung ------------ */
 UWORD                    UserCount;
 struct MultiRemember     Remember;
 struct UserNode          UserNode;
 struct MultiDesktopBase *MultiDesktopBase;

 /* --- Globale Applikationsdaten ---------- */
 UBYTE                   *GuideName;
 struct Catalog          *Catalog;
 struct Locale           *Locale;
 struct DiskObject       *Icon;

 struct TextAttr         *TextAttr;
 struct TextAttr         *NonPropTextAttr;
 struct TextAttr         *BoldTextAttr;

 struct TextFont         *TextFont;
 struct TextFont         *NonPropTextFont;

 /* --- FontSensitive-System --------------- */
 ULONG                    OldFontH,
                          OldFontV;
 ULONG                    NewFontH,
                          NewFontV;
 FLOAT                    FactorX,
                          FactorY;

 /* --- DOS-Daten -------------------------- */
 UBYTE                   *ProgramName;
 UBYTE                   *ProgramDirName;
 UBYTE                   *Arguments;
 UBYTE                  **ToolTypes;
 BOOL                     WorkbenchStartup;
 BYTE                     TaskPriority;
 BYTE                     OldTaskPriority;
 struct MsgPort          *AppPort;

 /* --- Variablen zur Verwaltung ----------- */
 UBYTE                    HelpOn;
 UBYTE                    DeveloperOn;
 UBYTE                    HasGadgetHelp;
 UBYTE                    HasMenuHelp;
 UBYTE                    SpaceSize;
 UBYTE                    BarCharSize;
 UWORD                    SubStringSize;

 /* --- Fenster- und Screenverwaltung ------ */
 WORD                     ActiveWindowID;
 struct WindowEntry      *ActiveWindow;
 struct ScreenEntry      *ScreenList[MAXSCREENS+1];
 struct WindowEntry      *WindowList[MAXWINDOWS+1];

 /* --- Caches, AmigaGuide ----------------- */
 struct List              AppObjectList;
 struct List              CachedFontsList;
 struct NewAmigaGuide    *Guide;
 ULONG                    GuideSignalMask;
 UBYTE                    GuideReady;
 UBYTE                    GuideCommand;

 /* --- Erweiterungen ---------------- */
 ULONG                    MWUUserData[4];   /* zur freien Verfügung     */
 ULONG                    MWUExtData[4];    /* für MultiDesktop, INTERN */

 /* --- Interne Speicherbereiche ----------- */
 struct TextAttr          TABuffer[3];
 struct MultiMessage      MultiMessage;
 struct IntuiMessage      IntuiMessage;
 struct AppMessage        AppMessage;
 struct SignalList        SignalList;
 struct NewAmigaGuide     AmigaGuideBuffer;
};

struct CachedFont
{
 struct Node      Node;
 UWORD            Height;
 struct TextFont *TextFont;
};

struct Wallpaper
{
 struct Node   Node;
 UWORD         UserCount;

 UWORD         Width;
 UWORD         Height;
 struct BitMap BitMap;

 /* --- INTERN ------------ */
 UBYTE         Name[];
};

struct Pointer
{
 struct Node   Node;
 UWORD         UserCount;

 UWORD         Width;
 UWORD         Height;
 WORD          HotSpotX,
               HotSpotY;

 UWORD         PointerCount;
 UWORD         PointerSize;
 UBYTE        *PointerImage;

 UBYTE         HasColors;
 UBYTE         Colors[12];

 /* --- INTERN ------------ */
 UBYTE         Name[];
};

struct UserInfo
{
 UBYTE Name[40];
 UBYTE Address[2][24];
 UBYTE Country[24];
 UBYTE PhoneNumber[24];
 UBYTE FaxNumber[24];

 UBYTE BirthDay;
 UBYTE BirthMonth;
 UWORD BirthYear;

 UBYTE UserLevel;
 UBYTE UserType;
};

#define USERLEVEL_EXPERT   0
#define USERLEVEL_ADVANCED 1
#define USERLEVEL_BEGINNER 2

#define USERTYPE_MALE       0          /* Usertyp: männlich */
#define USERTYPE_FEMALE  (1L<<0)       /* weiblich          */

struct MultiWindowsBase
{
 /* --- Exec-Verwaltung -------------- */
 struct Library       Library;
 struct Library      *AslLibrary;
 struct Library      *AmigaGuideLibrary;

 /* --- Listen ----------------------- */
 UWORD                AppCount;
 UWORD                WallpaperCount;
 UWORD                PointerCount;
 UWORD                VideoInfoCount;
 struct List          AppList;
 struct List          WallpaperList;
 struct List          PointerList;
 struct List          VideoInfoList;

 /* --- Standard-Zeichensätze -------- */
 UBYTE               *TestString;
 UWORD                TestStringLength;

 struct TextAttr     *TopazAttr;
 struct TextFont     *TopazFont;
 struct TextAttr     *Password5Attr;
 struct TextFont     *Password5Font;
 struct TextAttr     *Password9Attr;
 struct TextFont     *Password9Font;

 struct TextAttr     *DefaultAttr;
 struct TextAttr     *DefaultNonPropAttr;
 struct TextFont     *DefaultFont;
 struct TextFont     *DefaultNonPropFont;

 /* --- Zeiger auf Strukturen -------- */
 struct UserInfo      *UserInfo;
 struct Preferences   *Preferences;
 struct Pointer       *SleepPointer;
 struct Pointer       *WorkPointer;
 struct Pointer       *HelpPointer;
 struct Wallpaper     *HelpWallpaper;
 struct CommandTable **CommandTable;
 UBYTE                *MenuSubString;

 /* --- Verzeichnis- und Dateinamen -- */
 UBYTE                *WallpaperDir;
 UBYTE                *PointerDir;
 UBYTE                *SleepPointerName;
 UBYTE                *WorkPointerName;
 UBYTE                *HelpPointerName;
 UBYTE                *HelpWallpaperName;

 /* --- String-Gadget-Hooks ---------- */
 struct Hook           FloatHook;
 struct Hook           HexHook;
 struct Hook           UserHook;

 /* --- Menü-Konstanten -------------- */
 UBYTE                 MenuLineSpacing;   /* Abstand zwischen Items          */
 UBYTE                 MenuCommSeqSpacing;/* Abstand Item-Text - Kommando    */
 UBYTE                 MenuItemMove;      /* Item-Verschiebung nach rechts   */
 UBYTE                 MenuBarChar;       /* Baritem-Zeichen                 */

 /* --- Online-Hilfe-Konstanten ------ */
 UBYTE                 HelpTicks;         /* Zeitverzögerung für Gadget- und */
 UBYTE                 HelpAvoidFlicker;  /*  Menü-Hilfe                     */
 UBYTE                 HelpActive;        /* Hilfe aktiv?                    */
 UBYTE                 HelpDeveloper;     /* Developer-Mode aktiv?           */
 WORD                  HelpCorrY;         /* Y-Korrektur für Menü-Hilfe      */

 /* --- INTERN ----------------------- */
 struct Preferences    PreferencesBuffer;
 struct UserInfo       UserInfoBuffer;
};

#define WALLPAPER_DIR "MDD:Wallpapers"
#define POINTER_DIR   "MDD:Pointers"

#define HELP_TICKS          70
#define HELP_AVOIDFLICKER   3
#define HELP_ACTIVE         0
#define HELP_DEVELOPER      0
#define HELP_CORR_Y         0

#define MENU_LINESPACING    1
#define MENU_ITEMMOVE       5
#define MENU_COMMSEQSPACING 35
#define MENU_BARCHAR        183
#define MENU_SUBSTRING      "\xbb"

#define TOPAZ8_FONTH        792
#define TOPAZ8_FONTV        8

#ifdef LOAD_ALL
#define HELP_WALLPAPERNAME "Sand1.wallpaper"
#define HELP_POINTERNAME   "Help1.pointer"
#define SLEEP_POINTERNAME  "Sleep1.pointer"
#define WORK_POINTERNAME   "Work1.pointer"
#else
#define HELP_WALLPAPERNAME NULL
#define HELP_POINTERNAME   NULL
#define SLEEP_POINTERNAME  NULL
#define WORK_POINTERNAME   NULL
#endif

#define USER mw=(struct MultiDesktopUser *)(SysBase->ThisTask->tc_UserData)->MultiWindows
#define WE we=(struct MultiWindowsUser *)((struct MultiDesktopUser *)(SysBase->ThisTask->tc_UserData)->MultiWindows)->ActiveWindow
#define ALLOC1(size) AllocMemory(&mw->Remember,size,MEMF_CLEAR|MEMF_PUBLIC)
#define ALLOC2(size) AllocMemory(&we->Remember,size,MEMF_CLEAR|MEMF_PUBLIC)
#define FREE1(block) FreeMemoryBlock(&mw->Remember,block)
#define FREE2(block) FreeMemoryBlock(&we->Remember,block)
#endif

