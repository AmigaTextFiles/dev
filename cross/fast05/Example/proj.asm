*********************************************************
*							*
*                Clock Example				*
*							*
*********************************************************
*********************************************************
*							*
* Author         John Salmon				*
* Revision       0.2					*
* Date           Oct 1996				*
* Copyright	 Hot Chips				*
*							*
*********************************************************

*********************************************************
*							*
* note:   !^ is a clock dependent variable		*
*         !% is a temp test code location		*
*         !# is a buffer size variable			*
*         !- C4 C8 C9 processor				*
*         !@ not yet implemented			*
*							*
*********************************************************

*********************************************************
*							*
*               VARIABLE DECLARATIONS                   * 
*							*
* Note: Page 0 variables declared thus -  Variable	*
*       Constants declared thus        -  CONSTANT	*
*       Bit Fields declared thus       -  FieldBIT	*
*							*
*********************************************************

*********************************************************
*                On Chip Registers			*
*********************************************************

* Hardware Ports
PtAData		$00	; Port A
PtBData		$01	; Port B
PtCData		$02	; Port C
PtDData		$03	; Port D

PtADir		$04	; Port A data dir
PtBDir		$05	; Port A data dir
PtCDir		$06	; Port C data dir C9 chips only
PtDDir		$07	; Port D data dir C9 chips only

Spcr		$0A	; Control Reg
SpiSPR0		$0A.0	;  clock rate 0
SpiSPR1		$0A.1	;  clock rate 1
SpiCPHA		$0A.2	;  clock phase
SpiCPOL		$0A.3	;  clock polarity
SpiMSTR		$0A.4	;  master mode
SpiSPE		$0A.6	;  SPI enable
SpiSPIE		$0A.7	;  interupt enable
Spsr		$0B	;
SpiMODF		$0B.4	; mode fault
SpiWCOL		$0B.6	; write collision
SpiSPIF		$0B.7	; transfer complete
Spdr		$0C	;

* Serial Communications Interface
Baud		$0D	; baud rate
Sccr1		$0E	; control reg 1
ScR8		$0E.7	;   recieve data bit 8
ScT8		$0E.6	;   transmit data bit 8
ScWLEN		$0E.4	;   word length
ScWAKE		$0E.3	;   wake up select
Sccr2		$0F	; control reg 2
ScTIE		$0F.7	;   transmit interupt enable
ScTCIE		$0F.6	;   transmit complete interupt enable
ScRIE		$0F.5	;   reciever interupt enable
ScILIE		$0F.4	;   idle line interupt enable
ScTE		$0F.3	;   transmitter enable
ScRE		$0F.2	;   reciever enable
ScRWU		$0F.1	;   reciever wake up
ScSBK		$0F.0	;   send break

Scsr		$10	; status register
ScTDRE		$10.7	;   transmit data reg empty
ScTC		$10.6	;   transmit complete
ScRDRF		$10.5	;   reciever data reg full
ScIDLE		$10.4	;   idle line detect
ScOR		$10.3	;   overrun
ScNF		$10.2	;   noise
ScFE		$10.1	;   framing error

Scdr		$11	; data register 

* Timer System
Tcr		$12	; control
TcrOLVL		$12.0	;  output level
TcrIEDG		$12.1	;  input edge
TcrTOIE		$12.5	;  timer overflow interupt enable
TcrOCIE		$12.6	;  output compare interupt enable
TcrICIE		$12.7	;  input capture interupt enable
Tsr		$13	; status
TsrTOF		$13.5	;  timer overflow flag
TsrOCF		$13.6	;  output compare flag
TsrICF		$13.7	;  input capture flag
Icrh		$14	; input capture hi
Icrl		$15	; input capture lo
Ocrh		$16	; output compare hi
Ocrl		$17	; output compare lo
Trh		$18	; timer register hi
Trl		$19	; timer register lo
Atrh		$1A	; alternate timer register hi
Atrl		$1B	; alternate timer register lo

* Computer Operating Properly -C8
Coprst		$1D	;
Copcr		$1E	;
CopCOPE		$1E.2	;
CopCME		$1E.3	;
CopCOPF		$1E.4	;

