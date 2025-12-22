;
; Small C z88 String functions
;
; Compare strings (at most n bytes): s1>s2: >0 s1==s2: 0 s1<s2: <0

                XLIB    strncmp

                LIB     l_sxt

;strncmp(s1,s2,n) char *s1, *s2
;Stack on entry runs..
;return address,n, s2, s1


.strncmp
        ld      hl,2   
        add     hl,sp
        ld      c,(hl)
        inc     hl
        ld      b,(hl)  ;bc=n
        ld      a,b
        or      c
        ret     z       ;bc=0 so outta here
        inc     hl
        ld      e,(hl)  
        inc     hl
        ld      d,(hl)  ;de=s2
        inc     hl
        ld      a,(hl)
        inc     hl
        ld      h,(hl)  
        ld      l,a     ;hl=s1
;David Earlam's modified end to strncmp here
        ex      de,hl   ;de=s1, hl=s2
.strncmp1
        ld      a,(de)
        cpi
        jp      nz,strncmp2
        inc     de
        jp      pe,strncmp1
        ld      h,b
        ld      l,c             ;hl=bc=0
        ret
.strncmp2
        sub     (hl)
.strncmp3
        ld      l,a
        rlca
        sbc     a,a
        ld      h,a
        ret

;       Archaic old strncmp code
;       Wouldn't it be nice if Z80 understood END!

IF ARCHAIC

.strncmp1
        ld      a,(de)
        cp      (hl)
        jp      nz,strncmp2
        inc     hl
        inc     de
        dec     bc
        ld      a,b
        or      c
        jp      nz,strncmp1
;If here have matched n chars, so return hl=0
        ld      h,b
        ld      l,h
        ret
;Okay, take the defn to assume if the value at *s1 and value and *s2
;This is horrible, and probably returns the incorrect result...but WTF?
;.strncmp2
        ex      de,hl
        ld      a,(de)  ;s1
        sub     (hl)
        ld      l,a
        ld      h,0
        ret     nc
        ld      h,255
        ret
ENDIF
