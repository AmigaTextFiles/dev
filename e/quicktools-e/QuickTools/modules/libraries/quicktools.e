OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'utility/tagitem',
       'exec/semaphores'

#define QUICKTOOLSNAME 'quicktools.library'

CONST QUICKTOOLSVERSION = 2
CONST FILEBUFFERSIZE = 5120

OBJECT qtoolsdata
  datasem:ss
  dirloadsem:ss
  dirdatabuffer:LONG
  dirdatalength:LONG
  qdata:PTR TO LONG
  numdirs:INT
ENDOBJECT

OBJECT parsepathpart
  pp_next:PTR TO parsepathpart
  pp_size:LONG
  pp_root:CHAR
  pp_parsepattern[1]:ARRAY OF CHAR
ENDOBJECT

OBJECT matchdata
  md_scantype:LONG
  md_done:CHAR
  md_curdata:LONG
  md_patterns:PTR TO parsepathpart
  md_searchbuf[32]:ARRAY OF CHAR
  md_curqdata:PTR TO qdata
  md_filehandle:LONG
  md_filebuffer:LONG
  md_numfiles:LONG
ENDOBJECT

#define QUICKTOOLSDIRS 's:QuickTools.Dirs'
#define QUICKTOOLSFILES 's:QuickTools.Files'

OBJECT qdata
  qd_parrid:INT
  qd_useprev:CHAR
  qd_filename[1]:ARRAY OF CHAR
ENDOBJECT

CONST QT_SCAN_FILE = 1
CONST QT_SCAN_DIRECTORY = 2

CONST QT_TagBase   = TAG_USER
CONST QT_ScanType  = QT_TagBase+1
CONST QT_ReqTitle  = QT_TagBase+100
CONST QT_CenterReq = QT_TagBase+101
CONST QT_PubScreen = QT_TagBase+102
