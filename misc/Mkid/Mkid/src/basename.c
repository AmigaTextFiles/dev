/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)basename.c	1.1 86/10/09";

#include	"string.h"

char *basename();
char *dirname();

#define NULL ((char *) 0)

char *
basename(path)
	char		*path;
{
	char		*base;

	if ((base = strrchr(path, '/')) == 0)
#ifdef AMIGA
		if ((base = strchr(path,':')) != NULL)
			return ++base;
		else
#endif
		return path;
	else
		return ++base;
}

char *
dirname(path)
	char		*path;
{
	char		*base;

	if ((base = strrchr(path, '/')) == 0)
#ifdef UNIX
		return ".";
#endif
#ifdef AMIGA
	{
		if ((base = strrchr(path,':')) == 0)
			return "";
		else
			return strnsav(path, base - path + 1); /* for : */
	}
#endif
	else
		return strnsav(path, base - path);
}
