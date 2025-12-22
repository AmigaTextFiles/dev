with Interfaces; use Interfaces;

with Incomplete_Type; use Incomplete_Type;

with graphics_Gfx; use graphics_Gfx;

package graphics_rastport is
--#ifndef EXEC_TYPES_H
--#include <exec/types.h>
--#endif
--
--#ifndef GRAPHICS_GFX_H
--#include <graphics/gfx.h>
--#endif
type AreaInfo;
type AreaInfo_Ptr is access AreaInfo;
NullAreaInfo_Ptr : constant AreaInfo_Ptr := Null;
type AreaInfo is record
   VctrTbl : Integer_16_Ptr;
   Vctr_Ptr : Integer_16_Ptr;
   FlagTbl : Integer_8_Ptr;
   Flag_Ptr : Integer_8_Ptr;
   Count : Integer_16;
   MaxCount : Integer_16;
   FirstX : Integer_16;
   FirstY : Integer_16;
end record;
   
   
type TmpRas;
type TmpRas_Ptr is access TmpRas;
NullTmpRas_Ptr : constant TmpRas_Ptr := Null;
type TmpRas is record
   Ras_Ptr : Integer_8_Ptr;
   Size : Integer;
end record;
   
   
type GelsInfo;
type GelsInfo_Ptr is access GelsInfo;
NullGelsInfo_Ptr : constant GelsInfo_Ptr := Null;
type GelsInfo is record
   sprRsrvd : Integer_8;
   Flags : Unsigned_8;
   gelHead : VSprite_Ptr;
   gelTail : VSprite_Ptr;
   nextLine : Integer_16_Ptr;
   lastColor : Integer_16_Ptr_Ptr;
   collHandler : collTable_Ptr;
   leftmost : Integer_16;
   rightmost  : Integer_16;
   topmost  : Integer_16;
   bottommost  : Integer_16;
   firstBlissObj : Integer_Ptr;
   lastBlissObj : Integer_Ptr;
end record;
   
   
type RastPort;
type RastPort_Ptr is access RastPort;
NullRastPort_Ptr : constant RastPort_Ptr := Null;
type RastPort is record
   Layer : Layer_Ptr;
   BitMap : BitMap_Ptr;
   Area_Ptrn : Unsigned_16_Ptr;
   TmpRas : TmpRas_Ptr;
   AreaInfo : AreaInfo_Ptr;
   GelsInfo : GelsInfo_Ptr;
   Mask : Unsigned_8;
   FgPen : Integer_8;
   BgPen : Integer_8;
   AOlPen : Integer_8;
   DrawMode : Integer_8;
   AreaPtSz : Integer_8;
   linpatcnt : Integer_8;
   dummy : Integer_8;
   Flags : Unsigned_16;
   Line_Ptrn : Unsigned_16;
   cp_x : Integer_16;
   cp_y : Integer_16;
   minterms : Unsigned_8_Array(0..7);
   PenWidth : Integer_16;
   PenHeight : Integer_16;
   Font : TextFont_Ptr;
   AlgoStyle : Unsigned_8;
   TxFlags : Unsigned_8;
   TxHeight : Unsigned_16;
   TxWidth : Unsigned_16;
   TxBaseline : Unsigned_16;
   TxSpacing : Integer_16;
   RP_User : Integer_Ptr;
   Longreserved : Unsigned_32_Array(0..1);
   Wordreserved : Unsigned_16_Array(0..6);
   reserved : Unsigned_8_Array(0..7);
end record;
   
   
JAM1 : constant Integer :=0;
JAM2 : constant Integer :=1;
COMPLEMENT : constant Integer :=2;
INVERSVID : constant Integer :=4;
FRST_DOT : constant Integer :=16#01#;
ONE_DOT : constant Integer :=16#02#;
DBUFFER : constant Integer :=16#04#;
AREAOUTLINE : constant Integer :=16#08#;
NOCROSSFILL : constant Integer :=16#20#;
   
end graphics_rastport;
