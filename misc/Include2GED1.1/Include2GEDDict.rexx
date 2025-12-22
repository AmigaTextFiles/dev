/*     Include2GEDDict.rexx - macro for developers using GoldED

VERSION
    $VER: Include2GEDDict.rexx 1.1 06.03.95

COPYRIGHT
    ©1995 Jan Skypala, Better Software

DISTRIBUTION
    This file is freeware, but also copyrighted to its author.
    You can distribute it in unchaged form for no or nominal fee, upload it to
    BBS, include on public domain CD-ROMs (like Aminet or Fred Fish), in
    magazines.
    It is permitted to include this macro within GoldED archive.
    It is permitted to include this macro in GoldED macro collections (like
    ESEE).
    I would not mind if you send a copy of magazine or free CD if you decided to
    publish it in the magazine or on the CD-ROM.
    It is permitted to include this macro in language packages (I would not mind
    if you send me a copy of package)
    I would not mind if you send at least postcard.

DESCRIPTION
    This is Arexx macro to make life more comfortable. If you like using GoldED
    dictionary for autocompletition and autocasing you maybe hate manual
    inserting every word you want. That's why this Arexx script comes. Running
    it on standard files it will grab the words for them and insert them into
    dictionary automaticaly. Currently recognized files:

    .fd    files with list of libraries functions
    .h     C include files
    .i     assembler include files
    .m     AmigaE include files

USAGE
    rx Include2GEDDict.rexx FILES/M

    FILES - list of files (including paths). If not specified and rexxreqtools
            library available then file requester opens and lets you select
            files.

REQUIREMENTS
    GoldED running
    rexxreqtools.library for file requester if no files specified
    ec:ShowModule for AmigaE modules processing

BUGS
    The program doesn't process two level nested C structures. It's built in,
    but GoldED crashes sometimes when I insert the words into dictionary (maybe
    they are too long), so I made the program to ignore them i.e. it will not
    produce any mischmasch in dictionary. If you want to see the place it is
    lines 381-384. It is the case of following include files and structures:
    devices/inputevent.h
        InputEvent.ie_position.ie_xy.ie_x
        InputEvent.ie_position.ie_xy.ie_y
        InputEvent.ie_position.ie_dead.ie_prev1DownCode
        InputEvent.ie_position.ie_dead.ie_prev1DownQual
        InputEvent.ie_position.ie_dead.ie_prev2DownCode
        InputEvent.ie_position.ie_dead.ie_prev2DownQual
    dos/dosextens.h
        DosList.dol_misc.dol_handler.dol_Handler
        DosList.dol_misc.dol_handler.dol_StackSize
        DosList.dol_misc.dol_handler.dol_Priority
        DosList.dol_misc.dol_handler.dol_Startup
        DosList.dol_misc.dol_handler.dol_SegList
        DosList.dol_misc.dol_handler.dol_GlobVec
        DosList.dol_misc.dol_volume.dol_VolumeDate
        DosList.dol_misc.dol_volume.dol_LockList
        DosList.dol_misc.dol_volume.dol_DiskType
        DosList.dol_misc.dol_assign.dol_AssignName
        DosList.dol_misc.dol_assign.dol_List
    dos/notify.h
        NotifyRequest.nr_stuff.nr_Msg.nr_Port
        NotifyRequest.nr_stuff.nr_Signal.nr_Task
        NotifyRequest.nr_stuff.nr_Signal.nr_SignalNum
        NotifyRequest.nr_stuff.nr_Signal.nr_pad
    You can insert them manually, of course.
    There are no three level nested structures in include files so I didn't care
    about them at all.

HISTORY
    1.0 - first public release
    1.1 - error messages showing in shell eliminated
        - now also understands macro definitions in AmigaE .m modules
        - one level nested C structures are now processed alright
        - typedef struct { ... } name (used in intuition/classusr.h) corrected
        - two level nested C structures processed, just because of GoldED
          crashing the words are not inserted into dictionary yet.
        - arrays in C structures now processed alright

FUTURE
    If you send me files e.g. for pascal I can do the work for them too. Just in
    the case they are pre-compiled (like AmigaE modules) I need some utility to
    convert them into text files.

AUTHOR'S ADDRESSES
    e-mail:     one@risc.upol.cz
    snail mail: Jan Skypala
                Zasovska 730
                Valasske Mezirici
                757 01
                Czech Republic
*/

