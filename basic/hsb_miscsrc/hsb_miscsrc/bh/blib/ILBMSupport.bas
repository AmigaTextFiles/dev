'** $VER: ILBMSupport.bas 1.1 [14.01.96] 
'** Author: steffen.leistner@styx.in-chemnitz.de
'** Req.: Kickstart 37+, exec.-, graphics.-, iff.library
'** iff.library is © Christian A. Weber

CONST PicDims% 		= 7%
CONST PicWidth% 	= 0%
CONST PicHeight% 	= 1%
CONST PicDepth% 	= 2%
CONST PicColW%		= 3%	'Pointer to RGB4-Colortable
CONST PicColN% 		= 4%	'NumColors
CONST PicDMode% 	= 5%	'DisplaymodeID
CONST PicPWidth%	= 6%
CONST PicPHeight%	= 7%
CONST PERR_NOFILE&	= -1&	'File not found
CONST PERR_NOTYP&	= -2&	'not a IFF-File
CONST PERR_NOPIC&	= -3&	'no Bitmapheader
CONST PERR_NOMEM&	= -4&	'not enough Memory
CONST PERR_DECODE&	= -5&	'Error while unpacking
CONST PERR_NOCOL&	= -6&	'no Colortable

SUB RemoveBitMap (bm&, b%, h%)
	LOCAL planesoffset&, plane&
	WaitBlit
	IF PEEKW(LIBRARY("graphics.library") + lib_Version%) < 39% THEN
		planesoffset& = bm& + Planes%
		FOR z% = 0% TO 7%
			plane& = PEEKL (planesoffset& + (z% * 4%))
			IF plane& THEN
				FreeRaster plane&, b%, h%
			END IF
		NEXT z%
		FreeVec bm&
	ELSE
		FreeBitmap bm&
	END IF		
END SUB	

FUNCTION MakeBitMap& (b%, h%, d%)
	LOCAL bmadr&, planesoffset&, plane&
	IF PEEKW(LIBRARY("graphics.library") + lib_Version%) < 39% THEN
		bmadr& = AllocVec& (BitMap_sizeof%, MEMF_CHIP& OR MEMF_CLEAR&)
		IF bmadr& THEN
			InitBitMap bmadr&, d%, b%, h%
			planesoffset& = bmadr& + Planes%
			FOR z% = 0% TO (d% - 1%)
				plane& = AllocRaster (b%, h%)
				IF plane& THEN
					POKEL planesoffset& + (z% * 4%), plane&
				ELSE
					RemoveBitMap bmadr&, b%, h%
					bmadr& = NULL&
					EXIT FOR
				END IF
			NEXT z%
		END IF
		MakeBitMap& = bmadr&
	ELSE
		MakeBitmap& = AllocBitMap&(b%, h%, d%, 0&, 0&)
	END IF
	WaitBlit
END FUNCTION

'******************************************************************************
'** This is the Mainfunction:
'**
'** Syntax:
'**         res& = LoadILBM&(picname$, picdatas&())
'** 
'** res& 		bitmapptr& or PERR_...
'** picname$    DOS-Name of the ILBMFile
'** picdatas&() see Constants above
'**

FUNCTION LoadILBM& (pn$, pd&())
	LOCAL iffhandle&, bmhadr&, tempbm&
	IF FEXISTS(pn$) THEN

		iffhandle& = IFFLOpenIFF&(SADD(pn$ + CHR$(0)), IFFL_MODE_READ&)
		
		IF iffhandle& THEN
			bmhadr& = IFFLGetBMHD&(iffhandle&)
			IF bmhadr& THEN
				pd&(PicWidth%)	= PEEKW(bmhadr& + iff_bmh_Width%)
				pd&(PicHeight%)	= PEEKW(bmhadr& + iff_bmh_Height%)
				pd&(PicDepth%)	= PEEKB(bmhadr& + iff_bmh_nPlanes%)
				pd&(PicColN%)	= 2^pd&(PicDepth%)
				pd&(PicPWidth%)	= PEEKW(bmhadr& + iff_bmh_PageWidth%)
				pd&(PicPHeight%)= PEEKW(bmhadr& + iff_bmh_PageHeight%)
				pd&(PicDMode%)	= IFFLGetViewModes& (iffhandle&)
				
				tempbm& = MakeBitMap&(pd&(PicWidth%), pd&(PicHeight%), pd&(PicDepth%))
				IF tempbm& THEN
					
					IF IFFLDecodePic&(iffhandle&, tempbm&) THEN
						pd&(PicColW%) = AllocVec& (pd&(PicColN%) * 2%, MEMF_PUBLIC&)
						IF pd&(PicColW%) THEN
							IF IFFLGetColorTab&(iffhandle&, pd&(PicColW%)) THEN
								IFFLCloseIFF iffhandle&
								LoadILBM& = tempbm&
							ELSE
								RemoveBitMap tempbm&, pd&(PicWidth%), pd&(PicHeight%)
								IFFLCloseIFF iffhandle&
								LoadILBM& = PERR_NOCOL&
							END IF
						ELSE
							RemoveBitMap tempbm&, pd&(PicWidth%), pd&(PicHeight%)
							IFFLCloseIFF iffhandle&
							LoadILBM& = PERR_NOMEM&
						END IF
					ELSE
						RemoveBitMap tempbm&, pd&(PicWidth%), pd&(PicHeight%)
						IFFLCloseIFF iffhandle&
						LoadILBM& = PERR_DECODE&
					END IF
					
				ELSE
					IFFLCloseIFF iffhandle&
					LoadILBM& = PERR_NOMEM&
				END IF
				
			ELSE
				IFFLCloseIFF iffhandle&
				LoadILBM& = PERR_NOPIC&
			END IF
			
		ELSE
			LoadILBM& = PERR_NOTYP&
		END IF
		
	ELSE
		LoadILBM& = PERR_NOFILE&
	END IF
END FUNCTION