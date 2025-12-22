/* -----------------------------------------------------------------------------

 ©1999 Dietmar Eilert. All Rights Reserved.

 AmigaE version by Tomasz Wiszkowski [error@alpha.net.pl]

 -------------------------------------------------------------------------------
*/

OPT PREPROCESS

#date VERSION 'amigae.syntax 1.0 (%d.%m.%Y) by Tomasz Wiszkowski (error/bla²)'

MODULE 'golded/editor', 'golded/scanlib', 'exec/execbase'

    LIBRARY 'amigae.syntax', 1, 0, VERSION EXTRA 6 IS
        mountScanner,
        startScanner(A0,A1,D0,D1),
        closeScanner(A0),
        flushScanner(A0),
        setupScanner(A0),
        briefScanner(A0,A1),
        parseLine(A0,A1,D0),
        unparseLines(A0,D0),
        parseSection(A0,A1,D0)

PROC main()
    DEF b:PTR TO parserBase

    IF b:=FindName(execbase.liblist, 'amigae.syntax')
        b.magic:="GED6"
    ENDIF
ENDPROC

-> begin  "definitions"
OBJECT myParserHandle
    parserHandle:parserHandle;               // embedded parser handle
    syntaxStack:PTR TO syntaxChunk;          // parser output
ENDOBJECT

ENUM
    SYNTAX_STANDARD,
    SYNTAX_COMMENT,
    SYNTAX_STRING,
    SYNTAX_FUNCTION,
    SYNTAX_KEYWORD,
    SYNTAX_VARIABLE,
    SYNTAX_PREPROCESSOR,
    SYNTAX_VALUES,
    SYNTAX_MAXIMUM

-> end
-> begin "library functions"
-> begin mount scanner
PROC mountScanner()
    DEF parserData:parserData, example:PTR TO CHAR, labels:PTR TO CHAR

    parserData:=New(SIZEOF parserData)

    example:=[
        '/* ',
        '   AmigaE example',
        '*/ ',
        'OPT PREPROCESS             ',
        '#define BLAH "BLAH"+14     ',
        '                           ',
        'MODULE ''dos/dos''           ',
        '                           ',
        'PROC main()                ',
        '   // knock, knock...      ',
        '                           ',
        '   WriteF(''Hello world !'')',
        'ENDPROC                     ',
        NIL
    ]

    parserData.pd_Release    := SCANLIBVERSION;
    parserData.pd_Version    := 1;
    parserData.pd_Serial     := 0;
    parserData.pd_Info       := 'AmigaE syntax parser'
    parserData.pd_Example    := example;
    parserData.pd_Flags      := 0;
    parserData.pd_Properties := 0;

ENDPROC parserData
-> end
-> begin start scanner
PROC startScanner(globalConfigPtr=A0:PTR TO LONG /*globalConfig*/, editConfigPtr=A1:PTR TO editConfig, syntaxStack=D0:PTR TO syntaxChunk, syntaxSetup=D1:PTR TO syntaxSetup)
    DEF handle:PTR TO myParserHandle

    IF handle:=New(SIZEOF handle)
        handle.parserHandle.ph_Levels   := SYNTAX_MAXIMUM;
        handle.parserHandle.ph_Names    := ['Plain text', 'Comments', 'Strings', 'Functions', 'Keywords', 'Variables', 'Preprocessor', 'Values', NIL]
        handle.parserHandle.ph_ColorsFG := NIL;
        handle.parserHandle.ph_ColorsBG := NIL;
        handle.syntaxStack              := syntaxStack;
    ENDIF
ENDPROC handle
-> end
-> begin close scanner
PROC closeScanner(parserHandle=A0:PTR TO parserHandle)
    IF parserHandle THEN Dispose(parserHandle)
ENDPROC
-> end
-> begin flush scanner
PROC flushScanner(parserHandle=A0:PTR TO parserHandle) IS EMPTY
-> end
-> begin setup scanner
PROC setupScanner(globalConfigPtr=A0:PTR TO LONG /*globalConfig*/) IS EMPTY
-> end
-> begin brief scanner
PROC briefScanner(parserHandle=A0:PTR TO parserHandle, notify=A1:PTR TO scannerNotify) IS EMPTY
-> end
-> begin parse line
PROC parseLine(parserHandle=A0:PTR TO parserHandle, lineNode=A1:PTR TO lineNode, line=D0)

    IF IS_FOLD(lineNode) THEN RETURN

    IF lineNode.len
        RETURN parseString(lineNode.text, lineNode.len, parserHandle)
    ELSE
        RETURN
    ENDIF
