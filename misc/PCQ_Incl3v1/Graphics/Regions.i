
{$I "Include:Graphics/GFX.i"}

Type
 RegionRectangle = Record
    Next, Prev  : ^RegionRectangle;
    bounds      : Rectangle;
 end;
 RegionRectanglePtr = ^RegionRectangle;

 Region = Record
    bounds      : Rectangle;
    r_RegionRectangle  : RegionRectanglePtr;
 end;
 RegionPtr = ^Region;


