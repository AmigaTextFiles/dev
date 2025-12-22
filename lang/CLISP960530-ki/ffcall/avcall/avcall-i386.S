#ifdef UNDERSCORE
#ifdef __STDC__
#define C(entrypoint) _##entrypoint
#else
#define C(entrypoint) _/**/entrypoint
#endif
#else
#define C(entrypoint) entrypoint
#endif
	.file	"avcall-i386.c"
gcc2_compiled.:
C(__gnu_compiled_c:)
.text
	.align 4
.globl C(__builtin_avcall)
C(__builtin_avcall:)
	pushl %ebp
	movl %esp,%ebp
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%esi
	addl $-1024,%esp
	movl 20(%esi),%eax
	addl $-32,%eax
	subl %esi,%eax
	movl %eax,%ecx
	sarl $2,%ecx
	xorl %ebx,%ebx
	cmpl %ecx,%ebx
	jge L3
	movl %esp,%edx
L5:
	movl 32(%esi,%ebx,4),%eax
	movl %eax,(%edx)
	addl $4,%edx
	incl %ebx
	cmpl %ecx,%ebx
	jl L5
L3:
	testb $8,4(%esi)
	je L7
	cmpl $14,12(%esi)
	jne L7
#APP
	movl 8(%esi),%ebx
#NO_APP
L7:
	movl 12(%esi),%eax
	cmpl $11,%eax
	je L9
	cmpl $12,%eax
	je L10
	jmp L11
L9:
	movl (%esi),%eax
	call *%eax
	movl 8(%esi),%eax
	fstps (%eax)
	jmp L13
L10:
	movl (%esi),%eax
	call *%eax
	movl 8(%esi),%eax
	fstpl (%eax)
	jmp L13
L11:
	movl (%esi),%eax
	call *%eax
	movl %eax,%ebx
	cmpl $14,12(%esi)
	ja L13
	movl 12(%esi),%eax
	jmp *L53(,%eax,4)
L53:
	.long L47
	.long L13
	.long L45
	.long L45
	.long L45
	.long L46
	.long L46
	.long L47
	.long L47
	.long L47
	.long L47
	.long L13
	.long L13
	.long L47
	.long L28
L28:
	testb $1,4(%esi)
	je L29
	movl 16(%esi),%eax
	cmpl $2,%eax
	je L32
	ja L41
	cmpl $1,%eax
	je L31
	jmp L35
L41:
	cmpl $4,%eax
	je L33
	cmpl $8,%eax
	je L34
	jmp L35
L31:
	movl 8(%esi),%edx
	movb (%ebx),%al
	movb %al,(%edx)
	jmp L13
L32:
	movl 8(%esi),%edx
	movw (%ebx),%ax
	movw %ax,(%edx)
	jmp L13
L33:
	movl 8(%esi),%edx
	movl (%ebx),%eax
	movl %eax,(%edx)
	jmp L13
L34:
	movl 8(%esi),%edx
	movl (%ebx),%eax
	movl %eax,(%edx)
	movl 8(%esi),%edx
	movl 4(%ebx),%eax
	movl %eax,4(%edx)
	jmp L13
L35:
	movl 16(%esi),%eax
	addl $3,%eax
	movl %eax,%ecx
	shrl $2,%ecx
	decl %ecx
	js L13
	leal (%ebx,%ecx,4),%ebx
L38:
	movl 8(%esi),%edx
	movl (%ebx),%eax
	movl %eax,(%edx,%ecx,4)
	addl $-4,%ebx
	decl %ecx
	jns L38
	jmp L13
L29:
	testb $1,5(%esi)
	je L13
	movl 16(%esi),%eax
	cmpl $2,%eax
	je L46
	ja L51
	cmpl $1,%eax
	je L45
	jmp L13
L51:
	cmpl $4,%eax
	je L47
	cmpl $8,%eax
	je L48
	jmp L13
L45:
	movl 8(%esi),%eax
	movb %bl,(%eax)
	jmp L13
L46:
	movl 8(%esi),%eax
	movw %bx,(%eax)
	jmp L13
L47:
	movl 8(%esi),%eax
	movl %ebx,(%eax)
	jmp L13
L48:
	movl 8(%esi),%eax
	movl %ebx,(%eax)
	movl 8(%esi),%eax
	movl %edx,4(%eax)
L13:
	xorl %eax,%eax
	leal -8(%ebp),%esp
	popl %ebx
	popl %esi
	movl %ebp,%esp
	popl %ebp
	ret
