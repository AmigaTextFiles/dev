/* Noise Compiler v1.0       */
/* Compilateur de NoiseTracker v1.0 */
/* TraductionOlivier ANH (BUGSS) */

OBJECT sym              /* structure primaire de symboles de réécriture */
  next,type,name,rptr
ENDOBJECT

OBJECT rlist            /* structure de liste liée pour la grammaire */

  next,type,index,info
ENDOBJECT

OBJECT optset           /* structure pour stocker { | | } */
  next,rptr,weight
ENDOBJECT

OBJECT sample           /* toutes les données à propos d'un sample */
  path,len,adr,vol
ENDOBJECT

OBJECT i                /* indexation des arbres réécrit */
  start,len,isym
ENDOBJECT

ENUM SYM,OPTSET,OPTION,NOTE,SAMPLE,SFX          /* rlist.type   */
ENUM NOTYPE,REWRITE                             /* sym.type     */
ENUM NOMEM,NOFILE,NOFORM,NOGRAM,STACKFLOW,      /* erreurs      */
     BADSTRUCTURE,BREAK,WRITEMOD,READSAMPLE

CONST MAXINDEX=1000,MAXROWS=64*4*64,MAXDURATION=100
CONST MAXDATA=MAXROWS*4,MAXSAMPLE=31,MAXNOTE=23,MINNOTE=-12
CONST PARSE_ER=100,GEN_ER=200,MASK=$0FFF0FFF

RAISE NOMEM IF New()=NIL,                       /* définie les exceptions */
      NOMEM IF String()=NIL,
      STACKFLOW IF FreeStack()<1000,
      BREAK IF CtrlC()=TRUE

DEF buf,flen,p,tokeninfo,symlist=NIL:PTR TO sym,ltoken=-1,numsample=0,
    notes,np:PTR TO LONG,maxrows=0,cursample=0,cursfx=0,curglob=0,end,
    timings:PTR TO INT,fh=NIL,notevals:PTR TO LONG

DEF sdata[32]:ARRAY OF sample,
    itab[MAXINDEX]:ARRAY OF i,
    channel[4]:ARRAY OF i,
    infile[100]:STRING,outfile[100]:STRING

PROC main() HANDLE
  WriteF('Noise Compiler v1.0\n')
  WriteF('Traduit les fichiers compatible Noise en module ProTracker !\n')
  readgrammar()
  WriteF('Grammaire "\s" chargée. Analyse...\n',infile)
  parsegrammar()
  WriteF('Grammaire analysée avec succès. Génération...\n')
  generate()
  WriteF('Noise généré. Chargement des samples...\n')
  loadsamples()
  WriteF('Sauvegarde du fichier "\s".\n',outfile)
  writemodule()
  WriteF('done.\n')
EXCEPT
  IF fh THEN Close(fh)           /* Handlers des exceptions les plus basses */
  WriteF('Programme terminé: ')  /* report des grosses erreurs*/
  SELECT exception
    CASE NOFILE;       WriteF('Ne peut charger le fichier grammaire "\s" !\n',infile)
    CASE NOMEM;        WriteF('Pas assez de mémoire !\n')
    CASE NOFORM;       WriteF('Érreur du format grammaticale !\n')
    CASE STACKFLOW;    WriteF('Dépacement de la pile ! (récursion trop profonde ?)\n')
    CASE BADSTRUCTURE; WriteF('Problème à la génération.\n')
    CASE NOGRAM;       WriteF('Pas de rêgle réécrite!\n')
    CASE BREAK;        WriteF('Stoppé par l''utilisateur\n')
    CASE WRITEMOD;     WriteF('Impossible d''écrire le module PT "\s" !\n',outfile)
    CASE READSAMPLE;   WriteF('Impossible de lire les sample(s) !\n')
  ENDSELECT
ENDPROC

