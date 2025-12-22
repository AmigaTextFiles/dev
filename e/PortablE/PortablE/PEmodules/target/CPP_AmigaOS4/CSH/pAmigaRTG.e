/* pAmigaRTG.e 04-05-2013
	A collection of RTG wrappers for P96.
	Copyright (c) 2012, 2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
	
	NOTE: These procedures should NOT be used with 8-bit or lower depth bitmaps, unless otherwise specified.
*/
OPT INLINE, PREPROCESS
OPT POINTER
PUBLIC MODULE 'targetShared/Amiga/CSH/pAmigaRTG_base'
MODULE 'target/Picasso96API', 'graphics', 'utility/tagitem', 'exec', 'dos/dos'

CONST RGB_MASK = $FFFFFF, ALPHA_MASK = $FF000000

PROC new()
	p96base := OpenLibrary('Picasso96API.library', 0)
	IF p96base=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(p96base)
ENDPROC


/*
PROC rtgAvailVideoMem() RETURNS freeBytes
	p96GetBoardDataTagList(0, [P96BD_FreeMemory,ADDRESSOF freeBytes, TAG_DONE]:tagitem)
ENDPROC
*/

PROC rtgSupported() RETURNS supported:BOOL /*REPLACEMENT*/ IS TRUE

PROC rtgAllocBitMap(width, height, depth, flags, friend=NIL:PTR TO bitmap) RETURNS bitmap:PTR TO bitmap /*REPLACEMENT*/
	->don't inline as this as it causes GCC to say "warning: NULL used in arithmetic"
	bitmap := p96AllocBitMap(width, height, depth, flags OR IF (friend = NIL) AND (flags AND BMF_DISPLAYABLE = 0) THEN BMF_USERPRIVATE ELSE 0, friend, IF depth = 32 THEN RGBFB_A8R8G8B8 ELSE IF friend THEN p96GetBitMapAttr(friend, P96BMA_RGBFORMAT) ELSE IF depth > 8 THEN RGBFB_R8G8B8 ELSE RGBFB_CLUT)
ENDPROC

PROC rtgCloneBitMap(orig:PTR TO bitmap, friend=NIL:PTR TO bitmap, extraFlags=0, x=0, y=0, width=-1, height=-1, origRastport=NIL:PTR TO rastport) RETURNS clone:PTR TO bitmap REPLACEMENT
	DEF depth, flags, cloneDepth
	DEF useClipBlit:BOOL, cloneRastport:rastport
	
	IF width  = -1 THEN width  := GetBitMapAttr(orig, BMA_WIDTH)
	IF height = -1 THEN height := GetBitMapAttr(orig, BMA_HEIGHT)
	depth  := rtgGetBitMapDepth(orig)
	flags  := GetBitMapAttr(orig, BMA_FLAGS)
	
	cloneDepth := IF depth = 32 THEN 32 ELSE IF friend THEN rtgGetBitMapDepth(friend) ELSE IF depth > 8 THEN 24 ELSE depth		->this must match rtgAllocBitMap()'s format choices
 	clone := rtgAllocBitMap(width, height, cloneDepth, flags OR extraFlags, friend)
	IF clone = NIL THEN RETURN
	
	useClipBlit := IF origRastport THEN origRastport.layer <> NIL ELSE FALSE
	IF useClipBlit
		InitRastPort(cloneRastport)
		cloneRastport.bitmap := clone
		ClipBlit(origRastport,x,y, cloneRastport,0,0, width,height, $c0)
	ELSE
		BltBitMap(       orig,x,y, clone,0,0, width,height, $c0, $ff, NILA)
	ENDIF
ENDPROC

->if the bitmap has a depth <= 8, then it may return 0
->NOTE: This works-around OS4 seemingly defining "depth" to exclude the Alpha channel
PROC rtgGetBitMapDepth(bitmap:PTR TO bitmap) RETURNS depth /*REPLACEMENT*/ IS p96GetBitMapAttr(bitmap, P96BMA_BITSPERPIXEL)		->was: IF p96GetBitMapAttr(bitmap, P96BMA_RGBFORMAT) = RGBFB_A8R8G8B8 THEN 32 ELSE GetBitMapAttr(bitmap, BMA_DEPTH)

