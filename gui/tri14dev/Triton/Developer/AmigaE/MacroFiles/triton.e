/*
**	$VER: triton.h 2.54 (14.7.94)
**	Triton Release 1.1
**
**	triton.library definitions
**
**	(C) Copyright 1993-1994 Stefan Zeiger
**	All Rights Reserved
*/

/*	This version is done by Frank Verheyen, 18/09/1994, for AmigaE	*/

#define	NULL 0
#define	NIL 0

#define	TRITONNAME		'triton.library'
#define	TRITON10VERSION	1
#define	TRITON11VERSION	2

/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////////////////// Macros // */
/* ////////////////////////////////////////////////////////////////////// */
/* Project */
#define ProjectDefinition(name) struct TagItem name[]=
#define EndProject			TAG_END
#define WindowTitle(t)		TRWI_Title,t
#define ScreenTitle(t)		TRWI_ScreenTitle,t
#define WindowID(id)		TRWI_ID,id
#define WindowFlags(f)		TRWI_Flags,f
#define WindowPosition(pos)	TRWI_Position,pos
#define WindowUnderscore(und)	TRWI_Underscore,und
#define WindowDimensions(dim)	TRWI_Dimensions,dim
#define WindowBackfillWin	TRWI_Backfill,TRBF_WINDOWBACK
#define WindowBackfillReq	TRWI_Backfill,TRBF_REQUESTERBACK
#define WindowBackfillNone	TRWI_Backfill,TRBF_NONE
#define WindowBackfillS		TRWI_Backfill,TRBF_SHINE
#define WindowBackfillSA		TRWI_Backfill,TRBF_SHINE_SHADOW
#define WindowBackfillSF		TRWI_Backfill,TRBF_SHINE_FILL
#define WindowBackfillSB		TRWI_Backfill,TRBF_SHINE_BACKGROUND
#define WindowBackfillA		TRWI_Backfill,TRBF_SHADOW
#define WindowBackfillAF		TRWI_Backfill,TRBF_SHADOW_FILL
#define WindowBackfillAB		TRWI_Backfill,TRBF_SHADOW_BACKGROUND
#define WindowBackfillF		TRWI_Backfill,TRBF_FILL
#define WindowBackfillFB		TRWI_Backfill,TRBF_FILL_BACKGROUND
#define CustomScreen(scr)	TRWI_CustomScreen,scr
#define PubScreen(scr)		TRWI_PubScreen,scr
#define PubScreenName(name)	TRWI_PubScreenName,name

/* Menus */
#define BeginMenu(t)	TRMN_Title,t
#define MenuFlags(f)	TRMN_Flags,f
#define MenuItem(t,id)	TRMN_Item,t,ID(id)
#define BeginSub(t)		TRMN_Item,t
#define MenuItemD(t,id)	TRMN_Item,t,MenuFlags(TRMF_DISABLED),ID(id)
#define SubItem(t,id)	TRMN_Sub,t,ID(id)
#define SubItemD(t,id)	TRMN_Sub,t,MenuFlags(TRMF_DISABLED),ID(id)
#define ItemBarlabel	TRMN_Item,TRMN_BARLABEL
#define SubBarlabel		TRMN_Sub,TRMN_BARLABEL

