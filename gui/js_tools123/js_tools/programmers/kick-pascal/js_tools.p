unit js_tools;
uses gadtools;

CONST
 JSTOOLSNAME = "js_tools.library";

(*
 *  JS_Info Konstanten:
 *)

 JSINFO_BOX         = 1;
 JSINFO_VERSION     = 2;
 JSINFO_LIBVERSION  = 3;
 JSINFO_LIBREVISION = 4;
 JSINFO_DATE        = 5;


(*
 *  ListView:
 *)

CONST
 LISTVIEW1_KIND    = LISTVIEW_KIND;
 LISTVIEW2_KIND    = 101;
 LISTVIEW3_KIND    = 102;

(*
 *  ListView Tagitems:
 *)

CONST
 lv_Dummy  = (TAG_USER+$56000);

 lv_Labels       = GTLV_Labels;
 lv_Disabled     = GA_Disabled;
 lv_ScrollWidth  = GTLV_ScrollWidth;
 lv_ShowSelected = GTLV_ShowSelected;
 lv_ReadOnly     = GTLV_ReadOnly;
 lv_Spacing      = LAYOUTA_Spacing;
 lv_Top          = GTLV_Top;
 lv_Selected     = GTLV_Selected;
 lv_NewSelected  = (lv_Dummy+1);
 lv_Window       = (lv_Dummy+2);
 lv_SetMark      = (lv_Dummy+3);
 lv_ClearMark    = (lv_Dummy+4);
 lv_BlockStart   = (lv_Dummy+5);
 lv_BlockStop    = (lv_Dummy+6);
 lv_MarkBlock    = (lv_Dummy+7);
 lv_MarkIsIn     = (lv_Dummy+8);
 lv_OnlyRead     = (lv_Dummy+9);
 lv_Colour       = (lv_Dummy+10);
 lv_Color        = lv_Colour;
 lv_NewSelectMode= (lv_Dummy+11);
 lv_NewSelectLines= (lv_Dummy+12);
 lv_SetFont      = (lv_Dummy+13);
 lv_Redraw       = (lv_Dummy+14);
 lv_OffIsIn      = (lv_Dummy+15);
 lv_ElseSelected = (lv_Dummy+16);
 lv_OffColour    = (lv_Dummy+17);
 lv_OffColor     = lv_OffColour;
 lv_NewKind      = (lv_Dummy+18);
 lv_xFrontColour = (lv_Dummy+19);
 lv_xFrontColor  = lv_xFrontColour;
 lv_xBackColour  = (lv_Dummy+20);
 lv_xBackColor   = lv_xBackColour;
 lv_Hook         = (lv_Dummy+22);
 lv_Notick       = (lv_Dummy+23);
 lv_AlwaysMark   = (lv_Dummy+24);
 lv_MarkOn       = (lv_Dummy+25);
 lv_SuperListView= (lv_Dummy+26);
 lv_ScrollHeight = (lv_Dummy+27);
 lv_HorizSelected= (lv_Dummy+28);
 lv_HorizScroll  = (lv_Dummy+29);
 lv_Private1     = (lv_Dummy+30);
 lv_ColumnData   = (lv_Dummy+31);
 lv_FormatText   = (lv_Dummy+32);
 lv_AfterHook    = (lv_Dummy+33);


(*
 *  ein paar Ergebnis-Tags (Ask Tags)
 *
 *  die Ergebnisse stehen jeweils im ti_Data Feld,
 *  einige benötigen dort bereits vor dem Aufruf einen Bezugswert
 *  (Tags können grundsätzlich nur bei [S]et benutzt werden!)
 *
 *)

CONST
 lv_AskTop      = (lv_Dummy+50);
 lv_AskLines    = (lv_Dummy+51);
 lv_AskNumber   = (lv_Dummy+52);
 lv_AskNode     = (lv_Dummy+53);
 lv_IsShown     = (lv_Dummy+54);
 lv_IsMarked    = (lv_Dummy+55);
 lv_IsMarkedNr  = (lv_Dummy+56);
 lv_MarkedCount = (lv_Dummy+57);
 lv_AskHoriz    = (lv_Dummy+58);
 lv_AskMaxHoriz = (lv_Dummy+59);

(*
 *  Werte für lv_NewSelectMode
 *
 *  Wird ein Element über NewSelected bestimmt, wird automatisch lv_Top
 *  so gesetzt, daß das Element sichtbar ist. Wie, bestimmt NewSelectMode.
 *)

CONST
 NSM_ExtraLine = 0;
 NSM_Center    = 1;
 NSM_NoLine    = 2;
 NSM_FreeLine  = 3;
 NSM_max       = 3;


(*
 *  Datenfeld, daß Hooks übergeben wird
 *
 *  add_x Feld steht auf 0 und kann (darf) als einziges geändert werden
 *  im RastPort darf "alles" verändert werden, wenn es wieder auf die
 *  alten Werte gesetzt wird (außer APen, BPen und DrMd, diese werden
 *  von der ListView Textausgabe wieder richtig gesetzt)
 *  Breite und Höhe des ListView Eintrags müssen vom Hook selbst beachtet
 *  werden - jedes Überzeichnen wird sichtbar!
 *
 *)

