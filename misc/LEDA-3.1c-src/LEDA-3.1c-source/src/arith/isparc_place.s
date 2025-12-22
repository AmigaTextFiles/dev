gcc2_compiled.:
___gnu_compiled_c:
.text
	.align 4
	.global _veceq
	.proc	04
_veceq:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	cmp %i2,0
	ble,a L7
	mov 1,%i0
	ld [%i1],%g3
L8:
	add %i1,4,%i1
	ld [%i0],%g2
	cmp %g2,%g3
	be L4
	add %i0,4,%i0
	b L7
	mov 0,%i0
L4:
	add %i2,-1,%i2
	cmp %i2,0
	bg,a L8
	ld [%i1],%g3
	mov 1,%i0
L7:
	ret
	restore
	.align 4
	.global _vecgt
	.proc	04
_vecgt:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	sll %i2,2,%g2
	add %i0,%g2,%i0
	cmp %i2,0
	ble L11
	add %i1,%g2,%i1
	add %i0,-4,%i0
L18:
	ld [%i0],%g3
	add %i1,-4,%i1
	ld [%i1],%g2
	cmp %g3,%g2
	bleu L13
	nop
	b L17
	mov 1,%i0
L13:
	blu,a L17
	mov 0,%i0
	add %i2,-1,%i2
	cmp %i2,0
	bg L18
	add %i0,-4,%i0
L11:
	mov 0,%i0
L17:
	ret
	restore
	.align 4
	.global _vecsr1
	.proc	04
_vecsr1:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	sll %i1,2,%g2
	add %i0,%g2,%i0
	cmp %i1,0
	be L21
	mov 0,%g2
L22:
	add %i0,-4,%i0
	ld [%i0],%i2
	srl %i2,1,%g3
	sll %g2,31,%g2
	or %g3,%g2,%g3
	mov %i2,%g2
	addcc %i1,-1,%i1
	bne L22
	st %g3,[%i0]
L21:
	and %i2,1,%i0
	ret
	restore
	.align 4
	.global _vecsri
	.proc	020
_vecsri:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	sll %i1,2,%g2
	add %i0,%g2,%i3
	cmp %i1,0
	be L25
	mov 0,%i4
	mov 32,%g2
	sub %g2,%i2,%i5
L26:
	add %i3,-4,%i3
	ld [%i3],%i0
	srl %i0,%i2,%g3
	sll %i4,%i5,%g2
	or %g3,%g2,%g3
	mov %i0,%i4
	addcc %i1,-1,%i1
	bne L26
	st %g3,[%i3]
L25:
	ret
	restore
	.align 4
	.global _cvadd
	.proc	04
_cvadd:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	cmp %i3,%i4
	ble L28
	mov 0,%o2
	mov %i3,%l0
	cmp %i4,0
	ble L30
	sub %l0,%i4,%i3
L32:
	ld [%i1],%o0
	add %i1,4,%i1
	ld [%i2],%o1
	add %i2,4,%i2
	mov %i0,%o3
	call _PLACEadd,0
	add %i0,4,%i0
	add %i4,-1,%i4
	cmp %i4,0
	bg L32
	mov %o0,%o2
L30:
	cmp %i3,0
	ble L50
	cmp %o2,0
L36:
	ld [%i1],%o0
	add %i1,4,%i1
	mov %i0,%o3
	add %i0,4,%i0
	call _PLACEadd,0
	mov 0,%o1
	add %i3,-1,%i3
	cmp %i3,0
	bg L36
	mov %o0,%o2
	b L50
	cmp %o2,0
L28:
	mov %i4,%l0
	cmp %i3,0
	ble L49
	sub %l0,%i3,%i4
L41:
	ld [%i1],%o0
	add %i1,4,%i1
	ld [%i2],%o1
	add %i2,4,%i2
	mov %i0,%o3
	call _PLACEadd,0
	add %i0,4,%i0
	add %i3,-1,%i3
	cmp %i3,0
	bg L41
	mov %o0,%o2
	b L51
	cmp %i4,0
L45:
	add %i2,4,%i2
	mov %i0,%o3
	add %i0,4,%i0
	call _PLACEadd,0
	mov 0,%o0
	mov %o0,%o2
	add %i4,-1,%i4
L49:
	cmp %i4,0
L51:
	bg,a L45
	ld [%i2],%o1
	cmp %o2,0
