;  utoi -- convert unsigned decimal string to integer nbr
;               returns field size, else ERR on error
; 
;
;       Used by printf - Compiled C and hand optimized
;
;       13/10/98 djm

;utoi(char *decstr,int *nbr)



                XLIB    utoi
                LIB     l_gint
                LIB     l_pint
                LIB     l_lt
		LIB	l_ge
                LIB     l_mult

.utoi
;d=0;
        ld      hl,0    ;d=t=0
        push    hl
        push    hl
; *nbr =0
        ld      hl,6
        add     hl,sp
        call    l_gint
        ld      de,0
        ex      de,hl
        call    l_pint
.i_2
; while ( *decstr >= '0' && *decstr<= '9) 
        ld      hl,8
        add     hl,sp
        call    l_gint
        ld      a,(hl)
        cp      '0'
        jp      c,i_3
        cp      '9'+1
        jp      nc,i_3
;t=*nbr
        ld      hl,6
        add     hl,sp   ;*nbr
        call    l_gint
        call    l_gint
        pop     de      ;d
        pop     bc      ;t
        push    hl
        push    de
;t = (10*t) + (*decstr++ -'0') ;

        ld      hl,2
        add     hl,sp
        call    l_gint
        ld      de,10
        call    l_mult
        push    hl      ;(10*t)
        
;*decstr++
        ld      hl,10
        add     hl,sp
        push    hl
        call    l_gint
        inc     hl
        pop     de
        call    l_pint
        dec     hl
        ld      a,(hl)
        sub     '0'
        ld      e,a
        ld      d,0
        pop     hl      ;(10*t)
        add     hl,de
;Now store this hl in t
        pop     bc      ;d
        pop     de      ;t
        push    hl
        push    bc
; if ( t >= 0 && *nbr <0 )
        ld      hl,2
        add     hl,sp   ;t
        call    l_gint
        ex      de,hl
        ld      hl,0
        call    l_ge
        ld      a,h
        or      l
        jr      z,i_djm1
        ld      hl,6
        add     hl,sp
        call    l_gint
        call    l_gint
        ex      de,hl
        ld      hl,0
        call    l_lt
        ld      a,h
        or      l
        jr      z,i_6

.i_djm1
        ld      hl,-1
        pop     bc
        pop     bc
        ret

; ++d
.i_6
        pop     hl
        inc     hl
        push    hl

        ld      hl,6
        add     hl,sp   ;*nbr
        call    l_gint
        push    hl
        ld      hl,4
        add     hl,sp
        call    l_gint
        pop     de
        call    l_pint
        jp      i_2
.i_3
        pop     hl      ;d
        pop     bc      ;t
        ret


