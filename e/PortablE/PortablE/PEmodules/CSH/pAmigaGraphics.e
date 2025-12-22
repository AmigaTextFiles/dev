/* pAmigaGraphics.e 26-01-2013
	A collection of useful procedures/wrappers for the Graphics library.
	Copyright (c) 2009, 2010, 2011, 2012, 2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
OPT INLINE, POINTER, PREPROCESS
PUBLIC MODULE 'graphics'
MODULE 'CSH/pAmigaRTG', 'CSH/pGeneral'
MODULE 'exec/types', 'utility/tagitem'

/*****************************/	->portable bitmap (de)allocation, whether or not RTG is supported (but not yet tested on non-RTG systems)

PROC allocBitMap(width, height, depth, flags, friend=NIL:PTR TO bitmap) RETURNS bitmap:PTR TO bitmap IS IF rtgSupported() AND (depth > 8) THEN rtgAllocBitMap(width, height, depth, flags, friend) ELSE AllocBitMap(width, height, depth, flags, friend)

PROC freeBitMap(bitmap:PTR TO bitmap) IS FreeBitMap(bitmap)

PROC cloneBitMap(orig:PTR TO bitmap, friend=NIL:PTR TO bitmap, extraFlags=0, x=0, y=0, width=-1, height=-1, origRastport=NIL:PTR TO rastport) RETURNS clone:PTR TO bitmap IS IF rtgSupported() AND (getBitMapDepth(orig) > 8) THEN rtgCloneBitMap(orig, friend, extraFlags, x, y, width, height, origRastport) ELSE basicCloneBitMap(orig, friend, extraFlags, x, y, width, height, origRastport)
PRIVATE
PROC basicCloneBitMap(orig:PTR TO bitmap, friend=NIL:PTR TO bitmap, extraFlags=0, x=0, y=0, width=-1, height=-1, origRastport=NIL:PTR TO rastport) RETURNS clone:PTR TO bitmap
	DEF depth, flags, cloneDepth
	DEF useClipBlit:BOOL, cloneRastport:rastport
	
	IF width  = -1 THEN width  := GetBitMapAttr(orig, BMA_WIDTH)
	IF height = -1 THEN height := GetBitMapAttr(orig, BMA_HEIGHT)
	flags := GetBitMapAttr(orig, BMA_FLAGS)
	depth := getBitMapDepth(orig)
	
	cloneDepth := IF friend THEN getBitMapDepth(friend) ELSE depth
	clone := AllocBitMap(width, height, cloneDepth, flags OR extraFlags, friend)
	IF clone = NIL THEN RETURN
	
	useClipBlit := IF origRastport THEN origRastport.layer <> NIL ELSE FALSE
	IF useClipBlit
		InitRastPort(cloneRastport)
		cloneRastport.bitmap := clone
		ClipBlit(origRastport,x,y, cloneRastport,0,0, width,height, $c0)
	ELSE
		BltBitMap(       orig,x,y,         clone,0,0, width,height, $c0, $ff, NILA)
	ENDIF
ENDPROC
PUBLIC

PROC getBitMapDepth(bitmap:PTR TO bitmap) RETURNS depth
	depth := rtgGetBitMapDepth(bitmap)
	IF depth <= 8 THEN depth := GetBitMapAttr(bitmap, BMA_DEPTH)
ENDPROC

PROC bitMapInVideoMem(bitmap:PTR TO bitmap) RETURNS inVideoMem:BOOL IS IF rtgGetBitMapDepth(bitmap) > 8 THEN rtgBitMapInVideoMem(bitmap) ELSE (GetBitMapAttr(bitmap, BMA_FLAGS) AND BMF_DISPLAYABLE <> 0)


