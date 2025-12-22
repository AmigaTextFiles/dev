; SX4Amiga
;
; Programmer for the SX microcontrollers from Scenix
;
; Version 0.2ß
; By Dennis van Weeren
; 2000(C)
;
; 18-06-2000:
; Added watchdog to prevent hanging
; Changed timing to support newer revision SX
;
; Pic16C/F84-10P
; Osc.= HS, 9.8304 MHz, WatchDog ON

#define     PAGE0           bcf STATUS,RP0
#define     PAGE1           bsf STATUS,RP0


;Variables

flags       equ 0x0c
Wstack      equ 0x0d
Sstack      equ 0x0e

countin     equ 0x0f
shiftin     equ 0x10
bitin       equ 0x11
bitout      equ 0x12
shiftout    equ 0x13
countout    equ 0x14
buffer      equ 0x15

counter     equ 0x16
timer       equ 0x17

char        equ 0x18

datawrhi    equ 0x19
datawrlo    equ 0x1a
datawr_c_hi equ 0x1b
datawr_c_lo equ 0x1c
datardhi    equ 0x1d
datardlo    equ 0x1e

repeats     equ 0x1f
tmp         equ 0x20


;Flag Constants

send        equ 0
receive     equ 1
buf         equ 2
pcal        equ 3


;Serial constants 19200 baud @ 9.8304Mhz

Baudrate    equ 0xce ; baudclockratecount
Baudcount   equ 0x02 ; counts per full baud
Halfcount   equ 0x01 ; counts per half baud


;I/O constants PORTA

OSC1_GND    equ 1
OSC1_VPP    equ 2
OSC1_VCC    equ 3


;some more constants for porta osc1 control

OSC1HIGH    equ             0x08
OSC1LOW     equ             0x02
OSC1VPP     equ             0x04
OSC1FLOAT   equ             0x00


;I/O constants PORTB

rxd         equ 0
txd         equ 1

OSC2        equ 3
LED         equ 4




;--------------ProgramStart---------------


            org     0x000


            goto    Init
            nop
            nop
            nop
            goto    Int_Service

Init        movlw   0x12                ;set initial I/O conditions
            movwf   PORTB
            movlw   OSC1FLOAT
            movwf   PORTA


            PAGE1
            movlw   0x8c                ;WDT prescaler to 1:16 -->0.3s timeout
            movwf   OPTION_REG          ;RTCC to 1:1 internal cycle INT on falling edge

            movlw   0x09                ;set DDR/TRIS
            movwf   TRISB
            movlw   0x00
            movwf   TRISA
            PAGE0


            clrf    flags


            bcf     INTCON,INTF         ;switch on serial INT
            bsf     INTCON,INTE

            bcf     INTCON,T0IF
            bsf     INTCON,T0IE

            bsf     INTCON,GIE


;CHECK WATCHDOG
            btfss   STATUS,NOT_TO
            goto    Error               ;We were reset by the watchdog, error occurred !
;END OF CHECK WATCHDOG


Main        bsf     PORTB,LED


            call    GetSerial           ;wait for an Amiga command
            movwf   char
            bcf     PORTB,LED

            movf    char,W              ;s=start isp
            xorlw   0x73
            btfsc   STATUS,Z
            call    StartISP

            movf    char,W              ;q=stop isp
            xorlw   0x71
            btfsc   STATUS,Z
            call    StopISP

            movf    char,W              ;c=command
            xorlw   0x63
            btfsc   STATUS,Z
            call    DoCommand

            clrf     char               ;clear command buffer

            goto    Main



;----------ERROR Handling--------------------

Error       clrwdt

            movlw   0x72                ;send r=error
            call   SendSerial

            movf    char,W              ;Were we in the middle of a DoCommand ?
            xorlw   0x63
            btfss   STATUS,Z

            goto    Main                ;No, goto Main

            movlw   0x30                ;Send four zero's to finish DoCommand
            call    SendSerial
            movlw   0x30
            call    SendSerial
            movlw   0x30
            call    SendSerial
            movlw   0x30
            call    SendSerial

            clrf    char

            goto    Main







