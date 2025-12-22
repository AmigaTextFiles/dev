/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 * ConvertLine()
 * Converts multiple input formats to a standard one we can
 * work from.  This is to make us compatible with some of the
 * other assemblers out there.
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 * Dont actualy know how I'm going to do this yet !!!!!!
*/

/* The assembler is expecting a 3 field input on each line ...
** LABEL OPCODE OPERAND
**
** Comments have been dumped and the lot is upper case.
*/

#include <stdio.h>
#include <string.h>
#include "str_p.h"

void ConvertLine( char *Line, char *First, char *Second, char *Third )
{
  char *Ptr;

  Ptr=StrCpyChar(First,Line,' ');
  Ptr=StrCpyChar(Second,Ptr,' ');
	StrCpyChar(Third,Ptr,0);
}


