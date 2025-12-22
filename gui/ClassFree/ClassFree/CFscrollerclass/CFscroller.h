#ifndef CFSCROLLER_H
#define CFSCROLLER_H

#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

/* Public class name definition */

#define CFscrollerClassName "CFscrollergclass"

/* New attributes */

#define CFSC_Size     SYSIA_Size
#define CFSC_Freedom  PGA_Freedom
#define CFSC_Total    PGA_Total
#define CFSC_Visible  PGA_Visible
#define CFSC_Top      PGA_Top


/* These names seem more appropriate..*/
#define SIZE_LOWRES   SYSISIZE_LOWRES
#define SIZE_MEDRES   SYSISIZE_MEDRES
#define SIZE_HIRES    SYSISIZE_HIRES


#endif