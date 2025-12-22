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
#include <intuition/intuition.h>
#include <proto/dos.h>
#include <proto/intuition.h>
#include "ixprefs.h"
#include "ixemul.h"

#define IXPREFS_VERSION "1.2"

#define RUNNING 1
#define NOT_RUNNING 0

#define CONFIGFILE "S:ixprefs"

/* These strings are long enough to have a high probability of being typed
   incorrectly, especially as they are used more than once. Using these
   definitions, we can detect typing errors at compile time */
#define IX_NO_INSERT_DISK_REQUESTER "ix_no_insert_disk_requester"
#define IX_UNIX_PATTERN_MATCHING_CASE_SENSITIVE "ix_unix_pattern_matching_case_sensitive"
#define IX_UNIX_PATTERN_MATCHING "ix_unix_pattern_matching"
#define IX_NO_CES_THEN_OPEN_CONSOLE "ix_no_ces_then_open_console"
#define IX_IGNORE_GLOBAL_ENV "ix_ignore_global_env"
#define IX_DISABLE_FIBCACHE "ix_disable_fibcache"
#define IX_TRANSLATE_DOTS "ix_translate_dots"
#define IX_WATCH_STACK "ix_watch_stack"
#define IX_FORCE_TRANSLATION "ix_force_translation"
#define IX_TRANSLATE_SYMLINKS "ix_translate_symlinks"
#define IX_TRANSLATE_SLASH "ix_translate_slash"
#define IX_MEMBUF_LIMIT "ix_membuf_limit"
#define IX_RED_ZONE_SIZE "ix_red_zone_size"
#define IX_FS_BUF_FACTOR "ix_fs_buf_factor"

extern int showrequester(struct Window*, char *, char *);

extern struct ixemul_base *ixemulbase;
extern int translatedot, translateslash, translatelinks, amiga_dos, membuf,
	   watcher, redzone, blocks, ignoreenv, pattern, cases, suppress,
	   console, fibcache;
void
use(void)
{
  ixemulbase->ix_translate_dots = translatedot;
  ixemulbase->ix_translate_slash = translateslash;
  ixemulbase->ix_translate_symlinks = !translatelinks;
  ixemulbase->ix_force_translation = !amiga_dos;
  ixemulbase->ix_membuf_limit = membuf;
  ixemulbase->ix_watch_stack = watcher;
  ixemulbase->ix_red_zone_size = redzone;
  ixemulbase->ix_fs_buf_factor = blocks;
  ixemulbase->ix_ignore_global_env = ignoreenv;
  ixemulbase->ix_unix_pattern_matching = pattern;
  ixemulbase->ix_unix_pattern_matching_case_sensitive = cases;
  ixemulbase->ix_no_insert_disk_requester = suppress;
  ixemulbase->ix_no_ces_then_open_console = console;
  ixemulbase->ix_disable_fibcache = fibcache;
}

void
save(void)
{
  char buf[120];
  FILE *f;

  use();
  f = fopen(CONFIGFILE, "w");
  if (f) {
    fprintf(f, IX_NO_INSERT_DISK_REQUESTER "=%d\n", suppress);
    fprintf(f, IX_UNIX_PATTERN_MATCHING_CASE_SENSITIVE "=%d\n", cases);
    fprintf(f, IX_UNIX_PATTERN_MATCHING "=%d\n", pattern);
    fprintf(f, IX_NO_CES_THEN_OPEN_CONSOLE "=%d\n", console);
    fprintf(f, IX_IGNORE_GLOBAL_ENV "=%d\n", ignoreenv);
    fprintf(f, IX_DISABLE_FIBCACHE "=%d\n", fibcache);
    fprintf(f, IX_TRANSLATE_DOTS "=%d\n", translatedot);
    fprintf(f, IX_WATCH_STACK "=%d\n", watcher);
    fprintf(f, IX_FORCE_TRANSLATION "=%d\n", !amiga_dos);
    fprintf(f, IX_TRANSLATE_SYMLINKS "=%d\n", !translatelinks);
    fprintf(f, IX_TRANSLATE_SLASH "=%d\n", translateslash);
    fprintf(f, IX_MEMBUF_LIMIT "=%d\n", membuf);
    fprintf(f, IX_RED_ZONE_SIZE "=%d\n", redzone);
    fprintf(f, IX_FS_BUF_FACTOR "=%d\n", blocks);
    fclose(f);
  }else{
    showrequester(ixprefsWnd, "Can't open " CONFIGFILE, "OK");
  }
}

