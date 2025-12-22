#ifndef FEELIN_MACHINE_H
#define FEELIN_MACHINE_H

/*
**  feelin/machine.h
**
**  Must be included before any other Feelin include.
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 01.07 (2005/12/18)

	[GROG] Fix all _DEFFUNCxxx() macros:  return  value  was  not  taken  in
	account.   Add   some  macros  too.  Add  defaults  for  F_LIB_BASE  and
	F_LIB_STRUCT Fix F_THREAD_xxx() macros.

$VER: 01.06 (2005/08/30)

	Added BIG_ENDIAN_MACHINE macro from [GEOR].

	Added IEXEC, IDOS_, IGRAPHICS, ILAYERS, IINTUITION, IUTILITY, ILOCALE and
	finaly IFEELIN for AmigaOS4 support.

	The name of the  library  base  pointer  parameter  of  F_LIB_INIT()  is
	'SelfBase'  now,  and  no longer F_LIB_BASE. This was necessary to avoid
	protability troubles.

$VER: 01.05 (2005/08/22)

	[GROG] Fix all F_LIB_XXX macros. Fix FC_Thread macros.

$VER: 01.04 (2005/08/09)

	Moved API macros from Feelin:Sources/feelin/Private.h here.

$VER: 01.00 (2005/06/21)

************************************************************************************************/

#define BIG_ENDIAN_MACHINE 1

#ifdef __AROS__
	#include <aros/macros.h>

	#if !AROS_BIG_ENDIAN
		#undef BIG_ENDIAN_MACHINE
		#define BIG_ENDIAN_MACHINE 0
	#endif
#endif

/************************************************************************************************
*** Gates ***************************************************************************************
************************************************************************************************/

#ifdef __MORPHOS__

///Gate macros
#include <emul/emulinterface.h>

#ifndef __GNUC__
#error "This header is designed to be used with GCC only on MorphOS platform."
#endif

#define _GATENAME(name)                         _GTE_##name
#define _GATEPROTO(name)                        const struct EmulLibEntry _GATENAME(name)
#define _MAKEGATE(name, fct)                    _GATEPROTO(name) __attribute__((unused)) = {TRAP_LIB, 0, (APTR) (fct)}
#define _MAKEGATENR(name, fct)                  _GATEPROTO(name) __attribute__((unused)) = {TRAP_LIBNR, 0, (APTR) (fct)}

