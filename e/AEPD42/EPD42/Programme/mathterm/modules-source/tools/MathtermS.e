/**********************************************************************

						MathtermObject

-----------------------------------------------------------------------
:Beschreibung       Objekt, das das Rechnen mit Funktionen, die als
					String übergeben werden, ermöglicht. Dabei können
					beliebig viele Variablen und eigene Funktionen
					zur Laufzeit vereinbart werden.

:EC-Version         3.2e
:Beginn             14.04.1995  (IEEE-Double-Version 1.0 vom 18.01.1995)
:letzte Änderung    16.06.1996
:Autor              Marcel Bennicke
:EMail				marcel.bennicke@t-online.de
:Version            1.23

:für Variablentyp   IEEE-Single
	
PREFS:          TAB = 4
************************************************************************/


OPT PREPROCESS, MODULE

MODULE  'mathieeesingbas','mathieeesingtrans',
		'exec/lists','exec/nodes',
		'tools/singlesupport','tools/chars',
		'tools/mathtermerrors'

-> #define DEBUG

RAISE "MEM" IF String()=NIL

CONST   RAD     =  $4266EB17,   -> = 180/pi = 57.729578
		EINS    =  $3F800000    -> = 1.0


-> Prioritäten der Operatoren, Klammern, Funktionen, Konstanten
#define PRILIST [1,1,2,2,3,4,4,5,5,6,6]

ENUM    IS_ADD,IS_SUB,IS_MUL,IS_DIV,IS_POT,IS_KLAMMERAUF,IS_KLAMMERZU,
		IS_FUNC,IS_USERFUNC,IS_CONST,IS_VAR,IS_KOMMA
CONST   IS_UNKNOWN=-1, LAST_ID = IS_KOMMA+1


#define FUNCLIST ['-','sin','cos','tan','cot','asin','acos','atan','sinh','cosh','tanh','exp','ln','lg','sqrt','rad','grad','abs']
ENUM    F_NEG,F_SIN, F_COS, F_TAN, F_COT, F_ASIN, F_ACOS, F_ATAN, F_SINH,
		F_COSH, F_TANH, F_EXP, F_LN, F_LG, F_SQRT, F_RAD, F_GRAD, F_ABS

CONST   FUNCLAST  = F_ABS       -> Nr. des letzten Listeneintrags



OBJECT identifier
PUBLIC
	vonpos,bispos: INT
	id: INT		-> Inhalt von info abhängig von id:
	info: LONG  -> Klammern
					-> Nr. der ID des Gegenstücks (auch bei ")")
				-> Funktionen
					-> Nr. der Funktion in der Liste
				-> Variablen
					-> Nr. der Variable in der Liste
				-> Konstanten
					-> Wert
				-> Benutzerfunktion
					-> ^mathterm
					
	skip: LONG  -> bei Klammern und Kommas, jeweils Nr. der/des nächsten

	end: INT    -> bei Funktionen steht hier die Nr. der letzten ID,
					-> die von der Funktion erfaßt wird
				-> Konstanten, Klammern genauso
				-> sonst = Postition im Array, da nur 1 ID lang
ENDOBJECT


OBJECT identlist
PRIVATE
	idlist:PTR TO identifier
	arraysize: INT
	idcount: INT
ENDOBJECT


OBJECT mathfuncterm
PRIVATE
	funcstring:PTR TO CHAR
	name:PTR TO CHAR
ENDOBJECT


OBJECT knoten
PRIVATE
	left:PTR TO knoten
	right:PTR TO knoten

	type: INT
	data: LONG
ENDOBJECT



OBJECT variable
PRIVATE
	name:PTR TO CHAR 
PUBLIC
	value: LONG
ENDOBJECT


OBJECT variablelist
PRIVATE
	varlist:PTR TO LONG
	arraysize: INT
	varcount
ENDOBJECT


EXPORT OBJECT mathterms OF ln
PRIVATE
	function: PTR TO mathfuncterm
	vlist: PTR TO variablelist
	functree: PTR TO knoten
	lockcount                   -> wird dieser Term von anderen benutzt?
ENDOBJECT

EXPORT OBJECT funccontexts OF mlh
	count
ENDOBJECT




DEF mt_exceptionkey, mt_exception, mt_info,

	mt_pril:PTR TO LONG,            -> Prioritätenliste
	mt_fl:PTR TO LONG,              -> elementare Funktionsliste

	schmuggleBug

/* über schmuggelBug:

   Tja, das Objekt enthält einen ziehmlich tiefsitzenden
   "Strukturierungsfehler", der nur durch komplettes
   Neuschreiben zu beheben ist. Wenn gewünscht, entfernte
   ich ihn in einer neuen Version, ansonsten geht's aber
   auch so... Lediglich der Teil der Erzeugung des Baumes
   ist betroffen, die Berechnungsteil selbst wird durch
   den Fehler nicht beeinträchtigt, im Gegenteil er
   gewinnt sogar etwas an Geschwindigkeit.
*/


