include "inc/exec/types.inc";

struct BitScaleArgs is
  bsa_SrcX,bsa_SrcY:uword;
  bsa_SrcWidth,bsa_SrcHeight:uword;
  bsa_XSrcFactor,bsa_YSrcFactor:uword;
  bsa_DestX,bsa_DestY:uword;
  bsa_DestWidth,bsa_DestHeight:uword;
  bsa_XDestFactor,bsa_YDestFactor:uword;
  bsa_SrcBitMap:ulong;
  bsa_DestBitMap:ulong;
  bsa_Flags:ulong;
  bsa_XDDA,bsa_YDDA:uword;
  bsa_Reserved1:long;
  bsa_Reserved2:long;
;

