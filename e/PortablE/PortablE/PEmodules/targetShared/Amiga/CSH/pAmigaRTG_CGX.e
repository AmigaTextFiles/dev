/* pAmigaRTG.e 11-07-2013
	A collection of RTG wrappers for CGX.
	Copyright (c) 2012, 2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
	
	NOTE: These procedures should NOT be used with 8-bit or lower depth bitmaps, unless otherwise specified.
*/
OPT INLINE, PREPROCESS
PUBLIC MODULE 'targetShared/Amiga/CSH/pAmigaRTG_base'
MODULE 'target/cybergraphics', 'target/graphics', 'target/utility/tagitem', 'exec', 'target/dos/dos'

/*
#private
PRIVATE
CONST BMF_HIJACKED = $80

->CGX stuff
#ifndef pe_TargetOS_AROS
	CONST BMF_SPECIALFMT = BMF_HIJACKED
#endif
CONST PIXFMT_RGB24  =  9
CONST PIXFMT_BGR24  = 10	->not recommended
CONST PIXFMT_ARGB32 = 11
CONST PIXFMT_BGRA32 = 12	->not recommended
CONST PIXFMT_RGBA32 = 13	->not recommended
PUBLIC
#define SHIFT_PIXFMT(fmt) ((fmt) SHL 24)
*/

CONST RGB_MASK = $FFFFFF, ALPHA_MASK = $FF000000

PROC new()
	cybergfxbase := OpenLibrary('cybergraphics.library', 0)
	IF cybergfxbase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(cybergfxbase)
ENDPROC


PROC rtgSupported() RETURNS supported:BOOL /*REPLACEMENT*/ IS TRUE

PROC rtgAllocBitMap(width, height, depth, flags, friend=NIL:PTR TO bitmap) RETURNS bitmap:PTR TO bitmap /*REPLACEMENT*/ IS AllocBitMap(width, height, depth, (BMF_CLEAR OR BMF_DISPLAYABLE AND flags) OR BMF_MINPLANES OR (IF depth = 32 THEN BMF_SPECIALFMT OR SHIFT_PIXFMT(PIXFMT_ARGB32) ELSE IF friend THEN GetBitMapAttr(friend, BMA_FLAGS) AND NOT BMF_DISPLAYABLE ELSE IF depth > 8 THEN  BMF_SPECIALFMT OR SHIFT_PIXFMT(PIXFMT_RGB24) ELSE flags), friend)
/*
PROC rtgAllocBitMap(width, height, depth, flags, friend=NIL:PTR TO bitmap) RETURNS bitmap:PTR TO bitmap REPLACEMENT
	DEF newFlags
	
	IF depth = 32
		newFlags := BMF_SPECIALFMT OR SHIFT_PIXFMT(PIXFMT_ARGB32)
		
	ELSE IF friend
		newFlags := GetBitMapAttr(friend, BMA_FLAGS) AND NOT BMF_DISPLAYABLE
		
	ELSE IF depth > 8
		newFlags := BMF_SPECIALFMT OR SHIFT_PIXFMT(PIXFMT_RGB24)
	ELSE
		newFlags := flags
	ENDIF
	bitmap := AllocBitMap(width, height, depth, (BMF_CLEAR OR BMF_DISPLAYABLE AND flags) OR BMF_MINPLANES OR newFlags, friend)
ENDPROC
*/
/* Notes:
BMF_SPECIALFMT OR SHIFT_PIXFMT(PIXFMT_RGB24) are CGFX constants which boil down to BMF_HIJACKED OR (9 SHL 24).
BMF_MINPLANES ensure that a chunky bitmap is allocated on CGX (except for 1-bit depth that could be a mask).  This may be incorrect, and it is just to ensure compatibility with OS3.x datatypes.
BMF_DISPLAYABLE ensures that the bitmap is allocated in video memory.
*/

PROC rtgCloneBitMap(orig:PTR TO bitmap, friend=NIL:PTR TO bitmap, extraFlags=0, x=0, y=0, width=-1, height=-1, origRastport=NIL:PTR TO rastport) RETURNS clone:PTR TO bitmap REPLACEMENT
	DEF depth, flags, cloneDepth
	DEF useClipBlit:BOOL, cloneRastport:rastport
	
	IF width  = -1 THEN width  := GetBitMapAttr(orig, BMA_WIDTH)
	IF height = -1 THEN height := GetBitMapAttr(orig, BMA_HEIGHT)
	depth  := GetBitMapAttr(orig, BMA_DEPTH)
	flags  := GetBitMapAttr(orig, BMA_FLAGS)
	
	cloneDepth := IF depth = 32 THEN 32 ELSE IF friend THEN GetBitMapAttr(friend, BMA_DEPTH) ELSE IF depth > 8 THEN 24 ELSE depth		->this must match rtgAllocBitMap()'s flag choices
	clone := rtgAllocBitMap(width, height, cloneDepth, flags OR extraFlags, friend)
	IF clone = NIL THEN RETURN
	
	useClipBlit := IF origRastport THEN origRastport.layer <> NIL ELSE FALSE
	IF useClipBlit = FALSE
		BltBitMap(       orig,x,y, clone,0,0, width,height, $c0, $ff, NILA)
	ELSE
		InitRastPort(cloneRastport)
		cloneRastport.bitmap := clone
		ClipBlit(origRastport,x,y, cloneRastport,0,0, width,height, $c0)
	ENDIF
