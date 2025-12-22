/*
 * blockmon.dilp - Block Monitor plugin for DIL
 * Copyright ©2004-2007 Rupert Hausberger <naTmeg@gmx.net>
 * All rights reserved.
 *
 * Please see "License.readme" for the terms of this file
 */

#ifndef INCLUDE_H
#define INCLUDE_H 1

//------------------------------------------------------------------------------

#define __NOLIBBASE__

#define NULL ((void *)0l)

//------------------------------------------------------------------------------

#include <exec/libraries.h>
#include <exec/execbase.h>
#include <exec/rawfmt.h>
#include <exec/resident.h>
#include <devices/rawkeycodes.h>
#include <dos/dostags.h>
#include <graphics/gfxmacros.h>
#include <graphics/rpattr.h>
#include <intuition/intuition.h>
#include <libraries/dilplugin.h>
#include <libraries/gadtools.h>
#include <libraries/mui.h>
#include <mui/NListview_mcc.h>
#include <utility/tagitem.h>
#include <workbench/icon.h>

#include <proto/alib.h>
#include <proto/debug.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/graphics.h>
#include <proto/icon.h>
#include <proto/intuition.h>
#include <proto/muimaster.h>
#include <proto/timer.h>
#include <proto/utility.h>

#include <math.h>

//------------------------------------------------------------------------------

#if defined(__GNUC__)
#pragma pack(2)
#endif

#include "rev.h"

#include "config.h"
#include "struct.h"
#include "define.h"
#include "extern.h"

#include "main.h"
#include "init.h"
#include "mcc_about.h"
#include "mcc_application.h"
#include "mcc_custom.h"
#include "mcc_display.h"
#include "mcc_main.h"
#include "mcc_nlist.h"
#include "mcc_tags.h"
#include "misc.h"

#if defined(__GNUC__)
#pragma pack()
#endif

//------------------------------------------------------------------------------

#endif /* INCLUDE_H */