* Extra Registers
RegA		$50	; temporary register - non interupt
RegB		$51	; temporary register 2 - non interupt
IntRegA		$52	; temporary register - interupts
IntRegB		$53	; temporary register - interupts

* Real Time Debugger

COM_RD		#$FB	; read memory
COM_WR		#$FC	; write memory
COM_STP		#$FA	; stop
RPLY_OK		#$AA	; ok reply
RPLY_HS		#$F0	; handshake
OP_RTS		#$81	; RTS opcode
OP_LDA		#$D6	; LDA $####,X opcode
OP_STA		#$D7	; STA $####,X opcode

DbgOpc		$54	; opcode  --
DbgAdHi		$55	; address   | dont move
DbgAdLo		$56	;           | fixed @ $0054
DbgRts		$57	; return  --
DbgCtx		$58	; context switch
DbgSz		$59	; size
DbgIdx		$5A	; index

*********************************************************
*           Default IO Port Configuration               *
*********************************************************

PTADEF		#$00			; port A XXXX 0000
PTADIR		#$CF			;        OOII OOOO

PTBDEF		#$00			; port B XXXX XXXX
PTBDIR		#$C0			;        OOII IIII

PTCDEF		#$80			; port C 1XXX XXXX
PTCDIR		#$FF			;        OOOO OOOO

PTDDEF		#$00			; port D XXXX XXXX
PTDDIR		#$00			;        IIII IIII

*********************************************************
*           Control Module Variables                    *
*********************************************************

* Timer
TmrCnt		$5B	; timer event counter
TmrLstH		$5C	; last time hi for timer reload
TmrLstL		$5D	; last time lo

*********************************************************
*           Clock Module Variables                      *
*********************************************************

ClkInc		$74	; interupt bump
ClkTik		$75	; tick    0..49 ( 1/50th sec)
ClkSec		$76	; seconds 0..59
ClkMin		$77	; minutes 0..59
ClkHrs		$78	; hours   0..24
ClkDay		$79	; day     1..31
ClkMth		$7A	; month   1..12

ClkFlgs		$7B	; clock control flags
ClkSEC		$7B.0	;   second update
ClkMIN		$7B.1	;   minute update

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
*********************************************************
*							*
*                  EXAMPLE CLOCK MODULE                 *
*							*
*********************************************************
*********************************************************
*							*
*							*
*							*
*********************************************************

*********************************************************
* SUB                OPEN CLOCK                         *
*********************************************************

clk_open	JSR clk_rst		; reset clock values
		RTS			;

*********************************************************
* SUB                CLOCK UPDATE                       *
*********************************************************

clk_upd		LDA ClkInc		; if no clock inc
		BNE clk_tik		;   return
		RTS			;

*********************************************************
*                 Bump Clock Tick                       *
*********************************************************

clk_tik		DEC ClkInc		;
		LDA ClkTik		; bump ticks
		INC A			;
		STA ClkTik		;
		CMP #$32		; if ticks < 50
		BHS clk_sec		;   return
		RTS

*********************************************************
*                 Bump Clock Sec                        *
*********************************************************

clk_sec		LDA #$00		;
		STA ClkTik		; zero ticks
		SMB ClkSEC		; set the ctrl sec flag
		LDA ClkSec		; bump seconds
		INC A			;
		CMP #$3C		; if sec < 60
		BHS clk_min		;   return
		STA ClkSec		;
		RTS

*********************************************************
*                 Bump Clock Min                        *
*********************************************************

clk_min		LDA #$00		;
		STA ClkSec		; zero sec
		SMB ClkMIN		; set the ctrl min flag
		LDA ClkMin		; bump min
		INC A			;
		CMP #$3C		; if min < 60
		BHS clk_hrs		;   return
		STA ClkMin		;
		RTS

*********************************************************
*                 Bump Clock Hrs                        *
*********************************************************

