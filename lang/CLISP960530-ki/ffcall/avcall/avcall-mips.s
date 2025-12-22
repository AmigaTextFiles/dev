	.file	1 "avcall-mips.c"
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
	.globl	__builtin_avcall
	.ent	__builtin_avcall
__builtin_avcall:
	.frame	$fp,80,$31		# vars= 40, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$25
	.set	reorder
	subu	$sp,$sp,80
	.cprestore 16
	sw	$31,72($sp)
	sw	$fp,68($sp)
	sw	$28,64($sp)
	move	$fp,$sp
	sw	$4,80($fp)
	addu	$sp,$sp,-1032
	addu	$2,$sp,16
	addu	$3,$2,7
	srl	$2,$3,3
	move	$3,$2
	sll	$4,$3,3
	#.set	volatile
	lw	$2,0($sp)
	#.set	novolatile
	sw	$4,24($fp)
	sw	$sp,28($fp)
	lw	$2,80($fp)
	lw	$3,20($2)
	addu	$2,$3,-48
	lw	$3,80($fp)
	subu	$2,$2,$3
	move	$3,$2
	sra	$2,$3,2
	sw	$2,32($fp)
	lw	$2,80($fp)
	lw	$3,4($2)
	andi	$2,$3,0x0200
	beq	$2,$0,$L2
	lw	$8,80($fp)
 #APP
	l.d $f12,32($8)
 #NO_APP
	lw	$2,80($fp)
	lw	$3,4($2)
	andi	$2,$3,0x0400
	beq	$2,$0,$L3
	lw	$8,80($fp)
 #APP
	l.d $f14,40($8)
 #NO_APP
$L3:
$L2:
	.set	noreorder
	nop
	.set	reorder
	li	$2,0x00000004		# 4
	sw	$2,36($fp)
$L4:
	lw	$2,36($fp)
	lw	$3,32($fp)
	slt	$2,$2,$3
	bne	$2,$0,$L7
	j	$L5
$L7:
	lw	$2,36($fp)
	move	$3,$2
	sll	$2,$3,2
	lw	$3,28($fp)
	addu	$2,$2,$3
	lw	$3,80($fp)
	lw	$4,36($fp)
	move	$5,$4
	sll	$4,$5,2
	addu	$3,$4,$3
	addu	$4,$3,48
	lw	$3,0($4)
	sw	$3,0($2)
$L6:
	lw	$3,36($fp)
	addu	$2,$3,1
	move	$3,$2
	sw	$3,36($fp)
	j	$L4
$L5:
	lw	$2,80($fp)
	lw	$25,0($2)
	lw	$2,80($fp)
	lw	$3,80($fp)
	lw	$6,80($fp)
	lw	$7,80($fp)
	lw	$4,48($2)
	lw	$5,52($3)
	lw	$6,56($6)
	lw	$7,60($7)
	jal	$31,$25
	sw	$2,36($fp)
	lw	$2,80($fp)
	lw	$3,12($2)
	sltu	$4,$3,15
	beq	$4,$0,$L45
	lw	$2,12($2)
	move	$3,$2
	sll	$2,$3,2
	la	$3,$L46
	addu	$2,$2,$3
	lw	$3,0($2)
	.cpadd	$3
	j	$3
	.rdata
	.align	3
$L46:
	.gpword	$L10
	.gpword	$L9
	.gpword	$L11
	.gpword	$L12
	.gpword	$L13
	.gpword	$L14
	.gpword	$L15
	.gpword	$L16
	.gpword	$L17
	.gpword	$L18
	.gpword	$L19
	.gpword	$L20
	.gpword	$L21
	.gpword	$L22
	.gpword	$L23
	.text
$L9:
	j	$L8
$L10:
	lw	$2,80($fp)
	lw	$3,8($2)
	lw	$2,36($fp)
	sw	$2,0($3)
	j	$L8
$L11:
	lw	$2,80($fp)
	lw	$3,8($2)
	lbu	$2,39($fp)
	sb	$2,0($3)
	j	$L8
$L12:
	lw	$2,80($fp)
	lw	$3,8($2)
	lbu	$2,39($fp)
	sb	$2,0($3)
	j	$L8
$L13:
	lw	$2,80($fp)
	lw	$3,8($2)
	lbu	$2,39($fp)
	sb	$2,0($3)
	j	$L8
$L14:
	lw	$2,80($fp)
	lw	$3,8($2)
	lhu	$2,38($fp)
	sh	$2,0($3)
	j	$L8
$L15:
	lw	$2,80($fp)
	lw	$3,8($2)
	lhu	$2,38($fp)
	sh	$2,0($3)
	j	$L8
$L16:
	lw	$2,80($fp)
	lw	$3,8($2)
	lw	$2,36($fp)
	sw	$2,0($3)
	j	$L8
