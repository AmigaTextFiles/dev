OPT MODULE

MODULE  'amigalib/lists'
MODULE  'exec/lists'
MODULE  'exec/nodes'

CONST   ED_MAXLEN = 255         /* Maximal 256 byte (Zeichen) in eine Zeile!            */

OBJECT line
 ln:ln                          /* Exec-Listen-Node                                     */
 num                            /* Zeilennummer...                                      */
 buf[ED_MAXLEN]:ARRAY OF CHAR   /* Zeilenbuffer...                                      */
 size                           /* so viele bytes sind in >buf< genutzt!                */
ENDOBJECT

EXPORT OBJECT editor            /* Klasse des Editor-Objekts...                         */
 num                            /* Zeilennummer                                         */
PRIVATE                         /* Geht keinen was an!                                  */
 linelist:PTR TO lh             /* Hier die liste der lines... (PTR)                    */
 maxlines                       /* Soviele Lines sind es!                               */
ENDOBJECT

PROC init()     OF editor       /* Klasse initialisieren!                               */
 NEW self.linelist              /* Speicher für die Liste holen...                      */
  IF self.linelist=NIL THEN RETURN FALSE
   newList(self.linelist)       /* Liste initialisieren                                 */
    self.num:=0
ENDPROC TRUE

PROC exit()     OF editor       /* Alles wieder freigeben!                              */
 DEF    line:PTR TO line,
        nextline
  line:=self.linelist.head
   WHILE nextline:=line.ln.succ
    END line
     line:=nextline
   ENDWHILE
ENDPROC

PROC newline(buf,size) OF editor
 DEF    line:PTR TO line,
        num
  NEW line
   IF line=NIL THEN RETURN FALSE
    num:=self.num
     num++
      self.num:=num
       line.num:=num
        AstrCopy(line.buf,buf,size)
         line.size:=size
          line.ln.pri:=num
           line.ln.name:=line.buf
            AddTail(self.linelist,line)
ENDPROC TRUE

PROC getline(num,buf) OF editor
 DEF    line:PTR TO line
  line:=jumpline(self.linelist,line,num)
   AstrCopy(buf,line.buf,line.size)
ENDPROC line.size

PROC remline(num) OF editor
 DEF    line:PTR TO line,
        nextline:PTR TO line,
        predline:PTR TO line
  line:=jumpline(self.linelist,line,num)
   predline:=line.ln.pred
    nextline:=line.ln.succ
     predline.ln.succ:=nextline
      nextline.ln.pred:=predline
       END line
ENDPROC

PROC setline(num,buf,size) OF editor
 DEF    line:PTR TO line
  line:=jumpline(self.linelist,line,num)
   AstrCopy(line.buf,buf,size)
ENDPROC

PROC insline(num,buf,size) OF editor
 DEF    line:PTR TO line,
        predline:PTR TO line,
        succline:PTR TO line,
        nextline,
        linenum
 num:=num-2
  predline:=jumpline(self.linelist,predline,num)
   succline:=predline.ln.succ
    NEW line
     IF line=NIL THEN RETURN FALSE
      AstrCopy(line.buf,buf,size)
       line.size:=size
        linenum:=self.num
         linenum++
          self.num:=linenum
           linenum:=succline.num
            line.ln.pri:=linenum
             line.num:=linenum
              line.ln.name:=line.buf
               WHILE (nextline:=succline.ln.succ)
                succline:=nextline
                 succline.num:=succline.num+1
                  succline.ln.pri:=succline.num+1
               ENDWHILE
                Insert(self.linelist,line,predline)
ENDPROC TRUE

PROC inschars(num,buf,size,pos) OF editor
 DEF    line:PTR TO line,
        newbuf[ED_MAXLEN]:STRING,
        rightstr[ED_MAXLEN]:STRING
  line:=jumpline(self.linelist,line,num)
   MidStr(newbuf,line.buf,1,pos)
    AstrCopy(newbuf,buf,size)
     MidStr(rightstr,line.buf,pos+1,line.size)
      StrAdd(newbuf,rightstr,line.size-(pos+1))
       line.size:=StrLen(newbuf)
        AstrCopy(line.buf,newbuf,line.size)
ENDPROC

PROC remchars(num,size,pos) OF editor
 DEF    line:PTR TO line,
        newbuf[ED_MAXLEN]:STRING,
        rightstr[ED_MAXLEN]:STRING
  line:=jumpline(self.linelist,line,num)
   MidStr(newbuf,line.buf,1,pos)
    MidStr(rightstr,line.buf,pos+size+1,line.size)
     StrAdd(newbuf,rightstr,line.size-(pos+1))
      line.size:=StrLen(newbuf)
       AstrCopy(line.buf,newbuf,line.size)
ENDPROC

PROC jumpline(linelist:PTR TO lh,line:PTR TO line,num)
 DEF a
  line:=linelist.head
   FOR a:=1 TO num
    line:=line.ln.succ
   ENDFOR
ENDPROC line

PROC getlist() OF editor        IS self.linelist
