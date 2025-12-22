MODULE 'exec/memory',
       'intuition/intuition','intuition/screens',
       'graphics/text','graphics/view'

CONST NUMIMAGE=4,IMAGEDATASIZE=2*16*2,SCROLLSPEED=1

ENUM ER_NONE,ER_NOSCRN,ER_NOMEM

DEF s=NIL,w=NIL:PTR TO window,sprite=NIL,imagedata=NIL

PROC setupimages()
  IF (imagedata:=AllocVec(NUMIMAGE*IMAGEDATASIZE,
                          MEMF_CHIP OR MEMF_CLEAR))=NIL THEN Raise(ER_NOMEM)
  CopyMemQuick([$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
                $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
                $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,
                $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,

                $FFFF,$FFFF,$C003,$C003,$C003,$C003,$C3C3,$C3C3,
                $C3C3,$C3C3,$C003,$C003,$C003,$C003,$FFFF,$FFFF,
                $0000,$0000,$0000,$0000,$0000,$0000,$03C0,$03C0,
                $03C0,$03C0,$0000,$0000,$0000,$0000,$0000,$0000,

                $0000,$0000,$0000,$0000,$0000,$0000,$03C0,$03C0,
                $03C0,$03C0,$0000,$0000,$0000,$0000,$0000,$0000,
                $FFFF,$FFFF,$C003,$C003,$C003,$C003,$C003,$C003,
                $C003,$C003,$C003,$C003,$C003,$C003,$FFFF,$FFFF,

                $FFFF,$FFFF,$C003,$C003,$C003,$C003,$C003,$C003,
                $C003,$C003,$C003,$C003,$C003,$C003,$FFFF,$FFFF,
                $FFFF,$FFFF,$C003,$C003,$C003,$C003,$C3C3,$C3C3,
                $C3C3,$C3C3,$C003,$C003,$C003,$C003,$FFFF,$FFFF]:INT,
                imagedata,NUMIMAGE*IMAGEDATASIZE)
ENDPROC

PROC setupscreen()
  CloseWorkBench()
  IF (s:=OpenScreenTagList(NIL,
    [SA_WIDTH,784,SA_HEIGHT,200,SA_DEPTH,2,SA_DISPLAYID,0,
     SA_QUIET,TRUE,SA_FONT,['topaz.font',8,0,0]:textattr,
     SA_OVERSCAN,OSCAN_TEXT,
     0,0]))=NIL THEN Raise(ER_NOSCRN)
  IF (w:=OpenWindowTagList(NIL,
    [WA_LEFT,0,WA_TOP,0,WA_WIDTH,784,WA_HEIGHT,256,
     WA_IDCMP,0,
     WA_FLAGS,WFLG_SIMPLE_REFRESH OR WFLG_NOCAREREFRESH OR
              WFLG_BORDERLESS OR WFLG_ACTIVATE OR WFLG_RMBTRAP,
     WA_CUSTOMSCREEN,s,
     WA_MOUSEQUEUE,0,WA_RPTQUEUE,0,
     0,0]))=NIL THEN Raise(ER_NOSCRN)
  IF sprite:=AllocMem(20,MEMF_CHIP OR MEMF_CLEAR)
    SetPointer(w,sprite,1,16,0,0)
  ENDIF
  LoadRGB4(ViewPortAddress(w),
           [$000,$F00,$0F0,$FF0]:INT,16)
ENDPROC

PROC shutdown()
  IF w THEN CloseWindow(w)
  IF sprite THEN FreeMem(sprite,20)
  IF s THEN CloseScreen(s)
  IF imagedata THEN FreeVec(imagedata)
  OpenWorkBench()
ENDPROC

PROC scroll()
  DEF vp:PTR TO viewport,bigx,smallx,tile,imagenum,i,r,ypos
  r:=w.rport
  vp:=s+44
  REPEAT
    FOR bigx:=0 TO 384 STEP 16
      IF Mouse()
        Raise(ER_NONE)
      ENDIF
      FOR smallx:=0 TO 15 STEP SCROLLSPEED
        PutInt(vp.rasinfo+8,32+bigx+smallx)
        ScrollVPort(vp)
        WaitTOF()
        FOR tile:=0 TO SCROLLSPEED-1
          IF smallx+tile<12
            imagenum:=Rnd(NUMIMAGE)
            ypos:=smallx+tile*16
            i:=[0,0,16,16,1,imagenum*IMAGEDATASIZE+imagedata,3,0,NIL]:image
            DrawImage(r,i,bigx,ypos)
            DrawImage(r,i,bigx+400,ypos)
          ENDIF
        ENDFOR
      ENDFOR
    ENDFOR
  UNTIL FALSE
ENDPROC

PROC main() HANDLE
  setupimages()
  setupscreen()
  scroll()
  Raise(ER_NONE)
EXCEPT
  shutdown()
  IF exception<>ER_NONE THEN WriteF('Il y a eu une erreur.\n')
ENDPROC