/************************************************************
 überprüft eine Zeichenkette auf Gültigkeit für einen
 Bezeichner (richtig: a,Bb124   falsch: 2f, a3G)
*************************************************************/
PROC checkID(mtlist:PTR TO funccontexts,s:PTR TO CHAR)
	DEF bytes:REG,i:REG, nodigyet=TRUE

	bytes:=StrLen(s)
	IF bytes=0 THEN Raise(MT_IDTOOSHORT)

	IF Not(isAlpha(s[0])) THEN Throw(MT_NOTALLOWEDID,s)

	FOR i:=0 TO bytes-1
		IF nodigyet
			IF Not(isAlpha(s[i]))
				IF isDigit(s[i])
					nodigyet:=TRUE
				ELSE
					Throw(MT_NOTALLOWEDID,s)
				ENDIF
			ENDIF
		ELSE
			IF Not(isDigit(s[i])) THEN Throw(MT_NOTALLOWEDID,s)
		ENDIF
	ENDFOR

	FOR i:=0 TO FUNCLAST
		IF StrCmp(s,mt_fl[i]) THEN Throw(MT_IDRESERVED,s)
	ENDFOR
	IF mtlist
		IF mtlist.findTerm(s)<>NIL THEN Throw(MT_IDRESERVED,s)
	ENDIF
ENDPROC


PROC mathfuncterm(name, func) OF mathfuncterm
#ifdef DEBUG
	WriteF('Constructor mathfuncterm\n')
#endif

	self.funcstring:=String(StrLen(func)+1)
	StrCopy(self.funcstring,func)

	IF name
		self.name:=String(StrLen(name)+1)
		StrCopy(self.name,name)
	ENDIF
ENDPROC


PROC getStrAdr() OF mathfuncterm IS self.funcstring
PROC getStrLen() OF mathfuncterm IS EstrLen(self.funcstring)
PROC getName() OF mathfuncterm IS self.name

PROC findNextIdentifier(mtlist:PTR TO funccontexts,pos,vl:PTR TO variablelist) OF mathfuncterm
	DEF ende,typ=IS_UNKNOWN,addinfo=0,

		st:PTR TO CHAR,zeichen,i,mt:PTR TO mathterms,
		hs[100]:STRING,maxpos,err

	st:=self.getStrAdr()
	maxpos:=self.getStrLen()

	WHILE (zeichen:=st[pos])<=32 DO INC pos
	ende:=pos

#ifdef DEBUG
	WriteF('Zeichen \c\n',zeichen)
#endif

	SELECT 127 OF zeichen
	CASE "+"
		typ:=IS_ADD
		INC ende
	CASE "-"
		-> Minuszeichen als Negierung gebraucht ?
		IF (ende=0) OR (st[ende-1]="(") OR (st[ende-1]=",")
			IF isDigit(st[ende+1])
#ifdef DEBUG
	WriteF('findNextIdentifier: negative Constante\n')
#endif
				addinfo,ende,err:=str2Single(st,ende)
				IF err THEN Throw(MT_UNKNOWNID,ende)
				typ:=IS_CONST
			ELSE
				typ:=IS_FUNC
				addinfo:=F_NEG
				INC ende
			ENDIF
		ELSE
			typ:=IS_SUB
			INC ende
		ENDIF

	CASE "*"
		typ:=IS_MUL
		INC ende
	CASE "/"
		typ:=IS_DIV
		INC ende
	CASE "^"
		typ:=IS_POT
		INC ende
	CASE "("
		typ:=IS_KLAMMERAUF
		INC ende
	CASE ")"
		typ:=IS_KLAMMERZU
		INC ende
	CASE ","
		typ:=IS_KOMMA
		INC ende

	CASE "a" TO "z", "A" TO "Z"
		INC ende
		WHILE (isAlpha(st[ende]) OR isDigit(st[ende])) AND (ende<=maxpos) DO INC ende
		MidStr(hs,st,pos,ende-pos)

		-> ist es eine Variable?
		IF typ=IS_UNKNOWN
			i:=vl.getVarIndex(hs)    -> -1 bei nicht gefunden
			IF i<>-1
				typ:=IS_VAR
				addinfo:=i
#ifdef DEBUG
	WriteF('Variable \s\n',hs)
#endif
			ENDIF
		ENDIF

		-> eine interne Funktion ?
		IF typ=IS_UNKNOWN
			FOR i:=1 TO FUNCLAST        -> i:=1, weil 0 die Neg()-Funktion ist
				IF StrCmp(hs,mt_fl[i])  -> und die wird bei "-" behandelt
					typ:=IS_FUNC
					addinfo:=i
					i:=FUNCLAST
#ifdef DEBUG
	WriteF('Funktion: \s\n',hs)
#endif
				ENDIF
			ENDFOR
		ENDIF

		-> eine Benutzerfunktion bzw. symbolische Konstante?
		IF (typ=IS_UNKNOWN) AND (mtlist<>NIL)
			IF (mt:=mtlist.findTerm(hs))<>NIL
				IF mt.getVarCount()>0
					typ:=IS_USERFUNC
					addinfo:=mt
				ELSE
					schmuggleBug:=mt
					typ:=IS_CONST
					addinfo:=mt.calc()
				ENDIF
			ENDIF
		ENDIF

	DEFAULT -> dann muß es eine Zahl (oder Fehler) sein
#ifdef DEBUG
	WriteF('findNextIdentifier: Constante ?\n')
