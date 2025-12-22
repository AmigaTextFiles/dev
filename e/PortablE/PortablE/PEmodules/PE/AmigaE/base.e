/* PortablE's AmigaE target module */
OPT NATIVE, INLINE, POINTER, PREPROCESS
{OPT PREPROCESS, LARGE}
{
#define ANY   LONG
#define VALUE LONG
#define BOOL  INT
#define UBYTE CHAR
#define UINT  INT
#ifndef ECX_VERSION
	#define BYTE  CHAR
	#define FLOAT LONG
	#define WORD  INT
	#define ULONG LONG
#endif
#define POINTER LONG
#define ARRAYPTR LONG

#define NILA NIL
#define NILS NIL
#define NILL NIL
}

STATIC pe_TargetLanguage = 'AmigaE'
#define pe_TargetLanguage_AmigaE

PROC OptMultiThreaded() RETURNS multiThreaded:BOOL PROTOTYPE IS EMPTY

/* reserve words in constant's namespace, plus a few constants themselves */

NATIVE {OPT} CONST
NATIVE {MODULE} CONST
NATIVE {AND} CONST
NATIVE {OR} CONST
NATIVE {SIZEOF} CONST
NATIVE {IF} CONST
NATIVE {THEN} CONST
NATIVE {ELSE} CONST
NATIVE {BUT} CONST
NATIVE {NEW} CONST
NATIVE {JUMP} CONST
NATIVE {ELSEIF} CONST
NATIVE {ENDIF} CONST
NATIVE {FOR} CONST
NATIVE {TO} CONST
NATIVE {STEP} CONST
NATIVE {DO} CONST
NATIVE {ENDFOR} CONST
NATIVE {WHILE} CONST
NATIVE {ENDWHILE} CONST
NATIVE {REPEAT} CONST
NATIVE {UNTIL} CONST
NATIVE {LOOP} CONST
NATIVE {ENDLOOP} CONST
NATIVE {SELECT} CONST
NATIVE {CASE} CONST
NATIVE {DEFAULT} CONST
NATIVE {ENDSELECT} CONST
NATIVE {INC} CONST
NATIVE {DEC} CONST
NATIVE {VOID} CONST
NATIVE {END} CONST
NATIVE {PROC} CONST
NATIVE {HANDLE} CONST
NATIVE {IS} CONST
NATIVE {EXCEPT} CONST
NATIVE {ENDPROC} CONST
NATIVE {DEF} CONST
NATIVE {RETURN} CONST
NATIVE {CONST} CONST
NATIVE {ENUM} CONST
NATIVE {SET} CONST

NATIVE {TRUE}  CONST TRUE  = -1->!!BOOL
NATIVE {FALSE} CONST FALSE =  0->!!BOOL
NATIVE {NIL}   CONST NIL   =  0!!VALUE!!PTR
NATIVE {ALL}   CONST ALL   = -1!!LONG
NATIVE {GADGETSIZE} CONST
NATIVE {OLDFILE} CONST OLDFILE = 1005
NATIVE {NEWFILE} CONST NEWFILE = 1006
NATIVE {EMPTY}   CONST
NATIVE {STRLEN}  CONST

NATIVE {CHAR} CONST
NATIVE {INT} CONST
NATIVE {PTR} CONST
NATIVE {LONG} CONST
NATIVE {ARRAY} CONST
NATIVE {STRING} CONST
NATIVE {LIST} CONST
NATIVE {OBJECT} CONST
NATIVE {PRIVATE} CONST
NATIVE {PUBLIC} CONST
NATIVE {ENDOBJECT} CONST
NATIVE {RAISE} CONST
NATIVE {EXPORT} CONST
NATIVE {SUPER} CONST

NATIVE {NILA} CONST NILA  = 0!!VALUE!!ARRAY		->equivalent of NIL for arrays
NATIVE {NILS} CONST NILS  = 0!!VALUE!!STRING	->equivalent of NIL for strings
NATIVE {NILL} CONST NILL  = 0!!VALUE!!LIST		->equivalent of NIL for lists

/* built-in system variables + temporary access to some variables for compatability */

