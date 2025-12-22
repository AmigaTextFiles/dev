OPT OSVERSION=37

/*

    Program: AmiyDec
    Version: V0.6
    Author : Ian Chapman

    Description: Decoder for single-part and multi-part yEnc encoded files.

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

ENUM NORMAL, ERR_NOLINE, ERR_NOSIZE, ERR_NOFILENAME, ERR_NOINFILE,
     ERR_NOMEM, ERR_NOREAD, ERR_NOOUTFILE, ERR_NOTRAILER, ERR_BADARGS,
     ERR_OUTOFORDER, ERR_FILEEXISTS

RAISE ERR_NOMEM IF NewM()=NIL

OBJECT yencoding
headstart                                                                      ->Header offset
headlen                                                                        ->Header length
line                                                                           ->Line parameter value
size                                                                           ->Size parameter value
encstart                                                                       ->Encoding Offset
trailstart                                                                     ->Trailer offset
traillen                                                                       ->Trailer length
crc                                                                            ->CRC parameter value
crcavail                                                                       ->Is CRC available
crccalc                                                                        ->Calculated CRC value
multipart                                                                      ->Is it a multipart encoding
ENDOBJECT

OBJECT yencpart
ypartstart                                                                     ->Ypart header offset
ypartlen                                                                       ->Ypart header length
total                                                                          ->Total number of parts
currentpart                                                                    ->Current part being worked on
crc                                                                            ->CRC parameter value
crcavail                                                                       ->Is CRC available
crccalc                                                                        ->Calculated CRC value
ENDOBJECT


DEF header[400]:STRING,
    trailer[100]:STRING,
    filename[255]:STRING,
    yenc:PTR TO yencoding,
    ypart:PTR TO yencpart,
    partsdecoded=0,
    totalparts=0,
    decoded=0,
    myargs:PTR TO LONG,
    files[200]:ARRAY OF LONG,
    rdargs,
    prevpart=0,
    outputdir[500]:STRING,
    inputfile[500]:STRING,
    force=FALSE,
    debug=FALSE,
    exception2=0

DEF crctable:PTR TO LONG


PROC main() HANDLE
DEF filequeue=0,
    result=NIL

    myargs:=[NIL,NIL,NIL,NIL,NIL]

    IF rdargs:=ReadArgs('INPUTFILES/A/M,DEST/K,DEBUG/S,FORCE/S',myargs,NIL)            ->Command line parameters
        files:=myargs[0]
        StrCopy(inputfile, files[0])

        IF myargs[1] = 0
            StrCopy(outputdir, '')
        ELSE
            StrCopy(outputdir, myargs[1])
        ENDIF

        debug:=myargs[2]
        force:=myargs[3]
    ELSE
        Raise(ERR_BADARGS)
    ENDIF

    WHILE files[filequeue]<>0                                                  ->Process each file in the queue
        StrCopy(inputfile, files[filequeue])
        result:=process()
        EXIT result=ERR_FILEEXISTS                                             ->Aborts processing of further files if the output file
        filequeue++                                                            ->already exists. Necessary for multi-part as it uses MODE_READWRITE
    ENDWHILE                                                               

    FreeArgs(rdargs)

    EXCEPT DO
        SELECT exception
            CASE NORMAL
                IF (decoded=0) AND (result=0)
                    PrintF('WARNING: File did not contain a valid yEnc encoding\n')
                    exception2:=104
                ELSE
                    IF (partsdecoded <> totalparts)
                        PrintF('ERROR: \d parts are missing from multi-part encoding.\n', totalparts-partsdecoded)
                        exception2:=102
                    ENDIF
                    PrintF('Files and parts decoded: \d\n', decoded)
                ENDIF
            CASE ERR_BADARGS
                PrintF('yEnc Decoder by Ian Chapman v0.6\n\n')
                PrintF('Parameters: INPUTFILES/A/M,DEST/K,DEBUG/S,FORCE/S\n')
                PrintF('Example: amiydec encoded.ync DEST=RAM:\n')
                exception2:=ERR_BADARGS
            DEFAULT
                PrintF('ERROR: Unknown exception (\d). Please report to author.\n',exception)
        ENDSELECT

ENDPROC exception2


/*** Procedure to decode all encodings in a file ***/
PROC process() HANDLE
DEF p:PTR TO CHAR,
    ifh=NIL,
    ofh=NIL,
    mem=NIL,
    filelen=-1,
    outputpath[500]:STRING

    IF (filelen:=FileLength(inputfile))<30 THEN Raise(ERR_NOINFILE)            ->Get input filelength
    IF (ifh:=Open(inputfile, MODE_OLDFILE))=NIL THEN Raise(ERR_NOINFILE)       ->Open input file
    mem:=NewM(filelen, MEMF_PUBLIC OR MEMF_CLEAR)                              ->Reserve buffer to size of file
    IF (Read(ifh, mem, filelen)<>filelen) THEN Raise(ERR_NOREAD)               ->Read file into buffer
    p:=mem

    WHILE (p<(mem+filelen))                                                    ->Continually checks for yencodings till EOF
        StrCopy(outputpath, outputdir)
        init_crctable_and_object()                                             ->Initialise CRC32 table
        p:=loc_hdr_start(p, filelen, mem)                                      ->Locate Header
        IF yenc.headstart=-1 THEN Raise(NORMAL)                                ->Raise if no header found.
        p:=loc_hdr_end(p, filelen, mem)                                        ->Locate end of header
        IF yenc.headlen=-1 THEN Raise(NORMAL)                                  ->Raise if no header end found.
        find_line()                                                            ->Find line parameter
        find_size()                                                            ->Find size parameter
        find_name()                                                            ->Find name parameter
        find_part()                                                            ->Find if multi or single

        IF yenc.multipart = TRUE
            find_total()                                                       ->Find total parameter
            p:=loc_ypart_start(p, filelen, mem)                                ->Locate ypart header
            IF ypart.ypartstart=-1 THEN Raise(NORMAL)                          ->Raise if not found
            p:=loc_ypart_end(p, filelen, mem)                                  ->Locate end of ypart header
            IF ypart.ypartlen=-1 THEN Raise(NORMAL)                            ->Raise if not found
            IF (ypart.currentpart-1) <> prevpart THEN Raise(ERR_OUTOFORDER)    ->Check we get parts in order
            prevpart:=ypart.currentpart
        ENDIF

        IF volume_or_dir(outputdir) = 0 THEN StrAdd(outputpath, '/')           ->Check if we need / on filepath
        StrAdd(outputpath, filename)

        IF  ypart.currentpart > 1
            IF (ofh:=Open(outputpath, MODE_READWRITE)) = NIL THEN Raise(ERR_NOOUTFILE)
            Seek(ofh, NIL, OFFSET_END)
        ELSE
            IF (force=FALSE) AND (FileLength(outputpath) > -1)
                Raise(ERR_FILEEXISTS)
            ELSE
                IF (ofh:=Open(outputpath, MODE_NEWFILE))=NIL THEN Raise(ERR_NOOUTFILE)
            ENDIF
        ENDIF

        p:=decode(p, filelen, mem, ofh)                                        ->Run decode routine
        IF (yenc.trailstart=-1) THEN Raise(ERR_NOTRAILER)                      ->Raise if trailer not found
        p:=loc_trail_end(p, filelen, mem)                                      ->Locate end of trailer
        find_crc()                                                             ->Find CRC32 parameter in trailer

        IF (debug=TRUE)                                                        ->Debugging information if DEBUG used
            PrintF('\nHdr Offset:     \d\n', yenc.headstart)
            PrintF('Hdr Length:     \d\n', yenc.headlen)
            PrintF('Hdr Contents:   \s\n', header)
            PrintF('Hdr Line Size:  \d\n', yenc.line)
            PrintF('Hdr File Size:  \d\n', yenc.size)
            PrintF('Hdr Filename:   \s\n', filename)
            PrintF('Enc Offset:     \d\n', yenc.encstart)
            PrintF('Tlr Offset:     \d\n', yenc.trailstart)
            PrintF('Tlr Length:     \d\n', yenc.traillen)
            PrintF('Tlr Contents:   \s\n', trailer)
            PrintF('Tlr CRC32:      \h\n', yenc.crc)
            PrintF('Calc CRC32:     \h\n\n', yenc.crccalc)
            IF (yenc.multipart=TRUE)
                PrintF('Ypart Offset:   \d\n', ypart.ypartstart)
                PrintF('Ypart Length:   \d\n', ypart.ypartlen)
                PrintF('Total Parts:    \d\n', ypart.total)
                PrintF('Current Part:   \d\n', ypart.currentpart)
                PrintF('Ypart Tlr CRC:  \h\n', ypart.crc)
                PrintF('Ypart Calc CRC: \h\n\n', ypart.crccalc)
            ENDIF
        ENDIF

        Close(ofh)
        ofh:=NIL

        IF yenc.multipart = TRUE
            PrintF('=> \s [\d] (Part=\d)\n', outputpath, FileLength(outputpath), ypart.currentpart)
        ELSE
            PrintF('=> \s [\d]\n', outputpath, FileLength(outputpath))
        ENDIF

        IF ypart.crcavail=1
            IF (ypart.crc <> ypart.crccalc)
                PrintF('ERROR: CRC32 mismatch, part \d is corrupt.\n', ypart.currentpart)
                exception2:=100
            ENDIF
        ENDIF

        IF (ypart.total = ypart.currentpart)                                   ->Works also for single parts as they will both be 0
            IF FileLength(outputpath)<>yenc.size
                PrintF('ERROR: File size mismatch between header and decoded file.\n')
                exception2:=101
            ENDIF

            IF (yenc.crcavail=1) AND (yenc.multipart=FALSE)
                IF (yenc.crc <> yenc.crccalc)
                    PrintF('ERROR: CRC32 mismatch, file is corrupt.\n')
                    exception2:=100
                ENDIF
            ENDIF
        ENDIF

        decoded++                                                              ->Increment files/parts decoded
        IF (yenc.multipart = TRUE) THEN partsdecoded++                         ->Keeps track of part order
        totalparts:=ypart.total                                                ->This is needed as ypart gets freed, but we this this value afterwards
        IF (yenc) THEN Dispose(yenc)                                           ->Free allocated mem for yenc
        IF (ypart) THEN Dispose(ypart)                                         ->Free allocated mem from ypart
    ENDWHILE

    EXCEPT DO
        IF (ofh<>0) THEN Close(ofh)
        IF (mem) THEN Dispose(mem)
        IF (ifh) THEN Close(ifh)
        SELECT exception
            CASE NORMAL
                -> Normal Exception
            CASE ERR_NOFILENAME
                PrintF('ERROR: Missing filename parameter from header.\n')
                exception2:=ERR_NOFILENAME
            CASE ERR_NOINFILE
                PrintF('ERROR: Unable to open input file (\s) or file too small.\n', inputfile)
                exception2:=ERR_NOINFILE
            CASE ERR_NOOUTFILE
                PrintF('ERROR: Unable to open output file.\n')
                exception2:=ERR_NOOUTFILE
            CASE ERR_NOMEM
                PrintF('ERROR: Unable to allocate enough memory for buffer.\n')
                exception2:=ERR_NOMEM
            CASE ERR_NOREAD
                PrintF('ERROR: Unable to read all of the input file.\n')
                exception2:=ERR_NOREAD
            CASE ERR_NOTRAILER
                PrintF('ERROR: Premature end of encoding, file may be corrupt.\n')
                exception2:=ERR_NOTRAILER
            CASE ERR_OUTOFORDER
                PrintF('ERROR: Multi-part encoding, out of order. Need part \d, got part \d.\n', prevpart+1, ypart.currentpart)
                exception2:=ERR_OUTOFORDER
            CASE ERR_FILEEXISTS
                PrintF('WARNING: Destination file already exists\n')
                exception2:=ERR_FILEEXISTS
            DEFAULT
                PrintF('ERROR: Unknown exception (\d). Please report to author.\n',exception)
        ENDSELECT

