#NO_APP
gcc2_compiled.:
___gnu_compiled_c:
.text
	.even
.globl _vacall
_vacall:
	link a6,#-32
	moveml #0x3030,sp@-
	clrl a6@(-32)
	lea a6@(8),a3
	movel a3,a6@(-28)
	clrl a6@(-24)
	clrl a6@(-20)
	movel a1,a6@(-4)
	pea a6@(-32)
	movel _vacall_function,a2
	jbsr a2@
	addqw #4,sp
	moveq #13,d3
	cmpl a6@(-20),d3
	jcs L2
	movel a6@(-20),d2
LI30:
	movew pc@(L30-LI30-2:b,d2:l:2),d2
	jmp pc@(2,d2:w)
L30:
	.word L2-L30
	.word L4-L30
	.word L5-L30
	.word L6-L30
	.word L7-L30
	.word L8-L30
	.word L12-L30
	.word L12-L30
	.word L11-L30
	.word L12-L30
	.word L13-L30
	.word L16-L30
	.word L17-L30
	.word L18-L30
L4:
L5:
	moveb a6@(-12),d0
	extbl d0
	jra L2
L6:
	clrl d0
	moveb a6@(-12),d0
	jra L2
L7:
	movew a6@(-12),d0
	extl d0
	jra L2
L8:
	clrl d0
	movew a6@(-12),d0
	jra L2
L11:
L12:
	movel a6@(-12),d0
	jra L2
L13:
	btst #4,a6@(-29)
	jeq L14
	fmoves a6@(-12),fp0
	fmoved fp0,sp@-
	movel sp@+,d0
	movel sp@+,d1
	jra L2
L14:
	movel a6@(-12),d0
	jra L2
L16:
	movel a6@(-12),d0
	movel a6@(-8),d1
	jra L2
L17:
	movel a6@(-12),d0
	movel d0,a0
	jra L2
L18:
	btst #0,a6@(-29)
	jeq L19
	movel a6@(-24),d0
	movel d0,a0
	jra L2
L19:
	btst #0,a6@(-30)
	jeq L2
	movel a6@(-16),d2
	moveq #2,d3
	cmpl d2,d3
	jeq L24
	jcs L29
	moveq #1,d3
	cmpl d2,d3
	jeq L23
	jra L2
L29:
	moveq #4,d3
	cmpl d2,d3
	jeq L25
	moveq #8,d3
	cmpl d2,d3
	jeq L26
	jra L2
L23:
	movel a6@(-24),a2
	clrl d0
	moveb a2@,d0
	jra L2
L24:
	movel a6@(-24),a2
	clrl d0
	movew a2@,d0
	jra L2
L25:
	movel a6@(-24),a2
	movel a2@,d0
	jra L2
L26:
	movel a6@(-24),a2
	movel a2@,d0
	movel a2@(4),d1
L2:
	moveml a6@(-48),#0xc0c
	unlk a6
	rts
