#NO_APP
gcc2_compiled.:
___gnu_compiled_c:
.text
	.even
.globl ___builtin_avcall
___builtin_avcall:
	moveml #0x3030,sp@-
	movel sp@(20),a1
	addw #-1076,sp
	movel sp,a2
	moveq #-32,d0
	addl a1@(20),d0
	subl a1,d0
	asrl #2,d0
	clrw d1
	tstl d0
	jle L3
L5:
	movew d1,a0
	movel a1@(32,a0:l:4),a2@(a0:l:4)
	addqw #1,d1
	movew d1,a0
	cmpl a0,d0
	jgt L5
L3:
	moveq #14,d3
	cmpl a1@(12),d3
	jne L6
	movel a1@(8),a1@(1092)
L6:
#APP
	moveml #32764,sp@(1024)			| 0x7ffc == a6-a0/d7-d2
	movel #L7,sp@-
	movel a1@,sp@-
	moveml a1@(1056),#0x7fff		| 0x7fff == a6-a0/d7-d0
	rts
#NO_APP
L7:
#APP
	moveml sp@(1024),#32764
#NO_APP
	addw #1076,sp
	moveq #14,d3
	cmpl a1@(12),d3
	jcs L8
	movel a1@(12),d2
LI49:
	movew pc@(L49-LI49-2:b,d2:l:2),d2
	jmp pc@(2,d2:w)
L49:
	.word L43-L49
	.word L8-L49
	.word L41-L49
	.word L41-L49
	.word L41-L49
	.word L42-L49
	.word L42-L49
	.word L43-L49
	.word L43-L49
	.word L43-L49
	.word L43-L49
	.word L20-L49
	.word L23-L49
	.word L43-L49
	.word L25-L49
L20:
	btst #4,a1@(7)
	jeq L21
	movel a1@(8),a0
	movel d1,sp@-
	movel d0,sp@-
	fmoved sp@+,fp0
	fmoves fp0,a0@
	jra L8
L21:
	movel a1@(8),a0
	movel d0,a0@
	jra L8
L23:
	movel a1@(8),a0
	movel d0,a0@
	movel d1,a0@(4)
	jra L8
L25:
	btst #0,a1@(7)
	jeq L26
	movel a1@(16),d1
	moveq #2,d3
	cmpl d1,d3
	jeq L29
	jcs L37
	moveq #1,d3
	cmpl d1,d3
	jeq L28
	jra L32
L37:
	moveq #4,d3
	cmpl d1,d3
	jeq L30
	moveq #8,d3
	cmpl d1,d3
	jeq L31
	jra L32
L28:
	movel a1@(8),a1
	movel d0,a0
	moveb a0@,a1@
	jra L8
L29:
	movel a1@(8),a1
	movel d0,a0
	movew a0@,a1@
	jra L8
L30:
	movel a1@(8),a1
	movel d0,a0
	movel a0@,a1@
	jra L8
L31:
	movel a1@(8),a0
	movel d0,a2
	movel a2@,a0@
	movel a1@(8),a1
	movew #4,a0
	movel a0@(a2:l),a1@(4)
	jra L8
L32:
	movel a1@(16),d1
	addql #3,d1
	movel d1,d2
	lsrl #2,d2
	subql #1,d2
	jmi L8
L35:
	movel a1@(8),a0
	movel d2,d1
	asll #2,d1
	movel d1,a3
	movel a3@(d0:l),a0@(d2:l:4)
	dbra d2,L35
	clrw d2
	subql #1,d2
	jcc L35
	jra L8
L26:
	btst #0,a1@(6)
	jeq L8
	movel a1@(16),d2
	moveq #2,d3
	cmpl d2,d3
	jeq L42
	jcs L47
	moveq #1,d3
	cmpl d2,d3
	jeq L41
	jra L8
L47:
	moveq #4,d3
	cmpl d2,d3
	jeq L43
	moveq #8,d3
	cmpl d2,d3
	jeq L44
	jra L8
L41:
	movel a1@(8),a0
	moveb d0,a0@
	jra L8
L42:
	movel a1@(8),a0
	movew d0,a0@
	jra L8
L43:
	movel a1@(8),a0
	movel d0,a0@
	jra L8
L44:
	movel a1@(8),a0
	movel d0,a0@
	movel a1@(8),a0
	movel d1,a0@(4)
L8:
	clrl d0
	moveml sp@+,#0xc0c
	rts