;----------USER comm routines---------------------


StartISP    call    GoISP

            call    SyncISP             ;if GoISP was succesfull, there should be sync pulses

            xorlw   0x01
            btfsc   STATUS,Z
            goto    StartFAIL

            movlw   0x6f                ;send o=ok
            call    SendSerial
            return

StartFAIL   movlw   0x72                ;send r=error
            call    SendSerial
            return




StopISP     call    ExitISP

            movlw   0x6f                ;send o=ok
            call    SendSerial
            return




DoCommand   call    GetSerial           ;get hi part of repeats
            call    AscToHex
            movwf   repeats             ;put hi part in right nibble
            swapf   repeats,F
            call    GetSerial           ;get lo part of repeats
            call    AscToHex
            iorwf   repeats,F           ;combine both nibbles


            call    GetSerial           ;get hi part of datawrhi
            call    AscToHex
            movwf   datawrhi            ;put hi part in right nibble
            swapf   datawrhi,F
            call    GetSerial           ;get lo part of datawrhi
            call    AscToHex
            iorwf   datawrhi,F          ;combine both nibbles


            call    GetSerial           ;get hi part of datawrlo
            call    AscToHex
            movwf   datawrlo            ;put hi part in right nibble
            swapf   datawrlo,F
            call    GetSerial           ;get lo part of datawrlo
            call    AscToHex
            iorwf   datawrlo,F          ;combine both nibbles


            call    GoFrame             ;do the command


            xorlw   0x01                ;error ocurred ?
            btfsc   STATUS,Z
            goto    DoComFAIL

            movlw   0x6f                ;send o=ok
            call    SendSerial
            goto    DoComData

DoComFAIL   movlw   0x72                ;send r=error
            call    SendSerial
            goto    DoComData


DoComData   swapf   datardhi,W          ;send hi nibble of datardhi
            call    HexToAsc
            call    SendSerial

            movf    datardhi,W          ;send lo nibble of datardhi
            call    HexToAsc
            call    SendSerial

            swapf   datardlo,W          ;send hi nibble of datardlo
            call    HexToAsc
            call    SendSerial

            movf    datardlo,W          ;send lo nibble of datardlo
            call    HexToAsc
            call    SendSerial

            return


;-------------------------------------------------
;----------------ISP support routines-------------
;-------------------------------------------------


;-----------Enter the ISP mode-------------------------


GoISP       call    IntOFF


            movlw   OSC1LOW             ;pull osc1 low
            movwf   PORTA


            bcf     PORTB,OSC2
            PAGE1
            bcf     TRISB,OSC2          ;pull osc2 low
            PAGE0

            movlw   0xff
            call    Delay               ;delay for ~1000 cycles (more than 9 32khz cycles)





            movlw   0x0f                ;toggle OSC1 16 times, just to be sure
            movwf   counter

ToggleLp    movlw   OSC1HIGH
            movwf   PORTA               ;set osc1 high

            movlw   0x30
            call    Delay               ;delay 48*2 =about 24 khz togglerate

            movlw   OSC1LOW             ;set osc1 low
            movwf   PORTA

            movlw   0x30
            call    Delay

            decfsz  counter
            goto    ToggleLp


            PAGE1
            bsf     TRISB,OSC2          ;release the osc2 pin
            PAGE0

            movlw   OSC1VPP
            movwf   PORTA               ;apply the programming voltage



            call    IntON


            return


;---------Do a command, write and read------------


;timing:
;
;Sync overhead is 2 to 5 cycles
;
;place data after 16 cycles  (6.7us)
;sample data after 34 cycles (14us)
;remove data after 56 cycles (23us)
;
;this should work on SX chips varying from 90-150KHZ
;
;datawrhi,lo contains command and data to be written
;datardhi,lo contains data read back from the SX
;repeats contains the number of times this command should be issued
;
;returns 0x00 if OK, 0x01 if an error occurred


