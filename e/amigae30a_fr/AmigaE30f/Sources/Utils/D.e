/* outils récursifs de répertoire

A besoin de la v37.

Afficheur universel de répertoire. Appelé sans arguments, et tapant juste
"d", il liste le répertoire courant. Arguments:

DIR,REC/S,COL/K/N,SIZE/S,NOSORT/S,NOFILES/S,NODIRS/S,FULL/S,NOANSI/S,
TARGET/K,DO/K/F

DIR             spécifie un chemin optionnel au répertoire que vous voulez lister.
                il peut contenir des caractères génériques standards comme #?~[]%() etc.
REC             spécifie que les sous-répertoire doivent être listés récursivement.
COL <num>       où n=1..3, par défaut, D liste les répertoires en 3 colonnes.
                le tout bien mignon et compact. spécifie 1 ou 2 si vous voulez.
SIZE            reporte la taille de chaque répertoire lors de l'affichage.
                Notez que combiné avec REC, ça donne le taille de tout le répertoire
                et des sous répertoires.
NOSORT          par défaut, les répertoires sont triés avant l'affichage.
                Mettez cette option hors service avec NOSORT.
NOFILES         affiche juste les répertoires.
NODIRS          affiche juste les fichiers.
FULL            met le chemin entier au lieu des fichiers juste.
NOANSI          n'utilise pas l'affichage ansi lors de l'impression.
TARGET <dir>    spécifie le répertoire destination pour l'utilisation avec DO.
                le répertoire doit se terminer pas "/" ou ":"
DO <comline>    spécifie la ligne de commande pour la génération automatique
                des scripts. Notez que celui utilise toute la fin de la ligne.

Je doit dire quelquechose à dire sur les caractèristiques des scripts: ils
permettent de faire des taches répétitives sur des répertoires, ou des arbres-
répertoires. Les utilitaires éxistant qui vous permettent ce type de tache, ne
sont pas assez souple ; D vous permet d'utiliser le mot REC en combinaison avec
les scripts, accepte des extensions variables: utilisez <fichier>.o si le nom
original est <fichier>.s, et le chemin de destination: les fichiers créés par
l'opération sont placés dans un autre répertoire qui peut être une image d'un
autre arbre-répertoire. Les commandes 'makedir' sont insérés si la destination
est vide.

Les formats suivant peuvent être utilisé dansla ligne de commande:

%s est le fichier (chemin et nom)
%f est le fichier SANS extension
%r est le fichier sans extension, mais un <dir> remplacé par <target>
   (utile si <ligne de commande> permet un fichier de sortie)
%> ou %< %>> etc. prévients le shell de croire que ">" is une redirection
   pour D, au lieu de <ligne de commande>

Un exemple complexe:
Vous voulez avoir une référence complète ascii du répertoire emodules:,
récursivement, et avec un fichier .txt créé comme une structure répertoire
image quelque part.

1> D >ram:script emodules: REC TARGET=t:mods/ DO showmodule %>%r.txt %s
1> execute ram:script

le fera pour vous.
POur tous les fichiers du type "emodules:exec/io.m" D fera uneligne du style:
"showmodule  >t:mods/exec/io.txt emodules:exec/io.m"

autres exemples: D >mydirlist dh0: COL=2 SIZE REC NOANSI
                 D docs: DO type >prt: %s
                 D asm: TARGET=obj: DO genam %s -o%r.o
                 D emodules: REC TARGET=ram: DO showmodule %>%r.txt %s


BUGS:
 y en a plus.

AMéLIORATIONS PAR RAPPORT AU VIEUX "D"
- beaucoup plus rapide
- récursif
- calcule la taille des fichiers d'arbres d'un répertoire entier
- une, deux, trois colonnes
- caractères génériques (? * #?)
- meilleur tri, et plus rapide
- meilleur code : gère les répertoire de toutes les tailles
- un tas d'option grace au standard readargs()
- génération puissant de script
- utilise des gestionnaires d'exception imbriqués pour pister les appels
  MatchEnd() lors d'un CtrlC ou un erreur soudaine.

*/

OPT OSVERSION=37

CONST MAXPATH=250

ENUM ER_NONE,ER_BADARGS,ER_MEM,ER_UTIL,ER_ITARG,ER_COML
ENUM ARG_DIR,ARG_REC,ARG_COL,ARG_SIZE,ARG_NOSORT,ARG_NOFILES,
     ARG_NODIRS,ARG_FULL,ARG_NOANSI,ARG_TARGET,ARG_COMMAND,NUMARGS

MODULE 'dos/dosasl', 'dos/dos', 'utility'

RAISE ER_MEM IF New()=NIL,        /* fixe les exceptions habituelles:      */
      ER_MEM IF String()=NIL,     /* chaque appel à ces fonction seront    */
      ERROR_BREAK IF CtrlC()=TRUE /* automatiquement vérifié vis à vis de  */
                                  /* NIL et l'exception ER_MEM est levée   */

