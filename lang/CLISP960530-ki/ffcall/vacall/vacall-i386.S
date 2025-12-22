#ifdef UNDERSCORE
#ifdef __STDC__
#define C(entrypoint) _##entrypoint
#else
#define C(entrypoint) _/**/entrypoint
#endif
#else
#define C(entrypoint) entrypoint
#endif
	.file	"vacall-i386.c"
gcc2_compiled.:
C(__gnu_compiled_c:)
.text
	.align 4
.globl C(vacall)
C(vacall:)
	subl $32,%esp
	movl $0,(%esp)
	leal 36(%esp),%ecx
	movl %ecx,4(%esp)
	movl $0,8(%esp)
	movl $0,12(%esp)
	movl %ebx,28(%esp)
	movl %esp,%edx
	pushl %edx
	movl C(vacall_function),%edx
	call *%edx
	addl $4,%esp
	cmpl $13,12(%esp)
	ja L2
	movl 12(%esp),%edx
	jmp *L30(,%edx,4)
L30:
	.long L2
	.long L4
	.long L4
	.long L6
	.long L7
	.long L8
	.long L9
	.long L9
	.long L9
	.long L9
	.long L13
	.long L14
	.long L9
	.long L16
L4:
	movsbl 20(%esp),%eax
	addl $32,%esp
	ret
L6:
	movzbl 20(%esp),%eax
	addl $32,%esp
	ret
L7:
	movswl 20(%esp),%eax
	addl $32,%esp
	ret
L8:
	movzwl 20(%esp),%eax
	addl $32,%esp
	ret
L9:
	movl 20(%esp),%eax
	addl $32,%esp
	ret
L13:
	flds 20(%esp)
	addl $32,%esp
	ret
L14:
	fldl 20(%esp)
	addl $32,%esp
	ret
L16:
	testb $1,(%esp)
	je L17
	movl 8(%esp),%eax
	addl $32,%esp
	ret
L17:
	testb $1,1(%esp)
	je L19
	movl 16(%esp),%edx
	cmpl $2,%edx
	je L23
	ja L28
	cmpl $1,%edx
	je L21
	jmp L19
L28:
	cmpl $4,%edx
	je L24
	cmpl $8,%edx
	je L25
	jmp L19
L21:
	movl 8(%esp),%edx
	movzbl (%edx),%eax
	addl $32,%esp
	ret
L23:
	movl 8(%esp),%edx
	movzwl (%edx),%eax
	addl $32,%esp
	ret
L24:
	movl 8(%esp),%edx
	movl (%edx),%eax
	addl $32,%esp
	ret
L25:
	movl 8(%esp),%edx
	movl (%edx),%eax
	movl 4(%edx),%edx
	addl $32,%esp
	ret
L19:
	testb $8,(%esp)
	jne L2
	addl $32,%esp
	ret $4
L2:
	addl $32,%esp
	ret
