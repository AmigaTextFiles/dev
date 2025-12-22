
#define CODE_8SVX 0x38535658L
#define CODE_FORM 0x464F524DL
#define CODE_BODY 0x424F4459L

extern struct GVBase    *GVBase;
extern struct Module    *FileMod;
extern struct SysObject *SndObject;
extern struct ModPublic *Public;

extern WORD OpenCount;
extern WORD SndAlloc;
extern WORD SoundCount;
extern void LIBFreeAudio(void);
extern LONG LIBAllocAudio(void);
extern APTR SysBase;
extern APTR FILBase;

/************************************************************************************
** Proto-types.
*/

void FreeModule(void);
APTR FindHeader(LONG *, LONG);

LIBFUNC APTR LIBAllocSoundMem(mreg(__d0) LONG Size, mreg(__d1) LONG Flags);
LIBFUNC void LIBCheckSound(void);
LIBFUNC LONG LIBFreeSoundMem(mreg(__d0) APTR MemBlock);
LIBFUNC void LIBSetVolume(void);
LIBFUNC void LIBStopAudio(void);

#ifdef _DCC
LIBFUNC void           SND_Activate(void);
LIBFUNC void           SND_Deactivate(void);
#else
LIBFUNC LONG           SND_Activate(mreg(__a0) struct Sound *);
LIBFUNC LONG           SND_Deactivate(mreg(__a0) struct Sound *);
#endif

LIBFUNC LONG           SND_CheckFile(mreg(__a0) LONG, mreg(__a1) LONG);
LIBFUNC void           SND_CopyToUnv(mreg(__a0) LONG, mreg(__a1) LONG);
LIBFUNC void           SND_CopyFromUnv(mreg(__a0) LONG, mreg(__a1) LONG);
LIBFUNC struct Sound * SND_Get(mreg(__a0) struct Stats *);
LIBFUNC LONG           SND_Init(mreg(__a0) struct Sound *);
LIBFUNC void           SND_Free(mreg(__a0) struct Sound *);
LIBFUNC struct Sound * SND_Load(mreg(__a0) APTR Source);

