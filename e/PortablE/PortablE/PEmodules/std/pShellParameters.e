/* pShellParameters.e 06-06-2020
    Portable shell parameter parsing, heavily inspired by AmigaOS's marvelous ReadArgs().
	Developed in 2009, 2011, 2014 by Christopher Steven Handley.
	Basically finished 10-01-2009, started 09-01-2009.
*/

MODULE 'std/pShell'

PRIVATE

->CONST DEBUG = FALSE

DEF parsingTemplate:BOOL

SET TYPE_LETTER, TYPE_NUMBER,				->TYPE_WORD, but TYPE_LETTER is never returned by charaType()
	TYPE_STRING,
    TYPE_SLASH, TYPE_COMMA, TYPE_EQUALS,	->TYPE_SYMBOL
    TYPE_SPACER, TYPE_EOL, TYPE_UNKNOWN
CONST TYPE_WORD   = TYPE_LETTER OR TYPE_NUMBER
CONST TYPE_SYMBOL = TYPE_SLASH OR TYPE_COMMA OR TYPE_EQUALS

DEF templateCopy:OWNS STRING
DEF templateNames:OWNS ARRAY OF OWNS STRING		->aliases are linked to the first string
DEF templateFlags:OWNS ARRAY OF VALUE
DEF templateSize=0
SET FLAG_A, FLAG_K, FLAG_S, FLAG_N, FLAG_F

DEF paramCopy:OWNS STRING
DEF templateMatches:OWNS ARRAY OF OWNS STRING

PROC deallocate()
	DEF i
	IF templateNames   THEN FOR i := 0 TO templateSize - 1 DO END templateNames[i]
	IF templateMatches THEN FOR i := 0 TO templateSize - 1 DO END templateMatches[i]
	
	END templateCopy
	END templateNames
	END templateFlags
	END paramCopy
	END templateMatches
ENDPROC

PROC end() IS deallocate()


PROC findKeyword(word:ARRAY OF CHAR) RETURNS found:BOOL, index
	DEF name:STRING
	
	found := FALSE
	FOR index := 0 TO templateSize - 1
		name := templateNames[index]
		WHILE name
			found := StrCmpNoCase(word, name)
			name := Next(name)
		ENDWHILE IF found
	ENDFOR IF found
ENDPROC

DEF silentErrors:BOOL

PUBLIC


