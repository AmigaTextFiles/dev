#ifndef LIBRARIES_TRITON_H
#define LIBRARIES_TRITON_H

/*
**	$VER: triton.h 5.1 (15.8.95)
**	Triton Release 1.4
**
**	triton.library definitions
**
**	(C) Copyright 1993-1995 Stefan Zeiger
**	All Rights Reserved
*/

#define	TRITONNAME              "triton.library"
#define	TRITON10VERSION         1L
#define	TRITON11VERSION         2L
#define	TRITON12VERSION         3L
#define	TRITON13VERSION         4L
#define	TRITON14VERSION         5L


/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////////////// Includes // */
/* ////////////////////////////////////////////////////////////////////// */

#define INTUI_V36_NAMES_ONLY

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITIONBASE_H
#include <intuition/intuitionbase.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif

#ifndef INTUITION_IMAGECLASS_H
#include <intuition/imageclass.h>
#endif

#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

#ifndef GRAPHICS_GFX_H
#include <graphics/gfx.h>
#endif

#ifndef GRAPHICS_GFXBASE_H
#include <graphics/gfxbase.h>
#endif

#ifndef GRAPHICS_GFXMACROS_H
#include <graphics/gfxmacros.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

#ifndef LIBRARIES_DISKFONT_H
#include <libraries/diskfont.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef WORKBENCH_STARTUP_H
#include <workbench/startup.h>
#endif

#ifndef WORKBENCH_WORKBENCH_H
#include <workbench/workbench.h>
#endif


/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////// Some useful things // */
/* ////////////////////////////////////////////////////////////////////// */

#ifndef max
#define max(a,b) ((a)>(b)?(a):(b))
#endif

#ifndef min
#define min(a,b) ((a)<=(b)?(a):(b))
#endif


/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////////////////// Macros // */
/* ////////////////////////////////////////////////////////////////////// */

#ifndef TR_NOMACROS

/* Project */
#define ProjectDefinition(name) struct TagItem name[]=
#define EndProject              TAG_END
#define WindowTitle(t)          TRWI_Title,(ULONG)(t)
#define ScreenTitle(t)          TRWI_ScreenTitle,(ULONG)(t)
#define WindowID(id)            TRWI_ID,(ULONG)(id)
#define WindowFlags(f)          TRWI_Flags,(ULONG)(f)
#define WindowPosition(pos)     TRWI_Position,(ULONG)(pos)
#define WindowUnderscore(und)   TRWI_Underscore,(ULONG)(und)
#define WindowDimensions(dim)   TRWI_Dimensions,(ULONG)(dim)
#define WindowBackfillWin       TRWI_Backfill,TRBF_WINDOWBACK
#define WindowBackfillReq       TRWI_Backfill,TRBF_REQUESTERBACK
#define WindowBackfillNone      TRWI_Backfill,TRBF_NONE
#define WindowBackfillS         TRWI_Backfill,TRBF_SHINE
#define WindowBackfillSA        TRWI_Backfill,TRBF_SHINE_SHADOW
#define WindowBackfillSF        TRWI_Backfill,TRBF_SHINE_FILL
#define WindowBackfillSB        TRWI_Backfill,TRBF_SHINE_BACKGROUND
#define WindowBackfillA         TRWI_Backfill,TRBF_SHADOW
#define WindowBackfillAF        TRWI_Backfill,TRBF_SHADOW_FILL
#define WindowBackfillAB        TRWI_Backfill,TRBF_SHADOW_BACKGROUND
#define WindowBackfillF         TRWI_Backfill,TRBF_FILL
#define WindowBackfillFB        TRWI_Backfill,TRBF_FILL_BACKGROUND
#define CustomScreen(scr)       TRWI_CustomScreen,((ULONG)(scr))
#define PubScreen(scr)          TRWI_PubScreen,((ULONG)(scr))
#define PubScreenName(name)     TRWI_PubScreenName,((ULONG)(name))
#define QuickHelpOn(on)         TRWI_QuickHelp,((ULONG)(on))

/* Menus */
#define BeginMenu(t)            TRMN_Title,(ULONG)(t)
#define MenuFlags(f)            TRMN_Flags,(f)
#define MenuItem(t,id)          TRMN_Item,(ULONG)(t),TRAT_ID,id
#define MenuItemC(t,id)         TRMN_Item,(ULONG)(t),TRMN_Flags,TRMF_CHECKIT,TRAT_ID,id
#define MenuItemCC(t,id)        TRMN_Item,(ULONG)(t),TRMN_Flags,TRMF_CHECKED,TRAT_ID,id
#define BeginSub(t)             TRMN_Item,(ULONG)(t)
#define MenuItemD(t,id)         TRMN_Item,(ULONG)(t),MenuFlags(TRMF_DISABLED),TRAT_ID,id
#define SubItem(t,id)           TRMN_Sub,(ULONG)(t),TRAT_ID,id
#define SubItemD(t,id)          TRMN_Sub,(ULONG)(t),MenuFlags(TRMF_DISABLED),TRAT_ID,id
#define ItemBarlabel            TRMN_Item,TRMN_BARLABEL
#define SubBarlabel             TRMN_Sub,TRMN_BARLABEL

