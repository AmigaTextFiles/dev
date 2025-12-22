AC_DEFUN([AM_TRY_LINK_SDL_IMAGE],
[
	AC_MSG_CHECKING([for SDL_image library (>= 1.2.0)])

	old_CFLAGS="$CFLAGS"
	CFLAGS="$SDL_CFLAGS"
	old_LDFLAGS="$LDFLAGS"
	LDFLAGS="$SDL_LDFLAGS"
	old_LIBS="$LIBS"
	LIBS="$SDL_LIBS -lSDL_image"
	# echo "{Using CFLAGS='$CFLAGS' LDFLAGS='$LDFLAGS' LIBS='$LIBS'}"

	AC_TRY_LINK(
	[
		#include <SDL_image.h>
		int main(int argc, char **argv)
		{
		    SDL_Surface *image = IMG_LoadXPM_RW((SDL_RWops *) 0);
		    return image != image;
		}
		#undef main
		#define main suspended_main
	],
	[
	],
	[
		AC_MSG_RESULT([found])
	],
	[
		AC_MSG_ERROR([could not link with SDL_image.
You can get it at http://www.libsdl.org/projects/SDL_image/])
	])

	CFLAGS="$old_CFLAGS"
	unset old_CFLAGS
	LDFLAGS="$old_LDFLAGS"
	unset old_LDFLAGS
	LIBS="$old_LIBS"
	unset old_LIBS
]
)
