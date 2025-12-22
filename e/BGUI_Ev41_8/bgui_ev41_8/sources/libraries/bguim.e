OPT MODULE
OPT EXPORT
OPT PREPROCESS

/* -- Corrected by Daniel Kasmeroglu:                          -- *
 * --                                                          -- *
 * --    1. Tags from the system-modules were spelled like the -- *
 * --       ones of the BGUI.library but they all were written -- *
 * --       in upper case letters.                             -- *
 * --    2. Some Tags for the view-object are missed and some  -- *
 * --       has had a fault value.                             -- *
 * --                                                   Deekah -- */


/*  $VER: libraries/bgui_macros.e 41.8 (01.02.97)
**
**  bgui.library macros
**
**  (C) Copyright 1996-1997 Ian J. Einman.
**  (C) Copyright 1993-1996 Jaba Development.
**  (C) Copyright 1993-1996 Jan van den Baard.
**  (C) Copyright 1996-1997 Dominique Dutoit
**  All Rights Reserved.
**/
CONST   BGUIMACROVERSION        = 41
CONST   MACROS4BGUIVERSION      = 41
/*      General object creation macros.   */
#define LabelObject             BgUI_NewObjectA( BGUI_LABEL_IMAGE,      [ TAG_IGNORE, 0
#define FrameObject             BgUI_NewObjectA( BGUI_FRAME_IMAGE,      [ TAG_IGNORE, 0
#define VectorObject            BgUI_NewObjectA( BGUI_VECTOR_IMAGE,     [ TAG_IGNORE, 0

#define HGroupObject            BgUI_NewObjectA( BGUI_GROUP_GADGET,     [ TAG_IGNORE, 0
#define VGroupObject            BgUI_NewObjectA( BGUI_GROUP_GADGET,     [ GROUP_Style, GRSTYLE_VERTICAL
#define ButtonObject            BgUI_NewObjectA( BGUI_BUTTON_GADGET,    [ TAG_IGNORE, 0
#define ToggleObject            BgUI_NewObjectA( BGUI_BUTTON_GADGET,    [ GA_TOGGLESELECT, TRUE
#define CycleObject             BgUI_NewObjectA( BGUI_CYCLE_GADGET,     [ TAG_IGNORE, 0
#define CheckBoxObject          BgUI_NewObjectA( BGUI_CHECKBOX_GADGET,  [ TAG_IGNORE, 0
#define InfoObject              BgUI_NewObjectA( BGUI_INFO_GADGET,      [ TAG_IGNORE, 0
#define StringObject            BgUI_NewObjectA( BGUI_STRING_GADGET,    [ TAG_IGNORE, 0
#define PropObject              BgUI_NewObjectA( BGUI_PROP_GADGET,      [ TAG_IGNORE, 0
#define IndicatorObject         BgUI_NewObjectA( BGUI_INDICATOR_GADGET, [ TAG_IGNORE, 0
#define ProgressObject          BgUI_NewObjectA( BGUI_PROGRESS_GADGET,  [ TAG_IGNORE, 0
#define SliderObject            BgUI_NewObjectA( BGUI_SLIDER_GADGET,    [ TAG_IGNORE, 0
#define PageObject              BgUI_NewObjectA( BGUI_PAGE_GADGET,      [ TAG_IGNORE, 0
#define MxObject                BgUI_NewObjectA( BGUI_MX_GADGET,        [ TAG_IGNORE, 0
#define ListviewObject          BgUI_NewObjectA( BGUI_LISTVIEW_GADGET,  [ TAG_IGNORE, 0
#define ExternalObject          BgUI_NewObjectA( BGUI_EXTERNAL_GADGET,  [ GA_LEFT, 0, GA_TOP, 0, GA_WIDTH, 0, GA_HEIGHT, 0
#define SeparatorObject         BgUI_NewObjectA( BGUI_SEPARATOR_GADGET, [ TAG_IGNORE, 0
#define AreaObject              BgUI_NewObjectA( BGUI_AREA_GADGET,      [ TAG_IGNORE, 0
#define ViewObject              BgUI_NewObjectA(BGUI_VIEW_GADGET,       [ TAG_IGNORE, 0
#define PaletteObject           BgUI_NewObjectA(BGUI_PALETTE_GADGET,    [ TAG_IGNORE, 0
#define PopButtonObject         BgUI_NewObjectA(BGUI_POPBUTTON_GADGET,  [ TAG_IGNORE, 0

