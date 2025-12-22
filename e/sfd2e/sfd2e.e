
MODULE 'smartlib/utils'
MODULE 'smartlib/scanners'

OBJECT sfd_parser OF scan_handle
ENDOBJECT

DEF case
DEF basename
DEF offset
DEF version

DEF result
DEF formals[16]:LIST

PROC force_definition() OF sfd_parser
  LOOP
    IF self.is_char_raw("=")
      self.force_char("=")
      IF self.is_word('base')
        IF self.is_char_raw("_") THEN self.force_raw()
        self.force_name()
        self.force_case()
        basename:=str_dup(self.item)
        PrintF('\n')
        PrintF('OPT MODULE\n')
        PrintF('OPT EXPORT\n\n')
        PrintF('DEF \s\n\n',basename)
        self.force_eol()
      ELSEIF self.is_word('bias')
        self.force_long()
        offset:=-self.long
        self.force_eol()
      ELSEIF self.is_word('reserve')
        self.force_long()
        offset:=offset-(self.long*6)
        self.force_eol()
      ELSEIF self.is_word('version')
        self.force_long()
        IF self.long>version
          IF version>0 THEN RETURN
        ENDIF
        self.force_eol()
      ELSEIF self.is_word('varargs')
        self.force_eol()
        self.skip()
        self.force_char_raw("\n")
        WHILE self.is_raw(" ") OR self.is_raw("\t")
          self.skip()
          self.force_char_raw("\n")
        ENDWHILE
        self.is_blank()
      ELSEIF self.is_word('end')
        RETURN
      ELSE
        self.skip()
        self.force_eol()
      ENDIF
    ELSEIF self.is_char_raw("*")
      self.skip()
      self.force_eol()
    ELSE
      self.force_function()
      self.force_eol()
      offset:=offset-6
    ENDIF
  ENDLOOP
ENDPROC
PROC force_function() OF sfd_parser
  DEF n
  IF self.is_word('VOID')
    result:=FALSE
  ELSE
    self.force_type()
    result:=TRUE
  ENDIF
  PrintF('PROC ')
  self.force_name()
  self.force_case()
  PrintF(self.item)
  n:=0
  self.force_char("("); PrintF('(')
  WHILE self.is_char(")")=0
    IF n>0
      self.force_char(",")
      self.is_eol()
      PrintF(',')
    ENDIF
    self.force_formal()
    self.force_case()
    PrintF(self.item)
    formals[n]:=str_dup(self.item)
    INC n
  ENDWHILE
  PrintF(')\n')
  n:=0
  self.force_char_raw("(");
  WHILE self.is_char_raw(")")=0
    IF n>0 THEN self.force_char_raw(",")
    IF self.is_char_raw("d")
      PrintF('  MOVE.L  \s,D',formals[n])
    ELSEIF self.is_char_raw("a")
      PrintF('  MOVEA.L \s,A',formals[n])
    ENDIF
    self.force_raw()
    self.force_long()
    PrintF('\d\n',self.long)
    INC n
  ENDWHILE
  IF basename=NIL THEN self.error('unknown library base',0)
  PrintF('  MOVEA.L \s,A6\n',basename)
  PrintF('  JSR     \d(A6)\n',offset)
  IF result
    PrintF('  TST.L   D0\n')
    PrintF('ENDPROC D0\n')
  ELSE
    PrintF('ENDPROC\n')
  ENDIF
ENDPROC
PROC force_type() OF sfd_parser
  IF self.is_word('struct')
    self.force_name()
    self.force_char("*")
  ELSE
    self.force_name()
    self.is_char("*")
  ENDIF
  self.is_char("*")
ENDPROC
PROC force_formal() OF sfd_parser
  DEF item[80]:STRING
  IF self.is_word('const')
  ELSEIF self.is_word('CONST')
  ENDIF
  IF self.is_word('struct')
    self.force_name()
    self.force_char("*")
  ELSE
    self.force_name()
    self.is_char("*")
    IF self.is_char("(")
      self.force_char("*")
      self.force_name()
      StrCopy(item,self.item)
      self.force_char(")")
      self.force_char("(")
      IF self.is_char(")")
      ELSE
        self.force_type()
        self.force_name()
        WHILE TRUE
          EXIT self.is_char(")")
          self.force_char(",")
          self.force_type()
          self.force_name()
        ENDWHILE
      ENDIF
      AstrCopy(self.item,item)
      RETURN
    ENDIF
  ENDIF
  self.is_char("*")
  self.force_name()
ENDPROC
PROC force_case() OF sfd_parser
  IF case=0 THEN LowerStr(self.item)
ENDPROC

PROC main()
  DEF myargs[3]:LIST,rdargs
  DEF sfd:PTR TO sfd_parser
  rdargs:=ReadArgs('SFD=FILE/A,CASE/S,VERSION/N',myargs,NIL)
  IF rdargs
    case:=myargs[1]
    IF myargs[2] THEN version:=Long(myargs[2])
    NEW sfd.create(myargs[0])
    sfd.force_definition()
    END sfd
  ELSE
    WriteF('Bad Args!\n')
  ENDIF
ENDPROC

CHAR '$VER: sfd2e 1.0 (14.05.2004) Copyright © Damien Guichard',0


