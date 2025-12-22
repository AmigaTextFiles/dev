/* AmigaETag.e */

MODULE 'exec/types'
MODULE 'dos/dos'

CONST ERROR_EOF = -1,
      MAXSTRLEN = 512,
      MINVERSION = 37,
      NL = 10,
      SPACE = 32

ENUM ARG_TAGFILE,
     ARG_EDITFILE,
     ARG_NUMLINES,
     ARG_PREFIX,
     ARG_SEED,
     ARG_TAG,
     ARG_ADDNL,
     ARG_COUNT,
     ARG_NOSTRIP,
     ERROR_BADARGS,
     ERROR_DOS,
     ERROR_NONE,
     NUMARGS

PROC main() HANDLE
    DEF tagfile = NIL,
        editfile = NIL,
        tagfilename[MAXSTRLEN] : STRING,
        editfilename[MAXSTRLEN] : STRING,
        currline = 1,
        line[MAXSTRLEN] : STRING,
        prefix[MAXSTRLEN] : STRING,
        seed,
        tagnum,
        totallines = NIL,
        tagend,
        code,
        strip
        
    '$VER: AmigaETag 37.6 (13.03.94) by Rodney Hester'

    IF KickVersion(MINVERSION) = FALSE
        WriteF('This program requires Kickstart version 2.04 or greater.\n')
        CleanUp(RETURN_FAIL)
    ENDIF

    tagfile := NIL
    editfile := NIL

    getvars({tagfilename}, {editfilename}, {totallines}, prefix, {seed},
      {tagnum}, {tagend}, {strip})

    IF strip THEN striptag(editfilename, prefix)

    tagfile := Open(tagfilename, MODE_OLDFILE)
    IF tagfile = NIL THEN Raise(ERROR_DOS)
    IF StrCmp(editfilename, '', ALL) = FALSE
        editfile := Open(editfilename, MODE_OLDFILE)
        IF editfile = NIL THEN Raise(ERROR_DOS)
    ELSE
        editfile := stdout
    ENDIF

    IF tagnum = NIL
        IF seed = -1 THEN CurrentTime({seed}, {seed})
        Rnd(-seed)

        tagnum := Rnd(totallines) + 1
    ELSE
        IF tagnum > totallines THEN Raise(ERROR_BADARGS)
    ENDIF

    WHILE (currline < tagnum) AND (tagnum <> 1)
        fgets(tagfile, line, MAXSTRLEN)
        IF InStr(line, '%%', 0) = 0 THEN INC currline
    ENDWHILE

    IF editfile <> stdout THEN
      IF Seek(editfile, 0, OFFSET_END) = ERROR_EOF THEN Raise(ERROR_DOS)

    putline(editfile, tagfile, prefix, line, tagend)

    Raise(ERROR_NONE)

    EXCEPT
        IF tagfile THEN Close(tagfile)
        IF editfile AND (editfile <> stdout) THEN Close(editfile)

        code := IoErr()

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
                CleanUp(RETURN_OK)
        ENDSELECT
ENDPROC

