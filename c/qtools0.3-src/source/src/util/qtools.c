/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#define	LIBQTOOLS_CORE
#include <libqtools.h>
#include <libqdisplay.h>

/*
 * global vars
 */

int main(int argc, char **argv) {
  int i;
  char *outName = 0, *arcName = 0, *destDir = 0;
  bool script = TRUE, recurse = FALSE;
  operation procOper = OP_DEFAULT;
  unsigned char outType = TYPE_UNKNOWN, arcType = TYPE_UNKNOWN;

#if defined(DEBUG_C) && defined(HAVE_LIBDBMALLOC)
  union dbmalloptarg m;

  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_WARN, &m);
  m.i = M_HANDLE_IGNORE;
  dbmallopt(MALLOC_FATAL, &m);
#endif

  /* 
   * definition of interaction:
   *  if there is some to put out, use that specific type
   *  else if there is some to get in, use the same specific type
   */
  for (i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "-p") || !strcmp(argv[i], "--palette")) {
      argv[i] = 0;
      palFile = __open(argv[++i], H_READ_BINARY);
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-c") || !strcmp(argv[i], "--colormap")) {
      argv[i] = 0;
      colrFile = __open(argv[++i], H_READ_BINARY);
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-pp") || !strcmp(argv[i], "--preprocessor")) {
      argv[i] = 0;
      preProcessor = argv[++i];
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-a") || !strcmp(argv[i], "--achive-name")) {
      argv[i] = 0;
      arcName = argv[++i];
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-dd") || !strcmp(argv[i], "--destdir")) {
      argv[i] = 0;
      destDir = argv[++i];
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-l") || !strcmp(argv[i], "--darkness")) {
      char *tmp;

      argv[i] = 0;
      darkness = strtol(argv[++i], &tmp, 0);
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-o") || !strcmp(argv[i], "--output")) {
      argv[i] = 0;
      outName = argv[++i];
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-r") || !strcmp(argv[i], "--recurse")) {
      argv[i] = 0;
      recurse = TRUE;
    }
    else if (!strcmp(argv[i], "-ppm") || !strcmp(argv[i], "--output-ppm")) {
      argv[i] = 0;
      outType = TYPE_PPM;
    }
    else if (!strcmp(argv[i], "-jpg") || !strcmp(argv[i], "--output-jpeg")) {
      argv[i] = 0;
      outType = TYPE_JPEG;
    }
    else if (!strcmp(argv[i], "-iff") || !strcmp(argv[i], "--output-ilbm")) {
      argv[i] = 0;
      outType = TYPE_ILBM;
    }
    else if (!strcmp(argv[i], "-png") || !strcmp(argv[i], "--output-png")) {
      argv[i] = 0;
      outType = TYPE_PNG;
    }
    else if (!strcmp(argv[i], "-vis") || !strcmp(argv[i], "--type-is-vis")) {
      argv[i] = 0;
      arcType = TYPE_VIS;
    }
    else if (!strcmp(argv[i], "-wv") || !strcmp(argv[i], "--bsp-watervis")) {
      argv[i] = 0;
      watervis = TRUE;
    }
    else if (!strcmp(argv[i], "-sv") || !strcmp(argv[i], "--bsp-slimevis")) {
      argv[i] = 0;
      slimevis = TRUE;
    }
    else if (!strcmp(argv[i], "-wl") || !strcmp(argv[i], "--light-waterlit")) {
      argv[i] = 0;
      waterlit = TRUE;
    }
    else if (!strcmp(argv[i], "-light") || !strcmp(argv[i], "--light")) {
      argv[i] = 0;
      newLit = TRUE;
    }
    else if (!strcmp(argv[i], "-pvs") || !strcmp(argv[i], "--pvs")) {
      argv[i] = 0;
      newVis = TRUE;
    }
    else if (!strcmp(argv[i], "-rad") || !strcmp(argv[i], "--light-rad")) {
      argv[i] = 0;
      doradiosity = TRUE;
    }
    else if (!strcmp(argv[i], "-nf") || !strcmp(argv[i], "--bsp-nofill")) {
      argv[i] = 0;
      nofill = TRUE;
    }
    else if (!strcmp(argv[i], "-nt") || !strcmp(argv[i], "--bsp-notjunc")) {
      argv[i] = 0;
      notjunc = TRUE;
    }
    else if (!strcmp(argv[i], "-nc") || !strcmp(argv[i], "--bsp-noclip")) {
      argv[i] = 0;
      noclip = TRUE;
    }
    else if (!strcmp(argv[i], "-oe") || !strcmp(argv[i], "--bsp-onlyentities")) {
      argv[i] = 0;
      onlyents = TRUE;
    }
    else if (!strcmp(argv[i], "-cs") || !strcmp(argv[i], "--complete-search")) {
      argv[i] = 0;
      completeSearch = TRUE;
    }
    else if (!strcmp(argv[i], "-v") || !strcmp(argv[i], "--verbose")) {
      argv[i] = 0;
      verbose = TRUE;
#ifndef	VERBOSE
      mprintf("isn't compiled with verbose output, flag does not effect\n");
#endif
    }
    else if (!strcmp(argv[i], "-f") || !strcmp(argv[i], "--fatal")) {
      argv[i] = 0;
      fatal = TRUE;
    }
    else if (!strcmp(argv[i], "-fv") || !strcmp(argv[i], "--vis-fastvis")) {
      argv[i] = 0;
      fastvis = TRUE;
    }
    else if (!strcmp(argv[i], "-uh") || !strcmp(argv[i], "--bsp-usehulls")) {
      argv[i] = 0;
      usehulls = TRUE;
    }
    else if (!strcmp(argv[i], "-ex") || !strcmp(argv[i], "--light-extra")) {
      argv[i] = 0;
      extra = TRUE;
    }
    else if (!strcmp(argv[i], "-sc") || !strcmp(argv[i], "--light-scale")) {
      argv[i] = 0;
      scale = atof(argv[++i]);
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-rn") || !strcmp(argv[i], "--light-range")) {
      argv[i] = 0;
      range = atof(argv[++i]);
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-vl") || !strcmp(argv[i], "--vis-level")) {
      char *tmp;

      argv[i] = 0;
      vislevel = strtol(argv[++i], &tmp, 0);
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-hn") || !strcmp(argv[i], "--bsp-hullnum")) {
      char *tmp;

      argv[i] = 0;
      hullnum = strtol(argv[++i], &tmp, 0);
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-sd") || !strcmp(argv[i], "--bsp-subdivide")) {
      char *tmp;

      argv[i] = 0;
      subdivide = strtol(argv[++i], &tmp, 0);
      argv[i] = 0;
    }
    else if (!strcmp(argv[i], "-lit") || !strcmp(argv[i], "--type-is-light")) {
      argv[i] = 0;
      arcType = TYPE_LIT;
    }
    else if (!strcmp(argv[i], "-mip") || !strcmp(argv[i], "--type-is-mipmap")) {
      argv[i] = 0;
      arcType = TYPE_MIPMAP;
    }
    else if (!strcmp(argv[i], "-wal") || !strcmp(argv[i], "--type-is-wal")) {
      argv[i] = 0;
      arcType = outType = TYPE_WAL;
    }
    else if (!strcmp(argv[i], "-lmp") || !strcmp(argv[i], "--type-is-lump")) {
      argv[i] = 0;
      arcType = TYPE_LUMP;
    }
    else if (!strcmp(argv[i], "-ns") || !strcmp(argv[i], "--noscripting")) {
      argv[i] = 0;
      script = FALSE;
    }
    else if (!strcmp(argv[i], "-wv") || !strcmp(argv[i], "--wide-view")) {
      argv[i] = 0;
      wideView = TRUE;
    }
    else if (!strcmp(argv[i], "-lz") || !strcmp(argv[i], "--compress")) {
      argv[i] = 0;
      Compression |= CMP_LZ77;
    }
    else if (!strcmp(argv[i], "-mip0") || !strcmp(argv[i], "--onlymip0")) {
      argv[i] = 0;
      Compression |= CMP_MIP0;
    }
    else if (!strcmp(argv[i], "-dt") || !strcmp(argv[i], "--dither")) {
      char *tmp;

      argv[i] = 0;
      dither = TRUE;
      if((argv[i + 1][0] != '-') && (argv[i + 1][0] >= '0') && (argv[i + 1][0] <= '9')) {
        dithervalue = strtol(argv[++i], &tmp, 0);
        argv[i] = 0;
        if (dithervalue < 16)
	  dithervalue = 16;
        if (dithervalue > 256)
	  dithervalue = 256;
      }
    }
    else if (!strcmp(argv[i], "-sm") || !strcmp(argv[i], "--smooth")) {
      char *tmp;

      argv[i] = 0;
      smoothing = TRUE;
      if((argv[i + 1][0] != '-') && (argv[i + 1][0] >= '0') && (argv[i + 1][0] <= '9')) {
        smoothingvalue = strtol(argv[++i], &tmp, 0);
        argv[i] = 0;
        if (smoothingvalue < 1)
	  smoothingvalue = 1;
        if (smoothingvalue > 256)
	  smoothingvalue = 256;
      }
    }
    else if (!strcmp(argv[i], "x") || !strcmp(argv[i], "extract")) {
      argv[i] = 0;
      procOper = OP_EXTRACT;
    }
    else if (!strcmp(argv[i], "d") || !strcmp(argv[i], "delete")) {
      argv[i] = 0;
      procOper = OP_DELETE;
    }
    else if (!strcmp(argv[i], "a") || !strcmp(argv[i], "add")) {
      argv[i] = 0;
      procOper = OP_ADD;
    }
    else if (!strcmp(argv[i], "u") || !strcmp(argv[i], "update")) {
      argv[i] = 0;
      procOper = OP_UPDATE;
    }
    else if (!strcmp(argv[i], "r") || !strcmp(argv[i], "replace")) {
      argv[i] = 0;
      procOper = OP_REPLACE;
    }
    else if (!strcmp(argv[i], "l") || !strcmp(argv[i], "list")) {
      argv[i] = 0;
      procOper = OP_LIST;
      /* disable every standard-activity for listing */
      outType = 0;
    }
    else if (!strcmp(argv[i], "v") || !strcmp(argv[i], "view")) {
      argv[i] = 0;
      procOper = OP_VIEW;
      /* disable every standard-activity for viewing */
      outType = 0;
    }
    else if (!strcmp(argv[i], "-h") || !strcmp(argv[i], "--help")) {
      mprintf("%s [-<options>] [<command>] <file> ...

  options :
"
#ifdef	VERBOSE
"    -v, --verbose                     verbose output of informations
"
#endif
"    -f, --fatal                       make warnings errors
    -ns, --noscripting                do not script all actions
    -r, --recurse                     recurse operating

   input-basics:
    -p, --palette <palette>           use this quake palette lump
    -c, --colormap <colormap>         use this quake colormap lump
    -pp, --preprocessor <commandline> filter quake-c through this preprocessor
    -dd, --destdir <destdir>          alternative destination directory
    -l, --darkness <darkness>         take this darkness
    -lz, --compress                   compress wads
    -mip0, --onlymip0                 store only miplevel 0 in wads
    -dt, --dither [<value>]           dither floyd-steinberg with this error
    -sm, --smooth [<value>]           smooth with this fraction
    -light, --light		      if bsp calculate light too
    -pvs, --pvs			      if bsp calculate pvs (vis) too
    -cs, --complete-search            if searching for anim-frames, continue after FirstNotFound
  
   output-modifications:
    -o, --output <file>               specify archive-content or output-name
    -ppm, --output-ppm
    -jpg, --output-jpeg
    -iff, --output-ilbm
    -png, --output-png                convert pictures and palettes to ppm/jpg/iff/png
    -wv, --wide-view                  if view mipmaps display all mip-levels

   input-modifications
    -a, --archive-name <name>         use this name to load the file and input-name as
				      archive-entry
    -vis, --type-is-vis               use inputfile(s) as vis-lump fors bsps
    -lit, --type-is-light             use inputfile(s) as light-lump fors bsps
    -mip, --type-is-mipmap            use inputfile(s) as raw-mipmap
    -wal, --type-is-wal               use inputfile(s) as raw-wal
    -lmp, --type-is-lump              use inputfile(s) as raw-lump

   options for bsp:
    -wv, --bsp-watervis               make water visible in bsps
    -sv, --bsp-slimevis               make slime visible in bsps
    -nf, --bsp-nofill                 like -nofill in qbsp
    -nt, --bsp-notjunc                like -notjunc in qbsp
    -nc, --bsp-noclip                 like -noclip in qbsp
    -oe, --bsp-onlyentities           like -onlyents in qbsp
    -uh, --bsp-usehulls               like -usehulls in qbsp
    -hn, --bsp-hullnum <hullnum>      like -hullnum in qbsp
    -sd, --bsp-subdivide <subdivide>  like -subdivide in qbsp
   
   options for vis:
    -vl, --vis-level <level>          how much vis-calculation
    -fv, --vis-fastvis                like -fast in vis
   
   options for light:
    -ex, --light-extra                like -extra in light
    -rad, --light-rad                 do radiosity instead of old light algorithm
    -wl, --light-waterlit             make water emit light
    -sc, --light-range <range>        like -dist in light
    -rn, --light-scale <scale>        like -scale in light
   
  commands:

   a                   add
   d                   delete
   e                   edit (unimplemented)
   l                   list (default)
   r                   replace (unimplemented)
   u                   update (unimplemented)
   v                   view
   x                   extract

  examples:

   %s test.bsp test.pak test.wad test.mdl test.spr
    list all the contents of all the files
   %s x test.bsp test.pak test.wad test.mdl test.spr
    extract all the contents of all the files to the directory test.dir (bad :)
   %s x test1.bsp test2.pak test3.wad test4.mdl test" STR_FOR_DIR "test5.spr
    extract all the contents of all the files to the directories test1.dir
    test2.dir test3.dir test4.dir test" STR_FOR_DIR "test5.dir (good ;)
   %s -o *lava1 x test1.bsp
    extract the raw-mipmap-texture *lava1 to test1.dir" STR_FOR_DIR "*lava1.mip
   %s -dd test -o *lava1 x test1.bsp
    extract the raw-mipmap-texture *lava1 to test" STR_FOR_DIR "test1.dir" STR_FOR_DIR "*lava1.mip
   %s -o *lava1 x test1.wad
    extract the wad-content *lava1 to test1.dir" STR_FOR_DIR "*lava1.<wad2-type>
   %s -ppm -o *lava1 x test1.wad
    extract the wad-content *lava1 to test1.dir" STR_FOR_DIR "*lava1.ppm
   %s -ppm -o *lava1.mip x test1.wad
    extract the wad-content *lava1 to test1.dir" STR_FOR_DIR "*lava1.mip with conversion to ppm
    *lava1.mip is NOT a raw-mipmap-texture, its a PPM

   if you set \".xxx\" as extension, you will ever get the raw contents
   sometimes that could makes no sence (eg. for pictures if you can't read 'em)

(all rights reserved, Niels Froehling, Dyna-Tech 1998)
", argv[0], argv[0], argv[0], argv[0], argv[0], argv[0], argv[0], argv[0], argv[0]);
      if (palFile)
        __close(palFile);
      if (colrFile)
        __close(colrFile);
      return 0;
    }
  }

  if(argc > 1) {
    for (i = 1; i < argc; i++) {
      if(argv[i]) {
        processName(argv[i], destDir, outName, outType, arcName, arcType, procOper, script, recurse);
      }
    }
    if (palFile)
      __close(palFile);
    if (colrFile)
      __close(colrFile);
  }
  else
    mprintf("%s: no input files\nuse -h/--help for options\n", argv[0]);

  return 0;
}
