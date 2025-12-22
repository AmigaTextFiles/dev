

#ifdef cplusplus
extern void "C" MUIV_List_ConstructHook_String(Object *);
extern void "C" MUIV_List_DestructHook_String(Object *);
extern void "C" OkFunc(Object *);
extern void "C" CancelFunc(Object *);
extern void "C" ChangeContents(Object *);
#else
extern void MUIV_List_ConstructHook_String(Object *);
extern void MUIV_List_DestructHook_String(Object *);
extern void OkFunc(Object *);
extern void CancelFunc(Object *);
extern void ChangeContents(Object *);
#endif