/* Groups */
#define HorizGroup		TRGR_Horiz,NIL
#define HorizGroupE		TRGR_Horiz,TRGR_EQUALSHARE
#define HorizGroupS		TRGR_Horiz,TRGR_PROPSPACES
#define HorizGroupA		TRGR_Horiz,TRGR_ALIGN
#define HorizGroupEA	TRGR_Horiz,TRGR_EQUALSHARE OR TRGR_ALIGN
#define HorizGroupSA	TRGR_Horiz,TRGR_PROPSPACES OR TRGR_ALIGN
#define HorizGroupC		TRGR_Horiz,TRGR_CENTER
#define HorizGroupEC	TRGR_Horiz,TRGR_EQUALSHARE OR TRGR_CENTER
#define HorizGroupSC	TRGR_Horiz,TRGR_PROPSPACES OR TRGR_CENTER
#define HorizGroupAC	TRGR_Horiz,TRGR_ALIGN OR TRGR_CENTER
#define HorizGroupEAC	TRGR_Horiz,TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER
#define HorizGroupSAC	TRGR_Horiz,TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER
#define VertGroup		TRGR_Vert,NIL
#define VertGroupE		TRGR_Vert,TRGR_EQUALSHARE
#define VertGroupS		TRGR_Vert,TRGR_PROPSPACES
#define VertGroupA		TRGR_Vert,TRGR_ALIGN
#define VertGroupEA		TRGR_Vert,TRGR_EQUALSHARE OR TRGR_ALIGN
#define VertGroupSA		TRGR_Vert,TRGR_PROPSPACES OR TRGR_ALIGN
#define VertGroupC		TRGR_Vert,TRGR_CENTER
#define VertGroupEC		TRGR_Vert,TRGR_EQUALSHARE OR TRGR_CENTER
#define VertGroupSC		TRGR_Vert,TRGR_PROPSPACES OR TRGR_CENTER
#define VertGroupAC		TRGR_Vert,TRGR_ALIGN OR TRGR_CENTER
#define VertGroupEAC	TRGR_Vert,TRGR_EQUALSHARE OR TRGR_ALIGN OR TRGR_CENTER
#define VertGroupSAC	TRGR_Vert,TRGR_PROPSPACES OR TRGR_ALIGN OR TRGR_CENTER
#define EndGroup		TRGR_End,NIL
#define ColumnArray		TRGR_Horiz,TRGR_ARRAY OR TRGR_ALIGN OR TRGR_CENTER
#define LineArray		TRGR_Vert,TRGR_ARRAY OR TRGR_ALIGN OR TRGR_CENTER
#define BeginColumn		TRGR_Vert,TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER
#define BeginLine		TRGR_Horiz,TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER
#define BeginColumnI	TRGR_Vert,TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER OR TRGR_INDEP
#define BeginLineI		TRGR_Horiz,TRGR_PROPSHARE OR TRGR_ALIGN OR TRGR_CENTER OR TRGR_INDEP
#define EndColumn		EndGroup
#define EndLine		EndGroup
#define EndArray		EndGroup

/* Spaces */
#define SpaceB				TROB_Space,TRST_BIG
#define Space				TROB_Space,TRST_NORMAL
#define SpaceS				TROB_Space,TRST_SMALL
#define SpaceN				TROB_Space,TRST_NONE

/* Text */
#define TextN(t)			TROB_Text,NIL,Txt(t)
#define TextH(t)			TROB_Text,NIL,Txt(t),Flags(TRTX_HIGHLIGHT)
#define Text3(t)			TROB_Text,NIL,Txt(t),Flags(TRTX_3D)
#define TextB(t)			TROB_Text,NIL,Txt(t),Flags(TRTX_BOLD)
#define TextT(t)			TROB_Text,NIL,Txt(t),Flags(TRTX_TITLE)
#define TextID(t,id)		TROB_Text,NIL,Txt(t),ID(id)
#define TextNR(t)			TextN(t),Flags(TROF_RIGHTALIGN)
#define CenteredText(t)		HorizGroupSC,Space,TextN(t),Space,EndGroup
#define CenteredTextH(t)		HorizGroupSC,Space,TextH(t),Space,EndGroup
#define CenteredText3(t)		HorizGroupSC,Space,Text3(t),Space,EndGroup
#define CenteredTextB(t)		HorizGroupSC,Space,TextB(t),Space,EndGroup
#define CenteredTextID(t,id)	HorizGroupSC,Space,TextID(t,id),Space,EndGroup
#define CenteredText_BS(t)	HorizGroupSC,SpaceB,TextN(t),SpaceB,EndGroup
#define TextBox(t,id,mwid)	_TextBox,ObjectBackfillB,VertGroup,SpaceS,HorizGroupSC,Space,TextN(t),ID(id),MinWidth(mwid),Space,EndGroup,SpaceS,EndGroup
#define TextRIGHT(t,id)		HorizGroupS,Space,TextN(t),ID(id),EndGroup
#define Integer(i)			TROB_Text,NIL,VAL(i)
#define IntegerH(i)			TROB_Text,NIL,VAL(i),Flags(TRTX_HIGHLIGHT)
#define Integer3(i)			TROB_Text,NIL,VAL(i),Flags(TRTX_3D)
#define IntegerB(i)			TROB_Text,NIL,VAL(i),Flags(TRTX_BOLD)
#define CenteredInteger(i)	HorizGroupSC,Space,Integer(i),Space,EndGroup
#define CenteredIntegerH(i)	HorizGroupSC,Space,IntegerH(i),Space,EndGroup
#define CenteredInteger3(i)	HorizGroupSC,Space,Integer3(i),Space,EndGroup
#define CenteredIntegerB(i)	HorizGroupSC,Space,IntegerB(i),Space,EndGroup
#define IntegerBox(def,id,mwid) GroupBox,ObjectBackfillB,VertGroup,SpaceS,TRGR_Horiz,TRGR_PROPSPACES OR TRGR_CENTER,Space,Integer(def),ID(id),MinWidth(mwid),Space,TRGR_End,0,SpaceS,TRGR_End,0
#define CenteredIntegerBox(def,id,mwid) GroupBox,ObjectBackfillB,VertGroup,SpaceS,TRGR_Horiz,TRGR_CENTER,Space,Integer(def),ID(id),MinWidth(mwid),Space,TRGR_End,0,SpaceS,TRGR_End,0
#define IntegerID(def,id,mwid) VertGroup,TRGR_Horiz,TRGR_CENTER,Integer(def),ID(id),MinWidth(mwid),TRGR_End,0,TRGR_End,0

