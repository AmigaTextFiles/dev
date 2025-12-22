ShowModule v1.10 (c) 1992 $#%!
now showing: "picasso96.m"
NOTE: don't use this output in your code, use the module instead.

(----) OBJECT p96TrueColorInfo
(   0)   pixeldistance:LONG
(   4)   bytesperrow:LONG
(   8)   reddata:LONG
(  12)   greendata:LONG
(  16)   bluedata:LONG
(----) ENDOBJECT     /* SIZEOF=20 */

(----) OBJECT p96RenderInfo
(   0)   memory:LONG
(   4)   bytesperrow:INT
(   6)   pad:INT
(   8)   rgbformat:LONG
(----) ENDOBJECT     /* SIZEOF=12 */

(----) OBJECT p96mode
(   0)   ln:ln (or ARRAY OF ln)
(  14)   description[48]:ARRAY OF CHAR
(  62)   width:INT
(  64)   height:INT
(  66)   depth:INT
(  68)   displayid:LONG
(----) ENDOBJECT     /* SIZEOF=72 */

CONST P96SA_Type=$800200A3,
      P96SA_SaveFunc=$800200B7,
      P96SA_RenderFunc=$800200B6,
      MODENAMELENGTH=$30,
      P96IDA_BITSPERPIXEL=4,
      P96IDA_BYTESPERPIXEL=3,
      P96BMA_BITSPERPIXEL=6,
      P96BMA_BYTESPERPIXEL=5,
      P96SA_DisplayID=$800200A8,
      P96MA_DisplayID=$8001009D,
      P96SA_NoSprite=$800200B4,
      P96MA_FormatsAllowed=$8001009E,
      P96BIDTAG_FormatsAllowed=$80000097,
      RGBFF_A8R8G8B8=$40,
      RGBFF_R8G8B8=4,
      RGBFB_A8R8G8B8=6,
      RGBFB_R8G8B8=2,
      P96PIP_SourceHeight=$8003009B,
      P96SA_Height=$8002009A,
      P96MA_MaxHeight=$8001009B,
      P96MA_MinHeight=$80010098,
      P96BIDTAG_NominalHeight=$8000009A,
      P96SA_DClip=$800200A9,
      P96MA_FormatsForbidden=$8001009F,
      P96BIDTAG_FormatsForbidden=$80000098,
      P96IDA_RGBFORMAT=5,
      P96BMA_RGBFORMAT=7,
      P96SA_Left=$80020097,
      P96SA_BlockPen=$8002009D,
      P96SA_SharePens=$800200AF,
      P96SA_Pens=$800200AE,
      P96SA_Depth=$8002009B,
      P96SA_Top=$80020098,
      P96MA_MaxDepth=$8001009C,
      P96MA_MinDepth=$80010099,
      P96BIDTAG_Depth=$8000009B,
      P96SA_NoMemory=$800200B5,
      RGBFF_Y4U1V1=$8000,
      RGBFB_Y4U1V1=15,
      P96MA_Window=$800100A3,
      P96SA_Behind=$800200AB,
      P96SA_ShowTitle=$800200AA,
      P96SA_Title=$8002009E,
      P96MA_WindowTitle=$800100A0,
      RGBFF_A8B8G8R8=$80,
      RGBFF_B8G8R8=8,
      RGBFB_A8B8G8R8=7,
      RGBFB_B8G8R8=3,
      P96PIP_SourceWidth=$8003009A,
      P96SA_Width=$80020099,
      P96MA_MaxWidth=$8001009A,
      P96MA_MinWidth=$80010097,
      P96BIDTAG_NominalWidth=$80000099,
      P96SA_BackFill=$800200B0,
      P96SA_PubName=$800200A5,
      P96MA_PubScreenName=$800100A4,
      P96SA_SysFont=$800200A2,
      P96SA_Font=$800200A1,
      RGBFF_R5G5B5=$800,
      RGBFB_R5G5B5=11,
      P96PIP_SourceRPort=$80030099,
      P96SA_Colors32=$800200B1,
      P96IDA_BOARDNUMBER=7,
      RGBFF_Y4U2V2=$4000,
      RGBFB_Y4U2V2=14,
      P96IDA_STDBYTESPERROW=8,
      P96BMA_BYTESPERROW=4,
      RGBFF_B5G5R5PC=$2000,
      RGBFF_B5G6R5PC=$1000,
      RGBFF_R5G5B5PC=$20,
      RGBFF_R5G6B5PC=16,
      RGBFB_B5G5R5PC=13,
      RGBFB_B5G6R5PC=12,
      RGBFB_R5G5B5PC=5,
      RGBFB_R5G6B5PC=4,
      P96PIP_Dummy=$80030096,
      P96SA_Dummy=$80020096,
      P96MA_Dummy=$80010096,
      P96BIDTAG_Dummy=$80000096,
      P96PIP_SourceBitMap=$80030098,
      P96SA_FixedScreen=$800200BA,
      P96SA_BitMap=$800200A4,
      P96MA_Screen=$800100A5,
      P96SA_ErrorCode=$800200A0,
      P96PIP_SourceFormat=$80030097,
      P96SA_RGBFormat=$800200B3,
      P96SA_PubTask=$800200A7,
      P96SA_AutoScroll=$800200AD,
      P96SA_UserData=$800200B8,
      P96SA_DetailPen=$8002009C,
      RGBFF_NONE=1,
      RGBFB_NONE=0,
      P96SA_Exclusive=$800200BB,
      RGBFF_R5G6B5=$400,
      RGBFB_R5G6B5=10,
      P96SA_Quiet=$800200AC,
      P96SA_VideoControl=$800200B2,
      P96IDA_HEIGHT=1,
      P96BMA_HEIGHT=1,
      RGBFB_MaxFormats=16,
      P96SA_Colors=$8002009F,
      P96IDA_DEPTH=2,
      P96BMA_DEPTH=2,
      P96MA_CancelText=$800100A2,
      P96MA_OKText=$800100A1,
      P96BMA_MEMORY=3,
      P96IDA_ISP96=6,
      P96BMA_ISP96=8,
      RGBFF_CLUT=2,
      RGBFB_CLUT=1,
      P96IDA_WIDTH=0,
      P96BMA_WIDTH=0,
      RGBFF_B8G8R8A8=$200,
      RGBFF_R8G8B8A8=$100,
      RGBFB_B8G8R8A8=9,
      RGBFB_R8G8B8A8=8,
      P96SA_PubSig=$800200A6,
      P96SA_Alignment=$800200B9

#define P96NAME/0

