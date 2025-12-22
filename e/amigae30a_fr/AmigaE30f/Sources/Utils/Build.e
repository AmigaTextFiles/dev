/* build en E.

AFAIRE:   - vérification cyclic des structures
          - constantes (amigados?)

*/

OPT OSVERSION=37

MODULE 'tools/file', 'dos/dosextens', 'dos/dos'

/* object: dep1 dep2 ....
     act1
     act2
*/

OBJECT object
  next:PTR TO object
  name:PTR TO CHAR
  firstdep:PTR TO dependancy
  firstaction:PTR TO action
  child
ENDOBJECT

OBJECT dependancy
  next:PTR TO dependancy
  object:PTR TO object
ENDOBJECT

OBJECT action
  next:PTR TO action
  comstring:PTR TO CHAR
ENDOBJECT

OBJECT arg
  target,buildfile,force
ENDOBJECT

DEF curline=0, curstring, uptodate=TRUE, args:PTR TO arg

PROC main() HANDLE
  DEF m,l,buildfile[200]:STRING,rdargs=NIL
  NEW args
  IF (rdargs:=ReadArgs('TARGET,FROM/K,FORCE/S',args,NIL))=NIL THEN Raise("barg")
  IF args.buildfile THEN StrCopy(buildfile,args.buildfile)
  StrAdd(buildfile,'.build')
  PrintF('E Build v0.8 (c) 1993 Rob et Wouter (processing "\s")\n',buildfile)
  m,l:=readfile(buildfile)
  buildtree(parse(stringsinfile(m,l,countstrings(m,l))))
  IF uptodate THEN PrintF('All files are up to date.\n')
  Raise()
