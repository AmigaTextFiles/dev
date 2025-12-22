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

static char *Encode_Base64(unsigned char *Three);

char *Encode_Password(char *Username, char *Password)
{
char            in_buffer[76];
static char     out_buffer[76];
unsigned char   buffer[4];        /* Buffer to keep bytes in    */
unsigned char  *p;                /* Pointer to result          */
unsigned int    last=0;           /* Flag to count ending bytes */

unsigned int    t;

sprintf(in_buffer, "%s:%s", Username, Password);
out_buffer[0]='\0';

for(t=0; buffer[t]; t=t+3)
  {
  buffer[0]=in_buffer[t];      if(!in_buffer[t]) break;
  buffer[1]=in_buffer[t+1];    if(!in_buffer[t+1]) {buffer[1]=0; last=1;}
  buffer[2]=in_buffer[t+2];    if(!in_buffer[t+2] && !last) {buffer[2]=0; last=2;}

  p=Encode_Base64(buffer);

  if(last==1) {p[2]='=';p[3]='=';}
  if(last==2) {p[3]='=';}

  strcat(out_buffer, p);

  if(last) break;

  } /* End of for() loop */

return out_buffer;
}

static char *Encode_Base64(unsigned char *Three)
{
const char b64set[65]="ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
                      "abcdefghijklmnopqrstuvwxyz" \
                      "0123456789+/=";
static unsigned char four[5];
four[0]=b64set[                        (Three[0]>>2)];
four[1]=b64set[((Three[0] & 3)  <<4) + (Three[1]>>4)];
four[2]=b64set[((Three[1] & 15) <<2) + (Three[2]>>6)];
four[3]=b64set[ (Three[2] & 63)                     ];
four[4]=0;

return four;
}
