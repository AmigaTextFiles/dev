gcc2_compiled.:
___gnu_compiled_c:
.text
	.align 4
	.global _karatsuba_mult
	.proc	020
_karatsuba_mult:
	!#PROLOGUE# 0
	save %sp,-112,%sp
	!#PROLOGUE# 1
	cmp %i4,15
	bg L2
	srl %i4,31,%o0
	mov 0,%l0
	cmp %l0,%i4
	bge L27
	nop
L6:
	sll %l0,2,%o0
	add %l0,1,%l0
	cmp %l0,%i4
	bl L6
	st %g0,[%i0+%o0]
	mov 0,%l0
	cmp %l0,%i4
L27:
	bge L1
	nop
L10:
	sll %l0,2,%o2
	add %i0,%o2,%o0
	mov %i1,%o1
	ld [%i2+%o2],%o2
	call _vecmuladd,0
	mov %i4,%o3
	add %l0,%i4,%o1
	sll %o1,2,%o1
	add %l0,1,%l0
	cmp %l0,%i4
	bl L10
	st %o0,[%i0+%o1]
	b,a L1
L2:
	add %i4,%o0,%o0
	sra %o0,1,%l4
	add %i4,%l4,%l3
	sll %i4,2,%o0
	add %i0,%o0,%o0
	mov %i1,%o1
	mov %i2,%o2
	mov %i0,%o3
	call _karatsuba_mult,0
	mov %l4,%o4
	sll %l4,2,%o0
	add %i1,%o0,%l0
	mov %i1,%o0
	mov %l0,%o1
	call _vecgt,0
	mov %l4,%o2
	cmp %o0,0
	be L11
	mov 1,%l1
	mov %i3,%o0
	mov %i1,%o1
	b L25
	mov %l0,%o2
L11:
	mov 0,%l1
	sll %l4,2,%o1
	mov %i3,%o0
	add %i1,%o1,%o1
	mov %i1,%o2
L25:
	call _vecsub,0
	mov %l4,%o3
	sll %l4,2,%l0
	add %i2,%l0,%o0
	mov %i2,%o1
	call _vecgt,0
	mov %l4,%o2
	cmp %o0,0
	be L13
	add %i3,%l0,%o0
	xor %l1,1,%l1
	add %i2,%l0,%o1
	b L26
	mov %i2,%o2
L13:
	sll %l4,2,%o2
	add %i3,%o2,%o0
	mov %i2,%o1
	add %i2,%o2,%o2
L26:
	call _vecsub,0
	mov %l4,%o3
	sll %i4,2,%o0
	sll %l4,2,%l0
	add %i3,%o0,%o0
	mov %i3,%o1
	add %i3,%l0,%o2
	mov %i0,%o3
	call _karatsuba_mult,0
	mov %l4,%o4
	mov %i3,%o0
	add %i1,%l0,%o1
	add %i2,%l0,%o2
	mov %i0,%o3
	call _karatsuba_mult,0
	mov %l4,%o4
	cmp %l1,0
	bne L15
	mov 0,%l0
	cmp %l0,%l4
	bge,a L28
	sll %l4,2,%l0
L19:
	sll %l0,2,%o0
	add %i4,%l0,%o1
	sll %o1,2,%o1
	ld [%i0+%o1],%o1
	add %l0,1,%l0
	cmp %l0,%l4
	bl L19
	st %o1,[%i0+%o0]
	sll %l4,2,%l0
L28:
	sll %l3,2,%l3
	add %i0,%l3,%l1
	sll %i4,2,%o3
	add %i0,%o3,%l2
	st %l4,[%sp+92]
	add %i0,%l0,%o0
	mov %l1,%o1
	mov %l2,%o2
	add %i3,%o3,%o3
	mov %i3,%o4
	call _vecadd4carry,0
	mov 0,%o5
	mov %o0,%o5
	add %i3,%l0,%l0
	st %l4,[%sp+92]
	mov %l2,%o0
	mov %l1,%o1
	add %i3,%l3,%o2
	mov %l0,%o3
	call _vecadd4carry,0
	mov %i3,%o4
	mov %o0,%o5
	mov %l1,%o0
	mov %l0,%o1
	mov %o5,%o2
	call _vecaddPLACE,0
	mov %l4,%o3
	b,a L1
