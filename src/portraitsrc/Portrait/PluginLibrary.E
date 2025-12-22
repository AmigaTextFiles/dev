MODULE 'jpeg/jpeg',
       'jpeg'

LIBRARY 'jpeg.io',1,0,'jpeg.io 1.0 (20.9.98)' IS matchtype(),load

ENUM ERR_NONE,
     ERR_WRONG_TYPE,
     ERR_FILE,
     ERR_INVALID_DATA,
     ERR_NOMEM,
     ERR_FATAL

PROC main()
  /* Initialise library here */
ENDPROC

PROC close()
  /* Cleanup library here */
ENDPROC

PROC matchtype(fh,filename)
  DEF buf[10]:ARRAY
  IF Read(fh,buf,10)=10
    IF Long(buf+6)="JFIF" THEN RETURN ERR_NONE
  ELSE
    RETURN ERR_FILE
  ENDIF
ENDPROC ERR_WRONG_TYPE

PROC loadjpeg(fh,filename) HANDLE
  DEF error, jph=NIL:PTR TO jpegcomhandle, buf, jwidth, jheight, rowsize,
      colourspace, x, y, bpp, dptr:PTR TO CHAR, fptr:PTR TO CHAR,fh=NIL,
      ss=NIL:PTR TO ratio
  setstatus('Loading JPEG...')
  IF jpegbase:=OpenLibrary('jpeg.library',1)
    NEW ss.ratio(1,1)
    easyguiA('JPEG Scale',
      [ROWS,
        [PLUGIN,{dum},ss,TRUE]
      ],[EG_SCRN,scr,EG_WTYPE,WTYPE_NOSIZE,NIL])
      IF (error:=AllocJPEGDecompressA({jph},[JPG_SRCFILE,fh,
                                             TAG_DONE]))=NIL
        IF (error:=GetJPEGInfoA(jph, [JPG_WIDTH, {jwidth},
                                      JPG_HEIGHT, {jheight},
                                      JPG_ROWSIZE, {rowsize},
                                      JPG_COLOURSPACE, {colourspace},
                                      JPG_BYTESPERPIXEL, {bpp},
                                      JPG_SCALENUM,ss.ratiox,
                                      JPG_SCALEDENOM,ss.ratioy,
                                      TAG_DONE]))=NIL
          colourspace:=Shr(colourspace,24)
          IF (colourspace=JPCS_RGB) AND (bpp=3)
            IF changesize(jwidth,jheight)=ERR_NONE
              IF buf:=AllocRGBFromJPEGA(jph,[JPG_SCALENUM,ss.ratiox,
                                             JPG_SCALEDENOM,ss.ratioy,
                                             TAG_DONE])
                setstatus('Decompressing JPEG...')
                IF (error:=DecompressJPEGA(jph, [JPG_DESTRGBBUFFER, buf,
                                                 JPG_SCALENUM,ss.ratiox,
                                                 JPG_SCALEDENOM,ss.ratioy,
                                                 TAG_DONE]))=NIL
                  setstatus('Converting JPEG...')
                  IF (getflags() AND CF_USINGVMEM)=NIL
                    dptr:=getbuffer()
                    FOR y:=0 TO jheight-1
                      fptr:=buf+Mul(y,rowsize)
                      FOR x:=0 TO jwidth-1
                        dptr++
                        dptr[]++:=fptr[]++
                        dptr[]++:=fptr[]++
                        dptr[]++:=fptr[]++
                      ENDFOR
                    ENDFOR
                  ELSE
                    FOR y:=0 TO jheight-1
                      fptr:=buf+Mul(y,rowsize)
                      FOR x:=0 TO jwidth-1
                        dptr:=gettrue(x,y)+1
                        dptr[]++:=fptr[]++
                        dptr[]++:=fptr[]++
                        dptr[]++:=fptr[]++
                      ENDFOR
                    ENDFOR
                  ENDIF
                ENDIF
                canvas.vmod:=1
                canvas.minx:=0
                canvas.miny:=0
                canvas.maxx:=canvas.width-1
                canvas.maxy:=canvas.height-1
              ELSE
                error('JPEG: Decompress error')
              ENDIF
            ELSE
              error('JPEG: Out of memory')
            ENDIF
          ELSE
            error('JPEG: Format not supported')
          ENDIF
        ELSE
          error('JPEG: Get info error')
        ENDIF
      ELSE
        error('JPEG: Allocate decompress error')
      ENDIF
    ELSE
      error('JPEG: File not found')
    ENDIF
  ELSE
    error('JPEG: Cannot open jpeg.library V1+')
  ENDIF
EXCEPT DO
  IF buf THEN FreeJPEGRGBBuffer(buf)
  IF jph THEN FreeJPEGDecompress(jph)
  IF ss THEN END ss
  IF jpegbase
    CloseLibrary(jpegbase)
    jpegbase:=NIL
  ENDIF
  canvas.refresh(TRUE)
  setstatus('')
ENDPROC

PROC refresh()
ENDPROC

PROC setstatus(str)
ENDPROC

PROC changesize(width,height)
ENDPROC

PROC error(str)
ENDPROC

PROC gettrue(x,y)
ENDPROC

PROC getflags()
ENDPROC

PROC