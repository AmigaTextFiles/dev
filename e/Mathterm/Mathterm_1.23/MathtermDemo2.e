/*****************************************************
*
*				Mathterm-Demo 2
*
******************************************************
*
* shows how to struggle with the funccontext-OBJECT
* this time we use the double-modules
*
* author			Marcel Bennicke
* 					marcel.bennicke@t-online.de
*
* ec				V3.2e registered
* date				03.06.1996
* last modified		16.06.1996
*
* PREFS				TAB=4
*
*****************************************************/

MODULE	'tools/mathtermd','tools/doublesupport',
		'tools/mathtermerrorstrings',

		'intuition/intuition','utility/tagitem'


ENUM	ERR_NONE, ERR_MATH

RAISE	"lib" IF OpenLibrary()=NIL,
		"MEM" IF String()=NIL,
		"MEM" IF List()=NIL



PROC main() HANDLE
	DEF fc=NIL:PTR TO funccontextd -> I don't like global data

	openLibs()
	mtdInit(ERR_MATH)

	NEW fc.funccontextd()	-> initialize context-OBJECT

	WriteF('This program will demonstrate the funccontext-OBJECT.\n'+
			'Please feel free to follow the instructions.\n')

	LOOP		-> we quit via Exception "quit"
		do_action(menu(), fc)
	ENDLOOP

EXCEPT

	SELECT exception
	CASE "lib"
		WriteF('Failed opening math-libs!\n')
	CASE ERR_MATH
		handle_matherror()
	CASE "MEM"
		WriteF('Sorry, out of memory!\n')
	CASE "quit"
		WriteF('\n\nprogram quits.\n')
	CASE "GURU"
		WriteF('Guru abgefangen.\n')
	ENDSELECT

	END fc
	mtdCleanup()
	closeLibs()
ENDPROC


PROC do_action(ac, fc:PTR TO funccontextd) HANDLE
	SELECT ac
		CASE "v";	view(fc)
		CASE "c";	clear(fc)
		CASE "a";	add(fc)
		CASE "d";	remove(fc)
		CASE "i";	inquire(fc)
		CASE "p";	plot(fc)
		CASE "e";	evaluate(fc)
		CASE "q";	Raise("quit")
	ENDSELECT
EXCEPT
	SELECT exception
	CASE "quit"
		ReThrow()
	CASE ERR_MATH
		handle_matherror()
	CASE "MEM"
		WriteF('Sorry, out of memory!\n')
	ENDSELECT
ENDPROC


PROC openLibs()
	mathieeedoubbasbase:=OpenLibrary('mathieeedoubbas.library',0)
	mathieeedoubtransbase:=OpenLibrary('mathieeedoubtrans.library',0)
ENDPROC

PROC closeLibs()
	IF mathieeedoubbasbase THEN CloseLibrary(mathieeedoubbasbase)
	IF mathieeedoubtransbase THEN CloseLibrary(mathieeedoubtransbase)
ENDPROC


PROC menu()
	DEF i[4]:STRING

	WriteF('\npress <RETURN>')
	ReadStr(stdout,i)
	WriteF('\c',12)		-> Clear Console

	WriteF('Today\as menu:\n\n')
	WriteF(	'  v       view current list of terms\n'+
			'  c       clear list\n\n'+
			'  a       add a term\n'+
			'  d       delete a term\n'+
			'  i       inquire term\n'+
			'  p       plot graph\n'+
			'  e       evaluate term\n\n'+
			'  q       quit program\n\n'+
			'input> ')

	ReadStr(stdout,i)
	WriteF('\c',12)
ENDPROC i[]

PROC handle_matherror()
	DEF s[MT_ERRORLENGTH]:STRING, err, info

	err,info := mtdGetError()
	WriteF('\nMathterm-Error:\n\s!\n',getMTErrorStr(s,err,info))
ENDPROC


PROC view(fc:PTR TO funccontextd)
	DEF mt=NIL:PTR TO mathtermd

	WriteF('Content of list:\n\n')
	-> isn't that short?
	WHILE mt:=fc.nextTerm(mt) DO WriteF('\l\s[15] \s\n',mt.getFuncName(),mt.getFuncTerm())
ENDPROC

