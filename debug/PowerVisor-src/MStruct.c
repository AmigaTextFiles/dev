/*======================================*/
/*																			*/
/* Make a structure definition file for	*/
/* PowerVisor														*/
/* © J.Tyberghein												*/
/*		Mon Oct 22 09:14:41 1990 V1.0			*/
/*		Sat Feb  9 21:55:17 1991 V1.1			*/
/*			Included length in file					*/
/*		Fri Aug 23 17:10:34 1991 V1.2			*/
/*			New keywords 'padbyte',					*/
/*			'padword', 'padlong' and				*/
/*			'padstruct'											*/
/*		Sun Sep 22 15:30:49 1991 V1.3			*/
/*		Sun Jul 19 12:44:28 1992 V1.4			*/
/*			Error handling									*/
/*		Wed Jul 27 14:06:29 1994 V1.5			*/
/*			Support for arrays and inline		*/
/*			strings (new keyword 'STRING')	*/
/*																			*/
/*======================================*/

/* Part of PowerVisor source   Copyright © 1994   Jorrit Tyberghein
 *
 * - You may modify this source provided that you DON'T remove this copyright
 *   message
 * - You may use IDEAS from this source in your own programs without even
 *   mentioning where you got the idea from
 * - If you use algorithms and/or literal copies from this source in your
 *   own programs, it would be nice if you would quote me and PowerVisor
 *   somewhere in one of your documents or readme's
 * - When you change and reassemble PowerVisor please don't use exactly the
 *   same name (use something like 'PowerVisor Plus' or
 *   'ExtremelyPowerVisor' :-) and update all the copyright messages to reflect
 *   that you have changed something. The important thing is that the user of
 *   your program must be warned that he or she is not using the original
 *   program. If you think the changes you made are useful it is in fact better
 *   to notify me (the author) so that I can incorporate the changes in the real
 *   PowerVisor
 * - EVERY PRODUCT OR PROGRAM DERIVED DIRECTLY FROM MY SOURCE MAY NOT BE
 *   SOLD COMMERCIALLY WITHOUT PERMISSION FROM THE AUTHOR. YOU MAY ASK A
 *   SHAREWARE FEE
 * - In general it is always best to contact me if you want to release
 *   some enhanced version of PowerVisor
 * - This source is mainly provided for people who are interested to see how
 *   PowerVisor works. I make no guarantees that your mind will not be warped
 *   into hyperspace by the complexity of some of these source code
 *   constructions. In fact, I make no guarantees at all, only that you are
 *   now probably looking at this copyright notice :-)
 * - YOU MAY NOT DISTRIBUTE THIS SOURCE CODE WITHOUT ALL OTHER SOURCE FILES
 *   NEEDED TO ASSEMBLE POWERVISOR. YOU MAY DISTRIBUTE THE SOURCE OF
 *   POWERVISOR WITHOUT THE EXECUTABLE AND OTHER FILES. THE ORIGINAL
 *   POWERVISOR DISTRIBUTION AND THIS SOURCE DISTRIBUTION ARE IN FACT TWO
 *   SEPERATE ENTITIES AND MAY BE TREATED AS SUCH
 */

#include <exec/types.h>
#include <exec/memory.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <utility/tagitem.h>
#include <dos/rdargs.h>
#include <dos/dos.h>
#include <string.h>

/*================================== Data ====================================*/

// File format :
//
// for each structure
//   LONG				: 'PVSD'
//   BYTE				: string length (=a)
//   BYTE[a]		: string (NULL terminated)
//   LONG				: size of structure block (=b)
//   BYTE[b]		: structure (LONG-NULL terminated)
//   WORD				: structure size (new for 1.1)
//   LONG				: length of stringblock (=c)
//   BYTE[c]		: strings
// BYTE : 0x00

char CLI_Help[] = "\
[01mMake Struct 1.5[00m  [33mWritten by J.Tyberghein, 27 Jul 94[31m\n\n\
Usage:\n\
  MStruct <Structure def> <out file>\n";

char CLI_Template[] = "Struct/a,Out/a";
struct RDArgs *rcrda = NULL;
BPTR fout = NULL,fin = NULL;