PROC rtgBitMapInVideoMem(bitmap:PTR TO bitmap) RETURNS inVideoMem:BOOL /*REPLACEMENT*/ IS p96GetBitMapAttr(bitmap, P96BMA_ISONBOARD) <> 0

PROC rtgMaxWidthBitMapInVideoMem() RETURNS size /*REPLACEMENT*/ IS 1024-1

PROC rtgMaxHeightBitMapInVideoMem() RETURNS size /*REPLACEMENT*/ IS 1024-1

PROC rtgReadPixel( rp:PTR TO rastport, x, y) RETURNS colour /*REPLACEMENT*/ IS p96ReadPixel(rp, x!!UINT, y!!UINT)

PROC rtgWritePixel(rp:PTR TO rastport, x, y, color) /*REPLACEMENT*/ IS p96WritePixel(rp, x!!UINT, y!!UINT, color/*!!ULONG*/) BUT EMPTY

PROC rtgReadPixelArray(srcRastport:PTR TO rastport, minX, minY, maxX, maxY, destArray:ARRAY OF LONG) REPLACEMENT
	DEF destRI:p96RenderInfo, width, height
	
	width  := maxX - minX + 1
	height := maxY - minY + 1
	
	destRI.memory := destArray
	destRI.bytesperrow := width * SIZEOF LONG !!INT
	destRI.rgbformat   := RGBFB_A8R8G8B8
	
	p96ReadPixelArray(destRI, 0, 0, srcRastport, minX!!UINT, minY!!UINT, width!!UINT, height!!UINT)
ENDPROC

PROC rtgWritePixelArray(destRastport:PTR TO rastport, minX, minY, maxX, maxY, srcArray:ARRAY OF LONG) REPLACEMENT
	DEF srcRI:p96RenderInfo, width, height
	
	width  := maxX - minX + 1
	height := maxY - minY + 1
	
	srcRI.memory := srcArray
	srcRI.bytesperrow := width * SIZEOF LONG !!INT
	srcRI.rgbformat   := RGBFB_A8R8G8B8
	
	p96WritePixelArray(srcRI, 0, 0, destRastport, minX!!UINT, minY!!UINT, width!!UINT, height!!UINT)
ENDPROC

->NOTE: "smooth" may be ignored in some cases.
PROC rtgScale(srcBitMap:PTR TO bitmap, srcX, srcY, srcWidth, srcHeight, destBitMap:PTR TO bitmap, destX, destY, destWidth, destHeight, screenDepth, smooth=FALSE:BOOL) REPLACEMENT
	DEF result, flags
	
	IF rtgAlphaSupported(screenDepth)
		flags := /*COMPFLAG_FORCESOFTWARE OR COMPFLAG_HARDWAREONLY OR*/ IF smooth THEN COMPFLAG_SRCFILTER ELSE 0		->Using COMPFLAG_IGNOREDESTALPHA stops it working correctly
		IF rtgBitMapInVideoMem(srcBitMap) = FALSE THEN flags := flags OR COMPFLAG_FORCESOFTWARE		->this WOULD make it nearly *2 faster on X1000, IF rtgBitMapInVideoMem() actually worked
		
		result := CompositeTagList(COMPOSITE_SRC, srcBitMap, destBitMap, [
			COMPTAG_SRCX,      srcX,
			COMPTAG_SRCY,      srcY,
			COMPTAG_SRCWIDTH,  srcWidth,
			COMPTAG_SRCHEIGHT, srcHeight,
			COMPTAG_DESTX,     destX,
			COMPTAG_DESTY,     destY,
			COMPTAG_DESTWIDTH, destWidth,
			COMPTAG_DESTHEIGHT,destHeight,
			COMPTAG_OFFSETX,   destX,
			COMPTAG_OFFSETY,   destY,
			COMPTAG_SCALEX, destWidth  * COMP_FIX_ONE + (srcWidth -1) / srcWidth,		->was: Comp_float_to_fix(destWidth !!FLOAT / srcWidth),
			COMPTAG_SCALEY, destHeight * COMP_FIX_ONE + (srcHeight-1) / srcHeight,
			COMPTAG_FLAGS,  flags /*OR COMPFLAG_SRCALPHAOVERRIDE*/,
			/*MPTAG_SRCALPHA, COMP_FIX_ONE,*/
			/*COMPTAG_FRIENDBITMAP,destBitMap,*/
		TAG_END]:tagitem)
		IF result <> COMPERR_SUCCESS THEN Throw("BUG", 'pAmigaRTG; rtgScale(); CompositeTagList() failed')
	ELSE
		bitMapScaleClassic(srcBitMap, srcX, srcY, srcWidth, srcHeight, destBitMap, destX, destY, destWidth, destHeight, screenDepth)
	ENDIF
