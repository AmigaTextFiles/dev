-> Bumpee revision bump module. Do not alter this file manually.

OPT MODULE
OPT EXPORT
OPT PREPROCESS

/*
BUMP
  NAME=Bumpee
  VERSION=1
  REVISION=44
ENDBUMP
*/

CONST VERSION=1
CONST REVISION=44

CONST VERSION_DAY=6
CONST VERSION_MONTH=1
CONST VERSION_YEAR=95

#define VERSION_STRING {version_string}
#define VERSION_INFO {version_info}

PROC dummy() IS NIL

version_string:
CHAR '$VER: '
version_info:
CHAR 'Bumpee 1.44 (6.1.95)',0
