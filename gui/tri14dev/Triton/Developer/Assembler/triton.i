	IFND LIBRARIES_TRITON_I
LIBRARIES_TRITON_I SET 1
**
**	$Filename: libraries/triton.i $
**	$Release: 1.1 $
**	$Revision: 2.54 $
**
**	triton.library definitions
**
**	Translated to assembly language by Oskar Liljeblad
**
**	(C) Copyright 1991-1994 Stefan Zeiger
**	All Rights Reserved
**

TRITONNAME   MACRO
       DC.B  'triton.library',0
       ENDM

TRITON10VERSION		EQU	1
TRITON11VERSION		EQU	2

* ////////////////////////////////////////////////////////////////////// *
* ////////////////////////////////////////////////////////// Includes // *
* ////////////////////////////////////////////////////////////////////// *

   IFND EXEC_TYPES_I
   include "exec/types.i"
   ENDC

   IFND INTUITION_INTUITIONBASE_I
   include "intuition/intuitionbase.i"
   ENDC

   IFND INTUITION_INTUITION_I
   include "intuition/intuition.i"
   ENDC

   IFND INTUITION_GADGETCLASS_I
   include "intuition/gadgetclass.i"
   ENDC

   IFND INTUITION_IMAGECLASS_I
   include "intuition/imageclass.i"
   ENDC

   IFND INTUITION_CLASSUSR_I
   include "intuition/classusr.i"
   ENDC

   IFND GRAPHICS_GFXBASE_I
   include "graphics/gfxbase.i"
   ENDC

   IFND LIBRARIES_GADTOOLS_I
   include "libraries/gadtools.i"
   ENDC

   IFND LIBRARIES_DISKFONT_I
   include "libraries/diskfont.i"
   ENDC

   IFND UTILITY_TAGITEM_I
   include "utility/tagitem.i"
   ENDC

   IFND WORKBENCH_STARTUP_I
   include "workbench/startup.i"
   ENDC

   IFND WORKBENCH_WORKBENCH_I
   include "workbench/workbench.i"
   ENDC


* ////////////////////////////////////////////////////////////////////// *
* //////////////////////////////////////////////////////////// Macros // *
* ////////////////////////////////////////////////////////////////////// *

; implementors note: fix these bloody macros layout (tabs, spaces etc)!

 IFND TR_NOMACROS

* Project

				* ProjectDefinition(name) struct TagItem name[]=

EndProject	MACRO		* EndProject TAG_END
		DC.L TAG_END
		ENDM

WindowTitle	MACRO		* WridowTitle(t) TRWI_Title,(t)
		DC.L TRWI_Title,\1
		ENDM

ScreenTitle	MACRO		* ScreenTitle(t) TRWI_ScreenTitle,(t)
		DC.L TRWI_ScreenTitle,\1
		ENDM

WindowID	MACRO		* WindowID(id) TRWI_ID,(id)
		DC.L TRWI_ID,\1
		ENDM

WindowFlags	MACRO		* WindowFlags(f) TRWI_Flags,(ULONG)(f)
		DC.L TRWI_Flags,\1
		ENDM

WindowPosition	MACRO		* WindowPosition(pos) TRWI_Position,(pos)
		DC.L TRWI_Position,\1
		ENDM

WindowUnderscore   MACRO	* WindowUnderscore(und) TRWI_Underscore,(und)
		DC.L TRWI_Underscore,\1
		ENDM

WindowDimensions   MACRO	* WindowDimensions(dim) TRWI_Dimensions,(dim)
		DC.L TRWI_Dimensions,\1
		ENDM

WindowBackfillWin   MACRO	* WindowBackfillWin TRWI_Backfill,TRBF_WINDOWBACK
		DC.L TRWI_Backfill,TRBF_WINDOWBACK
		ENDM

WindowBackfillReq   MACRO	* WindowBackfillReq TRWI_Backfill,TRBF_REQUESTERBACK
		DC.L TRWI_Backfill,TRBF_REQUESTERBACK
		ENDM

WindowBackfillNon   MACRO	* WindowBackfillNone TRWI_Backfill,TRBF_NONE
		DC.L TRWI_Backfill,TRBF_NONE
		ENDM

WindowBackfillS	MACRO		* WindowBackfillS TRWI_Backfill,TRBF_SHINE
		DC.L TRWI_Backfill,TRBF_SHINE
		ENDM

WindowBackfillSA   MACRO	* WindowBackfillSA TRWI_Backfill,TRBF_SHINE_SHADOW
		DC.L TRWI_Backfill,TRBF_SHINE_SHADOW
		ENDM

WindowBackfillSF   MACRO	* WindowBackfillSF TRWI_Backfill,TRBF_SHINE_FILL
		DC.L TRWI_Backfill,TRBF_SHINE_FILL
		ENDM

WindowBackfillSB   MACRO	* WindowBackfillSB TRWI_Backfill,TRBF_SHINE_BACKGROUND
		DC.L TRWI_Backfill,TRBF_SHINE_BACKGROUND
		ENDM

WindowBackfillA	MACRO		* WindowBackfillA TRWI_Backfill,TRBF_SHADOW
		DC.L TRWI_Backfill,TRBF_SHADOW
		ENDM

WindowBackfillAF   MACRO	* WindowBackfillAF TRWI_Backfill,TRBF_SHADOW_FILL
		DC.L TRWI_Backfill,TRBF_SHADOW_FILL
		ENDM

WindowBackfillAB   MACRO	* WindowBackfillAB TRWI_Backfill,TRBF_SHADOW_BACKGROUND
		DC.L TRWI_Backfill,TRBF_SHADOW_BACKGROUND
		ENDM

WindowBackfillF	MACRO		* WindowBackfillF TRWI_Backfill,TRBF_FILL
		DC.L TRWI_Backfill,TRBF_FILL
		ENDM

WindowBackfillFB   MACRO	* WindowBackfillFB TRWI_Backfill,TRBF_FILL_BACKGROUND
		DC.L TRWI_Backfill,TRBF_FILL_BACKGROUND
		ENDM

CustomScreen	MACRO		* CustomScreen(scr) TRWI_CustomScreen,(scr)
		DC.L TRWI_CustomScreen,\1
		ENDM

PubScreen	MACRO		* PubScreen(scr) TRWI_PubScreen,(scr)
		DC.L TRWI_PubScreen,\1
		ENDM

PubScreenName	MACRO		* PubScreenName(name) TRWI_PubScreenName,(name)
		DC.L TRWI_PubScreenName,\1
		ENDM

* Menus

BeginMenu	MACRO		* BeginMenu(t) TRMN_Title,(ULONG)(t)
		DC.L TRMN_Title,\1
		ENDM

MenuFlags	MACRO		* MenuFlags(f) TRMN_Flags,(f)
		DC.L TRMN_Flags,\1
		ENDM

MenuItem	MACRO		* MenuItem(t,id) TRMN_Item,(ULONG)(t),TRAT_ID,id
		DC.L TRMN_Item,\1,TRAT_ID,\2
		ENDM

BeginSub	MACRO		* BeginSub(t) TRMN_Item,(ULONG)(t)
		DC.L TRMN_Item,\1
		ENDM

MenuItemD	MACRO		* MenuItemD(t,id) TRMN_Item,(ULONG)(t),MenuFlags(TRMF_DISABLED),TRAT_ID,id
		DC.L TRMN_Item,\1
		MenuFlags TRMF_DISABLED
		DC.L TRAT_ID,\2
		ENDM

SubItem		MACRO		* SubItem(t,id) TRMN_Sub,(ULONG)(t),TRAT_ID,id
		DC.L TRMN_Sub,\1,TRAT_ID,\2
		ENDM

SubItemD	MACRO		* SubItemD(t,id) TRMN_Sub,(ULONG)(t),MenuFlags(TRMF_DISABLED),TRAT_ID,id
		DC.L TRMN_Sub,\1
		MenuFlags TRMF_DISABLED
		DC.L TRAT_ID,\2
		ENDM

