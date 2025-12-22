/* Bump.c ©1999 Robin Cloutman. All Rights Reserved. */

#include <exec/memory.h>
#include <exec/execbase.h>
#include <dos/dos.h>
#include <dos/datetime.h>
#include <dos/rdargs.h>
#include <dos/var.h>

#include <proto/exec.h>
#include <proto/dos.h>

#include "Bump.h"
#include "Bump_rev.h"

/*
 * Global data...
 */
const char version[]	= VERSTAG "©1999 Robin Cloutman";
const char defpath[]	= DEFPATH;
const char revver[]		= "_rev.ver";
const char ld[]			= "%ld";
const char ldld[]		= "%ld.%ld\n";
const char showver[]	= "$VER: %n %v.%r (%d)\n";
const char prefix[]		= PREFIX;
const char varname[]	= VARNAME;
const char vers[]		= VERS;
const char template[]	= TEMPLATE;

/*
 * Code...
 */
int _start (char *argstr, int32 arglen, struct ExecBase *SysBase) {
	int ret = RETURN_OK;
	struct ExecIFace *IExec;
	struct Library *DOSBase;
	struct DOSIFace *IDOS;

	IExec = (struct ExecIFace *)SysBase->MainInterface;

	DOSBase = OpenLibrary(DOSNAME, 36);
	IDOS = (struct DOSIFace *)GetInterface(DOSBase, "main", 1, NULL);
	if (IDOS == NULL)
		ret = RETURN_FAIL;
	else {
		struct RDArgs	*rargs;
		LONG args[ARGS_count] = { 0 };

		if ( !( rargs = ReadArgs( template, args, NULL ) ) )ret = RETURN_ERROR, PrintFault( ERROR_REQUIRED_ARG_MISSING, NULL );
		else {
			BPTR file = ZERO, outfile = ZERO;
			char filename[MAX_BUFFER], path[MAX_BUFFER], code[MAX_BUFFER], buffer[MAX_BUFFER], *name = NULL, *buf, **files = (char **)args[ARGS_code];
			unsigned long oldver = 0, ver = 0, oldrev = 0, rev = 0, namelen = 0, codelen = 0, n = 0;

			for( name = (char *)args[ARGS_name] ; namelen <= ( MAX_BUFFER - 8 ) && name[namelen] != '\0' ; namelen++ ) filename[namelen] = name[namelen];
			name = FilePart( (char *)args[ARGS_name] );
			strcat( namelen, filename, revver );
			namelen += 5;
			if ( ( file = Open( filename, MODE_OLDFILE ) ) )
			{
				if ( Read( file, buffer, MAX_BUFFER ) )
				{
					n = StrToLong( &buffer[0], &oldver );
					if ( n && n != -1 && buffer[n] == '.' )StrToLong( &buffer[++n], &oldrev );
				}
				Close( file );
			}
			rev = oldrev;
			ver = oldver;
			if ( args[ARGS_version] )ver++, rev = 0;
			else if ( !args[ARGS_norevision] )rev++;
			if ( args[ARGS_setrevision] )rev = (unsigned long)(*((long **)args[ARGS_setrevision]));
			if ( args[ARGS_setversion] )ver = (unsigned long)(*((long **)args[ARGS_setversion]));
			if ( ver != oldver || rev != oldrev )
			{
				if ( ( file = Open( filename, MODE_NEWFILE ) ) )
				{
					FPrintf( file, ldld, ver, rev );
					Close( file );
				}
				if ( !args[ARGS_quiet] )bust_me( Output(), showver, name, ver, rev, IDOS );
			}
			buf = PathPart( strcat( 0, path, (char *)args[ARGS_name] ) );
			buf[0] = '\0';
			if (files) {
			for ( file = ZERO ; *files ; files++, file = outfile = ZERO )
			{
				strcat( 0, code, path );
				if ( code[0] != '\0' && AddPart( code, prefix, MAX_BUFFER ) )file = Open( strcat2( code, *files ), MODE_OLDFILE );
				if ( !file && ( file = Open( strcat2( strcat( 0, code, prefix ), *files ), MODE_OLDFILE ) ) == ZERO )
					if ( AddPart( strcat( 0, code, defpath ), prefix, MAX_BUFFER ) && ( file = Open( strcat2( code, *files ), MODE_OLDFILE ) ) == ZERO )
						if ( ( codelen = GetVar( varname, code, MAX_BUFFER, 0 ) ) != -1 )
							if ( AddPart( code, prefix, MAX_BUFFER ) )
								file = Open( strcat2( code, *files ), MODE_OLDFILE );
				if ( !file )break;
				while ( ( buf = FGets( file, &buffer[0], MAX_BUFFER-1 ) ) != NULL )if ( buf[0] == '#' && buf[1] == '#' )
				{
					for ( buf += 2 ; *buf == ' ' ; buf++ );
					if ( ( n = strcmp( "suffix", buf ) ) )
					{
						for ( buf += n, n = 0 ; *buf == ' ' ; buf++ )n++;
						if ( outfile )Close( outfile );
						if ( MAX_BUFFER-namelen-n > 0 )
						{
							buf[MAX_BUFFER-namelen-n] = '\0';
							outfile = Open( strcat( namelen, filename, buf ), MODE_NEWFILE );
						} else outfile = ZERO;
					}
					else if ( ( n = strcmp( "inform", buf ) ) )
					{
						for ( buf += n ; *buf == ' ' ; buf++ );
						if ( !args[ARGS_quiet] )bust_me( Output(), buf, name, ver, rev, IDOS );
					}
					else if ( ( n = strcmp( "filename", buf ) ) )
					{
						for ( buf += n ; *buf == ' ' ; buf++ );
						if ( outfile )Close( outfile );
						strcat( 0, code, path );
						if ( AddPart( code, buf, MAX_BUFFER ) )
						{
							for ( buf = code ; *buf ; buf++ )if ( *buf == '\n' || *buf == '\r' )*buf = '\0';
							outfile = Open( code, MODE_NEWFILE );
						}
						else outfile = ZERO;
					}
				} else if ( outfile )bust_me( outfile, buf, name, ver, rev, IDOS );
				Close( file );
				if ( outfile )Close( outfile );
			}
			}
			FreeArgs( rargs );
		}
		DropInterface((struct Interface *)IDOS);
	}
	CloseLibrary(DOSBase);
	return ret;
}

