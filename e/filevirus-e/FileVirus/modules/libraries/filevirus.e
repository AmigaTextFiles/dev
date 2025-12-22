OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'exec/libraries'

#define FILEVIRUSNAME 'filevirus.library'

OBJECT filevirusbase
  fb_lib:lib
  fb_seglist:LONG
  fb_flags:LONG
  fb_execbase:LONG
  fb_vinfototal:LONG
ENDOBJECT

OBJECT filevirusnode
  fv_buffer:LONG
  fv_bufferlen:LONG
  fv_specialid:LONG
  fv_fileinfection:PTR TO fileinfectionnode
  fv_info:PTR TO filevirusinfo
  fv_status:LONG
  fv_vinfocount:LONG
  fv_data:LONG
ENDOBJECT

OBJECT fileinfectionnode
  fi_nextnode:PTR TO fileinfectionnode
  fi_virusname:LONG
  fi_namearray:LONG
  fi_type:LONG
  fi_hunknum:LONG
  fi_private00:LONG
ENDOBJECT

OBJECT filevirusinfo
  fvi_name:LONG
  fvi_type:LONG
ENDOBJECT

CONST FV_UNKNOWN = 0
CONST FV_LINK    = 1
CONST FV_DELETE	 = 2
CONST FV_RENAME	 = 3
CONST FV_CODE    = 4
CONST FV_OVERLAY = 5

CONST FVCF_OnlyOne     = 1
CONST FVCF_NoIntegrity = 2
CONST FVRF_NoMulti     = 1

CONST FVMSG_OK     = 0
CONST FVMSG_SAVE   = 1
CONST FVMSG_DELETE = 2
CONST FVMSG_RENAME = 3

CONST FVERRORS             = 20
CONST FVERR_NoMemory       = 20
CONST FVERR_OddBuffer      = 21
CONST FVERR_EmptyBuffer    = 22
CONST FVERR_NotExecutable  = 30
CONST FVERR_UnknownHunk    = 31
CONST FVERR_SizesMismatch  = 32
CONST FVERR_UnexpectedHunk = 33

