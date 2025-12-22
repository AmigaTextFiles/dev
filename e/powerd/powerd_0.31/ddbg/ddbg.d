/*
** ddbg - PowerD programming language debugger by MarK
**
** history:
** 16.6.2002 v0.1: first working release
** 23.6.2002 v0.2: improved by MarK
**   - added the step-over ability
** 18.8.2002 v0.3: improved by MarK
**   - tracing routine speedup
**   - improved variable viewer
**   - some enforcer hits removed
** 25.1.2003 v0.4: improved by MarK
**   - debugging speedup
**   - fields are now shown better
** 30.3.2003 v0.5: improves by MarK
**   - crash fixes
**   - source/register/variable window contains scroller gadgets!!!
*/

MODULE	'exec/memory'

CONST	VER=0,
		REV=20,
		MAXVER=VER<<16|REV

RAISE	"^C" IF CtrlC()=TRUE

DEF	pool=NIL,exe=NIL:PTR TO exe

BYTE	0,0,'$VER:ddbg v0.4 (25.1.2003)',0,0

PROC main()
	DEF	ra=NIL,args=[0,0]:LONG,n,str[256]:STRING
	ENUM	EXE,ARGS
	IFN ra:=ReadArgs('EXE/A,ARGS',args,NIL) THEN Raise("IO")
	IFN pool:=CreatePool(MEMF_CLEAR|MEMF_PUBLIC,16384,1024) THEN Raise("MEM")
	IFN UtilityBase:=OpenLibrary('utility.library',37) THEN Raise("UTIL")
	IFN screen:=LockPubScreen(NIL) THEN Raise("SCRN")
	IFN dri:=GetScreenDrawInfo(screen) THEN Raise("DRIP")
	exe:=LoadExecutable(args[EXE])
	exe.src:=LoadDSource(EStringF(str,'\s.d',args[EXE]))
	exe.debug:=LoadDebugFile(EStringF(str,'\s.debug',args[EXE]))

	n:=0
	WHILE exe.hunks[n]
//		DisAsmHunk68k(exe.hunks[n],Long(exe.hstarts[n]),exe.hsymbols[n])
//		ViewSymbols(exe.hsymbols[n])
		n++
	ENDWHILE

//	ViewHex(exe.file,exe.length/4)

	setupscreen()
	openmainwindow()
	open_window("SRC",screen.Width*3/4,screen.Height*3/4)

	// setup code for running
	RunCustomCode([IF args[ARGS] THEN StrLen(args[ARGS]) ELSE 0,0,0,0,0,0,0,0,args[ARGS],0,0,0,0,0,0,0,0]:UL)
EXCEPTDO
	closemainwindow()
	closedownscreen()
	IF dri THEN FreeScreenDrawInfo(screen,dri)
	IF screen THEN UnlockPubScreen(NIL,screen)
	IF UtilityBase THEN CloseLibrary(UtilityBase)
	IF pool THEN DeletePool(pool)
	IF ra THEN FreeArgs(ra)
	SELECT exception
	CASE "IO";	PrintFault(IOErr(),'ddbg')
	CASE "MEM";	PrintF('\s: \s\n','ddbg','not enough memory')
	CASE "BADF";PrintF('\s: \s\n','ddbg','bad file type')
	CASE "VERS";PrintF('\s: \s\n','ddbg','newer version of ddbg required')
	CASE $000003ef;PrintF('\s: \s\n','ddbg','ext hunk is not supported')
	CASE $000003f0;PrintF('\s: \s\n','ddbg','symbol hunk is not supported')
	CASE $000003f1;PrintF('\s: \s\n','ddbg','debug hunk is not supported')
	CASE "DSTH";PrintF('\s: \s\n','ddbg','no destination hunk available')
	CASE "GTLI";PrintF('\s: \s\n','ddbg','can''t open gadtools.library v37+')
	CASE "GADG";PrintF('\s: \s\n','ddbg','can''t create gadgets')
	CASE "MENU";PrintF('\s: \s\n','ddbg','can''t create menus')
	CASE "WIND";PrintF('\s: \s\n','ddbg','can''t open window')
	CASE "WBSC";PrintF('\s: \s\n','ddbg','can''t lock Workbench screen')
	CASE "VISU";PrintF('\s: \s\n','ddbg','can''t get visual info')
	CASE "TYPE";PrintF('\s: \s\n','ddbg','bad debug file')
	CASE "RTLI";PrintF('\s: \s\n','ddbg','can''t open reqtools.library v37+')
	ENDSELECT
ENDPROC

OBJECT exe
	pc:PTR,				// pc address to run on
	regs:PTR TO UL,	// d0-a7,sr register contents
	file:PTR TO CHAR,
	length,
	start:UL,
	stop:UL,
	hunks:PTR TO PTR,
	hstarts:PTR TO PTR,
	hsymbols:PTR TO PTR,
	relocated:PTR TO CHAR,
	breakpoints:PTR TO breakpoint,
	debug:PTR TO debug,
	src:PTR TO src,
	srcwin:win,
	regwin:win,
	varwin:win

OBJECT win
	type:UL,
	sizeimage:PTR TO Image,
	leftimage:PTR TO Image,
	rightimage:PTR TO Image,
	upimage:PTR TO Image,
	downimage:PTR TO Image,
	horizgadget:PTR TO _Object,
	vertgadget:PTR TO _Object,
	leftgadget:PTR TO _Object,
	rightgadget:PTR TO _Object,
	upgadget:PTR TO _Object,
	downgadget:PTR TO _Object,
	window:PTR TO Window,
	htotal,hvisible,
	vtotal,vvisible

PROC LoadExecutable(name:PTR TO CHAR)(PTR TO exe)
	DEF	file=NIL,length,exe:PTR TO exe
	IFN exe:=AllocVecPooled(pool,SIZEOF_exe) THEN Raise("MEM")
	IF (length:=FileLength(name))<=0 THEN Raise("IO")
	exe.length:=length
	IFN file:=Open(name,OLDFILE) THEN Raise("IO")
	IFN exe.file:=AllocVecPooled(pool,length+16) THEN Raise("MEM")
	Read(file,exe.file,length)
	Close(file)
	file:=NIL

	// count and reloc all hunks available in the executable file
	DEF	mem:PTR TO CHAR,h,i,j,k,count,n,hunklist=NIL:PTR TO PTR,hunkstarts=NIL:PTR TO PTR,hunksymbols=NIL:PTR TO PTR,hunktoreloc,ops=FALSE
	FOR n:=0 TO 2
		mem:=exe.file
		hunktoreloc:=NIL
		SELECT n
		CASE 0
			PrintF('Reading...\n')
		CASE 1
			PrintF('# of hunks: \d\n',count)
			IFN exe.hunks:=AllocVecPooled(pool,(count+2)*SIZEOF_PTR) THEN Raise("MEM")
			hunklist:=exe.hunks
			IFN exe.hstarts:=AllocVecPooled(pool,(count+2)*SIZEOF_PTR) THEN Raise("MEM")
			hunkstarts:=exe.hstarts
			IFN exe.hsymbols:=AllocVecPooled(pool,(count+2)*SIZEOF_PTR) THEN Raise("MEM")
			hunksymbols:=exe.hsymbols
		CASE 2
			PrintF('Relocating...\n')
			hunklist:=exe.hunks
			hunkstarts:=exe.hstarts
			hunksymbols:=exe.hsymbols
		ENDSELECT
		count:=0
		WHILE mem<=(length+exe.file)
			SELECT Long(mem)
			CASE $000003e7,$0000003e8	// hunk unit, name
				mem+=4
				i:=Long(mem)
				mem+=4+AlignLong(i)
			CASE $000003e9,$000003ea,$000003eb	// hunk code, data, bss
//				PrintF('code/data\n')
				mem+=4
				i:=Long(mem)*4
				mem+=4
				hunktoreloc:=mem
				SELECT n
				CASE 1
					hunkstarts[count]:=mem-8
					hunklist[count]:=mem
//					VPrintF('hunklist: \h,\h,\h,\h\n',hunklist)
				ENDSELECT
				count++
				mem+=i
			CASE $000003ec,$000003ed,$000003ee	// hunk reloc32, reloc16, reloc8
//				PrintF('reloc\n')
				j:=Long(mem)
				mem+=4
				SELECT n
				CASE 0,1
					WHILE i:=Long(mem)
						mem+=8
						mem+=i*4
						CtrlC()
					ENDWHILE
					mem+=4
//					PrintF('mem1: \d\n',mem)
				CASE 2
					WHILE i:=Long(mem)
//						PrintF('\h: \h\n',hunklist[Long(mem+4)],Long(mem+4))
						IFN h:=hunklist[Long(mem+4)] THEN Raise("DSTH")
						mem+=8
						FOR k:=0 TO i-1
							SELECT j
							CASE $000003ec;	PutLong(hunktoreloc+Long(mem),h+ULong(hunktoreloc+Long(mem)))
							CASE $000003ed;	PutWord(hunktoreloc+Long(mem),h+UWord(hunktoreloc+Long(mem)))
							CASE $000003ee;	PutByte(hunktoreloc+Long(mem),h+UByte(hunktoreloc+Long(mem)))
							ENDSELECT
							mem+=4
						ENDFOR
						CtrlC()
					ENDWHILE
					mem+=4
//					PrintF('mem2: \d\n',mem)
				ENDSELECT
			CASE $000003ef	// hunk ext	UNSUPPORTED
				Raise(Long(mem))
			CASE $000003f0
				mem+=4
				SELECT n
				CASE 1
					IF count>0	// this should be enough to become safe, it's always the first argument
						hunksymbols[count-1]:=mem
					ENDIF
				ENDSELECT
				WHILE i:=Long(mem)
					mem+=(i+2)*4
					CtrlC()
				ENDWHILE
				mem+=4
			CASE $000003f1 // hunk debug UNSUPPORTED
				Raise(Long(mem))
			CASE $000003f2	// hunk end
