#NO_APP
gcc2_compiled.:
___gnu_compiled_c:
.text
	.even
.globl ___builtin_avcall
___builtin_avcall:
	moveml #0x3020,sp@-
	movel sp@(16),a2
	addw #-1024,sp
	moveq #-32,d0
	addl a2@(20),d0
	subl a2,d0
	asrl #2,d0
	subl a1,a1
	cmpl a1,d0
	jle L3
	movel sp,a0
L5:
	movel a2@(32,a1:l:4),a0@+
	addqw #1,a1
	cmpl a1,d0
	jgt L5
L3:
	moveq #14,d3
	cmpl a2@(12),d3
	jne L7
#APP
	movel a2@(8),a1
#NO_APP
L7:
	movel a2@,a0
	jbsr a0@
	movel d0,a1
	moveq #14,d3
	cmpl a2@(12),d3
	jcs L8
	movel a2@(12),d2
LI50:
	movew pc@(L50-LI50-2:b,d2:l:2),d2
	jmp pc@(2,d2:w)
L50:
	.word L44-L50
	.word L8-L50
	.word L42-L50
	.word L42-L50
	.word L42-L50
	.word L43-L50
	.word L43-L50
	.word L44-L50
	.word L44-L50
	.word L44-L50
	.word L44-L50
	.word L20-L50
	.word L23-L50
	.word L44-L50
	.word L25-L50
L20:
	btst #4,a2@(7)
	jeq L21
	movel a2@(8),a0
	movel d1,sp@-
	movel d0,sp@-
	fmoved sp@+,fp0
	fmoves fp0,a0@
	jra L8
L21:
	movel a2@(8),a0
	movel d0,a0@
	jra L8
L23:
	movel a2@(8),a0
	movel d0,a0@
	movel d1,a0@(4)
	jra L8
L25:
	btst #0,a2@(7)
	jeq L26
	movel a2@(16),d0
	moveq #2,d3
	cmpl d0,d3
	jeq L29
	jcs L38
	moveq #1,d3
	cmpl d0,d3
	jeq L28
	jra L32
L38:
	moveq #4,d3
	cmpl d0,d3
	jeq L30
	moveq #8,d3
	cmpl d0,d3
	jeq L31
	jra L32
L28:
	movel a2@(8),a0
	moveb a1@,a0@
	jra L8
L29:
	movel a2@(8),a0
	movew a1@,a0@
	jra L8
L30:
	movel a2@(8),a0
	movel a1@,a0@
	jra L8
L31:
	movel a2@(8),a0
	movel a1@,a0@
	movel a2@(8),a0
	movel a1@(4),a0@(4)
	jra L8
L32:
	movel a2@(16),d0
	addql #3,d0
	lsrl #2,d0
	subql #1,d0
	jmi L8
	lea a1@(d0:l:4),a1
L35:
	movel a2@(8),a0
	movel a1@,a0@(d0:l:4)
	subqw #4,a1
	dbra d0,L35
	clrw d0
	subql #1,d0
	jcc L35
	jra L8
L26:
	btst #0,a2@(6)
	jeq L8
	movel a2@(16),d0
	moveq #2,d3
	cmpl d0,d3
	jeq L43
	jcs L48
	moveq #1,d3
	cmpl d0,d3
	jeq L42
	jra L8
L48:
	moveq #4,d3
	cmpl d0,d3
	jeq L44
	moveq #8,d3
	cmpl d0,d3
	jeq L45
	jra L8
L42:
	movel a2@(8),a0
	exg d0,a1
	moveb d0,a0@
	exg d0,a1
	jra L8
L43:
	movel a2@(8),a0
	movew a1,a0@
	jra L8
L44:
	movel a2@(8),a0
	movel a1,a0@
	jra L8
L45:
	movel a2@(8),a0
	movel a1,a0@
	movel a2@(8),a0
	movel d1,a0@(4)
L8:
	addw #1024,sp
	clrl d0
	moveml sp@+,#0x40c
	rts