->parse shell parameters according to supplied template
PROC ParseParams(template:ARRAY OF CHAR, shellArgs=NILA:ARRAY OF CHAR, silent=FALSE:BOOL) RETURNS success:BOOL
	DEF i, len, token:OWNS STRING, type, flags
	DEF question:BOOL, inputBuffer:OWNS STRING
	DEF nextParam, isKeyword:BOOL, keywordParam
	
	success := TRUE
	silentErrors := silent
	
	->deallocate anything from a previous call
	deallocate()
	
	->count commas to find number of template parameters
	templateSize := 1
	len := StrLen(template)
	FOR i := 0 TO len-1 DO IF template[i] = "," THEN templateSize++
	
	NEW templateNames  [templateSize]
	NEW templateFlags  [templateSize + 1]	->last flag is always 0
	NEW templateMatches[templateSize + 1]	->last 'match' is always NILS
	
	->parse template
	parsingTemplate := TRUE
	templateCopy := StrJoin(template)
	initToken(templateCopy)
	i := 0
	REPEAT
		token, type := nextToken()
		
		->parameter name
		IF type AND NOT TYPE_WORD THEN lastTokenError(token, 'expected word for parameter name')
		IF findKeyword(token) THEN lastTokenError(token, 'parameter name already used')
		templateNames[i] := PASS token
		token, type := nextToken()
		
		->parameter name aliases
		WHILE type AND TYPE_EQUALS
			END token
			
			token, type := nextToken()
			IF type AND NOT TYPE_WORD THEN lastTokenError(token, 'expected word for parameter name')
			IF findKeyword(token) THEN lastTokenError(token, 'parameter name already used')
			Link(token, Next(templateNames[i]))
			Link(templateNames[i], PASS token)
			
			token, type := nextToken()
		ENDWHILE
		
		->parameter flag(s)
		flags := 0
		WHILE type AND TYPE_SLASH
			END token
			
			token, type := nextToken()
			IF type AND NOT TYPE_WORD THEN lastTokenError(token, 'expected letter for parameter type')
			IF      StrCmp(token, 'A') ; flags := flags OR FLAG_A ; IF flags AND FLAG_S THEN lastTokenError(token, 'parameter type conflicts with a previous type')
			ELSE IF StrCmp(token, 'K') ; flags := flags OR FLAG_K ; IF flags AND FLAG_S THEN lastTokenError(token, 'parameter type conflicts with a previous type')
			ELSE IF StrCmp(token, 'N') ; flags := flags OR FLAG_N ; IF flags AND FLAG_S THEN lastTokenError(token, 'parameter type conflicts with a previous type')
			ELSE IF StrCmp(token, 'F') ; flags := flags OR FLAG_F ; IF flags AND FLAG_S THEN lastTokenError(token, 'parameter type conflicts with a previous type')
			ELSE IF StrCmp(token, 'S') ; flags := flags OR FLAG_S ; IF flags AND (FLAG_A OR FLAG_K OR FLAG_N OR FLAG_F) THEN lastTokenError(token, 'parameter type conflicts with a previous type')
			ELSE
				lastTokenError(token, 'unknown parameter type')
			ENDIF
			END token
			
			token, type := nextToken()
		ENDWHILE
		templateFlags[i] := flags
		
		->handle end of parameter
		i++
		IF type AND TYPE_COMMA
			IF i >= templateSize THEN Throw("BUG", 'template array index out of bounds')
			
		ELSE IF type AND NOT TYPE_EOL
			lastTokenError(token, 'expected "," or end of line')
		ENDIF
		END token
	UNTIL type AND TYPE_EOL
	
	->check for ? at end of parameters
	IF shellArgs = NILA THEN shellArgs := ShellArgs()
	
	parsingTemplate := FALSE
	i := StrLen(shellArgs)
	WHILE i > 0
		i--
	ENDWHILE IF charaType(shellArgs[i]) <> TYPE_SPACER
	
	question := FALSE
	IF i >= 0
		IF shellArgs[i] = "?"
			IF i = 0
				question := TRUE
			ELSE
				question := (charaType(shellArgs[i-1]) = TYPE_SPACER)
			ENDIF
		ENDIF
	ENDIF
	
	IF question
		->report template
		Print('\s: ', template)
		PrintFlush()
		
		->ask user for additional parameters
		NEW inputBuffer[1000]
		IF ReadStr(stdin, inputBuffer) THEN StrCopy(inputBuffer, '\n')
		SetStr(inputBuffer, EstrLen(inputBuffer) - 1)	->strip trailing \n
		
		->append to original input
		NEW paramCopy[StrLen(shellArgs)-1 + EstrLen(inputBuffer)]
		StrCopy(paramCopy, shellArgs, StrLen(shellArgs)-1)
		StrAdd( paramCopy, inputBuffer)
		END inputBuffer
	ENDIF
	
	->parse parameters according to template
	parsingTemplate := FALSE
	IF paramCopy = NILS THEN paramCopy := StrJoin(shellArgs)
	initToken(paramCopy)
	
	token, type := nextToken()
	nextParam := 0
	WHILE (templateFlags[nextParam] AND (FLAG_K OR FLAG_S)) DO nextParam++
	
	WHILE type AND NOT TYPE_EOL
		->see if parameter is a keyword
		IF type AND TYPE_WORD
			isKeyword, i := findKeyword(token)
			IF templateMatches[i] THEN isKeyword := FALSE	->ignore keyword match if it has already been matched previously
		ELSE
			isKeyword := FALSE
		ENDIF
		
		IF isKeyword
			IF templateFlags[i] AND FLAG_S
				->store switch keyword
				templateMatches[i] := PASS token
			ELSE
				->(matched keyword) so get parameter
				END token
				token, type := nextToken()
				IF type = TYPE_EQUALS ; END token ; token, type := nextToken() ; ENDIF
				keywordParam := i
			ENDIF
			
		ELSE IF nextParam < templateSize
			keywordParam := nextParam
		ELSE
			lastTokenError(token, 'does not match template')
		ENDIF
		
		IF token
			->(was not a switch keyword)
			IF templateFlags[keywordParam] AND FLAG_F
				->extend current token to rest of line
				tokenNextPos := tokenNextPos - EstrLen(token)
				IF type AND TYPE_STRING THEN tokenNextPos := tokenNextPos - 2
				END token
				
				NEW token[EstrLen(tokenSource) - tokenNextPos]
				StrCopy(token, tokenSource, ALL, tokenNextPos)
				tokenNextPos := EstrLen(tokenSource)
			ENDIF
			
			IF type AND (TYPE_WORD OR TYPE_STRING)		->WORD = LETTER OR NUMBER
				->was: IF type AND TYPE_NUMBER = 0
				IF type <> TYPE_NUMBER
					IF templateFlags[keywordParam] AND FLAG_N THEN lastTokenError(token, 'expected number')
				ENDIF
				templateMatches[keywordParam] := PASS token
				
			ELSE IF type AND TYPE_EOL
				lastTokenError(token, IF isKeyword THEN 'expected value after keyword' ELSE 'unexpected end of line')
			ELSE
				lastTokenError(token, 'illegal character')
			ENDIF
		ENDIF
		
		->go to next parameter
		token, type := nextToken()
		WHILE (templateMatches[nextParam] <> NILS) OR (templateFlags[nextParam] AND (FLAG_K OR FLAG_S)) DO nextParam++
	ENDWHILE IF type AND TYPE_EOL
	
	->check all required parameters have been supplied
	FOR i := 0 TO templateSize - 1
		IF (templateMatches[i] = NILS) AND (templateFlags[i] AND FLAG_A) THEN generalError('missing required parameter "\s"', templateNames[i])
	ENDFOR
