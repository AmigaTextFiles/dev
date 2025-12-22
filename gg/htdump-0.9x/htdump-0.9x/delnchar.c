/***************************************************************************\
**                                                                         **
**  htdump                                                                 **
**                                                                         **
**  Program to make http requests and redirect, save or pipe the output.   **
**  Ideal for automation and debugging.                                    **
**                                                                         **
**                                                                         **
**  By Ren Hoek (ren@arak.cs.hro.nl) Under Artistic License, 2000          **
**                                                                         **
\***************************************************************************/

#include "global.h"

void DelNBin(char *Buffer, unsigned int Buffer_len, unsigned int Location, unsigned int Number)
{
register unsigned int t;
for(t=0; t<Buffer_len-Number-Location; t++) Buffer[t+Location]=Buffer[Location+t+Number];
}

void DelNChar(char *Buffer, unsigned int Location, unsigned int Number)
{
register unsigned int t;
for(t=Location; Buffer[t+Number]; t++) Buffer[t]=Buffer[t+Number];
Buffer[t]='\0';
}

