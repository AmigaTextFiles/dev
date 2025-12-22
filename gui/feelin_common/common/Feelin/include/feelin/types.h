#ifndef FEELIN_TYPES_H
#define FEELIN_TYPES_H

/*
**  feelin/types.h
**
**  Data typing. Should be included before any other Feelin include.
**
**  © 2001-2005 Olivier LAVIALE (gofromiel@gofromiel.com)
**
*************************************************************************************************

$VER: 10.02 (2005/12/15)

	Params field of FThreadMsg is an APTR now.

************************************************************************************************/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif
#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif
#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif
#ifndef FEELIN_CONF_H
#include <libraries/feelin_conf.h>
#endif
#ifndef FEELIN_COMPILER_H
#include <feelin/compiler.h>
#endif

/************************************************************************************************
*** Basic types *********************************************************************************
************************************************************************************************/

#define FF_TYPE_BIT                             (1 << 24)
#define FV_TYPE_BOOLEAN                         (FF_TYPE_BIT | 0)
#define FV_TYPE_FLAGS                           (FF_TYPE_BIT | 1)

#define FF_TYPE_NUMERIC                         (1 << 25)
#define FV_TYPE_INTEGER                         (FF_TYPE_NUMERIC | 0)
#define FV_TYPE_HEXADECIMAL                     (FF_TYPE_NUMERIC | 1)
#define FV_TYPE_BINARY                          (FF_TYPE_NUMERIC | 2)
#define FV_TYPE_PERCENTAGE                      (FF_TYPE_NUMERIC | 4)
#define FV_TYPE_PIXEL                           (FF_TYPE_NUMERIC | 5)
#define FV_TYPE_DEGREES                         (FF_TYPE_NUMERIC | 6)
#define FV_TYPE_RGB                             (FF_TYPE_NUMERIC | 7)

#define FF_TYPE_REFERENCE                       (1 << 26)
#define FV_TYPE_POINTER                         (FF_TYPE_REFERENCE | 0)
#define FV_TYPE_OBJECT                          (FF_TYPE_REFERENCE | 1)

#define FF_TYPE_LITERAL                         (1 << 27)
#define FV_TYPE_STRING                          (FF_TYPE_LITERAL | 0)

/*** Compiler **********************************************************************************/

#ifndef __amigaos4__
typedef signed char                             int8;
typedef signed short                            int16;
typedef signed long                             int32;
typedef unsigned char                           uint8;
typedef unsigned short                          uint16;
typedef unsigned long                           uint32;

typedef float                                   float32;
typedef double                                  float64;
#endif
typedef unsigned char                           bits8;
typedef unsigned short                          bits16;
typedef unsigned long                           bits32;

typedef unsigned char                           bool8;
typedef unsigned short                          bool16;
typedef unsigned long                           bool32;

/************************************************************************************************
*** Additionnal types ***************************************************************************
************************************************************************************************/

typedef void *                                  FObject;
typedef void                                    FNotifyHandler;

struct FeelinBase; /* defined in library/feelin.h */
struct FeelinClass;

/*

GOFROMIEL @ HOMBRE: Dis-moi beau gosse, on pourrait pas virer FeelinBase  de
FMethod, comme pour AOS4 ?

HOMBRE : ??? Mais c'est déjà le cas ! Je n'utilise pas FeelinBase... Ce memo
ne serait pas plutôt pour Yomgui ?

GOFROMIEL: Ui,  désolé...  faut  croire  que  j'ai  l'habitude  de  t'écrire
beaucoup ces temps-ci ;-) Alors Yomgui ?

*/

typedef uint32                                  (ASM (*FMethod))
												(
													REG(a2,APTR Class),
													REG(a0,FObject Obj),
													REG(d0,uint32 Method),
													REG(a1,APTR Msg)

													#ifndef __amigaos4__
													,REG(a6,struct FeelinBase *FeelinBase)
													#endif
												);

typedef uint32                                  (ASM(*FHook))(REG(a0,struct Hook *Hook),REG(a2,FObject Obj),REG(a1,APTR Msg));
typedef uint32                                  (ASM(*FHookEntry))(REG(a2,FObject Obj),REG(a1,APTR Msg));

/************************************************************************************************
*** Useful structures ***************************************************************************
************************************************************************************************/

/*** Nodes *************************************************************************************/

typedef struct FeelinNode
{
	struct FeelinNode              *Next;
	struct FeelinNode              *Prev;
}
FNode;

typedef struct FeelinNodeData
{
	struct FeelinNodeData          *Next;
	struct FeelinNodeData          *Prev;
	APTR                            Data;
}
FNodeData;

typedef struct FeelinFamilyNode
{
	struct FeelinFamilyNode        *Next;
	struct FeelinFamilyNode        *Prev;
	FObject                         Object;
}
FFamilyNode;

