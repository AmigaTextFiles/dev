/* Copyright (c) 1986, Greg McGary */
static char sccsid[] = "@(#)uerror.c	1.1 86/10/09";

#include	<stdio.h>

char *uerror();
void filerr();

extern int	errno;
extern int	sys_nerr;
extern char	*sys_errlist[];
extern char	*MyName;

char	cannot[] = "%s: Cannot %s `%s' (%s)\n";

char *
uerror()
{
	static char	errbuf[10];

	if (errno == 0 || errno >= sys_nerr) {
		sprintf(errbuf, "error %d", errno);
		return(errbuf);
	}
	return(sys_errlist[errno]);
}

void
filerr(syscall, fileName)
	char		*syscall;
	char		*fileName;
{
	fprintf(stderr, cannot, MyName, syscall, fileName, uerror());
}
