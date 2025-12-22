OPT REG=1

MODULE 'filevirus', 'libraries/filevirus', 'utility/tagitem'

DEF fvn:PTR TO filevirusnode
DEF fvi:PTR TO filevirusinfo
DEF filevirusbase:PTR TO filevirusbase
DEF s[10]:STRING


PROC main()

DEF x:REG

IF filevirusbase:=OpenLibrary('filevirus.library',0)
  fvn:=FvAllocNode()
  IF fvn<>0
    WriteF('Known virii : \d\n',filevirusbase.fb_vinfototal)
    
      fvi:=FvShowFVInfo(fvn)
    
      REPEAT
        x:=fvi.fvi_type
        SELECT x
          CASE FV_LINK
            StrCopy(s,'link')
          CASE FV_DELETE
            StrCopy(s,'delete')
          CASE FV_RENAME
            StrCopy(s,'rename')
          CASE FV_CODE
            StrCopy(s,'code')
          CASE FV_OVERLAY
            StrCopy(s,'overlay')
          DEFAULT
            StrCopy(s,'unknown')
        ENDSELECT
      
        WriteF('\d[4] \l\s[40] \s\n',fvn.fv_vinfocount,fvi.fvi_name,s)
        fvi:=FvShowNextFVInfo(fvn)
      UNTIL fvi=0
    
      FvFreeNode(fvn)
  ENDIF
  
  CloseLibrary(filevirusbase)
ELSE
  WriteF('couldnt open library\n')
ENDIF

ENDPROC
