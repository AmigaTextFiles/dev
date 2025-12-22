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

void Usage(void)
{
printf("\n"
       "\n"
       " htdump [options] [http[s]://][username:password@]<server>[:port][path]\n"
       "\n"
       "\n"
       " DESCRIPTION\n"
       " ===================================\n"
       " htdump is an automation utility to retrieve URLs and write them\n"
       " to a file or process them through a pipeline. When compiled with\n"
       " OpenSSL, this program will support SSL connections.\n"
       "\n"
       "\n"
       " OPTIONS\n"
       " ===================================\n"
       " Main mode of operation:\n"
       " -command=<command>     Define request command. Default is 'GET'.\n"
       " -post=<form data>      POST form data. When used, command is\n"
       "                        overriden to 'POST'\n"
       "\n"
       " Miscellaneous:\n"
       " -debug=<level>         Debug mode, specify level\n"
       " -file=<file>           Dump data to file. (Auto-resumes)\n"
       "                        When omitted, output goes to stdout.\n"
       "\n"
       " Header adjustment:\n"
       " -accept=<Accept>       Add 'Accept:' header\n"
       " -cookie=<Cookie>       Add 'Cookie:' header\n"
       " -from=<From>           Add 'From:' header\n"
       " -host=<Host>           Add 'Host:' header           (*)\n"
       " -referer=<Referer>     Add 'Referer:' header\n"
       " -range=<Range string>  Add 'Range:' header          (*)\n"
       " -agent=<Agent string>  Add 'User-Agent:' header\n"
       " -version=<0|1|r>       Select HTTP version. Default is HTTP/1.1\n"
       "\n"
       " (*) = HTTP/1.1 only\n"
       " You need version 1.1 to use password authentication\n"
       "\n"
       "\n"
       " EXAMPLES\n"
       " ===================================\n"
       " htdump www.netscape.com\n"
       " htdump https://flemming:secret@www.jamesbond.com/members/secret.html\n"
       " htdump -host=\"www.vhost1.com\" http://127.0.0.1/\n"
       " htdump -referer=\"www.fbi.gov\" http://www.arpa.mil/secret.zip\n"
       " htdump -version=r -agent=\"Crazy www browser 1.6\" http://bouncy.com/\n"
       " htdump -command=\"OPTIONS\" http://arak.cs.hro.nl/ -debug\n"
       " htdump -file=this.zip download.com/this.zip &\n"
       " htdump http://download.com/big.zip -range=\"644221-\" >> big.zip &\n"
       " htdump -post=\"name=Ren&op1=yes\" here.com/cgi-bin/prog\n"
       "\n"
       "\n"
       " htdump "VERSION"\n"
       " Copyright Ren Hoek (ren@arak.cs.hro.nl)\n"
       " Distributed under an Artistic License.\n"
       " Homepage: http://arak.cs.hro.nl/~ren/linux/\n"
       "\n"
      );
exit(6);
}      