//				PrintF('end\n')
				mem+=4
				hunktoreloc:=NIL
			CASE $000003f3	// hunk header
//				PrintF('head\n')
				mem+=4

				WHILE i:=Long(mem)	// skip names
					mem+=4
					mem+=i*4
					CtrlC()
				ENDWHILE
				mem+=4

				mem+=4				// highest hunk number +1
				i:=Long(mem)		// first
				j:=Long(mem+4)		// last
				mem+=8

				mem+=(j-i+1)*4		// skip sizes
			CASE $000003f7,$000003f8,$000003f9,$000003fc	// hunk drel32, drel16, drel8, reloc32short
				mem+=4
				SELECT n
				CASE 0,1
					WHILE i:=Word(mem)
						mem+=4
						mem+=i*2
						CtrlC()
					ENDWHILE
					mem+=2
				CASE 2
					WHILE i:=Word(mem)
//						PrintF('\h: \h\n',hunklist[Word(mem+2)],Word(mem+2))
						IFN h:=hunklist[Word(mem+2)] THEN Raise("DSTH")
						mem+=4
						FOR k:=0 TO i-1
							SELECT j
							CASE $000003ec;	PutLong(hunktoreloc+Word(mem),h+ULong(hunktoreloc+Word(mem)))
							CASE $000003ed;	PutWord(hunktoreloc+Word(mem),h+UWord(hunktoreloc+Word(mem)))
							CASE $000003ee;	PutByte(hunktoreloc+Word(mem),h+UByte(hunktoreloc+Word(mem)))
							ENDSELECT
							mem+=2
						ENDFOR
						CtrlC()
					ENDWHILE
					mem+=2

					WHILE i:=Word(mem)
						h:=Word(mem+2)
						mem+=4
						mem+=i*2
						CtrlC()
					ENDWHILE
					mem+=2
				ENDSELECT
			CASE 0;	ops:=TRUE
			DEFAULT
				PrintF('$\h\n',Long(mem))
			ENDSELECT
		EXITIF ops DO ops:=FALSE
			CtrlC()
		ENDWHILE
	ENDFOR

	exe.start:=exe.file
	exe.stop:=exe.file+exe.length

EXCEPTDO
	IF file THEN Close(file)
	IF exception THEN Raise(exception)
ENDPROC exe
/*
PROC DisAsmHunk68k(pos:PTR TO CHAR,hunktype:UL,symbols=NIL)
	DEF	max,start
	start:=pos
	max:=Long(pos-4)*4
	max+=pos
	PrintF('hunk: \h, start: \h, stop: \h\n',hunktype,pos,max)
	WHILE (pos:=DisAsm68k(pos,hunktype,FindLabel(start,pos,symbols)))<max
		CtrlC()
	ENDWHILE
ENDPROC

PROC FindLabel(start,addr,symlist:PTR TO LONG)(PTR)
	DEF	lab=NIL,i
	IF symlist=NIL THEN RETURN NIL
//	PrintF('\d\t',addr-start)
	WHILE i:=Long(symlist)
	EXITIF (addr-start)=symlist[i+1] DO lab:=symlist+4
		symlist+=(i+2)*4
		CtrlC()
	ENDWHILE
ENDPROC lab

PROC FindLabelGlobal(addr)(PTR)
	DEF	lab=NIL,i,n=0,start,symlist:PTR TO L
	WHILE symlist:=exe.hsymbols[n]
		start:=exe.hunks[n]
//		PrintF('\d: \h,\h,\h\n',n,start,addr,addr-start)
		WHILE i:=Long(symlist)
		EXITIF (addr-start)=symlist[i+1] DO lab:=symlist+4
			symlist+=(i+2)*4
			CtrlC()
		ENDWHILE
		n++
	ENDWHILE
ENDPROC lab
*/

PROC FindLabelAddr(name:PTR TO CHAR)(UL)
	DEF	lab=NIL,i,n=0,start,symlist:PTR TO L,addr
	WHILE symlist:=exe.hsymbols[n]
		start:=exe.hunks[n]
		WHILE i:=Long(symlist)
		EXITIF StrCmp(name,symlist+4) DO addr:=start+symlist[i+1]
//		EXITIF (addr-start)=symlist[i+1] DO lab:=symlist+4
			symlist+=(i+2)*4
			CtrlC()
		ENDWHILE
		n++
	ENDWHILE
ENDPROC addr

// get, if there is a line label on a given address
PROC FindLineAddr(addr)(UL)
	DEF	lab=NIL,i,n=0,start,symlist:PTR TO L
	WHILE symlist:=exe.hsymbols[n]
		start:=exe.hunks[n]
//		PrintF('\d: \h,\h,\h\n',n,start,addr,addr-start)
		WHILE i:=Long(symlist)
			IF (addr-start)=symlist[i+1]
				lab:=symlist+4
				IF StrCmp(lab,'line_',5) THEN RETURN lab
			ENDIF
			lab:=NIL
			symlist+=(i+2)*4
			CtrlC()
		ENDWHILE
		n++
	ENDWHILE
ENDPROC lab

