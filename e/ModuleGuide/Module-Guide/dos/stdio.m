@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}no
w showing: "dos/stdio.m"@{fg text}

NOTE: don't use this output in your code, use the module instead.

CONST DOS_STDIO_I=1,
      BUF_FULL=1,
      BUF_NONE=2,
      ENDSTREAMCH=-1,
      BUF_LINE=0

#define WriteStr/1
#define ReadChars/2
#define UnReadChar/1
#define WriteChar/1
#define ReadChar/0
#define ReadLn/2
#define Vwritef/2
@endnode
