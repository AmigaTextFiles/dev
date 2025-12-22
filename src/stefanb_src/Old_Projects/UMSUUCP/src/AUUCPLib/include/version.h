
/*
 *  VERSION.H
 *
 *  Major version number (minor version numbers kept in subsidary
 *  files.
 */

#ifndef _CONFIG_H
#include "config.h"
#endif

#define VERSION "V1.16"

#define COPYRIGHT \
   "(C) Copyright 1987 by John Gilmore\n"   \
   "Copying and use of this program are controlled by the terms of the Free\n" \
   "Software Foundation's GNU Emacs General Public License.\n"                \
   "Amiga Changes Copyright 1988 by William Loftus. All rights reserved.\n"     \
   "Additional chgs Copyright 1989 by Matthew Dillon, All Rights Reserved.\n"

#define DCOPYRIGHT \
    "(c)Copyright 1990-92, Matthew Dillon, all rights reserved\n"

#define IDENT(subv)   static char *Ident = "@($)" __FILE__ " " VERSION subv " " __DATE__

