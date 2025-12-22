MODULE 'jpeg/jpeg',
       'jpeg',
       'utility/tagitem'

SET CF_PRIVATE1,CF_PRIVATE2,CF_USINGVMEM,CF_PRIVATE4,CF_PRIVATE5

LIBRARY 'jpeg.io',1,0,'jpeg.io 1.0 (20.9.98)' IS init,matchfile,loadfile,savefile

OBJECT iobase
/* V1.3 */
  askscale
  refresh
  setstatus
  changesize
  error
  gettrue
  getflags
  setflags
  getbuffer
ENDOBJECT

DEF iobase:PTR TO iobase

ENUM ERR_NONE,
     ERR_UNIMPLEMENTED,
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

PROC init(base)
  iobase:=base
ENDPROC ERR_NONE

PROC matchfile(fh,filename)
  DEF buf[10]:ARRAY
  IF Read(fh,buf,10)=10
    IF Long(buf+6)="JFIF" THEN RETURN ERR_NONE
  ELSE
    RETURN ERR_FILE
  ENDIF
ENDPROC ERR_WRONG_TYPE

PROC loadfile(fh,filename) HANDLE
  DEF jerror, jph=NIL:PTR TO jpegdcomhandle, buf, jwidth, jheight, rowsize,
      colourspace, x, y, bpp, dptr:PTR TO CHAR, fptr:PTR TO CHAR,
      ratiox,ratioy,err=ERR_NONE
  setstatus('Loading JPEG...')
  IF jpegbase:=OpenLibrary('jpeg.library',1)
    IF askscale('JPEG Scale',{ratiox},{ratioy})=ERR_NONE
      IF (jerror:=AllocJPEGDecompressA({jph},[JPG_SRCFILE,fh,
                                             TAG_DONE]))=NIL
        IF (jerror:=GetJPEGInfoA(jph, [JPG_WIDTH, {jwidth},
                                      JPG_HEIGHT, {jheight},
                                      JPG_ROWSIZE, {rowsize},
                                      JPG_COLOURSPACE, {colourspace},
                                      JPG_BYTESPERPIXEL, {bpp},
                                      JPG_SCALENUM,ratiox,
                                      JPG_SCALEDENOM,ratioy,
                                      TAG_DONE]))=NIL
          colourspace:=Shr(colourspace,24)
          IF (colourspace=JPCS_RGB) AND (bpp=3)
            IF changesize(jwidth,jheight)=ERR_NONE
              IF buf:=AllocRGBFromJPEGA(jph,[JPG_SCALENUM,ratiox,
                                             JPG_SCALEDENOM,ratioy,
                                             TAG_DONE])
                setstatus('Decompressing JPEG...')
                IF (jerror:=DecompressJPEGA(jph, [JPG_DESTRGBBUFFER, buf,
                                                 JPG_SCALENUM,ratiox,
                                                 JPG_SCALEDENOM,ratioy,
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
                  IF refresh()<>ERR_NONE THEN err:=ERR_FATAL
                ELSE
                  error('JPEG: Decompress error')
                  err:=ERR_INVALID_DATA
                ENDIF
              ELSE
                error('JPEG: Out of memory')
                err:=ERR_NOMEM
              ENDIF
            ELSE
              error('JPEG: Could not change canvas size')
              err:=ERR_NOMEM
            ENDIF
          ELSE
            error('JPEG: Format not supported')
            err:=ERR_WRONG_TYPE
          ENDIF
        ELSE
          error('JPEG: Get info error')
          err:=ERR_INVALID_DATA
        ENDIF
      ELSE
        error('JPEG: Allocate decompress error')
        err:=ERR_NOMEM
      ENDIF
    ELSE
      error('JPEG: Scale requester failed')
      err:=ERR_FATAL
    ENDIF
  ELSE
    error('JPEG: Cannot open jpeg.library V1+')
    err:=ERR_FATAL
  ENDIF
EXCEPT DO
  IF buf THEN FreeJPEGRGBBuffer(buf)
  IF jph THEN FreeJPEGDecompress(jph)
  IF jpegbase THEN CloseLibrary(jpegbase)
  setstatus('')
ENDPROC err

PROC savefile(fh,filename)
ENDPROC ERR_UNIMPLEMENTED

PROC askscale(title,x,y)
  DEF proc
  proc:=iobase.askscale
ENDPROC proc(title,x,y)

PROC refresh()
  DEF proc
  proc:=iobase.refresh
ENDPROC proc()

PROC setstatus(str)
  DEF proc
  proc:=iobase.setstatus
ENDPROC proc(str)

PROC changesize(width,height)
  DEF proc
  proc:=iobase.changesize
ENDPROC proc(width,height)

PROC error(str)
  DEF proc
  proc:=iobase.error
ENDPROC proc(str)

PROC gettrue(x,y)
  DEF proc
  proc:=iobase.gettrue
ENDPROC proc(x,y)

PROC getflags()
  DEF proc
  proc:=iobase.getflags
ENDPROC proc()

PROC setflags(flags)
  DEF proc
  proc:=iobase.setflags
ENDPROC proc(flags)

PROC getbuffer()
  DEF proc
  proc:=iobase.getbuffer
ENDPROC proc()
