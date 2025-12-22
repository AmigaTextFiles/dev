                .ifndef    POWERPC_PPCMACROS_I
.set     POWERPC_PPCMACROS_I,1

**

                .set _POWERMODE,1
                .ifdef     _POWERMODE

*	.sdreg	r2

                .ifndef    __LOCALSIZE
.set     __LOCALSIZE,1024
                .endif
                .ifndef    local
.set     __LOCAL,r13
.set       local,r13
                .endif
.set        base,r2
.set       stack,r30
.set       trash,r0

**** these register symbols can be used when transferring parameters from
**** 68K to PPC and vice versa

.set         d0,r3
.set         d1,r4
.set         d2,r22
.set         d3,r23
.set         d4,r24
.set         d5,r25
.set         d6,r26
.set         d7,r27
.set         a0,r5
.set         a1,r6
.set         a2,r28
.set         a3,r29
.set         a4,base
.set         a5,r13
.set         a6,r31
.set         a7,stack

.set	codebase,r21	# for OptirE

.set        fp0,f1
.set        fp1,f22
.set        fp2,f23
.set        fp3,f24
.set        fp4,f25
.set        fp5,f26
.set        fp6,f27
.set        fp7,f28

#
# WarpOS PowerPC.library support for pasm
#
# Convertion by AlphaSOUND - Fantaisie Software
#
# Adapted for OptiRE by Marco Antoniazzi in 2006

.macro RUN_PPC
  law     r3,_PowerPCBase
  lwz     r3,0(r3)
  lwz     r0,\1+2(r3)
  mtlr    r0
  blrl
.endm

.set PP_CODE      ,  0   # Ptr to PPC code
.set PP_OFFSET    ,  4   # Offset to PP_CODE
.set PP_FLAGS     ,  8   # flags (see below)
.set PP_STACKPTR  , 12   # stack pointer
.set PP_STACKSIZE , 16   # stack size
.set PP_REGS      , 20   # 15 registers (d0-a6)  - 15*4
.set PP_FREGS     , 80   # 8 registers (fp0-fp7) - 8*8
.set PP_SIZE      ,176   # Theorically 144, but vbcc use 176 so..

# Run68k - Allow launching of regular 68000 sub functions.
#
# Usage: 'RUN68K _DOSBase,-198'
#

.macro RUN_68K
  push a6
  law     a6,\1
  lwz     a6,0(a6)

  subi    a7,a7,PP_SIZE
  stw     d0,PP_REGS(a7)
  stw     d1,PP_REGS+1*4(a7)
  stw     d2,PP_REGS+2*4(a7)   # FIXME: could use stmw ?
  stw     d3,PP_REGS+3*4(a7)
  stw     d4,PP_REGS+4*4(a7)
  stw     d5,PP_REGS+5*4(a7)
  stw     d6,PP_REGS+6*4(a7)
  stw     d7,PP_REGS+7*4(a7)
  stw     a0,PP_REGS+8*4(a7)
  stw     a1,PP_REGS+9*4(a7)
  stw     a2,PP_REGS+10*4(a7)
  stw     a3,PP_REGS+11*4(a7)
  stw     a4,PP_REGS+12*4(a7)
  stw     a5,PP_REGS+13*4(a7)
  stw     a6,PP_REGS+14*4(a7)

  stw     a6,PP_CODE(a7)        # Set the default base...
  li      d0,\2                 # ... and it's offset (ie: -526(a6))
  stw     d0,PP_OFFSET(a7)

  clrw    d0                    # We don't use them, so clear them.
  stw     d0,PP_FLAGS(a7)       #
  stw     d0,PP_STACKPTR(a7)    #
  stw     d0,PP_STACKSIZE(a7)   #
  mr      r4,a7
  RUN_PPC -300                  # Run68K(r3, r4) - BasePtr, PPArgs
  lwz     d0,PP_REGS(a7)        # We only need 'd0'
  addi    a7,a7,PP_SIZE
  pop  a6
.endm

.macro	clrw
	xor	\1,\1,\1
.endm

.macro	setw
	eqv	\1,\1,\1
.endm

.macro	tstw
	mr.	\1,\1
.endm

***********   added for OptiRE  ************
.macro	liw

  	.ifeq	(\2)+1		#=-1
	setw	\1
	.else			#
	 .ifeq	(\2) & 0xFFFF0000	#16bit

	  .ifeq	(\2)		#=0
	clrw	\1
	  .endif
	  .ifne	(\2)		#<>0
	li	\1,\2
	  .endif

	 .else			#32bit
	lis	\1,\2@h
	ori	\1,\1,\2@l

	 .endif
	.endif
.endm
.macro	law			#eg.	law a0,label <=> lea label,a0
	lwz	\1,\2_(base)
.endm
#.macro	law			#eg.	law a0,label <=> lea label,a0
#	addiw	\1,codebase,\2-Base	# Base is start address of code.codebase is register containing it.
#.endm
.macro	push
	stwu	\1,-4(stack)
.endm
.macro	pop
	lwz	\1,0(stack)
	addi	stack,stack,4
.endm
.macro	fpush
	stfsu	\1,-4(stack)
.endm
.macro  fpop
	lfs     \1,0(stack)
	addi    stack,stack,4
.endm
.macro	link
	mflr	r0
	push	r0
	push	\1
	mr	\1,a7
	addi	a7,a7,\2
.endm
.macro	unlk
	mr	a7,\1
	pop	\1
	pop	r0
	mtlr	r0
.endm
.macro	addiw
	.if	(\3) & 0xFFFF0000	#32bit
	addis	\1,\2,\3@ha
	.endif
	addi	\1,\1,\3@l
.endm
.macro	subiw
	addiw	\1,\2,-\3
.endm
.macro	mulliw
	liw	r0,\3
	mullw	\1,\2,r0
.endm
.macro	diviw
	liw	r0,\3
	divw	\1,\2,r0
.endm
.macro	andiw
	.if	(\3) & 0xFFFF0000	#32bit
	liw	r0,\3
	and	\1,\2,r0
	.else
	andi.	\1,\2,\3
	.endif
.endm
.macro	oriw
	.if	(\3) & 0xFFFF0000	#32bit
	liw	r0,\3
	or	\1,\2,r0
	.else
	ori	\1,\2,\3
	.endif
.endm
.macro	scc			#eg. scc lt,d0
	b\1	$+12
	clrw	\2
	b	$+8
	setw	\2
.endm
.macro	cmpiw
	.ifeq	(\2) & 0xFFFF0000	#16bit
	cmpwi	\1,\2
	.else
	liw	r0,\2
	cmpw	\1,r0
	.endif
.endm
.macro	fmovs			#eg.	fmovs	fp0,d0 #convert d0 to float fp0
	lis	r0,0x4330
	stw	r0,-8(a7)
	xoris	r0,\2,0x8000
	stw	r0,-4(a7)
	lfd	f0,-8(a7)
	law	a6,fconv
	lfd	\1,0(a6)
	fsub	\1,f0,\1
.endm
.macro	fmovl			#eg.	fmovl	d0,fp0 #convert fp0 to int. d0
	fctiw	f31,\2
	stfd	f31,-8(a7)
	lwz	\1,-4(a7)
.endm
.macro	fcsd			# convert single->double
	clrw	r0
	stw	r0,-8(a7)
	stfs	\2,-4(a7)
	lfd	\1,-8(a7)
.endm
.macro	fcmps
	fcmpo	0,\1,\2
.endm

***********  end  ************

                .endif

                .endif



