#ifndef CLASSES_SUPERMODEL_H
#define CLASSES_SUPERMODEL_H

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#define SMA_DUMMY(x) ( (TAG_USER | 0x40000000) + (x) )

#define SMA_AddMember SMA_DUMMY(1) // If NULL during OM_NEW the whole Model will fail.
#define SMA_RemMember SMA_DUMMY(2)

#define SMA_GlueFunc  SMA_DUMMY(3) // 
/*
  ULONG __asm (*GlueFunc)(register __a0 struct  smaGlueData *GD,
                          register __a1 struct  TagItem *TagList, 
                          register __a2 APTR    UserData,
                          register __a6 APTR    A6);
*/
#define SMA_GlueFuncA6        SMA_DUMMY(4) // if GlueFunc is a library function, sets A6 to libbase
#define SMA_GlueFuncUserData  SMA_DUMMY(5) // (APTR) Sent to GlueFunc in register a3

#define SMA_CacheStringTag SMA_DUMMY (100) // ? (ULONG) TagID of a tag whose value is a string.
//When Model object encounters this tag during Notify, the string is cached and the ti_Data will be changed to the cached string.

struct smGlueData
{                            // Don't TOUCH 
  Class   *ModelCL;          // Don't TOUCH
  Object  *ModelObject;      // Don't TOUCH
  struct  opUpdate *Update;  // Don't TOUCH
};

#define SMM_PRIVATE0  0x1000 // private

#define SICA_Model          SMA_DUMMY(1001)
#define SICA_ToTargetMap    SMA_DUMMY(1002)
#define SICA_FromTargetMap  SMA_DUMMY(1003)
#define SICA_TargetMap      SMA_DUMMY(1004)

/* Obsolete definitions */
#define SICA_InMap    SMA_DUMMY(1002) // TagList, given to object, must be allocated with CloneTagItems()
#define SICA_OutMap   SMA_DUMMY(1003) // TagList, given to object, must be allocated with CloneTagItems()

#endif /* CLASSES_SUPERMODEL_H */
