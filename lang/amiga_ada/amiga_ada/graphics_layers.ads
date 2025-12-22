with Interfaces; use Interfaces;

with exec_Lists; use exec_Lists;
with exec_Semaphores; use exec_Semaphores;

with Incomplete_Type; use Incomplete_Type;

--#ifndef EXEC_LISTS_H
--#include <exec/lists.h>
--#endif
--
--#ifndef EXEC_SEMAPHORES_H
--#include <exec/semaphores.h>
--#endif

package graphics_Layers is

LAYERSIMPLE : constant Unsigned_32 := 1;
LAYERSMART : constant Unsigned_32 := 2;
LAYERSUPER : constant Unsigned_32 := 4;
LAYERUPDATING : constant Unsigned_32 := 16#10#;
LAYERBACKDROP : constant Unsigned_32 := 16#40#;
LAYERREFRESH : constant Unsigned_32 := 16#80#;
LAYER_CLIPRECTS_LOST : constant Unsigned_32 := 16#100#;
LMN_REGION : constant Unsigned_32 := 16#ffffffff#;

type Layer_Info;
type Layer_Info_Ptr is access Layer_Info;
NullLayer_Info_Ptr : constant Layer_Info_Ptr := Null;
type Layer_Info is record
top_layer : Layer_Ptr;
check_lp : Layer_Ptr;
obs : ClipRect_Ptr;
FreeClipRects : MinList;
Lock : SignalSemaphore;
gs_Head : List;
Integerreserved : Integer;
Flags : Unsigned_16;
fatten_count : Integer_8;
LockLayersCount : Integer_8;
LayerInfo_extra_size : Unsigned_16;
blitbuff : Integer_16_Ptr;
LayerInfo_extra : Integer_Ptr;
end record;

NEWLAYERINFO_CALLED : constant Unsigned_32 := 1;
ALERTLAYERSNOMEM : constant Unsigned_32 := 16#83010000#;

end graphics_layers;
