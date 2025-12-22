/*
**  class_startup.c
**
**  Feelin class library startup code.
**
*************************************************************************************************

$VER: 01.10 (2006/12/06)

	The automatic global variable support was broken with GCC, because I was
	checking for PROTO_<LIB>_H, when _PROTO_<LIB>_H was defined.


$VER: 01.04 (2005/12/04)

	Uses the new F_QUERY_PROTO() and F_QUERY_CALL() macros.  Enhanced  debug
	macros. Correct some mistakes in OS4 variables names.


$VER: 01.03 (2005/09/30)

	If PROTO_DOS_H, PROTO_GRAPHICS_H, PROTO_LAYERS_H,  PROTO_INTUITION_H  or
	PROTO_UTILITY_H  are  defined,  the  corresponding  global variables are
	created for their library base and their  interface  (if  the  class  is
	compiled  under  AmigaOS4).  This  automatic  feature can be disabled by
	defining F_CLASS_NO_AUTO_PROTO.


$VER: 01.02 (2005/08/29)

	Added macros to request libraries base : F_CLASS_USE_DOS,
	F_CLASS_USE_INTUITION F_CLASS_USE_GRAPHICS F_CLASS_USE_LAYERS
	F_CLASS_USE_UTILITY.

	Added AmigaOS4 support.


$VER: 01.01 (2005/08/23)

	GROG: MorphOS edition. Re-enable debug.


$VER: 01.00 (2005/08/09)

	Rewrote class startup. It's no longer a linked object, but a file to include in the
	"Project.c" file of the class.

	The following macros must be defined by the compiler when creating the object :

	F_CLASS_NAME: The name of the class e.g. "Area"
	F_CLASS_VERSION_STRING: The version string e.g. "09.12 (2005/07/25)"
	F_CLASS_VERSION: The version number of the class e.g. "09"
	F_CLASS_REVISION: The revision number of the class e.g. "12"
	F_CLASS_AUTHOR: The author of the class e.g. "Olivier LAVIALE"


************************************************************************************************/

#define NDEBUG

#ifndef F_CLASS_AUTHOR
#define F_CLASS_AUTHOR                          "Olivier LAVIALE (gofromiel@gofromiel.com)"
#endif
#ifndef F_CLASS_EXTENSION
#define F_CLASS_EXTENSION                       ".fc"
#endif

#ifndef F_LIB_BASE
#define F_LIB_BASE                              ClassBase
#endif

#ifndef F_LIB_STRUCT
#define F_LIB_STRUCT                            struct in_ClassBase
#endif

#ifndef F_LIB_IFACE
#define F_LIB_IFACE                             FeelinClassIFace
#endif

#ifndef F_LIB_IFACE_PTR
#define F_LIB_IFACE_PTR                         IFeelinClass
#endif

/************************************************************************************************
*** Includes ************************************************************************************
************************************************************************************************/

#include <exec/types.h>
#include <exec/tasks.h>
#include <exec/ports.h>
#include <exec/memory.h>
#include <exec/lists.h>
#include <exec/semaphores.h>
#include <exec/execbase.h>
#include <exec/alerts.h>
#include <exec/libraries.h>
#include <exec/interrupts.h>
#include <exec/resident.h>
#include <dos/dos.h>

#include <feelin/types.h>
#include <feelin/machine.h>
#include <feelin/debug.h>

#include <proto/exec.h>
#include <proto/feelinclass.h>

#ifdef __amigaos4__

extern CONST struct TagItem libCreateTags[];

#else

struct FeelinLID
{
   uint8 i_Type,o_Type,d_Type,p_Type;
   uint16 i_Name,o_Name; STRPTR d_Name;
   uint8 i_Flags,o_Flags,d_Flags,p_Flags;
   uint8 i_Version,o_Version; uint16 d_Version;
   uint8 i_Revision,o_Revision; uint16 d_Revision;
   uint16 i_IdString,o_IdString; STRPTR d_IdString;
   uint32 endmark;
};

extern const uint32                 lib_init_table[4];

#endif

struct in_ClassBase
{
	struct Library                  lib;
	APTR                            seglist;
};

extern const char                   feelin_auto_class_id[];
extern const char                   feelin_auto_class_name[];
extern F_QUERY_PROTO();

/*

	GOFROMIEL @ YOMGUI: Once we have removed the 68k emulation, will  it  be
	possible to remove this __abox__ thing ?

*/

#ifdef __MORPHOS__
uint32 __abox__ = 1;
#endif

/************************************************************************************************
*** Global bases (or interfaces) ****************************************************************
************************************************************************************************/

///Bases
/* Bases (or Interfaces for AmigaOS 4) are stored here, local to the class */

struct ExecBase                     *SysBase;
#ifdef __amigaos4__
struct ExecIFace                    *IExec;
#endif

