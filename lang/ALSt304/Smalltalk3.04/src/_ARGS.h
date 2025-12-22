/* Define _ARGS(x) as either x or () depending on an educated guess
   on the presence of support for prototypes in the compiler.
   The idea is that you declare function with prototypes as follows:
   	extern char *malloc _ARGS((unsigned int));
   Watch the double parentheses (you'll quickly get used to them).
   Use _ARGS((void)) to declare a function with no arguments.
   Use things like _ARGS((char *, ...)) to declare printf-like functions.
   
   As a free extra, the macro HAVE_PROTOTYPES is defined if and only if
   prototypes are supported, and the macro 'const' is defined as empty
   if prototypes are not supported (and also if THINK_C is defined).
*/

#ifndef _ARGS

#ifdef __STDC__
#define HAVE_PROTOTYPES
#endif

#ifdef THINK_C
#undef HAVE_PROTOTYPES
#define HAVE_PROTOTYPES
#endif

#ifdef sgi
#ifdef mips
#define HAVE_PROTOTYPES
#endif
#endif

#ifdef HAVE_PROTOTYPES
#define _ARGS(x) x
#else
#define _ARGS(x) ()
#endif

#ifndef HAVE_PROTOTYPES
#define const /*empty*/
#else /* HAVE_PROTOTYPES */
#ifdef THINK_C
#undef const
#define const /*empty*/
#endif /* THINK_C */
#endif /* HAVE_PROTOTYPES */

#endif /* _ARGS */
