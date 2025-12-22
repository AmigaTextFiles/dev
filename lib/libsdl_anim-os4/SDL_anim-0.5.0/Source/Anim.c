/*
	SDL_anim:  an animation library for SDL
	Copyright (C) 2001  Michael Leonhard

	This library is under the GNU Library General Public License.
	See the file "COPYING" for details.

	Michael Leonhard
	mike@tamale.net
*/

#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "SDL_anim.h"

/* deal with MSVC++ crappiness */
#ifdef WIN32
	#include <io.h>
	#define strcasecmp _strcmpi
	#define stat _stat
	#define O_RDONLY _O_RDONLY
	#endif

#define MAXTOKENS 16

char *ANIM_endofline( char *line );
char *ANIM_loadtextfile( const char *filename );
int ANIM_ProcessFile( SDL_Animation *anim, char *line, char *dir );
int ANIM_ProcessLine( SDL_Animation *anim, char **tokens, char *dir );
char **ANIM_tokenizeline( char *line );

char *ANIM_endofline( char *line ) {
	while( (*line != 0) && (*line != '\r') && (*line != '\n') ) line++;
	if( *line == 0 ) return line;
	*line = 0;
	line++;
	return line;
	}// ANIM_endofline

char *ANIM_loadtextfile( const char *filename ) {
	char *data;
	int fh;
	int filesize, dataread;

	struct stat st;
	if( stat( filename, &st ) != 0 ) {
		ANIM_SetError( "stat() failed" );
		return NULL;
		}
	filesize = st.st_size;
	
	fh = open( filename, O_RDONLY );
	if( fh == -1 ) {
		ANIM_SetError( "open() failed" );
		return NULL;
		}

	data = (char *)malloc( filesize + 1 );
	if( !data ) {
		ANIM_SetError( "malloc() failed" );
		close( fh );
		return 0;
		}
	printf( "allocated %d bytes\n", filesize );

	dataread = read( fh, data, filesize );
	close( fh );
	if( !dataread ) {
		ANIM_SetError( "read() failed" );
		free( data );
		return NULL;
		}

	printf( "read %d bytes\n", dataread );

	data[dataread] = 0;
	return data;
	} // ANIM_loadtextfile

int ANIM_ProcessFile( SDL_Animation *anim, char *line, char *dir ) {
	char *next, **tokens;

	//verify signature
	next = ANIM_endofline( line );
	if( strcmp( line, "SDL_anim v1" ) != 0 ) {
		ANIM_SetError( "File has no `SDL_anim v1' signature" );
		return 0;
		}
	
	//process each line
	line = next;
	while( *line ) {
		next = ANIM_endofline( line );
		tokens = ANIM_tokenizeline( line );
		if( !tokens ) return 0;
		if( !ANIM_ProcessLine( anim, tokens, dir ) ) {
			free( tokens );
			return 0;
			}
		free( tokens );
		line = next;
		}

	if( !anim->surface ) {
		ANIM_SetError( "File has no IMAGE tag" );
		return 0;
		}
	if( !anim->frames ) {
		ANIM_SetError( "File has no FRAMES tag" );
		return 0;
		}
	if( anim->duration < (Uint32)anim->frames ) {
		ANIM_SetError( "DURATION is less than FRAMES" );
		return 0;
		}
	if( anim->surface->w % anim->frames ) {
		printf( "%d %% %d == %d\n", anim->surface->w, anim->frames, anim->surface->w % anim->frames );
		ANIM_SetError( "image width is not a multiple of FRAMES" );
		return 0;
		}
	anim->w = anim->surface->w / anim->frames;
	anim->h = anim->surface->h;
	return 1;
	}// ANIM_ProcessFile

int ANIM_ProcessLine( SDL_Animation *anim, char **tokens, char *dir ) {
	int parms[MAXTOKENS], count;
	char **counter;

	//count tokens
	count = 0;
	counter = tokens;
	while( *counter ) {
		parms[count] = atoi( *counter );
		counter++;
		count++;
		}
	if( !count ) return 1;
	if( count < 2 ) {
		ANIM_SetError( "syntax error" );
		return 0;
		}

	for( ; count < MAXTOKENS; count++ ) parms[count] = 0;

	//match commands
	if( strcasecmp( *tokens, "FRAMES" ) == 0 ) anim->frames = parms[1];
	else if( strcasecmp( *tokens, "DURATION" ) == 0 ) anim->duration = parms[1];
	else if( strcasecmp( *tokens, "IMAGE" ) == 0 ) {
		if( anim->image ) {
			ANIM_SetError( "syntax error: IMAGE found twice in anim file" );
			return 0;
			}
		anim->image = (char *)malloc( strlen( dir ) + strlen( tokens[1] ) + 1 );
		if( !anim->image ) {
			ANIM_SetError( "malloc() failed" );
			return 0;
			}
		strcpy( anim->image, dir );
		strcat( anim->image, tokens[1] );

		anim->surface = (anim->loader)( anim->image );
		if( !anim->surface ) return 0;
		}
	else if( strcasecmp( *tokens, "COLORKEY" ) == 0 ) {
		if( !anim->surface ) {
			ANIM_SetError( "syntax error: COLORKEY before IMAGE" );
			return 0;
			}
		if( anim->surface->format->BytesPerPixel > 1 ) SDL_SetColorKey( anim->surface, SDL_SRCCOLORKEY, SDL_MapRGB( anim->surface->format, (Uint8)parms[1], (Uint8)parms[2], (Uint8)parms[3] ) );
		else SDL_SetColorKey( anim->surface, SDL_SRCCOLORKEY, parms[1] );
		}
	else {
		ANIM_SetError( "syntax error" );
		return 0;
		}
	return 1;
	}// ANIM_ProcessLine