ItemBarlabel	MACRO		* ItemBarlabel TRMN_Item,TRMN_BARLABEL
		DC.L TRMN_Item,TRMN_BARLABEL
		ENDM

SubBarlabel	MACRO		* SubBarlabel TRMN_Sub,TRMN_BARLABEL
		DC.L TRMN_Sub,TRMN_BARLABEL
		ENDM

* Group

HorizGroup	MACRO		* HorizGroup TRGR_Horiz,NULL
		DC.L TRGR_Horiz,0
		ENDM

HorizGroupE	MACRO		* HorizGroupE TRGR_Horiz,TRGR_EQUALSHARE
		DC.L TRGR_Horiz,TRGR_EQUALSHARE
		ENDM

HorizGroupS	MACRO		* HorizGroupS TRGR_Horiz,TRGR_PROPSPACES
		DC.L TRGR_Horiz,TRGR_PROPSPACES
		ENDM

HorizGroupA	MACRO		* HorizGroupA TRGR_Horiz,TRGR_ALIGN
		DC.L TRGR_Horiz,TRGR_ALIGN
		ENDM

HorizGroupEA	MACRO		* HorizGroupEA TRGR_Horiz,TRGR_EQUALSHARE|TRGR_ALIGN
		DC.L TRGR_Horiz,TRGR_EQUALSHARE!TRGR_ALIGN
		ENDM

HorizGroupSA	MACRO		* HorizGroupSA TRGR_Horiz,TRGR_PROPSPACES|TRGR_ALIGN
		DC.L TRGR_Horiz,TRGR_PROPSPACES!TRGR_ALIGN
		ENDM

HorizGroupC	MACRO		* HorizGroupC TRGR_Horiz,TRGR_CENTER
		DC.L TRGR_Horiz,TRGR_CENTER
		ENDM

HorizGroupEC    MACRO		* HorizGroupEC TRGR_Horiz,TRGR_EQUALSHARE|TRGR_CENTER
		DC.L TRGR_Horiz,TRGR_EQUALSHARE!TRGR_CENTER
		ENDM

HorizGroupSC	MACRO		* HorizGroupSC TRGR_Horiz,TRGR_PROPSPACES|TRGR_CENTER
		DC.L TRGR_Horiz,TRGR_PROPSPACES!TRGR_CENTER
		ENDM

HorizGroupAC	MACRO		* HorizGroupAC TRGR_Horiz,TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Horiz,TRGR_ALIGN!TRGR_CENTER
		ENDM

HorizGroupEAC	MACRO		* HorizGroupEAC TRGR_Horiz,TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Horiz,TRGR_EQUALSHARE!TRGR_ALIGN!TRGR_CENTER
		ENDM

HorizGroupSAC	MACRO		* HorizGroupSAC TRGR_Horiz,TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Horiz,TRGR_PROPSPACES!TRGR_ALIGN!TRGR_CENTER
		ENDM

VertGroup	MACRO		* VertGroup TRGR_Vert,NULL
		DC.L TRGR_Vert,0
		ENDM

VertGroupE	MACRO		* VertGroupE TRGR_Vert,TRGR_EQUALSHARE
		DC.L TRGR_Vert,TRGR_EQUALSHARE
		ENDM

VertGroupS	MACRO		* VertGroupS TRGR_Vert,TRGR_PROPSPACES
		DC.L TRGR_Vert,TRGR_PROPSPACES
		ENDM

VertGroupA	MACRO		* VertGroupA TRGR_Vert,TRGR_ALIGN
		DC.L TRGR_Vert,TRGR_ALIGN
		ENDM

VertGroupEA	MACRO		* VertGroupEA TRGR_Vert,TRGR_EQUALSHARE|TRGR_ALIGN
		DC.L TRGR_Vert,TRGR_EQUALSHARE!TRGR_ALIGN
		ENDM

VertGroupSA	MACRO		* VertGroupSA TRGR_Vert,TRGR_PROPSPACES|TRGR_ALIGN
		DC.L TRGR_Vert,TRGR_PROPSPACES!TRGR_ALIGN
		ENDM

VertGroupC	MACRO		* VertGroupC TRGR_Vert,TRGR_CENTER
		DC.L TRGR_Vert,TRGR_CENTER
		ENDM

VertGroupEC	MACRO		* VertGroupEC TRGR_Vert,TRGR_EQUALSHARE|TRGR_CENTER
		DC.L TRGR_Vert,TRGR_EQUALSHARE!TRGR_CENTER
		ENDM

VertGroupSC	MACRO		* VertGroupSC TRGR_Vert,TRGR_PROPSPACES|TRGR_CENTER
		DC.L TRGR_Vert,TRGR_PROPSPACES!TRGR_CENTER
		ENDM

VertGroupAC	MACRO		* VertGroupAC TRGR_Vert,TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Vert,TRGR_ALIGN!TRGR_CENTER
		ENDM

VertGroupEAC	MACRO		* VertGroupEAC TRGR_Vert,TRGR_EQUALSHARE|TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Vert,TRGR_EQUALSHARE!TRGR_ALIGN!TRGR_CENTER
		ENDM

VertGroupSAC	MACRO		* VertGroupSAC TRGR_Vert,TRGR_PROPSPACES|TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Vert,TRGR_PROPSPACES!TRGR_ALIGN!TRGR_CENTER
		ENDM

EndGroup	MACRO		* EndGroup TRGR_End,NULL
		DC.L TRGR_End,0
		ENDM

ColumnArray	MACRO		* ColumnArray TRGR_Horiz,TRGR_ARRAY|TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Horiz,TRGR_ARRAY!TRGR_ALIGN!TRGR_CENTER
		ENDM

LineArray	MACRO		* LineArray TRGR_Vert,TRGR_ARRAY|TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Vert,TRGR_ARRAY!TRGR_ALIGN!TRGR_CENTER
		ENDM

BeginColumn	MACRO		* BeginColumn TRGR_Vert,TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Vert,TRGR_PROPSHARE!TRGR_ALIGN!TRGR_CENTER
		ENDM

BeginLine	MACRO		* BeginLine TRGR_Horiz,TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER
		DC.L TRGR_Horiz,TRGR_PROPSHARE!TRGR_ALIGN!TRGR_CENTER
		ENDM

BeginColumnI	MACRO		* BeginColumnI TRGR_Vert,TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER|TRGR_INDEP
		DC.L TRGR_Vert,TRGR_PROPSHARE!TRGR_ALIGN!TRGR_CENTER!TRGR_INDEP
		ENDM

BeginLineI	MACRO		* BeginLineI TRGR_Horiz,TRGR_PROPSHARE|TRGR_ALIGN|TRGR_CENTER|TRGR_INDEP
		DC.L TRGR_Horiz,TRGR_PROPSHARE!TRGR_ALIGN!TRGR_CENTER!TRGR_INDEP
		ENDM

EndColumn	MACRO		* EndColumn EndGroup
		DC.L EndGroup
		ENDM

EndLine		MACRO		* EndLine EndGroup
		DC.L EndGroup
		ENDM

EndArray	MACRO		* EndArray EndGroup
		DC.L EndGroup
		ENDM

* Spaces

SpaceB		MACRO		* SpaceB TROB_Space,TRST_BIG
		DC.L TROB_Space,TRST_BIG
		ENDM

Space		MACRO		* Space TROB_Space,TRST_NORMAL
		DC.L TROB_Space,TRST_NORMAL
		ENDM

SpaceS		MACRO		* SpaceS TROB_Space,TRST_SMALL
		DC.L TROB_Space,TRST_SMALL
		ENDM

SpaceN		MACRO		* SpaceN TROB_Space,TRST_NONE
		DC.L TROB_Space,TRST_NONE
		ENDM

* Text

TextN		MACRO		* TextN(text) TROB_Text,NULL,TRAT_Text,(ULONG)text
		DC.L TROB_Text,0
		DC.L TRAT_Text,\1
		ENDM

