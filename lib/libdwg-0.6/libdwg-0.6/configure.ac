dnl configure.ac

dnl Copyright (C) 2013 Free Software Foundation, Inc.
dnl
dnl This program is free software, licensed under the terms of the GNU
dnl General Public License as published by the Free Software Foundation,
dnl either version 3 of the License, or (at your option) any later version.
dnl You should have received a copy of the GNU General Public License
dnl along with this program.  If not, see <http://www.gnu.org/licenses/>.

AC_PREREQ([2.61])
AC_INIT([libdwg],[0.6],[fefcas@gmail.com])
AC_CONFIG_AUX_DIR([build-aux])
AM_INIT_AUTOMAKE([gnu no-define])

dnl libtoolize asks for this
AC_CONFIG_MACRO_DIR([m4])

dnl create a config.h file (Automake will add -DHAVE_CONFIG_H)
AM_CONFIG_HEADER([src/config.h])

ISODATE=`date +%Y-%m-%d`
AC_SUBST(ISODATE)

AC_CANONICAL_HOST

dnl Checks for programs.
AC_PROG_CC
AC_PROG_LN_S
AC_PROG_MAKE_SET
AC_PROG_INSTALL
LT_INIT
dnl AC_PROG_LIBTOOL

dnl Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([stdlib.h string.h unistd.h])

dnl Checks for typedefs, structures, and compiler characteristics.
AC_TYPE_SIZE_T

dnl Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_FUNC_STAT

dnl AC_DISABLE_OPTION_CHECKING

dnl Feature: --disable-trace
AC_ARG_ENABLE([trace],
  [AS_HELP_STRING([--disable-trace],
    [Disable runtime tracing (default: enabled).  When enabled,
     the environment variable LIBDWG_TRACE is consulted on the
     first decode attempt.  Its value is an integer: 0 (no output)
     through 9 (full verbosity).])],
  [],
  [enable_trace=yes])
AS_IF([test "x$enable_trace" != "xno"],
  [AC_DEFINE([ENABLE_TRACE],1,[Define to 1 to enable runtime tracing support.])])

dnl Write it out!
AC_CONFIG_FILES([
	Makefile
	src/Makefile
	programs/Makefile
	check/Makefile
	doc/Makefile
])
AC_OUTPUT
