-> WBClone.e - Clone the Workbench using graphics calls

->>> Header (globals)
OPT PREPROCESS

MODULE 'exec/memory',
       'graphics/displayinfo',
       'graphics/gfx',
       'graphics/gfxnodes',
       'graphics/monitor',
       'graphics/rastport',
       'graphics/view',
       'graphics/videocontrol',
       'intuition/intuitionbase',
       'intuition/screens'

ENUM ERR_NONE, ERR_CMAP, ERR_DINFO, ERR_GFXNEW, ERR_KICK, ERR_MONI

RAISE ERR_CMAP   IF GetColorMap()=NIL,
      ERR_DINFO  IF GetDisplayInfoData()=NIL,
      ERR_GFXNEW IF GfxNew()=NIL,
      ERR_KICK   IF KickVersion()=FALSE,
      ERR_MONI   IF OpenMonitor()=NIL

#define INTUITIONNAME 'intuition.library'
->>>

->>> PROC destroyView(view:PTR TO view)
-> Close and free everything to do with the View
PROC destroyView(view:PTR TO view)
  DEF ve:PTR TO viewextra
  IF view
    IF ve:=GfxLookUp(view)
      IF ve.monitor THEN CloseMonitor(ve.monitor)
      GfxFree(ve)
    ENDIF

    -> Free up the copper lists
    IF view.lofcprlist THEN FreeCprList(view.lofcprlist)
    IF view.shfcprlist THEN FreeCprList(view.shfcprlist)

    Dispose(view)
  ENDIF
ENDPROC
->>>

->>> PROC dupView(v:PTR TO view, modeID)
-> Duplicate the View
PROC dupView(v:PTR TO view, modeID) HANDLE
  -> Allocate and init a view OBJECT.  Also, get a viewextra OBJECT and
  -> attach the monitor type to the View.
  DEF view=NIL:PTR TO view, ve=NIL:PTR TO viewextra,
      mspc=NIL:PTR TO monitorspec
  view:=NewM(SIZEOF view, MEMF_CLEAR OR MEMF_PUBLIC)
  ve:=GfxNew(VIEW_EXTRA_TYPE)
  mspc:=OpenMonitor(NIL, modeID)
  InitView(view)
  view.dyoffset:=v.dyoffset
  view.dxoffset:=v.dxoffset
  view.modes:=v.modes
  GfxAssociate(view, ve)
  ve.monitor:=mspc
  RETURN view
EXCEPT
  -> E-Note: C version is wrong; failure may happen before attaching to view
  IF mspc THEN CloseMonitor(mspc)
  IF ve THEN GfxFree(ve)
  IF view THEN Dispose(view)
  ReThrow()  -> E-Note: pass on exception if it was an error
ENDPROC
->>>

->>> PROC destroyViewPort(vp:PTR TO viewport)
-> Close and free everything to do with the viewport
PROC destroyViewPort(vp:PTR TO viewport)
  DEF cm:PTR TO colormap, ti:PTR TO LONG
  IF vp
    -> Find the ViewPort's ColorMap.  From that use VideoControl to get the
    -> ViewPortExtra, and free it.
    -> Then free the ColorMap, and finally the ViewPort itself.
    IF cm:=vp.colormap
      -> E-Note: ti[1] will be filled in by the call to VideoControl
      IF VideoControl(cm, ti:=[VTAG_VIEWPORTEXTRA_GET, NIL, NIL])=NIL
        GfxFree(ti[1])
      ELSE
        WriteF('VideoControl error in destroyViewPort()\n')
      ENDIF

      FreeColorMap(cm)
    ELSE
      WriteF('Could not free the ColorMap\n')
    ENDIF

    FreeVPortCopLists(vp)

    Dispose(vp)
  ENDIF
ENDPROC
->>>

->>> PROC dupViewPort(vp:PTR TO viewport, modeID)
CONST COLOURS=32  -> E-Note: this is a bit out of date...