/* Buttons */
#define Button(t,id)		Butt(NIL),Txt(t),ID(id)
#define ButtonR(t,id)		Butt(NIL),Txt(t),ID(id),Flags(TRBU_RETURNOK)
#define ButtonE(t,id)		Butt(NIL),Txt(t),ID(id),Flags(TRBU_ESCOK)
#define ButtonRE(t,id)		Butt(NIL),Txt(t),ID(id),Flags(TRBU_RETURNOK OR TRBU_ESCOK)
#define CenteredButton(t,i)	HorizGroupSC,Space,Butt(NIL),Txt(t),ID(i),Space,EndGroup
#define CenteredButtonR(t,i)	HorizGroupSC,Space,Butt(NIL),Flags(TRBU_RETURNOK),Txt(t),ID(i),Space,EndGroup
#define CenteredButtonE(t,i)	HorizGroupSC,Space,Butt(NIL),Flags(TRBU_ESCOK),Txt(t),ID(i),Space,EndGroup
#define CenteredButtonRE(t,i)	HorizGroupSC,Space,Butt(NIL),Flags(TRBU_RETURNOK OR TRBU_ESCOK),Txt(t),ID(i),Space,EndGroup
#define EmptyButton(id)		Butt(NIL),EmptyText,ID(id)
#define GetFileButton(id)	Butt(TRBT_GETFILE),EmptyText,ID(id),Flags(TRBU_YRESIZE)
#define GetDrawerButton(id)	Butt(TRBT_GETDRAWER),EmptyText,ID(id),Flags(TRBU_YRESIZE)
#define GetEntryButton(id)	Butt(TRBT_GETENTRY),EmptyText,ID(id),Flags(TRBU_YRESIZE)
#define GetFileButtonS(s,id)	Butt(TRBT_GETFILE),Txt(s),ID(id),Flags(TRBU_YRESIZE)
#define GetDrawerButtonS(s,id)	Butt(TRBT_GETDRAWER),Txt(s),ID(id),Flags(TRBU_YRESIZE)
#define GetEntryButtonS(s,id)	Butt(TRBT_GETENTRY),Txt(s),ID(id),Flags(TRBU_YRESIZE)

/* Lines */
#define Line(flags)				TROB_Line,flags
#define HorizSeparator			HorizGroupEC,Space,Line(TROF_HORIZ),Space,EndGroup
#define VertSeparator			VertGroupEC,Space,Line(TROF_VERT),Space,EndGroup
#define NamedSeparator(t)		HorizGroupEC,Space,Line(TROF_HORIZ),Space,TextT(t),Space,Line(TROF_HORIZ),Space,EndGroup
#define NamedSeparatorI(t,id)		HorizGroupEC,Space,Line(TROF_HORIZ),Space,TextT(t),ID(id),Space,Line(TROF_HORIZ),Space,EndGroup
#define NamedSeparatorN(t)		HorizGroupEC,Line(TROF_HORIZ),Space,TextT(t),Space,Line(TROF_HORIZ),EndGroup
#define NamedSeparatorIN(t,id)	HorizGroupEC,Line(TROF_HORIZ),Space,TextT(t),ID(id),Space,Line(TROF_HORIZ),EndGroup

