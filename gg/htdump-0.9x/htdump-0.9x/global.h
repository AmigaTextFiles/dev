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


/*** BUG! Response size _has_ to bigger that the headers put together
     or you end up in an endless loop
***/


#define RESPONSE_SIZE        4096
#define REQUEST_SIZE         2048
#define TEMP_BUFFER_SIZE     2048
#define VERSION              "0.9x"



/******************** NO USER CHANGES BELOW THIS LINE ****************/
/** At least those not developing the program ;)                    **/


#define BOOL                 unsigned char
#define UCHAR                unsigned char        
#define UINT                 unsigned int         
#define ULINT                unsigned long int         




/***************************************************************************/
/** Includes                                                              **/

#include <unistd.h>     /* read() write() getopt() */
#include <string.h>     /* bcopy() strcmp() */
#include <stdlib.h>     /* atoi() */
#include <stdio.h>      /* printf() */

#include <sys/types.h>  /* open() */
#include <sys/stat.h>
#include <fcntl.h>



/***************************************************************************/
/** Proto-types                                                           **/

/* socket.c */
unsigned int OpenSocket(void);
unsigned int ReadSocket(unsigned int Socket, char *Buffer, unsigned int Length);
unsigned int WriteSocket(unsigned int Socket, char *Buffer, unsigned int Length);
void CloseSocket(unsigned int Socket);


/* file.c */
void OpenFile(void);
void WriteFile(void);
void CloseFile(void);


/* init.c */
void ArgCopy(UCHAR **Arg, UCHAR *NewValue);
void InitConfig(int Argc, char **Argv);
void CopyArguments(void);


/* read_headers.c */
UINT Read_Headers(void);


/* sgets.c */
UINT sgets(UCHAR *String, UINT Size, UCHAR *Buffer);


char *Encode_Password(char *Username, char *Password);                   /* enc_password.c */
void Mem2Hex(void *Mem, unsigned int Size);                              /* mem2hex.c */
void Usage(void);                                                        /* usage.c */

void BuildRequest(void);

void DelNChar(char *Buffer, unsigned int Location, unsigned int Number); /* delnchar.c */
void DelNBin(char *Buffer, unsigned int Buffer_len, unsigned int Location, unsigned int Number);
void Title(int Argc, char *Argv[], char *Title);





/***************************************************************************/
/** Struct declarations                                                   **/

struct ALL_CONFIG_DATA
  {
  UCHAR     *hdr_accept;
  UCHAR     *hdr_command;
  UCHAR     *hdr_from;
  UCHAR     *hdr_host;
  UCHAR     *hdr_cookie;
  UCHAR     *hdr_referer;
  UCHAR     *hdr_range;
  UCHAR     *hdr_agent;
  UINT       hdr_version;

  UCHAR     *url_host;
  UCHAR     *url_service;
  UCHAR     *url_username;
  UCHAR     *url_password;
  UCHAR     *url_b64_password;
  UCHAR     *url_path;
  
  BOOL       ssl;
  BOOL       escape;
  UINT       debug;

  UCHAR      request[REQUEST_SIZE];            /* Buffer for request        */
  UINT       request_length;

  UCHAR      response[RESPONSE_SIZE];          /* Buffer for responese      */
  UINT       response_length;

  UCHAR      temp_buffer[TEMP_BUFFER_SIZE];
  UINT       temp_length;

  int        argc;                             /* The original args         */
  char     **argv;

  int        new_argc;                         /* The args, after parsing   */
  char     **new_argv;
 
  ULINT      content_length;                   /* Contentlength of data     */
  UINT       response_code;                    /* Errorcode the server gave */

  UCHAR     *output_file;                      /* Output filename           */
  ULINT      output_written;                   /* Bytes written to file     */
  UINT       output_fd;                        /* FD to output to           */
  


  UCHAR     *post_content;                     /* Buffer with post data     */
  UINT       post_type;                        /* Method of post            */
  };




/***************************************************************************/
/** Globals                                                               **/

#if INTERN
#define EXTERN /**/
#else
#define EXTERN extern
#endif

EXTERN struct ALL_CONFIG_DATA CONFIG;         /* This struct contains all data */
