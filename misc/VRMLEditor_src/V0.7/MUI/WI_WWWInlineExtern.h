

#ifdef cplusplus
extern void "C" OkFunc(Object *);
extern void "C" CancelFunc(Object *);
extern void "C" DefaultFunc(Object *);
extern void "C" ChangeContents(Object *);
extern void "C" SpecialCmd(Object *);
#else
extern void OkFunc(Object *);
extern void CancelFunc(Object *);
extern void DefaultFunc(Object *);
extern void ChangeContents(Object *);
extern void SpecialCmd(Object *);
#endif
