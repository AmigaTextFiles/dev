/* PE/EString_partial.e 12-02-15
   A re-implementation of AmigaE's E-string functions.
   
   By Christopher S Handley:
   10-03-02 - Started coding it, to replace the existing AmigaE functions.
   19-03-02 - Mostly completed.
   14-07-06 - Ported to PortablE.
   27-07-06 - Updated to use the STRING type.
   27-10-07 - Fixed Next() & Link() bugs.
   19-04-09 - StrJoin() added earlier but not documented until now.
   09-10-09 - Added check to prevent source & destination being the same.  Problem reported by Matthias Rustler.
   03-05-10 - Declared the "missing" procedures as prototypes.  Added StringFL().
   13-01-11 - RealF() decimalPlaces is no-longer a BYTE.
   19-12-12 - Removed source<>destination restriction for StrCopy(), RightStr() & MidStr().  Fixed type of RightStr()'s eString2 parameter.
   12-02-15 - Removed source<>destination restriction for StrAdd().
*/
OPT INLINE, POINTER
MODULE 'target/PE/base'

/* Emulated procedures:
NewString(maxLen) RETURNS eString:STRING
DisposeString(eString:STRING) RETURNS NILS
StrCopy( eString:STRING, string:ARRAY OF CHAR, len=ALL, pos=0) RETURNS eString:STRING
StrAdd(  eString:STRING, string:ARRAY OF CHAR, len=ALL, pos=0) RETURNS eString:STRING
StrJoin(s1=NILA:ARRAY OF CHAR, s2=NILA:ARRAY OF CHAR, s3=NILA:ARRAY OF CHAR, s4=NILA:ARRAY OF CHAR, s5=NILA:ARRAY OF CHAR, s6=NILA:ARRAY OF CHAR, s7=NILA:ARRAY OF CHAR, s8=NILA:ARRAY OF CHAR, s9=NILA:ARRAY OF CHAR, s10=NILA:ARRAY OF CHAR, s11=NILA:ARRAY OF CHAR) RETURNS newString:STRING
EstrLen( eString:STRING) RETURNS len:VALUE
StrMax(  eString:STRING) RETURNS max:VALUE
RightStr(eString:STRING, eString2:ARRAY OF CHAR, n) RETURNS eString:STRING
MidStr(  eString:STRING, string:ARRAY OF CHAR, pos, len=ALL) RETURNS eString:STRING
SetStr(  eString:STRING, newLen)
Link(    complex:STRING, tail:OWNS STRING) RETURNS complex:STRING
Next(    complex:STRING) RETURNS tail:STRING
Forward( complex:STRING, num) RETURNS tail:STRING

On-purposely missing procedures:
ReadStr(fileHandle:PTR, eString:STRING) RETURNS fail:BOOL
StringF( eString:STRING, fmtString:ARRAY OF CHAR, ...)             RETURNS eString:STRING, len
StringFL(eString:STRING, fmtString:ARRAY OF CHAR, args=NILL:ILIST) RETURNS eString:STRING, len
RealF(   eString:STRING, value:FLOAT, decimalPlaces=8) RETURNS eString:STRING
*/

PRIVATE
OBJECT pEString PRIVATE
	length                 	->length of actual string (excluding terminating zero)
	size                  	->max length of string    (including terminating zero)
	next  :PTR TO pEString	->points to next string header, not the actual string
ENDOBJECT
PUBLIC

PROC NewString(maxLen)
	DEF eString:STRING
	DEF pEString:PTR TO pEString	
	DEF sizeOfEString
	
	->use check
	IF maxLen < 0 THEN Throw("EPU", 'EString; NewString(); maxLen<0')
	
	->allocate eString
	sizeOfEString := (maxLen + 1 * SIZEOF CHAR) + SIZEOF pEString
	pEString := FastNew(sizeOfEString, TRUE)!!PTR	->noClear=TRUE
	
	->init
	pEString.length := 0
	pEString.size   := maxLen + 1
	pEString.next   := NIL
	
	->retrieve string after header
	eString := pEString + SIZEOF pEString !!VALUE!!STRING
	
	->zero-terminate empty string
	eString[0] := "\0"
