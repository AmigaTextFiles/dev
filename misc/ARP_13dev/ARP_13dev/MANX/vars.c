/* Created 11/08/87 by -=+SDB+=- from file vars.c provided by Manx */
/* Copyright (C) 1987 by Scott Ballantyne */
/* Freely usable by arp supporters */

#include <fcntl.h>
#include <workbench/startup.h>

void *SysBase, *DOSBase, *MathBase, *MathTransBase;
void *MathIeeeDoubBasBase, *MathIeeeDoubTransBase;
void *ArpBase, *IntuitionBase, *GfxBase;  /* Arp specials, DOSBase == ArpBase (NOT ANY MORE) */

/* Following two declarations now moved to AztecGlue.s
 * Makes it easier to *only* use the glue routines, if that is what
 * you desire
 */
/*long Errno;				  /* For return from Atol() */
/*struct DefaultTracker *LastTracker;	  /* For tracking calls */

/*char *CLI_Template = ",,,,,,,,,,,,,,,"; /* Default command template for GADS */
/*void *CLI_Help;			  /* Extra help line for GADS */
long _savsp, _stkbase;

int errno, Enable_Abort;

struct WBStartup *WBenchMsg;

int _argc;
char **_argv;

struct _dev *_devtab;
short _numdev = 20;

char *_detach_name = 0; 		/* for DETACHED programs */
long _detach_curdir = 0;

void *_oldtrap, **_trapaddr;	/* for signal() cleanup */

