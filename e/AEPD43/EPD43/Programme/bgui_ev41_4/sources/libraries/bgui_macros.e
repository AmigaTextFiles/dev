OPT MODULE
OPT EXPORT
OPT PREPROCESS
/*  $VER: libraries/bgui_macros.m 41.4 (25.4.96)
**
**  bgui.library macros - by Dominique Dutoit
**
**  (C) Copyright 1996 Ian J. Einman.
**  (C) Copyright 1993-1996 Jaba Development.
**  (C) Copyright 1993-1996 Jan van den Baard.
**  All Rights Reserved.
**/
CONST   BGUIMACROVERSION        = 41
CONST   MACROS4BGUIVERSION      = 41
/*      General object creation macros.   */
#define LabelObject             BgUI_NewObjectA( BGUI_LABEL_IMAGE,      [ TAG_IGNORE, 0
#define FrameObject             BgUI_NewObjectA( BGUI_FRAME_IMAGE,      [ TAG_IGNORE, 0
#define VectorObject            BgUI_NewObjectA( BGUI_VECTOR_IMAGE,     [ TAG_IGNORE, 0
#define HGroupObject            BgUI_NewObjectA( BGUI_GROUP_GADGET,     [ TAG_IGNORE, 0
#define VGroupObject            BgUI_NewObjectA( BGUI_GROUP_GADGET,     [ GROUP_STYLE, GRSTYLE_VERTICAL
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
#define WindowObject            BgUI_NewObjectA( BGUI_WINDOW_OBJECT,    [ TAG_IGNORE, 0
#define FileReqObject           BgUI_NewObjectA( BGUI_FILEREQ_OBJECT,   [ TAG_IGNORE, 0
#define CommodityObject         BgUI_NewObjectA( BGUI_COMMODITY_OBJECT, [ TAG_IGNORE, 0
#define EndObject               TAG_END ] )
/* Typo */
#define SeperatorObject         SeparatorObject
/* Label Creation */
#define Label( l )              LAB_LABEL, l
#define UScoreLabel( l, u )     LAB_LABEL, l, LAB_UNDERSCORE, u
#define Style( s )              LAB_STYLE, s
#define Place( p )              LAB_PLACE, p
/* Frames */
#define ButtonFrame             FRM_TYPE, FRTYPE_BUTTON
#define RidgeFrame              FRM_TYPE, FRTYPE_RIDGE
#define DropBoxFrame            FRM_TYPE, FRTYPE_DROPBOX
#define NeXTFrame               FRM_TYPE, FRTYPE_NEXT
#define RadioFrame              FRM_TYPE, FRTYPE_RADIOBUTTON
#define XenFrame                FRM_TYPE, FRTYPE_XEN_BUTTON
#define TabAboveFrame           FRM_TYPE, FRTYPE_TAB_ABOVE
#define TabBelowFrame           FRM_TYPE, FRTYPE_TAB_BELOW
#define BorderFrame             FRM_TYPE, FRTYPE_BORDER
#define FuzzButtonFrame         FRM_TYPE, FRTYPE_FUZZ_BUTTON
#define FuzzRidgeFrame          FRM_TYPE, FRTYPE_FUZZ_RIDGE
/* For clarity */
#define StringFrame             RidgeFrame
#define MxFrame                 RadioFrame
#define FrameTitle(t)           FRM_TITLE, t
/* Built-in back fills */
#define ShineRaster             FRM_BACKFILL, SHINE_RASTER
#define ShadowRaster            FRM_BACKFILL, SHADOW_RASTER
#define ShineShadowRaster       FRM_BACKFILL, SHINE_SHADOW_RASTER
#define FillRaster              FRM_BACKFILL, FILL_RASTER
#define ShineFillRaster         FRM_BACKFILL, SHINE_FILL_RASTER
#define ShadowFillRaster        FRM_BACKFILL, SHADOW_FILL_RASTER
#define ShineBlock              FRM_BACKFILL, SHINE_BLOCK
#define ShadowBlock             FRM_BACKFILL, SHADOW_BLOCK
/* Vector image */
#define GetPath                 VIT_BUILTIN, BUILTIN_GETPATH
#define GetFile                 VIT_BUILTIN, BUILTIN_GETFILE
#define CheckMark               VIT_BUILTIN, BUILTIN_CHECKMARK
#define PopUp                   VIT_BUILTIN, BUILTIN_POPUP
#define ArrowUp                 VIT_BUILTIN, BUILTIN_ARROW_UP
#define ArrowDown               VIT_BUILTIN, BUILTIN_ARROW_DOWN
#define ArrowLeft               VIT_BUILTIN, BUILTIN_ARROW_LEFT
#define ArrowRight              VIT_BUILTIN, BUILTIN_ARROW_RIGHT
/* Group class macros */
#define StartMember             GROUP_MEMBER
#define EndMember               TAG_END, 0
#define Spacing(p)              GROUP_SPACING, p
#define HOffset(p)              GROUP_HORIZOFFSET, p
#define VOffset(p)              GROUP_VERTOFFSET, p
#define LOffset(p)              GROUP_LEFTOFFSET, p
#define ROffset(p)              GROUP_RIGHTOFFSET, p
#define TOffset(p)              GROUP_TOPOFFSET, p
#define BOffset(p)              GROUP_BOTTOMOFFSET, p
#define VarSpace(w)             GROUP_SPACEOBJECT, w
#define EqualWidth              GROUP_EQUALWIDTH, TRUE
#define EqualHeight             GROUP_EQUALHEIGHT, TRUE
#define NormalSpacing           GROUP_SPACING, GRSPACE_NORMAL
#define NormalHOffset           GROUP_HORIZOFFSET, GRSPACE_NORMAL
#define NormalVOffset           GROUP_VERTOFFSET, GRSPACE_NORMAL
#define NarrowSpacing           GROUP_SPACING, GRSPACE_NARROW
#define NarrowHOffset           GROUP_HORIZOFFSET, GRSPACE_NARROW,
#define NarrowVOffset           GROUP_VERTOFFSET, GRSPACE_NARROW
#define WideSpacing             GROUP_SPACING, GRSPACE_WIDE
#define WideHOffset             GROUP_HORIZOFFSET, GRSPACE_WIDE
#define WideVOffset             GROUP_VERTOFFSET, GRSPACE_WIDE
#define NormalOffset            NormalHOffset, NormalVOffset
/* Layout macros */
#define FixMinWidth             LGO_FIXMINWIDTH, TRUE
#define FixMinHeight            LGO_FIXMINHEIGHT, TRUE
#define Weight(w)               LGO_WEIGHT, w
#define FixWidth(w)             LGO_FIXWIDTH, w
#define FixHeight(h)            LGO_FIXHEIGHT, h
#define Align                   LGO_ALIGN, TRUE
#define FixMinSize              FixMinWidth, FixMinHeight
#define FixSize(w,h)            FixWidth(w), FixHeight(h)
#define NoAlign                 LGO_NOALIGN, TRUE
#define FixAspect(x,y)          LGO_FIXASPECT, ( (Shl(x,16)) OR (y) )
/* Page class macros */
#define PageMember              PAGE_MEMBER
/* "Quick" button creation macros */
#define PrefButton(label,id)\
        ButtonObject,\
                LAB_LABEL,          label,\
                GA_ID,              id,\
        EndObject
