#ifndef CLIB_CLASSES_REQUESTERS_PALETTE_PROTOS_H
#define CLIB_CLASSES_REQUESTERS_PALETTE_PROTOS_H


#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

Object *PREQ_NewRequesterA( struct TagItem *TagList);
Object *PREQ_NewRequester( Tag Tags, ... );
void PREQ_DisposeRequester( Object *Obj);



#endif /* CLIB_CLASSES_REQUESTERS_PALETTE_PROTOS_H */