OPTIONS RESULTS                             /* enable return codes     */

address 'GOLDED.1' 'LOCK CURRENT QUIET'     /* lock GUI, gain access   */
address command
OPTIONS FAILAT 6                            /* ignore warnings         */
SIGNAL ON SYNTAX                            /* ensure clean exit       */

if arg() = 1 then do
    args = upper( arg( 1 ) )
    do i = 1 to words( args )
        onearg = subword( args, i )
        if index( onearg, ' ' ) ~= 0 then onearg = substr( onearg, 1, index( onearg, ' ' ) - 1 )
        call processonefile( onearg )
        end
    end
else do
    if addlib( "rexxreqtools.library", 0, -30, 0 ) then do
        call rtfilerequest( , , "Select files", , "rtfi_flags=freqf_multiselect", files )
        if files == 1 then
            do i=1 to files.count
                call processonefile( upper( files.i ) )
            end
        end
    end

address 'GOLDED.1'
'UNLOCK'                                /* VERY important: unlock GUI */
EXIT

SYNTAX:

SAY "Sorry, error line" SIGL ":" ERRORTEXT(RC) ":-("
address 'GOLDED.1'
'UNLOCK'
EXIT

/* This procedure is called for every argument provided or every file selected
   in file requester */
processonefile: procedure
if index( arg(1), '.FD' ) ~= 0 then
    if substr( arg(1), index( arg(1), '.FD' ) ) = '.FD' then call fd( arg(1) )
if index( arg(1), '.M' ) ~= 0 then
    if substr( arg(1), index( arg(1), '.M' ) ) = '.M' then call m( arg(1) )
if index( arg(1), '.H' ) ~= 0 then
    if substr( arg(1), index( arg(1), '.H' ) ) = '.H' then call h( arg(1) )
if index( arg(1), '.I' ) ~= 0 then
    if substr( arg(1), index( arg(1), '.I' ) ) = '.I' then call i( arg(1) )
return 0

/* This procedure processes .fd files */
fd: procedure
if open( file, arg(1), read ) = 0 then do
                                       say 'File' arg(1) 'not found.'
                                       return 0
                                       end
fini = 0
process = 1
do until fini
    line = readln( file )
    uline = upper( line )
    fini = eof( file )
    select
        when uline = '##END' then fini = 1
        when uline = '##PUBLIC' then process = 1
        when uline = '##PRIVATE' then process = 0
        when process = 1 then
            select
                when index( line, '*' ) = 1 then nop
                when index( line, '##' ) = 1 then nop
                otherwise address 'GOLDED.1' 'PHRASE ADD' substr( line, 1, index( line, '(' ))
                end
        otherwise nop
        end
    end
call close(file)
return 0

/* This procedure processes AmigaE modules */
m: procedure
address command 'ec:showmodule' arg(1) '>t:module.$'
if open( file, 't:module.$', read ) = 0 then do
                                             say 'Error processing file' arg(1)
                                             return 0
                                             end
