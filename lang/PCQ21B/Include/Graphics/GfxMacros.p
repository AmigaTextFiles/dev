
{
    Graphics/GfxMacros.i
}

{$I "Include:Graphics/graphics.i"}
{$I "Include:Graphics/rastport.i"}
{$I "Include:Graphics/Gels.i"}
{$I "Include:Graphics/Pens.i"}


PROCEDURE BNDRYOFF (w: RastPortPtr);
EXTERNAL;

PROCEDURE InitAnimate (animkey: AnimObPtrPtr);
EXTERNAL;

PROCEDURE SetAfPt(w: RastPortPtr;p: Address;n: Byte);
EXTERNAL;

PROCEDURE SetDrPt(w: RastPortPtr;p: Word);
EXTERNAL;

PROCEDURE SetOPen(w: RastPortPtr;c: Byte);
EXTERNAL;

PROCEDURE SetWrMsk(w: RastPortPtr; m: Byte);
EXTERNAL;

PROCEDURE SafeSetOutlinePen(w : RastPortPtr; c : byte);
EXTERNAL;

PROCEDURE SafeSetWriteMask( w : RastPortPtr ; m : Integer ) ;
EXTERNAL;

PROCEDURE OFF_DISPLAY (cust: CustomPtr);
EXTERNAL;

PROCEDURE ON_DISPLAY (cust: CustomPtr);
EXTERNAL;

PROCEDURE OFF_SPRITE (cust: CustomPtr);
EXTERNAL;

PROCEDURE ON_SPRITE (cust: CustomPtr);
EXTERNAL;

PROCEDURE OFF_VBLANK (cust: CustomPtr);
EXTERNAL;

PROCEDURE ON_VBLANK (cust: CustomPtr);
EXTERNAL;







