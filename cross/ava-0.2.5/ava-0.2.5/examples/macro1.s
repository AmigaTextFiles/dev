/*
  macro1.s

  Compile with -T option.
 
  Some examples on macro usage.
  Uros Platise (c) 1999
*/

	seg flash.macro_test

extern eks
eks:

#define B 1\+2
\	+3
	*2
#define prsc	-1
#define t1	"asa"
#define NL	10
ha:
plus:

#ifdef B clr r0 #else clr r1
#else clr r9
 ldi r16,B
 ds.b B+(prsc)
 dc.b "test",ha,
      plus,0,NL,t1
 ldi r16,eks 
#endif
