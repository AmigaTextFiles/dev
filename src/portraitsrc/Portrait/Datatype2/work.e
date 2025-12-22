OPT PREPROCESS
OPT OSVERSION=39

LIBRARY 'work.datatype',1,0,'work.datatype 1.0 (17.9.98)' IS obtainworkengine()

MODULE 'exec/memory',
       'dos/dos',
       'graphics/gfx',
       'graphics/rastport',
       'graphics/modeid',
       'graphics/displayinfo',
       'intuition/classes',
       'intuition/classusr',
       'intuition/gadgetclass',
       'intuition/icclass',
       'datatypes/datatypes',
       'datatypes/datatypesclass',
       'datatypes/pictureclass',
       'utility/tagitem',
       'libraries/iffparse',
       'render/render',
       'utility',
       'datatypes',
       'iffparse',
       'render',
       'tools/inithook',
       'amigalib/boopsi'

CONST ID_ANNO="ANNO"
CONST ID_AUTH="AUTH"
CONST ID_COPYRIGHT="(c) "
CONST ID_FVER="FVER"
CONST ID_WORK="WORK"
CONST ID_PHDR="PHDR"

OBJECT phdr
  width,height
ENDOBJECT

DEF oldout

DEF class:PTR TO iclass

DEF superclassbase

#define MAXDEPTH 8
#define DEFDEPTH 8
#define TRUEDEPTH 24

PROC main()
  renderbase:=OpenLibrary('render.library', 0)
  iffparsebase:=OpenLibrary('iffparse.library', 39)
  datatypesbase:=OpenLibrary('datatypes.library', 39)
  utilitybase:=OpenLibrary('utility.library', 39)
  superclassbase:=OpenLibrary('datatypes/picture.datatype',39)
  ->oldout:=SetStdOut(Output())
  IF stdout THEN WriteF('DEBUG: library opened\n')
  initclass()
ENDPROC

PROC initclass()
  DEF o:PTR TO object
  IF class:=MakeClass('work.datatype', PICTUREDTCLASS, NIL, 0, 0)
    inithook(class.dispatcher,{dispatcher})
    AddClass(class)
    IF stdout THEN WriteF('DEBUG: addclass\n')
  ELSE
    IF stdout THEN WriteF('DEBUG: makeclass failed\n')
  ENDIF
ENDPROC class

PROC close()
  IF stdout THEN WriteF('DEBUG: library close\n')
  IF class
    RemoveClass(class)
    FreeClass(class)
    class:=NIL
  ENDIF
  IF superclassbase
    CloseLibrary(superclassbase)
    superclassbase:=NIL
  ENDIF
  IF renderbase
    CloseLibrary(renderbase)
    renderbase:=NIL
  ENDIF
  IF iffparsebase
    CloseLibrary(iffparsebase)
    iffparsebase:=NIL
  ENDIF
  IF datatypesbase
    CloseLibrary(datatypesbase)
    datatypesbase:=NIL
  ENDIF
  IF utilitybase
    CloseLibrary(utilitybase)
    utilitybase:=NIL
  ENDIF
  ->SetStdOut(oldout)
ENDPROC

PROC obtainworkengine() RETURN class

