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


/***************************************************************************/
/** Includes                                                              **/

#include "global.h"




/***************************************************************************\
**                                                                         **
**  Read_Headers()                                                         **
**                                                                         **
**  A function to parse the headers in front of the HTML data.             **
**  Activly looks for the errorcode and content-length.                    **
**                                                                         **
**  Returns 1 if still parsing headers but needs more data to be read.     **
**                                                                         **
\***************************************************************************/

UINT Read_Headers(void)
{
UINT  t;
UCHAR line[255];

for(;;) 
  {
  
  for(t=0; t<CONFIG.response_length; t++)              /* Search for newline */
    if(CONFIG.response[t]=='\n')
      break;
      
  if(t==CONFIG.response_length)                        /* No newline found in the headers, get more data */
    return 1;
  
  t=sgets(line, 254, CONFIG.response);

  CONFIG.response_length=CONFIG.response_length-t;     /* Response buffer minus what we read out of it */

  if(strncmp(line, "HTTP", 4)==0)                      /* Get HTTP response code, usually '200 OK' */
    CONFIG.response_code=atoi(line+9);

  if(strncmp(line, "Content-Length: ", 16)==0)         /* Get content-length */
    CONFIG.content_length=atoi(line+16);

  if(strncmp(line, "Content-length: ", 16)==0)         /* Netscape httpd is not conform RFC, so this is a workaround */
    CONFIG.content_length=atoi(line+16);

  if(CONFIG.debug)                                     /* Display header we found */
    fprintf(stderr, "Header: %s\n", line);      

  if(line[0]=='\0')                                    /* Found end of header block. Exit */
    {
    if(CONFIG.debug)
      fprintf(stderr, "-------------------------------------\n"
                      "Content-length : %lu\n"
                      "Errorcode      : %u\n"
                      "-------------------------------------\n"
                      ,CONFIG.content_length
                      ,CONFIG.response_code
                      );
    return 0;                                          /* Return 0, we're at the end of the headers */
    }

  } /* End of for() */


return 1;                                              /* Return 1, since we still need to read more headers */

} /* End of Read_Headers() */
