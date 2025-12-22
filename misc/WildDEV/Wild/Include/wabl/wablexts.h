extern struct WABL *NewWABL(ULONG *file,ULONG *gethook,ULONG *puthook);
extern struct WABLObject *FindWABLChild(char *type,char *name,struct WABLObject *par,struct WABLObject *cob);
extern struct WABLObject *FindWABLTree(char *type,char *name,struct WABLObject *par);
extern struct WABLObject *HaveWABLObject(struct WABL *wabl,char *type,char *name,struct WABLObject *par);
extern struct WABLAttr *GetWABLAttr(char *com,struct WABLObject *obj);
extern struct WABLAttr *SetWABLAttr(struct WABL *wabl,char *com,char *arg,struct WABLObject *obj);
extern struct WABLAttr *HaveWABLAttr(struct WABL *wabl,char *com,char *def,struct WABLObject *obj);
extern struct WABLFriend *GetWABLFriend(char *com,struct WABLObject *obj);
extern struct WABLObject *AllocWABLFriend(struct WABL *wabl,struct WABLObject *obj,char *com);
extern void SetWABLFriend(struct WABL *wabl,char *com,char *typ,char *arg,struct WABLObject *obj);
extern void SetWABLFriendObj(struct WABL *wabl,char *com,struct WABLObject *obj,struct WABLObject *friend);
extern void UpdateFriends(struct WABL *wabl,struct WABLObject *obj);




