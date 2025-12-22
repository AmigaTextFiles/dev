
MODULE 'exec/memory', 'exec/libraries', 'utility', 'utility/tagitem',
       'intuition/intuition', 'intuition/imageclass', 'intuition/screens',
       'intuition/classes', 'intuition/icclass', 'intuition/gadgetclass',
       'intuition/imageclass','graphics/gfx', 'graphics/text', 'graphics/rastport'

DEF screen:PTR TO Screen,dri:PTR TO DrawInfo,v39,bitmap:PTR TO BitMap
DEF UtilityBase

DEF horizgadget:PTR TO _Object,vertgadget:PTR TO _Object,
    leftgadget:PTR TO _Object,rightgadget:PTR TO _Object,
    upgadget:PTR TO _Object,downgadget:PTR TO _Object

ENUM HORIZ_GID=1,VERT_GID,LEFT_GID,RIGHT_GID,UP_GID,DOWN_GID

DEF window:PTR TO Window

-> these are actually PTR TO object too

DEF sizeimage:PTR TO Image,leftimage:PTR TO Image,rightimage:PTR TO Image,
    upimage:PTR TO Image,downimage:PTR TO Image

DEF htotal,vtotal,hvisible,vvisible

PROC max(x,y) IS IF x>y THEN x ELSE y
PROC min(x,y) IS IF x<y THEN x ELSE y
PROC rassize(w,h) IS Shr(w+15,3) AND $FFFE * h

PROC createbitmap(width,height,depth,flags,friend:PTR TO BitMap)
  DEF bm:PTR TO BitMap,memflags,pl:PTR TO LONG,i
  IF v39
    bm:=AllocBitMap(width,height,depth,flags,friend)
  ELSE
    memflags:=MEMF_CHIP
    IF bm:=New(SIZEOF_BitMap)
      InitBitMap(bm,depth,width,height)
      pl:=bm.Planes
      IF flags AND BMF_CLEAR THEN memflags:=memflags|MEMF_CLEAR
      pl[0]:=AllocVec(depth*rassize(width,height),memflags)
      IF pl[0]
        FOR i:=1 TO depth-1 DO pl[i]:=pl[i-1]+rassize(width,height)
      ELSE
        Dispose(bm)
      ENDIF
    ENDIF
  ENDIF
ENDPROC bm

PROC deletebitmap(bm:PTR TO BitMap)
  IF bm
    IF v39
      FreeBitMap(bm)
     ELSE
       FreeVec(Long(bm.Planes))
       Dispose(bm)
     ENDIF
  ENDIF
ENDPROC

PROC bitmapdepth(bm:PTR TO BitMap) IS
  IF v39 THEN GetBitMapAttr(bm,BMA_DEPTH) ELSE bm.Depth

PROC sysisize() IS
 IF screen.Flags AND SCREENHIRES THEN SYSISIZE_MedRes ELSE SYSISIZE_LowRes

PROC newimageobject(which) IS
  NewObjectA(NIL,'sysiclass',
    [SYSIA_DrawInfo,dri,SYSIA_Which,which,SYSIA_Size,sysisize(),NIL])

PROC newpropobject(freedom,taglist) IS
  NewObjectA(NIL,'propgclass',
    [ICA_TARGET,ICTARGET_IDCMP,PGA_Freedom,freedom,PGA_NewLook,TRUE,
     PGA_Borderless,(dri.Flags AND DRIF_NEWLOOK) AND (dri.Depth<>1),
     TAG_MORE,taglist])

PROC newbuttonobject(image:PTR TO _Object,taglist) IS
  NewObjectA(NIL,'buttongclass',
    [ICA_TARGET,ICTARGET_IDCMP,GA_Image,image,TAG_MORE,taglist])

