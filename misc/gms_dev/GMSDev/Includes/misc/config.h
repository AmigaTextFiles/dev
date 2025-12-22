#ifndef MISC_CONFIG_H
#define MISC_CONFIG_H TRUE

/*
**  $VER: config.h
**
**  Configuration Object.
**
**  (C) Copyright 1998 DreamWorld Productions.
**      All Rights Reserved
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

#ifndef _INCLUDE_PRAGMA_CONFIG_LIB_H
#include <pragmas/config_pragmas.h>
#endif

/****************************************************************************
** Config Object.
*/

#define VER_CONFIG  1
#define TAGS_CONFIG ((ID_SPCTAGS<<16)|ID_CONFIG)

typedef struct Config {
  struct Head Head;         /* [00] Standard header */
  APTR   Source;            /* [12] Source of config data */
  struct ConEntry *Entries; /* [16] Array of configuration entries */
  LONG   AmtEntries;        /* [20] Amount of configuration entries */

  struct ConEntry *prvEntries;
  BYTE   *prvBuffer;
} OBJConfig;

struct ConEntry {
  BYTE *Section;
  BYTE *Item;
  BYTE *Data;
};

#define CFA_Source     (TAPTR|12)
#define CFA_Entries    (TAPTR|16)
#define CFA_AmtEntries (TAPTR|20)

#endif /* MISC_CONFIG_H */
