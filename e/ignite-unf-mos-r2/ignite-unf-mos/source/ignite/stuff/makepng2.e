OPT MODULE, POWERPC

-> makepng.e by LS 2007
-> makepng2.e using z.library mod by Gelb

MODULE '*png'
MODULE 'z'
->MODULE 'libraries/z'

DEF zbase -> hide it


EXPORT PROC makePNG32(w,h,rptr,gptr,bptr,aptr,skip,complev)  HANDLE
   DEF allocsize=0, lptr:PTR TO LONG, pngmem=NIL, ihdr:PTR TO ihdr, crcstart, cptr:PTR TO CHAR
   DEF x,y, srcbuf=NIL, lenptr:PTR TO LONG, len
   DEF size, zbase

   zbase := OpenLibrary('z.library', 3)
   IF zbase = NIL THEN Raise("LIB")

   size:=w * h * (IF aptr THEN 4 ELSE 3) + h

   srcbuf := New(size)
   IF srcbuf = NIL THEN RETURN Raise("MEM")

   cptr := srcbuf
   y := h + 1
   WHILE y--
      cptr[]++ := NIL -> filterbyte
      x := w + 1
      WHILE x--
         cptr[]++ := rptr[] -> r
         rptr += skip
         cptr[]++ := gptr[] -> g
         gptr += skip
         cptr[]++ := bptr[] -> b
         bptr += skip
         IF aptr
            cptr[]++ := aptr[]
            aptr += skip
         ENDIF
      ENDWHILE
   ENDWHILE

   allocsize+=8 -> png identification
   allocsize+=12*3 -> 3 chunks
   allocsize+=w*h*(IF aptr THEN 4 ELSE 3)+h -> uncompressed rgb data size
   allocsize+=4096 -> safety

   pngmem := New(allocsize)
   IF pngmem = NIL THEN Raise("MEM")

   lptr := pngmem

    /* identification */
   lptr[]++ := PNGFILESIG1
   lptr[]++ := PNGFILESIG2

   /* ihdr chunk */
   lptr[]++ := 13 -> len of chunk data
   crcstart := lptr
   lptr[]++ := "IHDR"
   ihdr := lptr
   ihdr.width := w
   ihdr.height := h
   ihdr.bitdepth := 8
   ihdr.colortype := IF aptr THEN 6 ELSE 2
   ihdr.cmprmeth := 0
   ihdr.filtmeth := 0
   ihdr.ilacemeth := 0
   lptr := ihdr + 13 -> NOTE: some braindead came up with idea to _force_ 13 byte IHDR data.
   lptr := putlong(lptr, Crc32($0, crcstart, lptr - crcstart)) -> CRC

   /* idat chunk */
   lenptr := lptr++ -> len of chunk data, set it later
   crcstart := lptr
   lptr := putlong(lptr, "IDAT")
   IF Compress2(lptr, {len}, srcbuf, size, complev)
      Raise("COMP")
   ENDIF
   putlong(lenptr, len)
   lptr := lptr + len
   lptr := putlong(lptr, Crc32($0, crcstart, lptr - crcstart)) -> CRC
   Dispose(srcbuf)
   srcbuf := NIL

   /* iend chunk */
   lptr := putlong(lptr, 0) -> len of chunk data
   crcstart := lptr
   lptr := putlong(lptr, "IEND")
   lptr := putlong(lptr, Crc32($0, crcstart, lptr - crcstart)) -> CRC

EXCEPT DO

   CloseLibrary(zbase)
   Dispose(pngmem)
   Dispose(srcbuf)

   IF exception THEN RETURN NIL, exception

ENDPROC pngmem, lptr - pngmem

PROC putlong(ptr, value)
   ptr[]++ := value SHR 24
   ptr[]++ := value SHR 16
   ptr[]++ := value SHR 8
   ptr[]++ := value
ENDPROC ptr


EXPORT PROC freePNG(pngmem) IS Dispose(pngmem)

