
/*
 *  MISC1.C
 *
 *  General Stuff... mostly in assembly.
 */

#include <local/typedefs.h>
#include <exec/execbase.h>
#ifdef LATTICE
#include <string.h>
#endif

typedef struct {
    NODE     ml_Node;
    uword    ml_NumEntries;
    MEMENTRY ml_ME[2];
} MYMEMLIST;

/*BREAKUP   gettaskdata.c   */

APTR
GetTaskData(name, bytes)
char *name;
long bytes;
{
    extern EXECBASE *SysBase;
    register LIST *list;
    register MEMLIST *ml;

    list = &SysBase->ThisTask->tc_MemEntry;
    if (ml = FindName2(list, name))
	return(ml->ml_ME[0].me_Un.meu_Addr);
    if (!bytes)
	return(NULL);
    if (!list->lh_Head)
	NewList(list);
    {
	MYMEMLIST Ml;

	Ml.ml_NumEntries = 2;
	Ml.ml_ME[0].me_Un.meu_Reqs = MEMF_PUBLIC|MEMF_CLEAR;
	Ml.ml_ME[0].me_Length = bytes;
	Ml.ml_ME[1].me_Un.meu_Reqs = MEMF_PUBLIC;
	Ml.ml_ME[1].me_Length = strlen(name)+1;
	if (ml = AllocEntry((struct MemList *)&Ml)) {
	    ml->ml_Node.ln_Name = (char *)ml->ml_ME[1].me_Un.meu_Addr;
	    strcpy(ml->ml_Node.ln_Name, name);
	    AddHead(list, (NODE *)ml);
	    return(ml->ml_ME[0].me_Un.meu_Addr);
	}
    }
    return(NULL);
}

/*BREAKUP   freetaskdata.c  */

int
FreeTaskData(name)
char *name;
{
    extern EXECBASE *SysBase;
    register MEMLIST *ml;

    if (ml = FindName2(&SysBase->ThisTask->tc_MemEntry, name)) {
	Remove((NODE *)ml);
	FreeEntry(ml);
	return(1);
    }
    return(0);
}