#define WindowObject            BgUI_NewObjectA( BGUI_WINDOW_OBJECT,    [ TAG_IGNORE, 0
#define FileReqObject           BgUI_NewObjectA( BGUI_FILEREQ_OBJECT,   [ TAG_IGNORE, 0
#define FontReqObject           BgUI_NewObjectA( BGUI_FONTREQ_OBJECT,   [ TAG_IGNORE, 0
#define ScreenReqObject         BgUI_NewObjectA( BGUI_SCREENREQ_OBJECT, [ TAG_IGNORE, 0
#define CommodityObject         BgUI_NewObjectA( BGUI_COMMODITY_OBJECT, [ TAG_IGNORE, 0
#define ARexxObject             BgUI_NewObjectA( BGUI_AREXX_OBJECT,     [ TAG_IGNORE, 0
#define EndObject               TAG_END ] )

/* Typo */
#define SeperatorObject         SeparatorObject

/* Label Creation */
#define Label( l )              LAB_Label, l
#define UScoreLabel( l, u )     LAB_Label, l, LAB_Underscore, u
#define Style( s )              LAB_Style, s
#define Place( p )              LAB_Place, p

/* Frames */
#define ButtonFrame             FRM_Type, FRTYPE_BUTTON
#define RidgeFrame              FRM_Type, FRTYPE_RIDGE
#define DropBoxFrame            FRM_Type, FRTYPE_DROPBOX
#define NeXTFrame               FRM_Type, FRTYPE_NEXT
#define RadioFrame              FRM_Type, FRTYPE_RADIOBUTTON
#define XenFrame                FRM_Type, FRTYPE_XEN_BUTTON
#define TabAboveFrame           FRM_Type, FRTYPE_TAB_ABOVE
#define TabBelowFrame           FRM_Type, FRTYPE_TAB_BELOW
#define BorderFrame             FRM_Type, FRTYPE_BORDER
#define FuzzButtonFrame         FRM_Type, FRTYPE_FUZZ_BUTTON
#define FuzzRidgeFrame          FRM_Type, FRTYPE_FUZZ_RIDGE
#define NoFrame                 FRM_Type, FRTYPE_NONE
#define DefaultFrame            FRM_Type, FRTYPE_DEFAULT

/* For clarity */
#define StringFrame             RidgeFrame
#define MxFrame                 RadioFrame

#define FrameTitle(t)           FRM_Title, t

/* Built-in back fills */
#define ShineRaster             FRM_BackFill, SHINE_RASTER
#define ShadowRaster            FRM_BackFill, SHADOW_RASTER
#define ShineShadowRaster       FRM_BackFill, SHINE_SHADOW_RASTER
#define FillRaster              FRM_BackFill, FILL_RASTER
#define ShineFillRaster         FRM_BackFill, SHINE_FILL_RASTER
#define ShadowFillRaster        FRM_BackFill, SHADOW_FILL_RASTER
#define ShineBlock              FRM_BackFill, SHINE_BLOCK
#define ShadowBlock             FRM_BackFill, SHADOW_BLOCK

/* Vector image */
#define GetPath                 VIT_BuiltIn, BUILTIN_GETPATH
#define GetFile                 VIT_BuiltIn, BUILTIN_GETFILE
#define CheckMark               VIT_BuiltIn, BUILTIN_CHECKMARK
#define PopUp                   VIT_BuiltIn, BUILTIN_POPUP
#define ArrowUp                 VIT_BuiltIn, BUILTIN_ARROW_UP
#define ArrowDown               VIT_BuiltIn, BUILTIN_ARROW_DOWN
#define ArrowLeft               VIT_BuiltIn, BUILTIN_ARROW_LEFT
#define ArrowRight              VIT_BuiltIn, BUILTIN_ARROW_RIGHT

/* Group class macros */
#define StartMember             GROUP_Member
#define EndMember               TAG_END, 0
#define Spacing(p)              GROUP_Spacing, p
#define Offset(p)               GROUP_Offset, p
#define HOffset(p)              GROUP_HorizOffset, p
#define VOffset(p)              GROUP_VertOffset, p
#define LOffset(p)              GROUP_LeftOffset, p
#define ROffset(p)              GROUP_RightOffset, p
#define TOffset(p)              GROUP_TopOffset, p
#define BOffset(p)              GROUP_BottomOffset, p
#define VarSpace(w)             GROUP_SpaceObject, w
#define EqualWidth              GROUP_EqualWidth, TRUE
#define EqualHeight             GROUP_EqualHeight, TRUE