PROC allocMaskBitMap(width, height, noClear=FALSE:BOOL) RETURNS maskBitmap:PTR TO bitmap
	maskBitmap := AllocBitMap(width, height, 1, BMF_STANDARD OR IF noClear THEN 0 ELSE BMF_CLEAR, NIL)
	/*
	DEF i, size, plane:ARRAY OF BYTE
	
	NEW maskBitmap
	InitBitMap(maskBitmap, 1, width !!UINT, height !!UINT)
	plane := maskBitmap.planes[0] := AllocRaster(GetBitMapAttr(maskBitmap, BMA_WIDTH), GetBitMapAttr(maskBitmap, BMA_HEIGHT))
	IF noClear = FALSE
		IF plane
			size := maskBitmap.bytesperrow * maskBitmap.rows
			FOR i := 0 TO size-1 DO plane[i] := 0
		ENDIF
	ENDIF
	->old: maskBitmap.planes[0] := FastNew(maskBitmap.bytesperrow * maskBitmap.rows, noClear)
	IF maskBitmap.planes[0] = NIL THEN END maskBitmap
	*/
ENDPROC

PROC freeMaskBitMap(maskBitmap:NULL PTR TO bitmap) RETURNS nil:PTR TO bitmap
	IF maskBitmap THEN FreeBitMap(maskBitmap)
	/*
	IF maskBitmap THEN FreeRaster(maskBitmap.planes[0], GetBitMapAttr(maskBitmap, BMA_WIDTH), GetBitMapAttr(maskBitmap, BMA_HEIGHT))
	->old: IF maskBitmap THEN FastDispose(maskBitmap.planes[0], maskBitmap.bytesperrow * maskBitmap.rows)
	END maskBitmap
	*/
	
	nil := NIL
ENDPROC

/*****************************/	->portable blitting

#ifdef pe_TargetOS_AROS
->NOTE: This is required for at least Icaros v1.2.x, v1.3.x & v1.4.0 .
PROC bltBitMap(srcBitMap:PTR TO bitmap, xSrc, ySrc, destBitMap:PTR TO bitmap, xDest, yDest, width, height, minterm:ULONG, mask:ULONG, tempA:PLANEPTR)
	DEF srcDepth, srcRP:rastport
	DEF dstDepth, dstRP:rastport
	DEF arrayRTG:OWNS ARRAY OF LONG, array8:OWNS ARRAY OF BYTE, array8width, x, y, yIndex, yIndexRTG
	
	srcDepth := getBitMapDepth( srcBitMap)
	dstDepth := getBitMapDepth(destBitMap)
	
	IF (srcDepth = dstDepth) OR ((srcDepth>8) = (dstDepth>8))
		BltBitMap(srcBitMap, xSrc, ySrc, destBitMap, xDest, yDest, width, height, minterm, mask, tempA)
	ELSE
		InitRastPort(srcRP) ; srcRP.bitmap :=  srcBitMap
		InitRastPort(dstRP) ; dstRP.bitmap := destBitMap
		array8width := rwPixelArray8width(width)
		NEW arrayRTG[width * height], array8[array8width * height]
		
		IF srcDepth<=8
			readPixelArray8(   srcRP, xSrc, ySrc, xSrc+width-1, ySrc+height-1, array8)
			yIndex    := 0
			yIndexRTG := 0
			FOR y := 0 TO height-1
				FOR x := 0 TO width-1 DO arrayRTG[yIndexRTG + x] := array8[yIndex + x] OR ALPHA_MASK
				yIndex    := yIndex    + array8width
				yIndexRTG := yIndexRTG + width
			ENDFOR
			rtgWritePixelArray(dstRP, xDest, yDest, xSrc+width-1, ySrc+height-1, arrayRTG)
		ELSE
			rtgReadPixelArray( srcRP, xSrc, ySrc, xSrc+width-1, ySrc+height-1, arrayRTG)
			yIndex    := 0
			yIndexRTG := 0
			FOR y := 0 TO height-1
				FOR x := 0 TO width-1 DO array8[yIndex + x] := arrayRTG[yIndexRTG + x] AND RGB_MASK !!VALUE!!BYTE
				yIndex    := yIndex    + array8width
				yIndexRTG := yIndexRTG + width
			ENDFOR
			writePixelArray8(  dstRP, xDest, yDest, xSrc+width-1, ySrc+height-1, array8)
		ENDIF
	ENDIF
