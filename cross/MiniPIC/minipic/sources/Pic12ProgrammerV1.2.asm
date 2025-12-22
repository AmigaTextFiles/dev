; Pic12C508 Production Grade Programmer
; Version 1.2
; By Dennis van Weeren
; 1998(C)
;
; Pic16C84-04P
; Osc.= XT, 3.579545 MHz, no WatchDog (yet)


; CHANGES since Version 1.1
;-------------------------------------------------------------------
;
;increased delay between Clock and read databit from pic12




#define PAGE0 bcf STATUS,RP0
#define PAGE1 bsf STATUS,RP0



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
tmp1        equ 0x16
tmp2        equ 0x17
pchi        equ 0x18
pclo        equ 0x19
checkhi     equ 0x1a
checklo     equ 0x1b
datahi      equ 0x1c
datalo      equ 0x1d
ledstatus   equ 0x1e
ledcount    equ 0x1f
timeout     equ 0x20
pulse       equ 0x21
datahiback  equ 0x22
dataloback  equ 0x23


;Flag Constants

send        equ 0
receive     equ 1
buf         equ 2
pcal        equ 3

;Serial constants 2400 baud @ 3.579545Mhz

Baudrate    equ 0x53 ; baudclockratecount
Baudcount   equ 0x02 ; counts per full baud
Halfcount   equ 0x01 ; counts per quarter baud


;I/O constants

rxd         equ 0
txd         equ 1
green       equ 3
red         equ 2
button      equ 4
datain      equ 5
dataout     equ 6
clk         equ 7




icport      equ 0x05
icddr       equ 0x05
scl         equ 0x1
sda         equ 0x0

















;--------------ProgramStart---------------


            org 0x000

            goto Init
            nop
            nop
            nop
            goto Int_Service

Init        movlw 0x0a
            movwf PORTB
            movlw 0x00
            movwf PORTA

            PAGE1
            movlw 0x31
            movwf TRISB
            movlw 0x03
            movwf TRISA
            PAGE0

            clrf flags
            clrf ledstatus          ;leds off, no flashing

            PAGE1
            bcf OPTION_REG,INTEDG
            bsf OPTION_REG,3
            bcf OPTION_REG,5
            PAGE0

            bcf INTCON,INTF
            bsf INTCON,INTE

            bcf INTCON,T0IF
            bsf INTCON,T0IE

            bsf INTCON,GIE


Mainloop    btfss PORTB,button
            goto Program

            btfss flags,buf
            goto Mainloop

            movf buffer,W
            movwf tmp1
            bcf flags,buf

            movf tmp1,W
            xorlw 0x70
            btfsc STATUS,Z
            goto Program

            movf tmp1,W
            xorlw 0x64
            btfsc STATUS,Z
            goto Download

            movf tmp1,W
            xorlw 0x62
            btfsc STATUS,Z
            goto Blankreport

            goto Echo


;---------------------Echo-----------------------------
Echo        movf tmp1,W
            call Sendserial
            goto Mainloop


;-----------------Blankreport--------------------------


Blankreport clrw
            movwf ledstatus
            bcf PORTB,green
            bsf PORTB,red

            clrw
            call Setlow
            call Blanktest
            xorlw 0x00
            btfss STATUS,Z
            goto Brepfail

            call Setoff

            movlw 0x52
            call Sendserial
            bcf PORTB,red
            bsf PORTB,green
            goto Mainloop

Brepfail    call Setoff

            movlw 0x72
            call Sendserial
            movlw 0x84
            movwf ledstatus
            goto Mainloop

;----------------Download Part-------------------------



Download    clrw
            movwf ledstatus
            bcf PORTB,red
            bsf PORTB,green

            clrf pchi               ;teller=0
            clrf pclo
            clrf checkhi            ;checksum=0
            clrf checklo

Again       call Getserial          ;get hidigit&copy
            addlw 0x9f
            andlw 0x0f
            movwf datahi
            swapf datahi,F
            addlw 0x61
            call Sendserial

            call Getserial          ;get lodigit&copy
            addlw 0x9f
            andlw 0x0f
            addwf datahi,F
            addlw 0x61
            call Sendserial
 
            call Writemem           ;program & verify
            call Readmem

            movf datahi,W
            xorwf tmp1,W

            movlw 0x66
            btfsc STATUS,Z          ;send back result
            movlw 0x6f
            call Sendserial

