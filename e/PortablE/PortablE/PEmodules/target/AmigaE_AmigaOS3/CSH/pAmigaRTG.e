/* pAmigaRTG.e 02-04-2013
	A collection of dummy RTG wrappers for non-RTG systems.
	Copyright (c) 2012,2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
	
	NOTE: For OS3 we should really use the CGX implementation (with a fall-back if the library does not exist), but that means the CGX includes are required for compiling OS3 stuff... which I need to add to AmiDevCpp.
*/
OPT INLINE
PUBLIC MODULE 'targetShared/Amiga/CSH/pAmigaRTG_base'
MODULE 'graphics/gfx', 'graphics/rastport'

CONST RGB_MASK = $FFFFFF, ALPHA_MASK = $FF000000


PROC rtgSupported() RETURNS supported:BOOL /*REPLACEMENT*/ IS FALSE

PROC rtgAllocBitMap(width, height, depth, flags, friend=NIL:PTR TO bitmap) RETURNS bitmap:PTR TO bitmap /*REPLACEMENT*/
	width:=height:=depth:=flags ; friend:=NIL	->dummy
ENDPROC

->PROC rtgFreeBitMap(bitmap:PTR TO bitmap) REPLACEMENT IS EMPTY

PROC rtgCloneBitMap(orig:PTR TO bitmap, friend=NIL:PTR TO bitmap, extraFlags=0, x=0, y=0, width=-1, height=-1, origRastport=NIL:PTR TO rastport) RETURNS clone:PTR TO bitmap REPLACEMENT
	orig:=friend ; extraFlags:=x:=y:=width:=height ; origRastport:=NIL	->dummy
ENDPROC

PROC rtgGetBitMapDepth(bitmap:PTR TO bitmap) RETURNS depth /*REPLACEMENT*/ IS bitmap BUT 0

PROC rtgBitMapInVideoMem(bitmap:PTR TO bitmap) RETURNS inVideoMem:BOOL /*REPLACEMENT*/
	bitmap:=NIL	->dummy
ENDPROC

PROC rtgMaxWidthBitMapInVideoMem() RETURNS size /*REPLACEMENT*/ IS 1024-1	->guessed

PROC rtgMaxHeightBitMapInVideoMem() RETURNS size /*REPLACEMENT*/ IS 1024-1

PROC rtgReadPixel( rp:PTR TO rastport, x, y) RETURNS colour /*REPLACEMENT*/
	rp:=NIL ; x:=y	->dummy
ENDPROC

PROC rtgWritePixel(rp:PTR TO rastport, x, y, color) /*REPLACEMENT*/
	rp:=NIL ; x:=y:=color	->dummy
ENDPROC

PROC rtgReadPixelArray(srcRastport:PTR TO rastport, minX, minY, maxX, maxY, destArray:ARRAY OF LONG) REPLACEMENT
	srcRastport:=NIL ; minX:=minY:=maxX:=maxY ; destArray:=NILA	->dummy
ENDPROC

PROC rtgWritePixelArray(destRastport:PTR TO rastport, minX, minY, maxX, maxY, srcArray:ARRAY OF LONG) REPLACEMENT
	destRastport:=NIL ; minX:=minY:=maxX:=maxY ; srcArray:=NILA	->dummy
ENDPROC

PROC rtgScale(srcBitMap:PTR TO bitmap, srcX, srcY, srcWidth, srcHeight, dstBitMap:PTR TO bitmap, dstX, dstY, dstWidth, dstHeight, screenDepth, smooth=FALSE:BOOL) REPLACEMENT
	srcBitMap:=dstBitMap:=NIL ; srcX:=srcY:=srcWidth:=srcHeight:=dstX:=dstY:=dstWidth:=dstHeight:=screenDepth:=0 ; smooth:=FALSE	->dummy
ENDPROC

PROC rtgAlphaSupported(screenDepth) RETURNS alphaSupported:BOOL /*REPLACEMENT*/ IS screenDepth BUT FALSE

PROC rtgBltBitMapAlpha(srcBitMap:PTR TO bitmap, srcX, srcY, destBitMap:PTR TO bitmap, destX, destY, sizeX, sizeY) REPLACEMENT
	srcBitMap:=destBitMap ; srcX:=srcY:=destX:=destY:=sizeX:=sizeY
ENDPROC
