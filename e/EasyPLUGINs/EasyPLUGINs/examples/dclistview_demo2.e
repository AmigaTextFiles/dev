/* Original version by Jason                    **
** Some sections modified by Victor Ducedre,    **
** as indicated, for DCListview demo            */

OPT OSVERSION=37, PREPROCESS

-> Comment out this #define if you don't have/want to use sortlist.m
#define SORTLIST

MODULE 'tools/EasyGUI', 'tools/exceptions', 'amigalib/lists', 'utility',
       'gadtools', 'libraries/gadtools', 'exec/lists', 'exec/nodes',
       'dos/dos', 'dos/exall', 'dos/dosextens', 'easyplugins/dclistview', 'utility/tagitem'

#ifdef SORTLIST
MODULE '*dclistview_mod/sortlist'
#endif

ENUM ERR_NONE, ERR_NEW, ERR_STR, ERR_LOCK, ERR_ADO, ERR_NODE, ERR_LIB, ERR_PATT,
     ERR_OK, ERR_CANCEL

RAISE ERR_NEW  IF New()=NIL,
      ERR_STR  IF String()=NIL,
      ERR_LOCK IF Lock()=NIL,
      ERR_ADO  IF AllocDosObject()=NIL,
      ERR_LIB  IF OpenLibrary()=NIL,
      ERR_PATT IF ParsePatternNoCase()=-1

#define DIRSTR '<DIR> '
#define VOLSTR '<VOL> '
#define ASNSTR '<ASN> '
CONST DIRSTRLEN=6

CONST BUF_SIZE=1024, FILENAME_SIZE=300
CONST PATTERNBUFF_SIZE=FILENAME_SIZE*2+2
ENUM DIR_NODE, POS_NODE, VOL_NODE, ASN_NODE, FILE_NODE, MAX_TYPE

DEF pathStr[FILENAME_SIZE]:STRING, currPath[FILENAME_SIZE]:STRING,
    fileStr[FILENAME_SIZE]:STRING, patternStr[FILENAME_SIZE]:STRING,
    patternBuff[PATTERNBUFF_SIZE]:ARRAY,
    pathGad, fileGad, patternGad,
    nameList=NIL:PTR TO lh, posList=NIL:PTR TO lh

DEF gh=NIL:PTR TO guihandle,
    dclist=NIL:PTR TO dclistview

-> Store the contents of path directory in list
PROC getDir() HANDLE
  DEF success, eacontrol=NIL:PTR TO exallcontrol, lock=NIL,
      dlock=NIL, dl:PTR TO doslist, buffer[BUF_SIZE]:ARRAY, items=0
#ifndef SORTLIST
  freeNodes(nameList)
#endif
#ifdef SORTLIST
  emptySortedList(nameList)
#endif
  IF currPath[]  -> Valid path
    lock:=Lock(currPath, ACCESS_READ)
    eacontrol:=AllocDosObject(DOS_EXALLCONTROL, NIL)
    eacontrol.lastkey:=0
    eacontrol.matchstring:=patternBuff
    REPEAT
      success:=ExAll(lock, buffer, BUF_SIZE, ED_TYPE, eacontrol)
      IF eacontrol.entries<>0 THEN items:=items+addItems(buffer)
    UNTIL success=FALSE
  ELSE  -> Do a volume and assign list
    dl:=(dlock:=LockDosList(LDF_VOLUMES OR LDF_ASSIGNS OR LDF_READ))
    WHILE dl:=NextDosEntry(dl, LDF_VOLUMES OR LDF_ASSIGNS)
      addEntry(BADDR(dl.name),IF dl.type=DLT_VOLUME THEN VOL_NODE ELSE ASN_NODE)
      INC items
    ENDWHILE
  ENDIF
#ifdef SORTLIST
  IF items THEN makeSortedList(nameList, items, SIZEOF ln)  -> Sort it
#endif
EXCEPT DO
  IF eacontrol THEN FreeDosObject(DOS_EXALLCONTROL, eacontrol)
  IF lock THEN UnLock(lock)
  IF dlock THEN UnLockDosList(LDF_VOLUMES OR LDF_ASSIGNS OR LDF_READ)
  IF exception=ERR_LOCK
    DisplayBeep(NIL)
  ELSE
    ReThrow()
  ENDIF
ENDPROC

-> Add a Dos List entry
PROC addEntry(bname, type)
  addNode(nameList, bname+1, type, 0, bname[])