state = 0
do until eof( file )
    line = readln( file )
    select
        when index( line, 'CONST' ) = 1 then do
            address 'GOLDED.1' 'PHRASE ADD' substr( line, 7, index( line, '=' ) - 7 )
            status = 1
            end
        when index( line, '(---) OBJECT' ) = 1 then do
            object = substr( line, 14 )
            address 'GOLDED.1' 'PHRASE ADD' object
            status = 2
            end
        when index( line, '(---) ENDOBJECT' ) = 1 then status = 0
        when index( line, 'LIBRARY' ) = 1 then do
            address 'GOLDED.1' 'PHRASE ADD' substr( line, 9, index( line, ' ', 9 ) - 9 )
            status = 3
            end
        when index( line, 'ENDLIBRARY' ) = 1 then status = 0
        when index( line, 'PROC' ) = 1 then do
            address 'GOLDED.1' 'PHRASE ADD' substr( line, 6, index( line, '(' ) - 5 )
            status = 0
            end
        when index( line, '#define' ) = 1 then do
            if index( line, '/', 9 ) = 0 then address 'GOLDED.1' 'PHRASE ADD' substr( line, 9 )
                                         else address 'GOLDED.1' 'PHRASE ADD' substr( line, 9, index( line, '/' ) - 9 ) || '('
            status = 0
            end
        when line = '' then status = 0
        when status = 1 then address 'GOLDED.1' 'PHRASE ADD' substr( line, 7, index( line, '=' ) - 7 )
        when status = 2 then address 'GOLDED.1' 'PHRASE ADD' object || '.' || substr( line, 9, index( line, ':' ) - 9 )
        when status = 3 then address 'GOLDED.1' 'PHRASE ADD' substr( line, 3, index( line, '(' ) - 2 )
        otherwise nop
        end
    end
call close( file )
address command 'delete >NIL: t:module.$'
return 0

/* This procedure processes C headers (.h include files) */
h: procedure
if open( file, arg(1), read ) = 0 then do
                                       say 'File' arg(1) 'not found.'
                                       return 0
                                       end