#define NormalSpacing           GROUP_Spacing, GRSPACE_NORMAL
#define NormalHOffset           GROUP_HorizOffset, GRSPACE_NORMAL
#define NormalVOffset           GROUP_VertOffset, GRSPACE_NORMAL
#define NarrowSpacing           GROUP_Spacing, GRSPACE_NARROW
#define NarrowHOffset           GROUP_HorizOffset, GRSPACE_NARROW
#define NarrowVOffset           GROUP_VertOffset, GRSPACE_NARROW
#define WideSpacing             GROUP_Spacing, GRSPACE_WIDE
#define WideHOffset             GROUP_HorizOffset, GRSPACE_WIDE
#define WideVOffset             GROUP_VertOffset, GRSPACE_WIDE
#define NormalOffset            NormalHOffset, NormalVOffset

/* Layout macros */
#define FixMinWidth             LGO_FixMinWidth, TRUE
#define FixMinHeight            LGO_FixMinHeight, TRUE
#define Weight(w)               LGO_Weight, w
#define FixWidth(w)             LGO_FixWidth, w
#define FixHeight(h)            LGO_FixHeight, h
#define Align                   LGO_Align, TRUE
#define FixMinSize              FixMinWidth, FixMinHeight
#define FixSize(w,h)            FixWidth(w), FixHeight(h)
#define NoAlign                 LGO_NoAlign, TRUE
#define FixAspect(x,y)          LGO_FixAspect, ( (Shl(x,16)) OR (y) )

/* Page class macros */
#define PageMember              PAGE_Member

/* "Quick" button creation macros */
#define PrefButton(label,id)\
		ButtonObject,\
				LAB_Label,          label,\
				GA_ID,              id,\
		EndObject

#define Button(label,id)\
		ButtonObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				ButtonFrame,\
		EndObject

#define GetPathButton(id)\
		ButtonObject,\
				GetPath,\
				GA_ID,                  id,\
				ButtonFrame,\
		EndObject, FixMinWidth

#define GetFileButton(id)\
		ButtonObject,\
				GetFile,\
				GA_ID,                  id,\
				ButtonFrame,\
		EndObject, FixMinWidth

#define PopupButton(id)\
		ButtonObject,\
				VIT_BuiltIn,            BUILTIN_POPUP,\
				GA_ID,                  id,\
				ButtonFrame,\
		EndObject, FixMinWidth

#define KeyButton(label,id)   Button(label,id)

#define PrefToggle(label,state,id)\
		ToggleObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				GA_SELECTED,            state,\
		EndObject

#define Toggle(label,state,id)\
		ToggleObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				GA_SELECTED,            state,\
				ButtonFrame,\
		EndObject

#define KeyToggle(label,state,id)   Toggle(label,state,id)

#define XenButton(label,id)\
		ButtonObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				XenFrame,\
		EndObject

#define XenKeyButton(label,id)    XenButton(label,id)

#define XenToggle(label,state,id)\
		ToggleObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				GA_SELECTED,            state,\
				XenFrame,\
		EndObject

#define XenKeyToggle(label,state,id)    XenToggle(label,state,id)

/* "Quick" cycle creation macros. */
#define PrefCycle(label,labels,active,id)\
		CycleObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				CYC_Labels,             labels,\
				CYC_Active,             active,\
		EndObject

#define Cycle(label,labels,active,id)\
		CycleObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				ButtonFrame,\
				CYC_Labels,             labels,\
				CYC_Active,             active,\
				CYC_Popup,              FALSE,\
		EndObject

#define KeyCycle(label,labels,active,id)    Cycle(label,labels,active,id)

#define XenCycle(label,labels,active,id)\
		CycleObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				XenFrame,\
				CYC_Labels,             labels,\
				CYC_Active,             active,\
				CYC_Popup,              FALSE,\
		EndObject

#define XenKeyCycle(label,labels,active,id)     XenCycle(label,labels,active,id)

#define PopCycle(label,labels,active,id)\
		CycleObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				ButtonFrame,\
				CYC_Labels,             labels,\
				CYC_Active,             active,\
				CYC_PopUp,              TRUE,\
		EndObject

#define KeyPopCycle(label,labels,active,id)     PopCycle(label,labels,active,id)

#define XenPopCycle(label,labels,active,id)\
		CycleObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				XenFrame,\
				CYC_Labels,             labels,\
				CYC_Active,             active,\
				CYC_PopUp,              TRUE,\
		EndObject

#define XenKeyPopCycle(label,labels,active,id)      XenPopCycle(label,labels,active,id)

/* "Quick" checkbox creation macros. */
#define PrefCheckBoxNF(label,state,id)\
		CheckBoxObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				GA_SELECTED,            state,\
		EndObject, FixMinSize