L15:
	cmp %l0,%l4
	bge,a L29
	sll %l4,2,%l0
L24:
	sll %l0,2,%o0
	add %i4,%l0,%o1
	sll %o1,2,%o1
	ld [%i0+%o1],%o1
	add %l0,1,%l0
	cmp %l0,%l4
	bl L24
	st %o1,[%i0+%o0]
	sll %l4,2,%l0
L29:
	sll %l3,2,%l3
	add %i0,%l3,%l1
	sll %i4,2,%o4
	add %i0,%o4,%l2
	st %l4,[%sp+92]
	add %i0,%l0,%o0
	mov %l1,%o1
	mov %l2,%o2
	mov %i3,%o3
	add %i3,%o4,%o4
	call _vecadd3subcarry,0
	mov 0,%o5
	mov %o0,%o5
	add %i3,%l0,%l0
	st %l4,[%sp+92]
	mov %l2,%o0
	mov %l1,%o1
	mov %l0,%o2
	mov %i3,%o3
	call _vecadd3subcarry,0
	add %i3,%l3,%o4
	mov %o0,%o5
	mov %l1,%o0
	mov %l0,%o1
	mov %o5,%o2
	call _vecaddscarry,0
	mov %l4,%o3
L1:
	ret
	restore
	.align 4
	.proc	016
_vecsub:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	cmp %i3,0
	ble L32
	mov 0,%o2
L34:
	ld [%i1],%o0
	add %i1,4,%i1
	ld [%i2],%o1
	add %i2,4,%i2
	mov %i0,%o3
	call _PLACEsub,0
	add %i0,4,%i0
	add %i3,-1,%i3
	cmp %i3,0
	bg L34
	mov %o0,%o2
L32:
	and %o2,1,%i0
	ret
	restore
	.align 4
	.proc	016
_vecadd4carry:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	ld [%fp+92],%l6
	cmp %l6,0
	be L35
	mov %i5,%o0
	ld [%i1],%o1
	mov 0,%o2
	call _PLACEadd,0
	mov %i0,%o3
	mov %o0,%l5
	ld [%i0],%o0
	ld [%i2],%o1
	mov 0,%o2
	call _PLACEadd,0
	mov %i0,%o3
	mov %o0,%l4
	ld [%i0],%o0
	ld [%i3],%o1
	mov 0,%o2
	call _PLACEadd,0
	mov %i0,%o3
	mov %o0,%l3
	ld [%i0],%o0
	ld [%i4],%o1
	mov 0,%o2
	call _PLACEadd,0
	mov %i0,%o3
	mov 1,%i5
	cmp %i5,%l6
	bge L38
	mov %o0,%l2
L40:
	sll %i5,2,%l1
	add %i0,%l1,%l0
	ld [%i1+%l1],%o0
	ld [%i2+%l1],%o1
	mov %l5,%o2
	call _PLACEadd,0
	mov %l0,%o3
	mov %o0,%l5
	ld [%l0],%o0
	ld [%i3+%l1],%o1
	mov %l4,%o2
	call _PLACEadd,0
	mov %l0,%o3
	mov %o0,%l4
	ld [%l0],%o0
	ld [%i4+%l1],%o1
	mov %l3,%o2
	call _PLACEadd,0
	mov %l0,%o3
	mov %o0,%l3
	ld [%l0],%o0
	mov 0,%o1
	mov %l2,%o2
	call _PLACEadd,0
	mov %l0,%o3
	add %i5,1,%i5
	cmp %i5,%l6
	bl L40
	mov %o0,%l2
L38:
	add %l5,%l4,%i0
	add %i0,%l3,%i0
	add %i0,%l2,%i0
