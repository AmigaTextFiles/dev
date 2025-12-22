#include <stdio.h>
#include "util.h"

int filelength (FILE *f)
{
   int      pos;
   int      end;

   pos = ftell (f);
   fseek (f, 0, SEEK_END);
   end = ftell (f);
   fseek (f, pos, SEEK_SET);

   return end;
}
