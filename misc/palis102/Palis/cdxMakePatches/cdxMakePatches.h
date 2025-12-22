/*
	·C·O·D·E·X· ·D·E·S·I·G·N· ·S·O·F·T·W·A·R·E·
	presents:

	cdxMakePatches.h

	Here is some code on how I think patching libraries might be
	as save as possible:

	- cdxPutFunction() will automatically track your patches and thus
	  you won't need to make several calls to SetFunction() to remove
	  your patches. cdxRemAllFunctions() will do that for you.
	- cdxRemAllFunctions() is able to remove all patches.
	  In the case there do not occur problems (no overwritten patches,
	  SaferPatches active) it will simply remove them.
	  Otherwise it will return FALSE.
	  Moreover if you use the flag CDXFUNCF_ADDCODE when calling
	  cdxPutFunction() the object can also remove your functions without
	  direct danger for the system. A dummy code will be installed then.

	Suggested way of work:

	a) call cdxPutFunction(&ptr,CDXFUNCF_ADDCODE,,,,) for all patches.
		(don't forget to initialize "ptr" by zero !)
	b) do your job(s)
	c) call cdxRemAllFunctions(&ptr,FALSE) to try to remove your tool
		on the most friendly (I suggest the only acceptable) way.
	d) if it returns FALSE, warn the user that some vectors can't be
		restored execpt you waste memory when quitting your program.
	e)	if the user still wants to remove your tool, call
		cdxRemAllFunctions(&ptr,TRUE) and everything will be fine.
		Of course, the dummy-code will only be left in memory if it neccessary
		(e.g. the vector had been overwritten).

	For further flames call me up codex@stern.mathematik.hu-berlin.de or
	buehlhan@kadewe.artcom.de or codex@kadewe.artcom.de.

	BTW this code might be used in any way you want.

	(w)2.1.1996 - happy new year to all readers !
*/

#include	<exec/nodes.h>
#include	<exec/types.h>
#include	<exec/memory.h>
#include	<exec/semaphores.h>
#include	<proto/exec.h>			// for SAS

// ------------------------------------
// defines
// ------------------------------------

#define	CDXFUNCF_ADDCODE	0x0001
		// generate addtitional dummy code: If you use this, removing this
		// function will always be possible even if the vector had been
		// modified (though you waste about 10 bytes of memory)
#define	CDXFUNCF_ADDSEM	0x0002
		// allocate and initialize an additional struct SignalSemaphore *
		// for your function.
		// The address of it can be achieved by cdxGetPatchSem().
		// use it this way in your custom funcion:
		//
		// ANYTYPE newfunc(...)
		// {
		//    ObtainSemaphoreShared(sem);
		//
		//    ret = ... do what you want ...
		//
		//    ReleaseSemaphore(sem);
		//
		//    return ret;
		// }
		//
		// If you're now going to remove the function, cdxRemAllFunctions()
		// will first remove your function then try to ObtainSemaphore(sem)
		//  This way if any tasks were running your function
		// cdxRemAllFunctions() will wait until these tasks left your func.
		// Note that _you_ should even  dos/Delay(2)  after having called
		// cdxRemAllFunctions() to ensure that the last two lines have also been
		// executed !
		// Note that you should use this way if your new function does heavy
		// processing. If it is a fast one, forget it - it would be time-
		// wasting !
		// Note 2: Note that you cannot use this flag for
		// exec/ObtainSemaphore(),exec/ObtainSemaphoreShared(),exec/Release-
		// Semaphore(),GetMsg(),PutMsg(),ReplyMsg(),Wait() etc !!!!

// ------------------------------------
// functions
// ------------------------------------

/*
 * cdxPutFunction()
 * ----------------
 *
 * -- JOB --
 * This function will SetFunction() your new function. It will - if specified
 * using CDXFUNCF_ADDCODE generate a little dummy code which will be left
 * in memory if it is neccessary to do so to remove all functions and if you
 * want it by yourself.
 * -- INPUTS --
 * headPtr must be initialized by zero on first call.
 * Flags see above.
 * rest see dox for SetFunction()
 * -- RESULT --
 * Ptr to old vector or NULL (error)
 * Note that further patches of you are still active !!!!!
 *
 * Note 1: *headPtr _MUST_ be set to zero before you do anything.
 * Note 2: Since cdxPutFunction() uses Forbid(),Permit() and SetFunction()
 * it wouldn't be wise to patch these exec functions using these functions ;-)
 */

extern APTR __asm cdxPutFunction(register __a0 APTR	*headPtr,
                                 register __d0 UWORD	Flags,
                                 register __a1 APTR	lib,
                                 register __d1 WORD	offset,
                                 register __a2 APTR	newFunc);

/*
 * cdxRemAllFunctions()
 *
 * -- JOB --
 * This function will SetFunction() each of your old functions
 * you set using cdxPutFunction(). It will check whether the code returned
 * by SetFunction() matches the expected (your "NewFunc"s). In this case
 * everything is fine and TRUE is returned. Otherwise, at last one of your
 * vectors had been modified.
 * If you use the "force" option all patches that have been installed using
 * the CDXFUNCF_ADDCODE flag will be removed even if the library vector has
 * been overwritten and a little dummy code will be left in memory (10 bytes
 * per function the can't be removed ordinary).
 * -- INPUTS --
 * headPtr - see cdxPutFunction(). Might still be zero.
 * force - see JOB above.
 * -- RESULT --
 * TRUE or FALSE. Note that even if you "force"d to uninstall your patches
 * cdxRemAllFunctions() will reject to do so if a vector of a patch that
 * hasn't been installed using CDXFUNCF_ADDCODE had been found modified.
 *
 * Note: If this func returns FALSE you can be sure that all your functions
 * are still at work !!!!!!!!!!!!!!!
 */

extern BOOL __asm cdxRemAllFunctions(register __a0 APTR	*headPtr,
                                     register __d0 BOOL	force);

/*
 *	cdxGetPatchSem()
 * ----------------
 *
 * -- JOB --
 * This functions might be used to get the semaphore allocated for a
 * function by cdxPutFunction(...,CDXFUNCF_ADDSEM,...)
 * See explanation of CDXFUNCF_ADDSEM for more information.
 * -- INPUTS --
 * headPtr - see cdxPutFunction(). Might still be zero (=> returns zero)
 * newFunc - the address of the function you wanted a semaphore for.
 * Might be zero (in this case the sem of the last patch will be used,
 * even if you didn't wanted a semaphore (=>NULL)) !
 * -- RESULT --
 * Address or NULL. This function won't fail if there's a semaphore.
 */

extern struct SignalSemaphore *__asm cdxGetPatchSem(register __a0 APTR *headPtr,
                                                   register __a1 APTR newFunc);

/* (w)hans bühler */
