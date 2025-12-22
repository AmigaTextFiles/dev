OPT MODULE
OPT PREPROCESS
OPT EXPORT

/* makes 'width' an multiply of 16
** Usage eq. for WritePixelArray8()
*/
#define MakeEvenInt(width) (((width)+15) AND $FFFFFFF0)

/* returns size of an bitplane
*/
#define Rassize(width,height) ((height)*((((width)+15)/8) AND $FFFE))