/* Groups */
#define HorizGroup              TRGR_Horiz,0L
#define HorizGroupE             TRGR_Horiz,TRGR_EQUALSHARE
#define HorizGroupS             TRGR_Horiz,TRGR_PROPSPACES
#define HorizGroupA             TRGR_Horiz,TRGR_ALIGN
#define HorizGroupEA            TRGR_Horiz,TRGR_EQUALSHARE|TRGR_ALIGN
#define HorizGroupSA            TRGR_Horiz,TRGR_PROPSPACES|TRGR_ALIGN
#define HorizGroupC             TRGR_Horiz,TRGR_CENTER
#define HorizGroupEC            TRGR_Horiz,TRGR_EQUALSHARE|TRGR_CENTER
#define HorizGroupSC            TRGR_Horiz,TRGR_PROPSPACES|TRGR_CENTER
#define HorizGroupAC            TRGR_Horiz,TRGR_ALIGN|TRGR_CENTER
#define HorizGroupEAC           TRGR_Horiz,TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER
#define HorizGroupSAC           TRGR_Horiz,TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER
#define VertGroup               TRGR_Vert,0L
#define VertGroupE              TRGR_Vert,TRGR_EQUALSHARE
#define VertGroupS              TRGR_Vert,TRGR_PROPSPACES
#define VertGroupA              TRGR_Vert,TRGR_ALIGN
#define VertGroupEA             TRGR_Vert,TRGR_EQUALSHARE|TRGR_ALIGN
#define VertGroupSA             TRGR_Vert,TRGR_PROPSPACES|TRGR_ALIGN
#define VertGroupC              TRGR_Vert,TRGR_CENTER
#define VertGroupEC             TRGR_Vert,TRGR_EQUALSHARE|TRGR_CENTER
#define VertGroupSC             TRGR_Vert,TRGR_PROPSPACES|TRGR_CENTER
#define VertGroupAC             TRGR_Vert,TRGR_ALIGN|TRGR_CENTER
#define VertGroupEAC            TRGR_Vert,TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER
#define VertGroupSAC            TRGR_Vert,TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER
#define EndGroup                TRGR_End,0L
#define ColumnArray             TRGR_Horiz,TRGR_ARRAY|TRGR_ALIGN|TRGR_CENTER
#define LineArray               TRGR_Vert,TRGR_ARRAY|TRGR_ALIGN|TRGR_CENTER
#define BeginColumn             TRGR_Vert,TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER
#define BeginLine               TRGR_Horiz,TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER
#define BeginColumnI            TRGR_Vert,TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER|TRGR_INDEP
#define BeginLineI              TRGR_Horiz,TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER|TRGR_INDEP
#define EndColumn               EndGroup
#define EndLine                 EndGroup
#define EndArray                EndGroup

/* DisplayObject */
#define QuickHelp(str)          TRDO_QuickHelpString,((ULONG)(str))

/* Space */
#define SpaceB                  TROB_Space,TRST_BIG
#define Space                   TROB_Space,TRST_NORMAL
#define SpaceS                  TROB_Space,TRST_SMALL
#define SpaceN                  TROB_Space,TRST_NONE

/* Text */
#define TextN(text)             TROB_Text,0L,TRAT_Text,(ULONG)text
#define TextH(text)             TROB_Text,0L,TRAT_Text,(ULONG)text,TRAT_Flags,TRTX_HIGHLIGHT
#define Text3(text)             TROB_Text,0L,TRAT_Text,(ULONG)text,TRAT_Flags,TRTX_3D
#define TextB(text)             TROB_Text,0L,TRAT_Text,(ULONG)text,TRAT_Flags,TRTX_BOLD
#define TextT(text)             TROB_Text,0L,TRAT_Text,(ULONG)text,TRAT_Flags,TRTX_TITLE
#define TextID(text,id)         TROB_Text,0L,TRAT_Text,(ULONG)text,TRAT_ID,id
#define TextNR(t)               TextN(t),TRAT_Flags,TROF_RIGHTALIGN
#define ClippedText(t)          TextN(t),TRAT_Flags,TRTX_CLIPPED|TRTX_NOUNDERSCORE
#define ClippedTextID(t,id)     TextN(t),TRAT_Flags,TRTX_CLIPPED|TRTX_NOUNDERSCORE,TRAT_ID,id
#define CenteredText(text)      HorizGroupSC,Space,TextN(text),Space,EndGroup
#define CenteredTextH(text)     HorizGroupSC,Space,TextH(text),Space,EndGroup
#define CenteredText3(text)     HorizGroupSC,Space,Text3(text),Space,EndGroup
#define CenteredTextB(text)     HorizGroupSC,Space,TextB(text),Space,EndGroup
#define CenteredTextID(text,id) HorizGroupSC,Space,TextID(text,id),Space,EndGroup
#define CenteredText_BS(text)   HorizGroupSC,SpaceB,TextN(text),SpaceB,EndGroup
#define TextBox(text,id,mwid)   _TextBox, ObjectBackfillB, VertGroup, SpaceS, HorizGroupSC, Space, TextN(text),TRAT_ID,id,TRAT_MinWidth,mwid, Space, EndGroup, SpaceS, EndGroup
#define ClippedTextBox(text,id) _TextBox, ObjectBackfillB, VertGroupAC, SpaceS, HorizGroupAC, Space, ClippedTextID(text,id), Space, EndGroup, SpaceS, EndGroup
#define ClippedTextBoxMW(text,id,mwid) _TextBox, ObjectBackfillB, VertGroupAC, SpaceS, HorizGroupAC, Space, ClippedTextID(text,id),TRAT_MinWidth,mwid, Space, EndGroup, SpaceS, EndGroup
#define TextRIGHT(t,id)         HorizGroupS, Space, TextN(t), ID(id), EndGroup
#define Integer(i)              TROB_Text,0L,TRAT_Value,(ULONG)(i)
#define IntegerH(i)             TROB_Text,0L,TRAT_Value,(ULONG)(i),TRAT_Flags,TRTX_HIGHLIGHT
#define Integer3(i)             TROB_Text,0L,TRAT_Value,(ULONG)(i),TRAT_Flags,TRTX_3D
#define IntegerB(i)             TROB_Text,0L,TRAT_Value,(ULONG)(i),TRAT_Flags,TRTX_BOLD
#define CenteredInteger(i)      HorizGroupSC,Space,Integer(i),Space,EndGroup
#define CenteredIntegerH(i)     HorizGroupSC,Space,IntegerH(i),Space,EndGroup
#define CenteredInteger3(i)     HorizGroupSC,Space,Integer3(i),Space,EndGroup
#define CenteredIntegerB(i)     HorizGroupSC,Space,IntegerB(i),Space,EndGroup
#define IntegerBox(def,id,mwid) GroupBox, ObjectBackfillB, VertGroup, SpaceS, HorizGroupSC, Space, Integer(def),TRAT_ID,id,TRAT_MinWidth,mwid, Space, EndGroup, SpaceS, EndGroup

