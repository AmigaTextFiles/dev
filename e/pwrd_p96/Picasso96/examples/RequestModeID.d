/***********************************************************************
* This is example shows how to use p96RequestModeIDTagList()
*
* tabt (Sat Dec 28 03:44:35 1996)
*
* Converted by Martin <MarK> Kuchinka, 13.9.2001
***********************************************************************/

MODULE	'picasso96','libraries/picasso96'
MODULE	'graphics/displayinfo','utility/tagitem','graphics/modeid'

DEF	P96Base

PROC main()
	IF P96Base:=OpenLibrary(P96NAME,2)
		DEFUL	DisplayID
		DEFL	width=640,
				height=480,
				depth=15

		DEF	ra,array=[0,0,0,0]:L
		IF ra=ReadArgs('Width=W/N,Height=H/N,Depth=D/N',array,NIL)
			IF array[0] THEN width :=^array[0]
			IF array[1] THEN height:=^array[1]
			IF array[2] THEN depth :=^array[2]
			FreeArgs(ra)
		ENDIF
	
		IF DisplayID:=p96RequestModeIDTags(
										P96MA_MinWidth,       width,
										P96MA_MinHeight,      height,
										P96MA_MinDepth,       depth,
										P96MA_WindowTitle,   'RequestModeID Test',
										P96MA_FormatsAllowed, RGBFF_CLUT|RGBFF_R5G6B5|RGBFF_R8G8B8|RGBFF_A8R8G8B8,
										TAG_DONE)
			PrintF('DisplayID: %lx\n', DisplayID)
			IF DisplayID<>INVALID_ID
				DEF	dim:DimensionInfo
				IF GetDisplayInfoData(NIL,dim,SIZEOF_DimensionInfo,DTAG_DIMS,DisplayID) THEN
					PrintF('Dimensions: %ldx%ldx%ld\n',dim.Nominal.MaxX-dim.Nominal.MinX+1,dim.Nominal.MaxY-dim.Nominal.MinY+1,dim.MaxDepth)
			ENDIF
		ENDIF
		CloseLibrary(P96Base)
	ENDIF
ENDPROC
