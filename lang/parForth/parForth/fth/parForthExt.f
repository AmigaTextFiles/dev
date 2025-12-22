ANEW parForthExt.f

\ ndh 1/19/23 added F2DUP (coordinate pairs), F-ROT, and 3DROP (rgb values)
\ ndh 1/21/23 added LS as synonym of LATESTSTRING
\	$LEFT, $RIGHT, and $MID now all return a c$
\ ndh 1/23/23 debug FREELIST
\ ndh 1/27/23 added FTUCK, F//, FMOD, F$STR, and FSTR
\ ndh 1/30/23 added TOGGLE as complement to ON and OFF
\ end parForth 0.2 changes from 0.1

\ misc. 3 *********************************************************************
CREATE -protected 0 ,	\ protected auto.term xt so that auto.term completes even with error
: (PROTECT)  ( xt -- ) DUP -protected ! CATCH CR IF ." Err in " ELSE ." OK " THEN
	-protected @ >NAME ID. ;
: PROTECT    ( <xxx> -- ) ' [COMPILE] LITERAL COMPILE (PROTECT) ; IMMEDIATE
: C+!        ( n addr -- ) TUCK C@ + SWAP C! ;
: -C@		 ( b-addr -- b ) C@ DUP $ 80   AND NEGATE OR ; 	\ sign extended C@
: -W@		 ( w-addr -- w ) W@ DUP $ 8000 AND NEGATE OR ; 	\ sign extended W@
: ?   	 	 ( ... n -- ) DEPTH 1- > ABORT" insufficient stack items" ;
: | 	 	 ( n1 n2 -- n3 ) OR ;
: UNDER      ( n1 n2 -- n1 n1 n2 ) OVER SWAP ;
: 2,	 	 ( d -- ) ALIGN HERE 2! [ 2 CELLS ] LITERAL ALLOT ;
: 2= 	 	 ( n1 n2 n3 n4 -- f ) ROT = -ROT = AND ;
: 2OVER1 	 ( d n -- d n d ) >R 2DUP R> -ROT ;
: 1OVER2 	 ( n d -- n d n ) 2 PICK ;
: -ROLL      ( xu-1 ... x0 xu u -- xu xu-1 ... x0 ) DUP 0> IF 1+ DUP 1- 0 DO DUP ROLL SWAP LOOP THEN DROP ;
: (<!)	  	 ( n var -- n2 var ) DUP @ -ROT TUCK ! ;			\ runtime of <! ( to store)
: <!		 ( n var -- ) COMPILE (<!) COMPILE 2>R ; IMMEDIATE	\ e.g., 2 BASE <! do stuff !> back to original base
: !>		 ( -- ) COMPILE 2R> COMPILE ! ; IMMEDIATE			\ store from
: BS 	 	 ( -- ) 8 EMIT ;
: 'IMMEDIATE ( xt -- f ) >NAME C@ FLAG_IMMEDIATE TUCK AND = ;
: ?EXECUTE   ( ... xt -- ... ) ?DUP IF EXECUTE THEN ;
: :: :NONAME ;
: 3DROP      ( n1 n2 n3 --- ) 2DROP DROP ;
: TOGGLE     ( addr -- ) DUP @ 0= SWAP ! ;

\ memory ( all ALLOCATEd is freed by pForth) ----------------------------------
 0 CONSTANT DICT											\ allot from dictionary
-1 CONSTANT HEAP											\ allocate from heap
: 0ALLOT	( size -- ) HERE OVER ERASE ALLOT ;
: 0ALLOCATE ( size -- addr ) DUP ALLOCATE ABORT" Memory err" DUP ROT ERASE ;
: MEMORY	( size mem -- addr ) IF 0ALLOCATE ELSE ALIGN HERE SWAP 0ALLOT THEN ;
: FREE		( addr -- ) FREE ABORT" Free err" ;

