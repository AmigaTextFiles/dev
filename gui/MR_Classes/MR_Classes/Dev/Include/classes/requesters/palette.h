#ifndef CLASSES_REQUESTERS_PALETTE_H
#define CLASSES_REQUESTERS_PALETTE_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef CLASSES_REQUESTERS_REQUESTERS_H
#include <classes/requesters/requesters.h>
#endif

struct prRGB
{
  ULONG Red,
        Green,
        Blue;
};

#define PR_DUMMY        (REQ_SUBCLASS)

#define PR_Window             REQ_Window
#define PR_Screen             REQ_Screen
#define PR_PubScreenName      REQ_PubScreenName 
#define PR_PrivateIDCMP       REQ_PrivateIDCMP
#define PR_IntuiMsgFunc       REQ_IntuiMsgFunc    /* Function to handle IntuiMessages */
#define PR_SleepWindow        REQ_SleepWindow     /* Block input in REQ_Window?     */

#define PR_TextAttr           REQ_TextAttr
#define PR_Locale	            REQ_Locale                /* Locale  text   */
#define PR_TitleText          REQ_TitleText             /* Title of requester		     */
#define PR_PositiveText       REQ_PositiveText          /* Positive gadget text	     */
#define PR_NegativeText       REQ_NegativeText          /* Negative gadget text	     */


#define PR_InitialLeftEdge    REQ_InitialLeftEdge
#define PR_InitialTopEdge     REQ_InitialTopEdge
#define PR_InitialWidth       REQ_InitialWidth
#define PR_InitialHeight      REQ_InitialHeight

#define PR_Colors             (PR_DUMMY + 9)    /* Number of colors */

#define PR_InitialPalette     (PR_DUMMY + 10)
#define PR_Palette            (PR_DUMMY + 10)   /* When you OM_Get this, supply a buffer, the object will copy data to your buffer */

/* color bits per pixel 8 default, MAX 15! */
#define PR_RedBits            (PR_DUMMY + 20)
#define PR_GreenBits          (PR_DUMMY + 21) 
#define PR_BlueBits           (PR_DUMMY + 22)
#define PR_ModeIDRGBBits      (PR_DUMMY + 23)   /* Sets the above according to the ModeID */


#endif /* CLASSES_REQUESTERS_PALETTE_H */
