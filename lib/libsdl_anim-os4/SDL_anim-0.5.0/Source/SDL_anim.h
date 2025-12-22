/*
	SDL_anim:  an animation library for SDL
	Copyright (C) 2001  Michael Leonhard

	This library is under the GNU Library General Public License.
	See the file "COPYING" for details.

	Michael Leonhard
	mike@tamale.net
*/

#ifndef _SDL_anim_h
#define _SDL_anim_h

#include <SDL/SDL.h>
#include <SDL/begin_code.h>

/* Set up for C function definitions, even when using C++ */
#ifdef __cplusplus
extern "C" {
#endif

typedef SDL_Surface *(*ANIM_ImageLoader)(const char *);

typedef struct {
	SDL_Surface *surface;
	int frames, w, h;
	Uint32 duration;
	char *image;
	ANIM_ImageLoader loader;
	} SDL_Animation;

SDL_Animation *ANIM_Load( const char *file, ANIM_ImageLoader loader );
void ANIM_Free(			SDL_Animation *anim );
int ANIM_GetFrameNum(	SDL_Animation *anim, Uint32 start, Uint32 now );
int ANIM_BlitFrame(		SDL_Animation *anim, Uint32 start, Uint32 now, SDL_Surface *dest, SDL_Rect *dr );
void ANIM_GetFrameRect(	SDL_Animation *anim, int frame, SDL_Rect *rect );
int ANIM_BlitFrameNum(	SDL_Animation *anim, int frame, SDL_Surface *dest, SDL_Rect *dr );
int ANIM_DisplayFormat( SDL_Animation *anim );
	
/* We'll use SDL for reporting errors */
#define ANIM_SetError	SDL_SetError
#define ANIM_GetError	SDL_GetError

/* Ends C function definitions when using C++ */
#ifdef __cplusplus
};
#endif
#include "SDL/close_code.h"

#endif /* _SDL_anim_h */
