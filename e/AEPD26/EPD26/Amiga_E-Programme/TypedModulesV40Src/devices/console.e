OPT MODULE
OPT EXPORT

MODULE 'exec/ports',
       'graphics/gfx',
       'utility/tagitem'

CONST FS_NORMAL=0,
      FSB_UNDERLINED=0,
      FSF_UNDERLINED=1,
      FSB_BOLD=1,
      FSF_BOLD=2,
      FSB_ITALIC=2,
      FSF_ITALIC=4,
      FSB_EXTENDED=3,
      FSF_EXTENDED=8,
      FSB_COLORFONT=6,
      FSF_COLORFONT=$40,
      FSB_TAGGED=7,
      FSF_TAGGED=$80,
      FPB_ROMFONT=0,
      FPF_ROMFONT=1,
      FPB_DISKFONT=1,
      FPF_DISKFONT=2,
      FPB_REVPATH=2,
      FPF_REVPATH=4,
      FPB_TALLDOT=3,
      FPF_TALLDOT=8,
      FPB_WIDEDOT=4,
      FPF_WIDEDOT=16,
      FPB_PROPORTIONAL=5,
      FPF_PROPORTIONAL=$20,
      FPB_DESIGNED=6,
      FPF_DESIGNED=$40,
      FPB_REMOVED=7,
      FPF_REMOVED=$80

OBJECT textattr
  name:LONG
  ysize:INT  -> This is unsigned
  style:CHAR
  flags:CHAR
ENDOBJECT     /* SIZEOF=8 */

OBJECT ttextattr
  name:LONG
  ysize:INT  -> This is unsigned
  style:CHAR
  flags:CHAR
  tags:PTR TO tagitem
ENDOBJECT     /* SIZEOF=12 */

CONST TA_DEVICEDPI=$80000001,
      MAXFONTMATCHWEIGHT=$7FFF

OBJECT textfont
  mn:mn
  ysize:INT  -> This is unsigned
  style:CHAR
  flags:CHAR
  xsize:INT  -> This is unsigned
  baseline:INT  -> This is unsigned
  boldsmear:INT  -> This is unsigned
  accessors:INT  -> Thi