/* FrameBox */
#define GroupBox				TROB_FrameBox,TRFB_GROUPING
#define NamedFrameBox(t)			TROB_FrameBox,TRFB_FRAMING,Txt(t)
#define _TextBox				TROB_FrameBox,TRFB_TEXT

/* DropBox */
#define DropBox(id)				TROB_DropBox,NIL,ID(id)

/* CheckBox gadget */
#define CheckBox(id)			TROB_CheckBox,NIL,ID(id)
#define CheckBoxC(id)			TROB_CheckBox,NIL,ID(id),VAL(TRUE)
#define CheckBoxLEFT(id)			HorizGroupS,CheckBox(id),Space,EndGroup
#define CheckBoxCLEFT(id)		HorizGroupS,CheckBoxC(id),Space,EndGroup

/* String gadget */
#define StringGadget(def,id)		TROB_String,def,ID(id)
#define StringGadgetM(def,id,max)	TROB_String,def,ID(id),VAL(max)

/* Cycle gadget */
#define CycleGadget(ent,val,id)	TROB_Cycle,ent,ID(id),VAL(val)
#define MXGadget(ent,val,id)		TROB_Cycle,ent,ID(id),VAL(val),Flags(TRCY_MX)
#define MXGadgetR(ent,val,id)		TROB_Cycle,ent,ID(id),VAL(val),Flags(TRCY_MX OR TRCY_RIGHTLABELS)

/* Slider gadget */
#define SliderGadget(mini,maxi,val,id) TROB_Slider,NIL,TRSL_Min,mini,TRSL_Max,maxi,ID(id),VAL(val)

/* Palette gadget */
#define PaletteGadget(val,id)		TROB_Palette,NIL,ID(id),VAL(val)

/* Listview gadget */
#define ListRO(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_READONLY),ID(id),VAL(0),TRLV_Top,top
#define ListSel(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_SELECT),ID(id),VAL(0),TRLV_Top,top
#define ListSS(e,id,top,v)		TROB_Listview,e,Flags(TRLV_NOGAP OR TRLV_SHOWSELECTED),ID(id),VAL(v),TRLV_Top,top
#define ListROC(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_READONLY OR TRLV_NOCURSORKEYS),ID(id),VAL(0),TRLV_Top,top
#define ListSelC(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_SELECT OR TRLV_NOCURSORKEYS),ID(id),VAL(0),TRLV_Top,top
#define ListSSC(e,id,top,v)		TROB_Listview,e,Flags(TRLV_NOGAP OR TRLV_SHOWSELECTED OR TRLV_NOCURSORKEYS),ID(id),VAL(v),TRLV_Top,top
#define ListRON(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_READONLY OR TRLV_NUNUMPADKEYS),ID(id),VAL(0),TRLV_Top,top
#define ListSelN(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_SELECT OR TRLV_NONUMPADKEYS),ID(id),VAL(0),TRLV_Top,top
#define ListSSN(e,id,top,v)		TROB_Listview,e,Flags(TRLV_NOGAP OR TRLV_SHOWSELECTED OR TRLV_NONUMPADKEYS),ID(id),VAL(v),TRLV_Top,top
#define ListROCN(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_READONLY OR TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS),ID(id),VAL(0),TRLV_Top,top
#define ListSelCN(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_SELECT OR TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS),ID(id),VAL(0),TRLV_Top,top
#define ListSSCN(e,id,top,v)		TROB_Listview,e,Flags(TRLV_NOGAP OR TRLV_SHOWSELECTED OR TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS),ID(id),VAL(v),TRLV_Top,top

