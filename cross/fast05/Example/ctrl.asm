*********************************************************
*                  EXAMPLE CONTROL MODULE               *
*********************************************************

		ORG $0100		;!- C4 ROM starts here 
*		ORG $0160		;!- C8 ROM starts here 

		"COPYRIGHT YOU"

*********************************************************
*                UNUSED VECTORS 			*
*********************************************************

irq_int
swi_int
spi_int		RTI			; unused vectors

*********************************************************
*                   RESET ENTRY 			*
*********************************************************

reset		SEI			; mask interupts

		LDA #$00		; set options register
		STA $1FDF		;!- C4 C8

ctrl_rst				; reset command entry
		SEI			;
		RSP			; reset stack pointer

*********************************************************
*                Configure IO Ports			*
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
*                Open Software Modules			*
*********************************************************

		JSR clk_open		; open clock
		JSR tmr_open		; open timer system
		JSR dbg_open		; open debug port

*********************************************************
*                Main Service Loop    			*
*********************************************************

		CLI			; enable interupts
main_loop				; forever

*********************************************************
*               Functions Called Continiously		*
*********************************************************

		JSR clk_upd		;   update clock

*********************************************************
*               Functions Called Every Second		*
*********************************************************

ml_sec		BBC ClkSEC ml_min	; if new second
		CMB ClkSEC		;   clr sec flag

*********************************************************
*               Functions Called Every Minute		*
*********************************************************

ml_min		BBC ClkMIN ml_dog	; if new minute
		CMB ClkMIN		;   clr min flag

*********************************************************
*               Watch Dog Functions 			*
*********************************************************

ml_dog		BBC TsrTOF ml_loop	; if rollover flag
		LDA Trl			;   clr rollover flag


ml_loop		BRA main_loop		; loop

*********************************************************
* SUB        Enable 1000 hz Timer Interupt              *
*********************************************************
*********************************************************
*							*
*							*
*********************************************************

tmr_open
		LDA #$28		; reset event counter to 40
		STA TmrCnt		;
		SMB TcrOCIE		; enable timer compare int
		CMB TcrTOIE		; kill timer rollover int
		CMB TcrICIE		; kill timer capture int
		RTS

*********************************************************
* INT                TIMER INTERUPT 			*
*********************************************************
*********************************************************
*							*
* This interupt occurs at 500 per sec.			*
* 	  4mhz XTL = 2 mhz cpu clk			*
* 	  => 500 khz timer clock			*
*	  => 500 khz / 1000 = 500 interupts / sec	*
*	  1000 = $03E8					*
*							*
* The interupt simply sets various event flags for      *
* the software modules. To speed up any events simply   *
* increase the interupt rate & use counters to get the  *
* required event rate but must be an exact multiple     *
* of 50hz for the clock                                 *
*							*
*********************************************************

tmr_int
		BBC TsrOCF tmr_exit	; if not tcmp int
					;   do nothing

*********************************************************
*                  Reload Timer                         *
*********************************************************

		LDX TmrLstH		; get last time hi
		LDA TmrLstL		; get last time lo
		ADD #$E8		; compare = last time + 1000
		STA IntRegA		;
		TXA 			;
		ADC #$03		;
		STA Ocrh		; write cmp hi
		STA TmrLstH		; update last time hi
		LDA IntRegA		; write cmp lo and set
		STA Ocrl		;
		STA TmrLstL		; update last time lo

*********************************************************
*                  500 Hz Service                       *
*********************************************************

					; do nothing

*********************************************************
*                 50 Hz Service                         *
*********************************************************

tmr_50		LDA TmrCnt		; timer event count
		DEC A			; -- timer event count
		BNE tmr_exit		; if count zero

		INC ClkInc		;   bump time of day

		LDA #$0A		;   reset count to 10
		STA TmrCnt		;   exit
		RTI			;
tmr_exit	STA TmrCnt		;
		RTI			; exit