FINALLY
	END token
	END inputBuffer
	
	IF exception = "ERR"
		->(parsing error which was already reported) so return failure
		exception := 0
		success := FALSE
	ENDIF
ENDPROC

PROC GetParam(index) RETURNS arg:ARRAY OF CHAR
	->use check
	IF (index < 0) OR (index >= templateSize) THEN Throw("EPU", 'std/pShellParameters; GetParam(); index is out of range')
	
	arg := templateMatches[index]
ENDPROC

PROC NumberOfParams() RETURNS numberOfParams IS templateSize


PRIVATE

DEF tokenSource:STRING
DEF tokenNextPos

->initialise tokeniser
PROC initToken(source:STRING)
	tokenSource  := source
	tokenNextPos := 0
ENDPROC

->get next non-spacer token
PROC nextToken() RETURNS token:OWNS STRING, type
	DEF lastPos, startPos, size, firstChara:CHAR
	
	lastPos := EstrLen(tokenSource) - 1
	IF tokenNextPos > lastPos THEN RETURN NEW '', TYPE_EOL
	
	REPEAT
		END token
		startPos := tokenNextPos
		type := charaType(firstChara := tokenSource[tokenNextPos++])
		IF (firstChara = "-") AND (charaType(tokenSource[tokenNextPos], type) AND TYPE_WORD <> 0) THEN type := TYPE_WORD
		
		IF type AND (TYPE_WORD OR TYPE_SYMBOL OR TYPE_SPACER)
			->find last character with same type
			WHILE charaType(tokenSource[tokenNextPos], type) AND type <> 0 DO tokenNextPos++
			
			->create token
			NEW token[size := tokenNextPos - startPos]
			StrCopy(token, tokenSource, size, startPos)
			
		ELSE IF type AND TYPE_STRING
			->find closing quote character
			startPos++
			WHILE charaType(tokenSource[tokenNextPos]) <> TYPE_STRING
				tokenNextPos++
			ENDWHILE IF tokenNextPos > lastPos
			
			->create token
			NEW token[size := tokenNextPos - startPos]
			StrCopy(token, tokenSource, size, startPos)
			
			IF tokenNextPos > lastPos THEN lastTokenError(token, 'string is missing closing quote')
			tokenNextPos++	->move past closing quote character
			
		ELSE IF type AND TYPE_EOL
			token := NEW ''
			
		ELSE IF type AND TYPE_UNKNOWN
			token := NEW '?' ; token[0] := tokenSource[startPos]
			lastTokenError(token, 'unexpected character')
		ELSE
			Throw("BUG", 'std/pShellParameters; nextToken(); unknown token type')
		ENDIF
	UNTIL type <> TYPE_SPACER
	->Print('# token="\s", type=\s\n', token, IF type AND TYPE_LETTER THEN 'letter' ELSE IF type AND TYPE_NUMBER THEN 'number' ELSE IF type AND TYPE_STRING THEN 'string' ELSE IF type AND TYPE_EQUALS THEN 'equals' ELSE IF type AND TYPE_SYMBOL THEN 'symbol' ELSE IF type AND TYPE_SPACER THEN 'spacer' ELSE IF type AND TYPE_EOL THEN 'EOL' ELSE IF type AND TYPE_UNKNOWN THEN 'unknown' ELSE '(UNKNOWN)')
