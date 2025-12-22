;//

; L v0.17 - make a little library and use some ptrs -

; make it a library ***********************************

#mode LIBRARY 37 1 "ptrs.library" "ptrs.library by me 99"
#link library.lib                ; link in preassembled library code
#fdef bubblesort2                ; our two library functions ..
#fdef fill_longarray_with_words
#endfdef

; its was that simple *********************************

#equ Useful    10      ; define some constants
#equ NotUseful 0
#equ LongSize  4
#equ WordSize  2

    ; remember : youre only allowed to use d0-d5/a0-a3 ! //
    ; if itsnot a special case like, just before calling or doprocing //

proc bubblesort2     ; array of long -> d0, len -> d1
   var end           ; declare a variabel (local)
   codestart
   copy d0       end
   add  d1       end
   dec  end      LongSize
   repeat
      copy NotUseful d2
      copy d0 a0
      repeat
         if a0[] > a0[].LongSize      ; gt : greater then
            swap a0[]   a0[].LongSize ; aaah..mmm.. swap.. :)
            copy Useful d2
         endif
         inc a0 LongSize
      endrepeat a0 = end
   endrepeat d2 = NotUseful
endproc
 
   ; note : for speed reasons we use ax and dx registers here..  //
   ; but we could have done it in exactly the same way usin just //
   ; local vars, they can also work as ptrs : myvar[].           //
   ; remeber!  : you are only allowed to use d0-d5, a0-a3!       //
   ; but hey.. variables arent that slow anyway ..               //

   ; another example.. //

proc fill_longarray_with_words ; longarray -> d0, wordarray -> d1, nrofwords -> d2
   var larray  warray  len         ; local vars
   codestart
   copy d0 larray      ; copying some regs to som vars..
   copy d1 warray
   copy d2 len

   while len > 0                  ; while len > 0
      copy warray[W]  larray[L]
      inc warray      WordSize    ; add 2 to warray
      inc larray      LongSize    ; add 4 to larray
      dec len         ;sub 1 from len
   endwhile
endproc

end
  