/* Button */
#define Button(text,id)         TROB_Button,0L,TRAT_Text,(ULONG)(text),TRAT_ID,(id)
#define ButtonR(text,id)        TROB_Button,0L,TRAT_Text,(ULONG)(text),TRAT_ID,(id),TRAT_Flags,TRBU_RETURNOK
#define ButtonE(text,id)        TROB_Button,0L,TRAT_Text,(ULONG)(text),TRAT_ID,(id),TRAT_Flags,TRBU_ESCOK
#define ButtonRE(text,id)       TROB_Button,0L,TRAT_Text,(ULONG)(text),TRAT_ID,(id),TRAT_Flags,TRBU_RETURNOK|TRBU_ESCOK
#define CenteredButton(t,i)     HorizGroupSC,Space,TROB_Button,0L,TRAT_Text,(ULONG)(t),TRAT_ID,(i),Space,EndGroup
#define CenteredButtonR(t,i)    HorizGroupSC,Space,TROB_Button,0L,TRAT_Flags,TRBU_RETURNOK,TRAT_Text,(ULONG)(t),TRAT_ID,(i),Space,EndGroup
#define CenteredButtonE(t,i)    HorizGroupSC,Space,TROB_Button,0L,TRAT_Flags,TRBU_ESCOK,TRAT_Text,(ULONG)(t),TRAT_ID,(i),Space,EndGroup
#define CenteredButtonRE(t,i)   HorizGroupSC,Space,TROB_Button,0L,TRAT_Flags,TRBU_RETURNOK|TRBU_ESCOK,TRAT_Text,(ULONG)(t),TRAT_ID,(i),Space,EndGroup
#define EmptyButton(id)         TROB_Button,0L,TRAT_Text,(ULONG)"",TRAT_ID,(id)
#define GetFileButton(id)       TROB_Button,TRBT_GETFILE,TRAT_Text,(ULONG)"",TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE
#define GetDrawerButton(id)     TROB_Button,TRBT_GETDRAWER,TRAT_Text,(ULONG)"",TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE
#define GetEntryButton(id)      TROB_Button,TRBT_GETENTRY,TRAT_Text,(ULONG)"",TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE
#define GetFileButtonS(s,id)    TROB_Button,TRBT_GETFILE,TRAT_Text,(ULONG)(s),TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE
#define GetDrawerButtonS(s,id)  TROB_Button,TRBT_GETDRAWER,TRAT_Text,(ULONG)(s),TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE
#define GetEntryButtonS(s,id)   TROB_Button,TRBT_GETENTRY,TRAT_Text,(ULONG)(s),TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE

/* Line */
#define Line(flags)             TROB_Line,flags
#define HorizSeparator          HorizGroupEC,Space,Line(TROF_HORIZ),Space,EndGroup
#define VertSeparator           VertGroupEC,Space,Line(TROF_VERT),Space,EndGroup
#define NamedSeparator(text)    HorizGroupEC,Space,Line(TROF_HORIZ),Space,TextT(text),Space,Line(TROF_HORIZ),Space,EndGroup
#define NamedSeparatorI(te,id)  HorizGroupEC,Space,Line(TROF_HORIZ),Space,TextT(te),TRAT_ID,id,Space,Line(TROF_HORIZ),Space,EndGroup
#define NamedSeparatorN(text)   HorizGroupEC,Line(TROF_HORIZ),Space,TextT(text),Space,Line(TROF_HORIZ),EndGroup
#define NamedSeparatorIN(te,id) HorizGroupEC,Line(TROF_HORIZ),Space,TextT(te),TRAT_ID,id,Space,Line(TROF_HORIZ),EndGroup

/* FrameBox */
#define GroupBox                TROB_FrameBox,TRFB_GROUPING
#define NamedFrameBox(t)        TROB_FrameBox,TRFB_FRAMING,TRAT_Text,(ULONG)(t)
#define _TextBox                TROB_FrameBox,TRFB_TEXT

/* DropBox */
#define DropBox(id)             TROB_DropBox,0L,TRAT_ID,(id)

/* CheckBox gadget */
#define CheckBox(id)            TROB_CheckBox,0L,TRAT_ID,id
#define CheckBoxC(id)           TROB_CheckBox,0L,TRAT_ID,id,TRAT_Value,TRUE
#define CheckBoxLEFT(id)        HorizGroupS, CheckBox(id), Space, EndGroup
#define CheckBoxCLEFT(id)       HorizGroupS, CheckBoxC(id), Space, EndGroup

/* String gadget */
#define StringGadget(def,id)    TROB_String,(ULONG)def,TRAT_ID,(id)
#define PasswordGadget(def,id)  TROB_String,(ULONG)def,TRAT_ID,(id),TRAT_Flags,TRST_INVISIBLE

/* Cycle gadget */
#define CycleGadget(ent,val,id) TROB_Cycle,(ULONG)ent,TRAT_ID,(id),TRAT_Value,(val)
#define MXGadget(ent,val,id)    TROB_Cycle,(ULONG)ent,TRAT_ID,(id),TRAT_Value,(val),TRAT_Flags,TRCY_MX
#define MXGadgetR(ent,val,id)   TROB_Cycle,(ULONG)ent,TRAT_ID,(id),TRAT_Value,(val),TRAT_Flags,TRCY_MX|TRCY_RIGHTLABELS

/* Slider gadget */
#define SliderGadget(mini,maxi,val,id) TROB_Slider,0L,TRSL_Min,(mini),TRSL_Max,(maxi),TRAT_ID,(id),TRAT_Value,(val)

