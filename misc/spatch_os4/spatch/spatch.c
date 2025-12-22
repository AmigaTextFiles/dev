/* Clone of SAS/C_SPatch 6.51
 * © by Stefan Haubenthal 2005-07
 * AmigaOS 4 port © 2006-2007 Alexandre Balaban
 * No code by SAS Institute, Inc.
 */

#include <proto/dos.h>
#include <proto/iffparse.h>
#include <proto/exec.h>
#include <exec/memory.h>
#include <string.h>
#if !(defined(__VBCC__)) && !defined(__amigaos4__)
#include <dos.h>
#else
#define FNSIZE 108
#endif

#ifdef _DEBUG
#define D(a,b) printf(a,b)
#else
#define D(a,b)
#endif

#define ID_PTCH MAKE_ID('P','T','C','H')
#define ID_VERS MAKE_ID('V','E','R','S')
#define ID_INPF MAKE_ID('I','N','P','F')
#define ID_OUTF MAKE_ID('O','U','T','F')
#define ID_PSEQ MAKE_ID('P','S','E','Q')
#define ID_PMSG MAKE_ID('P','M','S','G')

#define LARGE_APPEND	0x49 /* 16 bit */
#define LARGE_REPLACE	0x52
#define LARGE_DELETE	0x53
#define LARGE_COPY	0x55
#define APPEND		0x69 /* 8 bit */
#define REPLACE		0x72
#define DELETE		0x73
#define COPY		0x75
#define RESERVED	0xe0 /* 5 bit */
#define SMALL_REPLACE	0xc0
#define SINGLE_REPLACE	0xa0
#define SMALL_COPY	0x80

enum {OUTPUT, PATCHFILE, OLDFILE, SIZEOF_ARGS};

#ifdef __amigaos4__
struct IFFParseIFace *IIFFParse = NULL;
#endif // __amigaos4__

#ifndef __AMIGADATE__
#define __AMIGADATE__ "("__DATE__")"
#endif
const char VERsion[]="$VER: spatch 6.51 "__AMIGADATE__" AmigaOS 4.0 version release 4\r\n";

LONG stops[]=
	{
	ID_PTCH, ID_VERS,
	ID_PTCH, ID_INPF,
	ID_PTCH, ID_OUTF,
	ID_PTCH, ID_PSEQ,
	ID_PTCH, ID_PMSG
	};

long calc_sum(BPTR file)
{
unsigned char byte;
long sum=0;

while (Read(file, &byte, sizeof byte))
	sum+=byte;
return sum;
}

unsigned char decode_seq(BPTR oldfile, BPTR newfile, unsigned char *buffer)
{
unsigned short len;
char byte;

while (*buffer)
switch (*buffer)
	{
	case LARGE_APPEND:
		buffer++;
		len=* (unsigned short *) buffer++;
		buffer++;
		D("large append %X\n",len);
		Write(newfile, buffer, len);
		buffer+=len;
		break;
	case LARGE_REPLACE:
		buffer++;
		len=* (unsigned short *) buffer++;
		buffer++;
		D("large replace %X\n",len);
		Seek(oldfile, len, OFFSET_CURRENT);
		Write(newfile, buffer, len);
		buffer+=len;
		break;
	case LARGE_DELETE:
		buffer++;
		len=* (unsigned short *) buffer++;
		buffer++;
		D("large delete %X\n",len);
		Seek(oldfile, len, OFFSET_CURRENT);
		break;
	case LARGE_COPY:
		buffer++;
		len=* (unsigned short *) buffer++;
		buffer++;
		D("large copy %X\n",len);
		while (len--)
			{
			Write(newfile, &byte, Read(oldfile, &byte, sizeof byte));
//			D("%4X\r",len);
			}
		break;
	case APPEND:
		buffer++;
		len=*buffer++;
		D("append %X\n",len);
		Write(newfile, buffer, len);
		buffer+=len;
		break;
	case REPLACE:
		buffer++;
		len=*buffer++;
		D("replace %X\n",len);
		Seek(oldfile, len, OFFSET_CURRENT);
		Write(newfile, buffer, len);
		buffer+=len;
		break;
	case DELETE:
		buffer++;
		len=*buffer++;
		D("delete %X\n",len);
		Seek(oldfile, len, OFFSET_CURRENT);
		break;
	case COPY:
		buffer++;
		len=*buffer++;
		D("copy %X\n",len);
		while (len--)
			Write(newfile, &byte, Read(oldfile, &byte, sizeof byte));
		break;
	default:
		if (*buffer>SMALL_REPLACE)
			{
			len=*buffer++-SMALL_REPLACE;
			D("small replace %X\n",len);
			Seek(oldfile, len, OFFSET_CURRENT);
			Write(newfile, buffer, len);
			buffer+=len;
			break;
			}
		if (*buffer>=SINGLE_REPLACE)
			{
			Read(oldfile, &byte, sizeof byte);
			byte+=*buffer++-SINGLE_REPLACE-0x10;
			D("single replace %X\n",byte);
			Write(newfile, &byte, sizeof byte);
			break;
			}
		if (*buffer>SMALL_COPY)
			{
			len=*buffer++-SMALL_COPY;
			D("small copy %X\n",len);
			while (len--)
				Write(newfile, &byte, Read(oldfile, &byte, sizeof byte));
			break;
			}
		return *buffer;
	}
return 0;
}

