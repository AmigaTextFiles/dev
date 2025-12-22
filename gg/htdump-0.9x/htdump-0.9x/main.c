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
/** Defines                                                               **/

#define INTERN         1       /* Tie global variables to this object */



/***************************************************************************/
/** Includes                                                              **/

#include "global.h"




int main(int Argc, char *Argv[])
{

/***************************************************************************/
/** Declare variables and pointers                                        **/

UINT   socket;                  /* FD of the tcp socket                    */
BOOL   scan_http_headers;       /* Boolean if we are still reading headers */
ULINT  bytes_left;




InitConfig(Argc, Argv);                                     /* arguments.c */


/* OpenFile should be called before BuildRequest, since an allready
   existing file might alter the range header in case of a resume.
   If no file is specified, output all data to stdout.
*/   


OpenFile();                                                      /* file.c */







BuildRequest();                                             /* arguments.c */

socket = OpenSocket();                                         /* socket.c */


if(CONFIG.debug)
  fprintf(stderr, "-------------------------------------\n"
                  "Request:\n"
                  "%s"
                  "-------------------------------------\n"
                  "Argv[0]  : [%s]\n"
                  "Username : [%s]\n"
                  "Password : [%s]\n"
                  "B64_pass : [%s]\n"
                  "Host     : [%s]\n"
                  "Port     : [%s]\n"
                  "Path     : [%s]\n"
                  "Debug    : [%i]\n"
                  "Newargc  : [%i]\n"
                  "output_fd: [%i]\n"
                  "-------------------------------------\n"
                  ,CONFIG.request
                  ,CONFIG.new_argv[0]
                  ,CONFIG.url_username
                  ,CONFIG.url_password
                  ,CONFIG.url_b64_password
                  ,CONFIG.url_host
                  ,CONFIG.url_service
                  ,CONFIG.url_path
                  ,CONFIG.debug
                  ,CONFIG.new_argc
                  ,CONFIG.output_fd
                  );






WriteSocket(socket, CONFIG.request, strlen(CONFIG.request));   /* socket.c */





/***************************************************************************/
/** Read response                                                         **/



if(CONFIG.hdr_version)                                                      /* If HTTP/1.x then we get headers */ 
  scan_http_headers=1;
  else 
  scan_http_headers=0;


for(;;)                                                                     /* LOOP until end of file */
  {

  if(CONFIG.content_length)                                                 /* Calc. what size to read in */
    {
    bytes_left = CONFIG.content_length - CONFIG.output_written;
    if(bytes_left > RESPONSE_SIZE)
      bytes_left = RESPONSE_SIZE - 1;
    }
    else
    bytes_left = RESPONSE_SIZE - 1;

/*
printf("CONFIG.response_length  %u\n"
       "CONFIG.content_length   %lu\n"
       "CONFIG.output_written   %lu\n"
       "bytes_left              %lu\n"
       "----------\n"
       ,CONFIG.response_length
       ,CONFIG.content_length
       ,CONFIG.output_written
       ,bytes_left
       );
*/  
  CONFIG.response_length=ReadSocket(socket, CONFIG.response, bytes_left);   /* Start reading */

  if(CONFIG.response_length==0)                                             /* Bad read or EOF if size unknown */
    {
    if(CONFIG.content_length)
      fprintf(stderr, "\nShort read!\n\n");
    break;
    }

  if(CONFIG.debug>1)                                                        /* Show what we read in */
    Mem2Hex(CONFIG.response, CONFIG.response_length);

  if(scan_http_headers==1)                                                  /* Parse headers */
    scan_http_headers=Read_Headers();

  if(CONFIG.response_length==0 || scan_http_headers==1)                     /* Go straight to read again? */
    continue;

  WriteFile();                                                              /* Write data to file or stdout */

  if(CONFIG.output_written==CONFIG.content_length)                          /* Written all the data */
    break;

  if(CONFIG.debug && CONFIG.output_file)                                    /* Show download progress */
    fprintf(stderr, "Downloaded %lu of %lu bytes\r"
                    ,CONFIG.output_written
                    ,CONFIG.content_length
                    );

  } /* End of loop */



/***************************************************************************/
/** Clean up                                                              **/

CloseFile();
CloseSocket(socket);

return 0;
} /* end of main() */