#define FWListRO(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_READONLY),ID(id),VAL(0),TRLV_Top,top
#define FWListSel(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SELECT),ID(id),VAL(0),TRLV_Top,top
#define FWListSS(e,id,top,v)		TROB_Listview,e,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SHOWSELECTED),ID(id),VAL(v),TRLV_Top,top
#define FWListROC(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_READONLY OR TRLV_NOCURSORKEYS),ID(id),VAL(0),TRLV_Top,top
#define FWListSelC(ent,id,top)	TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SELECT OR TRLV_NOCURSORKEYS),ID(id),VAL(0),TRLV_Top,top
#define FWListSSC(e,id,top,v)		TROB_Listview,e,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SHOWSELECTED OR TRLV_NOCURSORKEYS),ID(id),VAL(v),TRLV_Top,top
#define FWListRON(ent,id,top)		TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_READONLY OR TRLV_NUNUMPADKEYS),ID(id),VAL(0),TRLV_Top,top
#define FWListSelN(ent,id,top)	TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SELECT OR TRLV_NONUMPADKEYS),ID(id),VAL(0),TRLV_Top,top
#define FWListSSN(e,id,top,v)		TROB_Listview,e,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SHOWSELECTED OR TRLV_NONUMPADKEYS),ID(id),VAL(v),TRLV_Top,top
#define FWListROCN(ent,id,top)	TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_READONLY OR TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS),ID(id),VAL(0),TRLV_Top,top
#define FWListSelCN(ent,id,top)	TROB_Listview,ent,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SELECT OR TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS),ID(id),VAL(0),TRLV_Top,top
#define FWListSSCN(e,id,top,v)	TROB_Listview,e,Flags(TRLV_NOGAP OR TRLV_FWFONT OR TRLV_SHOWSELECTED OR TRLV_NOCURSORKEYS OR TRLV_NONUMPADKEYS),ID(id),VAL(v),TRLV_Top,top

/* Progress indicator */
#define Progress(maxi,val,id)		TROB_Progress,maxi,ID(id),VAL(val)

/* Image */
#define BoopsiImage(img)			TROB_Image,img,Flags(TRIM_BOOPSI)
#define BoopsiImageD(img,mw,mh)	TROB_Image,img,MinWidth(mw),MinHeight(mh),Flags(TRIM_BOOPSI)

/* Attributes */
#define ID(id)				TRAT_ID,id
#define VAL(val)			TRAT_Value,(val)
#define EmptyText			TRAT_Text,''
#define Txt(t)				TRAT_Text,t
#define MinWidth(w)			TRAT_MinWidth,(w)
#define MinHeight(h)		TRAT_MinHeight,(h)
#define Flags(f)			TRAT_Flags,(f)
#define Disabled			TRAT_Disabled,TRUE
#define ObjectBackfillWin	TRAT_Backfill,TRBF_WINDOWBACK
#define ObjectBackfillReq	TRAT_Backfill,TRBF_REQUESTERBACK
#define ObjectBackfillB		TRAT_Backfill,TRBF_NONE
#define ObjectBackfillS		TRAT_Backfill,TRBF_SHINE
#define ObjectBackfillSA		TRAT_Backfill,TRBF_SHINE_SHADOW
#define ObjectBackfillSF		TRAT_Backfill,TRBF_SHINE_FILL
#define ObjectBackfillSB		TRAT_Backfill,TRBF_SHINE_BACKGROUND
#define ObjectBackfillA		TRAT_Backfill,TRBF_SHADOW
#define ObjectBackfillAF		TRAT_Backfill,TRBF_SHADOW_FILL
#define ObjectBackfillAB		TRAT_Backfill,TRBF_SHADOW_BACKGROUND
#define ObjectBackfillF		TRAT_Backfill,TRBF_FILL
#define ObjectBackfillFB		TRAT_Backfill,TRBF_FILL_BACKGROUND
#define Butt(b)			TROB_Button,b

/* Requester support */
#define BeginRequester(t,p)	WindowTitle(t),WindowPosition(p),WindowBackfillReq,WindowFlags(TRWF_NOZIPGADGET OR TRWF_NOSIZEGADGET OR TRWF_NOCLOSEGADGET OR TRWF_NODELZIP OR TRWF_NOESCCLOSE),VertGroupA,Space,HorizGroupA,Space,GroupBox,ObjectBackfillB
#define BeginRequesterGads	Space,EndGroup,Space
#define EndRequester		Space,EndGroup,EndProject

/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////// The Triton message // */
/* ////////////////////////////////////////////////////////////////////// */

OBJECT TR_Message
	trm_Project:TR_Project,
	trm_ID,
	trm_Class,
	trm_Data,
	trm_Code,
	trm_Qualifier,
	trm_Seconds,
	trm_Micros,
	trm_App:TR_App
