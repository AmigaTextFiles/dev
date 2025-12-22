#ifndef MAXLINE
   #define MAXLINE 200
#endif

char line [MAXLINE];

int getline (char *line, int max, FILE *infile)
{
   int i;

   if (fgets (line, max, infile) == NULL) i = EOF;
   else
   {
      i = strlen (line) - 1;
      if (line [i] != '\n') {
         /*  If the line is longer than MAXLINE (including line ending
             chars) we simply use what we have and read the remainder
             as a subsequent line. */
         i ++;
      } else {
         line [i] = '\0';           /* Remove trailing newline. */
         if (line [i-1] == '\r') {
            /* Remove CR before newline, for DOS file compatibility
               on POSIX systems. */
            i --;
            line[i] = 0;
         }
      }
   }

   return i;
}
