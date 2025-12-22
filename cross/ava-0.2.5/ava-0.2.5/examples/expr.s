/*
  expr.s

  Compile with -T option.

  expression and conditional operators
  Uros Platise (c) 1999
*/

	seg flash.code
	clr r0
	ldi r16,5*(2==2)-(7*3>2)

