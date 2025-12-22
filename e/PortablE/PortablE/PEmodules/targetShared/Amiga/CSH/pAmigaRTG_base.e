/* pAmigaRTG_base.e 02-04-2013
	A base interface & fall-back implementation of RTG wrappers.
	Copyright (c) 2012, 2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
OPT PREPROCESS
MODULE 'target/graphics', 'target/exec/types'


/*PROC rtgSupported() RETURNS supported:BOOL PROTOTYPE IS EMPTY*/

/*PROC rtgAllocBitMap(width, height, depth, flags, friend=NIL:PTR TO bitmap) RETURNS bitmap:PTR TO bitmap PROTOTYPE IS EMPTY*/

PROC rtgCloneBitMap(orig:PTR TO bitmap, friend=NIL:PTR TO bitmap, extraFlags=0, x=0, y=0, width=-1, height=-1, origRastport=NIL:PTR TO rastport) RETURNS clone:PTR TO bitmap PROTOTYPE IS EMPTY

/*PROC rtgGetBitMapDepth(bitmap:PTR TO bitmap) RETURNS depth PROTOTYPE IS EMPTY*/

/*PROC rtgBitMapInVideoMem(bitmap:PTR TO bitmap) RETURNS inVideoMem:BOOL PROTOTYPE IS EMPTY*/

/*PROC rtgMaxWidthBitMapInVideoMem() RETURNS size PROTOTYPE IS EMPTY*/

/*PROC rtgMaxHeightBitMapInVideoMem() RETURNS size PROTOTYPE IS EMPTY*/

/*PROC rtgReadPixel( rp:PTR TO rastport, x, y) RETURNS colour PROTOTYPE IS EMPTY*/

/*PROC rtgWritePixel(rp:PTR TO rastport, x, y, color) PROTOTYPE IS EMPTY*/

PROC rtgReadPixelArray(srcRastport:PTR TO rastport, minX, minY, maxX, maxY, destArray:ARRAY OF LONG) PROTOTYPE IS EMPTY

PROC rtgWritePixelArray(destRastport:PTR TO rastport, minX, minY, maxX, maxY, srcArray:ARRAY OF LONG) PROTOTYPE IS EMPTY

PROC rtgScale(srcBitMap:PTR TO bitmap, srcX, srcY, srcWidth, srcHeight, dstBitMap:PTR TO bitmap, dstX, dstY, dstWidth, dstHeight, screenDepth, smooth=FALSE:BOOL) PROTOTYPE IS EMPTY

/*PROC rtgAlphaSupported(screenDepth) RETURNS alphaSupported:BOOL PROTOTYPE IS screenDepth BUT EMPTY*/

PROC rtgBltBitMapAlpha(srcBitMap:PTR TO bitmap, srcX, srcY, destBitMap:PTR TO bitmap, destX, destY, sizeX, sizeY) PROTOTYPE IS EMPTY


PROC bitMapScaleClassic(srcBitMap:PTR TO bitmap, srcX, srcY, srcWidth, srcHeight, dstBitMap:PTR TO bitmap, dstX, dstY, dstWidth, dstHeight, screenDepth)
	DEF /*reduce,*/ xMul, xDiv, yMul, yDiv, args:bitscaleargs
	
	xMul := dstWidth
	yMul := dstHeight
	xDiv := srcWidth
	yDiv := srcHeight
	
	/*
	->ensure that parameters stay within allowed range (under 16384)
	reduce := Max(xMul, xDiv) / 8192
	IF reduce > 1
		IF Min(xMul, xDiv) < reduce THEN Throw("EMU", 'bitMapScale(); X scaling exceeded supported range')
		xMul := xMul / reduce
		xDiv := xDiv / reduce
	ENDIF
	
	reduce := Max(yMul, yDiv) / 8192
	IF reduce > 1
		IF Min(yMul, yDiv) < reduce THEN Throw("EMU", 'bitMapScale(); Y scaling exceeded supported range')
		yMul := yMul / reduce
		yDiv := yDiv / reduce
	ENDIF
	*/
	
	->scale bitmap
	args. srcx      := srcX !!UINT
	args. srcy      := srcY !!UINT
	args. srcwidth  := srcWidth  !!UINT
	args. srcheight := srcHeight !!UINT
	args.xsrcfactor := xDiv !!UINT
	args.ysrcfactor := yDiv !!UINT
	
	args. destx      := dstX !!UINT
	args. desty      := dstY !!UINT
	args. destwidth  := dstWidth  !!UINT
	args. destheight := dstHeight !!UINT
	args.xdestfactor := xMul !!UINT
	args.ydestfactor := yMul !!UINT
	
	args. srcbitmap := srcBitMap
	args.destbitmap := dstBitMap
	args.flags := 0
	
	BitMapScale(args)
	
	screenDepth:=FALSE	->dummy
ENDPROC