struct FeelinBase                   *FeelinBase;
#ifdef __amigaos4__
struct FeelinIFace                  *IFeelin;
#endif

#ifndef F_CLASS_NO_AUTO_PROTO

/*

GOFROMIEL @ HOMBRE: Tu vois, je n'ajoute que  ce  qui  est  nécessaire.  Par
exemple,  si  le  developeur a défini <proto/graphics.h> parce qu'il se sert
des functions de  graphics.library,  ben  je  crée  les  variables  globales
adéquates. F_CLASS_NO_AUTO_PROTO sert juste a supprimer cette automatisme au
cas où le developeur préfére recourir à d'autres méthode,  comme  un  double
référencement par exemple...

*/

#if defined(PROTO_DOS_H) | defined(_PROTO_DOS_H)
struct DosLibrary                   *DOSBase;
#ifdef __amigaos4__
struct DOSIFace                     *IDOS;
#endif
#endif

#if defined (PROTO_GRAPHICS_H) | defined (_PROTO_GRAPHICS_H)
struct GfxBase                      *GfxBase;
#ifdef __amigaos4__
struct GraphicsIFace                *IGraphics;
#endif
#endif

#if defined (PROTO_LAYERS_H) | defined(_PROTO_LAYERS_H)
struct Library                      *LayersBase;
#ifdef __amigaos4__
struct LayersIFace                  *ILayers;
#endif
#endif

#if defined (PROTO_INTUITION_H) | defined(_PROTO_INTUITION_H)
struct IntuitionBase                *IntuitionBase;
#ifdef __amigaos4__
struct IntuitionIFace               *IIntuition;
#endif
#endif

#if defined (PROTO_UTILITY_H) | defined(_PROTO_UTILITY_H)
struct UtilityBase                  *UtilityBase;
#ifdef __amigaos4__
struct UtilityIFace                 *IUtility;
#endif
#endif

#if defined (PROTO_LOCALE_H) | defined(_PROTO_LOCALE_H)
struct Library                      *LocaleBase;
#ifdef __amigaos4__
struct LocaleIFace                  *ILocale;
#endif
#endif

#endif
//+

/************************************************************************************************
*** Interface ***********************************************************************************
************************************************************************************************/

///_start
int32 _start(void)
{
	return -1;
}
//+

///ROMTag
STATIC struct Resident ROMTag
#if defined(__GNUC__) && defined(__amigaos4__)
__attribute__((used))
#endif
=
{
	RTC_MATCHWORD,
	&ROMTag,
	&ROMTag + 1,

	FF_LIBRARY,
	F_CLASS_VERSION,
	NT_LIBRARY,
	0,
	(STRPTR) &feelin_auto_class_name,
	(STRPTR) &feelin_auto_class_id[6],
#ifdef __amigaos4__
	(APTR)libCreateTags
#else
	(APTR) &lib_init_table
#endif

#if defined(__MORPHOS__) || defined(__AROS__)
	/* New Fields */
	,F_CLASS_REVISION,
	NULL
#endif
};
//+

const char feelin_auto_class_name[] = F_CLASS_NAME F_CLASS_EXTENSION;
const char feelin_auto_class_id[] = "$VER: " F_CLASS_NAME " " F_CLASS_VERSION_STRING " by " F_CLASS_AUTHOR;

