/*

Bugs: This program is far from finished!
      But have a look around if you want

*/


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

void Mem2Hex(void *Mem, unsigned int Size);
void LowerCase(char *String, unsigned int Size);


#define BUFFER_SIZE  4096
#define BOOL         unsigned char


char *HTML_TAGS[]=
  {
  "href=",
  "src=",
  "action=",
  ".open(",
  ".replace(",
  "background=",
  "codebase=",
  "http://",
  NULL
  };

char *BASE="http://_BASE_";


void main(void)
{
char buffer[BUFFER_SIZE];
unsigned int s;
unsigned int t;
unsigned int r;

for(;;)
  {
  r=read(STDIN_FILENO, buffer, BUFFER_SIZE-1);   /* Read buffer                  */
  buffer[r]='\0';                                /* NULL terminate the buffer    */
  if(r==0) break;                                /* End of file                  */
#if 0
/* Cannot lowercase the buffer! URL's are case-sensitive! */ 
  LowerCase(buffer, r);                          /* Lowercase the entire buffer  */
  Mem2Hex(buffer, r+1);                          /* Debug to screen              */
#endif

  for(s=0; s<=r; s++)
    {
    for(t=0; HTML_TAGS[t]; t++)
      if(strncasecmp(&buffer[s], HTML_TAGS[t], strlen(HTML_TAGS[t]))==0) break;
    if(HTML_TAGS[t]==NULL) continue;  /* Tags not found */


    /*** Position 's' at beginning of URL ***/    
    s=s+strlen(HTML_TAGS[t]);
    while( (buffer[s]=='\'' || buffer[s]=='"' || buffer[s]==' ') && s<r ) s++;    


    /*** Prefix URL ***/
    if(strcmp(HTML_TAGS[t], "http://")==0) 
      {
      printf("http://");
      }
      else
      if(strncmp(&buffer[s], "http://", 7)) 
        {
        printf(BASE);
        if(buffer[s]!='/') printf("/");     /* Need a '/' after the base address?    */
        }


    /*** Print URL until end ***/
    while(buffer[s] && s<r && buffer[s]!='\'' && buffer[s]!='"' && buffer[s]!=' ' && buffer[s]!='\n')
      {
      printf("%c", buffer[s]);
      s++;
      }

    printf("\n");

    }
  

  } /* End of for() loop to read in the whole HTML file in chunks */

} /* End of main() */





void Mem2Hex(void *Mem, unsigned int Size)
{
unsigned int q1, q2;
unsigned char *p=Mem;

printf("\n          +00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F\n");
printf("---------+-------------------------------------------------+------------------+\n");

for(q1=0; q1<Size; q1=q1+16)
  {
  printf("%8X | ", (unsigned int) p);        /* Print memory address */
  for(q2=0; q2<16; q2++)
    {
    if((q1+q2)>=Size)
      {
      printf("   ");          /* Pad with spaces      */
      continue;
      }
    printf("%02X ", p[q2]);
    }
  printf("| ");

  for(q2=0; q2<16; q2++)
    {
    if((q1+q2)>=Size)
      {
      printf(" ");          /* Pad with spaces      */
      continue;
      }
    printf("%c", ((p[q2]>31 && p[q2]<127) ? p[q2] : '.'));
    }
  p=p+16;
  printf(" |\n");
  }
printf("---------+-------------------------------------------------+------------------+\n\n");
}




void LowerCase(char *String, unsigned int Size)
{
register unsigned int t;
for(t=0; String[t]; t++) 
  if(String[t]>='A' && String[t]<='Z') 
    String[t]=String[t]+32;
}

