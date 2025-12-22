struct lib {
	struct lib *succ, *prev;
	char type, priority;
	char *name;
	short flags;
	short negsize;
	short possize;
	short version;
	short revision;
	char *ID;
	long sum;
	short opencnt;
	char *env;
};

#define strlen __builtin_strlen

extern char *malloc(int);
extern char *strchr(char *, char);
extern int  strncmp(char *, char *, int);
extern struct lib *OpenLibrary(char *, long);
extern void CloseLibrary(struct lib *);
extern void Forbid(void), Permit(void);

char *
getenv(str)
	char *str;
{
	register struct lib *lp;
	register char *cp, *np;
	register int i;

	if ((lp = OpenLibrary("environment", 0L)) == 0)
		return(0L);
	CloseLibrary(lp);
	cp = lp->env;
	i  = strlen(str);

	Forbid();	/* works of all access goes through Forbid() */
			/* If I didn't want to be compatible with Aztec, */
			/* I'd put a semaphore in the library base */
	while (*cp) {
	 if ((np = strchr(cp, '=')) && np-cp == i && strncmp(cp, str, i) == 0) {
		cp = malloc(strlen(++np)+1);
		strcpy(cp, np);
		Permit();
		return(cp);
	 }
	 cp += strlen(cp) + 1;
	}
	Permit();
	return(0L);
}
