\ Convert a 'C' include file to a JForth include file.
\ xxx.h to xxx.j
\ This program will prompt an operator if it has trouble
\ parsing a file.
\ The parsing is based on the execution of an experimental
\ "Data Driven Finite State Machine"
\ The "data" are single characters from the file, that are passed
\ to a different parser for each state.
\ The state transitions are intitiated by the parsers.
\ Nesting is available by use of a "state stack".
\
\ Author: Phil Burk, 1986 Delta Research
\ Placed in the Public Domain by the Author.
\
\ MOD: PLB 1/30/87 Add " INCLUDE? :STRUCT JU:C_STRUCT" to .J
\ MOD: PLB 7/26/88 Added USHORT and UBYTE for signed and unsigned.
\          Indent member definitions in .j
\ MOD: PLB 7/11/89 Close INFILE if OUTFILE open fails.
\ MOD: PLB 8/3/89 Add RAWEXPECTECHO ON and USAGE.

include? ob.string jo:load_ode

ANEW TASK-H2J
true if-range-check !  ( turn on object range checking )
true ob-if-check-bind !     ( turn on valid object checking )

\ Letter characterizing words.
: ISHEXDIGIT  ( char -- flag , true if valid hex digit )
    dup isdigit
    IF drop true
    ELSE toupper dup ascii G <
         swap ascii @ > AND
    THEN
;

: ISAZ_09  ( char -- flag , Is char a valid 'C' name char, a-z, 0-9, or '_')
    dup ascii _ =
    IF drop true
    ELSE dup isdigit
        IF drop true
        ELSE ?letter
        THEN
    THEN
;

: ASKLINE ( -- addr count , Ask user for line )
    pad 128 expect cr
    pad span @
;


\ -----------------------------------------------------------
\ Define a class that associates keywords with indices.
METHOD MATCH:

:CLASS OB.COMMANDS <SUPER OB.LIST

:M MATCH: ( string -- index true | false , look for matching string )
    false swap
    many: self 0
    DO  dup i at: self $=
        IF  nip i swap true swap leave
        THEN
    LOOP drop
;M

