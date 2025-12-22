/*************************************************************************
 *
 * deea
 *
 * Copyright ©1995 Lee Kindness and Evan Tuer
 * cs2lk@scms.rgu.ac.uk
 *
 * dechunk.h
 */

#ifndef _DEEA_H_
#define _DEEA_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "machine.h"
#include "shared.h"
#include "version.h"

const char ver[] = "\0$VER: deea " VERSION_NUM " " VERSION_DATE;

#define BUF_SIZE 80

#define NOTIN_EA 0
#define IN_EA 1

#define SECTION_PRE 0
#define SECTION_DATA 1
#define SECTION_POST 2

#endif