NATIVE {arg}      DEF
NATIVE {stdout}   DEF stdout:PTR
NATIVE {stdin}    DEF stdin :PTR
NATIVE {conout}   DEF ->conout:PTR
NATIVE {dosbase}  DEF
NATIVE {execbase} DEF
NATIVE {utilitybase} DEF
NATIVE {gfxbase}  DEF
NATIVE {intuitionbase} DEF
NATIVE {stdrast}   DEF
NATIVE {wbmessage} DEF

/* system globals */

NATIVE {exception}     DEF exception:QUAD
NATIVE {exceptioninfo} DEF exceptionInfo:ARRAY OF CHAR

/* system procedure calls */

PROC Print( fmtString:ARRAY OF CHAR, arg=NIL, ...) IS NATIVE {PrintF(} fmtString {,} arg {,} ... {)} ENDNATIVE
PROC PrintL(fmtString:ARRAY OF CHAR, args=NILL:ILIST) PROTOTYPE IS EMPTY
PROC PrintFlush() IS NATIVE {Flush(stdout)} ENDNATIVE
PROC Out(a:PTR, b:CHAR) IS NATIVE {Out(} a {,} b {)} ENDNATIVE !!BYTE
PROC Inp(a:PTR) IS NATIVE {Inp(} a {)} ENDNATIVE !!INT		->returning INT is not a mistake, since must return -1 when there is an EOF or error
PROC FileLength(a:ARRAY OF CHAR) IS NATIVE {FileLength(} a {)} ENDNATIVE !!VALUE

PROC StrCmp(a:ARRAY OF CHAR, b:ARRAY OF CHAR, c=ALL, d=0, e=0) IS NATIVE {StrCmp(} a+d {,} b+e {,} c {)} ENDNATIVE !!BOOL
PROC StrLen(a:ARRAY OF CHAR) IS NATIVE {StrLen(} a {)} ENDNATIVE !!VALUE
PROC Val(a:ARRAY OF CHAR, b=NILA:ARRAY OF LONG, startPos=0) RETURNS c, d
	{} c {,} d {:= Val(} a + startPos {,} b {)}
ENDPROC
PROC InStr(a:ARRAY OF CHAR, b:ARRAY OF CHAR, c=0) IS NATIVE {InStr(} a {,} b {,} c {)} ENDNATIVE !!VALUE
PROC TrimStr(a:ARRAY OF CHAR) IS NATIVE {TrimStr(} a {)} ENDNATIVE !!ARRAY OF CHAR
PROC UpperStr(a:ARRAY OF CHAR) IS NATIVE {UpperStr(} a {)} ENDNATIVE !!ARRAY OF CHAR
PROC LowerStr(a:ARRAY OF CHAR) IS NATIVE {LowerStr(} a {)} ENDNATIVE !!ARRAY OF CHAR
PROC AstrCopy(a:ARRAY, b:ARRAY OF CHAR, c) IS NATIVE {AstrCopy(} a {,} b {,} c {)} ENDNATIVE
->OstrCmp()
->OstrCmpNoCase()

->This is like StrCmp() but it does not care about letter case
PROC StrCmpNoCase(string1:ARRAY OF CHAR, string2:ARRAY OF CHAR, max=ALL, string1Offset=0, string2Offset=0) RETURNS same:BOOL
	DEF char1:CHAR, char2:CHAR, index
	
	string1 := string1 + string1Offset
	string2 := string2 + string2Offset
	
	same := TRUE
	index := 0
	IF (index < max) OR (max=ALL)
		REPEAT
			char1:=string1[index]
			char2:=string2[index]
			
			IF (char1>="a") AND (char1<="z") THEN char1 := char1 - "a" + "A"
			IF (char2>="a") AND (char2<="z") THEN char2 := char2 - "a" + "A"
			
			IF char1 <> char2 THEN same := FALSE
			
			index++
		UNTIL (same = FALSE) OR (char1=0) OR ((index >= max) AND (max<>ALL))	->char1=0 catches case where both strings are same length
	ENDIF
ENDPROC