ENDOBJECT

/* Message classes */
#define TRMS_CLOSEWINDOW	1
#define TRMS_ERROR		2
#define TRMS_NEWVALUE	3
#define TRMS_ACTION		4
#define TRMS_ICONDROPPED	5
#define TRMS_KEYPRESSED	6
#define TRMS_HELP		7

/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////// Triton error codes // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRER_OK		0

#define TRER_ALLOCMEM	1
#define TRER_OPENWINDOW	2
#define TRER_WINDOWTOOBIG	3
#define TRER_DRAWINFO	4
#define TRER_OPENFONT	5
#define TRER_CREATEMSGPORT	6
#define TRER_INSTALLOBJECT	7
#define TRER_CREATECLASS		8
#define TRER_NOLOCKPUBSCREEN	9
#define TRER_CREATEMENUS		12
#define TRER_GT_CREATECONTEXT	14
#define TRER_MAXERRORNUM		15

/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////// Tags for TR_OpenProject() // */
/* ////////////////////////////////////////////////////////////////////// */

/* Window/Project */
#define TRWI_Title				(TAG_USER+1)
#define TRWI_Flags				(TAG_USER+2)
#define TRWI_Underscore			(TAG_USER+3)
#define TRWI_Position			(TAG_USER+4)
#define TRWI_CustomScreen		(TAG_USER+5)
#define TRWI_PubScreen			(TAG_USER+6)
#define TRWI_PubScreenName		(TAG_USER+7)
#define TRWI_PropFontAttr		(TAG_USER+8)
#define TRWI_FixedWidthFontAttr	(TAG_USER+9)
#define TRWI_Backfill			(TAG_USER+10)
#define TRWI_ID				(TAG_USER+11)
#define TRWI_Dimensions			(TAG_USER+12)
#define TRWI_ScreenTitle			(TAG_USER+13)

/* Menus */
#define TRMN_Title		(TAG_USER+101)
#define TRMN_Item		(TAG_USER+102)
#define TRMN_Sub		(TAG_USER+103)
#define TRMN_Flags		(TAG_USER+104)

/* General object attributes */
#define TRAT_ID		(TAG_USER+150)
#define TRAT_Flags		(TAG_USER+151)
#define TRAT_Value		(TAG_USER+152)
#define TRAT_Text		(TAG_USER+153)
#define TRAT_Disabled	(TAG_USER+154)
#define TRAT_Backfill	(TAG_USER+155)
#define TRAT_MinWidth	(TAG_USER+156)
#define TRAT_MinHeight	(TAG_USER+157)

#define TROB_USER		(TAG_USER+800)

/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////////// Window flags // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRWF_BACKDROP		1
#define TRWF_NODRAGBAR		2
#define TRWF_NODEPTHGADGET	4
#define TRWF_NOCLOSEGADGET	8
#define TRWF_NOACTIVATE		$10
#define TRWF_NOESCCLOSE		$20
#define TRWF_NOPSCRFALLBACK	$40
#define TRWF_NOZIPGADGET		$80
#define TRWF_ZIPCENTERTOP	$100
#define TRWF_NOMINTEXTWIDTH	$200
#define TRWF_NOSIZEGADGET	$400
#define TRWF_NOFONTFALLBACK	$800
#define TRWF_NODELZIP		$1000
#define TRWF_SIMPLEREFRESH	$2000
#define TRWF_ZIPTOCURRENTPOS	$4000
#define TRWF_APPWINDOW		$8000
#define TRWF_ACTIVATESTRGAD	$10000
#define TRWF_HELP			$20000

/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////////////// Menu flags // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRMF_CHECKIT		1
#define TRMF_CHECKED		2
#define TRMF_DISABLED		4

/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////// Window positions // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRWP_DEFAULT		0
#define TRWP_BELOWTITLEBAR	1
#define TRWP_CENTERTOP		1025
#define TRWP_TOPLEFTSCREEN	1026
#define TRWP_CENTERSCREEN	1027
#define TRWP_CENTERDISPLAY	1028
#define TRWP_MOUSEPOINTER	1029

