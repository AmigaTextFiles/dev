*
* CdBSian Obviously Universal & Interactive Nonsense (COUIN)
* (Absurdité CdBSienne Manifestement Universelle et Interactive)
* ©1997-1998, CdBS Software (MORB)
* Include file for gui stuff
* $Id: Gui.i 0.15 1998/04/11 12:15:39 MORB Exp MORB $
*

NbGuiPlanes        = 2

GuiBufferHeight    = 256
GuiBufferWidth     = 80
GuiLineSize        = GuiBufferWidth*NbGuiPlanes
GuiBufferSize      = GuiLineSize*GuiBufferHeight
GuiModulo          = GuiLineSize-80

GuiSelBufferHeight = 256
GuiSelBufferWidth  = 40
GuiSelLineSize     = GuiSelBufferWidth*NbPlanes
GuiSelBufferSize   = GuiSelLineSize*GuiSelBufferHeight
GuiSelModulo       = GuiSelLineSize-40

HotPointX          = 1
HotPointY          = 1

GuiHorSpacing      = 2
GuiVerSpacing      = 1

GuiScreenWidth     = (GuiBufferWidth-4)*8

         rsreset
Gui                rs.b      0
g_Object           rs.l      1
g_ObjectTree       rs.b      1

         rsreset
GuiDomain          rs.b      0
gd_Left            rs.l      1
gd_Right           rs.l      1
gd_Top             rs.l      1
gd_Bottom          rs.l      1
gd_Width           rs.l      1
gd_Height          rs.l      1
gd_Size            rs.l      1

***** GuiRootClass *****
         CLASS     GuiRootClass,RootClass

         METHOD    GCM_GetMinMax
         METHOD    GCM_Layout
         METHOD    GCM_Render
         METHOD    GCM_Update
         METHOD    GCM_Clear
         METHOD    GCM_UnderMouse
         METHOD    GCM_Click
         METHOD    GCM_Handle
         METHOD    GCM_GoActive
         METHOD    GCM_HandleRawKey
         METHOD    GCM_HandleAsciiKey
         METHOD    GCM_ActivateFirst
         METHOD    GCM_ActivateLast
         METHOD    GCM_ActivateNext
         METHOD    GCM_ActivatePrev

         DATA_BYTE guir,DTA_Domain,gd_Size
         DATA_LONG guir,DTA_MinWidth,1
         DATA_LONG guir,DTA_MinHeight,1
         DATA_LONG guir,DTA_MaxWidth,1
         DATA_LONG guir,DTA_MaxHeight,1
         DATA_LONG guir,DTA_Weight,1
         DATA_LONG guir,DTA_Hook,1
         DATA_LONG guir,DTA_HookData,1
         DATA_LONG guir,DTA_Activable,1
         DATA_SIZE guir_DataSize
************************

***** GuiClass *****
         CLASS     GuiClass,GuiRootClass

         METHOD    GM_Open
         METHOD    GM_Close
         METHOD    GM_Move
         METHOD    GM_Show
         METHOD    GM_Hide
         METHOD    GM_Toggle
         METHOD    GM_Activate

         DATA_LONG gui,GDTA_ShownFlag,1
         DATA_LONG gui,GDTA_ActiveObj,1

         DATA_LONG gui,GDTA_OldGui,1
         DATA_LONG gui,GDTA_OldStyleGui,1
         DATA_LONG gui,GDTA_Error,1
         DATA_SIZE gui_DataSize

GUI      macro
         dc.l      OBJ_Begin,_GuiClass
         endm

ENDOBJ   macro
         dc.l      OBJ_End
         endm

STOOBJ   macro     ; address
         dc.l      OBJ_Store,\1
         endm

SETHOOK  macro     ; hook,hookdata
         ifne      \1
         dc.l      DTA_Hook,\1
         endc

         ifne      \2
         dc.l      DTA_HookData,\2
         endc
         endm
********************

***** HGroupClass *****
         CLASS     HGroupClass,GuiRootClass

         DATA_LONG hgr,HGDT_Spacing,1
         DATA_SIZE hgr_DataSize

HGROUP   macro
         dc.l      OBJ_Begin,_HGroupClass
         endm
***********************

