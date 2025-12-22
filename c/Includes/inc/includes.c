/*
 * includes.c - dumps recursively all include files needed by C programs
 *
 * Bruno Costa - 24 Jan 90 - 22 Apr 92
 *
 */

#define DEBUG 0

/* #define UNIX  1 */
#define AMIGA 1

#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#define TRUE 1
#define FALSE 0

#define MAXPATH 100
#define MAXLINE 200
#define HASHSIZE 101

#define loop for(;;)
#define streq(a,b) (!strcmp(a,b))
#define prefix(pref,str) (!strncmp(pref,str,strlen(pref)))
#define isuser(name) ((*(name) == '"') ? 1 : 0)
#define issyst(name) ((*(name) == '<') ? 1 : 0)

typedef struct ITEM {
  struct ITEM *next;
  char *name;
  int done;
} item;

item *hashtable[HASHSIZE];

int verbose = TRUE;
int makemode = FALSE;
int sysdump = FALSE;

#if defined (AMIGA)
char *incdir = "INCLUDE:";
#elif defined (UNIX)
char *incdir = "/usr/include/";
#endif


void inithash (void)
{
 item **p, **q;

 for (p = hashtable, q = hashtable + HASHSIZE; p < q; p++)
   *p = NULL;
}


unsigned hash (char *str)
{
 unsigned value;

 for (value = 0; *str; str++)
   value = *str + 31 * value;

 return value % HASHSIZE;
}


item *lookup (char *name)
{
 item *p;

 for (p = hashtable[hash (name)]; p; p = p->next)
   if (streq (name, p->name))
     return p;

 return NULL;
}


item *install (char *name)
{
 item *p;
 unsigned int h;

 if ((p = lookup (name)) == NULL)
 {
   p = (item *) malloc (sizeof (item));
   if (p == NULL  ||  (p->name = strdup (name)) == NULL)
   {
     fputs ("includes: out of mem\n", stderr);
     exit (20);
   }
   p->done = FALSE;
   h = hash (name);
   p->next = hashtable[h];
   hashtable[h] = p;
 }

 return p;
}


int nospaces (char *str)
{
 register char *p, *q;

 for (p = str, q = str; *p; p++)
   if (!isspace (*p))
     *q++ = tolower (*p);

 *q = '\0';

 return q - str;
}


int mkpath (char *path, char *name)
{
 path[0] = '\0';
 switch (name[0])
 {
   case '<':		/* system directory */
     strcat (path, incdir);

   case '"':		/* current directory */
     strcat (path, name + 1);
     return TRUE;
     break;

   default:		/* current directory, name given in command line */
     strcat (path, name);
     return FALSE;
     break;
 }
 /* NOTREACHED */
}


#if AMIGA
int specialparse (char *fname)
{
 char c, line[MAXLINE];
 int compactheader = FALSE;
 FILE *f;

 f = fopen (fname, "rb");

 if (f  &&  (fgetc (f) == 0x80))
 {
   compactheader = TRUE;
#if DEBUG
   printf ("processing compact header %s\n", fname);
#endif
   loop
   {
     c = fgetc (f);
     if (c == EOF)
       break;
     if (c == 0x8C)	/* include directive */
     {
       int i = 0;
       char delim;

       line [i++] = (char)fgetc (f);
       delim = (line[0] == '<') ? '>' : line[0];
       while (i < MAXLINE  &&  (line [i++] = (char)fgetc (f)) != delim)
         ;
       line [i-1] = '\0';
#if DEBUG
       printf ("  found include %s%c\n", line, delim);
#endif
       if (sysdump  ||  isuser (line))
         install (line);
     }
   }
 }

 if (f)
   fclose (f);
 return (compactheader);
}
#endif


int parsefile (char *fname)
{
 char line[MAXLINE];
 FILE *f;

#if DEBUG
 printf ("parsing %s\n", fname);
#endif

#if AMIGA
 if (specialparse (fname))
   return TRUE;
#endif

 f = fopen (fname, "r");
 if (f)
 {
   while (fgets (line, MAXLINE, f))
     if (line[0] == '#')
     {
       nospaces (line);
       if (prefix ("include", &line[1]))
       {
         char *end;
         if (isuser (&line[8]))
           end = strchr (&line[9], '"');
         else
           end = strchr (&line[9], '>');
         if (!end)
         {
           fputs ("includes: improper include directive in '", stderr);
           fputs (fname, stderr);
           fputs ("'\n", stderr);
           continue;
         }
         *end = '\0';
         if (sysdump  ||  isuser (&line[8]))
           install (&line[8]);
       }
     }
   fclose (f);
   return TRUE;
 }
 else if (verbose)
 {
   fputs ("includes: could not open '", stderr);
   fputs (fname, stderr);
   fputs ("'\n", stderr);
   return FALSE;
 }
}


void incparse (char *fname)
{
 char pathname[MAXPATH];
 item *me;

 me = install (fname);

 if (parsefile (fname))
 {
   item *p;
   int i, more;

   me->done = TRUE;

   do
   {
     more = FALSE;
     for (i = 0; i < HASHSIZE; i++)
       for (p = hashtable[i]; p; p = p->next)
         if (!p->done)
         {
           more = TRUE;
           mkpath (pathname, p->name);
           if (!parsefile (pathname)  &&  isuser (p->name)  &&  sysdump)  /* TODO:? */
           {
             p->name[0] = '<';
             if (lookup (p->name) == NULL)
             {
               if (sysdump)
               {
                 mkpath (pathname, p->name);
                 if (!parsefile (pathname))
                   p->name[0] = '"';
               }
             }
             else
               p->name[0] = '"';
           }
           p->done = TRUE;
         }
   } while (more);
 }
}


void incdump (void (*dumpfunc) (char *))
{
 item *p;
 int i, more;

#if DEBUG
 printf ("\ndumping ...\n");
#endif

 do
   for (more = FALSE, i = 0; i < HASHSIZE; i++)
     for (p = hashtable[i]; p; p = p->next)
     {
       char path[MAXPATH];
       if (mkpath (path, p->name))    /* dump only if include file */
       {
         if (sysdump || isuser (p->name))
           (*dumpfunc) (path);
       }
#if DEBUG
       else
       {
         fputs (path, stdout);
         puts (" (cli)");
       }
#endif
     }
 while (more);

}


void putfile (char *name)
{
 fputc (' ', stdout);
 fputs (name, stdout);
}


void main (int argc, char *argv[])
{
 int i, j, c;

 if (argc == 1)
 {
   fputs ("includes 1.2 - (c) 1992 by Bruno Costa\n"
          "usage: includes [-ms] <C Sources> ...\n"
          "       -m = dump inclusions in makefile format\n"
          "       -s = process system include files too\n"
          "       -q = quiet operation\n", stderr);
   exit (5);
 }

 i = 1;
 if (argv[i][0] == '-')
 {
   for (j = 1; c = argv[i][j]; j++)
     switch (c)
     {
       case 'm':
         makemode = TRUE;
         break;
       case 's':
         sysdump = TRUE;
         break;
       case 'q':
         verbose = FALSE;
         break;
       default:
         fputs ("includes: unknown option", stderr);
         exit (10);
         break;
     }
   ++i;
 }

 if (makemode)
 {
   for (; i < argc; i++)
   {
     fputs (argv[i], stdout);
     fputc (':', stdout);

     inithash ();
     incparse (argv[i]);
     incdump (putfile);

     fputc ('\n', stdout);
   }
 }
 else
 {
   inithash ();

   for (; i < argc; i++)
     incparse (argv[i]);

   incdump (puts);
 }

 exit (0);
}
