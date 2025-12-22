OPT OSVERSION=37

MODULE 'asl',
       'diskfont',
       'graphics/text',
       'libraries/asl',
       'tools/easygui',
       '*fonts',
       '*text_plug'

ENUM ERR_NONE, ERR_ASL, ERR_FONT, ERR_LIB

RAISE ERR_ASL  IF AllocAslRequest()=NIL,
      ERR_FONT IF OpenDiskFont()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL

PROC main() HANDLE
  DEF fr=NIL:PTR TO fontrequester, font=NIL, a:PTR TO text_plug,
      b:PTR TO text_plug, c:PTR TO text_plug, d:PTR TO text_plug
  getdeffonts()
  aslbase:=OpenLibrary('asl.library', 37)
  diskfontbase:=OpenLibrary('diskfont.library', 37)
  fr:=AllocAslRequest(ASL_FONTREQUEST,
          [ASLFO_INITIALNAME,   'topaz.font',
           ASLFO_INITIALSIZE,   9,
           ASLFO_INITIALFLAGS,  FONF_STYLES,
           ASLFO_INITIALHEIGHT, 200,
           NIL])
  IF AslRequest(fr, NIL)
    font:=OpenDiskFont(fr.attr)
    easygui('Test Text PLUGIN',
           [ROWS,
             [PLUGIN, NIL, NEW a.create('Default Fixed Width',
                                        'Default Text Font:', 1)],
             [PLUGIN, NIL, NEW b.create('Selected Font',
                                        'Default:', 0, font)],
             [PLUGIN, NIL, NEW c.create('Fixed',
                                        'Selected:', 0, NIL, font)],
             [PLUGIN, NIL, NEW d.create('Selected',
                                        'Both:', 0, font, font)],
             [BUTTON, NIL, 'Quit']
           ])
  ENDIF
EXCEPT DO
  IF font THEN CloseFont(font)
  IF fr THEN FreeAslRequest(fr)
  IF aslbase THEN CloseLibrary(aslbase)
  IF diskfontbase THEN CloseLibrary(diskfontbase)
  freedeffonts()
  SELECT exception
  CASE ERR_ASL;  WriteF('Error: Could not allocate ASL request\n')
  CASE ERR_LIB;  WriteF('Error: Could not open ASL library\n')
  ENDSELECT
ENDPROC
