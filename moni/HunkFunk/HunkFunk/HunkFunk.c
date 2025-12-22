/****************************************************************************
*
*	HunkFunk.c ----	Source code for HunkFunk Amiga object/binary file
*			scanner.
*
*	Author --------	Olaf 'Olsen' Barthel, MXM
*			Brabeckstrasse 35
*			D-3000 Hannover 71
*
*	Compiler ------	Aztec 'C' 5.0
*
*			Use: CC -so HunkFunk.c
*			     LN HunkFunk.o -Lc
*
*	HunkFunk is © Copyright 1990 by MXM. Source code and executable
*	file are both placed in the public domain. A small copy fee
*	is okay, but anything which looks, smells or tastes like commercial
*	distribution must be registered with the author.
*
****************************************************************************/

#include <libraries/dosextens.h>
#include <functions.h>

	/* Hunk identifiers. */

#define HUNK_UNIT	0x03E7	/* Date unit to follow. */
#define HUNK_NAME	0x03E8	/* Define a name. */
#define HUNK_CODE	0x03E9	/* Code block to follow. */
#define HUNK_DATA	0x03EA	/* Data block to follow. */
#define HUNK_BSS	0x03EB	/* Data block to create. */
#define HUNK_RELOC32	0x03EC	/* 32-bit relocation information. */
#define HUNK_RELOC16	0x03ED	/* 16-bit relocation information (object files only). */
#define HUNK_RELOC8	0x03EE	/* 8-bit relocation information (object files only). */
#define HUNK_EXT	0x03EF	/* Extended data (object files only). */
#define HUNK_SYMBOL	0x03F0	/* A name symbol. */
#define HUNK_DEBUG	0x03F1	/* Debug information (compiler/assembler dependent). */
#define HUNK_END	0x03F2	/* End of unit. */
#define HUNK_HEADER	0x03F3	/* Segment header. */

	/* Note the gap between HUNK_HEADER and HUNK_OVERLAY. */

#define HUNK_OVERLAY	0x03F5	/* Overlay root node. */
#define HUNK_BREAK	0x03F6	/* End of overlay node. */

#define EXT_DEF		1	/* Symbol definition. */
#define EXT_ABS		2	/* Absolute reference. */
#define EXT_RES		3	/* Same as EXT_DEF? */
#define EXT_REF32	129	/* 32-bit reference. */
#define EXT_COMMON	130	/* 32-bit reference/BSS. */
#define EXT_REF16	131	/* 16-bit reference. */	
#define EXT_REF8	132	/* 8-bit reference. */	

	/* Some simple macros. */

#define ReadLong()	Read(FileHandle,&Type,sizeof(ULONG))
#define ReadName(Longs)	Read(FileHandle,NameString,sizeof(LONG) * (Longs))
#define SkipLong(Longs)	Seek(FileHandle,sizeof(LONG) * (Longs),OFFSET_CURRENT)
#define MakeName(Longs) NameString[Longs * sizeof(LONG)] = 0

	/* Unit load types. */

#define TYPE_CHIP	1
#define TYPE_FAST	2

	/* Disable the standard ^C handling. */

LONG Chk_Abort(VOID) { return(0); }
VOID _wb_parse(VOID) {}