/*** Lists *************************************************************************************/

typedef struct FeelinList
{
	struct FeelinNode              *Head;
	struct FeelinNode              *Tail;
}
FList;

typedef struct FeelinListSemaphored
{
	struct FeelinNode              *Head;
	struct FeelinNode              *Tail;
//  end of FeelinList header
	struct SignalSemaphore          Semaphore;
}
FListSemaphored;

/*** Coordinates *******************************************************************************/

typedef struct FeelinBox
{
	int16                           x,y;
	uint16                          w,h;
}
FBox;

typedef struct FeelinRect
{
	int16                           x1,y1,x2,y2;
}
FRect;

typedef struct FeelinMinMax
{
	uint16                          MinW,MinH,MaxW,MaxH;
}
FMinMax;

typedef struct FeelinPadding
{
	uint8                           l,r,t,b;
}
FPadding;

/*** Hashing ***********************************************************************************/

typedef struct FeelinHashLink
{
	struct FeelinHashLink          *Next;
	char                           *Key;
	uint32                          KeyLength;
	APTR                            Data;
}
FHashLink;

typedef struct FeelinHashTable
{
   uint32                           Size;
   FHashLink                      **Entries;
}
FHashTable;

#define FV_HASH_NORMAL                          211
#define FV_HASH_MEDIUM                          941
#define FV_HASH_HEAVY                           3911
#define FV_HASH_HEAVIER                         16267

/*** Atoms *************************************************************************************/

typedef struct FeelinAtom
{
	STRPTR                          Key;
	uint32                          KeyLength;
}
FAtom;

/*** Classes ***********************************************************************************/

typedef struct FeelinClassAtom
{
	STRPTR                          Name;
	FAtom                          *Atom;
}
FClassAtom;

typedef struct FeelinDynamicEntry
{
	STRPTR                          Name;
	uint32                          ID;
}
FDynamicEntry;

typedef struct FeelinClassMethod
{
	FMethod                         Function;
	STRPTR                          Name;
	uint32                          ID;
}
FClassMethod;

typedef struct FeelinClassAttributeValue
{
	STRPTR                          Name;
	uint32                          Value;
}
FClassAttributeValue;

typedef struct FeelinClassAttribute
{
	STRPTR                          Name;
	uint32                          Type;
	uint32                          ID;
	FClassAttributeValue           *Values;
}
FClassAttribute;

typedef struct FeelinClassProperty
{
	STRPTR                          Name;
	FAtom                          *Atom;
	FClassAttributeValue           *Values;
}
FClassProperty;

typedef struct FeelinClass
{
	struct FeelinClass             *Next;
	#ifndef F_NEW_SINGLELIST_CLASSES
	struct FeelinClass             *Prev;
	#endif
	struct FeelinClass             *Super;

	STRPTR                          Name;
	uint16                          Offset;
	uint16                          LocalSize;
	APTR                            UserData;
	uint32                          UserCount;

	uint16                          PropertiesOffset;
	uint32                          PropertiesLocalSize;

	FClassMethod                   *Methods;
	FClassAttribute                *Attributes;
	FClassProperty                 *Properties;
	FDynamicEntry                  *Resolveds;
	FDynamicEntry                  *Autos;

	FClassAtom                     *Atoms;

	FAtom                          *Atom;
}
FClass;

typedef struct FeelinCatalogEntry
{
	uint32                          ID;
	STRPTR                          String;
	STRPTR                          Default;
}
FCatalogEntry;

/*** Threads ***********************************************************************************/

typedef struct FeelinThreadMessage
{
	struct Message                  SysMsg;
	uint16                          pad0;

	int32                           Action;
	APTR                           *Params;
	uint32                          Return;
}
FThreadMsg;

typedef struct FeelinThreadPublic
{
	struct MsgPort                 *Port;
	struct Process                 *Process;
	bits32                          Signals;

	uint32                          id_Send;
	uint32                          id_Pop;
	uint32                          id_Wait;
}
FThreadPublic;

struct FS_Thread_Run
{
	FThreadPublic				   *Public;
};

/*** Display ***********************************************************************************/

/* I really don't like FColor  nor  FPalette,  they  may  change  in  future
releases. They may as well desapear... */

typedef struct FeelinColor
{
	uint32                          _priv0;
	uint32                          _priv1;
	uint32                          Pen;
	uint32                          ARGB;
}
FColor;

typedef struct FeelinPalette
{
	uint32                          Count;
	uint32                         *Pens;
	uint32                         *ARGB;
	FColor                        **Colors;
}
FPalette;

/*** Render ************************************************************************************/

typedef struct FeelinRender
{
	FObject                         Application;
	FObject                         Display;
	FObject                         Window;
	struct RastPort                *RPort;
	FPalette                       *Palette;
	bits32                          Flags;
}
FRender;

#endif
