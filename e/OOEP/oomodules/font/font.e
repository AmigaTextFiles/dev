OPT MODULE
OPT EXPORT

MODULE 'graphics/text', 'diskfont', 'libraries/diskfont'

/*

11-3-95: Fast ack of the font object 'afont'. Just opens a diskfont and
         closes it in END. seems to run...

*/

OBJECT afont
  tattr:textattr
  font:PTR TO textfont
ENDOBJECT

CONST ON_DISK=0,IN_RAM=1

/*
NAME

  open of font

SYNOPSIS

  open(name,size,flag=ON_DISK)

DESCRIPTION

  Opens the font of the given name and size. By now only fonts on disk
  are opened, therefore flag has to be ON_DISK.

NOTE

  If the diskfont library isn't open already it opens it.
  If a font is open it is closed first.

SEE ALSO

  OpenDiskFont()
*/

PROC open(name,size,flag=ON_DISK) OF afont

  IF diskfontbase=NIL THEN diskfontbase:=OpenLibrary('diskfont.library', 39)
  IF diskfontbase=NIL THEN Raise("LIB")

  IF flag = ON_DISK
    IF self.font THEN CloseFont(self.font)

    self.tattr.name := name
    self.tattr.ysize := size

    self.font := OpenDiskFont(self.tattr)
  ENDIF

ENDPROC self.font

/*
NAME

  end of font

DESCRIPTION

  Closes library and font if open.
*/
PROC end() OF afont
  CloseLibrary(diskfontbase)
  IF self.font THEN CloseFont(self.font)
ENDPROC
