#ifndef __AMIGEM_UTILS_H__
#define __AMIGEM_UTILS_H__
#include <amigem/machine.h>

/*
 * Some more or less useful macros for everybody's free use
 * Some of them are very kludgy, I know :-).
 */

#define NEWLIST(a) \
((a)->lh_Head=(struct Node *)&(a)->lh_Tail, \
 (a)->lh_Tail=NULL, \
 (a)->lh_TailPred=(struct Node *)&(a)->lh_Head)

#define ADDTAIL(a,b) \
((b)->ln_Pred=(a)->lh_TailPred, \
 (b)->ln_Succ=(struct Node *)&(a)->lh_Tail, \
 (a)->lh_TailPred=(b), \
 (b)->ln_Pred->ln_Succ=(b))

/*
 * ALIGN(m,s) aligns memory to 's' boundaries. s must be a power of two.
 *            The compiler can check for this when optimizing.
 * PAD(s1,s2) number of bytes to pad a field of size s1 to be a multiple of size s2.
 */
#ifdef __OPTIMIZE__
extern void *__alignment_breach__; /* Choke for misalignment */
#define ALIGN(m,s) \
((s)&((s)-1)?__alignment_breach__:(void *)(((unsigned long)(m)+((s)-1))&~((s)-1)))
#else
#define ALIGN(m,s)	((void *)(((unsigned long)(m)+((s)-1))&~((s)-1)))
#endif
#define PAD(s1,s2)	((s1)%(s2)?(s2)-(s1)%(s2):0)

/*
 * Set a library's jump vector.
 */
#define MINSETFUNCTION(v,f)	(MINPREPFUNCTION(v),MINGETFUNCTION(v)=(f))

/*
 * You generally can rely on a machine being able to align words to word boundaries
 * and long to long, etc (or otherwise you couldn't use calloc() to get arrays ;-) ).
 * But there are restrictions you may need to know about.
 *
 * This is the usual implementation of the offsetof() macro.
 */
struct ___wordtest { BYTE a;WORD b; }; /* The compiler will insert the needed pad bytes */
struct ___longtest { BYTE a;LONG b; };
#define WORDALIGN	((ULONG)&((struct ___wordtest *)0l)->b)
#define LONGALIGN	((ULONG)&((struct ___longtest *)0l)->b)

/*
 * How to determine the subtask starting stackpointer out of the stackbounds.
 * And how to preallocate some stack for calling subtasks with parameters.
 */
#ifdef STACK_GROWS_UPWARDS
#define STACKPOINTER(a,b) ((UBYTE *)(a)+STACKPOINTEROFFSET)
#define ALLOCONSTACK(s,l) (*(UBYTE **)(s)+=(l),*(UBYTE **)(s)-(l)-STACKPOINTEROFFSET)
#else
#define STACKPOINTER(a,b) ((UBYTE *)(b)+STACKPOINTEROFFSET)
#define ALLOCONSTACK(s,l) (*(UBYTE **)(s)-=(l),*(UBYTE **)(s)-STACKPOINTEROFFSET)
#endif

/*
 * Build a version string out of the name, version, revision and creation date (dd.mm.yy).
 * Get the library id embodied in the version string.
 */
#define	LIB_VERSTRING(n,v,r,d)	"$VER: " n " " #v "." #r " (" d ")\0xa\0xd"
#define LIB_ID(s)		((char *)(s)+6)
#endif
