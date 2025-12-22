/*
 * Quick written test suite for the named functions.
 *
 * Written 2008 J.v.d.Loo (-=ONIX=-)
 *
 * vc -c99 -cpu=68020 -const-in-data -O1 -sc -sd demo.c -o Demo -lvcs -lunisupps
 * vc +morphos demo.c -O1 -sd -o Demo -lvcs -lunisupps
 * vc +aosppc -D__USE_INLINE__ demo.c -O1 -sd -o Demo -lvcs -lunisupps
 */

#include <stdio.h>

#include <exec/libraries.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <libraries/locale.h>
#include <libraries/uni.h>

#include <proto/exec.h>
#include <proto/dos.h>

#define  __NOLIBBASE__		/* No need to auto-open these libraries */
#include <proto/locale.h>	/* nor to create external library bases */
#include <proto/uni.h>

#include <proto/unisupport.h>	/* Functions of static library */


/* The library bases we use */
struct Library *UniBase;

#if !defined(__amigaos4__)
struct LocaleBase *LocaleBase;
#else
struct Library *LocaleBase;
#endif

/* In case we compile it for OS4 we need also the Interfaces */
#if defined(__amigaos4__)
struct UniIFace *IUni;
struct LocaleIFace *ILocale;
#endif


/* Returned encoding of UniCheckEncoding() corresponds diretly with this */

unsigned char *EncodingsTxt[10] =
{
	"unknown",	/* <- the only encoding that cannot occcur */
	"UTF-8",
	"UTF-16 LE (Intel/AMD)",
	"UTF-16 BE (Motorola)",
	"UTF-32 LE (Intel/AMD)",
	"UTF-32 BE (Motorola)",
    "UTF-8 by guessing",
	"LATIN-1 by guessing",
	"ASCII by guessing",
	0
};

/* Supported ISO-8859-x character sets; used upon displaying texts to the console */

TEXT *ISOEncodingTxt[18] =
{
	"ISO-8859-1 (Western European)",
	"ISO-8859-2 (Central European)",
	"ISO-8859-3 (South European)",
	"ISO-8859-4 (North European)",
	"ISO-8859-5 (Cyrillic)",
	"ISO-8859-6 (Arabic)",
	"ISO-8859-7 (Greek)",
	"ISO-8859-8 (Hebrew)",
	"ISO-8859-9 (Turkish)",
	"ISO-8859-10 (Nordic)",
	"ISO-8859-11 (Thai - strictly, not in ISO norm family)",
	"ISO-8859-12",	/* Not allowed! */
	"ISO-8859-13 (Baltic Rim)",
	"ISO-8859-14 (Celtic)",
	"ISO-8859-15 (Extended Western European)",
	"ISO-8859-16 (South-Eastern European)",
	0
};

/* UTF encoding schemes (UCS 2/4 not supported!) */

TEXT *UTFEncodingTxt[6] =
{
	"UTF-16  Big Endian  (Motorola)",
	"UTF-16  Little Endian  (Intel/AMD)",
	"UTF-16  (Each chunk of text needs BOM to be set)",
	"UTF-32  (Each chunk of text needs BOM to be set)",
	"UTF-32  Big Endian  (Motorola)",
	"UTF-32  Little Endian  (Intel/AMD)"
};

/* Additional... */

TEXT UTF8_EncodingTxt[] = "UTF-8 (multibyte encoding scheme)";
TEXT TIS_620_EncodingTxt[] = "TIS-620 (Thai)";
TEXT Amiga_1251_EncodingTxt[] = "Amiga-1251 (Cyrillic with Euro sign)";
TEXT Unsupported_EncodingTxt[] = "unsupported (using as fallback ISO-8859-1)";


/* Return a brief description (string) that is related to the IANA-ID */

TEXT *GetEncodingScheme( ULONG iana_id)
{
	if (iana_id < 15)	/* ISO-8859-1 to ISO-8859-11? */
	{
		return ISOEncodingTxt[iana_id - 4];
	}
	else
	{
		if (iana_id == 106)	/* UTF-8? */
		{
			return UTF8_EncodingTxt;
		}
		else
		{
			if (iana_id > 108 && iana_id < 113)	/* ISO-8859-13 to ISO-8859-16? */
			{
				return ISOEncodingTxt[iana_id - 97];
			}
			else
			{
				if (iana_id > 1012 && iana_id < 1020)	/* UTF-16/32 */
				{
					return UTFEncodingTxt[iana_id - 1013];
				}
				else
				{
					if (iana_id == 2104)	/* Amiga-1251? */
					{
						return Amiga_1251_EncodingTxt;
					}
					else
					{
						if (iana_id == 2259)	/* TIS-620? */
						{
							return TIS_620_EncodingTxt;
						}
						else
						{
							return Unsupported_EncodingTxt;
						}
					}
				}
			}
		}
	}
}

/*
 * Small function to determine file size of a file (ANSI-C - not Amiga alike!)
 */

long FileSize( FILE *stream)
{
	long curpos, length = 0;

	curpos = ftell(stream);
	if ( !(ferror( stream)) )
	{
		fseek(stream, 0L, SEEK_END);
		if ( !(ferror( stream)) )
		{
			length = ftell(stream);
			if ( !(ferror( stream)) )
			{
				fseek(stream, curpos, SEEK_SET);
				if ( (ferror( stream)) )
					length = 0;
			}
			else
			{
				length = 0;
			}
		}
	}
	return length;
}

/*
 * Read a file (its binary form) from disk into memory
 */