ENDPROC exception


/*** Procedure to find the line parameter in the header ***/
PROC find_line() HANDLE
DEF strstart=0,
    space=0,
    linesize[8]:STRING

    IF (strstart:=InStr(header, 'line=', 0))>-1
        space:=InStr(header, ' ', strstart)
        MidStr(linesize, header, strstart+5, space-(strstart+5))
        yenc.line:=Val(linesize)
    ELSE
        Raise(ERR_NOLINE)
    ENDIF

    EXCEPT DO
        SELECT exception
            CASE ERR_NOLINE
                PrintF('ERROR: Missing line parameter. Attempting to decode anyway.\n')
                exception2:=ERR_NOLINE
        ENDSELECT
ENDPROC


/*** Procedure to find the size parameter in the header ***/
PROC find_size() HANDLE
DEF strstart=0,
    space=0,
    size[8]:STRING

    IF (strstart:=InStr(header, 'size=', 0))>-1
        space:=InStr(header, ' ', strstart)
        MidStr(size, header, strstart+5, space-(strstart+5))
        yenc.size:=Val(size)
    ELSE
        Raise(ERR_NOSIZE)
    ENDIF

    EXCEPT DO
        SELECT exception
            CASE ERR_NOSIZE
                PrintF('ERROR: Missing size parameter. Attempting to decode anyway.\n')
                exception2:=ERR_NOSIZE
        ENDSELECT
