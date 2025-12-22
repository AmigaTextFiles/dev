/*
 * MakeEFile
 *
 * Programme d'automatisation de création d'un éxécutable depuis un source en E.
 *
 * Version 1 - © Frantz Balinski
 *
 * Usage:
 * - Placer le programme MakeEFile dans C:
 * - pour chaque source E que vous voulez compiler, créez, dans le même répertoire,
 *   une icône TOOL. Appelez-la MakeEFile (pour que le wb recherche le programme
 *   dans le chemins mémorisés (default paths)).
 * - Réglez les TOOLTYPES suivants:
 *   (ceux-ci sont indispensables)
 *   NAME : le nom de l'éxécutable généré (ex MonProgramme).
 *   EPP  : (flag) YES/NO ou OUI/NON, indique que la compilation est en 2 passes.
 *          (EPP MonProgramme_epp MonProgramme.e, EC MonProgramme).
 *   (ceux-là sont optionnels)
 *   EPPDIR  : (seulement si EPP=(YES|OUI)) chemin d'accés à EPP (ex chemin/EPP).
 *   ECDIR   : chemin d'accès à EC.
 *   VERSION : Numéro de version de l'éxécutable, défault 1.
 *   AUTHOR  : Nom de l'auteur, utilisé pour la chaîne de version, placé aprés la
 *             date.
 *   REVPATH : Chemin d'accés au fichier comportant le numéro actuel de révision.
 *             Par défault RAVPATH='revision' (dans le chemin courant).
 *             si ce fichier n'est pas trouvé, REVPATH sera pris par défault,
 *             la révision sera définie à <revision, et en fin de compilation,
 *             le fichier 'revision' sera généré dans ce répertoire par défault.
 *   WINDOW  : définition de la fenêtre de sortie, défault conout du E.
 *
 * Petits détails à respecter:
 *   - Donnez l'extension '_epp.e' au fichier source EPP, '.e' au fichier source EC.
 *   - Entrez les chemin d'accées complets aux modules EPP.
 *
 * Pour compiler votre source E, double-cliquez sur l'icône MakeEFile et tout
 * devrait bien se passer.
 *
 * Une chaîne de version est générée pour l'éxécutable, la révision est incrémentée
 * à chaque compilation. Elle est incluse automatiquement à la fin du source E:
 * versionString:
 *  CHAR '$VER: <MonProgramme> <version>.<Revision> (<date>)\n\b\0'
 * La date est lue dans la variable ENV:DATE générée par KCommodity.
 * Si ENV:DATE n'est pas trouvé, la date sera lue depuis le système.
 *
 */

PMODULE 'PMODULES:User/argarray'

MODULE	'icon','dos/dos','dos/datetime','intuition/intuition'

DEF	ttypes:PTR TO LONG, conhdle, oldstdout,
	name:PTR TO CHAR,
	useepp:LONG, eppdir:PTR TO CHAR,
	ecdir:PTR TO CHAR,
	version, revision, revpath:PTR TO CHAR,
	date[9]:STRING,
	author:PTR TO CHAR

PROC main() HANDLE
  iconbase:=NIL
  IF _astartup()<>NIL; SetIoErr(ERROR_NO_FREE_STORE); Raise(RETURN_FAIL); ENDIF
  IF _argc<>0
    WriteF('MakeEFile: Uniquement par le Workbench.\n'); Raise(RETURN_WARN)
  ENDIF
  IF (iconbase:=OpenLibrary('icon.library',37))=NIL THEN Raise(RETURN_FAIL)

  ttypes:=_argarrayinit(_argc,_argv)
  getargs()

  /* sauver la chaîne de version dans t:
   * ne pas inscrire le caractère '$' devant 'VER:' car pour ce
   * programme, ça invaliderait la vraie chaîne de version qui sera
   * située aprés.
   */
  fwritef('T:version_string','CHAR \a\cVER: \s \d.\d (\s) \s\a,10,13,0\n',
	  [36,name,version,revision,date,author])

  /* création du script */
  IF (useepp)
    fwritef('makefile.script',
      'Join \s_epp.e T:version_string as \s_vs_epp.e\n'+
      '\s \s_vs_epp \s.e\n'+
      '\s \s\n'+
      'Delete >NIL: T:version_string \s_vs_epp.e \s.e\n',
      [name,name,eppdir,name,name,ecdir,name,name,name])
  ELSE
    fwritef('makefile.script',
      'Join \s.e T:version_string as \s_vs.e\n'+
      '\s \s_vs\n'+
      'Delete >NIL: T:version_string \s_vs.e\n'+
      'Rename \s_vs \s\n',
      [name,name,ecdir,name,name,name,name])
      Execute('Execute makefile.script',stdout,stdout)
  ENDIF
  IF oldstdout=NIL THEN WriteF('')
  Execute('Execute makefile.script',stdout,stdout)
  INC revision
  fwritef(revpath,'\d',[revision])
  DeleteFile('makefile.script')

  Raise(RETURN_OK)
  EXCEPT
  _argarraydone()
  IF conhdle<>NIL; SetStdOut(oldstdout); Close(conhdle); ENDIF
  IF iconbase<>NIL THEN CloseLibrary(iconbase)
  _exit(exception)
