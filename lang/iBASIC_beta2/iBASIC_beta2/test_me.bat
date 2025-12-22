; -------------------------------------------
;   test_me.bat MUST be run from Shell/CLI!!
; -------------------------------------------

If EXISTS RAM:ibasic_beta2/bin
Assign IBASIC: RAM:ibasic_beta2
path IBASIC:bin ADD

CD IBASIC:examples
CLEAR

ECHO "Now testing iBASIC IEEE:"
ECHO ""
WAIT 2 SECS
ibasic_ieee_a68k test.bas
WAIT 2 SECS
ibasic_ieee_020 test.bas
WAIT 2 SECS
ibasic_ieee_030 test.bas
WAIT 2 SECS
ibasic_ieee_040 test.bas
WAIT 2 SECS
ibasic_ieee_060 test.bas
ECHO ""

ECHO "Now testing iBASIC NOMATH:"
ECHO ""
WAIT 2 SECS
ibasic_nomath_a68k test.bas
WAIT 2 SECS
ibasic_nomath_010 test.bas
WAIT 2 SECS
ibasic_nomath_020 test.bas
WAIT 2 SECS
ibasic_nomath_030 test.bas
WAIT 2 SECS
ibasic_nomath_040 test.bas
WAIT 2 SECS
ibasic_nomath_060 test.bas
ECHO ""

ECHO "Now testing iBASIC FFP:"
ECHO ""
WAIT 2 SECS
ibasic_ffp_020 test.bas
WAIT 2 SECS
ibasic_ffp_030 test.bas
WAIT 2 SECS
ibasic_ffp_040 test.bas
WAIT 2 SECS
ibasic_ffp_060 test.bas
ECHO ""

ECHO " --- DONE. ---"

EndIf
