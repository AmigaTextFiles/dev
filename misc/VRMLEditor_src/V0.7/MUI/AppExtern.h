extern void OkFunc(Object *);
extern void CancelFunc(Object *);
extern void DefaultFunc(Object *);
extern void ChangeContents(Object *);
extern void MatChangeContents(Object *);
extern void ModifyCmd(Object *);
extern void IFSChangeContents(Object *);
extern void CoordinateChangeContents(Object *);
extern void GroupCmd(Object *);
extern void ActionsCmd(Object *);
extern void SelectNode(Object *);
extern void InOutCmd(Object *);
extern void AsciiTextChangeContents(Object *);
extern void ILSChangeContents(Object *);
extern void GroupsChangeContents(Object *);
extern void NormalChangeContents(Object *);
extern void OrthoChangeContents(Object *);
extern void PerspectiveChangeContents(Object *);
extern void Texture2ChangeContents(Object *);
extern void TextureCoordinate2ChangeContents(Object *);
extern void SpecialCmd(Object *);
extern void CyberGLCmd(Object *);
extern void MenuCmd(Object *);
extern void PrefsCmd(Object *);
extern void MWCmd(Object *);
extern void ChangeCamera(Object *);

#ifdef __GNUC__
extern ULONG StartScreen();
extern ULONG StopScreen();
extern ULONG LTConstruct();
extern ULONG LTDestruct();
#else
extern ULONG StartScreen (register __a0 Object *me,
			  register __a2 Object *obj,
			  register __a1 struct TagItem *tags);

extern ULONG StopScreen (register __a0 Object *me,
			 register __a2 Object *obj,
			 register __a1 struct ScreenModeRequester *req );

extern ULONG LTConstruct (register __a0 struct Hook *hook,
			  register __a2 APTR mempool,
			  register __a1 Msg *msg );

extern ULONG LTDestruct (register __a0 struct Hook *hook,
			 register __a2 APTR mempool,
			 register __a1 Msg *msg );
#endif