/* Palette gadget */
#define PaletteGadget(val,id)   TROB_Palette,0L,TRAT_ID,(id),TRAT_Value,(val)

/* Listview gadget */
#define ListRO(ent,id,top)      TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_READONLY,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define ListSel(ent,id,top)     TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_SELECT,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define ListSS(e,id,top,v)      TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_SHOWSELECTED,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
#define ListROC(ent,id,top)     TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_READONLY|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define ListSelC(ent,id,top)    TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_SELECT|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define ListSSC(e,id,top,v)     TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_SHOWSELECTED|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
#define ListRON(ent,id,top)     TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_READONLY|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define ListSelN(ent,id,top)    TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_SELECT|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define ListSSN(e,id,top,v)     TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_SHOWSELECTED|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
#define ListROCN(ent,id,top)    TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_READONLY|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define ListSelCN(ent,id,top)   TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_SELECT|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define ListSSCN(e,id,top,v)    TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_SHOWSELECTED|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top

#define FWListRO(ent,id,top)    TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_READONLY,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define FWListSel(ent,id,top)   TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SELECT,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define FWListSS(e,id,top,v)    TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SHOWSELECTED,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
#define FWListROC(ent,id,top)   TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_READONLY|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define FWListSelC(ent,id,top)  TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SELECT|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define FWListSSC(e,id,top,v)   TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SHOWSELECTED|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
#define FWListRON(ent,id,top)   TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_READONLY|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define FWListSelN(ent,id,top)  TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SELECT|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define FWListSSN(e,id,top,v)   TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SHOWSELECTED|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
#define FWListROCN(ent,id,top)  TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_READONLY|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define FWListSelCN(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SELECT|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
#define FWListSSCN(e,id,top,v)  TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SHOWSELECTED|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top

/* Progress indicator */
#define Progress(maxi,val,id)   TROB_Progress,(maxi),TRAT_ID,(id),TRAT_Value,(val)

/* Image */
#define BoopsiImage(img)        TROB_Image,(ULONG)(img),TRAT_Flags,TRIM_BOOPSI
#define BoopsiImageD(img,mw,mh) TROB_Image,(ULONG)(img),TRAT_MinWidth,(mw),TRAT_MinHeight,(mh),TRAT_Flags,TRIM_BOOPSI

/* Attributes */
#define ID(id)                  TRAT_ID,id
#define Disabled                TRAT_Disabled,TRUE
#define ObjectBackfillWin       TRAT_Backfill,TRBF_WINDOWBACK
#define ObjectBackfillReq       TRAT_Backfill,TRBF_REQUESTERBACK
#define ObjectBackfillB         TRAT_Backfill,TRBF_NONE
#define ObjectBackfillS         TRAT_Backfill,TRBF_SHINE
#define ObjectBackfillSA        TRAT_Backfill,TRBF_SHINE_SHADOW
#define ObjectBackfillSF        TRAT_Backfill,TRBF_SHINE_FILL
#define ObjectBackfillSB        TRAT_Backfill,TRBF_SHINE_BACKGROUND
#define ObjectBackfillA         TRAT_Backfill,TRBF_SHADOW
#define ObjectBackfillAF        TRAT_Backfill,TRBF_SHADOW_FILL
#define ObjectBackfillAB        TRAT_Backfill,TRBF_SHADOW_BACKGROUND
#define ObjectBackfillF         TRAT_Backfill,TRBF_FILL
#define ObjectBackfillFB        TRAT_Backfill,TRBF_FILL_BACKGROUND

/* Requester support */
#define BeginRequester(t,p)     WindowTitle(t),WindowPosition(p),WindowBackfillReq,\
                                WindowFlags(TRWF_NOZIPGADGET|TRWF_NOSIZEGADGET|TRWF_NOCLOSEGADGET|TRWF_NODELZIP|TRWF_NOESCCLOSE),\
                                VertGroupA,Space,HorizGroupA,Space,GroupBox,ObjectBackfillB
#define BeginRequesterGads      Space,EndGroup,Space
#define EndRequester            Space,EndGroup,EndProject

#endif /* TR_NOMACROS */


/* ////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////////////////////// Support library // */
/* ////////////////////////////////////////////////////////////////////// */

#ifndef TR_NOSUPPORT

extern struct TR_App *__Triton_Support_App;
extern struct IClass *TRIM_trLogo;

#ifndef TR_NOMACROS
#ifndef __OBJAM__
#define Application __Triton_Support_App
#endif /* __OBJAM__ */
#endif /* TR_NOMACROS */

#endif /* TR_NOSUPPORT */


/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////// The Triton message // */
/* ////////////////////////////////////////////////////////////////////// */

struct TR_Message
{
  struct TR_Project *           trm_Project;    /* The project which triggered the message */
  ULONG                         trm_ID;         /* The object's ID (where appropriate) */
  ULONG                         trm_Class;      /* The Triton message class */
  ULONG                         trm_Data;       /* The class-specific data */
  ULONG                         trm_Code;       /* Currently only used by TRMS_KEYPRESSED */
  ULONG                         trm_Qualifier;  /* IEQUALIFIERs */
  ULONG                         trm_Seconds;    /* \ Copy of system clock time (Only where */
  ULONG                         trm_Micros;     /* / available! If not set, trm_Seconds is 0) */
  struct TR_App *               trm_App;        /* The project's application */
};

/* Message classes */
#define TRMS_CLOSEWINDOW        1L  /* The window should be closed */
#define TRMS_ERROR              2L  /* An error occured. Error code in trm_Data */
#define TRMS_NEWVALUE           3L  /* Object's value has changed. New value in trm_Data */
#define TRMS_ACTION             4L  /* Object has triggered an action */
#define TRMS_ICONDROPPED        5L  /* Icon dropped over window (ID=0) or DropBox. AppMessage* in trm_Data */
#define TRMS_KEYPRESSED         6L  /* Key pressed. trm_Data contains ASCII code, trm_Code raw code and */
                                    /* trm_Qualifier contains qualifiers */
