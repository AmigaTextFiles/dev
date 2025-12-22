/*
syscall.c by Davic Roch
This routine translates some of the Berkely Unit (tm)
system calls to the Amiga.
*/

#include <stdio.h>
#include "/syscall.h"  /* was "syscall.h"  10/24/91 vjh */

syscall(n, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
int n;
call_args	arg1, arg2, arg3, arg4, arg5, arg6, arg7;
{
char dummy[200];

	switch (n) {

	case SYS_chdir:
	dummy[0] = '\0';
	strcpy(dummy,"cd ");
	strcpy(dummy,arg1);
	return(system(dummy));

	case SYS_chmod:
	dummy[0] = '\0';
	strcpy(dummy,"protect ");
	strcpy(dummy,arg1);
	strcpy(dummy," ");
	strcpy(dummy,arg2);
	return(system(dummy));

	case SYS_access:
	return(access(arg1, arg2));
	default: {
		printf("System call %d has not yet been implemented in this port of SBProlog\n",n);
		printf("If you wish to add this system primitive, you must add the proper case\n");
		printf("statement ot the C source file syscall.c and recompile\n");
		return(-1);
		}
	}
}