ENDPROC

-> Add the items from one call to ExAll
PROC addItems(buffer)
  DEF eabuf:PTR TO exalldata, items=0
  eabuf:=buffer
  WHILE eabuf
    addNode(nameList, eabuf.name,
            IF eabuf.type>0 THEN DIR_NODE ELSE FILE_NODE, 0)
    INC items
    eabuf:=eabuf.next
  ENDWHILE
ENDPROC items

-> Free a normal list of nodes and empty it
PROC freeNodes(list:PTR TO lh)
  DEF worknode:PTR TO ln, nextnode
  worknode:=list.head  -> First node
  WHILE nextnode:=worknode.succ
    IF worknode.name THEN DisposeLink(worknode.name)
    END worknode
    worknode:=nextnode
  ENDWHILE
  newList(list)
ENDPROC

-> Add a new node to the list
PROC addNode(list, name, type, pri, len=0) HANDLE
  DEF node=NIL:PTR TO ln, s=NIL
  NEW node
  IF name
    SELECT MAX_TYPE OF type
    CASE FILE_NODE
      s:=StrCopy(String(StrLen(name)), name)
    CASE DIR_NODE
      s:=String(StrLen(name)+DIRSTRLEN)
      StrCopy(s, DIRSTR)
      StrAdd(s, name)
    CASE VOL_NODE
      s:=String(len+DIRSTRLEN+1)
      StrCopy(s, VOLSTR)
      StrAdd(s, name, len)
      StrAdd(s, ':')
    CASE ASN_NODE
      s:=String(len+DIRSTRLEN+1)
      StrCopy(s, ASNSTR)
      StrAdd(s, name, len)
      StrAdd(s, ':')
    ENDSELECT
  ENDIF
  node.name:=s
  node.type:=type
  node.pri:=pri
  AddTail(list, node)
EXCEPT
  IF node THEN END node
  IF s THEN DisposeLink(s)
  Throw(ERR_NODE, type)
ENDPROC

-> Change the list to be a listing of volumes and assigns
PROC volsList()
  freeNodes(posList)
  SetStr(currPath, 0)
  changeList()
ENDPROC

-> Add dir to path and change list
PROC addDir(dir) HANDLE
  addNode(posList, NIL, POS_NODE, EstrLen(currPath))
  IF currPath[] AND (currPath[EstrLen(currPath)-1]<>":")
    StrAdd(currPath, '/')
  ENDIF
  StrAdd(currPath, dir)
  changeList()
EXCEPT
  -> Fix plist if exception not from first line (addNode to plist)
  IF (exception<>ERR_NODE) OR (exceptioninfo<>POS_NODE) THEN parentPos()
  ReThrow()
ENDPROC

-> Set path to be its parent
PROC parentPos()
  DEF node:PTR TO ln
  IF node:=RemTail(posList)
    SetStr(currPath, node.pri)
    END node
    RETURN TRUE
  ELSE
    RETURN FALSE
  ENDIF
ENDPROC

-> Change the displayed list             ->*** modified for DCListview demo
PROC changeList() HANDLE
  -> Remove list
  dclist.set(DCLV_CURRENT,-1)
  dclist.set(DCLV_LIST,-1)
  -> Change list contents
  getDir()
EXCEPT DO
  setstr(gh, pathGad, currPath)
  -> Reattach list
  dclist.set(DCLV_LIST,nameList)
  dclist.set(DCLV_TOP,0)
  ReThrow()
ENDPROC

-> Split path into directory positions
PROC splitDir() HANDLE
  DEF i
  freeNodes(posList)
  addNode(posList, NIL, POS_NODE, 0)
  IF -1<>(i:=InStr(currPath, ':'))
    IF currPath[i+1]
      addNode(posList, NIL, POS_NODE, i+1)
      WHILE -1<>(i:=InStr(currPath, '/', i+1))
        addNode(posList, NIL, POS_NODE, i)
      ENDWHILE
    ENDIF
  ENDIF
EXCEPT
  SetStr(currPath, 0)
ENDPROC

-> Parse the directory from a lock, set up plist
PROC setDir(lock)
  IF NameFromLock(lock, pathStr, FILENAME_SIZE)
    SetStr(pathStr, StrLen(pathStr))
    StrCopy(currPath, pathStr)
    splitDir()
  ENDIF
ENDPROC

