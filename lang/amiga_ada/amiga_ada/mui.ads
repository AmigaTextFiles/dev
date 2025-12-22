with Interfaces; use Interfaces;
with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with intuition_Intuition; use intuition_Intuition; 
with intuition_classusr; use intuition_classusr;
with intuition_classes; use intuition_classes;
with graphics_rastport; use graphics_rastport;
with utility_tagitem; use utility_tagitem; 
with utility_hooks; use utility_hooks; 

with incomplete_type; use incomplete_type; 
--/***************************************************************************
--**
--** MUI - MagicUserInterface
--** (c) 1993 by Stefan Stuntz
--**
--** Main Header File
--**
--****************************************************************************
--** Class Tree
--****************************************************************************
--**
--** rootclass               (BOOPSI's base class)
--** +--Notify               (implements notification mechanism)
--**    +--Family            (handles multiple children)
--**    !  +--Menustrip      (describes a complete menu strip)
--**    !  +--Menu           (describes a single menu)
--**    !  \--Menuitem       (describes a single menu item)
--**    +--Application       (main class for all applications)
--**    +--Window            (handles intuition window related topics)
--**    +--Area              (base class for all GUI elements)
--**       +--Rectangle      (creates (empty) rectangles)
--**       +--Image          (creates images)
--**       +--Text           (creates some text)
--**       +--String         (creates a string gadget)
--**       +--Prop           (creates a proportional gadget)
--**       +--Gauge          (creates a fule gauge)
--**       +--Scale          (creates a percentage scale)
--**       +--Boopsi         (interface to BOOPSI gadgets)
--**       +--Colorfield     (creates a field with changeable color)
--**       +--List           (creates a line-oriented list)
--**       !  +--Floattext   (special list with floating text)
--**       !  +--Volumelist  (special list with volumes)
--**       !  +--Scrmodelist (special list with screen modes)
--**       !  \--Dirlist     (special list with files)
--**       +--Group          (groups other GUI elements)
--**          +--Register    (handles page groups with titles)
--**          +--Virtgroup   (handles virtual groups)
--**          +--Scrollgroup (handles virtual groups with scrollers)
--**          +--Scrollbar   (creates a scrollbar)
--**          +--Listview    (creates a listview)
--**          +--Radio       (creates radio buttons)
--**          +--Cycle       (creates cycle gadgets)
--**          +--Slider      (creates slider gadgets)
--**          +--Coloradjust (creates some RGB sliders)
--**          +--Palette     (creates a complete palette gadget)
--**          +--Colorpanel  (creates a panel of colors)
--**          +--Popstring   (base class for popups)
--**             +--Popobject(popup a MUI object in a window)
--**             \--Popasl   (popup an asl requester)
--**
--****************************************************************************
--** General Header File Information
--****************************************************************************
--**
--** All macro and structure definitions follow these rules:
--**
--** Name                       Meaning
--**
--** MUIC_<class>               Name of a class
--** MUIM_<class>_<method>      Method
--** MUIP_<class>_<method>      Methods parameter structure
--** MUIV_<class>_<method>_<x>  Special method value
--** MUIA_<class>_<attrib>      Attribute
--** MUIV_<class>_<attrib>_<x>  Special attribute value
--** MUIE_<error>               Error return code from MUI_Error()
--** MUII_<name>                Standard MUI image
--** MUIX_<code>                Control codes for text strings
--** MUIO_<name>                Object type for MUI_MakeObject()
--**
--** MUIA_... attribute definitions are followed by a comment
--** consisting of the three possible letters I, S and G.
--** I: it's possible to specify this attribute at object creation time.
--** S: it's possible to change this attribute with SetAttrs().
--** G: it's possible to get this attribute with GetAttr().
--**
--** Items marked with "Custom Class" are for use in custom classes only!
--*/
--
--
--#ifndef LIBRARIES_MUI_H
--#define LIBRARIES_MUI_H
--
--#ifndef EXEC_TYPES_H
--#include "exec/types.h"
--#endif
--
--#ifndef INTUITION_CLASSES_H
--#include "intuition/classes.h"
--#endif
--
--#ifndef INTUITION_SCREENS_H
--#include "intuition/screens.h"
--#endif
--
--#ifndef CLIB_INTUITION_PROTOS_H
--#include "clib/intuition_protos.h"
--#endif
--
--
--/***************************************************************************
--** Library specification
--***************************************************************************/
--

package mui is

MUIMASTER_NAME : constant Chars_Ptr := Allocate_String("muimaster.library");
MUIMASTER_VMIN : constant Integer := 8;

MUIC_Notify : constant Chars_Ptr := Allocate_String("Notify.mui");
MUIC_Family : constant Chars_Ptr:= Allocate_String("Family.mui");
MUIC_Menustrip : constant Chars_Ptr:= Allocate_String("Menustrip.mui");
MUIC_Menu : constant Chars_Ptr:= Allocate_String("Menu.mui");
MUIC_Menuitem : constant Chars_Ptr:= Allocate_String("Menuitem.mui");
MUIC_Application : constant Chars_Ptr:= Allocate_String("Application.mui");
MUIC_Window : constant Chars_Ptr:= Allocate_String("Window.mui");
MUIC_Area : constant Chars_Ptr:= Allocate_String("Area.mui");
MUIC_Rectangle : constant Chars_Ptr:= Allocate_String("Rectangle.mui");
MUIC_Image : constant Chars_Ptr:= Allocate_String("Image.mui");
MUIC_Bitmap : constant Chars_Ptr:= Allocate_String("Bitmap.mui");
MUIC_Bodychunk : constant Chars_Ptr:= Allocate_String("Bodychunk.mui");
MUIC_Text : constant Chars_Ptr:= Allocate_String("Text.mui");
MUIC_String : constant Chars_Ptr:= Allocate_String("String.mui");
MUIC_Prop : constant Chars_Ptr:= Allocate_String("Prop.mui");
MUIC_Gauge : constant Chars_Ptr:= Allocate_String("Gauge.mui");
MUIC_Scale : constant Chars_Ptr:= Allocate_String("Scale.mui");
MUIC_Boopsi : constant Chars_Ptr:= Allocate_String("Boopsi.mui");
MUIC_Colorfield : constant Chars_Ptr:= Allocate_String("Colorfield.mui");
MUIC_List : constant Chars_Ptr:= Allocate_String("List.mui");
MUIC_Floattext : constant Chars_Ptr:= Allocate_String("Floattext.mui");
MUIC_Volumelist : constant Chars_Ptr:= Allocate_String("Volumelist.mui");
MUIC_Scrmodelist : constant Chars_Ptr:= Allocate_String("Scrmodelist.mui");
MUIC_Dirlist : constant Chars_Ptr:= Allocate_String("Dirlist.mui");
MUIC_Group : constant Chars_Ptr:= Allocate_String("Group.mui");
MUIC_Register : constant Chars_Ptr:= Allocate_String("Register.mui");
MUIC_Virtgroup : constant Chars_Ptr:= Allocate_String("Virtgroup.mui");
MUIC_Scrollgroup : constant Chars_Ptr:= Allocate_String("Scrollgroup.mui");
MUIC_Scrollbar : constant Chars_Ptr:= Allocate_String("Scrollbar.mui");
MUIC_Listview : constant Chars_Ptr:= Allocate_String("Listview.mui");
MUIC_Radio : constant Chars_Ptr:= Allocate_String("Radio.mui");
MUIC_Cycle : constant Chars_Ptr:= Allocate_String("Cycle.mui");
MUIC_Slider : constant Chars_Ptr:= Allocate_String("Slider.mui");
MUIC_Coloradjust : constant Chars_Ptr:= Allocate_String("Coloradjust.mui");
MUIC_Palette : constant Chars_Ptr:= Allocate_String("Palette.mui");
MUIC_Colorpanel : constant Chars_Ptr:= Allocate_String("Colorpanel.mui");
MUIC_Popstring : constant Chars_Ptr:= Allocate_String("Popstring.mui");
MUIC_Popobject : constant Chars_Ptr:= Allocate_String("Popobject.mui");
MUIC_Poplist : constant Chars_Ptr:= Allocate_String("Poplist.mui");
MUIC_Popasl : constant Chars_Ptr:= Allocate_String("Popasl.mui");

--
--
--/***************************************************************************
--** Object Types for MUI_MakeObject()
--***************************************************************************/

type MUI_MinMax;
type MUI_MinMax_Ptr is access MUI_MinMax;

type MUI_RenderInfo;
type MUI_RenderInfo_Ptr is access MUI_RenderInfo;



MUIO_Label : constant Unsigned_32 := 1;
MUIO_Button : constant Unsigned_32 := 2;
MUIO_Checkmark : constant Unsigned_32 := 3;
MUIO_Cycle : constant Unsigned_32 := 4;
MUIO_Radio : constant Unsigned_32 := 5;
MUIO_Slider : constant Unsigned_32 := 6;
MUIO_String : constant Unsigned_32 := 7;
MUIO_PopButton : constant Unsigned_32 := 8;
MUIO_HSpace : constant Unsigned_32 := 9;
MUIO_VSpace : constant Unsigned_32 := 10;
MUIO_HBar : constant Unsigned_32 := 11;
MUIO_VBar : constant Unsigned_32 := 12;
MUIO_MenustripNM : constant Unsigned_32 := 13;
MUIO_Menuitem : constant Unsigned_32 := 14;
MUIO_BarTitle : constant Unsigned_32 := 15;
MUIO_Label_SingleFrame : constant Unsigned_32 := (2** 8);
MUIO_Label_DoubleFrame : constant Unsigned_32 := (2** 9);
MUIO_Label_LeftAligned : constant Unsigned_32 := (2**10);
MUIO_Label_Centered : constant Unsigned_32 := (2**11);

type MUI_Command;
type MUI_CommandPtr is access MUI_Command;
type MUI_Command is record
mc_Name : Chars_Ptr;
mc_Template : Chars_Ptr;
mc_Parameters : Integer;
mc_Hook : Hook_Ptr;
mc_Reserved : Integer_Array(0..4);
end record;

