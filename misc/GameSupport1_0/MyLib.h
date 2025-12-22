#ifndef _MYLIB_H_
#define _MYLIB_H_

#ifdef MYLIB_CONFIG_H
#include "Config.h"
#endif

#if defined(MYLIB_MUI) && !defined(MYLIB_BOOPSI)
#define MYLIB_BOOPSI
#endif

#if defined(MYLIB_BOOPSI) && !defined(MYLIB_INTUITION)
#define MYLIB_INTUITION
#endif

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#if defined(MYLIB_GRAPHICS) && !defined(GRAPHICS_GFXBASE_H)
#include <graphics/gfxbase.h>
#endif

#if defined(MYLIB_MUI) && !defined(LIBRARIES_MUI_H)
#define _DCC
#include <libraries/mui.h>
#undef _DCC
#endif

#if defined(MYLIB_BOOPSI) && !defined(INTUITION_CLASSUSR_H)
#include <intuition/classusr.h>
#endif

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/alib.h>

#ifdef MYLIB_GRAPHICS
#include <proto/graphics.h>
#endif

#ifdef MYLIB_MUI
#include <proto/muimaster.h>
#endif

#ifdef MYLIB_BOOPSI
#include <proto/utility.h>
#endif

#ifdef MYLIB_INTUITION
#include <proto/intuition.h>
#endif

#ifdef MYLIB_FLOAT
#include <proto/mathieeedoubbas.h>
#include <proto/mathieeedoubtrans.h>
#include <proto/mathieeesingbas.h>
#include <proto/mathieeesingtrans.h>
#endif

/************************************************************************/

#define MAX_BYTE	0x7f
#define MAX_WORD	0x7fff
#define MAX_LONG	0x7fffffff

#define MIN_BYTE	(-128)
#define MIN_WORD	(-32768)
#define MIN_LONG	(-2147483648L)

#define MAX_UBYTE	(0xff)
#define MAX_UWORD	(0xffff)
#define MAX_ULONG	(0xffffffff)

/************************************************************************/

#ifndef ROM_VERSION
#define ROM_VERSION 37
#endif

#if ROM_VERSION<37
#error ROM_VERSION must be at least 37
#undef ROM_VERSION
#define ROM_VERSION 37
#endif

#if ROM_VERSION==37
#define ROM_RELEASE "2.04"
#elif ROM_VERSION==39
#define ROM_RELEASE "3.0"
#elif ROM_VERSION==40
#define ROM_RELEASE "3.1"
#endif

#ifdef MYLIB_MUI
#define MYLIB_MUI_VERSION 12
#endif

/************************************************************************/

#ifndef EOF
#define EOF ENDSTREAMCH
#endif

#define ERROR_UNKNOWN		(6971856)

/************************************************************************/
/*									*/
/* Random number generation						*/
/*									*/
/************************************************************************/

#define Random(Seed) (Seed*1103515245+12345)

/************************************************************************/
/*									*/
/* memory copying with overlapping source/dest				*/
/*									*/
/************************************************************************/

#if defined(__GNUC__)

extern __inline__ void CopyUp(void *From, void *To, int Size)
{
  while (--Size>=0)
    {
      ((UBYTE *)To)[Size]=((UBYTE *)From)[Size];
    }
}

extern __inline__ void CopyDown(void *From, void *To, int Size)
{
  while (--Size>=0)
    {
      *((UBYTE *)To)=*((UBYTE *)From);
      To=((UBYTE *)To)+1;
      From=((UBYTE *)From)+1;
    }
}

#else

void CopyUp(void *, void *, int);
void CopyDown(void *, void *, int);

#endif

/************************************************************************/
/*									*/
/* Floating point stuff							*/
/*									*/
/************************************************************************/

#ifdef MYLIB_FLOAT

typedef double IEEEDP;
typedef float IEEESP;

struct __IEEEDP
{
  unsigned int Sign:1;
  unsigned int Exponent:11;
  unsigned int MantissaHigh:20;
  unsigned int MantissaLow:32;
};

