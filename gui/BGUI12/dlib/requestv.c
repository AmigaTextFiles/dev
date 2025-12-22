#include <exec/types.h>
#include <utility/tagitem.h>
#include <libraries/bgui.h>

#include <proto/bgui.h>
#include <proto/intuition.h>

ULONG BGUI_Request( struct Window *win, struct bguiRequest *es, ... )
{
    return( BGUI_RequestA( win, es, ( ULONG * )&(es + 1)));
}

