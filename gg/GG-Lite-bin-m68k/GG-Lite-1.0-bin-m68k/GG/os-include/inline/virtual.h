#ifndef _INLINE_VIRTUAL_H
#define _INLINE_VIRTUAL_H

#ifndef CLIB_VIRTUAL_PROTOS_H
#define CLIB_VIRTUAL_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef  INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif
#ifndef  INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif
#ifndef  GADGETS_LAYOUT_H
#include <gadgets/layout.h>
#endif

#ifndef VIRTUAL_BASE_NAME
#define VIRTUAL_BASE_NAME VirtualBase
#endif

#define VIRTUAL_GetClass() \
	LP0(0x1e, Class *, VIRTUAL_GetClass, \
	, VIRTUAL_BASE_NAME)

#define RefreshVirtualGadget(gadget, obj, window, requester) \
	LP4NR(0x24, RefreshVirtualGadget, struct Gadget *, gadget, a0, Object *, obj, a1, struct Window *, window, a2, struct Requester *, requester, a3, \
	, VIRTUAL_BASE_NAME)

#define RethinkVirtualSize(virt_obj, rootlayout, font, screen, layoutlimits) \
	LP5(0x2a, BOOL, RethinkVirtualSize, Object *, virt_obj, a0, Object *, rootlayout, a1, struct TextFont *, font, a2, struct Screen *, screen, a3, struct LayoutLimits *, layoutlimits, d0, \
	, VIRTUAL_BASE_NAME)

#endif /*  _INLINE_VIRTUAL_H  */