/*
PROC DisAsm68k(inst:PTR TO CHAR,hunktype,label=NIL:PTR TO CHAR)(PTR)
	DEF	istr=NIL:PTR TO CHAR,i,a1[64]:CHAR,a2[64]:CHAR,q1=FALSE,q2=FALSE,type,str:PTR TO CHAR
	IF label
		PrintF('$\z\h[8]: \s\s',inst,label,IF StrLen(label)>4 THEN '\t' ELSE '\t\t')
	ELSE
		PrintF('$\z\h[8]:\t\t',inst)
	ENDIF
	IF hunktype=$000003ea
		PrintF('$\z\h[4]\n',UWord(inst))
		RETURN inst+2
	ENDIF
	SELECT i:=UWord(inst)
	CASE $4e71;	istr:='nop';	inst+=2
	CASE $4e75;	istr:='rts';	inst+=2
	DEFAULT
		SELECT (i&$ff00)>>8
		CASE %01001110
			SELECT (i&$00c0)>>6
			CASE %01
				SELECT (i&$0038)>>3
				CASE %010;	istr:='link'
					inst+=2
					DisArg68k(a1,(i&7)|8,inst);				q1:=TRUE
					inst:=DisArg68k(a2,%111100,inst,"w");	q2:=TRUE
				CASE %011;	istr:='unlk'
					inst+=2
					DisArg68k(a1,(i&7)|8,inst);				q1:=TRUE
				DEFAULT;	PrintF('$\z\h[4]',i);	inst+=2
				ENDSELECT
			CASE %10;	istr:='jsr';	inst+=2
			DEFAULT;	PrintF('$\z\h[4]',i)
			ENDSELECT
			IF istr
				inst:=DisArg68k(a1,(i&$003f),inst);		q1:=TRUE
			ENDIF
		DEFAULT
			SELECT (i&$c000)>>14
			CASE %00	// move
				SELECT (i&$3000)>>12
				CASE %01;	istr:='move.b'
				CASE %10;	istr:='move.l'
				CASE %11;	istr:='move.w'
				DEFAULT;	PrintF('$\z\h[4]',i)
				ENDSELECT
				inst+=2
				IF istr
					inst:=DisArg68k(a1,(i&$003f),inst);		q1:=TRUE
					inst:=DisArg68k(a2,(i&$0e00)>>9|(i&$01c0)>>3,inst);	q2:=TRUE

//					inst:=DisArg68k(a2,(i&$0fc0)>>6,inst);	q2:=TRUE
				ENDIF
			CASE %01	// moveq, lea
				SELECT (i&$3000)>>12
				CASE %00
					SELECT (i&$01c0)>>6
					CASE %010;	istr:='movem.w'
						SELECT (i&$0e00)>>9
						CASE %100
							DisRegList68k(a1,UWord(inst+2),-1);	q1:=TRUE;	inst+=4
							inst:=DisArg68k(a2,i,inst);			q2:=TRUE
						CASE %110
							DisRegList68k(a2,UWord(inst+2),+1);	q2:=TRUE;	inst+=4
							inst:=DisArg68k(a1,i,inst);			q1:=TRUE
						DEFAULT;	PrintF('\z\h[4]',i)
							inst+=2
						ENDSELECT
					CASE %011;	istr:='movem.l'
						SELECT (i&$0e00)>>9
						CASE %100
							DisRegList68k(a1,UWord(inst+2),-1);	q1:=TRUE;	inst+=4
							inst:=DisArg68k(a2,i,inst);			q2:=TRUE
						CASE %110
							DisRegList68k(a2,UWord(inst+2),+1);	q2:=TRUE;	inst+=4
							inst:=DisArg68k(a1,i,inst);			q1:=TRUE
						DEFAULT;	PrintF('\z\h[4]',i)
							inst+=2
						ENDSELECT
					CASE %111;	istr:='lea'
						inst+=2
						inst:=DisArg68k(a1,(i&$003f),inst);	q1:=TRUE
						StringF(a2,'a\d',(i&$0e00)>>9);		q2:=TRUE
					DEFAULT;	PrintF('\z\h[4]',i)
						inst+=2
					ENDSELECT
				CASE %10
					str:=DisCC68k((i&$0f00)>>8)
					istr:='b\0\0\0\0\0\0\0'
					istr[1]:="\0"	// needed, because else it won't restore those zero bytes each time
					StrAdd(istr,str)
					inst+=2
					q1:=TRUE
					IF i&$ff=$00
						StrAdd(istr,'.w')
						inst:=DisArg68k(a1,%111000,inst,"r")
					ELSEIF i&$ff=$ff
						StrAdd(istr,'.l')
						inst:=DisArg68k(a1,%111001,inst,"l")
					ELSE
						StrAdd(istr,'.b')
						DisArg68k(a1,%111001,inst,"b")
					ENDIF
				CASE %11
					SELECT (i&$0100)>>8
					CASE %0;	istr:='moveq';	StringF(a1,'#\d',Byte(inst+1));	q1:=TRUE;	StringF(a2,'d\d',(i&$0e00)>>9);	q2:=TRUE
					ENDSELECT
					inst+=2
				DEFAULT;	PrintF('\z\h[4]',i)
					inst+=2
				ENDSELECT
			CASE %11	// add
				SELECT (i&$3000)>>12
				CASE %01
					inst+=2
					inst,type:=DisOpArg68k(a1,a2,i,inst);	q1:=q2:=TRUE
					SELECT type
					CASE "b";	istr:='add.b'
					CASE "w";	istr:='add.w'
					CASE "l";	istr:='add.l'
					ENDSELECT
				DEFAULT;	PrintF('$\z\h[4]',i)
					inst+=2
				ENDSELECT
			DEFAULT;	PrintF('$\z\h[4]',i)
				inst+=2
			ENDSELECT
		ENDSELECT
	ENDSELECT
	PrintF('\s',istr)
	IF q1
		PrintF('\t\s',a1)
		IF q2 THEN PrintF(',\s',a2)
	ENDIF
	PrintF('\n')
ENDPROC inst

PROC DisArg68k(str:PTR TO CHAR,i,inst:PTR TO CHAR,type="l")(PTR)
	DEF	lab
	SELECT (i&$38)>>3
	CASE %000;	StringF(str,'d\d',i&7)
	CASE %001;	StringF(str,'a\d',i&7)
	CASE %010;	StringF(str,'(a\d)',i&7)
	CASE %011;	StringF(str,'(a\d)+',i&7)
	CASE %100;	StringF(str,'-(a\d)',i&7)
	CASE %101;	StringF(str,'(\d,a\d)',Word(inst),i&7);	inst+=2
	CASE %111
		SELECT i&7
		CASE %000
			SELECT type
			CASE "r"
				IF lab:=FindLabelGlobal(Word(inst)+inst)
					StringF(str,'\s',lab)
				ELSE
					StringF(str,'$\z\h[8]',Word(inst)+inst)
				ENDIF
				inst+=2
			DEFAULT
				StringF(str,'$\z\h[4].w',UWord(inst))
				inst+=2
			ENDSELECT
		CASE %001;
			SELECT type
			CASE "b"		// for bcc/dbcc/bra only
				IF lab:=FindLabelGlobal(Byte(inst-1)+inst)
					StringF(str,'\s',lab)
				ELSE
					StringF(str,'$\z\h[8]',Byte(inst-1)+inst)
				ENDIF
			CASE "l"
				IF lab:=FindLabelGlobal(Long(inst))
					StringF(str,'\s',lab)
				ELSE
					StringF(str,'$\z\h[8].l',Long(inst))
				ENDIF
				inst+=4
			ENDSELECT
		CASE %010;	StringF(str,'(\d,pc)',Word(inst));	inst+=2
		CASE %100;
			SELECT type
			CASE "w";	StringF(str,'#\d',Word(inst));	inst+=2
			CASE "l";	StringF(str,'#\d',Long(inst));	inst+=4
			ENDSELECT
		DEFAULT;	StringF(str,'???')
		ENDSELECT
	DEFAULT;	StringF(str,'???')
	ENDSELECT
ENDPROC inst

PROC DisOpArg68k(s1:PTR TO CHAR,s2:PTR TO CHAR,i,inst:PTR TO CHAR)(PTR,L)
	DEF	type
	SELECT (i&$01e0)>>6
	CASE %000;	type:="b";	inst:=DisArg68k(s1,i&$3f,inst,"w");	DisArg68k(s2,i>>9&7)
	CASE %001;	type:="w";	inst:=DisArg68k(s1,i&$3f,inst,"w");	DisArg68k(s2,i>>9&7)
	CASE %010;	type:="l";	inst:=DisArg68k(s1,i&$3f,inst);	DisArg68k(s2,i>>9&7)
	CASE %011;	type:="w";	inst:=DisArg68k(s1,i&$3f,inst,"w");	DisArg68k(s2,i>>9&7|8)
	CASE %100;	type:="b";	DisArg68k(s1,i>>9&7);	inst:=DisArg68k(s2,i&$3f,inst,"w")
	CASE %101;	type:="w";	DisArg68k(s1,i>>9&7);	inst:=DisArg68k(s2,i&$3f,inst,"w")
	CASE %110;	type:="l";	DisArg68k(s1,i>>9&7);	inst:=DisArg68k(s2,i&$3f,inst)
	CASE %111;	type:="l";	inst:=DisArg68k(s1,i&$3f,inst);	DisArg68k(s2,i>>9&7|8)
	ENDSELECT
ENDPROC inst,type

PROC DisCC68k(cc)(PTR)
	DEF	str:PTR TO CHAR
	SELECT cc&%1111
	CASE %0000;	str:='f'
	CASE %0001;	str:='t'
	CASE %0010;	str:='hi'
	CASE %0011;	str:='ls'
	CASE %0100;	str:='cc'
	CASE %0101;	str:='cs'
	CASE %0110;	str:='ne'
	CASE %0111;	str:='eq'
	CASE %1000;	str:='vc'
	CASE %1001;	str:='vs'
	CASE %1010;	str:='pl'
	CASE %1011;	str:='mi'
	CASE %1100;	str:='ge'
	CASE %1101;	str:='lt'
	CASE %1110;	str:='gt'
	CASE %1111;	str:='le'
	ENDSELECT
ENDPROC str

PROC DisRegList68k(str:PTR TO CHAR,word,dir)(PTR)
	DEF	n,haveany=FALSE,tmp[6]:STRING,min,max,step,i
	SetEStr(str,0)
	min:=0
	max:=15
	IF dir<0
		n:=max
		step:=-1
	ELSE
		n:=min
		step:=1
	ENDIF
	i:=0
	WHILE n>=min AND n<=max
		IF word&1<<n
			IF haveany THEN EStrAdd(str,'/')
			EStringF(tmp,'\c\d',IF i<=7 THEN "d" ELSE "a",i&7)
			EStrAdd(str,tmp)
			haveany:=TRUE
		ENDIF
		i++
		n+=step
	ENDWHILE
ENDPROC str
*/

PROC AlignLong(i)(L)
	SELECT i&%11
	CASE %01	i+=3
	CASE %10	i+=2
	CASE %11	i+=1
	ENDSELECT
ENDPROC i

OBJECT src
	src:PTR TO CHAR,
	length:L,
	linecount:L,
	lines:PTR TO PTR TO CHAR,
	showline:L,
	line:L

PROC LoadDSource(name:PTR TO CHAR)(PTR)
	DEF	src:PTR TO src,mem:PTR TO CHAR,len,pos,file,max=0,total=0
	IF (len:=FileLength(name))<=0 THEN Raise("IO")
	IFN file:=Open(name,OLDFILE) THEN Raise("IO")
	IFN src:=AllocVecPooled(pool,SIZEOF_src) THEN Raise("MEM")
	IFN mem:=AllocVecPooled(pool,len+16) THEN Raise("MEM")
	IF Read(file,mem,len)<>len THEN Raise("IO")
//	Write(stdout,mem,len)
	src.src:=mem
	src.length:=len

	DEF	count=1
	pos:=0
	// count lines
	WHILE pos<len
		IF mem[pos]="\n"
			count++
			IF max>total THEN total:=max
			max:=0
		ELSE
			max++
		ENDIF
		pos++
	ENDWHILE
	src.linecount:=count
	exe.srcwin.vtotal:=count
	exe.srcwin.htotal:=total
	exe.regwin.vtotal:=9
	exe.regwin.htotal:=256
	exe.varwin.htotal:=256
	PrintF('\d lines\n\d columns\n',count,total)

	// setup lines
	IFN src.lines:=AllocVecPooled(pool,(count+1)*SIZEOF_PTR) THEN Raise("MEM")
	count:=0
	pos:=0
	src.lines[count++]:=mem+pos
	WHILE pos<len
		IF mem[pos]="\n"
			mem[pos]:="\0"	// terminate the line
			src.lines[count++]:=mem+pos+1
		ENDIF
		pos++
	ENDWHILE

	src.showline:=-1	// don't jump to the line
EXCEPTDO
	IF file THEN Close(file)
	IF exception THEN Raise(exception)
ENDPROC src

OBJECT debug
	var:PTR TO var,
	proc:PTR TO proc,
	lastproc:PTR TO proc

OBJECT var
	name:PTR TO CHAR,
	offset:LONG,
	type:LONG,
	ofto:LONG,
	view:BOOL,
	next:PTR TO var

OBJECT proc
	name:PTR TO CHAR,
	var:PTR TO var,
	next:PTR TO proc

PROC LoadDebugFile(filename:PTR TO CHAR)(PTR)
	DEF	file=NIL,length,debug=NIL:PTR TO debug,mem=NIL:PTR TO CHAR,pos,name:PTR TO CHAR,proc:PTR TO proc,var:PTR TO var,val
	DEF	global=FALSE
	IF (length:=FileLength(filename))<=0 THEN Raise("IO")
	IFN file:=Open(filename,OLDFILE) THEN Raise("IO")
	IFN mem:=AllocVecPooled(pool,length+16) THEN Raise("MEM")
	IFN debug:=AllocVecPooled(pool,SIZEOF_debug) THEN Raise("MEM")
	IF Read(file,mem,length)<>length THEN Raise("IO")
	IF Long(mem)<>"DDBG" THEN Raise("TYPE")
	proc:=NIL
	pos:=Skip(mem,4,length)
	WHILE pos<length
		name:=mem+pos
		pos:=MakeName(mem,pos,length)
		pos:=Skip(mem,pos+1,length)
		IF StrCmp(name,'PROC')
			IF proc
				IFN proc.next:=AllocVecPooled(pool,SIZEOF_proc) THEN Raise("MEM")
				proc:=proc.next
			ELSE
				IFN proc:=AllocVecPooled(pool,SIZEOF_proc) THEN Raise("MEM")
				debug.proc:=proc
			ENDIF
			debug.lastproc:=proc

			name:=mem+pos
			pos:=MakeName(mem,pos,length)
			pos:=Skip(mem,pos+1,length)
			proc.name:=name
