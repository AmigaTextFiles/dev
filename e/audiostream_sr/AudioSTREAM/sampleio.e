/*

      AudioSTREAM Professional
      (c) 1997 Immortal SYSTEMS

      Source codes for version 1.0

      =================================================

      Source:     sampleio.e
      Description:    sample import and export stuff
      Contains:   sample i/o
      Version:    1.0
 --------------------------------------------------------------------
*/


OPT MODULE
OPT PREPROCESS
OPT EXPORT

#define SIO_OK          0
#define SIO_CANTOPEN    1
#define SIO_READERROR   2
#define SIO_NOMEM       3
#define SIO_FILEPROBLEM 4
#define SIO_WRITEERROR  5

-> sample encoding types

CONST SENC_PCM8=$2000,SENC_PCM16=$4000,SENC_OTHER=$6000,SENC_UNKNOWN=0
CONST SENC_PCM8S=$3000,SENC_PCM16S=$5000

MODULE '*common','exec/memory','*global','dos/dos','libraries/mui'

OBJECT obj_siodata
      slot,name,buf,frames,type,stereo,rate
      length ->save only =buffer length
ENDOBJECT

-> chunk object for saving

OBJECT obj_form
      id,chunksize,form
ENDOBJECT

OBJECT obj_comm
      id,chunksize
      channels:INT
      frames
      samplesize:INT
      rate[10]:ARRAY
ENDOBJECT

OBJECT obj_ssnd
      id,chunksize
      unused,unused2
ENDOBJECT


           DEF memflag
           DEF siodata:PTR TO obj_siodata


-> SAMPLE I/O SUPPORT (general routines)

PROC fillsiodata(slot,name,buf,frames,type,stereo,rate)
      siodata.slot:=slot;siodata.name:=name
      siodata.buf:=buf;siodata.frames:=frames
      siodata.type:=type;siodata.stereo:=stereo
      siodata.rate:=rate
      /*CDEBUG(FILLSIO: siodata \h,siodata)
      CDEBUG(FILLSIO: rate \d,rate)*/
ENDPROC

PROC findid(buf,id,max)
      DEF i

      FOR i:=0 TO max-2 STEP 2 DO EXIT Long(buf+i)=id
      IF Long(buf+i)<>id THEN i:=-1
ENDPROC i


PROC fucke(s)
      siodata:=s
ENDPROC


PROC wavecopy(src,dest,siz,type,stereo) -> WAVE reading support

      CDEBUG(WAVECOPY: size \d,siz)
      IF siz=0 THEN RETURN
      IF type
            IF stereo
                  MOVE.L src,A0
                  MOVE.L dest,A1
                  MOVEQ.L #0,D0
            wvcp2:MOVE.B (A0)+,D1
                  MOVE.B (A0)+,(A1)+
                  MOVE.B D1,(A1)+
                  MOVE.B (A0)+,D1
                  MOVE.B (A0)+,(A1)+
                  MOVE.B D1,(A1)+
                  ADDQ.L #4,D0
                  CMP.L siz,D0
                  BNE wvcp2
            ELSE
                  MOVE.L src,A0
                  MOVE.L dest,A1
                  MOVEQ.L #0,D0
            wvcp1:MOVE.B (A0)+,D1
                  MOVE.B (A0)+,(A1)+
                  MOVE.B D1,(A1)+
                  ADDQ.L #2,D0
                  CMP.L siz,D0
                  BNE wvcp1

            ENDIF
      ELSE
                  MOVE.L src,A0   -> unsigned2signed
                  MOVE.L dest,A1
                  MOVEQ.L #0,D0
            wvcp3:MOVE.B (A0)+,D1
                  SUB.B #$80,D1
                  MOVE.B D1,(A1)+
                  ADDQ.L #1,D0
                  CMP.L siz,D0
                  BNE wvcp3

      ENDIF
ENDPROC

PROC signed2unsigned(begin,end) -> 8bit only

      IF (end-begin)=0 THEN RETURN

            MOVE.L begin,A0
            MOVE.L end,A1
