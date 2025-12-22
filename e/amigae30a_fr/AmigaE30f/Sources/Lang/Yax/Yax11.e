/* Interpréteur YAX (Yet Another Instruction Code Set) v1.0
   Langage procédural/fonctionnel simple avec une syntaxe proche du lisp.
   Dévore de préférence les sources avec extension .yax au dîner.
   Traduction : Olivier ANH (BUGSS)
*/


OPT STACK=25000     /* il y aura de grosse récursions */

OBJECT var          /* c'est là que l'on stocke les valeurs runtime */
  type:INT
  name:LONG
  value:LONG
ENDOBJECT

/* codes intermediaires */
ENUM ENDSOURCE,VALUE,ISTRING,IDENT,LBRACKET,RBRACKET

/* mots clefs */
ENUM FWRITE=100,FADD,FEQ,FUNEQ,FSUB,FMUL,FDIV,FAND,FORX,FNOT,FIF,FDO,
     FSELECT,FSET,FFOR,FWHILE,FUNTIL,FDEFUN,FLAMBDA,FAPPLY,FREADINT,
     FARRAY,FGREATER,FSMALLER,FLOCATE,FCLS,FDUMP,FWINDOW,FTELL,FTOLD,
     FSEE,FSEEN,FSTRING,FREAD,FGET,FPUT,FFILELEN,FLINE,FPLOT,FBOX,
     FMOUSEX,FMOUSEY,FMOUSE,FTEXT,LAST

CONST KEYWORDSIZE=8,
      NRKEYWORDS=LAST-99,
      IDENTNAMESPACE=30000,
      VARSTACKSPACE=50000,
      MAXARGS=5,
      ERLEN=60

/* erreurs */
ENUM ER_WORKSPACE=1,ER_BUF,ER_GARBAGE,ER_SYNTAX,ER_EXPKEYWORD,ER_EXPRBRACKET,
     ER_EXPEXP,ER_QUOTE,ER_COMMENT,ER_INFILE,ER_SOURCEMEM,ER_EXPIDENT,
     ER_ARGS,ER_TYPE,ER_EXPLBRACKET,ER_STACK,ER_ALLOC,ER_ARRAY,ER_FILE,
     ER_GFXWIN,ER_VALUES

/* types de variables */
ENUM TINTEGER=1,TSTRING,TFUNC,TARRAY

DEF source,slen,erpos=NIL,
    ilen,ibuf,ipos:PTR TO INT,p:PTR TO INT,idents,
    name[100]:STRING,wfile,
    inputbuf[100]:STRING,winspec[100]:STRING,
    vartop,varbottom,vars,rec,globvar,
    infile,outfile,oldout,oldin,stdin,gfxwindow=0

PROC main()
  WriteF(''); stdin:=stdout
  loadsource()
  ilen:=Mul(slen,4)+1000       /* a besoin de l'espace nécessaire */
  ibuf:=New(ilen+10)
  idents:=String(IDENTNAMESPACE)
  vars:=New(VARSTACKSPACE)
  vartop:=vars; varbottom:=vars
  IF (ibuf=NIL) OR (idents=NIL) OR (vars=NIL)
    error(ER_WORKSPACE)
  ELSE
    lexanalyse()               /* traduit au format intermédiaire */
    p:=ibuf
    WHILE p[]<>ENDSOURCE DO eval()       /* lance le code */
  ENDIF
  error(0)
ENDPROC

