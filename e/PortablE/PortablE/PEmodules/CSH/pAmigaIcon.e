/* pAmigaIcon.e 06-02-2013
	A collection of useful procedures/wrappers for the Icon library.
	Copyright (c) 2010, 2011, 2012, 2013 Christopher Steven Handley ( http://cshandley.co.uk/email )
*/
OPT PREPROCESS
OPT POINTER	->for MorphOS
PUBLIC MODULE 'icon'
MODULE 'exec', 'dos'
MODULE 'intuition/imageclass', 'intuition/screens', 'utility/tagitem', 'workbench/icon', 'workbench/workbench'
MODULE 'wb'		->only used for "wbmessage"
MODULE 'icon'
MODULE 'CSH/pAmigaGraphics'
->for AmigaOS4 work-around
->MODULE 'CSH/pAmigaRTG'
->for MorphOS
MODULE 'intuition/intuition'
MODULE 'CSH/pAmigaRTG'

PROC new()
	iconbase := OpenLibrary('icon.library', 0)
ENDPROC

PROC end()
	CloseLibrary(iconbase)
ENDPROC

/*****************************/	->parse tooltypes (better than 'amigalib/argarray' as it handles being the tool of an icon)

PRIVATE
DEF cxlib_dobj:PTR TO diskobject
PUBLIC

PROC tooltypeArrayInit() RETURNS tooltype:ARRAY OF ARRAY OF CHAR
	DEF lock:BPTR, wbarg:PTR TO wbarg
	
	IF wbmessage
		wbarg := wbmessage.arglist[IF wbmessage.numargs > 1 THEN 1 ELSE 0]
		
		IF wbarg.lock THEN lock := CurrentDir(wbarg.lock)
		cxlib_dobj := GetDiskObject(wbarg.name)
		IF cxlib_dobj THEN tooltype := cxlib_dobj.tooltypes
	ENDIF
FINALLY
	IF lock THEN CurrentDir(lock)
ENDPROC

PROC tooltypeArrayDone()
	IF wbmessage
		FreeDiskObject(cxlib_dobj) ; cxlib_dobj := NIL
	ENDIF
ENDPROC

PROC tooltypeString(tooltype:ARRAY OF ARRAY OF CHAR, entry:ARRAY OF CHAR, default:ARRAY OF CHAR) RETURNS value:ARRAY OF CHAR
	DEF line:ARRAY OF CHAR
	
	value := default
	IF tooltype
		IF line := FindToolType(tooltype, entry) THEN value := line
	ENDIF
ENDPROC

PROC tooltypeInt(tooltype:ARRAY OF ARRAY OF CHAR, entry:ARRAY OF CHAR, default) RETURNS value
	DEF line:ARRAY OF CHAR, dva[1]:ARRAY OF VALUE
	
	IF tooltype
		dva[0] := default
		IF line := FindToolType(tooltype, entry) THEN StrToLong(line, dva)
		value := dva[0]
	ELSE
		value := default
	ENDIF
ENDPROC

PROC tooltypeSwitch(tooltype:ARRAY OF ARRAY OF CHAR, entry:ARRAY OF CHAR) RETURNS exists:BOOL
	IF tooltype
		exists := FindToolType(tooltype, entry) <> NILA
	ENDIF
ENDPROC

/*****************************/	->load icon bitmap

#ifndef pe_TargetOS_MorphOS
PROC loadIcon(filePath:ARRAY OF CHAR, screen:PTR TO screen, allowDefaultIcon=FALSE:BOOL) RETURNS bitmap:PTR TO bitmap, width, maskBitmap:PTR TO bitmap
	DEF icon:PTR TO diskobject
	
	->load icon
	IF iconbase = NIL THEN RETURN
	icon := GetIconTagList(filePath, [ICONGETA_FAILIFUNAVAILABLE,NOT allowDefaultIcon, ICONGETA_SCREEN,screen, /*ICONGETA_GETPALETTEMAPPEDICON,depth<=8,*/ TAG_END]:tagitem)
	->icon := GetDiskObject(filePath)
	
	IF icon
		bitmap, width, maskBitmap := icon2bitmap(icon, screen)
	ENDIF
