        IFND    GADTOOLSBOX_PREFS_I
GADTOOLSBOX_PREFS_I SET     1
**
**      $Filename: gadtoolsbox/prefs.i $
**      $Release: 1.0 $
**      $Revision: 38.4 $
**
**      GadToolsBox preferences file definitions.
**
**      (C) Copyright 1992,1993 Jaba Development.
**          Written by Jan van den Baard
**
        IFND    EXEC_TYPES_I
        include "exec/types.i"
        ENDC

        IFND    PREFS_PREFHDR_I
        include "prefs/prefhdr.i"
        ENDC

** GadToolsBox main config file format

GTBCONFIGSAVE       MACRO
                    DC.B    'ENVARC:GadToolsBox/GadToolsBox.prefs',0
                    ENDM

GTBCONFIGUSE        MACRO
                    DC.B    'ENV:GadToolsBox/GadToolsBox.prefs',0
                    ENDM

GTBCONFIGVERSION    EQU     0
MAXUSERNAME         EQU     64
MAXICONPATH         EQU     128

ID_GTCO             EQU     'GTCO'

        STRUCTURE GadToolsConfig,0
            ULONG       gtc_ConfigFlags0
            ULONG       gtc_ConfigFlags1
            UWORD       gtc_CrunchBuffer
            UWORD       gtc_CrunchType
            STRUCT      gtc_UserName,MAXUSERNAME
            STRUCT      gtc_IconPath,MAXICONPATH
            STRUCT      gtc_Reserved,4*4
        LABEL           gtc_SIZEOF

** flag definitions for gtc_ConfigFlags0
        BITDEF      GC0,COORDINATES,0
        BITDEF      GC0,WRITEICON,1
        BITDEF      GC0,GZZADJUST,2
        BITDEF      GC0,CRUNCH,3
        BITDEF      GC0,CLOSEWBENCH,4
        BITDEF      GC0,PASSWORD,5
        BITDEF      GC0,OVERWRITE,6
        BITDEF      GC0,ASLFREQ,7
        BITDEF      GC0,FONTADAPT,8
        BITDEF      GC0,USEPUBSCREEN,9

** GadToolsBox library generation prefs file format
** NOTE: This is not yet supported by GadToolsBox and the library

GTBLIBGENSAVE       MACRO
                    DC.B    'ENVARC:GadToolsBox/LibGen.prefs',0
                    ENDM

GTBLIBGENUSE        MACRO
                    DC.B    'ENV:GadToolsBox/LibGen.prefs',0
                    ENDM

GTBLIBGENVERSION    EQU     0
MAXLIBNAME          EQU     32
MAXBASENAME         EQU     32

ID_LIBG             EQU     'LIBG'

        STRUCTURE LibraryGen,0
            STRUCT      lg_LibraryName,MAXLIBNAME
            STRUCT      lg_LibraryBase,MAXBASENAME
            UWORD       lg_Flags
            WORD        lg_MinVersion
            STRUCT      lg_Reserved,4*4
        LABEL           lg_SIZEOF

** flags for the library generation preferences
        BITDEF      LG,GENERATE,0
        BITDEF      LG,MODULE,1
        BITDEF      LG,FAILREQ,2
        BITDEF      LG,DISKLIB,3
        BITDEF      LG,INTERNAL,4

** GadToolsBox C source generation preferences

GTBGENCSAVE         MACRO
                    DC.B    'ENVARC:GadToolsBox/GenC.prefs',0
                    ENDM

GTBGENCUSE          MACRO
                    DC.B    'ENV:GadToolsBox/GenC.prefs',0
                    ENDM

GTBGENCVERSION      EQU     0

ID_GENC             EQU     'GENC'

        STRUCTURE GenC,0
            STRUCT      gc_GTConfig,gtc_SIZEOF
            ULONG       gc_GenCFlags0
            ULONG       gc_GenCFlags1
            STRUCT      gc_Reserved,4*4
        LABEL           gc_SIZEOF

** flags for the C source generation preferences
        BITDEF      CS0,STATIC,0
        BITDEF      CS0,GENOPENFONT,1
        BITDEF      CS0,SYSFONT,2
        BITDEF      CS0,PRAGMAS,3
        BITDEF      CS0,AZTEC,4
        BITDEF      CS0,GENHANDLER,5
        BITDEF      CS0,TEMPLATES,6

** GadToolsBox assembly source generation preferences

GTBGENASMSAVE       MACRO
                    DC.B    'ENVARC:GadToolsBox/GenAsm.prefs',0
                    ENDM

GTBGENASMUSE        MACRO
                    DC.B    'ENV:GadToolsBox/GenAsm.prefs',0
                    ENDM

GTBGENASMVERSION    EQU     0

ID_GENA             EQU     'GENA'

        STRUCTURE GenAsm,0
            STRUCT      ga_GTConfig,gtc_SIZEOF
            ULONG       ga_GenAsmFlags0
            ULONG       ga_GenAsmFlags1
            STRUCT      ga_Reserved,4*4
        LABEL           ga_SIZEOF

** Flags for the asembly source generation preferences
        BITDEF      AS0,STATIC,0
        BITDEF      AS0,RAW,1
        BITDEF      AS0,GENOPENFONT,2
        BITDEF      AS0,SYSFONT,3
        BITDEF      AS0,AMIGALIB,4

        ENDC
