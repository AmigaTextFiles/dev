#ifndef EXTRAS_PROGRESSMETER_H
#define EXTRAS_PROGRESSMETER_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef GRAPHICS_TEXT_H
#include <graphics/text.h>
#endif

typedef void    *ProgressMeter;

/** AllocProgressMeter() Tags **/

#define PM_Dummy (TAG_USER)

/* All tags not marked otherwise, may be used for
   the initialization only 

   I-Initialize - AllocProgressMeter()
   S-Set          UpdateProgressMeter()
*/

/* these two are mutually exclusive, you must specify one */
#define PM_Screen       (PM_Dummy+1)   /* (struct Screen *)Screen to place 
                                          progress meter on */
#define PM_ParentWindow (PM_Dummy+2)   /* (struct Window *)Parent window 
                                          of meter */
/* not implemented */
#define PM_MsgPort      (PM_Dummy+4)   /* Already existing msgport */


#define PM_TextAttr     (PM_Dummy+5)   /* defaults to the screen font */

#define PM_LeftEdge     (PM_Dummy+10)  /* Defaults to be centered on PM_Window */
#define PM_TopEdge      (PM_Dummy+11)  /* or PMScreen */
#define PM_MinWidth     (PM_Dummy+12)  /* Minimum sizes*/
#define PM_MinHeight    (PM_Dummy+13)  /* (not implemented) */

#define PM_WinTitle     (PM_Dummy+14)  /* Meter's Window title (STRPTR) */

#define PM_LowText      (PM_Dummy+15)  /* default "0%" */ 
#define PM_HighText     (PM_Dummy+16)  /* default "100%" */

#define PM_MeterFormat    (PM_Dummy+17) /* printf style format string used inside the
                                           meter.  default "%ld%%" */
#define PM_MeterType      (PM_Dummy+18) /* How PM_MeterFormat is used, 
                                           see PM_TYPES_? */
#define PM_MeterLabel     (PM_Dummy+19) /* The label above the meter.  default NULL */
#define PM_MinMeterWidth  (PM_Dummy+20) /* The minimum meter bar width, the default
                                           minimum is 80 */      
                                    
/* rendering pens */
#define PM_MeterPen       (PM_Dummy+21) /* default fillpen */
#define PM_MeterBgPen     (PM_Dummy+22) /* default backgroundpen */
#define PM_FormatPen      (PM_Dummy+23) /* default highlight text */
#define PM_MeterLabelPen  (PM_Dummy+24) /* default highlight text */
#define PM_LowTextPen     (PM_Dummy+25) /* default text pen */
#define PM_HighTextPen    (PM_Dummy+26) /* default text pen */

#define PM_MeterValue     (PM_Dummy+27) /* (IS) (LONG) default 0 */
#define PM_LowValue       (PM_Dummy+28) /* (IS) default 0   */
#define PM_HighValue      (PM_Dummy+29) /* (IS) default 100 */

#define PM_Ticks          (PM_Dummy+40) /* ticks to draw under the meter box
                                     defaults to 0 for none */

#define PM_CancelButton   (PM_Dummy+41) /* (BOOL)    Create a Cancel button? */
#define PM_CancelText     (PM_Dummy+42) /* (STRPTR)  Text for cancel button (default "Cancel") */ 
#define PM_QueryCancel    (PM_Dummy+43) /* (S) (ULONG *) The number of time the user
                                                   has pressed the cancel button */  
/* the following three are not implemented */
#define PM_CancelID       (PM_Dummy+44) /* Creates an IDCMP_GADGETUP event when the
                                  Cancel button is clicked. 
                                  IntuiMessage->IAddress will be a pointer
                                  to a gadget whose GadgetID is taken from
                                  this tag */
#define PM_CancelSigNum   (PM_Dummy+45) /* Sets a signal when the Cancel button is
                                  clicked */
#define PM_CancelSigTask  (PM_Dummy+46)   



/* PM_MeterType */
#define PM_TYPE_PERCENTAGE   0  /* The meter's value is converted to a 
                                   percentage before rendering */
#define PM_TYPE_NUMBER       1  /* The meter's value is used */
#define PM_TYPE_STRING       2  /* Doens't process the meter's value
                                   simply prints PM_MeterFormat */

#endif  /* EXTRAS_PROGRESSMETER_H */ 
