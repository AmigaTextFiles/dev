OPT OSVERSION=37

/*

    Program: AmiyEnc
    Version: V0.6
    Author : Ian Chapman

    Description: Encodes files using single-part or multi-part yEnc encoding.

    LICENSE: Permission is granted to use this source code in whole or in part,
             providing that the author (Ian Chapman) is credited in your project
             in either the documentation, or the program itself. This applies to
             both free and commercial software. In the case of commercial
             software (including ShareWare), I am entitled to a free, fully
             functional copy of the software.

             NO WARRANTY EITHER EXPRESSED OR IMPLIED AS TO THE FITNESS OF THIS
             CODE FOR ANY PURPOSE. ALL USE IS ENTIRELY AND WHOLLY AT YOUR OWN
             RISK

*/

MODULE  'dos/dos',
        'exec/memory',
        '*crctable'

ENUM NORMAL, ERR_NOINFILE, ERR_NOMEM, ERR_NOREAD, ERR_NOOUTFILE, ERR_BADARGS, ERR_BADLINE,
     ERR_TOOMANYPARTS, ERR_FILEEXISTS

RAISE ERR_NOMEM IF NewM()=NIL

DEF line=128,
    multi=NIL,
    inputfile[500]:STRING,
    outputfile[500]:STRING,
    header[400]:STRING,
    part=1,
    total=0,
    force=NIL,
    crctable:PTR TO LONG

PROC main() HANDLE
DEF myargs:PTR TO LONG,
    p:PTR TO CHAR,
    ifh=NIL,
    mem=NIL,
    filelen,
    rdargs,
    basename[500]:STRING
    
myargs:=[NIL,NIL,NIL,NIL,NIL,NIL]

IF rdargs:=ReadArgs('INPUTFILE/A,DEST/K,LINE/N,MULTI/N,FORCE/S', myargs, NIL)          ->Command line parameters
    StrCopy(inputfile, myargs[0])
    IF (myargs[2] > 0) THEN line:=Long(myargs[2])
    IF (myargs[3] > 0) THEN multi:=Long(myargs[3])
    force:=myargs[4]
    IF myargs[1]=0
        StrCopy(basename, FilePart(inputfile), 26)                             ->Deals with a missing DEST option,
        IF multi=0 THEN StringF(basename, '\s.ync', basename)                  ->and also the case where truncation
    ELSE                                                                       ->may cause multi-parts to get the same name.
        IF multi=0                                                             ->(Due to AmigaDOS 30 char filename limit)
            StrCopy(basename, myargs[1])
        ELSE
            StrCopy(basename, myargs[1], 26)
        ENDIF
    ENDIF

    FreeArgs(rdargs)
ELSE
    Raise(ERR_BADARGS)
ENDIF

IF (line>997) OR (line<64) THEN Raise(ERR_BADLINE)                             ->Check line parameter is in range
init_crctable()                                                                ->Initialise CRC32 table
IF (filelen:=FileLength(inputfile))<1 THEN Raise(ERR_NOINFILE)                 ->Get input filelength

IF (ifh:=Open(inputfile, MODE_OLDFILE))=NIL THEN Raise(ERR_NOINFILE)           ->Open input file
mem:=NewM(filelen, MEMF_PUBLIC OR MEMF_CLEAR)                                  ->Reserve buffer to size of file
IF (Read(ifh, mem, filelen)<>filelen) THEN Raise(ERR_NOREAD)                   ->Read file into buffer
p:=mem                                                                         ->Initialise pointer to start of buffer

IF multi>0                                                                     ->This section calculates the number of chunks
    total:=Div(filelen, multi)                                                 ->that will be generated.
    IF Mul(total, multi) < filelen THEN total++                                ->This may seem odd, but it is to handle remainders
ENDIF                                                                          ->in a 32bit way. Ie any remainder means +1 chunk

IF total>999 THEN Raise(ERR_TOOMANYPARTS)                                      ->Raises if there are more than 999 parts. (as extention is 3 chars)

WHILE (p<(mem+filelen))                                                        ->Keep processing all chunks
                                                                               ->If multipart, name in sequence
    IF multi>0 THEN StringF(outputfile, '\s.\z\d[3]', basename, part) ELSE StrCopy(outputfile, basename)
    p:=encode(p, filelen, mem)                                                 ->Start encoding
    IF multi>0 THEN PrintF('=> \s [\d] (Part \d)\n', outputfile, FileLength(outputfile), part) ELSE PrintF('=> \s [\d]\n', outputfile, FileLength(outputfile))
    part++
ENDWHILE

