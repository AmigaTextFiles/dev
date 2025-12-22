@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/nodes.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT mln
@{fg shine}(   0)@{fg text}   succ:PTR TO mln
@{fg shine}(   4)@{fg text}   pred:PTR TO mln
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

@{fg shine}(----)@{fg text} OBJECT ln
@{fg shine}(   0)@{fg text}   succ:PTR TO ln
@{fg shine}(   4)@{fg text}   pred:PTR TO ln
@{fg shine}(   8)@{fg text}   type:CHAR
@{fg shine}(   9)@{fg text}   pri:CHAR
@{fg shine}(  10)@{fg text}   name:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=14 */

CONST NT_FONT=12,
      NT_MSGPORT=4,
      NT_BOOTNODE=16,
      NT_KICKMEM=17,
      NT_TASK=1,
      NT_EXTENDED=$FF,
      NT_SEMAPHORE=14,
      NT_SOFTINT=11,
      NT_LIBRARY=9,
      NT_GRAPHICS=18,
      NT_REPLYMSG=7,
      NT_USER=$FE,
      NT_INTERRUPT=2,
      NT_DEVICE=3,
      NT_UNKNOWN=0,
      NT_PROCESS=13,
      NT_SIGNALSEM=15,
      NT_FREEMSG=6,
      NT_DEATHMESSAGE=19,
      NT_MESSAGE=5,
      NT_MEMORY=10,
      NT_RESOURCE=8
@endnode
