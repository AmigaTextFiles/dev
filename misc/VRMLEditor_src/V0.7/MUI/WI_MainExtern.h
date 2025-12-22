

#ifdef cplusplus
extern void "C" MUIV_List_ConstructHook_String(Object *);
extern void "C" MUIV_List_DestructHook_String(Object *);
extern void "C" ModifyCmd(Object *);
extern void "C" ActionsCmd(Object *);
extern void "C" SelectNode(Object *);
extern void "C" InOutCmd(Object *);
extern void "C" SpecialCmd(Object *);
extern void "C" MenuCmd(Object *);
#else
extern void MUIV_List_ConstructHook_String(Object *);
extern void MUIV_List_DestructHook_String(Object *);
extern void ModifyCmd(Object *);
extern void ActionsCmd(Object *);
extern void SelectNode(Object *);
extern void InOutCmd(Object *);
extern void SpecialCmd(Object *);
extern void MenuCmd(Object *);
#endif
