OPT MODULE,OSVERSION=37
OPT PREPROCESS,REG=5


MODULE 'intuition/intuition','intuition/classes','intuition/classusr',
       'intuition/imageclass','intuition/gadgetclass','intuition/cghooks',
       'intuition/icclass','intuition/screens',
       'utility/tagitem','utility/hooks','graphics/rpattr','graphics/gfxmacros',
       'graphics/rastport',
       'devices/inputevent'
MODULE 'amigaLib/boopsi','tools/installhook'


/*
 * File:         IconifyButtonClass.c
 * Description:  window iconify button
 *
 * © 1995, Ketil Hunn
 *   1998, Piotr Gapiïski
 *
 */


->-#define DEBUG
#ifdef DEBUG
MODULE 'tools/debug'
#endif


#define ISBITSET(a,b)     ((a AND b)<>0)
#define ISBITCLEARED(a,b) ((a AND b)=0)
#define SETBIT(a,mask)    a:=Or(a,mask)
#define CLEARBIT(a,mask)  a:=(a AND Not(mask))


EXPORT PROC initIconifyButtonClass()
  DEF cl:PTR TO iclass
  DEF dispatcher:PTR TO hook

  cl:=MakeClass(NIL,GADGETCLASS,NIL,NIL,0)
  IF cl
    dispatcher:=cl.dispatcher
    installhook(dispatcher,{dispatchIconifyButton})
  ENDIF
ENDPROC cl

PROC dispatchIconifyButton(cl:PTR TO iclass,obj:PTR TO object,msg:PTR TO msg)
  DEF retval=FALSE,id
  DEF gpi:PTR TO gpinput,ie:PTR TO inputevent,code
  DEF gadget:PTR TO gadget

  id:=msg.methodid
  SELECT id
  CASE GM_HITTEST
    retval:=GMR_GADGETHIT
    #ifdef DEBUG
    kputfmt('HITTEST: \s\n',[IF (retval=GMR_GADGETHIT) THEN 'HIT' ELSE 'NO',NIL])
    #endif

  CASE GM_GOACTIVE
    ->- decyzja czy obsîugiwaê gadûet
    ->-
    IF (msg::gpinput.ievent)
      ->- intuition aktywowaîo gadûet (przez klikniëcie myszkâ bo inaczej nie moûna)
      ->-
      SETBIT(obj::gadget.flags,GFLG_SELECTED)
      doRedraw(obj,msg::gpinput.ginfo)
      retval:=GMR_MEACTIVE
    ELSE
      ->- odrzuê aktywacjë
      ->-
      retval:=GMR_NOREUSE
    ENDIF
    #ifdef DEBUG
    kputfmt('GOACTIVE: \s\n',[IF (retval=GMR_MEACTIVE) THEN 'yes' ELSE 'no',NIL])
    #endif

  CASE GM_GOINACTIVE
    ->- koniec aktywacji gadûeta
    ->-
    CLEARBIT(obj::gadget.flags,GFLG_SELECTED)
    doRedraw(obj,msg::gpgoinactive.ginfo)
    #ifdef DEBUG
    kputfmt('GOINACTIVE: \s\n',[IF ISBITSET(gadget.flags,GFLG_SELECTED) THEN 'no' ELSE 'yes',NIL])
    #endif

  CASE GM_RENDER
    renderButton(obj,msg)   ->- msg::gprender

  CASE GM_HANDLEINPUT
    gadget:=obj
    gpi:=msg
    ie:=gpi.ievent
    retval:=GMR_MEACTIVE
    IF(ie.class=IECLASS_RAWMOUSE)
      code:=ie.code
      SELECT code
      CASE SELECTUP
        ->- puszczono przycisk myszki
        ->-
        IF((gpi.mousex<0)             OR
           (gpi.mousex>gadget.width)  OR
           (gpi.mousey<0)             OR
           (gpi.mousey>gadget.height))
           ->- wskaúnik poza gadûetem
           ->-
           retval:=GMR_REUSE
        ELSE
          ->- wskaúnik w obrëbie gadûetu (generuj kod GADGETUP)
          ->-
          retval:=GMR_NOREUSE OR GMR_VERIFY
        ENDIF
        #ifdef DEBUG
        kputfmt('SELECTUP: over \s\n',[IF (retval=GMR_REUSE) THEN 'window' ELSE 'gadget',NIL])
        #endif
      CASE MENUDOWN
        ->- zamiast gadûetu wyôwietlaj menu
        ->-
        retval:=GMR_REUSE
      CASE IECODE_NOBUTTON
        IF((gpi.mousex<0)             OR
           (gpi.mousex>gadget.width)  OR
           (gpi.mousey<0)             OR
           (gpi.mousey>gadget.height))
          IF ISBITSET(gadget.flags,GFLG_SELECTED)
            CLEARBIT(gadget.flags,GFLG_SELECTED)
            doRedraw(obj,gpi.ginfo)
          ENDIF
        ELSE
          IF ISBITCLEARED(gadget.flags,GFLG_SELECTED)
            SETBIT(gadget.flags,GFLG_SELECTED)
            doRedraw(obj,gpi.ginfo)
          ENDIF
        ENDIF
        #ifdef DEBUG
        kputfmt('NOBUTTON: over \s (mousexy:\d,\d - gadgetwh:\d,\d)\n',
          [IF (ISBITSET(gadget.flags,GFLG_SELECTED)) THEN 'gadget' ELSE 'window',
          gpi.mousex,gpi.mousey,gadget.width,gadget.height,NIL])
        #endif
      ENDSELECT
    ENDIF
  DEFAULT
    retval:=doSuperMethodA(cl,obj,msg)
  ENDSELECT
