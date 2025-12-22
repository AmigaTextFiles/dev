/*
 * Generate special header files out of our FD-macros.
 */

#define FD0(offset,type,name)\
type __fd_##name(LIBTYPE);^\
%define name##() __fd_##name(LIBBASE)^\

#define FD1(offset,type,name,a1,r1)\
type __fd_##name(LIBTYPE,a1);^\
%define name##(b1) __fd_##name(LIBBASE,b1)^\

#define FD2(offset,type,name,a1,r1,a2,r2)\
type __fd_##name(LIBTYPE,a1,a2);^\
%define name##(b1,b2) __fd_##name(LIBBASE,b1,b2)^\

#define FD3(offset,type,name,a1,r1,a2,r2,a3,r3)\
type __fd_##name(LIBTYPE,a1,a2,a3);^\
%define name##(b1,b2,b3) __fd_##name(LIBBASE,b1,b2,b3)^\

#define FD4(offset,type,name,a1,r1,a2,r2,a3,r3,a4,r4)\
type __fd_##name(LIBTYPE,a1,a2,a3,a4);^\
%define name##(b1,b2,b3,b4) __fd_##name(LIBBASE,b1,b2,b3,b4)^\

#define FD5(offset,type,name,a1,r1,a2,r2,a3,r3,a4,r4,a5,r5)\
type __fd_##name(LIBTYPE,a1,a2,a3,a4,a5);^\
%define name##(b1,b2,b3,b4,b5) __fd_##name(LIBBASE,b1,b2,b3,b4,b5)^\

#define FD0F(offset,flags,type,name)\
type __fd_##name(LIBTYPE);^\
%define name##() __fd_##name(LIBBASE)^\