ENDPROC eString

PROC DisposeString(eString:STRING)
	DEF pEString:PTR TO pEString
	DEF next:PTR TO pEString
	
	IF eString
		->retrieve string header
		pEString := eString - SIZEOF pEString !!VALUE!!PTR TO pEString
		
		->loop through all strings in linked list
		REPEAT
			->store any string tail
			next := pEString.next
			
			->dealloc string
			pEString := FastDispose(pEString, (pEString.size * SIZEOF CHAR) + SIZEOF pEString)
			
			->move to tail
			pEString := next
		UNTIL pEString = NIL
	ENDIF
ENDPROC NILS

PROC StrCopy(eString:STRING, string:ARRAY OF CHAR, len=ALL, pos=0)
	DEF pEString:PTR TO pEString
	DEF  readIndex, maxReadIndex
	DEF writeIndex, maxWriteIndex
	
	->use check
	IF eString = NILS THEN Throw("EPU", 'EString; StrCopy(); eString=NILS')
	IF  string = NILA THEN Throw("EPU", 'EString; StrCopy(); string=NILA')
	IF (len < 0) AND (len <> ALL) THEN Throw("EPU", 'EString; StrCopy(); len<0')
	IF (pos < 0) THEN Throw("EPU", 'EString; StrCopy(); pos<0')
	
	->retrieve string header
	pEString := eString - SIZEOF pEString !!VALUE!!PTR TO pEString
	
	->calc end of string reading from & writing to (inc zero termination)
	maxReadIndex  := pos + IF len=ALL THEN pEString.size - 1 ELSE len
	maxWriteIndex := pEString.size - 1
	
	->copy all characters that will fit
	readIndex  := pos
	writeIndex := 0
	WHILE (string[readIndex] <> 0) AND (writeIndex < maxWriteIndex) AND (readIndex < maxReadIndex)
		eString[writeIndex] := string[readIndex]
		
		writeIndex++
		readIndex++
	ENDWHILE
	
	->update string's stored length
	pEString.length := writeIndex
	eString[writeIndex] := "\0"
ENDPROC eString

PROC StrAdd(eString:STRING, string:ARRAY OF CHAR, len=ALL, pos=0)
	DEF pEString:PTR TO pEString
	DEF  readIndex, maxReadIndex
	DEF writeIndex, maxWriteIndex
	
	->use check
	IF eString = NILS THEN Throw("EPU", 'EString; StrAdd(); eString=NILS')
	IF  string = NILA THEN Throw("EPU", 'EString; StrAdd(); string=NILA')
	IF (len < 0) AND (len <> ALL) THEN Throw("EPU", 'EString; StrAdd(); len<0')
	IF (pos < 0) THEN Throw("EPU", 'EString; StrAdd(); pos<0')
	
	->retrieve string header
	pEString := eString - SIZEOF pEString !!VALUE!!PTR TO pEString
	
	->calc end of string reading from & writing to (inc zero termination)
	maxReadIndex  := pos + IF len=ALL THEN pEString.size - 1 ELSE len
	maxWriteIndex := pEString.size - 1
	
	->copy all characters that will fit
	readIndex  := pos
	writeIndex := pEString.length	->start writing past end of string
	WHILE (string[readIndex] <> 0) AND (writeIndex < maxWriteIndex) AND (readIndex < maxReadIndex)
		eString[writeIndex] := string[readIndex]
		
		writeIndex++
		readIndex++
	ENDWHILE
	
	->update string's stored length
	pEString.length := writeIndex
	eString[writeIndex] := "\0"
ENDPROC eString

