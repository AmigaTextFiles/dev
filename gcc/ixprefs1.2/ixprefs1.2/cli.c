/*
    Ixprefs v.1.2--ixemul.library configuration program
    Copyright © 1995 Kriton Kyrimis

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

#include <dos/dos.h>
#include <stdio.h>
#include "getopt.h"

extern void defaults(void), use(void), save(void), last_saved(void);
extern int ixprefsabout(void);

extern int translatedot, translateslash, translatelinks, amiga_dos, membuf,
	   watcher, redzone, blocks, ignoreenv, pattern, cases, suppress,
	   console, fibcache;

void
usage(char *prog)
{
  printf("Usage: %s [OPTION]...\n\nOptions:\n", prog);
  printf("-. 1, --translate-dots\n");
  printf("  translate . and ..\n");
  printf("-. 0, --no-translate-dots\n");
  printf("  don't translate . and ..\n");
  printf("-/ 1, --translate-slash\n");
  printf("  translate /foo -> foo: and a//b -> a/b\n");
  printf("-/ 0, --no-translate-slash\n");
  printf("  don't translate /foo -> foo: and a//b -> a/b\n");
  printf("-l 1, --translate-symlinks\n");
  printf("  translate contents of symbolic links\n");
  printf("-l 0, --no-translate-symlinks\n");
  printf("  don't translate contents of symbolic links\n");
  printf("-a 0, --force-translation\n");
  printf("  don't allow AmigaDOS notation\n");
  printf("-a 1, --no-force-translation\n");
  printf("  allow AmigaDOS notation\n");
  printf("-m N, --membuf-limit N\n");
  printf("  files upto N bytes are cached in memory\n");
  printf("-w 1, --watch-stack\n");
  printf("  enable stack watcher\n");
  printf("-w 0, --no-watch-stack\n");
  printf("  disable stack watcher\n");
  printf("-r N, --red-zone-size N\n");
  printf("  set red zone size to N bytes\n");
  printf("-b N, --fs-buf-factor N\n");
  printf("  N physical blocks map into 1 logical (stdio) block\n");
  printf("-i 1, --ignore-global-env\n");
  printf("  ignore global environment (ENV:)\n");
  printf("-i 0, --no-ignore-global-env\n");
  printf("  don't ignore global environment (ENV:)\n");
  printf("-p 1, --unix-pattern-matching\n");
  printf("  use UNIX-style filename pattern-matching\n");
  printf("-p 0, --no-unix-pattern-matching\n");
  printf("  don't use UNIX-style filename pattern-matching\n");
  printf("-s 1, --unix-pattern-matching-case-sensitive\n");
  printf("  use case sensitive UNIX pattern matching\n");
  printf("-s 0, --no-unix-pattern-matching-case-sensitive\n");
  printf("  use case insensitive UNIX patter matching\n");
  printf("-v 0, --insert-disk-requester\n");
  printf("  suppress the \"Insert volume in drive\" requester\n");
  printf("-v 1, --noinsert-disk-requester\n");
  printf("  don't suppress the \"Insert volume in drive\" requester\n");
  printf("-c 1, --no-ces-then-open-console\n");
  printf("  open console if no errorstream was provided\n");
  printf("-c 0, --no-no-ces-then-open-console\n");
  printf("  don't open console if no errorstream was provided\n");
  printf("-x 1, --disable-fibcache\n");
  printf("  disable FileInfoBlock cache\n");
  printf("-x 0, --no-disable-fibcache\n");
  printf("  don't disable FileInfoBlock cache\n");
  printf("-d, --default\n");
  printf("  reset settings to defaults (other options are ignored)\n");
  printf("-L, --last-saved\n");
  printf("  reset settings from configuration file (other options are ignored)\n");
  printf("-S, --save\n");
  printf("  save new configuration\n");
  printf("-R, --report\n");
  printf("  display new configuration\n");
  printf("-V, --version\n");
  printf("  display program version information (other options are ignored)\n");
  printf("-h, --help\n");
  printf("  display this text\n");
  printf("\nUse no arguments to get the GUI\n");
}

void
display_config(void)
{
  printf((translatedot ? "T" : "Do not t"));
  printf("ranslate . and .., ");
  printf((translateslash ? "" : "do not "));
  printf("translate /, ");
  printf((translatelinks ? "" : "do not "));
  printf("translate symlinks,\n");
  printf((amiga_dos ? "" : "do not "));
  printf("allow AmigaDOS notation, ");
  printf("membuf size = %d,\n", membuf);
  printf("stack watcher is ");
  printf((watcher ? "en" : "dis"));
  printf("abled, red zone size = %d,\n", redzone);
  printf("%d physical block", blocks);
  printf(((blocks == 1) ? "" : "s"));
  printf(" build");
  printf(((blocks == 1) ? "s" : ""));
  printf(" one logical block (for stdio),\n");
  printf((ignoreenv ? "" : "do not "));
  printf("ignore global environment (ENV:),\n");
  printf((pattern ? "" : "do not "));
  printf("use UNIX-style pattern-matching (case ");
  printf((cases ? "" : "in"));
  printf("sensitive),\n");
  printf((suppress ? "" : "do not "));
  printf("suppress the \"Insert volume in drive\" requester,\n");
  printf((console ? "" : "do not "));
  printf("open console if no errorstream was provided,\n");
  printf((fibcache ? "" : "do not "));
  printf("disable FIB cache.\n");
}

int
parse_cli_commands(int argc, char *argv[])
{
  int c, error = 0, status;
  static int reset_defaults = 0, save_config = 0, help = 0, report = 0,
	     last = 0, version = 0;

  while (1) {
    int option_index = 0;
    static struct option long_options[] = {
      {"insert-disk-requester", 0, &suppress, 0},		/* -v */
      {"no-insert-disk-requester", 0, &suppress, 1},
      {"unix-pattern-matching-case-sensitive", 0, &cases, 1},	/* -s */
      {"no-unix-pattern-matching-case-sensitive", 0, &cases, 0},
      {"unix-pattern-matching", 0, &pattern, 1},		/* -p */
      {"no-unix-pattern-matching", 0, &pattern, 0},
      {"no-ces-then-open-console", 0, &console, 1},		/* -c */
      {"no-no-ces-then-open-console", 0, &console, 0},
      {"ignore-global-env", 0, &ignoreenv, 1},			/* -i */
      {"no-ignore-global-env", 0, &ignoreenv, 0},
      {"disable-fibcache", 0, &fibcache, 1},			/* -x */
      {"no-disable-fibcache", 0, &fibcache, 0},
      {"translate-dots", 0, &translatedot, 1},			/* -. */
      {"no-translate-dots", 0, &translatedot, 0},
      {"watch-stack", 0, &watcher, 1},				/* -w */
      {"no-watch-stack", 0, &watcher, 0},
      {"force-translation", 0, &amiga_dos, 0},			/* -a */
      {"no-force-translation", 0, &amiga_dos, 1},
      {"translate-symlinks", 0, &translatelinks, 1},		/* -l */
      {"no-translate-symlinks", 0, &translatelinks, 0},
      {"translate-slash", 0, &translateslash, 1},		/* -/ */
      {"no-translate-slash", 0, &translateslash, 0},
      {"membuf-limit", 1, 0, 'm'},				/* -m */
      {"red-zone-size", 1, 0, 'r'},				/* -r */
      {"fs-buf-factor", 1, 0, 'b'},				/* -b */
      {"default", 0, &reset_defaults, 1},			/* -d */
      {"save", 0, &save_config, 1},				/* -S */
      {"report", 0, &report, 1},				/* -R */
      {"last-saved", 0, &last, 1},				/* -L */
      {"version", 0, &version, 1},				/* -V */
      {"help", 0, &help, 1},					/* -h */
      {0, 0, 0, 0}
    };
    c = getopt_long (argc, argv, "v:s:p:c:i:x:.:w:a:l:/:m:r:b:dShRLV",
				 long_options, &option_index);
    if (c == EOF) {
      break;
    }
    switch (c) {
      case 0:
	break;
      case 'v':
	suppress = (atoi(optarg) ? 0 : 1);
	break;
      case 's':
	cases = (atoi(optarg) ? 1 : 0);
	break;
      case 'p':
	pattern = (atoi(optarg) ? 1 : 0);
	break;
      case 'c':
	console = (atoi(optarg) ? 1 : 0);
	break;
      case 'i':
	ignoreenv = (atoi(optarg) ? 1 : 0);
	break;
      case 'x':
	fibcache = (atoi(optarg) ? 1 : 0);
	break;
      case '.':
	translatedot = (atoi(optarg) ? 1 : 0);
	break;
      case 'w':
	watcher = (atoi(optarg) ? 1 : 0);
	break;
      case 'a':
	amiga_dos = (atoi(optarg) ? 1 : 0);
	break;
      case 'l':
	translatelinks = (atoi(optarg) ? 1 : 0);
	break;
      case '/':
	translateslash = (atoi(optarg) ? 1 : 0);
	break;
      case 'm':
	membuf = atoi(optarg);
	break;
      case 'r':
	redzone = atoi(optarg);
	break;
      case 'b':
	blocks = atoi(optarg);
	break;
      case 'd':
	reset_defaults = 1;
	break;
      case 'S':
	save_config = 1;
	break;
      case 'h':
        help = 1;
	break;
      case 'R':
        report = 1;
	break;
      case 'L':
        last = 1;
	break;
      case 'V':
        version = 1;
	break;
      default:
	error = 1;
	break;
    }
  }
  if (optind < argc) {
    error = 1;
  }
  if (error) {
    fprintf(stderr, "\n");
    usage(argv[0]);
    status = RETURN_FAIL;
  }else{
    status = RETURN_OK;
    if (version) {
      (void)ixprefsabout();
    }else{
      if (help) {
	usage(argv[0]);
      }else{
	if (last) {
	  if (reset_defaults) {
	    fprintf(stderr,
  "--last-saved and --default specified together.  --default ignored.\n");
	  }
	  last_saved();
	}
	if (reset_defaults) {
	  defaults();
	}
	if (save_config) {
	  save();
	}else{
	  use();
	}
	if (report) {
	  display_config();
	}
      }
    }
  }
  return status;
}