#endif
		addinfo,ende,err:=str2Single(st,ende)
		IF err THEN Throw(MT_UNKNOWNID,ende)
		typ:=IS_CONST
	ENDSELECT
ENDPROC ende,typ,addinfo


#ifdef DEBUG
PROC write() OF mathfuncterm
	WriteF('Funktion: \s -> \s\n  Länge: \d Zeichen\n',self.name,self.funcstring,self.getStrLen())
ENDPROC
#endif

PROC end() OF mathfuncterm
#ifdef DEBUG
	WriteF('Destruktor Mathfuncterm\n')
#endif

	IF self.funcstring
		DisposeLink(self.funcstring)
		self.funcstring:=NIL
	ENDIF

	IF self.name
		DisposeLink(self.name)
		self.name:=NIL
	ENDIF
ENDPROC




-> Baum aufbauen

PROC knoten(idl:PTR TO identlist,f:PTR TO mathfuncterm,beginn,ende) OF knoten
	DEF kn=NIL:PTR TO knoten,id:PTR TO identifier,
		pri = 10000,privgl=0, apos, aposvgl, pos, posvgl, ident,
		mt=NIL:PTR TO mathterms,j,args=NIL:PTR TO LONG

#ifdef DEBUG
	DEF conststring[40]:STRING
	WriteF('BuiltBinTree von \d bis \d\n',beginn,ende)
#endif

	IF FreeStack()<1000 THEN Raise(MT_STACKOVERFLOW)

	id:=idl.getIDArray()

	posvgl:=beginn
	WHILE posvgl<=ende
		ident:=id[posvgl].id
		aposvgl:=posvgl

		-> Ausdrücke, die länger länger als 1 ID sind, werden übersprungen
		-> und erst im nächsten Rekursionsschritt bearbeitet
		posvgl:=id[posvgl].end+1

		privgl:=mt_pril[ident]
		IF privgl<=pri
			apos:=aposvgl
			pos:=posvgl
			pri:=privgl
		ENDIF
	ENDWHILE

	ident:=id[apos].id

	SELECT ident
	CASE IS_VAR
		self.type:=IS_VAR
		self.data:=id[apos].info

	CASE IS_CONST
		self.type:=IS_CONST
		self.data:=id[apos].info
		IF id[apos].skip
			mt:=id[apos].skip
			self.left:=mt
			mt.lock()
		ENDIF

#ifdef DEBUG
	WriteF('BuiltBinTree Konstante: \s\n',single2Estr(conststring,self.data))
#endif

	CASE IS_KLAMMERAUF
#ifdef DEBUG
	WriteF('BuiltBinTree Klammer\n')
#endif
		self.knoten(idl,f,apos+1,id[apos].end-1)

	CASE IS_USERFUNC
		self.type:=IS_USERFUNC
		mt:=id[apos].info           -> ^mathterms
		self.data:=mt
		mt.lock()

		IF (args:=List(mt.getVarCount()))=NIL THEN Raise("MEM")

		self.left:=args                 -> Liste mit Arg-Bäumen
		self.right:=mt.getVarCount()-1  -> Argumentenanzahl-1

		apos:=apos+1
		FOR j:=0 TO self.right
			args[j]:=NEW kn.knoten(idl,f,apos+1,id[apos].skip-1)
			kn:=NIL
			apos:=id[apos].skip
		ENDFOR

	CASE IS_FUNC
#ifdef DEBUG
	WriteF('BuiltBinTree Funktion: \s\n',mt_fl[id[apos].info])
#endif

		self.type:=IS_FUNC
		self.data:=id[apos].info
		self.left:=NEW kn.knoten(idl,f,apos+1,id[apos].end)

	DEFAULT     -> alle (binären) Operatoren
		self.type:=ident
		self.left:=NEW kn.knoten(idl,f,beginn,apos-1)
		kn:=NIL
		self.right:=NEW kn.knoten(idl,f,apos+1,ende)
	ENDSELECT
ENDPROC