#define Button(label,id)\
        ButtonObject,\
                LAB_LABEL,              label,\
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
                VIT_BUILTIN,            BUILTIN_POPUP,\
                GA_ID,                  id,\
                ButtonFrame,\
        EndObject, FixMinWidth
#define KeyButton(label,id)\
        ButtonObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                ButtonFrame,\
        EndObject
#define PrefToggle(label,state,id)\
        ToggleObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                GA_SELECTED,            state,\
        EndObject
#define Toggle(label,state,id)\
        ToggleObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                GA_SELECTED,            state,\
                ButtonFrame,\
        EndObject
#define KeyToggle(label,state,id)\
        ToggleObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                GA_SELECTED,            state,\
                ButtonFrame,\
        EndObject
#define XenButton(label,id)\
        ButtonObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                XenFrame,\
        EndObject
#define XenKeyButton(label,id)\
        ButtonObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                XenFrame,\
        EndObject
#define XenToggle(label,state,id)\
        ToggleObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                GA_SELECTED,            state,\
                XenFrame,\
        EndObject
#define XenKeyToggle(label,state,id)\
        ToggleObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                GA_SELECTED,            state,\
                XenFrame,\
        EndObject
/* "Quick" cycle creation macros. */
#define PrefCycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
        EndObject
#define Cycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
        EndObject
#define KeyCycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
        EndObject
#define XenCycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_XEN_BUTTON,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
        EndObject
#define XenKeyCycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_XEN_BUTTON,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
        EndObject
