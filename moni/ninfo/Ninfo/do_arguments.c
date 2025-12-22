#include "hunk.h"
extern int Flgs[26];

void Do_Arguments(count,strings,addrs)
  int count;
  long *addrs;
  char *strings[];
  {
  register int loop;
  register char *ptr;
  int  c;

  if ( count == 2 && *strings[1] == '?' )
    {
    printf(" Usage is: %s [-option ... -option]\n",strings[0]);
    }
  else
    {
    for(loop=0; loop < 26;) Flgs[loop++] = FALSE;
    while ( --count > 0 )                       
      {
      ptr = *++strings;
      if ( *ptr++ == '-' )
        {
        c = toupper(*ptr) - 'A' ;  /* get an index 0 to 25 */
        if ( c >= 0 && c <= 25 )
          {
          Flgs[c] = TRUE;
          if( c == 12)
            {
            ptr++;
            (void)stch_l(ptr,addrs);
            };
          }
        else
          {
          printf(" %s has an invalid option: %s\n",strings[0],ptr);
          };
        };
      };
    };
  }
