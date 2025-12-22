/*****************************************************************************
**
** make a text-object with d2o:
**
**      d2o Main.c SYMBOL Text OBJECT Text.o
**
** compile your c-source to an object-file:
**
**      sc Main.c
**
**
** Now you've got the two object files:
**
**      Text.o
**      Main.o
**
** Make an executable file with for example SAS/C slink:
**
**      slink FROM lib:c.o main.o text.o TO Test
**            LIB lib:sc.lib lib:amiga.lib
**
*****************************************************************************/

#include <stdio.h>
#include <exec/types.h>

extern TEXT pText[];
extern LONG lTextLen;

void main( void )
{
    printf("Length of text: %ld\n", lTextLen);
    
    printf("%s",pText);
}