PROC readgrammar()
  StrCopy(infile,arg,ALL)
  StrAdd(infile,'.ngr',ALL)     /* '#?.ngr' = NoizGRammar */
  StrCopy(outfile,arg,ALL)      /* '#?.mod' = format ProTracker */
  StrAdd(outfile,'.mod',ALL)
  IF (flen:=FileLength(infile))<1 THEN Raise(NOFILE)
  IF (fh:=Open(infile,OLDFILE))=NIL THEN Raise(NOFILE)
  IF Read(fh,buf:=New(flen+1),flen)<>flen THEN Raise(NOFILE)
  Close(fh)
  fh:=NIL
  buf[flen]:=";"        /* pour analyser */
ENDPROC

/* c'est la partie analyse. on utilise une simple mais puissante analyse de
   haut en bas et construit notre arbre syntaxique ici.  */

ENUM ER_UNTOKEN=PARSE_ER,ER_UNEXPECTED,ER_QUOTE,ER_SYMEXP,ER_DOUBLE,
     ER_ARROWEXP,ER_RPARENTHEXP,ER_RBRACEEXP,ER_EMPTY,ER_EOLEXP,ER_RANGE,
     ER_COMMENT,ER_UNDEF,ER_RBRACKETEXP,ER_MAXSAMPLE,ER_NOSAMPLE,
     ER_INTEGEREXP,ER_COMMAEXP,ER_NOTEEXP

ENUM EOF,EOL,ARROW,BAR,COMMA,           /* ; -> | ,     */
     RSYM,INTEGER,HEXINTEGER,           /* sym 100 $E01 */
     ISTRING,NOTEVAL,                   /* "" C#+       */
     LBRACE,RBRACE,LPARENTH,            /* { } (        */
     RPARENTH,LBRACKET,RBRACKET         /* ) [ ]        */

PROC parsegrammar() HANDLE
  DEF end,spot,sl:PTR TO sym,s,i
  notevals:=[9,11,0,2,4,5,7]
  p:=buf
  WHILE parserule() DO NOP
  p:=NIL
  IF (sl:=symlist)=NIL THEN Raise(NOGRAM)
  IF numsample=0 THEN Raise(ER_NOSAMPLE)
  REPEAT
    IF sl.type=NOTYPE            /* vérifie si symboles indéfinis */
      s:=sl.name
      Raise(ER_UNDEF)
    ENDIF
  UNTIL (sl:=sl.next)=NIL
EXCEPT                         /* re-saute si exception inconnue*/
  IF exception>=PARSE_ER THEN WriteF('ERROR: ') ELSE Raise(exception)
  WriteF(ListItem(['Contenu léxical en faute\n',
    'Mauvais caractères en ligne !\n',
    'Nombre impaire d''apostrophes"\n',
    'Manque un symbole\n',
    'Double définition d''un symbole\n',           /* érreurs langage */
    'Manque "->"\n',
    'Manque ")"\n',
    'Manque "}"\n',
    'Liste de réécriture vide\n',
    'Manque la fin des règles (End of rule)\n',
    'Valeur Entière/Note hors norme\n',
    'Commentaire(s) incorrect(s)\n',
    'Pas de règle définie pour le symbole "\s"\n',
    'Manque "]"\n',
    'Plus de 32 samples\n',
    'Grammaire a besoin d'au moins un sample\n',
    'Manque un entier\n',
    'Manque ","\n',
    'Manque une note'],exception-PARSE_ER),s)
  IF p                /* affiche une indication utile des érreurs*/
    IF p[-1]=";" THEN DEC p
    spot:=p
    WHILE (p[]--<>";") AND (p[]<>10) AND (p<>buf) DO NOP
    INC p
    spot:=spot-p+5
    end:=p
    WHILE (end[]<>";") AND (end[]++<>10) DO NOP
    end[]--:=0
    WriteF('LINE: \s\n',p)
    FOR i:=1 TO spot DO WriteF(' ')
    WriteF('^\n')
  ENDIF
  Raise(NOFORM)
