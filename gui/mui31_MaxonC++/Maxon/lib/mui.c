#include <clib/muimaster_protos.h>
#include <pragma/muimaster_lib.h>

extern struct Library *MUIMasterBase;

APTR MUI_AllocAslRequestTags(ULONG type, Tag tag1, ...)
{
    return(MUI_AllocAslRequest(type, (struct TagItem *) &tag1));
}

BOOL MUI_AslRequestTags(APTR req, Tag tag1, ...)
{
    return(MUI_AslRequest(req, (struct TagItem *) &tag1));
}

Object *MUI_MakeObject(LONG type, ...)
{
    return(MUI_MakeObjectA(type, (ULONG *)(((ULONG)&type)+4)));
}

Object *MUI_NewObject(char *class, Tag tag1, ...)
{
    return(MUI_NewObjectA(class, (struct TagItem *) &tag1));
}

LONG MUI_Request(APTR app, APTR win, LONGBITS flags, char *title, char *gadgets, char *format, ...)
{
    return(MUI_RequestA(app, win, flags, title, gadgets, format, (APTR) (((ULONG)&format)+4) ));
}