#define CheckBoxNF(label,state,id)\
		CheckBoxObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				GA_SELECTED,            state,\
		EndObject, FixMinSize

#define XenCheckBoxNF(label,state,id)\
		CheckBoxObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				XenFrame,\
				GA_SELECTED,            state,\
		EndObject, FixMinSize

#define PrefCheckBox(label,state,id) PrefCheckBoxNF(label,state,id), FixMinSize
#define CheckBox(label,state,id)     CheckBoxNF(label,state,id), FixMinSize
#define XenCheckBox(label,state,id)  XenCheckBoxNF(label,state,id), FixMinSize

#define KeyCheckBoxNF(label,state,id)    CheckBoxNF(label,state,id)
#define XenKeyCheckBoxNF(label,state,id) XenCheckBoxNF(label,state,id)
#define KeyCheckBox(label,state,id)      CheckBox(label,state,id)
#define XenKeyCheckBo(label,state,id)x   XenCheckBox(label,state,id)

/* "Quick" info object creation macros. */
#define PrefInfoFixed(label,text,args,numlines)\
		InfoObject,\
				LAB_Label,              label,\
				DefaultFrame,\
				INFO_TextFormat,        text,\
				INFO_Args,              args,\
				INFO_MinLines,          numlines,\
				INFO_FixTextWidth,      TRUE,\
		EndObject

#define PrefInfo(label,text,args,numlines)\
		InfoObject,\
				LAB_Label,              label,\
				DefaultFrame,\
				INFO_TextFormat,        text,\
				INFO_Args,              args,\
				INFO_MinLines,          numlines,\
		EndObject

#define InfoFixed(label,text,args,numlines)\
		InfoObject,\
				LAB_Label,              label,\
				ButtonFrame,\
				FRM_Flags,              FRF_RECESSED,\
				INFO_TextFormat,        text,\
				INFO_Args,              args,\
				INFO_MinLines,          numlines,\
				INFO_FixTextWidth,      TRUE,\
		EndObject

#define InfoObj(label,text,args,numlines)\
		InfoObject,\
				LAB_Label,              label,\
				ButtonFrame,\
				FRM_Flags,              FRF_RECESSED,\
				INFO_TextFormat,        text,\
				INFO_Args,              args,\
				INFO_MinLines,          numlines,\
		EndObject

/* "Quick" string/integer creation macros. */

#define PrefString(label,contents,maxchars,id)\
		StringObject,\
				LAB_Label,              label,\
				STRINGA_TEXTVAL,        contents,\
				STRINGA_MAXCHARS,       maxchars,\
				GA_ID,                  id,\
				GA_TABCYCLE,            TRUE,\
		EndObject

#define StringG(label,contents,maxchars,id)\
		StringObject,\
				LAB_Label,              label,\
				RidgeFrame,\
				STRINGA_TEXTVAL,        contents,\
				STRINGA_MAXCHARS,       maxchars,\
				GA_ID,                  id,\
		EndObject

#define TabString(label,contents,maxchars,id)\
		StringObject,\
				LAB_Label,              label,\
				RidgeFrame,\
				STRINGA_TEXTVAL,        contents,\
				STRINGA_MAXCHARS,       maxchars,\
				GA_ID,                  id,\
				GA_TABCYCLE,            TRUE,\
		EndObject

#define PrefInteger(label,contents,maxchars,id)\
		StringObject,\
				LAB_Label,              label,\
				STRINGA_LONGVAL,        contents,\
				STRINGA_MAXCHARS,       maxchars,\
				GA_ID,                  id,\
				GA_TABCYCLE,            TRUE,\
		EndObject

#define Integer(label,contents,maxchars,id)\
		StringObject,\
				LAB_Label,              label,\
				RidgeFrame,\
				STRINGA_LONGVAL,        contents,\
				STRINGA_MAXCHARS,       maxchars,\
				GA_ID,                  id,\
		EndObject

#define TabInteger(label,contents,maxchars,id)\
		StringObject,\
				LAB_Label,              label,\
				RidgeFrame,\
				STRINGA_LONGVAL,        contents,\
				STRINGA_MAXCHARS,       maxchars,\
				GA_ID,                  id,\
				GA_TABCYCLE,            TRUE,\
		EndObject

#define KeyString(label,contents,maxchars,id)       StringG(label,contents,maxchars,id)
#define TabKeyString(label,contents,maxchars,id)    TabString(label,contents,maxchars,id)
#define KeyInteger(label,contents,maxchars,id)      Integer(label,contents,maxchars,id)
#define TabKeyInteger(label,contents,maxchars,id)   TabInteger(label,contents,maxchars,id)