L35:
	ret
	restore
	.align 4
	.proc	04
_vecadd3subcarry:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	ld [%fp+92],%l6
	cmp %l6,0
	be L41
	mov %i5,%o0
	cmp %o0,0
	bl L43
	mov 0,%o2
	ld [%i1],%o1
	call _PLACEadd,0
	mov %i0,%o3
	mov %o0,%l5
	ld [%i0],%o0
	ld [%i2],%o1
	mov 0,%o2
	call _PLACEadd,0
	mov %i0,%o3
	mov %o0,%l4
	ld [%i0],%o0
	ld [%i3],%o1
	mov 0,%o2
	call _PLACEadd,0
	mov %i0,%o3
	mov %o0,%l3
	ld [%i0],%o0
	ld [%i4],%o1
	b L49
	mov 0,%o2
L43:
	mov 0,%l5
	ld [%i1],%o0
	ld [%i2],%o1
	call _PLACEadd,0
	mov %i0,%o3
	mov %o0,%l4
	ld [%i0],%o0
	ld [%i3],%o1
	mov 0,%o2
	call _PLACEadd,0
	mov %i0,%o3
	mov %o0,%l3
	ld [%i0],%o0
	ld [%i4],%o1
	mov 1,%o2
L49:
	call _PLACEsub,0
	mov %i0,%o3
	mov 1,%i5
	cmp %i5,%l6
	bge L46
	mov %o0,%l2
L48:
	sll %i5,2,%l1
	add %i0,%l1,%l0
	ld [%i1+%l1],%o0
	ld [%i2+%l1],%o1
	mov %l5,%o2
	call _PLACEadd,0
	mov %l0,%o3
	mov %o0,%l5
	ld [%l0],%o0
	ld [%i3+%l1],%o1
	mov %l4,%o2
	call _PLACEadd,0
	mov %l0,%o3
	mov %o0,%l4
	ld [%l0],%o0
	mov 0,%o1
	mov %l3,%o2
	call _PLACEadd,0
	mov %l0,%o3
	mov %o0,%l3
	ld [%l0],%o0
	ld [%i4+%l1],%o1
	mov %l2,%o2
	call _PLACEsub,0
	mov %l0,%o3
	add %i5,1,%i5
	cmp %i5,%l6
	bl L48
	mov %o0,%l2
L46:
	add %l5,%l4,%i0
	add %i0,%l3,%i0
	sub %i0,%l2,%i0
L41:
	ret
	restore
	.align 4
	.proc	016
_vecaddPLACE:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	cmp %i3,0
	ble L52
	mov %i2,%o1
L54:
	ld [%i1],%o0
	add %i1,4,%i1
	mov %i0,%o3
	add %i0,4,%i0
	call _PLACEadd,0
	mov 0,%o2
	add %i3,-1,%i3
	cmp %i3,0
	bg L54
	mov %o0,%o1
L52:
	ret
	restore %g0,%o1,%o0
	.align 4
	.proc	016
_vecaddscarry:
	!#PROLOGUE# 0
	save %sp,-104,%sp
	!#PROLOGUE# 1
	orcc %i2,%g0,%o0
	bl L56
	cmp %i3,0
	ble L63
	mov %o0,%o2
L60:
	ld [%i1],%o0
	add %i1,4,%i1
	mov %i0,%o3
	add %i0,4,%i0
	mov %o2,%o1
	call _PLACEadd,0
	mov 0,%o2
	add %i3,-1,%i3
	cmp %i3,0
	bg L60
	mov %o0,%o2
	b,a L63
L56:
	ble L63
	mov 1,%o2
L65:
	ld [%i1],%o0
	add %i1,4,%i1
	mov %i0,%o3
	add %i0,4,%i0
	call _PLACEsub,0
	mov 0,%o1
	add %i3,-1,%i3
	cmp %i3,0
	bg L65
	mov %o0,%o2
L63:
	ret
	restore %g0,%o2,%o0