-> Duplicate the ViewPort
PROC dupViewPort(vp:PTR TO viewport, modeID) HANDLE
  -> Allocate and initialise a ViewPort.  Copy the ViewPort width and heights,
  -> offsets, and modes values.  Allocate and initialise a ColorMap.
  ->
  -> Also, allocate a ViewPortExtra, and copy the TextOScan values of the
  -> ModeID from the database into the ViewPortExtra.
  DEF myvp=NIL:PTR TO viewport, vpe=NIL:PTR TO viewportextra,
      cm=NIL:PTR TO colormap, query:dimensioninfo, colour, c
  myvp:=NewM(SIZEOF viewport, MEMF_CLEAR OR MEMF_PUBLIC)
  vpe:=GfxNew(VIEWPORT_EXTRA_TYPE)
  cm:=GetColorMap(COLOURS)  -> E-Note: use the constant that's been defined!
  GetDisplayInfoData(NIL, query, SIZEOF dimensioninfo, DTAG_DIMS, modeID)
  InitVPort(myvp)

  -> Duplicate the viewport object
  myvp.dwidth:=vp.dwidth
  myvp.dheight:=vp.dheight
  myvp.dxoffset:=vp.dxoffset
  myvp.dyoffset:=vp.dyoffset
  myvp.modes:=vp.modes
  myvp.spritepriorities:=vp.spritepriorities
  myvp.extendedmodes:=vp.extendedmodes

  -> Duplicate the Overscan values
  CopyMem(query.txtoscan, vpe.displayclip, SIZEOF rectangle)

  -> Attach everything together
  IF VideoControl(cm, [VTAG_ATTACH_CM_SET, myvp,
                       VTAG_VIEWPORTEXTRA_SET, vpe,
                       VTAG_NORMAL_DISP_SET, FindDisplayInfo(modeID),
                       NIL])
    WriteF('VideoControl error in duplicateViewPort()\n')
  ENDIF

  -> Copy the colours from the Workbench
  FOR c:=0 TO COLOURS-1
    IF -1<>(colour:=GetRGB4(vp.colormap, c))
      SetRGB4CM(cm, c, Shr(colour, 8), Shr(colour, 4) AND $F, colour AND $F)
    ENDIF 
  ENDFOR
  RETURN myvp
EXCEPT
  -> E-Note: C version is wrong; failure may happen before attaching to myvp
  IF cm THEN FreeColorMap(cm)
  IF vpe THEN GfxFree(vpe)
  IF myvp THEN Dispose(myvp)
  ReThrow()  -> E-Note: pass on exception if an error
ENDPROC
->>>

->>> PROC destroyBitMap(mybm:PTR TO bitmap, width, height, depth)
-> Close and free everything to do with the BitMap
PROC destroyBitMap(mybm:PTR TO bitmap, width, height, depth)
  DEF i
  IF mybm
    FOR i:=0 TO depth-1
      IF mybm.planes[i] THEN FreeRaster(mybm.planes[i], width, height)
    ENDFOR
    Dispose(mybm)
  ENDIF
ENDPROC
->>>

->>> PROC createBitMap(width, height, depth)
-> Create the BitMap
PROC createBitMap(width, height, depth) HANDLE
  -> Allocate a bitmap OBJECT, initialise it and allocate each plane.
  DEF mybm:PTR TO bitmap, i
  mybm:=NewM(SIZEOF bitmap, MEMF_CLEAR OR MEMF_PUBLIC)
  InitBitMap(mybm, depth, width, height)
  FOR i:=0 TO depth-1
    mybm.planes[i]:=AllocRaster(width, height)
  ENDFOR
  RETURN mybm
EXCEPT
  -> E-Note: hey! the C version is OK this time!
  destroyBitMap(mybm, width, height, depth)
  ReThrow()  -> E-Note: pass on exception if an error
ENDPROC
->>>

