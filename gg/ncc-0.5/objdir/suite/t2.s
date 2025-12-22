	.file	"t2.c"
	.version	"01.01"
gcc2_compiled.:
.text
	.align 4
.globl main
	.type	 main,@function
main:
	pushl %ebp
	movl %esp,%ebp
	subl $24,%esp
	movl $1,-8(%ebp)
.L2:
	movl %ebp,%esp
	popl %ebp
	ret
.Lfe1:
	.size	 main,.Lfe1-main
	.ident	"GCC: (GNU) 2.95.2 19991024 (release)"
