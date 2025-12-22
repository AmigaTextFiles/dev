OPT MODULE
OPT EXPORT
MODULE 'dos/dos'

-> Objects
ENUM  VDO_FILEINFO=1, VDO_EXTERNALARGS

-> Commands for binary modules
ENUM  VDCMD_READ=1, VDCMD_DELETE, VDCMD_WRITE, VDCMD_INFO,
      VDCMD_EXECUTE, VDCMD_EDIT

-> Returncodes for binary modules.
ENUM  VDRC_SAVED_IN_NOTE=1, VDRC_SAVED, VDRC_IOERROR, VDRC_MULTIFILES,
      VDRC_NOTSAVED

-> Versatile command tags
ENUM  VDT_TRIM=1, VDT_WRAP, VDT_READFILE=10, VDT_WRITEFILE

ENUM  VDREQ_SIMPLE=1, VDREQ_WINDOW, VDREQ_FILE, VDREQ_MULTIFILE

CONST ITEMS=50

OBJECT vdExternalArgs
  finf:PTR TO vdFileInfo
  command
  rc

  intuitionbase     ->Library bases, ALLWAYS NILCHECK before usage.
  gfxbase
  reqtoolsbase
  diskfontbase
  localebase
  viewdizbase

  reserved1
  reserved2
ENDOBJECT

OBJECT vdFileInfo
  filename
  fib:PTR TO fileinfoblock
  cfg:PTR TO vdConfig
  configitem
  xpk
  reserved1
  reserved2
ENDOBJECT

OBJECT vdWizard
  command
  arguments
  seglist
ENDOBJECT

OBJECT vdModule
  module
  flags
  item
  default
  pattern
  filetype
  seglist
ENDOBJECT

OBJECT vdConfig
  editor, edargs,
  tabu,
  descfile, desclock,

  module[50]:ARRAY OF vdModule
  wizard[20]:ARRAY OF vdWizard

  reserved1
  reserved2
ENDOBJECT

OBJECT vdModuleArgs
  file
  cmd
  desc
  finf
ENDOBJECT