PROC lexanalyse()
  DEF pos,end,c,count,ident[50]:STRING,pos2,keypos,a,nr,ident2[50]:STRING
  pos:=source; end:=pos+slen; ipos:=ibuf; erpos:=pos
  StrCopy(idents,' ',1)
  loop:
  c:=pos[]++
  IF c>96                          /* un identificateur */
    pos2:=pos-1
    WHILE pos[]++>96 DO NOP; DEC pos
    StrCopy(ident,pos2,pos-pos2)
    StrCopy(ident2,ident,ALL)
    StrAdd(ident,'..............',ALL)
    keypos:={keywords}
    nr:=0
    FOR a:=1 TO NRKEYWORDS         /* cherche le mot clef */
      IF StrCmp(ident,keypos,KEYWORDSIZE)
        nr:=99+a
        JUMP found
      ENDIF
      keypos:=keypos+KEYWORDSIZE
    ENDFOR
    found:
    IF nr>0                        /* mot clef */
      iword(nr)
    ELSE                           /* propre identificateur */
      iword(IDENT)
      StrCopy(ident,' ',1)
      StrAdd(ident,ident2,ALL)
      StrAdd(ident,' ',1)
      pos2:=InStr(idents,ident,0)
      IF pos2=-1
        ilong(EstrLen(idents)+idents)
        StrAdd(idents,ident2,ALL)
        StrAdd(idents,' ',1)
        IF EstrLen(idents)=StrMax(idents) THEN error(ER_WORKSPACE)
      ELSE
        ilong(pos2+idents+1)
      ENDIF
    ENDIF
  ELSE
    SELECT c                       /* autre chose */
      CASE " "
        IF pos<end THEN JUMP loop
      CASE "("
        iword(LBRACKET)
        erpos:=pos-1
        ilong(erpos)
      CASE ")"; iword(RBRACKET)
      CASE "+"; iword(FADD)
      CASE "-"
        IF pos[]=" "
          iword(FSUB)
        ELSE
          iword(VALUE)
          ilong(-Val(pos,{c}))
          IF c=0 THEN error(ER_GARBAGE) ELSE pos:=pos+c
        ENDIF
      CASE "*"; iword(FMUL)
      CASE "/"
        IF pos[]<>"*"
          iword(FDIV)
        ELSE                       /* commentaire (comme celui-ci) */
          INC pos
          WHILE pos-1<end
            INC count
            IF (pos[]++="*") AND (pos[]="/") THEN JUMP out
          ENDWHILE
          error(ER_COMMENT)
          out:
          INC pos
        ENDIF
      CASE "="
        iword(FEQ)
      CASE "?"
        iword(FUNEQ)
      CASE "'"                     /* constante  de chaine de caractères */
        iword(ISTRING)
        count:=0; pos2:=pos
        WHILE pos[]++<>"'"
          INC count
          IF pos=end THEN error(ER_QUOTE)
        ENDWHILE
        iword(count)
        ilong(pos2)                /* adresse caractère */
      CASE 10
        IF pos<end THEN JUMP loop
      CASE 0
        pos:=end
      CASE 9
        IF pos<end THEN JUMP loop
      DEFAULT
        iword(VALUE)
        ilong(Val(pos--,{c}))
        IF c=0 THEN error(ER_GARBAGE) ELSE pos:=pos+c
    ENDSELECT
  ENDIF
  IF pos<end THEN JUMP loop
  iword(ENDSOURCE)
ENDPROC

PROC checkstop()
  IF FreeStack()<1000 THEN error(ER_STACK)
  IF CtrlC() THEN error(-1)
ENDPROC

