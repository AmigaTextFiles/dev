/*
    Ixprefs v.1.2--ixemul.library configuration program
    Copyright © 1995 Kriton Kyrimis

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#include <stdio.h>
#include <string.h>
#include <exec/types.h>
#include <dos/dos.h>
#include <intuition/intuition.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include "ixemul.h"
#include "ixprefs.h"

void cleanup(void);
void displayprefs(void);
int showrequester(struct Window*, char *, char *);
extern int parse_cli_commands(int argc, char *argv[]);

extern struct ixemul_base *ixemulbase;
int translatedot, translateslash, translatelinks, amiga_dos, membuf, watcher,
    redzone, blocks, ignoreenv, pattern, cases, suppress, console, fibcache;

main(int argc, char *argv[])
{
  long status;
  char warn[160];

  if (ixemulbase->ix_lib.lib_Version < 41) {
    showrequester(NULL,
	"This program requires ixemul.library version 41.0",
	"EXIT");
    return RETURN_FAIL;
  }
  if (ixemulbase->ix_lib.lib_Version > 41 ||
	ixemulbase->ix_lib.lib_Revision > 1) {
    sprintf(warn, "This program requires ixemul.library version 41.0 or 41.1.\n"
		  "You are running version %d.%d,\n"
		  "under which the program has not been tested.",
		  ixemulbase->ix_lib.lib_Version,
		  ixemulbase->ix_lib.lib_Revision);
    status = showrequester(NULL, warn, "CONTINUE|QUIT");
    if (status == 0) {
      exit(RETURN_FAIL);
    }
  }
  suppress = (ixemulbase->ix_no_insert_disk_requester ? 1 : 0);
  cases = (ixemulbase->ix_unix_pattern_matching_case_sensitive ? 1 : 0);
  pattern = (ixemulbase->ix_unix_pattern_matching ? 1 : 0);
  console = (ixemulbase->ix_no_ces_then_open_console ? 1 : 0);
  ignoreenv = (ixemulbase->ix_ignore_global_env ? 1 : 0);
  fibcache = (ixemulbase->ix_disable_fibcache ? 1 : 0);
  translatedot = (ixemulbase->ix_translate_dots ? 1 : 0);
  watcher = (ixemulbase->ix_watch_stack ? 1 : 0);
  amiga_dos = (ixemulbase->ix_force_translation ? 0 : 1);      /* sic! */
  translatelinks = (ixemulbase->ix_translate_symlinks ? 0 : 1);/* sic! */
  translateslash = (ixemulbase->ix_translate_slash ? 1 : 0);
  membuf = ixemulbase->ix_membuf_limit;
  redzone = ixemulbase->ix_red_zone_size;
  blocks = ixemulbase->ix_fs_buf_factor;
  
  if (argc >= 2) {
    return parse_cli_commands(argc, argv);
  }

  atexit(cleanup);

  status = SetupScreen();
  if (status != 0) {
    fprintf(stderr, "SetupScreen failed, status = %d\n", status);
    return RETURN_FAIL;
  }
  ixprefsTop=Scr->BarHeight+1;
  status = OpenixprefsWindow();
  if (status != 0) {
    fprintf(stderr, "OpenixprefsWindow failed, status = %d\n", status);
    return RETURN_FAIL;
  }

  displayprefs();

  while (1) {
    WaitPort(ixprefsWnd->UserPort);
    status = HandleixprefsIDCMP();
    if (status == 0) {
      return RETURN_OK;
    }
  }
  return 0;
}

void
cleanup()
{
  CloseixprefsWindow();
  CloseDownScreen();
}

void
check(int which)
{
  ixprefsGadgets[which]->Flags |= GFLG_SELECTED;
}

void
uncheck(int which)
{
  ixprefsGadgets[which]->Flags &= ~GFLG_SELECTED;
}

void
showchecked(int which, int checkit)
{
  if (checkit) {
    check(which);
  }else{
    uncheck(which);
  }
  RefreshGList(ixprefsGadgets[which], ixprefsWnd, NULL, 1);
}

void
shownum(int which, int num)
{
  sprintf(GetString(ixprefsGadgets[which]), "%d", num);
  GetNumber(ixprefsGadgets[which]) = num;
  RefreshGList(ixprefsGadgets[which], ixprefsWnd, NULL, 1);
}

void
displayprefs()
{
  showchecked(GDX_translatedot, translatedot);
  showchecked(GDX_translateslash, translateslash);
  showchecked(GDX_translatelinks, translatelinks);
  showchecked(GDX_amigados, amiga_dos);
  shownum(GDX_membuf, membuf);
  showchecked(GDX_watcher, watcher);
  shownum(GDX_redzone, redzone);
  shownum(GDX_blocks, blocks);
  showchecked(GDX_ignoreenv, ignoreenv);
  showchecked(GDX_pattern, pattern);
  showchecked(GDX_case, cases);
  showchecked(GDX_suppress, suppress);
  showchecked(GDX_console, console);
  showchecked(GDX_fibcache, fibcache);
}

int
showrequester(struct Window *win, char *text, char *buttontext)
{
  static struct EasyStruct easy = {
    sizeof(struct EasyStruct),
    0,
    "ixprefs",
    NULL,
    NULL,
  };

  if (win || strchr(buttontext, '|')) {
    easy.es_TextFormat = (UBYTE *)text;
    easy.es_GadgetFormat = (UBYTE *)buttontext;
    return EasyRequest(NULL, &easy, NULL);
  }else{
    fprintf(stderr, "%s\n", text);
  }
}
