/* config.h.  Generated automatically by configure.  */
/* config.h.in.  Generated from configure.in by autoheader.  */
/* ========== Package information */

/* Package name (libmikmod) */
#define PACKAGE "libmikmod"
/* Package version */
#define VERSION "3.7.7"

/* ========== Features selected */

/* Define if your system supports binary pipes (i.e. Unix) */
#undef DRV_PIPE

/* Define if you want a .aiff file writer driver */
#define DRV_AIFF 1

/* Define if the AudioFile driver is compiled */
/* #undef DRV_AF 1 */
/* Define if the AIX audio driver is compiled */
/* #undef DRV_AIX */
/* Define if the Linux ALSA driver is compiled */
/* #undef DRV_ALSA */
/* Define if the Amiga AHI driver is compiled */
#define DRV_AHI 1
/* Define if the Enlightened Sound Daemon driver is compiled */
/* #undef DRV_ESD */
/* Define if the HP-UX audio driver is compiled */
/* #undef DRV_HP */
/* Define if the Open Sound System driver is compiled */
/* #undef DRV_OSS */
/* Define if the Linux SAM9407 driver is compiled */
/* #undef DRV_SAM9407 */
/* Define if the SGI audio driver is compiled */
/* #undef DRV_SGI */
/* Define if the Sun audio driver or compatible (NetBSD, OpenBSD)
   is compiled */
/* #undef DRV_SUN */
/* Define if the Linux Ultra driver is compiled */
/* #undef DRV_ULTRA */
/* Define this if you want the MacOS X CoreAudio driver */
/* #undef DRV_OSX */
/* Define this if you want the Carbon Mac Audio driver */
/* #undef DRV_MAC */

#define DRV_NOS 1
#define DRV_RAW 1
#define DRV_STDOUT 1
#define DRV_WAV 1

/* Define if you want a debug version of the library */
/* #undef MIKMOD_DEBUG */
/* Define if you want runtime dynamic linking of ALSA and EsounD drivers */
/* #undef MIKMOD_DYNAMIC */
/* Define if your system provides POSIX.4 threads */
/* #undef HAVE_PTHREAD */

/* ========== Build environment information */

/* Define if your system is SunOS 4.* */
/* #undef SUNOS */
/* Define if your system is AIX 3.* - might be needed for 4.* too */
/* #undef AIX */
/* Define if your system defines random(3) and srandom(3) in math.h instead
   of stdlib.h */
#define SRANDOM_IN_MATH_H 1
/* Define if EsounD driver depends on ALSA */
/* #undef MIKMOD_DYNAMIC_ESD_NEEDS_ALSA */
/* Define if your system has RTLD_GLOBAL defined in <dlfcn.h> */
/* #undef HAVE_RTLD_GLOBAL */
/* Define if your system needs leading underscore to function names in dlsym() calls */
/* #undef DLSYM_NEEDS_UNDERSCORE */

/* Define to 1 if you have the <AF/AFlib.h> header file. */
/* #undef HAVE_AF_AFLIB_H */

/* Define to 1 if you have the <dlfcn.h> header file. */
#define HAVE_DLFCN_H 1

/* Define to 1 if you have the <dl.h> header file. */
/* #undef HAVE_DL_H */

/* Define to 1 if you have the <dmedia/audio.h> header file. */
/* #undef HAVE_DMEDIA_AUDIO_H */

/* Define to 1 if you have the <fcntl.h> header file. */
#define HAVE_FCNTL_H 1

/* Define to 1 if you have the <inttypes.h> header file. */
/* #undef HAVE_INTTYPES_H */

/* Define to 1 if you have the <libgus.h> header file. */
/* #undef HAVE_LIBGUS_H */

/* Define to 1 if you have the <machine/soundcard.h> header file. */
/* #undef HAVE_MACHINE_SOUNDCARD_H */

/* Define to 1 if you have the <malloc.h> header file. */
#define HAVE_MALLOC_H 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the `setenv' function. */
#define HAVE_SETENV 1

/* Define to 1 if you have the `snprintf' function. */
#define HAVE_SNPRINTF 1

/* Define to 1 if you have the `srandom' function. */
/* #undef HAVE_SRANDOM */

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

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

/* Define to 1 if you have the `strstr' function. */
#define HAVE_STRSTR 1

/* Define to 1 if you have the <sun/audioio.h> header file. */
/* #undef HAVE_SUN_AUDIOIO_H */

/* Define to 1 if you have the <sys/acpa.h> header file. */
/* #undef HAVE_SYS_ACPA_H */

/* Define to 1 if you have the <sys/asoundlib.h> header file. */
/* #undef HAVE_SYS_ASOUNDLIB_H */

/* Define to 1 if you have the <sys/audioio.h> header file. */
/* #undef HAVE_SYS_AUDIOIO_H */

/* Define to 1 if you have the <sys/audio.h> header file. */
/* #undef HAVE_SYS_AUDIO_H */

/* Define to 1 if you have the <sys/ioctl.h> header file. */
#define HAVE_SYS_IOCTL_H 1

/* Define to 1 if you have the <sys/sam9407.h> header file. */
/* #undef HAVE_SYS_SAM9407_H */

/* Define to 1 if you have the <sys/soundcard.h> header file. */
/* #undef HAVE_SYS_SOUNDCARD_H */

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have <sys/wait.h> that is POSIX.1 compatible. */
#define HAVE_SYS_WAIT_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#define HAVE_UNISTD_H 1

#define HAVE_LIMITS_H 1

/* Name of package */
#define PACKAGE "libmikmod"

/* Define to the address where bug reports for this package should be sent. */
/* #undef PACKAGE_BUGREPORT */

/* Define to the full name of this package. */
/* #undef PACKAGE_NAME */

/* Define to the full name and version of this package. */
/* #undef PACKAGE_STRING */

/* Define to the one symbol short name of this package. */
/* #undef PACKAGE_TARNAME */

/* Define to the version of this package. */
/* #undef PACKAGE_VERSION */

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Define to empty if `const' does not conform to ANSI C. */
/* #undef const */

/* Define to `int' if <sys/types.h> does not define. */
/* #undef pid_t */

/* Define to `unsigned int' if <sys/types.h> does not define. */
/* #undef size_t */