ENDPROC

PROC rtgAlphaSupported(screenDepth) RETURNS alphaSupported:BOOL /*REPLACEMENT*/ IS IF gfxbase.version >= 53 THEN screenDepth = 32 ELSE FALSE

PROC rtgBltBitMapAlpha(srcBitMap:PTR TO bitmap, srcX, srcY, destBitMap:PTR TO bitmap, destX, destY, sizeX, sizeY) REPLACEMENT
	DEF result
	
	result := CompositeTagList(COMPOSITE_SRC_OVER_DEST, srcBitMap, destBitMap, [
		COMPTAG_SRCX,      srcX,
		COMPTAG_SRCY,      srcY,
		COMPTAG_SRCWIDTH,  sizeX,
		COMPTAG_SRCHEIGHT, sizeY,
		COMPTAG_DESTX,     destX,
		COMPTAG_DESTY,     destY,
		COMPTAG_DESTWIDTH, sizeX,
		COMPTAG_DESTHEIGHT,sizeY,
		COMPTAG_OFFSETX,   destX,
		COMPTAG_OFFSETY,   destY,
		COMPTAG_FLAGS,COMPFLAG_IGNOREDESTALPHA /*OR COMPFLAG_FORCESOFTWARE OR COMPFLAG_HARDWAREONLY*/,
		/*COMPTAG_FRIENDBITMAP,destBitMap,*/
	TAG_END]:tagitem)
/*
IF result <> COMPERR_SUCCESS
	Print('# bitmap $\h has drawable=\d\n', srcBitMap, p96GetBitMapAttr(srcBitMap, P96BMA_ISONBOARD))
	Print('# result = \d\n', result)
	result := CompositeTagList(COMPOSITE_SRC_OVER_DEST, srcBitMap, destBitMap, [COMPTAG_SRCX,      srcX, COMPTAG_SRCY,      srcY, COMPTAG_SRCWIDTH,  sizeX, COMPTAG_SRCHEIGHT, sizeY, COMPTAG_DESTX,     destX, COMPTAG_DESTY,     destY, COMPTAG_DESTWIDTH, sizeX, COMPTAG_DESTHEIGHT,sizeY, COMPTAG_OFFSETX,   destX, COMPTAG_OFFSETY,   destY, COMPTAG_FLAGS,COMPFLAG_IGNOREDESTALPHA, TAG_END]:tagitem)
ENDIF
*/
	IF result <> COMPERR_SUCCESS THEN Throw("BUG", 'pAmigaRTG; rtgBltBitMapAlpha(); CompositeTagList() failed')
ENDPROC


#ifdef pe_TargetOS_AmigaOS4
PROC bitMapScaleClassic(srcBitMap:PTR TO bitmap, srcX, srcY, srcWidth, srcHeight, dstBitMap:PTR TO bitmap, dstX, dstY, dstWidth, dstHeight, screenDepth) REPLACEMENT
	DEF kludge:BOOL, srcDepth, srcBitMap2:PTR TO bitmap
	
	->scaling does not seem to work on bitmaps that are friends with 16-bit screens, so work-around that
	srcDepth := rtgGetBitMapDepth(srcBitMap)
	IF kludge := (srcDepth > 8) AND (srcDepth < 32) AND (srcDepth = screenDepth)
		srcBitMap2 := rtgAllocBitMap(srcWidth, srcHeight, 32, 0)
		BltBitMap(srcBitMap,srcX,srcY, srcBitMap2,0,0, srcWidth,srcHeight, $c0,$ff,NILA)
		
		srcBitMap := srcBitMap2
		srcX := 0
		srcY := 0
	ENDIF
	
	SUPER bitMapScaleClassic(srcBitMap, srcX, srcY, srcWidth, srcHeight, dstBitMap, dstX, dstY, dstWidth, dstHeight, screenDepth)
	
	IF kludge
		FreeBitMap(srcBitMap2)
	ENDIF
ENDPROC
#endif
