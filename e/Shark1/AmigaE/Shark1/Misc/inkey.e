MODULE 'devices/inputevent',
       'graphics/gfxbase',
       'graphics/rastport',
       'graphics/text',
       'intuition/intuition',
       'intuition/screens',
       'tools/cookRawkey',
       'tools/ctype'

DEF window:PTR TO window,asc,strasc,msg,code,qual,addr
PROC main()

IF warmupRawkeyCooker() THEN CleanUp(0)

window:=OpenW(10,10,100,50,IDCMP_RAWKEY,WFLG_ACTIVATE,'inkey -demo',0,1,0)

LOOP
msg:=WaitIMessage(window)
code:=MsgCode()
qual:=MsgQualifier()
addr:=MsgIaddr()

IF msg=IDCMP_RAWKEY
		asc:=cookRawkey(code,qual,addr)
		TextF(20,30,'Char=\c',asc)
		StringF(strasc,'\c',asc)
	IF StrCmp(strasc,'Q') THEN JUMP end
ENDIF

ENDLOOP

end:
shutdownRawkeyCooker()
CloseW(window)
ENDPROC