#define TRMS_HELP               7L  /* The user requested help for the specified ID */
#define TRMS_DISKINSERTED       8L  /* A disk has been inserted into a drive */
#define TRMS_DISKREMOVED        9L  /* A disk has been removed from a drive */


/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////// Triton error codes // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRER_OK                 0L        /* No error */

#define TRER_ALLOCMEM           1L        /* Not enough memory */
#define TRER_OPENWINDOW         2L        /* Can't open window */
#define TRER_WINDOWTOOBIG       3L        /* Window would be too big for screen */
#define TRER_DRAWINFO           4L        /* Can't get screen's DrawInfo */
#define TRER_OPENFONT           5L        /* Can't open font */
#define TRER_CREATEMSGPORT      6L        /* Can't create message port */
#define TRER_INSTALLOBJECT      7L        /* Can't create an object */
#define TRER_CREATECLASS        8L        /* Can't create a class */
#define TRER_NOLOCKPUBSCREEN    9L        /* Can't lock public screen */
#define TRER_CREATEMENUS        12L       /* Error while creating the menus */
#define TRER_GT_CREATECONTEXT   14L       /* Can't create gadget context */

#define TRER_MAXERRORNUM        15L       /* PRIVATE! */


/* ////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////////////////////// Object messages // */
/* ////////////////////////////////////////////////////////////////////// */

#define TROM_ACTIVATE 23L                 /* Activate an object */


/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////// Tags for TR_OpenProject() // */
/* ////////////////////////////////////////////////////////////////////// */

/* Tag bases */
#define TRTG_OAT              (TAG_USER+0x400)  /* Object attribute */
#define TRTG_OBJ              (TAG_USER+0x100)  /* Object ID */
#define TRTG_OAT2             (TAG_USER+0x80)   /* PRIVATE! */
#define TRTG_PAT              (TAG_USER)        /* Project attribute */
#define TRTG_SER(ser)         ((ser)<<11)       /* PRIVATE! */

/* Window/Project */
#define TRWI_Title              (TRTG_PAT+0x01) /* STRPTR: The window title */
#define TRWI_Flags              (TRTG_PAT+0x02) /* See below for window flags */
#define TRWI_Underscore         (TRTG_PAT+0x03) /* char *: The underscore for menu and gadget shortcuts */
#define TRWI_Position           (TRTG_PAT+0x04) /* Window position, see below */
#define TRWI_CustomScreen       (TRTG_PAT+0x05) /* struct Screen * */
#define TRWI_PubScreen          (TRTG_PAT+0x06) /* struct Screen *, must have been locked! */
#define TRWI_PubScreenName      (TRTG_PAT+0x07) /* STRPTR, Triton is doing the locking */
#define TRWI_PropFontAttr       (TRTG_PAT+0x08) /* struct TextAttr *: The proportional font */
#define TRWI_FixedWidthFontAttr (TRTG_PAT+0x09) /* struct TextAttr *: The fixed-width font */
#define TRWI_Backfill           (TRTG_PAT+0x0A) /* The backfill type, see below */
#define TRWI_ID                 (TRTG_PAT+0x0B) /* ULONG: The window ID */
#define TRWI_Dimensions         (TRTG_PAT+0x0C) /* struct TR_Dimensions * */
#define TRWI_ScreenTitle        (TRTG_PAT+0x0D) /* STRPTR: The screen title */
#define TRWI_QuickHelp          (TRTG_PAT+0x0E) /* BOOL: Quick help active? */

/* Menus */
#define TRMN_Title              (TRTG_PAT+0x65) /* STRPTR: Menu */
#define TRMN_Item               (TRTG_PAT+0x66) /* STRPTR: Menu item */
#define TRMN_Sub                (TRTG_PAT+0x67) /* STRPTR: Menu subitem */
#define TRMN_Flags              (TRTG_PAT+0x68) /* See below for flags */

/* General object attributes */
#define TRAT_ID               (TRTG_OAT2+0x16)  /* The object's/menu's ID */
#define TRAT_Flags            (TRTG_OAT2+0x17)  /* The object's flags */
#define TRAT_Value            (TRTG_OAT2+0x18)  /* The object's value */
#define TRAT_Text             (TRTG_OAT2+0x19)  /* The object's text */
#define TRAT_Disabled         (TRTG_OAT2+0x1A)  /* Disabled object? */
#define TRAT_Backfill         (TRTG_OAT2+0x1B)  /* Backfill pattern */
#define TRAT_MinWidth         (TRTG_OAT2+0x1C)  /* Minimum width */
#define TRAT_MinHeight        (TRTG_OAT2+0x1D)  /* Minimum height */


/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////////// Window flags // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRWF_BACKDROP           0x00000001L     /* Create a backdrop borderless window */
#define TRWF_NODRAGBAR          0x00000002L     /* Don't use a dragbar */
#define TRWF_NODEPTHGADGET      0x00000004L     /* Don't use a depth-gadget */
#define TRWF_NOCLOSEGADGET      0x00000008L     /* Don't use a close-gadget */
#define TRWF_NOACTIVATE         0x00000010L     /* Don't activate window */
#define TRWF_NOESCCLOSE         0x00000020L     /* Don't send TRMS_CLOSEWINDOW when Esc is pressed */
#define TRWF_NOPSCRFALLBACK     0x00000040L     /* Don't fall back onto default PubScreen */
#define TRWF_NOZIPGADGET        0x00000080L     /* Don't use a zip-gadget */
#define TRWF_ZIPCENTERTOP       0x00000100L     /* Center the zipped window on the title bar */
#define TRWF_NOMINTEXTWIDTH     0x00000200L     /* Minimum window width not according to title text */
#define TRWF_NOSIZEGADGET       0x00000400L     /* Don't use a sizing-gadget */
#define TRWF_NOFONTFALLBACK     0x00000800L     /* Don't fall back to topaz.8 */
#define TRWF_NODELZIP           0x00001000L     /* Don't zip the window when Del is pressed */
#define TRWF_SIMPLEREFRESH      0x00002000L     /* *** OBSOLETE *** (V3+) */
#define TRWF_ZIPTOCURRENTPOS    0x00004000L     /* Will zip the window at the current position (OS3.0+) */
#define TRWF_APPWINDOW          0x00008000L     /* Create an AppWindow without using class_dropbox */
#define TRWF_ACTIVATESTRGAD     0x00010000L     /* Activate the first string gadget after opening the window */
#define TRWF_HELP               0x00020000L     /* Pressing <Help> will create a TRMS_HELP message (V4) */
#define TRWF_SYSTEMACTION       0x00040000L     /* System status messages will be sent (V4) */


