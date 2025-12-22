/* build in E.

TODO:	- cyclic structure check (part)
	- (amigados?) constants (part)

*/

OPT OSVERSION=37

MODULE 'tools/file', 'dos/dosextens', 'dos/dos','dos/dostags'

/*
  symbol=object
  object: dep1 dep2 ....
     act1
     act2

  $(symbol): $(symbol)bla ....
     act1
     ...
*/

/*
history:

(Version 0.8 by Rob and Wouter, lost modifications for 3.2 by Jason)

When		Who		What
23.07.97	Glauschwuffel	- Added symbolic constants. Constants are allowed everywhere
26.07.97	Glauschwuffel	- Removed bug in constants: The part after the last constant
				  wouldn't be copied. $(test): $(test).e crashed in cyclic
				  dependancy. :(
				- Used source that Jason mailed me to get right order of actions.
				- Minor modification in traverse(): "circ" is raised when object
				  and a dependancy have the same name. 
				- Added version facility :)
				- local constant $(target) is now available in actions
				- Added QUIET arg
27.07.97	Glauschwuffel	- Changed QUIET to VERBOSE since quiet was default for v3.1
(between        Glauschwuffel   - Used EBuild with new oomodules/ objects. *Very* stable, no errrors
      	      	      	      	  at all. I tend to say it's error-free <g>)
09.08.97	Glauschwuffel	- Actions of a target are now collected in a script again.
      	      	      	      	  EBuild now acts as described in the Ev3.2 doc (except of the
      	      	      	      	  modified $target). Bumped version to 0.9.
10.08.97	Glauschwuffel	- Added script variable $target for reasons of consistency. Now
      	      	      	      	  $(target) and $target are possible.
      	      	      	      	  Discovered a potential bug: if build is called without a target and
      	      	      	      	  the first target in the buildfile is not a filename (e.g. a symbolic
    	    	    	    	  target like `all' or `clean') the actions for this target are
    	    	    	    	  executed anyway (0.8 does this, too).
05.09.97	Glauschwuffel	- BUG: the temporary script in T: won't be closed on exceptions
				  Fixed.
13.09.97	Glauschwuffel	- ADD: commandline option CONSTANTS. Lists the constants before executing
				  anything. Modified `dumpC()' for this.
12.10.97	Glauschwuffel	- BUG: EBuild would cause an enforcer hit when no dependent objects are
				  specified (as with symbolic targets like 'clean'). target was only set
				  when there were dependencies, moved the statement two lines higher.
				  Fixed. Bumped version. Thanks to Nuno for the report.
16.11.97	Glauschwuffel	- ADD: script variable DEP holds the name of
				  the first dependancy. (used to avoid conflicts with <.)
				  Expanded 'depedancy' object with 'lastdep'.
				  BUG: dependancies were in wrong order as with the actions.
22.11.97	Glauschwuffel	- ADD: include directive. This one's pretty recursive.
23.11.97	Glauschwuffel	- BUG: Using the FROM argument took the name but added a '.build'.
				  ADD: constants in constants. Argument MESS (don't delete script).
				  BUG: Jason wasn't in the copyright line :)
				  CHG: script name is target dependent so MESS is useful.
				  BUG: $(dep) was set even if there was no dependancy.
				  CHG: Bumped version to 0.97
*/

OBJECT object
  next:PTR TO object
  name:PTR TO CHAR
  firstdep:PTR TO dependancy
  firstaction:PTR TO action
  child
  lastaction:PTR TO action
  lastdep:PTR TO dependancy
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
  target,buildfile,force,verbose,nohead,constants,mess
ENDOBJECT

OBJECT constant
  next:PTR TO constant
  name:PTR TO CHAR
  subst:PTR TO CHAR
ENDOBJECT

DEF curline=0, curstring, uptodate=TRUE, args:PTR TO arg,
    constants:PTR TO constant, -> global list of constants in reverse order
    target:PTR TO CHAR, -> holds name of current target
    depName:PTR TO CHAR -> holds current first dependancy

PROC main() HANDLE
  DEF m,l,buildfile[200]:STRING,rdargs=NIL,list,nulist

  NEW args
  IF (rdargs:=ReadArgs('TARGET,FROM/K,FORCE/S,VERBOSE/S,NOHEAD/S,CONSTANTS/S,MESS/S',args,NIL))=NIL THEN Raise("barg")
  IF args.buildfile
    StrCopy(buildfile,args.buildfile)
  ELSE
    StrAdd(buildfile,'.build')
  ENDIF

  IF (args.nohead = 0) -> be VERY quiet
    PrintF({versionString})
    PrintF(' (processing "\s")\n', buildfile)
  ENDIF
  m,l:=readfile(buildfile)
  list:=stringsinfile(m,l,countstrings(m,l))
  WHILE (nulist:=lookForDirectives(list)) <> list DO list:=nulist
  list:=nulist
  buildtree(parse(list))
  IF uptodate THEN PrintF('All files are up to date.\n')
  Raise()
