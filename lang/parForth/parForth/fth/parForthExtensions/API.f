include? parForthExt.f parForthExt.f

ANEW API.f

\ AROS library calls **********************************************************
: _OpenLibrary  ( 0$name vers -- libbase|0 ) 92 EXEC_SYSBASE CALL2 ;
: _CloseLibrary ( lib -- ) 69 EXEC_SYSBASE CALL1NR ;

\ ( fct lib -- fct libbase ) a defined library (lib) will check whether fct is negative and close self
\ otherwise it will check whether it's open yet and if not, open itself, leaving the AROS library base
\ " intuition.library" 0 LIBRARY IntuitionBase		\ define library accepting any version
\ 0 16 IntuitionBase CALL1NR						\ open intuition if unopened and beep display
\ -1 IntuitionBase									\ close intuition
: SysBase ( -- libbase ) EXEC_SYSBASE ; 			\ handled by parForth so simply rename
: DosBase ( -- libbase ) EXEC_DOSBASE ;

CREATE Libraries 0 ,								\ parForth library list
4 VECTOR{( lib) +node +base +vers +name				\ parForth lib structure

: libFail?  ( lib f -- ) 0= IF ." Need " DUP +name 0$COUNT TYPE ."  v" +vers @ . ABORT THEN DROP ;
: libOpen   ( lib -- libbase ) DUP +name OVER +vers @ _OpenLibrary TUCK libFail? ;			\ call _OpenLibrary
: ?libOpen  ( lib -- libbase ) DUP +base @ 0= IF DUP libOpen OVER +base ! THEN +base @ ;	\ open if not already open

: libClose ( lib -- ) +base DUP @ ?DUP IF _CloseLibrary THEN OFF ;		\ call _CloseLibrary if lib is open
: libEnd   ( -- ) Libraries BEGIN @ ?DUP WHILE DUP libClose REPEAT ;	\ close all open libs in list

: ?libFct   ( fct lib -- fct libbase| ) OVER 0< IF libClose DROP ELSE ?libOpen THEN ;		\ close lib if fct <0, else open		
: (LIBRARY) ( c$ vers -- ) NODE Libraries LINK 0 , , $>0$, DROP ;							\ store lib structure in list
: LIBRARY   ( c$ vers -- ) 2 ? CREATE (LIBRARY)	DOES> ( fct self -- fct libbase ) ?libFct ;	\ create lib; checks fct to close

}VECTOR
: auto.term PROTECT libEnd auto.term ;				\ close all open libraries on BYE

\ define all libraries here
" intuition.library" 39 LIBRARY IntuitionBase		\ windows, etc.
" gadtools.library"  39 LIBRARY GadToolsBase		\ parForth gadgets
" graphics.library"  39 LIBRARY GfxBase				\ graphics functions

