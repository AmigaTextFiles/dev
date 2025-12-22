# $Id: configure.ac,v 1.4 2004/05/02 04:15:55 sarrazip Exp $
# configure.ac for the FlatZebra library

AC_PREREQ(2.54)
AC_INIT(src/flatzebra/GameEngine.h)

API=0.1;	AC_SUBST(API)
RELEASE=1;	AC_SUBST(RELEASE)

PACKAGE_FULL_NAME="FlatZebra"
PACKAGE_SUMMARY_EN="Generic Game Engine library for 2D double-buffering animation"
PACKAGE_SUMMARY_FR="Moteur générique de jeu vidéo 2D à double tampon"
AC_SUBST(PACKAGE_FULL_NAME)
AC_SUBST(PACKAGE_SUMMARY_EN)
AC_SUBST(PACKAGE_SUMMARY_FR)


MINVER_SDL=1.2.4;		AC_SUBST(MINVER_SDL)
MINVER_SDL_IMAGE=1.2.2;		AC_SUBST(MINVER_SDL_IMAGE)
MINVER_SDL_MIXER=1.2.4;		AC_SUBST(MINVER_SDL_MIXER)


AC_CANONICAL_HOST
AC_CANONICAL_SYSTEM

AM_INIT_AUTOMAKE(flatzebra, $API.$RELEASE)


# Checks for programs.

AC_PROG_CXX
AC_COMPILE_WARNINGS
AC_LANG_CPLUSPLUS

AC_DISABLE_STATIC
# This macro changes the default behavior of AC_PROG_LIBTOOL so
# that static libraries will not be built by default.
# This avoids compiling every file twice.
# The user can still override this new default by using `--enable-static'.

AM_PROG_LIBTOOL
# This must come after AC_DISABLE_STATIC.


AC_CHECK_PROG(HAVE_PKGCONFIG, pkg-config, yes, no)
if test "_$HAVE_PKGCONFIG" = _no; then
	AC_MSG_ERROR([pkg-config required.
See http://www.freedesktop.org/software/pkgconfig/])
fi



# Checks for libraries.

# Use C mode for SDL tests:
AC_LANG_C

AM_PATH_SDL(1.2.4)

# Remove any -rpath option from SDL_LIBS, so as not to hardcode
# the library path into the executable file:
#

SDL_LIBS=`echo $SDL_LIBS | sed ['s:-Wl,-rpath,[^ ]*: :g]'`

# AM_PATH_SDL does not stop if SDL is not found; therefore:
if test "_$SDL_LIBS" = _; then
	AC_MSG_ERROR([SDL not found])
fi

# We also need the SDL_image and SDL_mixer libraries:
AM_TRY_LINK_SDL_IMAGE
TRY_LINK_SDL_MIXER

# Back to C++ mode after SDL tests.
AC_LANG_CPLUSPLUS


AC_CONFIG_FILES([
	Makefile
	flatzebra-0.1.spec
	flatzebra-0.1.pc
	src/Makefile
	src/flatzebra/Makefile
])
AC_OUTPUT
