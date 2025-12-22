
{$I "Include:Graphics/GFX.i"}

TYPE
 RegionRectangle = RECORD
    Next, Prev  : ^RegionRectangle;
    bounds      : Rectangle;
 END;
 RegionRectanglePtr = ^RegionRectangle;

 Region = RECORD
    bounds      : Rectangle;
    r_RegionRectangle  : RegionRectanglePtr;
 END;
 RegionPtr = ^Region;

FUNCTION NewRegion() : RegionPtr;
    EXTERNAL;

FUNCTION OrRectRegion(region : RegionPtr; rect : RectanglePtr) : Boolean;
    EXTERNAL;

FUNCTION OrRegionRegion(region1 : RegionPtr; region2 : RegionPtr) : Boolean;
    EXTERNAL;

PROCEDURE AndRectRegion(region : RegionPtr; rect : RectanglePtr);
    EXTERNAL;

FUNCTION AndRegionRegion(region1 : RegionPtr; region2 : RegionPtr) : Boolean;
    EXTERNAL;

FUNCTION ClearRectRegion(region : RegionPtr; rect : RectanglePtr) : Boolean;
    EXTERNAL;

PROCEDURE ClearRegion(region : RegionPtr);
    EXTERNAL;

PROCEDURE DisposeRegion(region : RegionPtr);
    EXTERNAL;

Function XorRectRegion(region : RegionPtr; rect : RectanglePtr) : Boolean;
    EXTERNAL;

FUNCTION XorRegionRegion(region1 : RegionPtr; region2 : RegionPtr) : Boolean;
    EXTERNAL;