void RealMain (char *, char *);
void __regargs CloseStuff (int);
void myPrintf (char *FormatStr, ...);
void OpenStuff ();

typedef void (*fntype)();

#define ERR_OPEN -1
#define ERR_OPENNEW -2
#define ERR_LIB	-3

/*================================== Code ====================================*/


/*------------------------------- main program -------------------------------*/

int main ()
{
	LONG Args[3];

	OpenStuff ();

	rcrda = ReadArgs (CLI_Template,Args,NULL);
	if (!rcrda)
		{
			PutStr (CLI_Help);
			CloseStuff (0);
		}

	RealMain ((char *)Args[0],(char *)Args[1]);
}

/*---------------------------------- printf ----------------------------------*/

void myPrintf (char *FormatStr, ...)
{
	VPrintf (FormatStr,(LONG *)((&FormatStr)+1));
}

/*-------------------------------- CloseStuff --------------------------------*/

void __regargs CloseStuff (int Error)
{
	if (fin) Close (fin);
	if (fout) Close (fout);
	if (rcrda) FreeArgs (rcrda);
	exit (Error);
}

/*------------------------------ Print an error ------------------------------*/

void __regargs SayError (int Error, char *Object)
{
	char *Head,*ObjSort;

	ObjSort = "file";
	switch (Error)
		{
			case ERR_OPEN		:	Head = "opening"; break;
			case ERR_OPENNEW:	Head = "opening new"; break;
		}
	myPrintf ("\015[33mERROR:[31m %s %s %s !\n",Head,ObjSort,Object);
	CloseStuff (-Error);
}

/*------------------------- Open everything we need --------------------------*/

void OpenStuff ()
{
	APTR DosBase;

	if (!(DosBase = (APTR)OpenLibrary ("dos.library",36)))
		{
			Write (Output (),"You need AmigaDOS 2.0 !\n",24);
			exit (-ERR_LIB);
		}
	CloseLibrary ((struct Library *)DosBase);
}


/*------------------------------ Main program --------------------------------*/

char __regargs *SkipSpace (char *Str)
{
	while (*Str == ' ' || *Str == 9) Str++;
	if (!*Str) return (NULL);
	else return (Str);
}



char __regargs *SkipNSpace (char *Str)
{
	while (*Str && *Str != ' ' && *Str != 9) Str++;
	if (!*Str) return (NULL);
	else return (Str);
}



char __regargs *SearchChar (char *Str, char c)
{
	while (*Str && *Str != c) Str++;
	return (Str);
}


char *as;
char buf[5000],*strbuf;
int size;
UBYTE w;
UBYTE arraysize;
UWORD curoff;
char *end;


void DoIt ()
{
	ULONG l;

	as = SkipNSpace (as);
	as = SkipSpace (as);
	l = (int)(strbuf-buf)+1;
	Write (fout,(UBYTE *)&l,4);
	end = SearchChar (as,',');
	*end++ = 0;
	strcpy (strbuf,as);
	strbuf += strlen (as)+1;
	size += 8;
	Write (fout,(UBYTE *)&w,1);
	Write (fout,(UBYTE *)&arraysize,1);
	Write (fout,(UBYTE *)&curoff,2);
}


