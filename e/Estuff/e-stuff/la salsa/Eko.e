MODULE 'intuition/intuition', 'intuition/intuitionbase',
'graphics/gfxbase', 'graphics/text', 'tools/ctype',
'tools/async', 'dos/dos'

DEF myargs[30]:LIST, width, height, delaytime
DEF hexno, ctrl, colour, c[10]:STRING

PROC main()
	DEF rdargs, strings[200]:STRING, template, i
	DEF result=0
	IF KickVersion(37)
		WriteF('\b')  -> this line just makes sure that stdout is valid,and that I won't crash the computer
		FOR i:=0 TO 19 DO myargs[i]:=0
		findconsoledimensions()
		template:='FILE/A,BOLD/S,ITALIC/S,UNDERLINED/S,NORMAL/S,SLOW/S,CENTRE/S,RIGHT/S,FORE/K/N,BACK/K/N,ALLBACK/K/N,CLS/S,DELAY/K/N,SCROLLUP/S,SCROLLDOWN/S,WIDTH/K/N,HEIGHT/K/N,STRING/S,HEX/S,BEEP/S,WAIT/S'
		IF (rdargs:=ReadArgs(template,myargs,NIL))
			IF myargs[15] THEN width:=Long(myargs[15])
			IF myargs[16] THEN height:=Long(myargs[16])
			delaytime:=4
			IF myargs[12] THEN delaytime:=Long(myargs[12])
			IF myargs[11]=TRUE
				StringF(i,'\c', 12)
				Write(stdout,i,1)
			ENDIF
			IF myargs[13]=-1
				FOR i:=0 TO height*2+2
					Write(stdout,'\eE',2)
				ENDFOR
			ENDIF
			IF myargs[14]=-1
				FOR i:=0 TO height*2+2
					Write(stdout,'\eM',2)
				ENDFOR
			ENDIF
			IF myargs[19]=-1
				StringF(i,'\c', 7)
				Write(stdout,i,1)
			ENDIF
			StrCopy(strings,myargs[0])
			dostring('')
			IF myargs[8]
				colour:=Long(myargs[8])
				StringF(c,'\e[\dm', colour+30)
				IF (colour>-1) AND (colour<8) THEN Write(stdout,c,5)
			ENDIF
			IF myargs[9]
				colour:=Long(myargs[9])
				StringF(c,'\e[\dm', colour+40)
				IF (colour>-1) AND (colour<8) THEN Write(stdout,c,5)
			ENDIF
			IF myargs[10]
				colour:=Long(myargs[10])
				StringF(c,'\e[>\dm', colour)
				IF (colour>-1) AND (colour<8) THEN Write(stdout,c,5)
			ENDIF
			IF myargs[1]=-1 THEN Write(stdout,'\e[1m',4)
			IF myargs[2]=-1 THEN Write(stdout,'\e[3m',4)
			IF myargs[3]=-1 THEN Write(stdout,'\e[4m',4)
			IF myargs[4]=-1 THEN Write(stdout,'\e[0m',4)
			IF (myargs[17]=0) OR (myargs[18])
				IF (myargs[18])
					result:=hexfile(strings)
				ELSE
					result:=dofile(strings)
				ENDIF
				IF result=0
					IF (strings[0]<>0) AND (strings[0]<>12) AND (strings[0]<>7) THEN WriteF('Error opening file!\n')
				ENDIF
			ELSE
				dostring(strings)
			ENDIF
			IF StrLen(strings)>0 THEN Write(stdout,'\n',1)
			FreeArgs(rdargs)
		ENDIF
	ENDIF
ENDPROC

PROC dostring(string:PTR TO CHAR)
	DEF i,strlength
	strlength:=StrLen(string)
	IF (myargs[6]=-1) AND (myargs[7]<>-1) THEN mid(strlength,0)
	IF (myargs[7]=-1) AND (myargs[6]<>-1) THEN mid(strlength,1)
	IF myargs[0]
		IF myargs[5]=-1
			FOR i:=0 TO strlength-1
				Delay(delaytime)
				StringF(c,'\c', string[i])
				Write(stdout,c,1)
			ENDFOR
		ELSE
			Write(stdout,string,strlength)
		ENDIF
	ENDIF
