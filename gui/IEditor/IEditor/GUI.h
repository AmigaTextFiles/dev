/*
    C source code created by Interface Editor
    Copyright © 1994-1996 by Simone Tellini

    Generator:  C.generator 37.18 (20.1.97)

    Copy registered to :  Simone Tellini
    Serial Number      : #0
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif
#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif
#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif
#ifndef CLIB_EXEC_PROTOS_H
#include <clib/exec_protos.h>
#endif
#ifndef CLIB_INTUITION_PROTOS_H
#include <clib/intuition_protos.h>
#endif
#ifndef CLIB_GADTOOLS_PROTOS_H
#include <clib/gadtools_protos.h>
#endif
#ifndef CLIB_GRAPHICS_PROTOS_H
#include <clib/graphics_protos.h>
#endif
#ifndef CTYPE_H
#include <ctype.h>
#endif
#ifndef STRING_H
#include <string.h>
#endif

#define GetString( g )	((( struct StringInfo * )g->SpecialInfo )->Buffer  )
#define GetNumber( g )	((( struct StringInfo * )g->SpecialInfo )->LongInt )

#define WT_LEFT				0
#define WT_TOP				1
#define WT_WIDTH			2
#define WT_HEIGHT			3

#define A0(stuff) __A0 stuff
#define A1(stuff) __A1 stuff
#define A2(stuff) __A2 stuff
extern struct CatCompArrayType CatCompArray[];
extern struct Library *LocaleBase;

#define GD_DP_Pens					0
#define GD_DP_Pal					1
#define GD_DP_Ok					2
#define GD_DP_Ann					3

#define GD_MEd_Img					0
#define GD_MEd_ImgDisp					1
#define GD_MEd_Bar					2
#define GD_MEd_Disab					3
#define GD_MEd_ChkIt					4
#define GD_MEd_Checked					5
#define GD_MEd_Toggle					6
#define GD_MEd_Ok					7
#define GD_MEd_Annulla					8
#define GD_MEd_Txt					9
#define GD_MEd_CmdK					10
#define GD_MEd_Label					11

#define GD_ME_Title					0
#define GD_ME_Item					1
#define GD_ME_Sub					2
#define GD_ME_TNuovo					3
#define GD_ME_TDel					4
#define GD_ME_INuovo					5
#define GD_ME_IDel					6
#define GD_ME_SNuovo					7
#define GD_ME_SDel					8
#define GD_ME_Test					9
#define GD_ME_IExclude					10
#define GD_ME_SExclude					11
#define GD_ME_Ok					12
#define GD_ME_ISu					13
#define GD_ME_TGiu					14
#define GD_ME_TSu					15
#define GD_ME_SGiu					16
#define GD_ME_SSu					17
#define GD_ME_IGiu					18

#define GD_IB_New					0
#define GD_IB_Imgs					1
#define GD_IB_Del					2
#define GD_IB_Label					3

#define GD_Img_ChkTxt					0
#define GD_Img_RPMode					1
#define GD_Img_Invers					2
#define GD_Img_FP					3
#define GD_Img_BP					4
#define GD_Img_GadRend					5
#define GD_Img_SelRend					6
#define GD_Img_High					7
#define GD_Img_Toggle					8
#define GD_Img_Immediate					9
#define GD_Img_RelVer					10
#define GD_Img_Follow					11
#define GD_Img_Sel					12
#define GD_Img_Disab					13
#define GD_Img_Same					14
#define GD_Img_OK					15
#define GD_Img_Annulla					16
#define GD_Img_Label					17
#define GD_Img_Txt					18
#define GD_Img_X					19
#define GD_Img_Y					20
#define GD_Img_Width					21
#define GD_Img_Height					22

#define GD_Status					0
#define GD_AddGad					1
#define GD_RemGadget					2
#define GD_LoadGUI					3
#define GD_SaveGUI					4
#define GD_DelWnd					5
#define GD_ToggleGadgets					6
#define GD_OpenImgBank					7
#define GD_ScrType					8
#define GD_AddWnd					9
#define GD_IDCMP					10
#define GD_WFlags					11

#define GD_MX_Inc					0
#define GD_MX_Exc					1
#define GD_MX_ExAll					2
#define GD_MX_ExThis					3
#define GD_MX_IncThis					4
#define GD_MX_IncAll					5
#define GD_MX_Ok					6
#define GD_MX_Annulla					7

#define GD_Qualif					0
#define GD_rx_1					1
#define GD_rx_2					2
#define GD_rx_3					3
#define GD_rx_4					4
#define GD_rx_5					5
#define GD_rx_6					6
#define GD_rx_7					7
#define GD_rx_8					8
#define GD_rx_9					9
#define GD_rx_10					10
#define GD_rx_Get4					11
#define GD_rx_Get5					12
#define GD_rx_Get6					13
#define GD_rx_Get7					14
#define GD_rx_Get8					15
#define GD_rx_Get9					16
#define GD_rx_Get10					17
#define GD_rx_Get1					18
#define GD_rx_Get2					19
#define GD_rx_Get3					20

#define GD_BB_X					0
#define GD_BB_Y					1
#define GD_BB_W					2
#define GD_BB_H					3
#define GD_BB_Recessed					4
#define GD_BB_Type					5
#define GD_BB_Left					6
#define GD_BB_Right					7
#define GD_BB_Up					8
#define GD_BB_Down					9
#define GD_BB_Delete					10

#define GD_TC_Gadgets					0
#define GD_TC_Up					1
#define GD_TC_Top					2
#define GD_TC_Down					3
#define GD_TC_Bottom					4

#define GD_SP_Ok					0
#define GD_SP_Annulla					1
#define GD_SP_GenScr					2
#define GD_SP_FontAdapt					3
#define GD_SP_OpenFonts					4
#define GD_SP_main					5
#define GD_SP_ShdPort					6
#define GD_SP_ShdPortIn					7

#define GD_TXT_FPen					0
#define GD_TXT_BPen					1
#define GD_TXT_Inv					2
#define GD_TXT_Mode					3
#define GD_TXT_Txt					4
#define GD_TXT_Font					5
#define GD_TXT_ScrFont					6
#define GD_TXT_Ok					7
#define GD_TXT_Annulla					8

#define GD_RXE_Cmd					0
#define GD_RXE_Add					1
#define GD_RXE_Del					2
#define GD_RXE_Port					3
#define GD_RXE_Ext					4
#define GD_RXE_CmdIn					5

#define GD_RXC_Label					0
#define GD_RXC_Cmd					1
#define GD_RXC_Template					2
#define GD_RXC_Ok					3
#define GD_RXC_Annulla					4

#define GD_MP_OpenLib					0
#define GD_MP_LibFrom					1
#define GD_MP_AddLib					2
#define GD_MP_DelLib					3
#define GD_MP_OpenWnd					4
#define GD_MP_AddWnd					5
#define GD_MP_DelWnd					6
#define GD_MP_CtrlC					7
#define GD_MP_XtraProc					8
#define GD_MP_XtraBits					9
#define GD_MP_WB					10
#define GD_MP_WndUp					11
#define GD_MP_WndTop					12
#define GD_MP_WndBottom					13
#define GD_MP_WndDown					14

#define GD_MPEL_Lib					0
#define GD_MPEL_Base					1
#define GD_MPEL_Vers					2
#define GD_MPEL_Fail					3
#define GD_MPEL_Ok					4
#define GD_MPEL_Annulla					5

#define GD_TitFin					0
#define GD_TitLabel					1
#define GD_TitFinOk					2
#define GD_TitFinAnnulla					3

#define GD_Lista					0

#define GD_DF_MinW					0
#define GD_DF_MaxW					1
#define GD_DF_MinH					2
#define GD_DF_MaxH					3
#define GD_DF_MinWb					4
#define GD_DF_MaxWb					5
#define GD_DF_MinHb					6
#define GD_DF_MaxHb					7
#define GD_DF_InWc					8
#define GD_DF_InHc					9
#define GD_DF_InW					10
#define GD_DF_InH					11
#define GD_DF_Ok					12
#define GD_DF_Annulla					13

#define GD_Z_Ok					0
#define GD_Z_Annulla					1
#define GD_Z_Left					2
#define GD_Z_Top					3
#define GD_Z_Width					4
#define GD_Z_Height					5
#define GD_Z_Lb					6
#define GD_Z_Tb					7
#define GD_Z_Wb					8
#define GD_Z_Hb					9
#define GD_Z_Usa					10

#define GD_WTg_ScTitle					0
#define GD_WTg_ScTitIn					1
#define GD_WTg_Adjust					2
#define GD_WTg_FallBack					3
#define GD_WTg_MQIn					4
#define GD_WTg_RQIn					5
#define GD_WTg_MQ					6
#define GD_WTg_RQ					7
#define GD_WTg_NotDepth					8
#define GD_WTg_MenuH					9
#define GD_WTg_TabMsg					10
#define GD_WTg_Ok					11
#define GD_WTg_Annulla					12
#define GD_WTg_LocGad					13
#define GD_WTg_LocTit					14
#define GD_WTg_LocScrTit					15
#define GD_WTg_LocMenu					16
#define GD_WTg_LocTxt					17
#define GD_WT_ShdPort					18
#define GD_WTg_Back					19

#define GD_GS_X					0
#define GD_GS_Y					1
#define GD_GS_H					2
#define GD_GS_W					3
#define GD_GS_Ok					4
#define GD_GS_Annulla					5

#define GD_LE_List					0
#define GD_LE_In					1
#define GD_LE_New					2
#define GD_LE_Del					3
#define GD_LE_Ok					4
#define GD_LE_Annulla					5
#define GD_LE_Up					6
#define GD_LE_Top					7
#define GD_LE_Bottom					8
#define GD_LE_Down					9

#define GD_BT_Tit					0
#define GD_BT_Label					1
#define GD_BT_PosTit					2
#define GD_BT_Und					3
#define GD_BT_High					4
#define GD_BT_Ok					5
#define GD_BT_Disab					6
#define GD_BT_Imm					7
#define GD_BT_Annulla					8

#define GD_CT_Tit					0
#define GD_CT_Label					1
#define GD_CT_PosTit					2
#define GD_CT_Und					3
#define GD_CT_High					4
#define GD_CT_Disab					5
#define GD_CT_Chk					6
#define GD_CT_Scaled					7
#define GD_CT_Ok					8
#define GD_CT_Annulla					9

#define GD_ITg_Tit					0
#define GD_ITg_Label					1
#define GD_ITg_PosTit					2
#define GD_ITg_Und					3
#define GD_ITg_High					4
#define GD_ITg_Num					5
#define GD_ITg_MaxCh					6
#define GD_ITg_Just					7
#define GD_ITg_Disab					8
#define GD_ITg_Imm					9
#define GD_ITg_Tab					10
#define GD_ITg_Help					11
#define GD_ITg_Rep					12
#define GD_ITg_Ok					13
#define GD_ITg_Annulla					14

#define GD_LT_Tit					0
#define GD_LT_Label					1
#define GD_LT_PosTit					2
#define GD_LT_Und					3
#define GD_LT_High					4
#define GD_LT_Ok					5
#define GD_LT_Annulla					6
#define GD_LT_Top					7
#define GD_LT_Vis					8
#define GD_LT_Sel					9
#define GD_LT_ScW					10
#define GD_LT_Spc					11
#define GD_LT_Disab					12
#define GD_LT_ROn					13
#define GD_LT_Show					14
#define GD_LT_IH					15
#define GD_LT_MaxP					16
#define GD_LT_Multi					17

#define GD_MT_PosTit					0
#define GD_MT_Und					1
#define GD_MT_High					2
#define GD_MT_Ok					3
#define GD_MT_Annulla					4
#define GD_MT_Tit					5
#define GD_MT_Label					6
#define GD_MT_Act					7
#define GD_MT_Spc					8
#define GD_MT_TitPlc					9
#define GD_MT_Disab					10
#define GD_MT_Scaled					11

#define GD_NT_Tit					0
#define GD_NT_Label					1
#define GD_NT_PosTit					2
#define GD_NT_Und					3
#define GD_NT_High					4
#define GD_NT_Ok					5
#define GD_NT_Annulla					6
#define GD_NT_Num					7
#define GD_NT_MNL					8
#define GD_NT_FPen					9
#define GD_NT_BPen					10
#define GD_NT_Just					11
#define GD_NT_Format					12
#define GD_NT_Border					13
#define GD_NT_Clip					14

#define GD_CyT_Tit					0
#define GD_CyT_Label					1
#define GD_CyT_PosTit					2
#define GD_CyT_Und					3
#define GD_CyT_High					4
#define GD_CyT_Ok					5
#define GD_CyT_Annulla					6
#define GD_CyT_Disab					7
#define GD_CyT_Act					8

#define GD_PT_Tit					0
#define GD_PT_Label					1
#define GD_PT_PosTit					2
#define GD_PT_Und					3
#define GD_PT_High					4
#define GD_PT_Ok					5
#define GD_PT_Annulla					6
#define GD_PT_Depth					7
#define GD_PT_Col					8
#define GD_PT_COff					9
#define GD_PT_NumC					10
#define GD_PT_Disab					11
#define GD_PT_IW					12
#define GD_PT_IH					13

#define GD_ST_Tit					0
#define GD_ST_Label					1
#define GD_ST_PosTit					2
#define GD_ST_Und					3
#define GD_ST_High					4
#define GD_ST_Ok					5
#define GD_ST_Annulla					6
#define GD_ST_Top					7
#define GD_ST_Tot					8
#define GD_ST_Vis					9
#define GD_ST_Arrows					10
#define GD_ST_Disab					11
#define GD_ST_RelVer					12
#define GD_ST_Imm					13
#define GD_ST_Free					14

#define GD_SlT_Tit					0
#define GD_SlT_Label					1
#define GD_SlT_PosTit					2
#define GD_SlT_Und					3
#define GD_SlT_High					4
#define GD_SlT_Ok					5
#define GD_SlT_Annulla					6
#define GD_SlT_Min					7
#define GD_SlT_Max					8
#define GD_SlT_Lev					9
#define GD_SlT_MLL					10
#define GD_SlT_Fmt					11
#define GD_SlT_MPL					12
#define GD_SlT_LevPlc					13
#define GD_SlT_Just					14
#define GD_SlT_Disab					15
#define GD_SlT_RelVer					16
#define GD_SlT_Imm					17
#define GD_SlT_Free					18

#define GD_StrT_Tit					0
#define GD_StrT_Label					1
#define GD_StrT_PosTit					2
#define GD_StrT_Und					3
#define GD_StrT_High					4
#define GD_StrT_Ok					5
#define GD_StrT_Annulla					6
#define GD_StrT_MaxC					7
#define GD_StrT_Str					8
#define GD_StrT_Just					9
#define GD_StrT_Disab					10
#define GD_StrT_Imm					11
#define GD_StrT_Tab					12
#define GD_StrT_Help					13
#define GD_StrT_Rep					14

#define GD_TT_Tit					0
#define GD_TT_Label					1
#define GD_TT_PosTit					2
#define GD_TT_Und					3
#define GD_TT_High					4
#define GD_TT_Ok					5
#define GD_TT_Annulla					6
#define GD_TT_FPen					7
#define GD_TT_BPen					8
#define GD_TT_Copy					9
#define GD_TT_Border					10
#define GD_TT_Clip					11
#define GD_TT_Txt					12
#define GD_TT_Just					13

#define GD_ScrT_LeftIn					0
#define GD_ScrT_TopIn					1
#define GD_ScrT_TitIn					2
#define GD_ScrT_Type					3
#define GD_ScrT_PubNameIn					4
#define GD_ScrT_Ok					5
#define GD_ScrT_Annulla					6
#define GD_ScrT_Left					7
#define GD_ScrT_Top					8
#define GD_ScrT_ShowTit					9
#define GD_ScrT_Behind					10
#define GD_ScrT_Quiet					11
#define GD_ScrT_FullPal					12
#define GD_ScrT_Error					13
#define GD_ScrT_Drag					14
#define GD_ScrT_Exclusive					15
#define GD_ScrT_SharePens					16
#define GD_ScrT_Interleaved					17
#define GD_ScrT_Overscan					18
#define GD_ScrT_LikeWB					19
#define GD_ScrT_MinISG					20

#define GD_GenList					0
#define GD_GenConfig					1

#define GD_LOC_On					0
#define GD_LOC_CatName					1
#define GD_LOC_Join					2
#define GD_LOC_BuiltIn					3
#define GD_LOC_Vers					4
#define GD_LOC_Ok					5
#define GD_LOC_Annulla					6
#define GD_LOC_Lang					7
#define GD_LOC_NewLang					8
#define GD_LOC_DelLang					9
#define GD_LOC_Strings					10
#define GD_LOC_NewStr					11
#define GD_LOC_DelStr					12
#define GD_LOC_ImpStr					13
#define GD_LOC_GetJoin					14

#define GD_GB_Lab					0
#define GD_GB_ShowOnOpen					1
#define GD_GB_Ok					2
#define GD_GB_Annulla					3

#define GD_BE_Label					0
#define GD_BE_Class					1
#define GD_BE_CType					2
#define GD_BE_Ok					3
#define GD_BE_Annulla					4
#define GD_BE_Tags					5
#define GD_BE_NewTag					6
#define GD_BE_DelTag					7
#define GD_BE_Bool					0
#define GD_BE_String					0
#define GD_BE_Objects					0
#define GD_BE_Long					0
#define GD_BE_Img					0

#define GD_LANG_Lang					0
#define GD_LANG_File					1
#define GD_LANG_Ok					2
#define GD_LANG_Cancel					3
#define GD_LANG_GetFile					4

#define GD_NS_Str					0
#define GD_NS_ID					1
#define GD_NS_Tran					2
#define GD_NS_New					3
#define GD_NS_Del					4
#define GD_NS_Ok					5
#define GD_NS_Cancel					6

#define GD_T_Str					0
#define GD_T_Lang					1
#define GD_T_Ok					2
#define GD_T_Cancel					3

#define GD_IMP_From					0
#define GD_IMP_To					1
#define GD_IMP_Link					2

#define DriPens_CNT 4
#define MEEdit_CNT 12
#define MenuEd_CNT 13
#define ImgBank_CNT 4
#define ImgBut_CNT 23
#define Tools_CNT 1
#define MutualX_CNT 8
#define Macro_CNT 11
#define BBox_CNT 6
#define TabCycle_CNT 1
#define SrcParams_CNT 8
#define IText_CNT 9
#define RexxEd_CNT 6
#define RexxCmd_CNT 5
#define MainProc_CNT 11
#define MPEdLib_CNT 6
#define WndTit_CNT 4
#define Lista_CNT 1
#define DimFin_CNT 14
#define Zoom_CNT 11
#define WndTag_CNT 20
#define GadSize_CNT 6
#define ListEd_CNT 6
#define ButTag_CNT 9
#define ChkTag_CNT 10
#define IntTag_CNT 15
#define LstTag_CNT 18
#define MxTag_CNT 12
#define NumTag_CNT 15
#define CycTag_CNT 9
#define PalTag_CNT 14
#define SclTag_CNT 15
#define SliTag_CNT 19
#define StrTag_CNT 15
#define TxtTag_CNT 14
#define ScrTags_CNT 21
#define Gen_CNT 2
#define Locale_CNT 14
#define GBankParam_CNT 4
#define BOOPSI_CNT 8
#define BE_BOOL_CNT 1
#define BE_STRING_CNT 1
#define BE_OBJECTS_CNT 1
#define BE_LONG_CNT 1
#define BE_IMAGE_CNT 1
#define Language_CNT 4
#define NewStr_CNT 7
#define Translation_CNT 4
#define Import_CNT 3

struct WindowBanks {
	struct Gadget **Banks;
	UWORD           Count;
};

extern struct IntuitionBase	*IntuitionBase;
extern struct Library		*GadToolsBase;
extern struct Library		*GfxBase;
extern struct Screen		*Scr;
extern int			YOffset;
extern UWORD			XOffset;
extern APTR			VisualInfo;
extern struct Catalog		*Catalog;
extern struct Window		*DriPensWnd;
extern struct Window		*BackWnd;
extern struct Window		*MEEditWnd;
extern struct Window		*MenuEdWnd;
extern struct Window		*ImgBankWnd;
extern struct Window		*ImgButWnd;
extern struct Window		*ToolsWnd;
extern struct Window		*MutualXWnd;
extern struct Window		*MacroWnd;
extern struct Window		*BBoxWnd;
extern struct Window		*TabCycleWnd;
extern struct Window		*SrcParamsWnd;
extern struct Window		*ITextWnd;
extern struct Window		*RexxEdWnd;
extern struct Window		*RexxCmdWnd;
extern struct Window		*MainProcWnd;
extern struct Window		*MPEdLibWnd;
extern struct Window		*WndTitWnd;
extern struct Window		*ListaWnd;
extern struct Window		*DimFinWnd;
extern struct Window		*ZoomWnd;
extern struct Window		*WndTagWnd;
extern struct Window		*GadSizeWnd;
extern struct Window		*ListEdWnd;
extern struct Window		*ButTagWnd;
extern struct Window		*ChkTagWnd;
extern struct Window		*IntTagWnd;
extern struct Window		*LstTagWnd;
extern struct Window		*MxTagWnd;
extern struct Window		*NumTagWnd;
extern struct Window		*CycTagWnd;
extern struct Window		*PalTagWnd;
extern struct Window		*SclTagWnd;
extern struct Window		*SliTagWnd;
extern struct Window		*StrTagWnd;
extern struct Window		*TxtTagWnd;
extern struct Window		*ScrTagsWnd;
extern struct Window		*GenWnd;
extern struct Window		*LocaleWnd;
extern struct Window		*GBankParamWnd;
extern struct Window		*BOOPSIWnd;
extern struct Window		*LanguageWnd;
extern struct Window		*NewStrWnd;
extern struct Window		*TranslationWnd;
extern struct Window		*ImportWnd;
extern struct Menu		*BackMenus;
extern struct Menu		*LocaleMenus;
extern struct Gadget		*DriPensGList;
extern struct Gadget		*MEEditGList;
extern struct Gadget		*MenuEdGList;
extern struct Gadget		*ImgBankGList;
extern struct Gadget		*ImgButGList;
extern struct Gadget		*ToolsGList;
extern struct Gadget		*MutualXGList;
extern struct Gadget		*MacroGList;
extern struct Gadget		*BBoxGList;
extern struct Gadget		*TabCycleGList;
extern struct Gadget		*SrcParamsGList;
extern struct Gadget		*ITextGList;
extern struct Gadget		*RexxEdGList;
extern struct Gadget		*RexxCmdGList;
extern struct Gadget		*MainProcGList;
extern struct Gadget		*MPEdLibGList;
extern struct Gadget		*WndTitGList;
extern struct Gadget		*ListaGList;
extern struct Gadget		*DimFinGList;
extern struct Gadget		*ZoomGList;
extern struct Gadget		*WndTagGList;
extern struct Gadget		*GadSizeGList;
extern struct Gadget		*ListEdGList;
extern struct Gadget		*ButTagGList;
extern struct Gadget		*ChkTagGList;
extern struct Gadget		*IntTagGList;
extern struct Gadget		*LstTagGList;
extern struct Gadget		*MxTagGList;
extern struct Gadget		*NumTagGList;
extern struct Gadget		*CycTagGList;
extern struct Gadget		*PalTagGList;
extern struct Gadget		*SclTagGList;
extern struct Gadget		*SliTagGList;
extern struct Gadget		*StrTagGList;
extern struct Gadget		*TxtTagGList;
extern struct Gadget		*ScrTagsGList;
extern struct Gadget		*GenGList;
extern struct Gadget		*LocaleGList;
extern struct Gadget		*GBankParamGList;
extern struct Gadget		*BOOPSIGList;
extern struct Gadget		*LanguageGList;
extern struct Gadget		*NewStrGList;
extern struct Gadget		*TranslationGList;
extern struct Gadget		*ImportGList;
extern struct WindowBanks		BOOPSIWBanks;
extern struct Gadget		*BE_BOOLGList;
extern struct Gadget		*BE_BOOLGadgets[1];
extern struct Gadget		*BE_STRINGGList;
extern struct Gadget		*BE_STRINGGadgets[1];
extern struct Gadget		*BE_OBJECTSGList;
extern struct Gadget		*BE_OBJECTSGadgets[1];
extern struct Gadget		*BE_LONGGList;
extern struct Gadget		*BE_LONGGadgets[1];
extern struct Gadget		*BE_IMAGEGList;
extern struct Gadget		*BE_IMAGEGadgets[1];
extern struct IntuiMessage	BackMsg;
extern struct IntuiMessage	MEEditMsg;
extern struct IntuiMessage	MenuEdMsg;
extern struct IntuiMessage	ImgButMsg;
extern struct IntuiMessage	ToolsMsg;
extern struct IntuiMessage	MutualXMsg;
extern struct IntuiMessage	BBoxMsg;
extern struct IntuiMessage	TabCycleMsg;
extern struct IntuiMessage	ITextMsg;
extern struct IntuiMessage	RexxCmdMsg;
extern struct IntuiMessage	MPEdLibMsg;
extern struct IntuiMessage	WndTitMsg;
extern struct IntuiMessage	ListaMsg;
extern struct IntuiMessage	DimFinMsg;
extern struct IntuiMessage	ZoomMsg;
extern struct IntuiMessage	WndTagMsg;
extern struct IntuiMessage	GadSizeMsg;
extern struct IntuiMessage	ListEdMsg;
extern struct IntuiMessage	ButTagMsg;
extern struct IntuiMessage	ChkTagMsg;
extern struct IntuiMessage	IntTagMsg;
extern struct IntuiMessage	LstTagMsg;
extern struct IntuiMessage	MxTagMsg;
extern struct IntuiMessage	NumTagMsg;
extern struct IntuiMessage	CycTagMsg;
extern struct IntuiMessage	PalTagMsg;
extern struct IntuiMessage	SclTagMsg;
extern struct IntuiMessage	SliTagMsg;
extern struct IntuiMessage	StrTagMsg;
extern struct IntuiMessage	TxtTagMsg;
extern struct IntuiMessage	GBankParamMsg;
extern struct IntuiMessage	BOOPSIMsg;
extern struct IntuiMessage	LanguageMsg;
extern struct IntuiMessage	NewStrMsg;
extern struct IntuiMessage	TranslationMsg;
extern struct IntuiMessage	ImportMsg;
extern struct Gadget		*DriPensGadgets[4];
extern struct Gadget		*MEEditGadgets[12];
extern struct Gadget		*MenuEdGadgets[13];
extern struct Gadget		*ImgBankGadgets[4];
extern struct Gadget		*ImgButGadgets[23];
extern struct Gadget		*ToolsGadgets[1];
extern struct Gadget		*MutualXGadgets[8];
extern struct Gadget		*MacroGadgets[11];
extern struct Gadget		*BBoxGadgets[6];
extern struct Gadget		*TabCycleGadgets[1];
extern struct Gadget		*SrcParamsGadgets[8];
extern struct Gadget		*ITextGadgets[9];
extern struct Gadget		*RexxEdGadgets[6];
extern struct Gadget		*RexxCmdGadgets[5];
extern struct Gadget		*MainProcGadgets[11];
extern struct Gadget		*MPEdLibGadgets[6];
extern struct Gadget		*WndTitGadgets[4];
extern struct Gadget		*ListaGadgets[1];
extern struct Gadget		*DimFinGadgets[14];
extern struct Gadget		*ZoomGadgets[11];
extern struct Gadget		*WndTagGadgets[20];
extern struct Gadget		*GadSizeGadgets[6];
extern struct Gadget		*ListEdGadgets[6];
extern struct Gadget		*ButTagGadgets[9];
extern struct Gadget		*ChkTagGadgets[10];
extern struct Gadget		*IntTagGadgets[15];
extern struct Gadget		*LstTagGadgets[18];
extern struct Gadget		*MxTagGadgets[12];
extern struct Gadget		*NumTagGadgets[15];
extern struct Gadget		*CycTagGadgets[9];
extern struct Gadget		*PalTagGadgets[14];
extern struct Gadget		*SclTagGadgets[15];
extern struct Gadget		*SliTagGadgets[19];
extern struct Gadget		*StrTagGadgets[15];
extern struct Gadget		*TxtTagGadgets[14];
extern struct Gadget		*ScrTagsGadgets[21];
extern struct Gadget		*GenGadgets[2];
extern struct Gadget		*LocaleGadgets[14];
extern struct Gadget		*GBankParamGadgets[4];
extern struct Gadget		*BOOPSIGadgets[8];
extern struct Gadget		*LanguageGadgets[4];
extern struct Gadget		*NewStrGadgets[7];
extern struct Gadget		*TranslationGadgets[4];
extern struct Gadget		*ImportGadgets[3];
extern struct MsgPort		*IDCMP_Port;
extern struct IntuiMessage	IDCMPMsg;
extern LONG OpenWndShd( struct Gadget *, struct TagItem *, struct Window **, ULONG );
extern void CloseWndShd( struct Window **, struct Gadget **, struct Menu ** );
extern void HandleIDCMPPort( void );
extern __chip UWORD UpGadgetImgData[78];
extern __chip UWORD DownGadgetImgData[78];
extern __chip UWORD WindowGadgetImgData[56];
extern __chip UWORD IDCMPGadgetImgData[56];
extern __chip UWORD WFlagsGadgetImgData[56];
extern __chip UWORD AddGadgetImgData[56];
extern __chip UWORD RemGadgetImgData[56];
extern __chip UWORD LoadGadgetImgData[56];
extern __chip UWORD SaveGadgetImgData[56];
extern __chip UWORD DelWndImgData[56];
extern __chip UWORD GImgData[56];
extern __chip UWORD ImgImgData[56];
extern __chip UWORD ScrImgData[56];
extern __chip UWORD GetFileImgData[56];
extern __chip UWORD GetFileDownImgData[56];
extern __chip UWORD AddGadgetDownImgData[56];
extern __chip UWORD DelWndDownImgData[56];
extern __chip UWORD GDownImgData[56];
extern __chip UWORD IDCMPGadgetDownImgData[56];
extern __chip UWORD ImgDownImgData[56];
extern __chip UWORD LoadGadgetDownImgData[56];
extern __chip UWORD RemGadgetDownImgData[56];
extern __chip UWORD SaveGadgetDownImgData[56];
extern __chip UWORD ScrDownImgData[56];
extern __chip UWORD WFlagsGadgetDownImgData[56];
extern __chip UWORD WindowGadgetDownImgData[56];
extern __chip UWORD DownGadgetDownImgData[78];
extern __chip UWORD BottomImgData[78];
extern __chip UWORD BottomDownImgData[78];
extern __chip UWORD UpGadgetDownImgData[78];
extern __chip UWORD TopImgData[78];
extern __chip UWORD TopDownImgData[78];
extern __chip UWORD LeftImgData[78];
extern __chip UWORD LeftDownImgData[78];
extern __chip UWORD RightImgData[78];
extern __chip UWORD RightDownImgData[78];
extern __chip UWORD DelBoxImgData[78];
extern __chip UWORD DelBoxDownImgData[78];
extern UBYTE			*Array0[];
extern UBYTE			*Array1[];
extern UBYTE			*Array2[];
extern UBYTE			*Array3[];
extern UBYTE			*Array4[];
extern UBYTE			*Array5[];
extern UBYTE			*Array6[];
extern UBYTE			*Array7[];
extern UBYTE			*Array8[];
extern UBYTE			*Array9[];
extern UBYTE			*Array10[];
extern UBYTE			*Array11[];
extern UBYTE			*Array12[];
extern UBYTE			*Array13[];
extern UBYTE			*QualifLabels[];
extern UBYTE			*BB_TypeLabels[];
extern struct MinList MP_LibFromList;
extern UWORD			DriPensGTypes[];
extern UWORD			MEEditGTypes[];
extern UWORD			MenuEdGTypes[];
extern UWORD			ImgBankGTypes[];
extern UWORD			ImgButGTypes[];
extern UWORD			ToolsGTypes[];
extern UWORD			MutualXGTypes[];
extern UWORD			MacroGTypes[];
extern UWORD			BBoxGTypes[];
extern UWORD			TabCycleGTypes[];
extern UWORD			SrcParamsGTypes[];
extern UWORD			ITextGTypes[];
extern UWORD			RexxEdGTypes[];
extern UWORD			RexxCmdGTypes[];
extern UWORD			MainProcGTypes[];
extern UWORD			MPEdLibGTypes[];
extern UWORD			WndTitGTypes[];
extern UWORD			ListaGTypes[];
extern UWORD			DimFinGTypes[];
extern UWORD			ZoomGTypes[];
extern UWORD			WndTagGTypes[];
extern UWORD			GadSizeGTypes[];
extern UWORD			ListEdGTypes[];
extern UWORD			ButTagGTypes[];
extern UWORD			ChkTagGTypes[];
extern UWORD			IntTagGTypes[];
extern UWORD			LstTagGTypes[];
extern UWORD			MxTagGTypes[];
extern UWORD			NumTagGTypes[];
extern UWORD			CycTagGTypes[];
extern UWORD			PalTagGTypes[];
extern UWORD			SclTagGTypes[];
extern UWORD			SliTagGTypes[];
extern UWORD			StrTagGTypes[];
extern UWORD			TxtTagGTypes[];
extern UWORD			ScrTagsGTypes[];
extern UWORD			GenGTypes[];
extern UWORD			LocaleGTypes[];
extern UWORD			GBankParamGTypes[];
extern UWORD			BOOPSIGTypes[];
extern UWORD			LanguageGTypes[];
extern UWORD			NewStrGTypes[];
extern UWORD			TranslationGTypes[];
extern UWORD			ImportGTypes[];
extern struct TextAttr		topaz8_065;
extern struct NewGadget		DriPensNGad[];
extern struct NewGadget		MEEditNGad[];
extern struct NewGadget		MenuEdNGad[];
extern struct NewGadget		ImgBankNGad[];
extern struct NewGadget		ImgButNGad[];
extern struct NewGadget		ToolsNGad[];
extern struct NewGadget		MutualXNGad[];
extern struct NewGadget		MacroNGad[];
extern struct NewGadget		BBoxNGad[];
extern struct NewGadget		TabCycleNGad[];
extern struct NewGadget		SrcParamsNGad[];
extern struct NewGadget		ITextNGad[];
extern struct NewGadget		RexxEdNGad[];
extern struct NewGadget		RexxCmdNGad[];
extern struct NewGadget		MainProcNGad[];
extern struct NewGadget		MPEdLibNGad[];
extern struct NewGadget		WndTitNGad[];
extern struct NewGadget		ListaNGad[];
extern struct NewGadget		DimFinNGad[];
extern struct NewGadget		ZoomNGad[];
extern struct NewGadget		WndTagNGad[];
extern struct NewGadget		GadSizeNGad[];
extern struct NewGadget		ListEdNGad[];
extern struct NewGadget		ButTagNGad[];
extern struct NewGadget		ChkTagNGad[];
extern struct NewGadget		IntTagNGad[];
extern struct NewGadget		LstTagNGad[];
extern struct NewGadget		MxTagNGad[];
extern struct NewGadget		NumTagNGad[];
extern struct NewGadget		CycTagNGad[];
extern struct NewGadget		PalTagNGad[];
extern struct NewGadget		SclTagNGad[];
extern struct NewGadget		SliTagNGad[];
extern struct NewGadget		StrTagNGad[];
extern struct NewGadget		TxtTagNGad[];
extern struct NewGadget		ScrTagsNGad[];
extern struct NewGadget		GenNGad[];
extern struct NewGadget		LocaleNGad[];
extern struct NewGadget		GBankParamNGad[];
extern struct NewGadget		BOOPSINGad[];
extern struct NewGadget		LanguageNGad[];
extern struct NewGadget		NewStrNGad[];
extern struct NewGadget		TranslationNGad[];
extern struct NewGadget		ImportNGad[];
extern ULONG			DriPensGTags[];
extern ULONG			MEEditGTags[];
extern ULONG			MenuEdGTags[];
extern ULONG			ImgBankGTags[];
extern ULONG			ImgButGTags[];
extern ULONG			ToolsGTags[];
extern ULONG			MutualXGTags[];
extern ULONG			MacroGTags[];
extern ULONG			BBoxGTags[];
extern ULONG			TabCycleGTags[];
extern ULONG			SrcParamsGTags[];
extern ULONG			ITextGTags[];
extern ULONG			RexxEdGTags[];
extern ULONG			RexxCmdGTags[];
extern ULONG			MainProcGTags[];
extern ULONG			MPEdLibGTags[];
extern ULONG			WndTitGTags[];
extern ULONG			ListaGTags[];
extern ULONG			DimFinGTags[];
extern ULONG			ZoomGTags[];
extern ULONG			WndTagGTags[];
extern ULONG			GadSizeGTags[];
extern ULONG			ListEdGTags[];
extern ULONG			ButTagGTags[];
extern ULONG			ChkTagGTags[];
extern ULONG			IntTagGTags[];
extern ULONG			LstTagGTags[];
extern ULONG			MxTagGTags[];
extern ULONG			NumTagGTags[];
extern ULONG			CycTagGTags[];
extern ULONG			PalTagGTags[];
extern ULONG			SclTagGTags[];
extern ULONG			SliTagGTags[];
extern ULONG			StrTagGTags[];
extern ULONG			TxtTagGTags[];
extern ULONG			ScrTagsGTags[];
extern ULONG			GenGTags[];
extern ULONG			LocaleGTags[];
extern ULONG			GBankParamGTags[];
extern ULONG			BOOPSIGTags[];
extern ULONG			LanguageGTags[];
extern ULONG			NewStrGTags[];
extern ULONG			TranslationGTags[];
extern ULONG			ImportGTags[];
extern struct Gadget		ME_IGiuGadget;
extern struct Gadget		ME_SSuGadget;
extern struct Gadget		ME_SGiuGadget;
extern struct Gadget		ME_TSuGadget;
extern struct Gadget		ME_TGiuGadget;
extern struct Gadget		ME_ISuGadget;
extern struct Gadget		WFlagsGadget;
extern struct Gadget		IDCMPGadget;
extern struct Gadget		AddWndGadget;
extern struct Gadget		ScrTypeGadget;
extern struct Gadget		OpenImgBankGadget;
extern struct Gadget		ToggleGadgetsGadget;
extern struct Gadget		DelWndGadget;
extern struct Gadget		SaveGUIGadget;
extern struct Gadget		LoadGUIGadget;
extern struct Gadget		RemGadgetGadget;
extern struct Gadget		AddGadGadget;
extern struct Gadget		rx_Get3Gadget;
extern struct Gadget		rx_Get2Gadget;
extern struct Gadget		rx_Get1Gadget;
extern struct Gadget		rx_Get10Gadget;
extern struct Gadget		rx_Get9Gadget;
extern struct Gadget		rx_Get8Gadget;
extern struct Gadget		rx_Get7Gadget;
extern struct Gadget		rx_Get6Gadget;
extern struct Gadget		rx_Get5Gadget;
extern struct Gadget		rx_Get4Gadget;
extern struct Gadget		BB_DeleteGadget;
extern struct Gadget		BB_DownGadget;
extern struct Gadget		BB_UpGadget;
extern struct Gadget		BB_RightGadget;
extern struct Gadget		BB_LeftGadget;
extern struct Gadget		TC_BottomGadget;
extern struct Gadget		TC_DownGadget;
extern struct Gadget		TC_TopGadget;
extern struct Gadget		TC_UpGadget;
extern struct Gadget		MP_WndDownGadget;
extern struct Gadget		MP_WndBottomGadget;
extern struct Gadget		MP_WndTopGadget;
extern struct Gadget		MP_WndUpGadget;
extern struct Gadget		LE_DownGadget;
extern struct Gadget		LE_BottomGadget;
extern struct Gadget		LE_TopGadget;
extern struct Gadget		LE_UpGadget;
extern struct Gadget		LOC_GetJoinGadget;
extern struct Gadget		LANG_GetFileGadget;
extern UWORD			BE_BOOLGTypes[];
extern struct NewGadget		BE_BOOLNGad[];
extern ULONG			BE_BOOLGTags[];
extern UWORD			BE_STRINGGTypes[];
extern struct NewGadget		BE_STRINGNGad[];
extern ULONG			BE_STRINGGTags[];
extern UWORD			BE_OBJECTSGTypes[];
extern struct NewGadget		BE_OBJECTSNGad[];
extern ULONG			BE_OBJECTSGTags[];
extern UWORD			BE_LONGGTypes[];
extern struct NewGadget		BE_LONGNGad[];
extern ULONG			BE_LONGGTags[];
extern UWORD			BE_IMAGEGTypes[];
extern struct NewGadget		BE_IMAGENGad[];
extern ULONG			BE_IMAGEGTags[];
extern BOOL AboutMenued( void );
extern BOOL NuovoMenued( void );
extern BOOL CaricaMenued( void );
extern BOOL SalvaMenued( void );
extern BOOL SalvaComeMenued( void );
extern BOOL SrcParamsMenued( void );
extern BOOL GeneraMenued( void );
extern BOOL FineMenued( void );
extern BOOL NewWndMenued( void );
extern BOOL ApriWndMenued( void );
extern BOOL ChiudiWndMenued( void );
extern BOOL ChiudiAllWndMenued( void );
extern BOOL EliminaWndMenued( void );
extern BOOL EliminaAllWndMenued( void );
extern BOOL TitoloWndMenued( void );
extern BOOL WndFlagsMenued( void );
extern BOOL IDCMPMenued( void );
extern BOOL WndSizeMenued( void );
extern BOOL ZoomMenued( void );
extern BOOL WndTagsMenued( void );
extern BOOL AddBoxMenued( void );
extern BOOL EditBoxesMenued( void );
extern BOOL AddImgMenued( void );
extern BOOL MoveImgMenued( void );
extern BOOL DelImgMenued( void );
extern BOOL AddTxtMenued( void );
extern BOOL DelTextMenued( void );
extern BOOL EditTxtMenued( void );
extern BOOL MoveTextMenued( void );
extern BOOL MakeGBankMenued( void );
extern BOOL DelGBankMenued( void );
extern BOOL EditGBankMenued( void );
extern BOOL HideGBankMenued( void );
extern BOOL ParamGBankMenued( void );
extern BOOL StampaWndMenued( void );
extern BOOL SalvaWndMenued( void );
extern BOOL CaricaWndMenued( void );
extern BOOL AddGadMenued( void );
extern BOOL DelGadMenued( void );
extern BOOL SelAllMenued( void );
extern BOOL ScelteMenued( void );
extern BOOL GadSizeMenued( void );
extern BOOL GadTagsMenued( void );
extern BOOL GadFontMenued( void );
extern BOOL AlignRightMenued( void );
extern BOOL AlignLeftMenued( void );
extern BOOL AlignUpMenued( void );
extern BOOL AlignDownMenued( void );
extern BOOL SpreadHorizMenued( void );
extern BOOL SpreadVertMenued( void );
extern BOOL XSpaceMenued( void );
extern BOOL YSpaceMenued( void );
extern BOOL ClonaWMenued( void );
extern BOOL ClonaHMenued( void );
extern BOOL ClonaBothMenued( void );
extern BOOL CopiaGadMenued( void );
extern BOOL TabOrderMenued( void );
extern BOOL SalvaGadMenued( void );
extern BOOL CaricaGadMenued( void );
extern BOOL ScrTagsMenued( void );
extern BOOL ScrTypeMenued( void );
extern BOOL ScrFontMenued( void );
extern BOOL DriPensMenued( void );
extern BOOL ChangeColMenued( void );
extern BOOL CaricaColMenued( void );
extern BOOL SalvaColMenued( void );
extern BOOL SalvaScrMenued( void );
extern BOOL CaricaScrMenued( void );
extern BOOL MenuEdMenued( void );
extern BOOL ImgBankMenued( void );
extern BOOL RexxEdMenued( void );
extern BOOL MainProcMenued( void );
extern BOOL LocaleMenued( void );
extern BOOL MacrosMenued( void );
extern BOOL AddMacroMenued( void );
extern BOOL RemMacroMenued( void );
extern BOOL ExecMacroMenued( void );
extern BOOL ToolsWndMenued( void );
extern BOOL UsaGadsMenued( void );
extern BOOL ToggleWBMenued( void );
extern BOOL WndInFrontMenued( void );
extern BOOL UseWFlagsMenued( void );
extern BOOL GenPrefsMenued( void );
extern BOOL IconeMenued( void );
extern BOOL SavePrefsMenued( void );
extern BOOL LOC_CatMenued( void );
extern BOOL LOC_CtMenued( void );
extern struct IntuiText		MainProcIText[];
extern struct IntuiText		WndTagIText[];
extern struct Image		UpGadgetImg;
extern struct Image		DownGadgetImg;
extern struct Image		WindowGadgetImg;
extern struct Image		IDCMPGadgetImg;
extern struct Image		WFlagsGadgetImg;
extern struct Image		AddGadgetImg;
extern struct Image		RemGadgetImg;
extern struct Image		LoadGadgetImg;
extern struct Image		SaveGadgetImg;
extern struct Image		DelWndImg;
extern struct Image		GImg;
extern struct Image		ImgImg;
extern struct Image		ScrImg;
extern struct Image		GetFileImg;
extern struct Image		GetFileDownImg;
extern struct Image		AddGadgetDownImg;
extern struct Image		DelWndDownImg;
extern struct Image		GDownImg;
extern struct Image		IDCMPGadgetDownImg;
extern struct Image		ImgDownImg;
extern struct Image		LoadGadgetDownImg;
extern struct Image		RemGadgetDownImg;
extern struct Image		SaveGadgetDownImg;
extern struct Image		ScrDownImg;
extern struct Image		WFlagsGadgetDownImg;
extern struct Image		WindowGadgetDownImg;
extern struct Image		DownGadgetDownImg;
extern struct Image		BottomImg;
extern struct Image		BottomDownImg;
extern struct Image		UpGadgetDownImg;
extern struct Image		TopImg;
extern struct Image		TopDownImg;
extern struct Image		LeftImg;
extern struct Image		LeftDownImg;
extern struct Image		RightImg;
extern struct Image		RightDownImg;
extern struct Image		DelBoxImg;
extern struct Image		DelBoxDownImg;
extern UWORD			RX_Unconfirmed;
extern struct MsgPort		*RexxPort;
extern UBYTE			RexxPortName[];
extern BOOL SetupRexxPort( void );
extern void DeleteRexxPort( void );
extern void HandleRexxMsg( void );
extern BOOL SendRexxMsg( char *Host, char *Ext, char *Command, APTR Msg, LONG Flags );
extern struct MinList		RexxCommands;

struct CmdNode {
	struct Node	Node;
	STRPTR	Template;
	LONG	( *Routine )( ULONG *, struct RexxMsg * );
};
extern LONG QuitRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG NewRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG SetNameRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetNameRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG AddBoxRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG AddITextRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GenerateRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetActWndDataRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetBoxRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetBoxAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetDriPenRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetFontAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetImgRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetImgAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetITextRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetITextAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetScrFontRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetWndDataRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG OpenRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG SaveRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG SaveAsRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG SetBoxAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG SetImgAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG SetITextAttrRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetTxtLenRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern LONG GetFileRexxed( ULONG *ArgArray, struct RexxMsg *Msg );
extern struct TagItem		DriPensWTags[];
extern struct TagItem		BackWTags[];
extern struct TagItem		MEEditWTags[];
extern struct TagItem		MenuEdWTags[];
extern struct TagItem		ImgBankWTags[];
extern struct TagItem		ImgButWTags[];
extern struct TagItem		ToolsWTags[];
extern struct TagItem		MutualXWTags[];
extern struct TagItem		MacroWTags[];
extern struct TagItem		BBoxWTags[];
extern struct TagItem		TabCycleWTags[];
extern struct TagItem		SrcParamsWTags[];
extern struct TagItem		ITextWTags[];
extern struct TagItem		RexxEdWTags[];
extern struct TagItem		RexxCmdWTags[];
extern struct TagItem		MainProcWTags[];
extern struct TagItem		MPEdLibWTags[];
extern struct TagItem		WndTitWTags[];
extern struct TagItem		ListaWTags[];
extern struct TagItem		DimFinWTags[];
extern struct TagItem		ZoomWTags[];
extern struct TagItem		WndTagWTags[];
extern struct TagItem		GadSizeWTags[];
extern struct TagItem		ListEdWTags[];
extern struct TagItem		ButTagWTags[];
extern struct TagItem		ChkTagWTags[];
extern struct TagItem		IntTagWTags[];
extern struct TagItem		LstTagWTags[];
extern struct TagItem		MxTagWTags[];
extern struct TagItem		NumTagWTags[];
extern struct TagItem		CycTagWTags[];
extern struct TagItem		PalTagWTags[];
extern struct TagItem		SclTagWTags[];
extern struct TagItem		SliTagWTags[];
extern struct TagItem		StrTagWTags[];
extern struct TagItem		TxtTagWTags[];
extern struct TagItem		ScrTagsWTags[];
extern struct TagItem		GenWTags[];
extern struct TagItem		LocaleWTags[];
extern struct TagItem		GBankParamWTags[];
extern struct TagItem		BOOPSIWTags[];
extern struct TagItem		LanguageWTags[];
extern struct TagItem		NewStrWTags[];
extern struct TagItem		TranslationWTags[];
extern struct TagItem		ImportWTags[];
extern struct TextAttr		ScreenFont;
extern struct ColorSpec		ScreenColors[];
extern UWORD			DriPens[];
extern ULONG			ScreenTags[];
extern void SetupLocale( void );
extern void LocalizeArray( UBYTE ** );
extern void LocalizeTags( ULONG *, UWORD );
extern void LocalizeList( struct MinList * );
extern void LocalizeGadgets( struct NewGadget *, ULONG *, UWORD *, UWORD );
extern void LocalizeMenus( struct NewMenu * );
extern void LocalizeITexts( struct IntuiText *, UWORD );
extern UBYTE GetActivationKey( STRPTR );
extern void AddGadgetBank( struct Window *, struct WindowBanks *, struct Gadget * );
extern void RemGadgetBank( struct Window *, struct WindowBanks *, struct Gadget * );
extern LONG OpenDriPensWindow( void );
extern void CloseDriPensWindow( void );
extern LONG OpenBackWindow( void );
extern void CloseBackWindow( void );
extern LONG OpenMEEditWindow( void );
extern void CloseMEEditWindow( void );
extern LONG OpenMenuEdWindow( void );
extern void CloseMenuEdWindow( void );
extern LONG OpenImgBankWindow( void );
extern void CloseImgBankWindow( void );
extern LONG OpenImgButWindow( void );
extern void CloseImgButWindow( void );
extern LONG OpenToolsWindow( void );
extern void CloseToolsWindow( void );
extern LONG OpenMutualXWindow( void );
extern void CloseMutualXWindow( void );
extern LONG OpenMacroWindow( void );
extern void CloseMacroWindow( void );
extern LONG OpenBBoxWindow( void );
extern void CloseBBoxWindow( void );
extern LONG OpenTabCycleWindow( void );
extern void CloseTabCycleWindow( void );
extern LONG OpenSrcParamsWindow( void );
extern void CloseSrcParamsWindow( void );
extern LONG OpenITextWindow( void );
extern void CloseITextWindow( void );
extern LONG OpenRexxEdWindow( void );
extern void CloseRexxEdWindow( void );
extern LONG OpenRexxCmdWindow( void );
extern void CloseRexxCmdWindow( void );
extern LONG OpenMainProcWindow( void );
extern void CloseMainProcWindow( void );
extern LONG OpenMPEdLibWindow( void );
extern void CloseMPEdLibWindow( void );
extern LONG OpenWndTitWindow( void );
extern void CloseWndTitWindow( void );
extern LONG OpenListaWindow( void );
extern void CloseListaWindow( void );
extern LONG OpenDimFinWindow( void );
extern void CloseDimFinWindow( void );
extern LONG OpenZoomWindow( void );
extern void CloseZoomWindow( void );
extern LONG OpenWndTagWindow( void );
extern void CloseWndTagWindow( void );
extern LONG OpenGadSizeWindow( void );
extern void CloseGadSizeWindow( void );
extern LONG OpenListEdWindow( void );
extern void CloseListEdWindow( void );
extern LONG OpenButTagWindow( void );
extern void CloseButTagWindow( void );
extern LONG OpenChkTagWindow( void );
extern void CloseChkTagWindow( void );
extern LONG OpenIntTagWindow( void );
extern void CloseIntTagWindow( void );
extern LONG OpenLstTagWindow( void );
extern void CloseLstTagWindow( void );
extern LONG OpenMxTagWindow( void );
extern void CloseMxTagWindow( void );
extern LONG OpenNumTagWindow( void );
extern void CloseNumTagWindow( void );
extern LONG OpenCycTagWindow( void );
extern void CloseCycTagWindow( void );
extern LONG OpenPalTagWindow( void );
extern void ClosePalTagWindow( void );
extern LONG OpenSclTagWindow( void );
extern void CloseSclTagWindow( void );
extern LONG OpenSliTagWindow( void );
extern void CloseSliTagWindow( void );
extern LONG OpenStrTagWindow( void );
extern void CloseStrTagWindow( void );
extern LONG OpenTxtTagWindow( void );
extern void CloseTxtTagWindow( void );
extern LONG OpenScrTagsWindow( void );
extern void CloseScrTagsWindow( void );
extern LONG OpenGenWindow( void );
extern void CloseGenWindow( void );
extern LONG OpenLocaleWindow( void );
extern void CloseLocaleWindow( void );
extern LONG OpenGBankParamWindow( void );
extern void CloseGBankParamWindow( void );
extern LONG OpenBOOPSIWindow( void );
extern void CloseBOOPSIWindow( void );
extern LONG OpenLanguageWindow( void );
extern void CloseLanguageWindow( void );
extern LONG OpenNewStrWindow( void );
extern void CloseNewStrWindow( void );
extern LONG OpenTranslationWindow( void );
extern void CloseTranslationWindow( void );
extern LONG OpenImportWindow( void );
extern void CloseImportWindow( void );
extern void ImgButRender( void );
extern void MainProcRender( void );
extern void WndTagRender( void );
extern void ButTagRender( void );
extern void ChkTagRender( void );
extern void IntTagRender( void );
extern void LstTagRender( void );
extern void MxTagRender( void );
extern void NumTagRender( void );
extern void CycTagRender( void );
extern void PalTagRender( void );
extern void SclTagRender( void );
extern void SliTagRender( void );
extern void StrTagRender( void );
extern void TxtTagRender( void );
extern void LocaleRender( void );
extern void GBankParamRender( void );
extern void BOOPSIRender( void );
extern LONG HandleDriPensIDCMP( void );
extern BOOL DriPensVanillaKey( void );
extern LONG HandleBackIDCMP( void );
extern BOOL BackRawKey( void );
extern LONG HandleMEEditIDCMP( void );
extern BOOL MEEditVanillaKey( void );
extern LONG HandleMenuEdIDCMP( void );
extern BOOL MenuEdCloseWindow( void );
extern BOOL MenuEdIntuiTicks( void );
extern LONG HandleImgBankIDCMP( void );
extern BOOL ImgBankCloseWindow( void );
extern LONG HandleImgButIDCMP( void );
extern BOOL ImgButVanillaKey( void );
extern LONG HandleMutualXIDCMP( void );
extern LONG HandleMacroIDCMP( void );
extern BOOL MacroVanillaKey( void );
extern BOOL MacroCloseWindow( void );
extern LONG HandleBBoxIDCMP( void );
extern BOOL BBoxVanillaKey( void );
extern BOOL BBoxCloseWindow( void );
extern BOOL BBoxIntuiTicks( void );
extern LONG HandleTabCycleIDCMP( void );
extern BOOL TabCycleCloseWindow( void );
extern LONG HandleSrcParamsIDCMP( void );
extern BOOL SrcParamsVanillaKey( void );
extern LONG HandleITextIDCMP( void );
extern BOOL ITextVanillaKey( void );
extern LONG HandleRexxEdIDCMP( void );
extern BOOL RexxEdVanillaKey( void );
extern BOOL RexxEdCloseWindow( void );
extern BOOL RexxEdIntuiTicks( void );
extern LONG HandleRexxCmdIDCMP( void );
extern BOOL RexxCmdVanillaKey( void );
extern LONG HandleMainProcIDCMP( void );
extern BOOL MainProcCloseWindow( void );
extern BOOL MainProcIntuiTicks( void );
extern LONG HandleMPEdLibIDCMP( void );
extern BOOL MPEdLibVanillaKey( void );
extern LONG HandleWndTitIDCMP( void );
extern BOOL WndTitVanillaKey( void );
extern LONG HandleListaIDCMP( void );
extern BOOL ListaCloseWindow( void );
extern BOOL ListaRawKey( void );
extern LONG HandleDimFinIDCMP( void );
extern BOOL DimFinVanillaKey( void );
extern LONG HandleZoomIDCMP( void );
extern BOOL ZoomVanillaKey( void );
extern LONG HandleWndTagIDCMP( void );
extern BOOL WndTagVanillaKey( void );
extern LONG HandleGadSizeIDCMP( void );
extern BOOL GadSizeVanillaKey( void );
extern LONG HandleListEdIDCMP( void );
extern BOOL ListEdVanillaKey( void );
extern BOOL ListEdRawKey( void );
extern LONG HandleButTagIDCMP( void );
extern BOOL ButTagVanillaKey( void );
extern LONG HandleChkTagIDCMP( void );
extern BOOL ChkTagVanillaKey( void );
extern LONG HandleIntTagIDCMP( void );
extern BOOL IntTagVanillaKey( void );
extern LONG HandleLstTagIDCMP( void );
extern BOOL LstTagVanillaKey( void );
extern LONG HandleMxTagIDCMP( void );
extern BOOL MxTagVanillaKey( void );
extern LONG HandleNumTagIDCMP( void );
extern BOOL NumTagVanillaKey( void );
extern LONG HandleCycTagIDCMP( void );
extern BOOL CycTagVanillaKey( void );
extern LONG HandlePalTagIDCMP( void );
extern BOOL PalTagVanillaKey( void );
extern LONG HandleSclTagIDCMP( void );
extern BOOL SclTagVanillaKey( void );
extern LONG HandleSliTagIDCMP( void );
extern BOOL SliTagVanillaKey( void );
extern LONG HandleStrTagIDCMP( void );
extern BOOL StrTagVanillaKey( void );
extern LONG HandleTxtTagIDCMP( void );
extern BOOL TxtTagVanillaKey( void );
extern LONG HandleScrTagsIDCMP( void );
extern BOOL ScrTagsVanillaKey( void );
extern LONG HandleGenIDCMP( void );
extern BOOL GenCloseWindow( void );
extern LONG HandleLocaleIDCMP( void );
extern BOOL LocaleVanillaKey( void );
extern LONG HandleGBankParamIDCMP( void );
extern BOOL GBankParamVanillaKey( void );
extern LONG HandleBOOPSIIDCMP( void );
extern BOOL BOOPSIVanillaKey( void );
extern LONG HandleLanguageIDCMP( void );
extern BOOL LanguageVanillaKey( void );
extern LONG HandleNewStrIDCMP( void );
extern BOOL NewStrVanillaKey( void );
extern LONG HandleTranslationIDCMP( void );
extern BOOL TranslationVanillaKey( void );
extern LONG HandleImportIDCMP( void );
extern BOOL ImportVanillaKey( void );
extern BOOL ImportCloseWindow( void );
extern BOOL HandleDriPensKeys( void );
extern BOOL DP_PensKeyPressed( void );
extern BOOL DP_PalKeyPressed( void );
extern BOOL HandleMEEditKeys( void );
extern BOOL MEd_BarKeyPressed( void );
extern BOOL MEd_DisabKeyPressed( void );
extern BOOL MEd_ChkItKeyPressed( void );
extern BOOL MEd_CheckedKeyPressed( void );
extern BOOL MEd_ToggleKeyPressed( void );
extern BOOL HandleImgBankKeys( void );
extern BOOL IB_ImgsKeyPressed( void );
extern BOOL HandleImgButKeys( void );
extern BOOL Img_ChkTxtKeyPressed( void );
extern BOOL Img_RPModeKeyPressed( void );
extern BOOL Img_InversKeyPressed( void );
extern BOOL Img_FPKeyPressed( void );
extern BOOL Img_BPKeyPressed( void );
extern BOOL Img_GadRendKeyPressed( void );
extern BOOL Img_SelRendKeyPressed( void );
extern BOOL Img_HighKeyPressed( void );
extern BOOL Img_ToggleKeyPressed( void );
extern BOOL Img_ImmediateKeyPressed( void );
extern BOOL Img_RelVerKeyPressed( void );
extern BOOL Img_FollowKeyPressed( void );
extern BOOL Img_SelKeyPressed( void );
extern BOOL Img_DisabKeyPressed( void );
extern BOOL HandleMacroKeys( void );
extern BOOL HandleBBoxKeys( void );
extern BOOL BB_RecessedKeyPressed( void );
extern BOOL HandleSrcParamsKeys( void );
extern BOOL SP_GenScrKeyPressed( void );
extern BOOL SP_FontAdaptKeyPressed( void );
extern BOOL SP_OpenFontsKeyPressed( void );
extern BOOL SP_mainKeyPressed( void );
extern BOOL SP_ShdPortKeyPressed( void );
extern BOOL HandleITextKeys( void );
extern BOOL TXT_FPenKeyPressed( void );
extern BOOL TXT_BPenKeyPressed( void );
extern BOOL TXT_InvKeyPressed( void );
extern BOOL TXT_ModeKeyPressed( void );
extern BOOL TXT_ScrFontKeyPressed( void );
extern BOOL HandleRexxEdKeys( void );
extern BOOL RXE_CmdKeyPressed( void );
extern BOOL RXE_CmdInKeyPressed( void );
extern BOOL HandleRexxCmdKeys( void );
extern BOOL HandleMPEdLibKeys( void );
extern BOOL MPEL_FailKeyPressed( void );
extern BOOL HandleWndTitKeys( void );
extern BOOL HandleDimFinKeys( void );
extern BOOL DF_InWcKeyPressed( void );
extern BOOL DF_InHcKeyPressed( void );
extern BOOL HandleZoomKeys( void );
extern BOOL Z_UsaKeyPressed( void );
extern BOOL HandleWndTagKeys( void );
extern BOOL WTg_ScTitleKeyPressed( void );
extern BOOL WTg_AdjustKeyPressed( void );
extern BOOL WTg_FallBackKeyPressed( void );
extern BOOL WTg_MQKeyPressed( void );
extern BOOL WTg_RQKeyPressed( void );
extern BOOL WTg_NotDepthKeyPressed( void );
extern BOOL WTg_MenuHKeyPressed( void );
extern BOOL WTg_TabMsgKeyPressed( void );
extern BOOL WTg_LocGadKeyPressed( void );
extern BOOL WTg_LocTitKeyPressed( void );
extern BOOL WTg_LocScrTitKeyPressed( void );
extern BOOL WTg_LocMenuKeyPressed( void );
extern BOOL WTg_LocTxtKeyPressed( void );
extern BOOL WT_ShdPortKeyPressed( void );
extern BOOL WTg_BackKeyPressed( void );
extern BOOL HandleGadSizeKeys( void );
extern BOOL HandleListEdKeys( void );
extern BOOL HandleButTagKeys( void );
extern BOOL BT_PosTitKeyPressed( void );
extern BOOL BT_UndKeyPressed( void );
extern BOOL BT_HighKeyPressed( void );
extern BOOL BT_DisabKeyPressed( void );
extern BOOL BT_ImmKeyPressed( void );
extern BOOL HandleChkTagKeys( void );
extern BOOL CT_PosTitKeyPressed( void );
extern BOOL CT_UndKeyPressed( void );
extern BOOL CT_HighKeyPressed( void );
extern BOOL CT_DisabKeyPressed( void );
extern BOOL CT_ChkKeyPressed( void );
extern BOOL CT_ScaledKeyPressed( void );
extern BOOL HandleIntTagKeys( void );
extern BOOL ITg_PosTitKeyPressed( void );
extern BOOL ITg_UndKeyPressed( void );
extern BOOL ITg_HighKeyPressed( void );
extern BOOL ITg_JustKeyPressed( void );
extern BOOL ITg_DisabKeyPressed( void );
extern BOOL ITg_ImmKeyPressed( void );
extern BOOL ITg_TabKeyPressed( void );
extern BOOL ITg_HelpKeyPressed( void );
extern BOOL ITg_RepKeyPressed( void );
extern BOOL HandleLstTagKeys( void );
extern BOOL LT_PosTitKeyPressed( void );
extern BOOL LT_UndKeyPressed( void );
extern BOOL LT_HighKeyPressed( void );
extern BOOL LT_DisabKeyPressed( void );
extern BOOL LT_ROnKeyPressed( void );
extern BOOL LT_ShowKeyPressed( void );
extern BOOL LT_MultiKeyPressed( void );
extern BOOL HandleMxTagKeys( void );
extern BOOL MT_PosTitKeyPressed( void );
extern BOOL MT_UndKeyPressed( void );
extern BOOL MT_HighKeyPressed( void );
extern BOOL MT_TitPlcKeyPressed( void );
extern BOOL MT_DisabKeyPressed( void );
extern BOOL MT_ScaledKeyPressed( void );
extern BOOL HandleNumTagKeys( void );
extern BOOL NT_PosTitKeyPressed( void );
extern BOOL NT_UndKeyPressed( void );
extern BOOL NT_HighKeyPressed( void );
extern BOOL NT_JustKeyPressed( void );
extern BOOL NT_BorderKeyPressed( void );
extern BOOL NT_ClipKeyPressed( void );
extern BOOL HandleCycTagKeys( void );
extern BOOL CyT_PosTitKeyPressed( void );
extern BOOL CyT_UndKeyPressed( void );
extern BOOL CyT_HighKeyPressed( void );
extern BOOL CyT_DisabKeyPressed( void );
extern BOOL HandlePalTagKeys( void );
extern BOOL PT_PosTitKeyPressed( void );
extern BOOL PT_UndKeyPressed( void );
extern BOOL PT_HighKeyPressed( void );
extern BOOL PT_DisabKeyPressed( void );
extern BOOL HandleSclTagKeys( void );
extern BOOL ST_PosTitKeyPressed( void );
extern BOOL ST_UndKeyPressed( void );
extern BOOL ST_HighKeyPressed( void );
extern BOOL ST_DisabKeyPressed( void );
extern BOOL ST_RelVerKeyPressed( void );
extern BOOL ST_ImmKeyPressed( void );
extern BOOL ST_FreeKeyPressed( void );
extern BOOL HandleSliTagKeys( void );
extern BOOL SlT_PosTitKeyPressed( void );
extern BOOL SlT_UndKeyPressed( void );
extern BOOL SlT_HighKeyPressed( void );
extern BOOL SlT_LevPlcKeyPressed( void );
extern BOOL SlT_JustKeyPressed( void );
extern BOOL SlT_DisabKeyPressed( void );
extern BOOL SlT_RelVerKeyPressed( void );
extern BOOL SlT_ImmKeyPressed( void );
extern BOOL SlT_FreeKeyPressed( void );
extern BOOL HandleStrTagKeys( void );
extern BOOL StrT_PosTitKeyPressed( void );
extern BOOL StrT_UndKeyPressed( void );
extern BOOL StrT_HighKeyPressed( void );
extern BOOL StrT_JustKeyPressed( void );
extern BOOL StrT_DisabKeyPressed( void );
extern BOOL StrT_ImmKeyPressed( void );
extern BOOL StrT_TabKeyPressed( void );
extern BOOL StrT_HelpKeyPressed( void );
extern BOOL StrT_RepKeyPressed( void );
extern BOOL HandleTxtTagKeys( void );
extern BOOL TT_PosTitKeyPressed( void );
extern BOOL TT_UndKeyPressed( void );
extern BOOL TT_HighKeyPressed( void );
extern BOOL TT_CopyKeyPressed( void );
extern BOOL TT_BorderKeyPressed( void );
extern BOOL TT_ClipKeyPressed( void );
extern BOOL TT_JustKeyPressed( void );
extern BOOL HandleScrTagsKeys( void );
extern BOOL ScrT_TypeKeyPressed( void );
extern BOOL ScrT_LeftKeyPressed( void );
extern BOOL ScrT_TopKeyPressed( void );
extern BOOL ScrT_ShowTitKeyPressed( void );
extern BOOL ScrT_BehindKeyPressed( void );
extern BOOL ScrT_QuietKeyPressed( void );
extern BOOL ScrT_FullPalKeyPressed( void );
extern BOOL ScrT_ErrorKeyPressed( void );
extern BOOL ScrT_DragKeyPressed( void );
extern BOOL ScrT_ExclusiveKeyPressed( void );
extern BOOL ScrT_SharePensKeyPressed( void );
extern BOOL ScrT_InterleavedKeyPressed( void );
extern BOOL ScrT_OverscanKeyPressed( void );
extern BOOL ScrT_LikeWBKeyPressed( void );
extern BOOL ScrT_MinISGKeyPressed( void );
extern BOOL HandleGenKeys( void );
extern BOOL HandleLocaleKeys( void );
extern BOOL LOC_OnKeyPressed( void );
extern BOOL HandleGBankParamKeys( void );
extern BOOL GB_ShowOnOpenKeyPressed( void );
extern BOOL HandleBOOPSIKeys( void );
extern BOOL BE_CTypeKeyPressed( void );
extern BOOL HandleLanguageKeys( void );
extern BOOL HandleNewStrKeys( void );
extern BOOL HandleTranslationKeys( void );
extern BOOL HandleImportKeys( void );

extern int SetupScreen( void );
extern void CloseDownScreen( void );
extern struct Gadget *MakeGadgets( struct Gadget **GList, struct Gadget *Gads[],
	struct NewGadget NGad[], UWORD GTypes[], ULONG GTags[], UWORD CNT );
extern LONG OpenWnd( struct Gadget *GList, struct TagItem WTags[], struct Window **Wnd );
extern void CloseWnd( struct Window **Wnd, struct Gadget **GList, struct Menu **Mn );
extern BOOL DP_PensClicked( void );
extern BOOL DP_PalClicked( void );
extern BOOL DP_OkClicked( void );
extern BOOL DP_AnnClicked( void );
extern BOOL MEd_ImgClicked( void );
extern BOOL MEd_BarClicked( void );
extern BOOL MEd_DisabClicked( void );
extern BOOL MEd_ChkItClicked( void );
extern BOOL MEd_CheckedClicked( void );
extern BOOL MEd_ToggleClicked( void );
extern BOOL MEd_OkClicked( void );
extern BOOL MEd_AnnullaClicked( void );
extern BOOL MEd_TxtClicked( void );
extern BOOL MEd_CmdKClicked( void );
extern BOOL MEd_LabelClicked( void );
extern BOOL ME_TitleClicked( void );
extern BOOL ME_ItemClicked( void );
extern BOOL ME_SubClicked( void );
extern BOOL ME_TNuovoClicked( void );
extern BOOL ME_TDelClicked( void );
extern BOOL ME_INuovoClicked( void );
extern BOOL ME_IDelClicked( void );
extern BOOL ME_SNuovoClicked( void );
extern BOOL ME_SDelClicked( void );
extern BOOL ME_TestClicked( void );
extern BOOL ME_IExcludeClicked( void );
extern BOOL ME_SExcludeClicked( void );
extern BOOL ME_OkClicked( void );
extern BOOL ME_ISuClicked( void );
extern BOOL ME_TGiuClicked( void );
extern BOOL ME_TSuClicked( void );
extern BOOL ME_SGiuClicked( void );
extern BOOL ME_SSuClicked( void );
extern BOOL ME_IGiuClicked( void );
extern BOOL IB_NewClicked( void );
extern BOOL IB_ImgsClicked( void );
extern BOOL IB_DelClicked( void );
extern BOOL IB_LabelClicked( void );
extern BOOL Img_ChkTxtClicked( void );
extern BOOL Img_RPModeClicked( void );
extern BOOL Img_InversClicked( void );
extern BOOL Img_FPClicked( void );
extern BOOL Img_BPClicked( void );
extern BOOL Img_GadRendClicked( void );
extern BOOL Img_SelRendClicked( void );
extern BOOL Img_HighClicked( void );
extern BOOL Img_ToggleClicked( void );
extern BOOL Img_ImmediateClicked( void );
extern BOOL Img_RelVerClicked( void );
extern BOOL Img_FollowClicked( void );
extern BOOL Img_SelClicked( void );
extern BOOL Img_DisabClicked( void );
extern BOOL Img_SameClicked( void );
extern BOOL Img_OKClicked( void );
extern BOOL Img_AnnullaClicked( void );
extern BOOL Img_LabelClicked( void );
extern BOOL Img_TxtClicked( void );
extern BOOL Img_XClicked( void );
extern BOOL Img_YClicked( void );
extern BOOL Img_WidthClicked( void );
extern BOOL Img_HeightClicked( void );
extern BOOL AddGadClicked( void );
extern BOOL RemGadgetClicked( void );
extern BOOL LoadGUIClicked( void );
extern BOOL SaveGUIClicked( void );
extern BOOL DelWndClicked( void );
extern BOOL ToggleGadgetsClicked( void );
extern BOOL OpenImgBankClicked( void );
extern BOOL ScrTypeClicked( void );
extern BOOL AddWndClicked( void );
extern BOOL IDCMPClicked( void );
extern BOOL WFlagsClicked( void );
extern BOOL MX_IncClicked( void );
extern BOOL MX_ExcClicked( void );
extern BOOL MX_ExAllClicked( void );
extern BOOL MX_ExThisClicked( void );
extern BOOL MX_IncThisClicked( void );
extern BOOL MX_IncAllClicked( void );
extern BOOL MX_OkClicked( void );
extern BOOL MX_AnnullaClicked( void );
extern BOOL QualifClicked( void );
extern BOOL rx_1Clicked( void );
extern BOOL rx_2Clicked( void );
extern BOOL rx_3Clicked( void );
extern BOOL rx_4Clicked( void );
extern BOOL rx_5Clicked( void );
extern BOOL rx_6Clicked( void );
extern BOOL rx_7Clicked( void );
extern BOOL rx_8Clicked( void );
extern BOOL rx_9Clicked( void );
extern BOOL rx_10Clicked( void );
extern BOOL rx_Get4Clicked( void );
extern BOOL rx_Get5Clicked( void );
extern BOOL rx_Get6Clicked( void );
extern BOOL rx_Get7Clicked( void );
extern BOOL rx_Get8Clicked( void );
extern BOOL rx_Get9Clicked( void );
extern BOOL rx_Get10Clicked( void );
extern BOOL rx_Get1Clicked( void );
extern BOOL rx_Get2Clicked( void );
extern BOOL rx_Get3Clicked( void );
extern BOOL BB_XClicked( void );
extern BOOL BB_YClicked( void );
extern BOOL BB_WClicked( void );
extern BOOL BB_HClicked( void );
extern BOOL BB_RecessedClicked( void );
extern BOOL BB_TypeClicked( void );
extern BOOL BB_LeftClicked( void );
extern BOOL BB_RightClicked( void );
extern BOOL BB_UpClicked( void );
extern BOOL BB_DownClicked( void );
extern BOOL BB_DeleteClicked( void );
extern BOOL TC_GadgetsClicked( void );
extern BOOL TC_UpClicked( void );
extern BOOL TC_TopClicked( void );
extern BOOL TC_DownClicked( void );
extern BOOL TC_BottomClicked( void );
extern BOOL SP_OkClicked( void );
extern BOOL SP_AnnullaClicked( void );
extern BOOL SP_GenScrClicked( void );
extern BOOL SP_FontAdaptClicked( void );
extern BOOL SP_OpenFontsClicked( void );
extern BOOL SP_mainClicked( void );
extern BOOL SP_ShdPortClicked( void );
extern BOOL SP_ShdPortInClicked( void );
extern BOOL TXT_FPenClicked( void );
extern BOOL TXT_BPenClicked( void );
extern BOOL TXT_InvClicked( void );
extern BOOL TXT_ModeClicked( void );
extern BOOL TXT_TxtClicked( void );
extern BOOL TXT_FontClicked( void );
extern BOOL TXT_ScrFontClicked( void );
extern BOOL TXT_OkClicked( void );
extern BOOL TXT_AnnullaClicked( void );
extern BOOL RXE_CmdClicked( void );
extern BOOL RXE_AddClicked( void );
extern BOOL RXE_DelClicked( void );
extern BOOL RXE_PortClicked( void );
extern BOOL RXE_ExtClicked( void );
extern BOOL RXE_CmdInClicked( void );
extern BOOL RXC_LabelClicked( void );
extern BOOL RXC_CmdClicked( void );
extern BOOL RXC_TemplateClicked( void );
extern BOOL RXC_OkClicked( void );
extern BOOL RXC_AnnullaClicked( void );
extern BOOL MP_OpenLibClicked( void );
extern BOOL MP_LibFromClicked( void );
extern BOOL MP_AddLibClicked( void );
extern BOOL MP_DelLibClicked( void );
extern BOOL MP_OpenWndClicked( void );
extern BOOL MP_AddWndClicked( void );
extern BOOL MP_DelWndClicked( void );
extern BOOL MP_CtrlCClicked( void );
extern BOOL MP_XtraProcClicked( void );
extern BOOL MP_XtraBitsClicked( void );
extern BOOL MP_WBClicked( void );
extern BOOL MP_WndUpClicked( void );
extern BOOL MP_WndTopClicked( void );
extern BOOL MP_WndBottomClicked( void );
extern BOOL MP_WndDownClicked( void );
extern BOOL MPEL_LibClicked( void );
extern BOOL MPEL_BaseClicked( void );
extern BOOL MPEL_VersClicked( void );
extern BOOL MPEL_FailClicked( void );
extern BOOL MPEL_OkClicked( void );
extern BOOL MPEL_AnnullaClicked( void );
extern BOOL TitFinClicked( void );
extern BOOL TitLabelClicked( void );
extern BOOL TitFinOkClicked( void );
extern BOOL TitFinAnnullaClicked( void );
extern BOOL ListaClicked( void );
extern BOOL DF_MinWClicked( void );
extern BOOL DF_MaxWClicked( void );
extern BOOL DF_MinHClicked( void );
extern BOOL DF_MaxHClicked( void );
extern BOOL DF_MinWbClicked( void );
extern BOOL DF_MaxWbClicked( void );
extern BOOL DF_MinHbClicked( void );
extern BOOL DF_MaxHbClicked( void );
extern BOOL DF_InWcClicked( void );
extern BOOL DF_InHcClicked( void );
extern BOOL DF_InWClicked( void );
extern BOOL DF_InHClicked( void );
extern BOOL DF_OkClicked( void );
extern BOOL DF_AnnullaClicked( void );
extern BOOL Z_OkClicked( void );
extern BOOL Z_AnnullaClicked( void );
extern BOOL Z_LeftClicked( void );
extern BOOL Z_TopClicked( void );
extern BOOL Z_WidthClicked( void );
extern BOOL Z_HeightClicked( void );
extern BOOL Z_LbClicked( void );
extern BOOL Z_TbClicked( void );
extern BOOL Z_WbClicked( void );
extern BOOL Z_HbClicked( void );
extern BOOL Z_UsaClicked( void );
extern BOOL WTg_ScTitleClicked( void );
extern BOOL WTg_ScTitInClicked( void );
extern BOOL WTg_AdjustClicked( void );
extern BOOL WTg_FallBackClicked( void );
extern BOOL WTg_MQInClicked( void );
extern BOOL WTg_RQInClicked( void );
extern BOOL WTg_MQClicked( void );
extern BOOL WTg_RQClicked( void );
extern BOOL WTg_NotDepthClicked( void );
extern BOOL WTg_MenuHClicked( void );
extern BOOL WTg_TabMsgClicked( void );
extern BOOL WTg_OkClicked( void );
extern BOOL WTg_AnnullaClicked( void );
extern BOOL WTg_LocGadClicked( void );
extern BOOL WTg_LocTitClicked( void );
extern BOOL WTg_LocScrTitClicked( void );
extern BOOL WTg_LocMenuClicked( void );
extern BOOL WTg_LocTxtClicked( void );
extern BOOL WT_ShdPortClicked( void );
extern BOOL WTg_BackClicked( void );
extern BOOL GS_XClicked( void );
extern BOOL GS_YClicked( void );
extern BOOL GS_HClicked( void );
extern BOOL GS_WClicked( void );
extern BOOL GS_OkClicked( void );
extern BOOL GS_AnnullaClicked( void );
extern BOOL LE_ListClicked( void );
extern BOOL LE_InClicked( void );
extern BOOL LE_NewClicked( void );
extern BOOL LE_DelClicked( void );
extern BOOL LE_OkClicked( void );
extern BOOL LE_AnnullaClicked( void );
extern BOOL LE_UpClicked( void );
extern BOOL LE_TopClicked( void );
extern BOOL LE_BottomClicked( void );
extern BOOL LE_DownClicked( void );
extern BOOL BT_TitClicked( void );
extern BOOL BT_LabelClicked( void );
extern BOOL BT_PosTitClicked( void );
extern BOOL BT_UndClicked( void );
extern BOOL BT_HighClicked( void );
extern BOOL BT_OkClicked( void );
extern BOOL BT_DisabClicked( void );
extern BOOL BT_ImmClicked( void );
extern BOOL BT_AnnullaClicked( void );
extern BOOL CT_TitClicked( void );
extern BOOL CT_LabelClicked( void );
extern BOOL CT_PosTitClicked( void );
extern BOOL CT_UndClicked( void );
extern BOOL CT_HighClicked( void );
extern BOOL CT_DisabClicked( void );
extern BOOL CT_ChkClicked( void );
extern BOOL CT_ScaledClicked( void );
extern BOOL CT_OkClicked( void );
extern BOOL CT_AnnullaClicked( void );
extern BOOL ITg_TitClicked( void );
extern BOOL ITg_LabelClicked( void );
extern BOOL ITg_PosTitClicked( void );
extern BOOL ITg_UndClicked( void );
extern BOOL ITg_HighClicked( void );
extern BOOL ITg_NumClicked( void );
extern BOOL ITg_MaxChClicked( void );
extern BOOL ITg_JustClicked( void );
extern BOOL ITg_DisabClicked( void );
extern BOOL ITg_ImmClicked( void );
extern BOOL ITg_TabClicked( void );
extern BOOL ITg_HelpClicked( void );
extern BOOL ITg_RepClicked( void );
extern BOOL ITg_OkClicked( void );
extern BOOL ITg_AnnullaClicked( void );
extern BOOL LT_TitClicked( void );
extern BOOL LT_LabelClicked( void );
extern BOOL LT_PosTitClicked( void );
extern BOOL LT_UndClicked( void );
extern BOOL LT_HighClicked( void );
extern BOOL LT_OkClicked( void );
extern BOOL LT_AnnullaClicked( void );
extern BOOL LT_TopClicked( void );
extern BOOL LT_VisClicked( void );
extern BOOL LT_SelClicked( void );
extern BOOL LT_ScWClicked( void );
extern BOOL LT_SpcClicked( void );
extern BOOL LT_DisabClicked( void );
extern BOOL LT_ROnClicked( void );
extern BOOL LT_ShowClicked( void );
extern BOOL LT_IHClicked( void );
extern BOOL LT_MaxPClicked( void );
extern BOOL LT_MultiClicked( void );
extern BOOL MT_PosTitClicked( void );
extern BOOL MT_UndClicked( void );
extern BOOL MT_HighClicked( void );
extern BOOL MT_OkClicked( void );
extern BOOL MT_AnnullaClicked( void );
extern BOOL MT_TitClicked( void );
extern BOOL MT_LabelClicked( void );
extern BOOL MT_ActClicked( void );
extern BOOL MT_SpcClicked( void );
extern BOOL MT_TitPlcClicked( void );
extern BOOL MT_DisabClicked( void );
extern BOOL MT_ScaledClicked( void );
extern BOOL NT_TitClicked( void );
extern BOOL NT_LabelClicked( void );
extern BOOL NT_PosTitClicked( void );
extern BOOL NT_UndClicked( void );
extern BOOL NT_HighClicked( void );
extern BOOL NT_OkClicked( void );
extern BOOL NT_AnnullaClicked( void );
extern BOOL NT_NumClicked( void );
extern BOOL NT_MNLClicked( void );
extern BOOL NT_FPenClicked( void );
extern BOOL NT_BPenClicked( void );
extern BOOL NT_JustClicked( void );
extern BOOL NT_FormatClicked( void );
extern BOOL NT_BorderClicked( void );
extern BOOL NT_ClipClicked( void );
extern BOOL CyT_TitClicked( void );
extern BOOL CyT_LabelClicked( void );
extern BOOL CyT_PosTitClicked( void );
extern BOOL CyT_UndClicked( void );
extern BOOL CyT_HighClicked( void );
extern BOOL CyT_OkClicked( void );
extern BOOL CyT_AnnullaClicked( void );
extern BOOL CyT_DisabClicked( void );
extern BOOL CyT_ActClicked( void );
extern BOOL PT_TitClicked( void );
extern BOOL PT_LabelClicked( void );
extern BOOL PT_PosTitClicked( void );
extern BOOL PT_UndClicked( void );
extern BOOL PT_HighClicked( void );
extern BOOL PT_OkClicked( void );
extern BOOL PT_AnnullaClicked( void );
extern BOOL PT_DepthClicked( void );
extern BOOL PT_ColClicked( void );
extern BOOL PT_COffClicked( void );
extern BOOL PT_NumCClicked( void );
extern BOOL PT_DisabClicked( void );
extern BOOL PT_IWClicked( void );
extern BOOL PT_IHClicked( void );
extern BOOL ST_TitClicked( void );
extern BOOL ST_LabelClicked( void );
extern BOOL ST_PosTitClicked( void );
extern BOOL ST_UndClicked( void );
extern BOOL ST_HighClicked( void );
extern BOOL ST_OkClicked( void );
extern BOOL ST_AnnullaClicked( void );
extern BOOL ST_TopClicked( void );
extern BOOL ST_TotClicked( void );
extern BOOL ST_VisClicked( void );
extern BOOL ST_ArrowsClicked( void );
extern BOOL ST_DisabClicked( void );
extern BOOL ST_RelVerClicked( void );
extern BOOL ST_ImmClicked( void );
extern BOOL ST_FreeClicked( void );
extern BOOL SlT_TitClicked( void );
extern BOOL SlT_LabelClicked( void );
extern BOOL SlT_PosTitClicked( void );
extern BOOL SlT_UndClicked( void );
extern BOOL SlT_HighClicked( void );
extern BOOL SlT_OkClicked( void );
extern BOOL SlT_AnnullaClicked( void );
extern BOOL SlT_MinClicked( void );
extern BOOL SlT_MaxClicked( void );
extern BOOL SlT_LevClicked( void );
extern BOOL SlT_MLLClicked( void );
extern BOOL SlT_FmtClicked( void );
extern BOOL SlT_MPLClicked( void );
extern BOOL SlT_LevPlcClicked( void );
extern BOOL SlT_JustClicked( void );
extern BOOL SlT_DisabClicked( void );
extern BOOL SlT_RelVerClicked( void );
extern BOOL SlT_ImmClicked( void );
extern BOOL SlT_FreeClicked( void );
extern BOOL StrT_TitClicked( void );
extern BOOL StrT_LabelClicked( void );
extern BOOL StrT_PosTitClicked( void );
extern BOOL StrT_UndClicked( void );
extern BOOL StrT_HighClicked( void );
extern BOOL StrT_OkClicked( void );
extern BOOL StrT_AnnullaClicked( void );
extern BOOL StrT_MaxCClicked( void );
extern BOOL StrT_StrClicked( void );
extern BOOL StrT_JustClicked( void );
extern BOOL StrT_DisabClicked( void );
extern BOOL StrT_ImmClicked( void );
extern BOOL StrT_TabClicked( void );
extern BOOL StrT_HelpClicked( void );
extern BOOL StrT_RepClicked( void );
extern BOOL TT_TitClicked( void );
extern BOOL TT_LabelClicked( void );
extern BOOL TT_PosTitClicked( void );
extern BOOL TT_UndClicked( void );
extern BOOL TT_HighClicked( void );
extern BOOL TT_OkClicked( void );
extern BOOL TT_AnnullaClicked( void );
extern BOOL TT_FPenClicked( void );
extern BOOL TT_BPenClicked( void );
extern BOOL TT_CopyClicked( void );
extern BOOL TT_BorderClicked( void );
extern BOOL TT_ClipClicked( void );
extern BOOL TT_TxtClicked( void );
extern BOOL TT_JustClicked( void );
extern BOOL ScrT_LeftInClicked( void );
extern BOOL ScrT_TopInClicked( void );
extern BOOL ScrT_TitInClicked( void );
extern BOOL ScrT_TypeClicked( void );
extern BOOL ScrT_PubNameInClicked( void );
extern BOOL ScrT_OkClicked( void );
extern BOOL ScrT_AnnullaClicked( void );
extern BOOL ScrT_LeftClicked( void );
extern BOOL ScrT_TopClicked( void );
extern BOOL ScrT_ShowTitClicked( void );
extern BOOL ScrT_BehindClicked( void );
extern BOOL ScrT_QuietClicked( void );
extern BOOL ScrT_FullPalClicked( void );
extern BOOL ScrT_ErrorClicked( void );
extern BOOL ScrT_DragClicked( void );
extern BOOL ScrT_ExclusiveClicked( void );
extern BOOL ScrT_SharePensClicked( void );
extern BOOL ScrT_InterleavedClicked( void );
extern BOOL ScrT_OverscanClicked( void );
extern BOOL ScrT_LikeWBClicked( void );
extern BOOL ScrT_MinISGClicked( void );
extern BOOL GenListClicked( void );
extern BOOL GenConfigClicked( void );
extern BOOL LOC_OnClicked( void );
extern BOOL LOC_CatNameClicked( void );
extern BOOL LOC_JoinClicked( void );
extern BOOL LOC_BuiltInClicked( void );
extern BOOL LOC_VersClicked( void );
extern BOOL LOC_OkClicked( void );
extern BOOL LOC_AnnullaClicked( void );
extern BOOL LOC_LangClicked( void );
extern BOOL LOC_NewLangClicked( void );
extern BOOL LOC_DelLangClicked( void );
extern BOOL LOC_StringsClicked( void );
extern BOOL LOC_NewStrClicked( void );
extern BOOL LOC_DelStrClicked( void );
extern BOOL LOC_ImpStrClicked( void );
extern BOOL LOC_GetJoinClicked( void );
extern BOOL GB_LabClicked( void );
extern BOOL GB_ShowOnOpenClicked( void );
extern BOOL GB_OkClicked( void );
extern BOOL GB_AnnullaClicked( void );
extern BOOL BE_LabelClicked( void );
extern BOOL BE_ClassClicked( void );
extern BOOL BE_CTypeClicked( void );
extern BOOL BE_OkClicked( void );
extern BOOL BE_AnnullaClicked( void );
extern BOOL BE_TagsClicked( void );
extern BOOL BE_NewTagClicked( void );
extern BOOL BE_DelTagClicked( void );
extern BOOL BE_BoolClicked( void );
extern BOOL BE_StringClicked( void );
extern BOOL BE_ObjectsClicked( void );
extern BOOL BE_LongClicked( void );
extern BOOL BE_ImgClicked( void );
extern BOOL LANG_LangClicked( void );
extern BOOL LANG_FileClicked( void );
extern BOOL LANG_OkClicked( void );
extern BOOL LANG_CancelClicked( void );
extern BOOL LANG_GetFileClicked( void );
extern BOOL NS_StrClicked( void );
extern BOOL NS_IDClicked( void );
extern BOOL NS_TranClicked( void );
extern BOOL NS_NewClicked( void );
extern BOOL NS_DelClicked( void );
extern BOOL NS_OkClicked( void );
extern BOOL NS_CancelClicked( void );
extern BOOL T_StrClicked( void );
extern BOOL T_LangClicked( void );
extern BOOL T_OkClicked( void );
extern BOOL T_CancelClicked( void );
extern BOOL IMP_FromClicked( void );
extern BOOL IMP_ToClicked( void );
extern BOOL IMP_LinkClicked( void );
