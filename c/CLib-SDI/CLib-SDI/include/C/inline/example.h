#ifndef _INLINE_EXAMPLE_H
#define _INLINE_EXAMPLE_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef EXAMPLE_BASE_NAME
#define EXAMPLE_BASE_NAME ExampleBase
#endif

#define ex_TestRequest(title, body, gadgets) \
	LP3(0x1e, LONG, ex_TestRequest, STRPTR, title, a0, STRPTR, body, a1, STRPTR, gadgets, a2, \
	, EXAMPLE_BASE_NAME)

#define ex_TestRequest2A(title, body, gadgets, args) \
	LP4(0x24, LONG, ex_TestRequest2A, STRPTR, title, a0, STRPTR, body, a1, STRPTR, gadgets, a2, APTR, args, a3, \
	, EXAMPLE_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define ex_TestRequest2(title, body, gadgets, tags...) \
	({ULONG _tags[] = {tags}; ex_TestRequest2A((title), (body), (gadgets), (APTR) _tags);})
#endif

#define ex_TestRequest3(hook) \
	LP1(0x2a, ULONG, ex_TestRequest3, struct Hook *, hook, a0, \
	, EXAMPLE_BASE_NAME)

#endif /*  _INLINE_EXAMPLE_H  */