GoFrame     call    IntOFF

            movf    datawrhi,W          ;copy data
            movwf   datawr_c_hi
            movf    datawrlo,W
            movwf   datawr_c_lo

            call    SyncISP             ;synchronize to the SX frame
                                                    
            movlw   0x10                ;4 commandbits and 12 databits --> 16 bits in total
            movwf   counter

            xorlw   0x01                ;synchronization OK ?
            btfsc   STATUS,Z
            goto    FrameFAIL           ;no, exit with errorcode

FrameLP     btfsc   PORTB,OSC2          ;wait for the sync pulse
            goto    FrameLP

            nop                         ;3
            nop                         ;4
            nop                         ;5
            nop                         ;6
            nop                         ;7
            nop                         ;8
            nop                         ;9
            nop                         ;10
            nop                         ;11
            nop                         ;12

            bcf     PORTB,OSC2          ;set osc2 outputbuffer low
            PAGE1
            btfss   datawr_c_hi,7
            bcf     TRISB,OSC2          ;pull osc2 low by enabling output driver on 16 cycles
            PAGE0

            rlf     datawr_c_lo         ;shift new databit into place
            rlf     datawr_c_hi

            nop                         ;20
            nop                         ;21
            nop                         ;22
            nop                         ;23
            nop                         ;24
            nop                         ;25
            nop                         ;26
            nop                         ;27
            nop                         ;28
            nop                         ;29
            nop                         ;30

            rlf     datardlo            ;shift old databits into place
            rlf     datardhi

            bcf     datardlo,0          ;sample OSC2 data on 34 cycles
            btfsc   PORTB,OSC2
            bsf     datardlo,0          

            movlw   0x03                ;delay for 16 cycles inc. movlw
            call    Delay

            nop                         ;52
            nop                         ;53
            nop                         ;54
            

            PAGE1
            bsf     TRISB,OSC2          ;release the osc2 pin on 56 cycles
            PAGE0

FrameWOH    btfss   PORTB,OSC2          ;Wait for OSC2 to get high again
            goto    FrameWOH

            decfsz  counter             ;last bit ?
            goto    FrameLP             ;no, do next bit

            decf    repeats             

            btfsc   STATUS,Z            ;last repeat?
            goto    FrameOK             ;yes, everything went alright->exit

            movf    datawrhi,W          ;copy data
            movwf   datawr_c_hi
            movf    datawrlo,W
            movwf   datawr_c_lo

            movlw   0x10                ;4 commandbits and 12 databits --> 16 bits in total
            movwf   counter

            goto    FrameLP             ;Do another frame


FrameOK     call    IntON
            retlw   0x00



FrameFAIL   call    IntON
            retlw   0x01




;---------------Exit from the ISP mode------------




ExitISP     call    IntOFF

            movlw   OSC1LOW             ;OSC1=low
            movwf   PORTA

            call    SyncISP             ;wait for the sync cycle ->SX exits ISP after sync

            movlw   0x30                ;give the SX some extra time to exit ISP
            call    Delay

            movlw   OSC1FLOAT
            movwf   PORTA               ;release osc1

            PAGE1
            bsf     TRISB,OSC2          ;release the osc2 pin
            PAGE0

            call    IntON

            return





;-------synchronize to the SX chip------------------


;SyncISP synchronize to the SX by waitng for a sync cycle
;returncodes:
; 0x00  OK we are in a sync cycle
; 0x01  NOT ok no sync cycle was found


SyncISP     movlw   0x40                ;retry's= 64 (about 3-4 frames)
            movwf   counter


SyncHigh    btfss   PORTB,OSC2          ;wait for OSC2 to get high
            goto    SyncHigh

            movlw   0x12                ;timeout= 18*5= 95 cycles= 39us
            movwf   timer

SyncLP      btfss   PORTB,OSC2          ;now wait for a falling edge
            goto    SyncEdge
            decfsz  timer
            goto    SyncLP

            retlw   0x00                ;time out -> this is a sync cycle



