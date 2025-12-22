;****************************
;	Main.asm
;
;	Main program
;****************************

	IFND GLOB_DAT
	include <Glob_Dat.i>	;pick up globals
	ENDIF

	CODE	;set PC to next code area

Start:	ldaa Reg_dat.m	;data for hardware
	ldab First.m	;register #
	jsr Output

	ldab Second.m	;reg #
	jsr Output

	ldaa #$FF	;nonsense busy loop
	staa Scratch1	;to use RAM
Loop@:	dec Scratch1
	bne Loop@

	jmp Start	;get the cables, George

;local static data

	DATA		;set PC to next data area
Reg_dat.m: FCB #200	;register data
First.m:	FCB 0		;reg nos.
Second.m: FCB 1

;local dynamic data

	AUTO
	ORG 0	;auto area

Scratch1: RMB BYTE
Scratch2: RMB WORD

	include <Output.asm>
	
	IFND OUTPUT
	include <D_Output.asm>
	ENDIF

	end
