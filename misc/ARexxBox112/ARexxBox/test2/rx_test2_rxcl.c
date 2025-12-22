/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#include <exec/types.h>
#include <dos/dos.h>
#include <rexx/storage.h>

#define NO_GLOBALS
#include "rx_test2.h"

#define RESINDEX(stype) (((long) &((struct stype *)0)->res) / sizeof(long))

char	RexxPortBaseName[80] = "TEST2";
char	*rexx_extension = "TEST2";

struct rxs_command rxs_commandlist[] =
{
	{ "ALIAS", "GLOBAL/S,NAME/A,COMMAND/F", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_alias, 1 },
	{ "CMDSHELL", "OPEN/S,CLOSE/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_cmdshell, 1 },
	{ "DISABLE", "GLOBAL/S,NAMES/M", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_disable, 1 },
	{ "ENABLE", "GLOBAL/S,NAMES/M", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_enable, 1 },
	{ "FAULT", "NUMBER/N/A", "DESCRIPTION", RESINDEX(rxd_fault), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_fault, 1 },
	{ "HELP", "COMMAND,PROMPT/S", "COMMANDDESC,COMMANDLIST/M", RESINDEX(rxd_help), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_help, 1 },
	{ "RX", "CONSOLE/S,ASYNC/S,COMMAND/F", "RC/N,RESULT", RESINDEX(rxd_rx), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_rx, 1 },
	{ NULL, NULL, NULL, NULL, NULL }
};

int		command_cnt = 7;

static struct arb_p_link link0[] = {
	{"RX", 1}, {"HELP", 2}, {"FAULT", 3}, {"ENABLE", 4}, {"DISABLE", 5}, {"CMDSHELL", 6},
	{"ALIAS", 7}, {NULL, 0} };

struct arb_p_state arb_p_state[] = {
	{-1, link0}, {6, NULL}, {5, NULL}, {4, NULL}, {3, NULL},
	{2, NULL}, {1, NULL}, {0, NULL}  };