Rescan      call Getserial          ;wait for response

            movwf tmp1

            movf tmp1,W             ;Reprogram Byte
            xorlw 0x72
            btfsc STATUS,Z
            goto Again

            movf tmp1,W             ;Program Next
            xorlw 0x6e
            btfsc STATUS,Z
            goto Next

            movf tmp1,W             ;End downloading
            xorlw 0x65
            btfss STATUS,Z
            goto Rescan


            movf datahi,W           ;add last byte to checksum
            call Calccheck

            movlw 0x04              ;set eeprom pointer to checksum
            movwf pchi
            movlw 0x02
            movwf pclo

            movf checkhi,W          ;write checksum hipart
            movwf datahi
            call Writemem
            call Readmem

            clrf checkhi
                                    ;verify checksum hipart
            movf datahi,W
            xorwf tmp1,W
            btfss STATUS,Z
            bsf checkhi,0

            incf pclo               ;next adress for checksum
            btfsc STATUS,Z
            incf pchi

            movf checklo,W          ;write checksum lopart
            movwf datahi
            call Writemem
            call Readmem

            movf datahi,W           ;verify checksum lopart
            xorwf tmp1,W
            btfss STATUS,Z
            bsf checkhi,0

            movlw 0x70              ;send back final result
            btfsc checkhi,0
            movlw 0x63

            call Sendserial

            goto Mainloop




Next        incf pclo
            btfsc STATUS,Z
            incf pchi
            movf datahi,W
            call Calccheck
            goto Again



;------------------Program Part------------------

Program     clrw
            movwf ledstatus
            bcf PORTB,green
            bsf PORTB,red

            call Checkmem           ;Check for eeprom
            xorlw 0x00              ;is correct
            btfss STATUS,Z
            goto Hardwaref

            call Setlow             ;do a blanktest
            call Blanktest
            xorlw 0x00
            btfss STATUS,Z
            goto Blankfail

            call Setoff             ;Set new Voltage and
            clrw                    ;go to programming phase
            call Timedelay
            clrw
            call Timedelay
            movlw 0x42
            call Sendserial         ;send B

            call Setmed             ;switch on the pic12....
            clrw
            call Timedelay

            clrf pchi               ;set eeprom begin adress
            movlw 0x02
            movwf pclo

Nextloc     movlw 0x06              ;goto next location
            movwf datalo
            call Command

            call Readmem            ;read data from eeprom
            movf tmp1,W
            andlw 0x0f
            movwf datahiback
            call Incpc
            call Readmem
            movf tmp1,W
            movwf dataloback
            call Incpc

            movf pchi,W             ;are we at the Calibration value?
            xorlw 0x04
            btfss STATUS,Z
            goto Nocal
            movf pclo,W
            xorlw 0x02
            btfss STATUS,Z
            goto Nocal

            movlw 0x04              ;yes, read data
            movwf datalo
            call Command
            call Readdata

            movf datahi,W           ;look if Calibration value
            andlw 0x0f
            xorlw 0x0c              ;is present if yes->end
            btfsc STATUS,Z
            goto Endprog

            movlw 0x0c              ;Cal value erased ? program a
            movwf datahiback        ;movlw 0x00
            movlw 0x00
            movwf dataloback
            goto Nocal

Nocal       movlw 0x7a              ;send z
            call Sendserial
            call Burnit             ;Burn this location

            xorlw 0x00              ;Burning succesfull ?
            btfss STATUS,Z
            goto Programfail


            movf pchi,W             ;last location programmed?
            xorlw 0x04
            btfss STATUS,Z
            goto Nextloc
            movf pclo,W
            xorlw 0x02
            btfss STATUS,Z
            goto Nextloc

Endprog     call Setoff             ;Set new Voltage and
            clrw                    ;go to Verify VDDmin phase
            call Timedelay
            clrw
            call Timedelay
            movlw 0x49
            call Sendserial         ;send I





            call Setlow

            call Verify             ;Verify low voltage

            xorlw 0x00              ;OK ?
            btfss STATUS,Z
            goto Minfail

            call Setoff             ;Set new Voltage and
            clrw                    ;go to Verify VDDmax phase
            call Timedelay
            clrw
            call Timedelay
            movlw 0x4d
            call Sendserial         ;send M




            call Sethigh

            call Verify             ;Verify high voltage

            xorlw 0x00              ;OK ?
            btfss STATUS,Z
            goto Maxfail

            call Setoff             ;Set new Voltage and
            clrw                    ;go to Program config phase
            call Timedelay
            clrw
            call Timedelay
            movlw 0x58
            call Sendserial         ;send X



            call Setmed             ;set to VDDp



            clrf pchi               ;set eeprom pointer to config
            movlw 0x01
            movwf pclo

            call Readmem            ;read config from eeprom
            movf tmp1,W
            andlw 0x1f
            movwf dataloback
            clrf datahiback




            movlw 0x02              ;load config in pic12
            movwf datalo
            call Command
            movf dataloback,W
            movwf datalo
            clrf datahi
            call Loaddata



            movlw 0x08              ;start programmingpulse
            movwf datalo
            call Command


            movlw 0x09              ;wait 10mS
            movwf tmp2


