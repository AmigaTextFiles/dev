;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; 11/3/99 Revised to allow input from stdin
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***

                INCLUDE "#fileio.def"
                INCLUDE "#stdio.def"
                INCLUDE "libdefs.def"

                XLIB    fgets

;char *fgets(s1,n,fp)
;char s1 int n int fp
;on stack
;return address,fp,n,s1
;s1 = buffer, n=bytes to read, fp=filepointer
;

;fgets - read bytes from file..
;these routines should check for stdin/out/err

.fgets
        ld      hl,2
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)
        ld      a,d
        or      e
        jr      nz,fgets1
.fgets_abort
        ld      hl,0            ;reply null for EOF
        ret
.fgets1
; Check for stdin etc
        ld      hl,stdout
        and     a
        sbc     hl,de
        jr      z,fgets_abort
        ld      hl,stderr
        and     a
        sbc     hl,de
        jr      z,fgets_abort
        ld      hl,stdin
        and     a
        sbc     hl,de
        jp      z,fgets_cons


        push    de
        pop     ix
        ld      hl,4
        add     hl,sp
        ld      c,(hl)
        inc     hl
        ld      b,(hl)          ;number of bytes to read
        ld      a,c
        or      b
        jr      z,fgets_abort   ;none required
        inc     hl              ;step up to buffer
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a             ;our buffer

.fgets2
        call_oz(os_gb)
        jr      c,fgets_abort
        dec     bc
;This isn't strictly ansi, but it don't 'alf help the z88!
        cp      13
        jr      z,fgets_endrd
        cp      10
        jr      z,fgets_endrd
        ld      (hl),a
        inc     hl
        ld      a,b
        or      c      
        jp      nz,fgets2
.fgets_endrd
        ld      (hl),0  ;terminate string
.fgets_endrd1
        pop     bc
        pop     hl      ;get s1 back
        push    hl
        push    bc
        ret

;
; Read a string from the console
;
.fgets_cons
        ld      hl,4
        add     hl,sp
        ld      b,(hl)
        inc     hl
        ld      c,(hl)          ;number of bytes to read
        ld      a,c
        or      b
        jr      z,fgets_abort   ;none required
        inc     hl              ;step up to buffer
        ld      e,(hl)          ;buffer
        inc     hl
        ld      d,(hl)
        ld      c,0             ;cursor position
        ld      a,8             ;allow return of ctrl chars
        call_oz(gn_sip)
        cp      3
        jp      z,fgets_abort   ;<>+C
        jr      fgets_endrd1    ;return to calling func
