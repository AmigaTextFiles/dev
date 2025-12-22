/* ScrollerWindow.e

   Traduit par Wouter de l'excellent exemple scrollerwindow.c
   par Christoph Feck, TowerSystems (feck@informatik.uni-kl.de)

   a besoin du E v2.1b / v39 emodules avec icclass.m corrigé pour compiler

*/

MODULE 'exec/memory', 'exec/libraries', 'utility', 'utility/tagitem',
       'intuition/intuition', 'intuition/imageclass', 'intuition/screens',
       'intuition/classes', 'intuition/icclass', 'intuition/gadgetclass',
       'intuition/imageclass',
       'graphics/gfx', 'graphics/text', 'graphics/rastport'

DEF screen:PTR TO screen,dri:PTR TO drawinfo,v39,bitmap:PTR TO bitmap

DEF horizgadget:PTR TO object,vertgadget:PTR TO object,
    leftgadget:PTR TO object,rightgadget:PTR TO object,
    upgadget:PTR TO object,downgadget:PTR TO object

ENUM HORIZ_GID=1,VERT_GID,LEFT_GID,RIGHT_GID,UP_GID,DOWN_GID

DEF window:PTR TO window

-> ils sont aussi des PTR TO object too

DEF sizeimage:PTR TO image,leftimage:PTR TO image,rightimage:PTR TO image,
    upimage:PTR TO image,downimage:PTR TO image

DEF htotal,vtotal,hvisible,vvisible

PROC max(x,y) IS IF x>y THEN x ELSE y
PROC min(x,y) IS IF x<y THEN x ELSE y
PROC rassize(w,h) IS Shr(w+15,3) AND $FFFE * h

PROC createbitmap(width,height,depth,flags,friend:PTR TO bitmap)
  DEF bm:PTR TO bitmap,memflags,pl:PTR TO LONG,i
  IF v39
    bm:=AllocBitMap(width,height,depth,flags,friend)
  ELSE
    memflags:=MEMF_CHIP
    IF bm:=New(SIZEOF bitmap)
      InitBitMap(bm,depth,width,height)
      pl:=bm.planes
      IF flags AND BMF_CLEAR THEN memflags:=memflags OR MEMF_CLEAR
      pl[0]:=AllocVec(depth*rassize(width,height),memflags)
      IF pl[0]
        FOR i:=1 TO depth-1 DO pl[i]:=pl[i-1]+rassize(width,height)
      ELSE
        Dispose(bm)
      ENDIF
    ENDIF
  ENDIF
ENDPROC bm

PROC deletebitmap(bm:PTR TO bitmap)
  IF bm
    IF v39
      FreeBitMap(bm)
     ELSE
       FreeVec(Long(bm.planes))
       Dispose(bm)
     ENDIF
  ENDIF
ENDPROC

PROC bitmapdepth(bm:PTR TO bitmap) IS
  IF v39 THEN GetBitMapAttr(bm,BMA_DEPTH) ELSE bm.depth

PROC sysisize() IS
 IF screen.flags AND SCREENHIRES THEN SYSISIZE_MEDRES ELSE SYSISIZE_LOWRES

PROC newimageobject(which) IS
  NewObjectA(NIL,'sysiclass',
    [SYSIA_DRAWINFO,dri,SYSIA_WHICH,which,SYSIA_SIZE,sysisize(),NIL])

PROC newpropobject(freedom,taglist) IS
  NewObjectA(NIL,'propgclass',
    [ICA_TARGET,ICTARGET_IDCMP,PGA_FREEDOM,freedom,PGA_NEWLOOK,TRUE,
     PGA_BORDERLESS,(dri.flags AND DRIF_NEWLOOK) AND (dri.depth<>1),
     TAG_MORE,taglist])

PROC newbuttonobject(image:PTR TO object,taglist) IS
  NewObjectA(NIL,'buttongclass',
    [ICA_TARGET,ICTARGET_IDCMP,GA_IMAGE,image,TAG_MORE,taglist])

