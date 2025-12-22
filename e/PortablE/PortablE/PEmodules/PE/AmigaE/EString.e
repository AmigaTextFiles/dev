/* PE/AmigaE/EString.e */
OPT NATIVE, INLINE
MODULE 'target/PE/base'

PROC NewString(maxLen) IS NATIVE {String(} maxLen {)} ENDNATIVE !!STRING
PROC DisposeString(eString:STRING) IS NATIVE {DisposeLink(} eString {)} ENDNATIVE BUT NILS
PROC StrCopy( eString:STRING, string:ARRAY OF CHAR, len=ALL, pos=0) IS NATIVE {StrCopy(} eString {,} string{+(}pos {),} len {)} ENDNATIVE !!STRING
PROC StrAdd(  eString:STRING, string:ARRAY OF CHAR, len=ALL, pos=0) IS NATIVE  {StrAdd(} eString {,} string{+(}pos {),} len {)} ENDNATIVE !!STRING
PROC EstrLen( eString:STRING) IS NATIVE {EstrLen(} eString {)} ENDNATIVE !!VALUE
PROC StrMax(  eString:STRING) IS NATIVE  {StrMax(} eString {)} ENDNATIVE !!VALUE
PROC RightStr(eString:STRING, eString2:STRING, n) IS NATIVE {RightStr(} eString {,} eString2 {,} n {)} ENDNATIVE !!STRING
PROC MidStr(  eString:STRING, string:ARRAY OF CHAR, pos, len=ALL) IS NATIVE {MidStr(} eString {,} string {,} pos {,} len {)} ENDNATIVE !!STRING
PROC SetStr(  eString:STRING, newLen) IS NATIVE {SetStr(} eString {,} newLen {)} ENDNATIVE
PROC Link(    complex:STRING, tail:STRING) IS NATIVE {Link(} complex {,} tail {)} ENDNATIVE !!STRING
PROC Next(    complex:STRING) IS NATIVE {Next(} complex {)} ENDNATIVE !!STRING
PROC Forward( complex:STRING, num) IS NATIVE {Forward(} complex {,} num {)} ENDNATIVE !!STRING

PROC ReadStr(fileHandle:PTR, eString:STRING) IS NATIVE {ReadStr(} fileHandle {,} eString {)} ENDNATIVE !!BOOL
PROC StringF(eString:STRING, fmtString:ARRAY OF CHAR, arg1=NIL, arg2=NIL, arg3=NIL, arg4=NIL, arg5=NIL, arg6=NIL, arg7=NIL, arg8=NIL)
	DEF len
	{} eString {,} len {:= StringF(} eString {,} fmtString {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {,} arg6 {,} arg7 {,} arg8 {)}
ENDPROC eString, len
PROC RealF(eString:STRING, value:FLOAT, decimalPlaces=8) IS NATIVE {RealF(} eString {,} value {,} decimalPlaces {)} ENDNATIVE !!STRING

PROC StringFL(eString:STRING, fmtString:ARRAY OF CHAR, args=NILL:ILIST) RETURNS eString2:STRING, len PROTOTYPE IS EMPTY

PROC StrJoin(s1=NILA:ARRAY OF CHAR, s2=NILA:ARRAY OF CHAR, s3=NILA:ARRAY OF CHAR, s4=NILA:ARRAY OF CHAR, s5=NILA:ARRAY OF CHAR, s6=NILA:ARRAY OF CHAR, s7=NILA:ARRAY OF CHAR, s8=NILA:ARRAY OF CHAR, s9=NILA:ARRAY OF CHAR, s10=NILA:ARRAY OF CHAR, s11=NILA:ARRAY OF CHAR)
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
ENDPROC newString