void
main(int argc,char **argv)
{
	BPTR	FileHandle;
	ULONG	Type;
	char	NameString[257];
	LONG	i,From,To;
	UBYTE	PrintFlag;

		/* Info? */

	if(argc < 2)
	{
		puts("Usage: HunkFunk <File>");
		exit(RETURN_OK);
	}

		/* Open file to be examined. */

	if(!(FileHandle = Open(argv[1],MODE_OLDFILE)))
	{
		printf("HunkFunk: Couldn't open file \"%s\"!\n",argv[1]);
		exit(RETURN_FAIL);
	}

		/* Scan the file until EOF. */

	for(;;)
	{
			/* End of file? */

		if(ReadLong() != sizeof(LONG))
			break;

			/* User pressed ^C? */

		if(SetSignal(NULL,NULL) & SIGBREAKF_CTRL_C)
		{
			printf("*** Break\a\n");

			SetSignal(NULL,SIGBREAKF_CTRL_C);
			goto Quit;
		}

			/* Look which type it is. */

		switch(Type & 0xFFFF)
		{
			case HUNK_UNIT:		ReadLong();

						if(Type)
							ReadName(Type);

						MakeName(Type);

						printf("HUNK_UNIT    \"%s\"\n",NameString);
						break;

			case HUNK_NAME:		ReadLong();

						if(Type)
							ReadName(Type);

						MakeName(Type);

						printf("HUNK_NAME    \"%s\"\n",NameString);
						break;

			case HUNK_CODE:		ReadLong();
						SkipLong(Type);
						printf("HUNK_CODE    %ld Bytes\n",Type << 2);
						break;

			case HUNK_DATA:		ReadLong();
						SkipLong(Type);
						printf("HUNK_DATA    %ld Bytes\n",Type << 2);
						break;

			case HUNK_BSS:		ReadLong();
						printf("HUNK_BSS     %ld Bytes\n",Type << 2);
						break;

			case HUNK_RELOC32:	printf("HUNK_RELOC32\n");

						for(;;)
						{
							ReadLong();

							if(SetSignal(NULL,NULL) & SIGBREAKF_CTRL_C)
							{
								printf("*** Break\a\n");

								SetSignal(NULL,SIGBREAKF_CTRL_C);
								goto Quit;
							}

							if(Type)
							{
								SkipLong(1);
								SkipLong(Type);
							}
							else
								break;
						}

						break;

			case HUNK_RELOC16:	printf("HUNK_RELOC16\n");

						for(;;)
						{
							ReadLong();

							if(SetSignal(NULL,NULL) & SIGBREAKF_CTRL_C)
							{
								printf("*** Break\a\n");

								SetSignal(NULL,SIGBREAKF_CTRL_C);
								goto Quit;
							}

							if(Type)
							{
								SkipLong(1);
								SkipLong(Type);
							}
							else
								break;
						}

						break;

			case HUNK_RELOC8:	printf("HUNK_RELOC8\n");

						for(;;)
						{
							ReadLong();

							if(SetSignal(NULL,NULL) & SIGBREAKF_CTRL_C)
							{
								printf("*** Break\a\n");

								SetSignal(NULL,SIGBREAKF_CTRL_C);
								goto Quit;
							}

							if(Type)
							{
								SkipLong(1);
								SkipLong(Type);
							}
							else
								break;
						}

						break;

			case HUNK_EXT:		printf("HUNK_EXT\n");

						for(;;)
						{
							ReadLong();

							if(SetSignal(NULL,NULL) & SIGBREAKF_CTRL_C)
							{
								printf("*** Break\a\n");

								SetSignal(NULL,SIGBREAKF_CTRL_C);
								goto Quit;
							}

							if(!Type)
								break;

							switch((Type >> 24) & 0xFF)
							{
								case EXT_DEF:	printf("             EXT_DEF\n");
										break;

								case EXT_ABS:	printf("             EXT_ABS\n");
										break;

								case EXT_RES:	printf("             EXT_RES\n");
										break;

								case EXT_REF32:	printf("             EXT_REF32\n");
										break;

								case EXT_COMMON:printf("             EXT_COMMON\n");
										break;

								case EXT_REF16:	printf("             EXT_REF16\n");
										break;

								case EXT_REF8:	printf("             EXT_REF8\n");
										break;

								default:	printf("             EXT_??? (0x%02x)\n",(Type >> 24) & 0xFF);
										break;
							}

							PrintFlag = FALSE;

								/* Is it followed by a symbol name? */

							if(Type & 0xFFFFFF)
							{
								ReadName((Type & 0xFFFFFF));
								MakeName((Type & 0xFFFFFF));

								printf("             %s",NameString);

								PrintFlag = TRUE;
							}

								/* Remember extension type. */

							i = (Type >> 24) & 0xFF;

								/* Display value of symbol. */

							if(i == EXT_DEF || i == EXT_ABS || i == EXT_RES)
							{
								if(!(Type & 0xFFFFFF))
									printf("???");

								ReadLong();

								printf(" = 0x%08lx",Type);

								PrintFlag = TRUE;
							}

							if(PrintFlag)
								printf("\n");

								/* Skip relocation information. */

							if(i == EXT_REF32 || i == EXT_REF16 || i == EXT_REF8)
							{
								ReadLong();
								SkipLong(Type);
							}

								/* Display size of common block. */

							if(i == EXT_COMMON)
							{
								ReadLong();

								printf("      Size = %ld Bytes\n",Type << 2);

								ReadLong();
								SkipLong(Type);
							}
						}

						break;

			case HUNK_SYMBOL:	printf("HUNK_SYMBOL\n");

						for(;;)
						{
							ReadLong();

							if(SetSignal(NULL,NULL) & SIGBREAKF_CTRL_C)
							{
								printf("*** Break\a\n");

								SetSignal(NULL,SIGBREAKF_CTRL_C);
								goto Quit;
							}

							if(!Type)
								break;

								/* Display name. */

							ReadName((Type & 0xFFFFFF));
							MakeName((Type & 0xFFFFFF));

							printf("             %s",NameString);

								/* Display value. */

							ReadLong();

							printf(" = 0x%08lx\n",Type);
						}

						break;

			case HUNK_DEBUG:	ReadLong();
						SkipLong(Type);

						printf("HUNK_DEBUG   %ld Bytes\n",Type << 2);
						break;

			case HUNK_END:		printf("HUNK_END\n\n");
						break;

			case HUNK_HEADER:	printf("HUNK_HEADER\n");

						for(;;)
						{
							ReadLong();

							if(SetSignal(NULL,NULL) & SIGBREAKF_CTRL_C)
							{
								printf("*** Break\a\n");

								SetSignal(NULL,SIGBREAKF_CTRL_C);
								goto Quit;
							}

								/* Display names of resident libraries. */

							if(Type)
							{
								ReadName(Type);
								MakeName(Type);

								printf("      Name = %s\n",NameString);
							}
							else
								break;
						}

						ReadLong();

						printf("  Numhunks = %ld (",Type);

						ReadLong();
						printf("%ld to ",From = Type);

						ReadLong();
						printf("%ld)\n",To = Type);

							/* Display hunk lengths/types. */

						for(i = 0 ; i < To - From + 1 ; i++)
						{
							ReadLong();
							printf("  Hunk %03ld = %ld Bytes ",i,(Type & 0x3FFFFFFF) << 2);

							if((Type >> 30) == TYPE_CHIP)
								printf("CHIP");

							if((Type >> 30) == TYPE_FAST)
								printf("FAST");

							printf("\n");
						}

						break;

			case HUNK_OVERLAY:	printf("HUNK_OVERLAY\n");

						ReadLong();

						/* 8 * Entries + Levels + 1 */

						From = Type;

						ReadLong();

						To = Type - 2;

						From -= (To + 1);

						printf("    Levels = %ld\n",To);
						printf("   Entries = %ld\n",From / 8);

						Seek(FileHandle,(From + To + 1) * sizeof(LONG),OFFSET_CURRENT);

						break;

			case HUNK_BREAK:	printf("HUNK_BREAK\n\n");
						break;

			default:		printf("HUNK_??? (0x%04lx) - Aborting!\a\n",Type & 0xFFFF);
						goto Quit;
		}
	}

Quit:	Close(FileHandle);

	exit(RETURN_OK);
}
