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


/* OpenFile will open a file and see if it has filepermissions. This is
   done because after a file is downloaded succesfully, filepermissions
   are set, but if the file is not completed yet, the filepermissions
   will be absent. e.g.
   
     11 ----------   1 root     root        12267 Nov 30 10:47 incomplete.zip
   
   7228 -rw-r--r--   1 root     root      7388035 Nov 30 10:47 finished.zip

   If the file _does_ exist, and filepermissions are clear, then the file
   is auto-resumed.
   Range headers are automatically appended to the request header, and the
   HTTP version is automatically set to HTTP 1.1.

   Note that these settings can still be overwritten by the arguments given
   on the commandline.

   Also note that this only works when the '-file' option is used, since
   we cannot detect if the user is saving to a file using stdout redirection.    

*/


void OpenFile(void)
{
struct stat output_stat;
UCHAR       output_range[32];

if(CONFIG.output_file==NULL)
  {
  CONFIG.output_fd=STDOUT_FILENO;
  if(CONFIG.debug)
    fprintf(stderr, "-------------------------------------\nWriting data to stdout\n");
  return; 
  }

if(stat(CONFIG.output_file, &output_stat)==0)
  {
  if(output_stat.st_mode==0x8000)  /* Check for filepermissions */
    {
    CONFIG.output_fd=open(CONFIG.output_file, O_WRONLY|O_APPEND, 0);

    sprintf(output_range, "%lu-", output_stat.st_size);
    ArgCopy(&CONFIG.hdr_range, output_range);
    CONFIG.hdr_version=2;
    }
    else
    {
    fprintf(stderr, "\nFile %s has permissions set (%u), will not overwrite, exiting...\n\n"
                    ,CONFIG.output_file
                    ,output_stat.st_mode
                    );
    exit(1);   /* Don't overwrite a valid file */
    }
  }
  else
  {
  CONFIG.output_written=0;
  CONFIG.output_fd=open(CONFIG.output_file, O_WRONLY|O_CREAT, 0);
  }
  

if(CONFIG.output_fd==-1)
  {
  fprintf(stderr, "\nError opening file [%s]\n\n", CONFIG.output_file);
  exit(1);
  }

if(CONFIG.debug) fprintf(stderr, "Opened file %s on fp %u\n", CONFIG.output_file, CONFIG.output_fd);
return;
}






void WriteFile(void)
{
unsigned int t;

t=write(CONFIG.output_fd, CONFIG.response, CONFIG.response_length);     /* Write data */

if(t==CONFIG.response_length)
  {
  CONFIG.output_written=CONFIG.output_written+t;
  }
  else
  {
  fprintf(stderr, "\nError writing to file! (%u of %u written)\n\n", t, CONFIG.response_length);
  CloseFile();
  exit(1);
  }

} /* End of WriteFile() */







void CloseFile(void)
{

if(CONFIG.output_fd==STDOUT_FILENO) return;   /* Don't close stdout! :) */

if(CONFIG.content_length)
  {
  if(CONFIG.output_written==CONFIG.content_length)
    {
    if(CONFIG.debug) 
      fprintf(stderr, "File closed complete, %lu bytes.\n\n"
                      ,CONFIG.output_written
                      );
    fchmod(CONFIG.output_fd, 0644);
    }
    else
    {
    if(CONFIG.debug) 
      fprintf(stderr, "File closed incomplete, %lu of %lu bytes.\n\n"
                      ,CONFIG.output_written
                      ,CONFIG.content_length
                      );
    }
  }
  else
  {
  if(CONFIG.debug)
    fprintf(stderr, "File closed, total size unknown, current %lu bytes.\n\n"
                    ,CONFIG.output_written
                    );
  fchmod(CONFIG.output_fd, 0644);
  }
  
close(CONFIG.output_fd);
}