ENDPROC
-> end
-> begin unparse lines
PROC unparseLines(lineNode=A0:PTR TO lineNode, lines=D0) IS EMPTY
-> end
-> begin parse section
PROC parseSection(parserHandle=A0:PTR TO parserHandle, lineNode=A1:PTR TO lineNode, lines=D0) IS EMPTY
-> end
-> end
-> begin  "private"
PROC parseString(text, len, parserHandle:PTR TO myParserHandle)
    DEF inString=0, indent=0, syntaxStack:PTR TO syntaxChunk
    DEF c=0, f

    syntaxStack:=parserHandle.syntaxStack

    IF len
        WHILE len AND (text[len-1]<=32) DO len--
        WHILE (indent<len) AND (text[]<=32)
            indent++
            text[]++
            len--
        ENDWHILE

        WHILE len>=2
            IF (text[]="$")
                syntaxStack[c].sc_Level:=SYNTAX_VALUES
                syntaxStack[c].sc_Start:=indent
                text++; indent++; len--
                WHILE ((text[]<="9") AND (text[]=>"0")) OR ((text[]=>"a") AND (text[]<="f")) OR ((text[]>="A") AND (text[]<="F")) AND (len=>0)
                    text++;indent++;len--
                ENDWHILE
                indent--; len++;text--
                syntaxStack[c].sc_End:=indent
                c++;
            ENDIF
            IF (text[]=$22)
                syntaxStack[c].sc_Level:=SYNTAX_VALUES
                syntaxStack[c].sc_Start:=indent
                REPEAT
                    text++; indent++; len--;
                UNTIL (text[]=$22) OR (len<0)
                syntaxStack[c].sc_End:=indent;
                c++;
            ENDIF
            IF ((text[]>"0") AND (text[]<"9"))
                syntaxStack[c].sc_Level:=SYNTAX_VALUES
                syntaxStack[c].sc_Start:=indent
                text++; indent++; len--
                WHILE ((text[]<="9") AND (text[]=>"0")) AND (len=>0)
                    text++;indent++;len--
                ENDWHILE
                indent--; len++;text--
                syntaxStack[c].sc_End:=indent
                c++;
            ENDIF
            IF text[]="#"
                syntaxStack[c].sc_Level:=SYNTAX_PREPROCESSOR
                syntaxStack[c].sc_Start:=indent
                text++; indent++; len--
                WHILE (text[]=>"a") AND (text[]<="z")
                      text++
                      len--
                      indent++
                ENDWHILE
                indent--
                len++
                text--
                syntaxStack[c].sc_End:=indent
                c++
            ENDIF

            IF text[]="\a"
                syntaxStack[c].sc_Level     := SYNTAX_STRING
                syntaxStack[c].sc_Start     := indent
                text[]++; indent++; len--
                WHILE text[]<>"\a"
                    text[]++
                    indent++
                    len--
                    IF len=0
                        syntaxStack[c].sc_Level:=FALSE
                        syntaxStack[c].sc_Start:=FALSE
                        syntaxStack[c].sc_End:=FALSE
                        RETURN syntaxStack
                    ENDIF
                ENDWHILE
                syntaxStack[c].sc_End       := indent
                c++
            ENDIF

            IF ((text[]=>"a") AND (text[]<="z")) OR (text[]="_")
                syntaxStack[c].sc_Level:=SYNTAX_VARIABLE
                syntaxStack[c].sc_Start:=indent
                WHILE (((text[]=>"a") AND (text[]<="z")) OR
                      ((text[]=>"A") AND (text[]<="Z")) OR
                      ((text[]=>"0") AND (text[]<="9")) OR
                      (text[]="_")) AND (len=>0)
                      text++
                      len--
                      indent++
                ENDWHILE
                indent--
                len++
                text--
                syntaxStack[c].sc_End:=indent
                c++
            ENDIF
            
            IF (text[]=>"A") AND (text[]<="Z")
                IF ((text[1]=>"A") AND (text[1]<="Z")) OR (text[1]="_")
                    syntaxStack[c].sc_Level:=SYNTAX_KEYWORD
                ELSE
                    syntaxStack[c].sc_Level:=SYNTAX_FUNCTION
                ENDIF
                syntaxStack[c].sc_Start:=indent
                WHILE (((text[]=>"a") AND (text[]<="z")) OR
                      ((text[]=>"A") AND (text[]<="Z")) OR
                      ((text[]=>"0") AND (text[]<="9")) OR
                      (text[]="_")) AND (len=>0)
                      text++
                      len--
                      indent++
                ENDWHILE
                indent--
                len++
                text--
                syntaxStack[c].sc_End:=indent
                c++
            ENDIF

            IF ((text[]="/") AND (text[1]="/")) OR
               ((text[]="-") AND (text[1]=">"))
                syntaxStack[c].sc_Level := SYNTAX_COMMENT;
                syntaxStack[c].sc_Start := indent;
                syntaxStack[c].sc_End   := indent + len - 1;
                c++
                syntaxStack[c].sc_Start := FALSE;
                syntaxStack[c].sc_End   := FALSE;
                syntaxStack[c].sc_Level := FALSE;
                RETURN syntaxStack
            ENDIF
            text++
            indent++
            len--
        ENDWHILE
    ENDIF
    syntaxStack[c].sc_Level     := FALSE
    syntaxStack[c].sc_Start     := FALSE
    syntaxStack[c].sc_End       := FALSE

ENDPROC syntaxStack
-> end
    CHAR '$VER: ', VERSION
