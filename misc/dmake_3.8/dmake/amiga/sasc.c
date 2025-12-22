/* Definitions for SAS/C 6.51 */

long __oslibversion = 37;	/* Requires AmigaOS 2.0 */
long __stack = 10000;		/* Estimate */
static char ver[] = "$VER: dmake 3.8 " __AMIGADATE__;

#include <stat.h>
#include <dos.h>

int my_stat(const char *name, struct stat *statstruct)
{
  /* SAS/C 6.51 stat() leaves a file lock if program has been aborted */
  /* As a workaround we must explicitly check the abort before stat() */

  chkabort();
  return stat(name, statstruct);
}