PROC doCalc(vl:PTR TO variablelist) OF knoten
	DEF typ, nr, kn: REG PTR TO knoten,
		a:REG, mt:REG PTR TO mathterms,
		i,args:REG PTR TO LONG


	typ:=self.type

	SELECT LAST_ID OF typ
	CASE IS_CONST
		RETURN self.data

	CASE IS_VAR
		RETURN vl.getVar(self.data)

	CASE IS_ADD
		RETURN !self.left.doCalc(vl)+self.right.doCalc(vl)

	CASE IS_SUB
		RETURN !self.left.doCalc(vl)-self.right.doCalc(vl)

	CASE IS_MUL
		RETURN !self.left.doCalc(vl)*self.right.doCalc(vl)

	CASE IS_DIV
		RETURN !self.left.doCalc(vl)/self.right.doCalc(vl)

	CASE IS_POT
		RETURN Fpow(self.right.doCalc(vl),self.left.doCalc(vl))

	CASE IS_USERFUNC
		args:=self.left
		mt:=self.data
		FOR i:=0 TO self.right
			kn:=args[i]
			mt.setVar(kn.doCalc(vl),i)
		ENDFOR
		RETURN mt.calc()

	CASE IS_FUNC
		kn:=self.left
		a:=kn.doCalc(vl)
		nr:=self.data
		SELECT nr
			CASE F_NEG; RETURN IeeeSPNeg(a)
			CASE F_SIN; RETURN IeeeSPSin(a)
			CASE F_COS; RETURN IeeeSPCos(a)
			CASE F_TAN; RETURN IeeeSPTan(a)
			CASE F_COT; RETURN IeeeSPDiv(EINS,IeeeSPTan(a))
			CASE F_ASIN; RETURN IeeeSPAsin(a)
			CASE F_ACOS; RETURN IeeeSPAcos(a)
			CASE F_ATAN; RETURN IeeeSPAtan(a)
			CASE F_SINH; RETURN IeeeSPSinh(a)
			CASE F_COSH; RETURN IeeeSPCosh(a)
			CASE F_TANH; RETURN IeeeSPTanh(a)
			CASE F_EXP; RETURN IeeeSPExp(a)
			CASE F_LN; RETURN IeeeSPLog(a)
			CASE F_LG; RETURN IeeeSPLog10(a)
			CASE F_SQRT; RETURN IeeeSPSqrt(a)
			CASE F_RAD; RETURN !a/RAD
			CASE F_GRAD; RETURN !a*RAD
			CASE F_ABS; RETURN IeeeSPAbs(a)
		ENDSELECT
	ENDSELECT
ENDPROC

#ifdef DEBUG
PROC write(ein=0) OF knoten
	DEF aus[40]:STRING,
		args:PTR TO LONG,i,kn:PTR TO knoten

	WriteF('\d. ID = \d\n',ein, self.type)
	IF (self.type=IS_FUNC) OR (self.type=IS_VAR)
		WriteF('\d. DATA: \d\n',ein,self.data)
	ELSEIF self.type=IS_CONST
		WriteF('\d. Konstante = \s\n',ein,single2Estr(aus,self.data))
	ENDIF

	IF self.left
		WriteF('\d. Links:\n',ein)
		IF self.type<>IS_USERFUNC
			self.left.write(ein+1)
		ELSE
			args:=self.left
			FOR i:=0 TO self.right
				kn:=args[i]
				kn.write(ein*100+100+i)
			ENDFOR
		ENDIF
	ENDIF

	IF self.right
		WriteF('\d. Rechts:\n',ein)
		IF self.type<>IS_USERFUNC
			self.right.write(ein+1)
		ELSE
			WriteF('\d Argumente\n',self.right)
		ENDIF
	ENDIF
ENDPROC
#endif


PROC end() OF knoten
	DEF kn:PTR TO knoten,mt:PTR TO mathterms,
		i,args:PTR TO LONG

#ifdef DEBUG
	WriteF('Destruktor knoten\n')
#endif
	IF self.type=IS_USERFUNC
		mt:=self.data
		mt.unlock()
		args:=self.left
		IF args
			FOR i:=0 TO ListLen(args)-1
				kn:=args[i]
				END kn
			ENDFOR
			DisposeLink(args)
		ENDIF
	ELSEIF self.type=IS_CONST
		IF self.left		-> wieder der Bug
			mt:=self.left
			mt.unlock()
		ENDIF
	ELSE
		kn:=self.left
		END kn
		kn:=self.right
		END kn
	ENDIF
	self.left:=NIL
	self.right:=NIL
ENDPROC






PROC variable(mtlist, s:PTR TO CHAR, value=0) OF variable
#ifdef DEBUG
	WriteF('Constructor Variable\n')
#endif

	checkID(mtlist,s)

	self.name:=String(StrLen(s))
	StrCopy(self.name,s)
	self.value:=value

#ifdef DEBUG
	WriteF('neue Variable: \s\n',self.name)
#endif
ENDPROC

#ifdef DEBUG
PROC write() OF variable
	DEF zahl[40]:STRING

	WriteF('Variable \s = \s\n',self.name,single2Estr(zahl,self.value))
ENDPROC
#endif

PROC getName() OF variable IS self.name

PROC end() OF variable
	IF self.name
		DisposeLink(self.name)
		self.name:=NIL
	ENDIF
ENDPROC




PROC variablelist(mtlist,vars:PTR TO LONG) OF variablelist HANDLE
	DEF l:PTR TO LONG,v=NIL:PTR TO variable,
		vnum=0,vcount,j

#ifdef DEBUG
	WriteF('Constructor Variablelist\n')
#endif

	IF vars
		vnum:=ListLen(vars)
		FOR vcount:=0 TO vnum-1
			FOR j:=vcount+1 TO vnum-1
				IF StrCmp(vars[vcount],vars[j]) THEN Throw(MT_VARSTWICE,vars[j])
			ENDFOR
		ENDFOR

		self.varcount:=0
		self.arraysize:=vnum
		self.varlist:=NEW l[vnum]

		FOR vcount:=0 TO vnum-1
			v:=NIL
			self.varlist[vcount]:=NEW v.variable(mtlist, vars[vcount])
			self.varcount:=self.varcount+1
		ENDFOR
	ENDIF
#ifdef DEBUG
	WriteF('Variablenliste angelegt\n')