EXCEPT
  IF rdargs THEN FreeArgs(rdargs)
  IF exception=0 THEN RETURN
  PrintF('Error: ')
  SELECT exception
    CASE "OPEN"
      PrintF('Couldn''t open "\s".\n',exceptioninfo)
    CASE "MEM"
      PrintF('Not enough memory.\n')
    CASE "IN"
      PrintF('Couldn''t read file.\n')
    CASE "nobj"
      PrintF('Action without object.\n')
    CASE "fexp"
      PrintF('Filename expected.\n')
    CASE "dexp"
      PrintF('":" or "=" expected.\n')
    CASE "empt"
      PrintF('Nothing to build.\n')
    CASE "circ"
      PrintF('Circular dependancies at file "\s".\n', exceptioninfo)
    CASE "bada"
      PrintF('Action failed to build "\s".\n',exceptioninfo)
    CASE "badd"
      PrintF('Dependancy "\s" not available.\n',exceptioninfo)
    CASE "derr"
      PrintF('Child process failed (actions script failed).\n')
    CASE "ntar"
      PrintF('No such target: "\s".\n',args.target)
    CASE "ndep"
      PrintF('No dependancies for object "\s".\n',exceptioninfo)
    CASE "clos"
      PrintF('Missing closing brace: "\s".\n',exceptioninfo)
    CASE "cons"
      PrintF('Unknown constant: "\s".\n',exceptioninfo)
      dumpC()
    CASE "barg"
      PrintFault(IoErr(),NIL)
    CASE "scrp"
      PrintF ('Unable to create temporary script.\n')
    CASE "inc"
      WriteF ('Unable to open include file \a\s\a.\n',exceptioninfo)
    DEFAULT
      PrintF('burp.\n')
  ENDSELECT
  IF curline THEN PrintF('at line: (\d) "\s"\n',curline,curstring)
  IF exception THEN PrintF('Build terminated\n')
  RETURN 10
ENDPROC

PROC parse(list:PTR TO LONG)
-> i holds the name of the constant/action
-> t points to i's tail

  DEF l=NIL:PTR TO object, s, c, i, t, const=NIL:PTR TO constant,str:PTR TO CHAR
  FOR curline:=0 TO ListLen(list)-1
    s:=list[curline]
    curstring:=s
    c:=s[]
    IF (c<>"#") AND (c<>"\0")			-> ignore?
      IF (c=" ") OR (c="\t")			-> action
        s:=eatwhite(s)
        IF s[]
          IF l=NIL THEN Raise("nobj")
          -> was: l.firstaction:=NEW [l.firstaction,s]:action
      	  -> replaced by the following IF (Rob through Glauschwuffel)
      	  IF l.lastaction
      	    l.lastaction.next:=NEW [NIL,s]:action
      	    l.lastaction:=l.lastaction.next
      	  ELSE
      	    l.firstaction:=NEW [NIL,s]:action
      	    l.lastaction:=l.firstaction
      	  ENDIF
        ENDIF
      ELSE					-> object rule or constant
        i:=s -> i holds the name
        s:=eatname(s)
        IF s=i THEN Raise("fexp")
        t:=s

	IF (s[]<>":") AND (s[]<>"=") THEN Raise("dexp")
        IF s[]=":"

	  -> check object rule for use of constants
	  str:=String(1024) -> dyn. alloc., free if no constants 
	  IF str=NIL THEN Raise("MEM")

	  substituteConstants (i, str)
	  i := str; s:=eatname(str) 
          IF s=i THEN Raise("fexp")
          t:=s
          t[]:="\0"
      	  s++
          s:=eatwhite(s)
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
              -> 16.11.97 was: l.firstdep:=NEW [l.firstdep,i]:dependancy
      	      IF l.lastdep
      	        l.lastdep.next:=NEW [NIL,i]:dependancy
      	        l.lastdep:=l.lastdep.next
      	      ELSE
      	        l.firstdep:=NEW [NIL,i]:dependancy
      	        l.lastdep:=l.firstdep
      	      ENDIF

            UNTIL s[]="\0"
          ENDIF
      	ELSE -> we have a constant

	  -> check rule for use of constants
	  str:=String(1024) -> dyn. alloc., free if no constants 
	  IF str=NIL THEN Raise("MEM")

	  substituteConstants (i, str)
          i := str; s:=eatname(str) 
          IF s=i THEN Raise("fexp")
          t:=s

          t[]:="\0" -> terminate name
     	  s++
     	  s:=eatwhite(s)
	  const:=NEW[const,i,s]:constant
	  constants:=const -> have to do it here so consts in rules are recognized
      	ENDIF
      ENDIF
    ENDIF
  ENDFOR
  curline:=0
  IF args.constants THEN dumpC()
  IF l=NIL THEN Raise("empt")