/* STRINGA_PENS & STRINGA_ACTIVEPENS pen-pack macro */
#define PACKPENS( a, b) (((Shl( b, 8) AND $FF00) OR (( a ) AND $00FF))

/* "Quick" scroller creation macros. */
#define HorizScroller(label,top,total,visible,id)\
		PropObject,\
				LAB_Label,              label,\
				PGA_TOP,                top,\
				PGA_TOTAL,              total,\
				PGA_VISIBLE,            visible,\
				PGA_FREEDOM,            FREEHORIZ,\
				GA_ID,                  id,\
				PGA_Arrows,             TRUE,\
		EndObject

#define VertScroller(label,top,total,visible,id)\
		PropObject,\
				LAB_Label,              label,\
				PGA_TOP,                top,\
				PGA_TOTAL,              total,\
				PGA_VISIBLE,            visible,\
				GA_ID,                  id,\
				PGA_Arrows,             TRUE,\
		EndObject

#define KeyHorizScroller(label,top,total,visible,id)    HorizScroller(label,top,total,visible,id)
#define KeyVertScroller(label,top,total,visible,id)     VertScroller(label,top,total,visible,id)

/* "Quick" indicator creation macros. */
#define Indicator(min,max,level,just)\
		IndicatorObject,\
				INDIC_Min,              min,\
				INDIC_Max,              max,\
				INDIC_Level,            level,\
				INDIC_Justification,    just,\
		EndObject

#define IndicatorFormat(min,max,level,just,format)\
		IndicatorObject,\
				INDIC_Min,              min,\
				INDIC_Max,              max,\
				INDIC_Level,            level,\
				INDIC_Justification,    just,\
				INDIC_FormatString,     format,\
		EndObject

/* "Quick" progress creation macros. */
#define HorizProgress(label,min,max,done)\
		ProgressObject,\
				LAB_Label,              label,\
				ButtonFrame,\
				FRM_Flags,              FRF_RECESSED,\
				PROGRESS_Min,           min,\
				PROGRESS_Max,           max,\
				PROGRESS_Done,          done,\
		EndObject

#define VertProgress(label,min,max,done)\
		ProgressObject,\
				LAB_Label,              label,\
				ButtonFrame,\
				FRM_Flags,              FRF_RECESSED,\
				PROGRESS_Min,           min,\
				PROGRESS_Max,           max,\
				PROGRESS_Done,          done,\
				PROGRESS_Vertical,      TRUE,\
		EndObject

#define HorizProgressFS(label,min,max,done,fstr)\
		ProgressObject,\
				LAB_Label,              label,\
				ButtonFrame,\
				FRM_Flags,              FRF_RECESSED,\
				PROGRESS_Min,           min,\
				PROGRESS_Max,           max,\
				PROGRESS_Done,          done,\
				PROGRESS_FormatString,  fstr,\
		EndObject

#define VertProgressFS(label,min,max,done,fstr)\
		ProgressObject,\
				LAB_Label,              label,\
				ButtonFrame,\
				FRM_Flags,              FRF_RECESSED,\
				PROGRESS_Min,           min,\
				PROGRESS_Max,           max,\
				PROGRESS_Done,          done,\
				PROGRESS_Vertical,      TRUE,\
				PROGRESS_FormatString,  fstr,\
		EndObject

/* "Quick" slider creation macros. */
#define HorizSlider(label,min,max,level,id)\
		SliderObject,\
				LAB_Label,              label,\
				SLIDER_Min,             min,\
				SLIDER_Max,             max,\
				SLIDER_Level,           level,\
				GA_ID,                  id,\
		EndObject

#define VertSlider(label,min,max,level,id)\
		SliderObject,\
				LAB_Label,              label,\
				SLIDER_Min,             min,\
				SLIDER_Max,             max,\
				SLIDER_Level,           level,\
				PGA_FREEDOM,            FREEVERT,\
				GA_ID,                  id,\
		EndObject

#define KeyHorizSlider HorizSlider
#define KeyVertSlider  VertSlider

/* "Quick" mx creation macros. */
#define PrefMx(label,labels,active,id)\
		MxObject,\
				GROUP_Style,            GRSTYLE_VERTICAL,\
				LAB_Label,              label,\
				MX_Labels,              labels,\
				MX_Active,              active,\
				GA_ID,                  id,\
		EndObject, FixMinSize

#define RightMx(label,labels,active,id)\
		MxObject,\
				GROUP_Style,            GRSTYLE_VERTICAL,\
				LAB_Label,              label,\
				MX_Labels,              labels,\
				MX_Active,              active,\
				MX_LabelPlace,          PLACE_RIGHT,\
				GA_ID,                  id,\
		EndObject, FixMinSize

