
extern struct GVBase    *GVBase;
extern struct ModPublic *Public;
extern struct STRBase   *STRBase;

LIBFUNC BYTE * LIBIntToStr(mreg(__d0) LONG Integer, mreg(__a0) BYTE *String);
LIBFUNC void   LIBStrCapitalize(mreg(__a0) BYTE *);
LIBFUNC BYTE * LIBStrClone(mreg(__a0) BYTE *, mreg(__d0) LONG MemFlags);
LIBFUNC LONG   LIBStrCompare(mreg(__a0) LONG argString1, mreg(__a1) LONG argString2, mreg(__d0) LONG Length,  mreg(__d1) WORD CaseSensitive);
LIBFUNC void   LIBStrCopy(mreg(__a0) LONG argString, mreg(__a1) LONG argDest, mreg(__d0) LONG Length);
LIBFUNC LONG   LIBStrLength(mreg(__a0) BYTE *);
LIBFUNC void   LIBStrLower(mreg(__a0) BYTE *);
LIBFUNC BYTE * LIBStrMerge(mreg(__a0) LONG argString1, mreg(__a1) LONG argString2, mreg(__a2) LONG argDest);
LIBFUNC LONG   LIBStrSearch(mreg(__a0) LONG argSearch, mreg(__a1) LONG argString);
LIBFUNC LONG   LIBStrToInt(mreg(__a0) BYTE *);
LIBFUNC void   LIBStrUpper(mreg(__a0) BYTE *);