:M PRINT.ELEMENT: ( e# -- , print string )
    at: self $.
;M

;CLASS

\ Declare objects needed.
OB.STRING S-J
OB.STRING S-H
OB.STRING S-KEY
OB.STRING S-NAME
OB.STRING S-TYPE
OB.STRING S-EXPR
OB.STRING S-OPER
OB.STRING S-PREFIX
OB.STRING S-ARRAY

OB.ARRAY SM-PARSERS
OB.STACK SM-STACK
OB.LIST  LEGAL-OPS
OB.COMMANDS KEYWORDS
OB.LIST     KEYACTIONS
\ State machine control. ----------------------------------
\ Define allowable states.
0 dup  constant STATE_|BASE|  ( initial base state )
1+ dup constant STATE_|S|  ( defining structure name)
1+ dup constant STATE_|K|  ( accumulating keyword )
1+ dup constant STATE_|M|  ( structure member being defined )
1+ dup constant STATE_|ST|  ( structure member struct type being defined )
1+ dup constant STATE_|MN|  ( structure member name being defined )
1+ dup constant STATE_|DN|  ( #define NAME )
1+ dup constant STATE_|DV|  ( #define name VALUE)
1+ dup constant STATE_|V|  ( parsing a value )
1+ dup constant STATE_|C|  ( inside a comment )
1+ dup constant STATE_|/|  ( detected / )
1+ dup constant STATE_|*|  ( detected * inside a comment )
1+ dup constant STATE_|W|  ( eat white space )
1+ dup constant STATE_|0I|  ( check for hex or octal constants )
1+ dup constant STATE_|I|  ( parse a integer )
1+ dup constant STATE_|N|  ( parse a name )
1+ dup constant STATE_|OP|  ( parse a name )
1+     constant #STATES

\ Variables used in parser.
V: SM-CURSTATE     ( Current state of parser. )
V: BAD-LINE        ( Flag set when unparseable line found)
V: HARD-LINE       ( Flag set when difficult line found)
V: LOOSE-CHAR      ( Character that could not be parsed, gets passed on)
V: IN-STRUCT       ( TRUE if inside a structure definition )
V: MEMBER-IS-PTR   ( TRUE if member has the *, and is therefore pointer)
V: #IF-LEVEL       ( Nesting level for compiler conditionals )
V: TYPE-#BYTES     ( Number of bytes for a given structure member )
V: IF-ARRAY        ( TRUE if member is subscripted )
V: ()-LEVEL        ( Tracks level of parens in define values. )
V: ASKED-PREFIX    ( Has user had chance to give prefix )
V: SUPPRESS-LINE   ( Don't print line if blank )


\ File support ------------------------------
USER J-FILEID
USER H-FILEID

: FCLOSE.ID ( addr -- , close variable holding fileid %H )
    dup @ ?dup
    IF fclose   0 swap !
    ELSE drop
    THEN
;

: H2J.CLOSEFILES ( -- )
    j-fileid fclose.id
    h-fileid fclose.id
;

: FILECHECK ( fileid -- , Report error if bad. )
    0=
    IF h2j.closefiles
       ." Could not open file!" cr
       ." Usage:     H2J infile.h outfile.j" cr
       abort
    THEN
;

: H2J.READLINE ( -- #CHARS | -1 , read a line from H-FILE )
    H-fileid @ readline: s-h
    type: s-h cr  ( %%% )
;

: H2J.WRITELINE ( -- , write a line to J-FILE )
    many: s-j 0> suppress-line @ 0= OR
    IF  J-fileid @ writeline: s-j
        type: s-j cr ( %%% )
        clear: s-j
    THEN
    suppress-line off
;

: WRITE2J ( $string -- , write line to J file )
    count load: s-j
    h2j.writeline
;

\ -----------------------------------------------
: BAD.LINE  ( -- , set flags for unparseable line )
    true bad-line !
    " \ %? " count load: s-j 
    count: s-h append: s-j
;

: HARD.LINE ( -- , set flags for difficult line )
    true hard-line !
    " ( %?) " count append: s-j
;

\ Define parsers.
: BAD.PARSER  ( char -- , catch bad parsing )
     ." Bad Parser!" . cr
     break
;

: SM.PUSH  ( -- , push current state )
    sm-curstate @ push: sm-stack
;

: SM.RETURN   ( -- , pop last state )
    pop: sm-stack sm-curstate !
;

: SM.CALL ( new_state -- , nest to new state )
    sm.push
    sm-curstate !
;

: EAT.WHITE  ( -- , Eat white space of line )
    state_|W| sm.call
;

\ PARSERS for various states ------------------------------
\ General parser for Initial state
: PARSE_|BASE|  ( char -- )
    CASE
    EOL OF ENDOF
    ascii / OF state_|/| sm.call ENDOF
    dup isblack
        IF state_|K| sm.call  clear: s-key
           add: s-key
        ENDOF
           add: s-j 0
    ENDCASE
;

: PARSE_|K| ( char -- , parse and execute a keyword )
    dup isblack
    IF add: s-key
    ELSE loose-char !  sm.return
         tolower: s-key
         count: s-key  dup pad c!  pad 1+ swap cmove
         pad match: keywords  ( string compare to interpret keyword )
         IF exec: keyactions
         ELSE cr type: s-key space count: s-key . . cr
              ." PARSE_|K| - Unrecognized Keyword" cr
              bad.line
         THEN
         clear: s-key
    THEN
;

: PARSE_|C|   ( char -- , handle inside of comment )
\ If start of line and in comment put '('
    many: s-j 0=
    IF " ( " count append: s-j
    THEN
\
    CASE
    ascii *
        OF state_|*| sm.call ENDOF
\ Prevent () from messing up JForth comment.
    ascii (  
        OF ascii [ add: s-j  ENDOF
    ascii )
        OF ascii ] add: s-j  ENDOF
    EOL OF ascii ) add: s-j ENDOF    
        add: s-j 0
    ENDCASE
;

: PARSE_|/|  ( char -- , test for start of comment )
    sm.return
    CASE
    ascii *
        OF  state_|C| sm.call
            " ( " count append: s-j
        ENDOF
    EOL OF ascii / add: s-j
        ENDOF
        ascii / add: s-j add: s-j 0
    ENDCASE
;

: PARSE_|*|  ( char -- , test for end of comment )
    sm.return
    CASE
    ascii / 
       OF  ascii ) add: s-j
           sm.return
       ENDOF
    EOL OF " *)" count append: s-j 
       ENDOF
          loose-char !
          ascii * add: s-j 0
    ENDCASE
;

: PARSE_|W| ( char -- , eat white space )
    dup isblack
    IF loose-char !  sm.return
    ELSE drop
    THEN
;

: PARSE_|DN| ( char -- , accumulate name )
    dup isblack
    IF dup ascii ( =    ( 'C' macro definition?? )
       IF drop bad.line
       ELSE add: s-name
       THEN
    ELSE sm.return EOL = ( Just defining name )
         IF " : " count append: s-j
            count: s-name  append: s-j
            "  ;" count append: s-j
            clear: s-name
         ELSE
            state_|dv| sm.call
            state_|w| sm.call
         THEN
    THEN
;

: PARSE_|0I|  ( char -- , check for HEX integer )
    dup toupper ascii X =
    IF drop " $ " count append: s-expr
    ELSE  loose-char !   ascii 0 add: s-expr
    THEN
    sm.return state_|I| sm.call
;

: <PARSE_|EX|>  ( char flag -- , build an expression, reverse Polish )
    IF add: s-expr
    ELSE bl add: s-expr
         count: s-oper append: s-expr
         bl add: s-expr
         clear: s-oper
         loose-char ! sm.return
    THEN
;

: PARSE_|I| ( char -- , accumulate an integer )
    dup ishexdigit
    <parse_|EX|>
;

: PARSE_|N| ( char -- , accumulate an identifier )
    dup isaz_09
    <parse_|EX|>
;

: PARSE_|OP| ( char -- , accumulate an operator )
    dup indexof: legal-ops
    IF drop add: s-oper
    ELSE loose-char ! sm.return
    THEN
;

: OUT.DEFINE ( -- , Output the #define construct in JForth )
    s-expr copy: s-j
    "  constant " count append: s-j
    count: s-name  append: s-j
    clear: s-name  clear: s-expr
    clear: s-oper
;

: PEEKNEXT ( -- char , peek ahead at next character )
    ?now.at: s-h
    manyleft: s-h
    IF next: s-h
    ELSE EOL
    THEN
    swap goto: s-h
;

: PARSE_|DV| ( char -- , assemble a define constant )
    dup ascii ( =   
        IF drop 1 ()-level +! 
           ()-level @ 1 >     ( Check for nesting. )
           IF bad.line   0 ()-level !
           THEN exit
        THEN
    dup ascii ) =
        IF drop -1 ()-level +!   exit
        THEN
    dup ascii 0 =    ( Maybe HEX )
        IF drop state_|0I| sm.call exit THEN
    dup ascii - =    ( Negative numbers )
        IF add: s-expr  state_|I| sm.call exit THEN
    dup isdigit
        IF loose-char ! state_|I| sm.call exit THEN
    dup ?letter 
        IF loose-char ! state_|N| sm.call exit THEN
    dup ascii / =    ( Start of comment? )
        IF ascii * peeknext =
            IF 32 add: s-name drop 
	       out.define sm.return state_|/| sm.call
            ELSE add: s-type
            THEN exit
        THEN
    dup indexof: legal-ops    ( Operator ? )
        IF drop loose-char !
           state_|OP| sm.call
           exit
        THEN
    dup EOL = 
        IF  drop out.define 
           sm.return exit
        THEN
    dup isblack  ( something unexpected!)
        IF  ." Unexpected char = " emit
            bad.line sm.return exit
        THEN
\ White space
    drop state_|W| sm.call
;

: PARSE_|S| ( char -- , parse struct definition )
    dup isblack
    IF add: s-name
    ELSE drop
         " :STRUCT " count append: s-j
         count: s-name  append: s-j
         clear: s-name
         sm.return ( %? )
         true in-struct !
    THEN
;

: NAME.MEMBER ( -- , build name in output stream )
    count: s-prefix append: s-j  ( put prefixes on members )
    count: s-name append: s-j
    clear: s-name
    false member-is-ptr !
;

: REGULAR.MEMBER ( -- , Build NON subscripted member )
    member-is-ptr @
    IF " APTR " count append: s-j
       4 type-#bytes !  ( %? )
    ELSE  count: s-type append: s-j
    THEN
    name.member
;

: ARRAY.MEMBER ( -- , Define member that is an array of something )
    count: s-array append: s-j
    member-is-ptr @
    IF 4
    ELSE type-#bytes @
    THEN
    dup 1 >
    IF  32 add: s-j  
        ascii 0 +  ( convert to char )
        add: s-j
        "  * " count append: s-j
    ELSE drop
    THEN
    "  BYTES " count append: s-j
    name.member
;

: DEFINE.MEMBER ( -- , Define some member of a structure )
    "   " count append: s-j ( %M )
    if-array @
    IF array.member
    ELSE regular.member
    THEN false if-array !
;
        
: PARSE_|ST| ( char -- , accumulate structure member struct type )
    dup add: s-type
    isaz_09 NOT
    IF sm.return
    THEN
;

: PARSE_|MN| ( char -- , parse member name definition )
    dup isaz_09 
    IF add: s-name exit THEN
    dup ascii * =
        IF true member-is-ptr ! drop
           eat.white exit
        THEN
    dup ascii , =
        IF  drop define.member
            h2j.writeline
            eat.white exit
        THEN
    dup isblack NOT
        IF drop eat.white exit
        THEN
    dup ascii ; = over EOL = OR
        IF  drop define.member 
            sm.return exit
        THEN
    dup ascii [ =
        IF ( array declaration !! )
           drop ascii ] word: s-h
           count load: s-array hard.line
           true if-array !
           exit
        THEN
        drop bad.line
;
       
: SM.INIT  ( -- , Initialize State Machine )
    #states new: sm-parsers
    32 new: sm-stack
    state_|BASE| sm-curstate !
    ' bad.parser fill: sm-parsers  ( default parser )
    ' parse_|BASE| state_|BASE| to: sm-parsers
    ' parse_|K|    state_|K|  to: sm-parsers
    ' parse_|DN|   state_|DN| to: sm-parsers
    ' parse_|DV|   state_|DV| to: sm-parsers
    ' parse_|S|    state_|S|  to: sm-parsers
    ' parse_|BASE| state_|M|  to: sm-parsers
    ' parse_|ST|   state_|ST| to: sm-parsers
    ' parse_|MN|   state_|MN| to: sm-parsers
    ' parse_|C|    state_|C|  to: sm-parsers
    ' parse_|/|    state_|/|  to: sm-parsers
    ' parse_|*|    state_|*|  to: sm-parsers
    ' parse_|W|    state_|W|  to: sm-parsers
    ' parse_|0I|   state_|0I| to: sm-parsers
    ' parse_|I|    state_|I|  to: sm-parsers
    ' parse_|N|    state_|N|  to: sm-parsers
    ' parse_|OP|   state_|OP| to: sm-parsers
;

\ Define keyword interpretation.
: ACT.#DEFINE  ( -- action for #define )
    state_|DN| sm.call
    state_|W| sm.call
;

: ASK.PREFIX ( -- , Ask user for prefix to prepend to structure members. )
    asked-prefix @ NOT
    IF  true asked-prefix !
         cr ." Enter optional prefix for unique structure member names:" cr
         ." Examples might be 'nw_' or 'lr_' ." cr
         askline load: s-prefix
    THEN
;

: ACT.STRUCT  ( -- ,  action for struct )
    in-struct @
    IF  ask.prefix
        " STRUCT " count load: s-type
        state_|MN| sm.call
        state_|W|  sm.call
        state_|ST| sm.call  ( structure type )
        state_|W| sm.call
    ELSE state_|S| sm.call
        state_|W| sm.call
        true in-struct !
        false asked-prefix !
        h2j.writeline ( force blank line before )
    THEN
;

: <ACT.MEMBER>  ( #bytes string -- , parse simple structure members )
    count load: s-type
    type-#bytes !
    ask.prefix
    state_|MN| sm.call
    state_|W|  sm.call
;

\ Implement common member types.
: ACT.LONG ( -- )
    4 " LONG " <act.member>
;
: ACT.ULONG ( -- )
    4 " ULONG " <act.member>
;
: ACT.APTR ( -- )
    4 " APTR " <act.member>
;
: ACT.SHORT ( -- )
    2 " SHORT " <act.member>
;
: ACT.USHORT ( -- )
    2 " USHORT " <act.member>
;
: ACT.BYTE ( -- )
    1 " BYTE " <act.member>
;
: ACT.UBYTE ( -- )
    1 " UBYTE " <act.member>
;

: ACT.EXTERN ( -- , IGNORE )
;

: ACT.{ ( -- , don't print line unless has text )
    suppress-line on
;

: ACT.}; ( -- , terminate structure def if in )
    in-struct @ IF
        false in-struct !  ( set to be outside of structure definition )
        " ;STRUCT " count append: s-j
        h2j.writeline  ( force one blank line for FILE? )
    ELSE bad.line
    THEN
;

: <ACT.#IFDEF> ( S1 S2 -- , build a name )
    #if-level @
    IF  " .THEN   \ %? Forced .THEN to prevent nesting!!!"
        count load: s-j
        h2j.writeline
        -1 #if-level +!
    THEN 
    swap count load: s-j
    ' 0= smart.word: s-h  ( get all )
    count append: s-j
    count append: s-j
    1 #if-level +!
;

: ACT.#IFDEF ( -- , Build the equivalent to #IFDEF )
    " EXISTS? " "  .IF" <act.#ifdef>
;

: ACT.#IFNDEF ( -- , Build the equivalent to #IFDEF )
    " EXISTS? " "  NOT .IF" <act.#ifdef>
;

: ACT.#ELSE ( -- , Build equivalent to #ELSE )
    " .ELSE " count load: s-j
;

: ACT.#ENDIF ( -- , Build equivalent to #ENDIF )
    #if-level @
    IF  " .THEN "
    ELSE
        " \ .THEN   %? Eliminated because of nesting!"
    THEN
    -1 #if-level +!
    count load: s-j
    ' 0= smart.word: s-h drop
;

: ACT.#INCLUDE ( -- , Build equivalent to #INCLUDE )
    " include ji:" count load: s-j
\ Convert file name:   "name.h"  to  ji:name.j
    ' 0= smart.word: s-h
    count load: s-name
    ascii " strip: s-name
    32      strip: s-name
    ascii < strip: s-name
    ascii > strip: s-name
    many: s-name 1- dup
    at: s-name ascii h =
    IF ascii j swap to: s-name 
    ELSE drop
    THEN
    count: s-name append: s-j
;

: ACT.#IF ( -- , Build equivalent to #IF )
;

: ADD.KEYWORD ( string cfa -- )
    add: keyactions
    add: keywords
;

: KEYWORDS.INIT ( --)
    32 new: keywords
    32 new: keyactions
    " #define" 'c act.#define add.keyword
    " struct"  'c act.struct  add.keyword
    " {"       'c act.{       add.keyword
    " };"      'c act.};      add.keyword
    " #if"     'c act.#if     add.keyword
    " #ifdef"  'c act.#ifdef  add.keyword
    " #ifndef" 'c act.#ifndef add.keyword
    " #else"   'c act.#else   add.keyword
    " #endif"  'c act.#endif  add.keyword
    " #include"  'c act.#include  add.keyword
\ 10
    " long"    'c act.long    add.keyword
    " ulong"   'c act.ulong   add.keyword
    " float"   'c act.long    add.keyword
    " bstr"    'c act.aptr    add.keyword
    " aptr"    'c act.aptr    add.keyword
    " strptr"  'c act.aptr    add.keyword
    " bptr"    'c act.long    add.keyword
    " word"    'c act.short   add.keyword
    " uword"   'c act.ushort  add.keyword
    " short"   'c act.short   add.keyword
\ 20
    " ushort"  'c act.ushort  add.keyword
    " count"   'c act.short   add.keyword
    " ucount"  'c act.ushort  add.keyword
    " bool"    'c act.short   add.keyword
    " byte"    'c act.byte    add.keyword
    " ubyte"   'c act.ubyte   add.keyword
    " char"    'c act.byte    add.keyword
    " uchar"   'c act.ubyte   add.keyword
    " text"    'c act.byte    add.keyword
    " extern"  'C act.extern  add.keyword
;

: OPS.INIT  ( -- define legal operators )
    7 new: legal-ops
    ascii + add: legal-ops
    ascii - add: legal-ops
    ascii * add: legal-ops
    ascii / add: legal-ops
    ascii < add: legal-ops
    ascii > add: legal-ops
    ascii | add: legal-ops
;

: HANDLE.BAD.LINE ( -- , Let user enter new line. )
    cr type: s-h cr
    type: s-j cr
    cr ." Above line could not be parsed!!" cr
    ." Would you like to enter it?" Y/N
    IF ." Enter line the way you want it." cr
       askline load: s-j
    THEN
;

: HANDLE.HARD.LINE ( -- , Let user enter new line. )
    cr type: s-h cr
    type: s-j cr
    cr ." Above line was difficult to parse!!" cr
    ." Would you like to CHANGE it?" Y/N
    IF ." Enter line the way you want it." cr
       askline load: s-j
    THEN
;

VARIABLE IF-WATCH
: TRACK.PARSER ( char -- char )
     if-watch @
     IF .s dup ." c= " safe.emit space
        sm-curstate @ at: sm-parsers >name id.
        ?pause
     THEN
;

: H2J.PARSECHAR ( char -- , parse a single character )
     BEGIN
         track.parser
         0 loose-char !
         sm-curstate @ exec: sm-parsers
         loose-char @ ?dup 0=    ( keep going until character accepted )
     UNTIL
;

: H2J.PARSELINE ( -- , Parse a line of input. )
    false bad-line !
    false hard-line !
    reset: s-h
    BEGIN manyleft: s-h 0= 0=
        bad-line @ not AND
    WHILE 
        next: s-h
        h2j.parsechar
    REPEAT
    EOL h2j.parsechar  ( handle EOL )
    bad-line @
    IF handle.bad.line
    THEN
    hard-line @
    IF handle.hard.line
    THEN
    clear: s-type
    clear: s-name
;

: H2J.OPENFILES  ( <name.h>  <name.j> --IN-- , open files %H )
    fopen dup filecheck h-fileid !
    new fopen dup filecheck j-fileid !
;

\ -------------------------------------------
\ Open a RAW window for single keystroke interaction.
variable H2J-WINDOW
variable H2J-OLDWINDOW
: H2J.OPENWINDOW  ( -- , open a RAW window )
    h2j-window @ 0=
    IF  " RAW:0/20/630/120/H2J by Phil Burk in JForth"
        $fopen ?dup
        IF  consoleout @ h2j-oldwindow !
            dup h2j-window !
            console!
        ELSE ." Warning! - could not open RAW window!" cr
        THEN
    ELSE ." Window already open!" cr
    THEN
;

: H2J.CLOSEWINDOW  ( -- , close window if open )
    h2j-window @ ?dup
    IF fclose
        h2j-oldwindow @ console!
        h2j-window off
    THEN
;
\ --------------------------------------------

128 constant SIZE_PSTR
: H2J.TERM ( -- )
    h2j.closewindow
    free: s-j
    free: s-h
    free: s-key
    free: s-name
    free: s-type
    free: s-expr
    free: s-oper
    free: s-prefix
    free: s-array
    free: sm-parsers
    free: sm-stack
    free: keywords
    free: keyactions
    free: legal-ops
    h2j.closefiles
;

: H2J.ABORT  ( -- )
    ['] (abort) is abort
    h2j.term
;

: H2J.INIT ( -- , Setup the objects )
    os.sp!  ( setup object stack )
    ['] h2j.abort is abort
    128 new: s-j   ( allocate data space )
    128 new: s-h
    size_pstr new: s-key
    size_pstr new: s-name
    size_pstr new: s-type
    size_pstr new: s-expr
    size_pstr new: s-oper
    size_pstr new: s-prefix
    size_pstr new: s-array
    false in-struct !
    false bad-line !
    0 #if-level !
    sm.init
    keywords.init
    ops.init
    h2j.openwindow
;

: H2J ( <name.h>  <name.j> --IN-- , Convert .h file to .j file )
    cr ." ----------------=< H2J V2.0>=------------------------"
    cr ." Convert 'C' include file to JForth include file."
    cr ." H2J written by Phil Burk of Delta Research"
    cr ." This code may be freely redistributed for use with"
    cr ." JForth Professional 2.0 from Delta Research"
    cr ." -----------------------------------------------------" cr
    h2j.openfiles
    h2j.init
    " \ AMIGA JForth Include file." write2j
    " include? :struct ju:c_struct" write2j
    " decimal" write2j
    BEGIN
        ." ---------------------------" cr
        h2j.readline -1 >
    WHILE
        h2j.parseline
        h2j.writeline
        ?pause
    REPEAT
    h2j.term
;

\ For debugging
: H2J.TEST
    h2j.init
    " hello /* wow */ 1234" count load: s-h
;

if.forgotten h2j.term

exists? CLONE .IF
    RAWEXPECTECHO ON   ( make sure input is echoed in cloned program )
.THEN

