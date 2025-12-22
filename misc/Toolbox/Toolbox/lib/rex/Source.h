$@ # ifndef xy$Source
$@ # define xy$Source

/* $Id: Source.h,v 1.7 1992/08/07 15:29:41 grosch rel $ */

# if defined __STDC__ | defined __cplusplus
# define ARGS(parameters)	parameters
# else
# define ARGS(parameters)	()
# endif

$@ extern int  $_BeginSource  ARGS((char * FileName));

   /*
$@       $_BeginSource is called from the scanner to open files.
      If not called input is read form standard input.
   */

$@ extern int  $_GetLine      ARGS((int File, char * Buffer, int Size));

   /*
$@       $_GetLine is called to fill a buffer starting at address 'Buffer'
      with a block of maximal 'Size' characters. Lines are terminated
$@       by newline characters (ASCII = 0xa). $_GetLine returns the number
      of characters transferred. Reasonable block sizes are between 128
      and 2048 or the length of a line. Smaller block sizes -
      especially block size 1 - will drastically slow down the scanner.
   */

$@ extern void $_CloseSource  ARGS((int File));

   /*
$@       $_CloseSource is called from the scanner at end of file respectively
      at end of input. It can be used to close files.
   */

# endif
