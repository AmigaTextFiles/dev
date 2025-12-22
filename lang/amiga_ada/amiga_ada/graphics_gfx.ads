with System; use System;
with Interfaces; use Interfaces;

with Incomplete_Type; use Incomplete_Type;

package graphics_Gfx is

--#include <sys/cdefs.h>
--#include <inline/stubs.h>

type Rectangle;
type Rectangle_Ptr is access Rectangle;

type Rectangle is
	record
		MinX : Integer_16;
		MinY : Integer_16;
		MaxX : Integer_16;
		MaxY : Integer_16;
	end record;

type Rect32;
type Rect32_Ptr is access Rect32;
type Rect32 is
	record
		MinX : Integer;
		MinY : Integer;
		MaxX : Integer;
		MaxY : Integer;
	end record;

type tPoint;
type tPoint_Ptr is access tPoint;

type tPoint is
	record
		x : Integer_16;
		y : Integer_16;
	end record;

Point : tPoint;

type PLANEPTR is new System.Address;
type PLANEPTR_Array is array (Natural range <>) of PLANEPTR;

type BitMap;
type BitMap_Ptr is access BitMap;

NullBitMap_Ptr : BitMap_Ptr := Null;

type BitMap is 
	record
		BytesPerRow : Integer_16;
		Rows : Integer_16;
		Flags : Integer_8;
		Depth : Integer_8;
		pad   : Integer_16;
		Planes: PLANEPTR_Array(0 .. 7);
	end record;

end graphics_gfx;