PROC eval()                        /* fonction principale d'évaluation de la récursion */
  DEF r=0,i,ins,p2,x:PTR TO LONG,a,adr:PTR TO var
  checkstop()
  i:=p[]++
  SELECT i
    CASE VALUE
      r:=^p++
    CASE IDENT
      r:=varvalue(^p++,TINTEGER)
    CASE LBRACKET
      erpos:=^p++
      ins:=p[]++
      IF ins=IDENT
        adr:=findvar(^p++)
        IF adr.type=TFUNC
          r:=dofunc(adr.value)
        ELSE
          IF adr.type<>TARRAY THEN error(ER_TYPE)
          x:=adr.value
          a:=eval()
          IF (a<0) OR (a>x[]) THEN error(ER_ARRAY)
          r:=x[a+1]
        ENDIF
      ELSE
        IF ins<100 THEN error(ER_EXPKEYWORD)
        SELECT ins
          CASE FWRITE                /* sortie de la constante chaine + expressions */
            x:=TRUE
            WHILE p[]<>RBRACKET
              IF p[]=ISTRING
                Write(stdout,Long(p+4),p[1])
                IF (p[1]=0) AND (p[4]=RBRACKET) THEN x:=FALSE
                p:=p+8
              ELSEIF p[]=IDENT
                IF (Int(findvar(Long(p+2)))=TSTRING)
                  WriteF('\s',eatstring())
                ELSE
                  WriteF('\d',eval())
                ENDIF
              ELSE
                WriteF('\d',eval())
              ENDIF
            ENDWHILE
            IF x THEN WriteF('\n')
          CASE FEQ
            r:=TRUE
            x:=eval()
            WHILE p[]<>RBRACKET DO IF x<>eval() THEN r:=FALSE
          CASE FUNEQ; r:=eval()<>eval()
          CASE FGREATER; r:=eval()>eval()
          CASE FSMALLER; r:=eval()<eval()
          CASE FADD; r:=eval(); WHILE p[]<>RBRACKET DO r:=r+eval()
          CASE FSUB; r:=eval(); WHILE p[]<>RBRACKET DO r:=r-eval()
          CASE FMUL; r:=eval(); WHILE p[]<>RBRACKET DO r:=Mul(r,eval())
          CASE FDIV; r:=eval(); WHILE p[]<>RBRACKET DO r:=Div(r,eval())
          CASE FAND; r:=eval(); WHILE p[]<>RBRACKET DO r:=r AND eval()
          CASE FORX; r:=eval(); WHILE p[]<>RBRACKET DO r:=r OR eval()
          CASE FNOT; r:=Not(eval())
          CASE FIF
            IF eval()
              r:=eval()
              IF p[]<>RBRACKET THEN skip()
            ELSE
              skip()
              IF p[]<>RBRACKET THEN r:=eval()
            ENDIF
          CASE FDO; WHILE p[]<>RBRACKET DO r:=eval()
          CASE FSELECT
            x:=eval()
            WHILE p[]<>RBRACKET DO IF x=eval() THEN r:=eval() ELSE skip()
          CASE FSET
            IF p[]=LBRACKET
              p:=p+2
              erpos:=^p++
              x:=varvalue(eatident(),TARRAY)
              a:=eval()
              IF (a<0) OR (a>x[0]) THEN error(ER_ARRAY)
              IF p[]++<>RBRACKET THEN error(ER_EXPRBRACKET)
              x[a+1]:=eval()
            ELSE
              x:=eatident()
              IF (p[]=LBRACKET) AND (p[3]=FLAMBDA)
                p:=p+8
                adr:=findvar(x)
                letvar(adr,p,TFUNC)
                WHILE p[]<>RBRACKET DO skip()
                p:=p+2
              ELSE
                r:=eval()
                x:=findvar(x)
                letvar(x,r,TINTEGER)
              ENDIF
            ENDIF
          CASE FFOR
            x:=eatident()
            r:=eval()
            adr:=findvar(x)
            x:=eval()
            p2:=p
            IF r>x               /* descend */
              FOR a:=r TO x STEP -1
                p:=p2
                letvar(adr,a,TINTEGER)
                WHILE p[]<>RBRACKET DO eval()
              ENDFOR
            ELSE
              FOR a:=r TO x
                p:=p2
                letvar(adr,a,TINTEGER)
                WHILE p[]<>RBRACKET DO eval()
              ENDFOR
            ENDIF
            r:=0
          CASE FWHILE
            p2:=p
            WHILE eval()
              WHILE p[]<>RBRACKET DO eval()
              p:=p2
            ENDWHILE
            WHILE p[]<>RBRACKET DO skip()
            r:=0
          CASE FUNTIL
            p2:=p
            WHILE eval()=FALSE
              WHILE p[]<>RBRACKET DO eval()
              p:=p2
            ENDWHILE
            WHILE p[]<>RBRACKET DO skip()
            r:=0
          CASE FDEFUN
            x:=eatident()
            adr:=findvar(x)
            letvar(adr,p,TFUNC)
            WHILE p[]<>RBRACKET DO skip()
          CASE FLAMBDA; error(ER_SYNTAX)
          CASE FAPPLY
            IF p[]<>IDENT
              IF (p[]<>LBRACKET) OR (p[3]<>FLAMBDA) THEN error(ER_EXPIDENT)
              p:=p+8; adr:=p
              WHILE p[]<>RBRACKET DO skip()
              p:=p+2
              r:=dofunc(adr)
            ELSE
              p:=p+2
              r:=dofunc(varvalue(^p++,TFUNC))
            ENDIF
          CASE FREADINT
            IF ReadStr(stdin,inputbuf)=-1
              r:=0
            ELSE
              r:=Val(inputbuf,{x})
            ENDIF
          CASE FARRAY
            adr:=findvar(eatident())
            a:=eval()
            x:=New(Mul(a,4)+8)
            IF x=NIL THEN error(ER_ALLOC)
            letvar(adr,x,TARRAY)
            x[0]:=a
          CASE FLOCATE; WriteF('\e[\d;\dH',eval(),eval())
          CASE FCLS; Out(stdout,12)
          CASE FDUMP
            adr:=varbottom
            WriteF('\n')
            WHILE adr<vartop
              a:=adr.name
              x:=a
              WHILE Char(x)<>" " DO INC x
              Write(stdout,a,x-a)
              x:=adr.type
              SELECT x
                CASE TINTEGER; WriteF(' = \d (int)\n',adr.value)
                CASE TSTRING;  WriteF(' = "\s" (string)\n',adr.value)
                CASE TFUNC;    WriteF(' (function)\n')
                CASE TARRAY;   WriteF('[\d] (array)\n',Long(adr.value))
              ENDSELECT
              adr:=adr+SIZEOF var
            ENDWHILE
            WriteF('\n')
          CASE FWINDOW
            StringF(winspec,'CON:\d/\d/\d/\d/',eval(),eval(),eval(),eval())
            x:=eatstring()
            StrAdd(winspec,x,ALL)
            wfile:=Open(winspec,1006)
            IF wfile=NIL THEN error(ER_FILE)
            IF conout<>NIL THEN Close(conout)
            stdout:=wfile
            conout:=stdout
            stdin:=stdout
            adr:=OpenWorkBench()
            Forbid()
            a:=NIL
            IF adr<>NIL
              adr:=Long(adr+4)
              WHILE (adr<>NIL) AND (a=NIL)
                IF StrCmp(x,Long(adr+32),ALL) THEN a:=adr
                adr:=^adr
              ENDWHILE
            ENDIF
            Permit()
            IF a THEN gfxwindow:=a
          CASE FTELL
            IF outfile<>NIL THEN Close(outfile)
            outfile:=NIL
            outfile:=Open(eatstring(),1006)
            IF outfile=NIL THEN error(ER_FILE)
            oldout:=stdout
            stdout:=outfile
          CASE FTOLD
            IF outfile<>NIL THEN Close(outfile)
            outfile:=NIL
            stdout:=oldout
          CASE FSEE
            IF infile<>NIL THEN Close(infile)
            infile:=NIL
            infile:=Open(eatstring(),1005)
            IF infile=NIL THEN error(ER_FILE)
            oldin:=stdin
            stdin:=infile
          CASE FSEEN
            IF infile<>NIL THEN Close(infile)
            infile:=NIL
            stdin:=oldin
          CASE FSTRING
            adr:=String(250)
            IF adr=NIL THEN error(ER_ALLOC)
            letvar(findvar(eatident()),adr,TSTRING)
          CASE FREAD
            x:=varvalue(eatident(),TSTRING)
            r:=ReadStr(stdin,x)
          CASE FGET; r:=Inp(stdin)
          CASE FPUT; r:=eval(); IF r<>-1 THEN Out(stdout,r)
          CASE FFILELEN
            r:=FileLength(eatstring())
            IF r=-1 THEN r:=0
          CASE FLINE; getrast(); Line(eval(),eval(),eval(),eval(),eval())
          CASE FPLOT; getrast(); Plot(eval(),eval(),eval())
          CASE FBOX
            getrast()
            a:=eval(); x:=eval(); p2:=eval(); r:=eval()
            IF (a>p2) OR (x>r) THEN error(ER_VALUES)
            Box(a,x,p2,r,eval())
            r:=0
          CASE FMOUSEX; r:=MouseX(getwin())
          CASE FMOUSEY; r:=MouseY(getwin())
          CASE FMOUSE; r:=Mouse()
          CASE FTEXT
            adr:=getrast()
            a:=eval(); x:=eval()
            Colour(eval(),eval())
            TextF(a,x,eatstring())
        ENDSELECT
      ENDIF
      IF p[]++<>RBRACKET THEN error(ER_EXPRBRACKET)
    DEFAULT
      IF (i=RBRACKET) OR (i=ISTRING) THEN error(ER_EXPEXP) ELSE error(ER_SYNTAX)
  ENDSELECT
