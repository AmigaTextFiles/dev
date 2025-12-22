/* Bin/Edoc2Guide

POur gagner de la place (pourquoi en fait?), mais aussi pour convertir être
facilement converti en .guide, E.doc est uniquement distribué au format
ascii, qui peut être mis au format .guide en utilisant ce programme.
(la version compilée est dans le répertoire bin/).

1> edoc2guide e:docs/e.doc

donnera un fichier e.doc.guide, que vous pourrez rennomer en 'e.guide'.

ATTENTION: le datatype AmigaGuide (multiview) semble sauter tous les "\"
           dans le texte, ce qui est embêtant avec les '\n' etc.
           C'est un bug, car l'AmigaGuide v34 marche bien. I vous conseille
           de lire le doc avec la v34 de toute façon, car il est mieux pour
           d'autre chose aussi.

*/

OPT OSVERSION=37

MODULE 'tools/file'

PROC main() HANDLE
  DEF m=NIL,l,n,list,myargs:PTR TO LONG,rdargs=NIL,fh=NIL,outf[50]:STRING
  IF (rdargs:=ReadArgs('DOC/A',myargs:=[0],NIL))=NIL THEN Raise("RDAR")
  m,l:=readfile(myargs[])
  list:=stringsinfile(m,l,n:=countstrings(m,l))
  StrCopy(outf,myargs[])
  StrAdd(outf,'.guide')
  IF (fh:=Open(outf,NEWFILE))=NIL THEN Raise("OPEN")
  process(fh,list,n)
EXCEPT DO
  IF fh THEN Close(fh)
  IF rdargs THEN FreeArgs(rdargs)
  IF m THEN freefile(m)
  SELECT exception
    CASE "RDAR"; WriteF('Mauvais argument!\n')
    CASE "NEW";  WriteF('Pas de mémoire!\n')
    CASE "OPEN"; WriteF('Ne peut pas ouvrir le fichier!\n')
  ENDSELECT
ENDPROC

PROC process(fh,list:PTR TO LONG,num)
  DEF line,l:PTR TO CHAR,c,s[500]:STRING,a,b,d
  Fputs(fh,'@database "e.guide"\n@node MAIN\n@title "Amiga E v3.0a"\n')
  FOR line:=0 TO num-1
     l:=list[line]
     IF StrCmp(l,'\t    ',5)
       IF l[6]="."
         c:=l[5]
         IF cap(c)
           StringF(s,'\t  @{"  \c. \s  " link CH_\d\c }',c,l+8,a,c)
           l:=s
         ENDIF
       ENDIF
     ELSE
       a,b:=Val(l)
       IF b
         c:=l[b]
         IF cap(c)
           IF (l[b+1]=".") AND (l[b+2]=" ")
             IF StrCmp(list[line+1],'------',6)
               StringF(s,'@endnode\n@node CH_\d\c\n@title "\s"\n\s',a,c,l,l)
               l:=s
             ENDIF
           ENDIF
         ENDIF
       ELSEIF StrCmp(l,'+-----',6)
         IF StrCmp(list[line+1],'|',1)
           IF StrCmp(list[line+2],'+-----',6)
             line:=line+3
             l:=list[line]
           ENDIF
         ENDIF
       ELSEIF (b:=InStr(l,'(see ',0))<>-1
         b:=b+5
         l[b-1]:=0
         a,c:=Val(l+b)
         IF c
           d:=b+c
           c:=l[d]
           IF cap(c)
             StringF(s,'\s @{" \d\c " link CH_\d\c }\s',l,a,c,a,c,l+d+1)
             l:=s
           ENDIF
         ENDIF
       ENDIF
     ENDIF
     Fputs(fh,l)
     FputC(fh,"\n")
  ENDFOR
  Fputs(fh,'@endnode\n')
ENDPROC

PROC cap(c) IS IF c>="A" THEN c<="Z" ELSE FALSE