MC_TEMPLATE_ID : constant Integer := -1; -- ???? was ((STRPTR)~0);
MUI_RXERR_BADDEFINITION : constant Integer := -1;
MUI_RXERR_OUTOFMEMORY : constant Integer := -2;
MUI_RXERR_UNKNOWNCOMMAND : constant Integer := -3;
MUI_RXERR_BADSYNTAX : constant Integer := -4;
MUIE_OK : constant Integer := 0;
MUIE_OutOfMemory : constant Integer := 1;
MUIE_OutOfGfxMemory : constant Integer := 2;
MUIE_InvalidWindowObject : constant Integer := 3;
MUIE_MissingLibrary : constant Integer := 4;
MUIE_NoARexx : constant Integer := 5;
MUIE_SingleTask : constant Integer := 6;
MUII_WindowBack : constant Integer := 0;
MUII_RequesterBack : constant Integer := 1;
MUII_ButtonBack : constant Integer := 2;
MUII_ListBack : constant Integer := 3;
MUII_TextBack : constant Integer := 4;
MUII_PropBack : constant Integer := 5;
-- repeated at 27 MUII_PopupBack : constant Integer := 6;
MUII_SelectedBack : constant Integer := 7;
MUII_ListCursor : constant Integer := 8;
MUII_ListSelect : constant Integer := 9;
MUII_ListSelCur : constant Integer := 10;
MUII_ArrowUp : constant Integer := 11;
MUII_ArrowDown : constant Integer := 12;
MUII_ArrowLeft : constant Integer := 13;
MUII_ArrowRight : constant Integer := 14;
MUII_CheckMark : constant Integer := 15;
MUII_RadioButton : constant Integer := 16;
MUII_Cycle : constant Integer := 17;
MUII_PopUp : constant Integer := 18;
MUII_PopFile : constant Integer := 19;
MUII_PopDrawer : constant Integer := 20;
MUII_PropKnob : constant Integer := 21;
MUII_Drawer : constant Integer := 22;
MUII_HardDisk : constant Integer := 23;
MUII_Disk : constant Integer := 24;
MUII_Chip : constant Integer := 25;
MUII_Volume : constant Integer := 26;
MUII_PopUpBack : constant Integer := 27;
MUII_Network : constant Integer := 28;
MUII_Assign : constant Integer := 29;
MUII_TapePlay : constant Integer := 30;
MUII_TapePlayBack : constant Integer := 31;
MUII_TapePause : constant Integer := 32;
MUII_TapeStop : constant Integer := 33;
MUII_TapeRecord : constant Integer := 34;
MUII_GroupBack : constant Integer := 35;
MUII_SliderBack : constant Integer := 36;
MUII_SliderKnob : constant Integer := 37;
MUII_TapeUp : constant Integer := 38;
MUII_TapeDown : constant Integer := 39;
MUII_Count : constant Integer := 40;
MUII_BACKGROUND : constant Integer := 128;
MUII_SHADOW : constant Integer := 129;
MUII_SHINE : constant Integer := 130;
MUII_FILL : constant Integer := 131;
MUII_SHADOWBACK : constant Integer := 132;
MUII_SHADOWFILL : constant Integer := 133;
MUII_SHADOWSHINE : constant Integer := 134;
MUII_FILLBACK : constant Integer := 135;
MUII_FILLSHINE : constant Integer := 136;
MUII_SHINEBACK : constant Integer := 137;
MUII_FILLBACK2 : constant Integer := 138;
MUII_HSHINEBACK : constant Integer := 139;
MUII_HSHADOWBACK : constant Integer := 140;
MUII_HSHINESHINE : constant Integer := 141;
MUII_HSHADOWSHADOW : constant Integer := 142;
MUII_LASTPAT : constant Integer := 142;
--
--
--/***************************************************************************
--** Special values for some methods
--***************************************************************************/
--
MUIV_TriggerValue : constant Unsigned_32 := 16#49893131#;
MUIV_NotTriggerValue : constant Unsigned_32 := 16#49893133#;
MUIV_EveryTime : constant Unsigned_32 := 16#49893131#;
MUIV_Application_Save_ENV : constant Unsigned_32 := 0; ---???? was ((STRPTR) 0);
MUIV_Application_Save_ENVARC : constant Unsigned_32 := 16#ffffffff#; -- ???? was ((STRPTR)~0);
MUIV_Application_Load_ENV : constant Unsigned_32 := 0; -- ????was ((STRPTR) 0);
MUIV_Application_Load_ENVARC : constant Unsigned_32 := 16#ffffffff#; --???? was ((STRPTR)~0);
MUIV_Application_ReturnID_Quit : constant Unsigned_32 := 16#ffffffff#; --was -1;
MUIV_List_Insert_Top : constant Unsigned_32 := 0;
MUIV_List_Insert_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_Insert_Sorted : constant Unsigned_32 := 16#fffffffe#;
MUIV_List_Insert_Bottom : constant Unsigned_32 := 16#fffffffd#;
MUIV_List_Remove_First : constant Unsigned_32 := 0;
MUIV_List_Remove_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_Remove_Last : constant Unsigned_32 := 16#fffffffe#;
MUIV_List_Remove_Last_Selected : constant Unsigned_32 := 16#fffffffd#;
MUIV_List_Select_Off : constant Unsigned_32 := 0;
MUIV_List_Select_On : constant Unsigned_32 := 1;
MUIV_List_Select_Toggle : constant Unsigned_32 := 2;
MUIV_List_Select_Ask : constant Unsigned_32 := 3;
MUIV_List_GetEntry_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_Select_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_Select_All : constant Unsigned_32 := 16#fffffffe#;
MUIV_List_Redraw_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_Redraw_All : constant Unsigned_32 := 16#fffffffe#;
MUIV_List_Move_Top : constant Unsigned_32 := 0;
MUIV_List_Move_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_Move_Bottom : constant Unsigned_32 := 16#fffffffe#;
MUIV_List_Move_Next : constant Unsigned_32 := 16#fffffffd#;
MUIV_List_Move_Previous : constant Unsigned_32 := 16#fffffffc#;
MUIV_List_Exchange_Top : constant Unsigned_32 := 0;
MUIV_List_Exchange_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_Exchange_Bootom : constant Unsigned_32 := 16#fffffffe#;
MUIV_List_Exchange_Next : constant Unsigned_32 := 16#fffffffd#;
MUIV_List_Exchange_Previous : constant Unsigned_32 := 16#fffffffc#;
MUIV_List_Jump_Top : constant Unsigned_32 := 0;
MUIV_List_Jump_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_Jump_Bottom : constant Unsigned_32 := 16#fffffffe#;
MUIV_Colorpanel_GetColor_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_Colorpanel_SetColor_Active : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_NextSelected_Start : constant Unsigned_32 := 16#ffffffff#;
MUIV_List_NextSelected_End : constant Unsigned_32 := 16#ffffffff#;
--/***************************************************************************
--** Control codes for text strings
--***************************************************************************/
MUIX_R : constant Chars_Ptr:= Allocate_String(Character'VAL(8#033#) & "r");
MUIX_C : constant Chars_Ptr:= Allocate_String(Character'VAL(8#033#) & "c");
MUIX_L : constant Chars_Ptr:= Allocate_String(Character'VAL(8#033#) & "l");
MUIX_N : constant Chars_Ptr:= Allocate_String(Character'VAL(8#033#) & "n");
MUIX_B : constant Chars_Ptr:= Allocate_String(Character'VAL(8#033#) & "b");
MUIX_I : constant Chars_Ptr:= Allocate_String(Character'VAL(8#033#) & "i");
MUIX_U : constant Chars_Ptr:= Allocate_String(Character'VAL(8#033#) & "u");
MUIX_PT : constant Chars_Ptr:= Allocate_String(Character'VAL(8#033#) & "2");
MUIX_PH : constant Chars_Ptr:= Allocate_String(Character'VAL(8#033#) & "8");
--/***************************************************************************
--** Parameter structures for some classes
--***************************************************************************/

type MUI_Palette_Entry;
type MUI_Palette_EntryPtr is access MUI_Palette_Entry;
type MUI_Palette_Entry is record
mpe_ID : Integer;
mpe_Red : Unsigned_32;
mpe_Green : Unsigned_32;
mpe_Blue : Unsigned_32;
mpe_Group : Integer;
end record;

MUIV_Palette_Entry_End : constant Integer := -1;
type MUI_Scrmodelist_Entry;
type MUI_Scrmodelist_EntryPtr is access MUI_Scrmodelist_Entry;
type MUI_Scrmodelist_Entry is record
sme_Name : Chars_Ptr;
sme_ModeID : Unsigned_32;
end record;
--
--/***************************************************************************
--**
--** For Boopsi Image Implementors Only:
--**
--** If MUI is using a boopsi image object, it will send a special method
--** immediately after object creation. This method has a parameter structure
--** where the boopsi can fill in its minimum and maximum size and learn if
--** its used in a horizontal or vertical context.
--**
--** The boopsi image must use the method id (MUIM_BoopsiQuery) as return
--** value. That's how MUI sees that the method is implemented.
--**
--** Note: MUI does not depend on this method. If the boopsi image doesn't
--** implement it, minimum size will be 0 and maximum size unlimited.
--**
--***************************************************************************/

MUIM_BoopsiQuery : constant Unsigned_32 := 16#80427157#;

type MUI_BoopsiQuery;
type MUI_BoopsiQuery_Ptr is access MUI_BoopsiQuery;
type MUI_BoopsiQuery is record
mbq_MethodID : Unsigned_32;
mbq_Screen : Screen_Ptr;
mbq_Flags : Unsigned_32;
mbq_MinWidth : Integer;
mbq_MinHeight : Integer;
mbq_MaxWidth : Integer;
mbq_MaxHeight : Integer;
mbq_DefWidth : Integer;
mbq_DefHeight : Integer;
mbq_RenderInfo : MUI_RenderInfo_Ptr;
end record;

--MUIP_BoopsiQuery : constant Integer := MUI_BoopsiQuery;
MBQF_HORIZ : constant Integer := (2**0);
MBQ_MUI_MAXMAX : constant Integer := (10000);
MUIM_CallHook : constant Unsigned_32 := 16#8042b96b#;
MUIM_FindUData : constant Unsigned_32 := 16#8042c196#;
MUIM_GetUData : constant Unsigned_32 := 16#8042ed0c#;
MUIM_KillNotify : constant Unsigned_32 := 16#8042d240#;
MUIM_MultiSet : constant Unsigned_32 := 16#8042d356#;
MUIM_NoNotifySet : constant Unsigned_32 := 16#8042216f#;
MUIM_Notify : constant Unsigned_32 := 16#8042c9cb#;
MUIM_Set : constant Unsigned_32 := 16#8042549a#;
MUIM_SetAsString : constant Unsigned_32 := 16#80422590#;
MUIM_SetUData : constant Unsigned_32 := 16#8042c920#;
MUIM_WriteInteger : constant Unsigned_32 := 16#80428d86#;
MUIM_WriteString : constant Unsigned_32 := 16#80424bf4#;

type MUIP_CallHook;
type MUIP_CallHook_Ptr is access MUIP_CallHook;
NullMUIP_CallHook_Ptr : constant MUIP_CallHook_Ptr := NULL;
type MUIP_CallHook is record
id : Unsigned_32;
Hook : Hook_Ptr;
param1 : Unsigned_32;
end record;


type MUIP_FindUData;
type MUIP_FindUData_Ptr is access MUIP_FindUData;
type MUIP_FindUData is record
id : Unsigned_32;
udata : Unsigned_32;
end record;


type MUIP_GetUData;
type MUIP_GetUData_Ptr is access MUIP_GetUData;
type MUIP_GetUData is record
id : Unsigned_32;
udata : Unsigned_32;
attr : Unsigned_32;
storage : Unsigned_32_Ptr;
end record;


type MUIP_KillNotify;
type MUIP_KillNotify_Ptr is access MUIP_KillNotify;
type MUIP_KillNotify is record
id : Unsigned_32;
TrigAttr : Unsigned_32;
end record;


type MUIP_MultiSet;
type MUIP_MultiSet_Ptr is access MUIP_MultiSet;
type MUIP_MultiSet is record
id : Unsigned_32;
attr : Unsigned_32;
val : Unsigned_32;
obj : Integer_Ptr;
end record;

type MUIP_NoNotifySet;
type MUIP_NoNotifySet_Ptr is access MUIP_NoNotifySet;
type MUIP_NoNotifySet is record
id : Unsigned_32;
attr : Unsigned_32;
format : Chars_Ptr;
val : Unsigned_32;
--   .....
end record;


type MUIP_Notify;
type MUIP_Notify_Ptr is access MUIP_Notify;
type MUIP_Notify is record
id : Unsigned_32;
TrigAttr : Unsigned_32;
TrigVal : Unsigned_32;
DestObj : Integer_Ptr;
FollowParams : Unsigned_32;
end record;


type MUIP_Set;
type MUIP_Set_Ptr is access MUIP_Set;
type MUIP_Set is record
id : Unsigned_32;
attr : Unsigned_32;
val : Unsigned_32;
end record;


type MUIP_SetAsString;
type MUIP_SetAsChar_Ptr is access MUIP_SetAsString;
type MUIP_SetAsString is record
id : Unsigned_32;
attr : Unsigned_32;
format : Chars_Ptr;
val : Unsigned_32;
end record;


type MUIP_SetUData;
type MUIP_SetUData_Ptr is access MUIP_SetUData;
type MUIP_SetUData is record
id : Unsigned_32;
udata : Unsigned_32;
attr : Unsigned_32;
val : Unsigned_32;
end record;


type MUIP_WriteInteger;
type MUIP_WriteInteger_Ptr is access MUIP_WriteInteger;
type MUIP_WriteInteger is record
id : Unsigned_32;
val : Unsigned_32;
memory : Unsigned_32_Ptr;
end record;


type MUIP_WriteString;
type MUIP_WriteChar_Ptr is access MUIP_WriteString;
type MUIP_WriteString is record
id : Unsigned_32;
str : Chars_Ptr;
memory : Chars_Ptr;
end record;

MUIA_AppMessage : constant Unsigned_32 := 16#80421955#;
MUIA_HelpLine : constant Unsigned_32 := 16#8042a825#;
MUIA_HelpNode : constant Unsigned_32 := 16#80420b85#;
MUIA_NoNotify : constant Unsigned_32 := 16#804237f9#;
MUIA_Revision : constant Unsigned_32 := 16#80427eaa#;
MUIA_UserData : constant Unsigned_32 := 16#80420313#;
MUIA_Version : constant Unsigned_32 := 16#80422301#;
MUIM_Family_AddHead : constant Unsigned_32 := 16#8042e200#;
MUIM_Family_AddTail : constant Unsigned_32 := 16#8042d752#;
MUIM_Family_Insert : constant Unsigned_32 := 16#80424d34#;
MUIM_Family_Remove : constant Unsigned_32 := 16#8042f8a9#;
MUIM_Family_Sort : constant Unsigned_32 := 16#80421c49#;
MUIM_Family_Transfer : constant Unsigned_32 := 16#8042c14a#;

type MUIP_Family_AddHead;
type MUIP_Family_AddHead_Ptr is access MUIP_Family_AddHead;
type MUIP_Family_AddHead is record
id : Unsigned_32;
obj : Object_Ptr;
end record;


type MUIP_Family_AddTail;
type MUIP_Family_AddTail_Ptr is access MUIP_Family_AddTail;
type MUIP_Family_AddTail is record
id : Unsigned_32;
obj : Object_Ptr;
end record;


type MUIP_Family_Insert;
type MUIP_Family_Insert_Ptr is access MUIP_Family_Insert;
type MUIP_Family_Insert is record
id : Unsigned_32;
obj : Object_Ptr;
pred : Object_Ptr;
end record;


type MUIP_Family_Remove;
type MUIP_Family_Remove_Ptr is access MUIP_Family_Remove;
type MUIP_Family_Remove is record
id : Unsigned_32;
obj : Object_Ptr;
end record;


type MUIP_Family_Sort;
type MUIP_Family_Sort_Ptr is access MUIP_Family_Sort;
type MUIP_Family_Sort is record
id : Unsigned_32;
obj : Object_Ptr_Array(0..0);
end record;


type MUIP_Family_Transfer;
type MUIP_Family_Transfer_Ptr is access MUIP_Family_Transfer;
type MUIP_Family_Transfer is record
id : Unsigned_32;
family : Object_Ptr;
end record;

MUIA_Family_Child : constant Unsigned_32 := 16#8042c696#;
MUIA_Menustrip_Enabled : constant Unsigned_32 := 16#8042815b#;
MUIA_Menu_Enabled : constant Unsigned_32 := 16#8042ed48#;
MUIA_Menu_Title : constant Unsigned_32 := 16#8042a0e3#;
MUIA_Menuitem_Checked : constant Unsigned_32 := 16#8042562a#;
MUIA_Menuitem_Checkit : constant Unsigned_32 := 16#80425ace#;
MUIA_Menuitem_Enabled : constant Unsigned_32 := 16#8042ae0f#;
MUIA_Menuitem_Exclude : constant Unsigned_32 := 16#80420bc6#;
MUIA_Menuitem_Shortcut : constant Unsigned_32 := 16#80422030#;
MUIA_Menuitem_Title : constant Unsigned_32 := 16#804218be#;
MUIA_Menuitem_Toggle : constant Unsigned_32 := 16#80424d5c#;
MUIA_Menuitem_Trigger : constant Unsigned_32 := 16#80426f32#;
MUIM_Application_Input : constant Unsigned_32 := 16#8042d0f5#;
MUIM_Application_InputBuffered : constant Unsigned_32 := 16#80427e59#;
MUIM_Application_Load : constant Unsigned_32 := 16#8042f90d#;
MUIM_Application_PushMethod : constant Unsigned_32 := 16#80429ef8#;
MUIM_Application_ReturnID : constant Unsigned_32 := 16#804276ef#;
MUIM_Application_Save : constant Unsigned_32 := 16#804227ef#;
MUIM_Application_ShowHelp : constant Unsigned_32 := 16#80426479#;

type MUIP_Application_GetMenuCheck;
type MUIP_Application_GetMenuCheck_Ptr is access MUIP_Application_GetMenuCheck;
type MUIP_Application_GetMenuCheck is record
id : Unsigned_32;
MenuID : Unsigned_32;
end record;


type MUIP_Application_GetMenuState;
type MUIP_Application_GetMenuState_Ptr is access MUIP_Application_GetMenuState;
type MUIP_Application_GetMenuState is record
id : Unsigned_32;
MenuID : Unsigned_32;
end record;


type MUIP_Application_Input;
type MUIP_Application_Input_Ptr is access MUIP_Application_Input;
type MUIP_Application_Input is record
id : Unsigned_32;
signal : Integer_Ptr;
end record;


type MUIP_Application_Load;
type MUIP_Application_Load_Ptr is access MUIP_Application_Load;
type MUIP_Application_Load is record
id : Unsigned_32;
name : Chars_Ptr;
end record;


type MUIP_Application_PushMethod;
type MUIP_Application_PushMethod_Ptr is access MUIP_Application_PushMethod;
type MUIP_Application_PushMethod is record
id : Unsigned_32;
dest : Object_Ptr;
count : Integer;
end record;


type MUIP_Application_ReturnID;
type MUIP_Application_ReturnID_Ptr is access MUIP_Application_ReturnID;
type MUIP_Application_ReturnID is record
id : Unsigned_32;
retid : Unsigned_32;
end record;


type MUIP_Application_Save;
type MUIP_Application_Save_Ptr is access MUIP_Application_Save;
type MUIP_Application_Save is record
id : Unsigned_32;
name : Chars_Ptr;
end record;


type MUIP_Application_SetMenuCheck;
type MUIP_Application_SetMenuCheck_Ptr is access MUIP_Application_SetMenuCheck;
type MUIP_Application_SetMenuCheck is record
id : Unsigned_32;
MenuID : Unsigned_32;
stat : Integer;
end record;


type MUIP_Application_SetMenuState;
type MUIP_Application_SetMenuState_Ptr is access MUIP_Application_SetMenuState;
type MUIP_Application_SetMenuState is record
id : Unsigned_32;
MenuID : Unsigned_32;
stat : Integer;
end record;


type MUIP_Application_ShowHelp;
type MUIP_Application_ShowHelp_Ptr is access MUIP_Application_ShowHelp;
type MUIP_Application_ShowHelp is record
id : Unsigned_32;
window : Object_Ptr;
name : Chars_Ptr;
node : Chars_Ptr;
line : Integer;
end record;

MUIA_Application_Active : constant Unsigned_32 := 16#804260ab#;
MUIA_Application_Author : constant Unsigned_32 := 16#80424842#;
MUIA_Application_Base : constant Unsigned_32 := 16#8042e07a#;
MUIA_Application_Broker : constant Unsigned_32 := 16#8042dbce#;
MUIA_Application_BrokerHook : constant Unsigned_32 := 16#80428f4b#;
MUIA_Application_BrokerPort : constant Unsigned_32 := 16#8042e0ad#;
MUIA_Application_BrokerPri : constant Unsigned_32 := 16#8042c8d0#;
MUIA_Application_Commands : constant Unsigned_32 := 16#80428648#;
MUIA_Application_Copyright : constant Unsigned_32 := 16#8042ef4d#;
MUIA_Application_Description : constant Unsigned_32 := 16#80421fc6#;
MUIA_Application_DiskObject : constant Unsigned_32 := 16#804235cb#;
MUIA_Application_DoubleStart : constant Unsigned_32 := 16#80423bc6#;
MUIA_Application_DropObject : constant Unsigned_32 := 16#80421266#;
MUIA_Application_ForceQuit : constant Unsigned_32 := 16#804257df#;
MUIA_Application_HelpFile : constant Unsigned_32 := 16#804293f4#;
MUIA_Application_Iconified : constant Unsigned_32 := 16#8042a07f#;
MUIA_Application_MenuAction : constant Unsigned_32 := 16#80428961#;
MUIA_Application_MenuHelp : constant Unsigned_32 := 16#8042540b#;
MUIA_Application_Menustrip : constant Unsigned_32 := 16#804252d9#;
MUIA_Application_RexxHook : constant Unsigned_32 := 16#80427c42#;
MUIA_Application_RexxMsg : constant Unsigned_32 := 16#8042fd88#;
MUIA_Application_RexxString : constant Unsigned_32 := 16#8042d711#;
MUIA_Application_SingleTask : constant Unsigned_32 := 16#8042a2c8#;
MUIA_Application_Sleep : constant Unsigned_32 := 16#80425711#;
MUIA_Application_Title : constant Unsigned_32 := 16#804281b8#;
MUIA_Application_Version : constant Unsigned_32 := 16#8042b33f#;
MUIA_Application_Window : constant Unsigned_32 := 16#8042bfe0#;
MUIM_Window_ScreenToBack : constant Unsigned_32 := 16#8042913d#;
MUIM_Window_ScreenToFront : constant Unsigned_32 := 16#804227a4#;
MUIM_Window_SetCycleChain : constant Unsigned_32 := 16#80426510#;
MUIM_Window_ToBack : constant Unsigned_32 := 16#8042152e#;
MUIM_Window_ToFront : constant Unsigned_32 := 16#8042554f#;

type MUIP_Window_GetMenuCheck;
type MUIP_Window_GetMenuCheck_Ptr is access MUIP_Window_GetMenuCheck;
type MUIP_Window_GetMenuCheck is record
id : Unsigned_32;
MenuID : Unsigned_32;
end record;


type MUIP_Window_GetMenuState;
type MUIP_Window_GetMenuState_Ptr is access MUIP_Window_GetMenuState;
type MUIP_Window_GetMenuState is record
id : Unsigned_32;
MenuID : Unsigned_32;
end record;


type MUIP_Window_SetCycleChain;
type MUIP_Window_SetCycleChain_Ptr is access MUIP_Window_SetCycleChain;
type MUIP_Window_SetCycleChain is record
id : Unsigned_32;
obj : Object_Ptr_Array(0..0);
end record;


type MUIP_Window_SetMenuCheck;
type MUIP_Window_SetMenuCheck_Ptr is access MUIP_Window_SetMenuCheck;
type MUIP_Window_SetMenuCheck is record
id : Unsigned_32;
MenuID : Unsigned_32;
stat : Integer;
end record;


type MUIP_Window_SetMenuState;
type MUIP_Window_SetMenuState_Ptr is access MUIP_Window_SetMenuState;
type MUIP_Window_SetMenuState is record
id : Unsigned_32;
MenuID : Unsigned_32;
stat : Integer;
end record;

MUIA_Window_Activate : constant Unsigned_32 := 16#80428d2f#;
MUIA_Window_ActiveObject : constant Unsigned_32 := 16#80427925#;
MUIA_Window_AltHeight : constant Unsigned_32 := 16#8042cce3#;
MUIA_Window_AltLeftEdge : constant Unsigned_32 := 16#80422d65#;
MUIA_Window_AltTopEdge : constant Unsigned_32 := 16#8042e99b#;
MUIA_Window_AltWidth : constant Unsigned_32 := 16#804260f4#;
MUIA_Window_AppWindow : constant Unsigned_32 := 16#804280cf#;
MUIA_Window_Backdrop : constant Unsigned_32 := 16#8042c0bb#;
MUIA_Window_Borderless : constant Unsigned_32 := 16#80429b79#;
MUIA_Window_CloseGadget : constant Unsigned_32 := 16#8042a110#;
MUIA_Window_CloseRequest : constant Unsigned_32 := 16#8042e86e#;
MUIA_Window_DefaultObject : constant Unsigned_32 := 16#804294d7#;
MUIA_Window_DepthGadget : constant Unsigned_32 := 16#80421923#;
MUIA_Window_DragBar : constant Unsigned_32 := 16#8042045d#;
MUIA_Window_FancyDrawing : constant Unsigned_32 := 16#8042bd0e#;
MUIA_Window_Height : constant Unsigned_32 := 16#80425846#;
MUIA_Window_ID : constant Unsigned_32 := 16#804201bd#;
MUIA_Window_InputEvent : constant Unsigned_32 := 16#804247d8#;
MUIA_Window_LeftEdge : constant Unsigned_32 := 16#80426c65#;
MUIA_Window_MenuAction : constant Unsigned_32 := 16#80427521#;
MUIA_Window_Menustrip : constant Unsigned_32 := 16#8042855e#;
MUIA_Window_NoMenus : constant Unsigned_32 := 16#80429df5#;
MUIA_Window_Open : constant Unsigned_32 := 16#80428aa0#;
MUIA_Window_PublicScreen : constant Unsigned_32 := 16#804278e4#;
MUIA_Window_RefWindow : constant Unsigned_32 := 16#804201f4#;
MUIA_Window_RootObject : constant Unsigned_32 := 16#8042cba5#;
MUIA_Window_Screen : constant Unsigned_32 := 16#8042df4f#;
MUIA_Window_ScreenTitle : constant Unsigned_32 := 16#804234b0#;
MUIA_Window_SizeGadget : constant Unsigned_32 := 16#8042e33d#;
MUIA_Window_SizeRight : constant Unsigned_32 := 16#80424780#;
MUIA_Window_Sleep : constant Unsigned_32 := 16#8042e7db#;
MUIA_Window_Title : constant Unsigned_32 := 16#8042ad3d#;
MUIA_Window_TopEdge : constant Unsigned_32 := 16#80427c66#;
MUIA_Window_Width : constant Unsigned_32 := 16#8042dcae#;
MUIA_Window_Window : constant Unsigned_32 := 16#80426a42#;
MUIV_Window_None_ActiveObject : constant Integer := 0;
MUIV_Window_Next_ActiveObject : constant Integer := -1;
MUIV_Window_ActiveObject_Prev : constant Integer := -2;
MUIV_Window_AltHeight_Scaled : constant Integer := -1000;
MUIV_Window_AltLeftEdge_Centered : constant Integer := -1;
MUIV_Window_Moused_AltLeftEdge : constant Integer := -2;
MUIV_Window_NoChange_AltLeftEdge : constant Integer := -1000;
MUIV_Window_Centered_AltTopEdge : constant Integer := -1;
MUIV_Window_Moused_AltTopEdge : constant Integer := -2;
MUIV_Window_NoChange_AltTopEdge : constant Integer := -1000;
MUIV_Window_Scaled_AltWidth : constant Integer := -1000;
MUIV_Window_Scaled_Height : constant Integer := -1000;
MUIV_Window_Default_Height : constant Integer := -1001;
MUIV_Window_Centered_LeftEdge : constant Integer := -1;
MUIV_Window_Moused_LeftEdge : constant Integer := -2;
MUIV_Window_Centered_TopEdge : constant Integer := -1;
MUIV_Window_Moused_TopEdge : constant Integer := -2;
MUIV_Window_Scaled_Width : constant Integer := -1000;
MUIV_Window_Default_Width : constant Integer := -1001;
MUIM_AskMinMax : constant Unsigned_32 := 16#80423874#;
MUIM_Cleanup : constant Unsigned_32 := 16#8042d985#;
MUIM_Draw : constant Unsigned_32 := 16#80426f3f#;
MUIM_HandleInput : constant Unsigned_32 := 16#80422a1a#;
MUIM_Hide : constant Unsigned_32 := 16#8042f20f#;
MUIM_Setup : constant Unsigned_32 := 16#80428354#;
MUIM_Show : constant Unsigned_32 := 16#8042cc84#;

type MUIP_AskMinMax;
type MUIP_AskMinMax_Ptr is access MUIP_AskMinMax;
type MUIP_AskMinMax is record
id : Unsigned_32;
MinMaxInfo : MUI_MinMax_Ptr;
end record;


type MUIP_Draw;
type MUIP_Draw_Ptr is access MUIP_Draw;
type MUIP_Draw is record
id : Unsigned_32;
flags : Unsigned_32;
end record;


type MUIP_HandleInput;
type MUIP_HandleInput_Ptr is access MUIP_HandleInput;
type MUIP_HandleInput is record
id : Unsigned_32;
imsg : IntuiMessage_Ptr;
muikey : Integer;
end record;


type MUIP_Setup;
type MUIP_Setup_Ptr is access MUIP_Setup;
type MUIP_Setup is record
id : Unsigned_32;
RenderInfo : MUI_RenderInfo_Ptr;
end record;

MUIA_ApplicationObject : constant Unsigned_32 := 16#8042d3ee#;
MUIA_Background : constant Unsigned_32 := 16#8042545b#;
MUIA_BottomEdge : constant Unsigned_32 := 16#8042e552#;
MUIA_ControlChar : constant Unsigned_32 := 16#8042120b#;
MUIA_Disabled : constant Unsigned_32 := 16#80423661#;
MUIA_ExportID : constant Unsigned_32 := 16#8042d76e#;
MUIA_FixHeight : constant Unsigned_32 := 16#8042a92b#;
MUIA_FixHeightTxt : constant Unsigned_32 := 16#804276f2#;
MUIA_FixWidth : constant Unsigned_32 := 16#8042a3f1#;
MUIA_FixWidthTxt : constant Unsigned_32 := 16#8042d044#;
MUIA_Font : constant Unsigned_32 := 16#8042be50#;
MUIA_Frame : constant Unsigned_32 := 16#8042ac64#;
MUIA_FramePhantomHoriz : constant Unsigned_32 := 16#8042ed76#;
MUIA_FrameTitle : constant Unsigned_32 := 16#8042d1c7#;
MUIA_Height : constant Unsigned_32 := 16#80423237#;
MUIA_HorizWeight : constant Unsigned_32 := 16#80426db9#;
MUIA_InnerBottom : constant Unsigned_32 := 16#8042f2c0#;
MUIA_InnerLeft : constant Unsigned_32 := 16#804228f8#;
MUIA_InnerRight : constant Unsigned_32 := 16#804297ff#;
MUIA_InnerTop : constant Unsigned_32 := 16#80421eb6#;
MUIA_InputMode : constant Unsigned_32 := 16#8042fb04#;
MUIA_LeftEdge : constant Unsigned_32 := 16#8042bec6#;
MUIA_Pressed : constant Unsigned_32 := 16#80423535#;
MUIA_RightEdge : constant Unsigned_32 := 16#8042ba82#;
MUIA_Selected : constant Unsigned_32 := 16#8042654b#;
MUIA_ShowMe : constant Unsigned_32 := 16#80429ba8#;
MUIA_ShowSelState : constant Unsigned_32 := 16#8042caac#;
MUIA_Timer : constant Unsigned_32 := 16#80426435#;
MUIA_TopEdge : constant Unsigned_32 := 16#8042509b#;
MUIA_VertWeight : constant Unsigned_32 := 16#804298d0#;
MUIA_Weight : constant Unsigned_32 := 16#80421d1f#;
MUIA_Width : constant Unsigned_32 := 16#8042b59c#;
MUIA_Window : constant Unsigned_32 := 16#80421591#;
MUIA_WindowObject : constant Unsigned_32 := 16#8042669e#;
MUIV_Font_Inherit : constant Unsigned_32 := 0;
MUIV_Font_Normal : constant Unsigned_32 := 16#ffffffff#; -- was -1;
MUIV_Font_List : constant Unsigned_32 := 16#fffffffe#; --  -2;
MUIV_Font_Tiny : constant Unsigned_32 := 16#fffffffd#; --  -3;
MUIV_Font_Fixed : constant Unsigned_32 := 16#fffffffc#; --  -4;
MUIV_Font_Title : constant Unsigned_32 := 16#fffffffb#; --  -5;
MUIV_Font_Big : constant Unsigned_32 := 16#fffffffa#; --  -6;
MUIV_Frame_None : constant Unsigned_32 := 0;
MUIV_Frame_Button : constant Unsigned_32 := 1;
MUIV_Frame_ImageButton : constant Unsigned_32 := 2;
MUIV_Frame_Text : constant Unsigned_32 := 3;
MUIV_Frame_String : constant Unsigned_32 := 4;
MUIV_Frame_ReadList : constant Unsigned_32 := 5;
MUIV_Frame_InputList : constant Unsigned_32 := 6;
MUIV_Frame_Prop : constant Unsigned_32 := 7;
MUIV_Frame_Gauge : constant Unsigned_32 := 8;
MUIV_Frame_Group : constant Unsigned_32 := 9;
MUIV_Frame_PopUp : constant Unsigned_32 := 10;
MUIV_Frame_Virtual : constant Unsigned_32 := 11;
MUIV_Frame_Slider : constant Unsigned_32 := 12;
MUIV_Frame_Count : constant Unsigned_32 := 13;
MUIV_InputMode_None : constant Unsigned_32 := 0;
MUIV_InputMode_RelVerify : constant Unsigned_32 := 1;
MUIV_InputMode_Immediate : constant Unsigned_32 := 2;
MUIV_InputMode_Toggle : constant Unsigned_32 := 3;
MUIA_Rectangle_HBar : constant Unsigned_32 := 16#8042c943#;
MUIA_Rectangle_VBar : constant Unsigned_32 := 16#80422204#;
MUIA_Image_FontMatch : constant Unsigned_32 := 16#8042815d#;
MUIA_Image_FontMatchHeight : constant Unsigned_32 := 16#80429f26#;
MUIA_Image_FontMatchWidth : constant Unsigned_32 := 16#804239bf#;
MUIA_Image_FreeHoriz : constant Unsigned_32 := 16#8042da84#;
MUIA_Image_FreeVert : constant Unsigned_32 := 16#8042ea28#;
MUIA_Image_OldImage : constant Unsigned_32 := 16#80424f3d#;
MUIA_Image_Spec : constant Unsigned_32 := 16#804233d5#;
MUIA_Image_State : constant Unsigned_32 := 16#8042a3ad#;
MUIA_Bitmap_Bitmap : constant Unsigned_32 := 16#804279bd#;
MUIA_Bitmap_Height : constant Unsigned_32 := 16#80421560#;
MUIA_Bitmap_MappingTable : constant Unsigned_32 := 16#8042e23d#;
MUIA_Bitmap_SourceColors : constant Unsigned_32 := 16#80425360#;
MUIA_Bitmap_Transparent : constant Unsigned_32 := 16#80422805#;
MUIA_Bitmap_Width : constant Unsigned_32 := 16#8042eb3a#;
MUIA_Bodychunk_Body : constant Unsigned_32 := 16#8042ca67#;
MUIA_Bodychunk_Compression : constant Unsigned_32 := 16#8042de5f#;
MUIA_Bodychunk_Depth : constant Unsigned_32 := 16#8042c392#;
MUIA_Bodychunk_Masking : constant Unsigned_32 := 16#80423b0e#;
MUIA_Text_Contents : constant Unsigned_32 := 16#8042f8dc#;
MUIA_Text_HiChar : constant Unsigned_32 := 16#804218ff#;
MUIA_Text_PreParse : constant Unsigned_32 := 16#8042566d#;
MUIA_Text_SetMax : constant Unsigned_32 := 16#80424d0a#;
MUIA_Text_SetMin : constant Unsigned_32 := 16#80424e10#;
MUIA_String_Accept : constant Unsigned_32 := 16#8042e3e1#;
MUIA_String_Acknowledge : constant Unsigned_32 := 16#8042026c#;
MUIA_String_AttachedList : constant Unsigned_32 := 16#80420fd2#;
MUIA_String_BufferPos : constant Unsigned_32 := 16#80428b6c#;
MUIA_String_Contents : constant Unsigned_32 := 16#80428ffd#;
MUIA_String_DisplayPos : constant Unsigned_32 := 16#8042ccbf#;
MUIA_String_EditHook : constant Unsigned_32 := 16#80424c33#;
MUIA_String_Format : constant Unsigned_32 := 16#80427484#;
MUIA_String_Integer : constant Unsigned_32 := 16#80426e8a#;
MUIA_String_MaxLen : constant Unsigned_32 := 16#80424984#;
MUIA_String_Reject : constant Unsigned_32 := 16#8042179c#;
MUIA_String_Secret : constant Unsigned_32 := 16#80428769#;
MUIV_String_Left_Format : constant Integer := 0;
MUIV_String_Center_Format : constant Integer := 1;
MUIV_String_Right_Format : constant Integer := 2;

MUIA_Prop_Entries : constant Unsigned_32 := 16#8042fbdb#;
MUIA_Prop_First : constant Unsigned_32 := 16#8042d4b2#;
MUIA_Prop_Horiz : constant Unsigned_32 := 16#8042f4f3#;
MUIA_Prop_Slider : constant Unsigned_32 := 16#80429c3a#;
MUIA_Prop_Visible : constant Unsigned_32 := 16#8042fea6#;
MUIA_Gauge_Current : constant Unsigned_32 := 16#8042f0dd#;
MUIA_Gauge_Divide : constant Unsigned_32 := 16#8042d8df#;
MUIA_Gauge_Horiz : constant Unsigned_32 := 16#804232dd#;
MUIA_Gauge_InfoText : constant Unsigned_32 := 16#8042bf15#;
MUIA_Gauge_Max : constant Unsigned_32 := 16#8042bcdb#;
MUIA_Scale_Horiz : constant Unsigned_32 := 16#8042919a#;
MUIA_Boopsi_Class : constant Unsigned_32 := 16#80426999#;
MUIA_Boopsi_ClassID : constant Unsigned_32 := 16#8042bfa3#;
MUIA_Boopsi_MaxHeight : constant Unsigned_32 := 16#8042757f#;
MUIA_Boopsi_MaxWidth : constant Unsigned_32 := 16#8042bcb1#;
MUIA_Boopsi_MinHeight : constant Unsigned_32 := 16#80422c93#;
MUIA_Boopsi_MinWidth : constant Unsigned_32 := 16#80428fb2#;
MUIA_Boopsi_Object : constant Unsigned_32 := 16#80420178#;
MUIA_Boopsi_Remember : constant Unsigned_32 := 16#8042f4bd#;
MUIA_Boopsi_TagDrawInfo : constant Unsigned_32 := 16#8042bae7#;
MUIA_Boopsi_TagScreen : constant Unsigned_32 := 16#8042bc71#;
MUIA_Boopsi_TagWindow : constant Unsigned_32 := 16#8042e11d#;
MUIA_Boopsi_Smart : constant Unsigned_32 := 16#8042b8d7#;
MUIA_Colorfield_Blue : constant Unsigned_32 := 16#8042d3b0#;
MUIA_Colorfield_Green : constant Unsigned_32 := 16#80424466#;
MUIA_Colorfield_Pen : constant Unsigned_32 := 16#8042713a#;
MUIA_Colorfield_Red : constant Unsigned_32 := 16#804279f6#;
MUIA_Colorfield_RGB : constant Unsigned_32 := 16#8042677a#;
MUIM_List_Clear : constant Unsigned_32 := 16#8042ad89#;
MUIM_List_Exchange : constant Unsigned_32 := 16#8042468c#;
MUIM_List_GetEntry : constant Unsigned_32 := 16#804280ec#;
MUIM_List_Insert : constant Unsigned_32 := 16#80426c87#;
MUIM_List_InsertSingle : constant Unsigned_32 := 16#804254d5#;
MUIM_List_Jump : constant Unsigned_32 := 16#8042baab#;
MUIM_List_Move : constant Unsigned_32 := 16#804253c2#;
MUIM_List_NextSelected : constant Unsigned_32 := 16#80425f17#;
MUIM_List_Redraw : constant Unsigned_32 := 16#80427993#;
MUIM_List_Remove : constant Unsigned_32 := 16#8042647e#;
MUIM_List_Select : constant Unsigned_32 := 16#804252d8#;
MUIM_List_Sort : constant Unsigned_32 := 16#80422275#;

type MUIP_List_Exchange;
type MUIP_List_Exchange_Ptr is access MUIP_List_Exchange;
type MUIP_List_Exchange is record
id : Unsigned_32;
pos1 : Integer;
pos2 : Integer;
end record;


type MUIP_List_GetEntry;
type MUIP_List_GetEntry_Ptr is access MUIP_List_GetEntry;
type MUIP_List_GetEntry is record
id : Unsigned_32;
pos : Integer;
an_entry : Integer_Ptr_Ptr;
end record;


type MUIP_List_Insert;
type MUIP_List_Insert_Ptr is access MUIP_List_Insert;
type MUIP_List_Insert is record
id : Unsigned_32;
entries : Integer_Ptr_Ptr;
count : Integer;
pos : Integer;
end record;


type MUIP_List_InsertSingle;
type MUIP_List_InsertSingle_Ptr is access MUIP_List_InsertSingle;
type MUIP_List_InsertSingle is record
id : Unsigned_32;
an_entry : Integer_Ptr;
pos : Integer;
end record;


type MUIP_List_Jump;
type MUIP_List_Jump_Ptr is access MUIP_List_Jump;
type MUIP_List_Jump is record
id : Unsigned_32;
pos : Integer;
end record;

type MUIP_List_Move;
type MUIP_List_Move_Ptr is access MUIP_List_Move;
type MUIP_List_Move is record
id : Unsigned_32;
from : Integer;
to : Integer;
end record;


type MUIP_List_NextSelected;
type MUIP_List_NextSelected_Ptr is access MUIP_List_NextSelected;
type MUIP_List_NextSelected is record
id : Unsigned_32;
pos : Integer_Ptr;
end record;


type MUIP_List_Redraw;
type MUIP_List_Redraw_Ptr is access MUIP_List_Redraw;
type MUIP_List_Redraw is record
id : Unsigned_32;
pos : Integer;
end record;


type MUIP_List_Remove;
type MUIP_List_Remove_Ptr is access MUIP_List_Remove;
type MUIP_List_Remove is record
id : Unsigned_32;
pos : Integer;
end record;


type MUIP_List_Select;
type MUIP_List_Select_Ptr is access MUIP_List_Select;
type MUIP_List_Select is record
id : Unsigned_32;
pos : Integer;
seltype : Integer;
state : Integer_Ptr;
end record;

MUIA_List_Active : constant Unsigned_32 := 16#8042391c#;
MUIA_List_AdjustHeight : constant Unsigned_32 := 16#8042850d#;
MUIA_List_AdjustWidth : constant Unsigned_32 := 16#8042354a#;
MUIA_List_CompareHook : constant Unsigned_32 := 16#80425c14#;
MUIA_List_ConstructHook : constant Unsigned_32 := 16#8042894f#;
MUIA_List_DestructHook : constant Unsigned_32 := 16#804297ce#;
MUIA_List_DisplayHook : constant Unsigned_32 := 16#8042b4d5#;
MUIA_List_Entries : constant Unsigned_32 := 16#80421654#;
MUIA_List_First : constant Unsigned_32 := 16#804238d4#;
MUIA_List_Format : constant Unsigned_32 := 16#80423c0a#;
MUIA_List_InsertPosition : constant Unsigned_32 := 16#8042d0cd#;
MUIA_List_MultiTestHook : constant Unsigned_32 := 16#8042c2c6#;
MUIA_List_Quiet : constant Unsigned_32 := 16#8042d8c7#;
MUIA_List_SourceArray : constant Unsigned_32 := 16#8042c0a0#;
MUIA_List_Title : constant Unsigned_32 := 16#80423e66#;
MUIA_List_Visible : constant Unsigned_32 := 16#8042191f#;
MUIV_List_Off_Active : constant Integer := -1;
MUIV_List_Top_Active : constant Integer := -2;
MUIV_List_Bottom_Active : constant Integer := -3;
MUIV_List_Up_Active : constant Integer := -4;
MUIV_List_Down_Active : constant Integer := -5;
MUIV_List_PageUp_Active : constant Integer := -6;
MUIV_List_PageDown_Active : constant Integer := -7;
MUIV_List_String_ConstructHook : constant Integer := -1;
MUIV_List_String_CopyHook : constant Integer := -1;
MUIV_List_None_CursorType : constant Integer := 0;
MUIV_List_Bar_CursorType : constant Integer := 1;
MUIV_List_Rect_CursorType : constant Integer := 2;
MUIV_List_String_DestructHook : constant Integer := -1;
MUIA_Floattext_Justify : constant Unsigned_32 := 16#8042dc03#;
MUIA_Floattext_SkipChars : constant Unsigned_32 := 16#80425c7d#;
MUIA_Floattext_TabSize : constant Unsigned_32 := 16#80427d17#;
MUIA_Floattext_Text : constant Unsigned_32 := 16#8042d16a#;
MUIM_Dirlist_ReRead : constant Unsigned_32 := 16#80422d71#;
MUIA_Dirlist_AcceptPattern : constant Unsigned_32 := 16#8042760a#;
MUIA_Dirlist_Directory : constant Unsigned_32 := 16#8042ea41#;
MUIA_Dirlist_DrawersOnly : constant Unsigned_32 := 16#8042b379#;
MUIA_Dirlist_FilesOnly : constant Unsigned_32 := 16#8042896a#;
MUIA_Dirlist_FilterDrawers : constant Unsigned_32 := 16#80424ad2#;
MUIA_Dirlist_FilterHook : constant Unsigned_32 := 16#8042ae19#;
MUIA_Dirlist_MultiSelDirs : constant Unsigned_32 := 16#80428653#;
MUIA_Dirlist_NumInteger_8s : constant Unsigned_32 := 16#80429e26#;
MUIA_Dirlist_NumDrawers : constant Unsigned_32 := 16#80429cb8#;
MUIA_Dirlist_NumFiles : constant Unsigned_32 := 16#8042a6f0#;
MUIA_Dirlist_Path : constant Unsigned_32 := 16#80426176#;
MUIA_Dirlist_RejectIcons : constant Unsigned_32 := 16#80424808#;
MUIA_Dirlist_RejectPattern : constant Unsigned_32 := 16#804259c7#;
MUIA_Dirlist_SortDirs : constant Unsigned_32 := 16#8042bbb9#;
MUIA_Dirlist_SortHighLow : constant Unsigned_32 := 16#80421896#;
MUIA_Dirlist_SortType : constant Unsigned_32 := 16#804228bc#;
MUIA_Dirlist_Status : constant Unsigned_32 := 16#804240de#;
MUIV_Dirlist_SortDirs_First : constant Integer := 0;
MUIV_Dirlist_SortDirs_Last : constant Integer := 1;
MUIV_Dirlist_SortDirs_Mix : constant Integer := 2;
MUIV_Dirlist_SortType_Name : constant Integer := 0;
MUIV_Dirlist_SortType_Date : constant Integer := 1;
MUIV_Dirlist_SortType_Size : constant Integer := 2;
MUIV_Dirlist_Status_Invalid : constant Integer := 0;
MUIV_Dirlist_Status_Reading : constant Integer := 1;
MUIV_Dirlist_Status_Valid : constant Integer := 2;
MUIA_Group_ActivePage : constant Unsigned_32 := 16#80424199#;
MUIA_Group_Child : constant Unsigned_32 := 16#804226e6#;
MUIA_Group_Columns : constant Unsigned_32 := 16#8042f416#;
MUIA_Group_Horiz : constant Unsigned_32 := 16#8042536b#;
MUIA_Group_HorizSpacing : constant Unsigned_32 := 16#8042c651#;
MUIA_Group_PageMode : constant Unsigned_32 := 16#80421a5f#;
MUIA_Group_Rows : constant Unsigned_32 := 16#8042b68f#;
MUIA_Group_SameHeight : constant Unsigned_32 := 16#8042037e#;
MUIA_Group_SameSize : constant Unsigned_32 := 16#80420860#;
MUIA_Group_SameWidth : constant Unsigned_32 := 16#8042b3ec#;
MUIA_Group_Spacing : constant Unsigned_32 := 16#8042866d#;
MUIA_Group_VertSpacing : constant Unsigned_32 := 16#8042e1bf#;
MUIA_Group_ActivePage_First : constant Unsigned_32 := 0;
MUIA_Group_ActivePage_Last : constant Unsigned_32 := 16#ffffffff#;
MUIA_Group_ActivePage_Prev : constant Unsigned_32 := 16#fffffffe#;
MUIA_Group_ActivePage_Next : constant Unsigned_32 := 16#fffffffd#;
MUIA_Register_Frame : constant Unsigned_32 := 16#8042349b#;
MUIA_Register_Titles : constant Unsigned_32 := 16#804297ec#;
MUIA_Virtgroup_Height : constant Unsigned_32 := 16#80423038#;
MUIA_Virtgroup_Left : constant Unsigned_32 := 16#80429371#;
MUIA_Virtgroup_Top : constant Unsigned_32 := 16#80425200#;
MUIA_Virtgroup_Width : constant Unsigned_32 := 16#80427c49#;
MUIA_Scrollgroup_Contents : constant Unsigned_32 := 16#80421261#;
MUIA_Scrollgroup_FreeHoriz : constant Unsigned_32 := 16#804292f3#;
MUIA_Scrollgroup_FreeVert : constant Unsigned_32 := 16#804224f2#;
MUIA_Listview_ClickColumn : constant Unsigned_32 := 16#8042d1b3#;
MUIA_Listview_DefClickColumn : constant Unsigned_32 := 16#8042b296#;
MUIA_Listview_DoubleClick : constant Unsigned_32 := 16#80424635#;
MUIA_Listview_Input : constant Unsigned_32 := 16#8042682d#;
MUIA_Listview_List : constant Unsigned_32 := 16#8042bcce#;
MUIA_Listview_MultiSelect : constant Unsigned_32 := 16#80427e08#;
MUIA_Listview_SelectChange : constant Unsigned_32 := 16#8042178f#;
MUIV_Listview_MultiSelect_None : constant Unsigned_32 := 0;
MUIV_Listview_MultiSelect_Default : constant Unsigned_32 := 1;
MUIV_Listview_MultiSelect_Shifted : constant Unsigned_32 := 2;
MUIV_Listview_MultiSelect_Always : constant Unsigned_32 := 3;
MUIA_Radio_Active : constant Unsigned_32 := 16#80429b41#;
MUIA_Radio_Entries : constant Unsigned_32 := 16#8042b6a1#;
MUIA_Cycle_Active : constant Unsigned_32 := 16#80421788#;
MUIA_Cycle_Entries : constant Unsigned_32 := 16#80420629#;
MUIV_Cycle_Next_Active : constant Integer := -1;
MUIV_Cycle_Prev_Active : constant Integer := -2;
MUIA_Slider_Level : constant Unsigned_32 := 16#8042ae3a#;
MUIA_Slider_Max : constant Unsigned_32 := 16#8042d78a#;
MUIA_Slider_Min : constant Unsigned_32 := 16#8042e404#;
MUIA_Slider_Quiet : constant Unsigned_32 := 16#80420b26#;
MUIA_Slider_Reverse : constant Unsigned_32 := 16#8042f2a0#;
MUIA_Coloradjust_Blue : constant Unsigned_32 := 16#8042b8a3#;
MUIA_Coloradjust_Green : constant Unsigned_32 := 16#804285ab#;
MUIA_Coloradjust_ModeID : constant Unsigned_32 := 16#8042ec59#;
MUIA_Coloradjust_Red : constant Unsigned_32 := 16#80420eaa#;
MUIA_Coloradjust_RGB : constant Unsigned_32 := 16#8042f899#;
MUIA_Palette_Entries : constant Unsigned_32 := 16#8042a3d8#;
MUIA_Palette_Groupable : constant Unsigned_32 := 16#80423e67#;
MUIA_Palette_Names : constant Unsigned_32 := 16#8042c3a2#;
MUIM_Popstring_Close : constant Unsigned_32 := 16#8042dc52#;
MUIM_Popstring_Open : constant Unsigned_32 := 16#804258ba#;

type MUIP_Popstring_Close;
type MUIP_Popstring_Close_Ptr is access MUIP_Popstring_Close;
type MUIP_Popstring_Close is record
id : Unsigned_32;
result : Integer;
end record;

MUIA_Popstring_Button : constant Unsigned_32 := 16#8042d0b9#;
MUIA_Popstring_CloseHook : constant Unsigned_32 := 16#804256bf#;
MUIA_Popstring_OpenHook : constant Unsigned_32 := 16#80429d00#;
MUIA_Popstring_String : constant Unsigned_32 := 16#804239ea#;
MUIA_Popstring_Toggle : constant Unsigned_32 := 16#80422b7a#;
MUIA_Popobject_Follow : constant Unsigned_32 := 16#80424cb5#;
MUIA_Popobject_Light : constant Unsigned_32 := 16#8042a5a3#;
MUIA_Popobject_Object : constant Unsigned_32 := 16#804293e3#;
MUIA_Popobject_ObjStrHook : constant Unsigned_32 := 16#8042db44#;
MUIA_Popobject_StrObjHook : constant Unsigned_32 := 16#8042fbe1#;
MUIA_Popobject_Volatile : constant Unsigned_32 := 16#804252ec#;
MUIA_Popobject_WindowHook : constant Unsigned_32 := 16#8042f194#;
MUIA_Poplist_Array : constant Unsigned_32 := 16#8042084c#;
MUIA_Popasl_Active : constant Unsigned_32 := 16#80421b37#;
MUIA_Popasl_StartHook : constant Unsigned_32 := 16#8042b703#;
MUIA_Popasl_StopHook : constant Unsigned_32 := 16#8042d8d2#;
MUIA_Popasl_Type : constant Unsigned_32 := 16#8042df3d#;

type MUI_GlobalInfo;
type MUI_GlobalInfo_Ptr is access MUI_GlobalInfo;
type MUI_GlobalInfo is record
priv0 : Unsigned_32;
mgi_ApplicationObject : Object_Ptr;
end record;


type MUI_NotifyData;
type MUI_NotifyData_Ptr is access MUI_NotifyData;
type MUI_NotifyData is record
mnd_GlobalInfo : MUI_GlobalInfo_Ptr;
mnd_UserData : Unsigned_32;
priv1 : Unsigned_32;
priv2 : Unsigned_32;
priv3 : Unsigned_32;
priv4 : Unsigned_32;
priv5 : Unsigned_32;
end record;


type MUI_MinMax is record
MinWidth : Integer_16;
MinHeight : Integer_16;
MaxWidth : Integer_16;
MaxHeight : Integer_16;
DefWidth : Integer_16;
DefHeight : Integer_16;
end record;

MUI_MAXMAX : constant Integer := 10000;

type MUI_AreaData;
type MUI_AreaData_Ptr is access MUI_AreaData;
type MUI_AreaData is record
mad_RenderInfo : MUI_RenderInfo_Ptr;
priv6 : Unsigned_32;
mad_Font : TextFont_Ptr;
mad_MinMax : MUI_MinMax;
mad_Box : IBox;
mad_addleft : Integer_8;
mad_addtop : Integer_8;
mad_subwidth : Integer_8;
mad_subheight : Integer_8;
mad_Flags : Unsigned_32;
end record;

MADF_DRAWOBJECT : constant Integer := (2** 0);
MADF_DRAWOBJECT_ADF_DRAWUPDATE : constant Integer := (2** 1);
MPEN_SHINE : constant Integer := 0;
MPEN_HALFSHINE : constant Integer := 1;
MPEN_BACKGROUND : constant Integer := 2;
MPEN_HALFSHADOW : constant Integer := 3;
MPEN_SHADOW : constant Integer := 4;
MPEN_TEXT : constant Integer := 5;
MPEN_FILL : constant Integer := 6;
MPEN_ACTIVEOBJ : constant Integer := 7;
MPEN_COUNT : constant Integer := 8;

type MUI_RenderInfo is record
mri_WindowObject : Object_Ptr;
mri_Screen : Screen_Ptr;
mri_DrawInfo : DrawInfo_Ptr;
mri_Pens : Unsigned_16_Ptr;
mri_Window : Window_Ptr;
mri_RastPort : RastPort_Ptr;
end record;

-- was an enum 

MUIKEY_RELEASE : constant Integer := -2;
MUIKEY_NONE : constant Integer := -1;
MUIKEY_PRESS : constant Integer := 0;
MUIKEY_TOGGLE : constant Integer := 1;
MUIKEY_UP : constant Integer := 2;
MUIKEY_DOWN : constant Integer := 3;
MUIKEY_PAGEUP : constant Integer := 4;
MUIKEY_PAGEDOWN : constant Integer := 5;
MUIKEY_TOP : constant Integer := 6;
MUIKEY_BOTTOM : constant Integer := 7;
MUIKEY_LEFT : constant Integer := 8;
MUIKEY_RIGHT : constant Integer := 9;
MUIKEY_WORDLEFT : constant Integer := 10;
MUIKEY_WORDRIGHT : constant Integer := 11;
MUIKEY_LINESTART : constant Integer := 12;
MUIKEY_LINEEND : constant Integer := 13;
MUIKEY_GADGET_NEXT : constant Integer := 14;
MUIKEY_GADGET_PREV : constant Integer := 15;
MUIKEY_GADGET_OFF : constant Integer := 16;
MUIKEY_WINDOW_CLOSE : constant Integer := 17;
MUIKEY_WINDOW_NEXT : constant Integer := 18;
MUIKEY_WINDOW_PREV : constant Integer := 19;
MUIKEY_HELP : constant Integer := 20;
MUIKEY_POPUP : constant Integer := 21;
MUIKEY_COUNT : constant Integer := 22;

type MUI_CustomClass;
type MUI_CustomClass_Ptr is access MUI_CustomClass;
type MUI_CustomClass is record
mcc_UserData : Integer_Ptr;
mcc_UtilityBase : Library_Ptr;
mcc_DOSBase : Library_Ptr;
mcc_GfxBase : Library_Ptr;
mcc_IntuitionBase : Library_Ptr;
mcc_Super : IClass_Ptr;
mcc_Class : IClass_Ptr;
end record;

procedure MUI_DisposeObject (obj : Object_Ptr);
pragma Import( C, MUI_DisposeObject, "MUI_DisposeObject");
function MUI_RequestA (app : Integer_Ptr;win : Integer_Ptr;flags : Unsigned_32;title : Chars_Ptr;gadgets : Chars_Ptr;format : Chars_Ptr;params : Integer_Ptr) return Integer;
pragma Import( C, MUI_RequestA, "MUI_RequestA");
function MUI_Error return Integer;
pragma Import( C, MUI_Error, "MUI_Error");
procedure MUI_FreeAslRequest (requester : Requester_Ptr);
pragma Import( C, MUI_FreeAslRequest, "MUI_FreeAslRequest");
function MUI_SetError (num : Integer) return Integer;
pragma Import( C, MUI_SetError, "MUI_SetError");
function MUI_GetClass (classname : Chars_Ptr) return IClass_Ptr;
pragma Import( C, MUI_GetClass, "MUI_GetClass");
procedure MUI_FreeClass (class_Ptr : IClass_Ptr);
pragma Import( C, MUI_FreeClass, "MUI_FreeClass");
procedure MUI_RequestIDCMP (obj : Object_Ptr ;flags : Unsigned_32);
pragma Import( C, MUI_RequestIDCMP, "MUI_RequestIDCMP");
procedure MUI_RejectIDCMP (obj : Object_Ptr;flags : Unsigned_32);
pragma Import( C, MUI_RejectIDCMP, "MUI_RejectIDCMP");
procedure MUI_Redraw (obj : Object_Ptr;flags : Unsigned_32);
pragma Import( C, MUI_Redraw, "MUI_Redraw");
function MUI_CreateCustomClass(base : Library_Ptr ;supername : Chars_Ptr;supermcc : MUI_CustomClass_Ptr ;datasize : Integer;dispatcher : Integer_Ptr) return MUI_CustomClass_Ptr;
pragma Import( C, MUI_CreateCustomClass, "MUI_CreateCustomClass");
function MUI_DeleteCustomClass(mcc : MUI_CustomClass_Ptr) return Boolean;
pragma Import( C, MUI_DeleteCustomClass, "MUI_DeleteCustomClass");

function MUI_AslRequest (requester : Requester_Ptr; tagList : TagListType) return Boolean;
function MUI_NewObjectA (classname : Chars_Ptr;tags :TagListType) return Object_Ptr;
function MUI_AllocAslRequest (reqType  : Unsigned_32;tagList : TagListType) return Integer_Ptr;
function MUI_MakeObjectA (Object_Type : Unsigned_32;params : Msg) return Object_Ptr;
--
--#define MUIV_Window_AltHeight_MinMax(p) (0-(p))              -- functions ???
--#define MUIV_Window_AltHeight_Visible(p) (-100-(p))
--#define MUIV_Window_AltHeight_Screen(p) (-200-(p))
--#define MUIV_Window_AltTopEdge_Delta(p) (-3-(p))
--#define MUIV_Window_AltWidth_MinMax(p) (0-(p))
--#define MUIV_Window_AltWidth_Visible(p) (-100-(p))
--#define MUIV_Window_AltWidth_Screen(p) (-200-(p))
--#define MUIV_Window_Height_MinMax(p) (0-(p))
--#define MUIV_Window_Height_Visible(p) (-100-(p))
--#define MUIV_Window_Height_Screen(p) (-200-(p))
--#define MUIV_Window_TopEdge_Delta(p) (-3-(p))
--#define MUIV_Window_Width_MinMax(p) (0-(p))
--#define MUIV_Window_Width_Visible(p) (-100-(p))
--#define MUIV_Window_Width_Screen(p) (-200-(p))
--
--/* the following macros can be used to get pointers to an objects
--   GlobalInfo and RenderInfo structures. */
--
--struct __dummyXFC2__
--{
--	struct MUI_NotifyData mnd;
--	struct MUI_AreaData   mad;
--};
--
--#define muiNotifyData(obj) (&(((struct __dummyXFC2__ *)(obj))->mnd))
--#define muiAreaData(obj)   (&(((struct __dummyXFC2__ *)(obj))->mad))
--#define muiGlobalInfo(obj) (((struct __dummyXFC2__ *)(obj))->mnd.mnd_GlobalInfo)
--#define muiUserData(obj)   (((struct __dummyXFC2__ *)(obj))->mnd.mnd_UserData)
--#define muiRenderInfo(obj) (((struct __dummyXFC2__ *)(obj))->mad.mad_RenderInfo)
--
--#define _app(obj)         (muiGlobalInfo(obj)->mgi_ApplicationObject)
--#define _win(obj)         (muiRenderInfo(obj)->mri_WindowObject)
--#define _dri(obj)         (muiRenderInfo(obj)->mri_DrawInfo)
--#define _window(obj)      (muiRenderInfo(obj)->mri_Window)
--#define _screen(obj)      (muiRenderInfo(obj)->mri_Screen)
--#define _rp(obj)          (muiRenderInfo(obj)->mri_RastPort)
--#define _left(obj)        (muiAreaData(obj)->mad_Box.Left)
--#define _top(obj)         (muiAreaData(obj)->mad_Box.Top)
--#define _width(obj)       (muiAreaData(obj)->mad_Box.Width)
--#define _height(obj)      (muiAreaData(obj)->mad_Box.Height)
--#define _right(obj)       (_left(obj)+_width(obj)-1)
--#define _bottom(obj)      (_top(obj)+_height(obj)-1)
--#define _addleft(obj)     (muiAreaData(obj)->mad_addleft  )
--#define _addtop(obj)      (muiAreaData(obj)->mad_addtop   )
--#define _subwidth(obj)    (muiAreaData(obj)->mad_subwidth )
--#define _subheight(obj)   (muiAreaData(obj)->mad_subheight)
--#define _mleft(obj)       (_left(obj)+_addleft(obj))
--#define _mtop(obj)        (_top(obj)+_addtop(obj))
--#define _mwidth(obj)      (_width(obj)-_subwidth(obj))
--#define _mheight(obj)     (_height(obj)-_subheight(obj))
--#define _mright(obj)      (_mleft(obj)+_mwidth(obj)-1)
--#define _mbottom(obj)     (_mtop(obj)+_mheight(obj)-1)
--#define _font(obj)        (muiAreaData(obj)->mad_Font)
--#define _flags(obj)       (muiAreaData(obj)->mad_Flags)
--
--function HVSpace  return Object_Ptr;
--         MUI_NewObject(MUIC_Rectangle,TAG_DONE)
--function HSpace(x : Natural)  return Object_Ptr;
--       MUI_MakeObject(MUIO_HSpace,x)
--function VSpace(x : Natural)  return Object_Ptr;
--       MUI_MakeObject(MUIO_VSpace,x)
--function HCenter(obj : Object_Ptr)  return Object_Ptr;
--    MUI_NewObject(MUIC_Group,MUIA_Group_Horiz, 1, MUIA_Group_Spacing, 0, MUIA_Group_Child, MUI_MakeObject(MUIO_HSpace,0), MUIA_Group_Child, (obj), MUIA_Group_Child, MUI_MakeObject(MUIO_HSpace,0), TAG_DONE)
--function VCenter(obj : Object_Ptr)  return Object_Ptr;
--    MUI_NewObject(MUIC_Group, MUIA_Group_Spacing, 0, MUIA_Group_Child, MUI_MakeObject(MUIO_VSpace,0), MUIA_Group_Child, (obj), MUIA_Group_Child, MUI_MakeObject(MUIO_VSpace,0), TAD_DONE)
--function SimpleButton(label : Chars_Ptr) return Object_Ptr;
--MUI_MakeObject(MUIO_Button,label)
--function PopButton(img) return Object_Ptr;
--MUI_MakeObject(MUIO_PopButton,img)
--function Label(label : Chars_Ptr)  return Object_Ptr;
-- MUI_MakeObject(MUIO_Label,label,0)
--function Label1(label : Chars_Ptr)  return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_SingleFrame)
--function Label2(label : Chars_Ptr)  return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_DoubleFrame)
--function LLabel(label : Chars_Ptr)  return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned)
--function LLabel1(label : Chars_Ptr) return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned+MUIO_Label_SingleFrame)
--function LLabel2(label : Chars_Ptr) return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned+MUIO_Label_DoubleFrame)

--function KeyLabel(label : Chars_Ptr ,key)  return Object_Ptr;
-- MUI_MakeObject(MUIO_Label,label,key)
--function KeyLabel1(label : Chars_Ptr,key)  return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_SingleFrame+(key))
--function KeyLabel2(label : Chars_Ptr,key)  return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_DoubleFrame+(key))
--function KeyLLabel(label : Chars_Ptr,key)  return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned+(key))
--function KeyLLabel1(label : Chars_Ptr,key) return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned+MUIO_Label_SingleFrame+(key))
--function KeyLLabel2(label : Chars_Ptr,key) return Object_Ptr;
--MUI_MakeObject(MUIO_Label,label,MUIO_Label_LeftAligned+MUIO_Label_DoubleFrame+(key))
--function get(obj : Object_Ptr,attr : Unsigned_32,store :Unsigned_32) return Object_Ptr;
--GetAttr(attr,obj,(ULONG *)store)
--function set(obj : Object_Ptr,attr : Unsigned_32,value : Unsigned_32) return Object_Ptr;
--SetAttrs(obj,attr,value,TAG_DONE)
--function nnset(obj : Object_Ptr,attr : Unsigned_32,value : Unsigned_32) return Object_Ptr;
--SetAttrs(obj,MUIA_NoNotify,TRUE,attr,value,TAG_DONE)
--function setmutex(obj : Object_Ptr,n : Boolean)  return Object_Ptr;
--   SetAttrs(obj,MUIA_Radio_Active,n,TAG_DONE)
--function setcycle(obj : Object_Ptr,n : Natural)  return Object_Ptr;
--   SetAttrs(obj,MUIA_Cycle_Active,n,TAG_DONE)
--function setstring(obj : Object_Ptr,s : Chars_Ptr)  return Object_Ptr;
--  SetAttrs(obj,MUIA_String_Contents,s,TAG_DONE)
--function setcheckmark(obj : Object_Ptr,b : Boolean) return Object_Ptr;
--SetAttrs(obj,MUIA_Selected,b,TAG_DONE)
--function setslider(obj : Object_Ptr,l : Natural)  return Object_Ptr;
--  SetAttrs(obj,MUIA_Slider_Level,l,TAG_DONE)

end mui;