#ifndef __DEBUG_H
#define __DEBUG_H

#ifndef DEBUG
#define dprintf(format, args...) ((void)0)
#define kprintf(format, args...) ((void)0)
#else /* DEBUG */
#define dprintf(format, args...)((struct ExecIFace *)((*(struct ExecBase **)4)->MainInterface))->DebugPrintF("[%s] " format, __PRETTY_FUNCTION__ , ## args)
#define kprintf(format, args...)((struct ExecIFace *)((*(struct ExecBase **)4)->MainInterface))->DebugPrintF(format, ## args)
#endif /* DEBUG */

#endif
