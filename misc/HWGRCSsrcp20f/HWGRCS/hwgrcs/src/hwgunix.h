/*------------------------------------------------------------------------*/
/*                                                                        *
 *  $Id: hwgunix.h 1.7 1995/06/21 19:50:09 heinz Exp $
 *                                                                        */
/*------------------------------------------------------------------------*/

/*------------------------------------------------------------------------*/
#include <time.h>
#include <stdio.h>

#include <exec/types.h>
#include <dos/dos.h>

/*------------------------------------------------------------------------*/
struct utimbuf
{
    time_t actime, modtime;
};

int utime(const char *file, const struct utimbuf *utb);

/*------------------------------------------------------------------------*/
int umask(int mode);
char *getlogin(void);

/*------------------------------------------------------------------------*/
char *mktemp(char *template);

/*------------------------------------------------------------------------*/
struct passwd
{
    int     pw_uid;
    int     pw_gid;
    char    *pw_name;
    char    *pw_dir;
};

struct passwd *getpwnam(char *nam);
struct passwd *getpwuid(int uid);

/*------------------------------------------------------------------------*/
int getuid(void);
int geteuid(void);

/*------------------------------------------------------------------------*/
int gethostname(char *name, int namelen);

/*------------------------------------------------------------------------*/
int dup2( int oldfd, int newfd);
int dup(int oldfd);

/*------------------------------------------------------------------------*/
char *AMIGA_makeargstr(const char **arglist, int withnewline,
                       const char *runcmd,
                       const char *bufprefix);

/*------------------------------------------------------------------------*/
FILE *AMIGA_popen(const char *command, const char *type);
int pclose(FILE *stream);

/*------------------------------------------------------------------------*/
FILE *popen(const char *command, const char *type);

/*------------------------------------------------------------------------*/
FILE *popenl(const char *arg0, ...);

/*------------------------------------------------------------------------*/
FILE *popenv(const char **arglist, const char *mode);

/*------------------------------------------------------------------------*/
void AMIGA_SPrintf(unsigned char *buf, const unsigned char *format, ...);

/*------------------------------------------------------------------------*/
void __DeleteNIHandler(void *SysBase, void *DOSBase, struct MsgPort *procid);
struct MsgPort *__CreateNIHandler(void *SysBase, void *DOSBase,
                                  BPTR origfh, BOOL dieonend);
BPTR __CreateNIReadFileHandle(void *SysBase, void *DOSBase, BPTR origfh);

/*------------------------------------------------------------------------*/

/* Ende des Quelltextes */

