/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#include <exec/types.h>
#include <dos/dos.h>
#include <rexx/storage.h>

#define NO_GLOBALS
#include "cxref.h"

#define RESINDEX(stype) (((long) &((struct stype *)0)->res) / sizeof(long))

char	RexxPortBaseName[80] = "FASTCREF";
char	*rexx_extension = "FASTCREF";

struct rxs_command rxs_commandlist[] =
{
	{ "FILE", "OPEN/S,CLOSE/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_file, 1 },
	{ "QUIT", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_quit, 1 },
	{ "SEARCH", "WORD/A", "FILENAME,LINENUMBER", RESINDEX(rxd_search), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_search, 1 },
	{ NULL, NULL, NULL, NULL, NULL }
};

int		command_cnt = 3;

static struct arb_p_link link0[] = {
	{"SEARCH", 1}, {"QUIT", 2}, {"FILE", 3}, {NULL, 0} };

struct arb_p_state arb_p_state[] = {
	{-1, link0}, {2, NULL}, {1, NULL}, {0, NULL}  };

