{
   NAP 2.03, a preprocessor for ACE
   Copyright (C) 1997/98 by Daniel Seifert 

		contact me at:  dseifert@berlin.sireco.net

				Daniel Seifert
				Elsenborner Weg 25
				12621 Berlin
				GERMANY

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or   
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software 
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

{********************************************************************
** NAP_Mods : Sub modules needed by NAP.                           **
**                                                                 **
** For information about the copyright read the corresponding sec- **
** tion in NAP.doc, since these modules are part of NAP.           **
*********************************************************************
** Copy - copies a string into an allocated memoryblock            **
**                                                                 **
**   Syntax : memorypos = Copy(text)                               **
**                                                                 **
**     memorypos      : (address) a pointer to the memory block    **
**                      the string has been copied to              **
**     text           : (string) the string to be stored           **
**                                                                 **
** Comment : There'll be no checking whether the memory block has  **
**           been allocated successfully !!!                       **
*********************************************************************
** Legal - checks whether a specified byte of a string is within a **
**         comment ala ACE or within a string                      **
**                                                                 **
**   Syntax : Result = Legal(text,position)                        **
**                                                                 **
**     Result         : (shortint) Is 1 if neither within a string **
**                      nor a comment. Otherwise 0                 **
**     Text           : (string)                                   **
**     Position       : (shortint) byte to check                   **
*********************************************************************
** Get_name_of_object : Gets the next text within a string that is **
**                      embetted in spaces                         **
**                                                                 **
**   Syntax : object = Get_name_of_object (startpos,text)          **
**                                                                 **
**     object         : (string) name of object                    **
**     startpos       : (shortint) where to start looking for      **
**     text           : (string) string to be gone through         **
*********************************************************************
** Get_name_of_object_alt : Same as "Get_name_of_object" but looks **
**                          for a string that is not within a-Z,   **
**                          0-9, "_" and "."                       **
*********************************************************************
** ParseExpr : Parses a mathematical expression                    **
**                                                                 **
**   Syntax : result = ParseExpr(expression)                       **
**                                                                 **
**     result         : (single) result of the expression          **
**     expression     : (string) expression to be parsed           **
**                                                                 **
** Comment: Does only support +, -, /, *, \, (, and ). Parentheses **
**          must not be nested. = statements are implemented and   **
**          if both sides of the = are mathematical the same a 1   **
**          will be returned, otherwise a 0.                       **
*********************************************************************
** Lese : Reads a line.                                            **
**                                                                 **
** This function is made to replace the "LINE INPUT #" command. It **
** is faster and easier to handle because it is a function. It is  **
** fully compatible with ACE's file handling and gives always the  **
** same result as "LINE INPUT #".                                  **
** To made this routine faster there is a buffered reading imple-  **
** mented. BufferPtrBase points to an array with the dimension (9, **
** 1), whereas the 1st field is the filenumber. If the second one  **
** is 0, we are getting the address of the buffer. The length of   **
** this buffer can be obtained with 1.                             **
*********************************************************************
** StripWS : Deletes whitespaces at the end of a line.             **
**                                                                 **
**   Syntax : StripWS (stringptr)                                  **
**                                                                 **
**     stringptr  : (address) Pointer to the string.               **
**                                                                 **
*********************************************************************


*********************************************************************
** Special thanks go to  Herbert Breuer  who not just supported me **
** with great moral support during my work on  NAP   but also with **
** tips, hints and ideas, especially for the assembler routines.   **
********************************************************************}

library dos
declare function ADDRESS _Read(address filehandler,address buffer,longint bytes) library dos

' structure definition, must be the same as in NAP.b

#INCLUDE "ACE:Projekte/NAP/NAP_Structs.h"
#INCLUDE "ACE:Projekte/NAP/NAP_Defines.h"

GLOBAL ADDRESS asmvar_address1
GLOBAL ADDRESS asmvar_address2
GLOBAL ADDRESS asmvar_address3
GLOBAL ADDRESS asmvar_result
GLOBAL ADDRESS asmvar_start
GLOBAL ADDRESS asmvar_end
GLOBAL ADDRESS asmvar_pointer


SUB StringCopy (ADDRESS source, ADDRESS destination) EXTERNAL
 asmvar_address1 = source
 asmvar_address2 = destination

 ASSEM

   movem.l  a0-a1,-(a7)

   move.l   _asmvar_address1,a0
   move.l   _asmvar_address2,a1

copy_loop:

   move.b   (a0)+,(a1)+
   bne.s    copy_loop

   movem.l  (a7)+,a0-a1

 END ASSEM
END SUB

SUB ADDRESS Copy (STRING text) EXTERNAL
 ADDRESS dummy

 dummy = ALLOC(LEN(text)+1,7)
 StringCopy (@text,dummy)
 Copy = dummy
END SUB

SUB SHORTINT legal (ADDRESS textptr,SHORTINT position) EXTERNAL

 IF position < 2 THEN legal = 1 : EXIT SUB

 asmvar_address1 = textptr
 asmvar_start    = position

 ASSEM

       movem.l a0-a1/d0,-(a7)               ' save registers

       movea.l  _asmvar_address1,a0         ' address of string -> a0
       move.l   _asmvar_start,d0            ' position -> d0
       movea.l  a0,a1
       adda.l   d0,a1                       ' a1 points to position in mem + 1
       subq.l   #1,a1                       ' -1

       move.l  #1,_asmvar_result

leg_loop:

       cmpa.l  a0,a1
       beq.s   leg_exit                     ; until eol

       move.b  (a0)+,d0                     ; read next byte

       cmp.b   #123,d0                      ; found "{"
       beq.s   leg_c1
       cmp.b   #34,d0                       ; found "
       beq.s   leg_c3
       cmp.b   #39,d0                       ; found '
       beq.s   leg_set

       bra.s   leg_loop                     ; loop

leg_c1:

       cmpa.l  a0,a1
       beq.s   leg_set                      ; reached eol?

       cmp.b   #125,(a0)+                   ; found "}"
       bne.s   leg_c1                       ; no :(, loop

       bra.s   leg_loop                     ; continue

leg_c3:

       cmpa.l  a0,a1                        ; reached eol?
       beq.s   leg_set                      ; yes -> branch

       cmp.b   #34,(a0)+                    ; next byte a " ?
       bne.s   leg_c3                       ; no, loop

       bra.s   leg_loop                     ; continue

leg_set:

       move.l  #0,_asmvar_result

leg_exit:

       movem.l (a7)+,a0-a1/d0

 END ASSEM

 Legal=asmvar_result
END SUB

SUB STRING Get_name_of_object (SHORTINT startpos, ADDRESS textptr) EXTERNAL
 asmvar_start   = startpos
 asmvar_pointer = textptr

 ASSEM

     movem.l  d0-d3/a0,-(a7)           { save registers }

     move.l   _asmvar_pointer,a0
     adda.l   _asmvar_start,a0
     subq.l   #1,a0

     move.b   #32,d1
     move.b   #9,d2

gno_loop1:

     move.b   (a0)+,d0
     cmp.b    d1,d0                    { <> SPACE -> exit            }
     beq.s    gno_loop1
     cmp.b    d2,d0
     beq.s    gno_loop1


     subq.l   #1,a0
     move.l   a0,_asmvar_pointer
     moveq.l  #0,d3

gno_loop2:

     move.b   (a0)+,d0
     beq.s    gno_exit                ; = EOS -> exit

     cmp.b    d1,d0
     beq.s    gno_exit                ; = SPACE -> exit

     cmp.b    d2,d0
     beq.s    gno_exit                ; = TAB -> exit

     addq.l   #1,d3
     bra.s    gno_loop2               ; else repeat

gno_exit:

     move.l   d3,_asmvar_end
     movem.l  (a7)+,d0-d3/a0           ; restore registers

 END ASSEM
 Get_name_of_object=LEFT$(CSTR(asmvar_pointer),asmvar_end)
END SUB

SUB STRING Get_name_of_object_alt (SHORTINT startpos, ADDRESS textptr) EXTERNAL
 asmvar_start   = startpos
 asmvar_pointer = textptr

 ASSEM

     movem.l  d0-d1/a0,-(a7)                  ' save registers

     move.l   _asmvar_pointer,a0              ' set values
     adda.l   _asmvar_start,a0                ' add start difference
     subq.l   #1,a0

gnoa_loop1:

     move.b   (a0)+,d0
     beq.s    gnoa_ex_l1

     cmp.b    #46,d0                   ' = "." then exit
     beq.s    gnoa_ex_l1

     cmp.b    #48,d0                   ' < "0" then repeat
     blt.s    gnoa_loop1

     cmp.b    #57,d0                   ' <= "9" then exit
     ble.s    gnoa_ex_l1

     cmp.b    #65,d0                   ' < "A" then repeat
     blt.s    gnoa_loop1

     cmp.b    #90,d0                   ' <= "Z" then exit
     ble.s    gnoa_ex_l1

     cmp.b    #95,d0                   ' = "_" then exit
     beq.s    gnoa_ex_l1

     cmp.b    #97,d0                   ' < "a" then repeat
     blt.s    gnoa_loop1

     cmp.b    #122,d0                  ' > "z" then repeat
     bgt.s    gnoa_loop1

gnoa_ex_l1:

     subq.l   #1,a0
     move.l   a0,_asmvar_pointer
     moveq.l  #-1,d1

gnoa_loop2:

     addq.l   #1,d1
     move.b   (a0)+,d0
     beq.s    gnoa_exit                { = EOS -> exit               }

     cmp.b   #46,d0                   ' = "." then repeat
     beq.s    gnoa_loop2

     cmp.b   #48,d0                   ' < "0" then exit
     blt.s    gnoa_exit
     cmp.b   #57,d0                   ' <= "9" then repeat
     ble.s    gnoa_loop2

     cmp.b    #65,d0                   ' < "A" then exit
     blt.s    gnoa_exit
     cmp.b    #90,d0                   ' <= "Z" then repeat
     ble.s    gnoa_loop2

     cmp.b    #95,d0                   ' = "_" then repeat
     beq.s    gnoa_loop2

     cmp.b    #97,d0                   ' < "a" then exit
     blt.s    gnoa_exit
     cmp.b    #122,d0                  ' <= "z" then repeat
     ble.s    gnoa_loop2

gnoa_exit:

     move.l   d1,_asmvar_end
     movem.l  (a7)+,d0-d1/a0           ' restore registers

 END ASSEM

 Get_name_of_object_alt=LEFT$(CSTR(asmvar_pointer),asmvar_end)
END SUB

{* Could be optimized in later versions and even expanded!         *}
SUB SINGLE ParseExpr(STRING expression_org) EXTERNAL
 SHORTINT i,j,foundend,start,start2,ende,escape
 SINGLE   erg,erg2
 STRING   char SIZE 2
 STRING   lexpr,rexpr,operators SIZE 20
 STRING   expression SIZE 256

 expression=expression_org

 REPEAT
  ende=INSTR(expression,")")
  IF ende THEN
   start=0
   FOR i=ende TO 1 STEP -1
    IF MID$(expression,i,1)="(" THEN start=i:EXIT FOR
   NEXT
   IF start THEN
    expression=LEFT$(expression,start-1)+~
               STR$(ParseExpr(MID$(expression,start+1,ende-start-1)))+~
               MID$(expression,ende+1)
   ELSE
    PRINT "!!! SUB-MOD FAILURE (ParseExpr) : Closing bracket without opening one !!!"
    expression=LEFT$(expression,ende-1)+MID$(expression,ende+1)
   END IF
  END IF
 UNTIL ende=0
 operators="+-/*\"

 REPEAT
  escape=1
  FOR i=1 TO LEN(expression)
   char=MID$(expression,i,1)
   IF char="*" OR char="\" OR char="/" THEN
    start=1
    FOR j=i-1 TO 1 STEP -1
     IF INSTR(operators,MID$(expression,j,1)) THEN
      IF j>1 THEN
       IF INSTR(operators,MID$(expression,j-1,1))=0 THEN
        start=j+1
        escape=0
        EXIT FOR
       END IF
      END IF
     END IF
    NEXT
    lexpr=MID$(expression,start,i-start)
    IF lexpr="" THEN EXIT FOR

    ende=LEN(expression)
    FOR j=i+1 TO len(expression)
     IF INSTR(operators,MID$(expression,j,1)) THEN
      IF j>i+1 THEN ende=j-1:escape=0:EXIT FOR
     END IF
    NEXT
    rexpr=MID$(expression,i+1,ende-i)

    CASE
     char="*":erg=VAL(lexpr) * VAL(rexpr)
     char="\":erg=VAL(lexpr) \ VAL(rexpr)
     char="/":BLOCK
               IF val(rexpr)=0 THEN
                PRINT "!!! SUB-MOD FAILURE (ParseExpr) : DIVISION BY ZERO !!! OVERRULED"
                erg=0
               ELSE
                erg=VAL(lexpr)/VAL(rexpr)
               END IF
              END BLOCK
    END CASE

    expression=LEFT$(expression,start-1)+STR$(erg)+MID$(expression,ende+1)
    EXIT FOR
   END IF
  NEXT
 UNTIL escape

 REPEAT
  escape=1
  FOR i=2 TO LEN(expression)
   char=MID$(expression,i,1)
   IF char="+" OR char="-" THEN
    lexpr=LEFT$(expression,i-1)
    expression=MID$(expression,i+1)

    FOR j=1 TO LEN(expression)
     IF INSTR(operators,MID$(expression,j,1)) THEN
      IF j>1 THEN
       rexpr=LEFT$(expression,j-1)
       expression=MID$(expression,j)
       escape=0
       EXIT FOR
      END IF
     ELSE
      rexpr=LEFT$(expression,j)
      IF j=LEN(expression) THEN expression=""
     END IF
    NEXT

    CASE
     char="-":erg=VAL(lexpr)-VAL(rexpr)
     char="+":erg=VAL(lexpr)+VAL(rexpr)
    END CASE

    expression=STR$(erg)+expression
    escape=0
    EXIT FOR
   END IF
  NEXT
 UNTIL escape

 ParseExpr=val(expression)
END SUB

SUB StripWS (ADDRESS textptr) EXTERNAL
 asmvar_address1 = textptr                 ' This short routine
                                           ' erases all white-
 ASSEM                                     ' spaces (by now only
                                           ' spaces) at the end
   movem.l d0/a0-a1,-(a7)                     ' of a line
   move.l  _asmvar_address1,a0
   movea.l a0,a1

delwhite.eol:

   cmp.b   #0,(a0)+
   bne.s   delwhite.loop                   ' look for end of string

   subq.l  #1,a0                           ' a0 points to end of string (0)

delwhite.loop:

   cmpa.l  a0,a1
   bge.s   delwhite.end

   move.b  -(a0),d0

   cmp.b   #32,d0                          ' find last byte that does
   beq.s   delwhite.loop                   ' NOT contain a space.

   cmp.b   #9,d0
   beq.s   delwhite.loop

   addq.l  #1,a0                           ' a0 points to the space
   move.b  #0,(a0)                         ' space is converted to eol

delwhite.end:

   movem.l (a7)+,d0/a0-a1
 END ASSEM
END SUB

SUB STRING lese(SHORTINT filenumber,ADDRESS bufferptrbase) EXTERNAL
 DIM ADDRESS BufferPointer(9,1) ADDRESS BufferPtrBase

 STRING   text SIZE 256
 ADDRESS  DataPtr,position,BufferPtr,DataPos,gelesen,MaxBuffer
 SHORTINT escape

 BufferPtr=BufferPointer(filenumber,0)

 DataPtr=BufferPtr+4
 DataPos=peekl(BufferPtr)

 Repeat
  position=DataPtr+DataPos
  asmvar_start=position

  {* The following assembler routine searches from a specified po- **
  ** sition the memory for an identifer to mark the end of line.   **
  ** If a 0 (NUL) is found the routine assumes that the buffer has **
  ** been read to the end.                                         *}
  ASSEM

         movem.l   a0/d0,-(a7)                ; rescue register a0/d0
         move.l    _asmvar_start,a0           ; store in a0 the position

lese_loop:

         move.b    (a0)+,d0
         beq.s     lese_eof                   ; read next char until eof

         cmp.b     #10,d0                     ; <>10 ?
         bne.s     lese_loop                  ;       -> repeat

         move.b    #0,-(a0)                   ; otherwise move a 0 to it
         bra.s     lese_end                   ; and exit

lese_eof:

         suba.l    a0,a0

lese_end:

         move.l    a0,_asmvar_start        ; store result
         movem.l   (a7)+,a0/d0             ; restore register

  END ASSEM

  IF asmvar_start=0 THEN
   text=text+CSTR(position)
   MaxBuffer=BufferPointer(filenumber,1)-5
   gelesen=_Read(HANDLE(filenumber),DataPtr,maxbuffer)
   CASE
    gelesen=0        :POKE DataPtr+maxbuffer,1:escape=1
    gelesen<MaxBuffer:POKE DataPtr+gelesen,0
   END CASE
   DataPos=0
  ELSE
   ++escape
   STRING dummy ADDRESS position
   DataPos=DataPos+LEN(dummy)
   ++DataPos
   Pokel BufferPtr,DataPos
   text=text+dummy
  end if
 UNTIL escape
' StripWS (@text)
 lese=text
end sub

sub texts (shortint code) external
 {* This function prints a text to standard output.                *}

 IF code=1 THEN
  ?"¯   ¯   ¯            ¯       ¯¯¯¯"
  ?"
  ?"Usage :"
  ?
  ?" "ARG$(0)" [-options [-options [-...]]] <infile> <outfile>"
  ?
  ?"               Options with additional parameter"
  ?
  ?"              b<kilobytes>       : set buffersize"
  ?"              d<token>[=value]   : define token"
  ?"              p<path>            : add includedirectory"
  ?"              u<token>           : undefine token"
  ?
  ?"                    Options without parameter"
  ?
  ?" c : do not remove comments      | e : suppress error messages"
  ?" h : this help text              | i : ignore defines"
  ?" l : remove empty lines          | q : write #define as CONST"
  ?" s : remove unused structs       | t : trace including"
  ?" x : comment preprocessed source | z : show elapsed time"
  ?
  ?" Read the manual for detailed information."
  ?
 END IF

 IF code=2 THEN
  ?
  ?" Welcome to NAP. You have activated the TRACING option. Therefore"
  ?" you will get lots of information. If you want you can use a pipe"
  ?" to save them to a file (use DOS' redirection command  > )."
  ?" I tried to make the output as understandable as possible. If you"
  ?" have suggestions of how to format the output better or any ideas"
  ?" of more output (or less) or if you find a bug contact the author"
  ?" at dseifert@hell1og.be.schule.de                            TIA,"
  ?"                                                   Daniel Seifert"
  ?
  ?"  filenumber      filename"
  ?" ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯"
 END IF

 IF code=3 THEN
  ? "!!! Due to memory problems, you must do the following !!!"
  ? "!!! from your CLI:                                    !!!"
  ? "       COPY t:"TempFile" TO "OutFile
 END IF

 IF code=4 THEN ? "New ACE Preprocessor version ";__VERSION;", copyright © ";__COPYEAR;" Daniel Seifert"
 IF code=5 THEN ? "  Looking for unused structs ..."

 IF code>100 THEN
  ?"-- ERROR : ";
  CASE
   code=101:? "Writing to file failed!"
   code=102:? "Not enough memory to create new filebuffer!"
   code=103:? "#ELIF without #IF #ENDIF"
   code=104:? "Too many #ENDIF"
   code=105:? "#IF without #ENDIF"
   code=106:? "Buffersize greater than 640kB, set to default (100kB)"
   code=107:? "Could not open outputfile."
   code=108:? "It seems as if you do not have 100 byte of memory free !?"
   code=109:? "Could not open input file."
  END CASE
 END IF
END SUB
