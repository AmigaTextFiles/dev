OPT MODULE

MODULE  '*screenobject'
MODULE  '*reqtypes'
MODULE  'reqtools'
MODULE  'asl'
MODULE  'graphics/displayinfo'
MODULE  'libraries/asl'
MODULE  'libraries/reqtools'

EXPORT PROC screenmoderequest(title,type,sd:PTR TO screenobj)   -> ScreenDate (sd)
 DEF    smr=NIL:PTR TO screenmoderequester,
        req=NIL:PTR TO rtscreenmoderequester
  IF type=TYPE_REQTOOLS
   IF (reqtoolsbase:=OpenLibrary('reqtools.library',37))
    IF (req:=RtAllocRequestA(RT_SCREENMODEREQ,0))
     RtScreenModeRequestA(req,title,[RTSC_FLAGS,
                SCREQF_SIZEGADS         OR 
                SCREQF_OVERSCANGAD      OR
                SCREQF_DEPTHGAD         ])
         sd.width:=req.displaywidth
        sd.height:=req.displayheight
       sd.depth:=req.displaydepth
      sd.displayid:=req.displayid
     RtFreeRequest(req)
    ENDIF
   CloseLibrary(reqtoolsbase)
   ELSE 
    JUMP asl
   ENDIF
  ELSE
   asl:
    IF (aslbase:=OpenLibrary('asl.library', 38))
     smr:=AllocAslRequest(ASL_SCREENMODEREQUEST, NIL)
      AslRequest(smr,     [ASLSM_DOOVERSCANTYPE,   TRUE,
                           ASLSM_DOAUTOSCROLL,     TRUE,
                           ASLSM_TITLETEXT,        title,
                           ASLSM_DODEPTH,          TRUE,
                           ASLSM_DOWIDTH,          TRUE,
                           ASLSM_DOHEIGHT,         TRUE])
      IF smr<>NIL
       sd.width:=smr.displaywidth
        sd.height:=smr.displayheight
         sd.depth:=smr.displaydepth
        sd.displayid:=smr.displayid
       FreeAslRequest(smr)
      ENDIF
     CloseLibrary(aslbase)
    ENDIF
  ENDIF
ENDPROC FALSE

