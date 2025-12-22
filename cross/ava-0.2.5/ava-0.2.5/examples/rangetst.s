/*
  rangetst.s

  Flash Memory Range Test
  Compile with -T option.

  This example fills all the FLASH memory of the AT90S8515.
  4095*2 are filled with zeros plus two bytes for rjmp instruction.
*/

#define SIZE	4095/* remarks can be placed immediatelly after asm*/
#define LSL(x)	(x<<1)

	seg flash.code

start:	ds.b	LSL(SIZE)
	rjmp	start
