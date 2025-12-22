#ifndef FD_LIB_H
#define FD_LIB_H

#define FD0(offset,type,name)\
void __##name(void); \
type ___##name(LIBBASE)

#define FD1(offset,type,name,a1,r1)\
void __##name(void); \
type ___##name(LIBBASE,a1)

#define FD2(offset,type,name,a1,r1,a2,r2)\
void __##name(void); \
type ___##name(LIBBASE,a1,a2)

#define FD3(offset,type,name,a1,r1,a2,r2,a3,r3)\
void __##name(void); \
type ___##name(LIBBASE,a1,a2,a3)

#define FD4(offset,type,name,a1,r1,a2,r2,a3,r3,a4,r4)\
void __##name(void); \
type ___##name(LIBBASE,a1,a2,a3,a4)

#define FD5(offset,type,name,a1,r1,a2,r2,a3,r3,a4,r4,a5,r5)\
void __##name(void); \
type ___##name(LIBBASE,a1,a2,a3,a4,a5)

#define FD0F(offset,flags,type,name)\
void __##name(void); \
type ___##name(LIBBASE)

#define FC0(offset,type,name,r0)\
void __##name(void); \
type name(void *); \
type ___##name(void *_me)

#define FC1(offset,type,name,r0,a1,r1)\
void __##name(void); \
type name(void *,a1); \
type ___##name(void *_me,a1)

#define FC2(offset,type,name,r0,a1,r1,a2,r2)\
void __##name(void); \
type name(void *,a1,a2); \
type ___##name(void *_me,a1,a2)

#define FC3(offset,type,name,r0,a1,r1,a2,r2,a3,r3)\
void __##name(void); \
type name(void *,a1,a2,a3); \
type ___##name(void *_me,a1,a2,a3)

#define FC1F(offset,flags,type,name,r0,a1,r1)\
void __##name(void); \
type name(void *,a1); \
type ___##name(void *_me,a1)

#define FC2F(offset,flags,type,name,r0,a1,r1,a2,r2)\
void __##name(void); \
type name(void *,a1,a2); \
type ___##name(void *_me,a1,a2)

#endif