s2uloop:    SUB.B #$80,(A0)+
            CMPA.L A1,A0
            BNE s2uloop
ENDPROC


PROC swapbyteorder(begin,end,stereo) ->16bit only
      IF (end-begin)=0 THEN RETURN

      IF stereo
            MOVE.L begin,A0
            MOVE.L end,A1
swploop1:   MOVE.B 1(A0),D0
            MOVE.B (A0),1(A0)
            MOVE.B D0,(A0)
            ADDQ.L #2,A0
            MOVE.B 1(A0),D0
            MOVE.B (A0),1(A0)
            MOVE.B D0,(A0)
            ADDQ.L #2,A0
            CMPA.L A1,A0
            BNE swploop1

      ELSE
            MOVE.L begin,A0
            MOVE.L end,A1
swploop2:   MOVE.B 1(A0),D0
            MOVE.B (A0),1(A0)
            MOVE.B D0,(A0)
            ADDQ.L #2,A0
            CMPA.L A1,A0
            BNE swploop2
      ENDIF
ENDPROC

PROC readle16(addr) IS Char(addr)+Shl(Char(addr+1),8)

PROC readle24(addr) IS Char(addr)+Shl(Char(addr+1),8)+Shl(Char(addr+2),16)

PROC readle32(addr) IS Char(addr)+Shl(Char(addr+1),8)+Shl(Char(addr+2),16)+Shl(Char(addr+3),24)



PROC alloccache(filesize) -> will attempt to allocate file cache
      DEF temp,size

      IF filesize>524288
            size:=524288  -> 0.5MB max,32K min
      ELSE
            size:=filesize
      ENDIF

      temp:=AllocVec(size,MEMF_PUBLIC)
      WHILE (temp=0) AND (size>65536)
            size:=size-32768
            temp:=AllocVec(size,MEMF_PUBLIC)
      ENDWHILE
      IF temp
            CDEBUG(SIO: Cache allocated \d bytes,size)
      ELSE
            CDEBUG(SIO: Cache allocation failed,0)
      ENDIF

ENDPROC temp,size



PROC dontusecache(area1,area2)
      DEF ta1,ta2
      -> returns true if one are is of public memory
      ta1:=TypeOfMem(area1)
      ta2:=TypeOfMem(area2)

ENDPROC ((ta1 AND MEMF_PUBLIC)=MEMF_PUBLIC) OR ((ta2 AND MEMF_PUBLIC)=MEMF_PUBLIC)





PROC copymemcache(src,dest,size) -> VMM optimized copymem
      DEF cache,cachesize,bytes,srctype,desttype,remaining,psize

      IF dontusecache(src,dest)
            CDEBUG(COPYMEM: Caching not used,0)
            CopyMem(src,dest,size)
            RETURN
      ENDIF

      CDEBUG(COPYMEM: Trying to use cache for VM2VM transfer,0)

      cache,cachesize:=alloccache(size)
      IF cache=NIL
            CDEBUG(COPYMEM: Out of public memory,0)
            CopyMem(src,dest,size)
            RETURN
      ENDIF

      bytes:=0

      CopyMem(src,cache,cachesize)
      CopyMem(cache,dest,cachesize)
      bytes:=bytes+cachesize;src:=src+cachesize;dest:=dest+cachesize
      WHILE bytes<size
            remaining:=size-bytes
            IF remaining>cachesize THEN psize:=cachesize ELSE psize:=remaining
            CopyMem(src,cache,psize)
            CopyMem(cache,dest,psize)
            bytes:=bytes+psize;src:=src+psize;dest:=dest+psize
      ENDWHILE
      FreeVec(cache)
ENDPROC



-> SAMPLE IMPORT