PROC openscrollerwindow(taglist)
  DEF resolution,topborder,sf:PTR TO TextAttr,w,h,bw,bh,rw,rh,gw,gh,gap
  resolution:=sysisize()
  sf:=screen.Font
  topborder:=screen.WBorTop+sf.YSize+1
  w:=sizeimage.Width
  h:=sizeimage.Height
  bw:=IF resolution=SYSISIZE_LowRes THEN 1 ELSE 2
  bh:=IF resolution=SYSISIZE_HiRes THEN 2 ELSE 1
  rw:=IF resolution=SYSISIZE_HiRes THEN 3 ELSE 2
  rh:=IF resolution=SYSISIZE_HiRes THEN 2 ELSE 1
  gh:=max(leftimage.Height,h)
  gh:=max(rightimage.Height,gh)
  gw:=max(upimage.Width,w)
  gw:=max(downimage.Width,gw)
  gap:=1
  horizgadget:=newpropobject(FREEHORIZ,
    [GA_Left,rw+gap,
     GA_RelBottom,bh-gh+2,
     GA_RelWidth,(-gw)-gap-leftimage.Width-rightimage.Width-rw-rw,
     GA_Height,gh-bh-bh-2,
     GA_BottomBorder,TRUE,
     GA_ID,HORIZ_GID,
     PGA_Total,htotal,
     PGA_Visible,hvisible,
     NIL])
  vertgadget:=newpropobject(FREEVERT,
    [GA_RelRight,bw-gw+3,
     GA_Top,topborder+rh,
     GA_Width,gw-bw-bw-4,
     GA_RelHeight,(-topborder)-h-upimage.Height-downimage.Height-rh-rh,
     GA_RightBorder,TRUE,
     GA_Previous,horizgadget,
     GA_ID,VERT_GID,
     PGA_Total,vtotal,
     PGA_Visible,vvisible,
     NIL])
  leftgadget:=newbuttonobject(leftimage,
    [GA_RelRight,(1)-leftimage.Width-rightimage.Width-gw,
     GA_RelBottom,(1)-leftimage.Height,
     GA_BottomBorder,TRUE,
     GA_Previous,vertgadget,
     GA_ID,LEFT_GID,
     NIL])
  rightgadget:=newbuttonobject(rightimage,
    [GA_RelRight,(1)-rightimage.Width-gw,
     GA_RelBottom,(1)-rightimage.Height,
     GA_BottomBorder,TRUE,
     GA_Previous,leftgadget,
     GA_ID,RIGHT_GID,
     NIL])
  upgadget:=newbuttonobject(upimage,
    [GA_RelRight,(1)-upimage.Width,
     GA_RelBottom,(1)-upimage.Height-downimage.Height-h,
     GA_RightBorder,TRUE,
     GA_Previous,rightgadget,
     GA_ID,UP_GID,
     NIL])
  downgadget:=newbuttonobject(downimage,
    [GA_RelRight,(1)-downimage.Width,
     GA_RelBottom,(1)-downimage.Height-h,
     GA_RightBorder,TRUE,
     GA_Previous,upgadget,
     GA_ID,DOWN_GID,
     NIL])
  IF downgadget
    window:=OpenWindowTagList(NIL,
      [WA_Gadgets,horizgadget,
       WA_MinWidth,max(80,gw+gap+leftimage.Width+rightimage.Width+rw+rw+KNOBHMIN),
       WA_MinHeight,max(50,topborder+h+upimage.Height+downimage.Height+rh+rh+KNOBVMIN),
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

PROC recalchvisible() IS window.Width-window.BorderLeft-window.BorderRight
PROC recalcvvisible() IS window.Height-window.BorderTop-window.BorderBottom

PROC updateprop(gadget:PTR TO _Object,attr,value)
  SetGadgetAttrsA(gadget,window,NIL,[attr,value,NIL])
ENDPROC

PROC copybitmap()
  DEF srcx,srcy
  GetAttr(PGA_Top,horizgadget,&srcx)
  GetAttr(PGA_Top,vertgadget,&srcy)
  BltBitMapRastPort(bitmap,srcx,srcy,window.RPort,window.BorderLeft,
    window.BorderTop,min(htotal,hvisible),min(vtotal,vvisible),$C0)
ENDPROC

PROC updatescrollerwindow()
  hvisible:=recalchvisible()
  updateprop(horizgadget,PGA_Visible,hvisible)
  vvisible:=recalcvvisible()
  updateprop(vertgadget,PGA_Visible,vvisible)
  copybitmap()
ENDPROC

PROC handlescrollerwindow()
  DEF imsg:PTR TO IntuiMessage,quit=FALSE,oldtop,cl,v
  WHILE quit=FALSE
    WHILE (quit=FALSE) AND (imsg:=GetMsg(window.UserPort))
      cl:=imsg.Class
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
          v:=GetTagData(GA_ID,0,imsg.IAddress)
          SELECT v
            CASE HORIZ_GID
              copybitmap()
            CASE VERT_GID
              copybitmap()
            CASE LEFT_GID
              GetAttr(PGA_Top,horizgadget,&oldtop)
              IF oldtop>0
                updateprop(horizgadget,PGA_Top,oldtop-1)
                copybitmap()
              ENDIF
            CASE RIGHT_GID
              GetAttr(PGA_Top,horizgadget,&oldtop)
              IF oldtop<(htotal-hvisible)
                updateprop(horizgadget,PGA_Top,oldtop+1)
                copybitmap()
              ENDIF
            CASE UP_GID
              GetAttr(PGA_Top,vertgadget,&oldtop)
              IF oldtop>0
                updateprop(vertgadget,PGA_Top,oldtop-1)
                copybitmap()
              ENDIF
            CASE DOWN_GID
              GetAttr(PGA_Top,vertgadget,&oldtop)
              IF oldtop<(vtotal-vvisible)
                updateprop(vertgadget,PGA_Top,oldtop+1)
                copybitmap()
              ENDIF
          ENDSELECT
      ENDSELECT
      ReplyMsg(imsg)
    ENDWHILE
    IF quit=FALSE THEN WaitPort(window.UserPort)
  ENDWHILE
ENDPROC

PROC doscrollerwindow()
  DEF r:PTR TO RastPort
  IF screen:=LockPubScreen(NIL)
    hvisible:=htotal:=screen.Width
    vvisible:=vtotal:=screen.Height
    r:=screen.RastPort
    IF bitmap:=createbitmap(htotal,vtotal,bitmapdepth(r.BitMap),0,r.BitMap)
      BltBitMap(r.BitMap,0,0,bitmap,0,0,htotal,vtotal,$C0,-1,NIL)
      IF dri:=GetScreenDrawInfo(screen)
        sizeimage:=newimageobject(SIZEIMAGE)
        leftimage:=newimageobject(LEFTIMAGE)
        rightimage:=newimageobject(RIGHTIMAGE)
        upimage:=newimageobject(UPIMAGE)
        downimage:=newimageobject(DOWNIMAGE)
        IF (sizeimage<>0) AND (leftimage<>0) AND (rightimage<>0) AND (upimage<>0) AND (downimage<>0)
          openscrollerwindow([WA_PubScreen,screen,
            WA_Title,'ScrollerWindow',
            WA_Flags,WFLG_CLOSEGADGET|WFLG_SIZEGADGET|WFLG_DRAGBAR|WFLG_DEPTHGADGET|WFLG_SMART_REFRESH|WFLG_ACTIVATE|WFLG_NEWLOOKMENUS,
            WA_IDCMP,IDCMP_CLOSEWINDOW|IDCMP_NEWSIZE|IDCMP_REFRESHWINDOW|IDCMP_IDCMPUPDATE,
            WA_InnerWidth,htotal,
            WA_InnerHeight,vtotal,
            WA_MaxWidth,-1,
            WA_MaxHeight,-1,
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
        WriteF('no draw infos!\n')
      ENDIF
      WaitBlit()
      deletebitmap(bitmap)
    ELSE
      WriteF('no bitmap!\n')
    ENDIF
    UnlockPubScreen(NIL,screen)
  ELSE
    WriteF('no pub screen!\n')
  ENDIF
ENDPROC

PROC main()
  v39:=KickVersion(39)
  IF UtilityBase:=OpenLibrary('utility.library',37)
    doscrollerwindow()
    CloseLibrary(UtilityBase)
  ENDIF
ENDPROC
