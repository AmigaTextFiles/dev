/*
** WADDir
**
** Shows all the lumps in a given .WAD
**
** WARNING: The commercial wads contain bloody loads of lumps, and WADDir
** has been known to crash if you leave it for too long on a commercial one.
*/

MODULE 'doomwad'

PROC main()
  DEF mwh:PTR TO wadhandle, mdb:dirblock, c
  
  /* No wad specified? */
  IF(StrCmp(arg,''))
    WriteF('WADdir ©1998 Mr Tickle/dNT\n\nUsage: WADdir <filename>.WAD\n')
  ELSE
  
    /* Open the wad */
    IF(mwh:=openwad(arg))
      
      /* Tell the user what sort of wad it is ... */
      WriteF('It is')
      IF(mwh.iwad=FALSE) THEN WriteF('n\at')
      WriteF(' an IWAD\n')
      
      /* ... how many lumps it has ... */
      WriteF('Number of lumps: \d\n',mwh.numlumps)
      
      /* ... where the directory is and ... */
      WriteF('Dir is at: \h\n',mwh.dirstrt)
      
      /* All the lumps :) */
      WriteF('\nDirectory:\n')
      
      /* Loop through all the lumps */
      FOR c:=0 TO mwh.numlumps-1
      
        /* Read entry C into mdb */
        readentry(c*16,mwh,mdb)
        
        /* If its size is larger than 0, its a proper lump, otherwise its
        ** just a level marker */
        
        IF(mdb.size>0)
          WriteF('\l\s[8]  \r\z\h[8]  \z\h[8]\n',mdb.name,mdb.offset,mdb.size)
        ELSE
          WriteF('  \e[32m\s\e[0m\n',mdb.name)
        ENDIF
        
        /* Check for CtrlC() */
        IF(CtrlC())
          WriteF('***BREAK\n')
          c:=mwh.numlumps-1
        ENDIF
      ENDFOR
      
      /* Close the wad */
      closewad(mwh)
    ENDIF
  ENDIF
ENDPROC
