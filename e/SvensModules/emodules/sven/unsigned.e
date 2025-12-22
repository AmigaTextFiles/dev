/* Macros for unsigning numbers
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

#define UBYTE(data) ((data) AND $FF)
#define UWORD(data) ((data) AND $FFFF)