char *strcat( unsigned long start, char *str, const char *append )
{
	str[start] = '\0';
	return strcat2( str, append );
}

char *strcat2( char *str, const char *append )
{
	char *ret = str;

	while( *str )str++;
	while( *append && *append != '\n' && *append != '\r' )*str++ = *append++;
	*str = '\0';
	return ret;
}

long strcmp( const char *a, const char *b )
{
	register long n = 0;
	for ( ; a[n] && b[n] ; n++ )if ( LOWER(a[n]) != LOWER(b[n]) )return 0;
	return n;
}

void bust_me( BPTR file, const char *from, char *name, int ver, int rev, struct DOSIFace *IDOS )
{
	char buf[MAX_BUFFER], date[9] = { "XX.XX.XX\0" }, time[9] = { "XX:XX:XX\0" };
	const char *txt;
	int n = 0, num = 0;
	struct DateTime dt = { { 0, 0, 0 }, FORMAT_CDN, 0, NULL, NULL, NULL };
	dt.dat_StrDate = date;
	dt.dat_StrTime = time;

	DateStamp( &dt.dat_Stamp );
	DateToStr( &dt );
	date[2] = date[5] = '.';
	for ( txt = ld ; *from != '\0' ; txt = ld, num = 0 )
	{
		for( n = 0 ; *from != '%' && *from != '\0' ; buf[n++] = *from++ );
		if ( n )buf[n] = '\0', VFPrintf( file, (char *)&buf, (void *)0 );
		if ( *from++ == '%' )
		{
			switch( *from++ )
			{
				case 'v':	num = ver;		break;
				case 'r':	num = rev;		break;
				case 'd':	txt = date;		break;
				case 't':	txt = time;		break;
				case 'n':	txt = name;		break;
				case 'V':	txt = vers;		break;
				case 'l':
					switch( *from++ )
					{
						case 'v':	while ( ver >= (10^(++num)) );	break;
						case 'r':	while ( rev >= (10^(++num)) );	break;
						case 'd':	num = 8;									break;
						case 't':	num = 8;									break;
						case 'n':	while ( name[++num] != '\0' );	break;
						case 'V':	while ( vers[++num] != '\0' );	break;
						default:		txt = NULL;								break;
					}
					break;
				case '%':	txt = "%%";		break;
				default:		txt = NULL;		break;
			}
			if ( txt != NULL )VFPrintf( file, txt, &num );
		} else --from;
	}
}
