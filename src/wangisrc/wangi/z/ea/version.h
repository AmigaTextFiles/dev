/*************************************************************************
 *
 * ea/deea
 *
 * Copyright ©1995 Lee Kindness and Evan Tuer
 * cs2lk@scms.rgu.ac.uk
 *
 * version.h
 */

#include "machine.h"

#ifndef _VERSION_H_
#define _VERSION_H_

#define VERSION_NUM "1.0"
#ifdef AMIGA
#define VERSION_DATE __AMIGADATE__
#else
#define VERSION_DATE ""
#endif

#ifdef AMIGA
#define CREATOR "ea " VERSION_NUM " Amiga"
#else
#ifdef MSDOS
#define CREATOR "ea " VERSION_NUM " MSDOS"
#else
#define CREATOR "ea " VERSION_NUM " Generic"
#endif
#endif

#endif