TextH		MACRO		* TextH(text) TROB_Text,NULL,TRAT_Text,(ULONG)text,TRAT_Flags,TRTX_HIGHLIGHT
		DC.L TROB_Text,NULL,TRAT_Text,\1,TRAT_Flags,TRTX_HIGHLIGHT
		ENDM

Text3		MACRO		* Text3(text) TROB_Text,NULL,TRAT_Text,(ULONG)text,TRAT_Flags,TRTX_3D
		DC.L TROB_Text,0
		DC.L TRAT_Text,\1
		DC.L TRAT_Flags,TRTX_3D
		ENDM

TextB		MACRO		* TextB(text) TROB_Text,NULL,TRAT_Text,(ULONG)text,TRAT_Flags,TRTX_BOLD
		DC.L TROB_Text,0
		DC.L TRAT_Text,\1
		DC.L TRAT_Flags,TRTX_BOLD
		ENDM

TextT		MACRO		* TextT(text) TROB_Text,NULL,TRAT_Text,(ULONG)text,TRAT_Flags,TRTX_TITLE
		DC.L TROB_Text,0
		DC.L TRAT_Text,\1
		DC.L TRAT_Flags,TRTX_TITLE
		ENDM

TextID		MACRO		* TextID(text,id) TROB_Text,NULL,TRAT_Text,(ULONG)text,TRAT_ID,id
		DC.L TROB_Text,0
		DC.L TRAT_Text,\1
		DC.L TRAT_ID,\2
		ENDM

TextNR		MACRO		* TextNR(t) TextN(t),TRAT_Flags,TROF_RIGHTALIGN
		TextN \1
		DC.L TRAT_Flags,TROF_RIGHTALIGN
		ENDM

CenteredText	MACRO		* CenteredText(text) HorizGroupSC,Space,TextN(text),Space,EndGroup
		HorizGroupSC
			Space
			TextN \1
			Space
		EndGroup
		ENDM

CenteredTextH	MACRO		* CenteredTextH(text) HorizGroupSC,Space,TextH(text),Space,EndGroup
		HorizGroupSC
			Space
			TextH \1
			Space
		EndGroup
		ENDM

CenteredText3	MACRO		* CenteredText3(text) HorizGroupSC,Space,Text3(text),Space,EndGroup
		HorizGroupSC
			Space
			Text3 \1
			Space
		EndGroup
		ENDM

CenteredTextB	MACRO		* CenteredTextB(text) HorizGroupSC,Space,TextB(text),Space,EndGroup
		HorizGroupSC
			Space
			TextB \1
			Space
		EndGroup
		ENDM

CenteredTextID	MACRO		* CenteredTextID(text,id) HorizGroupSC,Space,TextID(text,id),Space,EndGroup
		HorizGroupSC
			Space
			TextID \1,\2
			Space
		EndGroup
		ENDM

CenteredText_BS	MACRO		* CenteredText_BS(text) HorizGroupSC,SpaceB,TextN(text),SpaceB,EndGroup
		HorizGroupSC
			SpaceB
			TextN \1
			SpaceB
		EndGroup
		ENDM

TextBox		MACRO		* TextBox(text,id,mwid) _TextBox, ObjectBackfillB, VertGroup, SpaceS, HorizGroupSC, Space, TextN(text),TRAT_ID,id,TRAT_MinWidth,mwid, Space, EndGroup, SpaceS, EndGroup
		_TextBox
			ObjectBackfillB
			VertGroup
				SpaceS
				HorizGroupSC
				Space
				TextN \1
				DC.L TRAT_ID,\2
				DC.L TRAT_MinWidth,\3
				Space,
			EndGroup,
			SpaceS,
		EndGroup
		ENDM

TextRIGHT	MACRO		* TextRIGHT(t,id) HorizGroupS, Space, TextN(t), ID(id), EndGroup
		HorizGroupS
			Space
			TextN \1
			ID \2
		EndGroup
		ENDM

Integer		MACRO		* Integer(i) TROB_Text,NULL,TRAT_Value,(ULONG)(i)
		DC.L TROB_Text,0
		DC.L TRAT_Value,\1
		ENDM

IntegerH	MACRO		* IntegerH(i) TROB_Text,NULL,TRAT_Value,(ULONG)(i),TRAT_Flags,TRTX_HIGHLIGHT
		DC.L TROB_Text,0
		DC.L TRAT_Value,\1
		DC.L TRAT_Flags,TRTX_HIGHLIGHT
		ENDM

Integer3	MACRO		* Integer3(i) TROB_Text,NULL,TRAT_Value,(ULONG)(i),TRAT_Flags,TRTX_3D
		DC.L TROB_Text,0
		DC.L TRAT_Value,\1
		DC.L TRAT_Flags,TRTX_3D
		ENDM

IntegerB	MACRO		* IntegerB(i) TROB_Text,NULL,TRAT_Value,(ULONG)(i),TRAT_Flags,TRTX_BOLD
		DC.L TROB_Text,0
		DC.L TRAT_Value,\1
		DC.L TRAT_Flags,TRTX_BOLD
		ENDM

CenteredInteger	MACRO		* CenteredInteger(i) HorizGroupSC,Space,Integer(i),Space,EndGroup
		HorizGroupSC
			Space
			Integer \1
			Space
		EndGroup
		ENDM

CenteredIntegerH   MACRO	* CenteredIntegerH(i) HoizGroupSC,Space,IntegerH(i),Space,EndGroup
		HorizGroupSC
			Space
			IntegerH   \1
			Space
		EndGroup
		ENDM

CenteredInteger3   MACRO	* CenteredInteger3(i) HorizGroupSC,Space,Integer3(i),Space,EndGroup
		HorizGroupSC
			Space
			Integer3   \1
			Space
		EndGroup
		ENDM

CenteredIntegerB   MACRO	* CenteredIntegerB(i) HorizGroupSC,Space,IntegerB(i),Space,EndGroup
		HorizGroupSC
			Space
			IntegerB   \1
			Space
		EndGroup
		ENDM

IntegerBox	MACRO		* IntegerBox(def,id,mwid) GroupBox, ObjectBackfillB, VertGroup, SpaceS, HorizGroupSC, Space, Integer(def),TRAT_ID,id,TRAT_MinWidth,mwid, Space, EndGroup, SpaceS, EndGroup
		GroupBox
			ObjectBackfillB
			VertGroup
				SpaceS
				HorizGroupSC
				Space
				Integer \1
				DC.L TRAT_ID,\2
				DC.L TRAT_MinWidth,\3
				Space
			EndGroup
			SpaceS
		EndGroup
		ENDM

Button		MACRO		* Button(text,id) TROB_Button,NULL,TRAT_Text,(ULONG)(text),TRAT_ID,(id)
		DC.L TROB_Button,0
		DC.L TRAT_Text,\1
		DC.L TRAT_ID,\2
		ENDM

ButtonR		MACRO		* ButtonR(text,id) TROB_Button,NULL,TRAT_Text,(ULONG)(text),TRAT_ID,(id),TRAT_Flags,TRBU_RETURNOK
		DC.L TROB_Button,0
		DC.L TRAT_Text,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Flags,TRBU_RETURNOK
		ENDM

ButtonE		MACRO		* ButtonE(text,id) TROB_Button,NULL,TRAT_Text,(ULONG)(text),TRAT_ID,(id),TRAT_Flags,TRBU_ESCOK
		DC.L TROB_Button,0
		DC.L TRAT_Text,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Flags,TRBU_ESCOK
		ENDM

ButtonRE	MACRO		* ButtonRE(text,id) TROB_Button,NULL,TRAT_Text,(ULONG)(text),TRAT_ID,(id),TRAT_Flags,TRBU_RETURNOK|TRBU_ESCOK
		DC.L TROB_Button,0
		DC.L TRAT_Text,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Flags,TRBU_RETURNOK!TRBU_ESCOK
		ENDM

CenteredButton	MACRO		* CenteredButton(t,i) HorizGroupSC,Space,TROB_Button,NULL,TRAT_Text,(ULONG)(t),TRAT_ID,(i),Space,EndGroup
		HorizGroupSC
			Space
			DC.L TROB_Butto,0
			DC.L TRAT_Text,\1
			DC.L TRAT_ID,\2
			Space
		EndGroup
		ENDM

