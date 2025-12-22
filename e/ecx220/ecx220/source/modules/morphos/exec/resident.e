OPT MODULE
OPT EXPORT

MODULE 'utility/tagitem'

-> Added some MorphOS extensions (LS)

OBJECT rt
  matchword:INT  -> This is unsigned
  matchtag:PTR TO rt
  endskip:LONG
  flags:CHAR
  version:CHAR
  type:CHAR
  pri:CHAR  -> This is signed
  name:PTR TO CHAR
  idstring:PTR TO CHAR
  init:LONG
  /* following only if RTF_EXTENDED */
  revision:WORD
  tags:PTR TO tagitem
ENDOBJECT     /* SIZEOF=26 */

CONST RTC_MATCHWORD=$4AFC,
      RTF_COLDSTART=1,
      RTF_SINGLETASK=2,
      RTF_AFTERDOS=4,
      RTF_AUTOINIT=$80,
      RTW_NEVER=0,
      RTW_COLDSTART=1,
      /* extensions */
      RTF_PPC=8,
      RTF_EXTENDED=64