#define _DEFFUNC0(name, rt) \
	static rt _PPC_##name(void); \
	void _JMP_##name(void) \
	{ register ULONG r3 asm("r3"); \
		_PPC_##name(); REG_D0 = r3; } \
	_MAKEGATE(name, _JMP_##name); \
	rt (*name)(void) __attribute__((unused)) = (APTR) &_GATENAME(name); \
	static rt _PPC_##name(void)

#define _DEFFUNC2(name, rt, r1, t1, v1, r2, t2, v2) \
	static rt _PPC_##name(t1 v1, t2 v2); \
	void _JMP_##name(void) \
	{ register ULONG r3 asm("r3"); \
		_PPC_##name((t1) REG_##r1, (t2) REG_##r2); REG_D0 = r3; } \
	_MAKEGATE(name, _JMP_##name); \
	rt (*name)(t1 v1, t2 v2) __attribute__((unused)) = (APTR) &_GATENAME(name); \
	static rt _PPC_##name(t1 v1, t2 v2)

#define _DEFFUNC2NR(name, r1, t1, v1, r2, t2, v2) \
	static void _PPC_##name(t1 v1, t2 v2); \
	void _JMP_##name(void) \
	{ _PPC_##name((t1) REG_##r1, (t2) REG_##r2); } \
	_MAKEGATENR(name, _JMP_##name); \
	void (*name)(t1 v1, t2 v2) __attribute__((unused)) = (APTR) &_GATENAME(name); \
	static void _PPC_##name(t1 v1, t2 v2)

#define _DEFFUNC3(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3) \
	static rt _PPC_##name(t1 v1, t2 v2, t3 v3); \
	void _JMP_##name(void) \
	{ register ULONG r3 asm("r3"); \
		_PPC_##name((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3); REG_D0 = r3; } \
	_MAKEGATE(name, _JMP_##name); \
	rt (*name)(t1 v1, t2 v2, t3 v3) __attribute__((unused)) = (APTR) &_GATENAME(name); \
	static rt _PPC_##name(t1 v1, t2 v2, t3 v3)

#define _DEFFUNC3NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3) \
	static void _PPC_##name(t1 v1, t2 v2, t3 v3); \
	void _JMP_##name(void) \
	{ _PPC_##name((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3); } \
	_MAKEGATENR(name, _JMP_##name); \
	void (*name)(t1 v1, t2 v2, t3 v3) __attribute__((unused)) = (APTR) &_GATENAME(name); \
	static void _PPC_##name(t1 v1, t2 v2, t3 v3)

#define _DEFFUNC4(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4) \
	static rt _PPC_##name(t1 v1, t2 v2, t3 v3, t4 v4); \
	void _JMP_##name(void) \
	{ register ULONG r3 asm("r3"); \
		_PPC_##name((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (t4) REG_##r4); REG_D0 = r3; } \
	_MAKEGATE(name, _JMP_##name); \
	rt (*name)(t1 v1, t2 v2, t3 v3, t4 v4) __attribute__((unused)) = (APTR) &_GATENAME(name); \
	static rt _PPC_##name(t1 v1, t2 v2, t3 v3, t4 v4)

#define _DEFFUNC4NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4) \
	static void _PPC_##name(t1 v1, t2 v2, t3 v3, t4 v4); \
	void _JMP_##name(void) \
	{ register ULONG r3 asm("r3"); \
		_PPC_##name((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (t4) REG_##r4); } \
	_MAKEGATENR(name, _JMP_##name); \
	void (*name)(t1 v1, t2 v2, t3 v3, t4 v4) __attribute__((unused)) = (APTR) &_GATENAME(name); \
	static void _PPC_##name(t1 v1, t2 v2, t3 v3, t4 v4)
 
#define _DEFFUNC5(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, r5, t5, v5) \
	static rt _PPC_##name(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5); \
	void _JMP_##name(void) \
	{ register ULONG r3 asm("r3"); \
		_PPC_##name((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (t4) REG_##r4, (t5) REG_##r5); REG_D0 = r3; } \
	_MAKEGATE(name, _JMP_##name); \
	rt (*name)(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5) __attribute__((unused)) = (APTR) &_GATENAME(name); \
	static rt _PPC_##name(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5)

#define _LIB_DEFFUNC1(name, rt, r1, t1, v1)     _DEFFUNC2(name, rt, r1, t1, v1, a6, struct FeelinBase *, FeelinBase)
#define _LIB_DEFFUNC1NR(name, r1, t1, v1)       _DEFFUNC2NR(name, r1, t1, v1, a6, struct FeelinBase *, FeelinBase)

#define _LIB_DEFFUNC2NR(name, r1, t1, v1, r2, t2, v2) \
	_DEFFUNC3NR(name, r1, t1, v1, r2, t2, v2, a6, struct FeelinBase *, FeelinBase)

#define _LIB_DEFFUNC3(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3) \
	_DEFFUNC4(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, a6, struct FeelinBase *, FeelinBase)

#define _LIB_DEFFUNC4(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4) \
	_DEFFUNC5(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, a6, struct FeelinBase *, FeelinBase)

//+

/* F_FUNCTION_GATE gives the right function to call between code (or machine
code) */

#define F_FUNCTION_GATE(name)                   ((APTR) &_GATENAME(name))
 
#else

#define F_FUNCTION_GATE(name)                   name

#endif


/************************************************************************************************
*** Libraries ***********************************************************************************
************************************************************************************************/

///library function prototypes

#ifdef __amigaos4__

#define F_LIB_STRUCT_IFACE      struct F_LIB_IFACE *Self

#define LIB_PROTO0(name, rt) rt name(F_LIB_STRUCT_IFACE)
#define LIB_PROTO0NR(name) void name(F_LIB_STRUCT_IFACE)
#define LIB_PROTO1(name, rt, r1, v1) rt name(F_LIB_STRUCT_IFACE, v1)
#define LIB_PROTO1NR(name, r1, v1) void name(F_LIB_STRUCT_IFACE, v1)
#define LIB_PROTO2(name, rt, r1, v1, r2, v2) rt name(F_LIB_STRUCT_IFACE, v1, v2)
#define LIB_PROTO2NR(name, r1, v1, r2, v2) void name(F_LIB_STRUCT_IFACE, v1, v2)
#define LIB_PROTO3(name, rt, r1, v1, r2, v2, r3, v3) rt name(F_LIB_STRUCT_IFACE, v1, v2, v3)
#define LIB_PROTO3NR(name, r1, v1, r2, v2, r3, v3) void name(F_LIB_STRUCT_IFACE, v1, v2, v3)
#define LIB_PROTO4(name, rt, r1, v1, r2, v2, r3, v3, r4, v4) rt name(F_LIB_STRUCT_IFACE, v1, v2, v3, v4)
#define LIB_PROTO4NR(name, r1, v1, r2, v2, r3, v3, r4, v4) void name(F_LIB_STRUCT_IFACE, v1, v2, v3, v4)
#define LIB_PROTO5(name, rt, r1, v1, r2, v2, r3, v3, r4, v4, r5, v5) rt name(F_LIB_STRUCT_IFACE, v1, v2, v3, v4, v5)
#define LIB_PROTO5NR(name, r1, v1, r2, v2, r3, v3, r4, v4, r5, v5) void name(F_LIB_STRUCT_IFACE, v1, v2, v3, v4, v5)
#define LIB_PROTO6(name, rt, r1, v1, r2, v2, r3, v3, r4, v4, r5, v5, r6, v6) rt name(F_LIB_STRUCT_IFACE, v1, v2, v3, v4, v5, v6)
#define LIB_PROTO6NR(name, r1, v1, r2, v2, r3, v3, r4, v4, r5, v5, r6, v6) void name(F_LIB_STRUCT_IFACE, v1, v2, v3, v4, v5, v6)

#else

#define LIB_PROTO0(name, rt) ASM(rt) name(REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO0NR(name) ASM(void) name(REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO1(name, rt, r1, v1) ASM(rt) name(REG(r1, v1), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO1NR(name, r1, v1) ASM(void) name(REG(r1, v1), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO2(name, rt, r1, v1, r2, v2) ASM(rt) name(REG(r1, v1), REG(r2, v2), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO2NR(name, r1, v1, r2, v2) ASM(void) name(REG(r1, v1), REG(r2, v2), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO3(name, rt, r1, v1, r2, v2, r3, v3) ASM(rt) name(REG(r1, v1), REG(r2, v2), REG(r3, v3), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO3NR(name, r1, v1, r2, v2, r3, v3) ASM(void) name(REG(r1, v1), REG(r2, v2), REG(r3, v3), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO4(name, rt, r1, v1, r2, v2, r3, v3, r4, v4) ASM(rt) name(REG(r1, v1), REG(r2, v2), REG(r3, v3), REG(r4, v4), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO4NR(name, r1, v1, r2, v2, r3, v3, r4, v4) ASM(void) name(REG(r1, v1), REG(r2, v2), REG(r3, v3), REG(r4, v4), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO5(name, rt, r1, v1, r2, v2, r3, v3, r4, v4, r5, v5) ASM(rt) name(REG(r1, v1), REG(r2, v2), REG(r3, v3), REG(r4, v4), REG(r5, v5), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO5NR(name, r1, v1, r2, v2, r3, v3, r4, v4, r5, v5) ASM(void) name(REG(r1, v1), REG(r2, v2), REG(r3, v3), REG(r4, v4), REG(r5, v5), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO6(name, rt, r1, v1, r2, v2, r3, v3, r4, v4, r5, v5, r6, v6) ASM(rt) name(REG(r1, v1), REG(r2, v2), REG(r3, v3), REG(r4, v4), REG(r5, v5), REG(r6, v6), REG(a6, F_LIB_STRUCT *F_LIB_BASE))
#define LIB_PROTO6NR(name, r1, v1, r2, v2, r3, v3, r4, v4, r5, v5, r6, v6) ASM(void) name(REG(r1, v1), REG(r2, v2), REG(r3, v3), REG(r4, v4), REG(r5, v5), REG(r6, v6), REG(a6, F_LIB_STRUCT *F_LIB_BASE))

#endif


#ifdef __MORPHOS__

#define LIB_DEFFUNC0(name, rt) \
		static rt name##_PPC(F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO0(name, rt) { rt rc; \
				rc = name##_PPC((APTR)REG_A6); \
				REG_D0 = (uint32) rc; return rc; } \
		static rt name##_PPC(F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC0NR(name) \
		static void name##_PPC(F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO0NR(name) {name##_PPC((APTR)REG_A6);} \
		static void name##_PPC(F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC1(name, rt, r1, t1, v1) \
		static rt name##_PPC(t1 v1, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO1(name, rt, r1, t1 v1) { rt rc; \
				rc = name##_PPC((t1) REG_##r1, (APTR)REG_A6); \
				REG_D0 = (uint32) rc; return rc; } \
		static rt name##_PPC(t1 v1, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC1NR(name, r1, t1, v1) \
		static void name##_PPC(t1 v1, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO1NR(name, r1, t1 v1) { \
				name##_PPC((t1) REG_##r1, (APTR)REG_A6); } \
		static void name##_PPC(t1 v1, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC2(name, rt, r1, t1, v1, r2, t2, v2) \
		static rt name##_PPC(t1 v1, t2 v2, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO2(name, rt, r1, t1 v1, r2, t2 v2) { rt rc; \
				rc = name##_PPC((t1) REG_##r1, (t2) REG_##r2, (APTR)REG_A6); \
				REG_D0 = (uint32) rc; return rc; } \
		static rt name##_PPC(t1 v1, t2 v2, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC2NR(name, r1, t1, v1, r2, t2, v2) \
		static void name##_PPC(t1 v1, t2 v2, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO2NR(name, r1, t1 v1, r2, t2 v2) { \
				name##_PPC((t1) REG_##r1, (t2) REG_##r2, (APTR)REG_A6); } \
		static void name##_PPC(t1 v1, t2 v2, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC3(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3) \
		static rt name##_PPC(t1 v1, t2 v2, t3 v3, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO3(name, rt, r1, t1 v1, r2, t2 v2, r3, t3 v3) { rt rc; \
				rc = name##_PPC((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (APTR)REG_A6); \
				REG_D0 = (uint32) rc; return rc; } \
		static rt name##_PPC(t1 v1, t2 v2, t3 v3, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC3NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3) \
		static void name##_PPC(t1 v1, t2 v2, t3 v3, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO3NR(name, r1, t1 v1, r2, t2 v2, r3, t3 v3) { \
				name##_PPC((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (APTR)REG_A6); } \
		static void name##_PPC(t1 v1, t2 v2, t3 v3, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC4(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4) \
		static rt name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO4(name, rt, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4) { rt rc; \
				rc = name##_PPC((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (t4) REG_##r4, (APTR)REG_A6); \
				REG_D0 = (uint32) rc; return rc; } \
		static rt name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC4NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4) \
		static void name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO4NR(name, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4) { \
				name##_PPC((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (t4) REG_##r4, (APTR)REG_A6); } \
		static void name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC5(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, r5, t5, v5) \
		static rt name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO5(name, rt, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4, r5, t5 v5) { rt rc; \
				rc = name##_PPC((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (t4) REG_##r4, (t5) REG_##r5, (APTR)REG_A6); \
				REG_D0 = (uint32) rc; return rc; } \
		static rt name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC5NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, r5, t5, v5) \
		static void name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO5NR(name, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4, r5, t5 v5) { \
				name##_PPC((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (t4) REG_##r4, (t5) REG_##r5, (APTR)REG_A6); } \
		static void name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC6(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, r5, t5, v5, r6, t6, v6) \
		static rt name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5, t6 v6, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO6(name, rt, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4, r5, t5 v5, r6, t6 v6) { rt rc; \
				rc = name##_PPC((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (t4) REG_##r4, (t5) REG_##r5, (t6) REG_##r6, (APTR)REG_A6); \
				REG_D0 = (uint32) rc; return rc; } \
		static rt name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5, t6 v6, F_LIB_STRUCT *F_LIB_BASE)

#define LIB_DEFFUNC6NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, r5, t5, v5, r6, t6, v6) \
		static void name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5, t6 v6, F_LIB_STRUCT *F_LIB_BASE); \
		LIB_PROTO6NR(name, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4, r5, t5 v5, r6, t6 v6) { \
				name##_PPC((t1) REG_##r1, (t2) REG_##r2, (t3) REG_##r3, (t4) REG_##r4, (t5) REG_##r5, (t6) REG_##r6, (APTR)REG_A6); } \
		static void name##_PPC(t1 v1, t2 v2, t3 v3, t4 v4, t5 v5, t6 v6, F_LIB_STRUCT *F_LIB_BASE)

#else /* !__MORPHOS__ */

#define LIB_DEFFUNC0(name, rt) LIB_PROTO0(name, rt)
#define LIB_DEFFUNC0NR(name) LIB_PROTO0NR(name)
#define LIB_DEFFUNC1(name, rt, r1, t1, v1) LIB_PROTO1(name, rt, r1, t1 v1)
#define LIB_DEFFUNC1NR(name, r1, t1, v1) LIB_PROTO1NR(name, r1, t1 v1)
#define LIB_DEFFUNC2(name, rt, r1, t1, v1, r2, t2, v2) LIB_PROTO2(name, rt, r1, t1 v1, r2, t2 v2)
#define LIB_DEFFUNC2NR(name, r1, t1, v1, r2, t2, v2) LIB_PROTO2NR(name, r1, t1 v1, r2, t2 v2)
#define LIB_DEFFUNC3(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3) LIB_PROTO3(name, rt, r1, t1 v1, r2, t2 v2, r3, t3 v3)
#define LIB_DEFFUNC3NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3) LIB_PROTO3NR(name, r1, t1 v1, r2, t2 v2, r3, t3 v3)
#define LIB_DEFFUNC4(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4) LIB_PROTO4(name, rt, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4)
#define LIB_DEFFUNC4NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4) LIB_PROTO4NR(name, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4)
#define LIB_DEFFUNC5(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, r5, t5, v5) LIB_PROTO5(name, rt, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4, r5, t5 v5)
#define LIB_DEFFUNC5NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, r5, t5, v5) LIB_PROTO5NR(name, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4, r5, t5 v5)
#define LIB_DEFFUNC6(name, rt, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, r5, t5, v5, r6, t6, v6) LIB_PROTO6(name, rt, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4, r5, t5 v5, r6, t6 v6)
#define LIB_DEFFUNC6NR(name, r1, t1, v1, r2, t2, v2, r3, t3, v3, r4, t4, v4, r5, t5, v5, r6, t6, v6) LIB_PROTO6NR(name, r1, t1 v1, r2, t2 v2, r3, t3 v3, r4, t4 v4, r5, t5 v5, r6, t6 v6)

#endif
//+

///FC_Object

#if defined(__MORPHOS__)

#define F_HOOK_PROTO(rt,name)                   _GATEPROTO(name); \
												extern rt (*name)( \
													struct Hook * Hook, \
													FObject Obj, \
													uint32 * Msg) __attribute__((unused))

#define F_HOOK(rt,name)                         _DEFFUNC3(name, rt, \
													a0, struct Hook *, Hook, \
													a2, FObject, Obj, \
													a1, uint32 *, Msg)

#define F_HOOKM_PROTO(rt,name,sn)               _GATEPROTO(name) ;\
												extern rt (*name)( \
													struct Hook * Hook, \
													FObject Obj, \
													struct sn * Msg) __attribute__((unused))

#define F_HOOKM(rt,name,sn)                     _DEFFUNC3(name, rt, \
													a0, struct Hook *, Hook, \
													a2, FObject, Obj, \
													a1, struct sn *, Msg)

#elif defined(__amigaos4__) /*** Amiga OS4   ***************************************************/

#define F_HOOK(rc,name)                         rc name(struct Hook *Hook, FObject Obj, uint32 *Msg)
#define F_HOOKM(rc,name,sn)                     rc name(struct Hook *Hook, FObject Obj, struct sn *Msg)
#define F_HOOK_PROTO(rc,name)                   F_HOOK(rc,name)
#define F_HOOKM_PROTO(rc,name,sn)               F_HOOKM(rc,name,sn)

#else /*** classic *****************************************************************************/
 
#define F_HOOK(rc,name)                         SAVEDS ASM(rc) name(REG(a0,struct Hook *Hook),REG(a2,FObject Obj),REG(a1,uint32 *Msg))
#define F_HOOKM(rc,name,sn)                     SAVEDS ASM(rc) name(REG(a0,struct Hook *Hook),REG(a2,FObject Obj),REG(a1,struct sn *Msg))
#define F_HOOK_PROTO(rc,name)                   F_HOOK(rc,name)
#define F_HOOKM_PROTO(rc,name,sn)               F_HOOKM(rc,name,sn)

#endif

//+
///FC_Class

#if defined(__MORPHOS__)

/* Macro to be used to declare and define an object method */

#define F_METHOD_PROTO(rt,name)                 _GATEPROTO(name)
#define F_METHOD(rt,name)                       _LIB_DEFFUNC4(name, rt, \
												   a2, FClass *, Class, \
												   a0, FObject, Obj, \
												   d0, uint32, Method, \
												   a1, APTR, Msg)

/* Macro to be used to declare and define an object method, with a specific
type for Msg variable */

#define F_METHODM_PROTO(rt,name,sn)             _GATEPROTO(name)
#define F_METHODM(rt,name,sn)                   _LIB_DEFFUNC4(name, rt, \
												   a2, FClass *, Class, \
												   a0, FObject, Obj, \
												   d0, uint32, Method, \
												   a1, struct sn*, Msg)
												   
/* Macro to call a method (static in file or extern */

#define F_CALL_STATIC_METHOD(name, cl, obj, mth, msg, base) _PPC_##name(cl, obj, mth, msg, base)
#define F_CALL_EXTERN_METHOD(name, cl, obj, mth, msg, base) ({ \
												   REG_D0 = (uint32) (mth); \
												   REG_A0 = (uint32) (obj); \
												   REG_A1 = (uint32) (msg); \
												   REG_A2 = (uint32) (cl); \
												   REG_A6 = (uint32) (base); \
												   (*MyEmulHandle->EmulCallDirect68k)(name); })
 
#elif defined(__amigaos4__) /*** Amiga OS4   ********************************/

#define F_METHOD(rt,name)                       rt name(FClass *Class, FObject Obj, uint32 Method, APTR Msg)
#define F_METHOD_PROTO(rt,name)                 F_METHOD(rt,name)
#define F_METHODM(rt,name,sn)                   rt name(FClass *Class, FObject Obj, uint32 Method, struct sn *Msg)
#define F_METHODM_PROTO(rt,name,sn)             F_METHODM(rt,name,struct sn *)

#define F_CALL_EXTERN_METHOD(name, cl, obj, mth, msg, base) name(cl, obj, mth, msg)
#define F_CALL_STATIC_METHOD(name, cl, obj, mth, msg, base) F_CALL_EXTERN_METHOD(name, cl, obj, mth, msg, base)

#else /*** classic *********************************************************/

#define F_METHOD(rt,name)                       SAVEDS ASM(rt) name(REG(a2,FClass *Class),REG(a0,FObject Obj),REG(d0,uint32 Method),REG(a1,APTR Msg),REG(a6,struct FeelinBase *FeelinBase))
#define F_METHOD_PROTO(rt,name)                 F_METHOD(rt,name)
#define F_METHODM(rt,name,sn)                   SAVEDS ASM(rt) name(REG(a2,FClass *Class),REG(a0,FObject Obj),REG(d0,uint32 Method),REG(a1,struct sn *Msg),REG(a6,struct FeelinBase *FeelinBase))
#define F_METHODM_PROTO(rt,name,sn)             F_METHODM(rt,name,struct sn *)

#define F_CALL_EXTERN_METHOD(name, cl, obj, mth, msg, base) name(cl, obj, mth, msg, base)
#define F_CALL_STATIC_METHOD(name, cl, obj, mth, msg, base) F_CALL_EXTERN_METHOD(name, cl, obj, mth, msg, base)

#endif

#define F_QUERY_PROTO()                         struct TagItem * feelin_auto_class_query(uint32 Which)
#define F_QUERY()                               F_QUERY_PROTO()
#define F_QUERY_CALL(which)                     feelin_auto_class_query(which)

//+

/* FIXME:

GOFROMIEL @ HOMBRE: Bon je crois que j'ai eu  la  plus  mauvaise  des  idées
depuis  l'invention  du "papier cul en laine de verre" en mettant FeelinBase
partout comme un sauvage... surtout que ça ne me sert même plus pour 68k  vu
que  j'utilise  des  variable  globales partout... sauf dans feelin.library.
Faut que je m'en occupe et que je vire  tout  ça,  comme  ça  on  sera  tous
heureux avec le même code ;-)

*/

#ifdef __amigaos4__

#define APP_FEELINBASE_D                    /* Append FeelinBase declaration, in function parameter list */
#define APP_FEELINBASE_C                    /* Append FeelinBase in function parameter call */

#else

#define APP_FEELINBASE_D                    ,struct FeelinBase *FeelinBase
#define APP_FEELINBASE_C                    ,FeelinBase

#endif

/// Macros to Open/Close libraries
#ifdef __amigaos4__

#define F_OPENLIB(Base,IFStruct,IFace,LibName, Version)     ((Base = (struct Base *) IEXEC OpenLibrary( \
															LibName,Version)) && (IFace = (struct IFStruct *) IEXEC GetInterface( \
															(struct Library *)Base,"main",1,NULL)))
#define F_CLOSELIB(IFace,Base)                              IEXEC DropInterface((struct Interface *) IFace); IFace = 0; \
															IEXEC CloseLibrary((struct Library *)(Base)); Base = 0

#else

#define F_OPENLIB(Base,IFStruct,IFace,LibName, Version)     (Base = (struct Base *) OpenLibrary(LibName, Version))
#define F_CLOSELIB(IFace,Base)                              CloseLibrary((struct Library *)(FeelinBase)); FeelinBase = 0;

#endif
//+

///API basics
#ifdef __MORPHOS__

#define F_LIB_INIT                              struct Library * lib_init( \
														F_LIB_STRUCT *SelfBase, \
														APTR SegList, \
														struct ExecBase *SYS)

/*

	GOFROMIEL @ YOMGUI: Shouldn't I define F_LIB_INIT like the others:

		struct Library * lib_init(void)

	and use F_LIB_INIT_ARGS to get parameters ?

	YOMGUI @ GOFROMIEL: non! car lib_init() est la  seule  fonction  pouvant
	etre  appelee  dans un context PPC uniquement (c'est ramlib qui s'occupe
	de cela). Les autres peuvent l'etres en PPC ou m68k.

*/

#define F_LIB_EXPUNGE                           APTR lib_expunge(void)
#define F_LIB_CLOSE                             APTR lib_close(void)
#define F_LIB_OPEN                              struct Library * lib_open(void)
#define F_LIB_QUERY                             struct TagItem * lib_query(void)

/* args */     

#define F_LIB_INIT_ARGS

/*

	GOFROMIEL @ YOMGUI: Shouldn't I define some things such as:

		F_LIB_STRUCT *SelfBase = (F_LIB_STRUCT *) REG_D0;
		uint32 SegList = (uint32) REG_A0;
		struct ExecBase *SYS = (struct ExecBase *) REG_A6

	YOMGUI @ GOFROMIEL: non non non.... :P

*/

#define F_LIB_EXPUNGE_ARGS                      F_LIB_STRUCT *F_LIB_BASE = (APTR) REG_A6;
#define F_LIB_CLOSE_ARGS                        F_LIB_STRUCT *F_LIB_BASE = (APTR) REG_A6;
#define F_LIB_OPEN_ARGS                         F_LIB_STRUCT *F_LIB_BASE = (APTR) REG_A6;
#define F_LIB_QUERY_ARGS                        uint32 Which = (uint32) REG_D0; \
												struct FeelinBase *Feelin = (struct FeelinBase *) REG_A0;

#elif defined(__amigaos4__) /*** Amiga OS4   ***************************************************/

#define F_LIB_INIT                              struct Library *lib_init \
												( \
													F_LIB_STRUCT *SelfBase, \
													APTR SegList, \
													struct Interface *SYS \
												)

#define F_LIB_EXPUNGE                           APTR lib_expunge \
												( \
												   struct LibraryManagerInterface *SelfIFace \
												)

#define F_LIB_CLOSE                             APTR lib_close \
												( \
												   struct LibraryManagerInterface *SelfIFace \
												)

#define F_LIB_OPEN                              struct Library *lib_open \
												( \
													struct LibraryManagerInterface *SelfIFace \
												)

#define F_LIB_QUERY                             struct TagItem *lib_query \
												( \
													F_LIB_STRUCT *SelfBase, \
													uint32 Which, \
													struct FeelinBase *Feelin \
												)

#define F_LIB_NULL                              uint32 lib_null(struct FeelinClassIFace *SelfIFace)
#define F_LIB_RESERVED                          uint32 lib_reserved(struct FeelinClassIFace *SelfIFace)


#define F_LIB_INIT_ARGS
#define F_LIB_EXPUNGE_ARGS                      F_LIB_STRUCT *F_LIB_BASE = (F_LIB_STRUCT *) SelfIFace -> Data.LibBase;
#define F_LIB_CLOSE_ARGS                        F_LIB_STRUCT *F_LIB_BASE = (F_LIB_STRUCT *) SelfIFace -> Data.LibBase;
#define F_LIB_OPEN_ARGS                         F_LIB_STRUCT *F_LIB_BASE = (F_LIB_STRUCT *) SelfIFace -> Data.LibBase;
#define F_LIB_QUERY_ARGS


#else /*** classic *****************************************************************************/

#define F_LIB_INIT                              ASM(struct Library *) lib_init \
												( \
												   REG(d0,F_LIB_STRUCT *SelfBase), \
												   REG(a0,APTR SegList), \
												   REG(a6,struct ExecBase *SYS) \
												)

#define F_LIB_EXPUNGE                           ASM(APTR) lib_expunge \
												( \
												   REG(a6,F_LIB_STRUCT *F_LIB_BASE) \
												)

#define F_LIB_CLOSE                             ASM(APTR) lib_close \
												( \
												   REG(a6,F_LIB_STRUCT *F_LIB_BASE) \
												)

#define F_LIB_OPEN                              ASM(struct Library *) lib_open \
												( \
												   REG(a6,F_LIB_STRUCT *F_LIB_BASE) \
												)

#define F_LIB_QUERY                             ASM(struct TagItem *) lib_query \
												( \
													REG(d0,uint32 Which), \
													REG(a0,struct FeelinBase *Feelin), \
													REG(a6,F_LIB_STRUCT *F_LIB_BASE) \
												)

#define F_LIB_INIT_ARGS
#define F_LIB_EXPUNGE_ARGS
#define F_LIB_CLOSE_ARGS
#define F_LIB_OPEN_ARGS
#define F_LIB_QUERY_ARGS

#endif
//+

/************************************************************************************************
*** Interfaces macros ***************************************************************************
************************************************************************************************/

#ifdef __amigaos4__

	/* Les variables globales ne sont créé  que  dans  les  bibliothèque  de
	classe  et  dans  feelin.library,  mais  pas  dans les sources utilisant
	Feelin. Là, on utilise ce qui est présent dans FeelinBase

	__ISFEELINLIB__ est  définie  dans  le  makefile,  uniquement  pour  OS4
	(inutile pour les autres)*/

/*

GOFROMIEL @ HOMBRE: Tu es sûr qu'on utilise  le  double  référencement  dans
feelin.library  ?  Parce  qu'il  me  semble que je ne l'utilise plus que sur
m68k, pour les autres systèmes il y a des  variables  globales...  Ou  alors
j'ai pas bien compris ?

YOMGUI @ tous: moi je dit que variables globales partout pour  tout  ce  qui
est  globalement  partagé....  vu que les lib sont partagées alors globales.
D'ailleur c'est quasiement le seul cas  ou  on  peut  accepter  d'avoir  des
globales. Car globales = caca = pas bien = etc, sinon ! c'est ingerables les
globales dans des codes multithreadés  si  on  ne  sais  pas  manipuler  les
semaphores.  Mais  si  on est sur que ces globales sont read-only (comme les
pointeurs des bases) alors ok.

GOFROMIEL: Ui, a mort le double référencement ! ;-)

*/

	#define IEXEC                               IExec->
	#define IDOS_                               IDOS->
	#define IGRAPHICS                           IGraphics->
	#define ILAYERS                             ILayers->
	#define IINTUITION                          IIntuition->
	#define IUTILITY                            IUtility->
	#define ILOCALE                             ILocale->
	#define IFEELIN                             IFeelin->
	#define IFEELINCLASS                        IFeelinClass->

#else

	#define IEXEC
	#define IDOS_
	#define IGRAPHICS
	#define ILAYERS
	#define IINTUITION
	#define IUTILITY
	#define ILOCALE
	#define IFEELIN
	#define IFEELINCLASS

#endif

#endif

