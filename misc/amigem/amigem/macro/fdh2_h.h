/*
 * Generate special header files out of our FD-macros.
 */

#define FD0(offset,type,name)\
type _##name(LIBTYPE);^\
%define name##() _##name(LIBBASE)^\

#define FD1(offset,type,name,a1,r1)\
type _##name(LIBTYPE,a1);^\
%define name##(b1) _##name(LIBBASE,b1)^\

#define FD2(offset,type,name,a1,r1,a2,r2)\
type _##name(LIBTYPE,a1,a2);^\
%define name##(b1,b2) _##name(LIBBASE,b1,b2)^\

#define FD3(offset,type,name,a1,r1,a2,r2,a3,r3)\
type _##name(LIBTYPE,a1,a2,a3);^\
%define name##(b1,b2,b3) _##name(LIBBASE,b1,b2,b3)^\

#define FD4(offset,type,name,a1,r1,a2,r2,a3,r3,a4,r4)\
type _##name(LIBTYPE,a1,a2,a3,a4);^\
%define name##(b1,b2,b3,b4) _##name(LIBBASE,b1,b2,b3,b4)^\

#define FD5(offset,type,name,a1,r1,a2,r2,a3,r3,a4,r4,a5,r5)\
type _##name(LIBTYPE,a1,a2,a3,a4,a5);^\
%define name##(b1,b2,b3,b4,b5) _##name(LIBBASE,b1,b2,b3,b4,b5)^\

#define FD0F(offset,flags,type,name)\
type _##name(LIBTYPE);^\
%define name##() _##name(LIBBASE)^\
