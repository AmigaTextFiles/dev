/*************************************************************************
 *
 * Chunker/DeChunker
 *
 * Copyright ©1995 Lee Kindness
 * cs2lk@scms.rgu.ac.uk
 *
 * bfn.h
 */

#ifndef __BFN_H__
#define __BFN_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "machine.h"

char *BuildFName(char *base, long *num);
void FreeFName(char *fname);

#endif
