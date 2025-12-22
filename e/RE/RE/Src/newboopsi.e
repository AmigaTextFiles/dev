/* some basic procedures to handle BOOPSI-like objects
** procedures are called putting args on stack instead of regs
** a different method af accessing classes' attributes (AKA OBJECT's members) is used
** without using OM_GET
** Created by Marco Antoniazzi
*/
MODULE
       'exec/memory',
       'utility',
       'utility/tagitem',
       'utility/hooks'

->PROC objects
OBJECT mlh
 
      head:PTR TO MinNode
      tail:PTR TO MinNode
      tailpred:PTR TO MinNode
ENDOBJECT

OBJECT sclass
  dispatcher:Hook
  reserved:LONG
  super:PTR TO sclass
  id:LONG
  userdata:LONG
  subclasscount:LONG
  objectcount:LONG
  flags:LONG
ENDOBJECT

OBJECT object
  succ
  pred
  class:PTR TO sclass
ENDOBJECT

OBJECT basedata
  userdata
ENDOBJECT

OBJECT baseobject
  obj:object
  data:basedata
ENDOBJECT

OBJECT windata
  window
ENDOBJECT

OBJECT winobject
  obj:baseobject
  data:windata
ENDOBJECT

OBJECT msg
  methodid:LONG
ENDOBJECT

OBJECT opnew
  methodid:LONG
  datasize:LONG
  attrlist:PTR TO TagItem
ENDOBJECT

-> ENDPROC

ENUM ERR_NONE,ERR_UTIL

ENUM A_FirstTag=$90007000,
     A_UserData,
     A_Window
     
ENUM OM_NEW=$101,
     OM_DISPOSE,
     M_Window_Open=$90007002

DEF rclass:PTR TO sclass,bclass:PTR TO sclass,wclass:PTR TO sclass

#define V_UnrecognizedMethod   $49893131

#define basedata(obj)   obj::baseobject.data
#define windata(obj)    obj::winobject.data
->#define windata(obj)    basedata(obj).data

#define CLRMEM            MEMF_PUBLIC OR MEMF_CLEAR


/* call using stack instead of regs*/
PROC callHookA(h,o,msg)
ENDPROC h::Hook.Entry(h, o, msg)

#define installhook(h,f) h::Hook.Entry := f


PROC main() HANDLE
  DEF bo:PTR TO object,
      wi:PTR TO object
    
  IF (UtilityBase:=OpenLibrary('utility.library',0))=0 THEN Raise(ERR_UTIL)
  initclasses()
  bo:=newObjectA(bclass,0,SIZEOF baseobject,[A_UserData,1,0])
  WriteF('bud \d\n',basedata(bo).userdata)
  wi:=newObjectA(wclass,0,SIZEOF winobject,[A_Window,2,0])
  WriteF('wwi \d\n',windata(wi).window)
  exeMethodA(wi,[M_Window_Open,0,0])
EXCEPT DO
  disposeObject(wi)
  disposeObject(bo)
  freeclasses()
  CloseLibrary(UtilityBase)
ENDPROC

PROC initclasses()
  rclass:=makeClass(0,0,0,{dispatch_rclass})
  bclass:=makeClass(0,0,rclass,{dispatch_bclass})
  wclass:=makeClass(0,0,bclass,{dispatch_wclass})
ENDPROC

PROC freeclasses()
  freeClass(wclass)
  freeClass(bclass)
  freeClass(rclass)
ENDPROC



PROC makeClass(classID,superclassID,superPTR,dispatcher)
  DEF cl:PTR TO sclass
  
  IF cl:=AllocVec(SIZEOF sclass,CLRMEM)
    cl.super:=superPTR  -> valid also if superPTR=0 !
    installhook(cl.dispatcher,dispatcher)
  ENDIF
ENDPROC cl

PROC freeClass(cl)
  IF cl THEN FreeVec(cl)
ENDPROC

PROC exeMethodA(o:PTR TO object,msg)
  IF o AND msg
    RETURN callHookA(o.class.dispatcher,o,msg)
  ENDIF