int
selected(which)
{
  if (ixprefsGadgets[which]->Flags & GFLG_SELECTED) {
    return 1;
  }else{
    return 0;
  }
}

int translatedotClicked( void )
{
  /* routine when gadget "translate . and .." is clicked. */
  translatedot = selected(GDX_translatedot);
  return RUNNING;
}

int savegadClicked( void )
{
  /* routine when gadget "Save" is clicked. */
  save();
  return NOT_RUNNING;
}

int usegadClicked( void )
{
  /* routine when gadget "Use" is clicked. */
  use();
  return NOT_RUNNING;
}

int cancelgadClicked( void )
{
  /* routine when gadget "Cancel" is clicked. */
  return NOT_RUNNING;
}

int translatelinksClicked( void )
{
  /* routine when gadget "translate symlinks" is clicked. */
  translatelinks = selected(GDX_translatelinks);
  return RUNNING;
}

int translateslashClicked( void )
{
  /* routine when gadget "translate /" is clicked. */
  translateslash = selected(GDX_translateslash);
  return RUNNING;
}

int amigadosClicked( void )
{
  /* routine when gadget "allow AmigaDOS notation" is clicked. */
  amiga_dos = selected(GDX_amigados);
  return RUNNING;
}

int membufClicked( void )
{
  /* routine when gadget "membuf size" is clicked. */
  membuf = GetNumber(ixprefsGadgets[GDX_membuf]);
  return RUNNING;
}

int redzoneClicked( void )
{
  /* routine when gadget "red zone size" is clicked. */
  redzone = GetNumber(ixprefsGadgets[GDX_redzone]);
  return RUNNING;
}

int watcherClicked( void )
{
  /* routine when gadget "enable stack watcher" is clicked. */
  watcher = selected(GDX_watcher);
  return RUNNING;
}

int blocksClicked( void )
{
  /* routine when gadget "physical blocks to build one logical block (for stdio)" is clicked. */
  blocks = GetNumber(ixprefsGadgets[GDX_blocks]);
  return RUNNING;
}

int ignoreenvClicked( void )
{
  /* routine when gadget "ignore global environment (ENV:)" is clicked. */
  ignoreenv = selected(GDX_ignoreenv);
  return RUNNING;
}

int patternClicked( void )
{
  /* routine when gadget "use UNIX-style pattern-matching (" is clicked. */
  pattern = selected(GDX_pattern);
  return RUNNING;
}

int caseClicked( void )
{
  /* routine when gadget "case sensitive)" is clicked. */
  cases = selected(GDX_case);
  return RUNNING;
}

int suppressClicked( void )
{
  /* routine when gadget "suppress the \"Insert volume in drive\" requester" is clicked. */
  suppress = selected(GDX_suppress);
  return RUNNING;
}

int consoleClicked( void )
{
  /* routine when gadget "open console if no errorstream was provided" is clicked. */
  console = selected(GDX_console);
  return RUNNING;
}

int fibcacheClicked( void )
{
  /* routine when gadget "disable fibcache" is clicked. */
  fibcache = selected(GDX_fibcache);
  return RUNNING;
}

int ixprefssave( void )
{
  /* routine when (sub)item "Save" is selected. */
  save();
  return NOT_RUNNING;
}

int ixprefsuse( void )
{
  /* routine when (sub)item "Use" is selected. */
  use();
  return NOT_RUNNING;
}

int ixprefsabout( void )
{
  /* routine when (sub)item "About" is selected. */
  showrequester(ixprefsWnd,
    "Ixprefs v." IXPREFS_VERSION "--ixemul.library configuration program\n"
    "Copyright \251 1995 Kriton Kyrimis\n\n"
    "This program is free software; you can redistribute it\n"
    "and/or modify it under the terms of the GNU General\n"
    "Public License as published by the Free Software Foundation;\n"
    "either version 2 of the License, or (at your option)\n"
    "any later version.\n\n"
    "GUI designed using GadToolsBox 2.0c by Jan van den Baard",
    "OK");
  return RUNNING;
}

