#ifndef GADTOOLSBOX_PREFS_H
#define GADTOOLSBOX_PREFS_H
/*
**      $VER: gadtoolsbox/prefs.h 39.1 (12.4.93)
**      GTXLib headers release 2.0.
**
**      GadToolsBox preferences file definitions.
**
**      (C) Copyright 1992,1993 Jaba Development.
**          Written by Jan van den Baard
**/

#ifndef PREFS_PREFHDR_H
#include <prefs/prefhdr.h>
#endif

/* GadToolsBox main config file format */

#define GTBCONFIGSAVE       "ENVARC:GadToolsBox/GadToolsBox.prefs"
#define GTBCONFIGUSE        "ENV:GadToolsBox/GadToolsBox.prefs"

#define GTBCONFIGVERSION    0
#define MAXUSERNAME         64
#define MAXICONPATH         128

#define ID_GTCO                 MAKE_ID('G','T','C','O')

struct GadToolsConfig {
    ULONG                   gtc_ConfigFlags0;
    ULONG                   gtc_ConfigFlags1;
    UWORD                   gtc_CrunchBuffer;
    UWORD                   gtc_CrunchType;
    UBYTE                   gtc_UserName[ MAXUSERNAME ];
    UBYTE                   gtc_IconPath[ MAXICONPATH ];
    ULONG                   gtc_Reserved[ 4 ];
};

/* flag definitions for gtc_ConfigFlags0 */
#define GC0_COORDINATES     (1<<0)
#define GC0_WRITEICON       (1<<1)
#define GC0_GZZADJUST       (1<<2)
#define GC0_CRUNCH          (1<<3)
#define GC0_CLOSEWBENCH     (1<<4)
#define GC0_PASSWORD        (1<<5)
#define GC0_OVERWRITE       (1<<6)
#define GC0_ASLFREQ         (1<<7)
#define GC0_FONTADAPT       (1<<8)
#define GC0_USEPUBSCREEN    (1<<9)

/* GadToolsBox library generation prefs file format */
/* NOTE: This is not yet supported by GadToolsBox and the library! */

#define GTBLIBGENSAVE       "ENVARC:GadToolsBox/LibGen.prefs"
#define GTBLIBGENUSE        "ENV:GadToolsBox/LibGen.prefs"

#define GTBLIBGENVERSION    0
#define MAXLIBNAME          32
#define MAXBASENAME         32

#define ID_LIBG             MAKE_ID('L','I','B','G')

struct LibraryGen {
    UBYTE                   lg_LibraryName[ MAXLIBNAME ];
    UBYTE                   lg_LibraryBase[ MAXBASENAME ];
    UWORD                   lg_Flags;
    WORD                    lg_MinVersion;
    ULONG                   lg_Reserved[ 4 ];
};

/* Flags for the library generation preferences. */
#define LGF_GENERATE        (1<<0)
#define LGF_MODULE          (1<<1)
#define LGF_FAILREQ         (1<<2)
#define LGF_DISKLIB         (1<<3)
#define LGF_INTERNAL        (1<<4)

/* GadToolsBox C Source generation preferences. */

#define GTBGENCSAVE         "ENVARC:GadToolsBox/GenC.prefs"
#define GTBGENCUSE          "ENV:GadToolsBox/GenC.prefs"

#define GTBGENCVERSION      0

#define ID_GENC             MAKE_ID('G','E','N','C')

struct GenC {
    struct GadToolsConfig   gc_GTConfig;
    ULONG                   gc_GenCFlags0;
    ULONG                   gc_GenCFlags1;
    ULONG                   gc_Reserved[ 4 ];
};

/* Flags for the C Source generation preferences. */
#define CS0_STATIC          (1<<0)
#define CS0_GENOPENFONT     (1<<1)
#define CS0_SYSFONT         (1<<2)
#define CS0_PRAGMAS         (1<<3)
#define CS0_AZTEC           (1<<4)
#define CS0_GENHANDLER      (1<<5)
#define CS0_TEMPLATES       (1<<6)

/* GadToolsBox Assembly Source generation preferences */

#define GTBGENASMSAVE       "ENVARC:GadToolsBox/GenAsm.prefs"
#define GTBGENASMUSE        "ENV:GadToolsBox/GenAsm.prefs"

#define GTBGENASMVERSION    0

#define ID_GENA             MAKE_ID('G','E','N','A')

struct GenAsm {
    struct GadToolsConfig   ga_GTConfig;
    ULONG                   ga_GenAsmFlags0;
    ULONG                   ga_GenAsmFlags1;
    ULONG                   ga_Reserved[ 4 ];
};

/* Flags for the Assembly Source generation preferences. */
#define AS0_STATIC          (1<<0)
#define AS0_RAW             (1<<1)
#define AS0_GENOPENFONT     (1<<2)
#define AS0_SYSFONT         (1<<3)
#define AS0_AMIGALIB        (1<<4)

#endif