int IEEEDPIsInf(IEEEDP);
int IEEEDPIsNan(IEEEDP);
IEEEDP IEEEDPModF(IEEEDP,IEEEDP *);

#define FPF_FORMAT_STANDARD	(1<<0)		/* like printf %f */
#define FPF_FORMAT_SCIENTIFIC	(1<<1)		/* like printf %e */
/* no format: like printf %g */
/* both formats: undefined */

#define FPF_LEFTADJUST		(1<<2)		/* left adjustment */
#define FPF_ALTERNATE		(1<<3)		/* alternate format */

#endif

/************************************************************************/
/*									*/
/* 64 & 96 bit arithmetic						*/
/*									*/
/************************************************************************/

#ifdef __SASC

typedef struct {ULONG __Low; LONG __High;} LONG64;
typedef struct {ULONG __Low; ULONG __High;} ULONG64;

typedef struct {ULONG __Low; ULONG __Middle; LONG __High;} LONG96;
typedef struct {ULONG __Low; ULONG __Middle; ULONG __High;} ULONG96;

double __SMult64(LONG,LONG);
double __UMult64(ULONG,ULONG);

#if ROM_VERSION>=39
#pragma libcall UtilityBase __SMult64 c6 1002
#pragma libcall UtilityBase __UMult64 cc 1002
#define __SMult_64_64_64 __SMult39_64_64_64
#define __UMult_64_64_64 __UMult39_64_64_64
#define __SMult_64_64_32 __SMult39_64_64_32
#define __UMult_64_64_32 __UMult39_64_64_32
#define __SMult_96_64_32 __SMult39_96_64_32
#define __UMult_96_64_32 __UMult39_96_64_32
#endif

void __SDiv_64_64_64(LONG64 *, LONG64 *, LONG64 *);
void __UDiv_64_64_64(ULONG64 *, ULONG64 *, ULONG64 *);
void __SDiv_96_96_96(LONG96 *, LONG96 *, LONG96 *);
void __UDiv_96_96_96(ULONG96 *, ULONG96 *, ULONG96 *);
void __SMult_64_64_64(LONG64 *, LONG64 *, LONG64 *);
void __UMult_64_64_64(ULONG64 *, ULONG64 *, ULONG64 *);
void __SMult_64_64_32(LONG64 *, LONG64 *, LONG);
void __UMult_64_64_32(ULONG64 *, ULONG64 *, ULONG);
void __SMult_96_64_32(LONG96 *, LONG64 *, LONG);
void __UMult_96_64_32(ULONG96 *, ULONG64 *, ULONG);

#define SMult_64_32_32(Result,Arg1,Arg2) do {union{double __Double; LONG64 __Long64;} __Result; __Result.__Double=__SMult64((Arg1),(Arg2)); (Result)=__Result.__Long64;} while(0)
#define UMult_64_32_32(Result,Arg1,Arg2) do {union{double __Double; ULONG64 __Long64;} __Result; __Result.__Double=__UMult64((Arg1),(Arg2)); (Result)=__Result.__Long64;} while(0)

#define SMult_64_64_64(Result,Arg1,Arg2) __SMult_64_64_64(&Result,&Arg1,&Arg2)
#define UMult_64_64_64(Result,Arg1,Arg2) __UMult_64_64_64(&Result,&Arg1,&Arg2)

#define SMult_64_64_32(Result,Arg1,Arg2) __SMult_64_64_32(&Result,&Arg1,Arg2)
#define UMult_64_64_32(Result,Arg1,Arg2) __UMult_64_64_32(&Result,&Arg1,Arg2)

#define SMult_96_64_32(Result,Arg1,Arg2) __SMult_96_64_32(&Result,&Arg1,Arg2)
#define UMult_96_64_32(Result,Arg1,Arg2) __UMult_96_64_32(&Result,&Arg1,Arg2)

