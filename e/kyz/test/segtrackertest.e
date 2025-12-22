MODULE '*segtracker'

PROC main()
  DEF name[80]:STRING, segname, hunk, offset

  IF segtracker()
    Forbid()
      segname, hunk, offset := findseg({main})
      StrCopy(name, segname)
    Permit()
    Vprintf('I am segment "\s" hunk \d offset \d.\n', [name, hunk, offset])
  ELSE
    PutStr('SegTracker not available.\n')
  ENDIF
ENDPROC
