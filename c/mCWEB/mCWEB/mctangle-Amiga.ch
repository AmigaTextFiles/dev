This is the change file for mCWEB's mCTANGLE on the Amiga
(Contributed by Thomas Öllinger, April 1996)

With SAS 6.0, use compilation switches Code=far Data=far.

@x
@ @<Glob...@>=
text text_info[max_texts];
@y
@ @<Glob...@>=
char *version_tag="\0$VER: mCTANGLE 1.1 (4.10.98)";
text text_info[max_texts];
@z

@x
#include <utime.h>
@y
#include <dos/dos.h>
@z

@x
  struct stat s;
  struct utimbuf u;
@y
  BPTR lock;
  __aligned struct FileInfoBlock fib;
  BOOL success;
@z

@x
      stat(expname,&s);        /* save file date */
      remove(expname);         /* remove old file */
      rename(tmpname,expname); /* new file becomes export file */
      u.actime=s.st_atime;
      u.modtime=s.st_mtime;
      utime(expname,&u);       /* reset file date */
@y
      if(lock=Lock(expname, ACCESS_READ)) {
        success=Examine(lock, &fib);  /* save file date */
        UnLock(lock);
        remove(expname);         /* remove old file */
        rename(tmpname,expname); /* new file becomes export file */
        if(success) {
          SetFileDate(expname,&fib.fib_Date);  /* reset file date */
        }
      }
@z

@x
    if(*buffer && strcmp(buffer,"-") && strcmp(buffer,"/dev/null")) {
@y
    if(*buffer && strcmp(buffer,"-") && strcmp(buffer,"nil:")) {
@z

@x
  if(!mkdir(a_file_name,S_IRUSR|S_IWUSR|S_IXUSR|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH))
@y
  if(!mkdir(a_file_name))
@z