note = 0
status = 0
substruct = 0
parth = 0
do until eof( file )
    line = readln( file )
    if note = 0 then
        if index( line, '/*' ) ~= 0 then
            do while index( line, '/*' ) ~= 0
                if index( line, '*/' ) ~= 0 then line = substr( line, 1, index( line, '/*' ) - 1 ) || substr( line, index( line, '*/' ) + 2 )
                                            else do
                                                 if index( line, '/*' ) = 1 then line = ''
                                                                            else line = substr( line, 1, index( line, '/*' ) - 1 )
                                                 note = 1
                                                 end
                end
        else nop
    else
        if index( line, '*/' ) = 0 then line = ''
                                   else do
                                       line = substr( line, index( line, '*/' ) + 2 )
                                       note = 0
                                       if index( line, '/*' ) ~= 0 then
                                           do while index( line, '/*' ) ~= 0
                                               if index( line, '*/' ) ~= 0 then line = substr( line, 1, index( line, '/*' ) - 1 ) || substr( line, index( line, '*/' ) + 2 )
                                                                           else do
                                                                                if index( line, '/*' ) = 1 then line = ''
                                                                                                           else line = substr( line, 1, index( line, '/*' ) - 1 )
                                                                                note = 1
                                                                                end
                                               if index( line, '/*' ) = 0 then strip = 0
                                               end
                                       else nop
                                       end
    do while index( line, ';' ) ~= 0
        line = substr( line, 1, index( line, ';' ) - 1 ) ' 1 ' substr( line, index( line, ';' ) + 1 )
        end
    do while index( line, ',' ) ~= 0
        line = substr( line, 1, index( line, ',' ) - 1 ) ' 2 ' substr( line, index( line, ',' ) + 1 )
        end
    do while index( line, '	' ) ~= 0
        line = substr( line, 1, index( line, '	' ) - 1 ) substr( line, index( line, '	' ) + 1 )
        end
    if words( line ) > 0 then
        do i = 1 to words( line )
            word = subword( line, i )
            if index( word, ' ' ) ~= 0 then word = substr( word, 1, index( word, ' ' ) - 1 )
            output = 0
            array = 0
            select
                when status = 0 then
                    select
                        when word = 'struct' then status = 1
                        when word = '#define' then status = 5
                        when word = 'typedef' then status = 6
                        otherwise nop
                        end
                when status = 1 then do
                    struct = word
                    status = 2
                    output = 1
                    end
                when status = 2 then if word = '{' then status = 3
                                                   else status = 0
                when status = 3 then
                    select
                        when word = '}' then if substruct = 0 then status = 0
                                                              else status = 8
                        when word = 'struct' then status = 7
                        when word = 'union' then status = 7
                        when word = '1' then nop
                        otherwise status = 4
                        end
                when status = 4 then
                    if word = '*' then nop
                    else do
                         if index( word, '*' ) = 1 then word = substr( word, 2 )
                         if index( word, '[' ) ~= 0 then do
                            word = substr( word, 1, index( word, '[' ) - 1 )
                            array = 1
                            end
                         select
                            when substruct = 0 then do
                                word = struct || '.' || word
                                output = 1
                                end
                            otherwise attrs = attrs word
                            end
                         status = 3
                         end
                when status = 5 then do
                    if index( word, '(' ) ~= 0 then word = substr( word, 1, index( word, '(' ) )
                    output = 1
                    status = 0
                    end
                when status = 6 then do
                    if word = 'struct' then status = 9
                                       else do
                                           output = 1
                                           status = 0
                                       end
                    end
                when status = 7 then if word ~= '{' then status = 4
                                                    else do
                                                        substruct = substruct + 1
                                                        select
                                                            when substruct = 1 then attrs = ''
                                                            when substruct = 2 then attrs = attrs '|'
                                                            otherwise nop
                                                            end
                                                        status = 3
                                                        end
                when status = 8 then do
                    select
                        when substruct = 1 then do
                            if index( word, '[' ) ~= 0 then do
                                attr = substr( word, 1, index( word, '[' ) - 1 )
                                array = 1
                                end
                            word = struct || '.' || word
                            subsub = 0
                            firstsub = 0
                            do i = 1 to words( attrs )
                                attr = subword( attrs, i )
                                if index( attr, ' ' ) ~= 0 then attr = substr( attr, 1, index( attr, ' ' ) - 1 )
                                subarray = 0
                                if index( attr, '[' ) ~= 0 then do
                                    attr = substr( attr, 1, index( attr, '[' ) - 1 )
                                    subarray = 1
                                    end
                                select
                                    when attr = '{' then do
                                        subsub = subsub + 1
                                        firstsub = 1
                                        end
                                    when firstsub = 1 then do
                                        firstsub = 0
                                        subsubstruct = attr
                                        address 'GOLDED.1' 'PHRASE ADD' word || '.' || attr
                                        if subarray then address 'GOLDED.1' 'PHRASE ADD' word || '.' || attr || '['
                                        end
                                    when attr = '}' then
                                        subsub = subsub - 1
                                    when subsub = 0 then do
                                        address 'GOLDED.1' 'PHRASE ADD' word || '.' || attr
                                        if subarray then address 'GOLDED.1' 'PHRASE ADD' word || '.' || attr || '['
                                        end
                                    /* when subsub = 1 then do
                                        address 'GOLDED.1' 'PHRASE ADD' word || '.' || subsubstruct || '.' || attr
                                        if subarray then address 'GOLDED.1' 'PHRASE ADD' word || '.' || subsubstruct || '.' || attr || '['
                                        end */
                                    otherwise nop
                                    end
                                end
                            output = 1
                            attrs = ''
                            end
                        when substruct = 2 then attrs = substr( attrs, 1, index( attrs, '|' ) - 2 ) '{' word substr( attrs, index( attrs, '|' ) + 2 ) '}'
                        otherwise nop
                        end
                    status = 3
                    substruct = substruct - 1
                    end
                when status = 9 then
                    select
                        when word = '{' then parth = parth + 1
                        when word = '}' then do
                            parth = parth - 1
                            if parth = 0 then status = 10
                            end
                        otherwise nop
                        end
                when status = 10 then
                    if word = '*' then nop
                    else do
                         if index( word, '*' ) = 1 then word = substr( word, 2 )
                         status = 0
                         output = 1
                         end
                otherwise nop
                end
            if output then address 'GOLDED.1' 'PHRASE ADD' word
            if output & array then address 'GOLDED.1' 'PHRASE ADD' word || '['
            end
    end
