MODULE  'dos/dos'

/*
    Description: Throw away code that was used to convert some large service
                 tables into source code for GP's internal service table
*/


PROC main()
DEF fh,
    line[500]:STRING,
    keyword[500]:STRING,
    port[500]:STRING,
    desc[500]:STRING,
    res=5,
    index,
    index2,
    temp[500]:STRING,
    fh2,
    outstr[500]:STRING,
    x,
    t,
    found

IF (fh:=Open('extra:download/port-numbers.txt',MODE_OLDFILE))<>-1
    fh2:=Open('extra:portlist.txt', MODE_NEWFILE)
    ->FOR t:=0 TO 50
    WHILE res>0
    StrCopy(temp,'xxx')
    res:=Fgets(fh, line, 500)
    IF line[0]<>35
    IF line[0]=32
        StrAdd(temp, line, ALL)
        StrCopy(line, temp, ALL)
    ENDIF
            IF found:=InStr(line, '/udp', 0)=-1
            index:=InStr(line, ' ', 0)
            MidStr(keyword, line, 0, index)
            MidStr(line, line, index+1, ALL)

            x:=0
            WHILE x=0
                x:=InStr(line, ' ',0)
                IF x=0
                    MidStr(line, line, 1, ALL)
                ENDIF
            ENDWHILE

            index:=InStr(line, ' ', 0)
            MidStr(port, line, 0, index)
            MidStr(line, line, index+1, ALL)

            index2:=InStr(port, '/', 0)
            MidStr(port, port, 0, index2)

            x:=0
            WHILE x=0
                x:=InStr(line, ' ',0)
                IF x=0
                    MidStr(line, line, 1, ALL)
                ENDIF
            ENDWHILE

            StrCopy(desc, line, StrLen(line)-1)

            ->PrintF('Key \s Port \s Desc \s\n', keyword, port, desc)
            StringF(outstr,'    CASE \s\n        StrCopy(servicedesc, \a\s : \s\a)\n', port, keyword, desc)
            Write(fh2, outstr, StrLen(outstr))
        ENDIF
    ENDIF
    ENDWHILE
    ->ENDFOR
    Close(fh)
    Close(fh2)
ELSE
    PrintF('Unable to open port numbers file\n')
ENDIF



ENDPROC