DEF dir,command,target,
    recf=FALSE,col=3,comf=FALSE,sizef=FALSE,sortf=TRUE,filesf=TRUE,
    fullf=FALSE,ansif=TRUE,dirsf=TRUE,dirw[100]:STRING,
    rdargs=NIL,work[250]:STRING,work2[250]:STRING,dirno=0,
    prtab[25]:LIST,prcopy[25]:LIST,workdir[250]:STRING

PROC main() HANDLE
  DEF args[NUMARGS]:LIST,templ,x,lock,fib:fileinfoblock,s
  IF (utilitybase:=OpenLibrary('utility.library',37))=NIL THEN Raise(ER_UTIL)
  FOR x:=0 TO NUMARGS-1 DO args[x]:=0
  templ:='DIR,REC/S,COL/K/N,SIZE/S,NOSORT/S,NOFILES/S,NODIRS/S,' +
         'FULL/S,NOANSI/S,TARGET/K,DO/K/F'
  rdargs:=ReadArgs(templ,args,NIL)
  IF rdargs=NIL THEN Raise(ER_BADARGS)          /* initialise les drapeaux */
  IF args[ARG_SIZE] THEN sizef:=TRUE       /* des arguments de la commande */
  IF args[ARG_COL] THEN col:=Long(args[ARG_COL])
  IF args[ARG_NOSORT] THEN sortf:=FALSE
  IF args[ARG_NOANSI] THEN ansif:=FALSE
  IF args[ARG_NOFILES] THEN filesf:=FALSE
  IF args[ARG_NODIRS] THEN dirsf:=FALSE
  IF args[ARG_REC] THEN recf:=TRUE
  IF args[ARG_FULL] THEN fullf:=TRUE
  target:=args[ARG_TARGET]
  command:=args[ARG_COMMAND]
  IF command THEN comf:=TRUE
  IF (col<>1) AND (col<>2) THEN col:=3
  IF target
    x:=target+StrLen(target)-1
    IF (x<target) OR ((x[]<>":") AND (x[]<>"/")) THEN Raise(ER_ITARG)
  ENDIF
  IF comf
    sortf:=FALSE        /* lit et convertis la commande pour les scripts */
    col:=1
    filesf:=FALSE
    dirsf:=FALSE
    IF command[]=0 THEN Raise(ER_COML)
    s:=command
    WHILE x:=s[]++
      IF x="%"
        x:=s[]
        SELECT x
          CASE "s"; ListAdd(prtab,[1],1)                    /* %s = chemin entier */
          CASE "f"; ListAdd(prtab,NEW [work],1); s[]:="s"   /* %f = work     */
          CASE "r"; ListAdd(prtab,NEW [work2],1); s[]:="s"  /* %r = work2    */
          DEFAULT; s[-1]:=" "
        ENDSELECT
      ENDIF
    ENDWHILE
  ENDIF
  dir:=args[ARG_DIR]
  IF dir THEN StrCopy(dirw,dir,ALL)
  lock:=Lock(dirw,-2)
  IF lock                  /* si oui, le rép prob., sinon car. générique */
    IF Examine(lock,fib) AND (fib.direntrytype>0)
      AddPart(dirw,'#?',100)
    ENDIF
    UnLock(lock)
  ENDIF
  recdir(dirw)
  Raise(ER_NONE)
