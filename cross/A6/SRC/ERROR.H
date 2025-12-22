/* ------------------------------------------------------------------
    ERROR.H -- header file for A6 error handler module
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */
/* ERROR.H */

#ifndef _ERROR_H
#define _ERROR_H

#define ERR_FATAL (-1)
#define ERR_WARNING (1)
#define ERR_PASS1 (2)
#define ERR_PASS2 (3)

void error(char *,int);
void errors(char *,char *,int);

#endif
