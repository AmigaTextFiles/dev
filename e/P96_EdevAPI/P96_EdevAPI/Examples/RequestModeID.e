/***********************************************************************
* This is example shows how to use p96RequestModeIDTagList()
*
* Translated to E language by: Jean-Marie COAT (23.06.2006) <agalliance@wanadoo.fr>
*
***********************************************************************************/

OPT PREPROCESS

MODULE 'dos', 'dos/dos',
	'exec/types',
	'exec/lists',
	'exec/nodes',
	'utility/tagitem',
	'graphics/modeid',
	'graphics/displayinfo',
	'graphics/gfx',
	'graphics/gfxbase',
	'libraries/picasso96',
	'picasso96API'

ENUM ER_NONE, ER_NP96, ER_GFX

PROC main() HANDLE
DEF	displayid:PTR TO LONG,
	dwidth:LONG,
	dheight:LONG,
	ddepth:LONG,
	dim:PTR TO dimensioninfo, tags
 

	IF (p96base := OpenLibrary(P96NAME, 2)) = NIL THEN Raise(ER_NP96)
	IF (gfxbase := OpenLibrary(GRAPHICSNAME, 0)) = NIL THEN Raise(ER_GFX)

	dheight:=480
	ddepth:=15
	dwidth:=640

	tags := [P96MA_MinWidth, dwidth,
	 	 P96MA_MinHeight, dheight,
		 P96MA_MinDepth, ddepth,
		 P96MA_WindowTitle, 'RequestModeID Test',
		 P96MA_FormatsAllowed, (RGBFF_HICOLOR OR RGBFF_TRUECOLOR OR RGBFF_TRUEALPHA),
		 -> P96MA_FormatsAllowed, $FFFF,
		 TAG_DONE]: tagitem

	displayid := p96requestmodeidtaglist(tags)

	IF (displayid <> -1)
		WriteF('\e[1mP96RequestModeidTagList: \e[0m\nDisplayID: \e[32m\h \e[0m\n', displayid)
		IF(displayid <> INVALID_ID)
			IF(GetDisplayInfoData(NIL,dim, SIZEOF rectangle + 26, DTAG_DIMS, displayid))
				/* dim.nominal = 26 bytes
				** OBJECT dimensioninfo: nominal = (  26)   nominal:rectangle (or ARRAY OF rectangle)
				*/
				WriteF('Dimensions: \e[32m\d\e[31mx\e[32m\d\e[31mx\e[32m\d \e[0m\n',
					(dim.nominal.maxx-dim.nominal.minx+1), (dim.nominal.maxy-dim.nominal.miny+1), dim.maxdepth)
			ENDIF
		ENDIF
	ELSE
		WriteF('Canceled by user!\n')
	ENDIF
EXCEPT DO
   SELECT exception
	CASE ER_NP96
		WriteF('Library \s no found!\n',P96NAME)
	CASE ER_GFX
		WriteF('Graphics.library not opened!\n')
  ENDSELECT
  IF gfxbase THEN CloseLibrary(gfxbase)
  IF p96base THEN CloseLibrary(p96base)
  IF exception THEN CleanUp(20)

ENDPROC 0