TYPE lvData=record
 lvd_Current    : p_Node;
 lvd_RPort      : p_RastPort;
 lvd_x          : word;
 lvd_y          : word;
 lvd_width      : integer;
 lvd_height     : integer;
 lvd_selected   : boolean;
 lvd_marked     : boolean;
 lvd_free       : word;
(* Werte ab hier dürfen geändert werden! *)
 lvd_FrontPen   : integer;
 lvd_BackPen    : integer;
 lvd_Style      : integer;
 lvd_add_x      : integer;
 lvd_flags      : long;
end;
p_lvData=^lvData;

lvExtraWindow=record
  lvx_win       : p_Window;
  lvx_vi        : Ptr;
  lvx_TextAttr  : p_TextAttr;
  lvx_LeftEdge  : integer;
  lvx_TopEdge   : integer;
  lvx_Width     : integer;
  lvx_Height    : integer;
  lvx_MaxWidth  : integer;
  lvx_MaxHeight : integer;
  lvx_GadgetID  : word;
  lvx_UserData  : Ptr;
  lvx_Title     : str;
  lvx_Flags     : long;
end;
p_lvExtraWindow=^lvExtraWindow;

(*
 *  lvExtraWindow Flags:
 *
 *)
const
 LVXF_DEPTHGADGET  =  1;  (* Depth Gadget *)
 LVXF_SIZEGADGET   =  2;  (* Size Gadget *)
 LVXF_CLOSEGADGET  =  4;  (* Close Gadget *)
 LVXF_DRAGGADGET   =  8;  (* Dragbar *)
 LVXF_RAWKEY       = 16;  (* RAWKEY IDCMP *)
 LVXF_VANILLAKEY   = 32;  (* VANILLAKEY IDCMP *)

(*
 * ColumnData - Mehrere Spalten im ListView, ln_Name wird ignoriert
 * ARRAY wird über lv_ColumnData übergeben
 *)

TYPE
 ColumnData=RECORD
  cd_Offset     : Ptr;
  cd_LeftEdge   : Word;
  cd_Width      : Word;
  cd_Flags      : Long;
 end;
 p_ColumnData=^ColumnData;

(*
 * ColumnData Flags:
 *)

CONST
 cdf_AdjustRight	= 1;
 cdf_AdjustMid		= 2;

(*
 *  Multiselect Rückgaben
 *  (nur bei MARKVIEW_KIND)
 *
 *)

CONST
 MARK_QUALIFIER_SET   = 1;
 MARK_QUALIFIER_CLEAR = 2;

var JS_ToolsBase:Ptr;

library JS_ToolsBase:

-36: function  JS_LibInfo(d1:long):str;
-54: function  LV_CreateListViewA(d0:LONG;a0:p_Gadget;a1:p_NewGadget;a2:p_TagItem):p_Gadget;
-60: procedure LV_FreeListView(a0:p_Gadget);
-66: procedure LV_FreeListViews(a0:p_Gadget);
-72: procedure LV_SetListViewAttrsA(a0:p_Gadget;a1:p_Window;a2:p_Requester;a3:p_TagItem);
-78: procedure LV_RefreshWindow(a0:p_Window;a1:p_Requester);
-84: function  LV_GetIMsg(a0:p_MsgPort):p_IntuiMessage;
-90: procedure LV_ReplyIMsg(a1:p_IntuiMessage);
-96: function  LV_AskListViewAttrs(a0:p_Gadget;a1:p_Window;d0:long;d1:long):long;
-102: function LV_GetListViewAttrsA(a0:p_Gadget;a1:p_Window;a2:p_Requester;a3:p_TagItem):long;
-108: function LV_CreateExtraListViewA(a0:p_lvExtraWindow;a1:p_TagItem):p_Gadget;
-114: procedure JS_Sort(a0:p_List;d0:long);
-126: function LV_HandleKey(a0:p_Gadget;a1:p_IntuiMessage;d0:char;a2:p_TagItem):char;
end;

function lvHook(lvF:long;hk:p_Hook):ptr;
(*
 example:

 procedure myHook(h:p_Hook;lvd:p_lvData;m:ptr)
 begin
  (* Hook - m currently not used *)
 end;

 (* any procedure *)
 var hk:Hook;
   (* more *)
 begin

  (* something *)

  ti[0]:=TagItem(lv_Hook,lvHook(addr(myHook),hk));

  (* and so on *)

 end; 
*)  

procedure lvHookCode;import;

{$ulink "lvHookCode.o"}
IMPLEMENTATION

function lvHook;
begin
  hk^.h_Entry   :=ptr(addr(lvHookCode));
  hk^.h_SubEntry:=ptr(lvF);
  hk^.h_Data    :=nil;
  lvHook:=hk;
end;

begin
 OpenLib(JS_ToolsBase,"js_tools.library",37);

end.
