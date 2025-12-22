
MODULE 'grio/e/readstr','other/skipwhite','other/skipnonwhite'

PROC main()
DEF rd,args[2]:ARRAY OF LONG,ptr:PTR TO LONG,fh,
    s[500]:STRING,fht,tst,x,y

IF rd:=ReadArgs('FILES/A/M,TO/K/A',args,NIL)
   ptr:=^args
   IF fht:=Open(args[1],NEWFILE)
      Out(fht,"\n")
      WHILE ^ptr
         StringF(s,' ;  \s \n\n',^ptr)
         Write(fht,s,EstrLen(s))
         StringF(s,'C:StripC \s \s',^ptr,{temp})
         IF SystemTagList(s,NIL)=0
	    IF fh:=Open({temp},OLDFILE)
	       WHILE gReadStr(fh,s)>=0
                   IF (tst:=InStr(s,'EQU'))<0
		      IF (tst:=InStr(s,'equ'))<0
		         IF (tst:=InStr(s,'Equ'))<0
			    tst:=InStr(s,'=')
		         ENDIF
		      ENDIF
		   ENDIF
		   IF tst>0
                      IF (" "=s[tst-1]) OR ("\t"=s[tst-1])
                         x:=skipNonWhite(s)-s
		         Write(fht,s,x)
                         y:=3-(x/8)
                         FOR x:=1 TO y DO Out(fht,"\t")
                         Write(fht,'EQU\t',STRLEN)
                         tst:=skipWhite(skipNonWhite(tst+s))
                         Write(fht,tst,StrLen(tst))
		         Out(fht,"\n")
                      ENDIF
		   ENDIF
	       ENDWHILE
               Out(fht,"\n")
               Close(fh)
            ENDIF
	 ENDIF
	 ptr++
      ENDWHILE
      Close(fht)
   ENDIF
ELSE
   PrintFault(IoErr(),NIL)
ENDIF
ENDPROC


temp:
  CHAR 'T:GetEquTemp',0

