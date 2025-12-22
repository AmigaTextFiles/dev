/*
  define.s

  This example shows the way external macros can be used.
  Uros Platise (c) 1999

  You can externally change the value of the SYS_CLK macro.
  Type: 
    ava -DSYS_CLK 		; to set SYS_CLK = 1
  or
    ava -DSYS_CLK=3		; to set SYS_CLK = 3

  This file will link with errors, since label "test_jump" is not defined. 
*/

#arch AT90S1200
	seg flash.code

#ifdef SYS_CLK
	ldi r16, SYS_CLK
#endif

extern test_jump
#ifdef test_jump
	rcall test_jump
#endif
