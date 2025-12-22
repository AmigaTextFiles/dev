*********************************************************
*							*
*		        MINIMON				*
*							*
*    Mini 68HC805C4 Developement System Monitor		*
*    rpc special version				*
*							*
*********************************************************
*********************************************************
*							*
*   Author 	John Salmon				*
*							*
*   Assembler   FAST6805				*
*							*
*   This listing generates a simple monitor for		*
*   developing and testing 68HC805C4 code in circuit.	*
*							*
*   The monitor resides at loc $1060 in EEPROM		*
*							*
*   The monitor communicates with the host computer	*
*   via the serial port at 31250baud. This listing 	*
*   accepts 3 basic commands.				*
*   . $F9 Load Program - reads bytes into ram @ loc     *
*         $50 + then jumps into code @ loc $51    	*
*         1st byte @ $50 = prog size    		*
*         used by pgmIC  command                        *
*   . $FA reserved					*
*   . $FB Read memory - accepts a size byte then a      *
*         2 byte address.                               *
*         read uses locations $F0...$F3                 *
*         used by rv, rm & rpz commands                 *					*
*   . $FC reserved                      		*
*   . $FD reserved                      		*
*   . $FE execute - clr page zero RAM to #$FF then jump *
*         to test code at the "reset" label             *
*         used by the go command                        *					*
*							*
*   The monitor is activated by a hardware reset. It	*
*   then poles the serial port for a valid command	*
*   byte and calls the apropriate subroutine		*
*							*
*   The monitor can be modified to suit the target	*
*   circuit. Look for !!! in the listing.		*  
*							*
*   join this monitor to the end of the code you wish   *
*   to test (insted of the vector table) your code will *
*   need labels for the interupt vectors (see the       *
*   vector table below)                                 *
*							*
*   to eliminate the monitor from the picture just	*
*   change the last vector from #monitor to #reset	*
*							*
*********************************************************

*********************************************************
*		Initalisation				*
*********************************************************

monitor		SEI			;
		RSP			;

*********************************************************
*		Initalise Hardware		!!!	*
*********************************************************
*********************************************************
*							*
* at this point you should set up the chip data		*
* direction registers to suit the particular circuit	*							*
*							*
*********************************************************

		LDA #$00		; disable SPI
		STA $0A			;

		LDA #$00		;
		STA $12			; turn off timer int

*********************************************************
*		Set Up Ports				*
*********************************************************

		LDA PTADEF		; config port A
		STA PtAData		;
		LDA PTADIR		;
		STA PtADir		;

		LDA PTBDEF		; config port B
		STA PtBData		;
		LDA PTBDIR		;
		STA PtBDir		;

		LDA PTCDEF		; config port C
		STA PtCData		;
		LDA PTCDIR		;
		STA PtCDir		;

*********************************************************
*		Initalise Serial			*
*********************************************************

		LDA #$20		; 31250 baud @ 4mhz
		STA $0D			;
		LDA #$00		; 8 data 1 stop
		STA $0E			;
		LDA #$0C		;
		STA $0F			; turn on serial rcv & trans no int

*********************************************************
* 		Monitor Loop				*
*********************************************************

mon_loop	BBC $10.7 mon_loop	; wait for trans mt flag

ml_wait
* put code here for a hardware start
* ig test for button down & branch to ml_go 
		BBC $10.5 ml_wait	; wait for rcv full flag
		LDA $11			; get byte 
		CMP #$FE		; if Execute command
		BNE ml_ramx		;   goto execute
ml_go		JMP execute		;
ml_ramx		CMP #$F9		; if Load Program command
		BNE ml_read		;   goto ram load & execute
		JMP ramx		;
ml_read		CMP #$FB		; if Read command
		BNE mon_loop		;   !!! extend command set here
		JSR read		;   do read memory
		BRA mon_loop		;   loop back for next command

*********************************************************
* JMP	       Jump Into Program @ RESET		*
*********************************************************

execute		LDA #$AA		;
		STA $11			; send reply "OK"
		LDX #$A8		; clear RAM $50 - $F8
		LDA #$FF		;
ex_loop		STA $4F,X		;
		DEC X			;
		BNE ex_loop		;
		JMP reset		; goto test code

*********************************************************
* JMP		Load Prog In Ram & Execute		*
*********************************************************

ramx		LDA #$F0		; send handshake flag
		STA $11			;
		LDX #$00		;
rx_loop		BBC $10.5 rx_loop	; wait for serial recieve flag
		LDA $11			; get byte (1st = byte count)
		STA $50,X		; write ram program byte
		INC X			; if X < byte count
		CPX $50			;    loop
		BLO rx_loop		;
		JMP $51			; goto ram code

*********************************************************
* SUB		Read Memory 				*
*********************************************************
*

read		LDA #$C6		; LDA opcode
		STA $F0			;
		LDA #$81		; RTS opcode
		STA $F3			;

rd_wt1		BBC $10.5 rd_wt1	; wait for serial recieve flag
		LDX $11			; get byte - size
rd_wt2		BBC $10.5 rd_wt2	; wait for serial recieve flag
		LDA $11			; get byte - addr hi
		STA $F1			; set addr hi
rd_wt3		BBC $10.5 rd_wt3	; wait for serial recieve flag
		LDA $11			; get byte - addr lo
		STA $F2			; set addr lo

rd_loop		JSR $F0			; do read
rd_wt0		BBC $10.7 rd_wt0	; wait for trans mt flag
		STA $11			; transmit byte
		DEC X			; --size
		BEQ rd_rtn		; if size not zero
		INC $F2			;   ++ address
		BNE rd_loop		;
		INC $F1			; 
		BRA rd_loop		; else
rd_rtn		RTS			;   return

*********************************************************
* 		Vector Table				*
*********************************************************

		ORG $1FF4		; vector address table

		#spi_int		; SPI interupt
		#ser_int		; SCI interupt
		#tmr_int		; Timer interupt
		#irq_int		; External interupt
		#swi_int		; Software interupt
		#monitor		; reset to monitor


		END

