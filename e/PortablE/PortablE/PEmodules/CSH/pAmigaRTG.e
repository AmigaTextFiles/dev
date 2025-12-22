/* alias module */
OPT PREPROCESS
PUBLIC MODULE 'target/CSH/pAmigaRTG'
MODULE 'target/graphics'

->removed: #ifdef pe_TargetOS_AROS / 2 !!UINT #endif	->work-around a bug in AROS, up to at least Icaros v1.4.5 .
 
#ifdef pe_TargetOS_AROS
->work-around a bug in AROS, up to at least Icaros v1.4.5
PROC bitMapScaleClassic(srcBitMap:PTR TO bitmap, srcX, srcY, srcWidth, srcHeight, dstBitMap:PTR TO bitmap, dstX, dstY, dstWidth, dstHeight, screenDepth) REPLACEMENT
	DEF temp:PTR TO bitmap
	
	IF dstY = 0
		->(bug will not have an effect) so do it directly
		SUPER bitMapScaleClassic(srcBitMap, srcX, srcY, srcWidth, srcHeight, dstBitMap, dstX, dstY, dstWidth, dstHeight, screenDepth)
	ELSE
		->work-around the bug in a way which will still work when the bug is fixed
		temp := rtgAllocBitMap(dstWidth, dstHeight, rtgGetBitMapDepth(dstBitMap), /*flags*/ 0, dstBitMap)
		
		SUPER bitMapScaleClassic(srcBitMap, srcX, srcY, srcWidth, srcHeight, temp, 0, 0, dstWidth, dstHeight, screenDepth)
		BltBitMap(temp,0,0, dstBitMap,dstX,dstY, dstWidth,dstHeight, $c0,$ff,NILA)
		
		FreeBitMap(temp)
	ENDIF
ENDPROC
#endif
