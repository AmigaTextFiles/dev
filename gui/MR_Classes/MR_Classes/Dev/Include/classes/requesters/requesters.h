#ifndef CLASSES_REQUESTERS_REQUESTERS_H
#define CLASSES_REQUESTERS_REQUESTERS_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#define REQ_DUMMY (TAG_USER)
#define REQ_SUBCLASS (TAG_USER | 0x7000000)

#define REQ_Window          (REQ_DUMMY + 1)     /* Parent window */
#define REQ_Screen          (REQ_DUMMY + 2)     /*  */
#define REQ_PubScreenName   (REQ_DUMMY + 3)    
#define REQ_PrivateIDCMP    (REQ_DUMMY + 4)
#define REQ_IntuiMsgFunc    (REQ_DUMMY + 5)     /* Function to handle IntuiMessages */
#define REQ_SleepWindow     (REQ_DUMMY + 6)     /* Block input in REQ_Window?     */

/* Text display */
#define REQ_TextAttr	      (REQ_DUMMY + 50)  /* Text font to use for gadget text */
#define REQ_Locale	        (REQ_DUMMY + 51)  /* Locale ASL should use for text   */
#define REQ_TitleText       (REQ_DUMMY + 52)  /* Title of requester		     */
#define REQ_PositiveText    (REQ_DUMMY + 53) /* Positive gadget text	     */
#define REQ_NegativeText    (REQ_DUMMY + 54) /* Negative gadget text	     */

/* Initial settings */
#define REQ_InitialLeftEdge (REQ_DUMMY + 100)   /* Initial requester coordinates    */
#define REQ_InitialTopEdge  (REQ_DUMMY + 101)
#define REQ_InitialWidth    (REQ_DUMMY + 102)   /* Initial requester dimensions     */
#define REQ_InitialHeight   (REQ_DUMMY + 103)


/* Subclass use only */
#define REQ_LayoutGadget    (REQ_DUMMY + 200) /* */


/* Do Requester */
#define RM_DOREQUEST          (1)
#define RM_DOREQUESTASYNC     (2) /* DON'T Set attrs during this method */

/* RM_DOREQUEST */
struct rpDoRequest
{
  ULONG MethodID;
  struct TagItem *rpdr_AttrList;
};

/* RM_DOREQUEST */
struct rpDoRequestAsync
{
  ULONG MethodID;
  struct Message *rpdra_ReplyMsg; /* .mp_ReplyPort must be set */
  struct TagItem *rpdra_AttrList;
};





#endif /* CLASSES_REQUESTERS_REQUESTERS_H */