#endif
EXCEPT
	END v
	Throw(exception,vcount)
ENDPROC

PROC setVar(value, index) OF variablelist
	DEF v:REG PTR TO variable

	v:=self.varlist[index]
	v.value:=value
ENDPROC

PROC getVar(index) OF variablelist
	DEF v:REG PTR TO variable

	v:=self.varlist[index]
ENDPROC v.value

PROC getVarName(index) OF variablelist
	DEF v:REG PTR TO variable

	v:=self.varlist[index]
ENDPROC v.getName()

#ifdef DEBUG
PROC write() OF variablelist
	DEF i,v:PTR TO variable

	WriteF('Variablenliste:\n')
	FOR i:=0 TO self.varcount-1
		v:=self.varlist[i]
		WriteF('  ');v.write()
	ENDFOR
ENDPROC
#endif

PROC getVarIndex(s:PTR TO CHAR) OF variablelist
	DEF i:REG,v:REG PTR TO variable

	FOR i:=0 TO self.varcount-1
		v:=self.varlist[i]
		IF StrCmp(v.getName(),s) THEN RETURN i
	ENDFOR
ENDPROC -1

PROC getVarCount() OF variablelist IS self.varcount

PROC end() OF variablelist
	DEF l:PTR TO LONG,v:PTR TO variable,i:REG

#ifdef DEBUG
	WriteF('Destruktor Variablelist\n')
#endif

	l:=self.varlist
	IF l
		FOR i:=0 TO self.varcount-1
			v:=l[i]
			END v
		ENDFOR
		END l[self.arraysize]
		self.varlist:=NIL
	ENDIF
ENDPROC





#ifdef DEBUG
PROC identList(mtlist, f:PTR TO mathfuncterm, vl:PTR TO variablelist) OF identlist HANDLE
#endif
#ifndef DEBUG
PROC identList(mtlist, f:PTR TO mathfuncterm, vl:PTR TO variablelist) OF identlist
#endif
	DEF id=NIL:PTR TO identifier,idnum=0,
		ende, pos1=0,pos2=0,ident,info,
		i,j,skipid,id2,mt:PTR TO mathterms,kommas
		

#ifdef DEBUG
	WriteF('Konstruktor identlist\n')
#endif

	-> Indentifier-Array erst mal so groß wie Zeichen da sind.
	-> Für jeden Teil des Strings (Variablennamen, Funktionsnamen,
	-> Operatoren...) wird nun eine Kennziffer mit spezifischen
	-> Informationen ermittelt. Diese Liste erleichtert das erstellen
	-> des Baumes und wird danach wieder gelöscht
	idnum:=f.getStrLen()
	IF idnum=0 THEN Raise(MT_NOSTRING)

	self.arraysize:=idnum
	self.idlist:=NEW id[self.arraysize]
	self.idcount:=0

	ende:=idnum-1

	WHILE pos1<=ende
		schmuggleBug:=NIL

		pos2,ident,info:=f.findNextIdentifier(mtlist,pos1,vl)
		IF ident=IS_UNKNOWN THEN Throw(MT_UNKNOWNID,pos1)

		id[self.idcount].vonpos:=pos1
		id[self.idcount].bispos:=pos2-1
		id[self.idcount].id:=ident
		id[self.idcount].info:=info

		IF schmuggleBug		-> siehe oben
			id[self.idcount].skip:=schmuggleBug
#ifdef DEBUG
	WriteF('*** Schmuggel-Bug an Position \d = \h\n',self.idcount,schmuggleBug)
#endif
		ELSE
			id[self.idcount].skip:=NIL
		ENDIF

		pos1:=pos2
		self.idcount:=self.idcount+1
	ENDWHILE

	idnum:=self.idcount-1

#ifdef DEBUG
	WriteF('\nSyntax Prüfung...\n')
