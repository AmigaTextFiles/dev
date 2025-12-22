#
#  Chunky 2 Planar routine (C) 2009 Fredrik Wikstrom
#
	.data
	.align 2
c2p_funcs:
	.long c2p_1,c2p_2,c2p_3,c2p_4,c2p_5,c2p_6,c2p_7,c2p_8

	.text
	.align 2
	.global chunky2planar
chunky2planar:
	subi	r1,r1,76
	stmw	r13,0(r1)
	subi	r8,r8,1
	lis		r11,c2p_funcs@ha
	addi	r11,r11,c2p_funcs@l
	slwi	r8,r8,2
	srwi	r6,r6,4
	lwzx	r11,r11,r8
	subi	r10,r4,2
	mtctr	r11
	subi	r3,r3,4
	bctr

	.include "c2p/c2p_1.s"
	.include "c2p/c2p_2.s"
	.include "c2p/c2p_3.s"
	.include "c2p/c2p_4.s"
	.include "c2p/c2p_5.s"
	.include "c2p/c2p_6.s"
	.include "c2p/c2p_7.s"
	.include "c2p/c2p_8.s"
