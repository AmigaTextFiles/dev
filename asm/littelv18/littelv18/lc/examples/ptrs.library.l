;

; LITTEL v0.12 Example of using PTRs ..rewritten to 0.13b, 0.16b//
; extended to shared library, just for fun  //
; rewritten 4 LITTEL v18

#mode LIBRARY 37 1 "ptrs.library" "ptrs.library by me 99"
#link library.o

#makefd ptrs_lib.fd _PtrsBase

#fdef bubblesort2 (array,len)(d0/d1)
#fdef fill_longarray_with_words (larray,warray,nrofwords)(d0/d1/d2)
#endfdef

#regpreserve OFF
#libraryenv OFF

PROC init
ENDPROC 1
PROC open
ENDPROC 1
PROC close
ENDPROC
PROC expunge
ENDPROC

#equ Useful 10
#equ NotUseful 0
#equ LongSize 4
#equ WordSize 2

    ; remember : youre only allowed to use D0-D3/A0-A3 ! //


PROC bubblesort2 ; Array Of Long -> D0, Len -> D1
   VAR end           ; declare a variabel (local)
   CODESTART          ; as we use variables we need this one
   COPY D0       end
   ADD  D1       end
   DEC  end      LongSize
   REPEAT
      COPY NotUseful D2
      COPY D0        A0
      REPEAT
         IF A0[] > A0[].LongSize
            SWAP A0[]   A0[].LongSize
            COPY Useful D2
         ENDIF
         INC A0 LongSize
      ENDREPEAT A0 = end
   ENDREPEAT D2 = NotUseful
ENDPROC
 
   ; NOTE : for speed reasons we use Ax and Dx Registers here..  //
   ; but we could have done it in exactly the same way usin just //
   ; local vars, they can also work as PTRs : myvar[].           //
   ; Remeber!  : You are only Allowed to Use D0-D3, A0-A3!       //
   ; but hey.. variables arent THAT slow anyway ..               //

   ; another example.. //

#regpreserve d2

PROC fill_longarray_with_words ; longarray -> D0, wordarray -> D1, nrofwords -> D2
   VAR larray          ; local vars
   VAR warray          ; always LONGs as u know, I hope.
   VAR len             ;
   CODESTART
   COPY D0 larray      ; copying some regs to som vars..
   COPY D1 warray      ;
   COPY D2 len         ;

   WHILE len > 0
      COPY warray[W]  larray[L]
      INC warray WordSize  ; add 2 to warray
      INC larray LongSize  ; add 4 to larray
      DEC len      ; decrease len by 1
   ENDWHILE 
ENDPROC

END
  