//			PrintF('PROC \s\n',proc.name)
			LOOP
				name:=mem+pos
				pos:=MakeName(mem,pos,length)
				pos:=Skip(mem,pos+1,length)
			EXITIF StrCmp(name,'ENDPROC')

				DoVariable

				CtrlC()
			ENDLOOP
		ELSEIF StrCmp(name,'GLOBALS')
			pos:=Skip(mem,pos,length)
			global:=TRUE
			LOOP
				name:=mem+pos
				pos:=MakeName(mem,pos,length)
				pos:=Skip(mem,pos+1,length)
			EXITIF StrCmp(name,'ENDGLOBALS')

				DoVariable

				CtrlC()
			ENDLOOP
			global:=FALSE
		ELSE
			Raise("TYPE")
		ENDIF
		CtrlC()
	ENDWHILE

	SUB DoVariable
		IFN var:=AllocVecPooled(pool,SIZEOF_var) THEN Raise("MEM")
		IF global
			var.next:=debug.var
			IFN debug.var THEN debug.var:=var
			debug.var:=var
		ELSE
			var.next:=proc.var
			IFN proc.var THEN proc.var:=var
			proc.var:=var
		ENDIF
		val:=Val(name)
		var.offset:=val

		name:=mem+pos
		pos:=MakeName(mem,pos,length)
		pos:=Skip(mem,pos+1,length)
		var.name:=name
//		PrintF('VAR \s(\d)\n',var.name,var.offset)
		
		name:=mem+pos
		pos:=MakeName(mem,pos,length)
		pos:=Skip(mem,pos+1,length)
		val:=Val(name)
		var.type:=val

		IF (val&$1f)=10
			name:=mem+pos
			pos:=MakeName(mem,pos,length)
			pos:=Skip(mem,pos+1,length)
			var.ofto:=name
		ENDIF
	ENDSUB
EXCEPTDO
	IF file THEN Close(file)
	IF exception THEN Raise(exception)
ENDPROC debug

PROC MakeName(src:PTR TO CHAR,pos,length)(L)
	WHILE IsAlpha(src[pos]) OR IsNum(src[pos]) OR src[pos]="_" OR src[pos]="-"
		pos++
		CtrlC()
	ENDWHILE
	src[pos]:="\0"
ENDPROC pos

PROC Skip(src:PTR TO CHAR,pos,length)(L)
	LOOP
		IF src[pos]=" "
		ELSEIF src[pos]="\n"
		ELSEIF src[pos]="\t"
		ELSEIF src[pos]="\0"
		ELSE
			RETURN pos
		ENDIF
		pos++
		IF pos>=length THEN RETURN pos
		IF (pos\100)=0 THEN CtrlC()
	ENDLOOP
ENDPROC pos-1
/*
PROC ViewHex(data:PTR TO L,length,max=8)
	DEF	count=0,inter
	WHILE count<length
		inter:=0
		WHILE inter<max
			PrintF('$\z\h[8]',data[count+inter])
			inter++
		EXITIF inter+count>=length DO PrintF('\n')
			IF inter=8 THEN PrintF('\n') ELSE PrintF(',')
			CtrlC()
		ENDWHILE
		count+=inter
		CtrlC()
	ENDWHILE
ENDPROC

PROC ViewSymbols(symlist:PTR TO LONG)
	DEF	i
	WHILE i:=Long(symlist)
		PrintF('$\z\h[8]: \s\n',symlist[i+1],symlist+4)
		symlist+=(i+2)*4
		CtrlC()
	ENDWHILE
ENDPROC
*/

// view the PowerD source code
PROC UpdateSrc(win:PTR TO win)
	IFN win.type="SRC" THEN RETURN

	DEF	x,y
	GetAttr(PGA_Top,win.horizgadget,&x)
	GetAttr(PGA_Top,win.vertgadget,&y)

	DEF	str[256]:STRING,start
	DEF	line,n,a,b

	IF exe.src.showline=TRUE
		start:=y
	ELSE
		start:=exe.src.showline-win.vvisible/2
	ENDIF

	IF win.vvisible>exe.src.linecount THEN start:=0
	IF start+win.vvisible>=exe.src.linecount THEN start:=exe.src.linecount-win.vvisible
	IF start<0 THEN start:=0

	// clear the window
	SetAPen(win.window.RPort,0)
	RectFill(win.window.RPort,win.window.BorderLeft,win.window.BorderTop,win.window.Width-win.window.BorderRight-1,win.window.Height-win.window.BorderBottom-1)

	line:=start
	FOR n:=0 TO win.vvisible-1
		EStringF(str,'\z\d[5]: \s',line+1,IF x>=StrLen(exe.src.lines[line]) THEN NIL ELSE exe.src.lines[line]+x)
		IF EStrLen(str)>win.hvisible THEN SetEStr(str,win.hvisible-1)
		ConvStr(str)
		a:=IF line=exe.src.line THEN 2 ELSE 1
		b:=IF line=exe.src.line THEN 1 ELSE 0
		IF line=exe.src.showline
			a:=3
			b:=2
		ENDIF
		SetAPen(win.window.RPort,a)
		SetBPen(win.window.RPort,b)
		Move(win.window.RPort,4+win.window.BorderLeft,(n*win.window.RPort.Font.YSize)+win.window.RPort.Font.Baseline+win.window.BorderTop)
		Text(win.window.RPort,str,EStrLen(str))
	EXITIF line>=exe.src.linecount
		line++
		CtrlC()
	ENDFOR
ENDPROC

PROC ConvStr(str:PTR TO CHAR)
	DEF	n=0
	WHILE str[n]<>0
		IF str[n]="\t"
			str[n]:=" "
		ENDIF
		n++
	ENDWHILE
ENDPROC

PROC UpdateVars()
	DEF	proc:PTR TO proc,var:PTR TO var,value,a5,field,flt:D
	DEF	str[256]:STRING,n,width,strb[64]:STRING,addr,tstr[32]:CHAR,max
	DEF	start,stop
	IFN varwnd THEN RETURN
	width:=varwnd.Width-varwnd.BorderLeft-varwnd.BorderRight-8
	max:=(varwnd.Height-varwnd.BorderTop-varwnd.BorderBottom)/varwnd.RPort.Font.YSize
	SetRast(varwnd.RPort,0)
	SetAPen(varwnd.RPort,1)
	proc:=exe.debug.proc
	n:=0
	WHILE proc
		StringF(str,'_\s',proc.name)
		start:=FindLabelAddr(str)
		IF proc.next
			StringF(str,'_\s',proc.next.name)
			stop:=FindLabelAddr(str)
		ELSE
			stop:=exe.stop
		ENDIF
		IF exe.pc>=start AND exe.pc<stop
			var:=proc.var
			WHILE var
				field:=FALSE
				a5:=exe.regs[8+5]
				SELECT var.type
				CASE 0,1,2;	value:=Long(a5+var.offset)
				CASE 3;		value:=Word(a5+var.offset)
				CASE 4,9;	value:=UWord(a5+var.offset)
				CASE 5;		value:=Byte(a5+var.offset)
				CASE 6;		value:=UByte(a5+var.offset)
				CASE 7;		flt:=Float(a5+var.offset)
				CASE 8;		flt:=Double(a5+var.offset)
				CASE 10;		field:=1
				DEFAULT;		value:=Long(a5+var.offset)
					IF value&$ff00.0000 THEN field:=TRUE
				ENDSELECT
				SELECT var.type
				CASE 1;	StrCopy(tstr,':L')
				CASE 2;	StrCopy(tstr,':UL')
				CASE 3;	StrCopy(tstr,':W')
				CASE 4;	StrCopy(tstr,':UW')
				CASE 5;	StrCopy(tstr,':B')
				CASE 6;	StrCopy(tstr,':UB')
				CASE 7;	StrCopy(tstr,':F')
				CASE 8;	StrCopy(tstr,':D')
				CASE 9;	StrCopy(tstr,':BOOL')
				CASE 10;	StringF(tstr,':\s',var.ofto)
				CASE 11;	StrCopy(tstr,':PTR')
