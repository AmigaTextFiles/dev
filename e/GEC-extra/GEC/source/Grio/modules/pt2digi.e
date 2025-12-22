->OPT MODULE
OPT PREPROCESS
OPT REG=5


#define TEST

OBJECT ptsaminfo
   samname[22]:ARRAY
   samlen:INT               -> divided by 2
   finetune:CHAR
   volume:CHAR
   repeat:INT               -> div by 2
   replen:INT               -> div by 2
ENDOBJECT

OBJECT ptmod
  songname[20]:ARRAY
  saminfo[31]:ARRAY OF ptsaminfo
  songlen:CHAR
  blah:CHAR
  pattpos[128]:ARRAY
  mahkak:LONG               -> Mahoney and Kaktus identify : "M.K."
  /* pattdata numpatts*1024 */
  /* sample data in raw */
ENDOBJECT


OBJECT digisam
    samname[30]:ARRAY       ->  ended by zero
ENDOBJECT

OBJECT packpatt
    len:INT
    packtable[64]:ARRAY
ENDOBJECT



OBJECT digi NOALIGN
   header:LONG
   text[16]:ARRAY
   vers:LONG
   verh:CHAR                -> 1.7 = $17
   chanused:CHAR            -> always 8
   packenable:CHAR          -> 1 for packed pattern data , 0 for none
   reserved[19]:ARRAY
   patnum:CHAR
   ordnum:CHAR
   orders[128]:ARRAY
   samlens[31]:ARRAY OF LONG
   samreps[31]:ARRAY OF LONG
   samrepslens[31]:ARRAY OF LONG
   samvols[31]:ARRAY
   samfins[31]:ARRAY
   songname[32]:ARRAY       -> ended by zero
   samplenames[31]:ARRAY OF digisam
  /* pattern data ( 1 pat = 1024) = 1024*patnum */
  /* sample data in raw */
ENDOBJECT



EXPORT PROC pt2DIGI(ptmod)
DEF pt:PTR TO ptmod,digi:PTR TO digi,x,bufpat,
    pi=0:PTR TO ptsaminfo,big,patnum,j,size
IF (pt:=ptmod)
   IF (digi:=New(SIZEOF digi))
      digi.header:="DIGI"
      AstrCopy(digi.text,' Booster module',ALL)
      digi.vers:="V1.7"
      digi.verh:=$17
      digi.chanused:=8
      digi.ordnum:=pt.songlen-1
      digi.packenable:=1
      digi.reserved[0]:=1
      big:=0
      FOR x:=0 TO 128-1
	  pi:=pt.pattpos[x]
	  digi.orders[x]:=pi
	  IF pi>big THEN big:=pi
      ENDFOR
      digi.patnum:=big
      pi:=20+pt
      FOR x:=0 TO 31-1
	  digi.samlens[x]:=Shl(pi.samlen,1)
	  digi.samreps[x]:=Shl(pi.repeat,1)
	  IF pi.replen>1 THEN
	     digi.samrepslens[x]:=Shl(pi.replen,1)
	  j:=pi.finetune
	  IF j>8 THEN j:=j-16
	  digi.samfins[x]:=j
	  digi.samvols[x]:=pi.volume
	  AstrCopy(digi.samplenames[x],pi.samname,23)
	  pi++
      ENDFOR
      AstrCopy(digi.songname,pt.songname,21)
      x:=0
      pi:=pt+SIZEOF ptmod
      INC big
      patnum:=big
      IF (bufpat:=New(j:=Mul(1090,1+patnum)))   -> 4 safe extra pattern buff
	 CopyMem(pi,bufpat,j)
	 size:=0
	 WHILE big
	     j:=pattpack(x+pi,bufpat+size)
	     size:=size+j
	     x:=x+1024
	     DEC big
	 ENDWHILE
	 CopyMem(digi,pt,SIZEOF digi)
	 CopyMem(bufpat,pi:=pt+SIZEOF digi,size)
	 Dispose(bufpat)
	 pi:=pi+size
	 big:=Mul(patnum,1024)+pt+SIZEOF ptmod
	 FOR x:=0 TO 31-1
	     IF (j:=digi.samlens[x])
		CopyMem(big,pi,j)
		pi:=pi+j
		big:=big+j
	     ENDIF
	 ENDFOR
      ELSE
	 RETURN NIL
      ENDIF
      Dispose(digi)
   ENDIF
ENDIF
ENDPROC pi-pt


PROC pattpack(patt,poscopy)
   MOVEM.L  D3-D5,-(A7)
   MOVEA.L  patt,A0
   MOVEA.L  poscopy,A1
   LEA      66(A1),A2
   ADDQ.L   #2,A1
   MOVEQ    #64,D2
   MOVEQ    #64-1,D3
begin:
   MOVEQ    #0,D0
   MOVEQ    #7,D1
loop:
   MOVE.L   (A0)+,D4
   BEQ.S    skip
   MOVE.W   D4,D5
   ANDI.W   #$0FFF,D5
   CMPI.W   #$0600,D5
   BNE.S    no600
   ANDI.W   #$FDFF,D4
   BRA.S    save
no600:
   CMPI.W   #$0A00,D5
   BNE.S    noA00
   ANDI.W   #$F0FF,D4
   BRA.S    save
noA00:
   CMPI.W   #$0800,D5
   BNE.S    save
   ANDI.W   #$F000,D4
save:
   TST.L    D4
   BEQ.S    skip
   MOVE.L   D4,(A2)+
   BSET     D1,D0
   ADDQ.W   #4,D2
skip:
   SUBQ.W   #2,D1
   BPL.S    loop
   MOVE.B   D0,(A1)+
   DBF      D3,begin
   MOVEA.L  poscopy,A1
   MOVE.W   D2,(A1)
   MOVEQ    #0,D0
   MOVE.W   D2,D0
   ADDQ.L   #2,D0
   MOVEM.L  (A7)+,D3-D5
ENDPROC D0


#ifdef TEST

MODULE 'grio/file'

PROC main()
DEF file,name[108]:STRING,pos
IF arg[]
   IF (file:=gReadFile(arg))
       IF (pos:=InStri(arg,'mod'))>=0
	  IF arg[pos+3]="."
	     arg:=arg+4
	  ELSEIF (pos>0) AND (arg[pos-1]=".")
	     arg[pos-1]:=0
	  ENDIF
       ENDIF
       StringF(name,'\s.DIGI',arg)
       gWriteFile(name,file,pt2DIGI(file))
       gFreeFile(file)
   ENDIF
ENDIF
ENDPROC

#endif