#endif

	-> wahrscheinlich viel zu umständlich und zu aufwendig, aber sicher
	-> Es wird immer geprüft, was für ein Element nach dem aktuellen kommt
	-> und ob dieses erlaubt ist.
	-> z.B. nach einem "+" dürfen Konstanten, Variable, "(" und
	-> Funktionsaufrufe stehen
	FOR i:=0 TO idnum
		ident:=id[i].id
		SELECT LAST_ID OF ident

		/* Operatoren richtig ? */
		CASE IS_ADD, IS_SUB, IS_MUL, IS_DIV, IS_POT
			IF i<idnum
				id2:=id[i+1].id
				IF (id2<>IS_KLAMMERAUF) AND (id2<>IS_FUNC) AND (id2<>IS_USERFUNC) AND (id2<>IS_CONST) AND (id2<>IS_VAR) THEN Throw(MT_MISSOPERANDAFTER, id[i].bispos)
			ELSE
				Throw(MT_MISSOPERANDAFTER,id[i].bispos)
			ENDIF
			IF i=0 THEN Throw(MT_MISSOPERANDBEFORE,id[i].vonpos)

		/* Variablen und Konstanten richtig? */
		CASE IS_VAR, IS_CONST
			IF i<idnum
				id2:=id[i+1].id
				IF (id2=IS_VAR) OR (id2=IS_CONST) OR (id2=IS_USERFUNC) OR (id2=IS_FUNC) OR (id2=IS_KLAMMERAUF) THEN Throw(MT_MISSOPERATOR,id[i].bispos+1)
			ENDIF

		/* Schreibweise der Funktionen richtig? */
		CASE IS_FUNC, IS_USERFUNC
			IF ((ident=IS_FUNC) AND (id[i].info<>F_NEG)) OR (ident=IS_USERFUNC)
				IF i<idnum
					IF id[i+1].id<>IS_KLAMMERAUF THEN Throw(MT_MISSOPENBRACKET,id[i].bispos)
				ELSE
					Throw(MT_MISSOPENBRACKET,id[i].bispos)
				ENDIF
			ELSE
				/* hier keine weiteren Abfragen nötig, da sonst "-" 
				   als Subtraktion von findNextIdentifier() gewertet wird. */
				IF i<idnum
					id2:=id[i+1].id
					IF (id2<>IS_KLAMMERAUF) AND (id2<>IS_CONST) AND (id2<>IS_VAR) AND (id2<>IS_FUNC) AND (id2<>IS_USERFUNC) THEN Throw(MT_MISSOPERANDAFTER,id[i].bispos)
				ELSE
					Throw(MT_MISSOPERANDAFTER,id[i].bispos)
				ENDIF                   
			ENDIF

		/* Klammern richtig? */
		CASE IS_KLAMMERAUF
			IF i<idnum
				id2:=id[i+1].id
				IF (id2<>IS_KLAMMERAUF) AND (id2<>IS_FUNC) AND (id2<>IS_USERFUNC) AND (id2<>IS_CONST) AND (id2<>IS_VAR) THEN Throw(MT_MISSOPERANDAFTER,id[i].bispos)
			ENDIF
			id[i].info:=self.findMatchingBracket(i)

		CASE IS_KLAMMERZU
			IF i<idnum
				id2:=id[i+1].id
				IF (id2=IS_KLAMMERAUF) OR (id2=IS_FUNC) OR (id2=IS_USERFUNC) OR (id2=IS_CONST) OR (id2=IS_VAR) THEN Throw(MT_MISSOPERATOR, id[i].bispos+1)
			ENDIF
			id[i].info:=self.findMatchingBracket(i)

		CASE IS_KOMMA
			IF (i=0) OR (i=idnum) THEN Throw(MT_KOMMASEPARATES,id[i].bispos)
			id2:=id[i+1].id
			IF (id2<>IS_FUNC) AND (id2<>IS_USERFUNC) AND (id2<>IS_KLAMMERAUF) AND (id2<>IS_VAR) AND (id2<>IS_CONST) THEN Throw(MT_MISSOPERANDAFTER,id[i].bispos)
		ENDSELECT
	ENDFOR

	-> Gültigkeitsbereiche der IDs eintragen
	-> im .end-Feld der idents wird immer die Array-Position eines
	-> Gegenstücks eingetragen, also bei "(" die Position der
	-> dazugehörigen ")" und umgekehrt
	FOR i:=0 TO idnum
		ident:=id[i].id

		SELECT LAST_ID OF ident
		CASE IS_FUNC, IS_USERFUNC
			IF (ident=IS_FUNC) AND (id[i].info=F_NEG) -> Negierungsfunktion gesondert behandeln
				ende:=i+1
				IF id[ende].id=IS_KLAMMERAUF
					ende:=id[ende].info
				ELSEIF (id[ende].id=IS_FUNC) OR (id[ende].id=IS_USERFUNC)
					ende:=id[ende+1].info
				ENDIF
				WHILE (ende<idnum) AND (id[ende+1].id=IS_POT)
					ende:=ende+2
					IF id[ende].id=IS_KLAMMERAUF
						ende:=id[ende].info
					ELSEIF (id[ende].id=IS_FUNC) OR (id[ende].id=IS_USERFUNC)
						ende:=id[ende+1].info
					ENDIF
				ENDWHILE
			ELSE -> bei allen anderen Funktionen folgt Klammer (dort steht das Ende schon in .info)
				ende:=id[i+1].info
			ENDIF
			id[i].end:=ende
		CASE IS_KLAMMERAUF
			id[i].end:=id[i].info
		DEFAULT
			id[i].end:=i
		ENDSELECT

#ifdef DEBUG
		WriteF('ID (\d) \d -> \d:  Typ=\d   Info=\d   End=\d\n',i,id[i].vonpos,id[i].bispos,id[i].id,id[i].info,id[i].end)
