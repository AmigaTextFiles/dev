/*
 * Source generated with ARexxBox 1.12 (May 18 1993)
 * which is Copyright (c) 1992,1993 Michael Balzer
 */

#include <exec/types.h>
#include <dos/dos.h>
#include <rexx/storage.h>

#define NO_GLOBALS
#include "rx_test.h"

#define RESINDEX(stype) (((long) &((struct stype *)0)->res) / sizeof(long))

char	RexxPortBaseName[80] = "arbtest";
char	*rexx_extension = "arbtest";

struct rxs_command rxs_commandlist[] =
{
	{ "HELP", "COMMAND,PROMPT/S", "COMMANDDESC,COMMANDLIST/M", RESINDEX(rxd_help), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_help, 1 },
	{ "INOUT", "ARG1/N", "RES1", RESINDEX(rxd_inout), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_inout, 1 },
	{ "MULTI_IN_NUM", "LISTE/N/M", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_multi_in_num, 1 },
	{ "MULTI_IN_STR", "LISTE/M", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_multi_in_str, 1 },
	{ "MULTI_OUT_NUM", NULL, "LISTE/N/M", RESINDEX(rxd_multi_out_num), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_multi_out_num, 1 },
	{ "MULTI_OUT_STR", NULL, "LISTE/M", RESINDEX(rxd_multi_out_str), (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_multi_out_str, 1 },
	{ "OPEN", "FILE/K,PROMPT/S", NULL, 0, (void (*)(struct RexxHost *,void **,long,struct RexxMsg *)) rx_open, 1 },
	{ NULL, NULL, NULL, NULL, NULL }
};

int		command_cnt = 7;

static struct arb_p_link link0[] = {
	{"OPEN", 1}, {"MULTI_", 2}, {"INOUT", 9}, {"HELP", 10}, {NULL, 0} };

static struct arb_p_link link2[] = {
	{"OUT_", 3}, {"IN_", 6}, {NULL, 0} };

static struct arb_p_link link3[] = {
	{"STR", 4}, {"NUM", 5}, {NULL, 0} };

static struct arb_p_link link6[] = {
	{"STR", 7}, {"NUM", 8}, {NULL, 0} };

struct arb_p_state arb_p_state[] = {
	{-1, link0}, {6, NULL}, {2, link2}, {4, link3}, {5, NULL},
	{4, NULL}, {2, link6}, {3, NULL}, {2, NULL}, {1, NULL},
	{0, NULL}  };