***** VKnobClass *****
         CLASS     VKnobClass,GuiRootClass

         DATA_LONG vkb,VKDT_TotSize,1
         DATA_LONG vkb,VKDT_TotWeight,1
         DATA_LONG vkb,VKDT_MinPos,1
         DATA_LONG vkb,VKDT_MaxPos,1
         DATA_SIZE vkb_DataSize

VKNOB    macro
         dc.l      OBJ_Begin,_VKnobClass
         dc.l      OBJ_End
         endm
************************

***** VGroupClass *****
         CLASS     VGroupClass,GuiRootClass

         DATA_LONG vgr,VGDT_Spacing,1
         DATA_SIZE vgr_DataSize

VGROUP   macro
         dc.l      OBJ_Begin,_VGroupClass
         endm
***********************

***** HKnobClass *****
         CLASS     HKnobClass,GuiRootClass

         DATA_LONG hkb,HKDT_TotSize,1
         DATA_LONG hkb,HKDT_TotWeight,1
         DATA_LONG hkb,HKDT_MinPos,1
         DATA_LONG hkb,HKDT_MaxPos,1
         DATA_SIZE hkb_DataSize

HKNOB    macro
         dc.l      OBJ_Begin,_HKnobClass
         dc.l      OBJ_End
         endm
************************

***** EmptyClass *****
         CLASS     EmptyClass,GuiRootClass

EMPTY    macro
         dc.l      OBJ_Begin,_EmptyClass
         dc.l      OBJ_End
         endm
**********************

***** ButtonClass *****
         CLASS     ButtonClass,GuiRootClass

         DATA_LONG btn,BDTA_Label,1
         DATA_LONG btn,BDTA_Repeat,1

         DATA_LONG btn,BDTA_TextWidth,1
         DATA_LONG btn,BDTA_TextX,1
         DATA_SIZE btn_DataSize

BUTTON   macro     ; label,hook,hookdata
         dc.l      OBJ_Begin,_ButtonClass
         dc.l      BDTA_Label,\1
         SETHOOK   \2,\3
         dc.l      OBJ_End
         endm
***********************

***** DragBarClass *****
         CLASS     DragBarClass,ButtonClass

DRAGBAR  macro     ; label
         dc.l      OBJ_Begin,_DragBarClass
         dc.l      BDTA_Label,\1
         dc.l      OBJ_End
         endm
************************

***** SmallButtonClass *****
         CLASS     SmallButtonClass,ButtonClass

         DATA_LONG sbtn,SBDT_Char,2
         DATA_LONG sbtn,SBDT_Width,1
         DATA_SIZE sbtn_DataSize

SMALLBTN macro     ; char,hook,hookdata
         dc.l      OBJ_Begin,_SmallButtonClass
         dc.l      SBDT_Char,\1
         SETHOOK   \2,\3
         dc.l      OBJ_End
         endm
****************************

***** TextClass *****
         CLASS     TextClass,GuiRootClass

         DATA_LONG txt,TDTA_Text,1
         DATA_LONG txt,TDTA_FData,1
         DATA_SIZE txt_DataSize

TEXT     macro     ; text,fdatas
         dc.l      OBJ_Begin,_TextClass
         dc.l      TDTA_Text,\1
         dc.l      TDTA_FData,\2
         dc.l      OBJ_End
         endm
*********************

***** FixedTextClass *****
         CLASS     FixedTextClass,TextClass

FIXEDTXT macro     ; text,fdatas
         dc.l      OBJ_Begin,_FixedTextClass
         dc.l      TDTA_Text,\1
         dc.l      TDTA_FData,\2
         dc.l      OBJ_End
         endm
*********************


***** HPropClass *****
         CLASS     HPropClass,GuiRootClass

         METHOD    HPM_Incr
         METHOD    HPM_Decr

         DATA_LONG hpr,HPDT_Position,1
         DATA_LONG hpr,HPDT_Total,1
         DATA_LONG hpr,HPDT_Visible,1
         DATA_LONG hpr,HPDT_LayoutNotify,1

         DATA_LONG hpr,HPDT_MaxPos,1
         DATA_LONG hpr,HPDT_KnobPos,1
         DATA_LONG hpr,HPDT_KnobSize,1
         DATA_LONG hpr,HPDT_OldKnobPos,1
         DATA_LONG hpr,HPDT_OldKnobSize,1
         DATA_SIZE hpr_DataSize

