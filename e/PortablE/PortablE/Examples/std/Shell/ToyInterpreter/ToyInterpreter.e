/*
	A skeleton Toy Interpreter, by Christopher Handley.
	Version date: 13-Jan-2011
	
	Placed in the public domain, so do with it as you wish, but please credit me.
*/
OPT POINTER
MODULE 'std/cPath'

->global variables for the loaded file
DEF fileContents:STRING, fileSize


PROC main()
	DEF file:PTR TO cFile
	NEW file.new()
	
	->open file containing code to be interpreted
	IF file.open('code.txt', /*readOnly*/ TRUE) = FALSE THEN Throw("FILE", 'Failed to open file')
	
	->load contents of file into an e-string
	fileSize := file.getSize() !!VALUE
	
	NEW fileContents[fileSize]
	file.read(fileContents, fileSize)
	file.close()
	SetStr(fileContents, fileSize)
	
	->now interpret the loaded code
	interpreter()
FINALLY
	PrintException()
	
	->deallocate our resources
	END fileContents
	END file
ENDPROC


->constants that are used to represent the different kinds of characters/tokens
SET TYPE_NUMBER, TYPE_WORD, TYPE_SYMBOL,
    TYPE_NEWLINE, TYPE_SPACE,
    TYPE_STRING,
    TYPE_ENDOFFILE, TYPE_UNKNOWN,
    TYPEMAX

->determine the type of character 
PROC characterType(chara:CHAR)
	DEF type
	
	SELECT 128 OF chara
	CASE "0" TO "9"
		type := TYPE_NUMBER
		
	CASE "a" TO "z", "A" TO "Z", "_"
		type := TYPE_WORD
		
	CASE "=", "+", "-", "*", "/", ","
		type := TYPE_SYMBOL
		
	CASE "\n"
		type := TYPE_NEWLINE
		
	CASE " ", "\t", "\b"
		type := TYPE_SPACE
		
	CASE "'"
		type := TYPE_STRING
		
	CASE "\0"
		type := TYPE_ENDOFFILE
		
	DEFAULT
		type := TYPE_UNKNOWN
	ENDSELECT
ENDPROC type


->global variables for handling tokens
DEF token:STRING, tokenType, nextPosition=0

->get the next character
PROC nextCharacter() IS fileContents[nextPosition++]

->get the previous character
PROC prevCharacter() IS fileContents[--nextPosition]