ENDPROC


/*** Procedure to find the name parameter in the header ***/
PROC find_name()
DEF strstart=0,
    name[255]:STRING

    IF (strstart:=InStr(header, 'name=', 0))>-1
        MidStr(name, header, strstart+5, ALL)
        StrCopy(filename,name)
    ELSE
        Raise(ERR_NOFILENAME)
    ENDIF

    IF EstrLen(filename) > 102 THEN SetStr(filename, 102)                      -> AmigaDOS allows max of 102 chars for filename so truncate if necessary
    WHILE (filename[EstrLen(filename)-1] = $20) DO SetStr(filename, EstrLen(filename)-1) -> Remove trailing spaces
    IF (filename[0] = $22) AND (filename[EstrLen(filename)-1] = $22) THEN MidStr(filename, filename, 1, EstrLen(filename)-2) ->Remove " delimeters if necessary
    WHILE (InStr(filename, ':', 0)>-1) DO filename[InStr(filename,':',0)]:=$5F ->':' is illegal in Amiga filenames, so replace it.
    WHILE (InStr(filename, '/', 0)>-1) DO filename[InStr(filename,'/',0)]:=$5F ->'/' is illegal in Amiga filenames, so replace it.
                                                                               
    WHILE (InStr(filename, ';', 0)>-1) DO filename[InStr(filename,';',0)]:=$5F -> These are technically legal in filenames
    WHILE (InStr(filename, '%', 0)>-1) DO filename[InStr(filename,'%',0)]:=$5F -> but are problematic as they may get
    WHILE (InStr(filename, '#', 0)>-1) DO filename[InStr(filename,'#',0)]:=$5F -> interpreted as wildcards
    WHILE (InStr(filename, '?', 0)>-1) DO filename[InStr(filename,'?',0)]:=$5F
    WHILE (InStr(filename, '{', 0)>-1) DO filename[InStr(filename,'{',0)]:=$5F
    WHILE (InStr(filename, '}', 0)>-1) DO filename[InStr(filename,'}',0)]:=$5F