#define PrefPopCycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
                CYC_POPUP,              TRUE,\
        EndObject
#define PopCycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
                CYC_POPUP,              TRUE,\
        EndObject
#define KeyPopCycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
                CYC_POPUP,              TRUE,\
        EndObject
#define XenPopCycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_XEN_BUTTON,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
                CYC_POPUP,              TRUE,\
        EndObject
#define XenKeyPopCycle(label,labels,active,id)\
        CycleObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_XEN_BUTTON,\
                CYC_LABELS,             labels,\
                CYC_ACTIVE,             active,\
                CYC_POPUP,              TRUE,\
        EndObject
/* "Quick" checkbox creation macros. */
#define PrefCheckBox(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject, FixMinSize
#define CheckBox(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject, FixMinSize
#define KeyCheckBox(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject, FixMinSize
#define KeyCheckBoxRt(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                LAB_PLACE,              PLACE_RIGHT,\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject, FixMinSize
#define XenCheckBox(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_XEN_BUTTON,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject, FixMinSize
#define XenKeyCheckBox(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_XEN_BUTTON,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject, FixMinSize
#define CheckBoxNF(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject
#define KeyCheckBoxNF(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject
#define XenCheckBoxNF(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_XEN_BUTTON,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject
#define XenKeyCheckBoxNF(label,state,id)\
        CheckBoxObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                GA_ID,                  id,\
                FRM_TYPE,               FRTYPE_XEN_BUTTON,\
                FRM_FLAGS,              FRF_EDGES_ONLY,\
                GA_SELECTED,            state,\
        EndObject
/* "Quick" info object creation macros. */
#define InfoFixed(label,text,args,numlines)\
        InfoObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_RECESSED,\
                INFO_TEXTFORMAT,        text,\
                INFO_ARGS,              args,\
                INFO_MINLINES,          numlines,\
                INFO_FIXTEXTWIDTH,      TRUE,\
        EndObject
#define InfoObj(label,text,args,numlines)\
        InfoObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_RECESSED,\
                INFO_TEXTFORMAT,        text,\
                INFO_ARGS,              args,\
                INFO_MINLINES,          numlines,\
        EndObject
/* "Quick" string/integer creation macros. */
#define PrefStringG(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                STRINGA_TEXTVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
        EndObject
#define StringG(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_RIDGE,\
                STRINGA_TEXTVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
        EndObject
#define KeyString(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                FRM_TYPE,               FRTYPE_RIDGE,\
                STRINGA_TEXTVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
        EndObject
#define TabString(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_RIDGE,\
                STRINGA_TEXTVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
                GA_TABCYCLE,            TRUE,\
        EndObject
#define TabKeyString(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                FRM_TYPE,               FRTYPE_RIDGE,\
                STRINGA_TEXTVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
                GA_TABCYCLE,            TRUE,\
        EndObject
#define PrefInteger(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                STRINGA_LONGVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
        EndObject
#define Integer(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_RIDGE,\
                STRINGA_LONGVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
        EndObject
#define KeyInteger(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                FRM_TYPE,               FRTYPE_RIDGE,\
                STRINGA_LONGVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
        EndObject
#define TabInteger(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_RIDGE,\
                STRINGA_LONGVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
                GA_TABCYCLE,            TRUE,\
        EndObject
#define TabKeyInteger(label,contents,maxchars,id)\
        StringObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                FRM_TYPE,               FRTYPE_RIDGE,\
                STRINGA_LONGVAL,        contents,\
                STRINGA_MAXCHARS,       maxchars,\
                GA_ID,                  id,\
                GA_TABCYCLE,            TRUE,\
        EndObject
/* STRINGA_PENS & STRINGA_ACTIVEPENS pen-pack macro */
#define PackPens( a, b) (((Shl( b, 8) AND $FF00) OR (( a ) AND $00FF))
/* "Quick" scroller creation macros. */
#define HorizScroller(label,top,total,visible,id)\
        PropObject,\
                LAB_LABEL,              label,\
                PGA_TOP,                top,\
                PGA_TOTAL,              total,\
                PGA_VISIBLE,            visible,\
                PGA_FREEDOM,            FREEHORIZ,\
                GA_ID,                  id,\
                PGA_ARROWS,             TRUE,\
        EndObject
#define VertScroller(label,top,total,visible,id)\
        PropObject,\
                LAB_LABEL,              label,\
                PGA_TOP,                top,\
                PGA_TOTAL,              total,\
                PGA_VISIBLE,            visible,\
                GA_ID,                  id,\
                PGA_ARROWS,             TRUE,\
        EndObject