->get the next token
PROC nextToken()
	DEF character:CHAR, charaType, startPosition, size
	
	->dispose of the last token
	END token
	
	->get the first non-space character
	REPEAT
		character := nextCharacter()
		tokenType := characterType(character)
	UNTIL tokenType <> TYPE_SPACE
	
	
	->get the rest of the token
	SELECT TYPEMAX OF tokenType
	CASE TYPE_NUMBER, TYPE_WORD, TYPE_SYMBOL
		->find last character that has the same type (as the first one)
		startPosition := nextPosition - 1
		REPEAT
			character := nextCharacter()
		UNTIL characterType(character) <> tokenType
		
		prevCharacter()		->we don't want the last character, since it is of a different type
		
		->create a token from all the characters that had the same type
		size := nextPosition - startPosition
		NEW token[size]
		StrCopy(token, fileContents, size, startPosition)
		
	CASE TYPE_NEWLINE
		->create a new-line token
		token := NEW '\n'
		
	CASE TYPE_STRING
		->find end of string
		startPosition := nextPosition - 1
		REPEAT
			character := nextCharacter()
			charaType := characterType(character)
		UNTIL (charaType = TYPE_STRING) OR (charaType = TYPE_ENDOFFILE)
		
		IF charaType = TYPE_ENDOFFILE THEN prevCharacter()	->let next call of nextToken() handle end-of-file
		
		->create a token containing the string (without it's quote characters)
		size := (nextPosition - 1) - (startPosition + 1)
		NEW token[size]
		StrCopy(token, fileContents, size, startPosition + 1)
		
	CASE TYPE_ENDOFFILE
		->reached end of file, so silently quit
		Raise("QUIT")
		
	DEFAULT
		Print('ERROR: Character "\c" has an unknown type.\n', character)
		Raise("HALT")
	ENDSELECT
ENDPROC

/*
->returns the position of the next token to be parsed
PROC getPosition() IS nextPosition

->changes position of the next token to be parsed
PROC setPosition(position)
	nextPosition := position
ENDPROC
*/

->see if token matches
PROC tokenMatches(string:ARRAY OF CHAR, type) IS StrCmp(token, string) AND (tokenType = type)


->halt program with an error message
PROC error(message:ARRAY OF CHAR, opt1=0, opt2=0, opt3=0, opt4=0, opt5=0, opt6=0, opt7=0, opt8=0)
	Print('ERROR: ')
	Print(message, opt1, opt2, opt3, opt4, opt5, opt6, opt7, opt8)
	Print('.\n')
	Raise("HALT")
ENDPROC

->halt program if on an unexpected token type
PROC expectedType(type, error:ARRAY OF CHAR)
	IF tokenType <> type
		error('Reached "\s", but \s', token, error)
	ENDIF
ENDPROC


->global variables for interpreter
DEF variables[256]:ARRAY OF VALUE

->parse a number, returning it's value, and leaving it on the next token
PROC parseNumber()
	DEF value
	
	expectedType(TYPE_NUMBER, 'expected a number')
	value := Val(token)
	
	nextToken()
ENDPROC value

->parse a variable, returning it's letter, etc
PROC parseVariable()
	DEF letter:CHAR
	
	expectedType(TYPE_WORD, 'expected a variable')
	IF EstrLen(token) > 1 THEN error('expected a single letter for a variable')
	letter := token[0]
	
	nextToken()
ENDPROC letter

->parse an expression element (just a number or variable), returning it's value, etc
PROC parseExprElement()
	DEF value
	DEF letter:CHAR
	
	IF tokenType = TYPE_NUMBER
		->reached a number
		value := parseNumber()
		
	ELSE IF tokenType = TYPE_WORD
		->reached a (single letter) variable
		letter := parseVariable()
		value := variables[letter]
	ELSE
		expectedType(TYPE_NUMBER, 'expected a number or word')
	ENDIF
ENDPROC value

->parse a simple expression, returning it's value
PROC parseExpression()
	DEF value
	DEF second, symbol:CHAR
	
	value := parseExprElement()
	
	WHILE tokenType = TYPE_SYMBOL
		symbol := token[0]
		nextToken()
		
		second := parseExprElement()
		
		SELECT symbol
		CASE "+" ; value := value + second
		CASE "-" ; value := value - second
		CASE "*" ; value := value * second
		CASE "/" ; value := value / second
		DEFAULT
			error('unknown symbol "\c"', symbol)
		ENDSELECT
	ENDWHILE
	
ENDPROC value


->parse PRINT string, and leaving it on the next token
PROC parsePRINT()
	->parse statement
	nextToken()
	expectedType(TYPE_STRING, 'expected a string')
	
	->now execute statement
	Print('\s\n', token)
	
	->move to next token
	nextToken()
ENDPROC

->parse PRINTNUM expression, etc
PROC parsePRINTNUM()
	DEF value
	
	->parse statement
	nextToken()
	value := parseExpression()
	
	->now execute statement
	Print('\d\n', value)
	
	->no need to move to next token, as parseExpression() has already done that
ENDPROC

->parse LET letter = expression
PROC parseLET()
	DEF letter:CHAR, value
	
	->parse statement
	nextToken()
	letter := parseVariable()
	
	IF NOT tokenMatches('=', TYPE_SYMBOL) THEN error('expected an "="')
	nextToken()
	
	value := parseExpression()
	
	
	->now execute statement
	variables[letter] := value
	
	->no need to move to next token, as parseExpression() has already done that
ENDPROC

->interpret the next statement
PROC parseStatement()
	->skip any blank lines
	WHILE tokenType = TYPE_NEWLINE
		nextToken()
	ENDWHILE
	
	->parse the statement
	IF tokenMatches('PRINT', TYPE_WORD)
		parsePRINT()
		
	ELSE IF tokenMatches('PRINTNUM', TYPE_WORD)
		parsePRINTNUM()
		
	ELSE IF tokenMatches('LET', TYPE_WORD)
		parseLET()
	ELSE
		error('Unexpected token "\s" at beginning of statement', token)
	ENDIF
	
	->parse end of statement
	expectedType(TYPE_NEWLINE, 'expected a new line')
	nextToken()
ENDPROC


->our Interpreter
PROC interpreter()
	->interpret statements 'forever' (a "QUIT" exception is raised when reaching the end of the file)
	nextToken()
	LOOP
		parseStatement()
	ENDLOOP
	
FINALLY
	IF exception = "QUIT"
		Print('Finished.\n')
		exception := 0
		
	ELSE IF exception = "HALT"
		->error has already been reported
		exception := 0
	ENDIF
	
	->deallocate our resources
	END token
ENDPROC

