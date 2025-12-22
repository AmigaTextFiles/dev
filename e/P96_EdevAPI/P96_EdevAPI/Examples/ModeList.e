/**********************************************************************************
* This is example shows how to use p96AllocModeListTagList()
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
	'libraries/picasso96',
	'picasso96API'

ENUM ER_NONE, ER_NP96

PROC main() HANDLE
DEF	ml:PTR TO lh, width=640, height=480, depth=8, mn:PTR TO p96Mode

	IF (p96base := OpenLibrary(P96NAME, 2)) = NIL THEN Raise(ER_NP96)

	IF(ml:=p96allocmodelisttaglist([P96MA_MinWidth, width,
				P96MA_MinHeight, height,
				P96MA_MinDepth, depth,
				TAG_DONE]))

		mn:=ml.head
		WHILE mn
			IF mn.ln.succ<>0
				WriteF('\s\n',mn.description)
			ENDIF
	 		mn:=mn.ln.succ
  		ENDWHILE

		p96freemodelist(ml)
	ENDIF
EXCEPT DO
   SELECT exception
	CASE ER_NP96
		WriteF('Library \s no found!\n',P96NAME)
  ENDSELECT
  IF p96base THEN CloseLibrary(p96base)
  IF exception THEN CleanUp(20)

ENDPROC 0
