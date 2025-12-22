#include <exec/types.h>
#include <utility/tagitem.h>
#include <libraries/bgui.h>

#include <proto/bgui.h>
#include <proto/intuition.h>

long BGUI_NewObject( ULONG num, Tag tag1, ... )
{
        return( BGUI_NewObjectA( num, ( struct TagItem * )&tag1 ));
}
