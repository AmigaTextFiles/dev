; Small C startup module for Running Compiled C from BBC BASIC
; ZCC for z88 converted by Dominic Morris <djm@jb.man.ac.uk>
; Written August 1998
; Updated for small C+ continuously through September
; Changes by DG implemented 28/9/98
; GFX Stuff added 30/9/98
; 19/10/98 Atexit stuff added
; 27/11/98 Atexit stuff rejigged to allow 32 levels of atexit
;
; 29/2/99  Added the include for zcc_opt so we now if float package
;          required or not..
;
; 14/3/99  Renamed the printf vars to smc_pf*

                MODULE  z88_crt0

                INCLUDE "#bastoken.def"
                INCLUDE "#ctrlchar.def"
                INCLUDE "#error.def"
                INCLUDE "#stdio.def"

;
; Now include file which tells us if we need the float libs or not
;
; This file could be further extended for other things BTW


                INCLUDE "zcc_opt.def"

; The main function is external
        XREF    smc_main


;Standard startup for Z88 BBC BASIC programs

        XDEF    cleanup
        XDEF    l_dcal

;Graphic function XDEFS..

        XDEF    coords
        XDEF    base_graphics
        XDEF    gfx_bank

;Printf variables

        XDEF    smc_pf_string
        XDEF    smc_pf_count

;Exit variables

        XDEF    exitsp
        XDEF    exitcount
;        XDEF    prog_atexitrout

;For stdin, stdout, stder

        XDEF    smc_sgoioblk


;Hooks for the library functions

        LIB    l_gchar
        LIB    l_sxt
;        LIB    l_pchar        ;Not needed for Small C/Plus
        LIB     l_gint
        LIB     l_pint
        LIB    l_or
        LIB    l_xor
        LIB    l_and
        LIB    l_eq
        LIB    l_ne
        LIB    l_gt
        LIB    l_le
        LIB    l_ge
        LIB    l_lt
        LIB    l_uge
        LIB    l_ult
        LIB    l_ugt
        LIB    l_ule
        LIB    l_cmp
        LIB    l_ucmp
        LIB    l_asr
        LIB    l_asl
        LIB    l_sub
        LIB    l_neg
        LIB    l_com
        LIB    l_lneg
        LIB    l_bool
        LIB    l_cm_de
        LIB    l_cm_bc
        LIB    l_deneg
        LIB    l_bcneg
        LIB     l_case
        LIB     l_mult
        LIB     l_div
        LIB     l_div_u


;Long functions now

        LIB     int2long_s
        LIB     long2int_s
              LIB     l_glong
              LIB     l_long_add
              LIB     l_long_and
              LIB     l_long_asl
              LIB     l_long_asr
              LIB     l_long_bool
              LIB     l_long_cmp
              LIB     l_long_com
              LIB     l_long_eq
              LIB     l_long_ge
              LIB     l_long_gt
              LIB     l_long_le
              LIB     l_long_lneg
              LIB     l_long_lt
              LIB     l_long_ne
              LIB     l_long_neg
              LIB     l_long_or
              LIB     l_long_sub
              LIB     l_long_ucmp
              LIB     l_long_uge
              LIB     l_long_ugt
              LIB     l_long_ule
              LIB     l_long_ult
              LIB     l_long_xor
              LIB     l_plong
              LIB       l_inclong
              LIB       l_declong
              LIB     l_long_div
              LIB     l_long_div_u
              LIB     l_long_mult

;       All of the code in this file is for programs running from BASIC
;       memory space, a new startup will be written for proper z88 apps


; Dennis' snippet to create a BASIC program straight off!
; No need for a little boot program as well, this needed mods to the
; code as well - one line in cc6.c

        org $2300


.bas_first
        DEFB    bas_last - bas_first    ;Line Length
;       DEFW    0                       ;Row Number 0 can not be listed
        DEFW    1
        DEFM    BAS_IF & BAS_PAGE_G & "<>&2300" & BAS_THEN & BAS_NEW
        DEFM    BAS_ELSE & BAS_LOMEM_P & "=&AFFF" & BAS_CALL & BAS_TO & "P" & CR
.bas_last
        DEFB    0
        DEFW    $FFFF           ;End of BASIC program. Next address is TOP.


.start
        ld      hl,0
        add     hl,sp
        ld      sp,($1ffe)
        ld      (start1+1),hl
        ld      hl,-64
        add     hl,sp
        ld      sp,hl
        ld      (exitsp),sp
        call    doerrhan
        call    smc_main
.cleanup
;
;       Deallocate memory which has been allocated here!
;
        call_oz(gn_nln)
        call    resterrhan
.start1
        ld      sp,0
        ret

;Install an error handler, very simple, but prevents lot so problems

.doerrhan
        xor     a
        ld      (exitcount),a
        ld      b,0
        ld      hl,errhand
        call_oz(os_erh)
        ld      (l_erraddr),hl
        ld      (l_errlevel),a
        ret

;Restore BASICs error handler

.resterrhan
        ld      hl,(l_erraddr)
        ld      a,(l_errlevel)
        ld      b,0
        call_oz(os_erh)
        ret

;The laughable error handler itself!
.errhand
        ret     z       ;fatal
        cp      rc_esc
        jr     z,errescpressed
;Pass everything else to BASICs error handler
        ld      hl,(l_erraddr)
        scf
;Save a byte here, byte there! This has label because it's used for
;calculated calls etc
.l_dcal
        jp      (hl)

;Escape pressed, treat as cntl+c so quit out (bit crude, but there you go!)


.errescpressed
        call_oz(os_esc)
        jr      cleanup

; Now, define some values for stdin, stdout, stderr

.smc_sgoioblk
        defw    -11,-12,-10



;Just making me life harder! These will vanish for App startup!

.l_erraddr
        defw    0
.l_errlevel
        defb    0


.coords         defw      0
.base_graphics  defw      0
.gfx_bank       defb    0

;Printf variables

.smc_pf_count       defw    0
.smc_pf_string      defw    0

;Atexit routine

.exitsp
                defw    0
.exitcount
                defb    0
;.prog_atexitrout
;                defw    0

         defm  "Small C+ z88"&0

;All the float stuff is kept in a different file...for ease of altering!
;It will eventually be integrated into the library
;
;Here we have a minor (minor!) problem, we've no idea if we need the
;float package if this is separated from main (we had this problem before
;but it wasn't critical..so, now we will have to read in a file from
;the directory (this will be produced by zcc) which tells us if we need
;the floatpackage, and if so what it is..kludgey, but it might just work!
;
;Brainwave time! The zcc_opt file could actually be written by the
;compiler as it goes through the modules, appending as necessary - this
;way we only include the package if we *really* need it!

IF NEED_floatpack
        INCLUDE "#float.asm"     
ENDIF