PROC loadaiff(slot,name,len,fh) HANDLE
      DEF buf,buf2,frames,bread,b:PTR TO CHAR
      DEF type,stereo,cache,cachesize,rcode,temp,hsiz
      DEF compos,res,chan,ssndpos,length,offset,flg,rate


      CDEBUG(SLOAD: AIFF loader used,0)

      buf:=0;cache:=0
      temp:=AllocVec(4096,MEMF_PUBLIC OR MEMF_CLEAR OR MEMF_REVERSE)
      IF temp=NIL THEN Raise("NMEM")
      Seek(fh,0,OFFSET_BEGINNING)
      IF len<4096 THEN hsiz:=len ELSE hsiz:=4096
      b:=Read(fh,temp,hsiz)
      IF b=-1 THEN Raise("RERR")
      compos:=findid(temp,"COMM",hsiz)
      IF compos=-1 THEN Raise("FPRO") -> file format problem
      chan:=Char(temp+compos+9);res:=Char(temp+compos+15)
      frames:=Long(temp+compos+10);rate:=ext2long(temp+compos+16)
      ssndpos:=findid(temp,"SSND",hsiz)
      IF ssndpos=-1 THEN Raise("FPRO") -> file format problem
      length:=Long(temp+ssndpos+4)-8
      offset:=ssndpos+16
      flg:=FALSE
      IF chan=1
            IF res=8
                  type:=FALSE
                  stereo:=FALSE
                  flg:=TRUE
            ELSEIF res=16
                  type:=MUI_TRUE
                  stereo:=FALSE
                  flg:=TRUE
            ENDIF
      ELSEIF chan=2
            IF res=8
                  type:=FALSE
                  stereo:=MUI_TRUE
                  flg:=TRUE
            ELSEIF res=16
                  type:=MUI_TRUE
                  stereo:=MUI_TRUE
                  flg:=TRUE
            ENDIF
      ENDIF
      CDEBUG(AIFF: Sample resolution \dbit,res)
      CDEBUG(AIFF: Channels \d,chan)
      CDEBUG(AIFF: Frames \d,frames)
      CDEBUG(AIFF: Length \d,length)
      CDEBUG(AIFF: Rate \dHz,rate)
      IF flg=FALSE THEN Raise("FPRO")


      buf:=AllocVec(length,memflag)
      IF buf=NIL THEN Raise("NMEM")
      cache,cachesize:=alloccache(length)
      IF cache=NIL THEN Raise("NMEM")

      percent('Loading AIFF sample')
      buf2:=buf;bread:=0
      Seek(fh,offset,OFFSET_BEGINNING)

      b:=Read(fh,cache,cachesize)
      IF b=-1 THEN Raise("RERR")
      CopyMem(cache,buf2,b);buf2:=buf2+b
      bread:=bread+b
      percent('Loading AIFF sample',bread,length)
      WHILE bread<length
            EXIT b=0
            b:=Read(fh,cache,cachesize)
            IF b=-1 THEN Raise("RERR")
            CopyMem(cache,buf2,b);buf2:=buf2+b
            bread:=bread+b
            percent('Loading AIFF sample',bread,length)
      ENDWHILE
      IF bread<length THEN logit('WARNING: Sample is incomplete!')
      fillsiodata(slot,name,buf,frames,type,stereo,rate)

      rcode:=SIO_OK
      EXCEPT DO
            SELECT exception
                  CASE "NMEM"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_NOMEM
                  CASE "RERR"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_READERROR
                  CASE "FPRO"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_FILEPROBLEM
            ENDSELECT
      IF cache THEN FreeVec(cache)
      IF temp THEN FreeVec(temp)
      sidle()
ENDPROC rcode