ENDPROC


/*** Procedure to check for the part parameter in the header ***/
PROC find_part()
DEF strstart=0,
    part[10]:STRING,
    space=0

    IF (strstart:=InStr(header,'part=', 0))>-1
        space:=InStr(header, ' ', strstart)
        MidStr(part, header, strstart+5, space-(strstart+5))
        ypart.currentpart:=Val(part)
        yenc.multipart:=TRUE
    ELSE
        ypart.currentpart:=0
        yenc.multipart:=FALSE
    ENDIF

ENDPROC

/*** Procedure to check for the total parameter in the header ***/
PROC find_total()
DEF strstart=0,
    total[10]:STRING,
    space=0

    IF (strstart:=InStr(header,'total=', 0))>-1
        space:=InStr(header, ' ', strstart)
        MidStr(total, header, strstart+6, space-(strstart+6))
        ypart.total:=Val(total)
    ELSE
        PrintF('WARNING: Total parameter missing. Assuming only 1 part.\n')
        exception2:=103
        ypart.total:=1
    ENDIF

ENDPROC

/*** Procedure to find the CRC32 in the trailer ***/
PROC find_crc()
DEF strstart=0,
    crc[10]:STRING,
    space=0

    yenc.crcavail:=-1
    ypart.crcavail:=-1

    IF (strstart:=InStr(trailer, ' crc32=', 0))>-1
        space:=InStr(trailer, ' ', strstart)
        MidStr(crc, trailer, strstart+7, space-(strstart+7))
        StringF(crc, '$\s', crc)
        yenc.crcavail:=1
        yenc.crc:=Val(crc)
    ENDIF

    IF (strstart:=InStr(trailer, 'pcrc32=', 0))>-1
        space:=InStr(trailer, ' ', strstart)
        MidStr(crc, trailer, strstart+7, space-(strstart+7))
        StringF(crc, '$\s', crc)
        ypart.crcavail:=1
        ypart.crc:=Val(crc)
    ENDIF

