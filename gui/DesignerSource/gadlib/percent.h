#ifndef GADGETS_PERCENT_H
#define GADGETS_PERCENT_H
/*
**	$VER: percent.h 1.0 (26.12.94)
**
**	Definitions for the percent BOOPSI class
**
*/

/*****************************************************************************/

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

/*****************************************************************************/

#define PER_Dummy	     (TAG_USER+0x08000000)
#define PER_Min	         (PER_Dummy+1)   /* Set Min Value, default 0 */
#define PER_Max          (PER_Dummy+2)   /* Set Max value passed, default 100*/
                                         /* It will always display a percentage but of a spread between these values */
#define PER_Val          (PER_Dummy+3)   /* Value to display, between above values, defaults to Min */
#define PER_PulseUp      (PER_Dummy+4)   /* Increments current value */
#define PER_PulseDown    (PER_Dummy+5)   /* Decrement current value */
#define PER_Vertical     (PER_Dummy+6)   /* Orientation of object, defaults false */

/*****************************************************************************/


#endif /* GADGETS_PERCENT_H */

