#ifndef LIBRARIES_PATCH_H
#define LIBRARIES_PATCH_H
/*****************************************************************************/
/*
**	$Filename: libraries/patch.h $
**	$Release: 1.0 Includes $
**	$Date: 93/03/23 $
**
**	definition of patch.library public structures and returncodes
**
**	(C) Copyright 1993 Stefan Fuchs
**	All Rights Reserved
*/
/*****************************************************************************/

#ifndef	EXEC_TYPES_H
#include <exec/types.h>
#endif


#define	PatchName "patch.library"

/* Structure required to install new patches via patch.library/InstallPatch() */
struct NewPatch
{
	APTR	NPAT_NewCode;		/* pointer to the patch code to be installed */
	ULONG	NPAT_NewCodeSize;	/* optional length of NPAT_NewCode in bytes  */
	APTR	NPAT_LibraryName;	/* pointer to the LibraryName                */
	UWORD	NPAT_LibVersion;	/* version of Library to open                */
	WORD	NPAT_LVO;		/* LVO of function to patch                  */
	WORD	NPAT_Priority;		/* Priority (-127...+126) of the patch       */
	UWORD	NPAT_Flags;		/* currently none defined (keep zero)        */
	APTR	NPAT_PatchName;		/* optional pointer to an IDString           */
	APTR	NPAT_Result2;		/* optional pointer to longword for Result2  */
};


/* ErrorCodes */
#define PATERR_Ok		0	/* Everything Ok                    */
#define PATERR_PatchInUse	1	/* Patch Usecount <> 0              */
#define PATERR_OutOfMem		3	/* Out of memory                    */
#define PATERR_OpenLib		4	/* Failed to open requested library */
#define PATERR_FuncNotStd	5	/* Function to patch is not in the standard format */
#define PATERR_PatchInstalled	6	/* Can't remove patch because another program has  */
					/* installed a non-patch.library patch later       */

#endif	/* LIBRARIES_PATCH_H */