ENDPROC

PROC str2hex(string,stringlength)
	DEF i, o, string2[200]:STRING
	DEF spaces
	StringF(string2,'\z\h[4]: ', hexno)
	FOR i:=0 TO IF stringlength/4<>4 THEN stringlength/4 ELSE 3
		FOR o:=0 TO IF stringlength-(4*i)<4 THEN stringlength-(4*i)-1 ELSE 3
			StringF(string2,'\s\z\h[2]', string2, string[4*i+o])
		ENDFOR
		StrAdd(string2,' ')
	ENDFOR
	spaces:=(-9*i)+(-2*o)+43
	FOR i:=0 TO spaces
		StrAdd(string2,' ')
	ENDFOR
	StrAdd(string2,'   ')
	FOR i:=0 TO stringlength-1
		IF isprint(string[i]) THEN StringF(string2,'\s\c', string2,string[i]) ELSE StrAdd(string2,'.')
	ENDFOR
	spaces:=16-i
	FOR i:=0 TO spaces
		StrAdd(string2,' ')
	ENDFOR
	StrAdd(string2,'\n')
	dostring(string2)
	hexno:=hexno+16
ENDPROC

PROC mid(length,where)
	DEF i, string2[200]:STRING
	StrCopy(string2,'')
	FOR i:=0 TO IF where=1 THEN (width-length) ELSE (width/2-(length/2))
		StrAdd(string2,' ')
	ENDFOR
	Write(stdout,string2,i)
ENDPROC

PROC dofile(file:PTR TO CHAR)
	DEF fh, string[200]:ARRAY OF CHAR
	DEF gonedown=0
	IF (fh:=as_Open(file,MODE_OLDFILE,3,5120))
		WHILE (as_FGetS(fh,string,width)) AND ((ctrl:=CtrlC())=FALSE)
			IF myargs[20]=-1
				IF gonedown=(height-1)
					gonedown:=0
					waitforreturn()
				ENDIF
				dostring(string)
				gonedown++
			ELSE
				dostring(string)
			ENDIF
		ENDWHILE
		as_Close(fh)
		IF ctrl THEN WriteF('\nBreak!\n')
	ENDIF
ENDPROC fh

PROC hexfile(file:PTR TO CHAR)
	DEF fh, string[200]:ARRAY OF CHAR, read_in
	DEF gonedown=0
	IF (fh:=as_Open(file,OLDFILE,3,5120))
		WHILE (read_in:=as_Read(fh,string,16)) AND ((ctrl:=CtrlC())=FALSE)
			IF myargs[20]=-1
				IF gonedown=(height-1)
					gonedown:=0
					waitforreturn()
				ENDIF
				str2hex(string,read_in)
				gonedown++
			ELSE
				str2hex(string,read_in)
			ENDIF
		ENDWHILE
		as_Close(fh)
		IF ctrl THEN WriteF('\nBreak!\n')
	ENDIF
ENDPROC fh

PROC waitforreturn()
	DEF nill[200]:STRING
	WriteF('Press \e[30m\e[42mRETURN\e[31m\e[40m...')
	ReadStr(IF stdin THEN stdin ELSE stdout,nill)
	WriteF('\eM               \b')
ENDPROC

PROC findconsoledimensions()
	DEF ib:PTR TO intuitionbase, gb:PTR TO gfxbase, fw, w, fh, h
	ib:=intuitionbase
	gb:=gfxbase
	Forbid()
	w:=ib.activewindow.width
	h:=ib.activewindow.height
	fw:=gb.defaultfont.xsize
	fh:=gb.defaultfont.ysize
	Permit()
	width:=Bounds(w-24/fw,5,250)-1
	height:=Bounds(h-24/fh,5,250)
ENDPROC

vers:       CHAR 0,'$VER: Eko v4.1',0