/* ////////////////////////////////////////////////////////////////////// */
/* //////////////////////////////////////////////////// Backfill types // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRBF_WINDOWBACK		0
#define TRBF_REQUESTERBACK	1
#define TRBF_NONE			2
#define TRBF_SHINE			3
#define TRBF_SHINE_SHADOW	4
#define TRBF_SHINE_FILL		5
#define TRBF_SHINE_BACKGROUND	6
#define TRBF_SHADOW			7
#define TRBF_SHADOW_FILL		8
#define TRBF_SHADOW_BACKGROUND	9
#define TRBF_FILL			10
#define TRBF_FILL_BACKGROUND	11

/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////// Display Object flags // */
/* ////////////////////////////////////////////////////////////////////// */

/* General flags */
#define TROF_RAISED			1
#define TROF_HORIZ			2
#define TROF_VERT			4
#define TROF_RIGHTALIGN		8

/* Text flags */
#define TRTX_NOUNDERSCORE	$100
#define TRTX_HIGHLIGHT		$200
#define TRTX_3D			$400
#define TRTX_BOLD			$800
#define TRTX_TITLE			$1000
#define TRTX_SELECTED		$2000

/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////////////////// Menu entries // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRMN_BARLABEL		(-1)

/* ////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////////////// Tags for TR_CreateApp() // */
/* ////////////////////////////////////////////////////////////////////// */

#define TRCA_Name		(TAG_USER+1)
#define TRCA_LongName	(TAG_USER+2)
#define TRCA_Info		(TAG_USER+3)
#define TRCA_Version	(TAG_USER+4)
#define TRCA_Release	(TAG_USER+5)
#define TRCA_Date		(TAG_USER+6)

/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////// Tags for TR_EasyRequest() // */
/* ////////////////////////////////////////////////////////////////////// */

#define TREZ_ReqPos		(TAG_USER+1)
#define TREZ_LockProject	(TAG_USER+2)
#define TREZ_Return		(TAG_USER+3)
#define TREZ_Title		(TAG_USER+4)
#define TREZ_Activate	(TAG_USER+5)

/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////// The Application Structure // */
/* ////////////////////////////////////////////////////////////////////// */

OBJECT TR_App
	tra_MemPool,
	tra_BitMask,
	tra_LastError,
	tra_Name,
	tra_LongName,
	tra_Info,
	tra_Version,
	tra_Release,
	tra_Date,
	tra_AppPort:MsgPort,
	tra_IDCMPPort:MsgPort,
	tra_Prefs,
	tra_LastProject:TR_Project,
	tra_InputEvent:InputEvent
ENDOBJECT

/* ////////////////////////////////////////////////////////////////////// */
/* ////////////////////////////////////////// The Dimensions Structure // */
/* ////////////////////////////////////////////////////////////////////// */

OBJECT TR_Dimensions
	trd_Left:WORD,
	trd_Top:WORD,
	trd_Width:WORD,
	trd_Heigh:WORD,
	trd_Left2:WORD,
	trd_Top2:WORD,
	trd_Width:WORD,
	trd_Heigh:WORD,
	trd_Zoomed:BYTE,
	reserved[3]:WORD
ENDOBJECT

/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////////////////////// The Project Structure // */
/* ////////////////////////////////////////////////////////////////////// */

OBJECT TR_Project
	trp_App:TR_App,
	trp_Screen:Screen,

	trp_LockedPubScreen:Screen,
	trp_ScreenTitle,

	trp_Window:Window,
	trp_ID,
	trp_AppWindow:AppWindow,

	trp_IDCMPFlags,
	trp_Flags,

	trp_NewMenu:NewMenu,
	trp_NewMenuSize,
	trp_Menu:MENU,
	trp_NextSelect:WORD,

	trp_VisualInfo,
	trp_DrawInfo:DrawInfo,
	trp_UserDimensions:TR_Dimensions,
	trp_Dimensions:TR_Dimensions,

	trp_WindowStdHeight,
	trp_LeftBorder,
	trp_RightBorder,
	trp_TopBorder,
	trp_BottomBorder,
	trp_InnerWidth,
	trp_InnerHeight,
	trp_ZipDimensions[4]:WORD,
	trp_AspectFixing:WORD,

	trp_ObjectList:MinList,
	trp_MenuList:MinList,
	trp_IDList:MinList,
	trp_MemPool,
	trp_HasObjects:BYTE,

	trp_PropAttr:TextAttr,
	trp_FixedWidthAttr:TextAttr,
	trp_PropFont:TextFont,
	trp_FixedWidthFont:TextFont,
	trp_OpenedPropFont:BYTE,
	trp_OpenedFixedWidthFont:BYTE,
	trp_TotalPropFontHeight:WORD,

	trp_BackfillType,
	trp_BackfillHook:HOOK,

	trp_GadToolsGadgetList:Gadget,
	trp_PrevGadget:Gadget,
	trp_NewGadget:NewGadget,

	trp_InvisibleRequest:Requester,
	trp_IsUserLocked:BYTE,

	trp_CurrentID,
	trp_IsCancelDown:BYTE,
	trp_IsShortcutDown:BYTE,
	trp_Underscore:BYTE,

	trp_EscClose:BYTE,
	trp_DelZip:BYTE,
	trp_PubScreenFallBack:BYTE,
	trp_FontFallBack:BYTE,

	trp_OldWidth:WORD,
	trp_OldHeight:WORD
