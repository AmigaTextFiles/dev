


MODULE 'reqtools','libraries/reqtools','dos/dos','utility/tagitem',
       'grio/partutils'

PROC main()

DEF mod[120]:STRING,file[34]:STRING,dir[108]:STRING,
    filereq:PTR TO rtfilerequester,rf,ez

IF KickVersion(37)

  IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))
     IF (filereq:=RtAllocRequestA(RT_FILEREQ,0))
        StrCopy(dir,'emodules:',STRLEN)
        IF arg[]
           StrAdd(dir,pathpart(arg),ALL)
           StrCopy(file,filepart(arg),ALL)
        ENDIF
        RtChangeReqAttrA(filereq,[RTFI_DIR,dir,RTFI_MATCHPAT,'#?.m',TAG_END])
fuck:
        rf:=RtFileRequestA(filereq,file,'Select Emodule ...',
        [RTFI_FLAGS,FREQF_PATGAD,RT_REQPOS,REQPOS_POINTER,TAG_DONE])
        IF rf=0
            WriteF('Canceled...\n')
            JUMP end
        ENDIF

        StrCopy(dir,filereq.dir,ALL)

        addpart(dir,file,108)

        StringF(mod,'E:Bin/ShowModule \s',dir)

        SystemTagList(mod,NIL)
     ENDIF
     IF (ez:=RtEZRequestA('Once again ?','_Yes|_No',NIL,NIL,
        [RT_UNDERSCORE,"_",RT_REQPOS,REQPOS_POINTER,TAG_DONE])
        )=0 THEN JUMP end ELSE JUMP fuck
  ELSE
        WriteF('Unable to open reqtools.library v38!\n')
  ENDIF
ELSE
   WriteF('Os 2.04 or greater required!\n')
ENDIF
end:

 IF filereq THEN RtFreeRequest(filereq)
 IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)

ENDPROC