ENDPROC

PROC parserule()
  DEF token,csym:PTR TO sym
  IF (token:=gettoken())=EOF
    RETURN FALSE
  ELSEIF token=RSYM
    csym:=tokeninfo
    IF csym.type<>NOTYPE THEN Raise(ER_DOUBLE)
    IF gettoken()<>ARROW THEN Raise(ER_ARROWEXP)
    csym.rptr:=parseitemlist()
    csym.type:=REWRITE
    IF gettoken()<>EOL THEN Raise(ER_EOLEXP)
  ELSE
    Raise(ER_SYMEXP)
  ENDIF
ENDPROC TRUE

PROC parseitemlist()
  DEF item:PTR TO rlist,prev:PTR TO rlist,ilist=NIL
  prev:={ilist}
  WHILE (item:=parseitem())<>NIL
    prev.next:=item
    prev:=item
  ENDWHILE
  IF ilist=NIL THEN Raise(ER_EMPTY)
ENDPROC ilist

PROC parseitem()
  DEF token,item:PTR TO rlist,t2,prev:PTR TO optset,
      curr:PTR TO optset,olist,totalw=0
  token:=gettoken()
  IF token=RSYM
    item:=New(SIZEOF rlist)
    item.type:=SYM
    item.info:=tokeninfo
    IF (t2:=gettoken())=INTEGER
      item.index:=checkinfo(1,MAXINDEX-1)
    ELSE
      putback(t2)
      item.index=0
    ENDIF
  ELSEIF token=ISTRING
    item:=New(SIZEOF rlist)
    item.type:=SAMPLE
    sdata[numsample].path:=tokeninfo
    IF (t2:=gettoken())=INTEGER
      sdata[numsample].vol:=checkinfo(0,64)
    ELSE
      putback(t2)
      sdata[numsample].vol:=64
    ENDIF
    item.info:=numsample++
    IF numsample=MAXSAMPLE THEN Raise(ER_MAXSAMPLE)
  ELSEIF token=LBRACE          /* analyse { | | ... } */
    item:=New(SIZEOF rlist)
    item.type:=OPTSET
    prev:={olist}
    REPEAT
      curr:=New(SIZEOF optset)
      IF (token:=gettoken())=INTEGER        /* vérifie la largeur */
        curr.weight:=checkinfo(0,1000)
      ELSE
        curr.weight:=1
        putback(token)
      ENDIF
      totalw:=totalw+curr.weight
      curr.rptr:=parseitemlist()
      prev.next:=curr
      prev:=curr
    UNTIL (token:=gettoken())<>BAR
    IF token<>RBRACE THEN Raise(ER_RBRACEEXP)
    item.info:=olist
    item.index:=totalw     /* on stocke la largeur ici */
  ELSEIF token=LPARENTH
    item:=New(SIZEOF rlist)             /* analyse ( ) */
    item.type:=OPTION
    IF (token:=gettoken())=INTEGER        /* vérifie la largeur */
      item.index:=checkinfo(0,1000)
    ELSE
      item.index:=500
      putback(token)
    ENDIF
    item.info:=parseitemlist()
    IF gettoken()<>RPARENTH THEN Raise(ER_RPARENTHEXP)
  ELSEIF token=LBRACKET
    item:=New(SIZEOF rlist)             /* analyse [note,durée] */
    item.type:=NOTE
    token:=gettoken()
    IF (token<>INTEGER) AND (token<>NOTEVAL) THEN Raise(ER_NOTEEXP)
    item.info:=checkinfo(MINNOTE,MAXNOTE)
    IF gettoken()<>COMMA THEN Raise(ER_COMMAEXP)
    IF gettoken()<>INTEGER THEN Raise(ER_INTEGEREXP)
    item.index:=checkinfo(1,MAXDURATION)
    IF gettoken()<>RBRACKET THEN Raise(ER_RBRACKETEXP)
  ELSEIF token=HEXINTEGER
    item:=New(SIZEOF rlist)             /* analyse $SFX */
    item.type:=SFX
    item.info:=checkinfo(0,$FFF)
  ELSEIF (token=EOL) OR (token=RBRACE) OR (token=RPARENTH) OR (token=BAR)
    putback(token)
    RETURN NIL
  ELSE
    Raise(ER_UNTOKEN)
  ENDIF