CenteredButtonR	MACRO		* CenteredButtonR(t,i) HorizGroupSC,Space,TROB_Button,NULL,TRAT_Flags,TRBU_RETURNOK,TRAT_Text,(ULONG)(t),TRAT_ID,(i),Space,EndGroup
		HorizGroupSC
			Space
			DC.L TROB_Button,0
			DC.L TRAT_Flags,TRBU_RETURNOK
			DC.L TRAT_Text,\1
			DC.L TRAT_ID,\2
			Space
		EndGroup
		ENDM

CenteredButtonE	MACRO		* CenteredButtonE(t,i) HorizGroupSC,Space,TROB_Button,NULL,TRAT_Flags,TRBU_ESCOK,TRAT_Text,(ULONG)(t),TRAT_ID,(i),Space,EndGroup
		HorizGroupSC
			Space
			DC.L TROB_Button,0
			DC.L TRAT_Flags,TRBU_ESCOK
			DC.L TRAT_Text,\1
			DC.L TRAT_ID,\2
			Space
		EndGroup
		ENDM

CenteredButtonRE   MACRO	* CenteredButtonRE(t,i) HorizGroupSC,Space,TROB_Button,NULL,TRAT_Flags,TRBU_RETURNOK|TRBU_ESCOK,TRAT_Text,(ULONG)(t),TRAT_ID,(i),Space,EndGroup
		HorizGroupSC
			Space
			DC.L TROB_Button,0
			DC.L TRAT_Flags,TRBU_RETURNOK!TRBU_ESCOK
			DC.L TRAT_Text,\1
			DC.L TRAT_ID,\2
			Space
		EndGroup
		ENDM

				* EmptyButton(id) TROB_Button,NULL,TRAT_Text,(ULONG)"",TRAT_ID,(id)

				* GetFileButton(id) TROB_Button,TRBT_GETFILE,TRAT_Text,(ULONG)"",TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE

				* GetDrawerButton(id) TROB_Button,TRBT_GETDRAWER,TRAT_Text,(ULONG)"",TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE

				* GetEntryButton(id) TROB_Button,TRBT_GETENTRY,TRAT_Text,(ULONG)"",TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE

GetFileButtonS	MACRO		* GetFileButtonS(s,id) TROB_Button,TRBT_GETFILE,TRAT_Text,(ULONG)(s),TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE
		DC.L TROB_Button,TRBT_GETFILE
		DC.L TRAT_Text,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Flags,TRBU_YRESIZE
		ENDM

GetDrawerButtonS   MACRO	* GetDrawerButtonS(s,id) TROB_Button,TRBT_GETDRAWER,TRAT_Text,(ULONG)(s),TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE
		DC.L TROB_Button,TRBT_GETDRAWER
		DC.L TRAT_Text,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Flags,TRBU_YRESIZE
		ENDM

GetEntryButtonS	MACRO		* GetEntryButtonS(s,id) TROB_Button,TRBT_GETENTRY,TRAT_Text,(ULONG)(s),TRAT_ID,(id),TRAT_Flags,TRBU_YRESIZE
		DC.L TROB_Button,TRBT_GETENTRY
		DC.L TRAT_Text,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Flags,TRBU_YRESIZE
		ENDM

* Lines

Line		MACRO		* Line(flags) TROB_Line,flags
		DC.L TROB_Line,\1
		ENDM

HorizSeparator	MACRO		* HorizSeparator HorizGroupEC,Space,Line(TROF_HORIZ),Space,EndGroup
		HorizGroupEC
			Space
			Line	TROF_HORIZ
			Space
		EndGroup
		ENDM

VertSeparator	MACRO		* VertSeparator VertGroupEC,Space,Line(TROF_VERT),Space,EndGroup
		VertGroupEC
			Space
			Line	TROF_VERT
			Space
		EndGroup
		ENDM

NamedSeparator	MACRO		* NamedSeparator(text) HorizGroupEC,Space,Line(TROF_HORIZ),Space,TextT(text),Space,Line(TROF_HORIZ),Space,EndGroup
		HorizGroupEC
			Space
			Line	TROF_HORIZ
			Space
			TextT \1
			Space
			Line	TROF_HORIZ
			Space
		EndGroup
		ENDM

NamedSeparatorI	MACRO		* NamedSeparatorI(te,id) HorizGroupEC,Space,Line(TROF_HORIZ),Space,TextT(te),TRAT_ID,id,Space,Line(TROF_HORIZ),Space,EndGroup
		HorizGroupEC
			Space
			Line	TROF_HORIZ
			Space
			TextT \1
			DC.L TRAT_ID,\2
			Space
			Line	TROF_HORIZ
			Space
		EndGroup
		ENDM

NamedSeparatorN	MACRO		* NamedSeparatorN(text) HorizGroupEC,Line(TROF_HORIZ),Space,TextT(text),Space,Line(TROF_HORIZ),EndGroup
		HorizGroupEC
			Line	TROF_HORIZ
			Space
			TextT \1
			Space
			Line	TROF_HORIZ
		EndGroup
		ENDM

NamedSeparatorIN   MACRO	* NamedSeparatorIN(te,id) HorizGroupEC,Line(TROF_HORIZ),Space,TextT(te),TRAT_ID,id,Space,Line(TROF_HORIZ),EndGroup
		HorizGroupEC
			Line	TROF_HORIZ
			Space
			TextT \1
			DC.L TRAT_ID,\2
			Space
			Line	TROF_HORIZ
		EndGroup
		ENDM

* FrameBox

GroupBox	MACRO		* GroupBox TROB_FrameBox,TRFB_GROUPING
		DC.L TROB_FrameBox,TRFB_GROUPING
		ENDM

NamedFrameBox	MACRO		* NamedFrameBox(t) TROB_FrameBox,TRFB_FRAMING,TRAT_Text,(ULONG)(t)
		DC.L TROB_FrameBox,TRFB_FRAMING
		DC.L TRAT_Text,\1
		ENDM

_TextBox	MACRO		* _TextBox TROB_FrameBox,TRFB_TEXT
		DC.L TROB_FrameBox,TRFB_TEXT
		ENDM

* DropBox

DropBox		MACRO		* DropBox(id) TROB_DropBox,NULL,TRAT_ID,(id)
		DC.L TROB_DropBox,0
		DC.L TRAT_ID,\1
		ENDM

* CheckBox gadget

CheckBox	MACRO		* CheckBox(id) TROB_CheckBox,NULL,TRAT_ID,id
		DC.L TROB_CheckBox,0
		DC.L TRAT_ID,\1
		ENDM

CheckBoxC	MACRO		* CheckBoxC(id) TROB_CheckBox,NULL,TRAT_ID,id,TRAT_Value,TRUE
		DC.L TROB_CheckBox,0
		DC.L TRAT_ID,\1
		DC.L TRAT_Value,TRUE
		ENDM

CheckBoxLEFT	MACRO		* CheckBoxLEFT(id) HorizGroupS, CheckBox(id), Space, EndGroup
		HorizGroupS
			CheckBox   \1
			Space
		EndGroup
		ENDM

CheckBoxCLEFT	MACRO		* CheckBoxCLEFT(id) HorizGroupS, CheckBoxC(id), Space, EndGroup
		HorizGroupS
			CheckBoxC   \1
			Space
		EndGroup
		ENDM

* String gadget

StringGadget	MACRO		* StringGadget(def,id) TROB_String,(ULONG)def,TRAT_ID,(id)
		DC.L TROB_String,\1
		DC.L TRAT_ID,\1
		ENDM

* Cycle gadget

CycleGadget	MACRO		* CycleGadget(ent,val,id) TROB_Cycle,(ULONG)ent,TRAT_ID,(id),TRAT_Value,(val)
		DC.L TROB_Cycle,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		ENDM

