/* config.h.in.  Generated from configure.ac by autoheader.  */

/* Define to 1 if you have the declaration of `tzname', and to 0 if you don't.
   */
#define HAVE_DECL_TZNAME 0

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* Define to 1 if you have the `fseeko' function. */
//#define HAVE_FSEEKO 0

/* Define to 1 if you have the `ftello' function. */
//#define HAVE_FTELLO 0

/* Define to 1 if you have the `getopt' function. */
#define HAVE_GETOPT 1

/* Define to 1 if the system has the type `int16_t'. */
#undef HAVE_INT16_T

/* Define to 1 if the system has the type `int32_t'. */
#undef HAVE_INT32_T

/* Define to 1 if the system has the type `int64_t'. */
#undef HAVE_INT64_T

/* Define to 1 if the system has the type `int8_t'. */
#undef HAVE_INT8_T

/* Define to 1 if you have the <inttypes.h> header file. */
#undef HAVE_INTTYPES_H

/* Define to 1 if you have the `z' library (-lz). */
#define HAVE_LIBZ 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the `mkstemp' function. */
//#undef HAVE_MKSTEMP

/* Define to 1 if you have the `MoveFileExA' function. */
#undef HAVE_MOVEFILEEXA

/* Define to 1 if you have the `open' function. */
#define HAVE_OPEN 1

/* Define to 1 if you have the `snprintf' function. */
#define HAVE_SNPRINTF 1

/* Define to 1 if the system has the type `ssize_t'. */
#undef HAVE_SSIZE_T

/* Define to 1 if you have the <stdint.h> header file. */
#undef HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the `strcasecmp' function. */
#define HAVE_STRCASECMP 1

/* Define to 1 if you have the `strdup' function. */
#define HAVE_STRDUP 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if `tm_zone' is a member of `struct tm'. */
#undef HAVE_STRUCT_TM_TM_ZONE

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if your `struct tm' has `tm_zone'. Deprecated, use
   `HAVE_STRUCT_TM_TM_ZONE' instead. */
#undef HAVE_TM_ZONE

/* Define to 1 if you don't have `tm_zone' but do have the external array
   `tzname'. */
#undef HAVE_TZNAME

/* Define to 1 if the system has the type `uint16_t'. */
#undef HAVE_UINT16_T

/* Define to 1 if the system has the type `uint32_t'. */
#undef HAVE_UINT32_T

/* Define to 1 if the system has the type `uint64_t'. */
#undef HAVE_UINT64_T

/* Define to 1 if the system has the type `uint8_t'. */
#undef HAVE_UINT8_T

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to 1 if you have the `_close' function. */
#define HAVE__CLOSE 1

/* Define to 1 if you have the `_dup' function. */
#define HAVE__DUP 1

/* Define to 1 if you have the `_fdopen' function. */
#define HAVE__FDOPEN 1

/* Define to 1 if you have the `_fileno' function. */
#define HAVE__FILENO 1

/* Define to 1 if you have the `_open' function. */
#define HAVE__OPEN 1

/* Define to 1 if you have the `_snprintf' function. */
#undef HAVE__SNPRINTF

/* Define to 1 if you have the `_strdup' function. */
#define HAVE__STRDUP 1

/* Define to 1 if you have the `_stricmp' function. */
#define HAVE__STRICMP 1

/* Define to the sub-directory in which libtool stores uninstalled libraries.
   */
#undef LT_OBJDIR

/* Define to 1 if your C compiler doesn't accept -c and -o together. */
#undef NO_MINUS_C_MINUS_O

/* Name of package */
#undef PACKAGE

/* Define to the address where bug reports for this package should be sent. */
#undef PACKAGE_BUGREPORT

/* Define to the full name of this package. */
#undef PACKAGE_NAME

/* Define to the full name and version of this package. */
#undef PACKAGE_STRING

/* Define to the one symbol short name of this package. */
#undef PACKAGE_TARNAME

/* Define to the home page for this package. */
#undef PACKAGE_URL

/* Define to the version of this package. */
#undef PACKAGE_VERSION

/* The size of `int', as computed by sizeof. */
#undef SIZEOF_INT

/* The size of `long', as computed by sizeof. */
#define SIZEOF_LONG 1

/* The size of `long long', as computed by sizeof. */
#define SIZEOF_LONG_LONG 1

/* The size of `off_t', as computed by sizeof. */
#define SIZEOF_OFF_T 8

/* The size of `short', as computed by sizeof. */
#define SIZEOF_SHORT 1

/* The size of `size_t', as computed by sizeof. */
#define SIZEOF_SIZE_T SIZEOF_INT

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Define to 1 if your <sys/time.h> declares `struct tm'. */
#undef TM_IN_SYS_TIME

/* Version number of package */
#undef VERSION


#ifndef HAVE_SSIZE_T
#  if SIZEOF_SIZE_T == SIZEOF_INT
typedef int ssize_t;
#  elif SIZEOF_SIZE_T == SIZEOF_LONG
typedef long ssize_t;
#  elif SIZEOF_SIZE_T == SIZEOF_LONG_LONG
typedef long long ssize_t;
#  else
#error no suitable type for ssize_t found
#  endif
#endif

