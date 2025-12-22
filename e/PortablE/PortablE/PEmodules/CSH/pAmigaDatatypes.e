/* pAmigaDatatypes.e 29-12-2013
	A collection of useful procedures/wrappers for the Datatypes library.


Copyright (c) 2009,2010,2011,2012,2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

* The source code must not be modified after it has been translated or converted
away from the PortablE programming language.  For clarification, the intention
is that all development of the source code must be done using the PortablE
programming language (as defined by Christopher Steven Handley).

* Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

OPT INLINE, POINTER, PREPROCESS
OPT NATIVE		->for AROS
PUBLIC MODULE 'datatypes'
MODULE '*pAmigaGraphics', 'exec', 'dos', 'intuition/screens', 'intuition/classusr', 'intuition/gadgetclass', 'utility/tagitem'
MODULE '*pAmigaRTG', 'amigalib/boopsi'
MODULE 'intuition'	->for AROS

#ifdef pe_TargetOS_AROS
->for savePicture()
{
#include <cybergraphx/cybergraphics.h>
#include <proto/cybergraphics.h>
}
#endif

PROC new()
	datatypesbase := OpenLibrary('datatypes.library', 0)
	IF datatypesbase=NIL THEN CleanUp(RETURN_ERROR)
ENDPROC

PROC end()
	CloseLibrary(datatypesbase)
ENDPROC

/*****************************/

PROC bitsPerSampleOfSoundDT(datatypeObject:PTR TO INTUIOBJECT) RETURNS bitsPerSample
	#ifdef pe_TargetOS_AmigaOS4
		GetDTAttrsA(datatypeObject, [SDTA_BITSPERSAMPLE,ADDRESSOF bitsPerSample, TAG_END]:tagitem)
	#else
		#ifndef pe_TargetOS_MorphOS
			->(AmigaOS3 or AROS)
			bitsPerSample := 8
			datatypeObject := NIL	->dummy
		#else
			-># this should work on AROS, but does not
			DEF sampleType
			GetDTAttrsA(datatypeObject, [SDTA_SAMPLETYPE,ADDRESSOF sampleType, TAG_END]:tagitem)
			bitsPerSample := (sampleType AND $FFFF) * 8
		#endif
	#endif
ENDPROC

PROC lengthOfSoundDT(datatypeObject:PTR TO INTUIOBJECT) RETURNS lengthInSecs
	#ifdef pe_TargetOS_MorphOS
		GetDTAttrsA(datatypeObject, [SDTA_DURATION,ADDRESSOF lengthInSecs, TAG_END]:tagitem)
	#else
		DEF frequency, bitsPerSample, lengthInBytes
		
		bitsPerSample := bitsPerSampleOfSoundDT(datatypeObject)
		GetDTAttrsA(datatypeObject, [SDTA_SAMPLESPERSEC,ADDRESSOF frequency,
		                             SDTA_SAMPLELENGTH, ADDRESSOF lengthInBytes,
		                             TAG_END]:tagitem)
		lengthInSecs := lengthInBytes / (bitsPerSample/8) / frequency
	#endif
ENDPROC

#ifdef pe_TargetOS_MorphOS
	CONST SDTA_LEFTSAMPLE  = SDTA_SAMPLE
	CONST SDTA_RIGHTSAMPLE = SDTA_SAMPLE
	->rather than TAG_IGNORE (which is more likely to behave badly in an obfuscated module)
	-># this could still cause problems when a module which uses these constants is obfuscated under MorphOS...
#endif

/*****************************/

->CONST BMF_USERPRIVATE = $8000	->P96 flag