PROC InStrNoCase(haystack:ARRAY OF CHAR, needle:ARRAY OF CHAR, startPos=0) RETURNS matchPos
	DEF haystackPos, needlePos, haystackChara:CHAR, needleChara:CHAR
	
	haystackPos := startPos
	  needlePos := 0
	
	haystackChara := haystack[haystackPos]
	  needleChara :=   needle[needlePos]
	
	matchPos := IF needleChara<>0 THEN -1 ELSE haystackPos
	WHILE (haystackChara<>0) AND (needleChara<>0)
		IF lowerChar(haystackChara) = lowerChar(needleChara)
			->(matching charas)
			IF matchPos = -1 THEN matchPos := haystackPos
			needlePos++ ; needleChara := needle[needlePos]
		ELSE
			->(mismatched charas) so restart search
			IF matchPos <> -1
				haystackPos := matchPos
				matchPos := -1
			ENDIF
			needlePos := 0 ; needleChara := needle[needlePos]
		ENDIF
		
		haystackPos++ ; haystackChara := haystack[haystackPos]
	ENDWHILE
	
	IF needle[needlePos]<>0 THEN matchPos := -1
ENDPROC
PRIVATE
PROC lowerChar(chara:CHAR) IS IF (chara >= "A") AND (chara <= "Z") THEN chara + "a" - "A" ELSE chara
PUBLIC

PROC QuadToStr(value:QUAD) RETURNS string:ARRAY OF CHAR
	quadStr[0] := Max(32, value SHR 24 AND $FF) !!CHAR
	quadStr[1] := Max(32, value SHR 16 AND $FF) !!CHAR
	quadStr[2] := Max(32, value SHR  8 AND $FF) !!CHAR
	quadStr[3] := Max(32, value SHR  0 AND $FF) !!CHAR
	quadStr[4] := 0
	
	string := quadStr
ENDPROC
PRIVATE
DEF quadStr[5]:ARRAY OF CHAR
PUBLIC

PROC New(a, noClear=FALSE:BOOL) IS NATIVE {New(} (noClear) BUT a {)} ENDNATIVE !!ARRAY
PROC NewR(a, noClear=FALSE:BOOL) IS NATIVE {NewR(} (noClear) BUT a {)} ENDNATIVE !!ARRAY
PROC Dispose(a:ARRAY) IS NATIVE {Dispose(} a {)} ENDNATIVE BUT NILA
PROC CleanUp(returnValue=0)
	Throw(-1, returnValue!!ARRAY OF CHAR)	->use reserved exception -1 for CleanUp()
ENDPROC
->FreeStack()
->CtrlC()
/*NATIVE {FastNew}*/     PROC FastNew(size, noClear=FALSE:BOOL) RETURNS mem:ARRAY PROTOTYPE IS EMPTY
/*NATIVE {FastDispose}*/ PROC FastDispose(mem:ARRAY, size) PROTOTYPE IS NILA

PROC MemCopy(target:ARRAY, source:ARRAY, sizeInBytes, targetOffsetInBytes=0, sourceOffsetInBytes=0)
	DEF targetBytes:ARRAY OF BYTE, sourceBytes:ARRAY OF BYTE, i
	
	targetBytes := target + targetOffsetInBytes !!ARRAY
	sourceBytes := source + sourceOffsetInBytes !!ARRAY
	
	IF (sourceBytes + sizeInBytes <= targetBytes) OR (targetBytes + sizeInBytes <= sourceBytes)
		->(no overlap) so use optimised memory copying
		NATIVE {CopyMem(} sourceBytes {,} targetBytes {,} sizeInBytes {)} ENDNATIVE
		
	ELSE IF source > target
		->(overlap happens at start of source & end of target) so can safely copy forwards
		FOR i := 0 TO sizeInBytes-1 DO targetBytes[i] := sourceBytes[i]
	ELSE
		->(overlap happens at end of source & start of target) so can safely copy backwards
		FOR i := sizeInBytes-1 TO 0 STEP -1 DO targetBytes[i] := sourceBytes[i]
	ENDIF
ENDPROC

