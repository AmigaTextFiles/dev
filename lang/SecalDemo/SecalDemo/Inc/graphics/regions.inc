include "inc/exec/types.inc";
include "inc/graphics/gfx.inc";

struct RegionRectangle is
  Next:ulong;
  Prev:ulong;
  bounds:Rectangle;
;

struct Region is
  bounds:Rectangle;
  RegionRectangle:ulong;
;