#define GetUpperWord(Arg) ((Arg).__High)
#define GetLowerWord(Arg) ((Arg).__Low)
#define UMake_64(Result,High,Low) do {ULONG64 __t; __t.__Low=(Low); __t.__High=(High); (Result)=__t;} while(0)
#define SMake_64(Result,High,Low) do {LONG64 __t; __t.__Low=(Low); __t.__High=(High); (Result)=__t;} while(0)

#define SDiv_64_64_64(Result,Arg1,Arg2) __SDiv_64_64_64(&(Result),&(Arg1),&(Arg2))
#define UDiv_64_64_64(Result,Arg1,Arg2) __UDiv_64_64_64(&(Result),&(Arg1),&(Arg2))

#define SDiv_96_96_96(Result,Arg1,Arg2) __SDiv_96_96_96(&(Result),&(Arg1),&(Arg2))
#define UDiv_96_96_96(Result,Arg1,Arg2) __UDiv_96_96_96(&(Result),&(Arg1),&(Arg2))

#define UShiftLeft_64(Arg,Count) do {int __Count; __Count=Count; while (__Count>0){Arg.__High<<=1; if (Arg.__Low&(1<<31)) Arg.__High|=1; Arg.__Low<<=1; __Count--;}} while (0)

#define SDiv64K_64(Result) \
  ((Result.__Low>>=16), (Result.__Low|=(Result.__High&0xffff)<<16), (Result.__High=((LONG)Result.__High)>>16))

#define Neg64(Arg) ((Arg).__High=((Arg).__High^~0)+(((Arg).__Low=((Arg).__Low^~0)+1)==0 ? 1 : 0))

#define Neg96(Arg) \
  ((Arg).__High=((Arg).__High^~0)+((Arg).__Middle=((Arg).__Middle^~0)+(((Arg).__Low=((Arg).__Low^~0)+1)==0 ? 1 : 0)))

#elif defined(__GNUC__)
#endif

/************************************************************************/

#if ROM_VERSION<39
LONG Seek37(BPTR,LONG,LONG);
#define Seek(Filehandle,Position,Mode)	Seek37(Filehandle,Position,Mode)
#endif

#if ROM_VERSION<40
struct DosList *AttemptLockDosList37(ULONG);
#define AttemptLockDosList(Flags)	AttemptLockDosList37(Flags)
#endif

#if ROM_VERSION<39
#define CreatePool	LibCreatePool
#define DeletePool	LibDeletePool
#define AllocPooled	LibAllocPooled
#define FreePooled	LibFreePooled
#endif

/************************************************************************/
/*									*/
/* Some types that we declare pointers to.				*/
/*									*/
/************************************************************************/

#ifndef EXEC_LIBRARIES_H
struct Library;
#endif

#ifndef WORKBENCH_STARTUP_H
struct WBStartup;
#endif

#ifndef DOS_DOSEXTENS_H
struct DosLibrary;
#endif

#ifndef EXEC_EXECBASE_H
struct ExecBase;
#endif

#ifndef DOS_DOSEXTENS_H
struct Process;
#endif

#ifndef INTUITION_CLASSES_H
struct IClass;
#endif

#ifndef INTUITION_CLASSUSR_H
typedef ULONG Object;
#endif

#ifndef UTILITY_HOOKS_H
struct Hook;
#endif

#ifndef LIBRARIES_COMMODITIES_H
struct InputXpression;
#endif

#ifndef DISKFONT_GLYPH_H
struct GlyphEngine;
#endif

#ifdef MYLIB_MUI
#define __MUIx_Base (TAG_USER | (198<<16) | 65535)
#endif

/************************************************************************/
/*									*/
/* Fontspacing class							*/
/*									*/
/************************************************************************/

#ifdef MYLIB_MUI

struct MUI_CustomClass *CreateFontspacingClass(void);

extern struct MUI_CustomClass *FontspacingClass;

#define MUIA_Fontspacing_Factor(Nominator,Denominator)	(__MUIx_Base-0),((Nominator)<<16)|(Denominator)
#define MUIA_Fontspacing_Horizontal			(__MUIx_Base-1)

#define FontspacingObject NewObject(FontspacingClass->mcc_Class,NULL
#define __Christine__ )
#undef __Christine__

