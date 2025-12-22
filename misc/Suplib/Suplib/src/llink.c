
/*
 *  LLINK.C
 *
 *  llink()/lunlink()
 *
 *  THESE ROUTINES ARE OBSOLETE, DO NOT USE
 */

#include <local/typedefs.h>
#include <local/xmisc.h>

XLIST *
llink(list, en)
register XLIST *en, **list;
{
    en->next = *list;
    en->prev = list;
    *list = en;
    if (en->next)
	en->next->prev = &en->next;
    return(en);
}

XLIST *
lunlink(en)
register XLIST *en;
{
    if (en) {
	if (en->next)
	    en->next->prev = en->prev;
	*en->prev = en->next;
	en->next = NULL;
	en->prev = NULL;
    }
    return(en);
}