PROC NewArray(a, b:INT) IS NATIVE {New(} a*b {)} ENDNATIVE !!PTR		->returns !!PTR to ensure it can only used with OPT POINTER
PROC DisposeArray(a:ARRAY) IS NATIVE {Dispose(} a {)} ENDNATIVE BUT NILA
PROC ArrayCopy(target:PTR, source:ARRAY, sizeInItems, itemSizeInBytes:INT) IS MemCopy(target/*!!PTR*/, source!!PTR, sizeInItems * itemSizeInBytes)	->accepts :PTR to ensure that it can only be used with OPT POINTER

PROC  And(a, b) IS a AND b
->NATIVE {And(} a {,} b {)} ENDNATIVE !!VALUE
PROC   Or(a, b) IS a OR b
->NATIVE {Or(} a {,} b {)} ENDNATIVE !!VALUE
PROC  Xor(a, b) IS a XOR b
->PROC  Xor(a, b) IS NATIVE {Eor(} a {,} b {)} ENDNATIVE !!VALUE	->IS (a AND Not(b)) OR (Not(a) AND b)
PROC  Not(a)    IS NOT a
->PROC  Not(a)    IS NATIVE {Not(} a {)} ENDNATIVE !!VALUE		->### IS $FFFFFFFF - a
PROC  Mul(a, b) IS NATIVE {Mul(} a {,} b {)} ENDNATIVE !!VALUE	->obsolete
PROC  Div(a, b) IS NATIVE {Div(} a {,} b {)} ENDNATIVE !!VALUE		->obsolete
PROC  Odd(a) IS NATIVE {Odd(} a {)} ENDNATIVE !!BOOL		->(a AND 1)<>0
PROC Even(a) IS NATIVE {Even(} a {)} ENDNATIVE !!BOOL		->(a AND 1)=0
PROC  Min(a, b) IS NATIVE {Min(} a {,} b {)} ENDNATIVE !!VALUE
PROC  Max(a, b) IS NATIVE {Max(} a {,} b {)} ENDNATIVE !!VALUE
PROC  Rnd(a) IS NATIVE {Rnd(} a {)} ENDNATIVE !!VALUE
PROC RndQ(a) IS NATIVE {RndQ(} a {)} ENDNATIVE !!VALUE
PROC  Abs(a) IS NATIVE {Abs(} a {)} ENDNATIVE !!VALUE
PROC Sign(a) RETURNS sign:RANGE -1 TO 1 IS NATIVE {Sign(} a {)} ENDNATIVE !!RANGE -1 TO 1
PROC FastMod(a, b) IS a - ((a / b) * b)
PROC Mod(a, b) RETURNS c, d
	d := a / b
	c := a - (d * b)
ENDPROC
PROC Pow(a, b) RETURNS c
	c := 1
	WHILE b > 0
		c := c * a
		b--
	ENDWHILE
ENDPROC
PROC Shl(a, b) IS a SHL IF b >= 0 THEN b ELSE -b
->PROC Shl(a, b) IS NATIVE {Shl(} a {,} b {)} ENDNATIVE !!VALUE
PROC Shr(a, b) IS a SHR IF b >= 0 THEN b ELSE -b
->PROC Shr(a, b) IS NATIVE {Shr(} a {,} b {)} ENDNATIVE !!VALUE
PROC Bounds(a, b, c) IS NATIVE {Bounds(} a {,} b {,} c {)} ENDNATIVE !!VALUE

PROC BigMax(a:BIGVALUE, b:BIGVALUE) RETURNS c:BIGVALUE IS IF a > b THEN a ELSE b
PROC BigMin(a:BIGVALUE, b:BIGVALUE) RETURNS c:BIGVALUE IS IF a < b THEN a ELSE b
PROC BigFastMod(a:BIGVALUE, b) RETURNS c
	DEF d:BIGVALUE
	d := a / b
	c := a - (d * b) !!VALUE
ENDPROC

