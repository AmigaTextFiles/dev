	.file	1 "vacall-mips.c"
	.option pic2

 # GNU C 2.7.0 [AL 1.1, MM 40] SGI running IRIX 5.x compiled by GNU C

 # Cc1 defaults:
 # -mabicalls

 # Cc1 arguments (-G value = 0, Cpu = 3000, ISA = 1):
 # -quiet -dumpbase -o

gcc2_compiled.:
__gnu_compiled_c:
	.text
	.align	2
	.globl	vacall
	.ent	vacall
vacall:
	.frame	$fp,104,$31		# vars= 64, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,104
	.cprestore 16
	sw	$31,96($sp)
	sw	$fp,92($sp)
	sw	$28,88($sp)
	move	$fp,$sp
	sw	$4,104($fp)
	sw	$5,108($fp)
	sw	$6,112($fp)
	sw	$7,116($fp)
	lw	$3,104($fp)
	sw	$3,104($fp)
	lw	$3,108($fp)
	sw	$3,108($fp)
	lw	$3,112($fp)
	sw	$3,112($fp)
	lw	$3,116($fp)
	sw	$3,116($fp)
	s.d	$f12,72($fp)
	s.d	$f14,80($fp)
	s.s	$f12,64($fp)
	s.s	$f14,68($fp)
	sw	$0,24($fp)
	addu	$3,$fp,120
	addu	$4,$3,-16
	sw	$4,28($fp)
	sw	$0,32($fp)
	sw	$0,36($fp)
	addu	$3,$fp,120
	sw	$3,56($fp)
	sw	$0,60($fp)
	lw	$25,vacall_function
	addu	$4,$fp,24
	jal	$31,$25
	lw	$3,36($fp)
	sltu	$4,$3,14
	beq	$4,$0,$L28
	lw	$3,36($fp)
	move	$4,$3
	sll	$3,$4,2
	la	$4,$L27
	addu	$3,$3,$4
	lw	$4,0($3)
	.cpadd	$4
	j	$4
	.rdata
	.align	3
$L27:
	.gpword	$L3
	.gpword	$L4
	.gpword	$L5
	.gpword	$L6
	.gpword	$L7
	.gpword	$L8
	.gpword	$L9
	.gpword	$L10
	.gpword	$L11
	.gpword	$L12
	.gpword	$L13
	.gpword	$L14
	.gpword	$L15
	.gpword	$L16
	.text
$L3:
	j	$L2
$L4:
	lbu	$2,48($fp)
	j	$L2
$L5:
	lb	$2,48($fp)
	j	$L2
$L6:
	lbu	$2,48($fp)
	j	$L2
$L7:
	lh	$2,48($fp)
	j	$L2
$L8:
	lhu	$2,48($fp)
	j	$L2
$L9:
	lw	$2,48($fp)
	j	$L2
$L10:
	lw	$2,48($fp)
	j	$L2
$L11:
	lw	$2,48($fp)
	j	$L2
$L12:
	lw	$2,48($fp)
	j	$L2
$L13:
	l.s	$f0,48($fp)
	j	$L2
$L14:
	l.d	$f0,48($fp)
	j	$L2
$L15:
	lw	$2,48($fp)
	j	$L2
$L16:
	lw	$4,24($fp)
	andi	$3,$4,0x0001
	beq	$3,$0,$L17
	lw	$2,32($fp)
	j	$L18
$L17:
	lw	$4,24($fp)
	andi	$3,$4,0x0002
	beq	$3,$0,$L19
	lw	$3,40($fp)
	li	$4,0x00000002		# 2
	beq	$3,$4,$L22
	sltu	$4,$3,3
	beq	$4,$0,$L26
	li	$4,0x00000001		# 1
	beq	$3,$4,$L21
	j	$L24
$L26:
	li	$4,0x00000004		# 4
	beq	$3,$4,$L23
	j	$L24
$L21:
	lw	$3,32($fp)
	lbu	$2,0($3)
	j	$L20
$L22:
	lw	$3,32($fp)
	lhu	$2,0($3)
	j	$L20
$L23:
	lw	$3,32($fp)
	lw	$2,0($3)
	j	$L20
$L24:
	j	$L20
$L20:
$L19:
$L18:
	j	$L2
$L28:
$L2:
$L1:
	move	$sp,$fp			# sp not trusted here
	lw	$31,96($sp)
	lw	$fp,92($sp)
	addu	$sp,$sp,104
	j	$31
	.end	vacall