PROC getvars(tagfilename, editfilename, totallines, prefix, seed, tagnum,
  tagend, strip)
    DEF args[NUMARGS] : LIST,
        rdargs,
        template,
        line[MAXSTRLEN] : STRING,
        argnum,
        tagfile

    FOR argnum := 0 TO NUMARGS - 1 DO args[argnum] := NIL
    template := 'TAGFILE/A,EDITFILE,NUMLINES/K/N,PREFIX/K,SEED/K/N,' +
      'TAG/K/N,ADDNL/S,COUNT/S,NOSTRIP/S'
    rdargs := ReadArgs(template, args, NIL)
    IF rdargs = NIL THEN Raise(ERROR_BADARGS)

    ^strip := TRUE

    IF args[ARG_TAGFILE]
        StrCopy(^tagfilename, args[ARG_TAGFILE], ALL)
    ENDIF
    tagfile := Open(^tagfilename, MODE_OLDFILE)
    IF tagfile = NIL THEN Raise(ERROR_DOS)
    IF args[ARG_NUMLINES]
        ^totallines := Long(args[ARG_NUMLINES])
        IF ^totallines < 1 THEN Raise(ERROR_BADARGS)
    ELSE
        ^totallines := 1
        WHILE Fgets(tagfile, line, MAXSTRLEN)
            IF InStr(line, '%%', 0) = 0 THEN ^totallines := ^totallines + 1
        ENDWHILE
        IF IoErr() THEN Raise(ERROR_DOS)
        IF Seek(tagfile, 0, OFFSET_BEGINNING) = ERROR_EOF THEN
          Raise(ERROR_DOS)
        IF args[ARG_COUNT]
            WriteF('Number of lines in tag file: \d\n', ^totallines)
            Raise(ERROR_NONE)
        ENDIF
    ENDIF
    Close(tagfile)
    IF args[ARG_EDITFILE]
        StrCopy(^editfilename, args[ARG_EDITFILE], ALL)
    ELSE
        ^strip := FALSE
        ^editfilename := ''
    ENDIF
    IF args[ARG_PREFIX]
        StrCopy(prefix, args[ARG_PREFIX], ALL)
    ELSE
        StrCopy(prefix, '... ', ALL)
    ENDIF
    IF args[ARG_SEED]
        IF Long(args[ARG_SEED]) < 0
            ^seed := Abs(Long(args[ARG_SEED]))
        ELSE
            ^seed := Long(args[ARG_SEED])
        ENDIF
    ELSE
        ^seed := -1
    ENDIF
    IF args[ARG_TAG]
        IF args[ARG_SEED] <> NIL THEN Raise(ERROR_BADARGS)
        ^tagnum := Long(args[ARG_TAG])
        IF ^tagnum < 1 THEN Raise(ERROR_BADARGS)
    ELSE
        ^tagnum := NIL
    ENDIF
    ^tagend := IF args[ARG_ADDNL] THEN '\n\n' ELSE '\n'
    IF args[ARG_NOSTRIP] THEN ^strip := FALSE

    FreeArgs(rdargs)
ENDPROC

PROC putline(editfile, tagfile, prefix, line, tagend)
    DEF counter,
        seed,
        status,
        linelen
        
    fputc(editfile, NL)

    CurrentTime({seed}, {seed})
    Rnd(-seed)

    fputs(editfile, prefix)
    fgets(tagfile, line, MAXSTRLEN)
    StrCopy(line, line, StrLen(line) - 1)
    fputs(editfile, line)
    linelen := StrLen(prefix) + StrLen(line)
    REPEAT
        status := fgets(tagfile, line, MAXSTRLEN)
        IF (InStr(line, '%%', 0) <> 0) AND (status <> NIL)
            fputc(editfile, NL)
            FOR counter := 1 TO StrLen(prefix) DO fputc(editfile, SPACE)
            StrCopy(line, line, StrLen(line) - 1)
            fputs(editfile, line)
            linelen := StrLen(prefix) + StrLen(line)
        ENDIF
    UNTIL (InStr(line, '%%', 0) = 0) OR (status = NIL)
    fputs(editfile, tagend)
ENDPROC

PROC striptag(editfilename, prefix)
    DEF buffer[MAXSTRLEN] : STRING,
        line[MAXSTRLEN] : STRING,
        editfile,
        tempfile,
        tempfilename[MAXSTRLEN] : STRING,
        found = FALSE,
        bufferread,
        lineread,
        status

    editfile := Open(editfilename, MODE_OLDFILE)
    IF editfile = NIL THEN Raise(ERROR_DOS)

    IF (InStr(editfilename, ':', 0) = -1) AND
      (InStr(editfilename, '/', 0) = -1)
        tempfilename := 'StripTag.temp'
    ELSE
        IF InStr(editfilename, '/', 0) = -1
            MidStr(tempfilename, editfilename, 0,
              InStr(editfilename, ':', 0) + 1)
        ELSE
            MidStr(tempfilename, editfilename, 0,
              InStr(editfilename, '/', 0) + 1)
        ENDIF
        StrAdd(tempfilename, 'StripTag.temp', ALL)
    ENDIF
    tempfile := Open(tempfilename, MODE_NEWFILE)
    IF tempfile = NIL THEN Raise(ERROR_BADARGS)

    REPEAT
        bufferread := FALSE
        lineread := FALSE
        status := fgets(editfile, buffer, 256)
        IF status <> NIL
            bufferread := TRUE
            IF buffer[0] = 10
                IF fgets(editfile, line, 256) <> NIL
                    lineread := TRUE
                    IF InStr(line, prefix, 0) = 0 THEN found := TRUE
                ENDIF
            ENDIF
        ENDIF
        IF found <> TRUE
            IF bufferread THEN fputs(tempfile, buffer)
            IF lineread THEN fputs(tempfile, line)
        ENDIF
    UNTIL found OR (status = NIL)

    Close(editfile)
    Close(tempfile)

    DeleteFile(editfilename)
    Rename(tempfilename, editfilename)
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