PROC loadwave(slot,name,len,fh) HANDLE
      DEF buf,buf2,frames,bread,b:PTR TO CHAR
      DEF type,stereo,cache,cachesize,rcode,temp,hsiz,blk
      DEF compos,res,chan,ssndpos,length,offset,flg,rate


      CDEBUG(SLOAD: WAVE loader used,0)

      buf:=0;cache:=0
      temp:=AllocVec(4096,MEMF_PUBLIC OR MEMF_CLEAR OR MEMF_REVERSE)
      IF temp=NIL THEN Raise("NMEM")
      Seek(fh,0,OFFSET_BEGINNING)
      IF len<4096 THEN hsiz:=len ELSE hsiz:=4096
      b:=Read(fh,temp,hsiz)
      IF b=-1 THEN Raise("RERR")
      compos:=findid(temp,"fmt ",hsiz) -> find fmt chunk
      IF compos=-1 THEN Raise("FPRO") -> file format problem
      IF readle16(temp+compos+8)<>1 THEN Raise("FPRO") -> compression not supported
      chan:=readle16(temp+compos+10);res:=readle16(temp+compos+22)
      rate:=readle32(temp+compos+12)
      blk:=readle16(temp+compos+20)
      ssndpos:=findid(temp,"data",hsiz)
      IF ssndpos=-1 THEN Raise("FPRO") -> file format problem
      length:=readle32(temp+ssndpos+4)
      frames:=Div(length,blk)
      offset:=ssndpos+8
      flg:=FALSE
      IF chan=1
            IF res=8
                  type:=FALSE
                  stereo:=FALSE
                  flg:=TRUE
            ELSEIF res=16
                  type:=MUI_TRUE
                  stereo:=FALSE
                  flg:=TRUE
            ENDIF
      ELSEIF chan=2
            IF res=8
                  type:=FALSE
                  stereo:=MUI_TRUE
                  flg:=TRUE
            ELSEIF res=16
                  type:=MUI_TRUE
                  stereo:=MUI_TRUE
                  flg:=TRUE
            ENDIF
      ENDIF
      CDEBUG(WAVE: Sample resolution \dbit,res)
      CDEBUG(WAVE: Channels \d,chan)
      CDEBUG(WAVE: Frames \d,frames)
      CDEBUG(WAVE: Length \d,length)
      CDEBUG(WAVE: Rate \dHz,rate)
      IF flg=FALSE THEN Raise("FPRO")


      buf:=AllocVec(length,memflag)
      IF buf=NIL THEN Raise("NMEM")
      cache,cachesize:=alloccache(length)
      IF cache=NIL THEN Raise("NMEM")

      percent('Loading WAVE sample')
      buf2:=buf;bread:=0
      Seek(fh,offset,OFFSET_BEGINNING)

      b:=Read(fh,cache,cachesize)
      IF b=-1 THEN Raise("RERR")
      wavecopy(cache,buf2,b,type,stereo);buf2:=buf2+b
      bread:=bread+b
      percent('Loading WAVE sample',bread,length)
      WHILE bread<length
            EXIT b=0
            b:=Read(fh,cache,cachesize)
            IF b=-1 THEN Raise("RERR")
            wavecopy(cache,buf2,b,type,stereo);buf2:=buf2+b
            bread:=bread+b
            percent('Loading WAVE sample',bread,length)
      ENDWHILE
      IF bread<length THEN logit('WARNING: Sample is incomplete!')
      fillsiodata(slot,name,buf,frames,type,stereo,rate)

      rcode:=SIO_OK
      EXCEPT DO
            SELECT exception
                  CASE "NMEM"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_NOMEM
                  CASE "RERR"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_READERROR
                  CASE "FPRO"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_FILEPROBLEM
            ENDSELECT
      IF cache THEN FreeVec(cache)
      IF temp THEN FreeVec(temp)
      sidle()
ENDPROC rcode






