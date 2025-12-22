OPT PREPROCESS

MODULE '*paths', 'dos/dos'

OBJECT pathlist
  next -> BPTR TO pathlist
  lock -> BPTR TO filelock
ENDOBJECT

PROC main()
  DEF path=NIL:PTR TO pathlist
  IF path := BADDR(getpath()) THEN listpathlist(path)
  freepathlist(path)
ENDPROC

PROC listpathlist(next:PTR TO pathlist)
  DEF str[4096]:STRING
  WHILE next
    IF NameFromLock(next.lock, str, 4096) THEN PutStr(str) AND PutStr('\n')
    next := BADDR(next.next)
  ENDWHILE
ENDPROC