#endif  /* MYLIB_MUI */

/************************************************************************/
/*									*/
/* Messagewindow class							*/
/*									*/
/************************************************************************/

#ifdef MYLIB_MUI

struct MUI_CustomClass *CreateMessagewindowClass(void);

extern struct MUI_CustomClass *MessagewindowClass;

#define MUIA_Messagewindow_String			(__MUIx_Base-2)
#define MUIA_Messagewindow_Params			(__MUIx_Base-3)
#define MUIA_Messagewindow_Buttons			(__MUIx_Base-4)
#define MUIA_Messagewindow_Close			(__MUIx_Base-5)
#define MUIA_Messagewindow_Pointer			(__MUIx_Base-6)

#define MessagewindowObject NewObject(MessagewindowClass->mcc_Class,NULL
#define __Christine__ )
#undef __Christine__

#endif  /* MYLIB_MUI */

/************************************************************************/
/*									*/
/* BOOPSI stuff								*/
/*									*/
/************************************************************************/

#ifdef MYLIB_BOOPSI

extern const char BOOPSI_rootclass[];
extern const char BOOPSI_imageclass[];
extern const char BOOPSI_sysiclass[];
extern const char BOOPSI_frameiclass[];
extern const char BOOPSI_gadgetclass[];
extern const char BOOPSI_strgclass[];
extern const char BOOPSI_propgclass[];
extern const char BOOPSI_buttongclass[];

#if defined(__GNUC__) && defined(__OPTIMIZE__)
extern __inline__ ULONG AttrGet(Object *TheObject, ULONG AttrID)

{
  ULONG Result;

  GetAttr(AttrID,Object,&Result);
  return Result;
}
#else
ULONG AttrGet(Object *,ULONG);
#endif

#define INSTANCEDATA ((struct InstanceData *)INST_DATA(TheClass,TheObject))
#define SUPER_METHOD DoSuperMethodA(TheClass,TheObject,(Msg)Message)

#define METHOD(ID,Param) \
  static INLINE ULONG Method_##ID (struct IClass *TheClass, Object *TheObject, Param Message)

#define METHOD_DISP(ID,Param) \
  case ID: return Method_##ID (TheClass,TheObject,(Param)Message)

#endif  /* MYLIB_BOOPSI */

/************************************************************************/
/*									*/
/* Library bases							*/
/*									*/
/************************************************************************/

extern struct WBStartup *WorkbenchMessage;

extern struct ExecBase *SysBase;

extern struct Library *AslBase;
extern struct Library *DiskfontBase;
extern struct Library *IconBase;

#undef AslName
#undef DiskfontName
#undef IconName

extern const char AslName[];
extern const char DiskfontName[];
extern const char IconName[];

/************************************************************************/
/*									*/
/* AVL stuff								*/
/*									*/
/************************************************************************/

struct AVLNode
{
  struct AVLNode *Left, *Right;
  struct AVLNode *Parent;
  int Balance;		/* <0 -> Left is higher than Right */
};

struct AVLTree
{
  struct AVLNode *Root;
  int (*CompareNodes)(struct AVLNode *, struct AVLNode *);
};

struct AVLState_Inorder
{
  struct AVLNode *Current;
  struct AVLNode *From;
  int GoRight;
};

/************************************************************************/

struct AVLNode *AVLInsertNode(struct AVLTree *Tree, struct AVLNode *Node);
struct AVLNode *AVLSearchNode(struct AVLTree *Tree, struct AVLNode *Node);
void AVLUnlinkNode(struct AVLTree *Tree, struct AVLNode *Node);
struct AVLNode *AVLTraverse_Inorder(struct AVLState_Inorder *);
void AVLTraverseInit_Inorder(struct AVLTree *, struct AVLState_Inorder *);

/************************************************************************/

#define AVLTraverseInit_Inorder(Tree,State) \
  (((State)->From=NULL), ((State)->Current=(Tree)->Root), ((State)->GoRight=FALSE))

