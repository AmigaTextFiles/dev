

#ifdef cplusplus
extern void "C" StartScreen(Object *);
extern void "C" StopScreen(Object *);
extern void "C" PrefsCmd(Object *);
#else
extern void StartScreen(Object *);
extern void StopScreen(Object *);
extern void PrefsCmd(Object *);
#endif