ENDPROC item

/* l'analyseur léxical : appelé par l'analyseur chaque fois qu'il a besoin
   d'un token. Les valeurs attribue sont dans "tokeninfos".
   allows for one symbol lookahead, with putback() function */

PROC gettoken()
  DEF c,x,start,len,syml:PTR TO sym,s,depth
  FreeStack(); CtrlC()
  IF ltoken<>-1
    x:=ltoken
    ltoken:=-1
    RETURN x
  ENDIF
  tokeninfo:=0
  parse:
  c:=p[]++
  SELECT c
    CASE ";"; RETURN IF buf+flen<p THEN p-- BUT EOF ELSE EOL
    CASE "|"; RETURN BAR
    CASE ","; RETURN COMMA
    CASE "("; RETURN LPARENTH
    CASE ")"; RETURN RPARENTH
    CASE "{"; RETURN LBRACE
    CASE "}"; RETURN RBRACE
    CASE "["; RETURN LBRACKET
    CASE "]"; RETURN RBRACKET
    CASE "-"; IF p[]=">" THEN RETURN p++ BUT ARROW
    CASE "/"
      IF p[]="*"
        x:=p
        depth:=1
        WHILE buf+flen>p++
          IF (p[0]="/") AND (p[1]="*")
            INC depth
            INC p
          ENDIF
          IF (p[0]="*") AND (p[1]="/")
            DEC depth
            INC p
          ENDIF
          IF depth=0
            INC p
            BRA parse
          ENDIF
        ENDWHILE
        p:=x
        Raise(ER_COMMENT)
      ENDIF
      Raise(ER_UNEXPECTED)
    CASE 34
      start:=p
      WHILE (p[]<>";") AND (p[]<>10) AND (p[]++<>34) DO NOP
      IF p[-1]=";" THEN p-- BUT Raise(ER_QUOTE)
      len:=p-start-1
      tokeninfo:=String(len)
      StrCopy(tokeninfo,start,len)
      RETURN ISTRING
    DEFAULT
      IF (c>="a") AND (c<="z")
        start:=p--
        WHILE (p[]>="a") AND (p[]++<="z") DO NOP
        len:=p---start
        s:=String(len)
        StrCopy(s,start,len)
        syml:=symlist
        WHILE syml
          IF StrCmp(s,syml.name,ALL) THEN BRA found
          syml:=syml.next
        ENDWHILE
        syml:=New(SIZEOF sym)
        syml.next:=symlist
        syml.name:=s
        syml.type:=NOTYPE
        symlist:=tokeninfo:=syml
        RETURN RSYM
        found:
        tokeninfo:=syml
        RETURN RSYM
      ELSEIF (c>="A") AND (c<="G")
        tokeninfo:=notevals[c-"A"]
        LOOP
          x:=p[]++
          SELECT x
            CASE "+"; tokeninfo:=tokeninfo+12           /* octave sup   */
            CASE "-"; tokeninfo:=tokeninfo-12           /* octave inf   */
            CASE "#"; tokeninfo:=tokeninfo+1            /* piqué        */
            CASE "b"; tokeninfo:=tokeninfo-1            /* plat         */
            DEFAULT
              DEC p
              RETURN NOTEVAL
          ENDSELECT
        ENDLOOP
      ELSEIF ((c>="0") AND (c<="9")) OR (c="-") OR (c="$")
        tokeninfo:=Val(p--,{x})
        p:=p+x
        RETURN IF c="$" THEN HEXINTEGER ELSE INTEGER
      ENDIF
      IF c>32 THEN Raise(ER_UNEXPECTED) ELSE BRA parse
  ENDSELECT