HPROP    macro     ; position,total,visible,hook,hookdata
         dc.l      OBJ_Begin,_HPropClass
         dc.l      HPDT_Position,\1
         dc.l      HPDT_Total,\2
         dc.l      HPDT_Visible,\3
         SETHOOK   \4,\5
         dc.l      OBJ_End
         endm
**********************

***** VPropClass *****
         CLASS     VPropClass,GuiRootClass

         METHOD    VPM_Incr
         METHOD    VPM_Decr

         DATA_LONG vpr,VPDT_Position,1
         DATA_LONG vpr,VPDT_Total,1
         DATA_LONG vpr,VPDT_Visible,1
         DATA_LONG vpr,VPDT_LayoutNotify,1

         DATA_LONG vpr,VPDT_MaxPos,1
         DATA_LONG vpr,VPDT_KnobPos,1
         DATA_LONG vpr,VPDT_KnobSize,1
         DATA_LONG vpr,VPDT_OldKnobPos,1
         DATA_LONG vpr,VPDT_OldKnobSize,1
         DATA_SIZE vpr_DataSize

VPROP    macro     ; position,total,visible,hook,hookdata
         dc.l      OBJ_Begin,_VPropClass
         dc.l      VPDT_Position,\1
         dc.l      VPDT_Total,\2
         dc.l      VPDT_Visible,\3
         SETHOOK   \4,\5
         dc.l      OBJ_End
         endm
**********************

***** HScrollerClass *****
         CLASS     HScrollerClass,GuiRootClass

         METHOD    HSM_Incr
         METHOD    HSM_Decr

         DATA_LONG hsc,HSDT_Position,1
         DATA_LONG hsc,HSDT_Total,1
         DATA_LONG hsc,HSDT_Visible,1
         DATA_LONG hsc,HSDT_LayoutNotify,1

         DATA_LONG hsc,HSDT_Prop,1
         DATA_SIZE hsc_DataSize

HSCROLLR macro     ; position,total,visible,hook,hookdata
         dc.l      OBJ_Begin,_HScrollerClass
         dc.l      HSDT_Position,\1
         dc.l      HSDT_Total,\2
         dc.l      HSDT_Visible,\3
         SETHOOK   \4,\5
         dc.l      OBJ_End
         endm
**************************

***** VScrollerClass *****
         CLASS     VScrollerClass,GuiRootClass

         METHOD    VSM_Incr
         METHOD    VSM_Decr

         DATA_LONG vsc,VSDT_Position,1
         DATA_LONG vsc,VSDT_Total,1
         DATA_LONG vsc,VSDT_Visible,1
         DATA_LONG vsc,VSDT_LayoutNotify,1

         DATA_LONG vsc,VSDT_Prop,1
         DATA_SIZE vsc_DataSize

VSCROLLR macro     ; position,total,visible,hook,hookdata
         dc.l      OBJ_Begin,_VScrollerClass
         dc.l      VSDT_Position,\1
         dc.l      VSDT_Total,\2
         dc.l      VSDT_Visible,\3
         SETHOOK   \4,\5
         dc.l      OBJ_End
         endm
**************************

