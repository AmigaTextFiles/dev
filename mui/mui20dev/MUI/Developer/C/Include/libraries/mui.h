/***************************************************************************
**
** MUI - MagicUserInterface
** (c) 1993 by Stefan Stuntz
**
** Main Header File
**
****************************************************************************
** Class Tree
****************************************************************************
**
** rootclass               (BOOPSI's base class)
** +--Notify               (implements notification mechanism)
**    +--Application       (main class for all applications)
**    +--Window            (handles intuition window related topics)
**    +--Area              (base class for all GUI elements)
**       +--Rectangle      (creates (empty) rectangles)
**       +--Image          (creates images)
**       +--Text           (creates some text)
**       +--String         (creates a string gadget)
**       +--Prop           (creates a proportional gadget)
**       +--Gauge          (creates a fule gauge)
**       +--Scale          (creates a percentage scale)
**       +--Boopsi         (interface to BOOPSI gadgets)
**       +--Colorfield     (creates a field with changeable color)
**       +--List           (creates a line-oriented list)
**       !  +--Floattext   (special list with floating text)
**       !  +--Volumelist  (special list with volumes)
**       !  +--Scrmodelist (special list with screen modes)
**       !  \--Dirlist     (special list with files)
**       +--Group          (groups other GUI elements)
**          +--Virtgroup   (handles virtual groups)
**          +--Scrollgroup (handles virtual groups with scrollers)
**          +--Scrollbar   (creates a scrollbar)
**          +--Listview    (creates a listview)
**          +--Radio       (creates radio buttons)
**          +--Cycle       (creates cycle gadgets)
**          +--Slider      (creates slider gadgets)
**          +--Coloradjust (creates some RGB sliders)
**          +--Palette     (creates a complete palette gadget)
**          +--Popstring   (base class for popups)
**             +--Popobject(popup a MUI object in a window)
**             \--Popasl   (popup an asl requester)
**
****************************************************************************
** General Header File Information
****************************************************************************
**
** All macro and structure definitions follow these rules:
**
** Name                       Meaning
**
** MUIC_<class>               Name of a class
** MUIM_<class>_<method>      Method
** MUIP_<class>_<method>      Methods parameter structure
** MUIV_<class>_<method>_<x>  Special method value
** MUIA_<class>_<attrib>      Attribute
** MUIV_<class>_<attrib>_<x>  Special attribute value
** MUIE_<error>               Error return code from MUI_Error()
** MUII_<name>                Standard MUI image
** MUIX_<code>                Control codes for text strings
**
** MUIA_... attribute definitions are followed by a comment
** consisting of the three possible letters I, S and G.
** I: it's possible to specify this attribute at object creation time.
** S: it's possible to change this attribute with SetAttrs().
** G: it's possible to get this attribute with GetAttr().
**
** Items marked with "Custom Class" are for use in custom classes only!
*/


#ifndef LIBRARIES_MUI_H
#define LIBRARIES_MUI_H

#ifndef EXEC_TYPES_H
#include "exec/types.h"
#endif

#ifndef INTUITION_CLASSES_H
#include "intuition/classes.h"
#endif

#ifndef INTUITION_SCREENS_H
#include "intuition/screens.h"
#endif

#ifndef CLIB_INTUITION_PROTOS_H
#include "clib/intuition_protos.h"
#endif



/***************************************************************************
** Library specification
***************************************************************************/

#define MUIMASTER_NAME "muimaster.library"
#define MUIMASTER_VMIN 4



/***************************************************************************
** ARexx Interface
***************************************************************************/

struct MUI_Command
{
	char        *mc_Name;
	char        *mc_Template;
	LONG         mc_Parameters;
	struct Hook *mc_Hook;
	LONG         mc_Reserved[5];
};

#define MC_TEMPLATE_ID ((STRPTR)~0)

#define MUI_RXERR_BADDEFINITION  -1
#define MUI_RXERR_OUTOFMEMORY    -2
#define MUI_RXERR_UNKNOWNCOMMAND -3
#define MUI_RXERR_BADSYNTAX      -4


/***************************************************************************
** Return values for MUI_Error()
***************************************************************************/

#define MUIE_OK                  0
#define MUIE_OutOfMemory         1
#define MUIE_OutOfGfxMemory      2
#define MUIE_InvalidWindowObject 3
#define MUIE_MissingLibrary      4
#define MUIE_NoARexx             5
#define MUIE_SingleTask          6



/***************************************************************************
** Standard MUI Images
***************************************************************************/

#define MUII_WindowBack     0   /* These images are configured   */
#define MUII_RequesterBack  1   /* with the preferences program. */
#define MUII_ButtonBack     2
#define MUII_ListBack       3
#define MUII_TextBack       4
#define MUII_PropBack       5
#define MUII_ActiveBack     6   /* obsolete, don't use! */
#define MUII_SelectedBack   7
#define MUII_ListCursor     8
#define MUII_ListSelect     9
#define MUII_ListSelCur    10
#define MUII_ArrowUp       11
#define MUII_ArrowDown     12
#define MUII_ArrowLeft     13
#define MUII_ArrowRight    14
#define MUII_CheckMark     15
#define MUII_RadioButton   16
#define MUII_Cycle         17
#define MUII_PopUp         18
#define MUII_PopFile       19
#define MUII_PopDrawer     20
#define MUII_PropKnob      21
#define MUII_Drawer        22
#define MUII_HardDisk      23
#define MUII_Disk          24
#define MUII_Chip          25
#define MUII_Volume        26
#define MUII_PopUpBack     27
#define MUII_Network       28
#define MUII_Assign        29
#define MUII_TapePlay      30
#define MUII_TapePlayBack  31
#define MUII_TapePause     32
#define MUII_TapeStop      33
#define MUII_TapeRecord    34
#define MUII_GroupBack     35
#define MUII_SliderBack    36
#define MUII_SliderKnob    37
#define MUII_TapeUp        38
#define MUII_TapeDown      39
#define MUII_Count         40

#define MUII_BACKGROUND    128    /* These are direct color    */
#define MUII_SHADOW        129    /* combinations and are not  */
#define MUII_SHINE         130    /* affected by users prefs.  */
#define MUII_FILL          131
#define MUII_SHADOWBACK    132    /* Generally, you should     */
#define MUII_SHADOWFILL    133    /* avoid using them. Better  */
#define MUII_SHADOWSHINE   134    /* use one of the customized */
#define MUII_FILLBACK      135    /* images above.             */
#define MUII_FILLSHINE     136
#define MUII_SHINEBACK     137
#define MUII_FILLBACK2     138
#define MUII_HSHINEBACK    139
#define MUII_HSHADOWBACK   140
#define MUII_HSHINESHINE   141
#define MUII_HSHADOWSHADOW 142
#define MUII_N1HSHINE      143
#define MUII_LASTPAT       143



/***************************************************************************
** Special values for some methods
***************************************************************************/

#define MUIV_TriggerValue 0x49893131
#define MUIV_EveryTime    0x49893131

#define MUIV_Application_Save_ENV     ((STRPTR) 0)
#define MUIV_Application_Save_ENVARC  ((STRPTR)~0)
#define MUIV_Application_Load_ENV     ((STRPTR) 0)
#define MUIV_Application_Load_ENVARC  ((STRPTR)~0)

#define MUIV_Application_ReturnID_Quit -1

#define MUIV_List_Insert_Top             0
#define MUIV_List_Insert_Active         -1
#define MUIV_List_Insert_Sorted         -2
#define MUIV_List_Insert_Bottom         -3

#define MUIV_List_Remove_First           0
#define MUIV_List_Remove_Active         -1
#define MUIV_List_Remove_Last           -2

#define MUIV_List_Select_Off             0
#define MUIV_List_Select_On              1
#define MUIV_List_Select_Toggle          2
#define MUIV_List_Select_Ask             3

#define MUIV_List_Jump_Active           -1
#define MUIV_List_GetEntry_Active       -1
#define MUIV_List_Select_Active         -1
#define MUIV_List_Select_All            -2

#define MUIV_List_Redraw_Active         -1
#define MUIV_List_Redraw_All            -2

#define MUIV_List_Exchange_Active       -1

#define MUIV_Colorpanel_GetColor_Active -1
#define MUIV_Colorpanel_SetColor_Active -1


/***************************************************************************
** Control codes for text strings
***************************************************************************/

#define MUIX_R "\033r"    /* right justified */
#define MUIX_C "\033c"    /* centered        */
#define MUIX_L "\033l"    /* left justified  */

#define MUIX_N "\033n"    /* normal     */
#define MUIX_B "\033b"    /* bold       */
#define MUIX_I "\033i"    /* italic     */
#define MUIX_U "\033u"    /* underlined */

#define MUIX_PT "\0332"   /* text pen           */
#define MUIX_PH "\0338"   /* highlight text pen */



/***************************************************************************
** Parameter structures for some classes
***************************************************************************/

struct MUI_Palette_Entry
{
	LONG  mpe_ID;
	ULONG mpe_Red;
	ULONG mpe_Green;
	ULONG mpe_Blue;
	LONG  mpe_Group;
};

