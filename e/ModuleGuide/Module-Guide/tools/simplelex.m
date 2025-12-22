@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "tools/simplelex.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

/* this module contains 1216 bytes of code! */

/* ... and 2 reloc entries */

PROC lex_current@{fg shine}()@{fg text}
PROC lex_init@{fg shine}(start,size,freeform=0,onelinecomment=-2)@{fg text}
PROC lex_getline@{fg shine}(s)@{fg text}
PROC lex_curline@{fg shine}()@{fg text}
PROC lex@{fg shine}()@{fg text}

/* 6 private global variable@{fg shine}(s)@{fg text} in this module */

CONST LEX_EOF=$100,
      LEX_EOL=$101,
      LEX_IDENT=$103,
      LEX_STRINGA=$104,
      LEX_STRINGQ=$105,
      LEX_INTEGER=$102

/*
  code from module "emodules:tools/ctype.m" used:
    isalnum@{fg shine}()@{fg text}/1 @{fg shine}(1x)@{fg text}
*/
@endnode

