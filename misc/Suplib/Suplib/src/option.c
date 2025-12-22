
/*
 *  OPTION.C
 *
 *  ops format:     <op>[%[l][s/d/f]
 */

#include <local/typedefs.h>
#ifdef LATTICE
#include <stdlib.h>
#endif

int
DoOption(ac, av, ops, args)
int ac;
char *av[];
char *ops;
long args;
{
    short i;
    short j;

    for (i = j = 1; i < ac; ++i) {
	char *ptr = av[i];
	if (*ptr != '-') {
	    av[j++] = av[i];
	    continue;
	}
	while (*++ptr) {
	    char *op;
	    long **ap = (long **)&args;
	    short isshort;
	    for (op = ops; *op && *op != *ptr;) {
		if (*op == *ptr)
		    break;
		if (*++op == '%') {
		    while (*op && *op != 's' && *op != 'd')
			++op;
		    if (*op)
			++op;
		}
		if (*op == ',')
		    ++op;
		++ap;
	    }

	    /*	START, REMOVING THIS SECTION GETS RID OF ERROR SO SOMETHING
	     *	IN THIS SECTION IS CAUSING THE CXERR
	     */
	    if (*op == 0)
		return(-1);
	    if (op[1] != '%') {
		short *stmp = (short *)*ap;
		*stmp = 1;
		++ap;
		continue;
	    }
	    /* END OF SECTION */

	    op += 2;
	    isshort = 1;
	    while (*op && *op != 's' && *op != 'd') {
		switch(*op) {
		case 'h':
		    isshort = 1;
		    break;
		case 'l':
		    isshort = 0;
		    break;
		default:
		    return(-1);
		}
		++op;
	    }
	    switch(*op) {
	    case 's':
		if (ptr[1]) {
		    *(char **)*ap = ptr + 1;
		    ptr = "\0";
		} else {
		    *(char **)*ap = av[++i];
		}
		break;
	    case 'd':
		if (isshort)
		    *(short *)*ap = atoi(++ptr);
		else
		    *(long *)*ap = atoi(++ptr);
		while (*ptr >= '0' && *ptr <= '9')
		    ++ptr;
		--ptr;
		break;
	    default:
		return(-1);
	    }
	}
    }
    return((int)j);
}