#define MUIV_Palette_Entry_End -1


struct MUI_Scrmodelist_Entry
{
	char *sme_Name;
	ULONG sme_ModeID;
};



/***************************************************************************
**
** Macro Section
** -------------
**
** To make GUI creation more easy and understandable, you can use the
** macros below. If you dont want, just define MUI_NOSHORTCUTS to disable
** them.
**
** These macros are available to C programmers only.
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
**          MUIA_String_Contents, "foo",
**          MUIA_String_MaxLen  , 40,
**          End;
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
**                Child, String("foo",40),
**                Child, String("bar",50),
**                Child, HGroup,
**                   Child, CheckMark(TRUE),
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
**          End;
**
***************************************************************************/

#define WindowObject      MUI_NewObject(MUIC_Window
#define ImageObject       MUI_NewObject(MUIC_Image
#define NotifyObject      MUI_NewObject(MUIC_Notify
#define ApplicationObject MUI_NewObject(MUIC_Application
#define TextObject        MUI_NewObject(MUIC_Text
#define RectangleObject   MUI_NewObject(MUIC_Rectangle
#define ListObject        MUI_NewObject(MUIC_List
#define PropObject        MUI_NewObject(MUIC_Prop
#define StringObject      MUI_NewObject(MUIC_String
#define ScrollbarObject   MUI_NewObject(MUIC_Scrollbar
#define ListviewObject    MUI_NewObject(MUIC_Listview
#define RadioObject       MUI_NewObject(MUIC_Radio
#define VolumelistObject  MUI_NewObject(MUIC_Volumelist
#define FloattextObject   MUI_NewObject(MUIC_Floattext
#define DirlistObject     MUI_NewObject(MUIC_Dirlist
#define SliderObject      MUI_NewObject(MUIC_Slider
#define CycleObject       MUI_NewObject(MUIC_Cycle
#define GaugeObject       MUI_NewObject(MUIC_Gauge
#define ScaleObject       MUI_NewObject(MUIC_Scale
#define BoopsiObject      MUI_NewObject(MUIC_Boopsi
#define ColorfieldObject  MUI_NewObject(MUIC_Colorfield
#define ColorpanelObject  MUI_NewObject(MUIC_Colorpanel
#define ColoradjustObject MUI_NewObject(MUIC_Coloradjust
#define PaletteObject     MUI_NewObject(MUIC_Palette
#define GroupObject       MUI_NewObject(MUIC_Group
#define RegisterObject    MUI_NewObject(MUIC_Register
#define VirtgroupObject   MUI_NewObject(MUIC_Virtgroup
#define ScrollgroupObject MUI_NewObject(MUIC_Scrollgroup
#define PopstringObject   MUI_NewObject(MUIC_Popstring
#define PopobjectObject   MUI_NewObject(MUIC_Popobject
#define PopaslObject      MUI_NewObject(MUIC_Popasl
#define ScrmodelistObject MUI_NewObject(MUIC_Scrmodelist
#define VGroup            MUI_NewObject(MUIC_Group
#define HGroup            MUI_NewObject(MUIC_Group,MUIA_Group_Horiz,TRUE
#define ColGroup(cols)    MUI_NewObject(MUIC_Group,MUIA_Group_Columns,(cols)
#define RowGroup(rows)    MUI_NewObject(MUIC_Group,MUIA_Group_Rows   ,(rows)
#define PageGroup         MUI_NewObject(MUIC_Group,MUIA_Group_PageMode,TRUE
#define VGroupV           MUI_NewObject(MUIC_Virtgroup
#define HGroupV           MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Horiz,TRUE
#define ColGroupV(cols)   MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Columns,(cols)
#define RowGroupV(rows)   MUI_NewObject(MUIC_Virtgroup,MUIA_Group_Rows   ,(rows)
#define PageGroupV        MUI_NewObject(MUIC_Virtgroup,MUIA_Group_PageMode,TRUE
#define RegisterGroup(t)  MUI_NewObject(MUIC_Register,MUIA_Register_Titles,(t)
#define End               TAG_DONE)

#define Child             MUIA_Group_Child
#define SubWindow         MUIA_Application_Window
#define WindowContents    MUIA_Window_RootObject



/***************************************************************************
**
** Frame Types
** -----------
**
** These macros may be used to specify one of MUI's different frame types.
** Note that every macro consists of one { ti_Tag, ti_Data } pair.
**
** GroupFrameT() is a special kind of frame that contains a centered
** title text.
**
** HGroup, GroupFrameT("Horiz Groups"),
**    Child, RectangleObject, TextFrame  , End,
**    Child, RectangleObject, StringFrame, End,
**    Child, RectangleObject, ButtonFrame, End,
**    Child, RectangleObject, ListFrame  , End,
**    End,
**
***************************************************************************/

#define NoFrame          MUIA_Frame, MUIV_Frame_None
#define ButtonFrame      MUIA_Frame, MUIV_Frame_Button
#define ImageButtonFrame MUIA_Frame, MUIV_Frame_ImageButton
#define TextFrame        MUIA_Frame, MUIV_Frame_Text
#define StringFrame      MUIA_Frame, MUIV_Frame_String
#define ReadListFrame    MUIA_Frame, MUIV_Frame_ReadList
#define InputListFrame   MUIA_Frame, MUIV_Frame_InputList
#define PropFrame        MUIA_Frame, MUIV_Frame_Prop
#define SliderFrame      MUIA_Frame, MUIV_Frame_Slider
#define GaugeFrame       MUIA_Frame, MUIV_Frame_Gauge
#define VirtualFrame     MUIA_Frame, MUIV_Frame_Virtual
#define GroupFrame       MUIA_Frame, MUIV_Frame_Group
#define GroupFrameT(s)   MUIA_Frame, MUIV_Frame_Group, MUIA_FrameTitle, s



/***************************************************************************
**
** Spacing Macros
** --------------
**
***************************************************************************/

#define HVSpace           MUI_NewObject(MUIC_Rectangle,TAG_DONE)
#define HSpace(x)         MUI_NewObject(MUIC_Rectangle,(x) ? MUIA_FixWidth  : TAG_IGNORE,(x), MUIA_VertWeight , 0, TAG_DONE)
#define VSpace(x)         MUI_NewObject(MUIC_Rectangle,(x) ? MUIA_FixHeight : TAG_IGNORE,(x), MUIA_HorizWeight, 0, TAG_DONE)
#define HCenter(obj)      (HGroup, GroupSpacing(0), Child, HSpace(0), Child, (obj), Child, HSpace(0), End)
#define VCenter(obj)      (VGroup, GroupSpacing(0), Child, VSpace(0), Child, (obj), Child, VSpace(0), End)
#define InnerSpacing(h,v) MUIA_InnerLeft,(h),MUIA_InnerRight,(h),MUIA_InnerTop,(v),MUIA_InnerBottom,(v)
#define GroupSpacing(x)   MUIA_Group_Spacing,x



/***************************************************************************
**
** String-Object
** -------------
**
** The following macro creates a simple string gadget.
**
***************************************************************************/

#define String(contents,maxlen)\
	StringObject,\
		StringFrame,\
		MUIA_String_MaxLen  , maxlen,\
		MUIA_String_Contents, contents,\
		End

#define KeyString(contents,maxlen,controlchar)\
	StringObject,\
		StringFrame,\
		MUIA_ControlChar    , controlchar,\
		MUIA_String_MaxLen  , maxlen,\
		MUIA_String_Contents, contents,\
		End



/***************************************************************************
**
** CheckMark-Object
** ----------------
**
** The following macro creates a checkmark gadget.
**
***************************************************************************/

#define CheckMark(selected)\
	ImageObject,\
		ImageButtonFrame,\
		MUIA_InputMode        , MUIV_InputMode_Toggle,\
		MUIA_Image_Spec       , MUII_CheckMark,\
		MUIA_Image_FreeVert   , TRUE,\
		MUIA_Selected         , selected,\
		MUIA_Background       , MUII_ButtonBack,\
		MUIA_ShowSelState     , FALSE,\
		End

#define KeyCheckMark(selected,control)\
	ImageObject,\
		ImageButtonFrame,\
		MUIA_InputMode        , MUIV_InputMode_Toggle,\
		MUIA_Image_Spec       , MUII_CheckMark,\
		MUIA_Image_FreeVert   , TRUE,\
		MUIA_Selected         , selected,\
		MUIA_Background       , MUII_ButtonBack,\
		MUIA_ShowSelState     , FALSE,\
		MUIA_ControlChar      , control,\
		End



/***************************************************************************
**
** Button-Objects
** --------------
**
** Note: Use small letters for KeyButtons, e.g.
**       KeyButton("Cancel",'c')  and not  KeyButton("Cancel",'C') !!
**
***************************************************************************/

#define SimpleButton(name)\
	TextObject,\
		ButtonFrame,\
		MUIA_Text_Contents, name,\
		MUIA_Text_PreParse, "\33c",\
		MUIA_InputMode    , MUIV_InputMode_RelVerify,\
		MUIA_Background   , MUII_ButtonBack,\
		End

