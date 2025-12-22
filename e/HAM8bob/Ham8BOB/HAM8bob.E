MODULE	'graphics/gfx','graphics/rastport','graphics/modeid',
	'hardware/blit',
	'intuition/screens','intuition/intuition',
	'tools/ilbm','tools/ilbmdefs'

ENUM ERR_NONE,ERR_MEM,ERR_SCREEN,ERR_LIB,ERR_FILE,ERR_PIC

CONST NULL=0,TAG_END=0

RAISE ERR_MEM  IF AllocMem()=NIL
RAISE ERR_MEM  IF AllocBitMap()=NIL
RAISE ERR_LIB  IF OpenLibrary()=NIL

DEF s:PTR TO screen
DEF back:PTR TO bitmap, base:PTR TO bitmap, bob:PTR TO bitmap, maskbmp:PTR TO bitmap, rembmp:PTR TO bitmap
DEF base6:bitmap,pl1:PTR TO LONG,pl2:PTR TO LONG, mask, rem

PROC main() HANDLE
        DEF iff=0,i

	request('Yo!','Demo will size machine for a while.\nFinish all disk activity.')

	IF (s:=OpenScreenTagList(0,[	SA_DEPTH, 8,
					SA_DISPLAYID, HAM_KEY,
					SA_TITLE, 'LMB to exit',
					TAG_END]))=0
		Raise(ERR_SCREEN)
	ENDIF

	iff:=newpic('back.h8',ILBMNF_COLOURS32) -> Background to screen
	loadpic(iff,[ILBML_SCREEN, s, TAG_END])
	ilbm_Dispose(iff)

	
	-> Silly bug doesn't let you do two loadpic's from one newpic

	iff:=newpic('back.h8',ILBMNF_COLOURS32) -> Background 2 mem
	loadpic(iff,[ILBML_GETBITMAP, {back}, TAG_END])
        ilbm_Dispose(iff)

	-> Set up a faked 6 plane bitmap to load 64 color background into.
	-> The bitmap really is 8 planes, with the two top planes all zero.
	-> This way, you can blit straight into the ham8 pic (color 32
	-> becomes 'set base color 32').

	base:=AllocBitMap(320,256,8,BMF_CLEAR,0)
	base6.bytesperrow:=base.bytesperrow
	base6.rows:=base.rows
	base6.flags:=base.flags
	base6.depth:=6
	pl1:=base6.planes
	pl2:=base.planes
	FOR i:=0 TO 5
		pl1[i]:=pl2[i]
	ENDFOR
	
	
	iff:=newpic('back.64',ILBMNF_COLOURS32) -> 64 color version, same colors
	loadpic(iff,[ILBML_BITMAP, base6, TAG_END])
        ilbm_Dispose(iff)
        
	iff:=newpic('bob.h8',ILBMNF_COLOURS32) -> the bob
	loadpic(iff,[ILBML_GETBITMAP, {bob}, TAG_END])
	ilbm_Dispose(iff)

	iff:=newpic('bob.mask',ILBMNF_COLOURS4) -> its mask
	loadpic(iff,[ILBML_GETBITMAP, {maskbmp}, TAG_END])
	ilbm_Dispose(iff)

	mask:=maskbmp.planes
	mask:=^mask

	iff:=newpic('bob.rem',ILBMNF_COLOURS32) -> right edge mask
	loadpic(iff,[ILBML_GETBITMAP, {rembmp}, TAG_END])
	ilbm_Dispose(iff)
	iff:=0
	
	rem:=rembmp.planes
	rem:=^rem

        bounceBob()

        Raise(ERR_NONE)

EXCEPT
        SELECT exception
        CASE ERR_NONE
	CASE ERR_FILE
		request('Bug','Can''t find file')
        CASE ERR_MEM
                request('Bug','Out of memory')
        CASE ERR_SCREEN
                request('Bug','Screen allocation failed')
        CASE ERR_LIB
                request('Bug','OpenLibrary() failed')
	CASE ERR_PIC
		request('Bug','Couldn''t load one of the pictures')
        DEFAULT
                request('Bug','Unknown error (!?)')
        ENDSELECT

        IF s THEN CloseScreen(s)
        IF iff THEN ilbm_Dispose(iff)
	IF back THEN ilbm_FreeBitMap(back)
	IF base THEN ilbm_FreeBitMap(base)
	IF bob  THEN ilbm_FreeBitMap(bob)
	IF mask THEN ilbm_FreeBitMap(mask)
	IF rem  THEN ilbm_FreeBitMap(rem)

        CleanUp(exception)
ENDPROC


PROC request(title,messy) IS EasyRequestArgs(0,[20,0,title,messy,'OK'],0,0)

PROC newpic(a,b)
	DEF retval

	IF (retval:=ilbm_New(a,b))=NIL THEN Raise(ERR_FILE)
ENDPROC retval

PROC loadpic(a,b)
	DEF retval

	IF (retval:=ilbm_LoadPicture(a,b))<>0 THEN Raise(ERR_PIC)
ENDPROC retval

PROC bounceBob()
	DEF x=100,y=100,vx=3,vy=2
	
	Disable()
	REPEAT
		killbob(x,y)
		x:=x+vx
		y:=y+vy
		IF x<10  THEN vx:=-vx
		IF x>285 THEN vx:=-vx
		IF y<90  THEN vy:=-vy
		IF y>220 THEN vy:=-vy
		drawbob(x,y)
		REPEAT
		UNTIL Mouse()<>1
		WaitBOVP(s.viewport) -> I know this is horrible, but I'm busywaiting anyways...
	UNTIL Mouse()=2
	Enable()
ENDPROC

PROC drawbob(x,y)
	DEF mt
	
	mt:=ABC+ABNC+ANBC

	-> Blit bob through mask
	BltMaskBitMapRastPort(bob ,0,0,s.rastport,x,y,32,32,mt,mask)

	-> Blit 64-color background through right edge mask
	BltMaskBitMapRastPort(base,0,0,s.rastport,x,y,32,32,mt,rem)
ENDPROC

PROC killbob(x,y)
	BltBitMapRastPort(back,x,y,s.rastport,x,y,32,32,ABC+ABNC)
ENDPROC
