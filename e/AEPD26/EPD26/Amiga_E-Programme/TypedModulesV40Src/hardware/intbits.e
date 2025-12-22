RRT_FILE=3,
      RRT_HOST=4,
      RRT_CLIP=5,
      GLOBALSZ=$C8

OBJECT rexxtask
  global[$C8]:ARRAY
  msgport:mp
  flags:CHAR
  sigbit:CHAR  -> This is signed
  clientid:LONG
  msgpkt:LONG
  taskid:LONG
  port:LONG
  errtrap:LONG
  stackptr:LONG
  header1:lh
  header2:lh
  header3:lh
  header4:lh
  header5:lh
ENDOBJECT     /* SIZEOF=330 */

CONST ENVLIST=$104,
      FREELIST=$112,
      MEMLIST=$120,
      FILELIST=$12E,
      PORTLIST=$13C,
      NUMLISTS=5,
      RTFB_TRACE=0,
      RTFB_HALT=1,
      RTFB_SUSP=2,
      RTFB_TCUSE=3,
      RTFB_WAIT=6,
      RTFB_CLOSE=7,
      MEMQUANT=16,
      MEMMASK=-16,
      MEMQUICK=1,
      MEMCLEAR=$10000

OBJECT srcnode
  succ:PTR TO srcno