#define AVLInitTree(Tree,Compare) \
  (((Tree)->Root=NULL), ((Tree)->CompareNodes=(Compare)))

#define AVLTree_IsEmpty(Tree) \
  ((Tree)->Root==NULL)

#define AVLTree_Root(Tree) \
  ((Tree)->Root)

/************************************************************************/
/*									*/
/* "Small" AVLSmall stuff							*/
/*									*/
/************************************************************************/

struct AVLSmallNode
{
  ULONG Left, Right;		/* Bit 31: this child is higher than other child */
  struct AVLSmallNode *Parent;
};

struct AVLSmallTree
{
  struct AVLSmallNode *Root;
  int (*CompareNodes)(struct AVLSmallNode *, struct AVLSmallNode *);
};

struct AVLSmallState_Inorder
{
  struct AVLSmallNode *Current;
  struct AVLSmallNode *From;
  int GoRight;
};

/************************************************************************/

struct AVLSmallNode *AVLSmallInsertNode(struct AVLSmallTree *Tree, struct AVLSmallNode *Node);
struct AVLSmallNode *AVLSmallSearchNode(struct AVLSmallTree *Tree, struct AVLSmallNode *Node);
void AVLSmallUnlinkNode(struct AVLSmallTree *Tree, struct AVLSmallNode *Node);
struct AVLSmallNode *AVLSmallTraverse_Inorder(struct AVLSmallTree *, struct AVLSmallState_Inorder *);
void AVLSmallTraverseInit_Inorder(struct AVLSmallTree *, struct AVLSmallState_Inorder *);

/************************************************************************/

#define AVLSmallTraverseInit_Inorder(Tree,State) \
  (((State)->From=NULL), ((State)->Current=(Tree)->Root), ((State)->GoRight=FALSE))

#define AVLSmallInitTree(Tree,Compare) \
  (((Tree)->Root=NULL), ((Tree)->CompareNodes=(Compare)))

#define AVLSmallTree_IsEmpty(Tree) \
  ((Tree)->Root==NULL)

#define AVLSmallTree_Root(Tree) \
  ((Tree)->Root)

/************************************************************************/
/*									*/
/* The graphics stuff							*/
/*									*/
/************************************************************************/

#ifdef MYLIB_GRAPHICS

#ifdef DEBUG

LONG __debug_BltBitMap(struct GfxBase *,const char *,unsigned int,
		       struct BitMap *,WORD,WORD,struct BitMap *,WORD,WORD,WORD,WORD,UBYTE,UBYTE,PLANEPTR);
#define BltBitMap(SrcBitMap,SrcX,SrcY,DstBitMap,DstX,DstY,SizeX,SizeY,Minterm,Mask,TempA) \
  __debug_BltBitMap(GfxBase,__FILE__,__LINE__,SrcBitMap,SrcX,SrcY,DstBitMap,DstX,DstY,SizeX,SizeY,Minterm,Mask,TempA)

void __debug_BltBitMapRastPort(struct GfxBase *, const char *, unsigned int,
			       struct BitMap *, WORD, WORD, struct RastPort *, WORD, WORD, WORD, WORD, UBYTE);
#define BltBitMapRastPort(SrcBitMap,SrcX,SrcY,DstRPort,DstX,DstY,SizeX,SizeY,Minterm) \
  __debug_BltBitMapRastPort(GfxBase,__FILE__,__LINE__,SrcBitMap,SrcX,SrcY,DstRPort,DstX,DstY,SizeX,SizeY,Minterm)

#endif  /* DEBUG */

#if ROM_VERSION<39
#define SetABPenDrMd(RastPort,APen,BPen,DrMd) \
if (GfxBase->LibNode.lib_Version<39) \
  { \
    SetAPen(RastPort,APen); \
    SetBPen(RastPort,BPen); \
    SetDrMd(RastPort,DrMd); \
  } \
else SetABPenDrMd(RastPort,APen,BPen,DrMd)
#endif  /* ROM_VERSION */

LONG MakeTextAttr(const char *, struct TextAttr *);

