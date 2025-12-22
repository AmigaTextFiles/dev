#ifndef EXTRAS_BOOPSI_SUPERMODEL_H
#define EXTRAS_BOOPSI_SUPERMODEL_H

#define SMA_DUMMY(x) ( (TAG_USER | 0x40000000) + (x) )

#define SMA_AddMember SMA_DUMMY(1) // If NULL during OM_NEW the whole Model will fail.
#define SMA_RemMember SMA_DUMMY(2)
#define SMA_GlueFunc  SMA_DUMMY(3) // ULONG (*GlueSet)

#define SICA_Model    SMA_DUMMY(1001)
#define SICA_InMap    SMA_DUMMY(1002) // TagList, given to object, must be allocated with CloneTagItems()
#define SICA_OutMap   SMA_DUMMY(1003) // TagList, given to object, must be allocated with CloneTagItems()

#endif /* EXTRAS_BOOPSI_SUPERMODEL_H */