ENDPROC r

PROC getwin()
  IF gfxwindow=NIL THEN error(ER_GFXWIN)
ENDPROC gfxwindow

PROC getrast()
  DEF r
  IF gfxwindow=NIL THEN error(ER_GFXWIN)
  r:=Long(gfxwindow+50)
  SetStdRast(r)
ENDPROC r

PROC eatstring()
  DEF adr,x
  IF p[]=ISTRING
    p:=p+2; x:=p[]++; adr:=^p++
    adr[x]:=0
  ELSE
    adr:=varvalue(eatident(),TSTRING)
  ENDIF
ENDPROC adr

PROC eatident()
  IF p[]++<>IDENT THEN error(ER_EXPIDENT)
ENDPROC ^p++

PROC dofunc(lcode)
  DEF args[MAXARGS]:ARRAY OF LONG,a=0,oldvarb,oldvart,oldp,x,r=0,olderpos
  checkstop()
  WHILE p[]<>RBRACKET
    IF a=MAXARGS THEN error(ER_ARGS)
    args[a]:=eval()
    INC a
  ENDWHILE
  IF rec=0 THEN globvar:=vartop
  oldvarb:=varbottom; varbottom:=vartop; oldvart:=vartop;
  oldp:=p; p:=lcode; olderpos:=erpos; INC rec
  IF p[]++<>LBRACKET THEN error(ER_EXPLBRACKET)
  erpos:=^p++
  WHILE p[]<>RBRACKET
    IF a=0 THEN error(ER_ARGS)
    x:=findvar(eatident())
    letvar(x,args[]++,TINTEGER)
    DEC a
  ENDWHILE
  IF a<>0 THEN error(ER_ARGS)
  p:=p+2
  WHILE p[]<>RBRACKET DO r:=eval()
  varbottom:=oldvarb; vartop:=oldvart; p:=oldp; erpos:=olderpos; DEC rec
