/* MUI STUFF */

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

/*  #define MY_MUISERIALNR 115183563   just a big long, no ?  */
#define MY_MUISERIALNR 115
#define MY_TAGBASE (TAG_USER | ( MY_MUISERIALNR << 16))

#define MUIA_DXList_DClick       (MY_TAGBASE | 0x0001)
#define MUIA_DXList_XOffset      (MY_TAGBASE | 0x0002)
#define MUIA_DXList_XVisible     (MY_TAGBASE | 0x0003)
#define MUIA_DXList_AfterDraw    (MY_TAGBASE | 0x0004)

extern struct MUI_CustomClass *DXListClass;

void DeleteDXListClass(void);
struct MUI_CustomClass *CreateDXListClass(void);

