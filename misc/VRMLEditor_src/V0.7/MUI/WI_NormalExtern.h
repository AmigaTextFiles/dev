

#ifdef cplusplus
extern void "C" OkFunc(Object *);
extern void "C" CancelFunc(Object *);
extern void "C" ChangeContents(Object *);
extern void "C" NormalChangeContents(Object *);
#else
extern void OkFunc(Object *);
extern void CancelFunc(Object *);
extern void ChangeContents(Object *);
extern void NormalChangeContents(Object *);
#endif