PROC clear(fc:PTR TO funccontextd)
	DEF i[5]:STRING

	view(fc)
	WriteF('\nReally clear the list (n|Y)? ')
	ReadStr(stdout,i)
	IF i[]="Y"
		fc.clear()
		WriteF('List cleared.\n')
	ELSE
		WriteF('List NOT cleared.\n')
	ENDIF
ENDPROC

PROC add(fc:PTR TO funccontextd) HANDLE
	DEF name[30]:STRING, descr[100]:STRING,
		in[20]:STRING, varlist=NIL:PTR TO LONG,
		mt:PTR TO mathtermd

	WriteF('Add new term\n\n')

	WriteF('enter name: ')
	ReadStr(stdout,name)

	WriteF('enter number of variables: ')
	ReadStr(stdout,in);
	varlist:=getVars(in)
	
	WriteF('enter description: ')
	ReadStr(stdout, descr)
	mt:=fc.addTerm(name, descr, varlist)

EXCEPT DO
	disposeVars(varlist)	-> will be copied
	ReThrow()
ENDPROC

PROC getVars(in:PTR TO CHAR)
	DEF vars=NIL:PTR TO LONG,i,num,
		name[30]:STRING

	num:=Val(in)
	IF num>0
		vars:=List(num)
		FOR i:=1 TO num
			WriteF(' enter name for variable \d[2]: ',i)
			ReadStr(stdout,name)
			vars[i-1]:=String(StrLen(name))
			StrCopy(vars[i-1],name)
		ENDFOR
		SetList(vars,num)	-> important!
	ENDIF
ENDPROC vars

PROC disposeVars(list:PTR TO LONG)
	DEF i

	IF list
		FOR i:=0 TO ListLen(list)-1 DO IF list[i] THEN DisposeLink(list[i])
	ENDIF
ENDPROC


PROC remove(fc:PTR TO funccontextd)
	DEF name[30]:STRING,
		mt=NIL:PTR TO mathtermd

	WriteF('Remove term from list\n\n')
	view(fc);
	WriteF('\nenter name of term: ')
	ReadStr(stdout,name)
	
	mt:=fc.findTerm(name)
	IF mt
		fc.removeTerm(mt)	-> may raise exception
		WriteF('Term \a\s\a successfully removed.\n',name)
	ELSE
		WriteF('Term \a\s\a not found.\n',name)
	ENDIF
ENDPROC

PROC inquire(fc:PTR TO funccontextd)
	DEF name[30]:STRING, mt=NIL:PTR TO mathtermd

	WriteF('Inquire Term\n\n')
	view(fc)
	WriteF('\nSelect term to inquire: ')
	ReadStr(stdout,name)

	IF mt:=fc.findTerm(name)
		termInfo(mt)
	ELSE
		WriteF('Term \a\s\a not found',name)
	ENDIF
ENDPROC

PROC termInfo(mt:PTR TO mathtermd)
	DEF i, x:longreal, s[60]:STRING

	WriteF('Information about \a\s\a:\n\n',mt.getFuncName())
	WriteF('description: \s\n',mt.getFuncTerm())
	WriteF('\nvariables: \d\n',mt.getVarCount())
	FOR i:=0 TO mt.getVarCount()-1
		double2Estr(s,mt.getVar(x,i))
		WriteF(' variable \l\s[20] = \s\n',mt.getVarName(i),s)
	ENDFOR
	WriteF('\nnumber of users: \d\n',mt.getUsers())
ENDPROC

PROC plot(fc:PTR TO funccontextd)
	DEF in[30]:STRING, mtd=NIL:PTR TO mathtermd,

		left:longreal, right:longreal,top:longreal,
		bottom:longreal

	WriteF('Plot graph\n\n'+
			'Please notice that only 1st variable will be used as\n'+
			'iterator (hey, this is a demo, not a 3D-graph-plotter!)\n\n')

	view(fc)
	WriteF('\nChoose term to plot: ')
	ReadStr(stdout,in)
	mtd:=fc.findTerm(in)
	IF mtd
		IF mtd.getVarCount()=0
			WriteF('Term \a\s\a has no variables!\n',in)
			RETURN
		ENDIF
		
		WriteF('Enter boundings:\n')

		WriteF('   left = ')
		ReadStr(stdout,in)
		str2Double(left,in)

		WriteF('  right = ')
		ReadStr(stdout,in)
		str2Double(right,in)

		WriteF(' bottom = ')
		ReadStr(stdout,in)
		str2Double(bottom,in)

		WriteF('    top = ')
		ReadStr(stdout,in)
		str2Double(top,in)

		do_plot(mtd,left,right,bottom,top)
	ELSE
		WriteF('Term \a\s\a not found.\n',in)
	ENDIF