PROC loadmaud(slot,name,len,fh) HANDLE
      DEF buf,buf2,frames,bread,b:PTR TO CHAR
      DEF type,stereo,cache,cachesize,rcode,temp,hsiz
      DEF compos,res,chan,ssndpos,length,offset,flg,rate


      CDEBUG(SLOAD: MAUD loader used,0)

      buf:=0;cache:=0
      temp:=AllocVec(4096,MEMF_PUBLIC OR MEMF_CLEAR OR MEMF_REVERSE)
      IF temp=NIL THEN Raise("NMEM")
      Seek(fh,0,OFFSET_BEGINNING)
      IF len<4096 THEN hsiz:=len ELSE hsiz:=4096
      b:=Read(fh,temp,hsiz)
      IF b=-1 THEN Raise("RERR")
      compos:=findid(temp,"MHDR",hsiz)
      IF compos=-1 THEN Raise("FPRO") -> file format problem
      chan:=Int(temp+compos+$18);res:=Int(temp+compos+$0c)
      frames:=Long(temp+compos+8);rate:=Long(temp+compos+$10)
      IF chan>1 THEN frames:=Div(frames,chan)
      ssndpos:=findid(temp,"MDAT",hsiz)
      IF ssndpos=-1 THEN Raise("FPRO") -> file format problem
      length:=Long(temp+ssndpos+4)
      offset:=ssndpos+8
      flg:=FALSE
      IF chan=1
            IF res=8
                  type:=FALSE
                  stereo:=FALSE
                  flg:=TRUE
            ELSEIF res=16
                  type:=MUI_TRUE
                  stereo:=FALSE
                  flg:=TRUE
            ENDIF
      ELSEIF chan=2
            IF res=8
                  type:=FALSE
                  stereo:=MUI_TRUE
                  flg:=TRUE
            ELSEIF res=16
                  type:=MUI_TRUE
                  stereo:=MUI_TRUE
                  flg:=TRUE
            ENDIF
      ENDIF
      CDEBUG(MAUD: Sample resolution \dbit,res)
      CDEBUG(MAUD: Channels \d,chan)
      CDEBUG(MAUD: Frames \d,frames)
      CDEBUG(MAUD: Length \d,length)
      CDEBUG(MAUD: Rate \dHz,rate)
      IF flg=FALSE THEN Raise("FPRO")


      buf:=AllocVec(length,memflag)
      IF buf=NIL THEN Raise("NMEM")
      cache,cachesize:=alloccache(length)
      IF cache=NIL THEN Raise("NMEM")

      percent('Loading MAUD sample')
      buf2:=buf;bread:=0
      Seek(fh,offset,OFFSET_BEGINNING)

      b:=Read(fh,cache,cachesize)
      IF b=-1 THEN Raise("RERR")
      CopyMem(cache,buf2,b);buf2:=buf2+b
      bread:=bread+b
      percent('Loading MAUD sample',bread,length)
      WHILE bread<length
            EXIT b=0
            b:=Read(fh,cache,cachesize)
            IF b=-1 THEN Raise("RERR")
            CopyMem(cache,buf2,b);buf2:=buf2+b
            bread:=bread+b
            percent('Loading MAUD sample',bread,length)
      ENDWHILE
      IF res=8 THEN signed2unsigned(buf,buf+length) -> 8bit mauds are unsigned
      IF bread<length THEN logit('WARNING: Sample is incomplete!')
      fillsiodata(slot,name,buf,frames,type,stereo,rate)

      rcode:=SIO_OK
      EXCEPT DO
            SELECT exception
                  CASE "NMEM"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_NOMEM
                  CASE "RERR"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_READERROR
                  CASE "FPRO"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_FILEPROBLEM
            ENDSELECT
      IF cache THEN FreeVec(cache)
      IF temp THEN FreeVec(temp)
      sidle()
ENDPROC rcode


