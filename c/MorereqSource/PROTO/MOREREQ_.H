/*
 *	File:					MR_protos.h
 *	Description:	
 *
 *	(C) 1994, Ketil Hunn
 *
 */

#ifndef CLIB_MOREREQ_PROTOS_H
#define	CLIB_MOREREQ_PROTOS_H

#ifndef MR_LIB
#ifndef PRAGMAS_MOREREQ_PRAGMAS_H
#include <pragmas/MoreReq_pragmas.h>
#endif
#endif

#ifndef EASYGADGETS_H
#include <libraries/morereq.h>
#endif

__asm __saveds APTR mrAllocRequestA(register __d0 unsigned long reqType,
																		register __a0 struct TagItem *taglist);
__asm __saveds void mrFreeRequest(register __a0 APTR req);
__asm __saveds UWORD mrRequestA(register __a1 APTR req,
																register __a0 struct TagItem *taglist);
__asm __saveds void mrCloseWindowSafely(register __a0 struct Window *win);
__asm __saveds APTR mrLockWindow(register __a0 struct Window *window);
__asm __saveds void mrUnlockWindow(	register __a0 struct Window *window,
																		register __a1 APTR lock);
__asm __saveds void mrUnlockWindow(	register __a0 struct Window *window,
																		register __a1 APTR lock);
__asm __saveds void mrFreeGadget(register __a0 APTR *mrgadget);
__asm __saveds struct Gadget *mrCreateGadgetA(register __d0 ULONG								kind,
																							register __a1 struct Gadget				*previous,
																							register __a2 struct NewGadget		*ng, 
																							register __a3 APTR								mrgadget,
																							register __a4 struct DrawInfo			*dri,
																							register __a0 struct TagItem			*taglist);
__asm __saveds UWORD mrMatchVanillaKeyA(register __d0 int inkey,
																				register __a0 char **array);


/* tagcalls */
APTR mrAllocRequest(unsigned long reqType, Tag tag1, ...);
UWORD mrRequest(APTR req, Tag tag1, ...);
struct Gadget *mrCreateGadget(	ULONG								kind,
																struct Gadget				*previous,
																struct NewGadget		*ng, 
																APTR								mrgadget,
																struct DrawInfo			*dri,
																Tag									tag1, ...);
UWORD mrMatchVanillaKey(int key, char *text1, ...);
void mrFreeGadget(APTR *mrgadget);

#endif