WORD LabelText(struct RastPort *, const char *, int);

#endif  /* MYLIB_GRAPHICS */

/************************************************************************/
/*									*/
/* The MUI stuff							*/
/*									*/
/************************************************************************/

#ifdef MYLIB_MUI

ULONG MUI_DisposeWindow(Object *);

#if defined(__GNUC__) && defined(__OPTIMIZE__)
extern __inline__ ULONG MUI_OpenWindow(Object *Window)
{
  ULONG OpenState;

  set(Window,MUIA_Window_Open,TRUE);
  get(Window,MUIA_Window_Open,&OpenState);
  return OpenState;
}
#else
ULONG MUI_OpenWindow(Object *);
#endif

LONG MUI_EventLoop(Object *);

#define MUIA_FillArea 0x804294a3 /* V4  ... BOOL */ /* private */

Object *MUI_Button(const char *, Object **);

#define MUIV_Application_ReturnID_Break		-256

#endif  /* MYLIB_MUI */

/************************************************************************/
/*									*/
/* Intuition stuff							*/
/*									*/
/************************************************************************/

#ifdef MYLIB_INTUITION

struct GT_Menu
{
  struct Menu Menu;
  APTR UserData;
};

struct GT_MenuItem
{
  struct MenuItem MenuItem;
  APTR UserData;
};

void CloseWindowSafely(struct Window *);
void ShowWindow(struct Window *);

extern struct IClass *IconifyImageClass;
struct IClass *CreateIconifyImageClass(void);

struct MyScreen
{
  struct Screen *Screen;
  struct
    {
      unsigned int Signal:8;		/* Signal to be used to public treatment */
      unsigned int Foreign;		/* Screen is not owned by us */
    } Misc;
  struct TextAttr TextAttr;
  char *Title;
};

struct MyScreen *GetScreen(const char *, const char *);
int FreeScreen(struct MyScreen *, int);

#endif  /* MYLIB_INTUITION */

/************************************************************************/

struct RDArgs *ParseString(const char *, const char *, void *);
void ParseStringDone(struct RDArgs *);

/************************************************************************/

extern int __MyLib_CloseStdErr;
extern BPTR StdErr;

BPTR ErrorHandle(void);

void PError(LONG, const char *);

#define CloseStdErr()	do { if (__MyLib_CloseStdErr) Close(StdErr); } while (FALSE)

/************************************************************************/
/*									*/
/* A special return value. Name says it all.				*/
/*									*/
/************************************************************************/

#define RETURN_CATASTROPHY	(100)

/************************************************************************/
/*									*/
/* Some ISO/IEC 9899-1990 stuff						*/
/*									*/
/************************************************************************/

typedef int		ptrdiff_t;
typedef unsigned long	size_t;

#undef NULL
#define	NULL	((void *)0)

/************************************************************************/
/*									*/
/* Varargs stuff. ISO/IEC 9899-1990 compliant				*/
/*									*/
/************************************************************************/

typedef char *va_list;

#define	va_arg(ap,type) ((type *)(ap += sizeof(type)))[-1]
#define	va_end(ap)
#define	__va_promote(type) (((sizeof(type) + sizeof(int) - 1) / sizeof(int)) * sizeof(int))
#define	va_start(ap, last) (ap = ((char *)&(last) + __va_promote(last)))

/************************************************************************/
/*									*/
/* Some compiler macros							*/
/*									*/
/************************************************************************/

#if defined(__GNUC__)
#  define REGARGS
#  define NORETURN __attribute__((noreturn))
#  define INLINE inline
#  define ALIGN(Variable) Variable __attribute__((aligned(4)))
#  define COMPILER "GNU C " __VERSION__
#  undef CPU
#  if defined(mc68040)
#    define CPU "mc68040"
#  elif defined(mc68030)
#    if defined(__HAVE_68881__)
#      define CPU "mc68ec030/mc68881"
#    else
#      define CPU "mc68ec030"
#    endif
#  elif defined(mc68020)
#    if defined(__HAVE_68881__)
#      define CPU "mc68020/mc68881"
#    else
#      define CPU "mc68020"
#    endif
#  else
#    define CPU "mc68000"
#  endif
#elif defined(__SASC_510)
#  define REGARGS __regargs
#  define NORETURN
#  define INLINE
#  define ALIGN(Variable) __aligned Variable
#  define COMPILER "SAS/C 5.10b"
#  define CPU "mc68000"
#  ifndef SMALL_DATA
#    define __saveds
#  endif
#else
#  error Compiler not supported.
#endif

