#ifdef __STDC__
# define	P(s) s
#else
# define P(s) ()
#endif


/* GUI.c */
void About P((void ));
void OpenRefWindow P((void ));
void OpenScanStatWindow P((void ));
void CloseScanStatWindow P((void ));
void GiveHelp P((LONG id , struct Screen *scr ));
void LockGUI P((void ));
void UnlockGUI P((void ));
void AttachMainList P((struct List *newlist ));
void DetachMainList P((void ));
void AttachRefList P((void ));
void DetachRefList P((void ));
void DeleteSelectedReference P((void ));
void UpdateMain P((void ));
void UpdateRef P((void ));
void UpdateOptions P((void ));
void UpdateOptionsGhost P((void ));
void UpdateSettingsStruct P((void ));
void HandleGUI P((void ));
void HandleListViewClick P((struct TR_Message *m ));
void HandleMenu P((struct TR_Message *m ));
void HandleMainIDCMP P((struct TR_Message *m ));
void HandleRefIDCMP P((struct TR_Message *m ));
void HandleOptionsIDCMP P((struct TR_Message *m ));
void HandleScanStatIDCMP P((struct TR_Message *m ));
ULONG NumOfNodes P((struct List *l ));
struct FileEntry *SelectedMain P((void ));
struct RefsEntry *SelectedRef P((void ));
void GoGUI P((void ));
void CloseGUI P((void ));

/* Lists.c */
void StartTimer P((void ));
void StopTimer P((void ));
void *GetHead P((void *lst ));
void *GetTail P((void *lst ));
void *GetSucc P((void *nod ));
void *GetPred P((void *nod ));
void LoadData P((STRPTR name ));
LONG SaveData P((STRPTR name ));
void IndexFileList P((STRPTR path , struct rtFileList *lst ));
void IndexRecursive P((STRPTR path , STRPTR dir ));
void IndexFile P((STRPTR dir , STRPTR filename ));
void StartScanning P((void ));
void StopScanning P((BOOL force ));
LONG FileType P((STRPTR buf , LONG bufsize ));
LONG FileLength P((BPTR lock ));
STRPTR FindKeyword P((STRPTR buf , STRPTR keyword , LONG size ));
STRPTR FullName P((STRPTR path ));
UBYTE *JoinPath P((STRPTR dir , STRPTR name ));
STRPTR FindStructUnion P((STRPTR ptr , STRPTR end , LONG *l ));
STRPTR PickName P((STRPTR buf , STRPTR ptr ));
BOOL __regargs SortCompareFunc P((struct FileEntry *a , struct FileEntry *b , ULONG data ));
struct FileEntry *AddFileToList P((STRPTR name ));
struct RefsEntry *AddRefToList P((struct FileEntry *fileentry , LONG offset , LONG length , WORD gotoline , STRPTR name ));
struct FileEntry *IsFileInList P((BPTR newlock , STRPTR filepart ));
void FreeFile P((struct FileEntry *f ));
void FreeRef P((struct RefsEntry *r ));
void InitializeFileList P((void ));
void FreeFileList P((void ));

/* Main.c */
// void __stdargs __main P((char *argv ));
void CloseAll P((LONG error , ...));
void LoadSettings P((STRPTR file ));
void SaveSettings P((STRPTR file ));
void PostMessage P((STRPTR fmt , ...));

#undef P