PROC openscrollerwindow(taglist)
  DEF resolution,topborder,sf:PTR TO textattr,w,h,bw,bh,rw,rh,gw,gh,gap
  resolution:=sysisize()
  sf:=screen.font
  topborder:=screen.wbortop+sf.ysize+1
  w:=sizeimage.width
  h:=sizeimage.height
  bw:=IF resolution=SYSISIZE_LOWRES THEN 1 ELSE 2
  bh:=IF resolution=SYSISIZE_HIRES THEN 2 ELSE 1
  rw:=IF resolution=SYSISIZE_HIRES THEN 3 ELSE 2
  rh:=IF resolution=SYSISIZE_HIRES THEN 2 ELSE 1
  gh:=max(leftimage.height,h)
  gh:=max(rightimage.height,gh)
  gw:=max(upimage.width,w)
  gw:=max(downimage.width,gw)
  gap:=1
  horizgadget:=newpropobject(FREEHORIZ,
    [GA_LEFT,rw+gap,
     GA_RELBOTTOM,bh-gh+2,
     GA_RELWIDTH,(-gw)-gap-leftimage.width-rightimage.width-rw-rw,
     GA_HEIGHT,gh-bh-bh-2,
     GA_BOTTOMBORDER,TRUE,
     GA_ID,HORIZ_GID,
     PGA_TOTAL,htotal,
     PGA_VISIBLE,hvisible,
     NIL])
  vertgadget:=newpropobject(FREEVERT,
    [GA_RELRIGHT,bw-gw+3,
     GA_TOP,topborder+rh,
     GA_WIDTH,gw-bw-bw-4,
     GA_RELHEIGHT,(-topborder)-h-upimage.height-downimage.height-rh-rh,
     GA_RIGHTBORDER,TRUE,
     GA_PREVIOUS,horizgadget,
     GA_ID,VERT_GID,
     PGA_TOTAL,vtotal,
     PGA_VISIBLE,vvisible,
     NIL])
  leftgadget:=newbuttonobject(leftimage,
    [GA_RELRIGHT,(1)-leftimage.width-rightimage.width-gw,
     GA_RELBOTTOM,(1)-leftimage.height,
     GA_BOTTOMBORDER,TRUE,
     GA_PREVIOUS,vertgadget,
     GA_ID,LEFT_GID,
     NIL])
  rightgadget:=newbuttonobject(rightimage,
    [GA_RELRIGHT,(1)-rightimage.width-gw,
     GA_RELBOTTOM,(1)-rightimage.height,
     GA_BOTTOMBORDER,TRUE,
     GA_PREVIOUS,leftgadget,
     GA_ID,RIGHT_GID,
     NIL])
  upgadget:=newbuttonobject(upimage,
    [GA_RELRIGHT,(1)-upimage.width,
     GA_RELBOTTOM,(1)-upimage.height-downimage.height-h,
     GA_RIGHTBORDER,TRUE,
     GA_PREVIOUS,rightgadget,
     GA_ID,UP_GID,
     NIL])
  downgadget:=newbuttonobject(downimage,
    [GA_RELRIGHT,(1)-downimage.width,
     GA_RELBOTTOM,(1)-downimage.height-h,
     GA_RIGHTBORDER,TRUE,
     GA_PREVIOUS,upgadget,
     GA_ID,DOWN_GID,
     NIL])
  IF downgadget
    window:=OpenWindowTagList(NIL,
      [WA_GADGETS,horizgadget,
       WA_MINWIDTH,max(80,gw+gap+leftimage.width+rightimage.width+rw+rw+KNOBHMIN),
       WA_MINHEIGHT,max(50,topborder+h+upimage.height+downimage.height+rh+rh+KNOBVMIN),
       TAG_MORE,taglist])
  ENDIF
ENDPROC

PROC closescrollerwindow()
  IF window THEN CloseWindow(window)
  DisposeObject(horizgadget)
  DisposeObject(vertgadget)
  DisposeObject(leftgadget)
  DisposeObject(rightgadget)
  DisposeObject(upgadget)
  DisposeObject(downgadget)
ENDPROC

PROC recalchvisible() IS window.width-window.borderleft-window.borderright
PROC recalcvvisible() IS window.height-window.bordertop-window.borderbottom

PROC updateprop(gadget:PTR TO object,attr,value)
  SetGadgetAttrsA(gadget,window,NIL,[attr,value,NIL])
ENDPROC

PROC copybitmap()
  DEF srcx,srcy
  GetAttr(PGA_TOP,horizgadget,{srcx})
  GetAttr(PGA_TOP,vertgadget,{srcy})
  BltBitMapRastPort(bitmap,srcx,srcy,window.rport,window.borderleft,
    window.bordertop,min(htotal,hvisible),min(vtotal,vvisible),$C0)
ENDPROC

PROC updatescrollerwindow()
  hvisible:=recalchvisible()
  updateprop(horizgadget,PGA_VISIBLE,hvisible)
  vvisible:=recalcvvisible()
  updateprop(vertgadget,PGA_VISIBLE,vvisible)
  copybitmap()
ENDPROC