#define KeyHorizScroller(label,top,total,visible,id)\
        PropObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                PGA_TOP,                top,\
                PGA_TOTAL,              total,\
                PGA_VISIBLE,            visible,\
                PGA_FREEDOM,            FREEHORIZ,\
                GA_ID,                  id,\
                PGA_ARROWS,             TRUE,\
        EndObject
#define KeyVertScroller(label,top,total,visible,id)\
        PropObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                PGA_TOP,                top,\
                PGA_TOTAL,              total,\
                PGA_VISIBLE,            visible,\
                GA_ID,                  id,\
                PGA_ARROWS,             TRUE,\
        EndObject
/* "Quick" indicator creation macros. */
#define Indicator(min,max,level,just)\
        IndicatorObject,\
                INDIC_MIN,              min,\
                INDIC_MAX,              max,\
                INDIC_LEVEL,            level,\
                INDIC_JUSTIFICATION,    just,\
        EndObject
#define IndicatorFormat(min,max,level,just,format)\
        IndicatorObject,\
                INDIC_MIN,              min,\
                INDIC_MAX,              max,\
                INDIC_LEVEL,            level,\
                INDIC_JUSTIFICATION,    just,\
                INDIC_FORMATSTRING,     format,\
        EndObject
/* "Quick" progress creation macros. */
#define HorizProgress(label,min,max,done)\
        ProgressObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_RECESSED,\
                PROGRESS_MIN,           min,\
                PROGRESS_MAX,           max,\
                PROGRESS_DONE,          done,\
        EndObject
#define VertProgress(label,min,max,done)\
        ProgressObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_RECESSED,\
                PROGRESS_MIN,           min,\
                PROGRESS_MAX,           max,\
                PROGRESS_DONE,          done,\
                PROGRESS_VERTICAL,      TRUE,\
        EndObject
#define HorizProgressFS(label,min,max,done,fstr)\
        ProgressObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_RECESSED,\
                PROGRESS_MIN,           min,\
                PROGRESS_MAX,           max,\
                PROGRESS_DONE,          done,\
                PROGRESS_FORMATSTRING,  fstr,\
        EndObject
#define VertProgressFS(label,min,max,done,fstr)\
        ProgressObject,\
                LAB_LABEL,              label,\
                FRM_TYPE,               FRTYPE_BUTTON,\
                FRM_FLAGS,              FRF_RECESSED,\
                PROGRESS_MIN,           min,\
                PROGRESS_MAX,           max,\
                PROGRESS_DONE,          done,\
                PROGRESS_VERTICAL,      TRUE,\
                PROGRESS_FORMATSTRING,  fstr,\
        EndObject
/* "Quick" slider creation macros. */
#define HorizSlider(label,min,max,level,id)\
        SliderObject,\
                LAB_LABEL,              label,\
                SLIDER_MIN,             min,\
                SLIDER_MAX,             max,\
                SLIDER_LEVEL,           level,\
                GA_ID,                  id,\
        EndObject
#define VertSlider(label,min,max,level,id)\
        SliderObject,\
                LAB_LABEL,              label,\
                SLIDER_MIN,             min,\
                SLIDER_MAX,             max,\
                SLIDER_LEVEL,           level,\
                PGA_FREEDOM,            FREEVERT,\
                GA_ID,                  id,\
        EndObject
#define KeyHorizSlider(label,min,max,level,id)\
        SliderObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                SLIDER_MIN,             min,\
                SLIDER_MAX,             max,\
                SLIDER_LEVEL,           level,\
                GA_ID,                  id,\
        EndObject
#define KeyVertSlider(label,min,max,level,id)\
        SliderObject,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                SLIDER_MIN,             min,\
                SLIDER_MAX,             max,\
                SLIDER_LEVEL,           level,\
                PGA_FREEDOM,            FREEVERT,\
                GA_ID,                  id,\
        EndObject
/* "Quick" mx creation macros. */
#define RightMx(label,labels,active,id)\
        MxObject,\
                GROUP_STYLE,            GRSTYLE_VERTICAL,\
                LAB_LABEL,              label,\
                MX_LABELS,              labels,\
                MX_ACTIVE,              active,\
                GA_ID,                  id,\
        EndObject, FixMinSize
