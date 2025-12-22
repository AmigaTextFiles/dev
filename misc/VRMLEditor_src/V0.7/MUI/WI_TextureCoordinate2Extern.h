

#ifdef cplusplus
extern void "C" OkFunc(Object *);
extern void "C" CancelFunc(Object *);
extern void "C" TextureCoordinate2ChangeContents(Object *);
#else
extern void OkFunc(Object *);
extern void CancelFunc(Object *);
extern void TextureCoordinate2ChangeContents(Object *);
#endif
