#ifndef  STORMAMIGA_H
#define  STORMAMIGA_H

/*
**   $VER: stormamiga.h 42.10ß (04.03.1997)
**
**           B E T A V E R S I O N
**
**     Copyright © 1996/97 by COMPIUTECK
**         written by Matthias Henze
**            All Rights Reserved
*/

#ifndef  _INCLUDE_STDIO_H
  #include <stdio.h>
#endif
#ifndef _INCLUDE_TIME_H
  #include <time.h>
#endif
#ifndef INTUITION_INTUITION_H
  #include <intuition/intuition.h>
#endif
#ifndef GRAPHICS_RASTPORT_H
  #include <graphics/rastport.h>
#endif

#ifdef __cplusplus
  extern "C" {
#endif


#define uchar         unsigned char
#define ushort        unsigned short
#define lint          long int
#define llint         long long int
#define uint          unsigned int
#define ulint         unsigned long int
#define ullint        unsigned long long int
#define llong         long long
#define ulong         unsigned long
#define ullong        unsigned long long


/*----- Nonstandard-AmigaLib-functions -----*/

long    SPRINTF       (char *, const char *, ...);
long    VSPRINTF      (char *, const char *, va_list);


/*----- Nonstandard-stdio-functions -----*/

int     printf_       (const char *, ...);
int     fprintf_      (FILE *, const char *, ...);
int     sprintf_      (char *, const char *, ...);

int     vprintf_      (const char *, va_list);
int     vfprintf_     (FILE *, const char *, va_list);
int     vsprintf_     (char *, const char *, va_list);


int     scanf_        (const char *, ...);
int     fscanf_       (FILE *, const char *, ...);
int     sscanf_       (const char *, const char *, ...);

int     vscanf        (const char *, va_list);
int     vscanf_       (const char *, va_list);
int     vfscanf       (FILE *, const char *, va_list);
int     vfscanf_      (FILE *, const char *, va_list);
int     vsscanf       (const char *, const char *, va_list);
int     vsscanf_      (const char *, const char *, va_list);


/* only for compatibility to "stormamiga.lib" V.41.023 - V.41.035 */

#define printf__      printf_
#define fprintf__     fprintf_
#define sprintf__     sprintf_
#define vprintf__     vprintf_
#define vfprintf__    vfprintf_
#define vsprintf__    vsprintf_

#define scanf__       scanf_
#define fscanf__      fscanf_
#define sscanf__      sscanf_
#define vscanf__      vscanf_
#define vfscanf__     vfscanf_
#define vsscanf__     vsscanf_


/* only for compatibility to "stormamiga.lib" V.42.03 - V.42.05 */

#define dsscanf       sscanf


/*----- GCC-Nonstandard-stdio-functions -----*/

void    setbuffer     (FILE *, char *, int);
int     setlinebuf    (FILE *);


/*----- string-functions -----*/

int     strcoll       (const char *, const char *);
size_t  strxfrm       (char *, const char *, size_t);


/*----- Nonstandard-string-functions -----*/

#ifdef STORMAMIGA_DEUTSCH
  #define stricmp       stricmp_d
  #define strnicmp      strnicmp_d
  #define strcasecmp    strcasecmp_d
  #define strncasecmp   strncasecmp_d
  #define strlwr        strlwr_d
  #define strupr        strupr_d
  #define strlower      strlower_d
  #define strupper      strupper_d
#endif

int     strnicmp      (const char *, const char *, size_t);
int     stricmp_d     (const char *, const char *);
int     strnicmp_d    (const char *, const char *, size_t);
int     strcasecmp_d  (const char *, const char *);
int     strncasecmp_d (const char *, const char *, size_t);
char    *strlwr_d     (char *);
char    *strupr_d     (char *);
char    *strlower_d   (char *);
char    *strupper_d   (char *);


/*----- GCC-Nonstandard-string-functions -----*/

int     bcmp          (const void *, const void *, size_t);
void    bcopy         (const void *, void *, size_t);
int     ffs           (int);
char    *index        (const char *, int);
char    *rindex       (const char *, int);
void    *memccpy      (void *, const void *, int, size_t);
char    *strdup       (const char *);
char    *strsep       (char **, const char *);
void    swab          (const void *, void *, size_t);
int     strcasecmp    (const char *, const char *);
int     strncasecmp   (const char *, const char *, size_t);
char    *strlower     (char *);
char    *strupper     (char *);


/*----- Nonstandard-assert-functions -----*/

#ifdef  NDEBUG
  #define assert_(C)
#else
  void    do_assert_    (char *, char *, char *, uint);
  #define assert_(C)    { if(!(C)) do_assert_(#C, __FILE__, __FUNC__, __LINE__); }
#endif


/*----- Nonstandard-ctype-functions -----*/

#ifdef STORMAMIGA_DEUTSCH
  #define isalnum       isalnum_d
  #define isalpha       isalpha_d
  #define islower       islower_d
  #define isupper       isupper_d
  #define isprint       isprint_d
  #define ispunct       ispunct_d
  #define tolower       tolower_d
  #define toupper       toupper_d
#endif

int     isalnum_d     (int);
int     isalpha_d     (int);
int     islower_d     (int);
int     isprint_d     (int);
int     ispunct_d     (int);
int     isupper_d     (int);
int     tolower_d     (int);
int     toupper_d     (int);


/*----- Nonstandard-time-functions -----*/

#ifdef STORMAMIGA_DEUTSCH
  #define strftime      strftime_d
  #define asctime       asctime_d
  #define ctime         ctime_d
#endif

int     strftime_d    (char *, uint, const char *, const struct tm *);
char    *asctime_d    (const struct tm *);
char    *ctime_d      (const time_t *);


/*----- Nonstandard-math-functions -----*/

int     isinf         (double);
int     isnan         (double);


/*----- Amiga-functions -----*/

#ifdef STORMAMIGA_REGISTER
  #define Move          Move_r
  #define GetAPen       GetAPen_r
  #define GetBPen       GetBPen_r
#endif

void    Move_r        (register __a1 struct RastPort *, register __d0 long, register __d1 long);
ulong   GetAPen_r     (register __a0 struct RastPort *);
ulong   GetBPen_r     (register __a0 struct RastPort *);


/*----- Special-functions -----*/

#ifdef STORMAMIGA_REGISTER
  #define muls          muls_r
  #define mulu          mulu_r
  #define divsl         divsl_r
  #define divul         divul_r
  #define muls64        muls64_r
  #define mulu64        mulu64_r
  #define divs64        divs64_r
  #define divu64        divu64_r
  #define button        button_r
  #define waitbutton    waitbutton_r
  #define max_Width     max_Width_r
  #define max_Height    max_Height_r
#else
  long    muls          (long, long);
  ulong   mulu          (ulong, ulong);
  long    divsl         (long, long);
  ulong   divul         (ulong, ulong);
  long    muls64        (long, long);
  ulong   mulu64        (ulong, ulong);
  long    divs64        (long, long);
  ulong   divu64        (ulong, ulong);
  int     button        (int, int);
  void    waitbutton    (int, int);
  int     max_Width     (struct Window *);
  int     max_Height    (struct Window *);
#endif

long    muls_r        (register __d0 long, register __d1 long);
ulong   mulu_r        (register __d0 ulong, register __d1 ulong);
long    divsl_r       (register __d0 long, register __d1 long);
ulong   divul_r       (register __d0 ulong, register __d1 ulong);
long    muls64_r      (register __d0 long, register __d1 long);
ulong   mulu64_r      (register __d0 ulong, register __d1 ulong);
long    divs64_r      (register __d0 long, register __d1 long);
ulong   divu64_r      (register __d0 ulong, register __d1 ulong);
int     button_r      (register __d0 int, register __d1 int);
void    waitbutton_r  (register __d0 int, register __d1 int);
int     max_Width_r   (register __a0 struct Window *);
int     max_Height_r  (register __a0 struct Window *);

int     button_al     ();
int     button_ar     ();
int     button_bl     ();
int     button_br     ();
void    waitbutton_al ();
void    waitbutton_ar ();
void    waitbutton_bl ();
void    waitbutton_br ();


/*----- Alpha-functions -----*/

#ifdef STORMAMIGA_ALPHA
  #ifdef STORMAMIGA_REGISTER
    #define SetAPen SetAPen_r
    #define SetBPen SetBPen_r
  #endif
  void    SetAPen_r     (register __a1 struct RastPort *, register __d0 ulong);
  void    SetBPen_r     (register __a1 struct RastPort *, register __d0 ulong);
#endif


/*----- Inline-functions -----*/

#ifdef STORMAMIGA_INLINE
  #ifndef  STORMAMIGAINLINE_H
    #include <stormamigainline.h>
  #endif
#endif

#ifdef __cplusplus
  }
#endif

#endif   /* STORMAMIGA_H */