LoopTC      clrw
            call Timedelay
            decfsz tmp2
            goto LoopTC

            movlw 0x0e              ;end programming pulse
            movwf datalo
            call Command



            movlw 0x14              ;set vddmin
            movwf PORTA
            clrw
            call Timedelay

            movlw 0x04              ;read config
            movwf datalo
            call Command
            call Readdata

            movf datalo,W           ;OK ?
            andlw 0x1f
            xorwf dataloback,W
            btfss STATUS,Z
            goto Configfail



            movlw 0x1c              ;set vddmax
            movwf PORTA
            clrw
            call Timedelay

            movlw 0x04              ;read config
            movwf datalo
            call Command
            call Readdata

            movf datalo,W           ;OK?
            andlw 0x1f
            xorwf dataloback,W
            btfss STATUS,Z
            goto Configfail


            call Setoff             ;switch off PIC12
            movlw 0x43              ;send C
            call Sendserial


            clrw                    ;turn led to green
            movwf ledstatus
            bcf PORTB,red
            bsf PORTB,green
            
            goto Mainloop



Blankfail   call Setoff

            movlw 0x84
            movwf ledstatus

            movlw 0x62              ;send b
            call Sendserial

            goto Mainloop

Programfail call Setoff

            movlw 0x84
            movwf ledstatus

            movlw 0x69              ;send i
            call Sendserial

            goto Mainloop

Minfail     call Setoff

            movlw 0x84
            movwf ledstatus

            movlw 0x6d              ;send m
            call Sendserial

            goto Mainloop

Maxfail     call Setoff

            movlw 0x84
            movwf ledstatus

            movlw 0x78              ;send x
            call Sendserial

            goto Mainloop

Configfail  call Setoff

            movlw 0x84
            movwf ledstatus

            movlw 0x63              ;send c
            call Sendserial

            goto Mainloop





;--------------Burn a single location Routine-----------------

Burnit      clrf pulse              ;set #pulses to 0

Reburn      movlw 0x02              ;send data to Pic12
            movwf datalo
            call Command
            movf datahiback,W
            movwf datahi
            movf dataloback,W
            movwf datalo
            call Loaddata

            movlw 0x08              ;Apply 100uS
            movwf datalo            ;programming pulse
            call Command
            nop
            nop
            movlw 0x0e
            movwf datalo
            call Command
            incf pulse              ;add one pulse

            movlw 0x04              ;read data from pic12
            movwf datalo
            call Command
            call Readdata

            movf datahi,W           ;verify hipart
            andlw 0x0f
            xorwf datahiback,W
            btfss STATUS,Z
            goto Burnfail

            movf datalo,W           ;verify lopart
            xorwf dataloback,W
            btfss STATUS,Z
            goto Burnfail

            movf pulse,W            ;multiply by 11
            addwf pulse,F
            addwf pulse,F
            addwf pulse,F
            addwf pulse,F
            addwf pulse,F
            addwf pulse,F
            addwf pulse,F
            addwf pulse,F
            addwf pulse,F
            addwf pulse,F



Afterburn   movlw 0x02              ;send data to Pic12
            movwf datalo
            call Command
            movf datahiback,W
            movwf datahi
            movf dataloback,W
            movwf datalo
            call Loaddata

            movlw 0x08              ;Apply 100uS
            movwf datalo            ;afterburn pulse
            call Command
            nop
            nop
            movlw 0x0e
            movwf datalo
            call Command

            decfsz pulse            ;last afterburn pulse?
            goto Afterburn

            retlw 0x00              ;PASS return 0

Burnfail    movf pulse,W            ;more than 8 retry's ?
            xorlw 0x08              ;then Fail
            btfss STATUS,Z
            goto Reburn

            retlw 0x01              ;FAIL return 1




;---------------Verify Routine-----------------------

