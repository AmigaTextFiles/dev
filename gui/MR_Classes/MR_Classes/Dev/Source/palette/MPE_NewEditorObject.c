#include <proto/intuition.h>
#include <clib/classes/requesters/palette_protos.h>
#include <pragmas/classes/requesters/palette_pragmas.h>

extern Class *EditorClassPtr;

Object *__saveds __asm LIB_PREQ_NewRequesterA( register __a0 struct TagItem *TagList)
{
  Object *o;
  
  o=NewObjectA(EditorClassPtr,0,TagList);
  
  return(o);
}

void __saveds __asm LIB_PREQ_DisposeRequester( register __a0 Object *Obj)
{
  DisposeObject(Obj);
}