PROC handlescrollerwindow()
  DEF imsg:PTR TO intuimessage,quit=FALSE,oldtop,cl,v
  WHILE quit=FALSE
    WHILE (quit=FALSE) AND (imsg:=GetMsg(window.userport))
      cl:=imsg.class
      SELECT cl
        CASE IDCMP_CLOSEWINDOW
          quit:=TRUE
        CASE IDCMP_NEWSIZE
          updatescrollerwindow()
        CASE IDCMP_REFRESHWINDOW
          BeginRefresh(window)
          copybitmap()
          EndRefresh(window,TRUE)
        CASE IDCMP_IDCMPUPDATE
          v:=GetTagData(GA_ID,0,imsg.iaddress)
          SELECT v
            CASE HORIZ_GID
              copybitmap()
            CASE VERT_GID
              copybitmap()
            CASE LEFT_GID
              GetAttr(PGA_TOP,horizgadget,{oldtop})
              IF oldtop>0
                updateprop(horizgadget,PGA_TOP,oldtop-1)
                copybitmap()
              ENDIF
            CASE RIGHT_GID
              GetAttr(PGA_TOP,horizgadget,{oldtop})
              IF oldtop<(htotal-hvisible)
                updateprop(horizgadget,PGA_TOP,oldtop+1)
                copybitmap()
              ENDIF
            CASE UP_GID
              GetAttr(PGA_TOP,vertgadget,{oldtop})
              IF oldtop>0
                updateprop(vertgadget,PGA_TOP,oldtop-1)
                copybitmap()
              ENDIF
            CASE DOWN_GID
              GetAttr(PGA_TOP,vertgadget,{oldtop})
              IF oldtop<(vtotal-vvisible)
                updateprop(vertgadget,PGA_TOP,oldtop+1)
                copybitmap()
              ENDIF
          ENDSELECT
      ENDSELECT
      ReplyMsg(imsg)
    ENDWHILE
    IF quit=FALSE THEN WaitPort(window.userport)
  ENDWHILE
ENDPROC

PROC doscrollerwindow()
  DEF r:PTR TO rastport
  IF screen:=LockPubScreen(NIL)
    hvisible:=htotal:=screen.width
    vvisible:=vtotal:=screen.height
    r:=screen.rastport
    IF bitmap:=createbitmap(htotal,vtotal,bitmapdepth(r.bitmap),0,r.bitmap)
      BltBitMap(r.bitmap,0,0,bitmap,0,0,htotal,vtotal,$C0,-1,NIL)
      IF dri:=GetScreenDrawInfo(screen)
        sizeimage:=newimageobject(SIZEIMAGE)
        leftimage:=newimageobject(LEFTIMAGE)
        rightimage:=newimageobject(RIGHTIMAGE)
        upimage:=newimageobject(UPIMAGE)
        downimage:=newimageobject(DOWNIMAGE)
        IF (sizeimage<>0) AND (leftimage<>0) AND (rightimage<>0) AND (upimage<>0) AND (downimage<>0)
          openscrollerwindow([WA_PUBSCREEN,screen,
            WA_TITLE,'ScrollerWindow',
            WA_FLAGS,WFLG_CLOSEGADGET OR WFLG_SIZEGADGET OR WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_SIMPLE_REFRESH OR WFLG_ACTIVATE OR WFLG_NEWLOOKMENUS,
            WA_IDCMP,IDCMP_CLOSEWINDOW OR IDCMP_NEWSIZE OR IDCMP_REFRESHWINDOW OR IDCMP_IDCMPUPDATE,
            WA_INNERWIDTH,htotal,
            WA_INNERHEIGHT,vtotal,
            WA_MAXWIDTH,-1,
            WA_MAXHEIGHT,-1,
            NIL])
          IF window
            updatescrollerwindow()
            handlescrollerwindow()
          ELSE
            WriteF('no window!\n')
          ENDIF
          closescrollerwindow()
        ELSE
          WriteF('no images!\n')
        ENDIF
        DisposeObject(sizeimage)
        DisposeObject(leftimage)
        DisposeObject(rightimage)
        DisposeObject(upimage)
        DisposeObject(downimage)
        FreeScreenDrawInfo(screen,dri)
      ELSE
        WriteF('Pas d'infos sur le tracé!\n')
      ENDIF
      WaitBlit()
      deletebitmap(bitmap)
    ELSE
      WriteF('Pas de bitmap!\n')
    ENDIF
    UnlockPubScreen(NIL,screen)
  ELSE
    WriteF('Pas d'écran public!\n')
  ENDIF
ENDPROC

PROC main()
  v39:=KickVersion(39)
  IF utilitybase:=OpenLibrary('utility.library',37)
    doscrollerwindow()
    CloseLibrary(utilitybase)
  ENDIF
ENDPROC
