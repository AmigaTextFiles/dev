
#include "tek/kn/elate/exec.h"
#include <stdlib.h>

/* 
**	TEKlib
**	(C) 2001 TEK neoscientists
**	all rights reserved.
**
**	elate thread dispatcher
**
*/

int main(int argc, char **argv)
{
	if (argc == 2)
	{
		struct elatethread *t = (struct elatethread *) atoi(argv[1]);
		if (t)
		{
			kn_proc_sleep(-1);
			if (t->initok)
			{
				(*t->function)(t->data);
			}
			kn_proc_exit(0);
		}
	}
	return 0;
}