ENDPROC

PROC putback(token)
  ltoken:=token
ENDPROC

PROC checkinfo(min,max) RETURN IF (tokeninfo<min) OR (tokeninfo>max) THEN
  Raise(ER_RANGE) ELSE tokeninfo

ENUM NOCHANNEL=GEN_ER,LARGESONG,CROSSINDEX

PROC generate() HANDLE
  DEF x,ci:PTR TO i,syms:PTR TO LONG,numc=0
  Rnd(-Shl(VbeamPos(),14))        /* initialise seed */
  ci:=itab
  FOR x:=0 TO MAXINDEX-1 DO ci[].start++:=NIL
  ci:=channel
  timings:=[856,808,762,720,678,640,604,570,538,508,480,453,
            428,404,381,360,339,320,302,285,269,254,240,226,
            214,202,190,180,170,160,151,143,135,127,120,113]:INT
  /*        C-  C#- D-  D#- E-  F-  F#- G-  G#- A-  A#- B-
            C   C#  D   D#  E   F   F#  G   G#  A   A#  B
            C+  C#+ D+  D#+ E+  F+  F#+ G+  G#+ A+  A#+ B+     */
  np:=notes:=New(MAXDURATION*4+100+MAXDATA)
  end:=np+MAXDATA
  syms:=['one','two','three','four']
  FOR x:=0 TO 3
    ci[x].start:=np
    IF findsym(syms[x])
      ci[x].len:=np-ci[x].start
      IF ci[x].len>maxrows THEN maxrows:=ci[x].len
      INC numc
    ELSE
      ci[x].start:=NIL
    ENDIF
  ENDFOR
  IF numc=0 THEN Raise(NOCHANNEL)
  IF maxrows=0 THEN Raise(NOGRAM)
  IF maxrows>MAXROWS THEN Raise(LARGESONG)