//				CASE 12;	StrCopy(tstr,':Q')
//				CASE 13;	StrCopy(tstr,':UQ')
				DEFAULT;	StringF(tstr,'\s',NIL)
				ENDSELECT
				SELECT var.type
				CASE 0,1,2;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[8])\s[80]',a5+var.offset,var.name,tstr,value,value,NIL)
				CASE 7;		EStringF(str,'[$\z\h[8]] \s\s = \s ($\z\h[8])\s[80]',a5+var.offset,var.name,tstr,RealStr(strb,flt,7),Long(a5+var.offset),NIL)
				CASE 8;		EStringF(str,'[$\z\h[8]] \s\s = \s ($\z\h[8].\z\h[8])\s[80]',a5+var.offset,var.name,tstr,RealStr(strb,flt,15),Long(a5+var.offset),Long(a5+var.offset+4),NIL)
				CASE 5,6;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[2])\s[80]',a5+var.offset,var.name,tstr,value,value,NIL)
				CASE 3,4,9;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[4])\s[80]',a5+var.offset,var.name,tstr,value,value,NIL)
				CASE 10;		EStringF(str,'[$\z\h[8]] \s\s',a5+var.offset,var.name,tstr)
				DEFAULT;		EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[8])',a5+var.offset,var.name,tstr,value,value,NIL)
				ENDSELECT
				IF field=TRUE
					EStringF(strb,'=[$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8]]',Long(value),Long(value+4),Long(value+8),Long(value+12))
					EStrAdd(str,strb)
				ELSEIF field=1
					VEStringF(strb,'=[$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8]]',a5+var.offset)
					EStrAdd(str,strb)
				ENDIF
				WHILE TextLength(varwnd.RPort,str,EStrLen(str))>width
					SetEStr(str,EStrLen(str)-1)
				ENDWHILE
				Move(varwnd.RPort,4,(n*varwnd.RPort.Font.YSize)+varwnd.RPort.Font.Baseline)
				Text(varwnd.RPort,str,EStrLen(str))
				var:=var.next
				n++
				IF n>=max THEN RETURN
			ENDWHILE
		ENDIF
		proc:=proc.next
	ENDWHILE

	var:=exe.debug.var
	WHILE var
		field:=FALSE
		EStringF(str,'_\s',var.name)
		addr:=FindLabelAddr(str)
		SELECT var.type
		CASE 0,1,2;	value:=Long(addr)
		CASE 3;		value:=Word(addr)
		CASE 4,9;	value:=UWord(addr)
		CASE 5;		value:=Byte(addr)
		CASE 6;		value:=UByte(addr)
		CASE 7;		flt:=Float(addr)
		CASE 8;		flt:=Double(addr)
		DEFAULT;		value:=Long(addr)
			IF value&$ff00.0000 THEN field:=TRUE
		ENDSELECT
		SELECT var.type
		CASE 1;	StrCopy(tstr,':L')
		CASE 2;	StrCopy(tstr,':UL')
		CASE 3;	StrCopy(tstr,':W')
		CASE 4;	StrCopy(tstr,':UW')
		CASE 5;	StrCopy(tstr,':B')
		CASE 6;	StrCopy(tstr,':UB')
		CASE 7;	StrCopy(tstr,':F')
		CASE 8;	StrCopy(tstr,':D')
		CASE 9;	StrCopy(tstr,':BOOL')
		CASE 10;	StringF(tstr,':\s',var.ofto)
		CASE 11;	StrCopy(tstr,':PTR')
//		CASE 12;	StrCopy(tstr,':Q')
//		CASE 13;	StrCopy(tstr,':UQ')
		DEFAULT;	StringF(tstr,'\s',NIL)
		ENDSELECT
		SELECT var.type
		CASE 0,1,2;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[8])\s[80]',addr,var.name,tstr,value,value,NIL)
		CASE 7;		EStringF(str,'[$\z\h[8]] \s\s = \s ($\z\h[8])\s[80]',addr,var.name,tstr,RealStr(strb,flt,7),Long(addr),NIL)
		CASE 8;		EStringF(str,'[$\z\h[8]] \s\s = \s ($\z\h[8].\z\h[8])\s[80]',addr,var.name,tstr,RealStr(strb,flt,15),Long(addr),Long(addr+4),NIL)
		CASE 5,6;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[2])\s[80]',addr,var.name,tstr,value,value,NIL)
		CASE 3,4,9;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[4])\s[80]',addr,var.name,tstr,value,value,NIL)
		DEFAULT;		EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[8])',addr,var.name,tstr,value,value,NIL)
		ENDSELECT
		IF field
			EStringF(strb,'=[$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8]]',Long(value),Long(value+4),Long(value+8),Long(value+12))
			EStrAdd(str,strb)
		ENDIF
		WHILE TextLength(varwnd.RPort,str,EStrLen(str))>width
			SetEStr(str,EStrLen(str)-1)
		ENDWHILE
		Move(varwnd.RPort,4,(n*varwnd.RPort.Font.YSize)+varwnd.RPort.Font.Baseline)
		Text(varwnd.RPort,str,EStrLen(str))
		var:=var.next
		n++
	EXITIF n>=max
	ENDWHILE

ENDPROC

PROC UpdateVar(win:PTR TO win)
	IFN win.type="VAR" THEN RETURN

	// clear the window
	SetAPen(win.window.RPort,0)
	RectFill(win.window.RPort,win.window.BorderLeft,win.window.BorderTop,win.window.Width-win.window.BorderRight-1,win.window.Height-win.window.BorderBottom-1)
	SetAPen(win.window.RPort,1)

	DEF	proc:PTR TO proc,var:PTR TO var,value,a5,field,flt:D,myproc=NIL:PTR TO proc,start,stop
	DEF	n,addr,lcount

	proc:=exe.debug.proc
	n:=0
	WHILE proc
		StringF(str,'_\s',proc.name)
		start:=FindLabelAddr(str)
		IF proc.next
			StringF(str,'_\s',proc.next.name)
			stop:=FindLabelAddr(str)
		ELSE
			stop:=exe.stop
		ENDIF
		IF exe.pc>=start AND exe.pc<stop
			myproc:=proc
			var:=proc.var
			WHILE var
				n++
				var:=var.next
			ENDWHILE
		ENDIF
		proc:=proc.next
	ENDWHILE
	lcount:=n
	var:=exe.debug.var
	WHILE var
		n++
		var:=var.next
	ENDWHILE
	SetGadgetAttrsA(win.vertgadget,win.window,NIL,[PGA_Total,n,TAG_END])
	win.vtotal:=n
	win.htotal:=256

	DEF	x,y
	GetAttr(PGA_Top,win.horizgadget,&x)
	GetAttr(PGA_Top,win.vertgadget,&y)

	DEF	str[256]:STRING,strb[128]:STRING,tstr[32]:CHAR
	DEF	line,strptr:PTR TO CHAR

	start:=y

	IF win.vvisible>n THEN start:=0
	IF start+win.vvisible>=n THEN start:=n-win.vvisible
	IF start<0 THEN start:=0

	DEF	local
	line:=0
	IF start<lcount
		var:=exe.debug.var
		local:=FALSE
	ELSEIF start>=lcount
		IF myproc
			var:=myproc.var
			myproc:=NIL
			local:=TRUE
		ELSE RETURN
	ENDIF
	FOR n:=start TO start+win.vvisible-1
		IF var
			field:=FALSE
			EStringF(str,'_\s',var.name)
			IF local
				a5:=exe.regs[8+5]
				SELECT var.type
				CASE 0,1,2;	value:=Long(a5+var.offset)
				CASE 3;		value:=Word(a5+var.offset)
				CASE 4,9;	value:=UWord(a5+var.offset)
				CASE 5;		value:=Byte(a5+var.offset)
				CASE 6;		value:=UByte(a5+var.offset)
				CASE 7;		flt:=Float(a5+var.offset)
				CASE 8;		flt:=Double(a5+var.offset)
				CASE 10;		field:=1
				DEFAULT;		value:=Long(a5+var.offset)
					IF value&$ff00.0000 THEN field:=TRUE
				ENDSELECT
			ELSE
				addr:=FindLabelAddr(str)
				SELECT var.type
				CASE 0,1,2;	value:=Long(addr)
				CASE 3;		value:=Word(addr)
				CASE 4,9;	value:=UWord(addr)
				CASE 5;		value:=Byte(addr)
				CASE 6;		value:=UByte(addr)
				CASE 7;		flt:=Float(addr)
				CASE 8;		flt:=Double(addr)
				DEFAULT;		value:=Long(addr)
					IF value&$ff00.0000 THEN field:=TRUE
				ENDSELECT
			ENDIF
			SELECT var.type
			CASE 1;	StrCopy(tstr,':L   ')
			CASE 2;	StrCopy(tstr,':UL  ')
			CASE 3;	StrCopy(tstr,':W   ')
			CASE 4;	StrCopy(tstr,':UW  ')
			CASE 5;	StrCopy(tstr,':B   ')
			CASE 6;	StrCopy(tstr,':UB  ')
			CASE 7;	StrCopy(tstr,':F   ')
			CASE 8;	StrCopy(tstr,':D   ')
			CASE 9;	StrCopy(tstr,':BOOL')
			CASE 10;	StringF(tstr,':\s',var.ofto)
			CASE 11;	StrCopy(tstr,':PTR ')
//			CASE 12;	StrCopy(tstr,':Q   ')
//			CASE 13;	StrCopy(tstr,':UQ  ')
			DEFAULT;	StringF(tstr,'\s',NIL)
			ENDSELECT
			IF local
				SELECT var.type
				CASE 0,1,2;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[8])\s[80]',a5+var.offset,var.name,tstr,value,value,NIL)
				CASE 7;		EStringF(str,'[$\z\h[8]] \s\s = \s ($\z\h[8])\s[80]',a5+var.offset,var.name,tstr,RealStr(strb,flt,7),Long(a5+var.offset),NIL)
				CASE 8;		EStringF(str,'[$\z\h[8]] \s\s = \s ($\z\h[8].\z\h[8])\s[80]',a5+var.offset,var.name,tstr,RealStr(strb,flt,15),Long(a5+var.offset),Long(a5+var.offset+4),NIL)
				CASE 5,6;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[2])\s[80]',a5+var.offset,var.name,tstr,value,value,NIL)
				CASE 3,4,9;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[4])\s[80]',a5+var.offset,var.name,tstr,value,value,NIL)
				CASE 10;		EStringF(str,'[$\z\h[8]] \s\s',a5+var.offset,var.name,tstr)
				DEFAULT;		EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[8])',a5+var.offset,var.name,tstr,value,value,NIL)
				ENDSELECT
				IF field=TRUE
					EStringF(strb,'=[$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8]]',Long(value),Long(value+4),Long(value+8),Long(value+12))
					EStrAdd(str,strb)
				ELSEIF field=1
					VEStringF(strb,'=[$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8]]',a5+var.offset)
					EStrAdd(str,strb)
				ENDIF
			ELSE
				SELECT var.type
				CASE 0,1,2;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[8])\s[80]',addr,var.name,tstr,value,value,NIL)
				CASE 7;		EStringF(str,'[$\z\h[8]] \s\s = \s ($\z\h[8])\s[80]',addr,var.name,tstr,RealStr(strb,flt,7),Long(addr),NIL)
				CASE 8;		EStringF(str,'[$\z\h[8]] \s\s = \s ($\z\h[8].\z\h[8])\s[80]',addr,var.name,tstr,RealStr(strb,flt,15),Long(addr),Long(addr+4),NIL)
				CASE 5,6;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[2])\s[80]',addr,var.name,tstr,value,value,NIL)
				CASE 3,4,9;	EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[4])\s[80]',addr,var.name,tstr,value,value,NIL)
				DEFAULT;		EStringF(str,'[$\z\h[8]] \s\s = \d ($\z\h[8])',addr,var.name,tstr,value,value,NIL)
				ENDSELECT
				IF field
					EStringF(strb,'=[$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8]]',Long(value),Long(value+4),Long(value+8),Long(value+12))
					EStrAdd(str,strb)
				ENDIF
			ENDIF

			strptr:=str
			strptr+=x
			IF StrLen(strptr)>win.hvisible THEN strptr[win.hvisible-1]:="\0"
			Move(win.window.RPort,4+win.window.BorderLeft,line*win.window.RPort.Font.YSize+win.window.RPort.Font.Baseline+win.window.BorderTop)
			Text(win.window.RPort,strptr,StrLen(strptr))
			line++

			var:=var.next
		ENDIF
		IF var=NIL
			IF myproc
				var:=myproc.var
				myproc:=NIL
				local:=TRUE
			ENDIF
		ENDIF
	EXITIF var=NIL
		CtrlC()
	ENDFOR