PROC load8svx(slot,name,len,fh) HANDLE -> Stereo samples not supported yet!
      DEF buf,buf2,frames,bread,b:PTR TO CHAR
      DEF type,stereo,cache,cachesize,rcode,temp,hsiz
      DEF compos,ssndpos,length,offset,flg,rate


      CDEBUG(SLOAD: 8SVX loader used,0)

      buf:=0;cache:=0
      temp:=AllocVec(4096,MEMF_PUBLIC OR MEMF_CLEAR OR MEMF_REVERSE)
      IF temp=NIL THEN Raise("NMEM")
      Seek(fh,0,OFFSET_BEGINNING)
      IF len<4096 THEN hsiz:=len ELSE hsiz:=4096
      b:=Read(fh,temp,hsiz)
      IF b=-1 THEN Raise("RERR")
      compos:=findid(temp,"VHDR",hsiz)
      IF compos=-1 THEN Raise("FPRO") -> file format problem
      rate:=Int(temp+compos+$14)
      IF rate<0 THEN rate:=rate AND $7FFFFFFF
      ssndpos:=findid(temp,"BODY",hsiz)
      IF ssndpos=-1 THEN Raise("FPRO") -> file format problem
      length:=Long(temp+ssndpos+4);frames:=length
      offset:=ssndpos+8
      flg:=FALSE

      type:=FALSE
      stereo:=FALSE
      flg:=TRUE

      CDEBUG(8SVX: Frames \d,frames)
      CDEBUG(8SVX: Length \d,length)
      CDEBUG(8SVX: Rate \dHz,rate)

      IF flg=FALSE THEN Raise("FPRO")


      buf:=AllocVec(length,memflag)
      IF buf=NIL THEN Raise("NMEM")
      cache,cachesize:=alloccache(length)
      IF cache=NIL THEN Raise("NMEM")

      percent('Loading 8SVX sample')
      buf2:=buf;bread:=0
      Seek(fh,offset,OFFSET_BEGINNING)

      b:=Read(fh,cache,cachesize)
      IF b=-1 THEN Raise("RERR")
      CopyMem(cache,buf2,b);buf2:=buf2+b
      bread:=bread+b
      percent('Loading 8SVX sample',bread,length)
      WHILE bread<length
            EXIT b=0
            b:=Read(fh,cache,cachesize)
            IF b=-1 THEN Raise("RERR")
            CopyMem(cache,buf2,b);buf2:=buf2+b
            bread:=bread+b
            percent('Loading 8SVX sample',bread,length)
      ENDWHILE
      IF bread<length THEN logit('WARNING: Sample is incomplete!')
      fillsiodata(slot,name,buf,frames,type,stereo,rate)

      rcode:=SIO_OK
      EXCEPT DO
            SELECT exception
                  CASE "NMEM"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_NOMEM
                  CASE "RERR"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_READERROR
                  CASE "FPRO"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_FILEPROBLEM
            ENDSELECT
      IF cache THEN FreeVec(cache)
      IF temp THEN FreeVec(temp)
      sidle()
ENDPROC rcode


PROC load16sv(slot,name,len,fh) HANDLE -> Stereo samples not supported yet!
      DEF buf,buf2,frames,bread,b:PTR TO CHAR
      DEF type,stereo,cache,cachesize,rcode,temp,hsiz
      DEF compos,ssndpos,length,offset,flg,rate


      CDEBUG(SLOAD: 16SV loader used,0)

      buf:=0;cache:=0
      temp:=AllocVec(4096,MEMF_PUBLIC OR MEMF_CLEAR OR MEMF_REVERSE)
      IF temp=NIL THEN Raise("NMEM")
      Seek(fh,0,OFFSET_BEGINNING)
      IF len<4096 THEN hsiz:=len ELSE hsiz:=4096
      b:=Read(fh,temp,hsiz)
      IF b=-1 THEN Raise("RERR")
      compos:=findid(temp,"VHDR",hsiz)
      IF compos=-1 THEN Raise("FPRO") -> file format problem
      IF Char(temp+compos+$17) THEN Raise("FPRO")
      frames:=Long(temp+compos+8);rate:=Int(temp+compos+$14)
      IF rate<0 THEN rate:=rate AND $7FFFFFFF
      ssndpos:=findid(temp,"BODY",hsiz)
      IF ssndpos=-1 THEN Raise("FPRO") -> file format problem
      length:=Long(temp+ssndpos+4)
      offset:=ssndpos+8
      flg:=FALSE

      type:=MUI_TRUE
      stereo:=FALSE
      flg:=TRUE

      CDEBUG(16SV: Frames \d,frames)
      CDEBUG(16SV: Length \d,length)
      CDEBUG(16SV: Rate \dHz,rate)

      IF flg=FALSE THEN Raise("FPRO")


      buf:=AllocVec(length,memflag)
      IF buf=NIL THEN Raise("NMEM")
      cache,cachesize:=alloccache(length)
      IF cache=NIL THEN Raise("NMEM")

      percent('Loading 16SV sample')
      buf2:=buf;bread:=0
      Seek(fh,offset,OFFSET_BEGINNING)

      b:=Read(fh,cache,cachesize)
      IF b=-1 THEN Raise("RERR")
      CopyMem(cache,buf2,b);buf2:=buf2+b
      bread:=bread+b
      percent('Loading 16SV sample',bread,length)
      WHILE bread<length
            EXIT b=0
            b:=Read(fh,cache,cachesize)
            IF b=-1 THEN Raise("RERR")
            CopyMem(cache,buf2,b);buf2:=buf2+b
            bread:=bread+b
            percent('Loading 16SV sample',bread,length)
      ENDWHILE
      IF bread<length THEN logit('WARNING: Sample is incomplete!')
      fillsiodata(slot,name,buf,frames,type,stereo,rate)

      rcode:=SIO_OK
      EXCEPT DO
            SELECT exception
                  CASE "NMEM"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_NOMEM
                  CASE "RERR"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_READERROR
                  CASE "FPRO"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_FILEPROBLEM
            ENDSELECT
      IF cache THEN FreeVec(cache)
      IF temp THEN FreeVec(temp)
      sidle()
