*============================================================================*
*               1 6   B I T   M A T H   P A C K A G E
*          for the Motorola 6805 family of microprocessors.
*
*                            D G Weiss
*                          Motorola Inc
*                      Microprocessor Group
*                 Midrange Strategic Engineering
*                          13 Nov 1985
*
*   This is a collection of routines for maintaining a 32-bit pseudo-
*   accumulator.  Each routine uses the X register to locate an operand;
*   the math routines use the pseudo-accumulator as the other operand.
*
*============================================================================*
        ORG     $40       Beginning of RAM
ACCUM3  RMB     1         Accumulator high order byte
ACCUM2  RMB     1
ACCUM1  RMB     1
ACCUM0  RMB     1         Accumulator low order byte
CTR     RMB     1         Iteration counter
TEMP1   RMB     1         Miscelleneous temps
TEMP0   RMB     1
*----------------------------------------------------------------------------*
* Load 16-bit value pointed to by X register into Accumulator.
*    Accepts:
*       value to be loaded: X^[0..1]
*    Yields:
*       loaded value:       Accum[1..0]
*----------------------------------------------------------------------------*
        ORG     $800
LOAD16  EQU     *
        LDA     0,X
        STA     ACCUM1
        LDA     1,X
        STA     ACCUM0
        RTS 
*----------------------------------------------------------------------------*
* Store 16-bit value from Accumulator to location pointed to by X register.
*    Accepts:
*       value to be stored: Accum[1..0]
*    Yields:
*       stored value:       X^[0..1]
*----------------------------------------------------------------------------*
STORE16 EQU     *
        LDA     ACCUM1
        STA     0,X
        LDA     ACCUM0
        STA     1,X
        RTS 
*----------------------------------------------------------------------------*
* Add 16-bit value pointed to by X register into Accumulator.  
*    Accepts:
*       Addend: Accum[1..0]
*       Augend: X^[0..1]
*    Yields:
*       Sum:    Accum[1..0]
*----------------------------------------------------------------------------*
ADD16   EQU     *
        LDA     ACCUM0
        ADD     1,X
        STA     ACCUM0
        LDA     ACCUM1
        ADC     0,X
        STA     ACCUM1
        RTS 
*----------------------------------------------------------------------------*
* Subtract 16-bit value pointed to by X register from Accumulator.
*    Accepts:
*       Minuend:    Accum[1..0]
*       Subtrahend: X^[0..1]
*    Yields:
*       Difference: Accum[1..0]
*----------------------------------------------------------------------------*
SUB16   EQU     *
        LDA     ACCUM0
        SUB     1,X
        STA     ACCUM0
        LDA     ACCUM1
        SBC     0,X
        STA     ACCUM1
        RTS
*
*----------------------------------------------------------------------------*
* Multiply 16-bit value in Accumulator by 16-bit value pointed to by X
*   register.
*
*    Accepts:
*       Multiplier:    Accum[1..0]
*       Multiplicand:  X^[0..1]
*    Yields:
*       Product:       Accum[3..0]
*----------------------------------------------------------------------------*
PROD3   EQU     ACCUM3    Product high order byte
PROD2   EQU     ACCUM2
PROD1   EQU     ACCUM1
PROD0   EQU     ACCUM0    Product low order byte
MPR1    EQU     TEMP1     Multiplier high order byte
MPR0    EQU     TEMP0     Multiplier low order byte
MPD1    EQU     0         Multiplicand high order byte offset
MPD0    EQU     1         Multiplicand low order byte offset

MPY16   EQU     *
        LDA     PROD0                 .Mpr[1..0] := Prod[1..0]
        STA     MPR0
        LDA     PROD1
        STA     MPR1
        CLR     PROD0                 .Prod[2..0] := 0
        CLR     PROD1
        CLR     PROD2
        LDA     #16                   .For ctr := 16 Downto 1 Do
        STA     CTR

MPY16A  BRCLR   7,MPR1,MPY16C         .   If mpr msb = 1
        LDA     PROD0                 .       Then prod += mpd
        ADD     MPD0,X
        STA     PROD0
        LDA     PROD1
        ADC     MPD1,X
        STA     PROD1
        LDA     PROD2
        ADC     #0
        STA     PROD2

MPY16C  DEC     CTR                   .   If (ctr -= 1) = 0 Then Exit
        BEQ     MPY16E
        ASL     PROD0                 .   shift prod left
        ROL     PROD1
        ROL     PROD2
        ROL     PROD3
        ASL     MPR0                  .   shift mpr left
        ROL     MPR1
        BRA     MPY16A

MPY16E  RTS
*
*----------------------------------------------------------------------------*
* Divide 32 by 16 bit unsigned integer
*
*    Accepts:
*       Dividend:      Accum[3..0]
*       Divisor:       X^[0..1]
*    Yields:
*       Quotient:      Accum[1..0]
*       Remainder:     Accum[3..2]
*----------------------------------------------------------------------------*
DVDND3  EQU     ACCUM3  Dividend high order byte
DVDND2  EQU     ACCUM2
DVDND1  EQU     ACCUM1
DVDND0  EQU     ACCUM0  Dividend low order byte
RMNDR1  EQU     ACCUM3  Remainder high order byte
RMNDR0  EQU     ACCUM2  Remainder low order byte
QUOT1   EQU     ACCUM1  Quotient high order byte
QUOT0   EQU     ACCUM0  Quotient low order byte
DVSOR1  EQU     0       Divisor high order byte offset
DVSOR0  EQU     1       Divisor low order byte offset
*
DIV16   EQU     *
        LDA     #16                       .For Ctr := 16 Downto 1 do
        STA     CTR

DIV16A  LDA     DVDND3                    .    shift dividend left one place
        ROLA
        ROL     DVDND0
        ROL     DVDND1
        ROL     DVDND2
        ROL     DVDND3

        LDA     DVDND2                    .    subtract divisor from remainder
        SUB     DVSOR0,X
        STA     DVDND2
        LDA     DVDND3
        SBC     DVSOR1,X
        STA     DVDND3
        LDA     DVDND0                    .{dividend low bit holds subtract carry}
        SBC     #0
        STA     DVDND0

        BRCLR   0,DVDND0,DIV16C           .    if subtract carry = 1
        LDA     DVDND2                    .        Then add divisor back in
        ADD     DVSOR0,X
        STA     DVDND2
        LDA     DVDND3
        ADC     DVSOR1,X
        STA     DVDND3
        LDA     DVDND0
        ADC     #0
        STA     DVDND0
        BRA     DIV16D

DIV16C  BSET    0,DVDND0                  .        Else set hi bit := 1

DIV16D  DEC     CTR
        BNE     DIV16A
        RTS
        END
