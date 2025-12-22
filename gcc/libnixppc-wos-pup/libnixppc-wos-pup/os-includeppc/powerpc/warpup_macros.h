#ifndef WARPUP_MACROS_H
#define WARPUP_MACROS_H

#define PPCLIBCALLASM	"\n\
	stwu	1,-32(1)\n\
	mflr	12\n\
	stw	12,28(1)\n\
	mfcr	12\n\
	stw	12,24(1)\n\
	mtlr	0\n\
	blrl\n\
	lwz	12,24(1)\n\
	mtcr	12\n\
	lwz	12,28(1)\n\
	mtlr	12\n\
	la	1,32(1)\n\
	"

#define PPCLP0(base,offs,rt)					\
({								\
	register rt returnreg __asm("3");			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:"=r" (returnreg)					\
	:"r" (dummy)						\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
	returnreg;\
})

#define PPCLP0NR(base,offs)					\
({								\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:							\
	:"r" (dummy)						\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
})

#define PPCLP1(base,offs,rt,t1,r1,v1)				\
({								\
	register rt returnreg __asm("3");			\
	register t1 param1 __asm(#r1)=(v1);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:"=r" (returnreg)					\
	:"r" (dummy),"r" (param1)				\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
	returnreg;\
})

#define PPCLP1NR(base,offs,t1,r1,v1)				\
({								\
	register t1 param1 __asm(#r1)=(v1);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:							\
	:"r" (dummy),"r" (param1)				\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
})

#define PPCLP2(base,offs,rt,t1,r1,v1,t2,r2,v2)			\
({								\
	register rt returnreg __asm("3");			\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:"=r" (returnreg)					\
	:"r" (dummy),"r" (param1),"r" (param2)			\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
	returnreg;\
})

#define PPCLP2NR(base,offs,t1,r1,v1,t2,r2,v2)			\
({								\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:							\
	:"r" (dummy),"r" (param1),"r" (param2)			\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
})

#define PPCLP3(base,offs,rt,t1,r1,v1,t2,r2,v2,t3,r3,v3)		\
({								\
	register rt returnreg __asm("3");			\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:"=r" (returnreg)					\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
	returnreg;\
})

#define PPCLP3NR(base,offs,t1,r1,v1,t2,r2,v2,t3,r3,v3)		\
({								\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:							\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
})

#define PPCLP4(base,offs,rt,t1,r1,v1,t2,r2,v2,t3,r3,v3,t4,r4,v4)\
({								\
	register rt returnreg __asm("3");			\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register t4 param4 __asm(#r4)=(v4);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:"=r" (returnreg)					\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3),"r" (param4)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
	returnreg;\
})

#define PPCLP4NR(base,offs,t1,r1,v1,t2,r2,v2,t3,r3,v3,t4,r4,v4)		\
({								\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register t4 param4 __asm(#r4)=(v4);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:							\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3),"r" (param4)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
})

#define PPCLP5(base,offs,rt,t1,r1,v1,t2,r2,v2,t3,r3,v3,t4,r4,v4,t5,r5,v5)\
({								\
	register rt returnreg __asm("3");			\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register t4 param4 __asm(#r4)=(v4);			\
	register t5 param5 __asm(#r5)=(v5);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:"=r" (returnreg)					\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3),"r" (param4),"r" (param5)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
	returnreg;\
})

#define PPCLP5NR(base,offs,t1,r1,v1,t2,r2,v2,t3,r3,v3,t4,r4,v4,t5,r5,v5)		\
({								\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register t4 param4 __asm(#r4)=(v4);			\
	register t5 param5 __asm(#r5)=(v5);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:							\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3),"r" (param4),"r" (param5)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
})

#define PPCLP6(base,offs,rt,t1,r1,v1,t2,r2,v2,t3,r3,v3,t4,r4,v4,t5,r5,v5,t6,r6,v6)\
({								\
	register rt returnreg __asm("3");			\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register t4 param4 __asm(#r4)=(v4);			\
	register t5 param5 __asm(#r5)=(v5);			\
	register t6 param6 __asm(#r6)=(v6);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:"=r" (returnreg)					\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3),"r" (param4),"r" (param5),"r" (param6)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
	returnreg;\
})

#define PPCLP6NR(base,offs,t1,r1,v1,t2,r2,v2,t3,r3,v3,t4,r4,v4,t5,r5,v5,t6,r6,v6)		\
({								\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register t4 param4 __asm(#r4)=(v4);			\
	register t5 param5 __asm(#r5)=(v5);			\
	register t6 param6 __asm(#r6)=(v6);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:							\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3),"r" (param4),"r" (param5),"r" (param6)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
})

#define PPCLP7(base,offs,rt,t1,r1,v1,t2,r2,v2,t3,r3,v3,t4,r4,v4,t5,r5,v5,t6,r6,v6,t7,r7,v7)\
({								\
	register rt returnreg __asm("3");			\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register t4 param4 __asm(#r4)=(v4);			\
	register t5 param5 __asm(#r5)=(v5);			\
	register t6 param6 __asm(#r6)=(v6);			\
	register t7 param7 __asm(#r7)=(v7);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:"=r" (returnreg)					\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3),"r" (param4),"r" (param5),"r" (param6),"r" (param7)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
	returnreg;\
})

#define PPCLP8NR(base,offs,t1,r1,v1,t2,r2,v2,t3,r3,v3,t4,r4,v4,t5,r5,v5,t6,r6,v6,t7,r7,v7,t8,r8,v8)		\
({								\
	register t1 param1 __asm(#r1)=(v1);			\
	register t2 param2 __asm(#r2)=(v2);			\
	register t3 param3 __asm(#r3)=(v3);			\
	register t4 param4 __asm(#r4)=(v4);			\
	register t5 param5 __asm(#r5)=(v5);			\
	register t6 param6 __asm(#r6)=(v6);			\
	register t7 param7 __asm(#r7)=(v7);			\
	register t8 param8 __asm(#r8)=(v8);			\
	register unsigned long dummy __asm("0") = *(unsigned long *)((char *)base+2+offs); \
	__asm volatile(PPCLIBCALLASM				\
	:							\
	:"r" (dummy),"r" (param1),"r" (param2),"r" (param3),"r" (param4),"r" (param5),"r" (param6),"r" (param7),"r" (param8)	\
	:"0","3","4","5","6","7","8","9","10","11","12","32","33","34","35","36","37","38","39","40","41","42","43","44","45","ctr","memory");\
})

#endif
