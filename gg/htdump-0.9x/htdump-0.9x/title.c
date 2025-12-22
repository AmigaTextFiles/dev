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
#include <stdio.h>
#include <string.h>

void Title(int Argc, char *Argv[], char *Title)
{
static unsigned int total_len=0;
int t;

if(!total_len)
  for(t=0; t<Argc; t++) total_len=total_len+strlen(Argv[t])+1;
strncpy(Argv[0], Title, total_len);
}