FINALLY
	IF exception
		IF     bitmap THEN     freeBitMap(bitmap)
		IF maskBitmap THEN freeMaskBitMap(maskBitmap)
	ENDIF
	IF icon THEN FreeDiskObject(icon)
ENDPROC

PROC icon2bitmap(icon:PTR TO diskobject, screen:PTR TO screen) RETURNS bitmap:PTR TO bitmap, width, maskBitmap:PTR TO bitmap
	DEF depth, rp:rastport, rect:rectangle, height
	#ifdef pe_TargetOS_AmigaOS4
	DEF pixArray:OWNS ARRAY OF LONG, i
	#endif
	
	->obtain screen's depth
	depth := getBitMapDepth(screen.rastport.bitmap)
	
	->find size of icon
	InitRastPort(rp)
	GetIconRectangleA(rp, icon, NILA, rect, [ICONDRAWA_BORDERLESS,TRUE, TAG_END]:tagitem)
	width  := rect.maxx - rect.minx + 1
	height := rect.maxy - rect.miny + 1
	
	->create Amiga bitmap of icon
	bitmap := allocBitMap(width, height, depth, BMF_DISPLAYABLE OR BMF_CLEAR, screen.rastport.bitmap)
	rp.bitmap := bitmap
	->does not make a difference: SetRast(rp, 0)
	DrawIconStateA(rp, icon, NILA, -rect.minx, -rect.miny, IDS_NORMAL, [ICONDRAWA_BORDERLESS,TRUE, TAG_END]:tagitem)
	
	->work-around OS4 bug (where pixels of some colours randomly have a transparent alpha channel), which is obvious with certain small icons on a Sam440 (but not so obvious on an X1000)
	#ifdef pe_TargetOS_AmigaOS4
		NEW pixArray[i := width * height]
		rtgReadPixelArray(rp, 0,0, width-1,height-1, pixArray)
		WHILE (--i >= 0) DO pixArray[i] := pixArray[i] OR $FF000000
		rtgWritePixelArray(rp, 0,0, width-1,height-1, pixArray)
	#endif
	
	->extract mask (if any)
	/* -># this causes a corrupt IFF file to be created
	IconControlA(icon, [ICONCTRLA_GETIMAGEMASK1,ADDRESSOF maskPlane, TAG_END]:tagitem)
	
	mask := allocMaskBitMap(width, height)
	# copy maskPlane to mask.planes[0] probably via MemCopy()
	*/
FINALLY
	IF exception
		IF     bitmap THEN     freeBitMap(bitmap)
		IF maskBitmap THEN freeMaskBitMap(maskBitmap)
	ENDIF
	
	#ifdef pe_TargetOS_AmigaOS4
		END pixArray
	#endif
ENDPROC
#endif

#ifdef pe_TargetOS_MorphOS
CONST ICONGETA_PNGBITMAP        = ICONA_DUMMY + 256
CONST ICONGETA_PNGBITMAP_WIDTH  = ICONA_DUMMY + 257
CONST ICONGETA_PNGBITMAP_HEIGHT = ICONA_DUMMY + 258

