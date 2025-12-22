#ifndef AREACLASS_H
#define AREACLASS_H
/*
**      $VER: AreaClass.h 1.0 (30.4.95)
**      C Header for the BOOPSI Area gadget class.
**
**      (C) Copyright 1994-1995 Jaba Development.
**      (C) Copyright 1994-1995 Jan van den Baard.
**          All Rights Reserved.
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

/*
**      AREA_MinWidth and AREA_MinHeight are required attributes.
**      Just pass the minimum area size you need here.
**/
#define AREA_MinWidth           TAG_USER+0xCDEF         /* I---- */
#define AREA_MinHeight          TAG_USER+0xCDF0         /* I---- */
/*
**      When the ID of the area object is returned by the
**      event handler you should GetAttr() this attribute.
**      It will pass you a pointer (read only!) to the
**      current size of the area. ( struct IBox * )
**/
#define AREA_AreaBox            TAG_USER+0xCDF1         /* --G-- */

/* Prototypes for the class. */
Class *InitAreaClass( void );
BOOL FreeAreaClass( Class * );

#endif