char **ANIM_tokenizeline( char *line ) {
//	printf( "tokenizeline( \"%s\" )\n", line );

	char **tokens, **nexttoken, *here;
	int count = 0;

	tokens = (char **)malloc( sizeof( char *) * MAXTOKENS + 1 );
	if( !tokens ) {
		ANIM_SetError( "malloc() failed" );
		return NULL;
		}

	nexttoken = tokens;
	here = line;
	while( (*here != 0) && (count < MAXTOKENS) ) {
		//skip leading whitespace
		while( *here != 0 ) {
			if( strchr( ";._-#0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", *here ) ) break;
			here++;
			}

		//token is here
		*nexttoken = here;
		nexttoken++;
		count ++;
		
		//find end of token
		while( *here != 0 ) {
			if( !strchr( ";._-#0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", *here ) ) break;
			here++;
			}

		if( *here == 0 ) break;
		*here = 0;
		here++;
		}
	*nexttoken = NULL;
	return tokens;
	}// ANIM_tokenizeline

void ANIM_Free( SDL_Animation *anim ) {
	SDL_FreeSurface( anim->surface );
	free( anim );
	}

int ANIM_GetFrameNum( SDL_Animation *anim, Uint32 start, Uint32 now ) {
	int mspf, ms, frame;
	if( now < start ) return 0;

	mspf = anim->duration / anim->frames;
	ms = now - start;
	if( mspf == 0 ) frame = 0;
	else frame = ms / mspf;

	return frame;
	}

void ANIM_GetFrameRect( SDL_Animation *anim, int frame, SDL_Rect *rect ) {
	rect->x = anim->w * (frame % anim->frames);
	rect->y = 0;
	rect->w = anim->w;
	rect->h = anim->h;
	}

int ANIM_BlitFrame( SDL_Animation *anim, Uint32 start, Uint32 now, SDL_Surface *dest, SDL_Rect *dr ) {
	int frame;
	frame = ANIM_GetFrameNum( anim, start, now );
	return ANIM_BlitFrameNum( anim, frame, dest, dr );
	}

int ANIM_BlitFrameNum( SDL_Animation *anim, int frame, SDL_Surface *dest, SDL_Rect *dr ) {
	SDL_Rect rect;
	ANIM_GetFrameRect( anim, frame, &rect );
	return SDL_BlitSurface( anim->surface, &rect, dest, dr );
	}

int ANIM_DisplayFormat( SDL_Animation *anim ) {
	struct SDL_Surface *newsurface;
	newsurface = SDL_DisplayFormat( anim->surface );
	if( !newsurface ) return 0;
	anim->surface = newsurface;
	return 1;	
	}

SDL_Animation *ANIM_Load( const char *file, ANIM_ImageLoader loader ) {
	char *filetext, *dir, *here;
	SDL_Animation *anim;

	/* Load the anim file */
	filetext = ANIM_loadtextfile( file );
	if( !filetext ) return NULL;
	
	/* Create the SDL_Animation struct */
	anim = (SDL_Animation *)malloc( sizeof( SDL_Animation ) );
	if( !anim ) {
		ANIM_SetError( "malloc() failed" );
		free( filetext );
		return NULL;
		}

	anim->surface = NULL;
	anim->w = 0;
	anim->h = 0;
	anim->frames = 0;
	anim->duration = 0;
	anim->image = NULL;
	anim->loader = loader;

	/* Find the directory of the anim file */
	dir = (char *)malloc( strlen( file ) + 1 );
	if( !dir ) {
		ANIM_SetError( "malloc() failed" );
		free( anim );
		free( filetext );
		return NULL;
		}
	strcpy( dir, file );
	here = dir;
	while( *here ) here++;
	while( here >= dir ) {
		if( (*here == '\\') || (*here == '/') ) break;
		*here = 0;
		here--;
		}

	if( !ANIM_ProcessFile( anim, filetext, dir ) ) {
		free( filetext );
		if( anim->surface ) SDL_FreeSurface( anim->surface );
		if( anim->image ) free( anim->image );
		free( anim );
		return NULL;
		}
	
	free( filetext );
	return anim;
	}