***** ScrollAreaClass *****
         CLASS     ScrollAreaClass,GuiRootClass

         METHOD    SAM_HIncr
         METHOD    SAM_HDecr
         METHOD    SAM_VIncr
         METHOD    SAM_VDecr
         METHOD    SAM_ContentsGetSizes
         METHOD    SAM_ContentsRender
         METHOD    SAM_ContentsNewHPos
         METHOD    SAM_ContentsNewVPos
         METHOD    SAM_ContentsUpdate
         METHOD    SAM_ContentsUnderMouse
         METHOD    SAM_ContentsClick

         DATA_BYTE sac,SADT_ContentsDomain,gd_Size

         DATA_LONG sac,SADT_BoxWidth,1
         DATA_LONG sac,SADT_BoxHeight,1

         DATA_LONG sac,SADT_ContentsWidthNVS,1
         DATA_LONG sac,SADT_ContentsWidthVS,1
         DATA_LONG sac,SADT_ContentsHeightNHS,1
         DATA_LONG sac,SADT_ContentsHeightHS,1

         DATA_LONG sac,SADT_HScroller,1
         DATA_LONG sac,SADT_VScroller,1

         DATA_LONG sac,SADT_HSCRedraw,1
         DATA_LONG sac,SADT_VSCRedraw,1

         DATA_LONG sac,SADT_HPos,1
         DATA_LONG sac,SADT_VPos,1

         DATA_LONG sac,SADT_HSFlag,1
         DATA_LONG sac,SADT_VSFlag,1

         DATA_LONG sac,SADT_HTotalNVS,1
         DATA_LONG sac,SADT_HVisibleNVS,1
         DATA_LONG sac,SADT_VTotalNVS,1

         DATA_LONG sac,SADT_HTotalVS,1
         DATA_LONG sac,SADT_HVisibleVS,1
         DATA_LONG sac,SADT_VTotalVS,1

         DATA_LONG sac,SADT_VVisibleNHS,1
         DATA_LONG sac,SADT_VVisibleHS,1
         DATA_SIZE sac_DataSize
***************************

***** ListViewClass *****
         CLASS     ListViewClass,GuiRootClass

         DATA_LONG lvi,LVDT_List,1
         DATA_LONG lvi,LVDT_Selected,1

         DATA_LONG lvi,LVDT_Scroller,1
         DATA_LONG lvi,LVDT_ShowScroller,1
         DATA_LONG lvi,LVDT_ClearScroller,1
         DATA_LONG lvi,LVDT_Total,1
         DATA_LONG lvi,LVDT_FirstVis,1
         DATA_LONG lvi,LVDT_LastVis,1
         DATA_LONG lvi,LVDT_FVNum,1
         DATA_LONG lvi,LVDT_LVNum,1
         DATA_LONG lvi,LVDT_NumVis,1
         DATA_LONG lvi,LVDT_ClrTop,1
         DATA_LONG lvi,LVDT_ClrHeight,1
         DATA_LONG lvi,LVDT_Width,1
         DATA_LONG lvi,LVDT_Right,1
         DATA_SIZE lvi_DataSize

LISTVIEW macro     ; list,selected,first,hook,hookdata
         dc.l      OBJ_Begin,_ListViewClass
         dc.l      LVDT_List,\1
         dc.l      LVDT_Selected,\2
         dc.l      LVDT_FirstVis,\3
         SETHOOK   \4,\5
         dc.l      OBJ_End
         endm

         rsreset
ListViewEntry      rs.b      0
lve_Next           rs.l      1
lve_Prev           rs.l      1
lve_String         rs.l      1
lve_Color          rs.l      1
lve_Size           rs.b      0
*************************


***** OLD OBSOLETE SYSTEM *****
         rsreset
GuiEntry rs.b      0
ge_Class           rs.l      1
ge_Data            rs.l      1
ge_Data2           rs.l      1
ge_Data3           rs.l      1
ge_Hook            rs.l      1
ge_ID              rs.l      1
ge_Temp            rs.l      1
ge_Temp2           rs.l      1
ge_Temp3           rs.l      1
ge_Next            rs.l      1
ge_MinWidth        rs.l      1
ge_MinHeight       rs.l      1
ge_MaxWidth        rs.l      1
ge_MaxHeight       rs.l      1
ge_Domain          rs.b      gd_Size
ge_Size            rs.b      0

         rsreset
GuiClass rs.b      0
gc_GetMinMax       rs.l      1
gc_Layout          rs.l      1
gc_Render          rs.l      1
gc_Click           rs.l      1
gc_Size            rs.b      0

GENTRY   macro     ; gentry class,data,hook,[ID],[data2],[data3],[data4]
         dc.l      \1,\2

         IFLT      NARG-5
         dc.l      0
         ELSE
         dc.l      \5
         ENDIF

         IFLT      NARG-6
         dc.l      0
         ELSE
         dc.l      \6
         ENDIF

         dc.l      \3

         IFLT      NARG-4
         dc.l      0
         ELSE
         dc.l      \4
         ENDIF

         ds.b      ge_Size-24
         endm

GEND     macro
         ds.b      ge_Size
         endm

*****************