ENDPROC r

PROC findvar(id)
  DEF loc=0:PTR TO var,a:PTR TO var
  IF vartop<>varbottom
    a:=varbottom                     /* vérifie les variables locales */
    WHILE (a<vartop) AND (loc=0)
      IF a.name=id THEN loc:=a
      a:=a+SIZEOF var
    ENDWHILE
  ENDIF
  IF loc=0
    IF (rec>0) AND (globvar>vars)    /* vérifie les variables globales */
      a:=vars
      WHILE (a<globvar) AND (loc=0)
        IF a.name=id THEN loc:=a
        a:=a+SIZEOF var
      ENDWHILE
    ENDIF
    IF loc=0                         /* crée de nouvelle variable dynamique */
      loc:=vartop
      vartop:=vartop+SIZEOF var
      IF vars+VARSTACKSPACE<vartop THEN error(ER_WORKSPACE)
      loc.type:=TINTEGER
      loc.name:=id
      loc.value:=0
    ENDIF
  ENDIF
ENDPROC loc

PROC letvar(adr:PTR TO var,value,type)
  IF (adr.type<>type) AND (adr.type<>TINTEGER) THEN error(ER_TYPE)
  checkstop()
  adr.type:=type
  adr.value:=value
ENDPROC

PROC varvalue(id,type)
  DEF adr:PTR TO var
  checkstop()
  adr:=findvar(id)
  IF adr.type<>type THEN error(ER_TYPE)
ENDPROC adr.value

PROC skip()                        /* saute *une* expression */
  DEF deep=0,i
  REPEAT
    i:=p[]++
    IF (i=VALUE) OR (i=LBRACKET) OR (i=IDENT) THEN p:=p+4
    IF i=ISTRING THEN p:=p+6
    IF i=LBRACKET THEN INC deep
    IF i=RBRACKET THEN IF deep=0 THEN error(ER_EXPEXP) ELSE DEC deep
    IF i=ENDSOURCE THEN error(ER_EXPRBRACKET)
  UNTIL deep=0
ENDPROC

PROC iword(x)
  IF ibuf+ilen>ipos THEN ipos[]++:=x ELSE error(ER_BUF)
ENDPROC

PROC ilong(x)
  IF ibuf+ilen>ipos THEN ^ipos++:=x ELSE error(ER_BUF)
ENDPROC

