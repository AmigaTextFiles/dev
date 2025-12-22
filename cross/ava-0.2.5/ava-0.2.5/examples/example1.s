/*
  example1.s

  Compile with -T option.

  Simple example of code.
  Uros Platise (c) 1999
*/
	seg removable flash.code

	push r0 push r1 push r2 push r3 push r4
	ldi r16,12<<1
	ldi r16,$100-1
	clr r0

#define p	2
#define q	3

	sts 0,r31
	st Z,r0
	st Z+,r4
	std Z+q,r3
public here:
	ld r2,Z
	ld r3,Z+
	ldd r4,Z+p

	seg eeprom
	ldi r16,0
	 
	seg flash
	brmi here /* this code will be put before flash.code */
