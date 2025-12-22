/***********************************************************************
* This is example shows how to use p96AllocModeListTagList()
*
* tabt (Sat Dec 28 03:44:35 1996)
*
* converted by Martin <MarK> Kuchinka, 13.9.2001
***********************************************************************/

MODULE	'picasso96','libraries/picasso96'
MODULE	'exec/lists','utility/tagitem'

DEF	P96Base

PROC main()
	IF P96Base:=OpenLibrary(P96NAME,2)
		DEF	ml:PTR TO List
		DEFL	width=640,
				height=480,
				depth=8
		
		DEF	ra,array=[0,0,0,0]:L
		IF ra:=ReadArgs('Width=W/N,Height=H/N,Depth=D/N',array,NIL)
			IF array[0] THEN width :=^array[0]
			IF array[1] THEN height:=^array[1]
			IF array[2] THEN depth :=^array[2]
			FreeArgs(ra)
		ENDIF
	
		IF ml:=p96AllocModeListTags(
				P96MA_MinWidth,  width,
				P96MA_MinHeight, height,
				P96MA_MinDepth,  depth,
				TAG_DONE)
			DEF	mn:PTR TO P96Mode

			mn:=ml.Head
			WHILE mn.Node.Succ
				PrintF('%s\n',mn.Description)
				mn:=mn.Node.Succ
			ENDWHILE

			p96FreeModeList(ml)
		ENDIF
		CloseLibrary(P96Base)
	ENDIF
ENDPROC