MXGadget	MACRO		* MXGadget(ent,val,id) TROB_Cycle,(ULONG)ent,TRAT_ID,(id),TRAT_Value,(val),TRAT_Flags,TRCY_MX
		DC.L TROB_Cycle,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRAT_Flags,TRCY_MX
		ENDM

MXGadgetR	MACRO		* MXGadgetR(ent,val,id) TROB_Cycle,(ULONG)ent,TRAT_ID,(id),TRAT_Value,(val),TRAT_Flags,TRCY_MX|TRCY_RIGHTLABELS
		DC.L TROB_Cycle,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRAT_Flags,TRCY_MX!TRCY_RIGHTLABELS
		ENDM

* Slider gadget

SliderGadget	MACRO		* SliderGadget(mini,maxi,val,id) TROB_Slider,NULL,TRSL_Min,(mini),TRSL_Max,(maxi),TRAT_ID,(id),TRAT_Value,(val)
		DC.L TROB_Slider,0
		DC.L TRSL_Min,\1
		DC.L TRSL_Max,\2
		DC.L TRAT_ID,\3
		DC.L TRAT_Value,\4
		ENDM

* Palette gadget

PaletteGadget	MACRO		* PaletteGadget(val,id) TROB_Palette,NULL,TRAT_ID,(id),TRAT_Value,(val)
		DC.L TROB_Palette,0
		DC.L TRAT_ID,\1
		DC.L TRAT_Value,\2
		ENDM

* Listview gadget