ENDOBJECT

/* ////////////////////////////////////////////////////////////////////// */
/* ///////////////////////////// Default classes, attributes and flags // */
/* ////////////////////////////////////////////////////////////////////// */

/* Classes */

#define TROB_Button		(TAG_USER+305)
#define TROB_CheckBox	(TAG_USER+303)
#define TROB_Cycle		(TAG_USER+310)
#define TROB_FrameBox	(TAG_USER+306)
#define TROB_DropBox	(TAG_USER+312)
#define TRGR_Horiz		(TAG_USER+201)
#define TRGR_Vert		(TAG_USER+202)
#define TRGR_End		(TAG_USER+203)
#define TROB_Line		(TAG_USER+301)
#define TROB_Palette	(TAG_USER+307)
#define TROB_Scroller	(TAG_USER+309)
#define TROB_Slider		(TAG_USER+308)
#define TROB_Space		(TAG_USER+901)
#define TROB_String		(TAG_USER+311)
#define TROB_Text		(TAG_USER+304)
#define TROB_Listview	(TAG_USER+313)
#define TROB_Progress	(TAG_USER+314)
#define TROB_Image		(TAG_USER+315)

/* Button */
#define TRBU_RETURNOK	$10000
#define TRBU_ESCOK		$20000
#define TRBU_SHIFTED	$40000
#define TRBU_UNSHIFTED	$80000
#define TRBU_YRESIZE	$100000
#define TRBT_TEXT		0
#define TRBT_GETFILE	1
#define TRBT_GETDRAWER	2
#define TRBT_GETENTRY	3

/* Group */
#define TRGR_PROPSHARE	0
#define TRGR_EQUALSHARE	1
#define TRGR_PROPSPACES	2
#define TRGR_ARRAY		4

#define TRGR_ALIGN		8
#define TRGR_CENTER		$10

#define TRGR_FIXHORIZ	$20
#define TRGR_FIXVERT	$40
#define TRGR_INDEP		$80

/* Framebox */
#define TRFB_GROUPING	1
#define TRFB_FRAMING	2
#define TRFB_TEXT		4

/* Scroller */
#define TRSC_Total		(TAG_USER+1504)
#define TRSC_Visible	(TAG_USER+1505)

/* Slider */
#define TRSL_Min		(TAG_USER+1502)
#define TRSL_Max		(TAG_USER+1503)

/* Space */
#define TRST_NONE		1
#define TRST_SMALL		2
#define TRST_NORMAL		3
#define TRST_BIG		4

/* Listview */
#define TRLV_Top		(TAG_USER+1506)
#define TRLV_READONLY	$10000
#define TRLV_SELECT		$20000
#define TRLV_SHOWSELECTED	$40000
#define TRLV_NOCURSORKEYS	$80000
#define TRLV_NONUMPADKEYS	$100000
#define TRLV_FWFONT			$200000
#define TRLV_NOGAP			$400000

/* Image */
#define TRIM_BOOPSI		$10000

/* Cycle */
#define TRCY_MX		$10000
#define TRCY_RIGHTLABELS	$20000

/* ////////////////////////////////////////////////////////////////////// */
/* /////////////////////////////////////////////////////////// The End // */
/* ////////////////////////////////////////////////////////////////////// */
