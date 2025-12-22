->MODULE 'grio/file'

CONST JSRT=$4EB9,JMPT=$4EF9,LEA0=$41F9,LEA1=$43F9,LEA2=$45F9,LEA3=$47F9,
      LEA4=$49F9,LEA5=$4BF9,LEA6=$4DF9

PROC main()
DEF file=$78780000,size=$80000,tab:PTR TO INT,count,x,temp
->IF arg[]=0
->   WriteF('USAGE: <rom image>\n')
->   RETURN
->ENDIF
tab:=[JSRT,JMPT,LEA0,LEA1,LEA2,LEA3,LEA4,LEA5,LEA6]:INT
->file,size:=gReadFile(arg)
Disable()
IF file
   FOR count:=0 TO size STEP 2
      FOR x:=0 TO ListLen(tab)-1
	  IF tab[x]=Int(file+count)
	     temp:=Shr(Long(file+count+2),8)
	     temp:=Shr(Shr(temp,8),4)
	     IF temp=$F
		temp:=Long(file+count+2)-$F80000
		/*
		WriteF('puting new address (count = \d) $\h,\h,\h\n',
		count,Long(file+count),Long(file+count+4),Long(file+count+8))
		*/
		PutLong(file+count+2,$7BF80000+temp)
		INC count,6
	     ELSEIF Shr(temp,8)=$7
		INC count,6
	     ENDIF
	  ENDIF
      ENDFOR
      EXIT CtrlC()=TRUE
   ENDFOR
   PutLong(file+$7FFE8,romresum(file,size))
  -> gWriteFile('ram:Kick',file,size)
  -> gFreeFile(file)
ENDIF
Enable()
ENDPROC


PROC romresum(rom,size)
  MOVE.L  rom,A0
  MOVE.L  size,D0
  MOVE.L  D0,D1
  LSR.L   #2,D1
  MOVE.L  -$18(A0,D0.L),D0
  NOT.L   D0
  rr_loop:
  ADD.L   (A0)+,D0
  BCC.B   rr_skip
  ADDQ.L  #1,D0
  rr_skip:
  SUBQ.L  #1,D1
  BNE.B   rr_loop
  NOT.L   D0
ENDPROC D0