\ Tag lists *******************************************************************
\ tag lists are parameters for many AROS function calls
\ tags are 2 cells each (tag & value)
\ tag lists are terminated with a 0 , so #tags 2 CELLS * CELL+ is size of list
\ CREATE MyTags NM_xx1   4   NM_xx2   7   2 TAGS MyTags !	\ run-time taglist in HEAP
\ CREATE MyTags NM_xx1 , 4 , NM_xx2 , 7 , 0 ,				\ named taglist in DICT
\ TAGS[ NM_xx1 4 TAG: t#1 NM_xx2 7 TAG: t#2 ]TAGS MyTags	\ named taglist with members in DICT

2 CELLS CONSTANT TagTab										\ size of one tag (tag and value)
CREATE -tlFree 0 ,											\ tl to FREE

\ place tags (tag & value pairs) on stack and use TAGS to create a taglist in the HEAP
: tlSize     ( ... qty -- ... 0 size ) 0 SWAP TagTab * CELL+ ;	\ add terminating 0 to list too
: tlAllocate ( ... size mem -- ... tl.end qty ) UNDER MEMORY OVER + SWAP CELL / ;
: tlFill     ( ... tl.end qty -- tl ) 0 DO CELL- TUCK ! LOOP ;
: tlRFill    ( ... tl.end qty -- tl ) 0 DO CELL- TUCK R! LOOP ;	\ for gadgets with a list of 0$ choices
: TAGS       ( ... qty -- tl ) DUP 1+ ? tlSize HEAP tlAllocate tlFill DUP -tlFree ! ;

\ create a named taglist with named members in dictionary; tag values can easily be changed in code
\ TAGS[ NM_xx1 0 TAG: MyTag1 NM_xx2 0 TAG: MyTag2 ]TAGS MyTagList
\ 3 MyTagList MyTag2 ! changes value of NM_xx2 from 0 to 3
0 CONSTANT TAGS[
: TAG:    ( tab tag val -- tag val tab+8 ) 3 ? CREATE ROT DUP CELL+ , 4 , TagTab + DOES> ( tl self -- tl+tab+4 ) +member ;
: ]TAGS   ( ... size -- ) 1 ? 0 SWAP CELL+ CREATE DICT tlAllocate tlFill DROP ( DOES> self -- tl ) ;

\ tag utility words
: tlQty   ( tl -- qty ) 0 SWAP BEGIN DUP @ WHILE SWAP 1+ SWAP TagTab + REPEAT DROP ;
: tlFree  ( -- ) -tlFree @ ?DUP IF FREE -tlFree OFF THEN ;

\ Some exec structures *************************************************************

:STRUCT _List			\ Exec/Lists (word aligned)
	APTR 	lh_Head
	APTR 	lh_Tail
	APTR 	lh_TailPred
	UBYTE 	lh_Type
	BYTE	lh_Pad
;STRUCT

EXISTS? _Node NOT		\ already defined in MS.f?
[IF]
:STRUCT _Node			\ Exec/Nodes
	APTR	ln_Succ
	APTR 	ln_Pred
	APTR 	ln_Name		\ "special handling" in AROS nodes.h (amiga has ln_Name last)
	UBYTE 	ln_Type		\ mazze said it will be fixed in AROS v1 API todo
	BYTE 	ln_Pri
	SHORT	ln_ndh_pad	\ goofiness afoot
;STRUCT

:STRUCT Message			\ Exec/Ports
	STRUCT	_Node mn_Node
	APTR	mn_ReplyPort
	USHORT 	mn_Length
;STRUCT
[THEN]

:STRUCT MsgPort			\ abbreviated for sigbit access
	STRUCT	_Node mp_Node
	UBYTE 	mp_Flags
	UBYTE 	mp_SigBit
;STRUCT

\ AROS double linked lists ****************************************************
\ the GadTools ListView gadget uses an AROS list to hold entries in ln_Name
: _AddHead   ( alist anode -- ) 40 SysBase CALL2NR ;
: _AddTail   ( alist anode -- ) 41 SysBase CALL2NR ;
: _Remove    ( anode -- ) 42 SysBase CALL1NR ;
: _RemHead   ( alist -- anode ) 43 SysBase CALL1 ;

: ANext     ( anode -- next|0 ) @ DUP @ 0= IF DROP 0 THEN ;
: APrev     ( anode -- pred|0 ) ln_Pred @ DUP ln_Pred @ 0= IF DROP 0 THEN ;

: (ANODE)   ( mem -- anode ) _Node SWAP MEMORY ;
: ANODE     ( -- anode ) DICT (ANODE) ;
: ALInit    ( alist -- ) DUP lh_Tail OFF DUP lh_Tail OVER ! DUP lh_TailPred ! ;
: (ALIST)   ( mem -- alist ) _List SWAP MEMORY DUP ALInit ;
: ALIST     ( -- alist ) DICT (ALIST) ;
: ALINK     ( anode alist -- ) SWAP _AddHead ;
: >ALINK    ( anode alist -- ) ALINK ;
: ALINK>    ( anode alist -- ) SWAP _AddTail ;
: AUNLINK   ( anode alist -- ) DROP _Remove ;

\ change an AROS list (absolute addresses) to relative (relocatable) addresses
\ used in ENTRIES.END (Intuition.f)
: RelAddr   ( addr -- ) DUP @ SWAP R! ;							\ relocatable addr
: RelNode   ( anode -- ) DUP ln_Succ RelAddr ln_Pred RelAddr ;	\ relocatable anode
: (RelList) ( alist -- ) DUP lh_Head RelAddr DUP lh_Tail RelAddr lh_TailPred RelAddr ;
: RelList   ( alist -- ) DUP (RelList) BEGIN ANext ?DUP WHILE DUP RelNode REPEAT ;

: FreeAList ( alist -- ) BEGIN DUP ANext ?DUP WHILE _RemHead FREE REPEAT FREE ;

\ vectored execution of DOES DO: ;DO for user constancy *************************************
DEFER DOES    DEFER DO:    DEFER ;DO IMMEDIATE

\ the store (!) version of DO: ;DO DOES stores an xt at the given addr ----------------------
\ this is used with PORT (below), GADGETS (GadTools.f)  
: !DOES  ( addr -- ) 1 ? ' SWAP ! ;
: !DO:   ( addr -- addr &xt ) 1 ? :: ;
: !;DO   ( addr &xt -- ) 2 ? [COMPILE] ; SWAP ! ;
: !>DOES ( -- ) ['] !DOES IS DOES    ['] !DO: IS DO:    ['] !;DO IS ;DO ;

\ parForth ports **************************************************************
\ Messages are sent to ports which is how tasks communicate with each other and with AROS
\ Attach all ports to Ports list before you open them (pOpen) and start listening for messages
\ PORT WindowPort DOES HandleWindows								\ named pfPort and its handler
\ LISTEN waits for a port in the ports list to be signaled and then executes its handler
\ Use DOES or DO: ;DO to define and attach the handler to the port.
STRUCTURE pfPort													\ parForth port (p)
	ADDR:	p_Next													\ next pfPort
	LONG:	p_Sig													\ signal associated with AROS mp
	XT:		p_xt													\ port handler
	ADDR:	p_mp													\ AROS MessagePort
STRUCTURE.END

CREATE Ports 0 ,													\ parForth port list
CREATE -p 0 ,														\ pointer to current parForth port
: p  ( -- p  ) -p @ DUP 0= ABORT" No parForth port" ;				\ current parForth port
: mp ( -- mp ) p p_mp @ ; 											\ current AROS port

\ port actions --------------------------------------------------------------
EXISTS? _CreateMsgPort NOT		\ already defined in MS.f?
[IF]
: _CreateMsgPort ( -- mp )    111 SysBase CALL0 ;					\ 0=failure
: _DeleteMsgPort ( mp -- )    112 SysBase CALL1NR ;					\ mp=0 is OK
: _GetMsg		 ( mp -- msg ) 62 SysBase CALL1 ;					\ 0=no message
: CreateMsgPort  ( -- mp ) _CreateMsgPort DUP 0= ABORT" Can't create port" ;
[THEN]

: _Wait			 ( sigs -- sig ) 53 SysBase CALL1 ;					\ wait until one of the ORed signals is sent
: _ReplyMsg 	 ( msg -- )      63 SysBase CALL1NR ;

: ClosePort 	 ( -- )												\ delete impending messages and delete current port 
	mp ?DUP IF BEGIN DUP _GetMsg ?DUP WHILE _ReplyMsg REPEAT _DeleteMsgPort THEN ;
: pClose ( -- ) mp IF ClosePort p p_mp OFF p p_Sig OFF THEN ;		\ close current port if open
: pEnd	 ( -- ) Ports BEGIN @ ?DUP WHILE DUP -p ! pClose REPEAT Ports OFF ;
: auto.term PROTECT pEnd auto.term ;								\ close all ports on BYE

: sig     ( -- sig ) mp S@ mp_SigBit 1 SWAP LSHIFT ;				\ signal for mp
: !sig    ( -- ) sig p p_Sig ! ;									\ store signal in pfPort
: (pOpen) ( -- ) CreateMsgPort p p_mp ! !sig ;						\ open current pfPort, store mp and sig
: pOpen	  ( -- ) mp 0= IF (pOpen) THEN ;							\ open current pfPort if unopened

: (PORT)  ( mem -- p ) pfPort SWAP MEMORY DUP p_Next Ports LINK ;	\ allocate port and add to port list
: PORT 	  ( <xxx> -- &xt ) CREATE DICT (PORT) p_xt !>DOES			\ create named port with DOES or DO: ;DO following
	DOES> ( self -- ) -p ! ;										\ makes port current

\ port signal handling --------------------------------------------------------
: signalled?   ( sigs p -- f ) p_Sig @ AND ;				\ port's signal in sigs?
: HandlePort   ( p -- ) DUP -p ! p_xt @ ?EXECUTE ;			\ make current and run handler
: HandleSignal ( sig -- )									\ handle port affected by signal
	Ports BEGIN @ ?DUP WHILE								\ sig port		'til end of port list
	2DUP signalled? IF DUP HandlePort THEN					\ sig port		handle port if it was the one signalled
	REPEAT DROP ;											\	      		repeat

CREATE Listening 0 ,										\ flag to start or stop listening
: (LISTEN) ( sigs -- ) ?DUP IF _Wait HandleSignal THEN ; 	\ listen once for given signals
: LISTEN   ( -- )											\ listen to all ports until Listening OFF
	Listening ON BEGIN Ports |SWITCH| (LISTEN) Listening @ NOT UNTIL ;