EXCEPT
  IF exception>=GEN_ER THEN WriteF('ERROR: ')
  SELECT exception
    CASE NOCHANNEL;  WriteF('Un canal doit être au moins défini\n')
    CASE LARGESONG;  WriteF('Song trop grand !\n')
    CASE CROSSINDEX; WriteF('Pas d'indéxation permise cross-symbol\n')
    DEFAULT;         Raise(exception)         /* re-saute si inconnu */
  ENDSELECT
  Raise(BADSTRUCTURE)        /* termine */
ENDPROC

PROC findsym(name)
  DEF s:PTR TO sym
  s:=symlist
  WHILE s
    IF StrCmp(s.name,name,ALL) THEN BRA.S continue
    s:=s.next
  ENDWHILE
  RETURN FALSE
  continue:
  rewritelist(s.rptr)
ENDPROC TRUE

PROC rewritelist(list:PTR TO rlist)
  WHILE list
    rewritesym(list)
    list:=list.next
  ENDWHILE
ENDPROC

PROC rewritesym(rsym:PTR TO rlist)
  DEF t,sl:PTR TO sym,rnd,c1,c2,ol:PTR TO optset,x,i,st:PTR TO LONG,l,n
  FreeStack(); CtrlC()
  t:=rsym.type
  SELECT t
    CASE SYM
      sl:=rsym.info
      IF i:=rsym.index
        st:=itab[i].start
        l:=itab[i].len
        IF st
          IF np+l>=end THEN Raise(LARGESONG)
          IF sl<>itab[i].isym THEN Raise(CROSSINDEX)
          l:=Shr(l,2)
          IF l THEN FOR x:=1 TO l DO np[]++:=IF n:=st[]++ THEN
            n AND MASK OR curglob ELSE 0
        ELSE
          st:=np
          rewritelist(sl.rptr)
          itab[i].len:=np-st
          itab[i].start:=st
          itab[i].isym:=sl
        ENDIF
      ELSE
        rewritelist(sl.rptr)
      ENDIF
    CASE OPTION
      IF Rnd(1001)<rsym.index THEN rewritelist(rsym.info)
    CASE OPTSET
      rnd:=Rnd(rsym.index)
      c1:=c2:=0
      ol:=rsym.info
      WHILE ol
        c2:=c1+ol.weight
        IF (rnd>=c1) AND (rnd<c2) THEN rewritelist(ol.rptr)
        c1:=c2
        ol:=ol.next
      ENDWHILE
    CASE NOTE
      np[]++:=cursfx OR curglob OR Shl(timings[rsym.info+-MINNOTE],16)
      IF rsym.index>1 THEN FOR x:=2 TO rsym.index DO np[]++:=0
      IF np>=end THEN Raise(LARGESONG)
      cursfx:=0
    CASE SAMPLE
      cursample:=rsym.info
      curglob:=Shl(cursample+1 AND $F,12) OR Shl(cursample+1 AND $F0,24)
    CASE SFX
      cursfx:=rsym.info
  ENDSELECT
ENDPROC

PROC loadsamples() HANDLE
  DEF s:PTR TO sample,i,l,r,f:PTR TO LONG
  s:=sdata
  FOR i:=1 TO numsample
    IF (l:=FileLength(s.path))<10 THEN Raise(0)
    s.len:=l
    s.adr:=New(l)
    IF (fh:=Open(s.path,OLDFILE))=NIL THEN Raise(0)
    r:=Read(fh,s.adr,l)
    Close(fh)
    fh:=NIL
    IF r<10 THEN Raise(0)
    f:=s.adr
    IF f[]="FORM"
      WHILE f[]++<>"BODY" DO IF s.adr+l<f THEN Raise(0)
      s.len:=l+s.adr-f
      s.adr:=f
    ENDIF
    s++
  ENDFOR
EXCEPT
  WriteF('En travaillant le sample "\s":\n',s.path)
  Raise(READSAMPLE)
ENDPROC

PROC writemodule()
  DEF s,x,pnum,dat[4]:ARRAY OF LONG,nument,n,ch:PTR TO LONG,len,wl
  IF (fh:=Open(outfile,NEWFILE))=NIL THEN Raise(WRITEMOD)
  Write(fh,StringF(s:=String(19),'\l\s[20]',arg) BUT s,20)
  FOR x:=0 TO MAXSAMPLE-1
    wl:=Shr(sdata[x].len,1)
    IF x>=numsample
      Write(fh,[0,0,0,0,0,0,0,0],30)
    ELSE
      Write(fh,sdata[x].path,21)
      Out(fh,0)
      Write(fh,[wl,sdata[x].vol,0,1]:INT,8)  /* or [,,wl,] */
    ENDIF
  ENDFOR
  IF (pnum:=maxrows/256)*256<>maxrows THEN INC pnum
  Out(fh,pnum)
  Out(fh,120)  /* 127 */
  FOR x:=0 TO pnum-1 DO Out(fh,x)
  FOR x:=pnum TO 127 DO Out(fh,0)
  Write(fh,["M.K."],4)
  nument:=pnum*64-1
  FOR x:=0 TO nument
    FOR n:=0 TO 3
      ch:=channel[n].start
      IF ch
        len:=channel[n].len
        IF len
          dat[n]:=ch[]++
          channel[n].start:=ch
          channel[n].len:=len-4
        ELSE
          dat[n]:=0
        ENDIF
      ELSE
        dat[n]:=0
      ENDIF
    ENDFOR
    Write(fh,dat,16)
  ENDFOR
  FOR x:=0 TO numsample-1
    Write(fh,sdata[x].adr,sdata[x].len)
  ENDFOR
  Close(fh)
  fh:=NIL
ENDPROC