ENDPROC retval

PROC doRedraw(obj:PTR TO object,gi:PTR TO gadgetinfo)
  DEF rp:PTR TO rastport

  IF (rp:=ObtainGIRPort(gi))
    doMethodA(obj,[GM_RENDER,gi,rp,GREDRAW_REDRAW]:gprender)
    ReleaseGIRPort(rp)
  ENDIF
ENDPROC

PROC renderButton(gadget:PTR TO gadget,msg:PTR TO gprender)
  DEF rp:PTR TO rastport,retval=FALSE,pens:PTR TO INT
  DEF selected,x,y,w,h,hmarg,vmarg

  rp   := msg.rport
  pens := msg.ginfo.drinfo.pens

  IF (rp)AND(pens)
    selected:=ISBITSET(gadget.flags,GFLG_SELECTED)
    x:=gadget.leftedge+1
    y:=gadget.topedge
    w:=gadget.width-2
    h:=gadget.height
    hmarg:=5  ->-g->Width/5,
    vmarg:=(gadget.width/7)-(IF (gadget.height)<11 THEN 1 ELSE 0)
    IF (ISBITSET(gadget.flags,GFLG_RELRIGHT)) THEN x:=x+msg.ginfo.domain.width-1

    SetAPen(rp,pens[SHADOWPEN])
    Move(rp,x-1,y+1)
    Draw(rp,x-1,y+h)

    IF (selected)
      drawFrame(rp, pens[SHADOWPEN], pens[SHINEPEN],  x,y,w,h)
      drawFrame(rp, pens[SHINEPEN],  pens[SHADOWPEN], x+hmarg,y+vmarg,w-(hmarg*2),h-(vmarg*2))
      drawFrame(rp, pens[SHADOWPEN], pens[SHINEPEN],  x+hmarg+1,y+h-vmarg-4,5,3)
    ELSE
      drawFrame(rp, pens[SHINEPEN],  pens[SHADOWPEN], x,y,w,h)
      drawFrame(rp, pens[SHADOWPEN], pens[SHINEPEN],  x+hmarg,y+vmarg,w-(hmarg*2),h-(vmarg*2))
      drawFrame(rp, pens[SHINEPEN],  pens[SHADOWPEN], x+hmarg+1,y+h-vmarg-4,5,3)
    ENDIF
    retval:=TRUE
  ENDIF
ENDPROC retval

PROC drawFrame(rp:PTR TO rastport,pen1,pen2,x,y,w,h)
   SetAPen(rp,pen1)
   Move(rp,x,y+h-1)
   Draw(rp,x,y)
   Draw(rp,x+w-1,y)

   SetAPen(rp,pen2)
   Move(rp,x+w,y+1)
   Draw(rp,x+w,y+h)
   Draw(rp,x+1,y+h)
ENDPROC