ENDPROC

PROC UpdateReg(win:PTR TO win)
	IFN win.type="REG" THEN RETURN

	DEF	x,y
	GetAttr(PGA_Top,win.horizgadget,&x)
	GetAttr(PGA_Top,win.vertgadget,&y)

	DEF	str[256]:STRING,start,strb[128]:STRING
	DEF	line,n,strptr:PTR TO CHAR

	start:=y

	IF win.vvisible>9 THEN start:=0
	IF start+win.vvisible>=9 THEN start:=9-win.vvisible
	IF start<0 THEN start:=0

	// clear the window
	SetAPen(win.window.RPort,0)
	RectFill(win.window.RPort,win.window.BorderLeft,win.window.BorderTop,win.window.Width-win.window.BorderRight-1,win.window.Height-win.window.BorderBottom-1)
	SetAPen(win.window.RPort,1)

	line:=0
	FOR n:=start TO start+win.vvisible-1
		IF n<8
			EStringF(str,'d\d: $\z\h[8] a\d: $\z\h[8] ',n,exe.regs[n],n,exe.regs[n+8])
			IF exe.regs[n+8]&$ff00.0000
				EStringF(strb,'[$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8],$\z\h[8]]',ULong(exe.regs[n+8]),ULong(exe.regs[n+8]+4),ULong(exe.regs[n+8]+8),ULong(exe.regs[n+8]+12),ULong(exe.regs[n+8]+16),ULong(exe.regs[n+8]+20),ULong(exe.regs[n+8]+24),ULong(exe.regs[n+8]+28))
				EStrAdd(str,strb)
			ENDIF
		ELSE
			EStringF(str,'sr: $\z\h[4] pc: $\z\h[8] ',exe.regs[16],exe.pc)
		ENDIF
		strptr:=str
		strptr+=x
		IF StrLen(strptr)>win.hvisible THEN strptr[win.hvisible-1]:="\0"
		Move(win.window.RPort,4+win.window.BorderLeft,line*win.window.RPort.Font.YSize+win.window.RPort.Font.Baseline+win.window.BorderTop)
		Text(win.window.RPort,strptr,StrLen(strptr))
	EXITIF line>=8
		line++
		CtrlC()
	ENDFOR
ENDPROC

PROC Update()
	updatescrollerwindow(exe.varwin)
	updatescrollerwindow(exe.srcwin)
	updatescrollerwindow(exe.regwin)
ENDPROC

PROC GetLine(lab:PTR TO CHAR)(L)
	DEF	line,add
	IF StrCmp(lab,'line_',5)=FALSE THEN RETURN TRUE
	lab+=5
	add:=InStr(lab,'_')
	IF add=-1 THEN RETURN TRUE
	lab+=add+1
	line:=Val(lab)
	IF line=0 THEN RETURN TRUE
ENDPROC line-1

PROC GetProc(dst:PTR TO CHAR,lab:PTR TO CHAR)(PTR)
	DEF	add
	IF StrCmp(lab,'line_',5)=FALSE THEN RETURN TRUE
	lab+=5
	add:=InStr(lab,'_')
	StrCopy(dst,lab,add)
ENDPROC dst

OPT	LINK='*ddbg_trace.o'
RPROC Trace(a0:PTR,a1:PTR,a2:PTR,a3:PTR)(UL,PTR)

DEF	command=NIL,currentproc[64]:CHAR

// this is the main procedure, that executes after each instruction of the
// debugger proggy
PROC Test(pc:PTR IN a0,rl:PTR TO UL IN A1)(L)
	DEF	lab:PTR TO CHAR,line,dst[64]:CHAR
	exe.pc:=pc
	exe.regs:=rl
	cicount++
	IF command="in" AND (lab:=FindLineAddr(exe.pc))<>NIL
		command:="st"
		line:=GetLine(lab)
		exe.src.line:=line
		Update()
	ELSEIF command="ov" AND (lab:=FindLineAddr(exe.pc))<>NIL
		IF StrCmp(GetProc(dst,lab),currentproc)
			command:="st"
			line:=GetLine(lab)
			exe.src.line:=line
			Update()
		ENDIF
//		PrintF('\s\n',dst)
	ELSEIF exe.pc=exe.breakpoints.addr
		PrintF('breakpoint reached!\n')
		command:="st"
		IF lab:=FindLineAddr(exe.pc)
			line:=GetLine(lab)
			exe.src.line:=line
			Update()
		ENDIF
	ELSEIF command="ai"
		command:="st"
		Update()
	ELSEIF (lab:=FindLineAddr(exe.pc))<>NIL
		line:=GetLine(lab)
		exe.src.line:=line
		Update()
	ENDIF
//	PrintF('\c\c ',command>>8,command)
//	nextinst:=DisAsm68k(pc,0,FindLabelGlobal(exe.pc))
//	PrintF('$\h ',command)
	IF command="st"
		WaitMessage()
		WHILEN command:=GetMessage()
			WaitMessage()
		ENDWHILE
		SELECT command
		CASE "ov"
			IF lab THEN StrCopy(currentproc,GetProc(dst,lab))
		ENDSELECT
	ELSE
		IF GetMessage() THEN command:="st"
	ENDIF
	icount++
ENDPROC FALSE

OBJECT breakpoint
	addr:UL,next:PTR TO breakpoint

PROC RunCustomCode(rl:PTR TO UL)
	DEF	lab[80]:STRING
	exe.pc:=exe.hunks[0]
	exe.regs:=rl
	command:="go"
	exe.breakpoints:=[FindLabelAddr('_main'),NIL]:breakpoint
	EStringF(lab,'\sfinish',exe.debug.lastproc.name)
	Trace(exe.pc,&Test,exe.start,FindLabelAddr(lab))
	PrintF('total traced instruction count: \d\n',icount)
	PrintF(' custom code instruction count: \d\n',cicount)
ENDPROC

DEF	icount=0,cicount=0







PROC WaitMessage()
	DEF	signals
//	PrintF('Waiting...\n')
	signals:=1<<mainwnd.UserPort.SigBit
	IF exe.srcwin.type="SRC" THEN signals|=1<<exe.srcwin.window.UserPort.SigBit
	IF exe.regwin.type="REG" THEN signals|=1<<exe.regwin.window.UserPort.SigBit
	IF exe.varwin.type="VAR" THEN signals|=1<<exe.varwin.window.UserPort.SigBit
	Wait(signals)
//	PrintF('god a message.\n')
ENDPROC

PROC GetMessage()(L)
	DEF	mes:IntuiMessage,message:PTR TO IntuiMessage,win:PTR TO win,window:PTR TO Window,oldtop,v
	DEF	infos:PTR TO Gadget,id
	REPEAT
		id:=0
		IF message:=GT_GetIMsg(mainwnd.UserPort)
			CopyMem(message,mes,SIZEOF_IntuiMessage)
			GT_ReplyIMsg(message)
			window:=mainwnd
			win:=NIL
//			PrintF('main\n')
		ELSEIF exe.srcwin.type="SRC"
			IF message:=GetMsg(exe.srcwin.window.UserPort)
				CopyMem(message,mes,SIZEOF_IntuiMessage)
				ReplyMsg(message)
				win:=exe.srcwin
				window:=win.window
//				PrintF('src\n')
			ENDIF
		ENDIF
		IFN message
			IF exe.regwin.type="REG"
				IF message:=GetMsg(exe.regwin.window.UserPort)
					CopyMem(message,mes,SIZEOF_IntuiMessage)
					ReplyMsg(message)
					win:=exe.regwin
					window:=win.window
//					PrintF('reg\n')
				ENDIF
			ENDIF
		ENDIF
		IFN message
			IF exe.varwin.type="VAR"
				IF message:=GetMsg(exe.varwin.window.UserPort)
					CopyMem(message,mes,SIZEOF_IntuiMessage)
					ReplyMsg(message)
					win:=exe.varwin
					window:=win.window
//					PrintF('var\n')
				ENDIF
			ENDIF
		ENDIF
//		PrintF('\h\n',message)
	EXITIFN message
		IF message
			SELECT mes.Class
			CASE IDCMP_CLOSEWINDOW
//				PrintF('close\n')
				SELECT win
				CASE exe.srcwin;	id:="QUIT"
				CASE exe.varwin;	close_window("VAR");	id:=0
				CASE exe.regwin;	close_window("REG");	id:=0
				DEFAULT;				id:="QUIT"
				ENDSELECT
			CASE IDCMP_NEWSIZE
//				PrintF('resized\n')
				IF win THEN updatescrollerwindow(win)
			CASE IDCMP_REFRESHWINDOW