FINALLY
	IF exception THEN END token
ENDPROC

->get type of character
PROC charaType(chara:CHAR, firstType=0) RETURNS type
	SELECT 128 OF chara
	CASE "a" TO "z",
	     "A" TO "Z" ; type := TYPE_WORD
	CASE "0" TO "9" ; type := IF firstType = TYPE_WORD THEN TYPE_WORD ELSE TYPE_NUMBER
	CASE "-" ; type := TYPE_WORD		->was: IF firstType = 0 THEN TYPE_NUMBER ELSE TYPE_WORD
	CASE "\""; type := TYPE_STRING
	CASE "/" ; type := IF parsingTemplate THEN TYPE_SLASH ELSE TYPE_WORD
	CASE "," ; type := IF parsingTemplate THEN TYPE_COMMA ELSE TYPE_WORD
	CASE "=" ; type := TYPE_EQUALS
	CASE " ",
	     "\t"; type := TYPE_SPACER
	CASE 0   ; type := TYPE_EOL
	DEFAULT  ; type := IF parsingTemplate THEN TYPE_UNKNOWN ELSE TYPE_WORD
	ENDSELECT
ENDPROC

->report error message, highlighting the last token
PROC lastTokenError(token:STRING, message:ARRAY OF CHAR)
	DEF before:OWNS STRING, after:OWNS STRING, size
	DEF during:ARRAY OF CHAR
	
	IF NOT silentErrors
		NEW before[size := tokenNextPos - EstrLen(token)]
		StrCopy(before, tokenSource, size)
		
		during := IF EstrLen(token) = 0 THEN ' ' ELSE token
		
		NEW after[size := EstrLen(tokenSource) - tokenNextPos]
		StrCopy(after, tokenSource, size, tokenNextPos)
		
		Print('Shell \s error, \s:\n', IF parsingTemplate THEN 'template' ELSE 'parameter', message)
		Print('\s\s\s\s\s\n', before, HighlightOnString(), during, HighlightOffString(), after)
	ENDIF
	Raise("ERR")
FINALLY
	END before, after
ENDPROC

PROC generalError(message:ARRAY OF CHAR, p1=0, p2=0, p3=0, p4=0, p5=0, p6=0, p7=0, p8=0)
	IF NOT silentErrors
		Print('Shell \s error, ', IF parsingTemplate THEN 'template' ELSE 'parameter')
		Print(message, p1, p2, p3, p4, p5, p6, p7, p8)
		Print('\n')
	ENDIF
	Raise("ERR")
ENDPROC