PROC dispatcher(cl:PTR TO iclass, o:PTR TO object, msg:PTR TO msg)
  DEF methodid, retval=0, ti:PTR TO tagitem, error
  DEF rp:PTR TO rastport, gpr:gprender
  methodid:=msg.methodid
  SELECT methodid
    CASE OM_NEW
      IF stdout THEN WriteF('DEBUG: OM_NEW called\n')
      IF ti:=FindTagItem(DTA_SOURCETYPE, msg::opset.attrlist) THEN IF (ti.data<>DTST_FILE) AND (ti.data<>DTST_CLIPBOARD) AND (ti.data<>DTST_RAM) THEN SetIoErr(ERROR_OBJECT_WRONG_TYPE)
      IF o=cl
        IF retval:=doSuperMethodA(cl, o, msg)
          IF error:=loadwork(retval)
            coerceMethodA(cl, retval, OM_DISPOSE)
            retval:=NIL
          ENDIF
          SetIoErr(error)
        ENDIF
      ELSE
        SetIoErr(ERROR_NOT_IMPLEMENTED)
      ENDIF
    CASE OM_UPDATE
      IF doMethodA(o, ICM_CHECKLOOP)=NIL THEN JUMP set
    CASE OM_SET
      set:
      IF retval:=doSuperMethodA(cl, o, msg)
        IF OCLASS(o)=cl
          IF rp:=ObtainGIRPort(msg::opset.ginfo)
            gpr.methodid:=GM_RENDER
            gpr.ginfo:=msg::opset.ginfo
            gpr.rport:=rp
            gpr.redraw:=GREDRAW_UPDATE
            doMethodA(o, gpr)
            ReleaseGIRPort(rp)
            retval:=NIL
          ENDIF
        ENDIF
      ENDIF
    DEFAULT
      retval:=doSuperMethodA(cl, o, msg)
  ENDSELECT
ENDPROC retval

PROC loadwork(o:PTR TO object)
  DEF error=0, iff=NIL, sourcetype, phdr:PTR TO phdr,
      bmhd:PTR TO bitmapheader, modeid=0, bmp:PTR TO bitmap,
      name
  DEF phdrprop=NIL:PTR TO storedproperty,
      bodyprop=NIL:PTR TO storedproperty,
      annonprop=NIL:PTR TO storedproperty,
      authprop=NIL:PTR TO storedproperty,
      copyrightprop=NIL:PTR TO storedproperty,
      fverprop=NIL:PTR TO storedproperty,
      nameprop=NIL:PTR TO storedproperty
  DEF propchunks:PTR TO LONG
  propchunks:=[ID_WORK,ID_PHDR,
               ID_WORK,ID_BODY,
               ID_WORK,ID_ANNO,
               ID_WORK,ID_AUTH,
               ID_WORK,ID_COPYRIGHT,
               ID_WORK,ID_FVER,
               ID_WORK,ID_NAME]:LONG
  IF GetDTAttrsA(o, [DTA_SOURCETYPE, {sourcetype},
                     DTA_HANDLE, {iff},
                     PDTA_BITMAPHEADER, {bmhd},
                     TAG_DONE])=3
    IF sourcetype=DTST_RAM THEN iff:=NIL
    IF (sourcetype<>DTST_RAM) AND (sourcetype<>DTST_FILE) AND (sourcetype<>DTST_CLIPBOARD) THEN error:=ERROR_NOT_IMPLEMENTED
    IF error=0
      IF iff
        IF (error:=PropChunks(iff, propchunks, 7))=NIL
          WHILE (error=0)
            IF error:=ParseIFF(iff, IFFPARSE_STEP)
              IF error=IFFERR_EOC THEN error:=0
              IF phdrprop=NIL
                IF phdrprop:=FindProp(iff, ID_WORK, ID_PHDR)
                  phdr:=phdrprop.data
                  bmhd.width:=phdr.width
                  bmhd.height:=phdr.height
                  bmhd.pagewidth:=bmhd.width
                  bmhd.pageheight:=bmhd.height
                  IF ((bmhd.depth<1) OR (bmhd.depth>MAXDEPTH)) AND (bmhd.depth<>TRUEDEPTH) THEN bmhd.depth:=DEFDEPTH
                ENDIF
              ENDIF
              IF bodyprop=NIL
                IF bodyprop:=FindProp(iff, ID_WORK, ID_BODY)
                  IF phdrprop
                    IF bmp:=AllocBitMap(bmhd.width, bmhd.height, bmhd.depth, 0, NIL)
                      error:=loadworkbody(o, bmp, bmhd, bodyprop.data, bodyprop.size)
                    ELSE
                      error:=ERROR_NO_FREE_STORE
                    ENDIF
                  ELSE
                    error:=DTERROR_INVALID_DATA
                  ENDIF
                ENDIF
              ENDIF
            ENDIF
          ENDWHILE
          IF error=IFFERR_EOF THEN error:=0
          IF ((phdrprop=NIL) OR (bodyprop=NIL) OR (bmhd=NIL)) AND (error=0) THEN error:=DTERROR_INVALID_DATA
          IF error=0
            IF nameprop=NIL
              GetDTAttrsA(o, [DTA_NAME, {name}, TAG_DONE])
              SetDTAttrsA(o, NIL, NIL, [DTA_OBJNAME, name, TAG_DONE])
            ENDIF
            IF modeid=0
              modeid:=BestModeIDA([BIDTAG_NOMINALWIDTH, bmhd.pagewidth,
                                   BIDTAG_NOMINALHEIGHT, bmhd.pageheight,
                                   BIDTAG_DESIREDWIDTH, bmhd.width,
                                   BIDTAG_DESIREDHEIGHT, bmhd.height,
                                   BIDTAG_DEPTH, bmhd.depth,
                                   BIDTAG_DIPFMUSTNOTHAVE, DIPF_IS_DUALPF OR DIPF_IS_PF2PRI,
                                   TAG_DONE])
              IF modeid=INVALID_ID THEN modeid:=0
              SetDTAttrsA(o, NIL, NIL, [PDTA_MODEID, modeid,
                                        PDTA_BITMAP, bmp,
                                        DTA_NOMINALHORIZ, bmhd.width,
                                        DTA_NOMINALVERT, bmhd.height,
                                        TAG_DONE])
            ENDIF
          ENDIF
        ENDIF
      ELSE
        IF sourcetype<>DTST_RAM THEN error:=ERROR_REQUIRED_ARG_MISSING
      ENDIF
    ENDIF
  ELSE
    error:=ERROR_OBJECT_WRONG_TYPE
  ENDIF
  IF error<0 THEN error:=ListItem([0,
                                   0,
                                   DTERROR_INVALID_DATA,
                                   ERROR_NO_FREE_STORE,
                                   ERROR_SEEK_ERROR,
                                   ERROR_SEEK_ERROR,
                                   ERROR_SEEK_ERROR,
                                   DTERROR_INVALID_DATA,
                                   DTERROR_INVALID_DATA,
                                   ERROR_OBJECT_WRONG_TYPE,
                                   ERROR_REQUIRED_ARG_MISSING,
                                   0], (-error-1))
