/*! @addtogroup ablit
 *  @{
 */

/* @file ablit_utils.h
 *
 * Some usefull functions to make it easier to use screens and windows.
 * The functions are minimaliyed to allow rapid results.
 *
 * @author: Jürgen Schober
 *
 * @date: 10/31/2005
 *
 * @history:
 *  - 10/31/2005 Version 0.1
 *      - Halloween release
 *
 */
#ifndef __ABLIT_UTILS_H__
#define __ABLIT_UTILS_H__

#include <exec/types.h>

#include <intuition/intuition.h>

#ifdef __cplusplus
extern "C" {
#endif

struct ABU_VideoInfo
{
    struct Screen *screen;
    struct Window *window;

    BOOL   is_fullscreen;
};

enum enABU_IniFlags
{
    ABUB_FULLSCREEN = 0,
    ABUB_AMIGAINPUT = 1,
};

#define ABUF_NONE        0
#define ABUF_FULLSCREEN (1 << ABUB_FULLSCREEN)
#define ABUF_AMIGAINPUT (1 << ABUB_AMIGAINPUT)

struct ABU_VideoInfo* ABU_InitVideo( uint32 width, uint32 height, uint32 depth, uint32 flags );
void   ABU_CloseVideo( struct ABU_VideoInfo* vi );


#ifdef __cplusplus
}
#endif

#endif // __ABLIT_UTILS_H__

