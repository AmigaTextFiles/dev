
MODULE 'dos/dos','exec/memory','grio/skiparg',
       'grio/str/decstr2num','grio/char'


CONST START_HEADER_SIZE=30


DEF fh


PROC main()

DEF num , fill ,buf=NIL , nr=0, val=6 , x 
DEF p:PTR TO LONG , name[110]:STRING ,p2 , p3
DEF n2=$2000000,filter=$FFFF,cpu
IF arg[]
   cpu:=getCPU()
   skiparg(arg)
   x:=StrLen(arg)
   IF arg[x-1]="O" THEN arg[x-1]:="o"
   IF StrCmp(arg+x-2,'.o',ALL)
      StrCopy(name,arg,ALL)
      arg[x-2]:=0
   ELSE
      StringF(name,'\s.o',arg)
   ENDIF
   IF (fh:=Open(name,OLDFILE))
      num:=FileLength(name)
      IF (buf:=AllocMem(num+4,MEMF_ANY))
         ^buf:=num+4
         buf:=buf+4
         Read(fh,buf,num)
         WriteF('reading file "\s" , size = \d\n',name,num)
      ENDIF
      Close(fh)
   ELSE
      WriteF('can\at open file "\s"\n',name)
      RETURN
   ENDIF

   IF buf
      StringF(name,'\s.m',arg)
      IF (fh:=Open(name,NEWFILE))
         p:=buf
         REPEAT
            fill:=^p++
            num:=num-4
         UNTIL (fill=$3E9) OR (num=0)
         IF num > 0
            PutInt({startHeader}+16,cpu)
            write({startHeader},START_HEADER_SIZE)
            fill:=(^p*4)+4
            write(p,fill)
            p:=p+fill
            IF p[]=$3EC
               p++
               fill:=(p[])*4
               write([7]:INT,2)
               write(p,4)
               p:=p+8
               write(p,fill)
               p:=p+fill+4
            ENDIF
            IF p[]<>$3EF
               Close(fh)
               JUMP deletefile
            ENDIF
            write([4]:INT,2)
            p2:=p:=p+4
            num:=0
            WHILE (fill:=p[]++)
               x:=(fill AND filter)*4
               IF (fill>=n2)
                  INC nr
                  val:=val+x+6
               ELSE
                  INC num
               ENDIF
               p:=p+x+4
            ENDWHILE
            p3:=p:=p2
            WHILE num
                fill:=p[]++
                x:=(fill AND filter)*4
                p:=p+x
                IF (fill<n2) AND (fill>=$1000000)
                   symbols(p-x,p)
                   DEC num
                ENDIF
                p++
            ENDWHILE
            write([-1,IF nr THEN 1 ELSE 0]:INT,4)
            IF nr
               p:=p3
               write([val]:LONG,4)
               WHILE nr
                    fill:=p[]++
                    num:=(fill AND filter)*4
                    IF (fill>=n2)
                       p2:=(-2 AND (num+3))
                       write([p2]:INT,2)
                       p3:=p
                       p:=p+num
                       write(p,4)
                       p[]++:=0
                       UpperStr(p3)
                       write(p3,num)
                       FOR x:=num TO p2-1 DO Out(fh,0)
                       DEC nr
                    ELSE
                       p:=p+num+4
                    ENDIF
               ENDWHILE
               write([0]:INT,2)
            ENDIF
         ENDIF
         Close(fh)
         num:=FileLength(name)
         IF num>0
            WriteF('writing "\s" , size = \d\n',name,num)
         ELSE
            deletefile:
            DeleteFile(name)
         ENDIF
      ENDIF
      buf:=buf-4
      FreeMem(buf,^buf)
   ENDIF
ELSE
   WriteF('USAGE: <object name>\n')
ENDIF

ENDPROC


startHeader:

CHAR 'EMOD'
INT  5,0,0,33,2,$9800
INT  0,0,0,$A,0,0,3



PROC symbols(ptr,start)
DEF  align , len , pos , s[10]:STRING , dp ,name ,
     def , ls[20]:LIST , lens

name:=ptr
IF (pos:=InStr(name,'_',1)) > 0
   IF name[pos+1]="_"
      AstrCopy(name+pos+1,name+pos+2,ALL)
      pos:=InStr(name,'_',pos+1)
   ENDIF
   IF pos>0
      name[pos]:=0
      ListAdd(ls,[name+pos+1],1)
   ENDIF
ENDIF
len:=StrLen(name)
align:=(-2 AND (len+1))
IF align=len THEN align:=align+2
write([align]:INT,2)
name[]:=lowerChar(name[])
write(name,len)
REPEAT
   Out(fh,0)
   DEC align
UNTIL align=len
ptr:=ptr+len
lens:=StrLen(ptr+1)
IF ListLen(ls)
   pos:=0
   REPEAT
      IF (pos:=InStr(ptr,'_',pos+1)) > 0
         IF ptr[pos+1]="_"
            AstrCopy(ptr+pos+1,ptr+pos+2,ALL)
            pos:=InStr(ptr,'_',pos+1)
            DEC lens
         ENDIF
         IF pos >0
            ptr[pos]:=0
            ListAdd(ls,[ptr+pos+1],1)
         ENDIF
      ENDIF
   UNTIL pos=-1
ENDIF
write(start,4)
write([1,ListLen(ls)]:INT,4)
len:=ListLen(ls)
WriteF('PROC \s(\s',name,IF len=0 THEN ')\n' ELSE '')
IF len
   FOR dp:=0 TO len-1
       WriteF('\s',ls[dp])
       WriteF(IF (dp+1)=ListLen(ls) THEN ')\n' ELSE ',')
   ENDFOR
ENDIF
dp:=0
IF len
   FOR len:=len-1 TO 0 STEP -1
       WriteF('value for "\s" parameter (y/n) : ',ls[len])
       ReadStr(stdin,s)
       EXIT ($20 OR s[])<>"y"
       INC dp
   ENDFOR
ENDIF
write([dp]:LONG,4)
len:=ListLen(ls)
WHILE dp
     WriteF('enter value for "\s" parameter : ',ls[len-dp])
     ReadStr(stdin,s)
     def:=decStr2Num(IF (s[]="-") OR (s[]="+") THEN s+1 ELSE s)
     IF def=-1
        WriteF('bad value , try again\n')
     ELSE
        write([IF s[]="-" THEN -def ELSE def]:LONG,4)
        DEC dp
     ENDIF
ENDWHILE
IF len
   align:=(-2 AND (lens+1))
   IF align=lens THEN align:=align+2
   write([align]:INT,2)
   FOR dp:=0 TO len-1
       write(ls[dp],StrLen(ls[dp]))
       IF (dp+1)<len THEN Out(fh,",")
   ENDFOR
   INC len
   REPEAT
      Out(fh,0)
      DEC align
   UNTIL align=lens
ELSE
   write([0]:INT,2)
ENDIF

ENDPROC



PROC write(buf,len) IS Write(fh,buf,len)



PROC getCPU()
DEF cpu[5]:STRING,x,y=-1
WriteF('Enter CPU type for this module: ')
x:=ReadStr(stdin,cpu)
IF x=5
   Exists({x},['68000','68010','68020','68030','68040','68060',''],`(y:=y+1) BUT StrCmp(cpu,x))
   IF y=6
      badcpu()
   ENDIF
   y:=Shr(y,1)
ELSEIF x=0
   y:=0
ELSE
   badcpu()
ENDIF
ENDPROC y

PROC badcpu()
WriteF('You typed bad name of CPU\n')
CleanUp()
ENDPROC