call close( file )
return 0

/* This procedure processes assembler include files (.i) */
i: procedure
if open( file, arg(1), read ) = 0 then do
                                       say 'File' arg(1) 'not found.'
                                       return 0
                                       end
do until eof( file )
    line = readln( file )
    do while index( line, ',' ) ~= 0
        line = substr( line, 1, index( line, ',' ) - 1 ) ' 2 ' substr( line, index( line, ',' ) + 1 )
        end
    do while index( line, '	' ) ~= 0
        line = substr( line, 1, index( line, '	' ) - 1 ) substr( line, index( line, '	' ) + 1 )
        end
    fini = 0
    nth = 1
    status = 0
    do until fini
        if nth > words( line ) then fini = 1
        else do
            word = subword( line, nth )
            if index( word, ' ' ) ~= 0 then word = substr( word, 1, index( word, ' ' ) - 1 )
            nth = nth + 1
            output = 0
            select
                when index( word, ';' ) = 1 then fini = 1
                when index( word, '*' ) = 1 then fini = 1
                when nth = 2 then
                    select
                        when index( line, ' ' ) ~= 1 then do
                            if index( word, '=' ) = 0 then do
                                const = word
                                status = 0
                                end
                            else do
                                word = substr( word, 1, index( word, '=' ) - 1 )
                                output = 1
                                status = 0
                                end
                            end
                        when upper( word ) = 'STRUCTURE' then status = 1
                        when upper( word ) = 'STRUCT' then status = 1
                        when upper( word ) = 'APTR' then status = 1
                        when upper( word ) = 'BPTR' then status = 1
                        when upper( word ) = 'CPTR' then status = 1
                        when upper( word ) = 'FPTR' then status = 1
                        when upper( word ) = 'RPTR' then status = 1
                        when upper( word ) = 'LONG' then status = 1
                        when upper( word ) = 'ULONG' then status = 1
                        when upper( word ) = 'WORD' then status = 1
                        when upper( word ) = 'UWORD' then status = 1
                        when upper( word ) = 'BYTE' then status = 1
                        when upper( word ) = 'UBYTE' then status = 1
                        when upper( word ) = 'SHORT' then status = 1
                        when upper( word ) = 'USHORT' then status = 1
                        when upper( word ) = 'FLOAT' then status = 1
                        when upper( word ) = 'DOUBLE' then status = 1
                        when upper( word ) = 'BOOL' then status = 1
                        when upper( word ) = 'LABEL' then status = 1
                        when upper( word ) = 'ENUM' then status = 1
                        when upper( word ) = 'EITEM' then status = 1
                        when upper( word ) = 'LIBENT' then status = 1
                        when upper( word ) = 'LIBDEF' then status = 1
                        when upper( word ) = 'BITDEF' then status = 2
                        otherwise nop
                        end
                when nth = 3 then
                    select
                        when upper( word ) = 'EQU' then do
                            output = 1
                            word = const
                            const = ''
                            end
                        when upper( word ) = 'MACRO' then do
                            output = 1
                            word = const
                            const = ''
                            end
                        when word = '=' then do
                            output = 1
                            word = const
                            const = ''
                            end
                        when status = 1 then do
                            output = 1
                            status = 0
                            end
                        when status = 2 then do
                            prefix = word
                            status = 3
                            end
                        otherwise nop
                        end
                when nth = 4 then
                    if status = 3 & word = '2' then status = 4
                when nth = 5 then
                    select
                        when status = 4 then do
                            status = 0
                            address 'GOLDED.1' 'PHRASE ADD' prefix || 'B_' || word
                            word = prefix || 'F_' || word
                            output = 1
                            end
                        otherwise nop
                        end
                otherwise nop
                end
            if output then address 'GOLDED.1' 'PHRASE ADD' word
            end
        end
    end
call close( file )
return 0

