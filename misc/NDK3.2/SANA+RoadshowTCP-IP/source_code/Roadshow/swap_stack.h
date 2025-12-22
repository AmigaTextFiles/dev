/*
 * :ts=4
 *
 * Copyright © 2017-2018 by Olaf Barthel. All Rights Reserved.
 */

#ifndef _SWAP_STACK_H
#define _SWAP_STACK_H

/****************************************************************************/

#ifndef _COMPILER_H
#include "compiler.h"
#endif /* _COMPILER_H */

/****************************************************************************/

typedef LONG (* ASM stack_swapped_func_t)(
	REG(a0, APTR parameter),
	REG(a6, struct Library * sysbase));

/****************************************************************************/

extern long ASM swap_stack_and_call(
	REG(a0, APTR parameter),
	REG(a1, stack_swapped_func_t function),
	REG(a2, struct StackSwapStruct * stk),
	REG(a6, struct Library * sysbase));

/****************************************************************************/

extern BYTE * get_sp(void);

/****************************************************************************/

#endif /* _SWAP_STACK_H */
