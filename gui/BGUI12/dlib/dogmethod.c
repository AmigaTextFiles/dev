#include <exec/types.h>
#include <utility/tagitem.h>
#include <libraries/bgui.h>

#include <proto/bgui.h>
#include <proto/intuition.h>

ULONG BGUI_DoGadgetMethod( Object *obj, struct Window *win, struct Requester *req, ULONG method, ... )
{
        return( BGUI_DoGadgetMethodA( obj, win, req, ( Msg )&method ));
}