L50:
	bne L46
	st %o2,[%i0]
	b L48
	mov %l0,%i0
L46:
	add %l0,1,%i0
L48:
	ret
	restore
	.align 4
	.global _cvsub
	.proc	04
_cvsub:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	mov 0,%o2
	cmp %i4,0
	ble L67
	sub %i3,%i4,%l0
L56:
	ld [%i1],%o0
	add %i1,4,%i1
	ld [%i2],%o1
	add %i2,4,%i2
	mov %i0,%o3
	call _PLACEsub,0
	add %i0,4,%i0
	add %i4,-1,%i4
	cmp %i4,0
	bg L56
	mov %o0,%o2
	b L69
	cmp %o2,0
L59:
	add %i1,4,%i1
	mov %i0,%o3
	add %i0,4,%i0
	call _PLACEsub,0
	mov 0,%o1
	mov %o0,%o2
	add %l0,-1,%l0
L67:
	cmp %o2,0
L69:
	bne,a L59
	ld [%i1],%o0
	cmp %l0,0
	ble,a L68
	add %i0,-4,%i0
L63:
	ld [%i1],%o0
	st %o0,[%i0]
	add %i1,4,%i1
	add %l0,-1,%l0
	cmp %l0,0
	bg L63
	add %i0,4,%i0
	b L68
	add %i0,-4,%i0
L66:
	add %i3,-1,%i3
L68:
	cmp %i3,0
	ble L65
	nop
	ld [%i0],%o0
	cmp %o0,0
	be,a L66
	add %i0,-4,%i0
L65:
	ret
	restore %g0,%i3,%o0
	.align 4
	.global _vecaddto
	.proc	016
_vecaddto:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	cmp %i2,0
	ble L72
	mov 0,%o2
L74:
	ld [%i1],%o1
	add %i1,4,%i1
	ld [%i0],%o0
	call _PLACEadd,0
	mov %i0,%o3
	mov %o0,%o2
	add %i2,-1,%i2
	cmp %i2,0
	bg L74
	add %i0,4,%i0
L72:
	ret
	restore %g0,%o2,%o0
	.align 4
	.global _vecsubto
	.proc	016
_vecsubto:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	cmp %i2,0
	ble L77
	mov 0,%o2
L79:
	ld [%i1],%o1
	add %i1,4,%i1
	ld [%i0],%o0
	call _PLACEsub,0
	mov %i0,%o3
	mov %o0,%o2
	add %i2,-1,%i2
	cmp %i2,0
	bg L79
	add %i0,4,%i0
L77:
	and %o2,1,%i0
	ret
	restore
	.align 4
	.global _vecdiv
	.proc	016
_vecdiv:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	mov 0,%o1
	sll %i3,2,%o0
	add %i0,%o0,%i0
	cmp %i3,0
	ble L82
	add %i1,%o0,%i1
L84:
	add %i1,-4,%i1
	add %i0,-4,%i0
	mov %o1,%o0
	ld [%i1],%o1
	mov %i2,%o2
	call _PLACEdiv,0
	mov %i0,%o3
	add %i3,-1,%i3
	cmp %i3,0
	bg L84
	mov %o0,%o1
L82:
	ret
	restore %g0,%o1,%o0
	.align 4
	.global _vecmul
	.proc	016
_vecmul:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	cmp %i3,0
	ble L87
	mov 0,%o2
L89:
	ld [%i1],%o0
	add %i1,4,%i1
	mov %i0,%o3
	add %i0,4,%i0
	call _PLACEmul,0
	mov %i2,%o1
	add %i3,-1,%i3
	cmp %i3,0
	bg L89
	mov %o0,%o2
L87:
	ret
	restore %g0,%o2,%o0
	.align 4
	.global _vecmulsub
	.proc	016
_vecmulsub:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	cmp %i3,0
	ble L92
	mov 0,%o2
L94:
	ld [%i1],%o0
	add %i1,4,%i1
	mov %i0,%o3
	add %i0,4,%i0
	call _PLACEmulsub,0
	mov %i2,%o1
	add %i3,-1,%i3
	cmp %i3,0
	bg L94
	mov %o0,%o2
L92:
	ld [%i0],%o0
	mov %o2,%o1
	mov 0,%o2
	call _PLACEsub,0
	mov %i0,%o3
	ret
	restore %g0,%o0,%o0