clk_hrs		LDA #$00		;
		STA ClkMin		; zero min
		LDA ClkHrs		; bump hrs
		INC A			;
		CMP #$18		; if hrs < 24
		BHS clk_day		;   return
		STA ClkHrs		;
		RTS

*********************************************************
*                 Bump Clock Day                        *
*********************************************************

clk_day		LDA #$00		;
		STA ClkHrs		; zero hrs
		LDA ClkDay		; bump day
		INC A			;
		LDX ClkMth		; look up days in mth
		CMP clk_mth,X		; if =< days in mth
		BHI clk_mth		;   set day
		STA ClkDay		;   return
		RTS

*********************************************************
*                 Bump Clock Month                      *
*********************************************************

clk_mth		LDA #$01		;
		STA ClkDay		; set back day
		LDA ClkMth		; bump mth
		INC A			;
		CMP #$0C		; if mth =< 12
		BHI clk_yr		;   set mth
		STA ClkMth		;   return
		RTS			;
clk_yr		LDA #$01		; else
		STA ClkMth		;   set back mth
		RTS			;   return

*********************************************************
* SUB                RESET CLOCK                        *
*********************************************************

clk_rst		LDA #$00	; zero
		STA ClkInc	; interupt bump
		STA ClkTik	; tick
		STA ClkSec	; seconds
		STA ClkMin	; minutes
		STA ClkHrs	; hours
		STA ClkFlgs	; flags
		LDA #$01	; set 1
		STA ClkDay	; day
		STA ClkMth	; month
		RTS

*********************************************************
* TBL              DAYS IN MONTH                        *
*********************************************************

*		Nul Jan Feb Mar Apr May Jun Jly Aug Sep Oct Nov Dec
* month           0   1   2   3   4   5   6   7   8   9  10  11  12
* days		     31  28  31  30  31  30  31  31  30  31  30  31
clk_dim		$00,$1F,$1C,$1F,$1E,$1F,$1E,$1F,$1F,$1E,$1F,$1E,$1F

*********************************************************
*							*
*		        RTDBUG				*
*							*
*            Real Time 6805 Debuger Module              *
*							*
*********************************************************
*********************************************************
*							*
*   Author 	John Salmon				*
*							*
*   Assembler   FAST6805				*
*							*
*   This listing generates a real time debuger for      *
*   developing and testing 68HC05 code while your       *
*   software is running.                        	*
*							*
*   Add this module to your project to enable the debug *
*   commands rm, cm, rv, cv, rpz and stp                *
*							*
*   Use this module in conjunction with the reset       *
*   monitor						*
*   uses 3 basic command tokens.			*
*   . $FA stop - jumps into monitor                	*
*         used by stp command                           *
*   . $FB Read memory - accepts a size byte then a      *
*         2 byte address.                               *
*         used by rv, rm & rpz commands                 *
*   . $FC Write to memory - accepts a size byte then a  *
*         2 byte address then data bytes                *
*         used by cm & cv commands             		*
*							*
*   This debugger takes control of the serial port.     *
*   so you must debug serial port modules using only    *
*   the reset monitor.                                  *
*							*
*********************************************************


*********************************************************
* SUB		     DEBUG OPEN  			*
*********************************************************

dbg_open

*********************************************************
*		Initalise Variables			*
*********************************************************

		LDA #$00		;
		STA DbgCtx		; context = Command
		STA DbgSz		; data size = 0
		LDA OP_RTS		; set rts opcode
		STA DbgRts		;

*********************************************************
*		Initalise Serial			*
*********************************************************

		LDA #$20		;!^ 31250 baud @ 4mhz  XTL
		STA Baud		;
		LDA #$00		; 8 data 1 stop
		STA Sccr1		;
		LDA #$2C		; 10101100
		STA Sccr2		; rcv int on trans int off
		LDA Scsr		;
		LDA Scdr		; clear flags
		RTS

*********************************************************
* INT		SERIAL INTERUPT ENTRY			*
*********************************************************

ser_int		LDX DbgCtx		; get context
		JMP dbgtbl,x		; on X goto

