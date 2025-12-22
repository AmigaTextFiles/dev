
CONST MUIV_List_Jump_Active          = -1
CONST MUIV_List_Jump_Bottom          = -2
CONST MUIV_List_Jump_Up              = -4
CONST MUIV_List_Jump_Down            = -3

CONST MUIV_List_NextSelected_Start   = -1
CONST MUIV_List_NextSelected_End     = -1

CONST MUIV_DragQuery_Refuse = 0
CONST MUIV_DragQuery_Accept = 1

CONST MUIV_DragReport_Abort    = 0
CONST MUIV_DragReport_Continue = 1
CONST MUIV_DragReport_Lock     = 2
CONST MUIV_DragReport_Refresh  = 3



/***************************************************************************
** Control codes for text strings
***************************************************************************/

#define MUIX_R '\er'    /* right justified */
#define MUIX_C '\ec'    /* centered        */
#define MUIX_L '\el'    /* left justified  */

#define MUIX_N '\en'    /* normal     */
#define MUIX_B '\eb'    /* bold       */
#define MUIX_I '\ei'    /* italic     */
#define MUIX_U '\eu'    /* underlined */

#define MUIX_PT '\e2'   /* text pen           */
#define MUIX_PH '\e8'   /* highlight text pen */



/***************************************************************************
** Parameter structures for some classes
***************************************************************************/

OBJECT mui_palette_entry
    mpe_id    :LONG
    mpe_red   :LONG
    mpe_green :LONG
    mpe_blue  :LONG
    mpe_group :LONG
ENDOBJECT

CONST MUIV_Palette_Entry_End = -1


OBJECT mui_scrmodelist_entry
    sme_name   :PTR TO CHAR
    sme_modeid :LONG
ENDOBJECT

OBJECT mui_inputhandlernode
    ihn_node    :mln
    ihn_object  :LONG
    ihn_signals :LONG
    ihn_flags   :LONG
    ihn_method  :LONG
ENDOBJECT

OBJECT mui_list_testpos_result
    entry   :LONG  /* number of entry, -1 if mouse not over valid entry */
    column  :INT   /* numer of column, -1 if no valid column */
    flags   :INT   /* see below */
    xoffset :INT   /* currently unused */
    yoffset :INT   /* y offset of mouse click from center of line 
                     (negative values mean click was above center,
                      positive values mean click was below center) */
ENDOBJECT

CONST MUI_LPR_ABOVE  = 1
CONST MUI_LPR_BELOW  = 2
CONST MUI_LPR_LEFT   = 4
CONST MUI_LPR_RIGHT  = 8

/***************************************************************************
**
** Macro Section
** -------------
**
** To make GUI creation more easy and understandable, you can use the
** macros below. If you dont want, just define MUI_NOSHORTCUTS to disable
** them.
**
***************************************************************************/

#ifndef MUI_NOSHORTCUTS

/***************************************************************************
**
** Object Generation
** -----------------
**
** The xxxObject (and xChilds) macros generate new instances of MUI classes.
** Every xxxObject can be followed by tagitems specifying initial create
** time attributes for the new object and must be terminated with the
** End macro:
**
** obj = StringObject,
**          MUIA_String_Contents, 'foo',
**          MUIA_String_MaxLen  , 40,
**          End
**
** With the Child, SubWindow and WindowContents shortcuts you can
** construct a complete GUI within one command:
**
** app = ApplicationObject,
**
**          ...
**
**          SubWindow, WindowObject,
**             WindowContents, VGroup,
**                Child, String('foo',40),
**                Child, String('bar',50),
**                Child, HGroup,
**                   Child, CheckMark(MUI_TRUE),
**                   Child, CheckMark(FALSE),
**                   End,
**                End,
**             End,
**
**          SubWindow, WindowObject,
**             WindowContents, HGroup,
**                Child, ...,
**                Child, ...,
**                End,
**             End,
**
**          ...
**
**          End
**
***************************************************************************/