ENDPROC 0

PROC exeSuperMethodA(cl:PTR TO sclass,o,msg)
  IF cl AND o AND msg
    RETURN callHookA(cl.super.dispatcher,o,msg)
  ENDIF
ENDPROC 0

PROC newObjectA(class:PTR TO sclass,classID,datasize,taglist)
  IF class THEN RETURN callHookA(class.dispatcher,class,[OM_NEW,datasize,taglist])
ENDPROC

PROC disposeObject(o)
  exeMethodA(o,[OM_DISPOSE])
ENDPROC



-> rootclass
PROC dispatch_rclass(cl,o,msg:PTR TO msg)
PrintF('root_disp\n')
  SELECT msg.methodid
    CASE OM_NEW     ; RETURN new_rclass(cl,o,msg)
    CASE OM_DISPOSE ; RETURN dispose_rclass(cl,o,msg)
    DEFAULT         ; RETURN V_UnrecognizedMethod
  ENDSELECT
ENDPROC

PROC new_rclass(cl,o,msg:PTR TO msg)
  DEF obj:PTR TO object,
      tags:PTR TO TagItem,
      tag:PTR TO TagItem

PrintF('root_new\n')
  IF obj:=AllocVec(msg::opnew.datasize,CLRMEM)
    obj.class:=o
    /* parse initial taglist */
    tags:=msg::opnew.attrlist
    WHILE tag:=NextTagItem({tags})
      SELECT tag.Tag
    ->      CASE A_UserData ; basedata(obj).userdata:=tag.data
      ENDSELECT
    ENDWHILE
  ENDIF
ENDPROC obj

PROC dispose_rclass(cl,o,msg)
PrintF('root_end\n')
  FreeVec(o)
ENDPROC

-> baseclass
PROC dispatch_bclass(cl,o,msg:PTR TO msg)
  
PrintF('  base_disp\n')
  SELECT msg.methodid
    CASE OM_NEW ; RETURN new_bclass(cl,o,msg)
->    CASE OM_DISPOSE ; RETURN dispose_bclass(cl,o,msg)
    DEFAULT ; RETURN exeSuperMethodA(cl,o,msg)
  ENDSELECT
ENDPROC

PROC new_bclass(cl,o,msg:PTR TO msg)
  DEF obj:PTR TO object,
      tags:PTR TO TagItem,
      tag:PTR TO TagItem
  
PrintF('  base_new\n')
  IF obj:=exeSuperMethodA(cl,o,msg)
    /* parse initial taglist */
    tags:=msg::opnew.attrlist
    WHILE tag:=NextTagItem({tags})
      SELECT tag.Tag
        CASE A_UserData ; basedata(obj).userdata:=tag.Data
      ENDSELECT
    ENDWHILE
  ENDIF
ENDPROC obj

/* nothing to free and object is freed by rootclass
PROC dispose_bclass(cl,o,msg)
ENDPROC
*/


-> windowclass
PROC dispatch_wclass(cl,o,msg:PTR TO msg)
  
PrintF('    win_disp\n')
  SELECT msg.methodid
    CASE OM_NEW         ; RETURN new_wclass(cl,o,msg)
    CASE M_Window_Open  ; RETURN open_wclass(cl,o,msg)
    DEFAULT             ; RETURN exeSuperMethodA(cl,o,msg)
  ENDSELECT
ENDPROC

PROC new_wclass(cl,o,msg:PTR TO msg)
  DEF obj:PTR TO object,
      tags:PTR TO TagItem,
      tag:PTR TO TagItem
  
PrintF('    win_new\n')
  IF obj:=exeSuperMethodA(cl,o,msg)
    /* parse initial taglist */
    tags:=msg::opnew.attrlist
    WHILE tag:=NextTagItem({tags})
      SELECT tag.Tag
        CASE A_Window ; windata(obj).window:=tag.Data
      ENDSELECT
    ENDWHILE
  ENDIF
ENDPROC obj

PROC open_wclass(cl,o,msg)
  WriteF('    open window\n')
ENDPROC
