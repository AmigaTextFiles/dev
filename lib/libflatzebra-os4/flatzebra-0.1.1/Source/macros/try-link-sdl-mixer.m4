# TRY_LINK_SDL_MIXER
#
# Checks for the -lSDL_mixer library.
# See http://www.libsdl.org/projects/SDL_mixer/
# Assumes that SDL_CFLAGS and SDL_LIBS are properly defined.
#
AC_DEFUN([TRY_LINK_SDL_MIXER],
[
	# The gengameng check checks for the SDL library.
	# Check also for the SDL_mixer library
	#
	AC_MSG_CHECKING([for SDL_mixer])
	AC_LANG_SAVE
	AC_LANG_C
	old_CFLAGS="$CFLAGS"
	old_LIBS="$LIBS"
	CFLAGS="$SDL_CFLAGS"
	LIBS="$SDL_LIBS -lSDL_mixer"

	# Darwin seems to require main(int, char *[]) instead of main():

	AC_TRY_LINK(
		[
			#include <SDL_mixer.h>
			#define main bad_main
		],
		[
			return 0; }  /* close bad_main() */
			#undef main

			#ifdef __cplusplus
			extern "C"
			#endif
			int main(int argc, char *argv[]) {
			(void) Mix_OpenAudio(11025, AUDIO_U8, 1, 512);
		],
		[
			AC_MSG_RESULT([found])
		],
		[
			AC_MSG_ERROR([SDL_mixer not found

	SDL_mixer 1.2.4 or later is needed.
	See http://www.libsdl.org/projects/SDL_mixer/
	])
		]
	)
	CFLAGS="$old_CFLAGS"
	LIBS="$old_LIBS"
	AC_LANG_RESTORE
])