#define MenustripObject      Mui_NewObjectA(MUIC_Menustrip,[TAG_IGNORE,0
#define MenuObject           Mui_NewObjectA(MUIC_Menu,[TAG_IGNORE,0
#define MenuObjectT(name)    Mui_NewObjectA(MUIC_Menu,[MUIA_Menu_Title,name
#define MenuitemObject       Mui_NewObjectA(MUIC_Menuitem,[TAG_IGNORE,0
#define WindowObject         Mui_NewObjectA(MUIC_Window,[TAG_IGNORE,0
#define ImageObject          Mui_NewObjectA(MUIC_Image,[TAG_IGNORE,0
#define BitmapObject         Mui_NewObjectA(MUIC_Bitmap,[TAG_IGNORE,0
#define BodychunkObject      Mui_NewObjectA(MUIC_Bodychunk,[TAG_IGNORE,0
#define NotifyObject         Mui_NewObjectA(MUIC_Notify,[TAG_IGNORE,0
#define ApplicationObject    Mui_NewObjectA(MUIC_Application,[TAG_IGNORE,0
#define TextObject           Mui_NewObjectA(MUIC_Text,[TAG_IGNORE,0
#define RectangleObject      Mui_NewObjectA(MUIC_Rectangle,[TAG_IGNORE,0
#define BalanceObject        Mui_NewObjectA(MUIC_Balance,[TAG_IGNORE,0
#define ListObject           Mui_NewObjectA(MUIC_List,[TAG_IGNORE,0
#define PropObject           Mui_NewObjectA(MUIC_Prop,[TAG_IGNORE,0
#define StringObject         Mui_NewObjectA(MUIC_String,[TAG_IGNORE,0
#define ScrollbarObject      Mui_NewObjectA(MUIC_Scrollbar,[TAG_IGNORE,0
#define ListviewObject       Mui_NewObjectA(MUIC_Listview,[TAG_IGNORE,0
#define RadioObject          Mui_NewObjectA(MUIC_Radio,[TAG_IGNORE,0
#define VolumelistObject     Mui_NewObjectA(MUIC_Volumelist,[TAG_IGNORE,0
#define FloattextObject      Mui_NewObjectA(MUIC_Floattext,[TAG_IGNORE,0
#define DirlistObject        Mui_NewObjectA(MUIC_Dirlist,[TAG_IGNORE,0
#define SliderObject         Mui_NewObjectA(MUIC_Slider,[TAG_IGNORE,0
#define CycleObject          Mui_NewObjectA(MUIC_Cycle,[TAG_IGNORE,0
#define GaugeObject          Mui_NewObjectA(MUIC_Gauge,[TAG_IGNORE,0
#define ScaleObject          Mui_NewObjectA(MUIC_Scale,[TAG_IGNORE,0
#define NumericObject        Mui_NewObjectA(MUIC_Numeric,[TAG_IGNORE,0
#define NumericbuttonObject  Mui_NewObjectA(MUIC_Numericbutton,[TAG_IGNORE,0
#define KnobObject           Mui_NewObjectA(MUIC_Knob,[TAG_IGNORE,0
#define LevelmeterObject     Mui_NewObjectA(MUIC_Levelmeter,[TAG_IGNORE,0
#define BoopsiObject         Mui_NewObjectA(MUIC_Boopsi,[TAG_IGNORE,0
#define ColorfieldObject     Mui_NewObjectA(MUIC_Colorfield,[TAG_IGNORE,0
#define PenadjustObject      Mui_NewObjectA(MUIC_Penadjust,[TAG_IGNORE,0
#define ColoradjustObject    Mui_NewObjectA(MUIC_Coloradjust,[TAG_IGNORE,0
#define PaletteObject        Mui_NewObjectA(MUIC_Palette,[TAG_IGNORE,0
#define GroupObject          Mui_NewObjectA(MUIC_Group,[TAG_IGNORE,0
#define RegisterObject       Mui_NewObjectA(MUIC_Register,[TAG_IGNORE,0
#define VirtgroupObject      Mui_NewObjectA(MUIC_Virtgroup,[TAG_IGNORE,0
#define ScrollgroupObject    Mui_NewObjectA(MUIC_Scrollgroup,[TAG_IGNORE,0
#define PopstringObject      Mui_NewObjectA(MUIC_Popstring,[TAG_IGNORE,0
#define PopobjectObject      Mui_NewObjectA(MUIC_Popobject,[TAG_IGNORE,0
#define PoplistObject        Mui_NewObjectA(MUIC_Poplist,[TAG_IGNORE,0
#define PopaslObject         Mui_NewObjectA(MUIC_Popasl,[TAG_IGNORE,0
#define PoppenObject         Mui_NewObjectA(MUIC_Poppen,[TAG_IGNORE,0
#define AboutmuiObject       Mui_NewObjectA(MUIC_Aboutmui,[TAG_IGNORE,0
#define ScrmodelistObject    Mui_NewObjectA(MUIC_Scrmodelist,[TAG_IGNORE,0
#define KeyentryObject       Mui_NewObjectA(MUIC_Keyentry,[TAG_IGNORE,0
#define VGroup               Mui_NewObjectA(MUIC_Group,[TAG_IGNORE,0
#define HGroup               Mui_NewObjectA(MUIC_Group,[MUIA_Group_Horiz,MUI_TRUE
#define ColGroup(cols)       Mui_NewObjectA(MUIC_Group,[MUIA_Group_Columns,(cols)
#define RowGroup(rows)       Mui_NewObjectA(MUIC_Group,[MUIA_Group_Rows   ,