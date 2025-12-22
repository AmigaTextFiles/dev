/* PortablE target module that completes EStrings */
OPT NATIVE, INLINE, POINTER
MODULE 'target/PE/base'
PUBLIC MODULE 'PE/EString_partial'

/* missing E-string functions */

PROC StringF(eString:STRING, fmtString:ARRAY OF CHAR, arg1=0, arg2=0, arg3=0, arg4=0, arg5=0, arg6=0, arg7=0, arg8=0) REPLACEMENT
	DEF max, len
	
	max := StrMax(eString)
	len := NATIVE {snprintf(} eString {,} max+1 {,} fmtString {,} arg1 {,} arg2 {,} arg3 {,} arg4 {,} arg5 {,} arg6 {,} arg7 {,} arg8 {)} ENDNATIVE !!VALUE
	len := Min(len, max)
	SetStr(eString, len)
ENDPROC eString, len

PROC ReadStr(fileHandle:PTR, eString:STRING) RETURNS fail:BOOL REPLACEMENT
	fail := (NATIVE {fgets(} eString {,} StrMax(eString)+1 {, (FILE*) } fileHandle {)} ENDNATIVE !!PTR = NIL)
	SetStr(eString, StrLen(eString))
ENDPROC

/*->snprintf() simply does not work on too many compilers, for floating-point
PROC RealF(eString:STRING, value:FLOAT, decimalPlaces=8) REPLACEMENT
	DEF max, len
	
	max := StrMax(eString)
	len := NATIVE {snprintf(} eString {,} max+1 {, "%.*f",} decimalPlaces {,} value {)} ENDNATIVE !!VALUE
	SetStr(eString, Min(len, max))
ENDPROC eString
*/


PROC RealF(eString:STRING, value:FLOAT, decimalPlaces=8) REPLACEMENT
	DEF integer:FLOAT, nextDecimalPlaces
	
	StrCopy(eString, IF value>0 THEN '' ELSE '-')
	value := Fabs(value)
	
	integer := Ffloor(value)
	appendDecimal(eString, integer!!VALUE, 0)
	
	IF decimalPlaces > 0
		StrAdd(eString, '.')
		
		value := value - integer
		REPEAT
			nextDecimalPlaces := Min(decimalPlaces, 9)
			decimalPlaces := decimalPlaces - nextDecimalPlaces
			
			value := value * Pow(10, nextDecimalPlaces)
			integer := Ffloor(value)
			appendDecimal(eString, integer!!VALUE, nextDecimalPlaces)
			value := value - integer
		UNTIL decimalPlaces <= 0
	ENDIF
ENDPROC eString

PRIVATE
PROC appendDecimal(eString:STRING, value, minWidth)
	DEF isNegative:BOOL, temp[12]:ARRAY OF CHAR, pos:BYTE, digit
	
	->use check
	IF eString = NILA THEN Throw("EPU", 'PE/CPP/EString; appendDecimal(); eString=NILA')
	
	->force value to be positive
	IF value >= 0
		isNegative := FALSE
	ELSE
		isNegative := TRUE
		value := 0 - value		->make value positive
	ENDIF
	
	->end string with terminating zero to make it valid
	pos := 11
	temp[pos] := "\0"
	
	->write string (from end of string) representing value as decimal digits
	IF value = 0
		pos--
		temp[pos] := "0"
		minWidth--
	ELSE
		REPEAT
			->extract right-most digit then remove from value
			digit, value := Mod(value, 10)
			
			->write digit as character
			pos--
			temp[pos] := "0" + digit !!CHAR
			minWidth--
		UNTIL value = 0
		
		->prepend minus sign if was negative
		IF isNegative
			pos--
			temp[pos] := "-"
		ENDIF
	ENDIF
	
	->prepend required 0 digits
	WHILE minWidth > 0
		pos--
		temp[pos] := "0"
		minWidth--
	ENDWHILE
	
	->now append string representation to target E-string
	StrAdd(eString, temp, ALL, pos)
ENDPROC eString
PUBLIC