ENDPROC rcode

PROC loadmpeg(slot,name,len,fh)
ENDPROC


PROC loadraw(slot,name,len,fh,senc,offset) HANDLE
      DEF buf,buf2,frames,bread,b:PTR TO CHAR
      DEF type,stereo,cache,cachesize,rcode

      -> NO HEADER
      len:=len-offset
      SELECT senc
            CASE SENC_PCM8
                  frames:=len
                  type:=FALSE
                  stereo:=FALSE
            CASE SENC_PCM16
                  frames:=Shr(len,1)
                  type:=MUI_TRUE
                  stereo:=FALSE
            CASE SENC_PCM8S
                  frames:=Shr(len,1)
                  type:=FALSE
                  stereo:=MUI_TRUE
            CASE SENC_PCM16S
                  frames:=Shr(len,2)
                  type:=MUI_TRUE
                  stereo:=MUI_TRUE
      ENDSELECT

      buf:=0;cache:=0
      buf:=AllocVec(len,memflag)
      IF buf=NIL THEN Raise("NMEM")
      cache,cachesize:=alloccache(len)
      IF cache=NIL THEN Raise("NMEM")

      percent('Loading RAW sample')
      buf2:=buf;bread:=0
      Seek(fh,offset,OFFSET_BEGINNING)

      b:=Read(fh,cache,cachesize)
      IF b=-1 THEN Raise("RERR")
      CopyMem(cache,buf2,b);buf2:=buf2+b
      bread:=bread+b
      percent('Loading RAW sample',bread,len)
      WHILE bread<len
            EXIT b=0
            b:=Read(fh,cache,cachesize)
            IF b=-1 THEN Raise("RERR")
            CopyMem(cache,buf2,b);buf2:=buf2+b
            bread:=bread+b
            percent('Loading RAW sample',bread,len)
      ENDWHILE
      IF bread<len THEN logit('Sample is incomplete!')
      fillsiodata(slot,name,buf,frames,type,stereo,44100)

      rcode:=SIO_OK
      EXCEPT DO
            SELECT exception
                  CASE "NMEM"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_NOMEM
                  CASE "RERR"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_READERROR
            ENDSELECT
      IF cache THEN FreeVec(cache)
      sidle()
ENDPROC rcode




-> SAMPLE EXPORT



PROC savemaud(slot,fh)
      errimp()
ENDPROC

PROC savewave(slot,fh)
      errimp()
ENDPROC

PROC save8svx(slot,fh)
      errimp()
ENDPROC