#define KeyButton(name,key)\
	TextObject,\
		ButtonFrame,\
		MUIA_Text_Contents, name,\
		MUIA_Text_PreParse, "\33c",\
		MUIA_Text_HiChar  , key,\
		MUIA_ControlChar  , key,\
		MUIA_InputMode    , MUIV_InputMode_RelVerify,\
		MUIA_Background   , MUII_ButtonBack,\
		End



/***************************************************************************
**
** Cycle-Object
** ------------
**
***************************************************************************/

#define Cycle(entries)        CycleObject, MUIA_Cycle_Entries, entries, End
#define KeyCycle(entries,key) CycleObject, MUIA_Cycle_Entries, entries, MUIA_ControlChar, key, End



/***************************************************************************
**
** Radio-Object
** ------------
**
***************************************************************************/

#define Radio(name,array)\
	RadioObject,\
		GroupFrameT(name),\
		MUIA_Radio_Entries,array,\
		End

#define KeyRadio(name,array,key)\
	RadioObject,\
		GroupFrameT(name),\
		MUIA_Radio_Entries,array,\
		MUIA_ControlChar, key,\
		End



/***************************************************************************
**
** Slider-Object
** -------------
**
***************************************************************************/


#define Slider(min,max,level)\
	SliderObject,\
		MUIA_Slider_Min  , min,\
		MUIA_Slider_Max  , max,\
		MUIA_Slider_Level, level,\
		End

#define KeySlider(min,max,level,key)\
	SliderObject,\
		MUIA_Slider_Min  , min,\
		MUIA_Slider_Max  , max,\
		MUIA_Slider_Level, level,\
		MUIA_ControlChar , key,\
		End



/***************************************************************************
**
** Button to be used for popup objects
**
***************************************************************************/

#define PopButton(img) ImageObject,\
	ImageButtonFrame,\
	MUIA_Image_Spec          , img,\
	MUIA_Image_FontMatchWidth, TRUE,\
	MUIA_Image_FreeVert      , TRUE,\
	MUIA_InputMode           , MUIV_InputMode_RelVerify,\
	MUIA_Background          , MUII_BACKGROUND,\
	End



/***************************************************************************
**
** Labeling Objects
** ----------------
**
** Labeling objects, e.g. a group of string gadgets,
**
**   Small: |foo   |
**  Normal: |bar   |
**     Big: |foobar|
**    Huge: |barfoo|
**
** is done using a 2 column group:
**
** ColGroup(2),
** 	Child, Label2("Small:" ),
**    Child, StringObject, End,
** 	Child, Label2("Normal:"),
**    Child, StringObject, End,
** 	Child, Label2("Big:"   ),
**    Child, StringObject, End,
** 	Child, Label2("Huge:"  ),
**    Child, StringObject, End,
**    End,
**
** Note that we have three versions of the label macro, depending on
** the frame type of the right hand object:
**
** Label1(): For use with standard frames (e.g. checkmarks).
** Label2(): For use with double high frames (e.g. string gadgets).
** Label() : For use with objects without a frame.
**
** These macros ensure that your label will look fine even if the
** user of your application configured some strange spacing values.
** If you want to use your own labeling, you'll have to pay attention
** on this topic yourself.
**
***************************************************************************/

#define Label(label)   TextObject, MUIA_Text_PreParse, "\33r", MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, End
#define Label1(label)  TextObject, MUIA_Text_PreParse, "\33r", MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, ButtonFrame, MUIA_FramePhantomHoriz, TRUE, End
#define Label2(label)  TextObject, MUIA_Text_PreParse, "\33r", MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, StringFrame, MUIA_FramePhantomHoriz, TRUE, End
#define LLabel(label)  TextObject, MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, End
#define LLabel1(label) TextObject, MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, ButtonFrame, MUIA_FramePhantomHoriz, TRUE, End
#define LLabel2(label) TextObject, MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, StringFrame, MUIA_FramePhantomHoriz, TRUE, End

#define KeyLabel(label,hichar)   TextObject, MUIA_Text_PreParse, "\33r", MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, MUIA_Text_HiChar, hichar, End
#define KeyLabel1(label,hichar)  TextObject, MUIA_Text_PreParse, "\33r", MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, MUIA_Text_HiChar, hichar, ButtonFrame, MUIA_FramePhantomHoriz, TRUE, End
#define KeyLabel2(label,hichar)  TextObject, MUIA_Text_PreParse, "\33r", MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, MUIA_Text_HiChar, hichar, StringFrame, MUIA_FramePhantomHoriz, TRUE, End
#define KeyLLabel(label,hichar)  TextObject, MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, MUIA_Text_HiChar, hichar, End
#define KeyLLabel1(label,hichar) TextObject, MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, MUIA_Text_HiChar, hichar, ButtonFrame, MUIA_FramePhantomHoriz, TRUE, End
#define KeyLLabel2(label,hichar) TextObject, MUIA_Text_Contents, label, MUIA_Weight, 0, MUIA_InnerLeft, 0, MUIA_InnerRight, 0, MUIA_Text_HiChar, hichar, StringFrame, MUIA_FramePhantomHoriz, TRUE, End



/***************************************************************************
**
** Controlling Objects
** -------------------
**
** set() and get() are two short stubs for BOOPSI GetAttr() and SetAttrs()
** calls:
**
** {
**    char *x;
**
**    set(obj,MUIA_String_Contents,"foobar");
**    get(obj,MUIA_String_Contents,&x);
**
**    printf("gadget contains '%s'\n",x);
** }
**
** nnset() sets an attribute without triggering a possible notification.
**
***************************************************************************/

#define get(obj,attr,store) GetAttr(attr,obj,(ULONG *)store)
#define set(obj,attr,value) SetAttrs(obj,attr,value,TAG_DONE)
#define nnset(obj,attr,value) SetAttrs(obj,MUIA_NoNotify,TRUE,attr,value,TAG_DONE)

#define setmutex(obj,n)     set(obj,MUIA_Radio_Active,n)
#define setcycle(obj,n)     set(obj,MUIA_Cycle_Active,n)
#define setstring(obj,s)    set(obj,MUIA_String_Contents,s)
#define setcheckmark(obj,b) set(obj,MUIA_Selected,b)
#define setslider(obj,l)    set(obj,MUIA_Slider_Level,l)

#endif /* MUI_NOSHORTCUTS */


/***************************************************************************
**
** For Boopsi Image Implementors Only:
**
** If MUI is using a boopsi image object, it will send a special method
** immediately after object creation. This method has a parameter structure
** where the boopsi can fill in its minimum and maximum size and learn if
** its used in a horizontal or vertical context.
**
** The boopsi image must use the method id (MUIM_BoopsiQuery) as return
** value. That's how MUI sees that the method is implemented.
**
** Note: MUI does not depend on this method. If the boopsi image doesn't
**       implement it, minimum size will be 0 and maximum size unlimited.
**
***************************************************************************/

#define MUIM_BoopsiQuery 0x80427157 /* this is send to the boopsi and */
                                    /* must be used as return value   */

struct MUI_BoopsiQuery              /* parameter structure */
{
	ULONG mbq_MethodID;              /* always MUIM_BoopsiQuery */

	struct Screen *mbq_Screen;       /* obsolete, use mbq_RenderInfo */
	ULONG mbq_Flags;                 /* read only, see below */

	LONG mbq_MinWidth ;              /* write only, fill in min width  */
	LONG mbq_MinHeight;              /* write only, fill in min height */
	LONG mbq_MaxWidth ;              /* write only, fill in max width  */
	LONG mbq_MaxHeight;              /* write only, fill in max height */
	LONG mbq_DefWidth ;              /* write only, fill in def width  */
	LONG mbq_DefHeight;              /* write only, fill in def height */

	struct MUI_RenderInfo *mbq_RenderInfo;  /* read only, display context */

	/* may grow in future ... */
};

#define MUIP_BoopsiQuery MUI_BoopsiQuery  /* old structure name */

#define MBQF_HORIZ (1<<0)           /* object used in a horizontal */
                                    /* context (else vertical)     */

#define MBQ_MUI_MAXMAX (10000)          /* use this for unlimited MaxWidth/Height */


/****************************************************************************/
/** Notify.mui 7.13 (01.12.93)                                             **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Notify[];
#else
#define MUIC_Notify "Notify.mui"
#endif

/* Methods */

