#ifndef LIBRARIES_DILPLUGIN_H
#define LIBRARIES_DILPLUGIN_H

/*
**
**	$VER: dilpluin.h 1.2 (01.10.2008)
**
**	DIL plugin structures and definitions
**
**	©2004-2009 Rupert Hausberger
**	All Rights Reserved
**
*/

#ifndef EXEC_LIBRARIES_H
   #include <exec/libraries.h>
#endif /* EXEC_LIBRARIES_H */

#ifndef EXEC_EXECBASE_H
   #include <exec/execbase.h>
#endif /* EXEC_EXECBASE_H */

#ifndef DEVICES_DIL_H
   #include <devices/dil.h>
#endif /* DEVICES_DIL_H */

#ifndef DOS_DOS_H
   #include <dos/dos.h>
#endif /* DOS_DOS_H */

#if defined(__GNUC__)
   #pragma pack(2)
#endif

/***************************************************************************/
/* Info tags */

#define DILI_TAGBASE        (TAG_USER | (0x03021976 << 16))

/* Basic */
#define DILI_Name           (DILI_TAGBASE | 0x1001) /* Optional, short name */
#define DILI_Description    (DILI_TAGBASE | 0x1002) /* Optional, description or long name */
#define DILI_Warning        (DILI_TAGBASE | 0x1003) /* Optional, a warning  */

/* VerRev */
#define DILI_Version        (DILI_TAGBASE | 0x2001) /* MANDATORY, version */
#define DILI_Revision       (DILI_TAGBASE | 0x2002) /* MANDATORY, revision */
#define DILI_OS             (DILI_TAGBASE | 0x2003) /* Optional,  "MorphOS" or "AmigaOS3" */
#define DILI_CodeType       (DILI_TAGBASE | 0x2004) /* Optional,  "PPC" or "68K" */
#define DILI_SaneID         (DILI_TAGBASE | 0x2005) /* MANDATORY, the sane-id, see dil.h (1.1) */

/* Preferences */
#define DILI_Intervention   (DILI_TAGBASE | 0x3001) /* MANDATORY, plugin does intervene? */
#define DILI_GenerateSeed   (DILI_TAGBASE | 0x3002) /* MANDATORY, generate a seed? */
#define DILI_SeedDIL        (DILI_TAGBASE | 0x3003) /* Optional,  generate a DIL-seed? (1.2) */
#define DILI_SeedSHA        (DILI_TAGBASE | 0x3004) /* Optional,  generate a SHA-seed? (1.2) */

/* Author */
#define DILI_Author         (DILI_TAGBASE | 0x4001) /* Optional, name <mail> of the author */
#define DILI_Copyright      (DILI_TAGBASE | 0x4002) /* Optional, copyright */
#define DILI_License        (DILI_TAGBASE | 0x4003) /* Optional, type of license */
#define DILI_URL            (DILI_TAGBASE | 0x4004) /* Optional, uRL of the plugin or author */

/***************************************************************************/
/* Plugin flags */

/* p_Flags - bit definitions */
#define DILB_READ           0
#define DILB_DECRYPT        DILB_READ
#define DILB_WRITE          1
#define DILB_ENCRYPT        DILB_WRITE
#define DILB_INTERVENTION   16
#define DILB_GENERATESEED   17
#define DILB_SEEDDIL        18 /* (1.2) */
#define DILB_SEEDSHA        19 /* (1.2) */

/* p_Flags - flags */
#define DILF_READ           (1ul << DILB_READ)
#define DILF_DECRYPT        DILF_READ
#define DILF_WRITE          (1ul << DILB_WRITE)
#define DILF_ENCRYPT        DILF_WRITE
#define DILF_INTERVENTION   (1ul << DILB_INTERVENTION)
#define DILF_GENERATESEED   (1ul << DILB_GENERATESEED)
#define DILF_SEEDDIL        (1ul << DILB_SEEDDIL) /* (1.2) */
#define DILF_SEEDSHA        (1ul << DILB_SEEDSHA) /* (1.2) */

/***************************************************************************/
/* Plugin structure */

typedef struct DILPlugin
{
   DILParams               *p_Params;      /* See <devices/dil.h> */

   APTR                     p_Source;      /* Pointer to the src-buffer */
   APTR                     p_Destination; /* Pointer to the dst-buffer,
                                              NULL if not DILF_INTERVENTION */

   UBYTE                   *p_Seed;        /* Pointer to the seed-buffer,
                                              NULL if not DILF_GENERATESEED
                                              512 bytes if DILF_SEEDDIL
                                               32 bytes if DILF_SEEDSHA */
   ULONG                    p_SeedLen;     /* Seed length in bytes */

   ULONG                    p_Block;       /* Current block (Logical Block Address (LBA)) */
   ULONG                    p_Blocks;      /* Number of blocks, each is "p_Params->p_DosEnvec.de_SizeBlock << 2" bytes long */

   ULONG                    p_Flags;       /* Flags (DILF_#?) */
   APTR                     p_User;        /* Free for private use */
} DILPlugin;

/***************************************************************************/
/* Base structure */

struct DILPluginBase
{
   struct Library           lib_LibNode;
   BPTR                     lib_SegList;
   struct ExecBase         *lib_SysBase;
   struct DosLibrary       *lib_DOSBase;
   struct Library          *lib_UtilityBase;
};

/***************************************************************************/

#if defined(__GNUC__)
   #pragma pack()
#endif

#endif /* LIBRARIES_DILPLUGIN_H */