ENDPROC

PROC do_plot(mt:PTR TO mathtermd,
			l:PTR TO longreal,r:PTR TO longreal,
			b:PTR TO longreal,t:PTR TO longreal) HANDLE

	RAISE "WIN" IF OpenWindowTagList()=NIL

	DEF qh:longreal, qv:longreal,	-> Qutoient horiz/vert
		curr:longreal, temp:longreal, result:longreal,

		w:PTR TO window, rp, i


		dSub(r,l,qh)		-> qh := right - left
		dSub(t,b,qv)		-> qv := top - bottom
		str2Double(temp,'200')	-> window-width & height will be 200
		dDiv(qh,temp)		-> this we must add for each pixel we go forward on screen (horizontal zoom)
		dDiv(qv,temp)		-> used to zoom vertical

	w:=OpenWindowTagList(NIL,[WA_TITLE,'Graph',
			WA_TOP,15, WA_LEFT,0,
			WA_INNERWIDTH, 200, WA_INNERHEIGHT, 200,
			WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_RAWKEY,
			WA_FLAGS, WFLG_DRAGBAR OR WFLG_CLOSEGADGET OR WFLG_DEPTHGADGET OR WFLG_GIMMEZEROZERO OR WFLG_ACTIVATE,
			TAG_DONE,0]:tagitem)

	rp:=w.rport			-> draw lines
	SetAPen(rp,2)
	Move(rp,100,0)
	Draw(rp,100,200)
	Move(rp,0,100)
	Draw(rp,200,100)

	SetAPen(rp,1)

	dCopy(curr,l)
	FOR i:=0 TO 199
		mt.setVar(curr,0)		-> set 1st variable
		mt.calc(result)			-> calculate

		dDiv(result,qv)			-> zoom for top/bottom

		-> convert to LONG, correct vertical center/mirror and draw
		WritePixel(rp,i,100-dFix(result))
		dAdd(curr,qh)			-> add "pixelstep" to current
	ENDFOR

	WaitIMessage(w)
	CloseWindow(w)

EXCEPT
	SELECT exception
	CASE "WIN"	
		WriteF('Couldn\at open window!\n')
	ENDSELECT
ENDPROC


PROC evaluate(fc:PTR TO funccontextd) HANDLE
	DEF in[30]:STRING,mt:PTR TO mathtermd,
		result:longreal, out[80]:STRING

	WriteF('Evaluate Term\n\n')
	view(fc)
	WriteF('\nChoose term to evaluate: ')
	ReadStr(stdout,in)
	mt:=fc.findTerm(in)
	
	IF mt
		IF mt.getVarCount()>0
			WriteF('Please notice, that inputs like \asin(pi*0.75)\a\nare handled as well.\n\n')

			LOOP
				inputVars(fc,mt)
				mt.calc(result)
				double2Estr(out,result)
				WriteF('Result: \s\n\n',out)
			ENDLOOP
		ELSE
			mt.calc(result)
			double2Estr(out,result)
			WriteF('Result: \s\n\n',out)
		ENDIF
	ELSE
		WriteF('Term \a\s\a not found.',in)
	ENDIF
EXCEPT
	NOP
ENDPROC

PROC inputVars(fc:PTR TO funccontextd, mt:PTR TO mathtermd)
	DEF i, in[100]:STRING

	FOR i:=0 TO mt.getVarCount()-1
		WriteF('Enter value for variable \l\s[10]: ',mt.getVarName(i))
		ReadStr(stdout,in)
		IF EstrLen(in)=0 THEN Raise("end")
		fc.setVarTerm(mt,in,i)
	ENDFOR
ENDPROC