EXCEPT
  IF rdargs THEN FreeArgs(rdargs)
  IF exception=0 THEN RETURN
  PrintF('Error: ')
  SELECT exception
    CASE "OPEN"
      PrintF('Ne peut ouvrir "\s".\n',exceptioninfo)
    CASE "MEM"
      PrintF('Pas assez de mémoire.\n')
    CASE "IN"
      PrintF('Ne peut lire le fichier.\n')
    CASE "nobj"
      PrintF('action sans objet.\n')
    CASE "fexp"
      PrintF('nom de fichier attendu.\n')
    CASE "dexp"
      PrintF('":" attendu.\n')
    CASE "empt"
      PrintF('Rien à créer.\n')
    CASE "circ"
      PrintF('dépendances circulaires entre fichiers.\n')
    CASE "bada"
      PrintF('impossible de construire "\s".\n',exceptioninfo)
    CASE "badd"
      PrintF('dépendance "\s" non disponible.\n',exceptioninfo)
    CASE "derr"
      PrintF('Processus fils manqué.\n')
    CASE "ntar"
      PrintF('Pas une telle cible: "\s"\n',args.target)
    CASE "ndep"
      PrintF('Pas de dépendance pour l'objet "\s".\n',exceptioninfo)
    CASE "barg"
      PrintFault(IoErr(),NIL)
    DEFAULT
      PrintF('Coucou tralala !.\n')
  ENDSELECT
  IF curline THEN PrintF('en ligne: (\d) "\s"\n',curline,curstring)
  IF exception THEN PrintF('Build terminé\n')
  RETURN 10
ENDPROC

PROC parse(list:PTR TO LONG)
  DEF l=NIL:PTR TO object, s, c, i, t
  FOR curline:=0 TO ListLen(list)-1
    s:=list[curline]
    curstring:=s
    c:=s[]
    IF (c<>"#") AND (c<>"\0")                   -> ignore?
      IF (c=" ") OR (c="\t")                    -> action
        s:=eatwhite(s)
        IF s[]
          IF l=NIL THEN Raise("nobj")
          l.firstaction:=NEW [l.firstaction,s]:action
        ENDIF
      ELSE                                      -> object rule
        i:=s
        s:=eatname(s)
        IF s=i THEN Raise("fexp")
        t:=s
        s:=eatwhite(s)
        IF s[]++<>":" THEN Raise("dexp")
        t[]:="\0"
        l:=NEW [l,i,NIL,NIL,0]:object
        s:=eatwhite(s)
        IF s[]<>"\0"
          REPEAT
            i:=s
            s:=eatname(s)
            t:=s
            IF t=i THEN Raise("fexp")
            s:=eatwhite(s)
            t[]:="\0"
            l.firstdep:=NEW [l.firstdep,i]:dependancy
          UNTIL s[]="\0"
        ENDIF
      ENDIF
    ENDIF
  ENDFOR
  curline:=0
  IF l=NIL THEN Raise("empt")
ENDPROC l

PROC eatwhite(s)
  WHILE (s[]=" ") OR (s[]="\t") DO s++
ENDPROC s

PROC eatname(s)
  WHILE (s[]<>" ") AND (s[]<>"\t") AND (s[]<>"\0") AND (s[]<>":") DO s++
ENDPROC s

PROC execute(c)
  PrintF('\t\s\n',c)
  uptodate:=FALSE
  IF Execute(c,NIL,stdout)=NIL THEN Raise("derr")
ENDPROC

PROC filetime(name:PTR TO CHAR)
  DEF l:PTR TO filelock, fib:fileinfoblock, date:PTR TO datestamp
  IF l:=Lock(name,ACTION_READ)
    IF Examine(l,fib)
      date:=fib.datestamp
      IF fib.direntrytype<0
        UnLock(l)
        RETURN date.days, Shl(date.minute,12)+date.tick
      ENDIF
    ENDIF
    UnLock(l)
  ENDIF
ENDPROC -1

PROC timelater(day1,tick1,day2,tick2)
  IF day1>day2
    RETURN TRUE
  ELSEIF day1=day2
    RETURN tick1>tick2
  ENDIF
ENDPROC FALSE

/*----------------partie de rob-------------------*/

PROC buildtree(list:PTR TO object) -> retourne la racine de l'arbre
  DEF dep:PTR TO dependancy,
      obj:PTR TO object

  obj:=list
  WHILE obj         -> traverse objects
    dep:=obj.firstdep
    WHILE dep       -> traverse dependencies
      dep.object:=findobject(dep.object,list)
      dep:=dep.next
    ENDWHILE
    obj:=obj.next
  ENDWHILE

  -> VERIFICATION DES CYCLES!!!

  obj:=list
  IF args.target
    WHILE obj
      IF StrCmp(args.target,obj.name) THEN JUMP out
      obj:=obj.next
    ENDWHILE
    Raise("ntar")
    out:
  ELSE
    IF obj THEN WHILE obj.next DO obj:=obj.next
  ENDIF
  traverse(obj)
ENDPROC


-> trouve les objets dansla liste des objet par le nom
PROC findobject(name:PTR TO CHAR,list:PTR TO object)
  WHILE list
    IF StrCmp(name,list.name)
      -> enlève l'objet de la racine de la liste
      list.child:=TRUE;
      RETURN list
    ENDIF
    list:=list.next
  ENDWHILE
ENDPROC NEW [NIL,name,NIL,NIL]:object

-> child-first traversal of dependancy tree
PROC traverse(obj:PTR TO object) -> éxécute les actions dans l'arbre
  DEF dep:PTR TO dependancy,maxtime1=0,maxtime2=0,time1,time2,action:PTR TO action

  IF obj.firstdep OR obj.firstaction    -> objet avec dépendances/actions
    -> traverse children et prend le maximum de temps
    dep:=obj.firstdep
    WHILE dep
      time1,time2:=traverse(dep.object)
      IF timelater(time1,time2,maxtime1,maxtime2)
        maxtime1:=time1
        maxtime2:=time2
      ENDIF
      dep:=dep.next
    ENDWHILE
    time1,time2:=filetime(obj.name)
    IF time1<0 OR timelater(maxtime1,maxtime2,time1,time2) OR args.force
      -> fichiers de dépendance plus récent: build object
      -> éxécute les actions
      action:=obj.firstaction
      WHILE action
        execute(action.comstring)
        action:=action.next
      ENDWHILE
      time1,time2:=filetime(obj.name)
      IF (time1<0) AND (obj.child=TRUE) THEN Throw("bada",obj.name)
    ENDIF
    RETURN time1,time2
  ENDIF
  -> object requires no action: return timestamp
  time1,time2:=filetime(obj.name);
  IF time1<0 THEN Throw("badd",obj.name)
ENDPROC time1,time2