#define MUIM_CallHook                  0x8042b96b
#define MUIM_KillNotify                0x8042d240
#define MUIM_MultiSet                  0x8042d356
#define MUIM_Notify                    0x8042c9cb
#define MUIM_Set                       0x8042549a
#define MUIM_SetAsString               0x80422590
#define MUIM_WriteLong                 0x80428d86
#define MUIM_WriteString               0x80424bf4
struct  MUIP_CallHook                  { ULONG id; struct Hook *Hook; ULONG param1; /* ... */ };
struct  MUIP_KillNotify                { ULONG id; ULONG TrigAttr; };
struct  MUIP_MultiSet                  { ULONG id; ULONG attr; ULONG val; APTR obj; /* ... */ };
struct  MUIP_Notify                    { ULONG id; ULONG TrigAttr; ULONG TrigVal; APTR DestObj; ULONG FollowParams; /* ... */ };
struct  MUIP_Set                       { ULONG id; ULONG attr; ULONG val; };
struct  MUIP_SetAsString               { ULONG id; ULONG attr; char *format; ULONG val; /* ... */ };
struct  MUIP_WriteLong                 { ULONG id; ULONG val; ULONG *memory; };
struct  MUIP_WriteString               { ULONG id; char *str; char *memory; };

/* Attributes */

#define MUIA_AppMessage                 0x80421955 /* ..g struct AppMessage * */
#define MUIA_HelpFile                   0x80423a6e /* isg STRPTR            */
#define MUIA_HelpLine                   0x8042a825 /* isg LONG              */
#define MUIA_HelpNode                   0x80420b85 /* isg STRPTR            */
#define MUIA_NoNotify                   0x804237f9 /* .s. BOOL              */
#define MUIA_Revision                   0x80427eaa /* ..g LONG              */
#define MUIA_UserData                   0x80420313 /* isg ULONG             */
#define MUIA_Version                    0x80422301 /* ..g LONG              */



/****************************************************************************/
/** Application.mui 7.12 (28.11.93)                                        **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Application[];
#else
#define MUIC_Application "Application.mui"
#endif

/* Methods */

#define MUIM_Application_GetMenuCheck  0x8042c0a7
#define MUIM_Application_GetMenuState  0x8042a58f
#define MUIM_Application_Input         0x8042d0f5
#define MUIM_Application_InputBuffered 0x80427e59
#define MUIM_Application_Load          0x8042f90d
#define MUIM_Application_PushMethod    0x80429ef8
#define MUIM_Application_ReturnID      0x804276ef
#define MUIM_Application_Save          0x804227ef
#define MUIM_Application_SetMenuCheck  0x8042a707
#define MUIM_Application_SetMenuState  0x80428bef
#define MUIM_Application_ShowHelp      0x80426479
struct  MUIP_Application_GetMenuCheck  { ULONG id; ULONG MenuID; };
struct  MUIP_Application_GetMenuState  { ULONG id; ULONG MenuID; };
struct  MUIP_Application_Input         { ULONG id; LONGBITS *signal; };
struct  MUIP_Application_Load          { ULONG id; STRPTR name; };
struct  MUIP_Application_PushMethod    { ULONG id; Object *dest; LONG count; /* ... */ };
struct  MUIP_Application_ReturnID      { ULONG id; ULONG retid; };
struct  MUIP_Application_Save          { ULONG id; STRPTR name; };
struct  MUIP_Application_SetMenuCheck  { ULONG id; ULONG MenuID; LONG stat; };
struct  MUIP_Application_SetMenuState  { ULONG id; ULONG MenuID; LONG stat; };
struct  MUIP_Application_ShowHelp      { ULONG id; Object *window; char *name; char *node; LONG line; };

/* Attributes */

#define MUIA_Application_Active         0x804260ab /* isg BOOL              */
#define MUIA_Application_Author         0x80424842 /* i.g STRPTR            */
#define MUIA_Application_Base           0x8042e07a /* i.g STRPTR            */
#define MUIA_Application_Broker         0x8042dbce /* ..g Broker *          */
#define MUIA_Application_BrokerHook     0x80428f4b /* isg struct Hook *     */
#define MUIA_Application_BrokerPort     0x8042e0ad /* ..g struct MsgPort *  */
#define MUIA_Application_BrokerPri      0x8042c8d0 /* i.g LONG              */
#define MUIA_Application_Commands       0x80428648 /* isg struct MUI_Command * */
#define MUIA_Application_Copyright      0x8042ef4d /* i.g STRPTR            */
#define MUIA_Application_Description    0x80421fc6 /* i.g STRPTR            */
#define MUIA_Application_DiskObject     0x804235cb /* isg struct DiskObject * */
#define MUIA_Application_DoubleStart    0x80423bc6 /* ..g BOOL              */
#define MUIA_Application_DropObject     0x80421266 /* is. Object *          */
#define MUIA_Application_Iconified      0x8042a07f /* .sg BOOL              */
#define MUIA_Application_Menu           0x80420e1f /* i.g struct NewMenu *  */
#define MUIA_Application_MenuAction     0x80428961 /* ..g ULONG             */
#define MUIA_Application_MenuHelp       0x8042540b /* ..g ULONG             */
#define MUIA_Application_RexxHook       0x80427c42 /* isg struct Hook *     */
#define MUIA_Application_RexxMsg        0x8042fd88 /* ..g struct RxMsg *    */
#define MUIA_Application_RexxString     0x8042d711 /* .s. STRPTR            */
#define MUIA_Application_SingleTask     0x8042a2c8 /* i.. BOOL              */
#define MUIA_Application_Sleep          0x80425711 /* .s. BOOL              */
#define MUIA_Application_Title          0x804281b8 /* i.g STRPTR            */
#define MUIA_Application_Version        0x8042b33f /* i.g STRPTR            */
#define MUIA_Application_Window         0x8042bfe0 /* i.. Object *          */



/****************************************************************************/
/** Window.mui 7.16 (03.12.93)                                             **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Window[];
#else
#define MUIC_Window "Window.mui"
#endif

/* Methods */

#define MUIM_Window_GetMenuCheck       0x80420414
#define MUIM_Window_GetMenuState       0x80420d2f
#define MUIM_Window_ScreenToBack       0x8042913d
#define MUIM_Window_ScreenToFront      0x804227a4
#define MUIM_Window_SetCycleChain      0x80426510
#define MUIM_Window_SetMenuCheck       0x80422243
#define MUIM_Window_SetMenuState       0x80422b5e
#define MUIM_Window_ToBack             0x8042152e
#define MUIM_Window_ToFront            0x8042554f
struct  MUIP_Window_GetMenuCheck       { ULONG id; ULONG MenuID; };
struct  MUIP_Window_GetMenuState       { ULONG id; ULONG MenuID; };
struct  MUIP_Window_SetCycleChain      { ULONG id; APTR o1; /* ;o2;...;NULL */ };
struct  MUIP_Window_SetMenuCheck       { ULONG id; ULONG MenuID; LONG stat; };
struct  MUIP_Window_SetMenuState       { ULONG id; ULONG MenuID; LONG stat; };

/* Attributes */

#define MUIA_Window_Activate            0x80428d2f /* isg BOOL              */
#define MUIA_Window_ActiveObject        0x80427925 /* .sg Object *          */
#define MUIA_Window_AltHeight           0x8042cce3 /* i.g LONG              */
#define MUIA_Window_AltLeftEdge         0x80422d65 /* i.g LONG              */
#define MUIA_Window_AltTopEdge          0x8042e99b /* i.g LONG              */
#define MUIA_Window_AltWidth            0x804260f4 /* i.g LONG              */
#define MUIA_Window_AppWindow           0x804280cf /* i.. BOOL              */
#define MUIA_Window_Backdrop            0x8042c0bb /* i.. BOOL              */
#define MUIA_Window_Borderless          0x80429b79 /* i.. BOOL              */
#define MUIA_Window_CloseGadget         0x8042a110 /* i.. BOOL              */
#define MUIA_Window_CloseRequest        0x8042e86e /* ..g BOOL              */
#define MUIA_Window_DefaultObject       0x804294d7 /* isg Object *          */
#define MUIA_Window_DepthGadget         0x80421923 /* i.. BOOL              */
#define MUIA_Window_DragBar             0x8042045d /* i.. BOOL              */
#define MUIA_Window_Height              0x80425846 /* i.g LONG              */
#define MUIA_Window_ID                  0x804201bd /* isg ULONG             */
#define MUIA_Window_InputEvent          0x804247d8 /* ..g struct InputEvent * */
#define MUIA_Window_LeftEdge            0x80426c65 /* i.g LONG              */
#define MUIA_Window_Menu                0x8042db94 /* i.. struct NewMenu *  */
#define MUIA_Window_NoMenus             0x80429df5 /* .s. BOOL              */
#define MUIA_Window_Open                0x80428aa0 /* .sg BOOL              */
#define MUIA_Window_PublicScreen        0x804278e4 /* isg STRPTR            */
#define MUIA_Window_RefWindow           0x804201f4 /* is. Object *          */
#define MUIA_Window_RootObject          0x8042cba5 /* i.. Object *          */
#define MUIA_Window_Screen              0x8042df4f /* isg struct Screen *   */
#define MUIA_Window_ScreenTitle         0x804234b0 /* isg STRPTR            */
#define MUIA_Window_SizeGadget          0x8042e33d /* i.. BOOL              */
#define MUIA_Window_SizeRight           0x80424780 /* i.. BOOL              */
#define MUIA_Window_Sleep               0x8042e7db /* .sg BOOL              */
#define MUIA_Window_Title               0x8042ad3d /* isg STRPTR            */
#define MUIA_Window_TopEdge             0x80427c66 /* i.g LONG              */
#define MUIA_Window_Width               0x8042dcae /* i.g LONG              */
#define MUIA_Window_Window              0x80426a42 /* ..g struct Window *   */