dbgtbl		JMP dbg_com		; 00 command
		JMP dbg_gsz		; 03 get size
		JMP dbg_gah		; 06 get addr hi
		JMP dbg_gal		; 09 get addr lo
		JMP dbg_rd		; 0C read data
		JMP dbg_wr		; 0F write

*********************************************************
*		Recieve Command			     00	*
*********************************************************

dbg_com		BBS ScRDRF dc_full	; if rcv empty
		CMB ScTIE		;   kill trans interupt
		RTI			;   return
dc_full		LDA Scdr		; get command byte
		CMP COM_STP		; if stop
		BNE dc_rd		;
		LDA RPLY_OK		;   send ok
		STA Scdr		;
		JMP monitor		;   jump to monitor
dc_rd		CMP COM_RD		; if read
		BNE dc_wr		;   
		LDA OP_LDA		;   opcode = read
		STA DbgOpc		;
		LDA #$03		;   context = 03
		STA DbgCtx		;
		RTI

dc_wr		CMP COM_WR		; if write
		BNE dc_nop		;   jump to monitor
		LDA OP_STA		;   opcode = write
		STA DbgOpc		;
		LDA #$03		;   context = 03
		STA DbgCtx		;
		RTI
					
dc_nop		RTI			; else ignore

*********************************************************
*		Get Size		             03	*
*********************************************************

dbg_gsz		BBS ScRDRF dgs_full	; if rcv empty
		CMB ScTIE		;   kill trans interupt
		RTI			;   return
dgs_full	LDA Scdr		; get size byte
		STA DbgSz		; & set
		LDA #$00		; index = 0
		STA DbgIdx		;
		LDA #$06		;   context = 06
		STA DbgCtx		;
		RTI			; return

*********************************************************
*		Get Addr Hi		             06	*
*********************************************************

dbg_gah		BBS ScRDRF dgh_full	; if rcv empty
		CMB ScTIE		;   kill trans interupt
		RTI			;   return
dgh_full	LDA Scdr		; get add hi byte
		STA DbgAdHi		; & set
		LDA #$09		;   context = 09
		STA DbgCtx		;
		RTI			; return

*********************************************************
*		Get Addr Lo		             09	*
*********************************************************

dbg_gal		BBS ScRDRF dgl_full	; if rcv empty
		CMB ScTIE		;   kill trans interupt
		RTI			;   return
dgl_full	LDA Scdr		; get add hi byte
		STA DbgAdLo		; & set

*********************************************************
*		Set Up Read Or Write	             	*
*********************************************************

		LDA DbgOpc		; if opcode = read
		CMP OP_LDA		;
		BNE dgl_wr		;
		SMB ScTIE		;   start trans interupt
		LDA #$0C		;   context = 0C
		STA DbgCtx		;
		RTI			; return

dgl_wr		LDA #$0F		;   context = 0F
		STA DbgCtx		;
		RTI			; return


*********************************************************
*		Read Data		             0C	*
*********************************************************

dbg_rd
		BBS ScTDRE rd_mt	; if tx not empty
		LDA Scdr		;   read byte
		RTI			;   return

rd_mt		LDA DbgSz		;
		BNE dr_next		; if size = 0
		CMB ScTIE		;   kill trans interupt
		LDA #$00		;   return for next command
		STA DbgCtx		;
		RTI			;
					; else more data
dr_next		LDX DbgIdx		;   get index
		JSR $54			;   read byte
		STA Scdr		;   send it
		DEC DbgSz		;   dec size
		INC DbgIdx		;   inc index
		RTI			;   return

*********************************************************
*		Write Data		             0F	*
*********************************************************

dbg_wr		BBS ScRDRF dw_full	; if rcv empty
		CMB ScTIE		;   kill trans interupt
		RTI			;   return

dw_full		LDA DbgSz		;
		BNE dw_next		; if size = 0
		LDA #$00		;   return for next command
		STA DbgCtx		;
		RTI			;
					; else more data
dw_next		LDX DbgIdx		;   get index
		LDA Scdr		;   get data byte
		JSR $54			;   write byte
		DEC DbgSz		;   dec size
		INC DbgIdx		;   inc index
		RTI			;   return

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

