/* MakePCQTags.rexx   */

/*
** PCQ Pascal has a short linebuffer. I know.:)
** When I tried to compile some of the triton examples
** I got gurus. The only thing I could think about was
** PCQ linebuffer and with lines of over 380 chars and
** perhaps a buffer of 255 chars, guru.
**
** After a while I got tired of spliting the lines by
** hand so I did this rexx script.
**
** It's only a quick hack but it works.:)
** It's veeery sloooow but ....
** If you translate a long set of macros then do like this.
** Start the translation, go for coffee.
**
** One reason it's slow is that it checks for commas
** in strings, it's not nice if it splits a string
** with commas.
**
** Someday I will write this in pascal or if someone does
** this send the program to me.
**
** Nils Sjoholm     nils.sjoholm@mailbox.swipnet.se
**
** Date: May 1 1996
**
**
** Usage
** rx MakePCQTags <yourmacro.macro>
** You will get <yourmacro.tags>
**
*/

PARSE ARG name

SIGNAL ON BREAK_C
SIGNAL ON SYNTAX

IF Index(name,'.') > 0 THEN DO
    PARSE VAR name thesource '.' extension
    outdcpp = thesource || '.dcpp'
    outtags = thesource || '.tags'
    END
    ELSE DO
        outdcpp = name || '.dcpp'
        outtags = name || '.tags'
    END

SAY 'Starting preprocessor'

ADDRESS command 'dcpp ' || name ||' -o' || outdcpp
IF rc > 0 THEN DO
    SAY 'Problem WITH dcpp'
    EXIT
END

commacount = 0

IF Open('textfile',outdcpp,'READ') THEN DO
    Open('outfile',outtags,'W')
    SAY "Working on " || outtags
    i = 1
    DO WHILE ~eof('textfile')
    line.i = ReadLn('textfile')
    IF line.i ~= '' & ~Index(line.i,"#") > 0 THEN DO
        CALL CheckLine(line.i)
        SAY "Doing line :" || i
        i = i +1
    END
    END
    CALL Close('textfile')
    CALL Close('outfile')
    SAY 'Writing header'
    CALL WriteNew(outtags)
    ADDRESS command 'Delete ' || outdcpp || ' quiet'
    SAY 'Done'
    END
EXIT

CheckLine: PROCEDURE expose commacount
    PARSE ARG theline
    quote = 0
    comma = 0
    thestring = ''
    theline = Strip(theline)
    DO k = 1 TO Length(theline)
    c=substr(theline,k,1)
    SELECT
        WHEN c = '"' THEN DO
           quote = quote + 1
           thestring = thestring || c
        END
        WHEN c = ',' THEN DO
           comma = comma + 1
           commacount = commacount + 1
           thestring = thestring || c
        END
    OTHERWISE
        thestring = thestring || c
    END
    SELECT
    WHEN quote ~= 1 & comma = 2 THEN DO
        CALL WriteLn('outfile',Copies(' ',10) || Strip(thestring))
        comma = 0
        thestring = ''
    END
    WHEN quote = 1 & comma = 2 THEN
        comma = comma - 1
    WHEN quote = 2 & comma <2 THEN
        quote = 0
    OTHERWISE
    NOP
    END
    END
    IF Length(thestring)>0 THEN
        CALL WriteLn('outfile',Copies(' ',10) || Strip(thestring))

RETURN

WriteNew: PROCEDURE expose commacount
    PARSE ARG thename
    IF Open('taglist',thename,'R') THEN DO
        i = 1
        DO WHILE ~eof('taglist')
            line.i = ReadLn('taglist')
            i = i +1
        END
        i = i -1
        CALL Close('taglist')
        Open('taglist',thename,'W')
        CALL WriteLn('taglist','(*')
        CALL WriteLn('taglist','**')
        CALL WriteLn('taglist','** Note: TagList created by MakePCQTags.rexx ')
        CALL WriteLn('taglist','**')
        CALL WriteLn('taglist','**       @ MapMead SoftWare, Nils Sjoholm')
        CALL WriteLn('taglist','**       nils.sjoholm@mailbox.swipnet.se')
        CALL WriteLn('taglist','**')
        CALL WriteLn('taglist','** Date: ' || Date())
        CALL WriteLn('taglist','**')
        CALL WriteLn('taglist','**       There were '||commacount||' commas in the file')
        CALL WriteLn('taglist','**       So you need a taglist with a value of at least '||commacount/2 || ' tags')
        CALL WriteLn('taglist','**')
        CALL WriteLn('taglist','*)')
        CALL WriteLn('taglist','')
        k = 1
        CALL WriteLn('taglist',Copies(' ',5) || Strip(line.k))
        DO k = 2 TO i
           CALL WriteLn('taglist',line.k)
        END
        CALL Close('taglist')
    END
RETURN


BREAK_C:
SYNTAX:
SAY "Sorry, error line" SIGL ":" ErrorText(RC) ":-("
EXIT


