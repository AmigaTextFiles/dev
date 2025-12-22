-> compleximage.e - Program to show the use of a complex Intuition Image.

OPT OSVERSION=37  -> E-Note: silently require V37

MODULE 'exec/memory',
       'intuition/intuition',
       'intuition/screens'

ENUM ERR_NONE, ERR_SCRN, ERR_WIN

RAISE ERR_SCRN IF OpenScreenTagList()=NIL,
      E