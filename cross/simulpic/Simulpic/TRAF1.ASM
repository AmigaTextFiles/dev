; WRITTEN BY            NIGEL GARDNER
; COPYRIGHT             BLUEBIRD ELECTRONICS
; DATE                  6/9/95  
; ITERATION             1.1
; FILE SAVED AS         TRAF1.ASM
; FOR PIC16C54 
; 4.00 MHz RESONATOR. 
; INSTRUCTION CLOCK     1.00 MHz  T= 1uS 

; Software written for use with project board from Bluebird Electronics.
 
; ***** equates *****

rtcc    equ    1             ; counter
pc      equ    2             ; program counter
status  equ    3             ; status register
carry   equ    0             ; carry bit
dcarry  equ    1             ; digit carry bit
pdown   equ    3             ; power down bit
watdog  equ    4             ; watchdog timeout bit
fsr     equ    4             ; file select register
z       equ    2                

porta   equ     5                
auto    equ     0               ; manual auto switch
step    equ     1               ; sequence step switch

portb   equ     6                
red1    equ     0               ; set a of lights 
yel1    equ     1                
green1  equ     2                
red2    equ     3               ; set b of lights
yel2    equ     4                
green2  equ     5

count   equ     0bh             ; general purpose counter

        list p=16c84

        org     04

;************************ subroutines ********************

; test here to see if manual mode or delay if automatic

delay   btfsc   porta,auto      ; test for auto switch on
        goto    dly1            ; automatic mode
lp1     btfsc   porta,step      ; if manual mode, then wait for
        goto    delay           ; button press but check if auto
lp2     btfss   porta,step      ; and then release before continuing
        goto    lp2             ; to next sequence
        retlw   0               ; return without delay after button press
                                ; delete this previous line if a delay
                                ; is required after the button is pressed
        
; ************** long delay *********************************   

dly1    clrf    rtcc
        movlw   .156            ; 156 * 32ms = 5 seconds
        movwf   count           ; use this register temporarily
long2   btfsc   rtcc,7          ; test rtcc bit 7 128*256us = 32ms
        goto    jmp1
        goto    long2           ; loop until bit is set

jmp1    clrf    rtcc            ; yes, so clear rtcc 
        decfsz  count,f         ; decrement, until zero
        goto    long2
        retlw   0

; *********** initalise ports and rtcc *************

init    movlw   00h
        tris    portb           ; port b as outputs
        clrf    portb
        movlw   0fh
        tris    porta           ; port a as inputs
        movlw   b'00000111'     ; rtcc pre-scalar /256
        option                  ; 256us per count internal clock

; ********* program begins here **********************

main    bcf     portb,yel1
        bsf     portb,red1

        bcf     portb,yel2
        bcf     portb,red2
        bsf     portb,green2
        call    delay           ; wait for button press

        bsf     portb,yel1

        bcf     portb,green2
        bsf     portb,yel2
        call    dly1

        bcf     portb,yel1      
        bcf     portb,red1
        bsf     portb,green1

        bcf     portb,yel2
        bcf     portb,green2
        bsf     portb,red2
        call    delay           ; wait for button press

        bcf     portb,green1
        bsf     portb,yel1

        bsf     portb,yel2
        call    dly1

        goto    main

        org     000h            ; reset vector for c54
        goto    init

        end
