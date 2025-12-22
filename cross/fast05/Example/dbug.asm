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

