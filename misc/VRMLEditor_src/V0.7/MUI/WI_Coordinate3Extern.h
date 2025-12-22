

#ifdef cplusplus
extern void "C" OkFunc(Object *);
extern void "C" CancelFunc(Object *);
extern void "C" CoordinateChangeContents(Object *);
#else
extern void OkFunc(Object *);
extern void CancelFunc(Object *);
extern void CoordinateChangeContents(Object *);
#endif