int ixprefsquit( void )
{
  /* routine when (sub)item "Quit" is selected. */
  return NOT_RUNNING;
}

void
defaults()
{
  suppress	 = 0;
  cases		 = 0;
  pattern	 = 0;
  console	 = 1;
  ignoreenv	 = 0;
  fibcache	 = 0;
  translatedot	 = 1;
  watcher	 = 0;
  amiga_dos	 = 1;
  translatelinks = 1;
  translateslash = 1;
  membuf	 = 0;
  redzone	 = 0;
  blocks	 = 64;
}

int ixprefsreset( void )
{
  /* routine when (sub)item "Reset to defaults" is selected. */

  defaults();
  displayprefs();
  return RUNNING;
}

int
last_saved(void)
{
  FILE *f;
  char *eq;
  int line = 0, value, status;
  char buf[80], err[90], cmd[80];

  f = fopen(CONFIGFILE, "r");
  if (f) {
    defaults();
    while (fgets(buf, sizeof(buf), f) != NULL) {
      line++;
      if (buf[0] == '#') {
        continue;
      }
      eq = strchr(buf, '=');
      if (!eq) {
	sprintf(err, "Can't parse line %d:\n%s", line, buf);
        showrequester(ixprefsWnd, err, "IGNORE");
	continue;
      }
      *eq = ' ';
      sscanf(buf, "%s", cmd);
      sscanf(eq+1, "%d", &value);
      if (strcmp(IX_NO_INSERT_DISK_REQUESTER, cmd) == 0) {
        suppress = value;
	continue;
      }
      if (strcmp(IX_UNIX_PATTERN_MATCHING_CASE_SENSITIVE, cmd) == 0) {
        cases = value;
	continue;
      }
      if (strcmp(IX_UNIX_PATTERN_MATCHING, cmd) == 0) {
        pattern = value;
	continue;
      }
      if (strcmp(IX_NO_CES_THEN_OPEN_CONSOLE, cmd) == 0) {
        console = value;
	continue;
      }
      if (strcmp(IX_IGNORE_GLOBAL_ENV, cmd) == 0) {
        ignoreenv = value;
	continue;
      }
      if (strcmp(IX_DISABLE_FIBCACHE, cmd) == 0) {
        fibcache = value;
	continue;
      }
      if (strcmp(IX_TRANSLATE_DOTS, cmd) == 0) {
        translatedot = value;
	continue;
      }
      if (strcmp(IX_WATCH_STACK, cmd) == 0) {
        watcher = value;
	continue;
      }
      if (strcmp(IX_FORCE_TRANSLATION, cmd) == 0) {
        amiga_dos = !value;
	continue;
      }
      if (strcmp(IX_TRANSLATE_SYMLINKS, cmd) == 0) {
        translatelinks = !value;
	continue;
      }
      if (strcmp(IX_TRANSLATE_SLASH, cmd) == 0) {
        translateslash = value;
	continue;
      }
      if (strcmp(IX_MEMBUF_LIMIT, cmd) == 0) {
        membuf = value;
	continue;
      }
      if (strcmp(IX_RED_ZONE_SIZE, cmd) == 0) {
        redzone = value;
	continue;
      }
      if (strcmp(IX_FS_BUF_FACTOR, cmd) == 0) {
        blocks = value;
	continue;
      }
      sprintf(err, "Unknown option \"%s\" at line %d", cmd, line);
      showrequester(ixprefsWnd, err, "IGNORE");
    }
    fclose(f);
    status = 0;
  }else{
    showrequester(ixprefsWnd, "Can't open " CONFIGFILE, "OK");
    status = 1;
  }
  return status;
}

int ixprefslast( void )
{
  /* routine when (sub)item "Last Saved" is selected. */
  if (last_saved() == 0) {
    displayprefs();
  }
  return RUNNING;
}

int ixprefsrestore( void )
{
  /* routine when (sub)item "Restore" is selected. */
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

  displayprefs();

  return RUNNING;
}

int ixprefsCloseWindow( void )
{
  /* routine for "IDCMP_CLOSEWINDOW". */
  return NOT_RUNNING;
}