/************************************************************************/
/*									*/
/* Useful macros							*/
/*									*/
/************************************************************************/

/* return the number of items in an array */
#define ARRAYSIZE(x) (sizeof(x)/sizeof((x)[0]))

/* return the byte offset of some structure member */
#define STRUCTUREOFFSET(Structure,Item) ((int)&(((Structure *)0)->Item))

/* return the base address of a structure, given the address of a member */
#define STRUCTUREBASE(Structure,Item,Address) ((Structure *)(((char *)(Address))-STRUCTUREOFFSET(Structure,Item)))

/************************************************************************/
/*									*/
/* Memory pools								*/
/*									*/
/************************************************************************/

struct MemoryPool
{
  struct MinList MemList;
  ULONG BlockSize;
  ULONG Flags;
};

#if defined(__GNUC__) && defined(__OPTIMIZE__)
extern INLINE InitMemoryPool(struct MemoryPool *MemoryPool, ULONG BlockSize, ULONG Flags)
{
  NewList((struct List *)&MemoryPool->MemList);
  MemoryPool->BlockSize=BlockSize;
  MemoryPool->Flags=Flags;
}
#else
#define InitMemoryPool(__MemoryPool,__BlockSize,__Flags) (NewList((struct List *)&(__MemoryPool)->MemList), (__MemoryPool)->BlockSize=__BlockSize, (__MemoryPool)->Flags=__Flags)
#endif

void *MyAllocPooled(struct MemoryPool *, ULONG);
void MyFreePooled(struct MemoryPool *, void *, ULONG);
void MyDeletePool(struct MemoryPool *);

/************************************************************************/
/*									*/
/* ISO/IEC 9899-1990 compliant string functions				*/
/*									*/
/************************************************************************/

int stricmp(const char *, const char *);
int strnicmp (const char *, const char *, size_t);

size_t strlen (const char *);
char *strcpy (char *, const char *);
int strcmp (const char *, const char *);
int strncmp (const char *, const char *, size_t);
char *strncpy (char *, const char *, size_t);
char *strcat (char *, const char *);
char *strchr(const char *, int);

#if defined(__GNUC__) && defined(__OPTIMIZE__)

extern inline size_t __inlined_strlen(const char *String)
{
  const char *t;

  t=String;
  while(*t++)
    ;
  return ~(String-t);
}

extern inline char *__inlined_strcpy(char *Dest, const char *Source)
{
  char *t;

  t=Dest;
  do
    {
      *t++=*Source;
    }
  while(*Source++!='\0');
  return Dest;
}

extern inline char *__inlined_strcat(char *String1, const char *String2)
{
  char *t;

  t=String1;
  while(*t++)
    ;
  --t;
  while((*t++=*String2++))
    ;
  return String1;
}

extern inline int __inlined_strcmp(const char *String1, const char *String2)
{
  int Result;

  while (!(Result=*String1++-*String2) && *String2++)
    ;
  return Result;
}

extern inline int __inlined_strncmp(const char *String1, const char *String2, size_t Size)
{
  int Result;

  Result=0;
  if (Size != 0)
    {
      while (!(Result=*String1++-*String2) && *String2++ && (--Size != 0))
	;
    }
  return Result;
}

#define strlen(String)			__inlined_strlen(String)
#define strcpy(Dest,Source)		__inlined_strcpy(Dest,Source)
#define strcat(String1,String2)		__inlined_strcat(String1,String2)
#define strcmp(String1,String2)		__inlined_strcmp(String1,String2)
#define strncmp(String1,String2,Size)	__inlined_strncmp(String1,String2,Size)