#define LeftMx(label,labels,active,id)\
		MxObject,\
				GROUP_Style,            GRSTYLE_VERTICAL,\
				LAB_Label,              label,\
				MX_Labels,              labels,\
				MX_Active,              active,\
				MX_LabelPlace,          PLACE_LEFT,\
				GA_ID,                  id,\
		EndObject, FixMinSize

#define Tabs(label,labels,active,id)\
		MxObject,\
				MX_TabsObject,          TRUE,\
				LAB_Label,              label,\
				MX_Labels,              labels,\
				MX_Active,              active,\
				GA_ID,                  id,\
		EndObject, FixMinHeight


#define TabsEqual(label,labels,active,id)\
		MxObject,\
				GROUP_EqualWidth,       TRUE,\
				MX_TabsObject,          TRUE,\
				LAB_Label,              label,\
				MX_Labels,              labels,\
				MX_Active,              active,\
				GA_ID,                  id,\
		EndObject, FixMinHeight

#define USDTabs(label,labels,active,id)\
		MxObject,\
				MX_TabsObject,          TRUE,\
				LAB_Label,              label,\
				MX_Labels,              labels,\
				MX_Active,              active,\
				MX_TabsUpsideDown,      TRUE,\
				GA_ID,                  id,\
		EndObject, FixMinHeight

#define USDTabsEqual(label,labels,active,id)\
		MxObject,\
				GROUP_EqualWidth,       TRUE,\
				MX_TabsObject,          TRUE,\
				LAB_Label,              label,\
				MX_Labels,              labels,\
				MX_Active,              active,\
				MX_TabsUpsideDown,      TRUE,\
				GA_ID,                  id,\
		EndObject, FixMinHeight

#define RightMxKey(label,labels,active,id)          RightMx(label,labels,active,id)
#define LeftMxKey(label,labels,active,id)           LeftMx(label,labels,active,id)
#define TabsKey(label,labels,active,id)             Tabs(label,labels,active,id)
#define TabsEqualKey(label,labels,active,id)        TabsEqual(label,labels,active,id)
#define USDTabsKey(label,labels,active,id)          USDTabs(label,labels,active,id)
#define USDTabsEqualKey(label,labels,active,id)     USDTabsEqual(label,labels,active,id)

/* "Quick" listview creation macros. */
#define StrListview(label,strings,id)\
		ListviewObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				LISTV_EntryArray,       strings,\
		EndObject

#define StrListviewSorted(label,strings,id)\
		ListviewObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				LISTV_EntryArray,       strings,\
				LISTV_SortEntryArray,   TRUE,\
		EndObject

#define ReadStrListview(label,strings)\
		ListviewObject,\
				LAB_Label,              label,\
				LISTV_EntryArray,       strings,\
				LISTV_ReadOnly,         TRUE,\
		EndObject

#define ReadStrListviewSorted(label,strings)\
		ListviewObject,\
				LAB_Label,              label,\
				LISTV_EntryArray,       strings,\
				LISTV_SortEntryArray,   TRUE,\
				LISTV_ReadOnly,         TRUE,\
		EndObject

#define MultiStrListview(label,strings,id)\
		ListviewObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				LISTV_EntryArray,       strings,\
				LISTV_MultiSelect,      TRUE,\
		EndObject

#define MultiStrListviewSorted(label,strings,id)\
		ListviewObject,\
				LAB_Label,              label,\
				GA_ID,                  id,\
				LISTV_EntryArray,       strings,\
				LISTV_SortEntryArray,   TRUE,\
				LISTV_MultiSelect,      TRUE,\
		EndObject

/* "Quick" separator bar creation macros. */
#define VertSeparator\
		SeperatorObject,\
		EndObject, FixMinWidth

#define VertThinSeparator\
		SeperatorObject,\
				SEP_Thin,               TRUE,\
		EndObject, FixMinWidth

#define HorizSeparator\
		SeperatorObject,\
				SEP_Horiz,              TRUE,\
		EndObject, FixMinHeight

#define TitleSeparator(t)\
		SeperatorObject,\
				SEP_Horiz,              TRUE,\
				SEP_Title,              t,\
		EndObject, FixMinHeight

#define HTitleSeparator(t)\
		SeperatorObject,\
				SEP_Horiz,              TRUE,\
				SEP_Title,              t,\
				SEP_Highlight,          TRUE,\
		EndObject, FixMinHeight

#define CTitleSeparator(t)\
		SeperatorObject,\
				SEP_Horiz,              TRUE,\
				SEP_Title,              t,\
				SEP_CenterTitle,        TRUE,\
		EndObject, FixMinHeight