SyncEdge    decfsz  counter             ;we detected an edge ->this was not a sync cycle
            goto    SyncHigh
            retlw   0x01                ;too many retry's, synchronization failed






;-------------------------------------------------
;-------------system support routines-------------
;-------------------------------------------------



SendSerial  btfsc   flags,send      ;Sends byte in W over to the serial port
            goto    SendSerial
            movwf   shiftout
            movlw   0x0a
            movwf   bitout
            movwf   countout
            bsf     flags,send
            return

GetSerial   clrwdt                  ;!!!! ONLY FOR SX4AMIGA!!!!
            btfss   flags,buf       ;Waits for byte and returns byte in W
            goto    GetSerial
            movf    buffer,W
            bcf     flags,buf
            return



IntOFF      movf    flags,W         ;Switch interrupts off
            andlw   0x03
            btfss   STATUS,Z        ;wait for serial to finish
            goto    IntOFF
            bcf     INTCON,GIE
            return

IntON       bcf INTCON,T0IF         ;Switch interrupts back on
            bcf INTCON,INTF
            bsf INTCON,GIE
            return


Delay       addlw   0xff            ;Delay for W*4 cycles
            btfss   STATUS,Z
            goto    Delay
            return


; convert hex value in W to ascii in W

HexToAsc    andlw   0x0f            ;mask out 1 nibble
            movwf   tmp

            addlw   0xf6            ;greater than 9?
            btfsc   STATUS,C
            goto    HexHigh

            movf    tmp,W           ;0-9
            addlw   0x30
            return


HexHigh     movf    tmp,W           ;a-f
            addlw   0x57
            return


; convert ascii in W to hex value in W

AscToHex    movwf   tmp

            addlw   0xb0            ;greater than 0x50 ?
            btfsc   STATUS,C
            goto    AscHigh

            movf    tmp,W           ;0-9
            addlw   0xd0
            andlw   0x0f
            return

AscHigh     movf    tmp,W           ;a-f
            addlw   0xa9
            andlw   0x0f
            return





;---------------------Interrupt Handling------------
;-------------------and RS-232 Interfacing----------

Int_Service movwf   Wstack
            movf    STATUS,W
            movwf   Sstack
            PAGE0

            btfss   INTCON,T0IF
            goto    Skip

            movlw   Baudrate
            movwf   TMR0
            bcf     INTCON,T0IF
            btfsc   flags,send
            call    Send
            btfsc   flags,receive
            call    Receive

Skip        btfsc   INTCON,INTE
            call    Startbit

            swapf   Wstack
            movf    Sstack,W
            movwf   STATUS
            swapf   Wstack,W
            bsf     INTCON,GIE

            return



Startbit    btfss   INTCON,INTF
            return
            movlw   0x09
            movwf   bitin
            bcf     INTCON,INTE
            bcf     INTCON,INTF
            bsf     flags,receive
            movlw   Halfcount
            movwf   countin
            return

Receive     decfsz  countin
            return
            movlw   Baudcount
            movwf   countin
            rrf     shiftin
            bcf     shiftin,7
            btfsc   PORTB,rxd
            bsf     shiftin,7
            decfsz  bitin
            return
Received    bcf     flags,receive
            bcf     INTCON,INTF
            bsf     INTCON,INTE
            movf    shiftin,W
            movwf   buffer
            bsf     flags,buf
            return



Send        decfsz  countout
            return
            movlw   Baudcount
            movwf   countout
            movf    bitout,W
            xorlw   0x0a
            btfss   STATUS,Z
            goto    Dataout
            bcf     PORTB,txd
            decf    bitout
            return

Dataout     btfsc   shiftout,0
            bsf     PORTB,txd
            btfss   shiftout,0
            bcf     PORTB,txd
            bsf     STATUS,C
            rrf     shiftout
            decfsz  bitout
            return
            bcf     flags,send
            return