$L17:
	lw	$2,80($fp)
	lw	$3,8($2)
	lw	$2,36($fp)
	sw	$2,0($3)
	j	$L8
$L18:
	lw	$2,80($fp)
	lw	$3,8($2)
	lw	$2,36($fp)
	sw	$2,0($3)
	j	$L8
$L19:
	lw	$2,80($fp)
	lw	$3,8($2)
	lw	$2,36($fp)
	sw	$2,0($3)
	j	$L8
$L20:
	lw	$2,80($fp)
	lw	$3,8($2)
	s.s	$f0,0($3)
	j	$L8
$L21:
	lw	$2,80($fp)
	lw	$3,8($2)
	s.d	$f0,0($3)
	j	$L8
$L22:
	lw	$2,80($fp)
	lw	$3,8($2)
	lw	$2,36($fp)
	sw	$2,0($3)
	j	$L8
$L23:
	lw	$2,80($fp)
	lw	$3,4($2)
	andi	$2,$3,0x0001
	beq	$2,$0,$L24
	lw	$3,80($fp)
	lw	$2,16($3)
	li	$3,0x00000002		# 2
	beq	$2,$3,$L27
	sltu	$3,$2,3
	beq	$3,$0,$L35
	li	$3,0x00000001		# 1
	beq	$2,$3,$L26
	j	$L30
$L35:
	li	$3,0x00000004		# 4
	beq	$2,$3,$L28
	li	$3,0x00000008		# 8
	beq	$2,$3,$L29
	j	$L30
$L26:
	lw	$3,80($fp)
	lw	$2,8($3)
	lw	$3,36($fp)
	lbu	$4,0($3)
	sb	$4,0($2)
	j	$L25
$L27:
	lw	$3,80($fp)
	lw	$2,8($3)
	lw	$3,36($fp)
	lhu	$4,0($3)
	sh	$4,0($2)
	j	$L25
$L28:
	lw	$3,80($fp)
	lw	$2,8($3)
	lw	$3,36($fp)
	lw	$4,0($3)
	sw	$4,0($2)
	j	$L25
$L29:
	lw	$3,80($fp)
	lw	$2,8($3)
	lw	$3,36($fp)
	lw	$4,0($3)
	sw	$4,0($2)
	lw	$2,80($fp)
	lw	$3,8($2)
	addu	$2,$3,4
	lw	$4,36($fp)
	addu	$3,$4,4
	lw	$4,0($3)
	sw	$4,0($2)
	j	$L25
$L30:
	lw	$2,80($fp)
	lw	$3,16($2)
	addu	$2,$3,3
	srl	$3,$2,2
	sw	$3,40($fp)
$L31:
	lw	$3,40($fp)
	addu	$2,$3,-1
	move	$3,$2
	sw	$3,40($fp)
	bgez	$3,$L33
	j	$L32
$L33:
	lw	$2,80($fp)
	lw	$3,40($fp)
	move	$4,$3
	sll	$3,$4,2
	lw	$4,8($2)
	addu	$2,$3,$4
	lw	$3,40($fp)
	move	$4,$3
	sll	$3,$4,2
	lw	$4,36($fp)
	addu	$3,$3,$4
	lw	$4,0($3)
	sw	$4,0($2)
	j	$L31
$L32:
	j	$L25
$L25:
	j	$L36
$L24:
	lw	$2,80($fp)
	lw	$3,4($2)
	andi	$2,$3,0x0002
	beq	$2,$0,$L37
	lw	$3,80($fp)
	lw	$2,16($3)
	li	$3,0x00000002		# 2
	beq	$2,$3,$L40
	sltu	$3,$2,3
	beq	$3,$0,$L44
	li	$3,0x00000001		# 1
	beq	$2,$3,$L39
	j	$L42
$L44:
	li	$3,0x00000004		# 4
	beq	$2,$3,$L41
	j	$L42
$L39:
	lw	$2,80($fp)
	lw	$3,8($2)
	lbu	$2,39($fp)
	sb	$2,0($3)
	j	$L38
$L40:
	lw	$2,80($fp)
	lw	$3,8($2)
	lhu	$2,38($fp)
	sh	$2,0($3)
	j	$L38
$L41:
	lw	$2,80($fp)
	lw	$3,8($2)
	lw	$2,36($fp)
	sw	$2,0($3)
	j	$L38
$L42:
	j	$L38
$L38:
$L37:
$L36:
	j	$L8
$L45:
	j	$L8
$L8:
	move	$2,$0
	j	$L1
$L1:
	move	$sp,$fp			# sp not trusted here
	lw	$31,72($sp)
	lw	$fp,68($sp)
	addu	$sp,$sp,80
	j	$31
	.end	__builtin_avcall
