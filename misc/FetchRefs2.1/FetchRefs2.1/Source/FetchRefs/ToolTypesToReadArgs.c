/**************************************************************************/
/* ToolTypesToReadArgs.c - an not entirely completed idea for simplifying */
/*			   argument handling of Shell/Workbench arguments */
/**************************************************************************/

#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/utility_protos.h>
#include <dos/dos.h>
#include <string.h>
#include "FetchRefs.h"

#define TT_NO_ARGUMENTS_REQUIRED (1<<0)

#define flag_s (1<<0)
#define flag_k (1<<1)
#define flag_n (1<<2)
#define flag_t (1<<3)
#define flag_a (1<<4)
#define flag_f (1<<5)
#define flag_m (1<<6)


static int flags;
static short tooltypenumber, tooltypenumberreally;


static long __regargs quotestr (char *str)
{
    short found = 0;

    while (*str)
    {
	found |= ((*str == ' ') << 1) | (*str == '\"');
	str++;
    }
    if (found == 2)
	return 1;
    return 0;
}

static char ** __regargs nexttlt (char *arg, char **tt)
{
    int len = strlen(arg);

    while (*tt && Strnicmp(arg, *tt, len))
    {
	tt++;
	tooltypenumberreally++;
    }

    return (*tt ? tt : 0);
}

static char * __regargs findsign (char *s)
{
    tooltypenumber = tooltypenumberreally;

    while (*s && (*s++ != '='))
	;

    return(s);
}

static char * __regargs nextarg (char *s)
{
    tooltypenumberreally = 0;

    while ((*s) && (*s != '/') && (*s != ','))
	s++;

    flags = 0;

    while (*s == '/')
    {
	*s++ = 0;
	switch ((*s++)|32)
	{
	    case 's': flags |= flag_s; break;
	    case 'k': flags |= flag_k; break;
	    case 'n': flags |= flag_n; break;
	    case 't': flags |= flag_t; break;
	    case 'a': flags |= flag_a; break;
	    case 'f': flags |= flag_f; break;
	    case 'm': flags |= flag_m; break;
	}
    }

    if (*s)
    {
	*s++ = 0;
	return s;
    }
    else
	return 0;
}

static int __regargs transform (char **tt, char *tp, char *to, int options)
{
    char *str, *nxt = tp;

    while (str = nxt)
    {
	short toggleresult = 0, keywritten = 0;
	char **tlt;

	nxt = nextarg(nxt);
	tlt = nexttlt(str, tt);
	if ((flags & flag_a) && !tlt && !(options & TT_NO_ARGUMENTS_REQUIRED))
	    return ERROR_REQUIRED_ARG_MISSING;

	while (tlt)
	{
	    char *cut = findsign(*tlt);

	    if (!*cut && !(flags & (flag_s | flag_t)))
		return ERROR_KEY_NEEDS_ARG;

	    tooltypenumberreally++;
	    tlt = nexttlt(str, tlt + 1);
	    if (tlt && !(flags & (flag_m | flag_t)))
		return ERROR_TOO_MANY_ARGS;

	    if (flags & (flag_s | flag_t))
	    {
		if (!*cut)
		    toggleresult = (flags & flag_s) ? 1 : !toggleresult;
		else if (!Stricmp(cut, "NO") || !Stricmp(cut, "FALSE") || !Stricmp(cut, "OFF"))
		    toggleresult = 0;
		else
		    toggleresult = 1;
	    }
	    else
	    {
		if (flags & flag_n)
		{
		    char *n = cut;

		    if ((*n == '-') || (*n == '+'))
			n++;

		    while (*n)
		    {
			if ((*n < '0') || (*n > '9'))
			    return ERROR_BAD_NUMBER;
			n++;
		    }
		}

		if (!keywritten)
		{
		    strcat(to, str);
		    strcat(to, " ");
		    keywritten = 1;
		}

		if (quotestr(cut))
		    strcat(to, "\"");

		strcat(to, cut);

		if (quotestr(cut))
		    strcat(to, "\"");

		strcat(to, " ");
	    }
	}

	if (toggleresult)
	{
	    strcat(to, str);
	    strcat(to, " ");
	}
    }
    strcat (to, "\n");
    return 0;
}

int __regargs ToolTypesToReadArgs (char **tt, char *tp, char *to, int options)
{
    char *cpy;
    int err;

    if (!(cpy = AllocVec (strlen(tp) + 1, 0)))
	return ERROR_NO_FREE_STORE;
    strcpy (cpy, tp);

    err = transform (tt, cpy, to, options);

    FreeVec (cpy);
    return err ? (err | (tooltypenumber << 16)) : 0;
}
