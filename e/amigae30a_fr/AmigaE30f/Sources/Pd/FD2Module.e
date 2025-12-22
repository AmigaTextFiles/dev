/*

fd2module V1.0
Alex McCracken Mar 1994

Ce programme est essentiellement basé sur Pragma2Module de Wouter van
Oortmerssen. En fait, 90% de code appartient à Wouter, donc, pas de
remerciement pour ça. Cependant, tant que le Pragma2Module de Wouter marche
très bienpour les fichiers au bon format, je doit admettre que si ça plante,
c'est certainement de ma faute. Vous pouvez utiliser ce programme si il vous
convient. S'il doit planter et mange votre chien, fait exploser votre TV, ou
cause des problêmes quelconques, on ne pourra pas me rendre responsable. En
d'autres mots, utilisez le à vos propres risques. J'ai fait tous les efforts
pour m'assurer qu'il marche, mais je ne peut garantir d'avoir trouvé tous les
petits trucs qui plante tous les programmes.

Utilisation

Le programme est appelé en tapant (CLI uniquement):

        fd2module <libname>

où libname est le nom du fichier sans _lib.fd.
Ca produira un fichier <libname>.m. Pour le moment le programme annonce que le
fichier fd est lu, mais ca peut changer dans le futur. Vous devez donner
au programme le nom de la bibliothèque explicitement (mais, encore une fois,
ça peut changer.

Distribution

Ceci peut être distribué par n'importe quel moyen. Cependant, je retient le
droit de mettre à niveau l'ensemble sans informer quiconque. Cette distribution
contient :
        fd2module               L'éxécutable
        fd2module.doc           Ce document

Me contacter

Je peut être joind :

par courier postal:
        Alex McCracken
        11 Charles Street
        Kilmarnock
        Ayrshire
        KA1 2DX
        Scotland

par courier Internet :
        mccracal@dcs.gla.ac.uk

Je n'utilise mon compte email que pendant les temps 'Term', donc pendant l'été
il vaudrait mieux m'envoyer un lettre par la poste. L'adresse email devrait rester
valide jusqu'à l'été 95.

*/

/* FD2Module
   convertis un fichier bibliothèque fd en un module E.
   Usage: fd2module <file>
   convertis <file_lib.fd> en <file.m>                  */

ENUM INPUT_ERROR=10,OUTPUT_ERROR,FORMAT_ERROR

DEF cfh,efh,eof,done,
    gotbase=FALSE,
    public=TRUE,
    offset=30,
    cfile[200]:STRING,
    efile[200]:STRING,
    cstring[200]:STRING

PROC main()
  StrCopy(cfile,arg,ALL)
  StrAdd(cfile,'_lib.fd',ALL)
  StrCopy(efile,arg,ALL)
  StrAdd(efile,'.m',ALL)
  WriteF('Amiga E FD2Module\nconvertis: "\s" en "\s"\n',cfile,efile)
  IF (cfh:=Open(cfile,OLDFILE))=0 THEN closeall(INPUT_ERROR)
  IF (efh:=Open(efile,NEWFILE))=0 THEN closeall(OUTPUT_ERROR)
  REPEAT
    eof:=ReadStr(cfh,cstring)
    done:=convert(cstring)
  UNTIL eof OR done
  WriteF('dernier offset: -\d\n',offset)
  Out(efh,$FF)
  WriteF('Terminé.\n')
  closeall(0)
ENDPROC

PROC closeall(er)
  IF cfh<>0 THEN Close(cfh)
  IF efh<>0 THEN Close(efh)
  SELECT er
    CASE INPUT_ERROR;  WriteF('Ne peut pas ouvrir le fichier d\aentrée!\n')
    CASE OUTPUT_ERROR; WriteF('Ne peut pas ouvrir le fichier de sortie!\n')
    CASE FORMAT_ERROR; WriteF('Erreur dans le format du fichier définition des fonctions!\n')
  ENDSELECT
  CleanUp(er)
ENDPROC

/* format de ligne à convertir:
   ##base _<Basename>
     or
   ##bias <offset>
     or
   ##public
     or
   ##private
     or
   ##end
     or
   * <comment>
     or
   <funcname>(<paramlist>)(<reglist>)*/

