;
;  itou -- convert nbr to unsigned decimal string of width sz
;              right adjusted, blank filled ; returns str
; 
;             if sz > 0 terminate with null byte
;             if sz  =  0 find end of string
;             if sz < 0 use last byte for data
; 
;       Used by printf - compiled C optimized by hand

;itou (int nbr, char str[], int sz)

                XLIB    itou
                LIB     l_gint
                LIB     l_pint
                LIB     l_neg
                LIB     l_and
                LIB     l_asr
                LIB     l_asl
                LIB     l_div

.itou
        push    bc
; if (sz > 0)
        ld      hl,4
        add     hl,sp
        call    l_gint
        xor     a
        or      h
        jp      m,i_2
        or      l
        jr      z,i_2
; str[--sz]=NULL
        dec     hl
        ex      de,hl   ;de=--sz
        ld      hl,6
        add     hl,sp   ;str
        call    l_gint
        add     hl,de   ;str[--sz]
        ld      (hl),0
        ld      hl,4
        add     hl,sp   ;sz
        ex      de,hl
        call    l_pint
        jr      i_3
; else if (sz < 0)
;enter here with hl=sz
.i_2
        xor     a
        or      h
        jp      p,i_4
;sz=-sz
        call    l_neg
        ex      de,hl
        ld      hl,4
        add     hl,sp   ;sz
        ex      de,hl
        call    l_pint
        jr      i_5
.i_4
;else while (Str[sz] != NULL ) ++sz;
.i_6
        ld      hl,4
        add     hl,sp   ;sz
        push    hl
        call    l_gint
        ex      de,hl   ;keep safe
        ld      hl,8
        add     hl,sp   ;str
        call    l_gint
        add     hl,de
.i_djm1
        ld      a,(hl)
        inc     hl      ;increment reference to str
        inc     de
        and     a
        jr      nz,i_djm1
;We've gone one too far...so undo!
        dec     de
        ex      de,hl
        pop     de      ;sz
        call    l_pint


.i_7
.i_5
.i_3
.i_8
; while (sz)
        ld      hl,4
        add     hl,sp
        call    l_gint
        ld      a,h
        or      l
        jp      z,i_9
;lowbit = nbr & 1
        ld      hl,8
        add     hl,sp
        ld      a,(hl)
        and     1
        add     a,'0'    ;from below (much below)
        ld      l,a
        ld      h,0
        pop     bc      ;lowbit
        push    hl
;nbr= ( nbr >> 1 ) & 32767
        ld      hl,8
        add     hl,sp
        push    hl      ;nbr
        call    l_gint
        ex      de,hl
        ld      hl,1
        call    l_asr
        ld      de,32767
        call    l_and
        pop     de      ;&nbr back again
        call    l_pint
;str[--sz] = ( ( nbr % 5 ) << 1 ) +lowbit +'0'
        ld      hl,4
        add     hl,sp   ;sz
        push    hl
        call    l_gint
        dec     hl
        pop     de
        call    l_pint
        ex      de,hl   ;de= --sz
        ld      hl,6
        add     hl,sp   ;str
        call    l_gint
        add     hl,de
        push    hl      ;str[--sz]
        ld      hl,10
        add     hl,sp   ;nbr
        call    l_gint
        ex      de,hl
        ld      hl,5
        call    l_div
        ld      hl,1
        call    l_asl
;get low bit..
        push    hl
        ld      hl,4
        add     hl,sp   ;lowbit (already done + '0')
        call    l_gint
        pop     de
        add     hl,de
        pop     de      ;str[--sz]
        ld      a,l
        ld      (de),a
;if ( (nbr/=5) == 0) break;
        ld      hl,8
        add     hl,sp
        push    hl
        call    l_gint
        ex      de,hl
        ld      hl,5
        call    l_div
        pop     de
        call    l_pint
        ld      a,h
        or      l
        jp      nz,i_8
;        jp      nz,i_10
;        jp      i_9
.i_10
;        jp      i_8
.i_9
.i_11
; while (sz) str[--sz] = ' ';
        ld      hl,4
        add     hl,sp
        push    hl
        call    l_gint
        pop     de
        ld      a,h
        or      l
        jp      z,i_12
        dec     hl      ;--sz
        call    l_pint  ;store sz
        ex      de,hl   ;keep de=--sz
        ld      hl,8
        add     hl,sp   ;str
        call    l_gint
        add     hl,de
        ld      (hl),' '
        jr      i_11

.i_12
        ld      hl,6
        add     hl,sp
        call    l_gint
        pop     bc
        ret

