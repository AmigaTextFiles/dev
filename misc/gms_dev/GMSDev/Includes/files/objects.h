#ifndef FILES_OBJECTS_H
#define FILES_OBJECTS_H TRUE

/*
**  $VER: objects.h
**
**  Object definitions.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/****************************************************************************
** Object entries.
*/

typedef struct ObjectEntry { /* Entry stucture for PullObjectList() */
  BYTE  *Name;               /* Pointer to the name, may be NULL */
  APTR  Object;              /* Object is returned here */
} OBJObjectEntry;

/*****************************************************************************
** Object-File.
*/

#define VER_OBJECTFILE  2
#define TAGS_OBJECTFILE ((ID_SPCTAGS<<16)|ID_OBJECTFILE)

typedef struct ObjectFile {
  struct Head   Head;        /* [00] [--] Standard header*/
  struct Source *Source;     /* [12] [-I] Pointer to source */
  struct Config *Config;     /* [16] [R-] Associated Config object */
} OBJObjectFile;

#define OBJA_Source (12|TAPTR)
#define OBJA_Config (16|TAPTR)

#endif /* FILES_OBJECTS_H */