FINALLY
	END arrayRTG, array8
ENDPROC
#else
PROC bltBitMap(srcBitMap:PTR TO bitmap, xSrc, ySrc, destBitMap:PTR TO bitmap, xDest, yDest, xSize, ySize, minterm:ULONG, mask:ULONG, tempA:PLANEPTR) IS BltBitMap(srcBitMap, xSrc, ySrc, destBitMap, xDest, yDest, xSize, ySize, minterm, mask, tempA) BUT EMPTY
#endif

/*****************************/	->portable handling of RGB colours

#ifdef pe_TargetOS_AmigaOS4
	->make OS4 emulate how MorphOS & AROS do it
	PRIVATE
	CONST RPTAG_FGCOLOR = RPTAG_APENCOLOR
	CONST RPTAG_BGCOLOR = RPTAG_BPENCOLOR
	CONST RPTAG_PENMODE = TAG_IGNORE
	PUBLIC
#endif

#ifndef pe_TargetOS_AmigaOS3
PROC setRPAttrsFGCOLOR(rastport:PTR TO rastport, rgb) IS SetRPAttrsA(rastport, [RPTAG_FGCOLOR,rgb #ifdef pe_TargetOS_AmigaOS4 OR ALPHA_MASK #endif, RPTAG_PENMODE,FALSE, TAG_END]:tagitem)

PROC setRPAttrsBGCOLOR(rastport:PTR TO rastport, rgb) IS SetRPAttrsA(rastport, [RPTAG_BGCOLOR,rgb #ifdef pe_TargetOS_AmigaOS4 OR ALPHA_MASK #endif, RPTAG_PENMODE,FALSE, TAG_END]:tagitem)

PROC getRPAttrsFGCOLOR(rastport:PTR TO rastport) RETURNS rgb
	GetRPAttrsA(rastport, [RPTAG_FGCOLOR,ADDRESSOF rgb, TAG_END]:tagitem)
	rgb := rgb AND RGB_MASK
ENDPROC
#else
->dummy implementations, which should never be used at run-time
PROC setRPAttrsFGCOLOR(rastport:PTR TO rastport, rgb)
	rastport:=NIL ; rgb:=0	->dummy
ENDPROC

PROC setRPAttrsBGCOLOR(rastport:PTR TO rastport, rgb)
	rastport:=NIL ; rgb:=0	->dummy
ENDPROC

PROC getRPAttrsFGCOLOR(rastport:PTR TO rastport) RETURNS rgb
	rastport:=NIL	->dummy
ENDPROC
#endif

#ifdef pe_TargetOS_AROS
->WritePixel() does not work with 24-bit bitmaps on AROS, up to at least Icaros v1.4.0 .
PROC writePixel(rp:PTR TO rastport, x:VALUE, y:VALUE) RETURNS error IS RectFill(rp, x, y, x, y) BUT FALSE
#else
PROC writePixel(rp:PTR TO rastport, x:VALUE, y:VALUE) RETURNS error IS WritePixel(rp, x, y)
#endif

/*****************************/	->simplified array handling for <=8-bit rasterports

PROC readPixelArray8(sourceRastport:PTR TO rastport, minX, minY, maxX, maxY, targetArray:ARRAY OF BYTE) RETURNS count
	DEF tempRastport:rastport
	
	tempRastport.bitmap := NIL
	
	->InitRastPort(tempRastport)
	MemCopy(tempRastport, sourceRastport, SIZEOF rastport)
	tempRastport.layer := NIL
	tempRastport.bitmap := allocMaskBitMap(maxX - minX + 1, 1, TRUE)	->noClear=TRUE
	
	count := ReadPixelArray8(sourceRastport, minX, minY, maxX, maxY, targetArray!!ARRAY, tempRastport)
FINALLY
	IF tempRastport.bitmap THEN freeMaskBitMap(tempRastport.bitmap)
ENDPROC

PROC writePixelArray8(targetRastport:PTR TO rastport, minX, minY, maxX, maxY, sourceArray:ARRAY OF BYTE) RETURNS count
	DEF tempRastport:rastport
	
	tempRastport.bitmap := NIL
	
	->InitRastPort(tempRastport)
	MemCopy(tempRastport, targetRastport, SIZEOF rastport)
	tempRastport.layer := NIL
	tempRastport.bitmap := allocMaskBitMap(maxX - minX + 1, 1, TRUE)	->noClear=TRUE
	
	count := WritePixelArray8(targetRastport, minX, minY, maxX, maxY, sourceArray!!ARRAY, tempRastport)
FINALLY
	IF tempRastport.bitmap THEN freeMaskBitMap(tempRastport.bitmap)
ENDPROC

PROC rwPixelArray8width(width) /*RETURNS arrayWidth*/ IS width+15 AND NOT %1111
->was: width+15 SHR 4 SHL 4

PROC rwPixelArray8size(minX, minY, maxX, maxY) /*RETURNS arraySize*/ IS rwPixelArray8width(maxX - minX + 1) * (maxY-minY+1)

PROC rwPixelArray8index(x, y, arrayWidth) /*RETURNS arrayIndex*/ IS y * arrayWidth + x

/*****************************/	->portable scaling

->NOTE: Even with smooth=TRUE, scaling is not guaranteed to be smooth.
PROC bitMapScale(srcBitMap:PTR TO bitmap, srcX, srcY, srcWidth, srcHeight, dstBitMap:PTR TO bitmap, dstX, dstY, dstWidth, dstHeight, screenDepth, smooth=FALSE:BOOL)
	DEF useRTG:BOOL
	
	->examine current bitmap
	useRTG := rtgSupported() AND (getBitMapDepth(srcBitMap) > 8)
	
	->perform scaling
	IF useRTG
		rtgScale(srcBitMap, srcX, srcY, srcWidth, srcHeight, dstBitMap, dstX, dstY, dstWidth, dstHeight, screenDepth, smooth)
	ELSE
		bitMapScaleClassic(srcBitMap, srcX, srcY, srcWidth, srcHeight, dstBitMap, dstX, dstY, dstWidth, dstHeight, screenDepth)
	ENDIF
ENDPROC

/*****************************/

PROC sizeOfLine(line:ARRAY OF CHAR, font:PTR TO textfont) RETURNS width, height
	DEF te:textextent, rastport:rastport
	
	InitRastPort(rastport)
	SetFont(rastport, font)
	
	TextExtent(rastport, line, StrLen(line), te)
	width  := te.width /*+ te.extent.minx*/
	height := te.height - te.extent.miny
ENDPROC

/*****************************/

PROC formatLinesOfText(string:ARRAY OF CHAR) RETURNS lines:OWNS STRING, numberOfLines IS splitLinesIntoLinkedStrings(string)

PROC sizeOfText(lines:STRING, font:PTR TO textfont) RETURNS width, height
	DEF numberOfLines, node:STRING, te:textextent, rastport:rastport
	
	InitRastPort(rastport)
	SetFont(rastport, font)
	
	width := 0
	numberOfLines := 0
	node := lines
	REPEAT
		TextExtent(rastport, node, EstrLen(node), te)
		width := Max(width, te.width)
		
		numberOfLines++
		node := Next(node)
	UNTIL node = NILS
	
	TextExtent(rastport, '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM', STRLEN, te)	->this may not be necessary
	height := te.height * numberOfLines
ENDPROC

PROC drawText(lines:STRING, rastport:PTR TO rastport, x, y)
	DEF te:textextent, node:STRING
	
	TextExtent(rastport, '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM', STRLEN, te)
	x := x + te.extent.minx
	y := y - te.extent.miny		/*alternative: win.height - win.borderbottom - te.extent.maxy - 1*/
	
	node := lines
	REPEAT
		Move(rastport, x !!INT, y !!INT)
		Text(rastport, node, EstrLen(node))
		y := y + te.height
		
		node := Next(node)
	UNTIL node = NILS
ENDPROC