PROC Fsin(a:FLOAT) IS NATIVE {Fsin(} a {)} ENDNATIVE !!FLOAT
PROC Fcos(a:FLOAT) IS NATIVE {Fcos(} a {)} ENDNATIVE !!FLOAT
PROC Ftan(a:FLOAT) IS NATIVE {Ftan(} a {)} ENDNATIVE !!FLOAT
PROC Fatan(a:FLOAT) IS NATIVE {Fatan(} a {)} ENDNATIVE !!FLOAT
PROC Fasin(a:FLOAT) IS NATIVE {Fasin(} a {)} ENDNATIVE !!FLOAT
PROC Facos(a:FLOAT) IS NATIVE {Facos(} a {)} ENDNATIVE !!FLOAT
/*PROC Fsincos(a:FLOAT, b:FLOAT) RETURNS c:FLOAT
	NATIVE {} c {:= Fsincos(} a {,} b {)} ENDNATIVE
ENDPROC*/
PROC Fsinh(a:FLOAT) IS NATIVE {Fsinh(} a {)} ENDNATIVE !!FLOAT
PROC Fcosh(a:FLOAT) IS NATIVE {Fcosh(} a {)} ENDNATIVE !!FLOAT
PROC Ftanh(a:FLOAT) IS NATIVE {Ftanh(} a {)} ENDNATIVE !!FLOAT
PROC Fabs(a:FLOAT)   IS NATIVE {Fabs(} a {)}   ENDNATIVE !!FLOAT
PROC Ffloor(a:FLOAT) IS NATIVE {Ffloor(} a {)} ENDNATIVE !!FLOAT
PROC Fceil(a:FLOAT)  IS NATIVE {Fceil(} a {)}  ENDNATIVE !!FLOAT
PROC Fexp(a:FLOAT)   IS NATIVE {Fexp(} a {)}   ENDNATIVE !!FLOAT
PROC Flog(a:FLOAT)   IS NATIVE {Flog(} a {)}   ENDNATIVE !!FLOAT
PROC Flog10(a:FLOAT) IS NATIVE {Flog10(} a {)} ENDNATIVE !!FLOAT	->Flog(a) / Flog(10)
PROC Fpow(a:FLOAT, b:FLOAT) IS NATIVE {Fpow(} b {,} a {)} ENDNATIVE !!FLOAT
PROC Fsqrt(a:FLOAT)  IS NATIVE {Fsqrt(} a {)}  ENDNATIVE !!FLOAT
PROC RealVal(a:ARRAY OF CHAR) RETURNS b:FLOAT, c
	{} b {,} c {:= RealVal(} a {)}
ENDPROC

PROC Throw(a:QUAD, b=NILA:ARRAY OF CHAR) IS NATIVE {Throw(} a {,} b {)} ENDNATIVE
PROC Raise(a:QUAD) IS NATIVE {Raise(} a {)} ENDNATIVE
PROC ReThrow() IS NATIVE {ReThrow()} ENDNATIVE

PROC PrintException()
	IF (exception <> 0) AND (exception <> -1)
		IF exceptionInfo
			Print('EXCEPTION: "\s"; \s.\n', QuadToStr(exception), exceptionInfo)
		ELSE
			Print('EXCEPTION: "\s".\n'    , QuadToStr(exception))
		ENDIF
	ENDIF
ENDPROC


PROC KickVersion(version) IS NATIVE {KickVersion(} version {)} ENDNATIVE !!BOOL
PROC SetStdIn(fileHandle:PTR) IS NATIVE {SetStdIn(} fileHandle {)} ENDNATIVE !!PTR
PROC SetStdOut(fileHandle:PTR) IS NATIVE {SetStdOut(} fileHandle {)} ENDNATIVE !!PTR