ENDPROC

PROC getargs()
  DEF fhdle, window, lock, buffer[17]:STRING, dat:datetime, i
  oldstdout:=NIL
  IF (window:=_argstring(ttypes,'WINDOW',NIL))
    IF (conhdle:=Open(window,MODE_READWRITE)) THEN oldstdout:=SetStdOut(conhdle)
  ENDIF

  IF (name:=_argstring(ttypes,'NAME',NIL))=NIL
    alert('TOOLTYPE NAME non défini',NIL)
    Raise(RETURN_FAIL)
  ENDIF

  IF (version:=_argint(ttypes,'VERSION',1))<0
    alert('Mauvais numéro de version\n\d',[version])
    Raise(RETURN_ERROR)
  ENDIF

  author:=_argstring(ttypes,'AUTHOR',NIL)

  useepp:=_argstring(ttypes,'EPP',NIL); UpperStr(useepp)
  IF Or(StrCmp(useepp,'YES',STRLEN),StrCmp(useepp,'OUI',STRLEN))
    useepp:=TRUE
    eppdir:=_argstring(ttypes,'EPPDIR','E:EPP/bin/EPP')
  ELSE
    /* EPP inutilisé */
    useepp:=FALSE
    eppdir:=NIL
  ENDIF

  ecdir:=_argstring(ttypes,'ECDIR','E:v39_emodules/Bin/EC21b_v39')

  IF (revpath:=_argstring(ttypes,'REVPATH',NIL))
    IF (lock:=Lock(revpath,ACCESS_READ))THEN UnLock(lock) ELSE revpath:='revision'
  ELSE
    revpath:='revision'
  ENDIF

  revision:=0
  IF (fhdle:=Open(revpath,MODE_OLDFILE))
    Fgets(fhdle,buffer,31)
    StrToLong(buffer,{revision})
    Close(fhdle)
  ENDIF

  IF (fhdle:=Open('ENV:DATE',MODE_OLDFILE))
    Fgets(fhdle,date,31)
    Close(fhdle)
  ELSE
    DateStamp(dat)
    dat.format :=FORMAT_CDN /* dd-mm-yy */
    dat.flags  :=DTF_FUTURE
    dat.strday :=NIL
    dat.strdate:=date
    dat.strtime:=NIL
    DateToStr(dat)
  ENDIF
  i:=0
  WHILE And(date[i]>" ",i<9)
    IF Or(date[i]<"0",date[i++]>"9") THEN date[i-1]:="."
  ENDWHILE
ENDPROC

PROC alert(text,args)
  EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MakeEFile',text,'Abandon']:easystruct,
    NIL,args)
ENDPROC

PROC fwritef(filename,fmt,args)
  DEF fhdle, errbuff[512]:STRING, hdrbuffer[256]:STRING, n=-1
  IF (fhdle:=Open(filename,MODE_NEWFILE))
    n:=VfPrintf(fhdle,fmt,args)
    Close(fhdle)
  ENDIF
  IF n=-1
    StrCopy(hdrbuffer,'Impossible de créer\n',STRLEN)
    StrAdd(hdrbuffer,filename,ALL); StrAdd(hdrbuffer,'\n',STRLEN)
    Fault(IoErr(),hdrbuffer,errbuff,512)
    alert(errbuff,NIL)
    Raise(RETURN_ERROR)
  ENDIF
ENDPROC

