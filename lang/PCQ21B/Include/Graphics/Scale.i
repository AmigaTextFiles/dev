{ Scale.i }

{$I "Include:Exec/Types.i"}
{$I "Include:Graphics/GFX.i"}

Type
   BitScaleArgs = Record
    bsa_SrcX, bsa_SrcY,                 { source origin }
    bsa_SrcWidth, bsa_SrcHeight,        { source size }
    bsa_XSrcFactor, bsa_YSrcFactor,     { scale factor denominators }
    bsa_DestX, bsa_DestY,               { destination origin }
    bsa_DestWidth, bsa_DestHeight,      { destination size result }
    bsa_XDestFactor, bsa_YDestFactor : Short;   { scale factor numerators }
    bsa_SrcBitMap,                           { source BitMap }
    bsa_DestBitMap : BitMapPtr;              { destination BitMap }
    bsa_Flags   : Integer;              { reserved.  Must be zero! }
    bsa_XDDA, bsa_YDDA : Short;         { reserved }
    bsa_Reserved1,
    bsa_Reserved2 : Integer;
   END;
   BitScaleArgsPtr = ^BitScaleArgs;

PROCEDURE BitMapScale(bsa : bitScaleArgsPtr);
 External;

FUNCTION ScalerDiv(factor,numerator,denominator : Short) : Short;
 External;