#define MUIV_Window_ActiveObject_None 0
#define MUIV_Window_ActiveObject_Next -1
#define MUIV_Window_ActiveObject_Prev -2
#define MUIV_Window_AltHeight_MinMax(p) (0-(p))
#define MUIV_Window_AltHeight_Visible(p) (-100-(p))
#define MUIV_Window_AltHeight_Screen(p) (-200-(p))
#define MUIV_Window_AltHeight_Scaled -1000
#define MUIV_Window_AltLeftEdge_Centered -1
#define MUIV_Window_AltLeftEdge_Moused -2
#define MUIV_Window_AltLeftEdge_NoChange -1000
#define MUIV_Window_AltTopEdge_Centered -1
#define MUIV_Window_AltTopEdge_Moused -2
#define MUIV_Window_AltTopEdge_Delta(p) (-3-(p))
#define MUIV_Window_AltTopEdge_NoChange -1000
#define MUIV_Window_AltWidth_MinMax(p) (0-(p))
#define MUIV_Window_AltWidth_Visible(p) (-100-(p))
#define MUIV_Window_AltWidth_Screen(p) (-200-(p))
#define MUIV_Window_AltWidth_Scaled -1000
#define MUIV_Window_Height_MinMax(p) (0-(p))
#define MUIV_Window_Height_Visible(p) (-100-(p))
#define MUIV_Window_Height_Screen(p) (-200-(p))
#define MUIV_Window_Height_Scaled -1000
#define MUIV_Window_Height_Default -1001
#define MUIV_Window_LeftEdge_Centered -1
#define MUIV_Window_LeftEdge_Moused -2
#define MUIV_Window_Menu_NoMenu -1
#define MUIV_Window_TopEdge_Centered -1
#define MUIV_Window_TopEdge_Moused -2
#define MUIV_Window_TopEdge_Delta(p) (-3-(p))
#define MUIV_Window_Width_MinMax(p) (0-(p))
#define MUIV_Window_Width_Visible(p) (-100-(p))
#define MUIV_Window_Width_Screen(p) (-200-(p))
#define MUIV_Window_Width_Scaled -1000
#define MUIV_Window_Width_Default -1001


/****************************************************************************/
/** Area.mui 7.15 (28.11.93)                                               **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Area[];
#else
#define MUIC_Area "Area.mui"
#endif

/* Methods */

#define MUIM_AskMinMax                 0x80423874 /* Custom Class */
#define MUIM_Cleanup                   0x8042d985 /* Custom Class */
#define MUIM_Draw                      0x80426f3f /* Custom Class */
#define MUIM_HandleInput               0x80422a1a /* Custom Class */
#define MUIM_Hide                      0x8042f20f /* Custom Class */
#define MUIM_Setup                     0x80428354 /* Custom Class */
#define MUIM_Show                      0x8042cc84 /* Custom Class */
struct  MUIP_AskMinMax                 { ULONG id; struct MUI_MinMax *MinMaxInfo; }; /* Custom Class */
struct  MUIP_Draw                      { ULONG id; ULONG flags; }; /* Custom Class */
struct  MUIP_HandleInput               { ULONG id; struct IntuiMessage *imsg; LONG muikey; }; /* Custom Class */
struct  MUIP_Setup                     { ULONG id; struct MUI_RenderInfo *RenderInfo; }; /* Custom Class */

/* Attributes */

#define MUIA_ApplicationObject          0x8042d3ee /* ..g Object *          */
#define MUIA_Background                 0x8042545b /* is. LONG              */
#define MUIA_BottomEdge                 0x8042e552 /* ..g LONG              */
#define MUIA_ControlChar                0x8042120b /* i.. char              */
#define MUIA_Disabled                   0x80423661 /* isg BOOL              */
#define MUIA_ExportID                   0x8042d76e /* isg LONG              */
#define MUIA_FixHeight                  0x8042a92b /* i.. LONG              */
#define MUIA_FixHeightTxt               0x804276f2 /* i.. LONG              */
#define MUIA_FixWidth                   0x8042a3f1 /* i.. LONG              */
#define MUIA_FixWidthTxt                0x8042d044 /* i.. STRPTR            */
#define MUIA_Font                       0x8042be50 /* i.g struct TextFont * */
#define MUIA_Frame                      0x8042ac64 /* i.. LONG              */
#define MUIA_FramePhantomHoriz          0x8042ed76 /* i.. BOOL              */
#define MUIA_FrameTitle                 0x8042d1c7 /* i.. STRPTR            */
#define MUIA_Height                     0x80423237 /* ..g LONG              */
#define MUIA_HorizWeight                0x80426db9 /* i.. LONG              */
#define MUIA_InnerBottom                0x8042f2c0 /* i.. LONG              */
#define MUIA_InnerLeft                  0x804228f8 /* i.. LONG              */
#define MUIA_InnerRight                 0x804297ff /* i.. LONG              */
#define MUIA_InnerTop                   0x80421eb6 /* i.. LONG              */
#define MUIA_InputMode                  0x8042fb04 /* i.. LONG              */
#define MUIA_LeftEdge                   0x8042bec6 /* ..g LONG              */
#define MUIA_Pressed                    0x80423535 /* ..g BOOL              */
#define MUIA_RightEdge                  0x8042ba82 /* ..g LONG              */
#define MUIA_Selected                   0x8042654b /* isg BOOL              */
#define MUIA_ShowMe                     0x80429ba8 /* isg BOOL              */
#define MUIA_ShowSelState               0x8042caac /* i.. BOOL              */
#define MUIA_Timer                      0x80426435 /* ..g LONG              */
#define MUIA_TopEdge                    0x8042509b /* ..g LONG              */
#define MUIA_VertWeight                 0x804298d0 /* i.. LONG              */
#define MUIA_Weight                     0x80421d1f /* i.. LONG              */
#define MUIA_Width                      0x8042b59c /* ..g LONG              */
#define MUIA_Window                     0x80421591 /* ..g struct Window *   */
#define MUIA_WindowObject               0x8042669e /* ..g Object *          */

#define MUIV_Font_Inherit 0
#define MUIV_Font_Normal -1
#define MUIV_Font_List -2
#define MUIV_Font_Tiny -3
#define MUIV_Font_Fixed -4
#define MUIV_Font_Title -5
#define MUIV_Frame_None 0
#define MUIV_Frame_Button 1
#define MUIV_Frame_ImageButton 2
#define MUIV_Frame_Text 3
#define MUIV_Frame_String 4
#define MUIV_Frame_ReadList 5
#define MUIV_Frame_InputList 6
#define MUIV_Frame_Prop 7
#define MUIV_Frame_Gauge 8
#define MUIV_Frame_Group 9
#define MUIV_Frame_PopUp 10
#define MUIV_Frame_Virtual 11
#define MUIV_Frame_Slider 12
#define MUIV_Frame_Count 13
#define MUIV_InputMode_None 0
#define MUIV_InputMode_RelVerify 1
#define MUIV_InputMode_Immediate 2
#define MUIV_InputMode_Toggle 3


/****************************************************************************/
/** Rectangle.mui 7.14 (28.11.93)                                          **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Rectangle[];
#else
#define MUIC_Rectangle "Rectangle.mui"
#endif

/* Attributes */

#define MUIA_Rectangle_HBar             0x8042c943 /* i.g BOOL              */
#define MUIA_Rectangle_VBar             0x80422204 /* i.g BOOL              */



/****************************************************************************/
/** Image.mui 7.13 (28.11.93)                                              **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Image[];
#else
#define MUIC_Image "Image.mui"
#endif

/* Attributes */

#define MUIA_Image_FontMatch            0x8042815d /* i.. BOOL              */
#define MUIA_Image_FontMatchHeight      0x80429f26 /* i.. BOOL              */
#define MUIA_Image_FontMatchWidth       0x804239bf /* i.. BOOL              */
#define MUIA_Image_FreeHoriz            0x8042da84 /* i.. BOOL              */
#define MUIA_Image_FreeVert             0x8042ea28 /* i.. BOOL              */
#define MUIA_Image_OldImage             0x80424f3d /* i.. struct Image *    */
#define MUIA_Image_Spec                 0x804233d5 /* i.. char *            */
#define MUIA_Image_State                0x8042a3ad /* is. LONG              */



/****************************************************************************/
/** Text.mui 7.15 (28.11.93)                                               **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Text[];
#else
#define MUIC_Text "Text.mui"
#endif

/* Attributes */

#define MUIA_Text_Contents              0x8042f8dc /* isg STRPTR            */
#define MUIA_Text_HiChar                0x804218ff /* i.. char              */
#define MUIA_Text_PreParse              0x8042566d /* isg STRPTR            */
#define MUIA_Text_SetMax                0x80424d0a /* i.. BOOL              */
#define MUIA_Text_SetMin                0x80424e10 /* i.. BOOL              */



