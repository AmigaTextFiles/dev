/****h* AmigaTalk/Env.h [1.5] ********************************************
*
* NAME
*    Env.h
*
* DESCRIPTION 
*    execution environment definitions.
*
* NOTES 
*    The Little Smalltalk system is tailored to various machines by
*    changing defined constants.  These constants, and their meanings,
*    are as follows:
* 
* CURSES   defined if the curses(3) library is available and the primitive
*          graphics it provides is desired
* 
* GAMMA   defined if gamma() is part of the math library
* 
* ENVSAVE   defined if it is required to save environ during fast load
* 
* FACTMAX   maximum integer value for which a factorial can be computed by
*           repeated multiplication without overflow.
* 
* FASTDEFAULT   defined if the default behavior should be to do a fast load
* 
* FLUSHREQ   if defined a fflush is given after every call to printf
*            or fprintf
* 
* INLINE   generate inline code for increments or decrements -
*          produces larger, but faster, code.
* 
* NOSYSTEM   defined if the system() call is NOT provided
*            (seriously limits functionality)
* 
* PLOT3   defined if you have a device for which the plot(3) routines work
*         directly on the terminal (without a filter)
*         provides many of these routines as primitive operations
*         (see class PEN in /prelude)
* 
* SMALLDATA   if defined various means are used to reduce the size of the
*             data segment, at the expense of some functionality.
* 
* SIGS      define in the signal system call is available for trapping user 
*           interrupt signals
* 
* SETJUMP   defined if the setjump facility is available 
* 
* In addition to defining constants, the identifier type ``unsigned
* character'' needs to be defined.  Bytecodes are stored using this 
* datatype.  On machines which do not support this datatype directly, 
* macros need to be defined that convert normal chars into unsigned 
* chars.  unsigned chars are defined by a typedef for ``uchar'' 
* and a pair of macros that convert an int into a uchar and vice-versa.
* 
*    Finally, a few path names have to be compiled into the code.
* These path names are the following:
* 
* TEMPFILE - a temporary file name in mktemp format
* PRELUDE  - the location of the standard prelude in ascii format
* FAST     - the location of the standard prelude in saved format
**********************************************************************
*
*/

#ifndef   ENV_H
# define  ENV_H    1

# define AMIGATALK 1

# define PRELUDE  "AmigaTalk:prelude/standard"
# define FAST     "AmigaTalk:prelude/stdsave"

typedef unsigned char uchar;

# define FACTMAX 7
# define SETJUMP

# define itouc(x) ((uchar) ((x) & 0xFF))
# define uctoi(x) ((int) x)

//# define CURSES 1  // Put back in once the linkage problem with gcc is fixed.

# define PLOT3  1 // We just open windows on AmigaTalk Screen.

/* #define INLINE      produce in line code for incs and decs */

#endif

/* ------------------- END of Env.h file! ----------------------------- */
