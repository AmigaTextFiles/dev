/***********************************************************************
* This is example shows how to use p96BestModeIDTagList()
*
* tabt (Mon Aug 28 14:07:40 1995)
*
* converted by Martin <MarK> Kuchinka, 13.9.2001
***********************************************************************/

MODULE	'picasso96','libraries/picasso96','graphics/modeid'

DEF	fmts[RGBFB_MaxFormats]=[
		'RGBFB_NONE',
		'RGBFB_CLUT',
		'RGBFB_R8G8B8',
		'RGBFB_B8G8R8',
		'RGBFB_R5G6B5PC',
		'RGBFB_R5G5B5PC',
		'RGBFB_A8R8G8B8',
		'RGBFB_A8B8G8R8',
		'RGBFB_R8G8B8A8',
		'RGBFB_B8G8R8A8',
		'RGBFB_R5G6B5',
		'RGBFB_R5G5B5',
		'RGBFB_B5G6R5PC',
		'RGBFB_B5G5R5PC'
	]:PTR

DEF	P96Base

PROC main()
	IF P96Base:=OpenLibrary(P96NAME,2)
		DEFUL	DisplayID
		DEFL	width=640,
				height=480,
				depth=24

		DEF	ra,array=[0,0,0,0]:L
		IF ra:=ReadArgs('Width=W/N,Height=H/N,Depth=D/N',array,NIL)
			IF array[0] THEN width :=^array[0]
			IF array[1] THEN height:=^array[1]
			IF array[2] THEN depth :=^array[2]
			FreeArgs(ra)
		ENDIF

		IF DisplayID:=p96BestModeIDTags(
										P96BIDTAG_NominalWidth,     width,
										P96BIDTAG_NominalHeight,    height,
										P96BIDTAG_Depth,            depth,
										P96BIDTAG_FormatsForbidden, RGBFF_R5G5B5|RGBFF_R5G5B5PC|RGBFF_B5G5R5PC,
										TAG_DONE)
			PrintF('DisplayID: $\h\n', DisplayID)
			IF DisplayID<>INVALID_ID
				PrintF('Width: %ld\n',         p96GetModeIDAttr(DisplayID, P96IDA_WIDTH))
				PrintF('Height: %ld\n',        p96GetModeIDAttr(DisplayID, P96IDA_HEIGHT))
				PrintF('Depth: %ld\n',         p96GetModeIDAttr(DisplayID, P96IDA_DEPTH))
				PrintF('BytesPerPixel: %ld\n', p96GetModeIDAttr(DisplayID, P96IDA_BYTESPERPIXEL))
				PrintF('BitsPerPixel: %ld\n',  p96GetModeIDAttr(DisplayID, P96IDA_BITSPERPIXEL))
				PrintF('RGBFormat: %s\n', fmts[p96GetModeIDAttr(DisplayID, P96IDA_RGBFORMAT)])
				PrintF('Is P96: %s\n',      IF p96GetModeIDAttr(DisplayID, P96IDA_ISP96) THEN 'yes' ELSE 'no')
			ENDIF
		ENDIF
		CloseLibrary(P96Base)
	ELSE PrintF('Unable to open picasso69api.library v2+\n')
ENDPROC