int main(void)
{
struct RDArgs *myargs;
LONG args[SIZEOF_ARGS]={0};
char oldfile[FNSIZE], output[FNSIZE], patchfile[FNSIZE];
struct	{
	long sum, len;
	} checksum={0}, checksum2={0};
struct IFFHandle *iff;
LONG err;
unsigned char *buffer;
BPTR in, out;
int rc=RETURN_OK;
#ifdef __amigaos4__

	struct Library * IFFParseBase = OpenLibrary( "iffparse.library", 50 );
	if ( IFFParseBase )
	{
		IIFFParse = ( struct IFFParseIFace* ) GetInterface( IFFParseBase, "main", 1L, 0 );
		if ( IIFFParse )
		{
#endif

if ((myargs=ReadArgs("-o=OUTPUT/K,-p=PATCHFILE/K,OLDFILE/A", args, NULL)))
	{
	strcpy(oldfile, (STRPTR) args[OLDFILE]);
	if (args[OUTPUT])
		strcpy(output, (STRPTR) args[OUTPUT]);
	else	{
		strcpy(output, (STRPTR) args[OLDFILE]);
		strcat(output, ".new");
		}
	if (args[PATCHFILE])
		strcpy(patchfile, (STRPTR) args[PATCHFILE]);
	else	{
		strcpy(patchfile, (STRPTR) args[OLDFILE]);
		strcat(patchfile, ".pch");
		}
	FreeArgs(myargs);
	iff=AllocIFF();
	StopChunks(iff, stops, sizeof stops/sizeof(LONG)/2);
	if( (iff->iff_Stream=Open(patchfile, MODE_OLDFILE)) )
		{
		InitIFFasDOS(iff);
		OpenIFF(iff, IFFF_READ);
		while ((err=ParseIFF(iff, IFFPARSE_SCAN))!=IFFERR_EOF)
			{
			switch (CurrentChunk(iff)->cn_ID)
				{
				case ID_INPF:
					ReadChunkBytes(iff, &checksum, sizeof checksum);
//					ReadChunkBytes(iff, oldfile, CurrentChunk(iff)->cn_Size);
//					oldfile[CurrentChunk(iff)->cn_Size-sizeof checksum]='\0';
					break;
				case ID_OUTF:
					ReadChunkBytes(iff, &checksum2, sizeof checksum2);
//					ReadChunkBytes(iff, output, CurrentChunk(iff)->cn_Size);
//					output[CurrentChunk(iff)->cn_Size-sizeof checksum]='\0';
					break;
				case ID_PSEQ:
					if ((in=Open(oldfile, MODE_OLDFILE)) && (out=Open(output, MODE_NEWFILE)))
						{
						if (calc_sum(in)==checksum.sum)
							if( (buffer=AllocVec(CurrentChunk(iff)->cn_Size+1, MEMF_ANY|MEMF_CLEAR)) )
								{
								char pseq;
								Seek(in, 0, OFFSET_BEGINNING);
								ReadChunkBytes(iff, buffer, CurrentChunk(iff)->cn_Size);
								if( (pseq=decode_seq(in, out, buffer)) )
									{
									Printf("Please report unknown PSEQ command %lX\n", pseq);
//									rc=RETURN_ERROR+4;
									}
								FreeVec(buffer);
								Seek(out, 0, OFFSET_BEGINNING);
								if (calc_sum(out)!=checksum2.sum)
									{
									Printf("Final patched file fails checksum and is invalid\n");
									rc=RETURN_ERROR+3;
									}
								}
							else
								{
								Printf("Out of memory\n");
								rc=RETURN_ERROR+1;
								}
						else
							{
							Printf("Initial checksum incorrect\n");
							rc=RETURN_ERROR+2;
							}
						Close(out);
						}
					else
						{
						PrintFault(IoErr(), "spatch");
						rc=RETURN_ERROR;
						}
					if (in)
						Close(in);
					break;
//				case ID_VERS:
				case ID_PMSG:
					if( (buffer=AllocVec(CurrentChunk(iff)->cn_Size, MEMF_ANY)) )
						{
						Write(Output(), buffer, ReadChunkBytes(iff, buffer, CurrentChunk(iff)->cn_Size));
						FreeVec(buffer);
						}
					break;
				}
			}
		CloseIFF(iff);
		Close(iff->iff_Stream);
		}
	else
		{
		PrintFault(IoErr(), "spatch");
		rc=RETURN_ERROR;
		}
	FreeIFF(iff);
	}
else
	rc = -1;

#ifdef __amigaos4__
			DropInterface( ( struct Interface* ) IIFFParse );
			CloseLibrary( IFFParseBase );

		}
		else
		{
			CloseLibrary( IFFParseBase );
			PrintFault( ERROR_INVALID_RESIDENT_LIBRARY, "spatch" );
			rc = -1;
		}
	}
	else
	{
		PrintFault( ERROR_INVALID_RESIDENT_LIBRARY, "spatch" );
		rc = -1;
	}
#endif

	return rc;
}
