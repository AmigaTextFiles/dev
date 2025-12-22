
extern struct GVBase    *GVBase;
extern struct SysObject *OFObject;
extern struct Function  JumpTableV1[];
extern struct Module    *StrModule;
extern struct Module    *ConfigModule;
extern APTR STRBase;
extern APTR CNFBase;
extern APTR OBJBase;
extern struct ModPublic *Public;

/***********************************************************************************
** Internal proto-types.
*/

void FreeModule(void);

LIBFUNC void                OBJ_Free(mreg(__a0) struct ObjectFile *);
LIBFUNC struct ObjectFile * OBJ_Get(mreg(__a0) struct ObjectFile *);
LIBFUNC LONG                OBJ_Init(mreg(__a0) struct ObjectFile *);
LIBFUNC LONG                OBJ_CheckFile(mreg(__a0) LONG, mreg(__a1) LONG);
LIBFUNC struct ObjectFile * OBJ_Load(mreg(__a0) struct File *);

LIBFUNC APTR LIBPullObject(mreg(__a0) LONG argObjectFile, mreg(__a1) BYTE *Name);
LIBFUNC LONG LIBPullObjectList(mreg(__a0) LONG argObjectFile, mreg(__a1) struct ObjectEntry *);

