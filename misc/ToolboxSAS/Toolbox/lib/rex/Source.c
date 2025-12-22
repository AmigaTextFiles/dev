/* $Id: Source.c,v 2.4 1992/08/07 15:29:41 grosch rel $ */

$@ # include "$Source.h"

# include "System.h"

$@ int $_BeginSource(char * FileName)
{
   return OpenInput (FileName);
}

$@ int $_GetLine(int File, char * Buffer, int Size)
{
   register int n = Read (File, Buffer, Size);
# ifdef Dialog
# define IgnoreChar ' '
   /* Add dummy after newline character in order to supply a lookahead for rex. */
   /* This way newline tokens are recognized without typing an extra line.      */
   if (n > 0 && Buffer [n - 1] == '\n') Buffer [n ++] = IgnoreChar;
# endif
   return n;
}

$@ void $_CloseSource(int File)
{
   Close (File);
}
