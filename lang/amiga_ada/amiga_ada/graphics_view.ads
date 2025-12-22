with Interfaces; use Interfaces;
with Incomplete_Type; use Incomplete_Type;
with graphics_Gfx; use graphics_Gfx;
with graphics_GfxNodes; use graphics_GfxNodes;
with utility_TagItem; use utility_TagItem;

package graphics_view is
--#define ECS_SPECIFIC
--
--#ifndef EXEC_TYPES_H
--#include <exec/types.h>
--#endif
--
--#ifndef GRAPHICS_GFX_H
--#include <graphics/gfx.h>
--#endif
--
--#ifndef GRAPHICS_COPPER_H
--#include <graphics/copper.h>
--#endif
--
--#ifndef GRAPHICS_GFXNODES_H
--#include <graphics/gfxnodes.h>
--#endif
--
--#ifndef GRAPHICS_MONITOR_H
--#include <graphics/monitor.h>
--#endif
--
--#ifndef HARDWARE_CUSTOM_H
--#include <hardware/custom.h>
--#endif

type ColorMap;
type ColorMap_Ptr is access ColorMap;
NullColorMap_Ptr : constant ColorMap_Ptr := Null;

type ViewPort;
type ViewPort_Ptr is access ViewPort;
NullViewPort_Ptr : constant ViewPort_Ptr := Null;
type ViewPort is record
   Next : ViewPort_Ptr;
   ColorMap : ColorMap_Ptr; 
   DspIns : CopList_Ptr; 
   SprIns : CopList_Ptr; 
   ClrIns : CopList_Ptr; 
   UCopIns : UCopList_Ptr; 
   DWidth : Integer_16;
   DHeight : Integer_16;
   DxOffset : Integer_16;
   DyOffset : Integer_16;
   Modes : Integer_16;
   SpritePriorities : Integer_8; 
   ExtendedModes : Integer_8;
   RasInfo : RasInfo_Ptr;
end record;

type View;
type View_Ptr is access View;
NullView_Ptr : constant View_Ptr := Null;
type View is record
   ViewPort : ViewPort_Ptr;
   LOFCprList : cprlist_Ptr; 
   SHFCprList : cprlist_Ptr; 
   DyOffset : Integer_16;
   DxOffset : Integer_16; 
   Modes : Integer_16; 
end record;

type ViewExtra;
type ViewExtra_Ptr is access ViewExtra;
NullViewExtra_Ptr : constant ViewExtra_Ptr := Null;
type ViewExtra is record
   n : ExtendedNode;
   View : View_Ptr; 
   Monitor : MonitorSpec_Ptr; 
end record;

type ViewPortExtra;
type ViewPortExtra_Ptr is access ViewPortExtra;
NullViewPortExtra_Ptr : constant ViewPortExtra_Ptr := Null;
type ViewPortExtra is record
   n : ExtendedNode;
   ViewPort : ViewPort_Ptr; 
   DisplayClip : Rectangle; 
end record;

   EXTEND_V : constant Unsigned_16 := 16#1000# ;
   GENLOCK_VIDEO : constant Unsigned_16 := 16#0002#;
   LACE : constant Unsigned_16 := 16#0004#;
   SUPERHIRES : constant Unsigned_16 := 16#0020#;
   PFBA : constant Unsigned_16 := 16#0040#;
   EXTRA_HALFBRITE : constant Unsigned_16 := 16#0080#;
   GENLOCK_AUDIO : constant Unsigned_16 := 16#0100#;
   DUALPF : constant Unsigned_16 := 16#0400#;
   HAM : constant Unsigned_16 := 16#0800#;
   EXTENDED_MODE : constant Unsigned_16 := 16#1000#;
   VP_HIDE : constant Unsigned_16 := 16#2000#;
   SPRITES : constant Unsigned_16 := 16#4000#;
   HIRES : constant Unsigned_16 := 16#8000#;
   VPF_A2024 : constant Unsigned_16 := 16#40#;
   VPF_AGNUS : constant Unsigned_16 := 16#20#;
   VPF_TENHZ : constant Unsigned_16 := 16#20#;
type RasInfo ;
type RasInfo_Ptr is access RasInfo ;
NullRasInfo_Ptr : constant RasInfo_Ptr := Null;
type RasInfo  is record
   Next : RasInfo_Ptr; 
   RasInfo_BitMap : BitMap_Ptr;
   RxOffset : Integer_16;
   RyOffset : Integer_16; 
end record;

type ColorMap is record
   Flags : Integer_8;
   ColorMap_Type : Integer_8;
   Count : Integer_16;
   ColorTable : Integer_Ptr;
   cm_vpe : ViewPortExtra_Ptr;
   TransparencyBits : Integer_16_Ptr;
   TransparencyPlane : Integer_8;
   reserved1 : Integer_8;
   reserved2 : Integer_16;
   cm_vp : ViewPort_Ptr;
   NormalDisplayInfo : Integer_Ptr;
   CoerceDisplayInfo : Integer_Ptr;
   cm_batch_items : TagItem_Ptr;
   VPModeID : Integer;
end record;

   COLORMAP_TYPE_V1_2 : constant Integer := 16#00#;
   COLORMAP_TYPE_V1_4 : constant Integer := 16#01#;
   COLORMAP_TYPE_V36 : constant Integer := COLORMAP_TYPE_V1_4;
   COLORMAP_TRANSPARENCY : constant Integer := 16#01#;
   COLORPLANE_TRANSPARENCY : constant Integer := 16#02#;
   BORDER_BLANKING : constant Integer := 16#04#;
   BORDER_NOTRANSPARENCY : constant Integer := 16#08#;
   VIDEOCONTROL_BATCH : constant Integer := 16#10#;
   USER_COPPER_CLIP : constant Integer := 16#20#;
   
end graphics_view;