#define CHTitleSeparator(t)\
		SeperatorObject,\
				SEP_Horiz,              TRUE,\
				SEP_Title,              t,\
				SEP_Highlight,          TRUE,\
				SEP_CenterTitle,        TRUE,\
		EndObject, FixMinHeight

#define TitleSeparatorLeft(t)\
		SeperatorObject,\
				SEP_Horiz,              TRUE,\
				SEP_Title,              t,\
				SEP_TitleLeft,          TRUE,\
		EndObject, FixMinHeight

#define HTitleSeparatorLeft(t)\
		SeperatorObject,\
				SEP_Horiz,              TRUE,\
				SEP_Title,              t,\
				SEP_Highlight,          TRUE,\
				SEP_TitleLeft,          TRUE,\
		EndObject, FixMinHeight

#define CTitleSeparatorLeft(t)\
		SeperatorObject,\
				SEP_Horiz,              TRUE,\
				SEP_Title,              t,\
				SEP_CenterTitle,        TRUE,\
				SEP_TitleLeft,          TRUE,\
		EndObject, FixMinHeight

#define CHTitleSeparatorLeft(t)\
		SeperatorObject,\
				SEP_Horiz,              TRUE,\
				SEP_Title,              t,\
				SEP_Highlight,          TRUE,\
				SEP_CenterTitle,        TRUE,\
				SEP_TitleLeft,          TRUE,\
		EndObject, FixMinHeight

/* Typos */
#define VertSeperator           VertSeparator
#define VertThinSeperator       VertThinSeparator
#define HorizSeperator          HorizSeparator
#define TitleSeperator          TitleSeparator
#define HTitleSeperator         HTitleSeparator
#define CTitleSeperator         CTitleSeparator
#define CHTitleSeperator        CHTitleSeparator

/* Some simple menu macros */
#define StartMenu              [ NM_IGNORE, 0, 0, NIL, 0, 0, NIL
#define Title(t)                 NM_TITLE, 0, t, NIL, 0, 0, NIL
#define Item(t,s,i)              NM_ITEM, 0, t, s, 0, 0, i
#define ItemBar                  NM_ITEM, 0, NM_BARLABEL, NIL, 0, 0, NIL
#define SubItem(t,s,i)           NM_SUB, 0, t, s, 0, 0, i
#define SubBar                   NM_SUB, 0, NM_BARLABEL, NIL, 0, 0, NIL
#define End                      NM_END, 0, NIL, NIL, 0, 0, NIL ]:newmenu

/* Some object macros */
#define AbleObject(win,object,value)\
		SetGadgetAttrsA(object,win,NIL,[GA_DISABLED,value,TAG_DONE])

#define DisableObject(win,object)\
		AbleObject(win,object,TRUE)

#define EnableObject(win,object)\
		AbleObject(win,object,FALSE)

/* Base class method macros. */
#define AddMap(object,target,map)\
		domethod( object, [ BASE_ADDMAP, target, map ] )

#define AddCondit(object,target,ttag,tdat,ftag,fdat,stag,sdat)\
		domethod( object, [ BASE_ADDCONDITIONAL, target,\
				  ttag, tdat,\
				  ftag, fdat,\
				  stag, sdat ] )

#define AddHook(object,hook)\
		domethod( object, [ BASE_ADDHOOK, hook ] )

#define RemMap(object,target)\
		domethod( object, [ BASE_REMMAP, target  ] )

#define RemCondit(object,target)\
		domethod( object, [ BASE_REMCONDITIONAL, target ] )

#define RemHook( object,hook)\
		domethod( object, [ BASE_REMHOOK, hook ] )

/* Listview class method macros. */
#define AddEntry(window,object,entry,how)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_ADDSINGLE,\
							 NIL, entry, how, 0 ] )

#define AddEntryVisible(window,object,entry,how)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_ADDSINGLE,\
							 NIL, entry, how, LVASF_MAKEVISIBLE ] )

#define AddEntrySelect(window,object,entry,how)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_ADDSINGLE,\
							 NIL, entry, how, LVASF_SELECT ] )

#define InsertEntry(window,object,entry,where)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_INSERTSINGLE,\
							NIL, where, entry, 0 ] )

#define InsertEntryVisible(window,object,entry,where)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_INSERTSINGLE,\
							 NIL, where, entry, LVASF_MAKEVISIBLE ] )

#define InsertEntrySelect(window,object,entry,where)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_INSERTSINGLE,\
							NIL, where, entry, LVASF_SELECT ] )

