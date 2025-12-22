#ifndef GADTOOLSBOX_HOTKEY_H
#define GADTOOLSBOX_HOTKEY_H
/*
**      $VER: gadtoolsbox/hotkey.h 39.1 (12.4.93)
**      GTXLib headers release 2.0.
**
**      Definitions for the hotkey system.
**
**      (C) Copyright 1992,1993 Jaba Development.
**          Written by Jan van den Baard
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef LIBRARIES_GADTOOLS_H
#include <libraries/gadtools.h>
#endif

/* A _very_ important handle */
typedef ULONG               HOTKEYHANDLE;

/* Flags for the HKH_SetRepeat tag */
#define SRB_MX              0
#define SRF_MX              (1<<SRB_MX)
#define SRB_CYCLE           1
#define SRF_CYCLE           (1<<SRB_CYCLE)
#define SRB_SLIDER          2
#define SRF_SLIDER          (1<<SRB_SLIDER)
#define SRB_SCROLLER        3
#define SRF_SCROLLER        (1<<SRB_SCROLLER)
#define SRB_LISTVIEW        4
#define SRF_LISTVIEW        (1<<SRB_LISTVIEW)
#define SRB_PALETTE         5
#define SRF_PALETTE         (1<<SRB_PALETTE)

/* tags for the hotkey system */
#define HKH_TagBase         (TAG_USER+256)

#define HKH_KeyMap          (HKH_TagBase+1)
#define HKH_UseNewButton    (HKH_TagBase+2)
#define HKH_NewText         (HKH_TagBase+3)
#define HKH_SetRepeat       (HKH_TagBase+4)

#endif