\ objects *********************************************************************
: OBJ'	   ( <xxx> -- pfa ) ' >BODY ;
: [OBJ']   ( <xxx> -- ) ' [COMPILE] LITERAL COMPILE >BODY ; IMMEDIATE
: 'SYNONYM ( <xxx> xt -- ) CREATE DUP , 'IMMEDIATE IF IMMEDIATE THEN DOES> @EXECUTE ;
: 'IS	   ( <xxx> xt -- ) OBJ' ! ;

: (ARRAY) ( #rows width mem -- arr ) >R TUCK * CELL+ R> MEMORY TUCK ! ;
: []	  ( idx arr -- elem ) TUCK @ * + CELL+ ;
: ARRAY   ( <xxx> #rows width -- ) 2 ? CREATE DICT (ARRAY) DROP DOES> ( idx self -- elem ) [] ;
\ this replaces pForth array which was an array of cell-width values
\ 3 CELL ARRAY My[] 75 0 My[] !	    						     ( conventional named array)
\ CREATE My 0 ,        3 CELL DICT (ARRAY) My ! 75 0 My @ [] !   ( dictionary unnamed array)
\ CREATE My 0 , : test 3 CELL HEAP (ARRAY) My ! 75 0 My @ [] ! ; ( run-time unnamed heap array)
\ old pForth array redefinition would be : pForthArray CELL ARRAY ;

\ text ------------------------------------------------------------------------
\ c$ is address of a counted string
255 CONSTANT MAXCNT 										\ max length of a counted string (less cnt byte)
MAXCNT 1+ CONSTANT MAXSTRING 								\ max size of a counted string variable

\ get the next string buffer from an array of string buffers; recycles after #STRING_MEMBERS calls
20 CONSTANT #STRING_MEMBERS
#STRING_MEMBERS MAXSTRING ARRAY String[]
CREATE -LatestString #STRING_MEMBERS 1- ,
: LATESTSTRING ( -- c-addr ) -LatestString @ String[] ;		\ get the current string buffer from the array
' LATESTSTRING 'SYNONYM LS
: UPTO         ( addr qty -- ) 1- 2DUP SWAP @ = IF NEGATE ELSE DROP 1 THEN SWAP +! ;	\ cyclic 1 addr +! upto qty
: STRING       ( -- c-addr ) -LatestString #STRING_MEMBERS UPTO LATESTSTRING ;
	
: (TEXT)   ( c -- ) WORD COUNT PAD SWAP CMOVE ;
: TEXT     ( c -- ) PAD MAXSTRING BL FILL (TEXT) ;
: (>UPPER) ( c -- C ) DUP 96 > OVER 123 < AND IF 32 - THEN ;
: >UPPER   ( c-addr cnt -- ) \ in-place conversion to upper case
	?DUP IF OVER + SWAP DO I C@ (>UPPER) I C! LOOP ELSE DROP THEN ;
: 2COUNT   ( c$1 c$2 -- c-addr1 cnt1 c-addr2 cnt2 ) >R COUNT R> COUNT ;
: CLIP     ( cnt1 -- cnt2 ) MAXCNT MIN 0 MAX ;
: +PLACE   ( c-addr cnt dest$ -- ) >R CLIP MAXCNT R@ C@ - MIN R> 2DUP 2>R COUNT + SWAP CMOVE 2R> C+! ;
: >STRING  ( c-addr cnt -- c$ ) CLIP STRING PLACE LS ;
: $,       ( c$ -- ) COUNT ", ;
: $.	   ( c$ -- ) COUNT TYPE ;
: $!       ( c$ dest -- )   SWAP COUNT ROT  PLACE ;
: $+!	   ( from$ to$ -- ) SWAP COUNT ROT +PLACE ;
: LEFT     ( c-addr1 cnt len -- c-addr2 len ) NIP ;
: RIGHT    ( c-addr1 cnt len -- c-addr2 len ) TUCK - ROT + SWAP ;
: MID      ( c-addr1 cnt start len -- c-addr2 len ) ROT DROP -ROT + SWAP ; 
: $LEFT	   ( src$ len -- c-addr len ) SWAP COUNT ROT      LEFT  >STRING ;
: $RIGHT   ( src$ len -- c-addr len ) SWAP COUNT ROT      RIGHT >STRING ;
: $MID     ( src$ start len -- c-addr len ) 2>R COUNT 2R> MID   >STRING ;
: $LEN     ( c$ -- cnt ) C@ ;
: (STR)    ( d -- c-addr cnt ) 2DUP DABS <# #S ROT SIGN #> ROT DROP ;
: STR      ( n -- c-addr cnt ) S>D (STR) ;
: $STR     ( n -- c$ ) STR >STRING ;

CREATE -$ 1 C, CHAR - C,
CREATE .$ 1 C, CHAR . C,
CREATE E$ 1 C, CHAR E C,
: $CLR  ( c$ -- ) 0 SWAP C! ;
: F$STR ( -- c$ ) ( F: r -- )
	STRING DUP $CLR >R STRING PRECISION 10 MIN			\ c-addr2 u		R: c-addr1		clear c-addr1
	REPRESENT NOT ABORT" Invalid float"					\ n f1			R: c-addr1		significand to c-addr2
	IF -$ R@ $+! THEN									\ n				R: c-addr1		add minus if f1=-1
	LS C@ R@ COUNT + C!									\ n				R: c-addr1		store digit 1 in c-addr1
	R@ $LEN 1+ R@ C! .$ R@ $+!							\ n				R: c-addr1		update the count, add dot
	LS 1+ PRECISION 10 MIN 1- R@ +PLACE E$ R@ $+!		\ n				R: c-addr1		add remaining significand & E
	LS C@ [ CHAR 0 ] LITERAL <> IF 1- THEN				\ n				R: c-addr1		if significand<>0 then power-1
	$STR R@ $+! R> ;									\ c-addr1						add power, leave addr
: FSTR ( -- c-addr u ) ( F: r -- ) F$STR COUNT ;

CREATE CaseSensitive TRUE ,								\ TRUE|FALSE case-sensitive comparisons?
: 2>STRING ( c-addr1 cnt1 c-addr2 cnt2 -- c$1 c$2 ) >STRING -ROT >STRING SWAP ;
: 2>UPPER  ( c-addr1 cnt1 c-addr2 cnt2 -- c-addr3 cnt3 c-addr4 cnt4 ) 2>STRING OVER COUNT >UPPER DUP COUNT >UPPER 2COUNT ;
: ?2>UPPER ( c-addr1 cnt1 c-addr2 cnt2 -- c-addr3 cnt3 c-addr4 cnt4 ) CaseSensitive @ NOT IF 2>UPPER THEN ;
: (*LIKE*) ( c-addr1 cnt1 c-addr2 cnt2 -- f ) ?2>UPPER SEARCH -ROT 2DROP ;						\ f=true
: (LIKE*)  ( c-addr1 cnt1 c-addr2 cnt2 -- f ) ?2>UPPER 1OVER2 >R SEARCH SWAP R> = AND NIP ;		\ cnt1=u3
: (*LIKE)  ( c-addr1 cnt1 c-addr2 cnt2 -- f ) ?2>UPPER DUP    >R SEARCH SWAP R> = AND NIP ;		\ cnt2=u3
: *LIKE*   ( c$1 c$2 -- f ) 2COUNT (*LIKE*) ;													\ $2 within $1?
: LIKE*    ( c$1 c$2 -- f ) 2COUNT (LIKE*) ;													\ $2 at start of $1?
: *LIKE    ( c$1 c$2 -- f ) 2COUNT (*LIKE) ;													\ $2 at end of $1?
: $COMPARE ( c1$ c2$ -- n ) 2COUNT ?2>UPPER COMPARE ;
: $=       ( c$1 c$2 -- f ) $COMPARE 0= ;
: $<       ( c$1 c$2 -- f ) $COMPARE -1 = ;
: $>       ( c$1 c$2 -- f ) $COMPARE 1 = ;

\ convert string to number
: >SIGN ( c-addr u1 -- c-addr2 u2 sign )	\ extract sign of number$; >NUMBER doesn't do it
	OVER C@ [ ASCII - ] LITERAL =			\ c-addr1 u1 f		is the first character a minus sign?
	IF 1 /STRING -1							\ c-addr2 u2 sign		yes, leave -1 and skip to next character								
	ELSE OVER C@ [ ASCII + ] LITERAL =		\ c-addr1 u1 f			no, is the first character a plus sign?
		IF 1 /STRING THEN					\ c-addr2 u2				yes, skip to next character
		1									\ c-addr2 u2 sign			leave +1
	THEN ;									\ c-addr2 u2 sign
: >DOUBLE ( c-addr u -- d ) 0 0 2SWAP >SIGN >R >NUMBER 2DROP R> -1 = IF DNEGATE THEN ;
: VAL  ( c-addr u -- s ) >DOUBLE D>S ;
: $VAL ( c$ -- n ) COUNT VAL ;

\ floating point --------------------------------------------------------------
10 SET-PRECISION
-1e FACOS      FCONSTANT PI
2.718281828e0  FCONSTANT  E
: F? 		( n -- , ... -- ) FDEPTH > ABORT" insufficient Fstack items" ;
: F, 		( -- , r -- ) HERE F! [ 1 FLOATS ] LITERAL ALLOT ;
: F> 		( -- , r1 r2 -- ) FSWAP F- F0< ;
: F= 		( -- , r1 r2 -- ) F- F0= ;
: FVARIABLE ( <ccc> -- ) FALIGN CREATE 0. F, ; \ 0s when reincluding unlike Phil's
: FE**		( --, r -- e^r ) E FSWAP F** ;
: F+! 		( addr --, r -- ) DUP F@ F+ F! ;
: F2DUP     ( F: r1 r2 -- r1 r2 r1 r2 ) FOVER FOVER ;
: F-ROT     ( F: r1 r2 r3 -- r3 r1 r2 ) FROT FROT ;
: FTUCK     ( F: r1 r2 -- r2 r1 r2 ) FDUP F-ROT ;
: F//       ( F: r1 r2 -- r3 ) F/ FLOOR ;
: FMOD      ( F: r1 r2 -- r3 )		\ calculate the remainder r3 from dividing r1 by r2
	FTUCK F2DUP F//					\ r2 r1 r2 F//			find the whole number
	F-ROT F/						\ r2 F// F/				do the division
	FSWAP F- F* ;					\ r3					subtract the whole number and multiply by the divisor

FP-REQUIRE-E ON	\ close but not quite ANS Forth

\ vector compiler macros ------------------------------------------------------
\ vectors are private cell structures used when compiling instead of CELL+, 2 CELLS + etc.
\ see switches and structures for examples of their use
: (vector) ( n -- ) CREATE ,
	DOES>  ( addr self -- addr+ ) @ ?DUP IF [COMPILE] LITERAL COMPILE + THEN ;
: VECTOR{( ( n -- ) 1 ? [COMPILE] ( private{ 0 DO I CELLS (vector) IMMEDIATE
	LOOP }private ;
: }VECTOR  ( -- ) privatize ;

\ Relocation ******************************************************************
\ This is a Multi-Forth for the Amiga replacement system for A!, A, and A@; not so finicky.
\ Use R, and R! for addresses that need relocation when cloned/compiled.
\ Use @ as usual.  Not needed and does nothing if application not cloned/compiled.
\ RELOCATE relocates addresses.
\ Relocating OFF uses ! and , rather than R! and R,

400 CONSTANT MAX_RELOCATIONS						\ relocation table size
CREATE #Relocations 0 ,								\ next relocation number
CREATE Relocating TRUE ,							\ flag whether relocations are ON or OFF; starts on
MAX_RELOCATIONS 2 CELLS ARRAY Relocate[]			\ relocation table
2 VECTOR{( Relocation) +box +mail
: ?#REL   ( -- ) #Relocations @ MAX_RELOCATIONS < NOT ABORT" Relocations exceeded" ;
: NOTEREL ( mail box -- ) #Relocations @ Relocate[] TUCK +box A! +mail A! ;
: (R!)    ( mail box -- ) ?#REL 2DUP ! NOTEREL 1 #Relocations +! ;
: (R,)    ( mail -- ) ?#REL HERE ALIGNED OVER , NOTEREL 1 #Relocations +! ;
: -1|0	  ( n -- f ) DUP 0= SWAP -1 = OR ;
: R!      ( mail box -- ) Relocating @ NOT IF ! ELSE OVER -1|0 IF ! ELSE (R!) THEN THEN ;
: R,      ( mail -- )     Relocating @ NOT IF , ELSE DUP  -1|0 IF , ELSE (R,) THEN THEN ;

: (RELOCATE) ( idx -- ) Relocate[] DUP +mail A@ SWAP +box A@ ! ;
: RELOCATE   ( -- ) #Relocations @ 0 ?DO I (RELOCATE) LOOP ;
}VECTOR
: .Relocations ( -- )
	."      parForth v0.2" CR							\ add to map at startup 
	."      Max Relocations = " MAX_RELOCATIONS . CR
	."      Relocations Used= " #Relocations @ . CR RELOCATE ;
: auto.init auto.init .Relocations ;					\ RELOCATE relative addresses on startup

\ lists -----------------------------------------------------------------------
\ The list should not be used as a node.
\ Instead, it should point to the first node (head); ie., CREATE MyList 0 , NODE MyList LINK
\ NODES, HEAD, TAIL, PARENT, FREELIST assume this
: (NODE) ( mem -- node ) CELL SWAP MEMORY ;								\ allows creating node in heap|dictionary
: NODE   ( -- node ) ALIGN HERE 0 , ;									\ address of a new initialized node
: pfNODE ( -- node ) ALIGN HERE 0 , ;									\ Node will be redefined in AROS includes
: NODES  ( list -- n ) 0 SWAP BEGIN @ ?DUP WHILE SWAP 1+ SWAP REPEAT ; 	\ #nodes
: (HEAD) ( list -- head|0 ) @ ;											\ returns head|0 if empty list
: HEAD   ( list -- head ) DUP (HEAD) ?DUP IF NIP THEN ;					\ return head|list if empty
: TAIL   ( list -- tail|list ) BEGIN DUP @ ?DUP WHILE NIP REPEAT ;	 	\ return tail|list if empty
: LINK   ( node list ) DUP @ 1OVER2 R! R! ;   							\ add as head
: >LINK  ( node list -- ) LINK ;	 									\ add as head
: LINK>  ( node list -- ) TAIL LINK ;									\ add as tail|head if empty list

: PERUSE   ( n offset list -- node|0 ) \ search list for n at node+offset
	-ROT 2>R 0 SWAP					\ f list	r: offset n
	BEGIN @ DUP IF					\ f node	r: offset n, if next node not tail
	DUP 2R@ ROT + @ = IF			\ f node	r: offset n, and desired node
	NIP DUP THEN THEN				\ f node	r: offset n, then f=node
	2DUP 0= OR UNTIL				\ f node	r: offset n, otherwise go again
	NIP 2R> 2DROP ;					\ node|0
: (PARENT) ( node list -- prev|0 ) 2DUP @ = IF 2DROP 0 ELSE 0 SWAP PERUSE THEN ;	\ parent node|0 if at head ndh 11/21/2022
: PARENT   ( node list -- prev ) DUP >R (PARENT) ?DUP IF R> DROP ELSE R> THEN ;		\ allows parent to give list for unlinking/unhooking node1 ndh 11/22/2022
: UNLINK>  ( prev -- ) DUP @ ?DUP IF @ SWAP R! ELSE DROP THEN ;	   					\ unlink next node if not tail ndh 11/21/2022
: UNLINK   ( node list -- ) PARENT UNLINK> ;										\ unlink given node ndh 11/21/2022
: UNHOOK   ( node list -- ) PARENT OFF ;											\ unhook nodes from list ndh 11/21/2022
: HOOK>    ( node list -- ) TAIL R! ;												\ rehook unhooked nodes at tail

: FREENODE ( node list -- ) UNDER UNLINK FREE ;
: FREELIST ( list -- ) DUP @ ?DUP 0= IF DROP EXIT THEN DUP BEGIN @ ?DUP WHILE 2DUP SWAP FREENODE REPEAT FREE OFF ;

\ switches -------------------------------------------------------------------
\ switch syntax similar to SwiftForth
\ 2 vector{( switch sw) +List +ElseXT			\ first cell is list of switch cases; second is XT to use if case not found
3 VECTOR{( switch node) +node +case +CaseXT		\ 3 cells per case; list node, case, and XT to run for that case

: (SWITCH) ( case sw -- CaseXT|case ElseXT )	\ return CaseXT or case & ElseXT if undefined
	2DUP CELL SWAP PERUSE DUP IF				\ case sw node|0
	NIP NIP +CaseXT ELSE						\ &CaseXT
	DROP ( +ElseXT) CELL+ THEN					\ case &ElseXT
	@ ;											\ CaseXT|case ElseXT
: SWITCH ( case sw -- ... ) (SWITCH) ?EXECUTE ;

: ~SWITCH  ( case -- ) ." switch case " . ."  not found..." ABORT ;	\ default ElseXT
: ElseXT   ( xt sw -- ) CELL+ ( +ElseXT) ! ;

: [SWITCH  ( <xxx> -- sw ) CREATE NODE ['] ~SWITCH , DOES> ( self -- ) SWITCH ;
: [+SWITCH ( <xxx> -- sw ) OBJ' ;
: SWITCH]  ( sw -- ) DROP ;
: -SWITCH  ( sw case -- ) OVER 0 +case SWAP PERUSE ?DUP IF SWAP UNLINK THEN ;
: +SWITCH  ( sw case xt -- ) NODE ROT , SWAP , SWAP LINK ;

: RUNS	   ( sw case -- sw ) UNDER ' +SWITCH ;
: RUN:	   ( sw case -- sw sw case &xt ) UNDER :: ;
: ;RUN	   ( sw sw case &xt -- sw ) [COMPILE] ; +SWITCH ; IMMEDIATE

\ logical or of mutually exclusive switch cases (used with AROS API switches or to _Wait on signal bits)
: |SW|     ( cases1 node -- cases2 node ) DUP +case @ ROT OR SWAP ;
: |SWITCH| ( sw -- cases ) 0 SWAP BEGIN @ ?DUP WHILE |SW| REPEAT ;

\ print definition of a switch
\ [SWITCH test 1 RUN: ." case# 1" ;RUN 2 RUN: ." case# 2" ;RUN 3 RUN: ." case# 3" ;RUN SWITCH]
\ .SWITCH test
: .XT       ( xt -- ) DUP ." XT is " . BS ?DUP IF DUP >NAME ." , Name is " ID. ." , Definition is: " CR (SEE) THEN CR ; 
: .CASE     ( case -- ) DUP +case @ ." Case of " . BS +caseXT @ ." , " .XT ;
: .ELSEXT   ( sw -- ) ." Switch at " DUP . CELL+ ( +ElseXT) @ BS ." , ELSE" .XT ;
: (.SWITCH) ( sw -- ) DUP .ELSEXT BEGIN @ ?DUP WHILE DUP .CASE REPEAT ;
: .SWITCH   ( <switch> -- ) OBJ' (.SWITCH) ;
}VECTOR

\ structures ==================================================================
\ Structure syntax similar to Multi-Forth for Amiga; very simple :o)
\ Compatible with JForth include files (.j)
\ invoking a structure's name leaves its size on stack; invoking a member's name adds offset to the instance on the stack
: STRUCTURE 	( <xxx> -- HERE tab ) CREATE HERE 0 , 0 DOES> ( -- size ) @ ;
: STRUCTURE.END ( HERE size -- ) SWAP ! ;
: [STRUCTURE STRUCTURE ;	: STRUCTURE] STRUCTURE.END ;

2 VECTOR{( member) +tab +dt 	\ member datatype is parsable, dt meanings below
: +member  ( obj member -- obj+tab ) +tab @ + ;
: STRUCTS: ( <member> tab qty len|-l -- tab+len ) 3 ? CREATE 1OVER2 , DUP , ABS * +
	DOES>  ( obj self -- obj+tab ) +member ;

: UBYTES:  ( <member> tab qty -- tab+qty*len )                     1                          STRUCTS: ;	\ C! C,  C@
: BYTES:   ( <member> tab qty -- tab+qty*len )                    -1                          STRUCTS: ;	\ C! C, -C@
: USHORTS: ( <member> tab qty -- tab+qty*len ) SWAP EVEN-UP  SWAP [ CELL 2/         ] LITERAL STRUCTS: ;	\ W! W,  W@
: SHORTS:  ( <member> tab qty -- tab+qty*len ) SWAP EVEN-UP  SWAP [ CELL 2/ NEGATE  ] LITERAL STRUCTS: ;	\ W! W, -W@
: LONGS:   ( <member> tab qty -- tab+qty*len ) SWAP ALIGNED  SWAP CELL                        STRUCTS: ;	\  !  ,   @
: ADDRS:   ( <member> tab qty -- tab+qty*len ) SWAP ALIGNED  SWAP [ CELL NEGATE     ] LITERAL STRUCTS: ;	\ R!  R,  @
: DOUBLES: ( <member> tab qty -- tab+qty*len ) SWAP ALIGNED  SWAP [ 2 CELLS         ] LITERAL STRUCTS: ;	\ 2! 2,  2@
: FLOATS:  ( <member> tab qty -- tab+qty*len ) SWAP FALIGNED SWAP [ 1 FLOATS NEGATE ] LITERAL STRUCTS: ;	\ F! F,  F@
: CHARS: UBYTES: ; : ULONGS LONGS: ; : XTS: LONGS: ; : ADDRS: LONGS: ; : PTRS: LONGS: ;

: STRUCT:  ( <member> tab len -- tab+len )                                             1 SWAP STRUCTS: ;
: UBYTE: 1 UBYTES: ; : BYTE: 1 BYTES: ; : USHORT: 1 USHORTS: ; : SHORT: 1 SHORTS: ; : LONG: 1 LONGS: ;
: ADDR: 1 ADDRS: ; : DOUBLE: 1 DOUBLES: ; : FLOAT: 1 FLOATS: ;
: CHAR: UBYTE: ; : ULONG: LONG: ; : XT: LONG: ; : PTR: ADDR: ;

\ Member definers corresponding to JForth includes --------------------------
: STRUCT ( <structure> tab -- tab+len ) 32 PARSE-WORD EVALUATE STRUCT: ;
: :STRUCT STRUCTURE ;	: ;STRUCT STRUCTURE.END ;
: UBYTE UBYTE: ;		: BYTE BYTE: ;		: BYTES BYTES: ;
: USHORT USHORT: ;		: SHORT SHORT: ;
: ULONG ULONG: ;		: LONG LONG: ;
: APTR ADDR: ;

\ words needed to parse JForth include files ************************************************************
\ to-do, list node causes problems; node must be modified to AROS (mazze) and conflicts with my word node
' [IF]   'SYNONYM .IF
' [THEN] 'SYNONYM .THEN

\ JForth includes use unions
CREATE Union 0 ,								\ ON|OFF, nested unions are unsupported
CREATE Union_Start 0 ,							\ offset when union is started
CREATE Union_End 0 ,							\ offset when first part of union is ended

: UNION{  ( offset -- start ) Union @ ABORT" Nested unions unsupported" Union ON DUP Union_Start ! ;
: }UNION{ ( end1 -- start ) Union_End ! Union_Start @ ;	\ start redefining where we had left off
: }UNION  ( end2 -- max ) Union_End @ MAX Union OFF ;	\ offset is max of the alternate definition sets

\ state smart member switches for @, !, and , --------------------------------- RELOCATE before using
[SWITCH (S@) ( obj dt -- n )	\ fetch from an object member depending on member type
	1 RUNS C@ -1 RUNS -C@ 2 RUNS W@ -2 RUNS -W@	4 RUNS @ -4 RUNS @ 8 RUNS 2@ -8 RUNS F@ SWITCH]
[SWITCH (S!) ( n obj dt -- )	\ store to an object member depending on member type
	1 RUNS C! -1 RUNS C! 2 RUNS W! -2 RUNS W! 4 RUNS ! -4 RUNS R! 8 RUNS 2! -8 RUNS F! SWITCH]
[SWITCH (S,) ( n dt -- )		\ compile a value depending on member type
	1 RUNS C, -1 RUNS C, 2 RUNS W, -2 RUNS W, 4 RUNS , -4 RUNS R, 8 RUNS 2, -8 RUNS F, SWITCH]

\ executing: >member, +member, get dt
: SE  ( <member> obj -- obj+tab dt ) obj' TUCK +member SWAP +dt @ ;
: SE! ( <member> n obj -- ) SE (S!) ;
: SE@ ( <member> obj -- n ) SE (S@) ;
: SE, ( <member> n -- ) obj' +dt @ (S,) ;

\ compiling: >member, get tab, compile tab, compile +, get dt, (switch) dt to get xt, compile xt
: <SC ( <member> -- dt ) obj' DUP +tab @ ?DUP IF [COMPILE] LITERAL COMPILE + THEN +dt @ ;
: SC> ( dt sw -- ) (SWITCH) COMPILE, ;
: SC! ( <member> -- ) <SC [OBJ'] (S!) SC> ;
: SC@ ( <member> -- ) <SC [OBJ'] (S@) SC> ;
: SC, ( <member> -- ) obj' +dt @ [OBJ'] (S,) SC> ;

\ use: [structure test long: f1 long: f2 structure] HERE 1 , 2 ,
\ DUP S@ f1 . DUP S@ f2 .
\ : atest DUP S@ f1 . ; : btest DUP S@ f2 . ; atest btest DROP see atest see btest
: S! ( <member> n obj -- ) STATE @ IF SC! ELSE SE! THEN ; IMMEDIATE
: S@ ( <member> obj -- n ) STATE @ IF SC@ ELSE SE@ THEN ; IMMEDIATE
: S, ( <member> n -- )     STATE @ IF SC, ELSE SE, THEN ; IMMEDIATE
}VECTOR

\ AROS Shell Interface ********************************************************
\ escape sequences
: ESC       ( -- ) 27 emit 91 emit ;
: CLS       ( -- ) esc ." 0H" esc ." J" ;		\ clear shell
: FWhite    ( -- ) esc ." 32m" ;				\ foreground white
: FBlack    ( -- ) esc ." 34m" ;
: FBlue     ( -- ) esc ." 33m" ;
: FGrey     ( -- ) esc ." 30m" ;
: BBlue     ( -- ) esc ." 43m" ;				\ background blue
: BWhite    ( -- ) esc ." 42m" ;
: BBlack    ( -- ) esc ." 41m" ;
: BGrey     ( -- ) esc ." 40m" ;
: BOLD      ( -- ) esc ." 1m" ;
: NORMAL    ( -- ) esc ." 0m" ;
: UNDERLINE ( -- ) esc ." 4m" ;
: ITALIC    ( -- ) esc ." 3m" ;

\ 0$ words --------------------------------------------------------------------
\ 0$ is address of a zero-delimited string
CREATE MyPad MAXSTRING 0ALLOT	\ reserve pad for users
: 0$TEXT  ( c -- ) MyPad OFF WORD COUNT TUCK MyPad SWAP CMOVE MyPad + OFF ;
: 0$LEN	  ( 0$ -- cnt ) 0 BEGIN 2DUP + C@ WHILE 1+ REPEAT NIP ;
: 0$COUNT ( 0$ -- 0$ cnt ) DUP 0$LEN ;
: 0$>$ 	  ( 0$ -- ) \ in-place string conversion (truncates to 255)
    DUP 0$LEN MAXCNT MIN >R   DUP DUP 1+ R@ CMOVE>   R> SWAP C! ;
: $>0$  ( c$ -- ) DUP DUP C@ + SWAP COUNT OVER 1- SWAP CMOVE OFF ;
: 0$,   ( 0$ -- ) HERE SWAP 0$COUNT ", $>0$ ;
: $>0$, ( c$ -- 0$ ) HERE SWAP $, DUP $>0$ ;

\ C" behavior for 0$s
: (0")  ( -- 0$ ) R> DUP 0$COUNT + 1+ ALIGNED >R ;
: 0"    ( "xxx" -- 0$ ) STATE @ IF COMPILE (0") HERE ," $>0$ ELSE
	34 PARSE MyPad PLACE MyPad $>0$ MyPad THEN ; IMMEDIATE

\ CD --------------------------------------------------------------------------
\ parForth convention is that AROS function call names begin with an underscore
: _GetCurrentDirName ( buf len -- f )           94 EXEC_DOSBASE CALL2 ;
: _AddPart			 ( buf 0$ len -- f )       147 EXEC_DOSBASE CALL3 ;
: _Lock				 ( buf accessMode -- lock ) 14 EXEC_DOSBASE CALL2 ;
: _Close			 ( file -- f )               6 EXEC_DOSBASE CALL1 ;
: _CurrentDir		 ( lock -- oldLock )        21 EXEC_DOSBASE CALL1 ;
: _NameFromLock		 ( lock buf len -- f )      67 EXEC_DOSBASE CALL3 ;
: _SetCurrentDirName ( buf -- f )               93 EXEC_DOSBASE CALL1 ;

CREATE -CLI MAXSTRING ALLOT					\ holds 0$ of CLI current directory
											\ or current Shell Prompt (todo)
: Unlock ( lock -- ) _Close DROP ;
: CLI.	 ( -- ) FWhite BBlue -CLI 0$COUNT TYPE CR NORMAL ;
: ?CDErr ( f -- ) 0= IF CR ." CD err: " -CLI 0$COUNT TYPE ABORT THEN ;
: GetCD  ( buf len -- ) _GetCurrentDirName 0= ABORT" CD err" ;
: AddCD  ( buf 0$ len -- ) _AddPart ?CDErr ;
: LockCD ( buf -- lock ) -2 _Lock DUP ?CDErr ;	\ ACCESS_READ
: CDName ( 0$ buf len -- lock ) OVER >R 2DUP GetCD ROT SWAP AddCD R> LockCD ;
: ((CD)) ( lock -- ) _CurrentDir Unlock ;
: FullCD ( lock buf len -- ) _NameFromLock ?CDErr ;
: SetCD  ( buf -- ) _SetCurrentDirName ?CDErr ;
: PutCD  ( lock buf len -- ) OVER >R FullCD R> SetCD ;
: (CD) 	 ( 0$ -- ) -CLI MAXCNT CDName DUP ((CD)) -CLI MAXCNT PutCD ;
: CD	 ( "xxx" -- ) 0 0$TEXT MyPad (CD) CLI. ;

\ DOS -------------------------------------------------------------------------
: _Output  ( -- file ) 10 EXEC_DOSBASE CALL0 ;
: _Execute ( 0$ stdin stdout -- f ) 37 EXEC_DOSBASE CALL3 ;

CREATE -stdout 0 ,												\ CLI std output
: stdout  ( -- stdout ) -stdout DUP @ 0= IF _Output OVER ! THEN @ ;
: ((DOS)) ( 0$ -- f ) 0 stdout _Execute DROP ;
: Cmd?    ( 0$ a2 cnt2 -- f ) TUCK 2>R 2DUP >UPPER 2R> COMPARE 0= ;
: (DOS)   ( 0$ -- ) DUP S" CD " Cmd? IF 3 + (CD) CLI. ELSE ((DOS)) THEN ;
: DOS     ( <xxx>|CR -- ) 							\ dos loop exited by CR or "Forth"
	0 0$TEXT MyPad C@								\ f		command line residue?
	IF MyPad (DOS) 									\			yes, execute it
	ELSE											\			no,
		BEGIN ." DOS> " MyPad OFF					\ 				begin DOS loop
			MyPad MAXCNT ACCEPT MyPad + OFF 		\					accept 0$ input to MyPad
			MyPad S" FORTH" Cmd? NOT MyPad C@ AND	\ f					other than "FORTH" or "" entered?
		WHILE MyPad (DOS)							\						yes, execute a DOS command
		REPEAT										\				repeat
	THEN ;											\						no, end loop

: parForth ( -- ) 0" CD SYS:" (DOS) ;				\ change path to .../parForth/fth
: MyCode   ( -- ) 0" CD S:" (DOS) ;					\ set path to path to your parForth code
													\ rebuild parForth with your changes by 'pForth -i system.fth'
													
\ : auto.init auto.init MyCode ;					\ uncomment to CD to your code path on start-up
\ : auto.term PROTECT parForth auto.term ;			\ uncomment to CD to your parForth directory on BYE

\ load parForthExtensions
include? time&date.f parForthExtensions/Time&Date.f		\ ANS Forth Facility Extension word time&date
include? random.f    parForthExtensions/Random.f		\ 0 RANDOMIZE seeds generator with clock ticks since start of day 
include? ms.f        parForthExtensions/MS.f			\ ANS Forth Facility Extension word ms (milliseconds)
\ include? API.f		 parForthExtensions/API.f			\ AROS libraries, lists, and ports
\ include? GadTools.f	 parForthExtensions/GadTools.f		\ GadTools windows, menus, and gadgets
\ include? Turtle.f      parForthExtensions/Turtle.f		\ General graphics, Turtle Graphics