->>> PROC showView(view, vp, bm, width, height)
-> Assemble and display the View
PROC showView(view:PTR TO view, vp:PTR TO viewport, bm:PTR TO bitmap,
              width, height) HANDLE
  -> Attach the BitMap to the ViewPort via a RasInfo.  Attach the ViewPort to
  -> the View.  Clear the BitMap, and draw into it by attaching the BitMap to
  -> a RastPort.  Then MakeVPort(), MrgCop() and LoadView().
  -> Just wait for the user to press <RETURN> before returning.
  DEF rp=NIL:PTR TO rastport, ri=NIL:PTR TO rasinfo
  rp:=NewM(SIZEOF rastport, MEMF_CLEAR OR MEMF_PUBLIC)
  ri:=NewM(SIZEOF rasinfo, MEMF_CLEAR OR MEMF_PUBLIC)
  InitRastPort(rp)
  rp.bitmap:=bm
  ri.bitmap:=bm
  vp.rasinfo:=ri
  view.viewport:=vp

  -> Render
  SetRast(rp, 0)  -> Clear the background
  SetAPen(rp, Shl(1, bm.depth)-1)  -> Use the last pen
  Move(rp, 0, 0)
  Draw(rp, width, 0)
  Draw(rp, width, height)
  Draw(rp, 0, height)
  Draw(rp, 0, 0)

  -> Display it
  MakeVPort(view, vp)
  MrgCop(view)
  LoadView(view)

  -> E-Note: make this work even under Workbench
  WriteF('');  Inp(IF stdin THEN stdin ELSE stdout)

  -> Bring back the system
  RethinkDisplay()
EXCEPT DO
  IF ri THEN Dispose(ri)
  IF rp THEN Dispose(rp)
  ReThrow()  -> E-Note: pass on exception if an error
ENDPROC
->>>

->>> PROC main()
-> Clone the Workbench View using Graphics Library calls.
PROC main() HANDLE
  DEF wb=NIL:PTR TO screen, myview=NIL, myvp=NIL, mybm=NIL,
      modeID, ibaseLock=NIL, intuition:PTR TO intuitionbase

  KickVersion(37)  -> E-Note: requires V37

  -> To clone the Workbench using graphics calls involves duplicating the
  -> Workbench ViewPort, ViewPort mode, and Intuition's View.  This also
  -> involves duplicating the DisplayClip for the overscan value, the colours,
  -> and the View position.
  ->
  -> When this is all done, the View, ViewPort, ColorMap and BitMap (and
  -> ViewPortExtra, ViewExtra and RasInfo) all have to be linked together, and
  -> the copperlists made to create the display.
  ->
  -> This is not as difficult as it sounds (trust me!)

  -> First, lock the Workbench screen, so no changes can be made to it while
  -> we are duplicating it.
  wb:=LockPubScreen('Workbench')

  -> Find the Workbench's ModeID.  This is a 32-bit number that identifies the
  -> monitor type, and the display mode of that monitor.
  modeID:=GetVPModeID(wb.viewport)

  -> We need to duplicate Intuition's View structure, so lock IntuitionBase to
  -> prevent the View changing under our feet.
  ibaseLock:=LockIBase(0)
  intuition:=intuitionbase  -> E-Note: get the right type for intuitionbase
  myview:=dupView(intuition.viewlord, modeID)

  -> The View has been cloned, so we don't need to keep it locked.
  UnlockIBase(ibaseLock)
  ibaseLock:=NIL  -> E-Note: set to NIL so we don't Unlock it again

  -> Now duplicate the Workbench's ViewPort.  Remember, we still have the
  -> Workbench locked.
  myvp:=dupViewPort(wb.viewport, modeID)

  -> Create a BitMap to render into.  This will be of the same dimensions
  -> as the Workbench.
  mybm:=createBitMap(wb.width, wb.height, wb.bitmap.depth)

  -> Now we have everything copied, show something
  showView(myview, myvp, mybm, wb.width-1, wb.height-1)

EXCEPT DO
  -> Free up everything we may have allocated or still have locked
  IF mybm THEN destroyBitMap(mybm, wb.width, wb.height, wb.bitmap.depth)
  IF myvp THEN destroyViewPort(myvp)
  IF myview THEN destroyView(myview)
  IF ibaseLock THEN UnlockIBase(ibaseLock)
  IF wb THEN UnlockPubScreen(NIL, wb)
  SELECT exception
  CASE ERR_CMAP;    WriteF('Could not get ColorMap\n')
  CASE ERR_DINFO;   WriteF('Display database error\n')
  CASE ERR_GFXNEW;  WriteF('Could not get the View-/ViewPort- Extra\n')
  CASE ERR_KICK;    WriteF('Requires at least V37\n')
  CASE ERR_MONI;    WriteF('Could not open monitor\n')
  CASE "MEM";       WriteF('Ran out of memory\n')
  ENDSELECT
ENDPROC
->>>

