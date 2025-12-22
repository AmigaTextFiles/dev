

#ifdef cplusplus
extern void "C" OkFunc(Object *);
extern void "C" ChangeContents(Object *);
extern void "C" LODChangeContents(Object *);
extern void "C" GroupsChangeContents(Object *);
#else
extern void OkFunc(Object *);
extern void ChangeContents(Object *);
extern void LODChangeContents(Object *);
extern void GroupsChangeContents(Object *);
#endif