#define LeftMx(label,labels,active,id)\
        MxObject,\
                GROUP_STYLE,            GRSTYLE_VERTICAL,\
                LAB_LABEL,              label,\
                MX_LABELS,              labels,\
                MX_ACTIVE,              active,\
                MX_LABELPLACE,          PLACE_LEFT,\
                GA_ID,                  id,\
        EndObject, FixMinSize
#define RightMxKey(label,labels,active,id)\
        MxObject,\
                GROUP_STYLE,            GRSTYLE_VERTICAL,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                MX_LABELS,              labels,\
                MX_ACTIVE,              active,\
                GA_ID,                  id,\
        EndObject, FixMinSize
#define LeftMxKey(label,labels,active,id)\
        MxObject,\
                GROUP_STYLE,            GRSTYLE_VERTICAL,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                MX_LABELS,              labels,\
                MX_ACTIVE,              active,\
                MX_LABELPLACE,          PLACE_LEFT,\
                GA_ID,                  id,\
        EndObject, FixMinSize
#define Tabs(label,labels,active,id)\
        MxObject,\
                MX_TABSOBJECT,          TRUE,\
                LAB_LABEL,              label,\
                MX_LABELS,              labels,\
                MX_ACTIVE,              active,\
                GA_ID,                  id,\
        EndObject, FixMinHeight
#define TabsKey(label,labels,active,id)\
        MxObject,\
                MX_TABSOBJECT,          TRUE,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                MX_LABELS,              labels,\
                MX_ACTIVE,              active,\
                GA_ID,                  id,\
        EndObject, FixMinHeight
#define TabsEqual(label,labels,active,id)\
        MxObject,\
                GROUP_EQUALWIDTH,       TRUE,\
                MX_TABSOBJECT,          TRUE,\
                LAB_LABEL,              label,\
                MX_LABELS,              labels,\
                MX_ACTIVE,              active,\
                GA_ID,                  id,\
        EndObject, FixMinHeight
#define TabsEqualKey(label,labels,active,id)\
        MxObject,\
                GROUP_EQUALWIDTH,       TRUE,\
                MX_TABSOBJECT,          TRUE,\
                LAB_LABEL,              label,\
                LAB_UNDERSCORE,         "_",\
                MX_LABELS,              labels,\
                MX_ACTIVE,              active,\
                GA_ID,                  id,\
        EndObject, FixMinHeight
#define USDTabs(label,labels,active,id)\
        MxObject,\
                MX_TABSOBJECT,      TRUE,\
                LAB_LABEL,          label,\
                MX_LABELS,          labels,\
                MX_ACTIVE,          active,\
                MX_TABSUPSIDEDOWN,  TRUE,\
                GA_ID,              id,\
        EndObject, FixMinHeight
#define USDTabsKey(label,labels,active,id)\
        MxObject,\
                MX_TABSOBJECT,      TRUE,\
                LAB_LABEL,          label,\
                LAB_UNDERSCORE,     "_",\
                MX_LABELS,          labels,\
                MX_ACTIVE,          active,\
                MX_TABSUPSIDEDOWN,  TRUE,\
                GA_ID,              id,\
        EndObject, FixMinHeight
#define USDTabsEqual(label,labels,active,id)\
        MxObject,\
                GROUP_EQUALWIDTH,   TRUE,\
                MX_TABSOBJECT,      TRUE,\
                LAB_LABEL,          label,\
                MX_LABELS,          labels,\
                MX_ACTIVE,          active,\
                MX_TABSUPSIDEDOWN,  TRUE,\
                GA_ID,              id,\
        EndObject, FixMinHeight
#define USDTabsEqualKey(label,labels,active,id)\
        MxObject,\
                GROUP_EQUALWIDTH,   TRUE,\
                MX_TABSOBJECT,      TRUE,\
                LAB_LABEL,          label,\
                LAB_Underscore,     "_",\
                MX_LABELS,          labels,\
                MX_ACTIVE,          active,\
                MX_TABSUPSIDEDOWN,  TRUE,\
                GA_ID,              id,\
        EndObject, FixMinHeight
/* "Quick" listview creation macros. */
#define StrListview(label,strings,id)\
        ListviewObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                LISTV_ENTRYARRAY,       strings,\
        EndObject
#define StrListviewSorted(label,strings,id)\
        ListviewObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                LISTV_ENTRYARRAY,       strings,\
                LISTV_SORTENTRYARRAY,   TRUE,\
        EndObject
#define ReadStrListview(label,strings)\
        ListviewObject,\
                LAB_LABEL,              label,\
                LISTV_ENTRYARRAY,       strings,\
                LISTV_READONLY,         TRUE,\
        EndObject