Verify      clrf pchi               ;set eeprom begin adress
            movlw 0x02
            movwf pclo


Vernext     movlw 0x06              ;goto next location
            movwf datalo
            call Command

            call Readmem            ;read data from eeprom
            movf tmp1,W
            andlw 0x0f
            movwf datahiback
            call Incpc
            call Readmem
            movf tmp1,W
            movwf dataloback
            call Incpc

            movlw 0x04              ;read data from pic12
            movwf datalo
            call Command
            call Readdata

            movf datahi,W           ;verify hipart
            andlw 0x0f
            xorwf datahiback,W
            btfss STATUS,Z
            goto Verfail

            movf datalo,W           ;verify lopart
            xorwf dataloback,W
            btfss STATUS,Z
            goto Verfail

            movf pchi,W             ;last location verified?
            xorlw 0x04
            btfss STATUS,Z
            goto Vernext
            movf pclo,W
            xorlw 0x00
            btfss STATUS,Z
            goto Vernext

            movlw 0x06              ;goto Calibration location
            movwf datalo            ;and read
            call Command
            movlw 0x04
            movwf datalo
            call Command
            call Readdata

            movf datahi,W           ;verify Calibration location
            andlw 0x0f
            xorlw 0x0c
            btfss STATUS,Z
            goto Verfail

            retlw 0x00              ;PASS return 0

Verfail     retlw 0x01              ;FAIL return 1




;----------------Blanktest routine-------------------

Blanktest   movlw 0x04              ;read configuration
            movwf datalo
            call Command
            call Readdata
            movf datalo,W           ;blank ?
            andlw 0x1f
            xorlw 0x1f
            btfss STATUS,Z
            goto Bfail

            clrf pclo

Blankloop1  movlw 0x06              ;increment
            movwf datalo
            call Command

            movlw 0x04              ;read location
            movwf datalo
            call Command
            call Readdata

            movf datalo,W           ;blank ?
            xorlw 0xff
            btfss STATUS,Z
            goto Bfail
            movf datahi,W
            andlw 0x0f
            xorlw 0x0f
            btfss STATUS,Z
            goto Bfail

            decfsz pclo             ;next !
            goto Blankloop1

            movlw 0xff
            movwf pclo

Blankloop2  movlw 0x06              ;increment
            movwf datalo
            call Command

            movlw 0x04              ;read location
            movwf datalo
            call Command
            call Readdata

            movf datalo,W           ;blank ?
            xorlw 0xff
            btfss STATUS,Z
            goto Bfail
            movf datahi,W
            andlw 0x0f
            xorlw 0x0f
            btfss STATUS,Z
            goto Bfail

            decf pclo               ;next !
            btfss STATUS,Z
            goto Blankloop2

            retlw 0x00              ;PASS send 0

Bfail       retlw 0x01              ;FAIL send 1



;--------------Checksum routine----------------------

Checkmem    clrf pclo
            clrf pchi               ;set eeprom pointer to 0

            clrf checklo            ;clear checksum
            clrf checkhi

Memagain    call Readmem
            call Incpc              ;get byte and add to checksum
            movf tmp1,W
            call Calccheck

            movf pchi,W             ;last byte ?
            xorlw 0x04
            btfss STATUS,Z
            goto Memagain
            movf pclo,W
            xorlw 0x02
            btfss STATUS,Z
            goto Memagain

            call Readmem            ;Verify hipart
            call Incpc
            movf tmp1,W
            xorwf checkhi,W
            btfss STATUS,Z
            goto Memfail

            call Readmem            ;Verify lopart
            call Incpc
            movf tmp1,W
            xorwf checklo,W
            btfss STATUS,Z
            goto Memfail

            retlw 0x00              ;PASS return 0

Memfail     retlw 0x01              ;FAIL return 1


;--------------Support Routines----------------------

Sendserial  btfsc flags,send
            goto Sendserial
            movwf shiftout
            movlw 0x0a
            movwf bitout
            movwf countout
            bsf flags,send
            return

Getserial   btfss flags,buf
            goto Getserial
            movf buffer,W
            bcf flags,buf
            return



Writemem    clrf timeout
Writeagain  incf timeout
            btfsc STATUS,Z
            goto Hardwaref
            rlf pchi,W
            andlw 0x0e
            addlw 0xa0
            call Open
            btfsc tmp1,0
            goto Writeagain
            movf pclo,W
            call Write
            btfsc tmp1,0
            goto Hardwaref
            movf datahi,W
            call Write
            btfsc tmp1,0
            goto Hardwaref
            call Close
            return


