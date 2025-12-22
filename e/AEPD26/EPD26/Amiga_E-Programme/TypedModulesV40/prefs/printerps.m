OPT MODULE
OPT EXPORT

MODULE 'devices/timer',
       'dos/dos',
       'exec/libraries',
       'exec/lists',
       'exec/nodes',
       'exec/ports',
       'exec/semaphores',
       'exec/tasks'

OBJECT process
  task:tc
  msgport:mp
  pad:INT
  seglist:LONG
  stacksize:LONG
  globvec:LONG
  tasknum:LONG
  stackbase:LONG
  result2:LONG
  currentdir:LONG
  cis:LONG
  cos:LONG
  consoletask:LONG
  filesystemtask:LONG
  cli:LONG
  returnaddr:LONG
  pktwait:LONG
  windowptr:LONG
  homedir:LONG
  flags:LONG
  exitcode:LONG
  exitdata:LONG
  arguments:PTR TO CHAR
  localvars:mlh
  shellprivate:LONG
  ces:LONG
ENDOBJECT     /* SIZEOF=228 */

CONST PRB_FREESEGLIST=0,
      PRF_FREESEGLIST=1,
      PRB_FREECURRDIR=1,
      PRF_FREECURRDIR=2,
      PRB_FREECLI=2,
      PRF_FREECLI=4,
      PRB_CLOSEINPUT=3,
      PRF_CLOSEINPUT=8,
      PRB_CLOSEOUTPUT=4,
      PRF_CLOSEOUTPUT=16,
      PRB_FREEARGS=5,
      PRF_FREEARGS=$20

OBJECT filehandle
  link:PTR TO mn
  interactive:PTR TO mp
  type:PTR TO mp
  buf:LONG
  pos:LONG
  end:LONG
  funcs:LONG
  func2:LONG
  func3:LONG
  args:LONG
  arg2:LONG
ENDOBJECT     /* SIZEOF=44 */

OBJECT dospacket
  link:PTR TO mn
  port:PTR TO mp
-> a) next is unioned with "action:LONG"
  type:LONG
-> a) next is unioned with "status:LONG"
  res1:LONG
-> a) next is unioned with "status2:LONG"
  res2:LONG
-> a) next is unioned with "bufaddr:LONG"
  arg1:LONG
  arg2:LONG
  arg3:LONG
  arg4:LONG
  arg5:LONG
  arg6:LONG
  arg7:LONG
ENDOBJECT     /* SIZEOF=48 */

OBJECT standardpacket
  msg:mn
  pkt:dospacket
ENDOBJECT     /* SIZEOF=68 */

CONST ACTION_NIL=0,
      ACTION_ST