->NOTE: Remember to DisposeDTObject(datatypeObject) when you are finished with bitmap & bitmapheader.
->NOTE: Supply a screen pointer to remap it to the screen.
->NOTE: If a screen pointer is supplied, it is made a friend bitmap unless doNotMakeFriendBitmap=TRUE.
PROC loadPicture(file:ARRAY OF CHAR, scr=NIL:PTR TO screen, doNotMakeFriendBitmap=FALSE:BOOL) RETURNS datatypeObject:PTR TO INTUIOBJECT, bitmap:PTR TO bitmap, bitmapheader:PTR TO bitmapheader
	DEF arrayRTG:OWNS ARRAY OF LONG, width, height, dtb:pdtblitpixelarray, bitmapRastport:rastport
	#ifdef pe_TargetOS_MorphOS
		DEF maskPlane:APTR
	#endif
	
	datatypeObject := NIL
	bitmap := NIL
	bitmapheader := NIL
	
	IF datatypesbase.version >= 43
		IF scr
			datatypeObject := NewDTObjectA(file, [DTA_GROUPID,GID_PICTURE, PDTA_DESTMODE,PMODE_V43, /*PDTA_REMAP,TRUE,*/ PDTA_SCREEN,scr, PDTA_USEFRIENDBITMAP,NOT doNotMakeFriendBitmap, TAG_END]:tagitem)
		ELSE
			datatypeObject := NewDTObjectA(file, [DTA_GROUPID,GID_PICTURE, PDTA_DESTMODE,PMODE_V43, PDTA_REMAP,FALSE, TAG_END]:tagitem)		->PDTA_REMAP,FALSE required for AROS
		ENDIF
	ELSE
		->for AmigaOS3.1 & lower
		datatypeObject := NewDTObjectA(file, [DTA_GROUPID,GID_PICTURE, PDTA_REMAP,scr<>NIL, IF scr THEN PDTA_SCREEN ELSE TAG_IGNORE,scr, TAG_END]:tagitem)
	ENDIF
	IF datatypeObject = NIL THEN RETURN		->Print(GetDTString(IoErr()), file)
	
	#ifdef pe_TargetOS_AROS
		IF (scr <> NIL) AND doNotMakeFriendBitmap
			->(non-friend bitmaps don't work for <=8-bit pictures) so check whether it is one
			GetDTAttrsA(datatypeObject, [PDTA_BITMAPHEADER,ADDRESSOF bitmapheader, TAG_END]:tagitem)
			IF bitmapheader.depth <= 8 THEN SetDTAttrsA(datatypeObject, NIL, NIL, [PDTA_USEFRIENDBITMAP,TRUE, TAG_END]:tagitem)
		ENDIF
	#endif
	#ifdef pe_TargetOS_MorphOS
		IF (scr <> NIL) AND doNotMakeFriendBitmap
			->(non-friend bitmaps don't work for pictures with masks, and gives wrong colours for non-true-colour bitmaps) so check whether there is one
			GetDTAttrsA(datatypeObject, [PDTA_MASKPLANE,ADDRESSOF maskPlane, PDTA_BITMAPHEADER,ADDRESSOF bitmapheader, TAG_END]:tagitem)
			IF maskPlane OR (bitmapheader.depth <= 8) THEN SetDTAttrsA(datatypeObject, NIL, NIL, [PDTA_USEFRIENDBITMAP,TRUE, TAG_END]:tagitem)
		ENDIF
	#endif
	
	GetDTAttrsA(datatypeObject, [PDTA_BITMAPHEADER,ADDRESSOF bitmapheader, TAG_END]:tagitem)		->get header now, as remapping can change depth (etc?) on AmigaOS4
	DoDTMethodA(datatypeObject, NIL, NIL, [DTM_PROCLAYOUT, NIL, TRUE]:gplayout)			->initial=TRUE
	GetDTAttrsA(datatypeObject, [PDTA_DESTBITMAP,ADDRESSOF bitmap, TAG_END]:tagitem)	->PDTA_DESTBITMAP needed on AROS
	
	IF bitmap
		IF (bitmapheader.masking = MSKHASALPHA) AND (bitmapheader.depth = 32) AND (scr <> NIL) AND (datatypesbase.version >= 43)
			->(picture has an alpha-channel, but the AmigaOS4/MOS/AROS datatypes do not write it with the DTM_PROCLAYOUT method) so add it ourselves (while keeping the bitmap owned by the datatypeObject as the user expects)
			IF rtgSupported() AND rtgAlphaSupported(getBitMapDepth(scr.rastport.bitmap))
				width  := bitmapheader.width
				height := bitmapheader.height
				
				NEW arrayRTG[width * height]
				
				dtb.methodid := PDTM_READPIXELARRAY
				dtb.pixeldata   := arrayRTG
				dtb.pixelformat := PBPAFMT_ARGB
				dtb.pixelarraymod := 4*width
				dtb.width  := width
				dtb.height := height
				dtb.top    := 0
				dtb.left   := 0
				IF doMethodA(datatypeObject, dtb) <> 0
					InitRastPort(bitmapRastport)
					bitmapRastport.bitmap := bitmap
					rtgWritePixelArray(bitmapRastport, 0, 0, width-1, height-1, arrayRTG)
				ELSE
					->Print('# doMethodA() = 0\n')
				ENDIF
			ELSE
				->Print('# screen depth=\d\n', getBitMapDepth(scr.rastport.bitmap))
			ENDIF
		ELSE
			->Print('# masking is MSKHASALPHA=\d, depth=\d, scr=$\h\n', (bitmapheader.masking = MSKHASALPHA), bitmapheader.depth, scr)
		ENDIF
	ENDIF
	
	IF (bitmap = NIL) OR (bitmapheader = NIL)
		DisposeDTObject(datatypeObject) ; datatypeObject := NIL
		bitmap := NIL ; bitmapheader := NIL
		RETURN
	ENDIF
FINALLY
	END arrayRTG
ENDPROC

->NOTE: Thanks to Thomas Rapp for help getting this to work for depth>8.
->NOTE: maskBitmap may be ignored, depending on the OS.
PROC savePicture(file:ARRAY OF CHAR, bitmap:PTR TO bitmap, colormap:PTR TO colormap, width, maskBitmap=NIL:PTR TO bitmap) RETURNS success:BOOL
	DEF height, depth, numOfColours
	DEF datatypeObject:PTR TO INTUIOBJECT, bitmapheader:PTR TO bitmapheader,
	    colortable:ARRAY OF colorregister, colortable32:ARRAY OF ULONG, i, j
	DEF fhandle:BPTR
	#ifdef pe_TargetOS_AROS
		DEF dtb:pdtblitpixelarray, y, line:OWNS ARRAY OF UBYTE, rastport:rastport, temprp:rastport
	#endif
	
	datatypeObject := NIL
	success := FALSE
	
	->create datatype object of bitmap
	->width := GetBitMapAttr(bitmap, BMA_WIDTH)	->this does not always work, due to alignment requirements
	height := GetBitMapAttr(bitmap, BMA_HEIGHT)
	depth  := GetBitMapAttr(bitmap, BMA_DEPTH)
	numOfColours := IF depth <= 8 THEN 1 SHL depth ELSE 0
	
/*	->failed attempt to work-around messed-up saving on MorphOS
	#ifdef pe_TargetOS_MorphOS
		DEF scr:PTR TO screen, tempBitmap:PTR TO bitmap, tempMask:PTR TO bitmap, newWidth
	#endif
	#ifdef pe_TargetOS_MorphOS
		IF scr := LockPubScreen(NILA)
			->make a drawable clone of the bitmap (and mask)
			tempBitmap := cloneBitMap(bitmap, scr.rastport.bitmap, BMF_DISPLAYABLE)
			IF maskBitmap
				newWidth := GetBitMapAttr(tempBitmap, BMA_WIDTH)
				IF GetBitMapAttr(maskBitmap, BMA_WIDTH) <> newWidth
					->(mask width does not match drawable width) so create a mask which does
					tempMask := allocMaskBitMap(newWidth, height, /*noClear*/ TRUE)
					BltBitMap(maskBitmap,0,0, tempMask,0,0, newWidth,height, $c0, $ff, NIL)
				ENDIF
			ENDIF
			
			->save the drawable clone instead of the original (otherwise unmasked bitmaps look strange on MorphOS)
			bitmap := tempBitmap
			colormap := scr.viewport.colormap
			maskBitmap := tempMask
			
			UnlockPubScreen(NILA, scr) ; scr := NIL
		ENDIF
	#endif
	FINALLY
	#ifdef pe_TargetOS_MorphOS
		IF tempBitmap THEN freeBitMap(tempBitmap) ; tempBitmap := NIL
		IF tempMask   THEN freeBitMap(tempMask)   ;   tempMask := NIL
	#endif
*/
	
	datatypeObject := NewDTObjectA(NILA, [
		#ifndef pe_TargetOS_AROS
			DTA_GROUPID, GID_PICTURE, 
			PDTA_BITMAP, bitmap,
		#else
			DTA_BASENAME, 'png',
		#endif
		IF maskBitmap THEN PDTA_MASKPLANE ELSE TAG_IGNORE, IF maskBitmap THEN maskBitmap.planes[0] ELSE NIL,
		DTA_SOURCETYPE, DTST_RAM, 		->could use DTA_BASENAME or DTA_DATATYPE (along with DTWM_RAW instead of DTWM_IFF) to specify the the format to save in
		IF numOfColours THEN PDTA_NUMCOLORS ELSE PDTA_DESTMODE, IF numOfColours THEN numOfColours ELSE PMODE_V43, 
		->PDTA_MODEID, BestModeIDA([BIDTAG_NOMINALWIDTH,width, BIDTAG_NOMINALHEIGHT,height, BIDTAG_DEPTH,depth, TAG_END]:tagitem), 
		TAG_END]:tagitem)
	IF datatypeObject = NIL THEN RETURN
	
	GetDTAttrsA(datatypeObject, [PDTA_BITMAPHEADER,ADDRESSOF bitmapheader, TAG_END]:tagitem)
	IF bitmapheader = NIL THEN RETURN
	bitmapheader.width  := width  !!UINT
	bitmapheader.height := height !!UINT
	bitmapheader.depth  := depth  !!UBYTE
	
	#ifndef pe_TargetOS_AROS
		->(AmigaOS4 or MorphOS)
		bitmapheader.compression := CMPBYTERUN1		->CMPNONE or CMPBYTERUN1 or maybe CMPBYTERUN2
		bitmapheader.masking := IF maskBitmap THEN MSKHASMASK ELSE MSKNONE
		->bitmapheader.transparent := 0
	#else
		->write bitmap into datatype object
		NEW line[IF depth <= 8 THEN width ELSE 4*width]
		InitRastPort(rastport)
		rastport.bitmap := bitmap
		InitRastPort(temprp)
		temprp.layer := NIL
		IF depth <= 8 THEN temprp.bitmap := AllocBitMap(width, 1, depth, GetBitMapAttr(bitmap,BMA_FLAGS), bitmap)
		
		dtb.methodid := PDTM_WRITEPIXELARRAY
		dtb.pixeldata := line
		dtb.pixelformat   := IF depth <= 8 THEN PBPAFMT_LUT8 ELSE PBPAFMT_ARGB
		dtb.pixelarraymod := IF depth <= 8 THEN width        ELSE 4*width
		dtb.width  := width
		dtb.height := 1
		dtb.left   := 0
		->dtb.top
		
		FOR y := 0 TO height-1
			->read one line from bitmap
			IF depth <= 8
				ReadPixelLine8(rastport, 0, y, width, line, temprp)
			ELSE
				NATIVE {ReadPixelArray(} line {, 0, 0,} 4*width {,} rastport {, 0,} y {,} width {, 1, RECTFMT_ARGB)} ENDNATIVE
			ENDIF
			
			->write that line into datatype object
			dtb.top := y
			doMethodA(datatypeObject, dtb)
		ENDFOR
		
		IF temprp.bitmap THEN FreeBitMap(temprp.bitmap)
		END line
	#endif
	
	IF numOfColours
		GetDTAttrsA(datatypeObject, [PDTA_COLORREGISTERS,ADDRESSOF colortable, PDTA_CREGS,ADDRESSOF colortable32, PDTA_NUMCOLORS,ADDRESSOF numOfColours, TAG_END]:tagitem)
		IF (colortable <> NILA) AND (colortable32 <> NILA)
			->write colormap into color tables of datatype object
			GetRGB32(colormap, 0, numOfColours, colortable32)
			
			j := 0
			FOR i := 0 TO numOfColours-1
				colortable[i].red   := colortable32[j++] SHR 24 AND $FF !!UBYTE
				colortable[i].green := colortable32[j++] SHR 24 AND $FF !!UBYTE
				colortable[i].blue  := colortable32[j++] SHR 24 AND $FF !!UBYTE
			ENDFOR
		ENDIF
	ENDIF
	
	->write datatype object to file
	IF fhandle := Open(file, MODE_NEWFILE)
		IF DoDTMethodA(datatypeObject, NIL, NIL, [DTM_WRITE, NIL, fhandle, #ifndef pe_TargetOS_AROS DTWM_IFF #else DTWM_RAW #endif, NILA]:dtwrite) = 0
			->PrintFault(IoErr(), NILA)
			Close(fhandle) ; fhandle := NIL
			DeleteFile(file)
			RETURN
		ENDIF
	ENDIF
	
	success := TRUE
FINALLY
	IF datatypeObject
		#ifndef pe_TargetOS_AROS
			SetDTAttrsA(datatypeObject, NIL, NIL, [PDTA_BITMAP,NIL, TAG_END]:tagitem)
		#endif
		DisposeDTObject(datatypeObject)
	ENDIF
	IF fhandle THEN Close(fhandle)
ENDPROC