/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////////////// Menu flags // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRMF_CHECKIT            0x00000001L     /* Leave space for a checkmark */
#define TRMF_CHECKED            0x00000002L     /* Check the item (includes TRMF_CHECKIT) */
#define TRMF_DISABLED           0x00000004L     /* Ghost the menu/item */


/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////// Window positions // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRWP_DEFAULT            0L              /* Let Triton choose a good position */
#define TRWP_BELOWTITLEBAR      1L              /* Left side of screen, below title bar */
#define TRWP_CENTERTOP          1025L           /* Top of screen, centered on the title bar */
#define TRWP_TOPLEFTSCREEN      1026L           /* Top left corner of screen */
#define TRWP_CENTERSCREEN       1027L           /* Centered on the screen */
#define TRWP_CENTERDISPLAY      1028L           /* Centered on the currently displayed clip */
#define TRWP_MOUSEPOINTER       1029L           /* Under the mouse pointer */
#define TRWP_ABOVECOORDS        2049L           /* Above coordinates from the dimensions struct */
#define TRWP_BELOWCOORDS        2050L           /* Below coordinates from the dimensions struct */


/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////// Backfill types / System images // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRBF_WINDOWBACK         0x00000000L     /* Window backfill */
#define TRBF_REQUESTERBACK      0x00000001L     /* Requester backfill */

#define TRBF_NONE               0x00000002L     /* No backfill (= Fill with BACKGROUNDPEN) */
#define TRBF_SHINE              0x00000003L     /* Fill with SHINEPEN */
#define TRBF_SHINE_SHADOW       0x00000004L     /* Fill with SHINEPEN + SHADOWPEN */
#define TRBF_SHINE_FILL         0x00000005L     /* Fill with SHINEPEN + FILLPEN */
#define TRBF_SHINE_BACKGROUND   0x00000006L     /* Fill with SHINEPEN + BACKGROUNDPEN */
#define TRBF_SHADOW             0x00000007L     /* Fill with SHADOWPEN */
#define TRBF_SHADOW_FILL        0x00000008L     /* Fill with SHADOWPEN + FILLPEN */
#define TRBF_SHADOW_BACKGROUND  0x00000009L     /* Fill with SHADOWPEN + BACKGROUNDPEN */
#define TRBF_FILL               0x0000000AL     /* Fill with FILLPEN */
#define TRBF_FILL_BACKGROUND    0x0000000BL     /* Fill with FILLPEN + BACKGROUNDPEN */

#define TRSI_USBUTTONBACK       0x00010002L     /* Unselected button backfill */
#define TRSI_SBUTTONBACK        0x00010003L     /* Selected button backfill */


/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////// Display Object flags // */
/* ////////////////////////////////////////////////////////////////////// */

/* General flags */
#define TROF_RAISED             0x00000001L     /* Raised object */
#define TROF_HORIZ              0x00000002L     /* Horizontal object \ Works automatically */
#define TROF_VERT               0x00000004L     /* Vertical object   / in groups */
#define TROF_RIGHTALIGN         0x00000008L     /* Align object to the right border if available */

/* Text flags for different kinds of text-related objects */
#define TRTX_NOUNDERSCORE       0x00000100L     /* Don't interpret underscores */
#define TRTX_HIGHLIGHT          0x00000200L     /* Highlight text */
#define TRTX_3D                 0x00000400L     /* 3D design */
#define TRTX_BOLD               0x00000800L     /* Softstyle 'bold' */
#define TRTX_TITLE              0x00001000L     /* A title (e.g. of a group) */
#define TRTX_SELECTED           0x00002000L     /* PRIVATE! */


/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////////// Menu entries // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRMN_BARLABEL           (-1L)           /* A barlabel instead of text */


/* ////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////////////// Tags for TR_CreateApp() // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRCA_Name               (TAG_USER+1)
#define TRCA_LongName           (TAG_USER+2)
#define TRCA_Info               (TAG_USER+3)
#define TRCA_Version            (TAG_USER+4)
#define TRCA_Release            (TAG_USER+5)
#define TRCA_Date               (TAG_USER+6)


/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////// Tags for TR_EasyRequest() // */
/* ////////////////////////////////////////////////////////////////////// */

#define TREZ_ReqPos             (TAG_USER+1)
#define TREZ_LockProject        (TAG_USER+2)
#define TREZ_Return             (TAG_USER+3)
#define TREZ_Title              (TAG_USER+4)
#define TREZ_Activate           (TAG_USER+5)


/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////// The Application Structure // */
/* ////////////////////////////////////////////////////////////////////// */

struct TR_App /* This structure is PRIVATE! */
{
  VOID *                        tra_MemPool;        /* The memory pool */
  ULONG                         tra_BitMask;        /* Bits to Wait() for. THIS FIELD IS NOT PRIVATE! */
  ULONG                         tra_LastError;      /* TRER code of last error */
  STRPTR                        tra_Name;           /* Unique name */
  STRPTR                        tra_LongName;       /* User-readable name */
  STRPTR                        tra_Info;           /* Info string */
  STRPTR                        tra_Version;        /* Version */
  STRPTR                        tra_Release;        /* Release */
  STRPTR                        tra_Date;           /* Compilation date */
  struct MsgPort *              tra_AppPort;        /* Application message port */
  struct MsgPort *              tra_IDCMPPort;      /* IDCMP message port */
  VOID *                        tra_Prefs;          /* Pointer to Triton app prefs */
  struct TR_Project *           tra_LastProject;    /* Used for menu item linking */
  struct InputEvent *           tra_InputEvent;     /* Used for RAWKEY conversion */
};


