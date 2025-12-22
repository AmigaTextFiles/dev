/*
 * blank-to-hyphen.c -- Replace blanks in stdin by hyphens, write to stdout.
 *
 * Written 1998 by Thomas Aglassinger. Public domain.
 */
#include <stdio.h>

int main(int argc, char *argv[])
{
   int current_character = fgetc(stdin);

   while (current_character != EOF)
   {
      if (current_character == ' ')
      {
         current_character = '-';
      }
      fputc(current_character, stdout);
      current_character = fgetc(stdin);
   }

   return 0;
}