#define ReadStrListviewSorted(label,strings)\
        ListviewObject,\
                LAB_LABEL,              label,\
                LISTV_ENTRYARRAY,       strings,\
                LISTV_SORTENTRYARRAY,   TRUE,\
                LISTV_READONLY,         TRUE,\
        EndObject
#define MultiStrListview(label,strings,id)\
        ListviewObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                LISTV_ENTRYARRAY,       strings,\
                LISTV_MULTISELECT,      TRUE,\
        EndObject
#define MultiStrListviewSorted(label,strings,id)\
        ListviewObject,\
                LAB_LABEL,              label,\
                GA_ID,                  id,\
                LISTV_ENTRYARRAY,       strings,\
                LISTV_SORTENTRYARRAY,   TRUE,\
                LISTV_MULTISELECT,      TRUE,\
        EndObject
/* "Quick" separator bar creation macros. */
#define VertSeparator \
        SeparatorObject,\
                SEP_RECESSED,           TRUE,\
        EndObject, FixMinWidth
#define VertThinSeparator \
        SeparatorObject,\
                SEP_THIN,               TRUE,\
                SEP_RECESSED,           TRUE,\
        EndObject, FixMinWidth
#define HorizSeparator \
        SeparatorObject,\
                SEP_HORIZ,              TRUE,\
                SEP_RECESSED,           TRUE,\
        EndObject, FixMinHeight
#define TitleSeparator(t)\
        SeparatorObject,\
                SEP_HORIZ,              TRUE,\
                SEP_RECESSED,           TRUE,\
                SEP_TITLE,              t,\
        EndObject, FixMinHeight
#define HTitleSeparator(t)\
        SeparatorObject,\
                SEP_HORIZ,              TRUE,\
                SEP_RECESSED,           TRUE,\
                SEP_TITLE,              t,\
                SEP_HIGHLIGHT,          TRUE,\
        EndObject, FixMinHeight
#define CTitleSeparator(t)\
        SeparatorObject,\
                SEP_HORIZ,              TRUE,\
                SEP_RECESSED,           TRUE,\
                SEP_TITLE,              t,\
                SEP_CENTERTITLE,        TRUE,\
        EndObject, FixMinHeight
#define CHTitleSeparator(t)\
        SeparatorObject,\
                SEP_HORIZ,              TRUE,\
                SEP_RECESSED,           TRUE,\
                SEP_TITLE,              t,\
                SEP_HIGHLIGHT,          TRUE,\
                SEP_CENTERTITLE,        TRUE,\
        EndObject, FixMinHeight
#define TitleSeparatorLeft(t)\
        SeperatorObject,\
                SEP_HORIZ,              TRUE,\
                SEP_TITLE,              t,\
                SEP_TITLELEFT,          TRUE,\
        EndObject, FixMinHeight
#define HTitleSeparatorLeft(t)\
        SeperatorObject,\
                SEP_HORIZ,              TRUE,\
                SEP_TITLE,              t,\
                SEP_HIGHLIGHT,          TRUE,\
                SEP_TITLELEFT,          TRUE,\
        EndObject, FixMinHeight
#define CTitleSeparatorLeft(t)\
        SeperatorObject,\
                SEP_HORIZ,              TRUE,\
                SEP_TITLE,              t,\
                SEP_CENTERTITLE,        TRUE,\
                SEP_TITLELEFT,          TRUE,\
        EndObject, FixMinHeight
#define CHTitleSeparatorLeft(t)\
        SeperatorObject,\
                SEP_HORIZ,              TRUE,\
                SEP_TITLE,              t,\
                SEP_HIGHLIGHT,          TRUE,\
                SEP_CENTERTITLE,        TRUE,\
                SEP_TITLELEFT,          TRUE,\
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
#define Title(t)                 NM_TITLE, 0, t, NIL, 0, 0, NIL
#define Item(t,s,i)              NM_ITEM, 0, t, s, 0, 0, i
#define ItemBar                  NM_ITEM, 0, NM_BARLABEL, NIL, 0, 0, NIL
#define SubItem(t,s,i)           NM_SUB, 0, t, s, 0, 0, i
#define SubBar                   NM_SUB, 0, NM_BARLABEL, NIL, 0, 0, NIL
#define End                      NM_END, 0, NIL, NIL, 0, 0, NIL
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
        domethod( object, [ FRM_DOREQUEST ] )