void RealMain (char *Struct, char *Out)
{
	int lenpos;
	UBYTE b;
	ULONG l;
	LONG realarraysize;
	char line[256], *arr;

	if (!(fin = Open (Struct,MODE_OLDFILE)))
		SayError (ERR_OPEN,Struct);
	if (!(fout = Open (Out,MODE_NEWFILE)))
		SayError (ERR_OPENNEW,Out);

	curoff = -1;

	while (FGets (fin,line,255))
		{
			as = SkipSpace (line);
			line[strlen (line)-1] = 0;
			realarraysize = -1;
			arraysize = 0;
			arr = SearchChar (as, '[');
			if (*arr)
				{
					*arr++ = 0;
					StrToLong (arr, &realarraysize);
					if (realarraysize > 255) arraysize = 255;
					else arraysize = realarraysize;
				}
			if (!strnicmp (as,"structure",9))
				{
					if (curoff != -1)
						{
							l = 0;
							Write (fout,(UBYTE *)&l,4);
							Write (fout,(UBYTE *)&l,4);
							size += 8;

							Write (fout,(UBYTE *)&curoff,2);

							l = (int)(strbuf-buf)+1;
							Write (fout,(UBYTE *)&l,4);			/* Write string length */
							Write (fout,buf,l);

							lenpos = Seek (fout,lenpos,OFFSET_BEGINNING);
							Write (fout,(UBYTE *)&size,4);
							Seek (fout,lenpos,OFFSET_BEGINNING);
						}

					strbuf = buf;
					as = SkipNSpace (as);
					as = SkipSpace (as);
					end = SearchChar (as,',');
					*end++ = 0;
					b = strlen (as)+1;
					Write (fout,"PVSD",4);
					Write (fout,&b,1);				/* Write strlen */
					Write (fout,as,(int)b);
					size = 0;
					StrToLong (end,&l);
					curoff = l;
					lenpos = Seek (fout,0,OFFSET_CURRENT);
					Write (fout,as,4);				/* Dummy for length later */
				}
			else if ((!strnicmp (as,"long",4)) || (!strnicmp (as,"ulong",5)) ||
					(!strnicmp (as,"aptr",4)))
				{
					w = 2;
					if (realarraysize >= 0) w += 64;
					DoIt ();
					curoff += 4*(arraysize ? realarraysize : 1);
				}
			else if ((!strnicmp (as,"word",4)) || (!strnicmp (as,"uword",5)))
				{
					w = 1;
					if (realarraysize >= 0) w += 64;
					DoIt ();
					curoff += 2*(arraysize ? realarraysize : 1);
				}
			else if ((!strnicmp (as,"char",4)) || (!strnicmp (as,"byte",4)) ||
					(!strnicmp (as,"ubyte",5)))
				{
					w = 0;
					if (realarraysize >= 0) w += 64;
					DoIt ();
					curoff += 1*(arraysize ? realarraysize : 1);
				}
			else if (!strnicmp (as,"padbyte",7))
				{
					curoff += 1;
				}
			else if (!strnicmp (as,"padword",7))
				{
					curoff += 2;
				}
			else if (!strnicmp (as,"padlong",7))
				{
					curoff += 4;
				}
			else if (!strnicmp (as,"padstruct",9))
				{
					end = SearchChar (as,',');
					*end++ = 0;
					StrToLong (end,&l);
					curoff += l;
				}
			else if (!strnicmp (as,"cstr",4))
				{
					w = 3;
					arraysize = 0;	/* Arrays not yet supported for strings */
					DoIt ();
					curoff += 4;
				}
			else if (!strnicmp (as,"bstr",4))
				{
					w = 128+3;
					arraysize = 0;	/* Arrays not yet supported for strings */
					DoIt ();
					curoff += 4;
				}
			else if (!strnicmp (as,"bptr",4))
				{
					w = 128+2;
					arraysize = 0;	/* Arrays not supported */
					DoIt ();
					curoff += 4;
				}
			else if (!strnicmp (as,"struct",6))
				{
					w = 4;					/* Object in object */
					arraysize = 0;	/* Arrays not supported */
					DoIt ();
					StrToLong (end,&l);
					curoff += l;
				}
			else if (!strnicmp (as, "string", 6))
				{
					w = 5;					/* Inline string */
					DoIt ();
					curoff += realarraysize;
				}
		}

	l = 0;
	Write (fout,(UBYTE *)&l,4);
	Write (fout,(UBYTE *)&l,4);
	size += 8;

	Write (fout,(UBYTE *)&curoff,2);

	l = (int)(strbuf-buf)+1;
	Write (fout,(UBYTE *)&l,4);			/* Write string length */
	Write (fout,buf,l);

	Seek (fout,lenpos,OFFSET_BEGINNING);
	Write (fout,(UBYTE *)&size,4);

	CloseStuff (0);
}

/*================================ The end ===================================*/
