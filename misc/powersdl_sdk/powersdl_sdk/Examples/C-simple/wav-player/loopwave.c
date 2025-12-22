/* Program to load a wave file and loop playing it using SDL sound */

/* loopwaves.c is much more robust in handling WAVE files -- 
	This is only for simple WAVEs
*/

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

#include "SDL.h"
#include "SDL_audio.h"

int		done=0;
SDL_Surface 	*back;

struct {
	SDL_AudioSpec spec;
	Uint8   *sound;			/* Pointer to wave data */
	Uint32   soundlen;		/* Length of wave data */
	int      soundpos;		/* Current play position */
} wave;


void Slock(SDL_Surface *screen)
{
	if ( SDL_MUSTLOCK(screen) )
	{
		//if ( SDL_LockSurface(screen) < 0 )
		{
			return;
		}
	}
}

void Sulock(SDL_Surface *screen)
{
	if ( SDL_MUSTLOCK(screen) )
	{
		//SDL_UnlockSurface(screen);
	}
}

void fillerup(void *unused, Uint8 *stream, int len)
{
	Uint8 *waveptr;
	int    waveleft;

	/* Set up the pointers */
	waveptr = wave.sound + wave.soundpos;
	waveleft = wave.soundlen - wave.soundpos;

	/* Go! */
	while ( waveleft <= len ) {
		SDL_MixAudio(stream, waveptr, waveleft, SDL_MIX_MAXVOLUME);
		stream += waveleft;
		len -= waveleft;
		waveptr = wave.sound;
		waveleft = wave.soundlen;
		wave.soundpos = 0;
	}
	SDL_MixAudio(stream, waveptr, len, SDL_MIX_MAXVOLUME);
	wave.soundpos += len;
}


int main(int argc, char *argv[])
{
	char		name[32];
	SDL_Surface	*screen;
	SDL_Event	event;
	SDL_Rect	dest;

	/* Load the SDL library */
	if ( SDL_Init(SDL_INIT_AUDIO|SDL_INIT_VIDEO) < 0 ) {
		fprintf(stderr, "Couldn't initialize SDL: %s\n",SDL_GetError());
		exit(1);
	}
	atexit(SDL_Quit);

	if ( argv[1] == NULL ) {
		fprintf(stderr, "Usage: %s <wavefile>\n", argv[0]);
		exit(1);
	}

	screen = SDL_SetVideoMode(320, 240, 0, SDL_SWSURFACE);
	if ( screen == NULL )
	{
  		printf("Unable to set video mode: %s\n", SDL_GetError());
  		exit(1);
	}

	/* Just release a picture into the window */
	back = SDL_LoadBMP("logo.bmp");
	dest.x = 0;
	dest.y = 0;
	Slock(screen);
		SDL_BlitSurface(back, NULL, screen, &dest);
		SDL_Flip(screen);
	Sulock(screen);

	/* Load the wave file into memory */
	if ( SDL_LoadWAV(argv[1],
			&wave.spec, &wave.sound, &wave.soundlen) == NULL ) {
		fprintf(stderr, "Couldn't load %s: %s\n",
						argv[1], SDL_GetError());
		exit(1);
	}
	wave.spec.callback = fillerup;

	/* Initialize fillerup() variables */
	if ( SDL_OpenAudio(&wave.spec, NULL) < 0 ) {
		fprintf(stderr, "Couldn't open audio: %s\n", SDL_GetError());
		SDL_FreeWAV(wave.sound);
		exit(2);
	}
	SDL_PauseAudio(0);

	/* Let the audio run */
	printf("Using audio driver: %s\n", SDL_AudioDriverName(name, 32));
	printf("Close window to stop playing!\n");

	while ( ! done && (SDL_GetAudioStatus() == SDL_AUDIO_PLAYING) )
	{
		while ( SDL_PollEvent(&event) )
		{
			if ( event.type == SDL_QUIT )  {  done = 1;  }

			if ( event.type == SDL_KEYDOWN )
			{
				if ( event.key.keysym.sym == SDLK_ESCAPE ) { done = 1; }
			}
		}

		SDL_Delay(100);
	}




	/* Clean up on signal */
	SDL_CloseAudio();
	SDL_FreeWAV(wave.sound);
	return(0);
}