PROC StrJoin(s1=NILA:ARRAY OF CHAR, s2=NILA:ARRAY OF CHAR, s3=NILA:ARRAY OF CHAR, s4=NILA:ARRAY OF CHAR, s5=NILA:ARRAY OF CHAR, s6=NILA:ARRAY OF CHAR, s7=NILA:ARRAY OF CHAR, s8=NILA:ARRAY OF CHAR, s9=NILA:ARRAY OF CHAR, s10=NILA:ARRAY OF CHAR, s11=NILA:ARRAY OF CHAR, s12=NILA:ARRAY OF CHAR, s13=NILA:ARRAY OF CHAR, s14=NILA:ARRAY OF CHAR, s15=NILA:ARRAY OF CHAR, s16=NILA:ARRAY OF CHAR, s17=NILA:ARRAY OF CHAR, s18=NILA:ARRAY OF CHAR, s19=NILA:ARRAY OF CHAR)
	DEF newString:STRING
	DEF len
	
	len := 0
	IF s1 THEN len := len + StrLen(s1)
	IF s2 THEN len := len + StrLen(s2)
	IF s3 THEN len := len + StrLen(s3)
	IF s4 THEN len := len + StrLen(s4)
	IF s5 THEN len := len + StrLen(s5)
	IF s6 THEN len := len + StrLen(s6)
	IF s7 THEN len := len + StrLen(s7)
	IF s8 THEN len := len + StrLen(s8)
	IF s9 THEN len := len + StrLen(s9)
	IF s10 THEN len := len + StrLen(s10)
	IF s11 THEN len := len + StrLen(s11)
	IF s12 THEN len := len + StrLen(s12)
	IF s13 THEN len := len + StrLen(s13)
	IF s14 THEN len := len + StrLen(s14)
	IF s15 THEN len := len + StrLen(s15)
	IF s16 THEN len := len + StrLen(s16)
	IF s17 THEN len := len + StrLen(s17)
	IF s18 THEN len := len + StrLen(s18)
	IF s19 THEN len := len + StrLen(s19)
	
	NEW newString[len]
	IF s1 THEN StrAdd(newString, s1)
	IF s2 THEN StrAdd(newString, s2)
	IF s3 THEN StrAdd(newString, s3)
	IF s4 THEN StrAdd(newString, s4)
	IF s5 THEN StrAdd(newString, s5)
	IF s6 THEN StrAdd(newString, s6)
	IF s7 THEN StrAdd(newString, s7)
	IF s8 THEN StrAdd(newString, s8)
	IF s9 THEN StrAdd(newString, s9)
	IF s10 THEN StrAdd(newString, s10)
	IF s11 THEN StrAdd(newString, s11)
	IF s12 THEN StrAdd(newString, s12)
	IF s13 THEN StrAdd(newString, s13)
	IF s14 THEN StrAdd(newString, s14)
	IF s15 THEN StrAdd(newString, s15)
	IF s16 THEN StrAdd(newString, s16)
	IF s17 THEN StrAdd(newString, s17)
	IF s18 THEN StrAdd(newString, s18)
	IF s19 THEN StrAdd(newString, s19)
ENDPROC newString

PROC EstrLen(eString:STRING)
	DEF len
	DEF pEString:PTR TO pEString
	
	->use check
	IF eString = NILS THEN Throw("EPU", 'EString; EstrLen(); eString=NILS')
	
	->retrieve string header
	pEString := eString - SIZEOF pEString !!VALUE!!PTR TO pEString
	len := pEString.length
ENDPROC len

PROC StrMax(eString:STRING)
	DEF max
	DEF pEString:PTR TO pEString
	
	->use check
	IF eString = NILS THEN Throw("EPU", 'EString; StrMax(); eString=NILS')
	
	->retrieve string header
	pEString := eString - SIZEOF pEString !!VALUE!!PTR TO pEString
	max := pEString.size - 1
ENDPROC max

PROC RightStr(eString:STRING, eString2:STRING, n)
	DEF pEString2:PTR TO pEString
	DEF readString:ARRAY OF CHAR
	
	->use check
	IF eString  = NILS THEN Throw("EPU", 'EString; RightStr(); eString=NILS')
	IF eString2 = NILS THEN Throw("EPU", 'EString; RightStr(); eString2=NILS')
	IF n < 0           THEN Throw("EPU", 'EString; RightStr(); n<0')
	
	->retrieve string header
	pEString2 := eString2 - SIZEOF pEString !!VALUE!!PTR TO pEString
	
	->restrict n to sensible range
	IF n > pEString2.length THEN n := pEString2.length
	
	->move to start of n characters
	readString := eString2 + ((pEString2.length - n) * SIZEOF CHAR) !!ARRAY OF CHAR
	
	->use strCopy procedure
	StrCopy(eString, readString, n)
