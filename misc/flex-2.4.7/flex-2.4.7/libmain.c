/* libmain - flex run-time support library "main" function */

/* $Header: /home/daffy/u0/vern/flex/RCS/libmain.c,v 1.3 93/04/14 22:41:55 vern Exp $ */

#ifdef __STDC__
extern int yylex(void);
#else
extern int yylex();
#endif

int main( argc, argv )
int argc;
char *argv[];
	{
	return yylex();
	}