#endif
	ENDFOR

	-> Stellung der Kommas überprüfen
	-> dürfen nur in Aufrufen von Benutzerfunktionen mit mehreren
	-> Variablen stehen (zur Trennung der Argumente)
	FOR i:=0 TO idnum
		IF id[i].id=IS_KOMMA
			j:=i
			WHILE id[j].id<>IS_KLAMMERAUF
				j:=self.prevPosSameLevel(j)
				IF j<0 THEN Throw(MT_KOMMASEPARATES,id[i].bispos)
			ENDWHILE
			DEC j
			IF j<0 THEN Throw(MT_KOMMASEPARATES,id[i].bispos)
			IF id[j].id<>IS_USERFUNC
				IF id[j].id=IS_FUNC
					Throw(MT_WRONGARGS,mt_fl[id[j].info])
				ELSE
					Throw(MT_KOMMASEPARATES,id[i].bispos)
				ENDIF
			ENDIF
		ENDIF
	ENDFOR
			
	-> Argumentanzahl überprüfen
	FOR i:=0 TO idnum
		IF id[i].id=IS_USERFUNC
			mt:=id[i].info
			j:=i+2; skipid:=i+1; kommas:=0
			WHILE id[j].id<>IS_KLAMMERZU
				IF id[j].id=IS_KOMMA
					INC kommas
					id[skipid].skip:=j
					skipid:=j
				ENDIF
				j:=self.nextPosSameLevel(j)
			ENDWHILE
			id[skipid].skip:=j
			IF kommas+1<>mt.getVarCount() THEN Throw(MT_WRONGARGS,mt.getFuncName())
		ENDIF
	ENDFOR  
#ifdef DEBUG
EXCEPT
	WriteF('Fehler bei Identlistaufbau\n')
	ReThrow()
#endif
ENDPROC

PROC prevPosSameLevel(pos) OF identlist
	DEC pos
	IF (self.idlist[pos].id=IS_KLAMMERZU)
		pos:=self.idlist[pos].info-1
		IF (self.idlist[pos].id=IS_FUNC) OR (self.idlist[pos].id=IS_USERFUNC) THEN DEC pos
	ENDIF
ENDPROC pos

PROC nextPosSameLevel(pos) OF identlist
	DEF ident

	INC pos
	ident:=self.idlist[pos].id
	IF (ident=IS_KLAMMERAUF) OR (ident=IS_FUNC) OR (ident=IS_USERFUNC) THEN pos:=self.idlist[pos].end+1
ENDPROC pos


PROC findMatchingBracket(beginpos) OF identlist
	DEF id:REG PTR TO identifier,pos:REG,bracketlevel:REG, typ,dir=0,
		maxpos

	id:=self.idlist
	maxpos:=self.idcount-1

	typ:=id[beginpos].id
	SELECT typ
		CASE IS_KLAMMERAUF; dir:=1
		CASE IS_KLAMMERZU; dir:=-1
	DEFAULT
		RETURN id[beginpos].info
	ENDSELECT

	bracketlevel:=dir
	pos:=beginpos

	REPEAT
		pos:=pos+dir
		typ:=id[pos].id

		IF pos<0 THEN Throw(MT_TOOMUCHCLOSEBR,Abs(bracketlevel))
		IF pos>maxpos THEN Throw(MT_TOOMUCHOPENBR,bracketlevel)

		SELECT typ
			CASE IS_KLAMMERAUF; INC bracketlevel
			CASE IS_KLAMMERZU; DEC bracketlevel
		ENDSELECT
	UNTIL bracketlevel=0
ENDPROC pos

PROC getIDCount() OF identlist IS self.idcount
PROC getIDArray() OF identlist IS self.idlist

PROC end() OF identlist
	DEF id:PTR TO identifier

#ifdef DEBUG
	WriteF('Destructor von identlist\n')
#endif

	id:=self.idlist
	END id[self.arraysize]
	self.idlist:=NIL
ENDPROC




-> bei Benutzung ohne eine Funktionsliste max. die ersten
-> drei Argumente belegen (obwohl der Name dann ziehmlich
-> überflüssig erscheint)!!!
PROC mathterms(expr, varidents, name=NIL, mtlist=NIL:PTR TO funccontexts) OF mathterms HANDLE
	DEF func=NIL:PTR TO mathfuncterm,
		vl=NIL:PTR TO variablelist,
		idl=NIL:PTR TO identlist,
		kn=NIL:PTR TO knoten

#ifdef DEBUG
	WriteF('Constructor Mathterm\n')
#endif

-> ### Variablenliste anlegen
	self.vlist:=NEW vl.variablelist(mtlist,varidents)

-> ### Name & Funktionsstring kopieren
	self.function:=NEW func.mathfuncterm(name,expr)

-> ### temporäre Tokenliste aufbauen
	NEW idl.identList(mtlist,func,vl)

-> ### binären Funktionsbaum aufbauen
	self.functree:=NEW kn.knoten(idl,func,0,idl.getIDCount()-1)

	self.name:=self.function.getName()
EXCEPT DO
#ifdef DEBUG
	IF exception<>0 THEN WriteF('\n ---------- Fehler beim Objektaufbau ---------\n')
#endif
	END idl
	-> bei Einzelbenutzung des mathterms-Objekts hier Exception auslösen
	IF (mtlist=NIL) AND (exception<>0)
		mt_exception:=exception
		mt_info:=exceptioninfo
		Raise(mt_exceptionkey)
	ELSE
		ReThrow()           -> sonst weiterleiten
	ENDIF
ENDPROC

PROC setVar(value, nr=0) OF mathterms IS self.vlist.setVar(value, nr)
PROC getVar(nr=0) OF mathterms IS self.vlist.getVar(nr)
PROC getVarIndex(nr=0) OF mathterms IS self.vlist.getVarIndex(nr)
PROC getVarName(nr=0) OF mathterms IS self.vlist.getVarName(nr)
PROC getVarCount() OF mathterms IS self.vlist.getVarCount()