/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////// The Dimensions Structure // */
/* ////////////////////////////////////////////////////////////////////// */

struct TR_Dimensions
{
  UWORD                         trd_Left;           /* Left */
  UWORD                         trd_Top;            /* Top */
  UWORD                         trd_Width;          /* Width */
  UWORD                         trd_Height;         /* Height */
  UWORD                         trd_Left2;          /* Left */
  UWORD                         trd_Top2;           /* Top */
  UWORD                         trd_Width2;         /* Width */
  UWORD                         trd_Height2;        /* Height */
  BOOL                          trd_Zoomed;         /* Window zoomed? */
  UWORD                         reserved[3];        /* For future expansions */
};


/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////////// The Project Structure // */
/* ////////////////////////////////////////////////////////////////////// */

struct TR_Project /* This structure is PRIVATE! */
{
  struct TR_App *               trp_App;                        /* Our application */
  struct Screen *               trp_Screen;                     /* Our screen, always valid */
  ULONG                         trp_ScreenType;                 /* Type of screen (WA_...Screen) */

  ULONG                         trp_ID;                         /* The project's ID */

  struct Screen *               trp_LockedPubScreen;            /* Only valid if we're using a PubScreen */
  STRPTR                        trp_ScreenTitle;                /* The screen title */

  struct Window *               trp_Window;                     /* The window */
  struct AppWindow *            trp_AppWindow;                  /* AppWindow for icon dropping */

  ULONG                         trp_IDCMPFlags;                 /* The IDCMP flags */
  ULONG                         trp_Flags;                      /* Triton window flags */

  struct NewMenu *              trp_NewMenu;                    /* The newmenu stucture built by Triton */
  ULONG                         trp_NewMenuSize;                /* The number of menu items in the list */
  struct Menu *                 trp_Menu;                       /* The menu structure */
  UWORD                         trp_NextSelect;                 /* The next selected menu item */

  VOID *                        trp_VisualInfo;                 /* The VisualInfo of our window */
  struct DrawInfo *             trp_DrawInfo;                   /* The DrawInfo of the screen */
  struct TR_Dimensions *        trp_UserDimensions;             /* User-supplied dimensions */
  struct TR_Dimensions *        trp_Dimensions;                 /* Private dimensions */

  ULONG                         trp_WindowStdHeight;            /* The standard height of the window */
  ULONG                         trp_LeftBorder;                 /* The width of the left window border */
  ULONG                         trp_RightBorder;                /* The width of the right window border */
  ULONG                         trp_TopBorder;                  /* The height of the top window border */
  ULONG                         trp_BottomBorder;               /* The height of the bottom window border */
  ULONG                         trp_InnerWidth;                 /* The inner width of the window */
  ULONG                         trp_InnerHeight;                /* The inner height of the window */
  WORD                          trp_ZipDimensions[4];           /* The dimensions for the zipped window */
  UWORD                         trp_AspectFixing;               /* Pixel aspect correction factor */

  struct MinList                trp_ObjectList;                 /* The list of display objects */
  struct MinList                trp_MenuList;                   /* The list of menus */
  struct MinList                trp_IDList;                     /* The ID linking list (menus & objects) */
  VOID *                        trp_MemPool;                    /* The memory pool for the lists */
  BOOL                          trp_HasObjects;                 /* Do we have display objects? */

  struct TextAttr *             trp_PropAttr;                   /* The proportional font attributes */
  struct TextAttr *             trp_FixedWidthAttr;             /* The fixed-width font attributes */
  struct TextFont *             trp_PropFont;                   /* The proportional font */
  struct TextFont *             trp_FixedWidthFont;             /* The fixed-width font */
  BOOL                          trp_OpenedPropFont;             /* \ Have we opened the fonts ? */
  BOOL                          trp_OpenedFixedWidthFont;       /* /                            */
  UWORD                         trp_TotalPropFontHeight;        /* Height of prop font incl. underscore */

  ULONG                         trp_BackfillType;               /* The backfill type */
  struct Hook *                 trp_BackfillHook;               /* The backfill hook */

  struct Gadget *               trp_GadToolsGadgetList;         /* List of GadTools gadgets */
  struct Gadget *               trp_PrevGadget;                 /* Previous GadTools gadget */
  struct NewGadget *            trp_NewGadget;                  /* GadTools NewGadget */

  struct Requester *            trp_InvisibleRequest;           /* The invisible blocking requester */
  BOOL                          trp_IsUserLocked;               /* Project locked by the user? */

  ULONG                         trp_CurrentID;                  /* The currently keyboard-selected ID */
  BOOL                          trp_IsShortcutDown;             /* Shortcut key pressed? */
  UBYTE                         trp_Underscore;                 /* The underscore character */

  BOOL                          trp_EscClose;                   /* Close window on Esc? */
  BOOL                          trp_DelZip;                     /* Zip window on Del? */
  BOOL                          trp_PubScreenFallBack;          /* Fall back onto default public screen? */
  BOOL                          trp_FontFallBack;               /* Fall back to topaz.8? */

  UWORD                         trp_OldWidth;                   /* Old window width */
  UWORD                         trp_OldHeight;                  /* Old window height */

  struct Window *               trp_QuickHelpWindow;            /* The QuickHelp window */
  struct TROD_DisplayObject *   trp_QuickHelpObject;            /* Object for which help is popped up */
  ULONG                         trp_TicksPassed;                /* IntuiTicks passed since last MouseMove */
};


/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////// Default classes, attributes and flags // */
/* ////////////////////////////////////////////////////////////////////// */