->peek
PROC GetBool( ptr:PTR TO BOOL ) IS NATIVE {Char(} ptr {)} ENDNATIVE !!BOOL
PROC GetByte( ptr:PTR TO BYTE ) IS NATIVE {Char(} ptr {)} ENDNATIVE !!BYTE
PROC GetChar( ptr:PTR TO CHAR ) IS NATIVE {Char(} ptr {)} ENDNATIVE !!CHAR
PROC GetInt(  ptr:PTR TO INT  ) IS NATIVE { Int(} ptr {)} ENDNATIVE !!INT
PROC GetLong( ptr:PTR TO LONG ) IS NATIVE {Long(} ptr {)} ENDNATIVE !!LONG
PROC GetQuad( ptr:PTR TO QUAD ) IS NATIVE {Long(} ptr {)} ENDNATIVE !!QUAD
PROC GetFloat(ptr:PTR TO FLOAT) IS NATIVE {Long(} ptr {)} ENDNATIVE !!FLOAT
PROC GetPtr(  ptr:PTR TO PTR  ) IS NATIVE {Long(} ptr {)} ENDNATIVE !!PTR
PROC GetArray(ptr:PTR TO ARRAY) IS NATIVE {Long(} ptr {)} ENDNATIVE !!ARRAY
PROC GetValue(ptr:PTR TO VALUE) IS NATIVE {Long(} ptr {)} ENDNATIVE !!VALUE

->poke
PROC PutBool( ptr:PTR TO BOOL , value:BOOL ) IS NATIVE {PutChar(} ptr {,} value {)} ENDNATIVE
PROC PutByte( ptr:PTR TO BYTE , value:BYTE ) IS NATIVE {PutChar(} ptr {,} value {)} ENDNATIVE
PROC PutChar( ptr:PTR TO CHAR , value:CHAR ) IS NATIVE {PutChar(} ptr {,} value {)} ENDNATIVE
PROC PutInt(  ptr:PTR TO INT  , value:INT  ) IS NATIVE {PutInt( } ptr {,} value {)} ENDNATIVE
PROC PutLong( ptr:PTR TO LONG , value:LONG ) IS NATIVE {PutLong(} ptr {,} value {)} ENDNATIVE
PROC PutQuad( ptr:PTR TO QUAD , value:QUAD ) IS NATIVE {PutLong(} ptr {,} value {)} ENDNATIVE
PROC PutFloat(ptr:PTR TO FLOAT, value:FLOAT) IS NATIVE {PutLong(} ptr {,} value {)} ENDNATIVE
PROC PutPtr(  ptr:PTR TO PTR  , value:PTR  ) IS NATIVE {PutLong(} ptr {,} value {)} ENDNATIVE
PROC PutArray(ptr:PTR TO ARRAY, value:ARRAY) IS NATIVE {PutLong(} ptr {,} value {)} ENDNATIVE
PROC PutValue(ptr:PTR TO VALUE, value:VALUE) IS NATIVE {PutLong(} ptr {,} value {)} ENDNATIVE

/* non-native code */

->possible cast functions
->PROC Bool(value)  IS value <> FALSE
->PROC Byte(value)  IS (IF value>=0 THEN (value AND $7F) ELSE -(value AND $7F))!!BYTE
->PROC Char(value)  IS (value AND $FF)!!CHAR
->PROC Int(value)   IS (IF value>=0 THEN (value AND $7FFF) ELSE -(value AND $7FFF))!!INT
->PROC Long(value)  IS value!!LONG
->PROC Quad(value)  IS value!!QUAD
->PROC Float(value) IS value!!FLOAT
->PROC Ptr(value)   IS value!!PTR


OBJECT object
ENDOBJECT

TYPE CLASSTYPE IS VALUE
PROC HaveSameClassTypes(first:CLASSTYPE, second:CLASSTYPE) IS StrCmp(first !!ARRAY OF CHAR, second !!ARRAY OF CHAR)

OBJECT class OF object PRIVATE
	staticClass
ENDOBJECT
PROC end() OF class IS EMPTY
PROC InfoClassType() OF class IS TYPEOF class
PROC IsSameClassTypeAs(type:CLASSTYPE) OF class IS HaveSameClassTypes(type, self.InfoClassType())
PROC IsOfClassType(parent:CLASSTYPE) OF class IS HaveSameClassTypes(parent, TYPEOF class)

NATIVE {end} PROC	->### prevent a procedure called end(), so that methods can be called it without an AmigaE clash.  This is a hack, until I can discover why this does not happen automatically.

OBJECT function OF class
ENDOBJECT
PROC new() OF function IS EMPTY