ENDPROC eString

PROC MidStr(eString:STRING, string:ARRAY OF CHAR, pos, len=ALL)
	DEF index, readString:ARRAY OF CHAR
	
	->use check
	IF eString = NILS THEN Throw("EPU", 'EString; MidStr(); eString=NILS')
	IF  string = NILA THEN Throw("EPU", 'EString; MidStr(); string=NILA')
	IF pos < 0        THEN Throw("EPU", 'EString; MidStr(); pos<0')
	IF (len < 0) AND (len <> ALL) THEN Throw("EPU", 'EString; MidStr(); len<0')
	
	->find correct start position SAFELY (which is more than AmigaE does!)
	index := 0
	WHILE (string[index] <> 0) AND (pos > 0)
		index++
		pos--
	ENDWHILE
	
	readString := string + (index * SIZEOF CHAR) !!ARRAY OF CHAR
	
	->copy specified part of string
	StrCopy(eString, readString, len)
ENDPROC eString

PROC SetStr(eString:STRING, newLen)
	DEF pEString:PTR TO pEString
	
	->use check
	IF eString = NILS THEN Throw("EPU", 'EString; SetStr(); eString=NILS')
	IF newLen < 0     THEN Throw("EPU", 'EString; SetStr(); newLen<0')
	
	->retrieve string header
	pEString := eString - SIZEOF pEString !!VALUE!!PTR TO pEString
	
	->additional use check
	IF newLen >= pEString.size THEN Throw("EPU", 'EString; SetStr(); newLen exceeds string size')
	
	->set length
	pEString.length := newLen
	eString[newLen] := "\0"
ENDPROC

PROC ReadStr(fileHandle:PTR, eString:STRING) RETURNS fail:BOOL PROTOTYPE IS EMPTY

PROC StringF(eString:STRING, fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) RETURNS eString2:STRING, len PROTOTYPE IS EMPTY

PROC StringFL(eString:STRING, fmtString:ARRAY OF CHAR, args=NILL:ILIST) RETURNS eString2:STRING, len PROTOTYPE IS EMPTY

PROC RealF(eString:STRING, value:FLOAT, decimalPlaces=8) RETURNS eString2:STRING PROTOTYPE IS EMPTY

PROC Link(complex:STRING, tail:OWNS STRING)
	DEF pEString:PTR TO pEString
	
	->use check
	IF complex = NILS THEN Throw("EPU", 'EString; Link(); complex=NILS')
	
	->retrieve string header
	pEString := complex - SIZEOF pEString !!VALUE!!PTR TO pEString
	
	->store tail's header
	pEString.next := IF tail THEN tail - SIZEOF pEString !!VALUE!!PTR TO pEString ELSE NIL
ENDPROC complex

PROC Next(complex:STRING)
	DEF tail:STRING
	DEF pEString:PTR TO pEString
	
	IF complex = NILS THEN RETURN NILS
	
	->retrieve string header
	pEString := complex - SIZEOF pEString !!VALUE!!PTR TO pEString
	
	->return tail with hidden header
	pEString := pEString.next
	tail := IF pEString = NIL THEN NILS ELSE pEString + SIZEOF pEString !!VALUE!!STRING
ENDPROC tail

PROC Forward(complex:STRING, num)
	DEF tail:STRING
	DEF pEString:PTR TO pEString
	
	->use check
	IF num < 0        THEN Throw("EPU", 'EString; Forward(); num<0')
	
	IF complex = NILS THEN RETURN NILS
	
	->retrieve string header
	pEString := complex - SIZEOF pEString !!VALUE!!PTR TO pEString
	
	WHILE (pEString <> NIL) AND (num > 0)
		pEString := pEString.next
		num--
	ENDWHILE
	
	->retrieve string after header
	tail := IF pEString = NIL THEN NILS ELSE pEString + SIZEOF pEString !!VALUE!!STRING
ENDPROC tail