/* The following code has been assembled automatically from the class
   sources and may therefore look somehow unstructured and chaotic :-) */

/* class_DisplayObject */

#define TROB_DisplayObject      (TRTG_OBJ+0x3C) /* A basic display object */

#define TRDO_QuickHelpString    (TRTG_OAT+0x1E3)

/* class_Group */

#define TRGR_Horiz              (TAG_USER+201)  /* Horizontal group */
#define TRGR_Vert               (TAG_USER+202)  /* Vertical group */
#define TRGR_End                (TRTG_OAT2+0x4B)/* End of a group */

#define TRGR_PROPSHARE          0x00000000L     /* Default: Divide objects proportionally */
#define TRGR_EQUALSHARE         0x00000001L     /* Divide objects equally */
#define TRGR_PROPSPACES         0x00000002L     /* Divide spaces proportionally */
#define TRGR_ARRAY              0x00000004L     /* Top-level array group */

#define TRGR_ALIGN              0x00000008L     /* Align resizeable objects in secondary dimension */
#define TRGR_CENTER             0x00000010L     /* Center unresizeable objects in secondary dimension */

#define TRGR_FIXHORIZ           0x00000020L     /* Don't allow horizontal resizing */
#define TRGR_FIXVERT            0x00000040L     /* Don't allow vertical resizing */
#define TRGR_INDEP              0x00000080L     /* Group is independant of surrounding array */

/* class_Space */

#define TROB_Space              (TRTG_OBJ+0x285)/* The spaces class */

#define TRST_NONE               1L              /* No space */
#define TRST_SMALL              2L              /* Small space */
#define TRST_NORMAL             3L              /* Normal space (default) */
#define TRST_BIG                4L              /* Big space */

/* class_CheckBox */

#define TROB_CheckBox           (TRTG_OBJ+0x2F) /* A checkbox gadget */

/* class_Object */

#define TROB_Object             (TRTG_OBJ+0x3D) /* A rootclass object */

/* class_Cycle */

#define TROB_Cycle              (TRTG_OBJ+0x36) /* A cycle gadget */

#define TRCY_MX                 0x00010000L     /* Unfold the cycle gadget to a MX gadget */
#define TRCY_RIGHTLABELS        0x00020000L     /* Put the labels to the right of a MX gadget */

/* class_DropBox */

#define TROB_DropBox            (TRTG_OBJ+0x38) /* An icon drop box */

/* class_Scroller */

#define TROB_Scroller           (TRTG_OBJ+0x35) /* A scroller gadget */

#define TRSC_Total              (TRTG_OAT+0x1E0)
#define TRSC_Visible            (TRTG_OAT+0x1E1)

/* class_FrameBox */

#define TROB_FrameBox           (TRTG_OBJ+0x32) /* A framing box */

#define TRFB_GROUPING           0x00000001L     /* A grouping box */
#define TRFB_FRAMING            0x00000002L     /* A framing box */
#define TRFB_TEXT               0x00000004L     /* A text container */

/* class_Button */

#define TROB_Button             (TRTG_OBJ+0x31) /* A BOOPSI button gadget */

#define TRBU_RETURNOK           0x00010000L     /* <Return> answers the button */
#define TRBU_ESCOK              0x00020000L     /* <Esc> answers the button */
#define TRBU_SHIFTED            0x00040000L     /* Shifted shortcut only */
#define TRBU_UNSHIFTED          0x00080000L     /* Unshifted shortcut only */
#define TRBU_YRESIZE            0x00100000L     /* Button resizeable in Y direction */
#define TRBT_TEXT               0L              /* Text button */
#define TRBT_GETFILE            1L              /* GetFile button */
#define TRBT_GETDRAWER          2L              /* GetDrawer button */
#define TRBT_GETENTRY           3L              /* GetEntry button */

/* class_Line */

#define TROB_Line               (TRTG_OBJ+0x2D) /* A simple line */

/* class_Palette */

#define TROB_Palette            (TRTG_OBJ+0x33) /* A palette gadget */

/* class_Slider */

#define TROB_Slider             (TRTG_OBJ+0x34) /* A slider gadget */

#define TRSL_Min                (TRTG_OAT+0x1DE)
#define TRSL_Max                (TRTG_OAT+0x1DF)

/* class_Progress */

#define TROB_Progress           (TRTG_OBJ+0x3A) /* A progress indicator */

/* class_Text */

#define TROB_Text               (TRTG_OBJ+0x30) /* A line of text */

#define TRTX_CLIPPED            0x00010000L     /* Text is clipped */
/* class_Listview */

#define TROB_Listview           (TRTG_OBJ+0x39) /* A listview gadget */

#define TRLV_Top                (TRTG_OAT+0x1E2)

#define TRLV_READONLY           0x00010000L     /* A read-only list */
#define TRLV_SELECT             0x00020000L     /* You may select an entry */
#define TRLV_SHOWSELECTED       0x00040000L     /* Selected entry will be shown */
#define TRLV_NOCURSORKEYS       0x00080000L     /* Don't use arrow keys */
#define TRLV_NONUMPADKEYS       0x00100000L     /* Don't use numeric keypad keys */
#define TRLV_FWFONT             0x00200000L     /* Use the fixed-width font */
#define TRLV_NOGAP              0x00400000L     /* Don't leave a gap below the list */

/* class_Image */

#define TROB_Image              (TRTG_OBJ+0x3B) /* An image */

#define TRIM_BOOPSI             0x00010000L     /* Use a BOOPSI IClass image */

/* class_String */

#define TROB_String             (TRTG_OBJ+0x37) /* A string gadget */

#define TRST_INVISIBLE          0x00010000L     /* A password gadget -> invisible typing */
#define TRST_NORETURNBROADCAST  0x00020000L     /* <Return> keys will not be broadcast to the window */

/* End of automatically assembled code */


/* ////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////////////////////////////// The End // */
/* ////////////////////////////////////////////////////////////////////// */

#endif /* LIBRARIES_TRITON_H */