-> Check this string is a real directory and set it
PROC checkDir(dir) HANDLE
  DEF lock=NIL, fib=NIL:PTR TO fileinfoblock
  lock:=Lock(dir, ACCESS_READ)
  fib:=AllocDosObject(DOS_FIB, NIL)
  IF Examine(lock, fib)
    IF fib.direntrytype>0
      setDir(lock)
      changeList()
      Raise(ERR_NONE)  -> Finished, clean up
    ENDIF
  ENDIF
  DisplayBeep(NIL)  -> Something minor went wrong...
EXCEPT DO
  IF fib THEN FreeDosObject(DOS_FIB, fib)
  IF lock THEN UnLock(lock)
  IF exception=ERR_LOCK
    DisplayBeep(NIL)
  ELSE
    ReThrow()
  ENDIF
ENDPROC

PROC setPattern(s)
  ParsePatternNoCase(s, patternBuff, PATTERNBUFF_SIZE)
  changeList()
ENDPROC


-> GUI actions:

PROC a_pattern(info, str) IS setPattern(IF str[] THEN str ELSE '#?')

PROC a_path(info, str) IS checkDir(str)

PROC a_file(info, str) IS Raise(ERR_OK)

PROC a_list(info, list:PTR TO dclistview)->*** modified for DCListview demo
  DEF node:PTR TO ln, sel, i=0
  sel:=list.get(DCLV_CURRENT)
  node:=nameList.head  -> First node
  WHILE node.succ AND (i<sel)
    node:=node.succ
    INC i
  ENDWHILE
  IF node.type<>FILE_NODE
    addDir(node.name+DIRSTRLEN)
  ELSE
    IF node.type=FILE_NODE THEN setstr(gh, fileGad, node.name)
    IF list.get(DCLV_CLICK) THEN Raise(ERR_OK)  -> Double click on file
  ENDIF
ENDPROC

PROC b_ok(info) IS Raise(ERR_OK)

PROC b_cancel(info) IS Raise(ERR_CANCEL)

PROC b_vols(info) IS volsList()

PROC b_parent(info)
  IF parentPos()
    changeList()
  ELSE
    DisplayBeep(NIL)
  ENDIF
ENDPROC

-> GUI definition                        ->*** modified for DCListview demo
PROC fileRequester()
  easyguiA('Select a file:',
    [EQROWS,
      [DCLIST, {a_list},dclist, TRUE],  ->      NIL,13,10,nameList,0,NIL,0],
      patternGad:=[STR,{a_pattern},'Pattern',patternStr,FILENAME_SIZE,5],
      pathGad:=[STR,{a_path},'Drawer',pathStr,FILENAME_SIZE,5],
      fileGad:=[STR,{a_file},'File',fileStr,200,5],
      [EQCOLS,
        [SBUTTON,{b_ok},'Ok'],
        [SBUTTON,{b_vols},'Disks'],
        [SBUTTON,{b_parent},'Parent'],
        [SBUTTON,{b_cancel},'Cancel']
      ]
    ],[EG_GHVAR, {gh}, TAG_DONE]
  )
ENDPROC

PROC main() HANDLE                       ->*** modified for DCListview demo
  DEF here=NIL
  utilitybase:=OpenLibrary('utility.library', 37)
  gadtoolsbase:=OpenLibrary('gadtools.library', 37)
  NEW nameList, posList
  NEW dclist.dclistview([DCLV_RELX,13,
                         DCLV_RELY,10,
                         DCLV_LIST,nameList,
                         DCLV_CURRENT,-1,
                         TAG_DONE])
  newList(nameList)
  newList(posList)
  StrCopy(patternStr, '~(#?.info)')
  ParsePatternNoCase(patternStr, patternBuff, PATTERNBUFF_SIZE)
  here:=CurrentDir(NIL)
  setDir(here)
  CurrentDir(here)
  getDir()
  fileRequester()
EXCEPT DO
  END nameList, posList
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF utilitybase THEN CloseLibrary(utilitybase)
  SELECT exception
  CASE ERR_OK
    WriteF('User selected "\s\s\s"\n', currPath,
       IF currPath[] AND (currPath[EstrLen(currPath)-1]<>":") THEN '/' ELSE '',
       fileStr)
  CASE ERR_CANCEL
    WriteF('User cancelled requester\n')
  DEFAULT
    report_exception()
  ENDSELECT
ENDPROC