PROC getFuncName() OF mathterms IS self.function.getName()
PROC getFuncTerm() OF mathterms IS self.function.getStrAdr()

PROC calc() OF mathterms IS self.functree.doCalc(self.vlist)

PROC lock() OF mathterms
	self.lockcount:=self.lockcount+1
ENDPROC
PROC unlock() OF mathterms
	self.lockcount:=self.lockcount-1
ENDPROC
PROC getUsers() OF mathterms IS self.lockcount

#ifdef DEBUG
PROC write() OF mathterms
	DEF vl:PTR TO variablelist,kn:PTR TO knoten,
		f:PTR TO mathfuncterm

	f:=self.function
	f.write()
	WriteF('\n')

	vl:=self.vlist
	vl.write()
	WriteF('\n')

	kn:=self.functree
	IF kn
		WriteF('\nBaum:\n')
		kn.write()
	ENDIF

	WriteF('Benutzer: \d\n',self.lockcount)
ENDPROC
#endif

PROC end() OF mathterms
	DEF vl:PTR TO variablelist,
		f:PTR TO mathfuncterm,
		kn:PTR TO knoten

#ifdef DEBUG
	WriteF('Destructor von mathterms\n')
#endif

	kn:=self.functree
	END kn
	self.functree:=NIL

	f:=self.function
	END f
	self.function:=NIL

	vl:=self.vlist
	END vl
	self.vlist:=NIL
ENDPROC






PROC funccontexts() OF funccontexts
	self.head:=self+4
	self.tail:=0
	self.tailpred:=self

	self.addTerm('pi','3.141593')
	self.addTerm('e','2.718282')
ENDPROC

PROC nextTerm(mt:PTR TO mathterms) OF funccontexts
	DEF mt2=NIL: REG PTR TO mathterms

	mt2:=IF mt THEN mt.succ ELSE self.head
ENDPROC IF mt2.succ<>NIL THEN mt2 ELSE NIL

PROC findTerm(name) OF funccontexts
	DEF mt:PTR TO mathterms

	mt:=self.head
	WHILE mt.succ<>NIL
		IF StrCmp(mt.getFuncName(),name) THEN RETURN mt
		mt:=mt.succ
	ENDWHILE
ENDPROC NIL

-> erlaubt das Setzen des Variableninhalts, der sich aus einer
-> Formel berechnet (z.B. 2*pi). Darin dürfen in diesem
-> funccontexts-OBJECT bereits definierte Benutzerfunktionen
-> vorkommen, jedoch keine eigenen Variablen.
PROC setVarTerm(mt:PTR TO mathterms,expr,nr=0) OF funccontexts HANDLE
	DEF mthilf=NIL:PTR TO mathterms

	mt_exception:=0
	mt_info:=0

	NEW mthilf.mathterms(expr,NIL,NIL,self)
	AddTail(self,mthilf)
	self.count:=self.count+1

	mt.setVar(mthilf.calc(),nr)
	self.removeTerm(mthilf)
EXCEPT
	END mthilf
	mt_exception:=exception
	mt_info:=exceptioninfo
	Raise(mt_exceptionkey)
ENDPROC

PROC addTerm(name,expr,vars=NIL) OF funccontexts HANDLE
	DEF mt=NIL:PTR TO mathterms

	mt_exception:=0
	mt_info:=0

	checkID(self,name)

	NEW mt.mathterms(expr,vars,name,self)
	AddTail(self,mt)
	self.count:=self.count+1
EXCEPT
	END mt
	mt_exception:=exception
	mt_info:=exceptioninfo
	Raise(mt_exceptionkey)
ENDPROC mt

PROC removeTerm(mt:PTR TO mathterms) OF funccontexts
	IF mt.getUsers()>0
		mt_exception:=MT_TERMINUSE
		mt_info:=mt.getFuncName()
		Raise(mt_exceptionkey)
	ENDIF

	Remove(mt)
	END mt
	self.count:=self.count-1
ENDPROC

#ifdef DEBUG
PROC write() OF funccontexts
	DEF mt:PTR TO mathterms

	WriteF('Funktionsliste: \d Einträge\n'+
		   '~~~~~~~~~~~~~~~\n',self.count)

	mt:=self.head
	WHILE mt.succ<>NIL
		mt.write()
		WriteF('\n\n')
		mt:=mt.succ
	ENDWHILE
ENDPROC
#endif

PROC clear() OF funccontexts
	DEF mt:PTR TO mathterms,prev=NIL

	mt:=self.tailpred
	WHILE (prev:=mt.pred)<>NIL
		self.removeTerm(mt)
		mt:=prev
	ENDWHILE
ENDPROC

PROC end() OF funccontexts IS self.clear()





->  Hilfsfunktionen ------------------------------------------

EXPORT PROC mtsGetError() IS mt_exception, mt_info


EXPORT PROC mtsInit(key)
	DEF success=TRUE	-> macht in Zukunft vielleicht mehr Sinn

	mt_pril:=PRILIST
	mt_fl:=FUNCLIST
	mt_exceptionkey:=key
ENDPROC success


EXPORT PROC mtsCleanup() IS EMPTY