//				PrintF('refreshed\n')
				BeginRefresh(window)
				IF win THEN updatescrollerwindow(win)
				EndRefresh(window,TRUE)
			CASE IDCMP_IDCMPUPDATE
//				PrintF('boopsi\n')
				v:=GetTagData(GA_ID,0,mes.IAddress)
				SELECT v
				CASE HORIZ_GID
					copybitmap(win)
				CASE VERT_GID
					copybitmap(win)
				CASE LEFT_GID
					GetAttr(PGA_Top,win.horizgadget,&oldtop)
					IF oldtop>0
						updateprop(window,win.horizgadget,PGA_Top,oldtop-1)
						copybitmap(win)
					ENDIF
				CASE RIGHT_GID
					GetAttr(PGA_Top,win.horizgadget,&oldtop)
					IF oldtop<(win.htotal-win.hvisible)
						updateprop(window,win.horizgadget,PGA_Top,oldtop+1)
						copybitmap(win)
					ENDIF
				CASE UP_GID
					GetAttr(PGA_Top,win.vertgadget,&oldtop)
					IF oldtop>0
						updateprop(window,win.vertgadget,PGA_Top,oldtop-1)
						copybitmap(win)
					ENDIF
				CASE DOWN_GID
					GetAttr(PGA_Top,win.vertgadget,&oldtop)
					IF oldtop<(win.vtotal-win.vvisible)
						updateprop(window,win.vertgadget,PGA_Top,oldtop+1)
						copybitmap(win)
					ENDIF
				ENDSELECT
			CASE IDCMP_GADGETUP
//				PrintF('gadget\n')
				infos:=mes.IAddress
				id:=infos.GadgetID
			CASE IDCMP_MENUPICK
//				PrintF('menu\n')
				infos:=mes.Code
				IF item:=ItemAddress(window.MenuStrip,infos)
					id:=Long(item+34)
				ELSE
					id:=0
				ENDIF
			ENDSELECT

			SELECT id
			CASE "REGS"
				IFN exe.regwin.type="REG" THEN open_window("REG",300,160) ELSE close_window("REG")
				id:=0
			CASE "VARS"
				IFN exe.varwin.type="VAR" THEN open_window("VAR",600,160) ELSE close_window("VAR")
				id:=0
			CASE "FIND"
				Find()
				id:=0
			CASE "NEXT"
				Next()
				id:=0
			CASE "LINE"
				Line()
				id:=0
			CASE "REFR"
				Update()
				id:=0
			CASE "QUIT"
				close_window("SRC")
				close_window("REG")
				close_window("VAR")
				id:="ex"
			ENDSELECT
		ENDIF
	UNTIL id
ENDPROC id

MODULE 'gadtools',
       'libraries/gadtools',
       'intuition/intuition',
       'intuition/screens',
       'intuition/gadgetclass',
       'intuition/iobsolete',
       'utility/tagitem',
       'devices/inputevent',
       'graphics/text'
MODULE	'reqtools',
			'libraries/reqtools'

DEF mainwnd=NIL:PTR TO Window,
    mainmenus=NIL,
    mainglist=NIL,
    varwnd=NIL:PTR TO Window,
    scr=NIL:PTR TO Screen,
    visual=NIL,
    offx,offy,
    tattr:PTR TO TextAttr,
    item:PTR TO MenuItem
DEF	GadToolsBase
DEF	ReqToolsBase

PROC setupscreen()
	IFN GadToolsBase:=OpenLibrary('gadtools.library',37) THEN Raise("GTLI")
	IFN ReqToolsBase:=OpenLibrary('reqtools.library',37) THEN Raise("RTLI")
	IFN scr:=LockPubScreen('Workbench') THEN Raise("WBSC")
	IFN visual:=GetVisualInfoA(scr,NIL) THEN Raise("VISU")
	offy:=offx:=0
	tattr:=NIL	//['topaz.font',8,0,0]:TextAttr
ENDPROC

PROC closedownscreen()
	IF visual THEN FreeVisualInfo(visual)
	IF scr THEN UnlockPubScreen(NIL,scr)
	IF GadToolsBase THEN CloseLibrary(GadToolsBase)
	IF ReqToolsBase THEN CloseLibrary(ReqToolsBase)
ENDPROC

PROC openmainwindow()
  DEF g:PTR TO Gadget
  IFN g:=CreateContext(&mainglist) THEN Raise("GADG")
  IFN g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+4,offy+4,33,33,'In',tattr,"in",PLACETEXT_IN,visual,0]:NewGadget,
    [TAG_END]) THEN Raise("GADG")
  IFN g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+40,offy+4,33,33,'Over',tattr,"ov",PLACETEXT_IN,visual,0]:NewGadget,
    [GA_Disabled,FALSE,TAG_END]) THEN Raise("GADG")
  IFN g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+76,offy+4,33,33,'Run',tattr,"go",PLACETEXT_IN,visual,0]:NewGadget,
    [GA_Disabled,TRUE,TAG_END]) THEN Raise("GADG")
  IFN g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+112,offy+4,33,33,'Stop',tattr,"st",PLACETEXT_IN,visual,0]:NewGadget,
    [GA_Disabled,TRUE,TAG_END]) THEN Raise("GADG")
  IFN g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+148,offy+4,33,33,'Asm',tattr,"ai",PLACETEXT_IN,visual,0]:NewGadget,
    [GA_Disabled,TRUE,TAG_END]) THEN Raise("GADG")
  IFN g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+184,offy+4,33,33,'Over',tattr,"ao",PLACETEXT_IN,visual,0]:NewGadget,
    [GA_Disabled,TRUE,TAG_END]) THEN Raise("GADG")
  IFN g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+220,offy+4,33,33,'Raise',tattr,"ra",PLACETEXT_IN,visual,0]:NewGadget,
    [GA_Disabled,TRUE,TAG_END]) THEN Raise("GADG")
  IFN mainmenus:=CreateMenus([
    NM_TITLE,'Debug',            NIL,$0,0,0,
    NM_ITEM ,'Find...',          'F',$0,0,"FIND",
    NM_ITEM ,'Next',             'N',$0,0,"NEXT",
    NM_ITEM ,'Jump to line...',  'L',$0,0,"LINE",
    NM_ITEM ,NM_BARLABEL,        NIL,$0,0,0,
    NM_ITEM ,'Regs',             'R',$0,0,"REGS",
//    NM_ITEM ,'Memory',           NIL,$0,0,0,
    NM_ITEM ,'Variables',        'V',$0,0,"VARS",
    NM_ITEM ,NM_BARLABEL,        NIL,$0,0,0,
    NM_ITEM ,'Refresh',          ' ',$0,0,"REFR",
    NM_ITEM ,NM_BARLABEL,        NIL,$0,0,0,
    NM_ITEM ,'Run and Quit',     'Q',$0,0,"QUIT",
    0,0,0,0,0,0,0]:NewMenu,NIL) THEN Raise("MENU")
  IF LayoutMenusA(mainmenus,visual,NIL)=FALSE THEN Raise("MENU")
  IF (mainwnd:=OpenWindowTagList(NIL,
    [WA_Left,0,
     WA_Top,scr.BarHeight+1,
     WA_InnerWidth,257,
     WA_InnerHeight,41,
     WA_IDCMP,IDCMP_GADGETUP|IDCMP_MENUPICK|IDCMP_RAWKEY|IDCMP_CLOSEWINDOW,
     WA_Flags,WFLG_CLOSEGADGET|WFLG_DEPTHGADGET|WFLG_DRAGBAR|WFLG_GIMMEZEROZERO|WFLG_ACTIVATE,
     WA_Title,'Debugger',
     WA_CustomScreen,scr,
     WA_AutoAdjust,TRUE,
     WA_Gadgets,mainglist,
     WA_NewLookMenus,TRUE,
     TAG_END]))=NIL THEN Raise("WIND")
  IF SetMenuStrip(mainwnd,mainmenus)=FALSE THEN Raise("MENU")
  GT_RefreshWindow(mainwnd,NIL)
ENDPROC

PROC closemainwindow()
	close_window("VAR")
	close_window("REG")
	close_window("SRC")
	IF mainwnd THEN ClearMenuStrip(mainwnd)
	IF mainmenus THEN FreeMenus(mainmenus)
	IF mainwnd THEN CloseWindow(mainwnd)
	IF mainglist THEN FreeGadgets(mainglist)
ENDPROC

DEF	find_str[64]:CHAR,find_start=0

PROC Find()
	find_start:=0
	StrCopy(find_str,'')
	rtGetStringA(find_str,64,'Enter a text to find:',0,0)
	IF StrLen(find_str)=0
		DisplayBeep(NIL)
		RETURN
	ENDIF
	Next()
ENDPROC

PROC Next()
	DEF	line=find_start
	WHILE line<exe.src.linecount
		IF InStr(exe.src.lines[line],find_str)<>TRUE
			find_start:=line+1
			exe.src.showline:=line
			updateprop(exe.srcwin.window,exe.srcwin.vertgadget,PGA_Top,line)
			UpdateSrc(exe.srcwin)
			exe.src.showline:=-1
			RETURN
		ENDIF
		line++
	ENDWHILE
	IF line=>exe.src.linecount
		DisplayBeep(NIL)
		find_start:=0
	ENDIF
ENDPROC

DEF	line_jump=-1

PROC Line()
	line_jump:=exe.src.line+1
	rtGetLongA(&line_jump,'Enter a line number:',0,0)
	IF line_jump<0 OR line_jump>=exe.src.linecount
		line_jump:=exe.src.line+1
		DisplayBeep(NIL)
		RETURN
	ENDIF
	exe.src.showline:=line_jump-1
	updateprop(exe.srcwin.window,exe.srcwin.vertgadget,PGA_Top,line_jump-1)
	UpdateSrc(exe.srcwin)
	exe.src.showline:=-1
ENDPROC













