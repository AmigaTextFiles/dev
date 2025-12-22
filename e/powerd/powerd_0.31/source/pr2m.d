/* 30.9.1999 v1.0 first initial release
** 9.12.2001 v1.1 translated to PowerD, fixed a string (reported by DMX)
*/

PROC main()
	DEF	args:PTR TO LONG,ra,
			name[256]:STRING,dest[256]:STRING,
			src:PTR TO CHAR,l,f=NIL
	args:=['diskfont',NIL]:LONG
	IF ra:=ReadArgs('SOURCE/A,SASC/S',args,NIL)
		IF args[1]
			StringF(name,'\s_pragmas.h',args[0])
		ELSE
			StringF(name,'\s_lib.h',args[0])
		ENDIF
		StringF(dest,'\s.m',args[0])
		IF (l:=FileLength(name))>0
			IF src:=New(l)
				IF f:=Open(name,OLDFILE)
					Read(f,src,l)
					Close(f)
				ELSE
					PrintFault(IOErr(),'pr2m')
				ENDIF
				IF f
					IF f:=Open(dest,NEWFILE)
						IF args[1] THEN ConvertSASC(f,src,l) ELSE Convert(f,src,l)
						VFPrintF(f,'\n',NIL)
						Close(f)
					ELSE
						PrintFault(IOErr(),'pr2m')
					ENDIF
				ENDIF
				Dispose(src)
			ENDIF
		ELSE
			PrintFault(IOErr(),'pr2m')
		ENDIF
		FreeArgs(ra)
	ELSE
		PrintFault(IOErr(),'pr2m')
	ENDIF
ENDPROC

PROC Convert(f,src:PTR TO CHAR,l)
	DEF	p=0,type,head=FALSE,name[256]:STRING,offset,i
	WHILE p<l
		WHILE src[p]<>"#"
			p++
			IF p>=l THEN RETURN
			IF CtrlC() THEN RETURN
		ENDWHILE
		IF StrCmp('#pragma',src+p,7)
			p:=Skip(src,p+7,l)
			p:=GetName(name,src,p,l)
			IF StrCmp('amicall',name)
				type:="AMIC"
			ELSEIF StrCmp('tagcall',name)
				type:="TAGC"
			ELSE
				PrintF('Only amicall and tagcall allowed (\s).\n',name)
				RETURN
			ENDIF
			IF type
				p:=Skip(src,p,l)
				IF src[p]="("
					p:=Skip(src,p+1,l)
					p:=GetName(name,src,p,l)
					IF head=FALSE
						VFPrintF(f,'LIBRARY \s\n',[name])
						head:=TRUE
					ELSE
						VFPrintF(f,',\n',NIL)
					ENDIF
				ELSE
					PrintF('"(" expected.\n')
					RETURN
				ENDIF

				p:=Skip(src,p,l)
				IF src[p]=","
					p:=Skip(src,p+1,l)
					p:=GetName(name,src,p,l)
					IF (name[0]="0") AND (name[1]="x")
						name[0]:=" "
						name[1]:="$"
						offset:=Val(name)
					ELSE
						PrintF('"0x" expected.\n')
						RETURN
					ENDIF
				ELSE
					PrintF('"," expected.\n')
					RETURN
				ENDIF

				p:=Skip(src,p,l)
				IF src[p]=","
					p:=Skip(src,p+1,l)
					p:=GetName(name,src,p,l)
					VFPrintF(f,'\t\s',[name])
					i:=0
					WHILE src[p]<>")"
						name[i]:=src[p]
						IF p>=l THEN RETURN
						IF CtrlC() THEN RETURN
						i++
						p++
					ENDWHILE
					name[i]:="\0"
					VFPrintF(f,'\s',[name])
					IF type="AMIC"
						VFPrintF(f,')',NIL)
					ELSEIF type="TAGC"
						VFPrintF(f,':LIST OF TagItem)',NIL)
					ENDIF
				ELSE
					PrintF('"," expected.\n')
					RETURN
				ENDIF

				VFPrintF(f,'(d0)=-\d',[offset])
			ENDIF
		ELSE
			p++
		ENDIF
	EXITIF CtrlC()
	ENDWHILE
ENDPROC

PROC ConvertSASC(f,src:PTR TO CHAR,l)
	DEF	p=0,type,head=FALSE,name[256]:STRING,offset,i,num[16]:STRING,n
	WHILE p<l
		WHILE src[p]<>"#"
			p++
			IF p>=l THEN RETURN
			IF CtrlC() THEN RETURN
		ENDWHILE
		IF StrCmp('#pragma',src+p,7)
			p:=Skip(src,p+7,l)
			p:=GetName(name,src,p,l)
			IF StrCmp('libcall',name)
				type:="LIBC"
			ELSEIF StrCmp('tagcall',name)
				type:="TAGC"
			ELSE
				PrintF('Only libcall and tagcall allowed (\s).\n',name)
				RETURN
			ENDIF
			IF type
				p:=Skip(src,p,l)						-> read base
				p:=GetName(name,src,p,l)
				IF head=FALSE
					VFPrintF(f,'LIBRARY \s\n',[name])
					head:=TRUE
				ELSE
					VFPrintF(f,',\n',NIL)
				ENDIF

				p:=Skip(src,p,l)						-> read function name
				p:=GetName(name,src,p,l)
				VFPrintF(f,'\t\s(',[name])
				IF name[StrLen(name)-1]="A" THEN type:="TAGL"

				p:=Skip(src,p,l)						-> read function offset
				p:=GetName(name,src,p,l)
				StringF(num,'$\s',name)
				offset:=Val(num)

				p:=Skip(src,p,l)						-> read arguments
				p:=GetName(name,src,p,l)
				i:=StrLen(name)-3
				WHILE i>=0
					n:=name[i]
					StringF(num,'$\c',n)
					n:=Val(num)
					IF (n>=0) AND (n<=7)  THEN VFPrintF(f,'d\d',[n])
					IF (n>=8) AND (n<=15) THEN VFPrintF(f,'a\d',[n-8])
					i--
					IF CtrlC() THEN RETURN
				EXITIF i<0
					VFPrintF(f,',',NIL)
				ENDWHILE
				IF type="LIBC"
					VFPrintF(f,')',NIL)
				ELSEIF type="TAGL"
					VFPrintF(f,':PTR TO TagItem)',NIL)
				ELSEIF type="TAGC"
					VFPrintF(f,':LIST OF TagItem)',NIL)
				ENDIF

				VFPrintF(f,'(d0)=-\d',[offset])
			ENDIF
		ELSE
			p++
		ENDIF
	EXITIF CtrlC()
	ENDWHILE
ENDPROC

PROC Skip(src:PTR TO CHAR,p,l)(L)
	WHILE (src[p]=" ") OR (src[p]="\t")
		p++
		IF p>=l THEN RETURN l
		IF CtrlC() THEN RETURN l
	ENDWHILE
ENDPROC p

PROC GetName(dst:PTR TO CHAR,src:PTR TO CHAR,p,l)(L)
	DEF	i=0
	WHILE ((src[p]>="A") AND (src[p]<="Z")) OR ((src[p]>="a") AND (src[p]<="z")) OR ((src[p]>="0") AND (src[p]<="9")) OR (src[p]="_")
		dst[i]:=src[p]
		IF p>=l THEN RETURN l
		IF CtrlC() THEN RETURN l
		i++
		p++
	ENDWHILE
	dst[i]:="\0"
ENDPROC p

CHAR '\n\n$VER:pr2m v1.1 by MarK (9.12.2001)\0\n\n'