PROC saveraw(slot,fh) HANDLE
      DEF buf,buf2,bwritten,len,b,r,bb
      DEF cache,cachesize,rcode

      -> NO HEADER
      len:=siodata.length
      buf:=siodata.buf

      cache,cachesize:=alloccache(len)
      IF cache=NIL THEN Raise("NMEM")

      percent('Saving RAW sample')
      buf2:=buf;bwritten:=0;b:=len
      Seek(fh,0,OFFSET_BEGINNING)

      IF b<cachesize THEN bb:=b ELSE bb:=cachesize
      CopyMem(buf2,cache,bb);buf2:=buf2+bb;b:=b-bb
      r:=Write(fh,cache,bb)
      IF r=-1 THEN Raise("RERR")
      
      bwritten:=bwritten+bb
      percent('Saving RAW sample',bwritten,len)
      WHILE bwritten<len
            IF b<cachesize THEN bb:=b ELSE bb:=cachesize
            EXIT bb=0
            CopyMem(buf2,cache,bb);buf2:=buf2+bb;b:=b-bb
            r:=Write(fh,cache,bb)
            IF r=-1 THEN Raise("WERR")
            
            bwritten:=bwritten+bb
            percent('Saving RAW sample',bwritten,len)
      ENDWHILE

      rcode:=SIO_OK
      EXCEPT DO
            SELECT exception
                  CASE "NMEM"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_NOMEM
                  CASE "WERR"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_WRITEERROR
            ENDSELECT
      IF cache THEN FreeVec(cache)
      sidle()
ENDPROC

/*OBJECT obj_form
      id,chunksize,form
ENDOBJECT

OBJECT obj_comm
      id,chunksize
      channels:INT
      frames
      samplesize:INT
      rate[10]:ARRAY
ENDOBJECT

OBJECT obj_ssnd
      id,chunksize
      unused,unused2
ENDOBJECT

 */


PROC saveaiff(slot,fh) HANDLE
      DEF buf,buf2,bwritten,len,b,r,bb
      DEF cache,cachesize,rcode

      DEF form:obj_form,comm:obj_comm,ssnd:obj_ssnd

      -> Header setup
      ssnd.id:="SSND";ssnd.chunksize:=siodata.length+8
      ssnd.unused:=0;ssnd.unused2:=0
      comm.id:="COMM";comm.frames:=siodata.frames
      comm.chunksize:=(SIZEOF obj_comm)-8
      long2ext(comm.rate,siodata.rate)
      IF siodata.stereo THEN comm.channels:=2 ELSE comm.channels:=1
      IF siodata.type THEN comm.samplesize:=16 ELSE comm.samplesize:=8
      form.id:="FORM";form.form:="AIFF"
      form.chunksize:=ssnd.chunksize+12+SIZEOF obj_comm
      -> Write header
      Seek(fh,0,OFFSET_BEGINNING)
      Write(fh,form,SIZEOF obj_form)
      Write(fh,comm,SIZEOF obj_comm)
      Write(fh,ssnd,SIZEOF obj_ssnd)

      -> Write other
      len:=siodata.length
      buf:=siodata.buf

      cache,cachesize:=alloccache(len)
      IF cache=NIL THEN Raise("NMEM")

      percent('Saving AIFF sample')
      buf2:=buf;bwritten:=0;b:=len

      IF b<cachesize THEN bb:=b ELSE bb:=cachesize
      CopyMem(buf2,cache,bb);buf2:=buf2+bb;b:=b-bb
      r:=Write(fh,cache,bb)
      IF r=-1 THEN Raise("RERR")
      bwritten:=bwritten+bb
      percent('Saving AIFF sample',bwritten,len)

      WHILE bwritten<len
            IF b<cachesize THEN bb:=b ELSE bb:=cachesize
            EXIT bb=0
            CopyMem(buf2,cache,bb);buf2:=buf2+bb;b:=b-bb
            r:=Write(fh,cache,bb)
            IF r=-1 THEN Raise("WERR")

            bwritten:=bwritten+bb
            percent('Saving AIFF sample',bwritten,len)
      ENDWHILE

      rcode:=SIO_OK
      EXCEPT DO
            SELECT exception
                  CASE "NMEM"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_NOMEM
                  CASE "WERR"
                        IF buf THEN FreeVec(buf)
                        rcode:=SIO_WRITEERROR
            ENDSELECT
      IF cache THEN FreeVec(cache)
      sidle()
ENDPROC

