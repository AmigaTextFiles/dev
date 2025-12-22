        IFND    GADTOOLSBOX_GTXBASE_I
GADTOOLSBOX_GTXBASE_I   SET     1
**
**      $Filename: gtxbase.i $
**      $Release: 1.0 $
**      $Revision: 39.1 $
**
**      gadtoolsbox.library base definitions.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard
**
        IFND    EXEC_TYPES_I
        include "exec/types.i"
        ENDC

        IFND    EXEC_LIBRARIES_I
        include "exec/libraries.i"
        ENDC

GTXNAME         MACRO
                DC.B    'gadtoolsbox.library',0
                ENDM

GTXVERSION      EQU     39

        STRUCTURE GTXBase,LIB_SIZE
**
** These library bases may be extracted from this structure
** for your own usage as long as the GTXBase pointer remains
** valid.
**
            APTR            gxb_DOSBase;
            APTR            gxb_IntuitionBase;
            APTR            gxb_GfxBase;
            APTR            gxb_GadToolsBase;
            APTR            gxb_UtilityBase;
            APTR            gxb_IFFParseBase;
            APTR            gxb_ConsoleDevice;
            APTR            gxb_NoFragBase;
**
** The next library pointer is not guaranteed to
** be valid! Please check this pointer _before_ using
** it!
**
            APTR            gxb_PPBase;
        LABEL               gxb_SIZEOF

        ENDC