PROC convert(str)
DEF     pos,pos2,off2,len,narg,a,empty,dstr[50]:STRING,basestr[50]:STRING,
        funcstr[50]:STRING,regstr[20]:STRING,libstr[50]:STRING,
        tstr[80]:STRING,t2str[80]:STRING,t3str[80]:STRING,reg,check
  MidStr(tstr,str,TrimStr(str)-str,ALL)
  LowerStr(tstr)
  WriteF('\s\n',str)
  IF StrCmp(tstr,'##base ',STRLEN) OR StrCmp(tstr,'##base\t',STRLEN)
    pos:=STRLEN
    pos2:=InStr(tstr,'_',0)
    IF pos2=-1 THEN closeall(FORMAT_ERROR)
    IF gotbase=FALSE
      gotbase:=TRUE
      MidStr(basestr,str,(pos2+1),ALL)
      LowerStr(basestr)
      WriteF('Base will be: \s\n',basestr)
      WriteF('Correct name of this library (with the ".library" or ".device"):\n>')
      ReadStr(stdout,libstr)
      Write(efh,["EM","OD",6]:INT,6)
      Write(efh,libstr,EstrLen(libstr)+1)
      Write(efh,basestr,EstrLen(basestr)+1)
    ENDIF
  ELSEIF StrCmp(tstr,'##bias ',STRLEN) OR StrCmp(tstr,'##bias\t',STRLEN)
    pos:=STRLEN
    MidStr(t2str,tstr,pos,ALL)
    pos2:=TrimStr(t2str)
    MidStr(t3str,t2str,pos2-t2str,ALL)
    off2:=Val(t3str,NIL)
    IF off2=0 THEN closeall(FORMAT_ERROR)
    WHILE off2<>offset
      Write(efh,'Dum',3)                     /* "Emplacement vide de fonction" */
      Out(efh,16)
      IF offset>off2 THEN closeall(FORMAT_ERROR)
      offset:=offset+6
    ENDWHILE
  ELSEIF StrCmp(tstr,'##private',ALL)
    public:=FALSE
  ELSEIF StrCmp(tstr,'##public',ALL)
    public:=TRUE
  ELSEIF StrCmp(tstr,'##end',ALL)
    RETURN TRUE
  ELSEIF StrCmp(tstr,'*',STRLEN)
    NOP
  ELSE
    IF public
      pos:=0
      pos2:=InStr(str,'(',pos)
      IF pos2=-1 THEN closeall(FORMAT_ERROR)
      MidStr(funcstr,str,pos,pos2-pos)
      IF funcstr[0]>="a" THEN funcstr[0]:=funcstr[0]-32
      IF funcstr[1]<"a" THEN funcstr[1]:=funcstr[1]+32
      Write(efh,funcstr,EstrLen(funcstr))
      pos:=pos2+1
      pos2:=InStr(str,'(',pos)
      IF pos2=-1 THEN closeall(FORMAT_ERROR)
      narg:=0
      MidStr(dstr,str,pos2+1,ALL)
      UpperStr(dstr)
      WHILE StrCmp(dstr,')',1)=FALSE
        IF EstrLen(dstr)<2 THEN closeall(FORMAT_ERROR)
        MidStr(regstr,dstr,0,2)
        IF StrCmp(regstr,'D',1) OR StrCmp(regstr,'A',1)
          IF StrCmp(regstr,'D',1)
            reg:=0
          ELSEIF StrCmp(regstr,'A',1)
            reg:=8
          ENDIF
          MidStr(regstr,regstr,1,ALL)
          reg:=reg+Val(regstr,{check})
          IF check<1 THEN closeall(FORMAT_ERROR)
        ELSE
          closeall(FORMAT_ERROR)
        ENDIF
        MidStr(dstr,dstr,2,ALL)
        IF StrCmp(dstr,',',1) OR StrCmp(dstr,'/',1)
          MidStr(dstr,dstr,1,ALL)
        ENDIF
        Out(efh,reg)
        INC narg
      ENDWHILE
      IF narg=0 THEN Out(efh,16)
      offset:=offset+6
    ELSE
      Write(efh,'Dum',3)
      Out(efh,16)
      offset:=offset+6
    ENDIF
  ENDIF
ENDPROC FALSE
