OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE  'exec/libraries'

#define	FILEVIRUSNAME "filevirus.library"


/* --- Library structure --- */

OBJECT filevirusbase
  fb_Lib:lib
  fb_SegList
  fb_Flags
  fb_ExecBase
  fb_VInfoTotal
ENDOBJECT

/* --- Infection subnode --- */

OBJECT fileinfectionnode
  fi_NextNode:PTR TO fileinfectionnode
  fi_VirusName
  fi_NameArray
  fi_Type
  fi_HunkNum
  fi_Private00
ENDOBJECT

/* --- Main structure --- */

OBJECT filevirusnode
  fv_Buffer
  fv_BufferLen
  fv_SpecialId
  fv_FileInfection:PTR TO fileinfectionnode
  fv_Info:PTR TO filevirusinfo
  fv_Status
  fv_VInfoCount
  fv_Data
ENDOBJECT

/* --- Info subnode --- */

OBJECT filevirusinfo
  fvi_Name->:CHAR
  fvi_Type
ENDOBJECT


/* --- Virus types --- */

CONST FV_UNKNOWN	= 0
CONST FV_LINK		= 1	/* Certain hunk(s) must be removed */
CONST FV_DELETE	        = 2	/* File must be deleted */
CONST FV_RENAME	        = 3	/* File must be overwritten with healty file */
CONST FV_CODE		= 4	/* Some code must be removed from hunk */
CONST FV_OVERLAY	= 5	/* Virus in overlay hunk */

/* --- fvCheckFile flags --- */

CONST FVCF_OnlyOne		= 0	/* Stop after the first virus found */
CONST FVCF_NoIntegrity  	= 1	/* Don't perform integrity check before examining the file */

/* --- fvRepairFile flags --- */

CONST FVRF_NoMulti		= 1	/* Don't repair multiple infected hunks */


/* --- Reply/Error classes --- */

/* The reply messages */
CONST	FVMSG_OK		=0	/* No error has occured (you can */
					/* safely assume that this value */
					/* always will remain zero       */
CONST FVMSG_SAVE		=1	/* Infected hunks/code have been */
					/* removed. Save the file.       */
CONST FVMSG_DELETE		=2	/* Delete the file */
CONST FVMSG_RENAME		=3	/* Rename (or delete) the file */

/* The error messages */
CONST FVERRORS	        	=20
CONST FVERR_NoMemory		=20	/* Out of memory */
CONST FVERR_OddBuffer		=21	/* Pointer to buffer is misaligned */
CONST FVERR_EmptyBuffer	        =22	/* Length of buffer is zero */

CONST FVERR_NotExecutable 	=30	/* File is not executable. Files */
					/* that aren't executable cannot */
					/* trigger viruses.              */
CONST FVERR_UnknownHunk 	=31	/* Unknown or unsupported hunk */
CONST FVERR_SizesMismatch	=32	/* Size differs from expected size */
CONST FVERR_UnexpectedHunk	=33	/* Another hunk was expected */