PROC loadsource()
  DEF suxxes=FALSE,handle,read
  IF StrCmp(arg,'?',ALL) OR StrCmp(arg,'',ALL)
    WriteF('USAGE: Yax <source> (extensio par défaut ".yax")\n')
    error(0)
  ELSE
    StrCopy(name,arg,ALL)
    StrAdd(name,'.yax',4)
    slen:=FileLength(name)
    handle:=Open(name,1005)
    IF (handle=NIL) OR (slen=-1)
      error(ER_INFILE)
    ELSE
      source:=New(slen+10)
      IF source=NIL
        error(ER_SOURCEMEM)
      ELSE
        read:=Read(handle,source,slen)
        Close(handle)
        IF read=slen
          suxxes:=TRUE
          source[slen]:=0
        ELSE
          error(ER_INFILE)
        ENDIF
      ENDIF
    ENDIF
  ENDIF
ENDPROC

PROC error(nr)
  DEF erstr[ERLEN]:STRING,a
  IF outfile<>NIL
    IF stdout=outfile THEN stdout:=oldout
    Close(outfile)
  ENDIF
  IF infile<>NIL
    IF stdin=infile THEN stdin:=oldin
    Close(infile)
  ENDIF
  WriteF('\n')
  IF nr>0
    WriteF('ERROR: ')
    SELECT nr
      CASE ER_WORKSPACE;   WriteF('Ne peut allouer de la mémoire pour l\aespace de travaille !\n')
      CASE ER_BUF;         WriteF('Dépacement mémoire des buffers !\n')
      CASE ER_GARBAGE;     WriteF('Poubelle en ligne \n')
      CASE ER_SYNTAX;      WriteF('Votre syntaxe pose problême\n')
      CASE ER_EXPKEYWORD;  WriteF('Manque un mot clef\n')
      CASE ER_EXPRBRACKET; WriteF('Manque un crochet droit ]\n')
      CASE ER_EXPEXP;      WriteF('Manque une expression évaluable\n')
      CASE ER_QUOTE;       WriteF('Manque l''apostrophe\a\n')
      CASE ER_COMMENT;     WriteF('Manque "*/"\n')
      CASE ER_SOURCEMEM;   WriteF('Pas de mémoire pour le source !\n')
      CASE ER_INFILE;      WriteF('Ne peut ouvrir le fichier "\s".\n',name)
      CASE ER_EXPIDENT;    WriteF('Manque l''identificateur\n')
      CASE ER_ARGS;        WriteF('Nombre illégal d''arguments\n')
      CASE ER_TYPE;        WriteF('Mauvais type de variable/expression\n')
      CASE ER_EXPLBRACKET; WriteF('Manque le crochet gauche [\n')
      CASE ER_STACK;       WriteF('Limite du dépacement mémoire : \d récusions\n',rec)
      CASE ER_ALLOC;       WriteF('N''a put faire une allocation dynamique !\n')
      CASE ER_ARRAY;       WriteF('Index de tableau hors norme\n')
      CASE ER_FILE;        WriteF('Erreur de fichier\n')
      CASE ER_GFXWIN;      WriteF('N''est pas une fenêtre-utilisateur pour les graphiques\n')
      CASE ER_VALUES;      WriteF('Valeur(s) illégale(s)\n')
    ENDSELECT
    IF erpos<>NIL
      StrCopy(erstr,erpos,ALL)
      FOR a:=0 TO ERLEN-1 DO IF erstr[a]=10 THEN erstr[a]:=32
      WriteF('NEARBY: \s\n',erstr)
    ENDIF
  ELSEIF nr=-1
    WriteF('*** Programme terminé.\n')
  ENDIF
  IF conout<>NIL THEN WriteF('Pressez <return> pour continuer...\n')
  CleanUp(0)
ENDPROC

keywords:
CHAR 'write...', 'add.....', 'eq......', 'uneq....', 'sub.....',
     'mul.....', 'div.....', 'and.....', 'or......', 'not.....',
     'if......', 'do......', 'select..', 'set.....', 'for.....',
     'while...', 'until...', 'defun...', 'lambda..', 'apply...',
     'readint.', 'array...', 'greater.', 'smaller.', 'locate..',
     'cls.....', 'dump....', 'window..', 'tell....', 'told....',
     'see.....', 'seen....', 'string..', 'read....', 'get.....',
     'put.....', 'filelen.', 'line....', 'plot....', 'box.....',
     'mousex..', 'mousey..', 'mouse...', 'text....'
