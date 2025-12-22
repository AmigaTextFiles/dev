/****h* AmigaTalk/Drive.h [1.5] *************************************
*
* NAME
*    Drive.h - Little Smalltalk
*
* HISTORY
*    04-Feb-2003 - Removed pseudo variables amigatalk & smalltalk.
*                  Added pseudo variables tracingon & tracingoff.
*
* defines used by both parser and driver
*********************************************************************
*
*/

#ifndef  DRIVE_H
# define DRIVE_H 1

# ifndef  AMIGATALKSTRUCTS_H
#  include "ATStructs.h"
# endif

# define TWOBIT         0  // S/B called TWOBYTE
# define TWOBYTE        0
# define PUSHINSTANCE   1
# define PUSHTEMP       2
# define PUSHLIT        3
# define PUSHCLASS      4
# define PUSHSPECIAL    5
# define POPINSTANCE    6
# define POPTEMP        7
# define SEND           8
# define SUPERSEND      9
# define UNSEND        10
# define BINSEND       11
# define ARITHSEND     12
# define KEYSEND       13
# define BLOCKCREATE   14

# define SPECIAL       15

/* arguments for special */

# define NOOP           0
# define DUPSTACK       1
# define POPSTACK       2
# define RETURN         3
# define BLOCKRETURN    4
# define SELFRETURN     5
# define SKIPTRUEPUSH   6
# define SKIPFALSEPUSH  7
# define SKIPFORWARD    8
# define SKIPBACK       9
# define PRIMCMD       10
# define SKIPT         11
# define SKIPF         12
# define METHOD_CTRL   13

/* enum pseuvars { nilvar, truevar, falsevar, selfvar, supervar,
**    procvar, traceonvar, traceoffvar, smallvar, amigavar
** };
*/

# define nilvar      1
# define truevar     2
# define falsevar    3
# define selfvar     4
# define supervar    5
# define procvar     6
# define traceonvar  7
# define traceoffvar 8

# define amigavar    9  // amigatalk == smalltalk 
# define smallvar    10

/* only include driver code in driver, keeps both lint
** and the 11/70 quiet 
*/

# ifdef DRIVECODE

/* enum lextokens { nothing, LITNUM, LITFNUM, LITCHAR, LITSTR, LITSYM, 

   LITARR, LITBYTE, ASSIGN, BINARY, PRIMITIVE, PSEUDO, 
   UPPERCASEVAR, LOWERCASEVAR, COLONVAR, KEYWORD,
   LP, RP, LB, RB, PERIOD, BAR, SEMI, PS, MINUS, PE, NL
}; 
*/

#  define nothing      0
#  define LITNUM       1    // Integer
#  define LITFNUM      2    // Float
#  define LITCHAR      3    // $character
#  define LITSTR       4    // String
#  define LITSYM       5    // #symbol_string
#  define LITARR       6    // #()
#  define LITBYTE      7    // #[]
#  define ASSIGN       8    // <- or :=
#  define BINARY       9    // ??
#  define PRIMITIVE    10   // <primitive
#  define PSEUDO       11   // pseudo variable found.
#  define UPPERCASEVAR 12   // ClassName
#  define LOWERCASEVAR 13   // tempVar
#  define COLONVAR     14   // :method
#  define KEYWORD      15   // 
#  define LP           16   // (
#  define RP           17   // )
#  define LB           18   // [
#  define RB           19   // ]
#  define PERIOD       20   // .
#  define BAR          21   //  | or ! 
#  define SEMI         22   // ;
#  define PS           23   // #
#  define MINUS        24   // -
#  define PE           25   // >
#  define NL           26   // '\n'

typedef union  {

   char   *c;    // String 
   double  f;    // Floating point number
   int     i;    // Integer or Character.
   int     p;    // pseudo variable number (see enum pseuvars).

} tok_type;

IMPORT tok_type t;

# endif

#endif

/* --------------------- END of drive.h file! ----------------------- */
