OPT MODULE, REG = 5

MODULE 'exec/lists',
       'exec/nodes',
       '*mods/execlists'

EXPORT PROC findpubscreen(scrname)
  DEF pslist, found = FALSE

  IF pslist := LockPubScreenList()
    IF FindName(pslist, scrname) THEN found := TRUE
    UnlockPubScreenList()
  ENDIF
ENDPROC found

EXPORT PROC getscreenlist(screenlist:PTR TO lh)
  DEF pslist:PTR TO lh, psnode:PTR TO ln

  IF pslist := LockPubScreenList()
    psnode := pslist.head

    freeNameNodes(screenlist)
    WHILE psnode.succ
      addName(screenlist, psnode.name)
      psnode := psnode.succ
    ENDWHILE
    UnlockPubScreenList()
  ENDIF
ENDPROC screenlist
