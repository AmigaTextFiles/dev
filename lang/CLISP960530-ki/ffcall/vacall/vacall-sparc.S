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
	.global C(vacall)
	.proc	020
C(vacall:)
	!#PROLOGUE# 0
	save %sp,-144,%sp
	!#PROLOGUE# 1
	st %i0,[%fp+68]
	st %i1,[%fp+72]
	st %i2,[%fp+76]
	st %i3,[%fp+80]
	st %i4,[%fp+84]
	st %i5,[%fp+88]
	st %g0,[%fp-48]
	add %fp,68,%o0
	st %o0,[%fp-44]
	ld [%fp+64],%o0
	st %g0,[%fp-40]
	st %o0,[%fp-16]
	sethi %hi(C(vacall_function)),%o0
	ld [%o0+%lo(C(vacall_function))],%o1
	st %g0,[%fp-36]
	call %o1,0
	add %fp,-48,%o0
	ld [%fp-36],%o0
	cmp %o0,13
	bgu L2
	sethi %hi(L33),%o0
	ld [%fp-36],%o1
	or %o0,%lo(L33),%o0
	sll %o1,2,%o1
	ld [%o1+%o0],%o0
	jmp %o0
	nop
L33:
	.word	L2
	.word	L4
	.word	L5
	.word	L6
	.word	L7
	.word	L8
	.word	L17
	.word	L17
	.word	L17
	.word	L17
	.word	L13
	.word	L16
	.word	L17
	.word	L18
L4:
L5:
	b L2
	ldsb [%fp-24],%i0
L6:
	b L2
	ldub [%fp-24],%i0
L7:
	b L2
	ldsh [%fp-24],%i0
L8:
	b L2
	lduh [%fp-24],%i0
L13:
	ld [%fp-48],%o0
	andcc %o0,16,%g0
	be L14
	ld [%fp-24],%f2
	b L2
	fstod %f2,%f0
L14:
	b L2
	ld [%fp-24],%f0
L16:
	b L2
	ldd [%fp-24],%f0
L17:
	b L2
	ld [%fp-24],%i0
L18:
	ld [%fp-48],%o0
	andcc %o0,8,%g0
	be L19
	ld [%fp-32],%o0
	ld [%i7+8],%o1
	and %o0,4095,%o0
	cmp %o0,%o1
	bne L2
	ld [%fp-40],%i0
	b L2
	add %i7,4,%i7
L19:
	ld [%fp-48],%o0
	andcc %o0,1,%g0
	be L22
	andcc %o0,2,%g0
	b L2
	ld [%fp-40],%i0
L22:
	be L24
	ld [%fp-32],%o0
	cmp %o0,2
	be,a L28
	ld [%fp-40],%o0
	bgu L32
	cmp %o0,1
	be L26
	ld [%fp-40],%o0
	b L2
	add %i7,4,%i7
L32:
	cmp %o0,4
	be L29
	ld [%fp-40],%o0
	b L2
	add %i7,4,%i7
L26:
	b L2
	ldub [%o0],%i0
L28:
	b L2
	lduh [%o0],%i0
L29:
	b L2
	ld [%o0],%i0
L24:
	add %i7,4,%i7
L2:
	ret
	restore