int ReadFile( const char *fname, void **ptr, unsigned *sz)
{
	unsigned char *str;
	int err;

	FILE *stream = fopen( fname, "rb");

	if (stream)
	{
		long fsize = FileSize( stream);

		if (fsize > 0)
		{
			/* Make space for zero byte/word/long (+4) at end of file and also
			   divisable by eight */
			*ptr = (void *) AllocVec( (((fsize + 4) + 7) & -8), MEMF_CLEAR);
			if (*ptr)
			{
				*sz = fread( *ptr, sizeof (unsigned char), (unsigned) fsize, stream);

				if (*sz != fsize || (err = ferror( stream)) )	/* File corrupt? */
				{
					*sz = 0;
					FreeVec( *ptr);
					*ptr = NULL;
				}
				/* Else, okay */
			}
			else	/* Insufficient RAM */
			{
				*sz = 0;
				err = ERROR_NO_FREE_STORE;
			}
		}
		else	/* Impossible to deal with negative file sizes */
		{
			*ptr = NULL;
			*sz = 0;
			err = 20;
		}

		fclose( stream);
	}
	else	/* File not accessible */
	{
		*ptr = NULL;
		*sz = 0;
	}

	return err;
}



int main( int argc, char **argv)
{
	int error;
	TEXT *src = NULL, *dest = NULL;
	ULONG inlength, outlength, cps, encoding, iana_id, iana_id_src;
	struct Locale *user;
	BOOL okay;

	UniBase = (struct Library *) OpenLibrary( "uni.library", 5);
	if ( !UniBase)
	{
		printf( "Unable to open Uni-Library!\n");
		return 122;
	}

	#if defined(__amigaos4__)
		IUni = (struct UniIFace *) GetInterface( (struct Library *) UniBase, "main", 1, NULL);
		if ( !IUni)
		{
			CloseLibrary( UniBase);
			printf( "Unable to open interface \"IUni\"!");
			return 122;
		}
	#endif

	#if !defined(__amigaos4__)
		LocaleBase = (struct LocaleBase *) OpenLibrary( "locale.library", 1);
	#else
		LocaleBase = (struct Library *) OpenLibrary( "locale.library", 1);
		if (LocaleBase)
		{
			ILocale = (struct LocaleIFace *) GetInterface( (struct Library *) LocaleBase, "main", 1, NULL);
			if ( !ILocale)
			{
				CloseLibrary( (struct Library *) LocaleBase);
				LocaleBase = NULL;
			}
		}
	#endif

	/* Get the user defaults */
	if (LocaleBase)
		user = (struct Locale *) OpenLocale( NULL);
	else
		user = NULL;

	/* Get the IANA ID */
	if (user)
		iana_id = user->loc_CodeSet;	
	else
		iana_id = 0;

	/* A filename supplied */
	if (argc > 1)
	{
		if ( !(error = ReadFile( argv[1], (void *) &src, (unsigned *) &inlength)) )
		{
			/* Check the encoding! */
			encoding = UniCheckEncoding( (void *) src, (void *) ((TEXT *) src + inlength));
			printf( "Source file \"%s\" was encoded using \"%s\" encoding scheme!\n", argv[1], EncodingsTxt[encoding]);
			printf( "Source file size: %lu bytes\n", inlength);

			if (iana_id == 0)	/* OS 3.x sets no IANA ID */
				iana_id = 4;	/* but uses ISO-8859-1 */

			iana_id_src = iana_id;	/* Set the source IANA ID */

			if (encoding == UTF8_GUESSED)
				iana_id_src = 0;		/* Don't force to interpret encoding scheme!!! */

			printf( "System uses \"%s\" as default encoding scheme.\n", GetEncodingScheme( iana_id) );

			okay = UniConvertToUTF8( (void *) src, inlength, iana_id_src, encoding, &dest, &outlength, &cps);
			if (okay == TRUE)
			{
				printf( "Transcoded input file - UTF-8 sequences can be found in '%s' buffer\n", dest ? "dest" : "src");
				printf( "Amount code points in new file: %lu. Size in bytes: %lu\n", cps, outlength);

				/* If a new buffer was allocated */
				if (dest)
				{
					FreeVec( src);
					src = dest;
					dest = NULL;
				}

				/* Destination becomes source... */
				inlength = outlength;

				if (iana_id != 106)	/* Once the operating system supports UTF-8
									   we don't need to transcode it back to ISO-8859-x */
				{
					printf( "Converting now the UTF-8 text to singlebyte character encoding\nscheme: \"%s\"\n",
							 GetEncodingScheme( iana_id));
					if ( (UniFromUTF8ToSces( src, inlength, cps, &dest, &outlength, iana_id)) )
					{
						printf ("Text successfully converted, result:\n>>>\n%s\n<<<\n", dest);
					}
				}
				else
				{
					printf( "System supports UTF-8: Here the result:\n>>>\n%s\n<<<\n", src);
				}
			}
			else
			{
				printf( "Couldn't transcode input file...\n");
			}
		}
		else
		{
			printf( "Cannot read in file \"%s\"\nTerminating.\n", argv[1]);
		}
	}


	if (dest)
		FreeVec( dest);
	if (src)
		FreeVec( src);

	if (user)
		CloseLocale( user);

	#if defined(__amigaos4__)
		if (LocaleBase)
			DropInterface( (struct Interface *) ILocale);
	#endif

	if (LocaleBase)
		CloseLibrary( (struct Library *) LocaleBase);

	#if defined(__amigaos4__)
		DropInterface( (struct Interface *) IUni);
	#endif
	CloseLibrary( UniBase);

	return 0;
}