EXCEPT DO
    IF (mem) THEN Dispose(mem)
    IF (ifh) THEN Close(ifh)
    SELECT exception
        CASE NORMAL
            ->NORMAL EXIT
        CASE ERR_NOINFILE
            PrintF('ERROR: Unable to open input file or input file size is 0.\n')
        CASE ERR_NOOUTFILE
            PrintF('ERROR: Unable to open output file.\n')
        CASE ERR_NOMEM
            PrintF('ERROR: Unable to allocate enough memory for buffer.\n')
        CASE ERR_NOREAD
            PrintF('ERROR: Unable to read all of the input file.\n')
        CASE ERR_BADLINE
            PrintF('ERROR: Line parameter out of range (64 - 997).\n')
        CASE ERR_TOOMANYPARTS
            PrintF('ERROR: Produces more than 999 parts. Increase multi value.\n')
        CASE ERR_BADARGS
            PrintF('yEnc Encoder by Ian Chapman v0.6\n\n')
            PrintF('Parameters: INPUTFILE/A,DEST/K,LINE/N,MULTI/N,FORCE/S\n')
            PrintF('Example: amiyenc myfile DEST=RAM:encoded\n')
        CASE ERR_FILEEXISTS
            PrintF('WARNING: File already exists\n')
        DEFAULT
            PrintF('ERROR: Unknown exception (\d). Please report to author.\n',exception)
    ENDSELECT

ENDPROC exception


/*** Procedure to initialise the CRC table ***/
PROC init_crctable() IS crctable:=get_crctable()


/*** Procedure to peform encoding ***/
PROC encode(ptr:PTR TO CHAR, flen, memloc)
DEF count=0,
    bytesdone=1,
    crcvalue=$FFFFFFFF,
    holder[1000]:STRING,
    trailer[100]:STRING,
    stripped_name[101]:STRING,
    output,
    begin=0,
    end=0,
    char_loc=0

    IF (force=FALSE) AND (FileLength(outputfile) > -1)
        Raise(ERR_FILEEXISTS)
    ELSE
        IF (output:=Open(outputfile, MODE_NEWFILE))=NIL THEN Raise(ERR_NOOUTFILE)  ->Open outfile file
    ENDIF

    StrCopy(stripped_name, FilePart(inputfile))                                     -> Replace chars not allowed in a yEnc Filename
    WHILE (char_loc:=InStr(stripped_name, '\\'))>-1 DO stripped_name[char_loc]:=$5F -> Note : / are not allowed either but we
    WHILE (char_loc:=InStr(stripped_name, '<'))>-1 DO stripped_name[char_loc]:=$5F  -> shouldn't need to check them as they are
    WHILE (char_loc:=InStr(stripped_name, '>'))>-1 DO stripped_name[char_loc]:=$5F  -> illegal in Amiga filenames too.
    WHILE (char_loc:=InStr(stripped_name, '"'))>-1 DO stripped_name[char_loc]:=$5F
    WHILE (char_loc:=InStr(stripped_name, '@'))>-1 DO stripped_name[char_loc]:=$5F

    begin:=(ptr-memloc)+1
    IF part=total THEN end:=flen ELSE end:=(ptr-memloc)+multi

    IF multi>0                                                                 ->Create header depending on whether multi ot single
        StringF(header, '=ybegin part=\d total=\d line=\d size=\d name=\s\b\n', part, total, line, flen, stripped_name)
        StringF(header, '\s=ypart begin=\d end=\d',header, begin, end)
    ELSE
        StringF(header, '=ybegin X-Encoder=amiyenc X-Encoder-Version=0.6 line=\d size=\d name=\s', line, flen, stripped_name)
    ENDIF

    Write(output, header, EstrLen(header))                                     ->Write header to file

    WHILE (ptr<>(memloc+flen))                                                 ->Start encoding
        IF count=0 THEN Write(output, '\b\n', 2)                               ->We have reached EOL (line), so write EOL sequence
        crcvalue:=Eor(crctable[And(Eor(crcvalue, Char(ptr)), $FF)], And(Shr(crcvalue,8), $FFFFFF))
        PutChar(ptr, Mod(Char(ptr)+42, 256))                                   ->Decode character

        SELECT $3E OF Char(ptr)                                                ->The holder string is used as a buffer for
            CASE 0, 9, $A, $D, $20, $2E, $3D                                   ->converted characters so we don't need
                holder[count]:="="                                             ->to keep issuing writes for each character
                count++                                                        ->as this is very slow. We just write out
                PutChar(ptr, Mod(Char(ptr)+64, 256))                           ->the buffer when full, then flush it.
        ENDSELECT

        holder[count]:=Char(ptr)
        ptr++
        count++
        bytesdone++

        IF (count=line) OR (count > line)
            SetStr(holder, count)
            Write(output, holder, EstrLen(holder))
            count:=0
        ENDIF

        EXIT (multi>0) AND (bytesdone>multi)                                   ->If multi-part encoding, stop when part size reached
    ENDWHILE

    SetStr(holder, count)                                                      ->Write out any remaining buffer
    Write(output, holder, EstrLen(holder))
                                                                               ->Create trailer depending on multi or single
    IF multi>0
        StringF(trailer, '\b\n=yend part=\d total=\d size=\d pcrc32=\h\b\n', part, total, end-begin+1, Eor(crcvalue, $FFFFFFFF))
    ELSE
        StringF(trailer, '\b\n=yend size=\d crc32=\h\b\n', flen, Eor(crcvalue, $FFFFFFFF))
    ENDIF
    Write(output, trailer, EstrLen(trailer))                                   ->Write trailer to file
    Close(output)

ENDPROC ptr

version:
CHAR '$VER: yEnc Encoder by Ian Chapman v0.6',0
