
REM Jump.b, a VERY dangerous command!!!
REM Original idea and copyright, (C)2007 B.Walker, G0LCU.
REM For use with the Python_Enhancement project.
REM
REM Usage:-
REM Jump <address><RETURN/ENTER>
REM Where:-
REM 'address' is a 24 bit, decimal equivalent, number.
REM
REM $VER: Jump.b_Version_0_20_00_(C)2007_B.Walker_G0LCU.

REM Set up variables.
REM This is the old softboot RESET address!!!!!
  LET addr$="16515074"
  LET addr&=16515074
  LET n=0

REM Now obtain the correct values.
  LET addr$=ARG$(1)
  LET n=ARGCOUNT
REM If number of arguments is incorrect do a softboot.
  IF n<=0 THEN GOTO reboot:
  IF n>=2 THEN GOTO reboot:

REM Now convert 'ARG$()' to a numerical value.
  LET addr&=VAL(addr$)
REM Ensure an even address!!!
  IF addr&/2=INT(addr&/2) THEN GOTO errorcorrect:
REM If an odd address is detected then do a softboot.
  GOTO reboot:

REM Correct for any errors. ONLY allow a 24 bit address range!!!
errorcorrect:
  IF addr&<=0 THEN LET addr&=0
  IF addr&>=16777212 THEN LET addr&=16777212

REM Now do the CALL/JUMP.
  CALL addr&
REM Cleanup and exit.
  END

REM This is the Commodore OFFICIAL soft-reboot routine!!!
reboot:
ASSEM
	move.l	4,a6			;Pointer to ExecBase.
	lea.l	MagicResetCode(pc),a5	;Location of code to trap.
	jsr	-30(a6)			;_LVOSupervisor mode, do it.
					;
	cnop	0,4			;This is IMPORTANT, longword aligned.
MagicResetCode:				;
	lea.l	2,a0			;Point to JMP instruction in ROM.
	RESET				;Obvious!!!
	jmp	(a0)			;Rely on prefetch to execute this code.
					;
	cnop	0,4			;Same as above.
END ASSEM