ENDPROC

PROC rtgGetBitMapDepth(bitmap:PTR TO bitmap) RETURNS depth /*REPLACEMENT*/ IS GetBitMapAttr(bitmap, BMA_DEPTH)

->this does not work on MorphOS & maybe not AROS
PROC rtgBitMapInVideoMem(bitmap:PTR TO bitmap) RETURNS inVideoMem:BOOL /*REPLACEMENT*/ IS GetBitMapAttr(bitmap, BMA_FLAGS) AND BMF_DISPLAYABLE <> 0
->bitmap BUT TRUE

PROC rtgMaxWidthBitMapInVideoMem() RETURNS size /*REPLACEMENT*/ IS 2048-1	->work-around rtgBitMapInVideoMem() not working on CGX (at least for MorphOS)

PROC rtgMaxHeightBitMapInVideoMem() RETURNS size /*REPLACEMENT*/ IS 2048-1

PROC rtgReadPixel( rp:PTR TO rastport, x, y) RETURNS colour /*REPLACEMENT*/ IS ReadRGBPixel(rp, x!!UINT, y!!UINT)

PROC rtgWritePixel(rp:PTR TO rastport, x, y, color) /*REPLACEMENT*/ IS WriteRGBPixel(rp, x!!UINT, y!!UINT, color) BUT EMPTY

PROC rtgReadPixelArray(srcRastport:PTR TO rastport, minX, minY, maxX, maxY, destArray:ARRAY OF LONG) REPLACEMENT
	DEF width, height
	
	width  := maxX - minX + 1
	height := maxY - minY + 1
	
	->Icaros v1.4.0 does not account for endianess, so must ask for RECTFMT_BGRA for LONG reads/writes to see it as RECTFMT_RGBA
	ReadPixelArray(destArray, 0, 0, width*SIZEOF LONG !!UINT, srcRastport, minX!!UINT, minY!!UINT, width!!UINT, height!!UINT, #ifndef pe_TargetOS_AROS RECTFMT_ARGB #else RECTFMT_BGRA32 #endif)
ENDPROC

PROC rtgWritePixelArray(destRastport:PTR TO rastport, minX, minY, maxX, maxY, srcArray:ARRAY OF LONG) REPLACEMENT
	DEF width, height
	
	width  := maxX - minX + 1
	height := maxY - minY + 1
	
	->Icaros v1.4.0 does not account for endianess, so must ask for RECTFMT_BGRA for LONG reads/writes to see it as RECTFMT_RGBA
	WritePixelArray(srcArray, 0, 0, width*SIZEOF LONG !!UINT, destRastport, minX!!UINT, minY!!UINT, width!!UINT, height!!UINT, #ifndef pe_TargetOS_AROS RECTFMT_ARGB #else RECTFMT_BGRA32 #endif)
ENDPROC

PROC rtgScale(srcBitMap:PTR TO bitmap, srcX, srcY, srcWidth, srcHeight, dstBitMap:PTR TO bitmap, dstX, dstY, dstWidth, dstHeight, screenDepth, smooth=FALSE:BOOL) REPLACEMENT
	bitMapScaleClassic(srcBitMap, srcX, srcY, srcWidth, srcHeight, dstBitMap, dstX, dstY, dstWidth, dstHeight, screenDepth)
	smooth:=FALSE	->dummy
ENDPROC

PROC rtgAlphaSupported(screenDepth) RETURNS alphaSupported:BOOL /*REPLACEMENT*/ IS #ifdef pe_TargetOS_MorphOS IF cybergfxbase.version >= 50 THEN screenDepth = 32 ELSE FALSE #else screenDepth BUT FALSE #endif

PROC rtgBltBitMapAlpha(srcBitMap:PTR TO bitmap, srcX, srcY, destBitMap:PTR TO bitmap, destX, destY, sizeX, sizeY) REPLACEMENT
	#ifdef pe_TargetOS_MorphOS
		->IF rtgAlphaSupported() = FALSE THEN ...
		BltBitMapAlpha(srcBitMap, srcX!!INT, srcY!!INT, destBitMap, destX!!INT, destY!!INT, sizeX!!INT, sizeY!!INT, [BLTBMA_USESOURCEALPHA,TRUE, BLTBMA_DESTALPHAVALUE,DESTALPHAVALUE_UNDEFINED, TAG_END]:tagitem)
	#else
		Throw("EPU", 'pAmigaRTG; rtgBltBitMapAlpha(); this should not have been called as rtgAlphaSupported() returns FALSE')
		srcBitMap:=destBitMap:=NIL ; srcX:=srcY:=destX:=destY:=sizeX:=sizeY	->dummy
	#endif
ENDPROC