ENDPROC l


PROC eatwhite(s)
  WHILE (s[]=" ") OR (s[]="\t") DO s++
ENDPROC s

PROC eatname(s)
  WHILE (s[]<>" ") AND (s[]<>"\t") AND (s[]<>"\0") AND (s[]<>":") AND (s[]<>"=") DO s++
ENDPROC s

/* obsolete
PROC execute(c)
DEF s[1024]:STRING
  uptodate:=FALSE
  substituteConstants (c, s)
  IF args.verbose THEN PrintF('\s\n', s)
  IF Execute(s,NIL,stdout)=NIL THEN Raise("derr")
ENDPROC */

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

/*----------------rob's-stuff-------------------*/

PROC buildtree(list:PTR TO object) -> returns root of tree
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

  -> CHECK CYCLES!!!

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


-> find object in list of objects by name
PROC findobject(name:PTR TO CHAR,list:PTR TO object)
  WHILE list
    IF StrCmp(name,list.name)
      -> remove object from root list
      list.child:=TRUE;
      RETURN list
    ENDIF
    list:=list.next
  ENDWHILE
ENDPROC NEW [NIL,name,NIL,NIL]:object

-> child-first traversal of dependancy tree
PROC traverse(obj:PTR TO object) -> executes actions in tree
  DEF dep:PTR TO dependancy,maxtime1=0,maxtime2=0,time1,time2,action:PTR TO action,
    oldTarget
/*
 * oldTarget holds the value of target when the proc was entered. It will be set back
 * right before we return from this proc.
 */ 

  IF obj.firstdep OR obj.firstaction    -> object with dependancies/actions
    -> traverse children and get maximum timestamp
    dep:=obj.firstdep
    oldTarget:=target -> store it
    target := obj.name
    IF obj.firstdep
      IF obj.firstdep.object THEN depName := obj.firstdep.object.name ELSE depName := ' '
    ENDIF

    WHILE dep
      IF OstrCmp (dep.object.name, obj.name) = 0 THEN Throw("circ",obj.name) -> cyclic check by Glauschwuffel
      time1,time2:=traverse(dep.object)
      IF timelater(time1,time2,maxtime1,maxtime2)
        maxtime1:=time1
        maxtime2:=time2
      ENDIF
      dep:=dep.next
    ENDWHILE
    time1,time2:=filetime (obj.name)
    IF time1<0 OR timelater(maxtime1,maxtime2,time1,time2) OR args.force
      -> dependancy file(s) more recent: build object
      -> execute actions
->      action:=obj.firstaction

      buildAndExecuteScript (obj)

      time1,time2:=filetime(obj.name)
      IF (time1<0) AND (obj.child=TRUE) THEN Throw("bada",obj.name)
    ENDIF
    target:=oldTarget -> restore it
    RETURN time1,time2
  ENDIF
  -> object requires no action: return timestamp
  time1,time2:=filetime(obj.name);
  IF time1<0 THEN Throw("badd",obj.name)
ENDPROC time1,time2

/* - glauschwuffel's stuff --- */


PROC dumpC()
DEF co:PTR TO constant
  co:=constants
  WriteF ('Constants are:\n') 
  WHILE co  
    WriteF('\s => \s.\n', co.name, co.subst)
    co:=co.next
  ENDWHILE
ENDPROC

PROC substituteConstants(c:PTR TO CHAR, s:PTR TO CHAR)
-> search c for constants and substitute them
DEF dollar, bclose=-1,sub=NIL
  REPEAT
    bclose++
    dollar := InStr (c,'$(',bclose)
    IF (dollar<>-1) -> found it?
      StrAdd (s, c+bclose, dollar-bclose)
      bclose := InStr (c,')',dollar+2)
      IF bclose=-1 THEN Throw("clos",c)
      sub := findConstant(c,dollar+2,bclose-1)
      IF sub=NIL OR CtrlC() THEN Throw("cons",c+dollar)
      StrAdd (s,sub)
    ELSE -> copy rest of the line to buffer
      StrAdd (s, c+bclose)
    ENDIF
  UNTIL (dollar=-1) OR (bclose=-1)
  RETURN sub -> did we substitute something at all?