/****************************************************************************/
/** String.mui 7.13 (28.11.93)                                             **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_String[];
#else
#define MUIC_String "String.mui"
#endif

/* Attributes */

#define MUIA_String_Accept              0x8042e3e1 /* isg STRPTR            */
#define MUIA_String_Acknowledge         0x8042026c /* ..g STRPTR            */
#define MUIA_String_AttachedList        0x80420fd2 /* i.. Object *          */
#define MUIA_String_BufferPos           0x80428b6c /* .sg LONG              */
#define MUIA_String_Contents            0x80428ffd /* isg STRPTR            */
#define MUIA_String_DisplayPos          0x8042ccbf /* .sg LONG              */
#define MUIA_String_EditHook            0x80424c33 /* isg struct Hook *     */
#define MUIA_String_Format              0x80427484 /* i.g LONG              */
#define MUIA_String_Integer             0x80426e8a /* isg ULONG             */
#define MUIA_String_MaxLen              0x80424984 /* i.. LONG              */
#define MUIA_String_Reject              0x8042179c /* isg STRPTR            */
#define MUIA_String_Secret              0x80428769 /* i.g BOOL              */

#define MUIV_String_Format_Left 0
#define MUIV_String_Format_Center 1
#define MUIV_String_Format_Right 2


/****************************************************************************/
/** Prop.mui 7.12 (28.11.93)                                               **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Prop[];
#else
#define MUIC_Prop "Prop.mui"
#endif

/* Attributes */

#define MUIA_Prop_Entries               0x8042fbdb /* isg LONG              */
#define MUIA_Prop_First                 0x8042d4b2 /* isg LONG              */
#define MUIA_Prop_Horiz                 0x8042f4f3 /* i.g BOOL              */
#define MUIA_Prop_Slider                0x80429c3a /* isg BOOL              */
#define MUIA_Prop_Visible               0x8042fea6 /* isg LONG              */



/****************************************************************************/
/** Gauge.mui 7.41 (10.02.94)                                              **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Gauge[];
#else
#define MUIC_Gauge "Gauge.mui"
#endif

/* Attributes */

#define MUIA_Gauge_Current              0x8042f0dd /* isg LONG              */
#define MUIA_Gauge_Divide               0x8042d8df /* isg BOOL              */
#define MUIA_Gauge_Horiz                0x804232dd /* i.. BOOL              */
#define MUIA_Gauge_InfoText             0x8042bf15 /* isg char *            */
#define MUIA_Gauge_Max                  0x8042bcdb /* isg LONG              */



/****************************************************************************/
/** Scale.mui 7.37 (10.02.94)                                              **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Scale[];
#else
#define MUIC_Scale "Scale.mui"
#endif

/* Attributes */

#define MUIA_Scale_Horiz                0x8042919a /* isg BOOL              */



/****************************************************************************/
/** Boopsi.mui 7.36 (10.02.94)                                             **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Boopsi[];
#else
#define MUIC_Boopsi "Boopsi.mui"
#endif

/* Attributes */

#define MUIA_Boopsi_Class               0x80426999 /* isg struct IClass *   */
#define MUIA_Boopsi_ClassID             0x8042bfa3 /* isg char *            */
#define MUIA_Boopsi_MaxHeight           0x8042757f /* isg ULONG             */
#define MUIA_Boopsi_MaxWidth            0x8042bcb1 /* isg ULONG             */
#define MUIA_Boopsi_MinHeight           0x80422c93 /* isg ULONG             */
#define MUIA_Boopsi_MinWidth            0x80428fb2 /* isg ULONG             */
#define MUIA_Boopsi_Object              0x80420178 /* ..g Object *          */
#define MUIA_Boopsi_Remember            0x8042f4bd /* i.. ULONG             */
#define MUIA_Boopsi_TagDrawInfo         0x8042bae7 /* isg ULONG             */
#define MUIA_Boopsi_TagScreen           0x8042bc71 /* isg ULONG             */
#define MUIA_Boopsi_TagWindow           0x8042e11d /* isg ULONG             */



/****************************************************************************/
/** Colorfield.mui 7.38 (10.02.94)                                         **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Colorfield[];
#else
#define MUIC_Colorfield "Colorfield.mui"
#endif

/* Attributes */

#define MUIA_Colorfield_Blue            0x8042d3b0 /* isg ULONG             */
#define MUIA_Colorfield_Green           0x80424466 /* isg ULONG             */
#define MUIA_Colorfield_Pen             0x8042713a /* ..g ULONG             */
#define MUIA_Colorfield_Red             0x804279f6 /* isg ULONG             */
#define MUIA_Colorfield_RGB             0x8042677a /* isg ULONG *           */



/****************************************************************************/
/** List.mui 7.22 (28.11.93)                                               **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_List[];
#else
#define MUIC_List "List.mui"
#endif

/* Methods */

#define MUIM_List_Clear                0x8042ad89
#define MUIM_List_Exchange             0x8042468c
#define MUIM_List_GetEntry             0x804280ec
#define MUIM_List_Insert               0x80426c87
#define MUIM_List_InsertSingle         0x804254d5
#define MUIM_List_Jump                 0x8042baab
#define MUIM_List_NextSelected         0x80425f17
#define MUIM_List_Redraw               0x80427993
#define MUIM_List_Remove               0x8042647e
#define MUIM_List_Select               0x804252d8
#define MUIM_List_Sort                 0x80422275
struct  MUIP_List_Exchange             { ULONG id; LONG pos1; LONG pos2; };
struct  MUIP_List_GetEntry             { ULONG id; LONG pos; APTR *entry; };
struct  MUIP_List_Insert               { ULONG id; APTR *entries; LONG count; LONG pos; };
struct  MUIP_List_InsertSingle         { ULONG id; APTR entry; LONG pos; };
struct  MUIP_List_Jump                 { ULONG id; LONG pos; };
struct  MUIP_List_NextSelected         { ULONG id; LONG *pos; };
struct  MUIP_List_Redraw               { ULONG id; LONG pos; };
struct  MUIP_List_Remove               { ULONG id; LONG pos; };
struct  MUIP_List_Select               { ULONG id; LONG pos; LONG seltype; LONG *state; };

/* Attributes */

#define MUIA_List_Active                0x8042391c /* isg LONG              */
#define MUIA_List_AdjustHeight          0x8042850d /* i.. BOOL              */
#define MUIA_List_AdjustWidth           0x8042354a /* i.. BOOL              */
#define MUIA_List_CompareHook           0x80425c14 /* is. struct Hook *     */
#define MUIA_List_ConstructHook         0x8042894f /* is. struct Hook *     */
#define MUIA_List_DestructHook          0x804297ce /* is. struct Hook *     */
#define MUIA_List_DisplayHook           0x8042b4d5 /* is. struct Hook *     */
#define MUIA_List_Entries               0x80421654 /* ..g LONG              */
#define MUIA_List_First                 0x804238d4 /* ..g LONG              */
#define MUIA_List_Format                0x80423c0a /* isg STRPTR            */
#define MUIA_List_MultiTestHook         0x8042c2c6 /* is. struct Hook *     */
#define MUIA_List_Quiet                 0x8042d8c7 /* .s. BOOL              */
#define MUIA_List_SourceArray           0x8042c0a0 /* i.. APTR              */
#define MUIA_List_Title                 0x80423e66 /* isg char *            */
#define MUIA_List_Visible               0x8042191f /* ..g LONG              */

#define MUIV_List_Active_Off -1
#define MUIV_List_Active_Top -2
#define MUIV_List_Active_Bottom -3
#define MUIV_List_Active_Up -4
#define MUIV_List_Active_Down -5
#define MUIV_List_Active_PageUp -6
#define MUIV_List_Active_PageDown -7
#define MUIV_List_ConstructHook_String -1
#define MUIV_List_CopyHook_String -1
#define MUIV_List_CursorType_None 0
#define MUIV_List_CursorType_Bar 1
#define MUIV_List_CursorType_Rect 2
#define MUIV_List_DestructHook_String -1


/****************************************************************************/
/** Floattext.mui 7.39 (10.02.94)                                          **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Floattext[];
#else
#define MUIC_Floattext "Floattext.mui"
#endif

/* Attributes */

#define MUIA_Floattext_Justify          0x8042dc03 /* isg BOOL              */
#define MUIA_Floattext_SkipChars        0x80425c7d /* is. STRPTR            */
#define MUIA_Floattext_TabSize          0x80427d17 /* is. LONG              */
#define MUIA_Floattext_Text             0x8042d16a /* isg STRPTR            */



/****************************************************************************/
/** Volumelist.mui 7.36 (10.02.94)                                         **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Volumelist[];
#else
#define MUIC_Volumelist "Volumelist.mui"
#endif


/****************************************************************************/
/** Scrmodelist.mui 7.44 (10.02.94)                                        **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Scrmodelist[];
#else
#define MUIC_Scrmodelist "Scrmodelist.mui"
#endif

/* Attributes */




