/* ConvertTag.e */

MODULE 'exec/types'
MODULE 'dos/dos'

CONST ERROR_EOF = -1,
      MAXSTRLEN = 512,
      MINVERSION = 37,
      NL = 10

ENUM ARG_TAGFILE,
     ARG_BREAK,
     ERROR_BADARGS,
     ERROR_DOS,
     ERROR_NONE,
     NUMARGS

PROC main() HANDLE
    DEF line[MAXSTRLEN] : STRING,
        break[MAXSTRLEN] : STRING,
        tagfile,
        tempfile,
        tagfilename[MAXSTRLEN] : STRING,
        tempfilename[MAXSTRLEN] : STRING,
        status,
        pos,
        code

    '$VER: ConvertTag 37.4 (13.03.94) by Rodney Hester'

    IF KickVersion(MINVERSION) = FALSE
        WriteF('This program requires Kickstart version 2.04 or greater.\n')
        CleanUp(RETURN_FAIL)
    ENDIF

    tagfile := NIL
    tempfile := NIL

    getvars({tagfile}, {tempfile}, break)

    fgets(tagfile, line, 256)
    fputs(tempfile, line)
    REPEAT
        status := fgets(tagfile, line, 256)
        IF status <> NIL
           fputs(tempfile, '%%')
           fputc(tempfile, NL)
           IF InStr(line, break, 0) = -1
               fputs(tempfile, line)
           ELSE
               WHILE InStr(line, break, 0) <> -1
                   FOR pos := 0 TO (InStr(line, break, 0) - 1)
                       fputc(tempfile, line[pos])
                   ENDFOR
                   fputc(tempfile, NL)
                   MidStr(line, line, InStr(line, break, 0) + StrLen(break),
                     ALL)
               ENDWHILE
               fputs(tempfile, line)
            ENDIF
        ENDIF
    UNTIL status = NIL

    NameFromFH(tagfile, tagfilename, MAXSTRLEN)
    NameFromFH(tempfile, tempfilename, MAXSTRLEN)

    Raise(ERROR_NONE)

    EXCEPT
        code := IoErr()

        IF tagfile THEN Close(tagfile)
        IF tempfile THEN Close(tempfile)

        SELECT exception
            CASE ERROR_BADARGS;
                IF code
                    PrintFault(code, NIL)
                ELSE
                    PutStr('bad args\n')
                ENDIF
                CleanUp(RETURN_FAIL)
            CASE ERROR_DOS;
                PrintFault(code, NIL)
                CleanUp(RETURN_FAIL)
            CASE ERROR_NONE;
                DeleteFile(tagfilename)
                Rename(tempfilename, tagfilename)
                CleanUp(RETURN_OK)
        ENDSELECT
ENDPROC

PROC getvars(tagfile, tempfile, break)
    DEF args[NUMARGS] : LIST,
        rdargs,
        template,
        filename[MAXSTRLEN] : STRING,
        argnum

    FOR argnum := 0 TO NUMARGS - 1 DO args[argnum] := NIL
    template := 'TAGFILE/A,BREAK/K'
    rdargs := ReadArgs(template, args, NIL)
    IF rdargs = NIL THEN Raise(ERROR_BADARGS)

    IF args[ARG_TAGFILE]
        ^tagfile := Open(args[ARG_TAGFILE], MODE_OLDFILE)
        IF ^tagfile = NIL THEN Raise(ERROR_DOS)
        IF (InStr(args[ARG_TAGFILE], ':', 0) = -1) AND
          (InStr(args[ARG_TAGFILE], '/', 0) = -1)
            filename := 'ConvertTag.temp'
        ELSE
            IF InStr(args[ARG_TAGFILE], '/', 0) = -1
                MidStr(filename, args[ARG_TAGFILE], 0,
                  InStr(args[ARG_TAGFILE], ':', 0) + 1)
            ELSE
                MidStr(filename, args[ARG_TAGFILE], 0,
                  InStr(args[ARG_TAGFILE], '/', 0) + 1)
            ENDIF
            StrAdd(filename, 'ConvertTag.temp', ALL)
        ENDIF
        ^tempfile := Open(filename, MODE_NEWFILE)
        IF ^tempfile = NIL THEN Raise(ERROR_DOS)
    ENDIF
    IF args[ARG_BREAK]
        StrCopy(break, args[ARG_BREAK], ALL)
    ELSE
        StrCopy(break, '\\n', ALL)
    ENDIF

    FreeArgs(rdargs)
ENDPROC

PROC fgets(file, string, length)
    DEF status

    status := Fgets(file, string, length)
    IF status = NIL AND IoErr() THEN Raise(ERROR_DOS)

    RETURN status
ENDPROC

PROC fputc(file, char)
    IF FputC(file, char) = ERROR_EOF THEN Raise(ERROR_DOS)
ENDPROC

PROC fputs(file, string)
    IF Fputs(file, string) = ERROR_EOF THEN Raise(ERROR_DOS)
ENDPROC