#define ClearList(window,object)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_CLEAR, NIL ] )

#define FirstEntry(object)\
		domethod( object, [ LVM_FIRSTENTRY, NIL, 0 ] )

#define FirstSelected(object)\
		domethod( object, [ LVM_FIRSTENTRY, NIL, LVGEF_SELECTED ] )

#define LastEntry(object)\
		domethod( object, [ LVM_LASTENTRY, NIL, 0 ] )

#define LastSelected(object)\
		domethod( object, [ LVM_LASTENTRY, NIL, LVGEF_SELECTED ] )

#define NextEntry(object,last)\
		domethod( object, [ LVM_NEXTENTRY, last, 0 ] )

#define NextSelected(object,last)\
		domethod( object, [ LVM_NEXTENTRY, last, LVGEF_SELECTED ] )

#define PrevEntry(object,last)\
		domethod( object, [ LVM_PREVENTRY, last, 0 ] )

#define PrevSelected(object,last)\
		domethod( object, [ LVM_PREVENTRY, last, LVGEF_SELECTED ] )

#define RemoveEntry(object,entry)\
		domethod( object, [ LVM_REMENTRY, NIL, entry ] )

#define RemoveEntryVisible(window,object,entry)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_REMENTRY, NIL, entry ] )

#define RefreshList(window,object)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_REFRESH, NIL ] )

#define RedrawList(window,object)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_REDRAW, NIL ] )

#define SortList(window,object)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_SORT, NIL ] )

#define LockList(object)\
		domethod( object, [ LVM_LOCKLIST, NIL ] )

#define UnlockList(window,object)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_UNLOCKLIST, NIL ] )

#define MoveEntry(window,object,entry,dir)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_MOVE, NIL,\
							 entry, dir ] )

#define MoveSelectedEntry(window,object,dir)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_MOVE, NIL,\
							 NIL, dir ] )

#define ReplaceEntry(window,object,old,new)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_REPLACE, NIL,\
							 old, new ] )

#define RemoveSelected(window,object)\
		BgUI_DoGadgetMethodA( object, window, NIL, [ LVM_REMSELECTED, NIL ] )

/* Window class method macros. */
#define GadgetKey(wobj,gobj,key)\
		domethod( wobj, [ WM_GADGETKEY, NIL, gobj, key ] )

#define WindowOpen(wobj)\
		domethod( wobj, [ WM_OPEN ] )

#define WindowClose(wobj)\
		domethod( wobj, [ WM_CLOSE ] )

#define WindowBusy(wobj)\
		domethod( wobj, [ WM_SLEEP ] )

#define WindowReady(wobj)\
		domethod( wobj, [ WM_WAKEUP ] )

#define HandleEvent(wobj)\
		domethod( wobj, [ WM_HANDLEIDCMP ] )

#define DisableMenu(wobj,id,set)\
		domethod( wobj, [ WM_DISABLEMENU, id, set ] )

#define CheckItem(wobj,id,set)\
		domethod( wobj, [ WM_CHECKITEM, id, set ] )

#define MenuDisabled(wobj,id)\
		domethod( wobj, [ WM_MENUDISABLED, id ] )

#define ItemChecked(wobj,id)\
		domethod( wobj, [ WM_ITEMCHECKED, id ] )

#define GetAppMsg(wobj)\
		domethod( wobj, [ WM_GETAPPMSG ] )

#define AddUpdate(wobj,id,target,map)\
		domethod( wobj, [ WM_ADDUPDATE, id, target, map ] )

#define GetSignalWindow(wobj)\
		domethod( wobj, [ WM_GET_SIGNAL_WINDOW ] )

/* Commodity class method macros. */
#define AddHotkey(broker,desc,id,flags)\
		domethod( broker, [ CM_ADDHOTKEY, desc, id, flags ] )

#define RemHotkey(broker,id)\
		domethod( broker, [ CM_REMHOTKEY, id ] )

#define DisableHotkey(broker,id)\
		domethod( broker, [ CM_DISABLEHOTKEY, id ] )

#define EnableHotKey(broker,id)\
		domethod( broker, [ CM_ENABLEHOTKEY, id ] )

#define EnableBroker(broker)\
		domethod( broker, [ CM_ENABLEBROKER ] )

#define DisableBroker(broker)\
		domethod( broker, [ CM_DISABLEBROKER ] )

#define MsgInfo(broker,type,id,data)\
		domethod( broker, [ CM_MSGINFO,\
							type,\
							id,\
							data ] )

/* FileReq class method macros. */
#define DoRequest(object)\
		domethod( object, [ ASLM_DOREQUEST ] )
