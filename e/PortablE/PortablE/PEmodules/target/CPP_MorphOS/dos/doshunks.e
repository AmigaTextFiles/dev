/* $VER: doshunks.h 36.9 (2.6.1992) */
OPT NATIVE
{#include <dos/doshunks.h>}
NATIVE {DOS_DOSHUNKS_H} CONST

CONST EXT_COMMONDEF = 4

/* hunk types */
NATIVE {HUNK_UNIT}	CONST HUNK_UNIT	= 999
NATIVE {HUNK_NAME}	CONST HUNK_NAME	= 1000
NATIVE {HUNK_CODE}	CONST HUNK_CODE	= 1001
NATIVE {HUNK_DATA}	CONST HUNK_DATA	= 1002
NATIVE {HUNK_BSS}	CONST HUNK_BSS	= 1003
NATIVE {HUNK_RELOC32}	CONST HUNK_RELOC32	= 1004
NATIVE {HUNK_ABSRELOC32}	CONST HUNK_ABSRELOC32	= HUNK_RELOC32
NATIVE {HUNK_RELOC16}	CONST HUNK_RELOC16	= 1005
NATIVE {HUNK_RELRELOC16}	CONST HUNK_RELRELOC16	= HUNK_RELOC16
NATIVE {HUNK_RELOC8}	CONST HUNK_RELOC8	= 1006
NATIVE {HUNK_RELRELOC8}	CONST HUNK_RELRELOC8	= HUNK_RELOC8
NATIVE {HUNK_EXT}	CONST HUNK_EXT	= 1007
NATIVE {HUNK_SYMBOL}	CONST HUNK_SYMBOL	= 1008
NATIVE {HUNK_DEBUG}	CONST HUNK_DEBUG	= 1009
NATIVE {HUNK_END}	CONST HUNK_END	= 1010
NATIVE {HUNK_HEADER}	CONST HUNK_HEADER	= 1011

NATIVE {HUNK_OVERLAY}	CONST HUNK_OVERLAY	= 1013
NATIVE {HUNK_BREAK}	CONST HUNK_BREAK	= 1014

NATIVE {HUNK_DREL32}	CONST HUNK_DREL32	= 1015
NATIVE {HUNK_DREL16}	CONST HUNK_DREL16	= 1016
NATIVE {HUNK_DREL8}	CONST HUNK_DREL8	= 1017

NATIVE {HUNK_LIB}	CONST HUNK_LIB	= 1018
NATIVE {HUNK_INDEX}	CONST HUNK_INDEX	= 1019

/*
 * Note: V37 LoadSeg uses 1015 (HUNK_DREL32) by mistake.  This will continue
 * to be supported in future versions, since HUNK_DREL32 is illegal in load files
 * anyways.  Future versions will support both 1015 and 1020, though anything
 * that should be usable under V37 should use 1015.
 */
NATIVE {HUNK_RELOC32SHORT} CONST HUNK_RELOC32SHORT = 1020

/* see ext_xxx below.  New for V39 (note that LoadSeg only handles RELRELOC32).*/
NATIVE {HUNK_RELRELOC32}	CONST HUNK_RELRELOC32	= 1021
NATIVE {HUNK_ABSRELOC16}	CONST HUNK_ABSRELOC16	= 1022

/*
 * Any hunks that have the HUNKB_ADVISORY bit set will be ignored if they
 * aren't understood.  When ignored, they're treated like HUNK_DEBUG hunks.
 * NOTE: this handling of HUNKB_ADVISORY started as of V39 dos.library!  If
 * lading such executables is attempted under <V39 dos, it will fail with a
 * bad hunk type.
 */
NATIVE {HUNKB_ADVISORY}	CONST HUNKB_ADVISORY	= 29
NATIVE {HUNKB_CHIP}	CONST HUNKB_CHIP	= 30
NATIVE {HUNKB_FAST}	CONST HUNKB_FAST	= 31
NATIVE {HUNKF_ADVISORY}	CONST HUNKF_ADVISORY	= $20000000
NATIVE {HUNKF_CHIP}	CONST HUNKF_CHIP	= $40000000
NATIVE {HUNKF_FAST}	CONST HUNKF_FAST	= $80000000


/* hunk_ext sub-types */
NATIVE {EXT_SYMB}	CONST EXT_SYMB	= 0	/* symbol table */
NATIVE {EXT_DEF}		CONST EXT_DEF		= 1	/* relocatable definition */
NATIVE {EXT_ABS}		CONST EXT_ABS		= 2	/* Absolute definition */
NATIVE {EXT_RES}		CONST EXT_RES		= 3	/* no longer supported */
NATIVE {EXT_REF32}	CONST EXT_REF32	= 129	/* 32 bit absolute reference to symbol */
NATIVE {EXT_ABSREF32}	CONST EXT_ABSREF32	= EXT_REF32
NATIVE {EXT_COMMON}	CONST EXT_COMMON	= 130	/* 32 bit absolute reference to COMMON block */
NATIVE {EXT_ABSCOMMON}	CONST EXT_ABSCOMMON	= EXT_COMMON
NATIVE {EXT_REF16}	CONST EXT_REF16	= 131	/* 16 bit PC-relative reference to symbol */
NATIVE {EXT_RELREF16}	CONST EXT_RELREF16	= EXT_REF16
NATIVE {EXT_REF8}	CONST EXT_REF8	= 132	/*  8 bit PC-relative reference to symbol */
NATIVE {EXT_RELREF8}	CONST EXT_RELREF8	= EXT_REF8
NATIVE {EXT_DEXT32}	CONST EXT_DEXT32	= 133	/* 32 bit data relative reference */
NATIVE {EXT_DEXT16}	CONST EXT_DEXT16	= 134	/* 16 bit data relative reference */
NATIVE {EXT_DEXT8}	CONST EXT_DEXT8	= 135	/*  8 bit data relative reference */

/* These are to support some of the '020 and up modes that are rarely used */
NATIVE {EXT_RELREF32}	CONST EXT_RELREF32	= 136	/* 32 bit PC-relative reference to symbol */
NATIVE {EXT_RELCOMMON}	CONST EXT_RELCOMMON	= 137	/* 32 bit PC-relative reference to COMMON block */

/* for completeness... All 680x0's support this */
NATIVE {EXT_ABSREF16}	CONST EXT_ABSREF16	= 138	/* 16 bit absolute reference to symbol */

/* this only exists on '020's and above, in the (d8,An,Xn) address mode */
NATIVE {EXT_ABSREF8}	CONST EXT_ABSREF8	= 139	/* 8 bit absolute reference to symbol */
