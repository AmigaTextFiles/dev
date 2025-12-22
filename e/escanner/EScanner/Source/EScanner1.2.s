*    EScanner V1.2 r9 by Neil Carter
*	PUBLIC DOMAIN ONLY (!)
*
*    Modified for more conventional :-) program structure.  Now ignores commented out PROCs
*    and OBJECTs, and recognises assembly labels (crudely).  Note that /* */ comments are
*    detected by the presence of a "*" before anything useful is found.  This means that the
*    following will work as _I_ require it:
*
*         /*
*         **   PROC baaaaaaah() IS EMPTY         -> This line is ignored
*         */
*
*    However, if you use the following sort of thing (for your text editor's folding function,
*    for example):
*
*         /*FOLD*/PROC bleah()
*         ENDPROC/*ENDFOLD*/
*
*    ...You'll find the proc is not recognised.  Just reformat it differently:
*
*         /*FOLD*/                 -> Or "->FOLD"
*         PROC bleah()
*         ENDPROC
*         /*FEND*/
*
*    Works for me!  :-)
*
*	To do:
*
*    The output format could be changed, so:
*
*         PROC procedure(param1, param2) -> Nice proc!           "procedure(a,b)"
*         EXPORT PROC procedure()                                "procedure() *"
*         EXPORT PROC test(param) OF gubbin                      "test(a) OF gubbin *"
*         PROC nibbles(param1, param2, param3,
*                      param4) OF gubbin                         "nibbles(a,b,c,d..."
*         OBJECT object            /* Some comments */           "object"
*         EXPORT OBJECT object                                   "object *"
*         EXPORT OBJECT object OF gubbin                         "object OF gubbin *"
*         label:    /* A comment */                              "label:"
*
*    Inputs:   A0 = Pointer to pointer to text
*              D0 = Line length
*              D1 = Line number
*
*    Outputs:  A0 = Pointer to new text
*              D0 = Length of new text or NIL

init:
     MOVEM.L   D2-D7/A1-A6,-(SP)
     MOVE.L    (A0),A1             ;A1:=start of text and text pointer
     MOVE.L    A1,A2
     MOVE.L    D0,D7               ;Keep a copy of the original length
     ADD.L     D0,A2               ;A2:=end of text

*****     Scanner routine
*
*    LABEL SCANNER
scanforlabel:
     BSR       isalpha
     TST.W     D0
     BEQ.S     mainscan
colonscan:
     CMPI.B    #":",(A1)+
     BEQ.S     itsalabel           ;It's a label!
     CMP.L     A2,A1
     BNE.S     colonscan           ;Not a label

*    Restore pointers for the main scanner
     MOVE.L    (A0),A1             ;Go back to the start
     MOVE.L    A1,A2
     MOVE.L    D7,D0               ;Get the original size
     CMPI.L    #$F,D0              ;Only the first 16 characters for this part
     BLE.S     .lessthan16chars
     MOVEQ     #$F,D0
.lessthan16chars:
     ADD.L     D0,A2

*    MAIN SCANNER ROUTINE
mainscan:
     MOVE.L    A1,D3               ;D3:=last value of scan start pointer

*    Invalid cases ("END", "->", "*")
isitend:                           ;"END"
     MOVE.L    D3,A1               ;Restore pointer
     LEA       endstring(PC),A3
     BSR.S     cmpstring
     TST.W     D0
     BNE.S     quitnotfound
isitcomment1:                      ;"->"
     MOVE.L    D3,A1               ;Restore pointer
     LEA       comment1string(PC),A3
     BSR.S     cmpstring
     TST.W     D0
     BNE.S     quitnotfound
isitcomment2:                      ;"*"
     MOVE.L    D3,A1               ;Restore pointer
     LEA       comment2string(PC),A3
     BSR.S     cmpstring
     TST.W     D0
     BNE.S     quitnotfound

*    Valid cases ("PROC ", "OBJECT ")
isitaproc:                         ;"PROC "
     MOVE.L    D3,A1               ;Restore pointer
     LEA       procstring(PC),A3
     BSR.S     cmpstring
     TST.W     D0
     BNE.S     itsaproc
isitanobject:                      ;"OBJECT "
     MOVE.L    D3,A1               ;Restore pointer
     LEA       objectstring(PC),A3
     BSR.S     cmpstring
     TST.W     D0
     BNE.S     itsanobject

unknown:
     CMP.L     A2,A1               ;Reached or gone past end of text?  (Is this a good idea?)
     BGE.S     quitnotfound
     ADDQ      #1,D3
     MOVE.L    D3,A1               ;Restore scanner position +1
     BRA.S     mainscan

quitnotfound:
     MOVEQ     #0,D0               ;Nothing found
     MOVEM.L   (SP)+,D2-D7/A1-A6
     RTS                           ;Quit

*    Found a valid string
itsaproc:                          ;I'll modify 'em later :-)
     MOVE.L    A1,A0
     MOVE.L    D7,D0               ;Restore original string length
	BRA.S	quitfound
itsanobject:
     MOVE.L    (A0),A0             ;Pointer to text, _not_ pointer to pointer to text!
     MOVE.L    D7,D0               ;Restore original string length
	BRA.S	quitfound
itsalabel:
     MOVE.L    (A0),A0             ;Pointer to text, _not_ pointer to pointer to text!
     MOVE.L    D7,D0               ;Restore original string length
	BRA.S	quitfound
quitfound:
     MOVEM.L   (SP)+,D2-D7/A1-A6
     RTS                           ;Return the whole line for now



*****     cmpstring(A1={text}, A3={string}) := (D0=TRUE)=strings are same,
*                                              (D0=FALSE)=strings are different
cmpstring:
     CMP.B     (A3)+,(A1)+         ;Scan string
     BNE.S     .failed
     CMPI.B    #0,(A3)             ;Reached end marker?
     BNE.S     cmpstring
     MOVEQ     #-1,D0              ;String matches
     RTS
.failed:
     CLR.L     D0                  ;String doesn't match
     RTS

*****	findchar(A1={text}, A2={end of string}) := (A1={first non-space character})=ok,
*										   (A1=NIL)=nothing found
findchar:
	CMP.L	A2,A1			;Have we passed the end of the string?
	BGE.S	.failed			;Yes!
	CMP.B	#" ",(A1)+
	BEQ.S	findchar
	RTS						;Return new pointer in A1
.failed:
	SUBA.L	A1,A1			;Nothing found
	RTS

*****     isalpha(A1={text}) := (D0=TRUE)=character was alphabetic
*                               (D0=FALSE)=character was nonalphabetic
isalpha:
     CMPI.B    #"a",(A1)
     BLT.S     .failed             ;Lower than "a"
     CMPI.B    #"z",(A1)
     BGT.S     .failed             ;Higher than "z"
     MOVEQ     #-1,D0              ;Was alphabetic
     RTS
.failed:
     CLR.L     D0                  ;Wasn't!
     RTS

procstring:
     DC.B      "PROC ",0
objectstring:
     DC.B      "OBJECT ",0
endstring:
     DC.B      "END",0
comment1string:
     DC.B      "->",0
comment2string:
     DC.B      "*",0               ;It's a bit crude, but....

version:
     DC.B      "$VER: EScanner V1.2 (27/1/96) by Neil Carter",0

*	Interesting coding style, no?  :-/