ListRO		MACRO		* ListRO(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_READONLY,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_READONLY
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

ListSel		MACRO		* ListSel(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_SELECT,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_SELECT
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

ListSS		MACRO		* ListSS(e,id,top,v) TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_SHOWSELECTED,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_SHOWSELECTED
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRLV_Top,\4
		ENDM

ListROC		MACRO		* ListROC(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_READONLY|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_READONLY!TRLV_NOCURSORKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

ListSelC	MACRO		* ListSelC(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_SELECT|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_SELECT!TRLV_NOCURSORKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

ListSSC		MACRO		* ListSSC(e,id,top,v) TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_SHOWSELECTED|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_SHOWSELECTED!TRLV_NOCURSORKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRLV_Top,\4
		ENDM

ListRON		MACRO		* ListRON(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_READONLY|TRLV_NUNUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1,TRAT_Flags,TRLV_NOGAP!TRLV_READONLY!TRLV_NUNUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		ENDM

ListSelN	MACRO		* ListSelN(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_SELECT|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_SELECT!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

ListSSN		MACRO		* ListSSN(e,id,top,v) TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_SHOWSELECTED|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_SHOWSELECTED!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRLV_Top,\4
		ENDM

ListROCN	MACRO		* ListROCN(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_READONLY|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_READONLY!TRLV_NOCURSORKEYS!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

ListSelCN	MACRO		* ListSelCN(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_SELECT|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_SELECT!TRLV_NOCURSORKEYS!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

ListSSCN	MACRO		* ListSSCN(e,id,top,v) TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_SHOWSELECTED|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_SHOWSELECTED!TRLV_NOCURSORKEYS!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRLV_Top,\4
		ENDM


FWListRO	MACRO		* FWListRO(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_READONLY,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1,TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_READONLY,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		ENDM

FWListSel	MACRO		* FWListSel(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SELECT,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_SELECT
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

FWListSS	MACRO		* FWListSS(e,id,top,v) TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SHOWSELECTED,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_SHOWSELECTED
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRLV_Top,\4
		ENDM

FWListROC	MACRO		* FWListROC(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_READONLY|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_READONLY!TRLV_NOCURSORKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

FWListSelC	MACRO		* FWListSelC(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SELECT|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_SELECT!TRLV_NOCURSORKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

FWListSSC	MACRO		* FWListSSC(e,id,top,v) TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SHOWSELECTED|TRLV_NOCURSORKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_SHOWSELECTED!TRLV_NOCURSORKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRLV_Top,\4
		ENDM

FWListRON	MACRO		* FWListRON(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_READONLY|TRLV_NUNUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_READONLY!TRLV_NUNUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

FWListSelN	MACRO		* FWListSelN(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SELECT|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_SELECT!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

FWListSSN	MACRO		* FWListSSN(e,id,top,v) TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SHOWSELECTED|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_SHOWSELECTED!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRLV_Top,\4
		ENDM

FWListROCN	MACRO		* FWListROCN(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_READONLY|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_READONLY!TRLV_NOCURSORKEYS!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

FWListSelCN	MACRO		* FWListSelCN(ent,id,top) TROB_Listview,(ULONG)(ent),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SELECT|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,0,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_SELECT!TRLV_NOCURSORKEYS!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,0
		DC.L TRLV_Top,\3
		ENDM

FWListSSCN	MACRO		* FWListSSCN(e,id,top,v) TROB_Listview,(ULONG)(e),TRAT_Flags,TRLV_NOGAP|TRLV_FWFONT|TRLV_SHOWSELECTED|TRLV_NOCURSORKEYS|TRLV_NONUMPADKEYS,TRAT_ID,id,TRAT_Value,v,TRLV_Top,top
		DC.L TROB_Listview,\1
		DC.L TRAT_Flags,TRLV_NOGAP!TRLV_FWFONT!TRLV_SHOWSELECTED!TRLV_NOCURSORKEYS!TRLV_NONUMPADKEYS
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		DC.L TRLV_Top,\4
		ENDM

* Progress indicator

Progress	MACRO		* Progress(maxi,val,id) TROB_Progress,(maxi),TRAT_ID,(id),TRAT_Value,(val)
		DC.L TROB_Progress,\1
		DC.L TRAT_ID,\2
		DC.L TRAT_Value,\3
		ENDM

* Image

BoopsiImage	MACRO		* BoopsiImage(img) TROB_Image,(ULONG)(img),TRAT_Flags,TRIM_BOOPSI
		DC.L TROB_Image,\1
		DC.L TRAT_Flags,TRIM_BOOPSI
		ENDM

BoopsiImageD	MACRO		* BoopsiImageD(img,mw,mh) TROB_Image,(ULONG)(img),TRAT_MinWidth,(mw),TRAT_MinHeight,(mh),TRAT_Flags,TRIM_BOOPSI
		DC.L TROB_Image,\1
		DC.L TRAT_MinWidth,\2
		DC.L TRAT_MinHeight,\3
		DC.L TRAT_Flags,TRIM_BOOPSI
		ENDM

* Attributes

ID		MACRO		* ID(id) TRAT_ID,id
		DC.L TRAT_ID,\1
		ENDM

Disabled	MACRO		* Disabled                TRAT_Disabled,TRUE
		DC.L TRAT_Disabled,TRUE
		ENDM

ObjectBackfillWin   MACRO	* ObjectBackfillWin TRAT_Backfill,TRBF_WINDOWBACK
		DC.L TRAT_Backfill,TRBF_WINDOWBACK
		ENDM

ObjectBackfillReq   MACRO	* ObjectBackfillReq TRAT_Backfill,TRBF_REQUESTERBACK
		DC.L TRAT_Backfill,TRBF_REQUESTERBACK
		ENDM

ObjectBackfillB	MACRO		* ObjectBackfillB TRAT_Backfill,TRBF_NONE
		DC.L TRAT_Backfill,TRBF_NONE
		ENDM

ObjectBackfillS	MACRO		* ObjectBackfillS TRAT_Backfill,TRBF_SHINE
		DC.L TRAT_Backfill,TRBF_SHINE
		ENDM

ObjectBackfillSA   MACRO	* ObjectBackfillSA TRAT_Backfill,TRBF_SHINE_SHADOW
		DC.L TRAT_Backfill,TRBF_SHINE_SHADOW
		ENDM

ObjectBackfillSF   MACRO	* ObjectBackfillSF TRAT_Backfill,TRBF_SHINE_FILL
		DC.L TRAT_Backfill,TRBF_SHINE_FILL
		ENDM

ObjectBackfillSB   MACRO	* ObjectBackfillSB TRAT_Backfill,TRBF_SHINE_BACKGROUND
		DC.L TRAT_Backfill,TRBF_SHINE_BACKGROUND
		ENDM

ObjectBackfillA	MACRO		* ObjectBackfillA TRAT_Backfill,TRBF_SHADOW
		DC.L TRAT_Backfill,TRBF_SHADOW
		ENDM

ObjectBackfillAF   MACRO	* ObjectBackfillAF TRAT_Backfill,TRBF_SHADOW_FILL
		DC.L TRAT_Backfill,TRBF_SHADOW_FILL
		ENDM

ObjectBackfillAB   MACRO	* ObjectBackfillAB TRAT_Backfill,TRBF_SHADOW_BACKGROUND
		DC.L TRAT_Backfill,TRBF_SHADOW_BACKGROUND
		ENDM

ObjectBackfillF	MACRO		* ObjectBackfillF TRAT_Backfill,TRBF_FILL
		DC.L TRAT_Backfill,TRBF_FILL
		ENDM

ObjectBackfillFB   MACRO	* ObjectBackfillFB TRAT_Backfill,TRBF_FILL_BACKGROUND
		DC.L TRAT_Backfill,TRBF_FILL_BACKGROUND
		ENDM

* Requester support

				* BeginRequester(t,p) WindowTitle(t),WindowPosition(p),WindowBackfillReq,\
				* 		      WindowFlags(TRWF_NOZIPGADGET|TRWF_NOSIZEGADGET|TRWF_NOCLOSEGADGET|TRWF_NODELZIP|TRWF_NOESCCLOSE),\
BeginRequester	MACRO		* 		      VertGroupA,Space,HorizGroupA,Space,GroupBox,ObjectBackfillB
		WindowTitle   \1
		WindowPosition   \2
		WindowBackfillReq
		WindowFlags   TRWF_NOZIPGADGET!TRWF_NOSIZEGADGET!TRWF_NOCLOSEGADGET!TRWF_NODELZIP!TRWF_NOESCCLOSE
		VertGroupA
			Space
			HorizGroupA
				Space
				GroupBox
				ObjectBackfillB
		ENDM

BeginRequesterGad   MACRO	* BeginRequesterGads Space,EndGroup,Space
				Space
			EndGroup
			Space
		ENDM

EndRequester	MACRO		* EndRequester Space,EndGroup,EndProject
			Space
		EndGroup
		EndProject
		ENDM

 ENDC ; TR_NOMACROS


* ////////////////////////////////////////////////////////////////////// *
* //////////////////////////////////////////////// The Triton message // *
* ////////////////////////////////////////////////////////////////////// *

   STRUCTURE TR_Message,0
      APTR   trm_Project		* The project which triggered the message
      ULONG  trm_ID			* The object's ID (where appropriate)
      ULONG  trm_Class			* The Triton message class
      ULONG  trm_Data			* The class-specific data
      ULONG  trm_Code			* Currently only used by TRMS_KEYPRESSED
      ULONG  trm_Qualifiers		* IEQUALIFIERs
      ULONG  trm_Seconds		* \ Copy of system clock time (Only where
      ULONG  trm_Micros			* / available! If not set, trm_Seconds is NULL)
      APTR   trm_App			* The project's application
      LABEL  TR_Message_SIZE

TRMS_CLOSEWINDOW	equ	1	* The window should be closed
TRMS_ERROR		equ	2	* An error occured. Error code in trm_Data
TRMS_NEWVALUE		equ	3	* Object's value has changed. New value in trm_Data
TRMS_ACTION		equ	4	* Object has triggered an action */
TRMS_ICONDROPPED	equ	5	* Icon dropped over window (ID=0) or DropBox. AppMessage* in trm_Data
TRMS_KEYPRESSED		equ	6	* Key pressed. trm_Data contains ASCII code, trm_Code raw code and
					* trm_Qualifier contains qualifiers
TRMS_HELP		equ	7	* The user requested help for the specified ID


* ////////////////////////////////////////////////////////////////////// *
* //////////////////////////////////////////////// Triton error codes // *
* ////////////////////////////////////////////////////////////////////// *

TRER_OK			equ	0	* No error

TRER_ALLOCMEM		equ	1	* Not enough memory
TRER_OPENWINDOW		equ	2	* Can't open window
TRER_WINDOWTOOBIG	equ	3	* Window would be too big for screen
TRER_DRAWINFO		equ	4	* Can't get screen's DrawInfo
TRER_OPENFONT		equ	5	* Can't open font
TRER_CREATEMSGPORT	equ	6	* Can't create message port
TRER_INSTALLOBJECT	equ	7	* Can't create an object
TRER_CREATECLASS	equ	8	* Can't create a class
TRER_NOLOCKPUBSCREEN	equ	9	* Can't lock public screen
TRER_CREATEMENUS	equ	12	* Error while creating the menus
TRER_GT_CREATECONTEXT	equ	14	* Can't create gadget context

TRER_MAXERRORNUM	equ	15	* PRIVATE!


* ////////////////////////////////////////////////////////////////////// *
* ///////////////////////////////////////// Tags for TR_OpenProject() // *
* ////////////////////////////////////////////////////////////////////// *

* Window/Project
TRWI_Title		equ	(TAG_USER+1)	* STRPTR: The window title
TRWI_Flags		equ	(TAG_USER+2)	* See below for window flags
TRWI_Underscore		equ	(TAG_USER+3)	* char *: The underscore for menu and gadget shortcuts
TRWI_Position		equ	(TAG_USER+4)	* Window position, see below
TRWI_CustomScreen	equ	(TAG_USER+5)	* struct Screen *
TRWI_PubScreen		equ	(TAG_USER+6)	* struct Screen *, must have been locked!
TRWI_PubScreenName	equ	(TAG_USER+7)	* STRPTR, Triton is doing the locking
TRWI_PropFontAttr	equ	(TAG_USER+8)	* struct TextAttr *: The proportional font
TRWI_FixedWidthFontAttr	equ	(TAG_USER+9)	* struct TextAttr *: The fixed-width font
TRWI_Backfill		equ	(TAG_USER+10)	* The backfill type, see below
TRWI_ID			equ	(TAG_USER+11)	* ULONG: The window ID
TRWI_Dimensions		equ	(TAG_USER+12)	* struct TR_Dimensions *
TRWI_ScreenTitle	equ	(TAG_USER+13)	* STRPTR: The screen title

* Menus
TRMN_Title		equ	(TAG_USER+101)	* STRPTR: Menu
TRMN_Item		equ	(TAG_USER+102)	* STRPTR: Menu item
TRMN_Sub		equ	(TAG_USER+103)	* STRPTR: Menu subitem
TRMN_Flags		equ	(TAG_USER+104)	* See below for flags

* General object attributes
TRAT_ID			equ	(TAG_USER+150)	* The object's/menu's ID
TRAT_Flags		equ	(TAG_USER+151)	* The object's flags
TRAT_Value		equ	(TAG_USER+152)	* The object's value
TRAT_Text		equ	(TAG_USER+153)	* The object's text
TRAT_Disabled		equ	(TAG_USER+154)	* Disabled object?
TRAT_Backfill		equ	(TAG_USER+155)	* Backfill pattern
TRAT_MinWidth		equ	(TAG_USER+156)	* Minimum width
TRAT_MinHeight		equ	(TAG_USER+157)	* Minimum height

TROB_USER		equ	(TAG_USER+800)	* PRIVATE!


* ////////////////////////////////////////////////////////////////////// *
* ////////////////////////////////////////////////////// Window flags // *
* ////////////////////////////////////////////////////////////////////// *

TRWF_BACKDROP		equ	$00000001	* Create a backdrop borderless window
TRWF_NODRAGBAR		equ	$00000002	* Don't use a dragbar
TRWF_NODEPTHGADGET	equ	$00000004	* Don't use a depth-gadget
TRWF_NOCLOSEGADGET	equ	$00000008	* Don't use a close-gadget
TRWF_NOACTIVATE		equ	$00000010	* Don't activate window
TRWF_NOESCCLOSE		equ	$00000020	* Don't send TRMS_CLOSEWINDOW when Esc is pressed
TRWF_NOPSCRFALLBACK	equ	$00000040	* Don't fall back onto default PubScreen
TRWF_NOZIPGADGET	equ	$00000080	* Don't use a zip-gadget
TRWF_ZIPCENTERTOP	equ	$00000100	* Center the zipped window on the title bar
TRWF_NOMINTEXTWIDTH	equ	$00000200	* Minimum window width not according to title text
TRWF_NOSIZEGADGET	equ	$00000400	* Don't use a sizing-gadget
TRWF_NOFONTFALLBACK	equ	$00000800	* Don't fall back to topaz.8
TRWF_NODELZIP		equ	$00001000	* Don't zip the window when Del is pressed
TRWF_SIMPLEREFRESH	equ	$00002000	* Use simple refresh instead of smart refresh
TRWF_ZIPTOCURRENTPOS	equ	$00004000	* Will zip the window at the current position (OS3.0+)
TRWF_APPWINDOW		equ	$00008000	* Create an AppWindow without using class_dropbox
TRWF_ACTIVATESTRGAD	equ	$00010000	* Activate the first string gadget after opening the window
TRWF_HELP		equ	$00020000	* Pressing <Help> will create a TRMS_HELP message


* ////////////////////////////////////////////////////////////////////// *
* //////////////////////////////////////////////////////// Menu flags // *
* ////////////////////////////////////////////////////////////////////// *

TRMF_CHECKIT		equ	$00000001	* Leave space for a checkmark
TRMF_CHECKED		equ	$00000002	* Check the item (includes TRMF_CHECKIT)
TRMF_DISABLED		equ	$00000004	* Ghost the menu/item


* ////////////////////////////////////////////////////////////////////// *
* ////////////////////////////////////////////////// Window positions // *
* ////////////////////////////////////////////////////////////////////// *

TRWP_DEFAULT		equ	0		* Let Triton choose a good position
TRWP_BELOWTITLEBAR	equ	1		* Left side of screen, below title bar
TRWP_CENTERTOP		equ	1025		* Top of screen, centered on the title bar
TRWP_TOPLEFTSCREEN	equ	1026		* Top left corner of screen
TRWP_CENTERSCREEN	equ	1027		* Centered on the screen
TRWP_CENTERDISPLAY	equ	1028		* Centered on the currently displayed clip
TRWP_MOUSEPOINTER	equ	1029		* Under the mouse pointer


* ////////////////////////////////////////////////////////////////////// *
* //////////////////////////////////////////////////// Backfill types // *
* ////////////////////////////////////////////////////////////////////// *

TRBF_WINDOWBACK		equ	0		* Window backfill colors
TRBF_REQUESTERBACK	equ	1		* Requester backfill colors
TRBF_NONE		equ	2		* No backfill (= Fill with BACKGROUNDPEN)
TRBF_SHINE		equ	3		* Fill with SHINEPEN
TRBF_SHINE_SHADOW	equ	4		* Fill with SHINEPEN + SHADOWPEN
TRBF_SHINE_FILL		equ	5		* Fill with SHINEPEN + FILLPEN
TRBF_SHINE_BACKGROUND	equ	6		* Fill with SHINEPEN + BACKGROUNDPEN
TRBF_SHADOW		equ	7		* Fill with SHADOWPEN
TRBF_SHADOW_FILL	equ	8		* Fill with SHADOWPEN + FILLPEN
TRBF_SHADOW_BACKGROUND	equ	9		* Fill with SHADOWPEN + BACKGROUNDPEN
TRBF_FILL		equ	10		* Fill with FILLPEN
TRBF_FILL_BACKGROUND	equ	11		* Fill with FILLPEN + BACKGROUNDPEN


* ////////////////////////////////////////////////////////////////////// *
* ////////////////////////////////////////////// Display Object flags // *
* ////////////////////////////////////////////////////////////////////// *

* General flags
TROF_RAISED		equ	$00000001	* Raised object
TROF_HORIZ		equ	$00000002	* Horizontal object \ Works automatically
TROF_VERT		equ	$00000004	* Vertical object   / in groups
TROF_RIGHTALIGN		equ	$00000008	* Align object to the right border if available

* Text flags
TRTX_NOUNDERSCORE	equ	$00000100	* Don't interpret underscores
TRTX_HIGHLIGHT		equ	$00000200	* Highlight text
TRTX_3D			equ	$00000400	* 3D design
TRTX_BOLD		equ	$00000800	* Softstyle 'bold'
TRTX_TITLE		equ	$00001000	* A title (e.g. of a group)
TRTX_SELECTED		equ	$00002000	* PRIVATE!


* //////////////////////////////////////////////////////////////////////
* ////////////////////////////////////////////////////// Menu entries //
* //////////////////////////////////////////////////////////////////////

TRMN_BARLABEL		equ	-1		* A barlabel instead of text


* ////////////////////////////////////////////////////////////////////// *
* /////////////////////////////////////////// Tags for TR_CreateApp() // *
* ////////////////////////////////////////////////////////////////////// *

TRCA_Name		equ	(TAG_USER+1)
TRCA_LongName		equ	(TAG_USER+2)
TRCA_Info		equ	(TAG_USER+3)
TRCA_Version		equ	(TAG_USER+4)
TRCA_Release		equ	(TAG_USER+5)
TRCA_Date		equ	(TAG_USER+6)


* ////////////////////////////////////////////////////////////////////// *
* ///////////////////////////////////////// Tags for TR_EasyRequest() // *
* ////////////////////////////////////////////////////////////////////// *

TREZ_ReqPos		equ	(TAG_USER+1)
TREZ_LockProject	equ	(TAG_USER+2)
TREZ_Return		equ	(TAG_USER+3)
TREZ_Title		equ	(TAG_USER+4)
TREZ_Activate		equ	(TAG_USER+5)


* ////////////////////////////////////////////////////////////////////// *
* ///////////////////////////////////////// The Application Structure // *
* ////////////////////////////////////////////////////////////////////// *

   STRUCTURE TR_App,0 * This structure is PRIVATE!
      APTR   tra_MemPool		* The memory pool
      ULONG  tra_BitMask		* Bits to Wait() for
      ULONG  tra_LastError		* TRER code of last error
      APTR   tra_Name			* Unique name
      APTR   tra_LongName		* User-readable name
      APTR   tra_Info			* Info string
      APTR   tra_Version		* Version
      APTR   tra_Release		* Release
      APTR   tra_Date			* Compilation date
      APTR   tra_AppPort		* Application message port
      APTR   tra_IDCMPPort		* IDCMP message port
      APTR   tra_Prefs			* Pointer to Triton app prefs
      APTR   tra_LastProject		* Used for menu item linking
      APTR   tra_InputEvent		* Used for RAWKEY conversion
      LABEL  TR_App_SIZE


* ////////////////////////////////////////////////////////////////////// *
* ////////////////////////////////////////// The Dimensions Structure // *
* ////////////////////////////////////////////////////////////////////// *

   STRUCTURE TR_Dimensions,0
      UWORD  trd_Left			* Left
      UWORD  trd_Top			* Top
      UWORD  trd_Width			* Width
      UWORD  trd_Height			* Height
      UWORD  trd_Left2			* Left
      UWORD  trd_Top2			* Top
      UWORD  trd_Width2			* Width
      UWORD  trd_Height2		* Height
      BOOL   trd_Zoomed			* Window zoomed?
      STRUCT reserved,3			* For future expansions
      LABEL  TR_Dimensions_SIZE

* ////////////////////////////////////////////////////////////////////// *
* ///////////////////////////////////////////// The Project Structure // *
* ////////////////////////////////////////////////////////////////////// *

   STRUCTURE TR_Project,0 * This structure is PRIVATE!
      APTR   trp_App			* Our application
      APTR   trp_Screen			* Our screen, always valid

      APTR   trp_LockedPubScreen	* Only valid if we're using a PubScreen
      APTR   trp_ScreenTitle		* The screen title

      APTR   trp_Window			* The window
      ULONG  trp_ID			* The window ID
      APTR   trp_AppWindow		* AppWindow for icon dropping

      ULONG  trp_IDCMPFlags		* The IDCMP flags
      ULONG  trp_Flags			* Triton window flags

      APTR   trp_NewMenu		* The newmenu stucture built by Triton
      ULONG  trp_NewMenuSize		* The menu structure
      APTR   trp_Menu			* The next selected menu item
      UWORD  trp_NextSelect		* The next selected menu item

      APTR   trp_VisualInfo		* The VisualInfo of our window
      APTR   trp_DrawInfo		* The DrawInfo of the screen
      APTR   trp_UserDimensions		* User-supplied dimensions
      APTR   trp_Dimensions		* Private dimensions

      ULONG  trp_WindowStdHeight	* The standard height of the window
      ULONG  trp_LeftBorder		* The width of the left window border
      ULONG  trp_RightBorder		* The width of the right window border
      ULONG  trp_TopBorder		* The height of the top window border
      ULONG  trp_BottomBorder		* The height of the bottom window border
      ULONG  trp_InnerWidth		* The inner width of the window
      ULONG  trp_InnerHeight		* The inner height of the window
      STRUCT trp_ZipDimensions,8	* The dimensions for the zipped window
      UWORD  trp_AspectFixing		* Pixel aspect correction factor

      STRUCT trp_ObjectList,MLH_SIZE	* The list of display objects
      STRUCT trp_MenuList,MLH_SIZE	* The list of menus
      APTR   trp_MemPool		* The ID linking list (menus & objects)
      BOOL   trp_HasObjects		* The memory pool for the lists

      APTR   trp_PropAttr		* The proportional font attributes
      APTR   trp_FixedWidthAttr		* The fixed-width font attributes
      APTR   trp_PropFont		* The proportional font
      APTR   trp_FixedFontAttr		* The fixed-width font
      BOOL   trp_OpenedPropFont		* \ Have we opened the fonts ?
      BOOL   trp_OpenedFixedWidthFont	* /
      UWORD  trp_TotalPropFontHeight	* Height of prop font incl. underscore

      ULONG  trp_BackfillType		* The backfill type
      APTR   trp_BackfillHook		* The backfill hook

      APTR   trp_GadToolsGadgetList	* List of GadTools gadgets
      APTR   trp_PrevGadget		* Previous GadTools gadget
      APTR   trp_NewGadget		* GadTools NewGadget

      APTR   trp_InvisibleRequest	* The invisible blocking requester
      BOOL   trp_IsUserLocked		* Project locked by the user?

      ULONG  trp_CurrentID		* The currently keyboard-selected ID
      BOOL   trp_IsCancelDown		* Cancellation key pressed?
      BOOL   trp_IsShortcutDown		* Shortcut key pressed?
      UBYTE  trp_Underscore		* The underscore character

      BOOL   trp_EscClose		* Close window on Esc ?
      BOOL   trp_DelZip			* Zip window on Del ?
      BOOL   trp_PubScreenFallBack	* Fall back onto default public screen ?
      BOOL   trp_FontFallBack		* Fall back to topaz.8 ?

      UWORD  trp_OldWidth		* Old window width
      UWORD  trp_OldHeight		* Old window height

* ////////////////////////////////////////////////////////////////////// *
* ///////////////////////////// Default classes, attributes and flags // *
* ////////////////////////////////////////////////////////////////////// *

TROB_Button		equ	(TAG_USER+305)	* A BOOPSI button gadget
TROB_CheckBox		equ	(TAG_USER+303)	* A checkbox gadget
TROB_Cycle		equ	(TAG_USER+310)	* A cycle gadget
TROB_FrameBox		equ	(TAG_USER+306)	* A framing box
TROB_DropBox		equ	(TAG_USER+312)	* An icon drop box
TRGR_Horiz		equ	(TAG_USER+201)	* Horizontal group, see below for types
TRGR_Vert		equ	(TAG_USER+202)	* Vertical group, see below for types
TRGR_End		equ	(TAG_USER+203)	* End of a group
TROB_Line		equ	(TAG_USER+301)	* A simple line
TROB_Palette		equ	(TAG_USER+307)	* A palette gadget
TROB_Scroller		equ	(TAG_USER+309)	* A scroller gadget
TROB_Slider		equ	(TAG_USER+308)	* A slider gadget
TROB_Space		equ	(TAG_USER+901)	* The spaces class
TROB_String		equ	(TAG_USER+311)	* A string gadget
TROB_Text		equ	(TAG_USER+304)	* A line of text
TROB_Listview		equ	(TAG_USER+313)	* A listview gadget
TROB_Progress		equ	(TAG_USER+314)	* A progress indicator
TROB_Image		equ	(TAG_USER+315)	* An image


* Button
TRBU_RETURNOK		equ	$00010000	* <Return> answers the button
TRBU_ESCOK		equ	$00020000	* <Esc> answers the button
TRBU_SHIFTED		equ	$00040000	* Shifted shortcut only
TRBU_UNSHIFTED		equ	$00080000	* Unshifted shortcut only
TRBU_YRESIZE		equ	$00100000	* Button resizeable in Y direction
TRBT_TEXT		equ	0		* Text button
TRBT_GETFILE		equ	1		* GetFile button
TRBT_GETDRAWER		equ	2		* GetDrawer button
TRBT_GETENTRY		equ	3		* GetEntry button


* Group
TRGR_PROPSHARE		equ	$00000000	* Default: Divide objects proportionally
TRGR_EQUALSHARE		equ	$00000001	* Divide objects equally
TRGR_PROPSPACES		equ	$00000002	* Divide spaces proportionally
TRGR_ARRAY		equ	$00000004	* Top-level array group

TRGR_ALIGN		equ	$00000008	* Align resizeable objects in secondary dimension
TRGR_CENTER		equ	$00000010	* Center unresizeable objects in secondary dimension

TRGR_FIXHORIZ		equ	$00000020	* Don't allow horizontal resizing
TRGR_FIXVERT		equ	$00000040	* Don't allow vertical resizing
TRGR_INDEP		equ	$00000080	* Group is independant of surrounding array


* Framebox
TRFB_GROUPING		equ	$00000001	* A grouping box
TRFB_FRAMING		equ	$00000002	* A framing box
TRFB_TEXT		equ	$00000004	* A text container


* Scroller
TRSC_Total		equ	(TAG_USER+1504)
TRSC_Visible		equ	(TAG_USER+1505)


* Slider
TRSL_Min		equ	(TAG_USER+1502)
TRSL_Max		equ	(TAG_USER+1503)


* Space
TRST_NONE		equ	1		* No space
TRST_SMALL		equ	2		* Small space
TRST_NORMAL		equ	3		* Normal space (default)
TRST_BIG		equ	4		* Big space

* Listview
TRLV_Top		equ	(TAG_USER+1506)
TRLV_READONLY		equ	$00010000	/* A read-only list
TRLV_SELECT		equ	$00020000	/* You may select an entry
TRLV_SHOWSELECTED	equ	$00040000	/* Selected entry will be shown
TRLV_NOCURSORKEYS	equ	$00080000	/* Don't use arrow keys
TRLV_NONUMPADKEYS	equ	$00100000	/* Don't use numeric keypad keys
TRLV_FWFONT		equ	$00200000	/* Use the fixed-width font
TRLV_NOGAP		equ	$00400000	/* Don't leave a gap below the list


* Image
TRIM_BOOPSI		equ	$00010000	/* Use a BOOPSI IClass image


* Cycle
TRCY_MX			equ	$00010000	/* Unfold the cycle gadget to a MX gadget
TRCY_RIGHTLABELS	equ	$00020000	/* Put the labels to the right of a MX gadget


* ////////////////////////////////////////////////////////////////////// *
* /////////////////////////////////////////////////////////// The End // *
* ////////////////////////////////////////////////////////////////////// *

   ENDC ; LIBRARIES_TRITON_I
