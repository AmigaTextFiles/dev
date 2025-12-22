/**********************************************************************************
* This is example shows how to use p96BestModeIDTagList()
*
* Translated to E language by: Jean-Marie COAT (23.06.2006) <agalliance@wanadoo.fr>
*
***********************************************************************************/
OPT PREPROCESS

MODULE	'utility/tagitem',
	'graphics/modeid',
	'libraries/picasso96',
	'picasso96API'

ENUM ER_NONE, ER_NP96

PROC main() HANDLE
DEF	displayid:PTR TO LONG,
	width:LONG,
	height:LONG,
	depth:LONG,
	tags,
	fmtstrings[RGBFB_MaxFormats]:ARRAY OF LONG

	IF (p96base := OpenLibrary(P96NAME, 2)) = NIL THEN Raise(ER_NP96)

	height:=1024
	depth:=32
	width:=1280

	fmtstrings:=['RGBFB_NONE',
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
	'RGBFB_B5G5R5PC',
	NIL]

	tags :=[P96BIDTAG_NominalWidth, width,
		P96BIDTAG_NominalHeight, height,
		P96BIDTAG_Depth, depth,
		P96BIDTAG_FormatsForbidden, RGBFF_R5G5B5 AND RGBFF_R5G5B5PC AND RGBFF_B5G5R5PC,
		TAG_DONE]: tagitem

	displayid:=p96bestmodeidtaglist(tags)

	IF (displayid)
		WriteF('DisplayID: \t\h\n', displayid)
		IF (displayid <> INVALID_ID)
			WriteF('Width: \t\t\d\n', 	p96getmodeidattr(displayid, P96IDA_WIDTH))
			WriteF('Height: \t\d\n', 	p96getmodeidattr(displayid, P96IDA_HEIGHT))
			WriteF('Depth: \t\t\d\n', 	p96getmodeidattr(displayid, P96IDA_DEPTH))
			WriteF('BytesPerPixel: \t\d\n', p96getmodeidattr(displayid, P96IDA_BYTESPERPIXEL))
			WriteF('BitsPerPixel: \t\d\n', 	p96getmodeidattr(displayid, P96IDA_BITSPERPIXEL))
			WriteF('RGBFormat: \t\s\n', 	fmtstrings[p96getmodeidattr(displayid,P96IDA_RGBFORMAT)])
			WriteF('Is P96: \t\s\n', 	IF (p96getmodeidattr(displayid, P96IDA_ISP96) ) THEN 'yes' ELSE 'no')
		ENDIF
		
	ENDIF
EXCEPT DO
   SELECT exception
	CASE ER_NP96
		WriteF('Library \s no found!\n',P96NAME)
  ENDSELECT
  IF p96base THEN CloseLibrary(p96base)
  IF exception THEN CleanUp(20)

ENDPROC 0
