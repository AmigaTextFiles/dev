/*
 * :ts = 4
 *
 * This is a "2-clause" Berkeley-style license.
 *
 *
 * Copyright (c) 2008 J.v.d.Loo.
 * All rights reserved.
 *
 * This code is comprehended as contribution to Uni-Library.
 * Author: J.v.d.Loo
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * This  software  is  provided by the above named author and if named,
 * additional   parties,   "as   is"   and  any  expressed  or  implied
 * warranties,  including,  but  not limited to, the implied warranties
 * of   merchantability  and  fitness  for  a  particular  purpose  are
 * disclaimed.  In  no  event  shall  the  above  named  author nor any
 * additionally  named  party  be  liable  for  any  direct,  indirect,
 * incidental,    special,    exemplary,   or   consequential   damages
 * (including,  but  not limited to, procurement of substitute goods or
 * services;  loss  of use, data, or profits; or business interruption)
 * however  caused and on any theory of liability, whether in contract,
 * strict  liability,  or  tort  (including  negligence  or  otherwise)
 * arising  in any way out of the use of this software, even if advised
 * of the possibility of such damage.
 */


#include <utility/hooks.h>

/*
 * Init the hook(s) so that the correct routine is called. MorphOS hooks are
 * completely different because they will halt current PPC execution and Hooks
 * have to tell the system what kind of code should be processed further
 * (either 68k or PPC)!
 */

#if defined(__MORPHOS__)
/*
 * The following is called in PPC native mode - and not called from the 68k
 * emulator - and with that it is completely different than for 68k and OS4.
 *
 * BTW.: It shall be also suitable for C++ source codes...
 */
#include <emul/emulregs.h>	/* We refer to the emulator provided arguments! */


/*
 * Fetch 68k style arguments and call the real PPC code.
 *
 * Name is a bit misleading; code generated for this function is already PPC
 * native...
 */
static ULONG SwitchToPCC( void)
{
	/* Fetch the arguments */
	struct Hook *hook = (struct Hook *) REG_A0;
	APTR object = (APTR) REG_A2;
	APTR message = (APTR) REG_A1;

	/*
	 * Call the real thing...
	 * Because Commodore made a, hmmm - not perfect assignment, we need to
	 * provide a real prototype for h_SubEntry (C++ is more nitpicking than
	 * C...)
	 */

	return (ULONG) ((ULONG *(*)(struct Hook *, APTR, APTR)) hook->h_SubEntry)( hook, object, message);
}


/*
 * Calling Hooks under MorphOS will halt current PPC execution and depending
 * on the data (code) pointed to by Hook->h_Entry we can either switch to 68k
 * code or continue PPC execution.
 * We prefer PPC execution. :)
 */

static struct EmulLibEntry GateFunction =
{
	/* Tells the system that following code supplied is PPC native... */
	TRAP_LIB, 0, (void (*)(void)) SwitchToPCC
};
#endif


/*
 * Init the hooks accordingly to the OS we use.
 *
 * AROS code still missing...
 */

void InitLocalHook( struct Hook *hook, HOOKFUNC callbackfunc, APTR data)
{
	hook->h_MinNode.mln_Succ = NULL;
	hook->h_MinNode.mln_Pred = NULL;
	#if !defined(__MORPHOS__)
		hook->h_Entry = (HOOKFUNC) callbackfunc;	/* Safe under 68k and OS4 PPC */
		hook->h_SubEntry = NULL;
	#else
		hook->h_Entry = (HOOKFUNC) &GateFunction;	/* MorphOS PPC native */
		hook->h_SubEntry = (HOOKFUNC) callbackfunc;
	#endif
	hook->h_Data = data;
}

