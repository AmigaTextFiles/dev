#ifndef _INLINE_SCREENNOTIFY_H
#define _INLINE_SCREENNOTIFY_H

/*
 * dospath.h  V1.0
 *
 * GCC inline library calls for screennotify.library functions
 *
 * (c) 1995 Stefan Becker
 */

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef SCREENNOTIFY_BASE_NAME
#define SCREENNOTIFY_BASE_NAME ScreenNotifyBase
#endif

#define AddCloseScreenClient(screen, port, pri) \
        LP3(0x1e, APTR, AddCloseScreenClient, struct Screen *, screen, a0, struct MsgPort *, port, a1, BYTE, pri, d0, \
        , SCREENNOTIFY_BASE_NAME)

#define AddPubScreenClient(port, pri) \
        LP2(0x2a, APTR, AddPubScreenClient, struct MsgPort *, port, a0, BYTE, pri, d0, \
        , SCREENNOTIFY_BASE_NAME)

#define AddWorkbenchClient(port, pri) \
        LP2(0x36, APTR, AddWorkbenchClient, struct MsgPort *, port, a0, BYTE, pri, d0, \
        , SCREENNOTIFY_BASE_NAME)

#define RemCloseScreenClient(handle) \
        LP1(0x24, BOOL, RemCloseScreenClient, APTR, handle, a0, \
        , SCREENNOTIFY_BASE_NAME)

#define RemPubScreenClient(handle) \
        LP1(0x30, BOOL, RemPubScreenClient, APTR, handle, a0, \
        , SCREENNOTIFY_BASE_NAME)

#define RemWorkbenchClient(handle) \
        LP1(0x3c, BOOL, RemWorkbenchClient, APTR, handle, a0, \
        , SCREENNOTIFY_BASE_NAME)

#endif /* _INLINE_SCREENNOTIFY_H */