/// lib_init
SAVEDS STATIC F_LIB_INIT
{
	F_LIB_INIT_ARGS

	DEBUG_INIT(SelfBase, SegList, SYS);

#ifdef __amigaos4__

	/* The ROMTAG Initialisation */

	SelfBase->lib.lib_Node.ln_Type = NT_LIBRARY;
	SelfBase->lib.lib_Node.ln_Pri  = 0;
	SelfBase->lib.lib_Node.ln_Name = (STRPTR) &feelin_auto_class_name;
	SelfBase->lib.lib_Flags        = LIBF_SUMUSED|LIBF_CHANGED;
	SelfBase->lib.lib_Version      = F_CLASS_VERSION;
	SelfBase->lib.lib_Revision     = F_CLASS_REVISION;
	SelfBase->lib.lib_IdString     = (STRPTR) &feelin_auto_class_id;

	SysBase = (struct ExecBase *) SYS->Data.LibBase;
	IExec   = (struct ExecIFace *) SYS;

#else

	SysBase = SYS;

#endif

	SelfBase->seglist = SegList;

	return &SelfBase->lib;
}
//+
/// lib_expunge
SAVEDS STATIC F_LIB_EXPUNGE
{
	F_LIB_EXPUNGE_ARGS

	APTR seglist = ClassBase -> seglist;

	DEBUG_FCT(("ClassBase 0x%08lx\n",ClassBase));

	if (ClassBase -> lib.lib_OpenCnt)
	{
		DEBUG_FCT(("set LIBF_DELEXP\n"));

		ClassBase -> lib.lib_Flags |= LIBF_DELEXP;

		return 0;
	}

	/* We don't need a forbid() because Expunge and Close are called with a
	pending forbid. But let's do it for safety if somebody does it by hand.
	*/

	IEXEC Forbid();

	DEBUG_FCT(("remove the library\n"));

	IEXEC Remove(&ClassBase->lib.lib_Node);

	IEXEC Permit();

	DEBUG_FCT(("free the library\n"));

#ifdef __amigaos4__

	IEXEC DeleteLibrary((struct Library *) ClassBase);

#else

	IEXEC FreeMem((APTR) ((uint32) (ClassBase) - (uint32) (ClassBase->lib.lib_NegSize)),
			ClassBase->lib.lib_NegSize + ClassBase->lib.lib_PosSize);

#endif


	DEBUG_FCT(("return Segment 0x08%lx to ramlib\n", seglist));

	return seglist;
}
//+
/// lib_open
static F_LIB_OPEN
{
	F_LIB_OPEN_ARGS

	DEBUG_FCT(("0x%08lx <%s> OpenCount %ld\n",ClassBase, ClassBase->lib.lib_Node.ln_Name, ClassBase->lib.lib_OpenCnt));

	ClassBase->lib.lib_Flags &= ~LIBF_DELEXP;
	ClassBase->lib.lib_OpenCnt++;

	return &ClassBase->lib;
}
//+
///lib_close
static F_LIB_CLOSE
{
	F_LIB_CLOSE_ARGS

	DEBUG_FCT(("0x%08lx <%s> OpenCount %ld\n",ClassBase, ClassBase->lib.lib_Node.ln_Name, ClassBase->lib.lib_OpenCnt));

	/* This call is protected by a Forbid() */

	if (ClassBase->lib.lib_OpenCnt > 0)
		ClassBase->lib.lib_OpenCnt--;

	if (ClassBase->lib.lib_OpenCnt == 0)
	{
		if (ClassBase->lib.lib_Flags & LIBF_DELEXP)
		{

			DEBUG_FCT(("LIBF_DELEXP set\n"));

#ifdef __MORPHOS__

			REG_A6 = (uint32) ClassBase;

			return lib_expunge();

#elif defined(__amigaos4__)

			return lib_expunge(SelfIFace);

#else

			return lib_expunge(ClassBase);

#endif

		}
	}
	else
	{
		DEBUG_FCT(("done\n"));
	}
	return 0;
}
//+
///lib_reserved
static uint32 lib_reserved(void)
{

	/* These useless lines are used to hide symbols and shutup the compiler */

	uint32 a = (uint32)(&ROMTag) - (uint32)(&ROMTag);

/*

YOMGUI: devraient pas exister ces lignes! chercher pourquoi!

GOFROMIEL: c'est parce que ROMTag n'est utilisé nulle part

*/

	return a;
}
//+

/************************************************************************************************
*** Feelin Query ********************************************************************************
************************************************************************************************/

///lib_query
SAVEDS STATIC F_LIB_QUERY
{
	F_LIB_QUERY_ARGS

	/* feelin.library */

	FeelinBase = Feelin;

	#ifdef __amigaos4__
	IFeelin = FeelinBase->I_Feelin;
	#endif

	DEBUG_FCT(("FeelinBase (%08lx)\n", FeelinBase));

	#ifndef F_CLASS_NO_AUTO_PROTO

		/* dos.library */

		#if defined(PROTO_DOS_H) | defined(_PROTO_DOS_H)
			DOSBase = FeelinBase->DOS;

			#ifdef __amigaos4__
			IDOS = FeelinBase->I_DOS;
			#endif

			DEBUG_FCT(("DOSBase (%08lx)\n", DOSBase));
		#endif

		/* graphics.library */

		#if defined(PROTO_GRAPHICS_H) | defined(_PROTO_GRAPHICS_H)
			GfxBase = FeelinBase->Graphics;

			#ifdef __amigaos4__
			IGraphics = FeelinBase->I_Graphics;
			#endif

			DEBUG_FCT(("GfxBase (%08lx)\n", GfxBase));
		#endif

		/* layers.library */

		#if defined(PROTO_LAYERS_H) | defined(_PROTO_LAYERS_H)
			LayersBase = FeelinBase->Layers;

			#ifdef __amigaos4__
			ILayers = FeelinBase->I_Layers;
			#endif

			DEBUG_FCT(("LayersBase (%08lx)\n", LayersBase));
		#endif

		/* intuition.library */

		#if defined(PROTO_INTUITION_H) | defined(_PROTO_INTUITION_H)
			IntuitionBase = FeelinBase->Intuition;

			#ifdef __amigaos4__
			IIntuition = FeelinBase->I_Intuition;
			#endif

			DEBUG_FCT(("IntuitionBase (%08lx)\n", IntuitionBase));
		#endif

		/* utility.library */

		#if defined(PROTO_UTILITY_H) | defined(_PROTO_UTILITY_H)
			UtilityBase = FeelinBase->Utility;

			#ifdef __amigaos4__
			IUtility = FeelinBase->I_Utility;
			#endif

			DEBUG_FCT(("UtilityBase (%08lx)\n", UtilityBase));
		#endif

	#endif

	return F_QUERY_CALL(Which);
}
//+

