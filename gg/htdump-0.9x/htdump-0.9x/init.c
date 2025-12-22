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

#include <unistd.h>

#ifndef AMIGAOS
#include <getopt.h>
#endif

#ifdef AMIGAOS
#include "getopt.h"
#endif





/***************************************************************************\
**                                                                         **
**  InitConfig()                                                           **
**                                                                         **
**  Initialises the config struct.                                         **
**                                                                         **
\***************************************************************************/

void InitConfig(int Argc, char **Argv)
{
bzero(&CONFIG, sizeof(struct ALL_CONFIG_DATA));  /* Clear struct */

CONFIG.argc=Argc;                     /* Save argument count in CONFIG     */ 
CONFIG.argv=Argv;                     /* Save argument pointer in CONFIG   */

ArgCopy(&CONFIG.url_service, "80");   /* e.g. '8080'                       */
ArgCopy(&CONFIG.hdr_command, "GET");
CONFIG.hdr_version     = 2;           /* Standard on HTTP/1.1              */


CopyArguments();                      /* Parse commandline                 */


}







/***************************************************************************\
**                                                                         **
**  ArgCopy()                                                              **
**                                                                         **
**  Copies and allocates some memory.                                      **
**                                                                         **
\***************************************************************************/

void ArgCopy(UCHAR **Arg, UCHAR *NewValue)
{
if(*Arg) free(*Arg);

*Arg=malloc(strlen(NewValue)+1);

if(*Arg==NULL)
  {
  perror("ArgCopy");
  exit(1);
  }

strcpy(*Arg, NewValue);
}





/***************************************************************************\
**                                                                         **
**  CopyArguments()                                                        **
**                                                                         **
**  Parses the commandline into the CONFIG struct.                         **
**                                                                         **
\***************************************************************************/

void CopyArguments(void)
{
UINT t;

#define NO_ARG   0
#define ONE_ARG  1
#define OPT_ARG  2

static struct option long_options[] =
  { {"command",  ONE_ARG, NULL,  1},
    {"post",     ONE_ARG, NULL,  2},
    {"debug",    OPT_ARG, NULL,  3},
    {"file",     ONE_ARG, NULL,  4},
    {"escape",   OPT_ARG, NULL,  5},
    {"accept",   ONE_ARG, NULL,  6},
    {"cookie",   ONE_ARG, NULL,  7},
    {"host",     ONE_ARG, NULL,  8},
    {"referer",  ONE_ARG, NULL,  9},
    {"from",     ONE_ARG, NULL, 10},
    {"range",    ONE_ARG, NULL, 11},
    {"agent",    ONE_ARG, NULL, 12},
    {"version",  ONE_ARG, NULL, 13},
    {"help",     NO_ARG,  NULL, 14},
    {NULL, 0, NULL, 0}
  };


CONFIG.new_argc = CONFIG.argc;     /* Don't touch the original arguments  */
CONFIG.new_argv = CONFIG.argv;

while ((t = getopt_long_only(CONFIG.new_argc
                            ,CONFIG.new_argv
                            ,"h"
                            ,long_options
                            ,NULL
                            )) != EOF)

  {
  switch(t)
    {
    case  1:  /* Command to send, default GET */
              ArgCopy(&CONFIG.hdr_command, optarg);
              break;

    case  2:  /* POST message */
					// printf("post accepted...\n[%s]\n",optarg);
					strcpy(CONFIG.hdr_command,"POST");		// fixed by LouiSe
              ArgCopy(&CONFIG.post_content, optarg);
              break;

    case  3:  /* Turn on debugging */
              if(optarg)
                CONFIG.debug=atoi(optarg);
                else
                CONFIG.debug++;
              break;

    case  4:  /* Write data retrieved to file */
              ArgCopy(&CONFIG.output_file, optarg);
              break;

    case  5:  /* Escape characters in url */
              if(optarg)
                CONFIG.escape=atoi(optarg);
                else
                CONFIG.escape=1;
              break;

    case  6:  /* Accept: */
              ArgCopy(&CONFIG.hdr_accept, optarg);
              break;

    case  7:  /* Cookie: */
              ArgCopy(&CONFIG.hdr_cookie, optarg);
              break;

    case  8:  /* Host: */
              ArgCopy(&CONFIG.hdr_host, optarg);
              break;

    case  9:  /* Referer: */
              ArgCopy(&CONFIG.hdr_referer, optarg);
              break;

    case 10:  /* From: */
              ArgCopy(&CONFIG.hdr_from, optarg);
              break;

    case 11:  /* Range: bytes=xxx */
              ArgCopy(&CONFIG.hdr_range, optarg);
              break;

    case 12:  /* User-Agent: */
              ArgCopy(&CONFIG.hdr_agent, optarg);
              break;

    case 13:  /* HTTP version */
              switch(optarg[0])
                {
                case 'r':
                case 'R':  CONFIG.hdr_version=0;
                           break;
                case '0':  CONFIG.hdr_version=1;
                           break;
                case '1':  CONFIG.hdr_version=2;
                           break;
                }
              break;

    case 14:  /* Help */
    default:
    case '?': Usage();                               /* Usage, does not return         */

    } /* end of switch() */

  } /* end of while() */

CONFIG.new_argc = CONFIG.new_argc - optind;          /* Remove processed options       */
CONFIG.new_argv = CONFIG.new_argv + optind;

} /* End of CopyArguments() */
