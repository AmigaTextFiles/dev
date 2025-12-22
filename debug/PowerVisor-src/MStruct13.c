/*======================================*/
/*																			*/
/* Make a structure definition file for	*/
/* PowerVisor														*/
/* Version for AmigaDOS 1.3							*/
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
/*																			*/
/*======================================*/

/* Part of PowerVisor source   Copyright © 1992   Jorrit Tyberghein
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
#include <pragmas/dos.h>
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
[01mMake Struct 1.4 (for AmigaDOS 1.2/1.3)[00m  [33mWritten by J.Tyberghein, 19 Jul 92[31m\n\n\
Usage:\n\
  MStruct <Structure def> <out file>\n";
BPTR fout = NULL,fin = NULL;

extern APTR DOSBase;

void RealMain (char *, char *);
void __regargs CloseStuff (int);
void myPrintf (char *FormatStr, ...);
void Usage ();
/* void OpenStuff (); */

typedef void (*fntype)();

#define ERR_OPEN -1
#define ERR_OPENNEW -2
#define ERR_LIB -3

/*================================== Code ====================================*/


/*------------------------------- main program -------------------------------*/

void argmain (char *cmdline)

{
	LONG Args[2];
	char *p;

/*	OpenStuff (); */

	p = cmdline;
	while (*p == ' ' && *p != 0) p++;			/* Skip initial spaces if any */
	if (*p == '?' || *p == 0) Usage ();		/* Test if usage */

	// Skip command name first
	while (*p != ' ' && *p != 0) p++;			/* Skip command */

	while (*p == ' ' && *p != 0) p++;			/* Skip spaces after command */
	if (*p == '?' || *p == 0) Usage ();		/* Test if usage */

	Args[0] = (LONG)p;										/* First argument */
	while (*p != ' ' && *p != 0) p++;			/* Skip first argument */
	if (*p == 0) Usage ();								/* If no other argument, error */

	*p++ = 0;															/* End first argument */
	while (*p == ' ' && *p != 0) p++;			/* Skip spaces after argument */
	if (*p == 0) Usage ();								/* If no other argument, error */

	Args[1] = (LONG)p;										/* Second argument */
	while (*p != ' ' && *p != 10 && *p != 0) p++;			/* Skip second argument */
	*p++ = 0;															/* End second argument */

	RealMain ((char *)Args[0],(char *)Args[1]);
}

/*---------------------------------- printf ----------------------------------*/

void Usage ()
{
	Write (Output (),CLI_Help,strlen (CLI_Help));
	CloseStuff (0);
}

/*---------------------------------- printf ----------------------------------*/

void myPrintf (char *FormatStr, ...)
{
	char Str[266];
	int a;

	a = 0x16c04e75;		/* move.b d0,(a3)+  rts */
	RawDoFmt (FormatStr,(LONG *)((&FormatStr)+1),&a,Str);
	Write (Output (),Str,strlen (Str));
}

/*-------------------------------- CloseStuff --------------------------------*/

void __regargs CloseStuff (int Error)
{
	if (fin) Close (fin);
	if (fout) Close (fout);
	XCEXIT (Error);
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
/*
void OpenStuff ()
{
}
*/
/*----------------------------- String to long -------------------------------*/

void Str2Long (char *s, LONG *l)
{
	sscanf (s,"%ld",l);
}

/*-------------------------- Read a line from file ---------------------------*/

int __regargs rLine (BPTR file, char *buf, int MaxLength)
/* return -1 if eof				*/
/*   -3 if line to long		*/
/* else return length			*/
{
	int Length;
	LONG Len;

	if ((Len = Read (file,buf,MaxLength)) <=0 ) return (-1);
	buf[Len] = 0;
	for (Length=0 ; *buf != 0xa && *buf ; buf++,Length++) ;
	if (Length == MaxLength) return (-3);
	*buf = 0;
	Seek (file,-Len+Length+1L,OFFSET_CURRENT);
	return (Length);
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
UWORD w,curoff;
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
	Write (fout,(UBYTE *)&w,2);
	Write (fout,(UBYTE *)&curoff,2);
}


void RealMain (char *Struct, char *Out)
{
	int lenpos;
	UBYTE b;
	ULONG l;
	int err;
	char line[256];

	if (!(fin = Open (Struct,MODE_OLDFILE)))
		SayError (ERR_OPEN,Struct);
	if (!(fout = Open (Out,MODE_NEWFILE)))
		SayError (ERR_OPENNEW,Out);

	curoff = -1;

	while ((err = rLine (fin,line,255)) >= 0)
		{
			as = SkipSpace (line);
//			line[strlen (line)-1] = 0;
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
					Str2Long (end,&l);
					curoff = l;
					lenpos = Seek (fout,0,OFFSET_CURRENT);
					Write (fout,as,4);				/* Dummy for length later */
				}
			else if ((!strnicmp (as,"long",4)) || (!strnicmp (as,"ulong",5)) ||
					(!strnicmp (as,"aptr",4)))
				{
					w = 2;
					DoIt ();
					curoff += 4;
				}
			else if ((!strnicmp (as,"word",4)) || (!strnicmp (as,"uword",5)))
				{
					w = 1;
					DoIt ();
					curoff += 2;
				}
			else if ((!strnicmp (as,"char",4)) || (!strnicmp (as,"byte",4)) ||
					(!strnicmp (as,"ubyte",5)))
				{
					w = 0;
					DoIt ();
					curoff += 1;
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
					Str2Long (end,&l);
					curoff += l;
				}
			else if (!strnicmp (as,"cstr",4))
				{
					w = 3;
					DoIt ();
					curoff += 4;
				}
			else if (!strnicmp (as,"bstr",4))
				{
					w = 128+3;
					DoIt ();
					curoff += 4;
				}
			else if (!strnicmp (as,"bptr",4))
				{
					w = 128+2;
					DoIt ();
					curoff += 4;
				}
			else if (!strnicmp (as,"struct",6))
				{
					w = 4;
					DoIt ();
					Str2Long (end,&l);
					curoff += l;
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