Readmem     clrf timeout
Readagain   incf timeout
            btfsc STATUS,Z
            goto Hardwaref
            rlf pchi,W
            andlw 0x0e
            addlw 0xa0
            call Open
            btfsc tmp1,0
            goto Readagain
            movf pclo,W
            call Write
            btfsc tmp1,0
            goto Hardwaref
            rlf pchi,W
            andlw 0x0e
            addlw 0xa1
            call Open
            btfsc tmp1,0
            goto Hardwaref
            call Read_nack
            call Close
            return



Calccheck   addwf checklo,F
            btfsc STATUS,C
            incf checkhi,F
            return



Command     movlw 0x06
            movwf tmp1
Comrepeat   bcf PORTB,dataout
            btfsc datalo,0
            bsf PORTB,dataout

            nop
            nop
            bsf PORTB,clk
            nop
            nop
            nop
            nop
            bcf PORTB,clk
            nop
            nop

            rrf datalo,F
            bcf PORTB,dataout
            decfsz tmp1,F
            goto Comrepeat
            return

Loaddata    bcf STATUS,C
            rlf datalo,F
            rlf datahi,F
            movlw 0x1f
            andwf datahi,F

            movlw 0x10
            movwf tmp1

Loadrepeat  bcf PORTB,dataout
            btfsc datalo,0
            bsf PORTB,dataout

            nop
            nop
            bsf PORTB,clk
            nop
            nop
            nop
            nop
            bcf PORTB,clk
            nop
            nop

            rrf datahi,F
            rrf datalo,F
            bcf PORTB,dataout
            decfsz tmp1,F
            goto Loadrepeat
            return

Readdata    movlw 0x10
            movwf tmp2
            bsf PORTB,dataout

Readrepeat  bsf PORTB,clk

            movlw 0xf0
            call Timedelay

            bcf datahi,7
            btfsc PORTB,datain
            bsf datahi,7
            nop
            nop
            nop
            nop
            nop
            nop
            bcf PORTB,clk

            bcf STATUS,Z
            rrf datahi,F
            rrf datalo,F

            decfsz tmp2,F
            goto Readrepeat

            bcf PORTB,dataout
            return

Setlow      bcf PORTB,clk           ;place PIC in PROGRAM mode Vddmin
            bcf PORTB,dataout
            movlw 0x04
            movwf PORTA
            clrw
            call Timedelay
            movlw 0x14
            movwf PORTA
            return


Setmed      bcf PORTB,clk           ;place PIC in PROGRAM mode Vddp
            bcf PORTB,dataout
            movlw 0x08
            movwf PORTA
            clrw
            call Timedelay
            movlw 0x18
            movwf PORTA
            return

Sethigh     bcf PORTB,clk           ;place PIC in PROGRAM mode Vddmax
            bcf PORTB,dataout
            movlw 0x0c
            movwf PORTA
            clrw
            call Timedelay
            movlw 0x1c
            movwf PORTA
            return

Timedelay   movwf tmp1              ;wait specified time
TDloop      decf tmp1
            btfss STATUS,Z
            goto TDloop
            return


Setoff      bcf PORTB,dataout       ;Switch off pic12
            bcf PORTB,clk
            nop
            nop
            clrw
            movwf PORTA
            return

Incpc       incf pclo               ;increment eeprom pointer
            btfsc STATUS,Z
            incf pchi
            return



;--------------------Hardware Failure---------------

Hardwaref   call Setoff
            clrf ledstatus
            bsf PORTB,green
            bcf PORTB,red
Hardfloop   movlw 0x88
            movwf ledstatus
            goto Hardfloop














;---------------------Interrupt Handling------------
;-------------------and RS-232 Interfacing----------

Int_Service movwf Wstack
            movf STATUS,W
            movwf Sstack
            PAGE0

            btfss INTCON,T0IF
            goto Skip

            movlw Baudrate
            movwf TMR0
            bcf INTCON,T0IF
            btfsc flags,send
            call Send
            btfsc flags,receive
            call Receive

Skip        btfsc INTCON,INTE
            call Startbit


            btfss ledstatus,7
            goto Noflash
            incf ledcount
            btfss STATUS,Z
            goto Noflash
            movf ledstatus,W
            andlw 0x0c
            xorwf PORTB,F


Noflash     swapf Wstack

            movf Sstack,W
            movwf STATUS
            swapf Wstack,W
            bsf INTCON,GIE
            return


