#ifndef SYSTEM_MODULES_H
#define SYSTEM_MODULES_H TRUE

/*
**  $VER: modules.h V1.2
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**
*/

#ifndef DPKERNEL_H
#include <dpkernel/dpkernel.h>
#endif

#ifndef SYSTEM_GLOBALBASE_H
#include <system/globalbase.h>
#endif

/*****************************************************************************
** Module Object.
*/

#define VER_MODULE  2
#define TAGS_MODULE ((ID_SPCTAGS<<16)|ID_MODULE)

struct Module {
  struct Head Head;              /* [00] Standard header */
  WORD   Number;                 /* [12] Number of the associated module */
  APTR   ModBase;                /* [14] Ptr to function jump table */
  struct Segment *Segment;       /* [18] Segment pointer */
  WORD   TableType;              /* [22] Type of table */
  WORD   e01;                    /* [24] */
  struct Function *FunctionList; /* [26] Array of functions */
  LONG   MinVersion;             /* [30] Minimum required ver. of the module */
  LONG   MinRevision;            /* [34] Minimum required rev. of the module */
  LONG   e02;                    /* [38] */
  BYTE   *Name;                  /* [42] Name of the module */
  struct ModPublic *Public;      /* [46] Shared details on the module */

  /*** Private Variables ***/

  APTR   prvMBMemory;            /* Module base memory */
};

struct Function {
  APTR Address;
  BYTE *Name;
};

#define MODA_Number      (12|TWORD)
#define MODA_TableType   (22|TWORD)
#define MODA_MinVersion  (30|TLONG)
#define MODA_MinRevision (34|TLONG)
#define MODA_Name        (42|TAPTR)

/*****************************************************************************
** Table-Type definitions.
*/

#define JMP_DEFAULT 1  /* LVO jump type (standard) */
#define JMP_AMIGAE  2  /* Amiga E jump table */

#define JMP_LIBRARY JMP_AMIGAE
#define JMP_LVO     JMP_DEFAULT

/*****************************************************************************
** Module file header.
*/

#define MODULE_HEADER_V1 0x4D4F4401

struct ModHeader {
  LONG Version;
  LIBPTR LONG (*Init)(mreg(__a0) struct Module *, mreg(__a1) APTR DPKBase,
               mreg(__a2) struct GVBase *, mreg(__d0) LONG dpkVersion,
               mreg(__d1) LONG dpkRevision);
  LIBPTR void (*Close)(mreg(__a0) struct Module *);
  LIBPTR LONG (*Expunge)(void);
  WORD  LVOType;         /* Type of function table to generate for our own use */
  WORD  prvEmpty;        /* */
  BYTE  *Author;         /* Author of the module */
  struct Function *DefaultList;   /* Pointer to default function list */
  LONG  CPUNumber;       /* CPU that this module is compiled for */
  LONG  ModVersion;      /* Version of this module */
  LONG  ModRevision;     /* Revision of this module */
  LONG  MinDPKVersion;   /* Minimum DPK version required */
  LONG  MinDPKRevision;  /* Minimum DPK revision required */
  LIBPTR LONG (*Open)(mreg(__a0) struct Module *);
  APTR  prvModBaseEmpty; /* Generated function base for given CPU */
  BYTE  *Copyright;      /* Copyright details */
  BYTE  *Date;           /* Date of compilation */
  BYTE  *Name;           /* Name of the module */
  WORD  DPKTable;        /* Type of function table to get from DPK */
  WORD  emp;             /* Reserved */
};

/*****************************************************************************
** This shared module structure is built during the initialisation process
** and placed in Module->Public.
*/

struct ModPublic {
  WORD  Version;
  WORD  OpenCount;      /* Amount of programs with this module open */
  LIBPTR LONG (*Init)(mreg(__a0) struct Module *, mreg(__a1) APTR DPKBase,
               mreg(__a2) struct GVBase *, mreg(__d0) LONG dpkVersion,
               mreg(__d1) LONG dpkRevision);
  LIBPTR void (*Close)(mreg(__a0) struct Module *);
  LIBPTR LONG (*Expunge)(void);
  LIBPTR LONG (*Open)(mreg(__a0) struct Module *);
  LONG  CPU;            /* CPU that this module is compiled for */
  LONG  ModVersion;     /* Version of this module */
  LONG  ModRevision;    /* Revision of this module */
  BYTE  *Author;        /* Author of the module */
  BYTE  *Copyright;     /* Copyright details */
  BYTE  *Date;          /* Date of compilation */
  BYTE  *Name;          /* Name of the module */
  struct ModHeader *Table; /* Type of function table to get from DPK */
};

/*****************************************************************************
** This structure is 100% private to the dpkernel.
*/

struct ModEntry {
  struct ModEntry  *Next;     /* Next module in list */
  struct ModEntry  *Prev;     /* Previous module in list */
  struct Segment   *Segment;  /* Module segment */
  struct ModHeader *Header;   /* Pointer to module header */
  WORD   ModuleID;            /* Module ID */
  WORD   BaseType;            /* The type of PersonalBase (eg JMP_LVO) */
  BYTE   *Name;               /* Name of the module */
  struct ModPublic *Public;   /* Remember the details for the expunge */
  APTR   PersonalBase;        /* Module's personal base structure */
  APTR   PBMemory;            /* PersonalBase memory allocation */
};

struct LVOFunction {
  WORD Jump;
  LONG Code;
};

/****************************************************************************/

#define CPU_68000  1
#define CPU_68010  2
#define CPU_68020  3
#define CPU_68030  4
#define CPU_68040  5
#define CPU_68060  6

#endif /* SYSTEM_MODULES_H */

