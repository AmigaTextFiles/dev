MODULE  'dos/var','dos/dos','dos/rdargs','dos/dostags',
        'utility/tagitem','utility','utility/hooks'

PROC main()
  DEF cmd[256]:STRING, rc=FALSE, out

  IF out:=Open('t:test', NEWFILE)
    StringF( cmd, 'execute /env/viewdiz/modules/.getdrawer'  )

    IF SystemTagList( cmd, [SYS_OUTPUT, out, NP_SYNCHRONOUS, TRUE, TAG_DONE] )=0
      rc:=TRUE
    ENDIF
  Close(out)
  ENDIF
ENDPROC
