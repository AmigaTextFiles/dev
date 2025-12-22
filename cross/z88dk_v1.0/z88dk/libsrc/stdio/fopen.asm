;
; Small C z88 File functions
; Written by Dominic Morris <djm@jb.man.ac.uk>
; 22 August 1998 ** UNTESTED **
;
; *** THIS IS A Z88 SPECIFIC ROUTINE!!! ***

                INCLUDE "#fileio.def"
                INCLUDE "#stdio.def"

                XLIB    fopen

;*fopen(s1,s2)
;char s1,s2
;on stack
;return address,s1,s2
;s1=filename, s2=filemode
;s2 -   r = open for read
;       w  = open for write
;       a  = open to append
;       r+ = open file for read and write, if file exists write at start
;       w+ = overwrite file if exists
;       a+ = append to end of file

.fopen
;First of all, find filemode..
        ld      hl,2
        add     hl,sp
        ld      e,(hl) 
        inc     hl
        ld      d,(hl) 
        ld      a,(de)
        and     223
        ld      d,3             ;our open type marker
        cp      'A'             ;append
        jp      z,fopen_try
        dec     d
        cp      'W'
        jp      z,fopen_try
        dec     d
        cp      'R'
        jp      z,fopen_try
;Unspecified operator..quit!
.fopen_abort
        ld      hl,0            ;ahem..null file pointer!
        ret
;Try to open the file
;d=access mode..
;Create some room on the stack for the filename to be expanded into..
.fopen_try
        ld      hl,-10
        add     hl,sp
        ld      sp,hl
;So, d=mode, hl=where to expand filename to...
        ld      b,d     ;keep open specifier
        ex      de,hl   ;put this in final place
        ld      c,8     ;max chars to expand..
;Now, find the filename!
        ld      hl,4+10
        add     hl,sp
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a     ;hl should point to filename
        ld      a,b     ;open type
        ld      b,0     ;absolute page
        call_oz(gn_opf)
        ex      af,af'  ;keep our flags!
        ld      hl,10
        add     hl,sp
        ld      sp,hl   ;restore our stack (we did nothing to it!)
        ex      af,af'
        jp      c,fopen_abort
;ix holds our file handle...
        push    ix
        pop     hl
        ret