/************************************************************************************************
*** AmigaOS 4 IFace *****************************************************************************
************************************************************************************************/

#ifdef __amigaos4__

/*** Manager Interface *************************************************************************/

///_manager_Obtain
STATIC int32 _manager_Obtain(struct LibraryManagerInterface *Self)
{
	return ++Self->Data.RefCount;
}
//+
///_manager_Release
STATIC uint32 _manager_Release(struct LibraryManagerInterface *Self)
{
	return --Self->Data.RefCount;
}
//+

///lib_manager_vectors
/* Manager interface vectors */
STATIC CONST APTR lib_manager_vectors[] =
{
	_manager_Obtain,
	_manager_Release,
	NULL,
	NULL,
	lib_open,
	lib_close,
	lib_expunge,
	NULL,
	(APTR)-1
};
//+
///lib_managerTags
/* "__library" interface tag list */
STATIC CONST struct TagItem lib_managerTags[] =
{
	{ MIT_Name,        (Tag)"__library"         },
	{ MIT_VectorTable, (Tag)lib_manager_vectors },
	{ MIT_Version,     1                        },
	{ TAG_DONE,        0                        }
};
//+

/*** Library Interface(s) **********************************************************************/

///_FeelinClass_Obtain
uint32 _FeelinClass_Obtain(struct FeelinClassIFace *Self)
{
	/* Increment the reference count and return it */
	Self->Data.RefCount++;
	return Self->Data.RefCount;
}
//+
///_FeelinClass_Release
uint32 _FeelinClass_Release(struct FeelinClassIFace *Self)
{
	/* Decrement reference count */
	Self->Data.RefCount--;

	/* Self-destruction on the last Release() call: */
	if (Self->Data.RefCount == 0)
	{
		Self->Expunge();
		return 0;
	}

	/* This is usually only required for non-permanent interfaces.*/
	return Self->Data.RefCount;
}
//+

extern const APTR lib_func_table[];

///mainTags
STATIC CONST struct TagItem mainTags[] =
{
	{ MIT_Name,        (Tag)"main"              },
	{ MIT_VectorTable, (Tag)lib_func_table      },
	{ MIT_Version,     1                        },
	{ TAG_DONE,        0                        }
};
//+
///libInterfaces
STATIC CONST CONST_APTR libInterfaces[] =
{
	lib_managerTags,
	mainTags,
	NULL
};
//+

///libCreateTags
CONST struct TagItem libCreateTags[] =
{
	{ CLT_DataSize,    sizeof(struct in_ClassBase)  },
	{ CLT_InitFunc,    (Tag)lib_init                },
	{ CLT_Interfaces,  (Tag)libInterfaces           },
	{ TAG_DONE,         0                           }
};
//+

#endif

/************************************************************************************************
*** Functions Table *****************************************************************************
************************************************************************************************/

///lib_func_table
const APTR lib_func_table[] =
{
#ifdef __MORPHOS__

	(APTR) FUNCARRAY_BEGIN,
	(APTR) FUNCARRAY_32BIT_NATIVE,

#endif

#ifdef __amigaos4__

	_FeelinClass_Obtain,
	_FeelinClass_Release,
	NULL,
	NULL,

#else

	lib_open,
	lib_close,
	lib_expunge,

#endif

	lib_reserved,

	lib_query,

	(APTR) -1

#ifdef __MORPHOS__

	,(APTR) FUNCARRAY_END

#endif
};
//+

#ifndef __amigaos4__

#if defined(__MORPHOS__) || defined(__AROS__)

#define lib_init_data                           NULL

#else

static const struct FeelinLID lib_init_data =
{
	0xA0,  8, NT_LIBRARY, 0,
	0x80, 10, (STRPTR) &feelin_auto_class_name,
	0xA0, 14, LIBF_SUMUSED|LIBF_CHANGED, 0,
	0x90, 20, F_CLASS_VERSION,
	0x90, 22, F_CLASS_REVISION,
	0x80, 24, (STRPTR) &feelin_auto_class_id,

	0
};

#endif /* __MORPHOS__ || __AROS__ */

const uint32 lib_init_table[4] =
{
   (uint32) sizeof (struct in_ClassBase),
   (uint32) lib_func_table,
   (uint32) &lib_init_data,
   (uint32) lib_init
};

#endif