ENDPROC


/*** Procedure to initialise objects and CRC table ***/
PROC init_crctable_and_object()
    yenc:=New(SIZEOF yencoding)
    ypart:=New(SIZEOF yencpart)
    yenc.headstart:=-1                                                          -> Initialise these to -1 to be able to detect a failure
    yenc.headlen:=-1                                                            -> as 0 is considered a non-failure.
    yenc.trailstart:=-1
    yenc.crcavail:=-1
    yenc.multipart:=FALSE
    ypart.total:=0
    ypart.ypartstart:=-1
    ypart.ypartlen:=-1
    ypart.currentpart:=0
    ypart.crcavail:=-1
    crctable:=get_crctable()                                                   ->Initialise the CRC32 lookup table.
ENDPROC


/*** Procedure to locate the start of a header ***/
PROC loc_hdr_start(ptr:PTR TO CHAR, flen, memloc)
DEF stop=FALSE,
    temp[8]:STRING

    WHILE stop=FALSE                                                           ->Search the buffer for start of header
        IF (Char(ptr) = "=")
            StrCopy(temp, ptr, 8)
            IF (StrCmp(temp, '=ybegin ') = TRUE)
                yenc.headstart:=(ptr-memloc)
                stop:=TRUE
            ENDIF
        ENDIF
        ptr++
        IF (ptr>(memloc+flen)) THEN stop:=TRUE                                 ->Failsafe for loop in case header not found.
    ENDWHILE
ENDPROC ptr


/*** Procedure to locate the ypart header ***/
PROC loc_ypart_start(ptr:PTR TO CHAR, flen, memloc)
DEF stop=FALSE,
    temp[7]:STRING

    WHILE stop=FALSE                                                           ->Search the buffer for start of ypart header
        IF (Char(ptr) = "=")
            StrCopy(temp, ptr, 7)
            IF (StrCmp(temp, '=ypart ') = TRUE)
                ypart.ypartstart:=(ptr-memloc)
                stop:=TRUE
            ENDIF
        ENDIF
        ptr++
        IF (ptr>(memloc+flen)) THEN stop:=TRUE                                 ->Failsafe for loop in case header not found.
    ENDWHILE
ENDPROC ptr


/*** Procedure to locate the end of a header ***/
PROC loc_hdr_end(ptr:PTR TO CHAR, flen, memloc)
DEF stop=FALSE

    WHILE stop=FALSE                                                           ->Search for the end of the header
        IF (Char(ptr) = $0A)
            yenc.encstart:=(ptr-memloc)+1
            IF (Char(ptr-1) <> $0D)                                            ->For broken encoders only using LF instead of CRLF
                yenc.headlen:=(ptr-memloc)-yenc.headstart
            ELSE
                yenc.headlen:=(ptr-memloc)-yenc.headstart-1
            ENDIF
            StrCopy(header, memloc+yenc.headstart, yenc.headlen)
            stop:=TRUE                                                
        ENDIF


        ptr++
        IF (ptr>(memloc+flen)) THEN stop:=TRUE                                 ->Failsafe for loop in case end not found
    ENDWHILE
ENDPROC ptr


