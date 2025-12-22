/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#include <exec/types.h>
#include <dos/dos.h>
#include <rexx/storage.h>

#define NO_GLOBALS
#include "EditPrefs.h"

#define RESINDEX(stype) (((long) &((struct stype *)0)->res) / sizeof(long))

char	RexxPortBaseName[80] = "standard";
char	*rexx_extension = "standard";

struct rxs_command rxs_commandlist[] =
{
	{ "DEFAULTS", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_defaults, 1 },
	{ "LASTSAVED", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_lastsaved, 1 },
	{ "OPEN", "FILENAME/K", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_open, 1 },
	{ "QUIT", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_quit, 1 },
	{ "RESTORE", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_restore, 1 },
	{ "SAVE", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_save, 1 },
	{ "SAVEAS", "NAME/K", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_saveas, 1 },
	{ "SETATTR", "TITLE/A,VALUE/A", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_setattr, 1 },
	{ "USE", NULL, NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_use, 1 },
	{ NULL, NULL, NULL, NULL, NULL }
};

int		command_cnt = 9;

static struct arb_p_link link0[] = {
	{"USE", 1}, {"S", 2}, {"RESTORE", 6}, {"QUIT", 7}, {"OPEN", 8}, {"LASTSAVED", 9},
	{"DEFAULTS", 10}, {NULL, 0} };

static struct arb_p_link link2[] = {
	{"ETATTR", 3}, {"AVE", 4}, {NULL, 0} };

static struct arb_p_link link4[] = {
	{"AS", 5}, {NULL, 0} };

struct arb_p_state arb_p_state[] = {
	{-1, link0}, {8, NULL}, {5, link2}, {7, NULL}, {5, link4},
	{6, NULL}, {4, NULL}, {3, NULL}, {2, NULL}, {1, NULL},
	{0, NULL}  };

