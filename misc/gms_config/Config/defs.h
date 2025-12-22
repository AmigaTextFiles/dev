
extern struct GVBase    *GVBase;
extern struct Module    *FileMod;
extern struct Module    *StrMod;
extern struct SysObject *ConfigObject;
extern struct ModPublic *Public;

extern APTR FILBase;
extern APTR STRBase;
extern APTR CNFBase;

/************************************************************************************
** Proto-types.
*/

void FreeModule(void);

LIBFUNC BYTE * LIBReadConfig(mreg(__a0) struct Config *Config, mreg(__a1) BYTE *Section, mreg(__a2) BYTE *Item);
LIBFUNC LONG LIBReadConfigInt(mreg(__a0) struct Config *Config, mreg(__a1) BYTE *Section, mreg(__a2) BYTE *Item);

LIBFUNC LONG            CON_CheckFile(mreg(__a0) struct File *);
LIBFUNC void            CON_Free(mreg(__a0) struct Config *);
LIBFUNC struct Config * CON_Get(mreg(__a0) struct Stats *);
LIBFUNC LONG            CON_Init(mreg(__a0) struct Config *);
LIBFUNC struct Config * CON_Load(mreg(__a0) APTR Source);