/*** Procedure to locate the end of a ypart header ***/
PROC loc_ypart_end(ptr:PTR TO CHAR, flen, memloc)
DEF stop=FALSE

    WHILE stop=FALSE                                                           ->Search for the end of ypart header
        IF (Char(ptr) = $0A)
            yenc.encstart:=(ptr-memloc)+1
            IF (Char(ptr-1) <> $0D)                                            ->For broken encoders only using LF instead of CRLF
                ypart.ypartlen:=(ptr-memloc)-ypart.ypartstart
            ELSE
                ypart.ypartlen:=(ptr-memloc)-ypart.ypartstart-1
            ENDIF
            stop:=TRUE
        ENDIF
        ptr++
        IF (ptr>(memloc+flen)) THEN stop:=TRUE                                 ->Failsafe for loop in case end not found
    ENDWHILE
ENDPROC ptr


/*** Procedure to peform decoding ***/
PROC decode(ptr:PTR TO CHAR, flen, memloc, output)
DEF stop=FALSE,
    temp[8]:STRING,
    count=0,
    crcvalue=-1

    WHILE stop=FALSE
                                                                  ->Decode the yEnc encoded section
        IF (Char(ptr) = $0D)
            Write(output, ptr-count, count)
            ptr++
            count:=0
        ENDIF

        IF (Char(ptr) = $0A)
            Write(output, ptr-count, count)
            ptr++
            count:=0
        ENDIF

        IF (Char(ptr) = $3D)
            StrCopy(temp, ptr, 6)
            IF (StrCmp(temp, '=yend ') = TRUE)
                yenc.trailstart:=(ptr-memloc)
                stop:=TRUE
            ELSE
                Write(output, ptr-count, count)
                ptr++
                count:=0
                PutChar(ptr, Char(ptr)-64)
            ENDIF
        ENDIF

        IF stop=FALSE
            PutChar(ptr, Char(ptr)-42)
            crcvalue:=Eor(crctable[And(Eor(crcvalue, Char(ptr)), $FF)], And(Shr(crcvalue,8), $FFFFFF))
            ptr++
            count++
        ENDIF

        IF (ptr>(memloc+flen)) THEN stop:=TRUE                                 ->Failsafe for loop in case premature end
    ENDWHILE
    Write(output, ptr-count, count)                                            ->Write any remaining buffers.

    IF yenc.multipart=TRUE
        ypart.crccalc:=Eor(crcvalue, $FFFFFFFF)
    ELSE
        yenc.crccalc:=Eor(crcvalue, $FFFFFFFF)                                 ->Calculate final CRC
    ENDIF
ENDPROC ptr


/*** Procedure to locate the end of the trailer ***/
PROC loc_trail_end(ptr:PTR TO CHAR, flen, memloc)
DEF stop=FALSE

    WHILE stop=FALSE                                                           ->Search for end of trailer
        IF (Char(ptr)=$0A)
            IF (Char(ptr-1) <> $0D)                                            ->For broken encoders only using LF instead of CRLF
                StrCopy(trailer, yenc.trailstart+memloc, ptr-(yenc.trailstart+memloc))
                yenc.traillen:=ptr-(yenc.trailstart+memloc)
            ELSE
                StrCopy(trailer, yenc.trailstart+memloc, (ptr-(yenc.trailstart+memloc))-1)
                yenc.traillen:=ptr-((yenc.trailstart+memloc))-1
            ENDIF
            stop:=TRUE
        ELSE
            ptr++
        ENDIF
        IF (ptr>(memloc+flen)) THEN stop:=TRUE                                 -> Failsafe for loop
    ENDWHILE
ENDPROC ptr


/*** Procedure to check if output is a volume or directory ***/
PROC volume_or_dir(path)
DEF type=0,
    temp[500]:STRING

    StrCopy(temp, path)
    IF (temp[(EstrLen(temp)-1)] = "/")                                         ->Check if output is a dir or volume
        type:=1
    ELSEIF (temp[(EstrLen(temp)-1)] = ":")
        type:=1
    ELSEIF (temp[(EstrLen(temp)-1)] = "")
        type:=1
    ENDIF
ENDPROC type

version:
CHAR '$VER: yEnc Decoder by Ian Chapman v0.6',0