/****************************************************************************/
/** Dirlist.mui 7.37 (10.02.94)                                            **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Dirlist[];
#else
#define MUIC_Dirlist "Dirlist.mui"
#endif

/* Methods */

#define MUIM_Dirlist_ReRead            0x80422d71

/* Attributes */

#define MUIA_Dirlist_AcceptPattern      0x8042760a /* is. STRPTR            */
#define MUIA_Dirlist_Directory          0x8042ea41 /* is. STRPTR            */
#define MUIA_Dirlist_DrawersOnly        0x8042b379 /* is. BOOL              */
#define MUIA_Dirlist_FilesOnly          0x8042896a /* is. BOOL              */
#define MUIA_Dirlist_FilterDrawers      0x80424ad2 /* is. BOOL              */
#define MUIA_Dirlist_FilterHook         0x8042ae19 /* is. struct Hook *     */
#define MUIA_Dirlist_MultiSelDirs       0x80428653 /* is. BOOL              */
#define MUIA_Dirlist_NumBytes           0x80429e26 /* ..g LONG              */
#define MUIA_Dirlist_NumDrawers         0x80429cb8 /* ..g LONG              */
#define MUIA_Dirlist_NumFiles           0x8042a6f0 /* ..g LONG              */
#define MUIA_Dirlist_Path               0x80426176 /* ..g STRPTR            */
#define MUIA_Dirlist_RejectIcons        0x80424808 /* is. BOOL              */
#define MUIA_Dirlist_RejectPattern      0x804259c7 /* is. STRPTR            */
#define MUIA_Dirlist_SortDirs           0x8042bbb9 /* is. LONG              */
#define MUIA_Dirlist_SortHighLow        0x80421896 /* is. BOOL              */
#define MUIA_Dirlist_SortType           0x804228bc /* is. LONG              */
#define MUIA_Dirlist_Status             0x804240de /* ..g LONG              */

#define MUIV_Dirlist_SortDirs_First 0
#define MUIV_Dirlist_SortDirs_Last 1
#define MUIV_Dirlist_SortDirs_Mix 2
#define MUIV_Dirlist_SortType_Name 0
#define MUIV_Dirlist_SortType_Date 1
#define MUIV_Dirlist_SortType_Size 2
#define MUIV_Dirlist_Status_Invalid 0
#define MUIV_Dirlist_Status_Reading 1
#define MUIV_Dirlist_Status_Valid 2


/****************************************************************************/
/** Group.mui 7.12 (28.11.93)                                              **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Group[];
#else
#define MUIC_Group "Group.mui"
#endif

/* Methods */


/* Attributes */

#define MUIA_Group_ActivePage           0x80424199 /* isg LONG              */
#define MUIA_Group_Child                0x804226e6 /* i.. Object *          */
#define MUIA_Group_Columns              0x8042f416 /* is. LONG              */
#define MUIA_Group_Horiz                0x8042536b /* i.. BOOL              */
#define MUIA_Group_HorizSpacing         0x8042c651 /* is. LONG              */
#define MUIA_Group_PageMode             0x80421a5f /* is. BOOL              */
#define MUIA_Group_Rows                 0x8042b68f /* is. LONG              */
#define MUIA_Group_SameHeight           0x8042037e /* i.. BOOL              */
#define MUIA_Group_SameSize             0x80420860 /* i.. BOOL              */
#define MUIA_Group_SameWidth            0x8042b3ec /* i.. BOOL              */
#define MUIA_Group_Spacing              0x8042866d /* is. LONG              */
#define MUIA_Group_VertSpacing          0x8042e1bf /* is. LONG              */



/****************************************************************************/
/** Group.mui 7.12 (28.11.93)                                              **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Register[];
#else
#define MUIC_Register "Register.mui"
#endif

/* Attributes */

#define MUIA_Register_Frame             0x8042349b /* i.g BOOL              */
#define MUIA_Register_Titles            0x804297ec /* i.g STRPTR *          */



/****************************************************************************/
/** Virtgroup.mui 7.36 (10.02.94)                                          **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Virtgroup[];
#else
#define MUIC_Virtgroup "Virtgroup.mui"
#endif

/* Methods */


/* Attributes */

#define MUIA_Virtgroup_Height           0x80423038 /* ..g LONG              */
#define MUIA_Virtgroup_Left             0x80429371 /* isg LONG              */
#define MUIA_Virtgroup_Top              0x80425200 /* isg LONG              */
#define MUIA_Virtgroup_Width            0x80427c49 /* ..g LONG              */



/****************************************************************************/
/** Scrollgroup.mui 7.34 (10.02.94)                                        **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Scrollgroup[];
#else
#define MUIC_Scrollgroup "Scrollgroup.mui"
#endif

/* Attributes */

#define MUIA_Scrollgroup_Contents       0x80421261 /* i.. Object *          */



/****************************************************************************/
/** Scrollbar.mui 7.12 (28.11.93)                                          **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Scrollbar[];
#else
#define MUIC_Scrollbar "Scrollbar.mui"
#endif


/****************************************************************************/
/** Listview.mui 7.13 (28.11.93)                                           **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Listview[];
#else
#define MUIC_Listview "Listview.mui"
#endif

/* Attributes */

#define MUIA_Listview_ClickColumn       0x8042d1b3 /* ..g LONG              */
#define MUIA_Listview_DefClickColumn    0x8042b296 /* isg LONG              */
#define MUIA_Listview_DoubleClick       0x80424635 /* i.g BOOL              */
#define MUIA_Listview_Input             0x8042682d /* i.. BOOL              */
#define MUIA_Listview_List              0x8042bcce /* i.. Object *          */
#define MUIA_Listview_MultiSelect       0x80427e08 /* i.. LONG              */
#define MUIA_Listview_SelectChange      0x8042178f /* ..g BOOL              */

#define MUIV_Listview_MultiSelect_None 0
#define MUIV_Listview_MultiSelect_Default 1
#define MUIV_Listview_MultiSelect_Shifted 2
#define MUIV_Listview_MultiSelect_Always 3


/****************************************************************************/
/** Radio.mui 7.12 (28.11.93)                                              **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Radio[];
#else
#define MUIC_Radio "Radio.mui"
#endif

/* Attributes */

#define MUIA_Radio_Active               0x80429b41 /* isg LONG              */
#define MUIA_Radio_Entries              0x8042b6a1 /* i.. STRPTR *          */



/****************************************************************************/
/** Cycle.mui 7.16 (28.11.93)                                              **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Cycle[];
#else
#define MUIC_Cycle "Cycle.mui"
#endif

/* Attributes */

#define MUIA_Cycle_Active               0x80421788 /* isg LONG              */
#define MUIA_Cycle_Entries              0x80420629 /* i.. STRPTR *          */

#define MUIV_Cycle_Active_Next -1
#define MUIV_Cycle_Active_Prev -2


/****************************************************************************/
/** Slider.mui 7.12 (28.11.93)                                             **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Slider[];
#else
#define MUIC_Slider "Slider.mui"
#endif

/* Attributes */

#define MUIA_Slider_Level               0x8042ae3a /* isg LONG              */
#define MUIA_Slider_Max                 0x8042d78a /* i.. LONG              */
#define MUIA_Slider_Min                 0x8042e404 /* i.. LONG              */
#define MUIA_Slider_Quiet               0x80420b26 /* i.. BOOL              */
#define MUIA_Slider_Reverse             0x8042f2a0 /* isg BOOL              */



/****************************************************************************/
/** Coloradjust.mui 7.46 (10.02.94)                                        **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Coloradjust[];
#else
#define MUIC_Coloradjust "Coloradjust.mui"
#endif

/* Attributes */

#define MUIA_Coloradjust_Blue           0x8042b8a3 /* isg ULONG             */
#define MUIA_Coloradjust_Green          0x804285ab /* isg ULONG             */
#define MUIA_Coloradjust_ModeID         0x8042ec59 /* isg ULONG             */
#define MUIA_Coloradjust_Red            0x80420eaa /* isg ULONG             */
#define MUIA_Coloradjust_RGB            0x8042f899 /* isg ULONG *           */



/****************************************************************************/
/** Palette.mui 7.35 (10.02.94)                                            **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Palette[];
#else
#define MUIC_Palette "Palette.mui"
#endif

/* Attributes */

#define MUIA_Palette_Entries            0x8042a3d8 /* i.g struct MUI_Palette_Entry * */
#define MUIA_Palette_Groupable          0x80423e67 /* isg BOOL              */
#define MUIA_Palette_Names              0x8042c3a2 /* isg char **           */



/****************************************************************************/
/** Colorpanel.mui 7.11 (10.02.94)                                         **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Colorpanel[];
#else
#define MUIC_Colorpanel "Colorpanel.mui"
#endif

/* Methods */


/* Attributes */




/****************************************************************************/
/** Popstring.mui 7.19 (02.12.93)                                          **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Popstring[];
#else
#define MUIC_Popstring "Popstring.mui"
#endif

/* Methods */

