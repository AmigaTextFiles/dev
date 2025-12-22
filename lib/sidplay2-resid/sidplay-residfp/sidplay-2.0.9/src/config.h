/* unix/config.h.  Generated from config.h.in by configure.  */
/* unix/config.h.in.  Generated from configure.ac by autoheader.  */

/* Define supported audio driver */
/* #undef HAVE_HARDSID */
/* #undef HAVE_ALSA */
/* #undef HAVE_MMSYSTEM */
/* #undef HAVE_OSS */
/* #undef HAVE_PULSE */
#define HAVE_AHI 1

/* Define if building universal (internal helper macro) */
/* #undef AC_APPLE_UNIVERSAL_BUILD */

/* Define to 1 if you have the <alsa/asoundlib.h> header file. */
/* #undef HAVE_ALSA_ASOUNDLIB_H */

/* Define to 1 if you have the <audio.h> header file. */
/* #undef HAVE_AUDIO_H */

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* Define to 1 if you have the <dmedia/audio.h> header file. */
/* #undef HAVE_DMEDIA_AUDIO_H */

/* Define if your C++ compiler implements exception-handling. */
#define HAVE_EXCEPTIONS /**/

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define if standard member ``ios::binary'' is called ``ios::bin''. */
/* #undef HAVE_IOS_BIN */

/* Define if ``ios::openmode'' is supported. */
#define HAVE_IOS_OPENMODE /**/

/* Define to 1 if you have the `hardsid-builder' library (-lhardsid-builder).
   */
/* #undef HAVE_LIBHARDSID_BUILDER */

/* Define to 1 if you have the `resid-builder' library (-lresid-builder). */
#define HAVE_LIBRESID_BUILDER 1

/* Define to 1 if you have the `sidplay2' library (-lsidplay2). */
#define HAVE_LIBSIDPLAY2 1

/* Define to 1 if you have the `sidutils' library (-lsidutils). */
#define HAVE_LIBSIDUTILS 1

/* Define to 1 if you have the <linux/soundcard.h> header file. */
/* #undef HAVE_LINUX_SOUNDCARD_H */

/* Define to 1 if you have the <machine/soundcard.h> header file. */
/* #undef HAVE_MACHINE_SOUNDCARD_H */

/* Define to 1 if you have the <memory.h> header file. */
/* #undef HAVE_MEMORY_H */

/* Define to 1 if you have the <pulse/simple.h> header file. */
/* #undef HAVE_PULSE_SIMPLE_H */

/* Define to 1 if you have the <soundcard.h> header file. */
/* #undef HAVE_SOUNDCARD_H */

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the <sun/audioio.h> header file. */
/* #undef HAVE_SUN_AUDIOIO_H */

/* Define to 1 if you have the <sun/dbriio.h> header file. */
/* #undef HAVE_SUN_DBRIIO_H */

/* Define to 1 if you have the <sys/asoundlib.h> header file. */
/* #undef HAVE_SYS_ASOUNDLIB_H */

/* Define to 1 if you have the <sys/audioio.h> header file. */
/* #undef HAVE_SYS_AUDIOIO_H */

/* Define to 1 if you have the <sys/audio.h> header file. */
/* #undef HAVE_SYS_AUDIO_H */

/* Define to 1 if you have the <sys/ioctl.h> header file. */
#define HAVE_SYS_IOCTL_H 1

/* Define to 1 if you have the <sys/soundcard.h> header file. */
/* #undef HAVE_SYS_SOUNDCARD_H */

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

/* Define to the sub-directory in which libtool stores uninstalled libraries.
   */
#define LT_OBJDIR ".libs/"

/* Name of package */
#define PACKAGE "sidplay"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT ""

/* Define to the full name of this package. */
#define PACKAGE_NAME ""

/* Define to the full name and version of this package. */
#define PACKAGE_STRING ""

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME ""

/* Define to the version of this package. */
#define PACKAGE_VERSION ""

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Version number of package */
#define VERSION "2.0.9"

/* Define WORDS_BIGENDIAN to 1 if your processor stores words with the most
   significant byte first (like Motorola and SPARC, unlike Intel). */
#define WORDS_BIGENDIAN 1
