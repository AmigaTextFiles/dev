/* ------------------------------------------------------------------
    GLOBAL.H -- global variables for the A6 cross assembler
     This is free software, please see the file
     "COPYING" for copyright and licence details
   ------------------------------------------------------------------ */

#ifndef _GLOBAL_H
#define _GLOBAL_H

#include <stdio.h>

#define G_VER 0x403
#define G_FAILVER 0x500

extern int g_listflag;
extern FILE *g_listout;

extern int g_dotflag;

extern int g_pass;
extern int g_endofpass;

extern unsigned int g_errorcount;

extern int g_undocopsflag;

extern int g_syntax;

extern int g_outf_add;
extern int g_outf_eor;

extern int g_outf_format;

extern char *g_outname;

#endif
