OPT NATIVE
{#include <x86_64-linux-gnu/bits/wordsize.h>}
/* Determine the wordsize from the preprocessor defines.  */

 NATIVE {__WORDSIZE}	CONST WORDSIZE__	= 64

 ->NATIVE {__WORDSIZE_TIME64_COMPAT32}	CONST __WORDSIZE_TIME64_COMPAT32	= 1
/* Both x86-64 and x32 use the 64-bit system call interface.  */
 ->NATIVE {__SYSCALL_WORDSIZE}		CONST __SYSCALL_WORDSIZE		= 64
