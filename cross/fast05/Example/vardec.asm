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

