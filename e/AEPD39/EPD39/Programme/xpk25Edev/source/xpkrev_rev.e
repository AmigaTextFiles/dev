-> Bumpee revision bump module. Do not alter this file manually.

OPT MODULE
OPT EXPORT
OPT PREPROCESS

/*
BUMP
  NAME=xpkrev
  VERSION=1
  REVISION=0
ENDBUMP
*/

CONST VERSION=1
CONST REVISION=0

CONST VERSION_DAY=19
CONST VERSION_MONTH=1
CONST VERSION_YEAR=96

#define VERSION_STRING {version_string}
#define VERSION_INFO {version_info}

PROC dummy() IS NIL

version_string:
CHAR '$VER: '
version_info:
CHAR 'xpkrev 1.0 (19.1.96)',0
