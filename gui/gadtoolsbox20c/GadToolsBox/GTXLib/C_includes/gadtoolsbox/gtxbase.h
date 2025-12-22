#ifndef GADTOOLSBOX_GTXBASE_H
#define GADTOOLSBOX_GTXBASE_H
/*
**      $VER: gadtoolsbox/gtxbase.h 39.1 (12.4.93)
**      GTXLib headers release 2.0.
**
**      gadtoolsbox.library base definitions.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#define GTXNAME             "gadtoolsbox.library"
#define GTXVERSION          39

struct GTXBase {
    struct Library          LibNode;
    /*
    ** These library bases may be extracted from this structure
    ** for your own usage as long as the GTXBase pointer remains
    ** valid.
    **/
    struct Library         *DOSBase;
    struct IntuitionBase   *IntuitionBase;
    struct GfxBase         *GfxBase;
    struct Library         *GadToolsBase;
    struct Library         *UtilityBase;
    struct Library         *IFFParseBase;
    APTR                    ConsoleDevice;
    struct Library         *NoFragBase;
    /*
    ** The next library pointer is not guaranteed to
    ** be valid! Please check this pointer *before* using
    ** it.
    **/
    struct Library         *PPBase;
};

#endif