ENDPROC

PROC findConstant(c,start,end)
-> find constant of given position in list
-> add 27.07.97: returns global target on target
DEF co:PTR TO constant

  IF OstrCmp('target',c+start,end-start+1)=0
    IF target=NIL THEN RETURN '$target' ELSE RETURN target
  ENDIF

  IF OstrCmp('dep',c+start,end-start+1)=0
    IF depName=NIL THEN RETURN '$dep' ELSE RETURN depName
  ENDIF
 
  co:=constants
  WHILE co  
    EXIT (OstrCmp(co.name,c+start,end-start+1)=0)
    co:=co.next
  ENDWHILE
  RETURN IF co THEN co.subst ELSE NIL
ENDPROC

PROC buildAndExecuteScript (obj:PTR TO object) HANDLE
/*
History:
16.11.97 glauschwuffel
Introduced new script variable 'dep' which holds the name of the
first dependancy.
*/
DEF s[1024]:STRING,
  action:PTR TO action,
  first_dependent_object:PTR TO object,
  handle,
  scriptName[255]:STRING,
  executeLine[255]:STRING

  action := obj.firstaction
  first_dependent_object := obj.firstdep.object

  StringF(scriptName,'T:Ebuild_actions_\s', args.target)
  handle := Open (scriptName, MODE_NEWFILE) -> open script file
  IF (handle = NIL) THEN Raise ("scrp")

  /* create script variable TARGET */
  StrAdd (s, 'Set target ')
  StrAdd (s, target)
  StrAdd (s, '\n') -> add newline
  Write (handle, s, StrLen (s))
  IF args.verbose THEN PrintF('\s', s)
  SetStr (s, 0) -> "delete" the string of the last action

  /* create script variable DEP */
  StrAdd (s, 'Set dep ')
  StrAdd (s, IF first_dependent_object THEN first_dependent_object.name ELSE ' ')
  StrAdd (s, '\n') -> add newline
  Write (handle, s, StrLen (s))
  IF args.verbose THEN PrintF('\s', s)

  
  WHILE action
    uptodate:=FALSE
    SetStr (s, 0) -> "delete" the string of the last action
    substituteConstants (action.comstring, s) -> expand action
    StrAdd (s, '\n') -> add newline
    IF args.verbose THEN PrintF('\s', s)
    Write (handle, s, StrLen (s))
    action:=action.next
  ENDWHILE

  Close (handle)
  StringF(executeLine,'Execute \s', scriptName)

  IF SystemTagList(executeLine, NIL)=-1 THEN Raise("derr")
  IF args.mess=0 
    DeleteFile (scriptName)
  ELSE
    WriteF('Script can be found at \s.\n', scriptName)
  ENDIF

EXCEPT
  IF handle THEN Close(handle)
  ReThrow()
ENDPROC

PROC lookForDirectives (list:PTR TO LONG)
->22.11.97
DEF i, -> list index
  s:PTR TO CHAR -> current line

  FOR i:=0 TO ListLen(list)-1
    s:=ListItem(list,i)
    IF s[0] = "#"
      IF s[1]="i" THEN RETURN includeFile(list,i,s+3)
    ENDIF
  ENDFOR
  RETURN list
ENDPROC

PROC includeFile(list:PTR TO LONG,currentIndex,file) HANDLE
->22.11.97
DEF mem,len,nulist,l
  mem,len:=readfile(file)
  l:=stringsinfile(mem,len,countstrings(mem,len))

  nulist := List (ListLen(list)+ListLen(l))
  IF currentIndex>0 THEN ListAdd(nulist,list,currentIndex)
  ListAdd(nulist,l)
  ListAdd(nulist,list+(currentIndex*4)+4,ListLen(list)-currentIndex-1)
  SetList(nulist,ListLen(list)+ListLen(l))
  DisposeLink(list)
  RETURN nulist
EXCEPT
  Throw("inc",file)
ENDPROC

versionTag: CHAR 0,'$VER:'
versionString: CHAR 'EBuild 0.97 (23.11.97) ©1997 Rob, Wouter, Jason and Glauschwuffel',0
