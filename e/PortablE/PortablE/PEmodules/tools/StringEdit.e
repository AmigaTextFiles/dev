/* StringEdit.e 08-04-2017 by Chris Handley
	This is an INCOMPLETE reimplementation of the StringEdit module written by Daniel Westerberg,
	but the hardest procedures are already done :-)
*/

->PROC killMark(string:ARRAY OF CHAR) RETURN str:OWNS STRING

->PROC center(string:ARRAY OF CHAR, centeredWidth, makeWidthFixed=0) RETURNS str:OWNS STRING

PROC splitStr(str:ARRAY OF CHAR, numOfWords=2) RETURNS list:OWNS LIST /*OF STRING*/, numOfStr
	DEF start, pastEnd, term:CHAR, len, newStr:OWNS STRING
	
	NEW list[numOfWords]
	numOfStr := 0
	
	start := 0
	WHILE str[start] = " " DO start++
	WHILE str[start] <> 0
		pastEnd := start + 1
		term := IF str[start] <> "\"" THEN " " ELSE "\""
		WHILE (str[pastEnd] <> term) AND (str[pastEnd] <> 0) DO pastEnd++
		IF term <> " " THEN pastEnd++
		NEW newStr[len := pastEnd - start]
		StrCopy(newStr, str, len, start)
		list[numOfStr++] := newStr
		WHILE (str[pastEnd] <> "\"") AND (str[pastEnd] <> 0) DO pastEnd++
		
		start := pastEnd
		WHILE str[start] = " " DO start++
	ENDWHILE IF numOfStr >= numOfWords
	SetList(list, numOfStr)
FINALLY
	IF exception THEN END list
ENDPROC

PROC makeBin(value, numOfBits=-1, pre=1) RETURNS str:OWNS STRING
	DEF i, pos
	
	NEW str[(IF pre THEN 1 ELSE 0) + IF numOfBits >= 1 THEN numOfBits ELSE 32]
	pos := 0
	IF pre THEN str[pos++] := "%"
	IF numOfBits < 0
		i := 31
		WHILE %1 SHL i AND value = 0 DO i--
	ELSE
		i := Min(32,numOfBits) - 1
	ENDIF
	WHILE i >= 0 DO str[pos++] := IF %1 SHL i-- AND value THEN "1" ELSE "0"
	SetStr(str, pos)
FINALLY
	IF exception THEN END str
ENDPROC
