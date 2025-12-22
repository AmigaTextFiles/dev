-> arq.e converted from arq.h by Arne Meyer <q09883@pbhrzx.uni-paderborn.de>

OPT MODULE
OPT EXPORT

MODULE 'intuition/intuition'

CONST ARQ_MAGIC       = $6D6A6C21

CONST ARQ_ID_INFO     = 0,
      ARQ_ID_DISK     = 1,
      ARQ_ID_DELETE   = 2,
      ARQ_ID_GURU     = 3,
      ARQ_ID_RWERROR  = 4,
      ARQ_ID_WPROTECT = 5,
      ARQ_ID_PRINTER  = 6,
      ARQ_ID_QUESTION = 7,
      ARQ_ID_EXCLAM   = 8,

      ARQ_ID_IMAGE    = -1,
      ARQ_ID_ANIM     = -2

OBJECT exteasystruct
        image:PTR TO image
        sound                 ->:CHAR
        animid:INT
        flags:INT
        magic:LONG
        reserved[3]:ARRAY OF LONG
        easy:easystruct
ENDOBJECT
/*
OBJECT easystruct
  structsize:LONG
  flags:LONG
  title:LONG
  textformat:LONG
  gadgetformat:LONG
ENDOBJECT     /* SIZEOF=20 */
*/