#define MUIM_Popstring_Close           0x8042dc52
#define MUIM_Popstring_Open            0x804258ba
struct  MUIP_Popstring_Close           { ULONG id; LONG result; };

/* Attributes */

#define MUIA_Popstring_Button           0x8042d0b9 /* i.g Object *          */
#define MUIA_Popstring_CloseHook        0x804256bf /* isg struct Hook *     */
#define MUIA_Popstring_OpenHook         0x80429d00 /* isg struct Hook *     */
#define MUIA_Popstring_String           0x804239ea /* i.g Object *          */
#define MUIA_Popstring_Toggle           0x80422b7a /* isg BOOL              */



/****************************************************************************/
/** Popobject.mui 7.18 (02.12.93)                                          **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Popobject[];
#else
#define MUIC_Popobject "Popobject.mui"
#endif

/* Attributes */

#define MUIA_Popobject_Follow           0x80424cb5 /* isg BOOL              */
#define MUIA_Popobject_Light            0x8042a5a3 /* isg BOOL              */
#define MUIA_Popobject_Object           0x804293e3 /* i.g Object *          */
#define MUIA_Popobject_ObjStrHook       0x8042db44 /* isg struct Hook *     */
#define MUIA_Popobject_StrObjHook       0x8042fbe1 /* isg struct Hook *     */
#define MUIA_Popobject_Volatile         0x804252ec /* isg BOOL              */



/****************************************************************************/
/** Popasl.mui 7.5 (03.12.93)                                              **/
/****************************************************************************/

#ifdef _DCC
extern char MUIC_Popasl[];
#else
#define MUIC_Popasl "Popasl.mui"
#endif

/* Attributes */

#define MUIA_Popasl_Active              0x80421b37 /* ..g BOOL              */
#define MUIA_Popasl_StartHook           0x8042b703 /* isg struct Hook *     */
#define MUIA_Popasl_StopHook            0x8042d8d2 /* isg struct Hook *     */
#define MUIA_Popasl_Type                0x8042df3d /* i.g ULONG             */






/*************************************************************************
** Structures and Macros for creating custom classes.
*************************************************************************/


/*
** GENERAL NOTES:
**
** - Everything described in this header file is only valid within
**   MUI classes. You may never use any of these things out of
**   a class, e.g. in a traditional MUI application.
**
** - Except when otherwise stated, all structures are strictly read only.
*/


/* Global information for every object */

struct MUI_GlobalInfo
{
	ULONG priv0;
	Object                   *mgi_ApplicationObject;

	/* ... private data follows ... */
};


/* Instance data of notify class */

struct MUI_NotifyData
{
	struct MUI_GlobalInfo *mnd_GlobalInfo;
	ULONG                  mnd_UserData;
	ULONG priv1;
	ULONG priv2;
	ULONG priv3;
	ULONG priv4;
	ULONG priv5;
};


/* MUI_MinMax structure holds information about minimum, maximum
   and default dimensions of an object. */

struct MUI_MinMax
{
	WORD MinWidth;
	WORD MinHeight;
	WORD MaxWidth;
	WORD MaxHeight;
	WORD DefWidth;
	WORD DefHeight;
};

#define MUI_MAXMAX 10000 /* use this if a dimension is not limited. */


/* (partial) instance data of area class */

struct MUI_AreaData
{
	struct MUI_RenderInfo *mad_RenderInfo;  /* RenderInfo for this object */
	ULONG priv6;
	struct TextFont       *mad_Font;        /* Font */
	struct MUI_MinMax      mad_MinMax;      /* min/max/default sizes */
	struct IBox            mad_Box;         /* position and dimension */
	BYTE                   mad_addleft;     /* frame & innerspacing left offset */
	BYTE                   mad_addtop;      /* frame & innerspacing top offset  */
	BYTE                   mad_subwidth;    /* frame & innerspacing add. width  */
	BYTE                   mad_subheight;   /* frame & innerspacing add. height */
	ULONG                  mad_Flags;       /* see definitions below */

	/* ... private data follows ... */
};

/* Definitions for mad_Flags, other flags are private */

#define MADF_DRAWOBJECT        (1<< 0) /* completely redraw yourself */
#define MADF_DRAWUPDATE        (1<< 1) /* only update yourself */




/* MUI's draw pens */

#define MPEN_SHINE      0
#define MPEN_HALFSHINE  1
#define MPEN_BACKGROUND 2
#define MPEN_HALFSHADOW 3
#define MPEN_SHADOW     4
#define MPEN_TEXT       5
#define MPEN_FILL       6
#define MPEN_ACTIVEOBJ  7
#define MPEN_COUNT      8


/* Information on display environment */

struct MUI_RenderInfo
{
	Object          *mri_WindowObject;  /* valid between MUIM_Setup/MUIM_Cleanup */

	struct Screen   *mri_Screen;        /* valid between MUIM_Setup/MUIM_Cleanup */
	struct DrawInfo *mri_DrawInfo;      /* valid between MUIM_Setup/MUIM_Cleanup */
	UWORD           *mri_Pens;          /* valid between MUIM_Setup/MUIM_Cleanup */
	struct Window   *mri_Window;        /* valid between MUIM_Show/MUIM_Hide */
	struct RastPort *mri_RastPort;      /* valid between MUIM_Show/MUIM_Hide */

	/* ... private data follows ... */
};



/* the following macros can be used to get pointers to an objects
   GlobalInfo and RenderInfo structures. */

struct __dummyXFC2__
{
	struct MUI_NotifyData mnd;
	struct MUI_AreaData   mad;
};

#define muiNotifyData(obj) (&(((struct __dummyXFC2__ *)(obj))->mnd))
#define muiAreaData(obj)   (&(((struct __dummyXFC2__ *)(obj))->mad))

#define muiGlobalInfo(obj) (((struct __dummyXFC2__ *)(obj))->mnd.mnd_GlobalInfo)
#define muiRenderInfo(obj) (((struct __dummyXFC2__ *)(obj))->mad.mad_RenderInfo)



/* User configurable keyboard events coming with MUIM_HandleInput */

enum
{
	MUIKEY_RELEASE = -2, /* not a real key, faked when MUIKEY_PRESS is released */
	MUIKEY_NONE    = -1,
	MUIKEY_PRESS,
	MUIKEY_TOGGLE,
	MUIKEY_UP,
	MUIKEY_DOWN,
	MUIKEY_PAGEUP,
	MUIKEY_PAGEDOWN,
	MUIKEY_TOP,
	MUIKEY_BOTTOM,
	MUIKEY_LEFT,
	MUIKEY_RIGHT,
	MUIKEY_WORDLEFT,
	MUIKEY_WORDRIGHT,
	MUIKEY_LINESTART,
	MUIKEY_LINEEND,
	MUIKEY_GADGET_NEXT,
	MUIKEY_GADGET_PREV,
	MUIKEY_GADGET_OFF,
	MUIKEY_WINDOW_CLOSE,
	MUIKEY_WINDOW_NEXT,
	MUIKEY_WINDOW_PREV,
	MUIKEY_HELP,
};


/* Some useful shortcuts. define MUI_NOSHORTCUTS to get rid of them */

#ifndef MUI_NOSHORTCUTS

#define _app(obj)         (muiGlobalInfo(obj)->mgi_ApplicationObject)
#define _win(obj)         (muiRenderInfo(obj)->mri_WindowObject)
#define _dri(obj)         (muiRenderInfo(obj)->mri_DrawInfo)
#define _window(obj)      (muiRenderInfo(obj)->mri_Window)
#define _screen(obj)      (muiRenderInfo(obj)->mri_Screen)
#define _rp(obj)          (muiRenderInfo(obj)->mri_RastPort)
#define _left(obj)        (muiAreaData(obj)->mad_Box.Left)
#define _top(obj)         (muiAreaData(obj)->mad_Box.Top)
#define _width(obj)       (muiAreaData(obj)->mad_Box.Width)
#define _height(obj)      (muiAreaData(obj)->mad_Box.Height)
#define _right(obj)       (_left(obj)+_width(obj)-1)
#define _bottom(obj)      (_top(obj)+_height(obj)-1)
#define _addleft(obj)     (muiAreaData(obj)->mad_addleft  )
#define _addtop(obj)      (muiAreaData(obj)->mad_addtop   )
#define _subwidth(obj)    (muiAreaData(obj)->mad_subwidth )
#define _subheight(obj)   (muiAreaData(obj)->mad_subheight)
#define _mleft(obj)       (_left(obj)+_addleft(obj))
#define _mtop(obj)        (_top(obj)+_addtop(obj))
#define _mwidth(obj)      (_width(obj)-_subwidth(obj))
#define _mheight(obj)     (_height(obj)-_subheight(obj))
#define _mright(obj)      (_mleft(obj)+_mwidth(obj)-1)
#define _mbottom(obj)     (_mtop(obj)+_mheight(obj)-1)
#define _font(obj)        (muiAreaData(obj)->mad_Font)
#define _flags(obj)       (muiAreaData(obj)->mad_Flags)

#endif


#endif /* MUI_H */