Startbit    btfss INTCON,INTF
            return
            movlw 0x09
            movwf bitin
            bcf INTCON,INTE
            bcf INTCON,INTF
            bsf flags,receive
            movlw Halfcount
            movwf countin
            return

Receive     decfsz countin
            return
            movlw Baudcount
            movwf countin
            rrf shiftin
            bcf shiftin,7
            btfsc PORTB,rxd
            bsf shiftin,7
            decfsz bitin
            return
Received    bcf flags,receive
            bcf INTCON,INTF
            bsf INTCON,INTE
            movf shiftin,W
            movwf buffer
            bsf flags,buf
            return



Send        decfsz countout
            return
            movlw Baudcount
            movwf countout
            movf bitout,W
            xorlw 0x0a
            btfss STATUS,Z
            goto Dataout
            bcf PORTB,txd
            decf bitout
            return

Dataout     btfsc shiftout,0
            bsf PORTB,txd
            btfss shiftout,0
            bcf PORTB,txd
            bsf STATUS,C
            rrf shiftout
            decfsz bitout
            return
            bcf flags,send
            return





;------------------------------I2C part-------------------------------;


;---------------------------------------------------------------------;
;   Support Routines (Open,Close,Write,Read_ack,Read_nack)            ;
;---------------------------------------------------------------------;
; Open:      Opens the I2C bus ,adress=W, LSB of W =R/~W              ;
;            returns tmp1=0 if OK, tmp1=1 if an Nack occured          ;
;                                                                     ;
; Close:     Closes the I2C bus                                       ;
;                                                                     ;
; Write:     Writes the byte in W    to the bus                       ;
;            returns tmp1=0 if OK, tmp1=1 if an Nack occured          ;
;                                                                     ;
; Read_ack   Reads a byte from the bus into tmp1 & generates an       ;
;            acknowledge                                              ;
;                                                                     ;
; Read_nack  Reads a byte from the bus without generating an          ;
;            acknowledge                                              ;
;                                                                     ;
;            Before calling the Open Routine, make sure sda & scl in  ;
;            icport are cleared !!!!!!!!!!                            ;
;                                                                     ;
;            Every routine returns the memorymap to page0             ;
;                                                                     ;
;---------------------------------------------------------------------;
;            Max stack depth used=3 !!!                               ;
;---------------------------------------------------------------------;





Open        PAGE0
            movwf tmp1
            btfsc icport,scl
            goto Norepeat
            PAGE1
            bsf icddr,sda
            call Delay
            call Setclk
            call Delay
Norepeat    PAGE1
            bcf icddr,sda
            call Delay
            bcf icddr,scl
            call Delay
            movf tmp1,W


; Write follows after Open because Open uses Write


Write       movwf tmp1
            movlw 0x08
            movwf tmp2

Sendloop    rlf tmp1
            PAGE1
            bcf icddr,sda
            btfsc STATUS,C
            bsf icddr,sda

            call Delay
            call Setclk
            call Delay
            bcf icddr,scl
            decfsz tmp2
            goto Sendloop

            bsf icddr,sda
            call Setclk
            call Delay
            PAGE0
            btfss icport,sda
            goto Sendsucces
            call Restore
            call Delay
            movlw 0x01
            movwf tmp1
            goto Close
Sendsucces  call Restore
            call Delay
            clrf tmp1
            PAGE0
            return



Read_ack    call Readbyte
            bcf icddr,sda
            goto Retread




Read_nack   call Readbyte

Retread     call Setclk
            call Delay
            bcf icddr,scl
            call Delay
            bcf icddr,sda
            PAGE0
            return




Close       PAGE1
            call Setclk
            call Delay
            bsf icddr,sda
            call Delay
            PAGE0
            return



;  Additional Routines used by the Support routines
;------------------------------------------------------------------


Readbyte    PAGE1
            movlw 0x08
            movwf tmp2
            bsf icddr,sda

Readloop    call Setclk
            call Delay
            bcf STATUS,C
            PAGE0
            btfsc icport,sda
            bsf STATUS,C
            rlf tmp1
            PAGE1
            bcf icddr,scl
            call Delay
            decfsz tmp2
            goto Readloop
            return

Restore     PAGE1
            bcf icddr,scl
            bcf icddr,sda
            return

Delay       nop
            nop
            nop
            nop
            nop
            return


Setclk      bsf icddr,scl
            PAGE0
Setclkloop  btfss icport,scl
            goto Setclkloop
            PAGE1
            return

