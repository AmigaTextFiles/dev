
PROC main()
DEF fh,nfh,buf,size=10000,len,ptr,ptrs,char,temp,s[108]:STRING
IF arg[]
   IF (buf:=New(size))
      IF (fh:=Open(arg,OLDFILE))
         StringF(s,'\s!',arg)
         IF (nfh:=Open(s,NEWFILE))
            REPEAT
               len:=Read(fh,buf,size)
               ptr:=ptrs:=buf
               ptr[len]:=0
               WHILE (char:=ptr[]++)
                     ptrs[]++:=char
                     IF char=34
                        temp:=ptr
                        REPEAT
                           char:=ptr[]++
                           IF (char=10) OR (char=0)
                              ptr:=temp
                              char:=34
                           ENDIF  
                        UNTIL char=34
                        WHILE (ptr<>temp) DO ptrs[]++:=temp[]++
                     ELSEIF char=32
                        WHILE ptr[]=32 DO ptr++
                     ENDIF
               ENDWHILE
               Write(nfh,buf,ptrs-buf)
            UNTIL size>len
            Close(nfh)
         ENDIF
         Close(fh)
      ENDIF
      Dispose(buf)
   ENDIF
ENDIF
ENDPROC

