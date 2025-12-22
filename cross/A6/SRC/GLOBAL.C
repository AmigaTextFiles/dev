/* ------------------------------------------------------------------
    GLOBAL.C -- global variables for the A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#include <stdio.h>

/* Listing to stdout?  0=no */
int g_listflag=0;
FILE *g_listout=stdout;

/* Pass 2?  1=yes */
int g_pass;

/* End of current pass?  1=yes */
int g_endofpass;

/* Allow dropping of dots on pseudo-ops? */
int g_dotflag=0;

/* Number of errors so far */
unsigned int g_errorcount=0;

/* Undocumented opcodes on/off */
int g_undocopsflag=0;

/* Syntax limitations */
int g_syntax=1;

/* Encode bytes */
int g_outf_add=0;
int g_outf_eor=0;

/* Output format and filename */
int g_outf_format=0;
char *g_outname;