ENDPROC error

PROC loadworkbody(o:PTR TO object, bitmap:PTR TO bitmap,
                  bmhd:PTR TO bitmapheader, buffer, buffersize)
  DEF error=0
  DEF palette,histogram,chunky
  DEF cm:PTR TO CHAR,cregs:PTR TO LONG,nc,cbuf,i,cptr:PTR TO CHAR
  IF stdout THEN WriteF('DEBUG: loadworkbody() called\n')
  IF (bmhd.depth<>TRUEDEPTH)
    IF chunky:=AllocVec(Shr(buffersize,2),MEMF_ANY)
      IF stdout THEN WriteF('DEBUG: AllocVec\n')
      IF palette:=CreatePaletteA([RND_HSTYPE,HSTYPE_15BIT,TAG_DONE])
        IF stdout THEN WriteF('DEBUG: Palette\n')
        IF histogram:=CreateHistogramA([RND_HSTYPE,HSTYPE_15BIT_TURBO,TAG_DONE])
          IF stdout THEN WriteF('DEBUG: Histogram\n')
          IF AddRGBImageA(histogram,buffer,bmhd.width,bmhd.height,[TAG_DONE])=ADDH_SUCCESS
            IF stdout THEN WriteF('DEBUG: AddImage\n')
            IF ExtractPaletteA(histogram,palette,Shl(1,bmhd.depth),[RND_COLORMODE,COLORMODE_CLUT,TAG_DONE])=EXTP_SUCCESS
              IF stdout THEN WriteF('DEBUG: ExtractPalette\n')
              IF RenderA(buffer, bmhd.width, bmhd.height, chunky, palette, [TAG_DONE])=REND_SUCCESS
                IF stdout THEN WriteF('DEBUG: Render\n')
                Chunky2BitMapA(chunky, 0, 0, bmhd.width, bmhd.height, bitmap, 0, 0, [RND_COLORMODE,COLORMODE_CLUT,TAG_DONE])
                SetDTAttrsA(o, NIL, NIL, [PDTA_NUMCOLORS, Shl(1,bmhd.depth), TAG_DONE])
                IF GetDTAttrsA(o, [PDTA_COLORREGISTERS, {cm},
                                   PDTA_CREGS, {cregs},
                                   PDTA_NUMCOLORS, {nc},
                                   TAG_DONE])=3
                  IF stdout THEN WriteF('DEBUG: GetDTAttrs\n')
                  IF cbuf:=AllocVec(Shl(nc,2), MEMF_ANY)
                    IF stdout THEN WriteF('DEBUG: Colour buffer\n')
                    ExportPaletteA(palette,cbuf,[RND_PALETTEFORMAT,PALFMT_RGB8,RND_NUMCOLORS,nc,TAG_DONE])
                    IF stdout THEN WriteF('DEBUG: Export palette\n')
                    cptr:=cbuf
                    FOR i:=0 TO nc-1
                      cptr++
                      cm[]++:=cptr[]
                      cregs[]++:=Mul(cptr[]++,$01010101)
                      cm[]++:=cptr[]
                      cregs[]++:=Mul(cptr[]++,$01010101)
                      cm[]++:=cptr[]
                      cregs[]++:=Mul(cptr[]++,$01010101)
                    ENDFOR
                    IF stdout THEN WriteF('DEBUG: Load colours\n')
                    FreeVec(cbuf)
                    IF stdout THEN WriteF('DEBUG: Free colour buffer\n')
                  ELSE
                    error:=ERROR_NO_FREE_STORE
                    IF stdout THEN WriteF('DEBUG: no mem for colour buf\n')
                  ENDIF
                ELSE
                  error:=ERROR_REQUIRED_ARG_MISSING
                  IF stdout THEN WriteF('DEBUG: Missing pal info\n')
                ENDIF
              ELSE
                error:=ERROR_NOT_IMPLEMENTED
                IF stdout THEN WriteF('DEBUG: RenderA() failed\n')
              ENDIF
            ELSE
              error:=ERROR_NOT_IMPLEMENTED
              IF stdout THEN WriteF('DEBUG: ExtractPaletteA() failed\n')
            ENDIF
          ELSE
            error:=ERROR_NOT_IMPLEMENTED
            IF stdout THEN WriteF('DEBUG: AddrgbimageA failed\n')
          ENDIF
          DeleteHistogram(histogram)
          IF stdout THEN WriteF('DEBUG: Delete histogram\n')
        ELSE
          error:=ERROR_NO_FREE_STORE
          IF stdout THEN WriteF('DEBUG: No mem for hist\n')
        ENDIF
        DeletePalette(palette)
        IF stdout THEN WriteF('DEBUG: Delete palette\n')
      ELSE
        error:=ERROR_NO_FREE_STORE
        IF stdout THEN WriteF('DEBUG: No mem for palette\n')
      ENDIF
      FreeVec(chunky)
      IF stdout THEN WriteF('DEBUG: free chunky\n')
    ELSE
      error:=ERROR_NO_FREE_STORE
      IF stdout THEN WriteF('DEBUG: no mem for chunky\n')
    ENDIF
  ELSE
    error:=ERROR_NOT_IMPLEMENTED
    IF stdout THEN WriteF('DEBUG: 24-bit bitmaps not supported')
  ENDIF
  IF stdout THEN WriteF('DEBUG: ENDPROC\n')
ENDPROC error
