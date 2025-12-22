OPT MODULE
OPT PREPROCESS

MODULE 'graphics/rastport','graphics/gfx'
MODULE 'sven/getConfigSoftware',
       'sven/safeGetBitMapAttr',
       'sven/bitmap',
       'sven/support/bitmap'

/* Writes an pixelarray (1Byte=1Pixel) into an rastport.
** Should work on any system, uses advantages of certain versions of graphics.library
** and falls back to easiest mode in low-memory situations.
**
**  src    - the pixel array
**  srcx   - x-offset within src
**  srcy   - y-offest within src
**  srcmod - bytes per row in the source array (at least 'width')
**  rp     - the destination bitmap
**  dstx   - x-offset into rastport
**  dsty   - y-offset into rastport
**  width  - width of the rectangle
**  height - height of the rectangle
*/
EXPORT PROC safeWritePixelArray8(src:PTR TO CHAR,srcx,srcy,srcmod,
                                 rp:PTR TO rastport,dstx,dsty,
                                 width,height)
DEF bm:PTR TO bitmap,
    rph:rastport

  /* clipping
  ** help saving memory and cpu-time
  */
  IF srcx<0
    dstx:=dstx-srcx
    width:=width+srcx
    srcx:=0
  ENDIF
  IF dstx<0
    srcx:=srcx-dstx
    width:=width+dstx
    dstx:=0
  ENDIF
  IF srcy<0
    dsty:=dsty-srcy
    height:=height+srcy
    srcy:=0
  ENDIF
  IF dsty<0
    srcy:=srcy-dsty
    height:=height+dsty
    dsty:=0
  ENDIF

  width:=Min(width,safeGetBitMapAttr(rp.bitmap,BMA_WIDTH)-dstx)
  height:=Min(height,safeGetBitMapAttr(rp.bitmap,BMA_HEIGHT)-dsty)

  IF (width<=0) OR (height<=0) THEN RETURN

  /* calc startpixel of source buffer
  */
  src:=src+Mul(srcy,srcmod)+srcx


  IF getGfxVersion()>=40
    /* the easy way
    */
    WriteChunkyPixels(rp,
                      dstx,dsty,dstx+width-1,dsty+height-1,
                      src,srcmod)
    RETURN

  ELSEIF getGfxVersion()>=36
    /* a bit more complicated but still fast
    **
    ** We need an temporary rastport, so allocate an bitmap and initialize
    ** the rastport.
    ** Note: We only allocate an bitmap that is 1 pixel height because
    **       it safes a lot of memory.
    */
    IF bm:=allocBitMap(MakeEvenInt(width),1,safeGetBitMapAttr(rp.bitmap,BMA_DEPTH),0,rp.bitmap)
      InitRastPort(rph)
      rph.bitmap:=bm

      /* now draw that thingy line by line.
      */
      FOR srcy:=0 TO height-1
        WritePixelLine8(rp,dstx,dsty+srcy,
                        width,
                        src,
                        rph)
        /* calc next line
        */
        src:=src+srcmod
      ENDFOR
      freeBitMap(bm)
      RETURN
    ENDIF

  ENDIF

  /* uhhh. Pixel by pixel.
  ** Either we are on a pre v36 system or in a low memory situation.
  */
  FOR srcy:=0 TO height-1
    FOR srcx:=0 TO width-1
      SetAPen(rp,src[]++)
      WritePixel(rp,dstx+srcx,dsty+srcy)
    ENDFOR
    /* calc next line
    */
    src:=src+srcmod-width
  ENDFOR

ENDPROC