PROC loadIcon(filePath:ARRAY OF CHAR, screen:PTR TO screen, allowDefaultIcon=FALSE:BOOL) RETURNS bitmap:PTR TO bitmap, width, maskBitmap:PTR TO bitmap
	DEF depth, icon:PTR TO diskobject, png:PTR TO bitmap, height, rp:rastport
	DEF image:PTR TO image, iBitmap:OWNS PTR TO bitmap, i, plane:PLANEPTR, bytesperrow
	
	->obtain screen's depth
	depth := getBitMapDepth(screen.rastport.bitmap)
	
	->load (PNG) icon
	IF iconbase = NIL THEN RETURN
	icon := GetIconTagList(filePath, [ICONGETA_PNGBITMAP,ADDRESSOF png, ICONGETA_PNGBITMAP_WIDTH,ADDRESSOF width, ICONGETA_PNGBITMAP_HEIGHT,ADDRESSOF height, TAG_END]:tagitem)
	
	->create Amiga bitmap of icon
	IF png
		IF rtgSupported() AND rtgAlphaSupported(depth)
			->(bitmap may have an alpha channel) so draw transparent bitmap over a blank background
			bitmap := allocBitMap(width, height, depth, BMF_DISPLAYABLE /*OR BMF_CLEAR*/, screen.rastport.bitmap)
			
			InitRastPort(rp)
			rp.bitmap := bitmap
			SetRast(rp, 0)
			
			rtgBltBitMapAlpha(png, 0,0, bitmap, 0,0, width,height)
		ELSE
			bitmap := cloneBitMap(png, screen.rastport.bitmap, BMF_DISPLAYABLE, 0,0, width,height)
		ENDIF
		
	ELSE IF icon
		image  := icon.gadget.gadgetrender !!PTR TO image
		IF (icon.gadget.flags AND GFLG_GADGHIMAGE <> 0) AND (image <> NIL)			->MOS doesn't use GFLG_GADGIMAGE for some reason
			->(icon's gadget is an Image gadget - although that should always be the case!)
->Print('#2; image.depth=\d\n', image.depth)
			IF image.depth <= 3
				width  := image.width
				height := image.height
				bytesperrow := (width+15/16)*2	->round-up to integer UINT widths for imagedata
				
				NEW iBitmap
				InitBitMap(iBitmap, image.depth, width !!UINT, height !!UINT)
				iBitmap.flags := BMF_STANDARD
				iBitmap.bytesperrow := bytesperrow !!UINT	->override whatever InitBitMap() assumes
				
				plane := image.imagedata !!PLANEPTR
				FOR i := 0 TO image.depth-1
					IF image.planepick AND (1 SHL i)
						iBitmap.planes[i] := plane
						plane := plane + (bytesperrow * height)		->move to next plane in the imagedata
					ELSE
						iBitmap.planes[i] := (IF image.planeonoff AND (1 SHL i) THEN -1 ELSE 0) !!VALUE!!PLANEPTR
					ENDIF
				ENDFOR
				
				->create a normal bitmap copy of iBitmap, which we can return
				bitmap := allocBitMap(width, height, depth, BMF_DISPLAYABLE /*OR BMF_CLEAR*/, screen.rastport.bitmap)
				BltBitMap(iBitmap, 0,0, bitmap, 0,0, width,height, $c0,$ff,NILA)
			ENDIF
		ENDIF
		
		/*	->this sneaky solution works on AmigaOS, but crashes the entire machine on MorphOS, so no use
		DEF win:PTR TO window
		icon.gadget.leftedge := 0
		icon.gadget. topedge := 0
		->icon.gadget.nextgadget := NIL
		
		width  := icon.gadget.width
		height := icon.gadget.height
		win := OpenWindowTagList(NIL, [
			WA_LEFT,0, WA_TOP,0,
			WA_INNERWIDTH, width, WA_INNERHEIGHT,height,
			WA_FLAGS,WFLG_SMART_REFRESH OR WFLG_BORDERLESS,
			WA_CUSTOMSCREEN,screen,
			WA_GADGETS,icon.gadget,
		TAG_END]:tagitem)
		bitmap := cloneBitMap(win.rport.bitmap, screen.rastport.bitmap, BMF_DISPLAYABLE, 0,0, width,height, win.rport)
		win := closeWindow(win)
		*/
	ENDIF
	
	allowDefaultIcon := 0	->dummy
FINALLY
	IF exception
		IF     bitmap THEN     freeBitMap(bitmap)
		IF maskBitmap THEN freeMaskBitMap(maskBitmap)
	ENDIF
	IF icon THEN FreeDiskObject(icon)
	
	END iBitmap
ENDPROC
#endif
