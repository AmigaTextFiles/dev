
/* bootname.e */

MODULE	'dos/dos','exec/memory'

PROC main()

DEF myinfo:PTR TO fileinfoblock,success
   
      myinfo := NewM(SIZEOF fileinfoblock,MEMF_CLEAR)

       IF success := Examine(0,myinfo) THEN WriteF('\s\n',myinfo.filename)

      Dispose(myinfo)
ENDPROC