MODULE 'exec/memory', 'exec/libraries', 'utility', 'utility/tagitem',
       'intuition/intuition', 'intuition/imageclass', 'intuition/screens',
       'intuition/classes', 'intuition/icclass', 'intuition/gadgetclass',
       'intuition/imageclass','graphics/gfx', 'graphics/text', 'graphics/rastport'

DEF screen=NIL:PTR TO Screen,dri=NIL:PTR TO DrawInfo
DEF UtilityBase=NIL

ENUM HORIZ_GID=1,VERT_GID,LEFT_GID,RIGHT_GID,UP_GID,DOWN_GID

PROC max(x,y)(L) IS IF x>y THEN x ELSE y
PROC min(x,y)(L) IS IF x<y THEN x ELSE y

PROC sysisize()(L) IS
 IF screen.Flags AND SCREENHIRES THEN SYSISIZE_MedRes ELSE SYSISIZE_LowRes

PROC newimageobject(which)(L) IS
  NewObjectA(NIL,'sysiclass',
    [SYSIA_DrawInfo,dri,SYSIA_Which,which,SYSIA_Size,sysisize(),NIL])

PROC newpropobject(freedom,taglist)(L) IS
  NewObjectA(NIL,'propgclass',
    [ICA_TARGET,ICTARGET_IDCMP,PGA_Freedom,freedom,PGA_NewLook,TRUE,
     PGA_Borderless,(dri.Flags AND DRIF_NEWLOOK) AND (dri.Depth<>1),
     TAG_MORE,taglist])

PROC newbuttonobject(image:PTR TO _Object,taglist)(L) IS
  NewObjectA(NIL,'buttongclass',
    [ICA_TARGET,ICTARGET_IDCMP,GA_Image,image,TAG_MORE,taglist])

PROC openscrollerwindow(win:PTR TO win,taglist)
  DEF resolution,topborder,sf:PTR TO TextAttr,w,h,bw,bh,rw,rh,gw,gh,gap
  resolution:=sysisize()
  sf:=screen.Font
  topborder:=screen.WBorTop+sf.YSize+1
  w:=win.sizeimage.Width
  h:=win.sizeimage.Height
  bw:=IF resolution=SYSISIZE_LowRes THEN 1 ELSE 2
  bh:=IF resolution=SYSISIZE_HiRes THEN 2 ELSE 1
  rw:=IF resolution=SYSISIZE_HiRes THEN 3 ELSE 2
  rh:=IF resolution=SYSISIZE_HiRes THEN 2 ELSE 1
  gh:=max(win.leftimage.Height,h)
  gh:=max(win.rightimage.Height,gh)
  gw:=max(win.upimage.Width,w)
  gw:=max(win.downimage.Width,gw)
  gap:=1
  win.horizgadget:=newpropobject(FREEHORIZ,
    [GA_Left,rw+gap,
     GA_RelBottom,bh-gh+2,
     GA_RelWidth,(-gw)-gap-win.leftimage.Width-win.rightimage.Width-rw-rw,
     GA_Height,gh-bh-bh-2,
     GA_BottomBorder,TRUE,
     GA_ID,HORIZ_GID,
     PGA_Total,win.htotal,
     PGA_Visible,win.hvisible,
     NIL])
  win.vertgadget:=newpropobject(FREEVERT,
    [GA_RelRight,bw-gw+3,
     GA_Top,topborder+rh,
     GA_Width,gw-bw-bw-4,
     GA_RelHeight,(-topborder)-h-win.upimage.Height-win.downimage.Height-rh-rh,
     GA_RightBorder,TRUE,
     GA_Previous,win.horizgadget,
     GA_ID,VERT_GID,
     PGA_Total,win.vtotal,
     PGA_Visible,win.vvisible,
     NIL])
  win.leftgadget:=newbuttonobject(win.leftimage,
    [GA_RelRight,(1)-win.leftimage.Width-win.rightimage.Width-gw,
     GA_RelBottom,(1)-win.leftimage.Height,
     GA_BottomBorder,TRUE,
     GA_Previous,win.vertgadget,
     GA_ID,LEFT_GID,
     NIL])
  win.rightgadget:=newbuttonobject(win.rightimage,
    [GA_RelRight,(1)-win.rightimage.Width-gw,
     GA_RelBottom,(1)-win.rightimage.Height,
     GA_BottomBorder,TRUE,
     GA_Previous,win.leftgadget,
     GA_ID,RIGHT_GID,
     NIL])
  win.upgadget:=newbuttonobject(win.upimage,
    [GA_RelRight,(1)-win.upimage.Width,
     GA_RelBottom,(1)-win.upimage.Height-win.downimage.Height-h,
     GA_RightBorder,TRUE,
     GA_Previous,win.rightgadget,
     GA_ID,UP_GID,
     NIL])
  win.downgadget:=newbuttonobject(win.downimage,
    [GA_RelRight,(1)-win.downimage.Width,
     GA_RelBottom,(1)-win.downimage.Height-h,
     GA_RightBorder,TRUE,
     GA_Previous,win.upgadget,
     GA_ID,DOWN_GID,
     NIL])
  IF win.downgadget
    win.window:=OpenWindowTagList(NIL,
      [WA_Gadgets,win.horizgadget,
       WA_MinWidth,max(80,gw+gap+win.leftimage.Width+win.rightimage.Width+rw+rw+KNOBHMIN),
       WA_MinHeight,max(50,topborder+h+win.upimage.Height+win.downimage.Height+rh+rh+KNOBVMIN),
       TAG_MORE,taglist])
  ENDIF
ENDPROC

PROC closescrollerwindow(win:PTR TO win)
	IF win.window THEN CloseWindow(win.window)
	DisposeObject(win.horizgadget)
	DisposeObject(win.vertgadget)
	DisposeObject(win.leftgadget)
	DisposeObject(win.rightgadget)
	DisposeObject(win.upgadget)
	DisposeObject(win.downgadget)
ENDPROC

PROC recalchvisible(window:PTR TO Window)(L)
	DEF	str[256]:STRING,width
	EStrCopy(str,'W')
	width:=window.Width-window.BorderLeft-window.BorderRight
	WHILE TextLength(window.RPort,str,EStrLen(str))<width
		EStrAdd(str,'W')
	ENDWHILE
ENDPROC EStrLen(str)-1
PROC recalcvvisible(window:PTR TO Window)(L) IS (window.Height-window.BorderTop-window.BorderBottom)/window.RPort.Font.YSize

PROC updateprop(window:PTR TO Window,gadget:PTR TO _Object,attr,value)
	SetGadgetAttrsA(gadget,window,NIL,[attr,value,TAG_END])
ENDPROC

PROC copybitmap(win:PTR TO win)
	SELECT win.type
	CASE "SRC";	UpdateSrc(win)
	CASE "REG";	UpdateReg(win)
	CASE "VAR";	UpdateVar(win)
	ENDSELECT
ENDPROC

PROC updatescrollerwindow(win:PTR TO win)
//	PrintF('visible h: \d, v: \d\n',win.hvisible,win.vvisible)
	win.hvisible:=recalchvisible(win.window)
	win.vvisible:=recalcvvisible(win.window)
//	PrintF('visible h: \d, v: \d\n',win.hvisible,win.vvisible)

	updateprop(win.window,win.horizgadget,PGA_Visible,win.hvisible)
	updateprop(win.window,win.vertgadget,PGA_Visible,win.vvisible)

//	PrintF('Copying...\n')
	copybitmap(win)
ENDPROC

PROC open_window(type,wi,he)
	DEF	name:PTR TO CHAR,win:PTR TO win
	SELECT type
	CASE "SRC";	name:='source code';	win:=exe.srcwin
	CASE "REG";	name:='registers';	win:=exe.regwin
	CASE "VAR";	name:='variables';	win:=exe.varwin
	DEFAULT;		name:='window'
	ENDSELECT

	win.hvisible:=wi/screen.Font.YSize
	win.vvisible:=he/screen.Font.YSize
	win.sizeimage:=newimageobject(SIZEIMAGE)
	win.leftimage:=newimageobject(LEFTIMAGE)
	win.rightimage:=newimageobject(RIGHTIMAGE)
	win.upimage:=newimageobject(UPIMAGE)
	win.downimage:=newimageobject(DOWNIMAGE)
	IFN (win.sizeimage<>0) AND (win.leftimage<>0) AND (win.rightimage<>0) AND (win.upimage<>0) AND (win.downimage<>0)
		Raise("IMGS")
	ENDIF
	openscrollerwindow(win,[
		WA_PubScreen,screen,
		WA_Title,name,
		WA_Flags,WFLG_CLOSEGADGET|WFLG_SIZEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_SMART_REFRESH|WFLG_ACTIVATE|WFLG_NEWLOOKMENUS,
		WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_REFRESHWINDOW|IDCMP_IDCMPUPDATE,
		WA_Left,(screen.Width-wi)/2,
		WA_Top,(screen.Height-he)/2,
		WA_InnerWidth,wi,
		WA_InnerHeight,he,
		WA_MaxWidth,-1,
		WA_MaxHeight,-1,
		TAG_END])
//	PrintF('Updating...\n')
	IF win.window
		win.type:=type
		updatescrollerwindow(win)
	ELSE Raise("WIND")
//	PrintF('Done.\n')
ENDPROC

PROC close_window(type)
	DEF	win=NIL:PTR TO win
	SELECT type
	CASE "SRC";	win:=exe.srcwin
	CASE "REG";	win:=exe.regwin
	CASE "VAR";	win:=exe.varwin
	ENDSELECT
	IF win
		closescrollerwindow(win)
		IF win.sizeimage  THEN DisposeObject(win.sizeimage)
		IF win.leftimage  THEN DisposeObject(win.leftimage)
		IF win.rightimage THEN DisposeObject(win.rightimage)
		IF win.upimage    THEN DisposeObject(win.upimage)
		IF win.downimage  THEN DisposeObject(win.downimage)
		win.type:=NIL
	ENDIF
ENDPROC
