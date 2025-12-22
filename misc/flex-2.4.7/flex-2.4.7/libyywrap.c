/* libyywrap - flex run-time support library "yywrap" function */

/* $Header: /home/daffy/u0/vern/flex/RCS/libyywrap.c,v 1.1 93/10/02 15:23:09 vern Exp $ */

#ifdef __STDC__
int yywrap(void);
#endif

int yywrap()
	{
	return 1;
	}
