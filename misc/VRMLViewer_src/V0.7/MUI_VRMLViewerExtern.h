extern void PrefsWindowCmd(Object *);
extern void ChangeGLMode(Object *);
extern void ChangeCamera();
extern void MenuCmd(Object *);
extern void PositionCmd(Object *);
extern void MainWindowCmd(Object *);
#ifdef __GNUC__
extern ULONG StartScreen();
extern ULONG StopScreen();
#else
extern ULONG StartScreen (register __a0 Object *me,
			  register __a2 Object *obj,
			  register __a1 struct TagItem *tags);
extern ULONG StopScreen (register __a0 Object *me,
			 register __a2 Object *obj,
			 register __a1 struct ScreenModeRequester *req );
#endif
