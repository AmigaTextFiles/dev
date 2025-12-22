
OPT MODULE
OPT REG=5
OPT OSVERSION=36


MODULE 'dos/dosextens','dos/dos','dos/rdargs'

MODULE 'other/skipwhite'



OBJECT path
  next:LONG
  lock:LONG
ENDOBJECT





EXPORT OBJECT segtool PRIVATE
stack  : LONG
resseg : LONG
segl   : LONG
name   : LONG
ENDOBJECT




PROC find(name) OF segtool

DEF dir , cli:PTR TO commandlineinterface , segl
DEF path:PTR TO path , seg:PTR TO segment


segl := seg :=NIL

IF (cli := Cli())

   self.stack := Shl(cli.defaultstack,2)

   self.name := name

   IF (segl:=LoadSeg(name))=NIL

      IF (name = FilePart(name) )

         Forbid()
         IF (seg:=FindSegment(name,0,1))
            IF (0 <= seg.uc)
               segl:=seg.seg
               seg.uc:=seg.uc+1
            ELSE
               IF (-2 = seg.uc)
                  segl:=seg.seg
               ELSE
                  seg:=NIL
               ENDIF
            ENDIF
         ENDIF
         Permit()

         IF segl=NIL
            path:=Shl(cli.commanddir,2)
            WHILE segl=NIL
                EXIT path=NIL
                dir:=CurrentDir(path.lock)
                segl:=LoadSeg(name)
                CurrentDir(dir)
                path:=Shl(path.next,2)
            ENDWHILE
         ENDIF

         IF segl=NIL
            IF (dir:=Lock('C:',SHARED_LOCK))
               dir:=CurrentDir(dir)
               segl:=LoadSeg(name)
               UnLock(CurrentDir(dir))
            ENDIF
         ENDIF

      ENDIF

   ENDIF

ENDIF

self.resseg := seg

self.segl   := segl


ENDPROC segl




PROC free() OF segtool

DEF seg:PTR TO segment

   IF (seg:=self.resseg)
      Forbid()
      IF (seg.uc > 0) THEN seg.uc:=seg.uc-1
      Permit()
   ELSE
      IF self.segl THEN UnLoadSeg(self.segl)
   ENDIF

ENDPROC



PROC run(argline) OF segtool

DEF pos,in,out,buf[512]:ARRAY,cs:csource

  IF self.segl
     in:=out:=0
     IF (pos:=InStr(argline,'<',0)) > -1
        in:=skipWhite(argline+pos+1)
        IF ">"=in[] THEN in:=out:=skipWhite(in+1)
        StrLen(in)
        MOVEA.L  cs,A0
        MOVE.L   in,(A0)+  /* csource.buffer */
        MOVE.L   D0,(A0)+  /* csource.length */
        CLR.L    (A0)      /* csource.curchr */
        ReadItem(buf,512,cs)
        AstrCopy(argline+pos,in+cs.curchr)
        in:=Open(buf,OLDFILE)
     ENDIF
     IF out=NIL
        IF (pos:=InStr(argline,'>')) > -1
           out:=skipWhite(argline+pos+1)
           StrLen(out)
           MOVEA.L  cs,A0
           MOVE.L   out,(A0)+ /* csource.buffer */
           MOVE.L   D0,(A0)+  /* csource.length */
           CLR.L    (A0)      /* csource.curchr */
           ReadItem(buf,512,cs)
           AstrCopy(argline+pos,out+cs.curchr)
        ENDIF
     ENDIF
     IF out THEN out:=Open(buf,NEWFILE)
     SetProgramName(self.name)
     IF in  THEN in :=SelectInput(in)
     IF out THEN out:=SelectOutput(out)
     RunCommand(self.segl,self.stack,argline,StrLen(argline))
     IF in  THEN Close(SelectInput(in))
     IF out THEN Close(SelectOutput(out))
  ENDIF

ENDPROC