EXCEPT
  IF rdargs THEN FreeArgs(rdargs)
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
    CASE ER_BADARGS;            WriteF('Mauvais Arguments pour D!\n')
    CASE ER_MEM;                WriteF('Pas de mémoire!\n')
    CASE ER_COML;               WriteF('Pas de ligne de commande spécifié\n')
    CASE ER_ITARG;              WriteF('Cible illégale\n')
    CASE ER_UTIL;               WriteF('Nepeut pas ouvrir l''"utility.library" v37\n')
    CASE ERROR_BREAK;           WriteF('Arrêt de D par l'utilisateur\n')
    CASE ERROR_BUFFER_OVERFLOW; WriteF('Erreur interne\n')
    DEFAULT;                    PrintFault(exception,'Dos Error')
  ENDSELECT
ENDPROC

PROC recdir(dirr) HANDLE
  DEF er,i:PTR TO fileinfoblock,size=0,anchor=NIL:PTR TO anchorpath,fullpath,
      flist=NIL,first,entries=0,sortdone,next,nnext,prev,ascii,x,y,flist2=NIL,
      esc1,esc2,ds:PTR TO LONG,isfirst=0
  anchor:=New(SIZEOF anchorpath+MAXPATH)
  anchor.breakbits:=4096
  anchor.strlen:=MAXPATH-1
  esc1:=IF ansif THEN '\e[1;32m' ELSE ''
  esc2:=IF ansif THEN '\e[0;31m' ELSE ''
  ds:=['\s\l\s[50]\s <dir>','\l\s[47] \r\d[8]','\s\l\s[30]\s <dir>','\l\s[27] \r\d[8]','\s\l\s[19]\s <dir>','\l\s[17] \r\d[7]']
  er:=MatchFirst(dirr,anchor)                   /* collecte les chaines */
  WHILE er=0
    fullpath:=anchor+SIZEOF anchorpath
    i:=anchor.info
    ascii:=IF fullf THEN fullpath ELSE i.filename
    IF i.direntrytype>0 THEN StringF(work,ds[col-1*2],esc1,ascii,esc2) ELSE StringF(work,ds[col-1*2+1],ascii,i.size)
    IF IF i.direntrytype>0 THEN dirsf ELSE filesf
      first:=String(EstrLen(work))
      StrCopy(first,work,ALL)
      flist:=Link(first,flist)
      INC entries
    ENDIF
    IF i.direntrytype<0 THEN size:=size+i.size
    IF (i.direntrytype<0) AND comf              /* éxécute la ligne de cmd */
      ListCopy(prcopy,prtab,ALL)
      IF comf THEN MapList({x},prcopy,prcopy,`IF x=1 THEN fullpath ELSE x)
      StrCopy(work,fullpath,ALL)
      x:=InStr(work,'.',0)
      IF x<>-1 THEN SetStr(work,x)              /* trouve f% */
      IF target
        StrCopy(work2,target,ALL)
        x:=work; y:=dirw        /* was dirr */
        WHILE x[]++=y[]++ DO NOP
        DEC x
        StrAdd(work2,x,ALL)                     /* trouve r% */
      ELSE
        StrCopy(work2,work,ALL)
      ENDIF
      IF isfirst++=0
        StrCopy(workdir,work2,ALL)      /* regarde si makedir est nécessaire */
        SetStr(workdir,PathPart(work2)-work2)
        x:=Lock(workdir,-2)
        IF x THEN UnLock(x) ELSE WriteF('makedir \s\n',workdir)
      ENDIF
      Flush(stdout); VfPrintf(stdout,command,prcopy); Flush(stdout)
      WriteF('\n')
    ENDIF
    IF recf AND (i.direntrytype>0)              /* fait la récursion(=tail) */
      x:=StrLen(fullpath)
      IF x+5<MAXPATH THEN CopyMem('/#?',fullpath+x,4)
      size:=size+recdir(fullpath)
      fullpath[x]:=0
    ENDIF
    er:=MatchNext(anchor)
  ENDWHILE
  IF er<>ERROR_NO_MORE_ENTRIES THEN Raise(er)
  MatchEnd(anchor)
  Dispose(anchor)
  anchor:=NIL
  flist:=Link(String(1),flist)
  IF entries>2 AND sortf
    REPEAT
      sortdone:=TRUE                            /* tri de la liste de rép */
      prev:=first:=flist
      WHILE first:=Next(first)
        IF next:=Next(first)
          IF Stricmp(first,next)>0
            nnext:=Next(next)
            Link(prev,first:=Link(next,Link(first,nnext)))
            sortdone:=FALSE
          ENDIF
        ENDIF
        CtrlC()
        prev:=first
      ENDWHILE
    UNTIL sortdone
  ENDIF
  IF col>1                                    /* met lalist de rép en colonne */
    x:=entries/col
    IF x*col<entries THEN INC x
    first:=Next(flist)
    next:=Forward(first,x)
    nnext:=IF col=3 THEN Forward(next,x) ELSE NIL
    flist2:=Link(String(1),flist2)
    prev:=flist2
    WHILE first AND (x-->=0)
      StrCopy(work,first,ALL)
      IF next
        StrAdd(work,' ',1)
        StrAdd(work,next,ALL)
        IF nnext
          StrAdd(work,' ',1)
          StrAdd(work,nnext,ALL)
        ENDIF
      ENDIF
      ascii:=String(EstrLen(work))
      StrCopy(ascii,work,ALL)
      Link(prev,prev:=ascii)
      first:=Next(first)
      IF next THEN next:=Next(next)
      IF nnext THEN nnext:=Next(nnext)
    ENDWHILE
    DisposeLink(flist)
    flist:=flist2
  ENDIF
  IF comf=FALSE                                         /* affiche le rép */
    IF dirno THEN WriteF('\n')
    WriteF(IF ansif THEN '\e[1mRépertoire de: "\s"\e[0m\n' ELSE 'Répertoire de: "\s"\n',dirr)
  ENDIF
  first:=flist
  WHILE first:=Next(first)
    WriteF('\s\n',first)
    CtrlC()
  ENDWHILE
  IF sizef THEN WriteF('BYTE SIZE: \d\n',size)
  DisposeLink(flist)
  INC dirno
EXCEPT                                  /* gestionnaire d'exception! */
  IF anchor THEN MatchEnd(anchor)
  Raise(exception)  /* Comme ça on peut appeler _tous_ les gestionnaires dans la récursion  */
ENDPROC size        /* et donc appeler MatchEnd() sur tousles 'anchors' */
