#ifndef COMPONENTS_COMPONENTS_H
#define COMPONENTS_COMPONENTS_H TRUE

/*
**  $VER: components.h V1.0
**
**  Component Definitions.
**
**  (C) Copyright 1998 DreamWorld Productions.
**      All Rights Reserved.
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

/***************************************************************************
** Menu bar.
*/

#define TAGS_COMPONENT ((ID_SPCTAGS<<16)|ID_COMPONENT)
#define VER_COMPONENT  1

struct Component {
  struct Head Head;           /* [00] Standard header structure */
  struct FileName *Source;    /* [12] Source */
  BYTE   *Args;               /* [16] Arguments */
  struct DPKTask *Task;       /* [20] Task */
};

#define CPA_Source (12|TAPTR)
#define CPA_Args   (16|TAPTR)

#endif /* COMPONENTS_COMPONENTS_H */

