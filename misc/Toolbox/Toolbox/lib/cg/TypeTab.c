int
# define beginint(a)		
# define closeint(a)		
# define readint(a)		(void) fscanf (yyf, "%d", & a);
# define writeint(a)		(void) fprintf (yyf, "%d", a);
# define getint(a)		yyGet ((char *) & a, sizeof (a));
# define putint(a)		yyPut ((char *) & a, sizeof (a));
# define copyint(a, b)		
# define equalint(a, b)		a == b
short
# define beginshort(a)		
# define closeshort(a)		
# define readshort(a)		(void) fscanf (yyf, "%hd", & a);
# define writeshort(a)		(void) fprintf (yyf, "%hd", a);
# define getshort(a)		yyGet ((char *) & a, sizeof (a));
# define putshort(a)		yyPut ((char *) & a, sizeof (a));
# define copyshort(a, b)		
# define equalshort(a, b)	a == b
long
# define beginlong(a)		
# define closelong(a)		
# define readlong(a)		(void) fscanf (yyf, "%ld", & a);
# define writelong(a)		(void) fprintf (yyf, "%ld", a);
# define getlong(a)		yyGet ((char *) & a, sizeof (a));
# define putlong(a)		yyPut ((char *) & a, sizeof (a));
# define copylong(a, b)		
# define equallong(a, b)	a == b
unsigned
# define beginunsigned(a)	
# define closeunsigned(a)	
# define readunsigned(a)	(void) fscanf (yyf, "%u", & a);
# define writeunsigned(a)	(void) fprintf (yyf, "%u", a);
# define getunsigned(a)		yyGet ((char *) & a, sizeof (a));
# define putunsigned(a)		yyPut ((char *) & a, sizeof (a));
# define copyunsigned(a, b)		
# define equalunsigned(a, b)	a == b
float
# define beginfloat(a)		
# define closefloat(a)		
# define readfloat(a)		(void) fscanf (yyf, "%g", & a);
# define writefloat(a)		(void) fprintf (yyf, "%g", a);
# define getfloat(a)		yyGet ((char *) & a, sizeof (a));
# define putfloat(a)		yyPut ((char *) & a, sizeof (a));
# define copyfloat(a, b)		
# define equalfloat(a, b)	a == b
double
# define begindouble(a)		
# define closedouble(a)		
# define readdouble(a)		(void) fscanf (yyf, "%lg", & a);
# define writedouble(a)		(void) fprintf (yyf, "%lg", a);
# define getdouble(a)		yyGet ((char *) & a, sizeof (a));
# define putdouble(a)		yyPut ((char *) & a, sizeof (a));
# define copydouble(a, b)		
# define equaldouble(a, b)	a == b
bool
# define beginbool(a)		
# define closebool(a)		
# define readbool(a)		a = fgetc (yyf) == 'T';
# define writebool(a)		(void) fputc (a ? 'T' : 'F', yyf);
# define getbool(a)		yyGet ((char *) & a, sizeof (a));
# define putbool(a)		yyPut ((char *) & a, sizeof (a));
# define copybool(a, b)		
# define equalbool(a, b)	a == b
char
# define beginchar(a)		
# define closechar(a)		
# define readchar(a)		a = fgetc (yyf);
# define writechar(a)		(void) fputc (a, yyf);
# define getchar(a)		yyGet ((char *) & a, sizeof (a));
# define putchar(a)		yyPut ((char *) & a, sizeof (a));
# define copychar(a, b)		
# define equalchar(a, b)	a == b
tString
# define begintString(a)	
# define closetString(a)	
# define readtString(a)		
# define writetString(a)	(void) fputs (a, yyf);
# define gettString(a)		
# define puttString(a)		
# define copytString(a, b)		
# define equaltString(a, b)	strcmp (a, b)
tStringRef
# define begintStringRef(a)	
# define closetStringRef(a)	
# define readtStringRef(a)	
# define writetStringRef(a)	WriteString (yyf, a);
# define gettStringRef(a)	
# define puttStringRef(a)	
# define copytStringRef(a, b)		
# define equaltStringRef(a, b)	a == b
tIdent
# define begintIdent(a)		
# define closetIdent(a)		
# define readtIdent(a)		a = yyReadIdent ();
# define writetIdent(a)		WriteIdent (yyf, a);
# define gettIdent(a)		yyGetIdent (& a);
# define puttIdent(a)		yyPutIdent (a);
# define copytIdent(a, b)		
# define equaltIdent(a, b)	a == b
tSet
# define begintSet(a)		
# define closetSet(a)		
# define readtSet(a)		ReadSet (yyf, & a);
# define writetSet(a)		WriteSet (yyf, & a);
# define gettSet(a)		
# define puttSet(a)		
# define copytSet(a, b)		
# define equaltSet(a, b)	IsEqual (& a, & b)
tPosition
# define begintPosition(a)		
# define closetPosition(a)		
# define readtPosition(a)
# define writetPosition(a)	WritePosition (yyf, a);
# define gettPosition(a)		
# define puttPosition(a)		
# define copytPosition(a, b)		
# define equaltPosition(a, b)	Compare (a, b) == 0
