#ifdef UNDERSCORE
#ifdef __STDC__
#define C(entrypoint) _##entrypoint
#else
#define C(entrypoint) _/**/entrypoint
#endif
#else
#define C(entrypoint) entrypoint
#endif
gcc2_compiled.:
C(__gnu_compiled_c:)
.text
	.align 4
	.global C(__builtin_avcall)
	.proc	04
C(__builtin_avcall:)
	!#PROLOGUE# 0
	save %sp,-1128,%sp
	!#PROLOGUE# 1
	ld [%i0+12],%o0
	cmp %o0,14
	ld [%i0+20],%o0
	add %sp,68,%o4
	add %o0,-40,%o0
	sub %o0,%i0,%o0
	bne L2
	sra %o0,2,%o3
	ld [%i0+4],%o0
	andcc %o0,8,%g0
	bne L71
	cmp %o3,6
	ld [%i0+8],%o0
	st %o0,[%sp+64]
L2:
	cmp %o3,6
L71:
	ble L4
	add %i0,24,%o1
	mov 24,%o2
	sll %o3,2,%o0
	add %o0,%i0,%o3
L6:
	ld [%o1+40],%o0
	st %o0,[%o2+%o4]
	add %o1,4,%o1
	cmp %o1,%o3
	bl L6
	add %o2,4,%o2
L4:
	ld [%i0+40],%o0
	ld [%i0],%g2
	ld [%i0+44],%o1
	ld [%i0+48],%o2
	ld [%i0+52],%o3
	ld [%i0+56],%o4
	call %g2,0
	ld [%i0+60],%o5
	nop
	ld [%i0+12],%o1
	cmp %o1,14
	bgu L8
	mov %o0,%o3
	sethi %hi(L70),%o0
	or %o0,%lo(L70),%o0
	sll %o1,2,%o1
	ld [%o1+%o0],%o0
	jmp %o0
	nop
L70:
	.word	L65
	.word	L8
	.word	L63
	.word	L63
	.word	L63
	.word	L64
	.word	L64
	.word	L65
	.word	L65
	.word	L65
	.word	L65
	.word	L20
	.word	L23
	.word	L65
	.word	L25
L20:
	ld [%i0+4],%o0
	andcc %o0,16,%g0
	bne,a L21
	fdtos %f0,%f0
L21:
	ld [%i0+8],%o0
	b L8
	st %f0,[%o0]
L23:
	ld [%i0+8],%o0
	b L8
	std %f0,[%o0]
L25:
	ld [%i0+4],%o0
	andcc %o0,8,%g0
	be L26
	andcc %o0,1,%g0
	ld [%i0+16],%o0
	cmp %o0,2
	be,a L29
	ld [%i0+8],%o1
	bgu L45
	cmp %o0,1
	be,a L28
	ld [%i0+8],%o1
	b L72
	andcc %o0,3,%g0
L45:
	cmp %o0,4
	be L30
	cmp %o0,8
	be,a L31
	ld [%i0+8],%o1
	b L32
	ld [%i0+16],%o0
L28:
	ldub [%sp-1],%o0
	b L8
	stb %o0,[%o1]
L29:
	lduh [%sp-2],%o0
	b L8
	sth %o0,[%o1]
L30:
	ld [%i0+8],%o1
	ld [%sp-4],%o0
	b L8
	st %o0,[%o1]
L31:
	ld [%sp-8],%o0
	st %o0,[%o1]
	ld [%i0+8],%o1
	ld [%sp-4],%o0
	b L8
	st %o0,[%o1+4]
L32:
	andcc %o0,3,%g0
L72:
	be L33
	sub %sp,%o0,%o1
	ld [%i0+8],%g2
	cmp %o0,4
	bleu L34
	mov %o0,%o2
	and %o1,-4,%o1
L34:
	cmp %o0,0
	be L73
	mov 0,%i0
L37:
	ldub [%o1],%o0
	addcc %o2,-1,%o2
	stb %o0,[%g2]
	add %o1,1,%o1
	bne L37
	add %g2,1,%g2
	b L73
	mov 0,%i0
L33:
	cmp %o1,%sp
	bgeu L8
	ld [%i0+8],%g2
L42:
	ld [%o1],%o0
	st %o0,[%g2]
	add %o1,4,%o1
	cmp %o1,%sp
	blu L42
	add %g2,4,%g2
	b L73
	mov 0,%i0
L26:
	be L47
	andcc %o0,2,%g0
	ld [%i0+16],%o0
	cmp %o0,2
	be,a L50
	ld [%i0+8],%o1
	bgu L59
	cmp %o0,1
	be,a L49
	ld [%i0+8],%o1
	b L74
	add %o0,3,%o0
L59:
	cmp %o0,4
	be L51
	cmp %o0,8
	be,a L52
	ld [%i0+8],%o1
	b L53
	ld [%i0+16],%o0
L49:
	ldub [%o3],%o0
	b L8
	stb %o0,[%o1]
L50:
	lduh [%o3],%o0
	b L8
	sth %o0,[%o1]
L51:
	ld [%i0+8],%o1
	ld [%o3],%o0
	b L8
	st %o0,[%o1]
L52:
	ld [%o3],%o0
	st %o0,[%o1]
	ld [%i0+8],%o1
	ld [%o3+4],%o0
	b L8
	st %o0,[%o1+4]
L53:
	add %o0,3,%o0
L74:
	srl %o0,2,%o0
	addcc %o0,-1,%o0
	bneg L8
	sll %o0,2,%o2
	ld [%i0+8],%o1
L75:
	ld [%o2+%o3],%o0
	st %o0,[%o1+%o2]
	addcc %o2,-4,%o2
	bpos,a L75
	ld [%i0+8],%o1
	b L73
	mov 0,%i0
L47:
	be,a L73
	mov 0,%i0
	ld [%i0+16],%o0
	cmp %o0,2
	be,a L76
	ld [%i0+8],%o0
	bgu L68
	cmp %o0,1
	be,a L77
	ld [%i0+8],%o0
	b L73
	mov 0,%i0
L68:
	cmp %o0,4
	be,a L78
	ld [%i0+8],%o0
	b L73
	mov 0,%i0
L63:
	ld [%i0+8],%o0
L77:
	b L8
	stb %o3,[%o0]
L64:
	ld [%i0+8],%o0
L76:
	b L8
	sth %o3,[%o0]
L65:
	ld [%i0+8],%o0
L78:
	st %o3,[%o0]
L8:
	mov 0,%i0
L73:
	ret
	restore
