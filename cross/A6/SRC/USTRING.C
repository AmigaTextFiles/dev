/* ------------------------------------------------------------------
    USTRING.C -- useful string funcions that C doesn't give me :-)
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <ctype.h>
#include <stdlib.h>
#include <string.h>

/* NEWSTRING -- return same string in a new place in memory */
char *newstring(char *s)
{
	char *ns;
	int i=strlen(s);

	if(i==0) return(0);

	ns=malloc(++i);
	strcpy(ns,s);

	return(ns);
}


/* RTRIM -- note this function messes with the original data.  However,
   it's still safe to use on things you are going to need to free... */
char *rtrim(char *s)
{
	char *t;

	t=s+strlen(s);
	t--;

	while(isspace(*t)) t--;

	t++;

	if(isspace(*t)) *t='\0';

	return(s);
}

/* STRIPQUOTE -- strips leading and trailing quotes, if found.
   *Not safe for stuff that needs freeing* */
char *stripquote(char *s)
{
	int i;

	if(s[0]=='\'' || s[0]=='\"') {
		i=strlen(s);
		while(i && s[i]!=s[0]) i--;
		if(i)
			s[i]=0;
		s++;
	}

	return s;
}

/* TOHEX -- returns $xxxx for input long */
char *tohex(long n)
{
	static char buffer[6];
	int i;

	buffer[0]='$';
	i=(n/0x1000) & 0x0f;
	buffer[1]=i>9 ? i+'7' : i|'0';
	i=(n/0x100) & 0x0f;
	buffer[2]=i>9 ? i+'7' : i|'0';
	i=(n/0x10) & 0x0f;
	buffer[3]=i>9 ? i+'7' : i|'0';
	i=n & 0x0f;
	buffer[4]=i>9 ? i+'7' : i|'0';
	buffer[5]=0;

	return((char *)buffer);
}

/* TRIM -- note this function returns a slightly `moved' pointer, and
   messes with the original data.  Don't use it on things you're going
   to need to free... */
char *trim(char *s)
{
	char *t;

	while(isspace(*s)) s++;

	t=s+strlen(s);
	t--;
	while(isspace(*t)) t--;

	t++;

	if(isspace(*t)) *t='\0';

	return(s);
}