#endif  /* defined(__GNUC__) && defined(__OPTIMIZE__) */

#ifdef __SASC_510

int __builtin_memcmp (const void *, const void *, size_t);
void *__builtin_memcpy (void *, const void *, size_t);
void *__builtin_memset (void *, int, size_t);
size_t __builtin_strlen (const char *);
int __builtin_strcmp (const char *, const char *);
char *__builtin_strcpy (char *, const char *);

#define memset(Memory,Value,Size)	__builtin_memset(Memory,Value,Size)
#define memcmp(Memory1,Memory2,Size)	__builtin_memcmp(Memory1,Memory2,Size)
#define memcpy(Dest,Source,Size)	__builtin_memcpy(Dest,Source,Size)
#define strlen(String)			__builtin_strlen(String)
#define strcmp(String1,String2)		__builtin_strcmp(String1,String2)
#define strcpy(Dest,Source)		__builtin_strcpy(Dest,Source)

#endif  /* __SASC_510 */

/************************************************************************/
/*									*/
/* ctype functions							*/
/*									*/
/************************************************************************/

#define isdigit(c) ((c)>='0' && (c)<='9')
#define islower(c) ((c)>='a' && (c)<='z')
#define isupper(c) ((c)>='A' && (c)<='Z')
#define isalpha(c) (isupper(c) || islower(c))
#define toupper(c) (islower(c) ? (c)&~0x20 : (c))
#define tolower(c) (isupper(c) ? (c)|0x20 : (c))

/************************************************************************/
/*									*/
/*									*/
/************************************************************************/

void MyExit(int, LONG) NORETURN;

int SPrintf(char *, const char *, ...);
int VSPrintf(char *, const char *, va_list);

/************************************************************************/
/*									*/
/* More string functions, stolen from various sources			*/
/*									*/
/************************************************************************/

char *stpcpy(char *, const char *);			/* Lattice */

#if defined(__GNUC__) && defined(__OPTIMIZE__)

extern inline char *__inlined_stpcpy(char *Dest, const char *Source)
{
  while ((*Dest++=*Source++))
    ;
  return Dest-1;
}

#define stpcpy(Dest,Source)		__inlined_stpcpy(Dest,Source)

#endif

/************************************************************************/
/*									*/
/* Misc functions							*/
/*									*/
/************************************************************************/

Object *DoSuperNew(struct IClass *, Object *, ULONG, ...);

#ifdef __SASC
ULONG __saveds __asm MyHookEntry(register __a0 struct Hook *, register __a2 APTR, register __a1 APTR);
#else
ULONG MyHookEntry(void);
#endif

#ifdef __SASC
#define abs(x)	__builtin_abs(x)
#endif

LONG *ReadFile(const char *);
void FreeFile(LONG *);

#if defined(__GNUC__)

extern __inline__ ULONG CurrentTimeSeconds(void)
{
  ULONG Seconds, Micros;

  CurrentTime(&Seconds,&Micros);
  return Seconds;
}

#else

ULONG CurrentTimeSeconds(void);

#endif

/************************************************************************/
/*									*/
/* Asynchronous asl facility						*/
/*									*/
/************************************************************************/

struct AsyncAslMessage
{
  struct Message Message;
  void *Requester;
  struct TagItem *TagList;
  LONG Result;
  LONG Error;
};

void AsyncAslRequest(struct AsyncAslMessage *);

/************************************************************************/
/*									*/
/* Debugging								*/
/*									*/
/************************************************************************/

#ifdef DEBUG

kprintf(const char *, ...);

#define debug_printf(x) kprintf x
#define assert(x) if (!(x)) {debug_printf(("assertion failed: file %s, line %lu\n",__FILE__,__LINE__)); while (*((UBYTE *)0x00bfe001) & 0x80) *((UWORD *)0x00dff180)=0x0f00;}

#else

#define debug_printf(x)
#define assert(x)

#endif  /* DEBUG */

#endif  /* _MYLIB_H_ */
