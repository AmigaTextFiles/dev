
/*  MRGadgets.h - Miscellaneous gadget support routines. */
 
/* The SelectRastPort macro selects a rastport from either a window or
 * a requester. If the requester, <r> is non-null, it is used. Otherwise
 * the window's (<w>) RastPort is used.
 */

/*  Macros: */

/* Get the pointer to a gadget image, given a pointer to a gadget. */
#define GadgetImage(g) (struct Image *) (g)->GadgetRender

/* Get the pointer to a gadget's image data. */
#define GadgetImageData(g) (GadgetImage(g))->ImageData

/* Get the pointer to a gadget string, given a pointer to a gadget. */
#define GadgetString(g) ((struct StringInfo *) ((g)->SpecialInfo))->Buffer

/* Get the longint value for a string gadget. */
#define GadgetValue(g) ((struct StringInfo *) ((g)->SpecialInfo))->LongInt

/* Select a RastPort from either a window or a requester. */
#define SelectRastPort(w, r) (struct RastPort *) (r ? r->ReqLayer->rp : w->RPort)

/*  Functions: */

void            EraseGadgetBox(/*gadget, window, requester*/);
struct Gadget   *GetGadget(/* id, window */);
void            ResetStringInfo(/* char * */);
void            SelectGadget(/*gadget,window,requester,state*/);
void            SetOptionGadget(/*gadget,window,requester,option*/);
void            SetStringGadget(/*gadget,window,requester,string*/);

