#ifndef SUPERMODEL_H
#define SUPERMODEL_H

#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

extern Class *SuperModelClass,
             *SuperICClass;


struct SuperModelData
{
  struct List Members;
  ULONG __asm (*GlueFunc)(register __a0 struct smGlueData *GD, 
                          register __a1 struct TagItem    *TagList, 
                          register __a2 APTR UserData,
                          register __a6 APTR LibBase);
  /*
  ULONG __asm (*GlueFunc)(register __a0 Class *CL, 
                          register __a2 Object *O, 
                          register __a1 struct opSet *Set, 
                          register __a3 APTR UserData,
                          register __a6 APTR LibBase);
                          */
  ULONG A6;
  APTR UserData;
  struct TagItem *CachedStringTags;
  BOOL NullAddMember;
};

struct SuperICData
{
  struct TagItem ID;    // ignore update if this pair is found
  Object *Model;
  struct TagItem *Map;  // Map Tags

  Object *Target;
  struct TagItem *TMap;

  BOOL Notify;
};

#endif /* SUPERMODEL_H */
