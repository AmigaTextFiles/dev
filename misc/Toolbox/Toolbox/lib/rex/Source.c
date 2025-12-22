/* $Id: Source.c,v 2.4 1992/08/07 15:29:41 grosch rel $ */

$@ # include "$Source.h"

# ifdef __cplusplus
extern "C" {
# include "System.h"
}
# else
# include "System.h"
# endif

$@ int $_BeginSource
# if defined __STDC__ | defined __cplusplus
   (char * FileName)
# else
   (FileName) char * FileName;
# endif
{
   return OpenInput (FileName);
}

$@ int $_GetLine
# if defined __STDC__ | defined __cplusplus
   (int File, char * Buffer, int Size)
# else
   (File, Buffer, Size) int File; char * Buffer; int Size;
# endif
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

$@ void $_CloseSource
# if defined __STDC__ | defined __cplusplus
   (int File)
# else
   (File) int File;
# endif
{
   Close (File);
}
